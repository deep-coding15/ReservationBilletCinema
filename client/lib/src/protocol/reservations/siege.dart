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

abstract class Siege implements _i1.SerializableModel {
  Siege._({
    required this.id,
    required this.salleId,
    required this.numero,
    this.type,
  });

  factory Siege({
    required int id,
    required int salleId,
    required String numero,
    String? type,
  }) = _SiegeImpl;

  factory Siege.fromJson(Map<String, dynamic> jsonSerialization) {
    return Siege(
      id: jsonSerialization['id'] as int,
      salleId: jsonSerialization['salleId'] as int,
      numero: jsonSerialization['numero'] as String,
      type: jsonSerialization['type'] as String?,
    );
  }

  int id;
  int salleId;
  String numero;
  String? type;

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'salleId': salleId,
        'numero': numero,
        'type': type,
      };
}

class _SiegeImpl extends Siege {
  _SiegeImpl({
    required super.id,
    required super.salleId,
    required super.numero,
    super.type,
  });
}
