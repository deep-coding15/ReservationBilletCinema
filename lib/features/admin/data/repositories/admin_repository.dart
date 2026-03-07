import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/network/serverpod_provider.dart';

/// Repository admin : stats dashboard et liste utilisateurs.
class AdminRepository {
  AdminRepository(this._client);

  final Client _client;

  /// Comptes pour le tableau de bord (films, événements, séances, utilisateurs).
  Future<Map<String, int>> getDashboardStats() async {
    final map = await _client.admin.getDashboardStats();
    return {
      'filmsCount': (map['filmsCount'] as num?)?.toInt() ?? 0,
      'eventsCount': (map['eventsCount'] as num?)?.toInt() ?? 0,
      'seancesCount': (map['seancesCount'] as num?)?.toInt() ?? 0,
      'usersCount': (map['usersCount'] as num?)?.toInt() ?? 0,
    };
  }

  /// Liste des utilisateurs.
  Future<List<Utilisateur>> getUsers() async {
    return _client.admin.getUsers();
  }
}

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final client = ref.watch(serverpodClientProvider);
  return AdminRepository(client);
});
