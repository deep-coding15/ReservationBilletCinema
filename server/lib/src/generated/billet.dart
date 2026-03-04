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
import 'reservation.dart' as _i2;
import 'paiement.dart' as _i3;
import 'optionnel_reservation.dart' as _i4;
import 'package:cinema_reservation_server/src/generated/protocol.dart' as _i5;

abstract class Billet implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Billet._({
    this.id,
    required this.reservationId,
    this.reservation,
    required this.paiementId,
    this.paiement,
    required this.code,
    this.produitsOptionnel,
    required this.dateEmission,
    required this.price,
    required this.qrCode,
    required this.estValide,
  });

  factory Billet({
    int? id,
    required int reservationId,
    _i2.Reservation? reservation,
    required int paiementId,
    _i3.Paiement? paiement,
    required String code,
    List<_i4.OptionnelReservation>? produitsOptionnel,
    required DateTime dateEmission,
    required double price,
    required String qrCode,
    required bool estValide,
  }) = _BilletImpl;

  factory Billet.fromJson(Map<String, dynamic> jsonSerialization) {
    return Billet(
      id: jsonSerialization['id'] as int?,
      reservationId: jsonSerialization['reservationId'] as int,
      reservation: jsonSerialization['reservation'] == null
          ? null
          : _i5.Protocol().deserialize<_i2.Reservation>(
              jsonSerialization['reservation'],
            ),
      paiementId: jsonSerialization['paiementId'] as int,
      paiement: jsonSerialization['paiement'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.Paiement>(
              jsonSerialization['paiement'],
            ),
      code: jsonSerialization['code'] as String,
      produitsOptionnel: jsonSerialization['produitsOptionnel'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i4.OptionnelReservation>>(
              jsonSerialization['produitsOptionnel'],
            ),
      dateEmission: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateEmission'],
      ),
      price: (jsonSerialization['price'] as num).toDouble(),
      qrCode: jsonSerialization['qrCode'] as String,
      estValide: jsonSerialization['estValide'] as bool,
    );
  }

  static final t = BilletTable();

  static const db = BilletRepository._();

  @override
  int? id;

  int reservationId;

  _i2.Reservation? reservation;

  int paiementId;

  _i3.Paiement? paiement;

  String code;

  List<_i4.OptionnelReservation>? produitsOptionnel;

  DateTime dateEmission;

  double price;

  String qrCode;

  bool estValide;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Billet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Billet copyWith({
    int? id,
    int? reservationId,
    _i2.Reservation? reservation,
    int? paiementId,
    _i3.Paiement? paiement,
    String? code,
    List<_i4.OptionnelReservation>? produitsOptionnel,
    DateTime? dateEmission,
    double? price,
    String? qrCode,
    bool? estValide,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Billet',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      if (reservation != null) 'reservation': reservation?.toJson(),
      'paiementId': paiementId,
      if (paiement != null) 'paiement': paiement?.toJson(),
      'code': code,
      if (produitsOptionnel != null)
        'produitsOptionnel': produitsOptionnel?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'dateEmission': dateEmission.toJson(),
      'price': price,
      'qrCode': qrCode,
      'estValide': estValide,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Billet',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      if (reservation != null) 'reservation': reservation?.toJsonForProtocol(),
      'paiementId': paiementId,
      if (paiement != null) 'paiement': paiement?.toJsonForProtocol(),
      'code': code,
      if (produitsOptionnel != null)
        'produitsOptionnel': produitsOptionnel?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'dateEmission': dateEmission.toJson(),
      'price': price,
      'qrCode': qrCode,
      'estValide': estValide,
    };
  }

  static BilletInclude include({
    _i2.ReservationInclude? reservation,
    _i3.PaiementInclude? paiement,
    _i4.OptionnelReservationIncludeList? produitsOptionnel,
  }) {
    return BilletInclude._(
      reservation: reservation,
      paiement: paiement,
      produitsOptionnel: produitsOptionnel,
    );
  }

  static BilletIncludeList includeList({
    _i1.WhereExpressionBuilder<BilletTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BilletTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BilletTable>? orderByList,
    BilletInclude? include,
  }) {
    return BilletIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Billet.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Billet.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BilletImpl extends Billet {
  _BilletImpl({
    int? id,
    required int reservationId,
    _i2.Reservation? reservation,
    required int paiementId,
    _i3.Paiement? paiement,
    required String code,
    List<_i4.OptionnelReservation>? produitsOptionnel,
    required DateTime dateEmission,
    required double price,
    required String qrCode,
    required bool estValide,
  }) : super._(
         id: id,
         reservationId: reservationId,
         reservation: reservation,
         paiementId: paiementId,
         paiement: paiement,
         code: code,
         produitsOptionnel: produitsOptionnel,
         dateEmission: dateEmission,
         price: price,
         qrCode: qrCode,
         estValide: estValide,
       );

  /// Returns a shallow copy of this [Billet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Billet copyWith({
    Object? id = _Undefined,
    int? reservationId,
    Object? reservation = _Undefined,
    int? paiementId,
    Object? paiement = _Undefined,
    String? code,
    Object? produitsOptionnel = _Undefined,
    DateTime? dateEmission,
    double? price,
    String? qrCode,
    bool? estValide,
  }) {
    return Billet(
      id: id is int? ? id : this.id,
      reservationId: reservationId ?? this.reservationId,
      reservation: reservation is _i2.Reservation?
          ? reservation
          : this.reservation?.copyWith(),
      paiementId: paiementId ?? this.paiementId,
      paiement: paiement is _i3.Paiement?
          ? paiement
          : this.paiement?.copyWith(),
      code: code ?? this.code,
      produitsOptionnel: produitsOptionnel is List<_i4.OptionnelReservation>?
          ? produitsOptionnel
          : this.produitsOptionnel?.map((e0) => e0.copyWith()).toList(),
      dateEmission: dateEmission ?? this.dateEmission,
      price: price ?? this.price,
      qrCode: qrCode ?? this.qrCode,
      estValide: estValide ?? this.estValide,
    );
  }
}

