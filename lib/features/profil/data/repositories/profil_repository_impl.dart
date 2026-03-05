import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/features/profil/domain/repositories/profil_repository.dart';

/// Stub tant que l'endpoint profil n'existe pas côté client Serverpod.
class ProfilRepositoryImpl implements ProfilRepository {
  final Client _client;
  ProfilRepositoryImpl(this._client);

  @override
  Future<Utilisateur?> getProfil() async => null;

  @override
  Future<Utilisateur?> updateProfil({
    required String nom,
    required String telephone,
    List<String>? preferences,
  }) async => null;

  @override
  Future<List<Favori>> getFavoris() async => const [];

  @override
  Future<void> ajouterFavori(int cinemaId) async {}

  @override
  Future<void> supprimerFavori(int cinemaId) async {}
}