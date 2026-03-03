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

abstract class Film implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Film._({
    this.id,
    required this.titre,
    this.synopsis,
    this.genre,
    required this.duree,
    this.realisateur,
    this.casting,
    this.affiche,
    this.bande_annonce,
    this.classification,
    this.note_moyenne,
    required this.date_debut,
    required this.date_fin,
    this.createdAt,
  });

  factory Film({
    int? id,
    required String titre,
    String? synopsis,
    String? genre,
    required int duree,
    String? realisateur,
    List<String>? casting,
    String? affiche,
    String? bande_annonce,
    String? classification,
    double? note_moyenne,
    required DateTime date_debut,
    required DateTime date_fin,
    DateTime? createdAt,
  }) = _FilmImpl;

  factory Film.fromJson(Map<String, dynamic> jsonSerialization) {
    return Film(
      id: jsonSerialization['id'] as int?,
      titre: jsonSerialization['titre'] as String,
      synopsis: jsonSerialization['synopsis'] as String?,
      genre: jsonSerialization['genre'] as String?,
      duree: jsonSerialization['duree'] as int,
      realisateur: jsonSerialization['realisateur'] as String?,
      casting: jsonSerialization['casting'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['casting'],
            ),
      affiche: jsonSerialization['affiche'] as String?,
      bande_annonce: jsonSerialization['bande_annonce'] as String?,
      classification: jsonSerialization['classification'] as String?,
      note_moyenne: (jsonSerialization['note_moyenne'] as num?)?.toDouble(),
      date_debut: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['date_debut'],
      ),
      date_fin: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['date_fin'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = FilmTable();

  static const db = FilmRepository._();

  @override
  int? id;

  String titre;

  String? synopsis;

  String? genre;

  int duree;

  String? realisateur;

  List<String>? casting;

  String? affiche;

  String? bande_annonce;

  String? classification;

  double? note_moyenne;

  DateTime date_debut;

  DateTime date_fin;

  DateTime? createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Film]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Film copyWith({
    int? id,
    String? titre,
    String? synopsis,
    String? genre,
    int? duree,
    String? realisateur,
    List<String>? casting,
    String? affiche,
    String? bande_annonce,
    String? classification,
    double? note_moyenne,
    DateTime? date_debut,
    DateTime? date_fin,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Film',
      if (id != null) 'id': id,
      'titre': titre,
      if (synopsis != null) 'synopsis': synopsis,
      if (genre != null) 'genre': genre,
      'duree': duree,
      if (realisateur != null) 'realisateur': realisateur,
      if (casting != null) 'casting': casting?.toJson(),
      if (affiche != null) 'affiche': affiche,
      if (bande_annonce != null) 'bande_annonce': bande_annonce,
      if (classification != null) 'classification': classification,
      if (note_moyenne != null) 'note_moyenne': note_moyenne,
      'date_debut': date_debut.toJson(),
      'date_fin': date_fin.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Film',
      if (id != null) 'id': id,
      'titre': titre,
      if (synopsis != null) 'synopsis': synopsis,
      if (genre != null) 'genre': genre,
      'duree': duree,
      if (realisateur != null) 'realisateur': realisateur,
      if (casting != null) 'casting': casting?.toJson(),
      if (affiche != null) 'affiche': affiche,
      if (bande_annonce != null) 'bande_annonce': bande_annonce,
      if (classification != null) 'classification': classification,
      if (note_moyenne != null) 'note_moyenne': note_moyenne,
      'date_debut': date_debut.toJson(),
      'date_fin': date_fin.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
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
    required String titre,
    String? synopsis,
    String? genre,
    required int duree,
    String? realisateur,
    List<String>? casting,
    String? affiche,
    String? bande_annonce,
    String? classification,
    double? note_moyenne,
    required DateTime date_debut,
    required DateTime date_fin,
    DateTime? createdAt,
  }) : super._(
         id: id,
         titre: titre,
         synopsis: synopsis,
         genre: genre,
         duree: duree,
         realisateur: realisateur,
         casting: casting,
         affiche: affiche,
         bande_annonce: bande_annonce,
         classification: classification,
         note_moyenne: note_moyenne,
         date_debut: date_debut,
         date_fin: date_fin,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Film]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Film copyWith({
    Object? id = _Undefined,
    String? titre,
    Object? synopsis = _Undefined,
    Object? genre = _Undefined,
    int? duree,
    Object? realisateur = _Undefined,
    Object? casting = _Undefined,
    Object? affiche = _Undefined,
    Object? bande_annonce = _Undefined,
    Object? classification = _Undefined,
    Object? note_moyenne = _Undefined,
    DateTime? date_debut,
    DateTime? date_fin,
    Object? createdAt = _Undefined,
  }) {
    return Film(
      id: id is int? ? id : this.id,
      titre: titre ?? this.titre,
      synopsis: synopsis is String? ? synopsis : this.synopsis,
      genre: genre is String? ? genre : this.genre,
      duree: duree ?? this.duree,
      realisateur: realisateur is String? ? realisateur : this.realisateur,
      casting: casting is List<String>?
          ? casting
          : this.casting?.map((e0) => e0).toList(),
      affiche: affiche is String? ? affiche : this.affiche,
      bande_annonce: bande_annonce is String?
          ? bande_annonce
          : this.bande_annonce,
      classification: classification is String?
          ? classification
          : this.classification,
      note_moyenne: note_moyenne is double? ? note_moyenne : this.note_moyenne,
      date_debut: date_debut ?? this.date_debut,
      date_fin: date_fin ?? this.date_fin,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
    );
  }
}