class BilletUpdateTable extends _i1.UpdateTable<BilletTable> {
  BilletUpdateTable(super.table);

  _i1.ColumnValue<int, int> reservationId(int value) => _i1.ColumnValue(
    table.reservationId,
    value,
  );

  _i1.ColumnValue<int, int> paiementId(int value) => _i1.ColumnValue(
    table.paiementId,
    value,
  );

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dateEmission(DateTime value) =>
      _i1.ColumnValue(
        table.dateEmission,
        value,
      );

  _i1.ColumnValue<double, double> price(double value) => _i1.ColumnValue(
    table.price,
    value,
  );

  _i1.ColumnValue<String, String> qrCode(String value) => _i1.ColumnValue(
    table.qrCode,
    value,
  );

  _i1.ColumnValue<bool, bool> estValide(bool value) => _i1.ColumnValue(
    table.estValide,
    value,
  );
}

class BilletTable extends _i1.Table<int?> {
  BilletTable({super.tableRelation}) : super(tableName: 'billets') {
    updateTable = BilletUpdateTable(this);
    reservationId = _i1.ColumnInt(
      'reservationId',
      this,
    );
    paiementId = _i1.ColumnInt(
      'paiementId',
      this,
    );
    code = _i1.ColumnString(
      'code',
      this,
    );
    dateEmission = _i1.ColumnDateTime(
      'dateEmission',
      this,
    );
    price = _i1.ColumnDouble(
      'price',
      this,
    );
    qrCode = _i1.ColumnString(
      'qrCode',
      this,
    );
    estValide = _i1.ColumnBool(
      'estValide',
      this,
    );
  }

  late final BilletUpdateTable updateTable;

  late final _i1.ColumnInt reservationId;

  _i2.ReservationTable? _reservation;

  late final _i1.ColumnInt paiementId;

  _i3.PaiementTable? _paiement;

  late final _i1.ColumnString code;

  _i4.OptionnelReservationTable? ___produitsOptionnel;

  _i1.ManyRelation<_i4.OptionnelReservationTable>? _produitsOptionnel;

  late final _i1.ColumnDateTime dateEmission;

  late final _i1.ColumnDouble price;

  late final _i1.ColumnString qrCode;

  late final _i1.ColumnBool estValide;

  _i2.ReservationTable get reservation {
    if (_reservation != null) return _reservation!;
    _reservation = _i1.createRelationTable(
      relationFieldName: 'reservation',
      field: Billet.t.reservationId,
      foreignField: _i2.Reservation.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ReservationTable(tableRelation: foreignTableRelation),
    );
    return _reservation!;
  }

  _i3.PaiementTable get paiement {
    if (_paiement != null) return _paiement!;
    _paiement = _i1.createRelationTable(
      relationFieldName: 'paiement',
      field: Billet.t.paiementId,
      foreignField: _i3.Paiement.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.PaiementTable(tableRelation: foreignTableRelation),
    );
    return _paiement!;
  }

  _i4.OptionnelReservationTable get __produitsOptionnel {
    if (___produitsOptionnel != null) return ___produitsOptionnel!;
    ___produitsOptionnel = _i1.createRelationTable(
      relationFieldName: '__produitsOptionnel',
      field: Billet.t.id,
      foreignField:
          _i4.OptionnelReservation.t.$_billetsProduitsoptionnelBilletsId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.OptionnelReservationTable(tableRelation: foreignTableRelation),
    );
    return ___produitsOptionnel!;
  }

