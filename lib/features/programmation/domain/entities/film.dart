/// Entité Film (côté client).
class Film {
  Film({
    required this.id,
    required this.titre,
    required this.synopsis,
    required this.genre,
    required this.duree,
    required this.realisateur,
    this.affiche,
    this.noteMoyenne = 0.0,
  });

  final int id;
  final String titre;
  final String synopsis;
  final String genre;
  final int duree;
  final String realisateur;
  final String? affiche;
  final double noteMoyenne;
}
