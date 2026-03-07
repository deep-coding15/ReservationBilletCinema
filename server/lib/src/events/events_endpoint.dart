import 'package:serverpod/serverpod.dart';
import '../generated/events/evenement.dart';

/// Endpoint événements : liste et détail. Retourne des [Evenement] typés.
class EventsEndpoint extends Endpoint {
  /// Liste des événements à venir (filtres optionnels ville, date).
  Future<List<Evenement>> getEvents(Session session, {String? ville, DateTime? date}) async {
    var sql = r'''
      SELECT id, titre, description, categorie, lieu_type, cinema_id,
             lieu_nom, adresse, ville, date_heure, prix, places_disponibles, affiche
      FROM evenements
      WHERE date_heure >= CURRENT_TIMESTAMP
    ''';
    final params = <String, Object?>{};
    if (ville != null && ville.trim().isNotEmpty) {
      sql += r' AND ville ILIKE @ville';
      params['ville'] = '%${ville.trim()}%';
    }
    if (date != null) {
      sql += r' AND DATE(date_heure) = DATE(@date)';
      params['date'] = date;
    }
    sql += ' ORDER BY date_heure';

    final result = await session.db.unsafeQuery(
      sql,
      parameters: params.isEmpty ? null : QueryParameters.named(params),
    );
    return result.map((row) => _rowToEvenement(row)).toList();
  }

  /// Détail d'un événement par id.
  Future<Evenement?> getEventById(Session session, int id) async {
    final result = await session.db.unsafeQuery(
      r'''
      SELECT id, titre, description, categorie, lieu_type, cinema_id,
             lieu_nom, adresse, ville, date_heure, prix, places_disponibles, affiche
      FROM evenements WHERE id = @id
      ''',
      parameters: QueryParameters.named({'id': id}),
    );
    if (result.isEmpty) return null;
    return _rowToEvenement(result.first);
  }

  Evenement _rowToEvenement(DatabaseResultRow row) {
    final m = row.toColumnMap();
    return Evenement(
      id: m['id'] as int,
      titre: m['titre'] as String,
      description: m['description'] as String?,
      categorie: m['categorie'] as String?,
      lieuType: m['lieu_type'] as String?,
      cinemaId: m['cinema_id'] as int?,
      lieuNom: m['lieu_nom'] as String?,
      adresse: m['adresse'] as String?,
      ville: m['ville'] as String?,
      dateHeure: _parseDateTime(m['date_heure']),
      prix: (m['prix'] as num).toDouble(),
      placesDisponibles: m['places_disponibles'] as int,
      affiche: m['affiche'] as String?,
    );
  }

  DateTime _parseDateTime(dynamic v) {
    if (v == null) throw ArgumentError('DateTime null');
    if (v is DateTime) return v;
    if (v is String) return DateTime.parse(v);
    throw ArgumentError('Invalid DateTime: $v');
  }

  /// Crée une réservation pour un événement (même logique que cinéma).
  Future<Map<String, dynamic>> createEventReservation(
    Session session, {
    required int eventId,
    required int nbBillets,
    required double montantTotal,
    int utilisateurId = 1,
  }) async {
    if (nbBillets < 1) throw ArgumentError('nbBillets >= 1');
    final eventRows = await session.db.unsafeQuery(
      r'SELECT id, places_disponibles FROM evenements WHERE id = @id',
      parameters: QueryParameters.named({'id': eventId}),
    );
    if (eventRows.isEmpty) throw Exception('Événement introuvable');
    final places = eventRows.first.toColumnMap()['places_disponibles'] as int;
    if (nbBillets > places) throw Exception('Places insuffisantes');
    final idResult = await session.db.unsafeQuery(
      r'''
      INSERT INTO reservations_evenements (utilisateur_id, evenement_id, nb_billets, montant_total, statut)
      VALUES (@uid, @eid, @nb, @montant, 'en_attente')
      RETURNING id
      ''',
      parameters: QueryParameters.named({
        'uid': utilisateurId,
        'eid': eventId,
        'nb': nbBillets,
        'montant': montantTotal,
      }),
    );
    final reservationId = idResult.first.toColumnMap()['id'] as int;
    await session.db.unsafeExecute(
      r'UPDATE evenements SET places_disponibles = places_disponibles - @n WHERE id = @id',
      parameters: QueryParameters.named({'n': nbBillets, 'id': eventId}),
    );
    return {'reservationId': reservationId, 'montantTotal': montantTotal};
  }
}
