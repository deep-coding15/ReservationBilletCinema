import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/programmation/data/repositories/films_repository.dart';
import 'package:reservation_billet_cinema/features/programmation/presentation/pages/film_detail_page.dart';

/// Page liste des films : recherche, filtre genre, cartes cliquables.
class FilmsListPage extends ConsumerStatefulWidget {
  const FilmsListPage({super.key});

  @override
  ConsumerState<FilmsListPage> createState() => _FilmsListPageState();
}

class _FilmsListPageState extends ConsumerState<FilmsListPage> {
  final _searchController = TextEditingController();
  String _search = '';
  String? _genre;
  List<Film> _films = [];
  bool _loading = false;
  String? _error;

  static const List<String> _genres = [
    'Action',
    'Comédie',
    'Drame',
    'Science-fiction',
    'Thriller',
    'Animation',
    'Aventure',
    'Horreur',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() => _search = _searchController.text));
    _loadFilms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFilms() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final repo = ref.read(filmsRepositoryProvider);
    try {
      final films = await repo.getFilms(
        search: _search.trim().isEmpty ? null : _search.trim(),
        genre: _genre,
      );
      if (mounted) {
        setState(() {
          _films = films;
          _loading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _films = [];
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  void _onSearchOrGenreChanged() {
    _loadFilms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        title: const Text('Films à l\'affiche'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _onSearchOrGenreChanged(),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un film...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                    prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF1f1f1f),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _GenreChip(
                        label: 'Tous',
                        selected: _genre == null,
                        onTap: () {
                          setState(() => _genre = null);
                          _onSearchOrGenreChanged();
                        },
                      ),
                      ..._genres.map(
                        (g) => _GenreChip(
                          label: g,
                          selected: _genre == g,
                          onTap: () {
                            setState(() => _genre = g);
                            _onSearchOrGenreChanged();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (_search.isNotEmpty || _genre != null)
                  TextButton.icon(
                    onPressed: _loadFilms,
                    icon: const Icon(Icons.refresh_rounded, size: 18, color: Colors.white70),
                    label: const Text('Actualiser', style: TextStyle(color: Colors.white70)),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading && _films.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_error != null && _films.isEmpty) {
      final isConnectionRefused = _error!.toLowerCase().contains('connection refused') ||
          _error!.toLowerCase().contains('socketexception');
      return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'Erreur de chargement',
                  style: TextStyle(color: Colors.red.shade300, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isConnectionRefused) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Sur téléphone : lance le serveur sur ton PC (dart run bin/main.dart dans server/) '
                    'et mets l\'IP de ton PC dans lib/core/constants/api_constants_io.dart (serverHostForMobile).',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.amber.shade200, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _loadFilms,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (_films.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.movie_outlined, size: 64, color: Colors.white.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text(
              'Aucun film trouvé.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Vérifiez la base de données ou les filtres.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadFilms,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: _films.length,
        itemBuilder: (context, index) {
          final film = _films[index];
          return _FilmCard(
            film: film,
            onTap: () => context.push('/films/${film.id}'),
          );
        },
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  const _GenreChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: TextStyle(color: selected ? Colors.black87 : Colors.white70)),
        selected: selected,
        onSelected: (_) => onTap(),
        backgroundColor: const Color(0xFF1f1f1f),
        selectedColor: AppColors.accent,
        checkmarkColor: Colors.black87,
      ),
    );
  }
}

class _FilmCard extends StatelessWidget {
  const _FilmCard({required this.film, required this.onTap});

  final Film film;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1f1f1f),
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: film.affiche != null && film.affiche!.isNotEmpty
                    ? Image.network(
                        film.affiche!,
                        width: 90,
                        height: 130,
                        fit: BoxFit.cover,
                        errorBuilder: (_, Object e, Object? st) => _posterPlaceholder(),
                      )
                    : _posterPlaceholder(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      film.titre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (film.genre != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        film.genre!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      '${film.duree} min',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                    if (film.noteMoyenne != null && film.noteMoyenne! > 0) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.accent, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            film.noteMoyenne!.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _posterPlaceholder() {
    return Container(
      width: 90,
      height: 130,
      color: AppColors.primary.withValues(alpha: 0.3),
      child: Icon(Icons.movie_rounded, size: 40, color: Colors.white.withValues(alpha: 0.5)),
    );
  }
}
