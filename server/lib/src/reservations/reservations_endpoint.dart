import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Endpoint réservations : sièges, créneaux réservés, création réservation.
class ReservationsEndpoint extends Endpoint {
  /// Liste des sièges d'une salle (pour le plan de salle).
  Future<List<Siege>> getSiegesBySalle(Session session, int salleId) async {
    final result = await session.db.unsafeQuery(
      r'SELECT id, salle_id, numero, type FROM sieges WHERE salle_id = @salleId ORDER BY numero',
      parameters: QueryParameters.named({'salleId': salleId}),
    );
    return result.map((row) {
      final m = row.toColumnMap();
      return Siege(
        id: m['id'] as int,
        salleId: m['salle_id'] as int,
        numero: m['numero'] as String,
        type: m['type'] as String?,
      );
    }).toList();
  }

  /// Ids des sièges déjà réservés pour une séance (pour griser sur le plan).
  Future<List<int>> getReservedSiegeIdsForSeance(Session session, int seanceId) async {
    final result = await session.db.unsafeQuery(
      r'''
      SELECT rs.siege_id FROM reservation_sieges rs
      JOIN reservations r ON r.id = rs.reservation_id
      WHERE r.seance_id = @seanceId AND r.statut != 'annulee'
      ''',
      parameters: QueryParameters.named({'seanceId': seanceId}),
    );
    return result.map((row) => (row.toColumnMap()['siege_id'] as int)).toList();
  }

  /// Crée une réservation pour la séance et les sièges choisis.
  /// utilisateurId: 1 par défaut si non connecté (à remplacer par l'auth réelle).
  Future<ReservationResult> createReservation(
    Session session, {
    required int seanceId,
    required List<int> siegeIds,
    int utilisateurId = 1,
  }) async {
    if (siegeIds.isEmpty) throw ArgumentError('Au moins un siège requis');
    final reserved = await getReservedSiegeIdsForSeance(session, seanceId);
    for (final id in siegeIds) {
      if (reserved.contains(id)) throw Exception('Un ou plusieurs sièges sont déjà pris');
    }
    // Prix par siège: on récupère le prix de la séance
    final seanceRow = await session.db.unsafeQuery(
      r'SELECT prix FROM seances WHERE id = @id',
      parameters: QueryParameters.named({'id': seanceId}),
    );
    if (seanceRow.isEmpty) throw Exception('Séance introuvable');
    final prixUnitaire = (seanceRow.first.toColumnMap()['prix'] as num).toDouble();
    final montantTotal = prixUnitaire * siegeIds.length;

    final idResult = await session.db.unsafeQuery(
      r'''
      INSERT INTO reservations (utilisateur_id, seance_id, montant_total, statut)
      VALUES (@uid, @seanceId, @montant, 'en_attente')
      RETURNING id
      ''',
      parameters: QueryParameters.named({
        'uid': utilisateurId,
        'seanceId': seanceId,
        'montant': montantTotal,
      }),
    );
    final reservationId = idResult.first.toColumnMap()['id'] as int;

    for (final siegeId in siegeIds) {
      await session.db.unsafeExecute(
        r'INSERT INTO reservation_sieges (reservation_id, siege_id) VALUES (@rid, @sid)',
        parameters: QueryParameters.named({'rid': reservationId, 'sid': siegeId}),
      );
    }

    await session.db.unsafeExecute(
      r'UPDATE seances SET places_disponibles = places_disponibles - @n WHERE id = @seanceId',
      parameters: QueryParameters.named({'n': siegeIds.length, 'seanceId': seanceId}),
    );

    return ReservationResult(
      reservationId: reservationId,
      numeroReservation: 'BOOK-$reservationId',
      montantTotal: montantTotal,
    );
  }
}
