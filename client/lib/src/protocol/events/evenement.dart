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

abstract class Evenement implements _i1.SerializableModel {
  Evenement._({
    required this.id,
    required this.titre,
    this.description,
    this.categorie,
    this.lieuType,
    this.cinemaId,
    this.lieuNom,
    this.adresse,
    this.ville,
    required this.dateHeure,
    required this.prix,
    required this.placesDisponibles,
    this.affiche,
  });

  factory Evenement({
    required int id,
    required String titre,
    String? description,
    String? categorie,
    String? lieuType,
    int? cinemaId,
    String? lieuNom,
    String? adresse,
    String? ville,
    required DateTime dateHeure,
    required double prix,
    required int placesDisponibles,
    String? affiche,
  }) = _EvenementImpl;

  factory Evenement.fromJson(Map<String, dynamic> jsonSerialization) {
    return Evenement(
      id: jsonSerialization['id'] as int,
      titre: jsonSerialization['titre'] as String,
      description: jsonSerialization['description'] as String?,
      categorie: jsonSerialization['categorie'] as String?,
      lieuType: jsonSerialization['lieuType'] as String?,
      cinemaId: jsonSerialization['cinemaId'] as int?,
      lieuNom: jsonSerialization['lieuNom'] as String?,
      adresse: jsonSerialization['adresse'] as String?,
      ville: jsonSerialization['ville'] as String?,
      dateHeure: _i2.Protocol().deserialize<DateTime>(
        jsonSerialization['dateHeure'],
      ),
      prix: (jsonSerialization['prix'] as num).toDouble(),
      placesDisponibles: jsonSerialization['placesDisponibles'] as int,
      affiche: jsonSerialization['affiche'] as String?,
    );
  }

  int id;
  String titre;
  String? description;
  String? categorie;
  String? lieuType;
  int? cinemaId;
  String? lieuNom;
  String? adresse;
  String? ville;
  DateTime dateHeure;
  double prix;
  int placesDisponibles;
  String? affiche;

  @_i1.useResult
  Evenement copyWith({
    int? id,
    String? titre,
    String? description,
    String? categorie,
    String? lieuType,
    int? cinemaId,
    String? lieuNom,
    String? adresse,
    String? ville,
    DateTime? dateHeure,
    double? prix,
    int? placesDisponibles,
    String? affiche,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Evenement',
      'id': id,
      'titre': titre,
      if (description != null) 'description': description,
      if (categorie != null) 'categorie': categorie,
      if (lieuType != null) 'lieuType': lieuType,
      if (cinemaId != null) 'cinemaId': cinemaId,
      if (lieuNom != null) 'lieuNom': lieuNom,
      if (adresse != null) 'adresse': adresse,
      if (ville != null) 'ville': ville,
      'dateHeure': dateHeure.toJson(),
      'prix': prix,
      'placesDisponibles': placesDisponibles,
      if (affiche != null) 'affiche': affiche,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EvenementImpl extends Evenement {
  _EvenementImpl({
    required int id,
    required String titre,
    String? description,
    String? categorie,
    String? lieuType,
    int? cinemaId,
    String? lieuNom,
    String? adresse,
    String? ville,
    required DateTime dateHeure,
    required double prix,
    required int placesDisponibles,
    String? affiche,
  }) : super._(
         id: id,
         titre: titre,
         description: description,
         categorie: categorie,
         lieuType: lieuType,
         cinemaId: cinemaId,
         lieuNom: lieuNom,
         adresse: adresse,
         ville: ville,
         dateHeure: dateHeure,
         prix: prix,
         placesDisponibles: placesDisponibles,
         affiche: affiche,
       );

  @override
  Evenement copyWith({
    int? id,
    String? titre,
    Object? description = _Undefined,
    Object? categorie = _Undefined,
    Object? lieuType = _Undefined,
    int? cinemaId,
    Object? lieuNom = _Undefined,
    Object? adresse = _Undefined,
    Object? ville = _Undefined,
    DateTime? dateHeure,
    double? prix,
    int? placesDisponibles,
    Object? affiche = _Undefined,
  }) {
    return Evenement(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      description: description is String? ? description : this.description,
      categorie: categorie is String? ? categorie : this.categorie,
      lieuType: lieuType is String? ? lieuType : this.lieuType,
      cinemaId: cinemaId ?? this.cinemaId,
      lieuNom: lieuNom is String? ? lieuNom : this.lieuNom,
      adresse: adresse is String? ? adresse : this.adresse,
      ville: ville is String? ? ville : this.ville,
      dateHeure: dateHeure ?? this.dateHeure,
      prix: prix ?? this.prix,
      placesDisponibles: placesDisponibles ?? this.placesDisponibles,
      affiche: affiche is String? ? affiche : this.affiche,
    );
  }
}
