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
    required this.id,
    required this.titre,
    this.synopsis,
    this.genre,
    required this.duree,
    this.realisateur,
    this.casting,
    this.affiche,
    this.bandeAnnonce,
    this.classification,
    this.noteMoyenne,
    required this.dateDebut,
    required this.dateFin,
  });

  factory Film({
    required int id,
    required String titre,
    String? synopsis,
    String? genre,
    required int duree,
    String? realisateur,
    List<String>? casting,
    String? affiche,
    String? bandeAnnonce,
    String? classification,
    double? noteMoyenne,
    required DateTime dateDebut,
    required DateTime dateFin,
  }) = _FilmImpl;

  factory Film.fromJson(Map<String, dynamic> jsonSerialization) {
    return Film(
      id: jsonSerialization['id'] as int,
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
      bandeAnnonce: jsonSerialization['bandeAnnonce'] as String?,
      classification: jsonSerialization['classification'] as String?,
      noteMoyenne: (jsonSerialization['noteMoyenne'] as num?)?.toDouble(),
      dateDebut: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateDebut'],
      ),
      dateFin: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dateFin']),
    );
  }

  int id;

  String titre;

  String? synopsis;

  String? genre;

  int duree;

  String? realisateur;

  List<String>? casting;

  String? affiche;

  String? bandeAnnonce;

  String? classification;

  double? noteMoyenne;

  DateTime dateDebut;

  DateTime dateFin;

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
    String? bandeAnnonce,
    String? classification,
    double? noteMoyenne,
    DateTime? dateDebut,
    DateTime? dateFin,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Film',
      'id': id,
      'titre': titre,
      if (synopsis != null) 'synopsis': synopsis,
      if (genre != null) 'genre': genre,
      'duree': duree,
      if (realisateur != null) 'realisateur': realisateur,
      if (casting != null) 'casting': casting?.toJson(),
      if (affiche != null) 'affiche': affiche,
      if (bandeAnnonce != null) 'bandeAnnonce': bandeAnnonce,
      if (classification != null) 'classification': classification,
      if (noteMoyenne != null) 'noteMoyenne': noteMoyenne,
      'dateDebut': dateDebut.toJson(),
      'dateFin': dateFin.toJson(),
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
    required int id,
    required String titre,
    String? synopsis,
    String? genre,
    required int duree,
    String? realisateur,
    List<String>? casting,
    String? affiche,
    String? bandeAnnonce,
    String? classification,
    double? noteMoyenne,
    required DateTime dateDebut,
    required DateTime dateFin,
  }) : super._(
         id: id,
         titre: titre,
         synopsis: synopsis,
         genre: genre,
         duree: duree,
         realisateur: realisateur,
         casting: casting,
         affiche: affiche,
         bandeAnnonce: bandeAnnonce,
         classification: classification,
         noteMoyenne: noteMoyenne,
         dateDebut: dateDebut,
         dateFin: dateFin,
       );

  /// Returns a shallow copy of this [Film]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Film copyWith({
    int? id,
    String? titre,
    Object? synopsis = _Undefined,
    Object? genre = _Undefined,
    int? duree,
    Object? realisateur = _Undefined,
    Object? casting = _Undefined,
    Object? affiche = _Undefined,
    Object? bandeAnnonce = _Undefined,
    Object? classification = _Undefined,
    Object? noteMoyenne = _Undefined,
    DateTime? dateDebut,
    DateTime? dateFin,
  }) {
    return Film(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      synopsis: synopsis is String? ? synopsis : this.synopsis,
      genre: genre is String? ? genre : this.genre,
      duree: duree ?? this.duree,
      realisateur: realisateur is String? ? realisateur : this.realisateur,
      casting: casting is List<String>?
          ? casting
          : this.casting?.map((e0) => e0).toList(),
      affiche: affiche is String? ? affiche : this.affiche,
      bandeAnnonce: bandeAnnonce is String? ? bandeAnnonce : this.bandeAnnonce,
      classification: classification is String?
          ? classification
          : this.classification,
      noteMoyenne: noteMoyenne is double? ? noteMoyenne : this.noteMoyenne,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
    );
  }
}
