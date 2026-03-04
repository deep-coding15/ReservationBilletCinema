/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'seance.dart' as _i2;
import 'reservation_siege.dart' as _i3;
import 'optionnel_reservation.dart' as _i4;
import 'reservation_statut.dart' as _i5;
import 'package:cinema_reservation_server/src/generated/protocol.dart' as _i6;

abstract class Reservation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Reservation._({
    this.id,
    required this.userId,
    required this.seanceId,
    this.seance,
    this.reservationSieges,
    this.produitsOptionnels,
    required this.dateReservation,
    required this.montantTotal,
    required this.statut,
    this.codePromo,
  });

  factory Reservation({
    int? id,
    required int userId,
    required int seanceId,
    _i2.Seance? seance,
    List<_i3.ReservationSiege>? reservationSieges,
    List<_i4.OptionnelReservation>? produitsOptionnels,
    required DateTime dateReservation,
    required double montantTotal,
    required _i5.ReservationStatut statut,
    String? codePromo,
  }) = _ReservationImpl;

  factory Reservation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reservation(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      seanceId: jsonSerialization['seanceId'] as int,
      seance: jsonSerialization['seance'] == null
          ? null
          : _i6.Protocol().deserialize<_i2.Seance>(jsonSerialization['seance']),
      reservationSieges: jsonSerialization['reservationSieges'] == null
          ? null
          : _i6.Protocol().deserialize<List<_i3.ReservationSiege>>(
              jsonSerialization['reservationSieges'],
            ),
      produitsOptionnels: jsonSerialization['produitsOptionnels'] == null
          ? null
          : _i6.Protocol().deserialize<List<_i4.OptionnelReservation>>(
              jsonSerialization['produitsOptionnels'],
            ),
      dateReservation: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateReservation'],
      ),
      montantTotal: (jsonSerialization['montantTotal'] as num).toDouble(),
      statut: _i5.ReservationStatut.fromJson(
        (jsonSerialization['statut'] as String),
      ),
      codePromo: jsonSerialization['codePromo'] as String?,
    );
  }

  static final t = ReservationTable();

  static const db = ReservationRepository._();

  @override
  int? id;

  int userId;

  int seanceId;

  _i2.Seance? seance;

  List<_i3.ReservationSiege>? reservationSieges;

  List<_i4.OptionnelReservation>? produitsOptionnels;

  DateTime dateReservation;

  double montantTotal;

  _i5.ReservationStatut statut;

  String? codePromo;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Reservation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Reservation copyWith({
    int? id,
    int? userId,
    int? seanceId,
    _i2.Seance? seance,
    List<_i3.ReservationSiege>? reservationSieges,
    List<_i4.OptionnelReservation>? produitsOptionnels,
    DateTime? dateReservation,
    double? montantTotal,
    _i5.ReservationStatut? statut,
    String? codePromo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reservation',
      if (id != null) 'id': id,
      'userId': userId,
      'seanceId': seanceId,
      if (seance != null) 'seance': seance?.toJson(),
      if (reservationSieges != null)
        'reservationSieges': reservationSieges?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (produitsOptionnels != null)
        'produitsOptionnels': produitsOptionnels?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'dateReservation': dateReservation.toJson(),
      'montantTotal': montantTotal,
      'statut': statut.toJson(),
      if (codePromo != null) 'codePromo': codePromo,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Reservation',
      if (id != null) 'id': id,
      'userId': userId,
      'seanceId': seanceId,
      if (seance != null) 'seance': seance?.toJsonForProtocol(),
      if (reservationSieges != null)
        'reservationSieges': reservationSieges?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (produitsOptionnels != null)
        'produitsOptionnels': produitsOptionnels?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'dateReservation': dateReservation.toJson(),
      'montantTotal': montantTotal,
      'statut': statut.toJson(),
      if (codePromo != null) 'codePromo': codePromo,
    };
  }

  static ReservationInclude include({
    _i2.SeanceInclude? seance,
    _i3.ReservationSiegeIncludeList? reservationSieges,
    _i4.OptionnelReservationIncludeList? produitsOptionnels,
  }) {
    return ReservationInclude._(
      seance: seance,
      reservationSieges: reservationSieges,
      produitsOptionnels: produitsOptionnels,
    );
  }

  static ReservationIncludeList includeList({
    _i1.WhereExpressionBuilder<ReservationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationTable>? orderByList,
    ReservationInclude? include,
  }) {
    return ReservationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reservation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Reservation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReservationImpl extends Reservation {
  _ReservationImpl({
    int? id,
    required int userId,
    required int seanceId,
    _i2.Seance? seance,
    List<_i3.ReservationSiege>? reservationSieges,
    List<_i4.OptionnelReservation>? produitsOptionnels,
    required DateTime dateReservation,
    required double montantTotal,
    required _i5.ReservationStatut statut,
    String? codePromo,
  }) : super._(
         id: id,
         userId: userId,
         seanceId: seanceId,
         seance: seance,
         reservationSieges: reservationSieges,
         produitsOptionnels: produitsOptionnels,
         dateReservation: dateReservation,
         montantTotal: montantTotal,
         statut: statut,
         codePromo: codePromo,
       );

  /// Returns a shallow copy of this [Reservation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Reservation copyWith({
    Object? id = _Undefined,
    int? userId,
    int? seanceId,
    Object? seance = _Undefined,
    Object? reservationSieges = _Undefined,
    Object? produitsOptionnels = _Undefined,
    DateTime? dateReservation,
    double? montantTotal,
    _i5.ReservationStatut? statut,
    Object? codePromo = _Undefined,
  }) {
    return Reservation(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      seanceId: seanceId ?? this.seanceId,
      seance: seance is _i2.Seance? ? seance : this.seance?.copyWith(),
      reservationSieges: reservationSieges is List<_i3.ReservationSiege>?
          ? reservationSieges
          : this.reservationSieges?.map((e0) => e0.copyWith()).toList(),
      produitsOptionnels: produitsOptionnels is List<_i4.OptionnelReservation>?
          ? produitsOptionnels
          : this.produitsOptionnels?.map((e0) => e0.copyWith()).toList(),
      dateReservation: dateReservation ?? this.dateReservation,
      montantTotal: montantTotal ?? this.montantTotal,
      statut: statut ?? this.statut,
      codePromo: codePromo is String? ? codePromo : this.codePromo,
    );
  }
}

