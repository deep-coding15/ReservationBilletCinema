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

abstract class Reservation implements _i1.SerializableModel {
  Reservation._({
    required this.id,
    required this.utilisateurId,
    required this.seanceId,
    this.dateReservation,
    required this.montantTotal,
    this.statut,
  });

  factory Reservation({
    required int id,
    required int utilisateurId,
    required int seanceId,
    DateTime? dateReservation,
    required double montantTotal,
    String? statut,
  }) = _ReservationImpl;

  factory Reservation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reservation(
      id: jsonSerialization['id'] as int,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      seanceId: jsonSerialization['seanceId'] as int,
      dateReservation: jsonSerialization['dateReservation'] != null
          ? _i2.Protocol().deserialize<DateTime>(
              jsonSerialization['dateReservation'],
            )
          : null,
      montantTotal: (jsonSerialization['montantTotal'] as num).toDouble(),
      statut: jsonSerialization['statut'] as String?,
    );
  }

  int id;
  int utilisateurId;
  int seanceId;
  DateTime? dateReservation;
  double montantTotal;
  String? statut;

  @_i1.useResult
  Reservation copyWith({
    int? id,
    int? utilisateurId,
    int? seanceId,
    DateTime? dateReservation,
    double? montantTotal,
    String? statut,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reservation',
      'id': id,
      'utilisateurId': utilisateurId,
      'seanceId': seanceId,
      if (dateReservation != null)
        'dateReservation': dateReservation!.toJson(),
      'montantTotal': montantTotal,
      if (statut != null) 'statut': statut,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReservationImpl extends Reservation {
  _ReservationImpl({
    required int id,
    required int utilisateurId,
    required int seanceId,
    DateTime? dateReservation,
    required double montantTotal,
    String? statut,
  }) : super._(
         id: id,
         utilisateurId: utilisateurId,
         seanceId: seanceId,
         dateReservation: dateReservation,
         montantTotal: montantTotal,
         statut: statut,
       );

  @override
  Reservation copyWith({
    int? id,
    int? utilisateurId,
    int? seanceId,
    DateTime? dateReservation,
    double? montantTotal,
    Object? statut = _Undefined,
  }) {
    return Reservation(
      id: id ?? this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      seanceId: seanceId ?? this.seanceId,
      dateReservation: dateReservation ?? this.dateReservation,
      montantTotal: montantTotal ?? this.montantTotal,
      statut: statut is String? ? statut : this.statut,
    );
  }
}
