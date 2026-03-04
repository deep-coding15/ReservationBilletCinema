import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:reservation_billet_cinema/core/constants/api_constants.dart';

class InMemoryAuthKeyManager extends AuthenticationKeyManager {
  String? _key;

  @override
  Future<String?> get() async => _key;

  @override
  Future<void> put(String key) async {
    _key = key;
    // ignore: avoid_print
    print('🔑 Token sauvegardé: ${key.substring(0, 20)}...');
  }

  @override
  Future<void> remove() async {
    _key = null;
    // ignore: avoid_print
    print('🔑 Token supprimé');
  }

  @override
  @override
  Future<String?> toHeaderValue(String? key) async {
    if (key == null) return null;
    return 'Bearer $key';
  }
}

// Instance GLOBALE et UNIQUE partagée dans toute l'app
final globalAuthKeyManager = InMemoryAuthKeyManager();

final serverpodClientProvider = Provider<Client>((ref) {
  return Client(
    ApiConstants.baseUrl,
    authenticationKeyManager: globalAuthKeyManager,
  );
});