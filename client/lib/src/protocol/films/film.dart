// client/lib/src/protocol/films/film.dart
// ignore_for_file: non_constant_identifier_names

class Film {
  Film._({
    this.id,
    required this.titre,
    this.synopsis,
    this.genre,
    required this.duree,
    this.realisateur,
    this.casting,
    this.affiche,
    this.bandeAnnonce,
    this.classification,
    this.noteMoyenne,
    required this.dateDebut,
    required this.dateFin,
    this.createdAt,
  });

  factory Film({
    int? id,
    required String titre,
    String? synopsis,
    String? genre,
    required int duree,
    String? realisateur,
    List<String>? casting,
    String? affiche,
    String? bandeAnnonce,
    String? classification,
    double? noteMoyenne,
    required DateTime dateDebut,
    required DateTime dateFin,
    DateTime? createdAt,
  }) = _FilmImpl;

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'] as int?,
      titre: json['titre'] as String,
      synopsis: json['synopsis'] as String?,
      genre: json['genre'] as String?,
      duree: json['duree'] as int,
      realisateur: json['realisateur'] as String?,
      casting: json['casting'] == null
          ? null
          : (json['casting'] as List).cast<String>(),
      affiche: json['affiche'] as String?,
      bandeAnnonce: json['bandeAnnonce'] as String?,
      classification: json['classification'] as String?,
      noteMoyenne: (json['noteMoyenne'] as num?)?.toDouble(),
      dateDebut: DateTime.parse(json['dateDebut'] as String),
      dateFin: DateTime.parse(json['dateFin'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );
  }

  int? id;
  String titre;
  String? synopsis;
  String? genre;
  int duree;
  String? realisateur;
  List<String>? casting;
  String? affiche;
  String? bandeAnnonce;
  String? classification;
  double? noteMoyenne;
  DateTime dateDebut;
  DateTime dateFin;
  DateTime? createdAt;

  Film copyWith({
    int? id,
    String? titre,
    String? synopsis,
    String? genre,
    int? duree,
    String? realisateur,
    List<String>? casting,
    String? affiche,
    String? bandeAnnonce,
    String? classification,
    double? noteMoyenne,
    DateTime? dateDebut,
    DateTime? dateFin,
    DateTime? createdAt,
  }) {
    return Film(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      synopsis: synopsis ?? this.synopsis,
      genre: genre ?? this.genre,
      duree: duree ?? this.duree,
      realisateur: realisateur ?? this.realisateur,
      casting: casting ?? this.casting,
      affiche: affiche ?? this.affiche,
      bandeAnnonce: bandeAnnonce ?? this.bandeAnnonce,
      classification: classification ?? this.classification,
      noteMoyenne: noteMoyenne ?? this.noteMoyenne,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'titre': titre,
      if (synopsis != null) 'synopsis': synopsis,
      if (genre != null) 'genre': genre,
      'duree': duree,
      if (realisateur != null) 'realisateur': realisateur,
      if (casting != null) 'casting': casting,
      if (affiche != null) 'affiche': affiche,
      if (bandeAnnonce != null) 'bandeAnnonce': bandeAnnonce,
      if (classification != null) 'classification': classification,
      if (noteMoyenne != null) 'noteMoyenne': noteMoyenne,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  @override
  String toString() => 'Film(id: $id, titre: $titre)';
}

class _FilmImpl extends Film {
  _FilmImpl({
    int? id,
    required String titre,
    String? synopsis,
    String? genre,
    required int duree,
    String? realisateur,
    List<String>? casting,
    String? affiche,
    String? bandeAnnonce,
    String? classification,
    double? noteMoyenne,
    required DateTime dateDebut,
    required DateTime dateFin,
    DateTime? createdAt,
  }) : super._(
    id: id,
    titre: titre,
    synopsis: synopsis,
    genre: genre,
    duree: duree,
    realisateur: realisateur,
    casting: casting,
    affiche: affiche,
    bandeAnnonce: bandeAnnonce,
    classification: classification,
    noteMoyenne: noteMoyenne,
    dateDebut: dateDebut,
    dateFin: dateFin,
    createdAt: createdAt,
  );
}