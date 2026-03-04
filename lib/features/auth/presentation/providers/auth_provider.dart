import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';
import 'package:reservation_billet_cinema/core/network/serverpod_provider.dart';
import 'package:reservation_billet_cinema/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:reservation_billet_cinema/features/auth/domain/repositories/auth_repository.dart';

// ── Repository provider ──────────────────────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(serverpodClientProvider);
  return AuthRepositoryImpl(client);
});

// ── State ────────────────────────────────────────────────────────────────────
class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final UuidValue? accountRequestId;
  final String? registrationToken;
  final UuidValue? passwordResetRequestId;
  final String? resetToken;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.accountRequestId,
    this.registrationToken,
    this.passwordResetRequestId,
    this.resetToken,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    UuidValue? accountRequestId,
    String? registrationToken,
    UuidValue? passwordResetRequestId,
    String? resetToken,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      accountRequestId: accountRequestId ?? this.accountRequestId,
      registrationToken: registrationToken ?? this.registrationToken,
      passwordResetRequestId:
      passwordResetRequestId ?? this.passwordResetRequestId,
      resetToken: resetToken ?? this.resetToken,
    );
  }
}

// ── Notifier ─────────────────────────────────────────────────────────────────
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  AuthNotifier(this._repo) : super(const AuthState());

  // LOGIN
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.login(email, password);
      state = state.copyWith(isLoading: false, isAuthenticated: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _msg(e));
      return false;
    }
  }

  // REGISTER étape 1 : envoie code email
  Future<bool> startRegistration(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final id = await _repo.startRegistration(email);
      state = state.copyWith(isLoading: false, accountRequestId: id);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _msg(e));
      return false;
    }
  }

  // REGISTER étape 2 : vérifie le code
  Future<bool> verifyRegistrationCode(String code) async {
    if (state.accountRequestId == null) return false;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await _repo.verifyRegistrationCode(
          state.accountRequestId!, code);
      state = state.copyWith(isLoading: false, registrationToken: token);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _msg(e));
      return false;
    }
  }

  // REGISTER étape 3 : finalise + sauvegarde profil
  Future<bool> finishRegistration({
    required String password,
    required String nom,
    required String email,
    String? telephone,
    DateTime? dateNaissance,
  }) async {
    if (state.registrationToken == null) return false;
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.finishRegistration(state.registrationToken!, password);
      // Attendre que le token soit bien enregistré
      await Future.delayed(const Duration(milliseconds: 300));
      await _repo.saveProfile(
        nom: nom,
        email: email,
        telephone: telephone,
        dateNaissance: dateNaissance,
      );
      state = state.copyWith(isLoading: false, isAuthenticated: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _msg(e));
      return false;
    }
  }

  // RESET PASSWORD étape 1
  Future<bool> startPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final id = await _repo.startPasswordReset(email);
      state = state.copyWith(isLoading: false, passwordResetRequestId: id);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _msg(e));
      return false;
    }
  }

  // RESET PASSWORD étape 2
  Future<bool> verifyPasswordResetCode(String code) async {
    if (state.passwordResetRequestId == null) return false;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await _repo.verifyPasswordResetCode(
          state.passwordResetRequestId!, code);
      state = state.copyWith(isLoading: false, resetToken: token);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _msg(e));
      return false;
    }
  }

  // RESET PASSWORD étape 3
  Future<bool> finishPasswordReset(String newPassword) async {
    if (state.resetToken == null) return false;
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.finishPasswordReset(state.resetToken!, newPassword);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _msg(e));
      return false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState();
  }

  String _msg(dynamic e) {
    final s = e.toString().toLowerCase();
    if (s.contains('invalid') || s.contains('credentials'))
      return 'Email ou mot de passe incorrect.';
    if (s.contains('already') || s.contains('exists'))
      return 'Cet email est déjà utilisé.';
    if (s.contains('expired')) return 'Le code a expiré. Recommencez.';
    if (s.contains('too many')) return 'Trop de tentatives. Réessayez.';
    return 'Une erreur est survenue. Réessayez.';
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────
final authProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});