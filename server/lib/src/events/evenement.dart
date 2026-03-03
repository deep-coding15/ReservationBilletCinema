/// Modèle événement (table evenements) — utilisé par l'endpoint.
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'titre': titre,
        'description': description,
        'categorie': categorie,
        'lieuType': lieuType,
        'cinemaId': cinemaId,
        'lieuNom': lieuNom,
        'adresse': adresse,
        'ville': ville,
        'dateHeure': dateHeure.toIso8601String(),
        'prix': prix,
        'placesDisponibles': placesDisponibles,
        'affiche': affiche,
      };
}
