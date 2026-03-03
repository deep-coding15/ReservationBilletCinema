import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Endpoint Films & séances : catalogue, recherche, listes, horaires, cinémas.
class FilmsEndpoint extends Endpoint {
  /// Liste des films à l'affiche (date du jour entre date_debut et date_fin).
  Future<List<Film>> getFilms(Session session, {String? search, String? genre}) async {
    var sql = r'''
      SELECT id, titre, synopsis, genre, duree, realisateur, casting,
             affiche, bande_annonce, classification, note_moyenne,
             date_debut, date_fin
      FROM films
      WHERE CURRENT_DATE BETWEEN date_debut AND date_fin
    ''';
    final params = <String, Object?>{};
    if (search != null && search.trim().isNotEmpty) {
      sql += r' AND (titre ILIKE @search OR synopsis ILIKE @search)';
      params['search'] = '%${search.trim()}%';
    }
    if (genre != null && genre.trim().isNotEmpty) {
      sql += r' AND genre ILIKE @genre';
      params['genre'] = genre.trim();
    }
    sql += ' ORDER BY note_moyenne DESC NULLS LAST, titre';

    final result = await session.db.unsafeQuery(
      sql,
      parameters: params.isEmpty ? null : QueryParameters.named(params),
    );
    return result.map((row) => _rowToFilm(row)).toList();
  }

  /// Détail d'un film par id.
  Future<Film?> getFilmById(Session session, int id) async {
    final result = await session.db.unsafeQuery(
      r'''
      SELECT id, titre, synopsis, genre, duree, realisateur, casting,
             affiche, bande_annonce, classification, note_moyenne,
             date_debut, date_fin
      FROM films WHERE id = @id
      ''',
      parameters: QueryParameters.named({'id': id}),
    );
    if (result.isEmpty) return null;
    return _rowToFilm(result.first);
  }

  /// Séances à venir pour un film (avec nom cinéma et code salle).
  Future<List<Seance>> getSeancesByFilm(Session session, int filmId) async {
    final result = await session.db.unsafeQuery(
      r'''
      SELECT s.id, s.film_id, s.salle_id, s.date_heure, s.langue,
             s.type_projection, s.places_disponibles, s.prix, s.type_seance,
             c.nom AS cinema_nom, sal.code_salle AS salle_code
      FROM seances s
      JOIN salles sal ON sal.id = s.salle_id
      JOIN cinemas c ON c.id = sal.cinema_id
      WHERE s.film_id = @filmId AND s.date_heure >= CURRENT_TIMESTAMP
      ORDER BY s.date_heure
      ''',
      parameters: QueryParameters.named({'filmId': filmId}),
    );
    return result.map((row) => _rowToSeance(row)).toList();
  }

  /// Séances à venir pour un cinéma (optionnel: filtrer par date).
  Future<List<Seance>> getSeancesByCinema(Session session, int cinemaId, {DateTime? date}) async {
    var sql = r'''
      SELECT s.id, s.film_id, s.salle_id, s.date_heure, s.langue,
             s.type_projection, s.places_disponibles, s.prix, s.type_seance,
             c.nom AS cinema_nom, sal.code_salle AS salle_code
      FROM seances s
      JOIN salles sal ON sal.id = s.salle_id
      JOIN cinemas c ON c.id = sal.cinema_id
      WHERE sal.cinema_id = @cinemaId AND s.date_heure >= CURRENT_TIMESTAMP
    ''';
    final params = <String, Object?>{'cinemaId': cinemaId};
    if (date != null) {
      sql += r' AND DATE(s.date_heure) = DATE(@date)';
      params['date'] = date;
    }
    sql += ' ORDER BY s.date_heure';

    final result = await session.db.unsafeQuery(
      sql,
      parameters: QueryParameters.named(params),
    );
    return result.map((row) => _rowToSeance(row)).toList();
  }

  /// Liste des cinémas.
  Future<List<Cinema>> getCinemas(Session session, {String? ville}) async {
    var sql = r'SELECT id, nom, adresse, ville, latitude, longitude FROM cinemas WHERE 1=1';
    final params = <String, Object?>{};
    if (ville != null && ville.trim().isNotEmpty) {
      sql += r' AND ville ILIKE @ville';
      params['ville'] = '%${ville.trim()}%';
    }
    sql += ' ORDER BY nom';

    final result = await session.db.unsafeQuery(
      sql,
      parameters: QueryParameters.named(params),
    );
    return result.map((row) => _rowToCinema(row)).toList();
  }

  Film _rowToFilm(DatabaseResultRow row) {
    final m = row.toColumnMap();
    return Film(
      id: m['id'] as int,
      titre: m['titre'] as String,
      synopsis: m['synopsis'] as String?,
      genre: m['genre'] as String?,
      duree: m['duree'] as int,
      realisateur: m['realisateur'] as String?,
      casting: _parseStringList(m['casting']),
      affiche: m['affiche'] as String?,
      bandeAnnonce: m['bande_annonce'] as String?,
      classification: m['classification'] as String?,
      noteMoyenne: (m['note_moyenne'] as num?)?.toDouble(),
      dateDebut: _parseDateTime(m['date_debut']),
      dateFin: _parseDateTime(m['date_fin']),
    );
  }

  Seance _rowToSeance(DatabaseResultRow row) {
    final m = row.toColumnMap();
    return Seance(
      id: m['id'] as int,
      filmId: m['film_id'] as int,
      salleId: m['salle_id'] as int,
      dateHeure: _parseDateTime(m['date_heure']),
      langue: m['langue'] as String?,
      typeProjection: m['type_projection'] as String?,
      placesDisponibles: m['places_disponibles'] as int,
      prix: (m['prix'] as num).toDouble(),
      typeSeance: m['type_seance'] as String?,
      cinemaNom: m['cinema_nom'] as String?,
      salleCode: m['salle_code'] as String?,
    );
  }

  Cinema _rowToCinema(DatabaseResultRow row) {
    final m = row.toColumnMap();
    return Cinema(
      id: m['id'] as int,
      nom: m['nom'] as String,
      adresse: m['adresse'] as String?,
      ville: m['ville'] as String?,
      latitude: (m['latitude'] as num?)?.toDouble(),
      longitude: (m['longitude'] as num?)?.toDouble(),
    );
  }

  DateTime _parseDateTime(dynamic v) {
    if (v == null) throw ArgumentError('DateTime null');
    if (v is DateTime) return v;
    if (v is String) return DateTime.parse(v);
    throw ArgumentError('Invalid DateTime: $v');
  }

  List<String>? _parseStringList(dynamic v) {
    if (v == null) return null;
    if (v is List) return v.map((e) => e.toString()).toList();
    if (v is String) {
      final s = v.trim();
      if (s.startsWith('{') && s.endsWith('}')) {
        final inner = s.substring(1, s.length - 1);
        if (inner.isEmpty) return [];
        return inner.split(',').map((e) => e.trim().replaceAll('"', '')).toList();
      }
      return [s];
    }
    return null;
  }
}
