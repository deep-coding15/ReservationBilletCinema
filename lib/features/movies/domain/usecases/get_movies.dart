import 'package:reservation_billet_cinema/features/movies/domain/entities/movie.dart';
import 'package:reservation_billet_cinema/features/movies/domain/repositories/movie_repository.dart';

class GetMovies {
  final MovieRepository repository;

  GetMovies(this.repository);

  Future<List<Movie>> call() {
    return repository.getMovies();
  }
}