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

abstract class DemandeSupport implements _i1.SerializableModel {
  DemandeSupport._({
    this.id,
    required this.utilisateur_id,
    required this.sujet,
    required this.message,
    String? statut,
    this.reponse,
    DateTime? created_at,
  }) : statut = statut ?? 'ouvert',
       created_at = created_at ?? DateTime.now();

  factory DemandeSupport({
    int? id,
    required int utilisateur_id,
    required String sujet,
    required String message,
    String? statut,
    String? reponse,
    DateTime? created_at,
  }) = _DemandeSupportImpl;

  factory DemandeSupport.fromJson(Map<String, dynamic> jsonSerialization) {
    return DemandeSupport(
      id: jsonSerialization['id'] as int?,
      utilisateur_id: jsonSerialization['utilisateur_id'] as int,
      sujet: jsonSerialization['sujet'] as String,
      message: jsonSerialization['message'] as String,
      statut: jsonSerialization['statut'] as String?,
      reponse: jsonSerialization['reponse'] as String?,
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

  String sujet;

  String message;

  String statut;

  String? reponse;

  DateTime? created_at;

  /// Returns a shallow copy of this [DemandeSupport]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DemandeSupport copyWith({
    int? id,
    int? utilisateur_id,
    String? sujet,
    String? message,
    String? statut,
    String? reponse,
    DateTime? created_at,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DemandeSupport',
      if (id != null) 'id': id,
      'utilisateur_id': utilisateur_id,
      'sujet': sujet,
      'message': message,
      'statut': statut,
      if (reponse != null) 'reponse': reponse,
      if (created_at != null) 'created_at': created_at?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DemandeSupportImpl extends DemandeSupport {
  _DemandeSupportImpl({
    int? id,
    required int utilisateur_id,
    required String sujet,
    required String message,
    String? statut,
    String? reponse,
    DateTime? created_at,
  }) : super._(
         id: id,
         utilisateur_id: utilisateur_id,
         sujet: sujet,
         message: message,
         statut: statut,
         reponse: reponse,
         created_at: created_at,
       );

  /// Returns a shallow copy of this [DemandeSupport]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DemandeSupport copyWith({
    Object? id = _Undefined,
    int? utilisateur_id,
    String? sujet,
    String? message,
    String? statut,
    Object? reponse = _Undefined,
    Object? created_at = _Undefined,
  }) {
    return DemandeSupport(
      id: id is int? ? id : this.id,
      utilisateur_id: utilisateur_id ?? this.utilisateur_id,
      sujet: sujet ?? this.sujet,
      message: message ?? this.message,
      statut: statut ?? this.statut,
      reponse: reponse is String? ? reponse : this.reponse,
      created_at: created_at is DateTime? ? created_at : this.created_at,
    );
  }
}
