import 'dart:convert';
import 'package:serverpod/serverpod.dart';

class AdminReservationsEndpoint extends Endpoint {

  // Récupérer les réservations avec détails (Film, Salle, User)
  Future<List<String>> getReservations(Session session) async {
    final rows = await session.db.unsafeQuery("""
      SELECT r.id, r.utilisateur_id, r.seance_id, r.date_reservation, r.montant_total, r.statut,
             f.titre AS film_titre, s.code_salle
      FROM   reservations r
      JOIN   seances      se ON se.id = r.seance_id
      JOIN   films        f  ON f.id  = se.film_id
      JOIN   salles       s  ON s.id  = se.salle_id
      ORDER  BY r.date_reservation DESC
    """);

    return rows.map((r) {
      final row = r.toList();
      return jsonEncode({
        'id': row[0],
        'utilisateurId': row[1],
        'seanceId': row[2],
        'dateReservation': row[3]?.toString(),
        'montantTotal': row[4],
        'statut': row[5],
        'filmTitre': row[6],
        'salleCode': row[7],
      });
    }).toList();
  }

  // Annuler une réservation
  Future<bool> annulerReservation(Session session, int id) async {
    await session.db.unsafeQuery(
      "UPDATE reservations SET statut = 'annulee' WHERE id = \$1",
      parameters: QueryParameters.positional([id]),
    );
    return true;
  }

  // Rembourser une réservation
  Future<bool> effectuerRemboursement(Session session, int id) async {
    await session.db.unsafeQuery(
      "UPDATE reservations SET statut = 'remboursee' WHERE id = \$1",
      parameters: QueryParameters.positional([id]),
    );
    return true;
  }
}