class ReservationUpdateTable extends _i1.UpdateTable<ReservationTable> {
  ReservationUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> seanceId(int value) => _i1.ColumnValue(
    table.seanceId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dateReservation(DateTime value) =>
      _i1.ColumnValue(
        table.dateReservation,
        value,
      );

  _i1.ColumnValue<double, double> montantTotal(double value) => _i1.ColumnValue(
    table.montantTotal,
    value,
  );

  _i1.ColumnValue<_i5.ReservationStatut, _i5.ReservationStatut> statut(
    _i5.ReservationStatut value,
  ) => _i1.ColumnValue(
    table.statut,
    value,
  );

  _i1.ColumnValue<String, String> codePromo(String? value) => _i1.ColumnValue(
    table.codePromo,
    value,
  );
}

class ReservationTable extends _i1.Table<int?> {
  ReservationTable({super.tableRelation}) : super(tableName: 'reservations') {
    updateTable = ReservationUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    seanceId = _i1.ColumnInt(
      'seanceId',
      this,
    );
    dateReservation = _i1.ColumnDateTime(
      'dateReservation',
      this,
    );
    montantTotal = _i1.ColumnDouble(
      'montantTotal',
      this,
    );
    statut = _i1.ColumnEnum(
      'statut',
      this,
      _i1.EnumSerialization.byName,
    );
    codePromo = _i1.ColumnString(
      'codePromo',
      this,
    );
  }

  late final ReservationUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnInt seanceId;

  _i2.SeanceTable? _seance;

