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

abstract class ReservationResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ReservationResult._({
    required this.reservationId,
    required this.montantTotal,
  });

  factory ReservationResult({
    required int reservationId,
    required double montantTotal,
  }) = _ReservationResultImpl;

  factory ReservationResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReservationResult(
      reservationId: jsonSerialization['reservationId'] as int,
      montantTotal: (jsonSerialization['montantTotal'] as num).toDouble(),
    );
  }

  int reservationId;
  double montantTotal;

  @override
  Map<String, dynamic> toJson() => {
        'reservationId': reservationId,
        'montantTotal': montantTotal,
      };

  @override
  Map<String, dynamic> toJsonForProtocol() => toJson();
}

class _ReservationResultImpl extends ReservationResult {
  _ReservationResultImpl({
    required super.reservationId,
    required super.montantTotal,
  });
}
