import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/programmation/data/repositories/films_repository.dart';

/// Page détail d'un film : cinéma, ville, date, genre, type, synopsis, séances, bouton réserver.
class FilmDetailPage extends ConsumerStatefulWidget {
  const FilmDetailPage({super.key, required this.filmId, this.cinema});

  final int filmId;
  final Cinema? cinema;

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
        backgroundColor: const Color(0xFF0d0d0d),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
          title: const Text('Détail film'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null || _film == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0d0d0d),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
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
            // Affiche principale (grande photo)
            if (film.affiche != null && film.affiche!.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    film.affiche!,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, Object e, Object? st) => _placeholderPoster(film.titre),
                  ),
                ),
              )
            else
              _placeholderPoster(film.titre),
            if (film.bandeAnnonce != null && film.bandeAnnonce!.isNotEmpty) ...[
              const SizedBox(height: 12),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.neon.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.play_circle_filled_rounded, color: AppColors.neon, size: 40),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Bande-annonce',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(Icons.open_in_new_rounded, color: Colors.white54, size: 20),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            if (widget.cinema != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.neon.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.neon.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: AppColors.neon, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.cinema!.nom} • ${widget.cinema!.ville ?? ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              film.titre,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (film.genre != null)
                  Chip(
                    label: Text(film.genre!, style: const TextStyle(fontSize: 12)),
                    backgroundColor: AppColors.neon.withValues(alpha: 0.2),
                    side: const BorderSide(color: AppColors.neon),
                  ),
                if (film.classification != null)
                  Chip(
                    label: Text(film.classification!, style: const TextStyle(fontSize: 11)),
                    backgroundColor: Colors.white12,
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                Text('${film.duree} min', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
              ],
            ),
            if (film.noteMoyenne != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.accent, size: 24),
                  const SizedBox(width: 6),
                  Text(
                    film.noteMoyenne!.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
            // Réalisateur
            if (film.realisateur != null && film.realisateur!.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Réalisateur',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                film.realisateur!,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 15,
                ),
              ),
            ],
            // Casting (acteurs)
            if (film.casting != null && film.casting!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Distribution',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: film.casting!.map((a) => Chip(
                  label: Text(a, style: const TextStyle(fontSize: 12)),
                  backgroundColor: const Color(0xFF252525),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                )).toList(),
              ),
            ],
            const SizedBox(height: 20),
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
          '$dateStr • ${seance.prix.toStringAsFixed(0)} DH • ${seance.placesDisponibles} places${seance.typeProjection != null || seance.langue != null ? " • ${seance.typeProjection ?? seance.langue ?? ''}" : ''}',
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
