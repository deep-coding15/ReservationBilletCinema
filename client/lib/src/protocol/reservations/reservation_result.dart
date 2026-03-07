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

abstract class ReservationResult implements _i1.SerializableModel {
  ReservationResult._({
    required this.reservationId,
    this.numeroReservation,
    required this.montantTotal,
  });

  factory ReservationResult({
    required int reservationId,
    String? numeroReservation,
    required double montantTotal,
  }) = _ReservationResultImpl;

  factory ReservationResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReservationResult(
      reservationId: jsonSerialization['reservationId'] as int,
      numeroReservation: jsonSerialization['numeroReservation'] as String?,
      montantTotal: (jsonSerialization['montantTotal'] as num).toDouble(),
    );
  }

  int reservationId;

  String? numeroReservation;

  double montantTotal;

  @_i1.useResult
  ReservationResult copyWith({
    int? reservationId,
    String? numeroReservation,
    double? montantTotal,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReservationResult',
      'reservationId': reservationId,
      if (numeroReservation != null) 'numeroReservation': numeroReservation,
      'montantTotal': montantTotal,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReservationResultImpl extends ReservationResult {
  _ReservationResultImpl({
    required int reservationId,
    String? numeroReservation,
    required double montantTotal,
  }) : super._(
         reservationId: reservationId,
         numeroReservation: numeroReservation,
         montantTotal: montantTotal,
       );

  @_i1.useResult
  @override
  ReservationResult copyWith({
    int? reservationId,
    String? numeroReservation,
    double? montantTotal,
  }) {
    return ReservationResult(
      reservationId: reservationId ?? this.reservationId,
      numeroReservation: numeroReservation ?? this.numeroReservation,
      montantTotal: montantTotal ?? this.montantTotal,
    );
  }
}
