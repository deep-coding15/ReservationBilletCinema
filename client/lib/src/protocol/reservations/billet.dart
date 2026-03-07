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

abstract class Billet implements _i1.SerializableModel {
  Billet._({
    required this.id,
    required this.reservationId,
    this.dateEmission,
    this.estValide,
    this.typeBillet,
    this.qrCode,
  });

  factory Billet({
    required int id,
    required int reservationId,
    DateTime? dateEmission,
    bool? estValide,
    String? typeBillet,
    String? qrCode,
  }) = _BilletImpl;

  factory Billet.fromJson(Map<String, dynamic> jsonSerialization) {
    return Billet(
      id: jsonSerialization['id'] as int,
      reservationId: jsonSerialization['reservationId'] as int,
      dateEmission: jsonSerialization['dateEmission'] != null
          ? _i2.Protocol().deserialize<DateTime>(
              jsonSerialization['dateEmission'],
            )
          : null,
      estValide: jsonSerialization['estValide'] as bool?,
      typeBillet: jsonSerialization['typeBillet'] as String?,
      qrCode: jsonSerialization['qrCode'] as String?,
    );
  }

  int id;
  int reservationId;
  DateTime? dateEmission;
  bool? estValide;
  String? typeBillet;
  String? qrCode;

  @_i1.useResult
  Billet copyWith({
    int? id,
    int? reservationId,
    DateTime? dateEmission,
    bool? estValide,
    String? typeBillet,
    String? qrCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Billet',
      'id': id,
      'reservationId': reservationId,
      if (dateEmission != null) 'dateEmission': dateEmission!.toJson(),
      if (estValide != null) 'estValide': estValide,
      if (typeBillet != null) 'typeBillet': typeBillet,
      if (qrCode != null) 'qrCode': qrCode,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BilletImpl extends Billet {
  _BilletImpl({
    required int id,
    required int reservationId,
    DateTime? dateEmission,
    bool? estValide,
    String? typeBillet,
    String? qrCode,
  }) : super._(
         id: id,
         reservationId: reservationId,
         dateEmission: dateEmission,
         estValide: estValide,
         typeBillet: typeBillet,
         qrCode: qrCode,
       );

  @override
  Billet copyWith({
    int? id,
    int? reservationId,
    DateTime? dateEmission,
    bool? estValide,
    Object? typeBillet = _Undefined,
    Object? qrCode = _Undefined,
  }) {
    return Billet(
      id: id ?? this.id,
      reservationId: reservationId ?? this.reservationId,
      dateEmission: dateEmission ?? this.dateEmission,
      estValide: estValide ?? this.estValide,
      typeBillet: typeBillet is String? ? typeBillet : this.typeBillet,
      qrCode: qrCode is String? ? qrCode : this.qrCode,
    );
  }
}
