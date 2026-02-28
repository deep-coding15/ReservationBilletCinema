import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Modèle Salle (salle de cinéma).
class Salle extends SerializationEntity {
  final int? id;
  final int cinemaId;
  final String codeSalle;
  final int capacite;
  final List<String> equipements;

  Salle({
    this.id,
    required this.cinemaId,
    required this.codeSalle,
    required this.capacite,
    this.equipements = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'cinemaId': cinemaId,
        'codeSalle': codeSalle,
        'capacite': capacite,
        'equipements': equipements,
      };

  factory Salle.fromJson(Map<String, dynamic> json) => Salle(
        id: json['id'] as int?,
        cinemaId: json['cinemaId'] as int,
        codeSalle: json['codeSalle'] as String,
        capacite: json['capacite'] as int,
        equipements: (json['equipements'] as List<dynamic>?)?.cast<String>() ?? [],
      );
}
