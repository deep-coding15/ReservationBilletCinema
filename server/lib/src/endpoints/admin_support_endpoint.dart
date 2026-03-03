import 'dart:convert';
import 'package:serverpod/serverpod.dart';

class AdminSupportEndpoint extends Endpoint {

  // Récupérer toutes les demandes avec le nom de l'utilisateur (via jointure)
  Future<List<String>> getDemandesSupport(Session session) async {
    final rows = await session.db.unsafeQuery("""
      SELECT d.id, d.utilisateur_id, d.sujet, d.message, d.statut, d.reponse, d.created_at, u.nom
      FROM   demandes_support d
      JOIN   utilisateurs     u ON u.id = d.utilisateur_id
      ORDER  BY d.created_at DESC
    """);

    return rows.map((r) {
      final row = r.toList();
      return jsonEncode({
        'id': row[0],
        'utilisateurId': row[1],
        'sujet': row[2],
        'message': row[3],
        'statut': row[4],
        'reponse': row[5],
        'createdAt': row[6]?.toString(),
        'userName': row[7],
      });
    }).toList();
  }

  // Répondre à une demande et la fermer
  Future<bool> repondreDemande(Session session, int id, String reponse) async {
    await session.db.unsafeQuery("""
      UPDATE demandes_support 
      SET reponse = \$2, statut = 'ferme' 
      WHERE id = \$1
    """, parameters: QueryParameters.positional([id, reponse]));
    return true;
  }
}