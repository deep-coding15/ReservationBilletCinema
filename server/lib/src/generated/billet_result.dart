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
import 'optionnel_reservation.dart' as _i2;
import 'package:cinema_reservation_server/src/generated/protocol.dart' as _i3;

abstract class BilletResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  BilletResult._({
    required this.billetId,
    required this.reservationId,
    required this.siegeId,
    required this.seanceId,
    required this.filmId,
    required this.salleId,
    required this.produitsOptionnels,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.qrCode,
    required this.estValide,
  });

  factory BilletResult({
    required int billetId,
    required int reservationId,
    required int siegeId,
    required int seanceId,
    required int filmId,
    required int salleId,
    required List<_i2.OptionnelReservation> produitsOptionnels,
    required DateTime startTime,
    required DateTime endTime,
    required double price,
    required String qrCode,
    required bool estValide,
  }) = _BilletResultImpl;

  factory BilletResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return BilletResult(
      billetId: jsonSerialization['billetId'] as int,
      reservationId: jsonSerialization['reservationId'] as int,
      siegeId: jsonSerialization['siegeId'] as int,
      seanceId: jsonSerialization['seanceId'] as int,
      filmId: jsonSerialization['filmId'] as int,
      salleId: jsonSerialization['salleId'] as int,
      produitsOptionnels: _i3.Protocol()
          .deserialize<List<_i2.OptionnelReservation>>(
            jsonSerialization['produitsOptionnels'],
          ),
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      price: (jsonSerialization['price'] as num).toDouble(),
      qrCode: jsonSerialization['qrCode'] as String,
      estValide: jsonSerialization['estValide'] as bool,
    );
  }

  int billetId;

  int reservationId;

  int siegeId;

  int seanceId;

  int filmId;

  int salleId;

  List<_i2.OptionnelReservation> produitsOptionnels;

  DateTime startTime;

  DateTime endTime;

  double price;

  String qrCode;

  bool estValide;

  /// Returns a shallow copy of this [BilletResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BilletResult copyWith({
    int? billetId,
    int? reservationId,
    int? siegeId,
    int? seanceId,
    int? filmId,
    int? salleId,
    List<_i2.OptionnelReservation>? produitsOptionnels,
    DateTime? startTime,
    DateTime? endTime,
    double? price,
    String? qrCode,
    bool? estValide,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BilletResult',
      'billetId': billetId,
      'reservationId': reservationId,
      'siegeId': siegeId,
      'seanceId': seanceId,
      'filmId': filmId,
      'salleId': salleId,
      'produitsOptionnels': produitsOptionnels.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'price': price,
      'qrCode': qrCode,
      'estValide': estValide,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BilletResult',
      'billetId': billetId,
      'reservationId': reservationId,
      'siegeId': siegeId,
      'seanceId': seanceId,
      'filmId': filmId,
      'salleId': salleId,
      'produitsOptionnels': produitsOptionnels.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'price': price,
      'qrCode': qrCode,
      'estValide': estValide,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _BilletResultImpl extends BilletResult {
  _BilletResultImpl({
    required int billetId,
    required int reservationId,
    required int siegeId,
    required int seanceId,
    required int filmId,
    required int salleId,
    required List<_i2.OptionnelReservation> produitsOptionnels,
    required DateTime startTime,
    required DateTime endTime,
    required double price,
    required String qrCode,
    required bool estValide,
  }) : super._(
         billetId: billetId,
         reservationId: reservationId,
         siegeId: siegeId,
         seanceId: seanceId,
         filmId: filmId,
         salleId: salleId,
         produitsOptionnels: produitsOptionnels,
         startTime: startTime,
         endTime: endTime,
         price: price,
         qrCode: qrCode,
         estValide: estValide,
       );

  /// Returns a shallow copy of this [BilletResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BilletResult copyWith({
    int? billetId,
    int? reservationId,
    int? siegeId,
    int? seanceId,
    int? filmId,
    int? salleId,
    List<_i2.OptionnelReservation>? produitsOptionnels,
    DateTime? startTime,
    DateTime? endTime,
    double? price,
    String? qrCode,
    bool? estValide,
  }) {
    return BilletResult(
      billetId: billetId ?? this.billetId,
      reservationId: reservationId ?? this.reservationId,
      siegeId: siegeId ?? this.siegeId,
      seanceId: seanceId ?? this.seanceId,
      filmId: filmId ?? this.filmId,
      salleId: salleId ?? this.salleId,
      produitsOptionnels:
          produitsOptionnels ??
          this.produitsOptionnels.map((e0) => e0.copyWith()).toList(),
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      price: price ?? this.price,
      qrCode: qrCode ?? this.qrCode,
      estValide: estValide ?? this.estValide,
    );
  }
}