  _i3.ReservationSiegeTable? ___reservationSieges;

  _i1.ManyRelation<_i3.ReservationSiegeTable>? _reservationSieges;

  _i4.OptionnelReservationTable? ___produitsOptionnels;

  _i1.ManyRelation<_i4.OptionnelReservationTable>? _produitsOptionnels;

  late final _i1.ColumnDateTime dateReservation;

  late final _i1.ColumnDouble montantTotal;

  late final _i1.ColumnEnum<_i5.ReservationStatut> statut;

  late final _i1.ColumnString codePromo;

  _i2.SeanceTable get seance {
    if (_seance != null) return _seance!;
    _seance = _i1.createRelationTable(
      relationFieldName: 'seance',
      field: Reservation.t.seanceId,
      foreignField: _i2.Seance.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.SeanceTable(tableRelation: foreignTableRelation),
    );
    return _seance!;
  }

  _i3.ReservationSiegeTable get __reservationSieges {
    if (___reservationSieges != null) return ___reservationSieges!;
    ___reservationSieges = _i1.createRelationTable(
      relationFieldName: '__reservationSieges',
      field: Reservation.t.id,
      foreignField:
          _i3.ReservationSiege.t.$_reservationsReservationsiegesReservationsId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ReservationSiegeTable(tableRelation: foreignTableRelation),
    );
    return ___reservationSieges!;
  }

  _i4.OptionnelReservationTable get __produitsOptionnels {
    if (___produitsOptionnels != null) return ___produitsOptionnels!;
    ___produitsOptionnels = _i1.createRelationTable(
      relationFieldName: '__produitsOptionnels',
      field: Reservation.t.id,
      foreignField: _i4
          .OptionnelReservation
          .t
          .$_reservationsProduitsoptionnelsReservationsId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.OptionnelReservationTable(tableRelation: foreignTableRelation),
    );
    return ___produitsOptionnels!;
  }

  _i1.ManyRelation<_i3.ReservationSiegeTable> get reservationSieges {
    if (_reservationSieges != null) return _reservationSieges!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'reservationSieges',
      field: Reservation.t.id,
      foreignField:
          _i3.ReservationSiege.t.$_reservationsReservationsiegesReservationsId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ReservationSiegeTable(tableRelation: foreignTableRelation),
    );
    _reservationSieges = _i1.ManyRelation<_i3.ReservationSiegeTable>(
      tableWithRelations: relationTable,
      table: _i3.ReservationSiegeTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _reservationSieges!;
  }

  _i1.ManyRelation<_i4.OptionnelReservationTable> get produitsOptionnels {
    if (_produitsOptionnels != null) return _produitsOptionnels!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'produitsOptionnels',
      field: Reservation.t.id,
      foreignField: _i4
          .OptionnelReservation
          .t
          .$_reservationsProduitsoptionnelsReservationsId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.OptionnelReservationTable(tableRelation: foreignTableRelation),
    );
    _produitsOptionnels = _i1.ManyRelation<_i4.OptionnelReservationTable>(
      tableWithRelations: relationTable,
      table: _i4.OptionnelReservationTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _produitsOptionnels!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    seanceId,
    dateReservation,
    montantTotal,
    statut,
    codePromo,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'seance') {
      return seance;
    }
    if (relationField == 'reservationSieges') {
      return __reservationSieges;
    }
    if (relationField == 'produitsOptionnels') {
      return __produitsOptionnels;
    }
    return null;
  }
}

class ReservationInclude extends _i1.IncludeObject {
  ReservationInclude._({
    _i2.SeanceInclude? seance,
    _i3.ReservationSiegeIncludeList? reservationSieges,
    _i4.OptionnelReservationIncludeList? produitsOptionnels,
  }) {
    _seance = seance;
    _reservationSieges = reservationSieges;
    _produitsOptionnels = produitsOptionnels;
  }

  _i2.SeanceInclude? _seance;

  _i3.ReservationSiegeIncludeList? _reservationSieges;

