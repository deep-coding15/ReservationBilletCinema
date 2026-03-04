import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/features/profil/domain/repositories/profil_repository.dart';

class ProfilRepositoryImpl implements ProfilRepository {
  final Client _client;
  ProfilRepositoryImpl(this._client);

  @override
  Future<Utilisateur?> getProfil() async {
    return await _client.profil.getProfil();
  }

  @override
  Future<Utilisateur?> updateProfil({
    required String nom,
    required String telephone,
    List<String>? preferences,
  }) async {
    return await _client.profil.updateProfil(
      nom: nom,
      telephone: telephone,
      preferences: preferences,
    );
  }

  @override
  Future<List<Favori>> getFavoris() async {
    return await _client.profil.getFavoris();
  }

  @override
  Future<void> ajouterFavori(int cinemaId) async {
    await _client.profil.ajouterFavori(cinemaId: cinemaId);
  }

  @override
  Future<void> supprimerFavori(int cinemaId) async {
    await _client.profil.supprimerFavori(cinemaId: cinemaId);
  }
}