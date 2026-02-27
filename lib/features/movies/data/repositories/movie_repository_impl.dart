import 'package:reservation_billet_cinema/features/movies/domain/entities/movie.dart';
import 'package:reservation_billet_cinema/features/movies/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  @override
  Future<List<Movie>> getMovies() async {
    return [
      Movie(id: "1", title: "Film1: Interstellar"),
      Movie(id: "2", title: "Film2: Inception"),
    ];
  }
}