class FilmUpdateTable extends _i1.UpdateTable<FilmTable> {
  FilmUpdateTable(super.table);

  _i1.ColumnValue<String, String> titre(String value) => _i1.ColumnValue(
    table.titre,
    value,
  );

  _i1.ColumnValue<String, String> synopsis(String? value) => _i1.ColumnValue(
    table.synopsis,
    value,
  );

  _i1.ColumnValue<String, String> genre(String? value) => _i1.ColumnValue(
    table.genre,
    value,
  );

  _i1.ColumnValue<int, int> duree(int value) => _i1.ColumnValue(
    table.duree,
    value,
  );

  _i1.ColumnValue<String, String> realisateur(String? value) => _i1.ColumnValue(
    table.realisateur,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> casting(List<String>? value) =>
      _i1.ColumnValue(
        table.casting,
        value,
      );

  _i1.ColumnValue<String, String> affiche(String? value) => _i1.ColumnValue(
    table.affiche,
    value,
  );

  _i1.ColumnValue<String, String> bande_annonce(String? value) =>
      _i1.ColumnValue(
        table.bande_annonce,
        value,
      );

  _i1.ColumnValue<String, String> classification(String? value) =>
      _i1.ColumnValue(
        table.classification,
        value,
      );

  _i1.ColumnValue<double, double> note_moyenne(double? value) =>
      _i1.ColumnValue(
        table.note_moyenne,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> date_debut(DateTime value) =>
      _i1.ColumnValue(
        table.date_debut,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> date_fin(DateTime value) =>
      _i1.ColumnValue(
        table.date_fin,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime? value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class FilmTable extends _i1.Table<int?> {
  FilmTable({super.tableRelation}) : super(tableName: 'films') {
    updateTable = FilmUpdateTable(this);
    titre = _i1.ColumnString(
      'titre',
      this,
    );
    synopsis = _i1.ColumnString(
      'synopsis',
      this,
    );
    genre = _i1.ColumnString(
      'genre',
      this,
    );
    duree = _i1.ColumnInt(
      'duree',
      this,
    );
    realisateur = _i1.ColumnString(
      'realisateur',
      this,
    );
    casting = _i1.ColumnSerializable<List<String>>(
      'casting',
      this,
    );
    affiche = _i1.ColumnString(
      'affiche',
      this,
    );
    bande_annonce = _i1.ColumnString(
      'bande_annonce',
      this,
    );
    classification = _i1.ColumnString(
      'classification',
      this,
    );
    note_moyenne = _i1.ColumnDouble(
      'note_moyenne',
      this,
    );
    date_debut = _i1.ColumnDateTime(
      'date_debut',
      this,
    );
    date_fin = _i1.ColumnDateTime(
      'date_fin',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final FilmUpdateTable updateTable;

  late final _i1.ColumnString titre;

  late final _i1.ColumnString synopsis;

  late final _i1.ColumnString genre;

  late final _i1.ColumnInt duree;

  late final _i1.ColumnString realisateur;

  late final _i1.ColumnSerializable<List<String>> casting;

  late final _i1.ColumnString affiche;

  late final _i1.ColumnString bande_annonce;

  late final _i1.ColumnString classification;

  late final _i1.ColumnDouble note_moyenne;

  late final _i1.ColumnDateTime date_debut;

  late final _i1.ColumnDateTime date_fin;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    titre,
    synopsis,
    genre,
    duree,
    realisateur,
    casting,
    affiche,
    bande_annonce,
    classification,
    note_moyenne,
    date_debut,
    date_fin,
    createdAt,
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