  _i1.ManyRelation<_i4.OptionnelReservationTable> get produitsOptionnel {
    if (_produitsOptionnel != null) return _produitsOptionnel!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'produitsOptionnel',
      field: Billet.t.id,
      foreignField:
          _i4.OptionnelReservation.t.$_billetsProduitsoptionnelBilletsId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.OptionnelReservationTable(tableRelation: foreignTableRelation),
    );
    _produitsOptionnel = _i1.ManyRelation<_i4.OptionnelReservationTable>(
      tableWithRelations: relationTable,
      table: _i4.OptionnelReservationTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _produitsOptionnel!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    reservationId,
    paiementId,
    code,
    dateEmission,
    price,
    qrCode,
    estValide,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'reservation') {
      return reservation;
    }
    if (relationField == 'paiement') {
      return paiement;
    }
    if (relationField == 'produitsOptionnel') {
      return __produitsOptionnel;
    }
    return null;
  }
}

class BilletInclude extends _i1.IncludeObject {
  BilletInclude._({
    _i2.ReservationInclude? reservation,
    _i3.PaiementInclude? paiement,
    _i4.OptionnelReservationIncludeList? produitsOptionnel,
  }) {
    _reservation = reservation;
    _paiement = paiement;
    _produitsOptionnel = produitsOptionnel;
  }

  _i2.ReservationInclude? _reservation;

  _i3.PaiementInclude? _paiement;

  _i4.OptionnelReservationIncludeList? _produitsOptionnel;

  @override
  Map<String, _i1.Include?> get includes => {
    'reservation': _reservation,
    'paiement': _paiement,
    'produitsOptionnel': _produitsOptionnel,
  };

  @override
  _i1.Table<int?> get table => Billet.t;
}

