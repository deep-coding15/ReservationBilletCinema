/// Entité Séance.
class Seance {
  Seance({
    required this.id,
    required this.filmId,
    required this.dateHeure,
    required this.prix,
    required this.placesDisponibles,
  });

  final int id;
  final int filmId;
  final DateTime dateHeure;
  final double prix;
  final int placesDisponibles;
}
