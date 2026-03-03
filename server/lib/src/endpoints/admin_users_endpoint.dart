import 'dart:convert';
import 'package:serverpod/serverpod.dart';

class AdminUsersEndpoint extends Endpoint {

  // Récupérer la liste de tous les utilisateurs
  Future<List<String>> getUtilisateurs(Session session) async {
    final rows = await session.db.unsafeQuery("""
      SELECT id, nom, email, telephone, mot_de_passe_hash, preferences, statut, created_at
      FROM   utilisateurs
      ORDER BY nom ASC
    """);

    return rows.map((r) {
      final row = r.toList();
      return jsonEncode({
        'id': row[0],
        'nom': row[1],
        'email': row[2],
        'telephone': row[3],
        'motDePasseHash': row[4],
        'preferences': row[5],
        'statut': row[6],
        'createdAt': row[7]?.toString(),
      });
    }).toList();
  }

  // Suspendre ou Activer un compte utilisateur
  Future<bool> changerStatutUtilisateur(Session session, int id, String nouveauStatut) async {
    await session.db.unsafeQuery(
      "UPDATE utilisateurs SET statut = \$2 WHERE id = \$1",
      parameters: QueryParameters.positional([id, nouveauStatut])
    );
    return true;
  }

  // Supprimer un utilisateur
  Future<bool> supprimerUtilisateur(Session session, int id) async {
    await session.db.unsafeQuery("DELETE FROM utilisateurs WHERE id = \$1",
        parameters: QueryParameters.positional([id]));
    return true;
  }

  // Historique des achats pour un utilisateur précis
  Future<List<String>> getHistoriqueAchats(Session session, int utilisateurId) async {
    final rows = await session.db.unsafeQuery("""
      SELECT r.id, f.titre, r.date_reservation, r.montant_total, r.statut
      FROM   reservations r
      JOIN   seances      se ON se.id = r.seance_id
      JOIN   films        f  ON f.id  = se.film_id
      WHERE  r.utilisateur_id = \$1
      ORDER BY r.date_reservation DESC
    """, parameters: QueryParameters.positional([utilisateurId]));

    return rows.map((r) {
      final row = r.toList();
      return jsonEncode({
        'id': row[0],
        'filmTitre': row[1],
        'date': row[2]?.toString(),
        'montant': row[3],
        'statut': row[4],
      });
    }).toList();
  }
}
