import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/network/serverpod_provider.dart';

/// Repository Films : appelle l'endpoint Serverpod films.
class FilmsRepository {
  FilmsRepository(this._client);

  final Client _client;

  Future<List<Film>> getFilms({String? search, String? genre}) async {
    return _client.films.getFilms(search: search, genre: genre);
  }

  Future<Film?> getFilmById(int id) async {
    return _client.films.getFilmById(id);
  }

  Future<List<Seance>> getSeancesByFilm(int filmId) async {
    return _client.films.getSeancesByFilm(filmId);
  }

  Future<List<Cinema>> getCinemas({String? ville}) async {
    return _client.films.getCinemas(ville: ville);
  }
}

final filmsRepositoryProvider = Provider<FilmsRepository>((ref) {
  final client = ref.watch(serverpodClientProvider);
  return FilmsRepository(client);
});
