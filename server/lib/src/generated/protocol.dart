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
import 'favori.dart' as _i5;
import 'films/cinema.dart' as _i6;
import 'films/film.dart' as _i7;
import 'films/salle.dart' as _i8;
import 'films/seance.dart' as _i9;
import 'utilisateur.dart' as _i10;
import 'reservations/reservation_result.dart' as _i16;
import 'reservations/siege.dart' as _i17;
import 'events/evenement.dart' as _i18;
import 'reservations/reservation.dart' as _i19;
import 'reservations/billet.dart' as _i20;
import 'events/reservation_evenement.dart' as _i21;
import 'package:cinema_reservation_server/src/generated/favori.dart' as _i12;
import 'package:cinema_reservation_server/src/generated/films/film.dart'
    as _i13;
import 'package:cinema_reservation_server/src/generated/films/seance.dart'
    as _i14;
import 'package:cinema_reservation_server/src/generated/films/cinema.dart'
    as _i15;
export 'favori.dart';
export 'films/cinema.dart';
export 'films/film.dart';
export 'films/salle.dart';
export 'films/seance.dart';
export 'utilisateur.dart';
export 'reservations/reservation_result.dart';
export 'reservations/siege.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'favoris',
      dartName: 'Favori',
      schema: 'public',
      module: 'cinema_reservation',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'favoris_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'utilisateurId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'cinemaId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'favoris_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'favori_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'utilisateurId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'cinemaId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: false,
    ),
    _i2.TableDefinition(
      name: 'users',
      dartName: 'Utilisateur',
      schema: 'public',
      module: 'cinema_reservation',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'users_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'nom',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'telephone',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'dateNaissance',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'preferences',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<String>?',
        ),
        _i2.ColumnDefinition(
          name: 'statut',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'actif\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'client\'::text',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'users_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'utilisateur_email_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'utilisateur_auth_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: false,
    ),
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

    if (t == _i5.Favori) {
      return _i5.Favori.fromJson(data) as T;
    }
    if (t == _i6.Cinema) {
      return _i6.Cinema.fromJson(data) as T;
    }
    if (t == _i7.Film) {
      return _i7.Film.fromJson(data) as T;
    }
    if (t == _i8.Salle) {
      return _i8.Salle.fromJson(data) as T;
    }
    if (t == _i9.Seance) {
      return _i9.Seance.fromJson(data) as T;
    }
    if (t == _i10.Utilisateur) {
      return _i10.Utilisateur.fromJson(data) as T;
    }
    if (t == _i16.ReservationResult) {
      return _i16.ReservationResult.fromJson(data) as T;
    }
    if (t == _i17.Siege) {
      return _i17.Siege.fromJson(data) as T;
    }
    if (t == _i18.Evenement) {
      return _i18.Evenement.fromJson(data) as T;
    }
    if (t == _i19.Reservation) {
      return _i19.Reservation.fromJson(data) as T;
    }
    if (t == _i20.Billet) {
      return _i20.Billet.fromJson(data) as T;
    }
    if (t == _i21.ReservationEvenement) {
      return _i21.ReservationEvenement.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.Favori?>()) {
      return (data != null ? _i5.Favori.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Cinema?>()) {
      return (data != null ? _i6.Cinema.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Film?>()) {
      return (data != null ? _i7.Film.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Salle?>()) {
      return (data != null ? _i8.Salle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Seance?>()) {
      return (data != null ? _i9.Seance.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Utilisateur?>()) {
      return (data != null ? _i10.Utilisateur.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.ReservationResult?>()) {
      return (data != null ? _i16.ReservationResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.Siege?>()) {
      return (data != null ? _i17.Siege.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.Evenement?>()) {
      return (data != null ? _i18.Evenement.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.Reservation?>()) {
      return (data != null ? _i19.Reservation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Billet?>()) {
      return (data != null ? _i20.Billet.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.ReservationEvenement?>()) {
      return (data != null ? _i21.ReservationEvenement.fromJson(data) : null)
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
    if (t == List<_i12.Favori>) {
      return (data as List).map((e) => deserialize<_i12.Favori>(e)).toList()
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
    if (t == List<_i13.Film>) {
      return (data as List).map((e) => deserialize<_i13.Film>(e)).toList() as T;
    }
    if (t == List<_i14.Seance>) {
      return (data as List).map((e) => deserialize<_i14.Seance>(e)).toList()
          as T;
    }
    if (t == List<_i15.Cinema>) {
      return (data as List).map((e) => deserialize<_i15.Cinema>(e)).toList()
          as T;
    }
    if (t == List<_i17.Siege>) {
      return (data as List).map((e) => deserialize<_i17.Siege>(e)).toList()
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
      _i5.Favori => 'Favori',
      _i6.Cinema => 'Cinema',
      _i7.Film => 'Film',
      _i8.Salle => 'Salle',
      _i9.Seance => 'Seance',
      _i10.Utilisateur => 'Utilisateur',
      _i16.ReservationResult => 'ReservationResult',
      _i17.Siege => 'Siege',
      _i18.Evenement => 'Evenement',
      _i19.Reservation => 'Reservation',
      _i20.Billet => 'Billet',
      _i21.ReservationEvenement => 'ReservationEvenement',
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
      case _i5.Favori():
        return 'Favori';
      case _i6.Cinema():
        return 'Cinema';
      case _i7.Film():
        return 'Film';
      case _i8.Salle():
        return 'Salle';
      case _i9.Seance():
        return 'Seance';
      case _i10.Utilisateur():
        return 'Utilisateur';
      case _i16.ReservationResult():
        return 'ReservationResult';
      case _i17.Siege():
        return 'Siege';
      case _i18.Evenement():
        return 'Evenement';
      case _i19.Reservation():
        return 'Reservation';
      case _i20.Billet():
        return 'Billet';
      case _i21.ReservationEvenement():
        return 'ReservationEvenement';
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
    if (dataClassName == 'Favori') {
      return deserialize<_i5.Favori>(data['data']);
    }
    if (dataClassName == 'Cinema') {
      return deserialize<_i6.Cinema>(data['data']);
    }
    if (dataClassName == 'Film') {
      return deserialize<_i7.Film>(data['data']);
    }
    if (dataClassName == 'Salle') {
      return deserialize<_i8.Salle>(data['data']);
    }
    if (dataClassName == 'Seance') {
      return deserialize<_i9.Seance>(data['data']);
    }
    if (dataClassName == 'Utilisateur') {
      return deserialize<_i10.Utilisateur>(data['data']);
    }
    if (dataClassName == 'ReservationResult') {
      return deserialize<_i16.ReservationResult>(data['data']);
    }
    if (dataClassName == 'Siege') {
      return deserialize<_i17.Siege>(data['data']);
    }
    if (dataClassName == 'Evenement') {
      return deserialize<_i18.Evenement>(data['data']);
    }
    if (dataClassName == 'Reservation') {
      return deserialize<_i19.Reservation>(data['data']);
    }
    if (dataClassName == 'Billet') {
      return deserialize<_i20.Billet>(data['data']);
    }
    if (dataClassName == 'ReservationEvenement') {
      return deserialize<_i21.ReservationEvenement>(data['data']);
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
    switch (t) {
      case _i5.Favori:
        return _i5.Favori.t;
      case _i10.Utilisateur:
        return _i10.Utilisateur.t;
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
