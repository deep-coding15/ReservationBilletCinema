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
import 'films/cinema.dart' as _i2;
import 'films/film.dart' as _i3;
import 'films/salle.dart' as _i4;
import 'films/seance.dart' as _i5;
import 'greetings/greeting.dart' as _i6;
import 'reservations/reservation_result.dart' as _i7;
import 'reservations/siege.dart' as _i8;
import 'utilisateur.dart' as _i13;
import 'package:cinema_reservation_client/src/protocol/films/film.dart' as _i8;
import 'package:cinema_reservation_client/src/protocol/films/seance.dart'
    as _i9;
import 'package:cinema_reservation_client/src/protocol/films/cinema.dart'
    as _i10;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i11;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i12;
export 'films/cinema.dart';
export 'films/film.dart';
export 'films/salle.dart';
export 'films/seance.dart';
export 'greetings/greeting.dart';
export 'reservations/reservation_result.dart';
export 'reservations/siege.dart';
export 'utilisateur.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
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

    if (t == _i2.Cinema) {
      return _i2.Cinema.fromJson(data) as T;
    }
    if (t == _i3.Film) {
      return _i3.Film.fromJson(data) as T;
    }
    if (t == _i4.Salle) {
      return _i4.Salle.fromJson(data) as T;
    }
    if (t == _i5.Seance) {
      return _i5.Seance.fromJson(data) as T;
    }
    if (t == _i6.Greeting) {
      return _i6.Greeting.fromJson(data) as T;
    }
    if (t == _i7.Utilisateur) {
      return _i7.Utilisateur.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Cinema?>()) {
      return (data != null ? _i2.Cinema.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Film?>()) {
      return (data != null ? _i3.Film.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Salle?>()) {
      return (data != null ? _i4.Salle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Seance?>()) {
      return (data != null ? _i5.Seance.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Greeting?>()) {
      return (data != null ? _i6.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ReservationResult?>()) {
      return (data != null ? _i7.ReservationResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Siege?>()) {
      return (data != null ? _i8.Siege.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.Utilisateur?>()) {
      return (data != null ? _i13.Utilisateur.fromJson(data) : null) as T;
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
    if (t == List<_i8.Film>) {
      return (data as List).map((e) => deserialize<_i8.Film>(e)).toList() as T;
    }
    if (t == List<_i9.Seance>) {
      return (data as List).map((e) => deserialize<_i9.Seance>(e)).toList()
          as T;
    }
    if (t == List<_i10.Cinema>) {
      return (data as List).map((e) => deserialize<_i10.Cinema>(e)).toList()
          as T;
    }
    try {
      return _i11.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i12.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Cinema => 'Cinema',
      _i3.Film => 'Film',
      _i4.Salle => 'Salle',
      _i5.Seance => 'Seance',
      _i6.Greeting => 'Greeting',
      _i7.ReservationResult => 'ReservationResult',
      _i8.Siege => 'Siege',
      _i13.Utilisateur => 'Utilisateur',
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
      case _i2.Cinema():
        return 'Cinema';
      case _i3.Film():
        return 'Film';
      case _i4.Salle():
        return 'Salle';
      case _i5.Seance():
        return 'Seance';
      case _i6.Greeting():
        return 'Greeting';
      case _i7.Utilisateur():
        return 'Utilisateur';
    }
    className = _i11.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i12.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'Cinema') {
      return deserialize<_i2.Cinema>(data['data']);
    }
    if (dataClassName == 'Film') {
      return deserialize<_i3.Film>(data['data']);
    }
    if (dataClassName == 'Salle') {
      return deserialize<_i4.Salle>(data['data']);
    }
    if (dataClassName == 'Seance') {
      return deserialize<_i5.Seance>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i6.Greeting>(data['data']);
    }
    if (dataClassName == 'ReservationResult') {
      return deserialize<_i7.ReservationResult>(data['data']);
    }
    if (dataClassName == 'Siege') {
      return deserialize<_i8.Siege>(data['data']);
    }
    if (dataClassName == 'Utilisateur') {
      return deserialize<_i13.Utilisateur>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i11.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i12.Protocol().deserializeByClassName(data);
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
      return _i11.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i12.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
