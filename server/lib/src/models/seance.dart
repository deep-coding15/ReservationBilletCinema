import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Modèle Seance (séance de film).
class Seance extends SerializationEntity {
  final int? id;
  final int filmId;
  final int salleId;
  final DateTime dateHeure;
  final String langue;
  final String typeProjection;
  final int placesDisponibles;
  final double prix;
  final String typeSeance;

  Seance({
    this.id,
    required this.filmId,
    required this.salleId,
    required this.dateHeure,
    this.langue = 'VF',
    this.typeProjection = '2D',
    required this.placesDisponibles,
    required this.prix,
    this.typeSeance = 'standard',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'filmId': filmId,
        'salleId': salleId,
        'dateHeure': dateHeure.toIso8601String(),
        'langue': langue,
        'typeProjection': typeProjection,
        'placesDisponibles': placesDisponibles,
        'prix': prix,
        'typeSeance': typeSeance,
      };

  factory Seance.fromJson(Map<String, dynamic> json) => Seance(
        id: json['id'] as int?,
        filmId: json['filmId'] as int,
        salleId: json['salleId'] as int,
        dateHeure: DateTime.parse(json['dateHeure'] as String),
        langue: json['langue'] as String? ?? 'VF',
        typeProjection: json['typeProjection'] as String? ?? '2D',
        placesDisponibles: json['placesDisponibles'] as int,
        prix: (json['prix'] as num).toDouble(),
        typeSeance: json['typeSeance'] as String? ?? 'standard',
      );
}
