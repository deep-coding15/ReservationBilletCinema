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

abstract class Optionnel
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Optionnel._({
    this.id,
    required this.name,
    required this.stock,
    required this.price,
  });

  factory Optionnel({
    int? id,
    required String name,
    required int stock,
    required double price,
  }) = _OptionnelImpl;

  factory Optionnel.fromJson(Map<String, dynamic> jsonSerialization) {
    return Optionnel(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      stock: jsonSerialization['stock'] as int,
      price: (jsonSerialization['price'] as num).toDouble(),
    );
  }

  static final t = OptionnelTable();

  static const db = OptionnelRepository._();

  @override
  int? id;

  String name;

  int stock;

  double price;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Optionnel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Optionnel copyWith({
    int? id,
    String? name,
    int? stock,
    double? price,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Optionnel',
      if (id != null) 'id': id,
      'name': name,
      'stock': stock,
      'price': price,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Optionnel',
      if (id != null) 'id': id,
      'name': name,
      'stock': stock,
      'price': price,
    };
  }

  static OptionnelInclude include() {
    return OptionnelInclude._();
  }

  static OptionnelIncludeList includeList({
    _i1.WhereExpressionBuilder<OptionnelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OptionnelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OptionnelTable>? orderByList,
    OptionnelInclude? include,
  }) {
    return OptionnelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Optionnel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Optionnel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OptionnelImpl extends Optionnel {
  _OptionnelImpl({
    int? id,
    required String name,
    required int stock,
    required double price,
  }) : super._(
         id: id,
         name: name,
         stock: stock,
         price: price,
       );

  /// Returns a shallow copy of this [Optionnel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Optionnel copyWith({
    Object? id = _Undefined,
    String? name,
    int? stock,
    double? price,
  }) {
    return Optionnel(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      stock: stock ?? this.stock,
      price: price ?? this.price,
    );
  }
}

class OptionnelUpdateTable extends _i1.UpdateTable<OptionnelTable> {
  OptionnelUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<int, int> stock(int value) => _i1.ColumnValue(
    table.stock,
    value,
  );

  _i1.ColumnValue<double, double> price(double value) => _i1.ColumnValue(
    table.price,
    value,
  );
}

class OptionnelTable extends _i1.Table<int?> {
  OptionnelTable({super.tableRelation}) : super(tableName: 'optionnels') {
    updateTable = OptionnelUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    stock = _i1.ColumnInt(
      'stock',
      this,
    );
    price = _i1.ColumnDouble(
      'price',
      this,
    );
  }

  late final OptionnelUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnInt stock;

  late final _i1.ColumnDouble price;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    stock,
    price,
  ];
}

class OptionnelInclude extends _i1.IncludeObject {
  OptionnelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Optionnel.t;
}

class OptionnelIncludeList extends _i1.IncludeList {
  OptionnelIncludeList._({
    _i1.WhereExpressionBuilder<OptionnelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Optionnel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Optionnel.t;
}

class OptionnelRepository {
  const OptionnelRepository._();

  /// Returns a list of [Optionnel]s matching the given query parameters.
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
  Future<List<Optionnel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OptionnelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OptionnelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OptionnelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Optionnel>(
      where: where?.call(Optionnel.t),
      orderBy: orderBy?.call(Optionnel.t),
      orderByList: orderByList?.call(Optionnel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Optionnel] matching the given query parameters.
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
  Future<Optionnel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OptionnelTable>? where,
    int? offset,
    _i1.OrderByBuilder<OptionnelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OptionnelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Optionnel>(
      where: where?.call(Optionnel.t),
      orderBy: orderBy?.call(Optionnel.t),
      orderByList: orderByList?.call(Optionnel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Optionnel] by its [id] or null if no such row exists.
  Future<Optionnel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Optionnel>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Optionnel]s in the list and returns the inserted rows.
  ///
  /// The returned [Optionnel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Optionnel>> insert(
    _i1.Session session,
    List<Optionnel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Optionnel>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Optionnel] and returns the inserted row.
  ///
  /// The returned [Optionnel] will have its `id` field set.
  Future<Optionnel> insertRow(
    _i1.Session session,
    Optionnel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Optionnel>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Optionnel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Optionnel>> update(
    _i1.Session session,
    List<Optionnel> rows, {
    _i1.ColumnSelections<OptionnelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Optionnel>(
      rows,
      columns: columns?.call(Optionnel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Optionnel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Optionnel> updateRow(
    _i1.Session session,
    Optionnel row, {
    _i1.ColumnSelections<OptionnelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Optionnel>(
      row,
      columns: columns?.call(Optionnel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Optionnel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Optionnel?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<OptionnelUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Optionnel>(
      id,
      columnValues: columnValues(Optionnel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Optionnel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Optionnel>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<OptionnelUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<OptionnelTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OptionnelTable>? orderBy,
    _i1.OrderByListBuilder<OptionnelTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Optionnel>(
      columnValues: columnValues(Optionnel.t.updateTable),
      where: where(Optionnel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Optionnel.t),
      orderByList: orderByList?.call(Optionnel.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Optionnel]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Optionnel>> delete(
    _i1.Session session,
    List<Optionnel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Optionnel>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Optionnel].
  Future<Optionnel> deleteRow(
    _i1.Session session,
    Optionnel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Optionnel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Optionnel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<OptionnelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Optionnel>(
      where: where(Optionnel.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OptionnelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Optionnel>(
      where: where?.call(Optionnel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
