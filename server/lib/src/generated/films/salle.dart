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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class Salle
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Salle._({
    required this.id,
    required this.cinemaId,
    required this.codeSalle,
    required this.capacite,
  });

  factory Salle({
    required int id,
    required int cinemaId,
    required String codeSalle,
    required int capacite,
  }) = _SalleImpl;

  factory Salle.fromJson(Map<String, dynamic> jsonSerialization) {
    return Salle(
      id: jsonSerialization['id'] as int,
      cinemaId: jsonSerialization['cinemaId'] as int,
      codeSalle: jsonSerialization['codeSalle'] as String,
      capacite: jsonSerialization['capacite'] as int,
    );
  }

  int id;

  int cinemaId;

  String codeSalle;

  int capacite;

  /// Returns a shallow copy of this [Salle]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Salle copyWith({
    int? id,
    int? cinemaId,
    String? codeSalle,
    int? capacite,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Salle',
      'id': id,
      'cinemaId': cinemaId,
      'codeSalle': codeSalle,
      'capacite': capacite,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Salle',
      'id': id,
      'cinemaId': cinemaId,
      'codeSalle': codeSalle,
      'capacite': capacite,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SalleImpl extends Salle {
  _SalleImpl({
    required int id,
    required int cinemaId,
    required String codeSalle,
    required int capacite,
  }) : super._(
         id: id,
         cinemaId: cinemaId,
         codeSalle: codeSalle,
         capacite: capacite,
       );

  /// Returns a shallow copy of this [Salle]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Salle copyWith({
    int? id,
    int? cinemaId,
    String? codeSalle,
    int? capacite,
  }) {
    return Salle(
      id: id ?? this.id,
      cinemaId: cinemaId ?? this.cinemaId,
      codeSalle: codeSalle ?? this.codeSalle,
      capacite: capacite ?? this.capacite,
    );
  }
}