  _i4.OptionnelReservationIncludeList? _produitsOptionnels;

  @override
  Map<String, _i1.Include?> get includes => {
    'seance': _seance,
    'reservationSieges': _reservationSieges,
    'produitsOptionnels': _produitsOptionnels,
  };

  @override
  _i1.Table<int?> get table => Reservation.t;
}

class ReservationIncludeList extends _i1.IncludeList {
  ReservationIncludeList._({
    _i1.WhereExpressionBuilder<ReservationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Reservation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Reservation.t;
}

class ReservationRepository {
  const ReservationRepository._();

  final attach = const ReservationAttachRepository._();

  final attachRow = const ReservationAttachRowRepository._();

  final detach = const ReservationDetachRepository._();

  final detachRow = const ReservationDetachRowRepository._();

  /// Returns a list of [Reservation]s matching the given query parameters.
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
  Future<List<Reservation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReservationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationTable>? orderByList,
    _i1.Transaction? transaction,
    ReservationInclude? include,
  }) async {
    return session.db.find<Reservation>(
      where: where?.call(Reservation.t),
      orderBy: orderBy?.call(Reservation.t),
      orderByList: orderByList?.call(Reservation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Reservation] matching the given query parameters.
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
  Future<Reservation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReservationTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReservationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationTable>? orderByList,
    _i1.Transaction? transaction,
    ReservationInclude? include,
  }) async {
    return session.db.findFirstRow<Reservation>(
      where: where?.call(Reservation.t),
      orderBy: orderBy?.call(Reservation.t),
      orderByList: orderByList?.call(Reservation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Reservation] by its [id] or null if no such row exists.
  Future<Reservation?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ReservationInclude? include,
  }) async {
    return session.db.findById<Reservation>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Reservation]s in the list and returns the inserted rows.
  ///
  /// The returned [Reservation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Reservation>> insert(
    _i1.Session session,
    List<Reservation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Reservation>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Reservation] and returns the inserted row.
  ///
  /// The returned [Reservation] will have its `id` field set.
  Future<Reservation> insertRow(
    _i1.Session session,
    Reservation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Reservation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Reservation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Reservation>> update(
    _i1.Session session,
    List<Reservation> rows, {
    _i1.ColumnSelections<ReservationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Reservation>(
      rows,
      columns: columns?.call(Reservation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Reservation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Reservation> updateRow(
    _i1.Session session,
    Reservation row, {
    _i1.ColumnSelections<ReservationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Reservation>(
      row,
      columns: columns?.call(Reservation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Reservation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Reservation?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ReservationUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Reservation>(
      id,
      columnValues: columnValues(Reservation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Reservation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Reservation>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ReservationUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ReservationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationTable>? orderBy,
    _i1.OrderByListBuilder<ReservationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Reservation>(
      columnValues: columnValues(Reservation.t.updateTable),
      where: where(Reservation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reservation.t),
      orderByList: orderByList?.call(Reservation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Reservation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Reservation>> delete(
    _i1.Session session,
    List<Reservation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Reservation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Reservation].
  Future<Reservation> deleteRow(
    _i1.Session session,
    Reservation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Reservation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Reservation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ReservationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Reservation>(
      where: where(Reservation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReservationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Reservation>(
      where: where?.call(Reservation.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ReservationAttachRepository {
  const ReservationAttachRepository._();

  /// Creates a relation between this [Reservation] and the given [ReservationSiege]s
  /// by setting each [ReservationSiege]'s foreign key `_reservationsReservationsiegesReservationsId` to refer to this [Reservation].
  Future<void> reservationSieges(
    _i1.Session session,
    Reservation reservation,
    List<_i3.ReservationSiege> reservationSiege, {
    _i1.Transaction? transaction,
  }) async {
    if (reservationSiege.any((e) => e.id == null)) {
      throw ArgumentError.notNull('reservationSiege.id');
    }
    if (reservation.id == null) {
      throw ArgumentError.notNull('reservation.id');
    }

    var $reservationSiege = reservationSiege
        .map(
          (e) => _i3.ReservationSiegeImplicit(
            e,
            $_reservationsReservationsiegesReservationsId: reservation.id,
          ),
        )
        .toList();
    await session.db.update<_i3.ReservationSiege>(
      $reservationSiege,
      columns: [
        _i3.ReservationSiege.t.$_reservationsReservationsiegesReservationsId,
      ],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Reservation] and the given [OptionnelReservation]s
  /// by setting each [OptionnelReservation]'s foreign key `_reservationsProduitsoptionnelsReservationsId` to refer to this [Reservation].
  Future<void> produitsOptionnels(
    _i1.Session session,
    Reservation reservation,
    List<_i4.OptionnelReservation> optionnelReservation, {
    _i1.Transaction? transaction,
  }) async {
    if (optionnelReservation.any((e) => e.id == null)) {
      throw ArgumentError.notNull('optionnelReservation.id');
    }
    if (reservation.id == null) {
      throw ArgumentError.notNull('reservation.id');
    }

    var $optionnelReservation = optionnelReservation
        .map(
          (e) => _i4.OptionnelReservationImplicit(
            e,
            $_reservationsProduitsoptionnelsReservationsId: reservation.id,
          ),
        )
        .toList();
    await session.db.update<_i4.OptionnelReservation>(
      $optionnelReservation,
      columns: [
        _i4
            .OptionnelReservation
            .t
            .$_reservationsProduitsoptionnelsReservationsId,
      ],
      transaction: transaction,
    );
  }
}

class ReservationAttachRowRepository {
  const ReservationAttachRowRepository._();

  /// Creates a relation between the given [Reservation] and [Seance]
  /// by setting the [Reservation]'s foreign key `seanceId` to refer to the [Seance].
  Future<void> seance(
    _i1.Session session,
    Reservation reservation,
    _i2.Seance seance, {
    _i1.Transaction? transaction,
  }) async {
    if (reservation.id == null) {
      throw ArgumentError.notNull('reservation.id');
    }
    if (seance.id == null) {
      throw ArgumentError.notNull('seance.id');
    }

    var $reservation = reservation.copyWith(seanceId: seance.id);
    await session.db.updateRow<Reservation>(
      $reservation,
      columns: [Reservation.t.seanceId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Reservation] and the given [ReservationSiege]
  /// by setting the [ReservationSiege]'s foreign key `_reservationsReservationsiegesReservationsId` to refer to this [Reservation].
  Future<void> reservationSieges(
    _i1.Session session,
    Reservation reservation,
    _i3.ReservationSiege reservationSiege, {
    _i1.Transaction? transaction,
  }) async {
    if (reservationSiege.id == null) {
      throw ArgumentError.notNull('reservationSiege.id');
    }
    if (reservation.id == null) {
      throw ArgumentError.notNull('reservation.id');
    }

    var $reservationSiege = _i3.ReservationSiegeImplicit(
      reservationSiege,
      $_reservationsReservationsiegesReservationsId: reservation.id,
    );
    await session.db.updateRow<_i3.ReservationSiege>(
      $reservationSiege,
      columns: [
        _i3.ReservationSiege.t.$_reservationsReservationsiegesReservationsId,
      ],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Reservation] and the given [OptionnelReservation]
  /// by setting the [OptionnelReservation]'s foreign key `_reservationsProduitsoptionnelsReservationsId` to refer to this [Reservation].
  Future<void> produitsOptionnels(
    _i1.Session session,
    Reservation reservation,
    _i4.OptionnelReservation optionnelReservation, {
    _i1.Transaction? transaction,
  }) async {
    if (optionnelReservation.id == null) {
      throw ArgumentError.notNull('optionnelReservation.id');
    }
    if (reservation.id == null) {
      throw ArgumentError.notNull('reservation.id');
    }

    var $optionnelReservation = _i4.OptionnelReservationImplicit(
      optionnelReservation,
      $_reservationsProduitsoptionnelsReservationsId: reservation.id,
    );
    await session.db.updateRow<_i4.OptionnelReservation>(
      $optionnelReservation,
      columns: [
        _i4
            .OptionnelReservation
            .t
            .$_reservationsProduitsoptionnelsReservationsId,
      ],
      transaction: transaction,
    );
  }
}

class ReservationDetachRepository {
  const ReservationDetachRepository._();

  /// Detaches the relation between this [Reservation] and the given [ReservationSiege]
  /// by setting the [ReservationSiege]'s foreign key `_reservationsReservationsiegesReservationsId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> reservationSieges(
    _i1.Session session,
    List<_i3.ReservationSiege> reservationSiege, {
    _i1.Transaction? transaction,
  }) async {
    if (reservationSiege.any((e) => e.id == null)) {
      throw ArgumentError.notNull('reservationSiege.id');
    }

    var $reservationSiege = reservationSiege
        .map(
          (e) => _i3.ReservationSiegeImplicit(
            e,
            $_reservationsReservationsiegesReservationsId: null,
          ),
        )
        .toList();
    await session.db.update<_i3.ReservationSiege>(
      $reservationSiege,
      columns: [
        _i3.ReservationSiege.t.$_reservationsReservationsiegesReservationsId,
      ],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Reservation] and the given [OptionnelReservation]
  /// by setting the [OptionnelReservation]'s foreign key `_reservationsProduitsoptionnelsReservationsId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> produitsOptionnels(
    _i1.Session session,
    List<_i4.OptionnelReservation> optionnelReservation, {
    _i1.Transaction? transaction,
  }) async {
    if (optionnelReservation.any((e) => e.id == null)) {
      throw ArgumentError.notNull('optionnelReservation.id');
    }

    var $optionnelReservation = optionnelReservation
        .map(
          (e) => _i4.OptionnelReservationImplicit(
            e,
            $_reservationsProduitsoptionnelsReservationsId: null,
          ),
        )
        .toList();
    await session.db.update<_i4.OptionnelReservation>(
      $optionnelReservation,
      columns: [
        _i4
            .OptionnelReservation
            .t
            .$_reservationsProduitsoptionnelsReservationsId,
      ],
      transaction: transaction,
    );
  }
}

class ReservationDetachRowRepository {
  const ReservationDetachRowRepository._();

  /// Detaches the relation between this [Reservation] and the given [ReservationSiege]
  /// by setting the [ReservationSiege]'s foreign key `_reservationsReservationsiegesReservationsId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> reservationSieges(
    _i1.Session session,
    _i3.ReservationSiege reservationSiege, {
    _i1.Transaction? transaction,
  }) async {
    if (reservationSiege.id == null) {
      throw ArgumentError.notNull('reservationSiege.id');
    }

    var $reservationSiege = _i3.ReservationSiegeImplicit(
      reservationSiege,
      $_reservationsReservationsiegesReservationsId: null,
    );
    await session.db.updateRow<_i3.ReservationSiege>(
      $reservationSiege,
      columns: [
        _i3.ReservationSiege.t.$_reservationsReservationsiegesReservationsId,
      ],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Reservation] and the given [OptionnelReservation]
  /// by setting the [OptionnelReservation]'s foreign key `_reservationsProduitsoptionnelsReservationsId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> produitsOptionnels(
    _i1.Session session,
    _i4.OptionnelReservation optionnelReservation, {
    _i1.Transaction? transaction,
  }) async {
    if (optionnelReservation.id == null) {
      throw ArgumentError.notNull('optionnelReservation.id');
    }

    var $optionnelReservation = _i4.OptionnelReservationImplicit(
      optionnelReservation,
      $_reservationsProduitsoptionnelsReservationsId: null,
    );
    await session.db.updateRow<_i4.OptionnelReservation>(
      $optionnelReservation,
      columns: [
        _i4
            .OptionnelReservation
            .t
            .$_reservationsProduitsoptionnelsReservationsId,
      ],
      transaction: transaction,
    );
  }
}
