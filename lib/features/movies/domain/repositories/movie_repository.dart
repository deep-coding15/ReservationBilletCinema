import 'package:reservation_billet_cinema/features/movies/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMovies();
}