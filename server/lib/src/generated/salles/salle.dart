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
import 'package:cinema_reservation_server/src/generated/protocol.dart' as _i2;

abstract class Salle implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Salle._({
    this.id,
    required this.cinema_id,
    required this.code_salle,
    required this.capacite,
    this.equipements,
  });

  factory Salle({
    int? id,
    required int cinema_id,
    required String code_salle,
    required int capacite,
    List<String>? equipements,
  }) = _SalleImpl;

  factory Salle.fromJson(Map<String, dynamic> jsonSerialization) {
    return Salle(
      id: jsonSerialization['id'] as int?,
      cinema_id: jsonSerialization['cinema_id'] as int,
      code_salle: jsonSerialization['code_salle'] as String,
      capacite: jsonSerialization['capacite'] as int,
      equipements: jsonSerialization['equipements'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['equipements'],
            ),
    );
  }

  static final t = SalleTable();

  static const db = SalleRepository._();

  @override
  int? id;

  int cinema_id;

  String code_salle;

  int capacite;

  List<String>? equipements;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Salle]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Salle copyWith({
    int? id,
    int? cinema_id,
    String? code_salle,
    int? capacite,
    List<String>? equipements,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Salle',
      if (id != null) 'id': id,
      'cinema_id': cinema_id,
      'code_salle': code_salle,
      'capacite': capacite,
      if (equipements != null) 'equipements': equipements?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Salle',
      if (id != null) 'id': id,
      'cinema_id': cinema_id,
      'code_salle': code_salle,
      'capacite': capacite,
      if (equipements != null) 'equipements': equipements?.toJson(),
    };
  }

  static SalleInclude include() {
    return SalleInclude._();
  }

  static SalleIncludeList includeList({
    _i1.WhereExpressionBuilder<SalleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SalleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SalleTable>? orderByList,
    SalleInclude? include,
  }) {
    return SalleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Salle.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Salle.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SalleImpl extends Salle {
  _SalleImpl({
    int? id,
    required int cinema_id,
    required String code_salle,
    required int capacite,
    List<String>? equipements,
  }) : super._(
         id: id,
         cinema_id: cinema_id,
         code_salle: code_salle,
         capacite: capacite,
         equipements: equipements,
       );

  /// Returns a shallow copy of this [Salle]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Salle copyWith({
    Object? id = _Undefined,
    int? cinema_id,
    String? code_salle,
    int? capacite,
    Object? equipements = _Undefined,
  }) {
    return Salle(
      id: id is int? ? id : this.id,
      cinema_id: cinema_id ?? this.cinema_id,
      code_salle: code_salle ?? this.code_salle,
      capacite: capacite ?? this.capacite,
      equipements: equipements is List<String>?
          ? equipements
          : this.equipements?.map((e0) => e0).toList(),
    );
  }
}

class SalleUpdateTable extends _i1.UpdateTable<SalleTable> {
  SalleUpdateTable(super.table);

  _i1.ColumnValue<int, int> cinema_id(int value) => _i1.ColumnValue(
    table.cinema_id,
    value,
  );

  _i1.ColumnValue<String, String> code_salle(String value) => _i1.ColumnValue(
    table.code_salle,
    value,
  );

  _i1.ColumnValue<int, int> capacite(int value) => _i1.ColumnValue(
    table.capacite,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> equipements(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.equipements,
    value,
  );
}

class SalleTable extends _i1.Table<int?> {
  SalleTable({super.tableRelation}) : super(tableName: 'salles') {
    updateTable = SalleUpdateTable(this);
    cinema_id = _i1.ColumnInt(
      'cinema_id',
      this,
    );
    code_salle = _i1.ColumnString(
      'code_salle',
      this,
    );
    capacite = _i1.ColumnInt(
      'capacite',
      this,
    );
    equipements = _i1.ColumnSerializable<List<String>>(
      'equipements',
      this,
    );
  }

  late final SalleUpdateTable updateTable;

  late final _i1.ColumnInt cinema_id;

  late final _i1.ColumnString code_salle;

  late final _i1.ColumnInt capacite;

  late final _i1.ColumnSerializable<List<String>> equipements;

  @override
  List<_i1.Column> get columns => [
    id,
    cinema_id,
    code_salle,
    capacite,
    equipements,
  ];
}

class SalleInclude extends _i1.IncludeObject {
  SalleInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Salle.t;
}

class SalleIncludeList extends _i1.IncludeList {
  SalleIncludeList._({
    _i1.WhereExpressionBuilder<SalleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Salle.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Salle.t;
}

class SalleRepository {
  const SalleRepository._();

  /// Returns a list of [Salle]s matching the given query parameters.
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
  Future<List<Salle>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SalleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SalleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SalleTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Salle>(
      where: where?.call(Salle.t),
      orderBy: orderBy?.call(Salle.t),
      orderByList: orderByList?.call(Salle.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Salle] matching the given query parameters.
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
  Future<Salle?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SalleTable>? where,
    int? offset,
    _i1.OrderByBuilder<SalleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SalleTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Salle>(
      where: where?.call(Salle.t),
      orderBy: orderBy?.call(Salle.t),
      orderByList: orderByList?.call(Salle.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Salle] by its [id] or null if no such row exists.
  Future<Salle?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Salle>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Salle]s in the list and returns the inserted rows.
  ///
  /// The returned [Salle]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Salle>> insert(
    _i1.Session session,
    List<Salle> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Salle>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Salle] and returns the inserted row.
  ///
  /// The returned [Salle] will have its `id` field set.
  Future<Salle> insertRow(
    _i1.Session session,
    Salle row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Salle>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Salle]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Salle>> update(
    _i1.Session session,
    List<Salle> rows, {
    _i1.ColumnSelections<SalleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Salle>(
      rows,
      columns: columns?.call(Salle.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Salle]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Salle> updateRow(
    _i1.Session session,
    Salle row, {
    _i1.ColumnSelections<SalleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Salle>(
      row,
      columns: columns?.call(Salle.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Salle] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Salle?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SalleUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Salle>(
      id,
      columnValues: columnValues(Salle.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Salle]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Salle>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SalleUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SalleTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SalleTable>? orderBy,
    _i1.OrderByListBuilder<SalleTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Salle>(
      columnValues: columnValues(Salle.t.updateTable),
      where: where(Salle.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Salle.t),
      orderByList: orderByList?.call(Salle.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Salle]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Salle>> delete(
    _i1.Session session,
    List<Salle> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Salle>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Salle].
  Future<Salle> deleteRow(
    _i1.Session session,
    Salle row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Salle>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Salle>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SalleTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Salle>(
      where: where(Salle.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SalleTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Salle>(
      where: where?.call(Salle.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
