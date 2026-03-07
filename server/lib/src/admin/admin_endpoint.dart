import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint admin : stats dashboard et liste utilisateurs.
class AdminEndpoint extends Endpoint {
  /// Comptes pour le tableau de bord (films, événements, séances, utilisateurs).
  Future<Map<String, dynamic>> getDashboardStats(Session session) async {
    final filmsResult = await session.db.unsafeQuery(
      r'SELECT COUNT(*) AS c FROM films WHERE CURRENT_DATE BETWEEN date_debut AND date_fin',
    );
    final eventsResult = await session.db.unsafeQuery(
      r'SELECT COUNT(*) AS c FROM evenements WHERE date_heure >= CURRENT_TIMESTAMP',
    );
    final seancesResult = await session.db.unsafeQuery(
      r'SELECT COUNT(*) AS c FROM seances WHERE date_heure >= CURRENT_TIMESTAMP',
    );
    final usersResult = await session.db.unsafeQuery(
      r'SELECT COUNT(*) AS c FROM users',
    );

    int filmsCount = 0, eventsCount = 0, seancesCount = 0, usersCount = 0;
    if (filmsResult.isNotEmpty) filmsCount = (filmsResult.first.first as num?)?.toInt() ?? 0;
    if (eventsResult.isNotEmpty) eventsCount = (eventsResult.first.first as num?)?.toInt() ?? 0;
    if (seancesResult.isNotEmpty) seancesCount = (seancesResult.first.first as num?)?.toInt() ?? 0;
    if (usersResult.isNotEmpty) usersCount = (usersResult.first.first as num?)?.toInt() ?? 0;

    return {
      'filmsCount': filmsCount,
      'eventsCount': eventsCount,
      'seancesCount': seancesCount,
      'usersCount': usersCount,
    };
  }

  /// Liste des utilisateurs (admin).
  Future<List<Utilisateur>> getUsers(Session session) async {
    return await Utilisateur.db.find(
      session,
      orderBy: (u) => u.id,
    );
  }
}
