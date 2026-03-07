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

abstract class ReservationEvenement
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ReservationEvenement._({
    required this.id,
    required this.utilisateurId,
    required this.evenementId,
    required this.nbBillets,
    required this.montantTotal,
    this.statut,
  });

  factory ReservationEvenement({
    required int id,
    required int utilisateurId,
    required int evenementId,
    required int nbBillets,
    required double montantTotal,
    String? statut,
  }) = _ReservationEvenementImpl;

  factory ReservationEvenement.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ReservationEvenement(
      id: jsonSerialization['id'] as int,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      evenementId: jsonSerialization['evenementId'] as int,
      nbBillets: jsonSerialization['nbBillets'] as int,
      montantTotal: (jsonSerialization['montantTotal'] as num).toDouble(),
      statut: jsonSerialization['statut'] as String?,
    );
  }

  int id;
  int utilisateurId;
  int evenementId;
  int nbBillets;
  double montantTotal;
  String? statut;

  @_i1.useResult
  ReservationEvenement copyWith({
    int? id,
    int? utilisateurId,
    int? evenementId,
    int? nbBillets,
    double? montantTotal,
    String? statut,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReservationEvenement',
      'id': id,
      'utilisateurId': utilisateurId,
      'evenementId': evenementId,
      'nbBillets': nbBillets,
      'montantTotal': montantTotal,
      if (statut != null) 'statut': statut,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return toJson();
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReservationEvenementImpl extends ReservationEvenement {
  _ReservationEvenementImpl({
    required int id,
    required int utilisateurId,
    required int evenementId,
    required int nbBillets,
    required double montantTotal,
    String? statut,
  }) : super._(
         id: id,
         utilisateurId: utilisateurId,
         evenementId: evenementId,
         nbBillets: nbBillets,
         montantTotal: montantTotal,
         statut: statut,
       );

  @override
  ReservationEvenement copyWith({
    int? id,
    int? utilisateurId,
    int? evenementId,
    int? nbBillets,
    double? montantTotal,
    Object? statut = _Undefined,
  }) {
    return ReservationEvenement(
      id: id ?? this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      evenementId: evenementId ?? this.evenementId,
      nbBillets: nbBillets ?? this.nbBillets,
      montantTotal: montantTotal ?? this.montantTotal,
      statut: statut is String? ? statut : this.statut,
    );
  }
}
