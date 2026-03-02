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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'films/cinema.dart' as _i5;
import 'films/film.dart' as _i6;
import 'films/salle.dart' as _i7;
import 'films/seance.dart' as _i8;
import 'greetings/greeting.dart' as _i9;
import 'reservations/reservation_result.dart' as _i10;
import 'reservations/siege.dart' as _i11;
import 'package:cinema_reservation_server/src/generated/films/film.dart'
    as _i12;
import 'package:cinema_reservation_server/src/generated/films/seance.dart'
    as _i13;
import 'package:cinema_reservation_server/src/generated/films/cinema.dart'
    as _i14;
export 'films/cinema.dart';
export 'films/film.dart';
export 'films/salle.dart';
export 'films/seance.dart';
export 'greetings/greeting.dart';
export 'reservations/reservation_result.dart';
export 'reservations/siege.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

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

    if (t == _i5.Cinema) {
      return _i5.Cinema.fromJson(data) as T;
    }
    if (t == _i6.Film) {
      return _i6.Film.fromJson(data) as T;
    }
    if (t == _i7.Salle) {
      return _i7.Salle.fromJson(data) as T;
    }
    if (t == _i8.Seance) {
      return _i8.Seance.fromJson(data) as T;
    }
    if (t == _i9.Greeting) {
      return _i9.Greeting.fromJson(data) as T;
    }
    if (t == _i10.ReservationResult) {
      return _i10.ReservationResult.fromJson(data) as T;
    }
    if (t == _i11.Siege) {
      return _i11.Siege.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.Cinema?>()) {
      return (data != null ? _i5.Cinema.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Film?>()) {
      return (data != null ? _i6.Film.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Salle?>()) {
      return (data != null ? _i7.Salle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Seance?>()) {
      return (data != null ? _i8.Seance.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Greeting?>()) {
      return (data != null ? _i9.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.ReservationResult?>()) {
      return (data != null ? _i10.ReservationResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Siege?>()) {
      return (data != null ? _i11.Siege.fromJson(data) : null) as T;
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
    if (t == List<_i12.Film>) {
      return (data as List).map((e) => deserialize<_i12.Film>(e)).toList() as T;
    }
    if (t == List<_i13.Seance>) {
      return (data as List).map((e) => deserialize<_i13.Seance>(e)).toList()
          as T;
    }
    if (t == List<_i14.Cinema>) {
      return (data as List).map((e) => deserialize<_i14.Cinema>(e)).toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.Cinema => 'Cinema',
      _i6.Film => 'Film',
      _i7.Salle => 'Salle',
      _i8.Seance => 'Seance',
      _i9.Greeting => 'Greeting',
      _i10.ReservationResult => 'ReservationResult',
      _i11.Siege => 'Siege',
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
      case _i5.Cinema():
        return 'Cinema';
      case _i6.Film():
        return 'Film';
      case _i7.Salle():
        return 'Salle';
      case _i8.Seance():
        return 'Seance';
      case _i9.Greeting():
        return 'Greeting';
      case _i10.ReservationResult():
        return 'ReservationResult';
      case _i11.Siege():
        return 'Siege';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
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
      return deserialize<_i5.Cinema>(data['data']);
    }
    if (dataClassName == 'Film') {
      return deserialize<_i6.Film>(data['data']);
    }
    if (dataClassName == 'Salle') {
      return deserialize<_i7.Salle>(data['data']);
    }
    if (dataClassName == 'Seance') {
      return deserialize<_i8.Seance>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i9.Greeting>(data['data']);
    }
    if (dataClassName == 'ReservationResult') {
      return deserialize<_i10.ReservationResult>(data['data']);
    }
    if (dataClassName == 'Siege') {
      return deserialize<_i11.Siege>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'cinema_reservation';

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
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
