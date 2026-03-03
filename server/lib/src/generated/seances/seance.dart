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

abstract class Seance implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Seance._({
    this.id,
    required this.film_id,
    required this.salle_id,
    required this.date_heure,
    String? langue,
    String? type_projection,
    required this.places_disponibles,
    required this.prix,
    String? type_seance,
    DateTime? created_at,
  }) : langue = langue ?? 'VF',
       type_projection = type_projection ?? '2D',
       type_seance = type_seance ?? 'standard',
       created_at = created_at ?? DateTime.now();

  factory Seance({
    int? id,
    required int film_id,
    required int salle_id,
    required DateTime date_heure,
    String? langue,
    String? type_projection,
    required int places_disponibles,
    required double prix,
    String? type_seance,
    DateTime? created_at,
  }) = _SeanceImpl;

  factory Seance.fromJson(Map<String, dynamic> jsonSerialization) {
    return Seance(
      id: jsonSerialization['id'] as int?,
      film_id: jsonSerialization['film_id'] as int,
      salle_id: jsonSerialization['salle_id'] as int,
      date_heure: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['date_heure'],
      ),
      langue: jsonSerialization['langue'] as String?,
      type_projection: jsonSerialization['type_projection'] as String?,
      places_disponibles: jsonSerialization['places_disponibles'] as int,
      prix: (jsonSerialization['prix'] as num).toDouble(),
      type_seance: jsonSerialization['type_seance'] as String?,
      created_at: jsonSerialization['created_at'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created_at']),
    );
  }

  static final t = SeanceTable();

  static const db = SeanceRepository._();

  @override
  int? id;

  int film_id;

  int salle_id;

  DateTime date_heure;

  String langue;

  String type_projection;

  int places_disponibles;

  double prix;

  String type_seance;

  DateTime created_at;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Seance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Seance copyWith({
    int? id,
    int? film_id,
    int? salle_id,
    DateTime? date_heure,
    String? langue,
    String? type_projection,
    int? places_disponibles,
    double? prix,
    String? type_seance,
    DateTime? created_at,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Seance',
      if (id != null) 'id': id,
      'film_id': film_id,
      'salle_id': salle_id,
      'date_heure': date_heure.toJson(),
      'langue': langue,
      'type_projection': type_projection,
      'places_disponibles': places_disponibles,
      'prix': prix,
      'type_seance': type_seance,
      'created_at': created_at.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Seance',
      if (id != null) 'id': id,
      'film_id': film_id,
      'salle_id': salle_id,
      'date_heure': date_heure.toJson(),
      'langue': langue,
      'type_projection': type_projection,
      'places_disponibles': places_disponibles,
      'prix': prix,
      'type_seance': type_seance,
      'created_at': created_at.toJson(),
    };
  }

  static SeanceInclude include() {
    return SeanceInclude._();
  }

  static SeanceIncludeList includeList({
    _i1.WhereExpressionBuilder<SeanceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SeanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SeanceTable>? orderByList,
    SeanceInclude? include,
  }) {
    return SeanceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Seance.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Seance.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SeanceImpl extends Seance {
  _SeanceImpl({
    int? id,
    required int film_id,
    required int salle_id,
    required DateTime date_heure,
    String? langue,
    String? type_projection,
    required int places_disponibles,
    required double prix,
    String? type_seance,
    DateTime? created_at,
  }) : super._(
         id: id,
         film_id: film_id,
         salle_id: salle_id,
         date_heure: date_heure,
         langue: langue,
         type_projection: type_projection,
         places_disponibles: places_disponibles,
         prix: prix,
         type_seance: type_seance,
         created_at: created_at,
       );

  /// Returns a shallow copy of this [Seance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Seance copyWith({
    Object? id = _Undefined,
    int? film_id,
    int? salle_id,
    DateTime? date_heure,
    String? langue,
    String? type_projection,
    int? places_disponibles,
    double? prix,
    String? type_seance,
    DateTime? created_at,
  }) {
    return Seance(
      id: id is int? ? id : this.id,
      film_id: film_id ?? this.film_id,
      salle_id: salle_id ?? this.salle_id,
      date_heure: date_heure ?? this.date_heure,
      langue: langue ?? this.langue,
      type_projection: type_projection ?? this.type_projection,
      places_disponibles: places_disponibles ?? this.places_disponibles,
      prix: prix ?? this.prix,
      type_seance: type_seance ?? this.type_seance,
      created_at: created_at ?? this.created_at,
    );
  }
}

class SeanceUpdateTable extends _i1.UpdateTable<SeanceTable> {
  SeanceUpdateTable(super.table);

  _i1.ColumnValue<int, int> film_id(int value) => _i1.ColumnValue(
    table.film_id,
    value,
  );

