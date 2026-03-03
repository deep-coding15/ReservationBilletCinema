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

abstract class Seance implements _i1.SerializableModel {
  Seance._({
    this.id,
    required this.film_id,
    required this.salle_id,
    required this.date_heure,
    String? langue,
    String? type_projection,
    required this.places_disponibles,
    required this.prix,
    String? type_seance,
    DateTime? created_at,
  }) : langue = langue ?? 'VF',
       type_projection = type_projection ?? '2D',
       type_seance = type_seance ?? 'standard',
       created_at = created_at ?? DateTime.now();

  factory Seance({
    int? id,
    required int film_id,
    required int salle_id,
    required DateTime date_heure,
    String? langue,
    String? type_projection,
    required int places_disponibles,
    required double prix,
    String? type_seance,
    DateTime? created_at,
  }) = _SeanceImpl;

  factory Seance.fromJson(Map<String, dynamic> jsonSerialization) {
    return Seance(
      id: jsonSerialization['id'] as int?,
      film_id: jsonSerialization['film_id'] as int,
      salle_id: jsonSerialization['salle_id'] as int,
      date_heure: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['date_heure'],
      ),
      langue: jsonSerialization['langue'] as String?,
      type_projection: jsonSerialization['type_projection'] as String?,
      places_disponibles: jsonSerialization['places_disponibles'] as int,
      prix: (jsonSerialization['prix'] as num).toDouble(),
      type_seance: jsonSerialization['type_seance'] as String?,
      created_at: jsonSerialization['created_at'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created_at']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int film_id;

  int salle_id;

  DateTime date_heure;

  String langue;

  String type_projection;

  int places_disponibles;

  double prix;

  String type_seance;

  DateTime created_at;

  /// Returns a shallow copy of this [Seance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Seance copyWith({
    int? id,
    int? film_id,
    int? salle_id,
    DateTime? date_heure,
    String? langue,
    String? type_projection,
    int? places_disponibles,
    double? prix,
    String? type_seance,
    DateTime? created_at,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Seance',
      if (id != null) 'id': id,
      'film_id': film_id,
      'salle_id': salle_id,
      'date_heure': date_heure.toJson(),
      'langue': langue,
      'type_projection': type_projection,
      'places_disponibles': places_disponibles,
      'prix': prix,
      'type_seance': type_seance,
      'created_at': created_at.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SeanceImpl extends Seance {
  _SeanceImpl({
    int? id,
    required int film_id,
    required int salle_id,
    required DateTime date_heure,
    String? langue,
    String? type_projection,
    required int places_disponibles,
    required double prix,
    String? type_seance,
    DateTime? created_at,
  }) : super._(
         id: id,
         film_id: film_id,
         salle_id: salle_id,
         date_heure: date_heure,
         langue: langue,
         type_projection: type_projection,
         places_disponibles: places_disponibles,
         prix: prix,
         type_seance: type_seance,
         created_at: created_at,
       );

  /// Returns a shallow copy of this [Seance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Seance copyWith({
    Object? id = _Undefined,
    int? film_id,
    int? salle_id,
    DateTime? date_heure,
    String? langue,
    String? type_projection,
    int? places_disponibles,
    double? prix,
    String? type_seance,
    DateTime? created_at,
  }) {
    return Seance(
      id: id is int? ? id : this.id,
      film_id: film_id ?? this.film_id,
      salle_id: salle_id ?? this.salle_id,
      date_heure: date_heure ?? this.date_heure,
      langue: langue ?? this.langue,
      type_projection: type_projection ?? this.type_projection,
      places_disponibles: places_disponibles ?? this.places_disponibles,
      prix: prix ?? this.prix,
      type_seance: type_seance ?? this.type_seance,
      created_at: created_at ?? this.created_at,
    );
  }
}
