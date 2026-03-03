/// Modèle événement (côté client).
class Evenement {
  Evenement({
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

  final int id;
  final String titre;
  final String? description;
  final String? categorie;
  final String? lieuType;
  final int? cinemaId;
  final String? lieuNom;
  final String? adresse;
  final String? ville;
  final DateTime dateHeure;
  final double prix;
  final int placesDisponibles;
  final String? affiche;

  /// Lieu affiché (cinéma ou autre lieu).
  String get lieuDisplay {
    if (lieuNom != null && lieuNom!.isNotEmpty) return lieuNom!;
    if (ville != null && ville!.isNotEmpty) return ville!;
    return 'Lieu à préciser';
  }

  static Evenement fromJson(Map<String, dynamic> json) {
    return Evenement(
      id: json['id'] as int,
      titre: json['titre'] as String,
      description: json['description'] as String?,
      categorie: json['categorie'] as String?,
      lieuType: json['lieuType'] as String?,
      cinemaId: json['cinemaId'] as int?,
      lieuNom: json['lieuNom'] as String?,
      adresse: json['adresse'] as String?,
      ville: json['ville'] as String?,
      dateHeure: DateTime.parse(json['dateHeure'] as String),
      prix: (json['prix'] as num).toDouble(),
      placesDisponibles: json['placesDisponibles'] as int,
      affiche: json['affiche'] as String?,
    );
  }
}
