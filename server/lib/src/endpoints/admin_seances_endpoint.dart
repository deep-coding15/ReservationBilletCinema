import 'package:serverpod/serverpod.dart';
import 'dart:convert';

class AdminSeancesEndpoint extends Endpoint {

  static const String _selectCols = """
    se.id,
    se.film_id,
    se.salle_id,
    f.titre            AS film_titre,
    s.code_salle,
    c.nom              AS cinema_nom,
    s.capacite,
    se.date_heure,
    se.langue,
    se.type_projection,
    se.places_disponibles,
    se.prix,
    se.type_seance,
    se.created_at
  """;

  Map<String, dynamic> _rowToMap(List<dynamic> row) => {
    'id':                row[0],
    'filmId':            row[1],
    'salleId':           row[2],
    'filmTitre':         row[3],
    'salleCode':         row[4],
    'cinemanom':         row[5],
    'capaciteTotale':    row[6],
    'dateHeure':         row[7]?.toString(),
    'langue':            row[8],
    'typeProjection':    row[9],
    'placesDisponibles': row[10],
    'prix':              row[11],
    'typeSeance':        row[12],
    'createdAt':         row[13]?.toString(),
  };

  Future<List<String>> getSeances(Session session) async {
    final rows = await session.db.unsafeQuery("""
      SELECT $_selectCols
      FROM   seances  se
      JOIN   films    f  ON f.id  = se.film_id
      JOIN   salles   s  ON s.id  = se.salle_id
      JOIN   cinemas  c  ON c.id  = s.cinema_id
      ORDER  BY se.date_heure ASC
    """);
    return rows.map((r) => jsonEncode(_rowToMap(r.toList()))).toList();
  }

  Future<List<String>> getFilmsDisponibles(Session session) async {
    final rows = await session.db.unsafeQuery("""
      SELECT id, titre, genre
      FROM   films
      ORDER  BY titre
    """);
    return rows.map((r) {
      final row = r.toList();
      return jsonEncode({
        'id': row[0],
        'titre': row[1],
        'genre': row[2],
      });
    }).toList();
  }

  Future<List<String>> getSallesDisponibles(Session session) async {
    final rows = await session.db.unsafeQuery("""
      SELECT s.id, s.code_salle, s.capacite, c.nom AS cinema_nom
      FROM   salles   s
      LEFT JOIN cinemas c ON c.id = s.cinema_id
      ORDER  BY c.nom, s.code_salle
    """);
    return rows.map((r) {
      final row = r.toList();
      return jsonEncode({
        'id': row[0],
        'codeSalle': row[1],
        'capacite': row[2],
        'cinemaNom': row[3] ?? 'Cinéma inconnu'
      });
    }).toList();
  }

  Future<String> createSeance(
      Session session, {
        required int filmId,
        required int salleId,
        required String dateHeure,
        required String langue,
        required String typeProjection,
        required int placesDisponibles,
        required double prix,
        required String typeSeance,
      }) async {
    final result = await session.db.unsafeQuery("""
      INSERT INTO seances
        (film_id, salle_id, date_heure, langue, type_projection,
         places_disponibles, prix, type_seance, created_at)
      VALUES (\$1, \$2, \$3::timestamp, \$4, \$5, \$6, \$7, \$8, NOW())
      RETURNING id
    """, parameters: QueryParameters.positional([
      filmId, salleId, dateHeure, langue, typeProjection,
      placesDisponibles, prix, typeSeance,
    ]));
    final newId = result.first.toList()[0] as int;
    final map = await _getById(session, newId);
    return jsonEncode(map);
  }

  Future<String> updateSeance(
      Session session, {
        required int id,
        required int filmId,
        required int salleId,
        required String dateHeure,
        required String langue,
        required String typeProjection,
        required int placesDisponibles,
        required double prix,
        required String typeSeance,
      }) async {
    await session.db.unsafeQuery("""
      UPDATE seances SET
        film_id            = \$2,
        salle_id           = \$3,
        date_heure         = \$4::timestamp,
        langue             = \$5,
        type_projection    = \$6,
        places_disponibles = \$7,
        prix               = \$8,
        type_seance        = \$9
      WHERE id = \$1
    """, parameters: QueryParameters.positional([
      id, filmId, salleId, dateHeure, langue, typeProjection,
      placesDisponibles, prix, typeSeance,
    ]));
    final map = await _getById(session, id);
    return jsonEncode(map);
  }

  Future<bool> deleteSeance(Session session, int id) async {
    final rows = await session.db.unsafeQuery(
      'DELETE FROM seances WHERE id = \$1 RETURNING id',
      parameters: QueryParameters.positional([id]),
    );
    return rows.isNotEmpty;
  }

  Future<Map<String, dynamic>> _getById(Session session, int id) async {
    final rows = await session.db.unsafeQuery("""
      SELECT $_selectCols
      FROM   seances  se
      JOIN   films    f  ON f.id  = se.film_id
      JOIN   salles   s  ON s.id  = se.salle_id
      JOIN   cinemas  c  ON c.id  = s.cinema_id
      WHERE  se.id = \$1
    """, parameters: QueryParameters.positional([id]));
    if (rows.isEmpty) throw Exception('Séance introuvable id=$id');
    return _rowToMap(rows.first.toList());
  }
}
