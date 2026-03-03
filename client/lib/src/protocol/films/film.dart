/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:cinema_reservation_client/src/protocol/protocol.dart' as _i2;

abstract class Film implements _i1.SerializableModel {
  Film._({
    this.id,
    required this.titre,
    this.synopsis,
    this.genre,
    required this.duree,
    this.realisateur,
    this.casting,
    this.affiche,
    this.bande_annonce,
    this.classification,
    this.note_moyenne,
    required this.date_debut,
    required this.date_fin,
    this.createdAt,
  });

  factory Film({
    int? id,
    required String titre,
    String? synopsis,
    String? genre,
    required int duree,
    String? realisateur,
    List<String>? casting,
    String? affiche,
    String? bande_annonce,
    String? classification,
    double? note_moyenne,
    required DateTime date_debut,
    required DateTime date_fin,
    DateTime? createdAt,
  }) = _FilmImpl;

  factory Film.fromJson(Map<String, dynamic> jsonSerialization) {
    return Film(
      id: jsonSerialization['id'] as int?,
      titre: jsonSerialization['titre'] as String,
      synopsis: jsonSerialization['synopsis'] as String?,
      genre: jsonSerialization['genre'] as String?,
      duree: jsonSerialization['duree'] as int,
      realisateur: jsonSerialization['realisateur'] as String?,
      casting: jsonSerialization['casting'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['casting'],
            ),
      affiche: jsonSerialization['affiche'] as String?,
      bande_annonce: jsonSerialization['bande_annonce'] as String?,
      classification: jsonSerialization['classification'] as String?,
      note_moyenne: (jsonSerialization['note_moyenne'] as num?)?.toDouble(),
      date_debut: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['date_debut'],
      ),
      date_fin: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['date_fin'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String titre;

  String? synopsis;

  String? genre;

  int duree;

  String? realisateur;

  List<String>? casting;

  String? affiche;

  String? bande_annonce;

  String? classification;

  double? note_moyenne;

  DateTime date_debut;

  DateTime date_fin;

  DateTime? createdAt;

  /// Returns a shallow copy of this [Film]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Film copyWith({
    int? id,
    String? titre,
    String? synopsis,
    String? genre,
    int? duree,
    String? realisateur,
    List<String>? casting,
    String? affiche,
    String? bande_annonce,
    String? classification,
    double? note_moyenne,
    DateTime? date_debut,
    DateTime? date_fin,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Film',
      if (id != null) 'id': id,
      'titre': titre,
      if (synopsis != null) 'synopsis': synopsis,
      if (genre != null) 'genre': genre,
      'duree': duree,
      if (realisateur != null) 'realisateur': realisateur,
      if (casting != null) 'casting': casting?.toJson(),
      if (affiche != null) 'affiche': affiche,
      if (bande_annonce != null) 'bande_annonce': bande_annonce,
      if (classification != null) 'classification': classification,
      if (note_moyenne != null) 'note_moyenne': note_moyenne,
      'date_debut': date_debut.toJson(),
      'date_fin': date_fin.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FilmImpl extends Film {
  _FilmImpl({
    int? id,
    required String titre,
    String? synopsis,
    String? genre,
    required int duree,
    String? realisateur,
    List<String>? casting,
    String? affiche,
    String? bande_annonce,
    String? classification,
    double? note_moyenne,
    required DateTime date_debut,
    required DateTime date_fin,
    DateTime? createdAt,
  }) : super._(
         id: id,
         titre: titre,
         synopsis: synopsis,
         genre: genre,
         duree: duree,
         realisateur: realisateur,
         casting: casting,
         affiche: affiche,
         bande_annonce: bande_annonce,
         classification: classification,
         note_moyenne: note_moyenne,
         date_debut: date_debut,
         date_fin: date_fin,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Film]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Film copyWith({
    Object? id = _Undefined,
    String? titre,
    Object? synopsis = _Undefined,
    Object? genre = _Undefined,
    int? duree,
    Object? realisateur = _Undefined,
    Object? casting = _Undefined,
    Object? affiche = _Undefined,
    Object? bande_annonce = _Undefined,
    Object? classification = _Undefined,
    Object? note_moyenne = _Undefined,
    DateTime? date_debut,
    DateTime? date_fin,
    Object? createdAt = _Undefined,
  }) {
    return Film(
      id: id is int? ? id : this.id,
      titre: titre ?? this.titre,
      synopsis: synopsis is String? ? synopsis : this.synopsis,
      genre: genre is String? ? genre : this.genre,
      duree: duree ?? this.duree,
      realisateur: realisateur is String? ? realisateur : this.realisateur,
      casting: casting is List<String>?
          ? casting
          : this.casting?.map((e0) => e0).toList(),
      affiche: affiche is String? ? affiche : this.affiche,
      bande_annonce: bande_annonce is String?
          ? bande_annonce
          : this.bande_annonce,
      classification: classification is String?
          ? classification
          : this.classification,
      note_moyenne: note_moyenne is double? ? note_moyenne : this.note_moyenne,
      date_debut: date_debut ?? this.date_debut,
      date_fin: date_fin ?? this.date_fin,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
    );
  }
}