class BilletIncludeList extends _i1.IncludeList {
  BilletIncludeList._({
    _i1.WhereExpressionBuilder<BilletTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Billet.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Billet.t;
}

class BilletRepository {
  const BilletRepository._();

  final attach = const BilletAttachRepository._();

  final attachRow = const BilletAttachRowRepository._();

  final detach = const BilletDetachRepository._();

  final detachRow = const BilletDetachRowRepository._();

  /// Returns a list of [Billet]s matching the given query parameters.
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
  Future<List<Billet>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BilletTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BilletTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BilletTable>? orderByList,
    _i1.Transaction? transaction,
    BilletInclude? include,
  }) async {
    return session.db.find<Billet>(
      where: where?.call(Billet.t),
      orderBy: orderBy?.call(Billet.t),
      orderByList: orderByList?.call(Billet.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Billet] matching the given query parameters.
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
  Future<Billet?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BilletTable>? where,
    int? offset,
    _i1.OrderByBuilder<BilletTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BilletTable>? orderByList,
    _i1.Transaction? transaction,
    BilletInclude? include,
  }) async {
    return session.db.findFirstRow<Billet>(
      where: where?.call(Billet.t),
      orderBy: orderBy?.call(Billet.t),
      orderByList: orderByList?.call(Billet.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Billet] by its [id] or null if no such row exists.
  Future<Billet?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    BilletInclude? include,
  }) async {
    return session.db.findById<Billet>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Billet]s in the list and returns the inserted rows.
  ///
  /// The returned [Billet]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Billet>> insert(
    _i1.Session session,
    List<Billet> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Billet>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Billet] and returns the inserted row.
  ///
  /// The returned [Billet] will have its `id` field set.
  Future<Billet> insertRow(
    _i1.Session session,
    Billet row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Billet>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Billet]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Billet>> update(
    _i1.Session session,
    List<Billet> rows, {
    _i1.ColumnSelections<BilletTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Billet>(
      rows,
      columns: columns?.call(Billet.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Billet]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Billet> updateRow(
    _i1.Session session,
    Billet row, {
    _i1.ColumnSelections<BilletTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Billet>(
      row,
      columns: columns?.call(Billet.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Billet] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Billet?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<BilletUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Billet>(
      id,
      columnValues: columnValues(Billet.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Billet]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Billet>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<BilletUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BilletTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BilletTable>? orderBy,
    _i1.OrderByListBuilder<BilletTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Billet>(
      columnValues: columnValues(Billet.t.updateTable),
      where: where(Billet.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Billet.t),
      orderByList: orderByList?.call(Billet.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Billet]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Billet>> delete(
    _i1.Session session,
    List<Billet> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Billet>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Billet].
  Future<Billet> deleteRow(
    _i1.Session session,
    Billet row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Billet>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Billet>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BilletTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Billet>(
      where: where(Billet.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BilletTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Billet>(
      where: where?.call(Billet.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class BilletAttachRepository {
  const BilletAttachRepository._();

  /// Creates a relation between this [Billet] and the given [OptionnelReservation]s
  /// by setting each [OptionnelReservation]'s foreign key `_billetsProduitsoptionnelBilletsId` to refer to this [Billet].
  Future<void> produitsOptionnel(
    _i1.Session session,
    Billet billet,
    List<_i4.OptionnelReservation> optionnelReservation, {
    _i1.Transaction? transaction,
  }) async {
    if (optionnelReservation.any((e) => e.id == null)) {
      throw ArgumentError.notNull('optionnelReservation.id');
    }
    if (billet.id == null) {
      throw ArgumentError.notNull('billet.id');
    }

    var $optionnelReservation = optionnelReservation
        .map(
          (e) => _i4.OptionnelReservationImplicit(
            e,
            $_billetsProduitsoptionnelBilletsId: billet.id,
          ),
        )
        .toList();
    await session.db.update<_i4.OptionnelReservation>(
      $optionnelReservation,
      columns: [_i4.OptionnelReservation.t.$_billetsProduitsoptionnelBilletsId],
      transaction: transaction,
    );
  }
}

class BilletAttachRowRepository {
  const BilletAttachRowRepository._();

  /// Creates a relation between the given [Billet] and [Reservation]
  /// by setting the [Billet]'s foreign key `reservationId` to refer to the [Reservation].
  Future<void> reservation(
    _i1.Session session,
    Billet billet,
    _i2.Reservation reservation, {
    _i1.Transaction? transaction,
  }) async {
    if (billet.id == null) {
      throw ArgumentError.notNull('billet.id');
    }
    if (reservation.id == null) {
      throw ArgumentError.notNull('reservation.id');
    }

    var $billet = billet.copyWith(reservationId: reservation.id);
    await session.db.updateRow<Billet>(
      $billet,
      columns: [Billet.t.reservationId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Billet] and [Paiement]
  /// by setting the [Billet]'s foreign key `paiementId` to refer to the [Paiement].
  Future<void> paiement(
    _i1.Session session,
    Billet billet,
    _i3.Paiement paiement, {
    _i1.Transaction? transaction,
  }) async {
    if (billet.id == null) {
      throw ArgumentError.notNull('billet.id');
    }
    if (paiement.id == null) {
      throw ArgumentError.notNull('paiement.id');
    }

    var $billet = billet.copyWith(paiementId: paiement.id);
    await session.db.updateRow<Billet>(
      $billet,
      columns: [Billet.t.paiementId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Billet] and the given [OptionnelReservation]
  /// by setting the [OptionnelReservation]'s foreign key `_billetsProduitsoptionnelBilletsId` to refer to this [Billet].
  Future<void> produitsOptionnel(
    _i1.Session session,
    Billet billet,
    _i4.OptionnelReservation optionnelReservation, {
    _i1.Transaction? transaction,
  }) async {
    if (optionnelReservation.id == null) {
      throw ArgumentError.notNull('optionnelReservation.id');
    }
    if (billet.id == null) {
      throw ArgumentError.notNull('billet.id');
    }

    var $optionnelReservation = _i4.OptionnelReservationImplicit(
      optionnelReservation,
      $_billetsProduitsoptionnelBilletsId: billet.id,
    );
    await session.db.updateRow<_i4.OptionnelReservation>(
      $optionnelReservation,
      columns: [_i4.OptionnelReservation.t.$_billetsProduitsoptionnelBilletsId],
      transaction: transaction,
    );
  }
}

class BilletDetachRepository {
  const BilletDetachRepository._();

  /// Detaches the relation between this [Billet] and the given [OptionnelReservation]
  /// by setting the [OptionnelReservation]'s foreign key `_billetsProduitsoptionnelBilletsId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> produitsOptionnel(
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
            $_billetsProduitsoptionnelBilletsId: null,
          ),
        )
        .toList();
    await session.db.update<_i4.OptionnelReservation>(
      $optionnelReservation,
      columns: [_i4.OptionnelReservation.t.$_billetsProduitsoptionnelBilletsId],
      transaction: transaction,
    );
  }
}

class BilletDetachRowRepository {
  const BilletDetachRowRepository._();

  /// Detaches the relation between this [Billet] and the given [OptionnelReservation]
  /// by setting the [OptionnelReservation]'s foreign key `_billetsProduitsoptionnelBilletsId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> produitsOptionnel(
    _i1.Session session,
    _i4.OptionnelReservation optionnelReservation, {
    _i1.Transaction? transaction,
  }) async {
    if (optionnelReservation.id == null) {
      throw ArgumentError.notNull('optionnelReservation.id');
    }

    var $optionnelReservation = _i4.OptionnelReservationImplicit(
      optionnelReservation,
      $_billetsProduitsoptionnelBilletsId: null,
    );
    await session.db.updateRow<_i4.OptionnelReservation>(
      $optionnelReservation,
      columns: [_i4.OptionnelReservation.t.$_billetsProduitsoptionnelBilletsId],
      transaction: transaction,
    );
  }
}
