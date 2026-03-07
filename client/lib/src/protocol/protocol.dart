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
import 'favori.dart' as _i2;
import 'films/cinema.dart' as _i3;
import 'films/film.dart' as _i4;
import 'films/salle.dart' as _i5;
import 'films/seance.dart' as _i6;
import 'utilisateur.dart' as _i7;
import 'package:cinema_reservation_client/src/protocol/reservations/reservation_result.dart' as _i15;
import 'package:cinema_reservation_client/src/protocol/reservations/siege.dart' as _i16;
import 'package:cinema_reservation_client/src/protocol/events/evenement.dart' as _i17;
import 'package:cinema_reservation_client/src/protocol/reservations/reservation.dart' as _i18;
import 'package:cinema_reservation_client/src/protocol/reservations/billet.dart' as _i19;
import 'package:cinema_reservation_client/src/protocol/events/reservation_evenement.dart' as _i20;
import 'package:cinema_reservation_client/src/protocol/favori.dart' as _i9;
import 'package:cinema_reservation_client/src/protocol/films/film.dart' as _i10;
import 'package:cinema_reservation_client/src/protocol/films/seance.dart'
    as _i11;
import 'package:cinema_reservation_client/src/protocol/films/cinema.dart'
    as _i12;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i13;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i14;
export 'favori.dart';
export 'films/cinema.dart';
export 'films/film.dart';
export 'films/salle.dart';
export 'films/seance.dart';
export 'utilisateur.dart';
export 'events/evenement.dart';
export 'reservations/reservation.dart';
export 'reservations/billet.dart';
export 'events/reservation_evenement.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final raw = data['__className__'] as String?;
    if (raw == null) return null;
    return raw.replaceFirst('cinema_reservation.', '').replaceFirst('protocol.', '');
  }

  static DateTime _deserializeDateTime(dynamic data) {
    if (data == null) throw ArgumentError('DateTime null');
    if (data is DateTime) return data;
    if (data is String) return DateTime.parse(data);
    if (data is int) return DateTime.fromMillisecondsSinceEpoch(data);
    if (data is Map) {
      final time = data['time'] ?? data['dateTime'] ?? data['value'];
      if (time is String) return DateTime.parse(time);
      if (time is int) return DateTime.fromMillisecondsSinceEpoch(time);
      for (final v in data.values) {
        if (v is String && v.contains('-') && v.contains('T')) {
          try { return DateTime.parse(v); } catch (_) {}
        }
      }
    }
    return _i1.DateTimeJsonExtension.fromJson(data);
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Favori) {
      return _i2.Favori.fromJson(data) as T;
    }
    if (t == _i3.Cinema) {
      return _i3.Cinema.fromJson(data) as T;
    }
    if (t == _i4.Film) {
      return _i4.Film.fromJson(data) as T;
    }
    if (t == _i5.Salle) {
      return _i5.Salle.fromJson(data) as T;
    }
    if (t == _i6.Seance) {
      return _i6.Seance.fromJson(data) as T;
    }
    if (t == _i7.Utilisateur) {
      return _i7.Utilisateur.fromJson(data) as T;
    }
    if (t == _i15.ReservationResult) {
      return _i15.ReservationResult.fromJson(data) as T;
    }
    if (t == _i16.Siege) {
      return _i16.Siege.fromJson(data) as T;
    }
    if (t == _i17.Evenement) {
      return _i17.Evenement.fromJson(data) as T;
    }
    if (t == _i18.Reservation) {
      return _i18.Reservation.fromJson(data) as T;
    }
    if (t == _i19.Billet) {
      return _i19.Billet.fromJson(data) as T;
    }
    if (t == _i20.ReservationEvenement) {
      return _i20.ReservationEvenement.fromJson(data) as T;
    }
    if (t == DateTime) {
      return _deserializeDateTime(data) as T;
    }
    if (t == _i1.getType<_i2.Favori?>()) {
      return (data != null ? _i2.Favori.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Cinema?>()) {
      return (data != null ? _i3.Cinema.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Film?>()) {
      return (data != null ? _i4.Film.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Salle?>()) {
      return (data != null ? _i5.Salle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Seance?>()) {
      return (data != null ? _i6.Seance.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Utilisateur?>()) {
      return (data != null ? _i7.Utilisateur.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.ReservationResult?>()) {
      return (data != null ? _i15.ReservationResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Siege?>()) {
      return (data != null ? _i16.Siege.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.Evenement?>()) {
      return (data != null ? _i17.Evenement.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.Reservation?>()) {
      return (data != null ? _i18.Reservation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.Billet?>()) {
      return (data != null ? _i19.Billet.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.ReservationEvenement?>()) {
      return (data != null ? _i20.ReservationEvenement.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i9.Favori>) {
      return (data as List).map((e) => deserialize<_i9.Favori>(e)).toList()
          as T;
    }
    if (t == List<dynamic>) {
      return (data as List).map((e) => deserialize<dynamic>(e)).toList() as T;
    }
    if (t == List<Map<String, dynamic>>) {
      return (data as List)
              .map((e) => deserialize<Map<String, dynamic>>(e))
              .toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, dynamic>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
                )
              : null)
          as T;
    }
    if (t == List<_i10.Film>) {
      return (data as List).map((e) => deserialize<_i10.Film>(e)).toList() as T;
    }
    if (t == List<_i11.Seance>) {
      return (data as List).map((e) => deserialize<_i11.Seance>(e)).toList()
          as T;
    }
    if (t == List<_i12.Cinema>) {
      return (data as List).map((e) => deserialize<_i12.Cinema>(e)).toList()
          as T;
    }
    if (t == List<_i16.Siege>) {
      return (data as List).map((e) => deserialize<_i16.Siege>(e)).toList()
          as T;
    }
    if (t == List<_i17.Evenement>) {
      return (data as List).map((e) => deserialize<_i17.Evenement>(e)).toList()
          as T;
    }
    try {
      return _i13.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i14.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      DateTime => 'DateTime',
      _i2.Favori => 'Favori',
      _i3.Cinema => 'Cinema',
      _i4.Film => 'Film',
      _i5.Salle => 'Salle',
      _i6.Seance => 'Seance',
      _i7.Utilisateur => 'Utilisateur',
      _i15.ReservationResult => 'ReservationResult',
      _i16.Siege => 'Siege',
      _i17.Evenement => 'Evenement',
      _i18.Reservation => 'Reservation',
      _i19.Billet => 'Billet',
      _i20.ReservationEvenement => 'ReservationEvenement',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'cinema_reservation.',
        '',
      );
    }

    switch (data) {
      case _i2.Favori():
        return 'Favori';
      case _i3.Cinema():
        return 'Cinema';
      case _i4.Film():
        return 'Film';
      case _i5.Salle():
        return 'Salle';
      case _i6.Seance():
        return 'Seance';
      case _i7.Utilisateur():
        return 'Utilisateur';
      case _i15.ReservationResult():
        return 'ReservationResult';
      case _i16.Siege():
        return 'Siege';
      case _i17.Evenement():
        return 'Evenement';
      case _i18.Reservation():
        return 'Reservation';
      case _i19.Billet():
        return 'Billet';
      case _i20.ReservationEvenement():
        return 'ReservationEvenement';
    }
    className = _i13.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i14.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Favori') {
      return deserialize<_i2.Favori>(data['data']);
    }
    if (dataClassName == 'Cinema') {
      return deserialize<_i3.Cinema>(data['data']);
    }
    if (dataClassName == 'Film') {
      return deserialize<_i4.Film>(data['data']);
    }
    if (dataClassName == 'Salle') {
      return deserialize<_i5.Salle>(data['data']);
    }
    if (dataClassName == 'Seance') {
      return deserialize<_i6.Seance>(data['data']);
    }
    if (dataClassName == 'Utilisateur') {
      return deserialize<_i7.Utilisateur>(data['data']);
    }
    if (dataClassName == 'ReservationResult') {
      return deserialize<_i15.ReservationResult>(data['data']);
    }
    if (dataClassName == 'Siege') {
      return deserialize<_i16.Siege>(data['data']);
    }
    if (dataClassName == 'Evenement') {
      return deserialize<_i17.Evenement>(data['data']);
    }
    if (dataClassName == 'Reservation') {
      return deserialize<_i18.Reservation>(data['data']);
    }
    if (dataClassName == 'Billet') {
      return deserialize<_i19.Billet>(data['data']);
    }
    if (dataClassName == 'ReservationEvenement') {
      return deserialize<_i20.ReservationEvenement>(data['data']);
    }
    if (dataClassName == 'DateTime') {
      return _deserializeDateTime(data['data'] ?? data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i13.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i14.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i13.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i14.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
