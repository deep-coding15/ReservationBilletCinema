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
import 'package:cinema_reservation_client/src/protocol/protocol.dart' as _i2;

abstract class Utilisateur implements _i1.SerializableModel {
  Utilisateur._({
    this.id,
    required this.nom,
    required this.email,
    this.telephone,
    required this.mot_de_passe_hash,
    this.preferences,
    String? statut,
    DateTime? created_at,
  }) : statut = statut ?? 'actif',
       created_at = created_at ?? DateTime.now();

  factory Utilisateur({
    int? id,
    required String nom,
    required String email,
    String? telephone,
    required String mot_de_passe_hash,
    List<String>? preferences,
    String? statut,
    DateTime? created_at,
  }) = _UtilisateurImpl;

  factory Utilisateur.fromJson(Map<String, dynamic> jsonSerialization) {
    return Utilisateur(
      id: jsonSerialization['id'] as int?,
      nom: jsonSerialization['nom'] as String,
      email: jsonSerialization['email'] as String,
      telephone: jsonSerialization['telephone'] as String?,
      mot_de_passe_hash: jsonSerialization['mot_de_passe_hash'] as String,
      preferences: jsonSerialization['preferences'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['preferences'],
            ),
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

  String nom;

  String email;

  String? telephone;

  String mot_de_passe_hash;

  List<String>? preferences;

  String statut;

  DateTime? created_at;

  /// Returns a shallow copy of this [Utilisateur]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Utilisateur copyWith({
    int? id,
    String? nom,
    String? email,
    String? telephone,
    String? mot_de_passe_hash,
    List<String>? preferences,
    String? statut,
    DateTime? created_at,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Utilisateur',
      if (id != null) 'id': id,
      'nom': nom,
      'email': email,
      if (telephone != null) 'telephone': telephone,
      'mot_de_passe_hash': mot_de_passe_hash,
      if (preferences != null) 'preferences': preferences?.toJson(),
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

class _UtilisateurImpl extends Utilisateur {
  _UtilisateurImpl({
    int? id,
    required String nom,
    required String email,
    String? telephone,
    required String mot_de_passe_hash,
    List<String>? preferences,
    String? statut,
    DateTime? created_at,
  }) : super._(
         id: id,
         nom: nom,
         email: email,
         telephone: telephone,
         mot_de_passe_hash: mot_de_passe_hash,
         preferences: preferences,
         statut: statut,
         created_at: created_at,
       );

  /// Returns a shallow copy of this [Utilisateur]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Utilisateur copyWith({
    Object? id = _Undefined,
    String? nom,
    String? email,
    Object? telephone = _Undefined,
    String? mot_de_passe_hash,
    Object? preferences = _Undefined,
    String? statut,
    Object? created_at = _Undefined,
  }) {
    return Utilisateur(
      id: id is int? ? id : this.id,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      telephone: telephone is String? ? telephone : this.telephone,
      mot_de_passe_hash: mot_de_passe_hash ?? this.mot_de_passe_hash,
      preferences: preferences is List<String>?
          ? preferences
          : this.preferences?.map((e0) => e0).toList(),
      statut: statut ?? this.statut,
      created_at: created_at is DateTime? ? created_at : this.created_at,
    );
  }
}
