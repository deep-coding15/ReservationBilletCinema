import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_billet_cinema/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:reservation_billet_cinema/features/movies/domain/entities/movie.dart';
import 'package:reservation_billet_cinema/features/movies/domain/repositories/movie_repository.dart';
import 'package:reservation_billet_cinema/features/movies/domain/usecases/get_movies.dart';

/// Repository Provider
final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepositoryImpl();
});

/// UseCase Provider
final getMoviesProvider = Provider<GetMovies>((ref) {
  final repository = ref.read(movieRepositoryProvider);
  return GetMovies(repository);
});

/// Movies Future Provider
final moviesProvider = FutureProvider<List<Movie>>((ref) async {
  final getMovies = ref.read(getMoviesProvider);
  return getMovies();
});