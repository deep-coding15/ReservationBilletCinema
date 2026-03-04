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

abstract class OptionnelReservation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  OptionnelReservation._({
    this.id,
    required this.reservationId,
    required this.optionnelId,
    required this.number,
    required this.dateAjout,
  }) : _billetsProduitsoptionnelBilletsId = null,
       _reservationsProduitsoptionnelsReservationsId = null;

  factory OptionnelReservation({
    int? id,
    required int reservationId,
    required int optionnelId,
    required int number,
    required DateTime dateAjout,
  }) = _OptionnelReservationImpl;

  factory OptionnelReservation.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return OptionnelReservationImplicit._(
      id: jsonSerialization['id'] as int?,
      reservationId: jsonSerialization['reservationId'] as int,
      optionnelId: jsonSerialization['optionnelId'] as int,
      number: jsonSerialization['number'] as int,
      dateAjout: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateAjout'],
      ),
      $_billetsProduitsoptionnelBilletsId:
          jsonSerialization['_billetsProduitsoptionnelBilletsId'] as int?,
      $_reservationsProduitsoptionnelsReservationsId:
          jsonSerialization['_reservationsProduitsoptionnelsReservationsId']
              as int?,
    );
  }

  static final t = OptionnelReservationTable();

  static const db = OptionnelReservationRepository._();

  @override
  int? id;

  int reservationId;

  int optionnelId;

  int number;

  DateTime dateAjout;

  final int? _billetsProduitsoptionnelBilletsId;

  final int? _reservationsProduitsoptionnelsReservationsId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [OptionnelReservation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OptionnelReservation copyWith({
    int? id,
    int? reservationId,
    int? optionnelId,
    int? number,
    DateTime? dateAjout,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OptionnelReservation',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      'optionnelId': optionnelId,
      'number': number,
      'dateAjout': dateAjout.toJson(),
      if (_billetsProduitsoptionnelBilletsId != null)
        '_billetsProduitsoptionnelBilletsId':
            _billetsProduitsoptionnelBilletsId,
      if (_reservationsProduitsoptionnelsReservationsId != null)
        '_reservationsProduitsoptionnelsReservationsId':
            _reservationsProduitsoptionnelsReservationsId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OptionnelReservation',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      'optionnelId': optionnelId,
      'number': number,
      'dateAjout': dateAjout.toJson(),
    };
  }

  static OptionnelReservationInclude include() {
    return OptionnelReservationInclude._();
  }

  static OptionnelReservationIncludeList includeList({
    _i1.WhereExpressionBuilder<OptionnelReservationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OptionnelReservationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OptionnelReservationTable>? orderByList,
    OptionnelReservationInclude? include,
  }) {
    return OptionnelReservationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OptionnelReservation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OptionnelReservation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OptionnelReservationImpl extends OptionnelReservation {
  _OptionnelReservationImpl({
    int? id,
    required int reservationId,
    required int optionnelId,
    required int number,
    required DateTime dateAjout,
  }) : super._(
         id: id,
         reservationId: reservationId,
         optionnelId: optionnelId,
         number: number,
         dateAjout: dateAjout,
       );

  /// Returns a shallow copy of this [OptionnelReservation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OptionnelReservation copyWith({
    Object? id = _Undefined,
    int? reservationId,
    int? optionnelId,
    int? number,
    DateTime? dateAjout,
  }) {
    return OptionnelReservationImplicit._(
      id: id is int? ? id : this.id,
      reservationId: reservationId ?? this.reservationId,
      optionnelId: optionnelId ?? this.optionnelId,
      number: number ?? this.number,
      dateAjout: dateAjout ?? this.dateAjout,
      $_billetsProduitsoptionnelBilletsId:
          this._billetsProduitsoptionnelBilletsId,
      $_reservationsProduitsoptionnelsReservationsId:
          this._reservationsProduitsoptionnelsReservationsId,
    );
  }
}

