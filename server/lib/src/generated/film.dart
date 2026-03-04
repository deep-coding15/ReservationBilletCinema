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

abstract class Film implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Film._({
    this.id,
    required this.title,
    required this.description,
    this.duration,
    required this.releaseDate,
    required this.startTime,
    required this.endTime,
    required this.genre,
    required this.posterUrl,
  });

  factory Film({
    int? id,
    required String title,
    required String description,
    Duration? duration,
    required DateTime releaseDate,
    required DateTime startTime,
    required DateTime endTime,
    required String genre,
    required String posterUrl,
  }) = _FilmImpl;

  factory Film.fromJson(Map<String, dynamic> jsonSerialization) {
    return Film(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      duration: jsonSerialization['duration'] == null
          ? null
          : _i1.DurationJsonExtension.fromJson(jsonSerialization['duration']),
      releaseDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['releaseDate'],
      ),
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      genre: jsonSerialization['genre'] as String,
      posterUrl: jsonSerialization['posterUrl'] as String,
    );
  }

  static final t = FilmTable();

  static const db = FilmRepository._();

  @override
  int? id;

  String title;

  String description;

  Duration? duration;

  DateTime releaseDate;

  DateTime startTime;

  DateTime endTime;

  String genre;

  String posterUrl;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Film]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Film copyWith({
    int? id,
    String? title,
    String? description,
    Duration? duration,
    DateTime? releaseDate,
    DateTime? startTime,
    DateTime? endTime,
    String? genre,
    String? posterUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Film',
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      if (duration != null) 'duration': duration?.toJson(),
      'releaseDate': releaseDate.toJson(),
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'genre': genre,
      'posterUrl': posterUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Film',
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      if (duration != null) 'duration': duration?.toJson(),
      'releaseDate': releaseDate.toJson(),
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'genre': genre,
      'posterUrl': posterUrl,
    };
  }

  static FilmInclude include() {
    return FilmInclude._();
  }

  static FilmIncludeList includeList({
    _i1.WhereExpressionBuilder<FilmTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FilmTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FilmTable>? orderByList,
    FilmInclude? include,
  }) {
    return FilmIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Film.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Film.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FilmImpl extends Film {
  _FilmImpl({
    int? id,
    required String title,
    required String description,
    Duration? duration,
    required DateTime releaseDate,
    required DateTime startTime,
    required DateTime endTime,
    required String genre,
    required String posterUrl,
  }) : super._(
         id: id,
         title: title,
         description: description,
         duration: duration,
         releaseDate: releaseDate,
         startTime: startTime,
         endTime: endTime,
         genre: genre,
         posterUrl: posterUrl,
       );

  /// Returns a shallow copy of this [Film]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Film copyWith({
    Object? id = _Undefined,
    String? title,
    String? description,
    Object? duration = _Undefined,
    DateTime? releaseDate,
    DateTime? startTime,
    DateTime? endTime,
    String? genre,
    String? posterUrl,
  }) {
    return Film(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration is Duration? ? duration : this.duration,
      releaseDate: releaseDate ?? this.releaseDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      genre: genre ?? this.genre,
      posterUrl: posterUrl ?? this.posterUrl,
    );
  }
}

class FilmUpdateTable extends _i1.UpdateTable<FilmTable> {
  FilmUpdateTable(super.table);

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<Duration, Duration> duration(Duration? value) =>
      _i1.ColumnValue(
        table.duration,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> releaseDate(DateTime value) =>
      _i1.ColumnValue(
        table.releaseDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> startTime(DateTime value) =>
      _i1.ColumnValue(
        table.startTime,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endTime(DateTime value) =>
      _i1.ColumnValue(
        table.endTime,
        value,
      );

  _i1.ColumnValue<String, String> genre(String value) => _i1.ColumnValue(
    table.genre,
    value,
  );

  _i1.ColumnValue<String, String> posterUrl(String value) => _i1.ColumnValue(
    table.posterUrl,
    value,
  );
}

class FilmTable extends _i1.Table<int?> {
  FilmTable({super.tableRelation}) : super(tableName: 'films') {
    updateTable = FilmUpdateTable(this);
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    duration = _i1.ColumnDuration(
      'duration',
      this,
    );
    releaseDate = _i1.ColumnDateTime(
      'releaseDate',
      this,
    );
    startTime = _i1.ColumnDateTime(
      'startTime',
      this,
    );
    endTime = _i1.ColumnDateTime(
      'endTime',
      this,
    );
    genre = _i1.ColumnString(
      'genre',
      this,
    );
    posterUrl = _i1.ColumnString(
      'posterUrl',
      this,
    );
  }

  late final FilmUpdateTable updateTable;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnDuration duration;

  late final _i1.ColumnDateTime releaseDate;

  late final _i1.ColumnDateTime startTime;

  late final _i1.ColumnDateTime endTime;

  late final _i1.ColumnString genre;

  late final _i1.ColumnString posterUrl;

  @override
  List<_i1.Column> get columns => [
    id,
    title,
    description,
    duration,
    releaseDate,
    startTime,
    endTime,
    genre,
    posterUrl,
  ];
}

class FilmInclude extends _i1.IncludeObject {
  FilmInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Film.t;
}

class FilmIncludeList extends _i1.IncludeList {
  FilmIncludeList._({
    _i1.WhereExpressionBuilder<FilmTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Film.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Film.t;
}

class FilmRepository {
  const FilmRepository._();

  /// Returns a list of [Film]s matching the given query parameters.
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
  Future<List<Film>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FilmTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FilmTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FilmTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Film>(
      where: where?.call(Film.t),
      orderBy: orderBy?.call(Film.t),
      orderByList: orderByList?.call(Film.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Film] matching the given query parameters.
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
  Future<Film?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FilmTable>? where,
    int? offset,
    _i1.OrderByBuilder<FilmTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FilmTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Film>(
      where: where?.call(Film.t),
      orderBy: orderBy?.call(Film.t),
      orderByList: orderByList?.call(Film.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Film] by its [id] or null if no such row exists.
  Future<Film?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Film>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Film]s in the list and returns the inserted rows.
  ///
  /// The returned [Film]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Film>> insert(
    _i1.Session session,
    List<Film> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Film>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Film] and returns the inserted row.
  ///
  /// The returned [Film] will have its `id` field set.
  Future<Film> insertRow(
    _i1.Session session,
    Film row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Film>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Film]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Film>> update(
    _i1.Session session,
    List<Film> rows, {
    _i1.ColumnSelections<FilmTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Film>(
      rows,
      columns: columns?.call(Film.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Film]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Film> updateRow(
    _i1.Session session,
    Film row, {
    _i1.ColumnSelections<FilmTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Film>(
      row,
      columns: columns?.call(Film.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Film] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Film?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<FilmUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Film>(
      id,
      columnValues: columnValues(Film.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Film]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Film>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<FilmUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<FilmTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FilmTable>? orderBy,
    _i1.OrderByListBuilder<FilmTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Film>(
      columnValues: columnValues(Film.t.updateTable),
      where: where(Film.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Film.t),
      orderByList: orderByList?.call(Film.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Film]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Film>> delete(
    _i1.Session session,
    List<Film> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Film>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Film].
  Future<Film> deleteRow(
    _i1.Session session,
    Film row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Film>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Film>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FilmTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Film>(
      where: where(Film.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FilmTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Film>(
      where: where?.call(Film.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
