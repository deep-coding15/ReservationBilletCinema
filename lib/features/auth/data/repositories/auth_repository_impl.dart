import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';
import 'package:reservation_billet_cinema/core/network/serverpod_provider.dart';
import 'package:reservation_billet_cinema/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Client _client;
  AuthRepositoryImpl(this._client);

  @override
  Future<AuthSuccess> login(String email, String password) async {
    final result = await _client.emailIdp.login(
      email: email,
      password: password,
    );
    await globalAuthKeyManager.put(result.token);
    return result;
  }

  @override
  Future<UuidValue> startRegistration(String email) async {
    return await _client.emailIdp.startRegistration(email: email);
  }

  @override
  Future<String> verifyRegistrationCode(
      UuidValue accountRequestId, String verificationCode) async {
    return await _client.emailIdp.verifyRegistrationCode(
      accountRequestId: accountRequestId,
      verificationCode: verificationCode,
    );
  }

  @override
  Future<AuthSuccess> finishRegistration(
      String registrationToken, String password) async {
    final result = await _client.emailIdp.finishRegistration(
      registrationToken: registrationToken,
      password: password,
    );
    await globalAuthKeyManager.put(result.token);
    return result;
  }

  @override
  Future<void> saveProfile({
    required String nom,
    required String email,
    String? telephone,
    DateTime? dateNaissance,
  }) async {
    await _client.auth.saveProfile(
      nom: nom,
      email: email,
      telephone: telephone,
      dateNaissance: dateNaissance,
    );
  }

  @override
  Future<UuidValue> startPasswordReset(String email) async {
    return await _client.emailIdp.startPasswordReset(email: email);
  }

  @override
  Future<String> verifyPasswordResetCode(
      UuidValue passwordResetRequestId, String verificationCode) async {
    return await _client.emailIdp.verifyPasswordResetCode(
      passwordResetRequestId: passwordResetRequestId,
      verificationCode: verificationCode,
    );
  }

  @override
  Future<void> finishPasswordReset(
      String finishPasswordResetToken, String newPassword) async {
    await _client.emailIdp.finishPasswordReset(
      finishPasswordResetToken: finishPasswordResetToken,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> logout() async {
    await globalAuthKeyManager.remove();
  }
}