class OptionnelReservationImplicit extends _OptionnelReservationImpl {
  OptionnelReservationImplicit._({
    int? id,
    required int reservationId,
    required int optionnelId,
    required int number,
    required DateTime dateAjout,
    int? $_billetsProduitsoptionnelBilletsId,
    int? $_reservationsProduitsoptionnelsReservationsId,
  }) : _billetsProduitsoptionnelBilletsId = $_billetsProduitsoptionnelBilletsId,
       _reservationsProduitsoptionnelsReservationsId =
           $_reservationsProduitsoptionnelsReservationsId,
       super(
         id: id,
         reservationId: reservationId,
         optionnelId: optionnelId,
         number: number,
         dateAjout: dateAjout,
       );

  factory OptionnelReservationImplicit(
    OptionnelReservation optionnelReservation, {
    int? $_billetsProduitsoptionnelBilletsId,
    int? $_reservationsProduitsoptionnelsReservationsId,
  }) {
    return OptionnelReservationImplicit._(
      id: optionnelReservation.id,
      reservationId: optionnelReservation.reservationId,
      optionnelId: optionnelReservation.optionnelId,
      number: optionnelReservation.number,
      dateAjout: optionnelReservation.dateAjout,
      $_billetsProduitsoptionnelBilletsId: $_billetsProduitsoptionnelBilletsId,
      $_reservationsProduitsoptionnelsReservationsId:
          $_reservationsProduitsoptionnelsReservationsId,
    );
  }

  @override
  final int? _billetsProduitsoptionnelBilletsId;

  @override
  final int? _reservationsProduitsoptionnelsReservationsId;
}

