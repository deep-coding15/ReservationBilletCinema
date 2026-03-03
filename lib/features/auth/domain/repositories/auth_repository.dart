import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

/// Contrat du repository d'authentification.
abstract class AuthRepository {
  // Login
  Future<AuthSuccess> login(String email, String password);

  // Register (3 étapes Serverpod emailIdp)
  Future<UuidValue> startRegistration(String email);
  Future<String> verifyRegistrationCode(
      UuidValue accountRequestId, String verificationCode);
  Future<AuthSuccess> finishRegistration(
      String registrationToken, String password);

  // Sauvegarder profil après inscription
  Future<void> saveProfile({
    required String nom,
    required String email,
    String? telephone,
    DateTime? dateNaissance,
  });

  // Reset password (3 étapes)
  Future<UuidValue> startPasswordReset(String email);
  Future<String> verifyPasswordResetCode(
      UuidValue passwordResetRequestId, String verificationCode);
  Future<void> finishPasswordReset(
      String finishPasswordResetToken, String newPassword);

  // Logout
  Future<void> logout();
}