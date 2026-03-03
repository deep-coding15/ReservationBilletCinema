import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AdminFilmsEndpoint extends Endpoint {
  Future<List<Film>> getFilms(Session session) async {
    return await Film.db.find(
      session,
      orderBy: (t) => t.date_debut,
      orderDescending: true,
    );
  }

  Future<Film> createFilm(Session session, Film film) async {
    return await Film.db.insertRow(session, film);
  }

  Future<Film> updateFilm(Session session, Film film) async {
    return await Film.db.updateRow(session, film);
  }

  Future<void> deleteFilm(Session session, int id) async {
    final film = await Film.db.findById(session, id);
    if (film != null) {
      await Film.db.deleteRow(session, film);
    }
  }
}
