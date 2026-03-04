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

  /// Désérialisation robuste : accepte dateHeure en String ISO ou DateTime,
  /// et clés camelCase (lieuType, dateHeure, etc.) ou snake_case de secours.
  static Evenement fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final titre = json['titre'] as String;
    final dateHeure = _parseDateTime(json['dateHeure'] ?? json['date_heure']);
    final prix = (json['prix'] as num?)?.toDouble() ?? 0.0;
    final placesDisponibles = json['placesDisponibles'] as int? ?? json['places_disponibles'] as int? ?? 0;
    return Evenement(
      id: id,
      titre: titre,
      description: json['description'] as String?,
      categorie: json['categorie'] as String?,
      lieuType: json['lieuType'] as String? ?? json['lieu_type'] as String?,
      cinemaId: json['cinemaId'] as int? ?? json['cinema_id'] as int?,
      lieuNom: json['lieuNom'] as String? ?? json['lieu_nom'] as String?,
      adresse: json['adresse'] as String?,
      ville: json['ville'] as String?,
      dateHeure: dateHeure,
      prix: prix,
      placesDisponibles: placesDisponibles,
      affiche: json['affiche'] as String?,
    );
  }

  static DateTime _parseDateTime(dynamic v) {
    if (v == null) throw ArgumentError('dateHeure manquant');
    if (v is DateTime) return v;
    if (v is String) return DateTime.parse(v);
    throw ArgumentError('Format dateHeure invalide: $v');
  }
}
