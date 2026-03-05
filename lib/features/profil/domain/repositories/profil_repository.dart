import 'package:cinema_reservation_client/cinema_reservation_client.dart';

/// Modèle simple pour un favori (pas encore branché à l'API).
class Favori {
  final int cinemaId;
  const Favori({required this.cinemaId});
}

abstract class ProfilRepository {
  Future<Utilisateur?> getProfil();
  Future<Utilisateur?> updateProfil({
    required String nom,
    required String telephone,
    List<String>? preferences,
  });
  Future<List<Favori>> getFavoris();
  Future<void> ajouterFavori(int cinemaId);
  Future<void> supprimerFavori(int cinemaId);
}