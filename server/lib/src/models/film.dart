import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Modèle Film (programmation).
class Film extends SerializationEntity {
  final int? id;
  final String titre;
  final String synopsis;
  final String genre;
  final int duree;
  final String realisateur;
  final List<String> casting;
  final String? affiche;
  final String? bandeAnnonce;
  final String classification;
  final double noteMoyenne;
  final DateTime dateDebut;
  final DateTime dateFin;

  Film({
    this.id,
    required this.titre,
    required this.synopsis,
    required this.genre,
    required this.duree,
    required this.realisateur,
    this.casting = const [],
    this.affiche,
    this.bandeAnnonce,
    this.classification = 'Tous publics',
    this.noteMoyenne = 0.0,
    required this.dateDebut,
    required this.dateFin,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'titre': titre,
        'synopsis': synopsis,
        'genre': genre,
        'duree': duree,
        'realisateur': realisateur,
        'casting': casting,
        'affiche': affiche,
        'bandeAnnonce': bandeAnnonce,
        'classification': classification,
        'noteMoyenne': noteMoyenne,
        'dateDebut': dateDebut.toIso8601String(),
        'dateFin': dateFin.toIso8601String(),
      };

  factory Film.fromJson(Map<String, dynamic> json) => Film(
        id: json['id'] as int?,
        titre: json['titre'] as String,
        synopsis: json['synopsis'] as String,
        genre: json['genre'] as String,
        duree: json['duree'] as int,
        realisateur: json['realisateur'] as String,
        casting: (json['casting'] as List<dynamic>?)?.cast<String>() ?? [],
        affiche: json['affiche'] as String?,
        bandeAnnonce: json['bandeAnnonce'] as String?,
        classification: json['classification'] as String? ?? 'Tous publics',
        noteMoyenne: (json['noteMoyenne'] as num?)?.toDouble() ?? 0.0,
        dateDebut: DateTime.parse(json['dateDebut'] as String),
        dateFin: DateTime.parse(json['dateFin'] as String),
      );
}
