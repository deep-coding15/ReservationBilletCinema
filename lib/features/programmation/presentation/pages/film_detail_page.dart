import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/programmation/data/repositories/films_repository.dart';

/// Page détail d'un film : synopsis, séances, bouton réserver.
class FilmDetailPage extends ConsumerStatefulWidget {
  const FilmDetailPage({super.key, required this.filmId});

  final int filmId;

  @override
  ConsumerState<FilmDetailPage> createState() => _FilmDetailPageState();
}

class _FilmDetailPageState extends ConsumerState<FilmDetailPage> {
  Film? _film;
  List<Seance> _seances = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(filmsRepositoryProvider);
    try {
      final film = await repo.getFilmById(widget.filmId);
      final seances = await repo.getSeancesByFilm(widget.filmId);
      if (mounted) {
        setState(() {
          _film = film;
          _seances = seances;
          _loading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Détail film'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null || _film == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Détail film'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _error ?? 'Film introuvable',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.go('/films'),
                  child: const Text('Retour aux films'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final film = _film!;
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        title: Text(film.titre),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (film.affiche != null && film.affiche!.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    film.affiche!,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, Object e, Object? st) => _placeholderPoster(film.titre),
                  ),
                ),
              )
            else
              _placeholderPoster(film.titre),
            const SizedBox(height: 20),
            Text(
              film.titre,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (film.genre != null)
              Text(
                film.genre!,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
            if (film.noteMoyenne != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.accent, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    film.noteMoyenne!.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            if (film.synopsis != null && film.synopsis!.isNotEmpty) ...[
              const Text(
                'Synopsis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                film.synopsis!,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
            ],
            const Text(
              'Séances',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (_seances.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Aucune séance à venir.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                ),
              )
            else
              ..._seances.map((s) => _SeanceTile(
                    seance: s,
                    onReserve: () => context.push('/reservation', extra: s),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _placeholderPoster(String title) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.movie_rounded, size: 64, color: Colors.white.withValues(alpha: 0.5)),
    );
  }
}

class _SeanceTile extends StatelessWidget {
  const _SeanceTile({required this.seance, required this.onReserve});

  final Seance seance;
  final VoidCallback onReserve;

  @override
  Widget build(BuildContext context) {
    final date = seance.dateHeure;
    final dateStr = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return Card(
      color: const Color(0xFF1f1f1f),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(
          '${seance.cinemaNom ?? 'Cinéma'} — ${seance.salleCode ?? ''}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '$dateStr • ${seance.prix.toStringAsFixed(0)} DH • ${seance.placesDisponibles} places',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
        ),
        trailing: FilledButton(
          onPressed: onReserve,
          style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Réserver'),
        ),
      ),
    );
  }
}
