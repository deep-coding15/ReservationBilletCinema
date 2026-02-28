/// Contrat du repository d'authentification.
abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> register(String email, String password, String nom);
  Future<void> logout();
}
