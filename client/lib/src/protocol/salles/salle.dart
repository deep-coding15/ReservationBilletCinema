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

abstract class Salle implements _i1.SerializableModel {
  Salle._({
    this.id,
    required this.cinema_id,
    required this.code_salle,
    required this.capacite,
    this.equipements,
  });

  factory Salle({
    int? id,
    required int cinema_id,
    required String code_salle,
    required int capacite,
    List<String>? equipements,
  }) = _SalleImpl;

  factory Salle.fromJson(Map<String, dynamic> jsonSerialization) {
    return Salle(
      id: jsonSerialization['id'] as int?,
      cinema_id: jsonSerialization['cinema_id'] as int,
      code_salle: jsonSerialization['code_salle'] as String,
      capacite: jsonSerialization['capacite'] as int,
      equipements: jsonSerialization['equipements'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['equipements'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int cinema_id;

  String code_salle;

  int capacite;

  List<String>? equipements;

  /// Returns a shallow copy of this [Salle]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Salle copyWith({
    int? id,
    int? cinema_id,
    String? code_salle,
    int? capacite,
    List<String>? equipements,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Salle',
      if (id != null) 'id': id,
      'cinema_id': cinema_id,
      'code_salle': code_salle,
      'capacite': capacite,
      if (equipements != null) 'equipements': equipements?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SalleImpl extends Salle {
  _SalleImpl({
    int? id,
    required int cinema_id,
    required String code_salle,
    required int capacite,
    List<String>? equipements,
  }) : super._(
         id: id,
         cinema_id: cinema_id,
         code_salle: code_salle,
         capacite: capacite,
         equipements: equipements,
       );

  /// Returns a shallow copy of this [Salle]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Salle copyWith({
    Object? id = _Undefined,
    int? cinema_id,
    String? code_salle,
    int? capacite,
    Object? equipements = _Undefined,
  }) {
    return Salle(
      id: id is int? ? id : this.id,
      cinema_id: cinema_id ?? this.cinema_id,
      code_salle: code_salle ?? this.code_salle,
      capacite: capacite ?? this.capacite,
      equipements: equipements is List<String>?
          ? equipements
          : this.equipements?.map((e0) => e0).toList(),
    );
  }
}
