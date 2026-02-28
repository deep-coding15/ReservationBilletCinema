import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Modèle Cinema.
class Cinema extends SerializationEntity {
  final int? id;
  final String nom;
  final String adresse;
  final String ville;
  final double? latitude;
  final double? longitude;

  Cinema({
    this.id,
    required this.nom,
    required this.adresse,
    required this.ville,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'adresse': adresse,
        'ville': ville,
        'latitude': latitude,
        'longitude': longitude,
      };

  factory Cinema.fromJson(Map<String, dynamic> json) => Cinema(
        id: json['id'] as int?,
        nom: json['nom'] as String,
        adresse: json['adresse'] as String,
        ville: json['ville'] as String,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
      );
}
