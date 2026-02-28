import 'package:reservation_billet_cinema/features/auth/domain/repositories/auth_repository.dart';

/// Implémentation du repository d'authentification (appels Serverpod).
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> login(String email, String password) async {
    // TODO: appeler client.auth.login(...)
  }

  @override
  Future<void> register(String email, String password, String nom) async {
    // TODO: appeler client.auth.register(...)
  }

  @override
  Future<void> logout() async {
    // TODO: déconnexion
  }
}