class OptionnelReservationUpdateTable
    extends _i1.UpdateTable<OptionnelReservationTable> {
  OptionnelReservationUpdateTable(super.table);

  _i1.ColumnValue<int, int> reservationId(int value) => _i1.ColumnValue(
    table.reservationId,
    value,
  );

  _i1.ColumnValue<int, int> optionnelId(int value) => _i1.ColumnValue(
    table.optionnelId,
    value,
  );

  _i1.ColumnValue<int, int> number(int value) => _i1.ColumnValue(
    table.number,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dateAjout(DateTime value) =>
      _i1.ColumnValue(
        table.dateAjout,
        value,
      );

  _i1.ColumnValue<int, int> $_billetsProduitsoptionnelBilletsId(int? value) =>
      _i1.ColumnValue(
        table.$_billetsProduitsoptionnelBilletsId,
        value,
      );

  _i1.ColumnValue<int, int> $_reservationsProduitsoptionnelsReservationsId(
    int? value,
  ) => _i1.ColumnValue(
    table.$_reservationsProduitsoptionnelsReservationsId,
    value,
  );
}

class OptionnelReservationTable extends _i1.Table<int?> {
  OptionnelReservationTable({super.tableRelation})
    : super(tableName: 'optionnel_reservation') {
    updateTable = OptionnelReservationUpdateTable(this);
    reservationId = _i1.ColumnInt(
      'reservationId',
      this,
    );
    optionnelId = _i1.ColumnInt(
      'optionnelId',
      this,
    );
    number = _i1.ColumnInt(
      'number',
      this,
    );
    dateAjout = _i1.ColumnDateTime(
      'dateAjout',
      this,
    );
    $_billetsProduitsoptionnelBilletsId = _i1.ColumnInt(
      '_billetsProduitsoptionnelBilletsId',
      this,
    );
    $_reservationsProduitsoptionnelsReservationsId = _i1.ColumnInt(
      '_reservationsProduitsoptionnelsReservationsId',
      this,
    );
  }

  late final OptionnelReservationUpdateTable updateTable;

  late final _i1.ColumnInt reservationId;

  late final _i1.ColumnInt optionnelId;

  late final _i1.ColumnInt number;

  late final _i1.ColumnDateTime dateAjout;

  late final _i1.ColumnInt $_billetsProduitsoptionnelBilletsId;

  late final _i1.ColumnInt $_reservationsProduitsoptionnelsReservationsId;

  @override
  List<_i1.Column> get columns => [
    id,
    reservationId,
    optionnelId,
    number,
    dateAjout,
    $_billetsProduitsoptionnelBilletsId,
    $_reservationsProduitsoptionnelsReservationsId,
  ];

  @override
  List<_i1.Column> get managedColumns => [
    id,
    reservationId,
    optionnelId,
    number,
    dateAjout,
  ];
}

class OptionnelReservationInclude extends _i1.IncludeObject {
  OptionnelReservationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => OptionnelReservation.t;
}

class OptionnelReservationIncludeList extends _i1.IncludeList {
  OptionnelReservationIncludeList._({
    _i1.WhereExpressionBuilder<OptionnelReservationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OptionnelReservation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => OptionnelReservation.t;
}

class OptionnelReservationRepository {
  const OptionnelReservationRepository._();

  /// Returns a list of [OptionnelReservation]s matching the given query parameters.
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
  Future<List<OptionnelReservation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OptionnelReservationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OptionnelReservationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OptionnelReservationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<OptionnelReservation>(
      where: where?.call(OptionnelReservation.t),
      orderBy: orderBy?.call(OptionnelReservation.t),
      orderByList: orderByList?.call(OptionnelReservation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [OptionnelReservation] matching the given query parameters.
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
  Future<OptionnelReservation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OptionnelReservationTable>? where,
    int? offset,
    _i1.OrderByBuilder<OptionnelReservationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OptionnelReservationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<OptionnelReservation>(
      where: where?.call(OptionnelReservation.t),
      orderBy: orderBy?.call(OptionnelReservation.t),
      orderByList: orderByList?.call(OptionnelReservation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [OptionnelReservation] by its [id] or null if no such row exists.
  Future<OptionnelReservation?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<OptionnelReservation>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [OptionnelReservation]s in the list and returns the inserted rows.
  ///
  /// The returned [OptionnelReservation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<OptionnelReservation>> insert(
    _i1.Session session,
    List<OptionnelReservation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<OptionnelReservation>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [OptionnelReservation] and returns the inserted row.
  ///
  /// The returned [OptionnelReservation] will have its `id` field set.
  Future<OptionnelReservation> insertRow(
    _i1.Session session,
    OptionnelReservation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OptionnelReservation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OptionnelReservation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OptionnelReservation>> update(
    _i1.Session session,
    List<OptionnelReservation> rows, {
    _i1.ColumnSelections<OptionnelReservationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OptionnelReservation>(
      rows,
      columns: columns?.call(OptionnelReservation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OptionnelReservation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OptionnelReservation> updateRow(
    _i1.Session session,
    OptionnelReservation row, {
    _i1.ColumnSelections<OptionnelReservationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OptionnelReservation>(
      row,
      columns: columns?.call(OptionnelReservation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OptionnelReservation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OptionnelReservation?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<OptionnelReservationUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OptionnelReservation>(
      id,
      columnValues: columnValues(OptionnelReservation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OptionnelReservation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OptionnelReservation>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<OptionnelReservationUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<OptionnelReservationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OptionnelReservationTable>? orderBy,
    _i1.OrderByListBuilder<OptionnelReservationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OptionnelReservation>(
      columnValues: columnValues(OptionnelReservation.t.updateTable),
      where: where(OptionnelReservation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OptionnelReservation.t),
      orderByList: orderByList?.call(OptionnelReservation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OptionnelReservation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OptionnelReservation>> delete(
    _i1.Session session,
    List<OptionnelReservation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OptionnelReservation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OptionnelReservation].
  Future<OptionnelReservation> deleteRow(
    _i1.Session session,
    OptionnelReservation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OptionnelReservation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OptionnelReservation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<OptionnelReservationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OptionnelReservation>(
      where: where(OptionnelReservation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OptionnelReservationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OptionnelReservation>(
      where: where?.call(OptionnelReservation.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
