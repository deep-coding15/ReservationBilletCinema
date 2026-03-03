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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class Reservation implements _i1.SerializableModel {
  Reservation._({
    this.id,
    required this.utilisateur_id,
    required this.seance_id,
    DateTime? date_reservation,
    required this.montant_total,
    String? statut,
    DateTime? created_at,
  }) : date_reservation = date_reservation ?? DateTime.now(),
       statut = statut ?? 'en_attente',
       created_at = created_at ?? DateTime.now();

  factory Reservation({
    int? id,
    required int utilisateur_id,
    required int seance_id,
    DateTime? date_reservation,
    required double montant_total,
    String? statut,
    DateTime? created_at,
  }) = _ReservationImpl;

  factory Reservation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reservation(
      id: jsonSerialization['id'] as int?,
      utilisateur_id: jsonSerialization['utilisateur_id'] as int,
      seance_id: jsonSerialization['seance_id'] as int,
      date_reservation: jsonSerialization['date_reservation'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['date_reservation'],
            ),
      montant_total: (jsonSerialization['montant_total'] as num).toDouble(),
      statut: jsonSerialization['statut'] as String?,
      created_at: jsonSerialization['created_at'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created_at']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int utilisateur_id;

  int seance_id;

  DateTime? date_reservation;

  double montant_total;

  String statut;

  DateTime? created_at;

  /// Returns a shallow copy of this [Reservation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Reservation copyWith({
    int? id,
    int? utilisateur_id,
    int? seance_id,
    DateTime? date_reservation,
    double? montant_total,
    String? statut,
    DateTime? created_at,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reservation',
      if (id != null) 'id': id,
      'utilisateur_id': utilisateur_id,
      'seance_id': seance_id,
      if (date_reservation != null)
        'date_reservation': date_reservation?.toJson(),
      'montant_total': montant_total,
      'statut': statut,
      if (created_at != null) 'created_at': created_at?.toJson(),
    };
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
    required int utilisateur_id,
    required int seance_id,
    DateTime? date_reservation,
    required double montant_total,
    String? statut,
    DateTime? created_at,
  }) : super._(
         id: id,
         utilisateur_id: utilisateur_id,
         seance_id: seance_id,
         date_reservation: date_reservation,
         montant_total: montant_total,
         statut: statut,
         created_at: created_at,
       );

  /// Returns a shallow copy of this [Reservation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Reservation copyWith({
    Object? id = _Undefined,
    int? utilisateur_id,
    int? seance_id,
    Object? date_reservation = _Undefined,
    double? montant_total,
    String? statut,
    Object? created_at = _Undefined,
  }) {
    return Reservation(
      id: id is int? ? id : this.id,
      utilisateur_id: utilisateur_id ?? this.utilisateur_id,
      seance_id: seance_id ?? this.seance_id,
      date_reservation: date_reservation is DateTime?
          ? date_reservation
          : this.date_reservation,
      montant_total: montant_total ?? this.montant_total,
      statut: statut ?? this.statut,
      created_at: created_at is DateTime? ? created_at : this.created_at,
    );
  }
}
