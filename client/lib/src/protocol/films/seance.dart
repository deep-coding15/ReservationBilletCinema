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

abstract class Seance implements _i1.SerializableModel {
  Seance._({
    required this.id,
    required this.filmId,
    required this.salleId,
    required this.dateHeure,
    this.langue,
    this.typeProjection,
    required this.placesDisponibles,
    required this.prix,
    this.typeSeance,
    this.cinemaNom,
    this.salleCode,
  });

  factory Seance({
    required int id,
    required int filmId,
    required int salleId,
    required DateTime dateHeure,
    String? langue,
    String? typeProjection,
    required int placesDisponibles,
    required double prix,
    String? typeSeance,
    String? cinemaNom,
    String? salleCode,
  }) = _SeanceImpl;

  factory Seance.fromJson(Map<String, dynamic> jsonSerialization) {
    return Seance(
      id: jsonSerialization['id'] as int,
      filmId: jsonSerialization['filmId'] as int,
      salleId: jsonSerialization['salleId'] as int,
      dateHeure: _i2.Protocol().deserialize<DateTime>(
        jsonSerialization['dateHeure'],
      ),
      langue: jsonSerialization['langue'] as String?,
      typeProjection: jsonSerialization['typeProjection'] as String?,
      placesDisponibles: jsonSerialization['placesDisponibles'] as int,
      prix: (jsonSerialization['prix'] as num).toDouble(),
      typeSeance: jsonSerialization['typeSeance'] as String?,
      cinemaNom: jsonSerialization['cinemaNom'] as String?,
      salleCode: jsonSerialization['salleCode'] as String?,
    );
  }

  int id;

  int filmId;

  int salleId;

  DateTime dateHeure;

  String? langue;

  String? typeProjection;

  int placesDisponibles;

  double prix;

  String? typeSeance;

  String? cinemaNom;

  String? salleCode;

  /// Returns a shallow copy of this [Seance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Seance copyWith({
    int? id,
    int? filmId,
    int? salleId,
    DateTime? dateHeure,
    String? langue,
    String? typeProjection,
    int? placesDisponibles,
    double? prix,
    String? typeSeance,
    String? cinemaNom,
    String? salleCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Seance',
      'id': id,
      'filmId': filmId,
      'salleId': salleId,
      'dateHeure': dateHeure.toJson(),
      if (langue != null) 'langue': langue,
      if (typeProjection != null) 'typeProjection': typeProjection,
      'placesDisponibles': placesDisponibles,
      'prix': prix,
      if (typeSeance != null) 'typeSeance': typeSeance,
      if (cinemaNom != null) 'cinemaNom': cinemaNom,
      if (salleCode != null) 'salleCode': salleCode,
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
    required int id,
    required int filmId,
    required int salleId,
    required DateTime dateHeure,
    String? langue,
    String? typeProjection,
    required int placesDisponibles,
    required double prix,
    String? typeSeance,
    String? cinemaNom,
    String? salleCode,
  }) : super._(
         id: id,
         filmId: filmId,
         salleId: salleId,
         dateHeure: dateHeure,
         langue: langue,
         typeProjection: typeProjection,
         placesDisponibles: placesDisponibles,
         prix: prix,
         typeSeance: typeSeance,
         cinemaNom: cinemaNom,
         salleCode: salleCode,
       );

  /// Returns a shallow copy of this [Seance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Seance copyWith({
    int? id,
    int? filmId,
    int? salleId,
    DateTime? dateHeure,
    Object? langue = _Undefined,
    Object? typeProjection = _Undefined,
    int? placesDisponibles,
    double? prix,
    Object? typeSeance = _Undefined,
    Object? cinemaNom = _Undefined,
    Object? salleCode = _Undefined,
  }) {
    return Seance(
      id: id ?? this.id,
      filmId: filmId ?? this.filmId,
      salleId: salleId ?? this.salleId,
      dateHeure: dateHeure ?? this.dateHeure,
      langue: langue is String? ? langue : this.langue,
      typeProjection: typeProjection is String?
          ? typeProjection
          : this.typeProjection,
      placesDisponibles: placesDisponibles ?? this.placesDisponibles,
      prix: prix ?? this.prix,
      typeSeance: typeSeance is String? ? typeSeance : this.typeSeance,
      cinemaNom: cinemaNom is String? ? cinemaNom : this.cinemaNom,
      salleCode: salleCode is String? ? salleCode : this.salleCode,
    );
  }
}
