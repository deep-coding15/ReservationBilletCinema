import 'dart:convert';
import 'package:serverpod/serverpod.dart';

class AdminSallesEndpoint extends Endpoint {

  // Récupérer toutes les salles avec le nom du cinéma associé
  Future<List<String>> getSalles(Session session) async {
    final rows = await session.db.unsafeQuery("""
      SELECT s.id, s.cinema_id, s.code_salle, s.capacite, s.equipements, c.nom AS cinema_nom
      FROM   salles s
      LEFT JOIN cinemas c ON c.id = s.cinema_id
      ORDER BY c.nom, s.code_salle
    """);

    return rows.map((r) {
      final row = r.toList();
      return jsonEncode({
        'id': row[0],
        'cinemaId': row[1],
        'codeSalle': row[2],
        'capacite': row[3],
        'equipements': row[4], // C'est déjà une liste car text[] est géré par Serverpod
        'cinemaNom': row[5] ?? 'Inconnu'
      });
    }).toList();
  }

  // Récupérer les cinémas pour le filtre et le formulaire
  Future<List<String>> getCinemas(Session session) async {
    final rows = await session.db.unsafeQuery("SELECT id, nom, ville FROM cinemas ORDER BY nom");
    return rows.map((r) {
      final row = r.toList();
      return jsonEncode({'id': row[0], 'nom': row[1], 'ville': row[2]});
    }).toList();
  }

  Future<bool> createSalle(Session session, {
    required int cinemaId,
    required String codeSalle,
    required int capacite,
    List<String>? equipements,
  }) async {
    await session.db.unsafeQuery("""
      INSERT INTO salles (cinema_id, code_salle, capacite, equipements)
      VALUES (\$1, \$2, \$3, \$4::jsonb) 
    """, parameters: QueryParameters.positional([
      cinemaId,
      codeSalle,
      capacite,
      jsonEncode(equipements ?? []) // On encode la liste en JSON
    ]));
    return true;
  }

  Future<bool> updateSalle(Session session, {
    required int id,
    required int cinemaId,
    required String codeSalle,
    required int capacite,
    List<String>? equipements,
  }) async {
    await session.db.unsafeQuery("""
      UPDATE salles SET
        cinema_id = \$2,
        code_salle = \$3,
        capacite = \$4,
        equipements = \$5::jsonb
      WHERE id = \$1
    """, parameters: QueryParameters.positional([
      id,
      cinemaId,
      codeSalle,
      capacite,
      jsonEncode(equipements ?? []) // On encode la liste en JSON
    ]));
    return true;
  }

  Future<bool> deleteSalle(Session session, int id) async {
    await session.db.unsafeQuery("DELETE FROM salles WHERE id = \$1",
        parameters: QueryParameters.positional([id]));
    return true;
  }
}