  _i1.ColumnValue<int, int> salle_id(int value) => _i1.ColumnValue(
    table.salle_id,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> date_heure(DateTime value) =>
      _i1.ColumnValue(
        table.date_heure,
        value,
      );

  _i1.ColumnValue<String, String> langue(String value) => _i1.ColumnValue(
    table.langue,
    value,
  );

  _i1.ColumnValue<String, String> type_projection(String value) =>
      _i1.ColumnValue(
        table.type_projection,
        value,
      );

  _i1.ColumnValue<int, int> places_disponibles(int value) => _i1.ColumnValue(
    table.places_disponibles,
    value,
  );

  _i1.ColumnValue<double, double> prix(double value) => _i1.ColumnValue(
    table.prix,
    value,
  );

  _i1.ColumnValue<String, String> type_seance(String value) => _i1.ColumnValue(
    table.type_seance,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> created_at(DateTime value) =>
      _i1.ColumnValue(
        table.created_at,
        value,
      );
}

class SeanceTable extends _i1.Table<int?> {
  SeanceTable({super.tableRelation}) : super(tableName: 'seances') {
    updateTable = SeanceUpdateTable(this);
    film_id = _i1.ColumnInt(
      'film_id',
      this,
    );
    salle_id = _i1.ColumnInt(
      'salle_id',
      this,
    );
    date_heure = _i1.ColumnDateTime(
      'date_heure',
      this,
    );
    langue = _i1.ColumnString(
      'langue',
      this,
      hasDefault: true,
    );
    type_projection = _i1.ColumnString(
      'type_projection',
      this,
      hasDefault: true,
    );
    places_disponibles = _i1.ColumnInt(
      'places_disponibles',
      this,
    );
    prix = _i1.ColumnDouble(
      'prix',
      this,
    );
    type_seance = _i1.ColumnString(
      'type_seance',
      this,
      hasDefault: true,
    );
    created_at = _i1.ColumnDateTime(
      'created_at',
      this,
      hasDefault: true,
    );
  }

  late final SeanceUpdateTable updateTable;

  late final _i1.ColumnInt film_id;

  late final _i1.ColumnInt salle_id;

  late final _i1.ColumnDateTime date_heure;

  late final _i1.ColumnString langue;

  late final _i1.ColumnString type_projection;

  late final _i1.ColumnInt places_disponibles;

  late final _i1.ColumnDouble prix;

  late final _i1.ColumnString type_seance;

  late final _i1.ColumnDateTime created_at;

  @override
  List<_i1.Column> get columns => [
    id,
    film_id,
    salle_id,
    date_heure,
    langue,
    type_projection,
    places_disponibles,
    prix,
    type_seance,
    created_at,
  ];
}

class SeanceInclude extends _i1.IncludeObject {
  SeanceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Seance.t;
}

class SeanceIncludeList extends _i1.IncludeList {
  SeanceIncludeList._({
    _i1.WhereExpressionBuilder<SeanceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Seance.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Seance.t;
}

class SeanceRepository {
  const SeanceRepository._();

  /// Returns a list of [Seance]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Seance>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SeanceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SeanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SeanceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Seance>(
      where: where?.call(Seance.t),
      orderBy: orderBy?.call(Seance.t),
      orderByList: orderByList?.call(Seance.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Seance] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Seance?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SeanceTable>? where,
    int? offset,
    _i1.OrderByBuilder<SeanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SeanceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Seance>(
      where: where?.call(Seance.t),
      orderBy: orderBy?.call(Seance.t),
      orderByList: orderByList?.call(Seance.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Seance] by its [id] or null if no such row exists.
  Future<Seance?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Seance>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Seance]s in the list and returns the inserted rows.
  ///
  /// The returned [Seance]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Seance>> insert(
    _i1.Session session,
    List<Seance> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Seance>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Seance] and returns the inserted row.
  ///
  /// The returned [Seance] will have its `id` field set.
  Future<Seance> insertRow(
    _i1.Session session,
    Seance row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Seance>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Seance]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Seance>> update(
    _i1.Session session,
    List<Seance> rows, {
    _i1.ColumnSelections<SeanceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Seance>(
      rows,
      columns: columns?.call(Seance.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Seance]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Seance> updateRow(
    _i1.Session session,
    Seance row, {
    _i1.ColumnSelections<SeanceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Seance>(
      row,
      columns: columns?.call(Seance.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Seance] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Seance?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SeanceUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Seance>(
      id,
      columnValues: columnValues(Seance.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Seance]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Seance>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SeanceUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SeanceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SeanceTable>? orderBy,
    _i1.OrderByListBuilder<SeanceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Seance>(
      columnValues: columnValues(Seance.t.updateTable),
      where: where(Seance.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Seance.t),
      orderByList: orderByList?.call(Seance.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Seance]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Seance>> delete(
    _i1.Session session,
    List<Seance> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Seance>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Seance].
  Future<Seance> deleteRow(
    _i1.Session session,
    Seance row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Seance>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Seance>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SeanceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Seance>(
      where: where(Seance.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SeanceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Seance>(
      where: where?.call(Seance.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
