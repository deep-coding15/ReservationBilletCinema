import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_billet_cinema/core/network/serverpod_provider.dart';
import 'package:reservation_billet_cinema/features/profil/data/repositories/profil_repository_impl.dart';
import 'package:reservation_billet_cinema/features/profil/domain/repositories/profil_repository.dart';

// ── State ────────────────────────────────────────────────────────────────────
class ProfilState {
  final bool isLoading;
  final String? error;
  final Utilisateur? utilisateur;
  final List<Favori> favoris;

  const ProfilState({
    this.isLoading = false,
    this.error,
    this.utilisateur,
    this.favoris = const [],
  });

  ProfilState copyWith({
    bool? isLoading,
    String? error,
    Utilisateur? utilisateur,
    List<Favori>? favoris,
  }) {
    return ProfilState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      utilisateur: utilisateur ?? this.utilisateur,
      favoris: favoris ?? this.favoris,
    );
  }
}

// ── Notifier ─────────────────────────────────────────────────────────────────
class ProfilNotifier extends StateNotifier<ProfilState> {
  final ProfilRepository _repository;

  ProfilNotifier(this._repository) : super(const ProfilState());

  Future<void> loadProfil() async {
    state = state.copyWith(isLoading: true);
    try {
      final utilisateur = await _repository.getProfil();
      final favoris = await _repository.getFavoris();
      state = state.copyWith(
        isLoading: false,
        utilisateur: utilisateur,
        favoris: favoris,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseError(e),
      );
    }
  }

  Future<bool> updateProfil({
    required String nom,
    required String telephone,
    List<String>? preferences,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final updated = await _repository.updateProfil(
        nom: nom,
        telephone: telephone,
        preferences: preferences,
      );
      state = state.copyWith(isLoading: false, utilisateur: updated);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _parseError(e));
      return false;
    }
  }

  Future<void> ajouterFavori(int cinemaId) async {
    try {
      await _repository.ajouterFavori(cinemaId);
      await loadProfil();
    } catch (e) {
      state = state.copyWith(error: _parseError(e));
    }
  }

  Future<void> supprimerFavori(int cinemaId) async {
    try {
      await _repository.supprimerFavori(cinemaId);
      state = state.copyWith(
        favoris: state.favoris.where((f) => f.cinemaId != cinemaId).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: _parseError(e));
    }
  }

  String _parseError(dynamic e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('non authentifié')) return 'Session expirée, reconnectez-vous';
    if (msg.contains('connection')) return 'Erreur de connexion au serveur';
    return 'Une erreur est survenue';
  }
}

// ── Providers ────────────────────────────────────────────────────────────────
final profilRepositoryProvider = Provider<ProfilRepository>((ref) {
  final client = ref.watch(serverpodClientProvider);
  return ProfilRepositoryImpl(client);
});

final profilProvider =
StateNotifierProvider<ProfilNotifier, ProfilState>((ref) {
  final repository = ref.watch(profilRepositoryProvider);
  return ProfilNotifier(repository);
});