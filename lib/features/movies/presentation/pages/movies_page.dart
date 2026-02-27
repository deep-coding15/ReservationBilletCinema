import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_billet_cinema/features/movies/presentation/providers/movies_provider.dart';

class MoviesPage extends ConsumerWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(moviesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Movies")),
      body: moviesAsync.when(
        data: (movies) => ListView(
          children: movies
              .map((movie) => ListTile(title: Text(movie.title)))
              .toList(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error")),
      ),
    );
  }
}