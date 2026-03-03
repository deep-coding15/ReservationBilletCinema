import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/programmation/data/repositories/films_repository.dart';
import 'package:go_router/go_router.dart';

enum _SearchContentType { all, films, events }

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _search = '';
  String? _genre;
  String? _selectedVille;
  String? _selectedCinemaName;
  DateTime? _selectedDate;
  _SearchContentType _contentType = _SearchContentType.all;

  List<Cinema> _cinemas = [];
  List<_FilmWithSeances> _results = [];
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
    _initData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    final repo = ref.read(filmsRepositoryProvider);
    try {
      final cinemas = await repo.getCinemas();
      if (mounted) {
        setState(() {
          _cinemas = cinemas;
        });
      }
      await _runSearch();
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    }
  }

  List<String> get _villes {
    final set = <String>{};
    for (final c in _cinemas) {
      if (c.ville != null && c.ville!.isNotEmpty) set.add(c.ville!);
    }
    final list = set.toList()..sort();
    return list;
  }

  List<Cinema> get _cinemasForVille {
    if (_selectedVille == null) return _cinemas;
    return _cinemas.where((c) => c.ville == _selectedVille).toList()..sort((a, b) => a.nom.compareTo(b.nom));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _selectedDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      await _runSearch();
    }
  }

  Future<void> _runSearch() async {
    // Pour l'instant, la recherche est branchée uniquement sur les films.
    // Le mode \"Événements\" sera connecté dès que la base événements sera en place.
    if (_contentType == _SearchContentType.events) {
      setState(() {
        _results = [];
        _loading = false;
        _error = null;
      });
      return;
    }

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

      final List<_FilmWithSeances> withSeances = [];
      for (final film in films) {
        final seances = await repo.getSeancesByFilm(film.id!);
        final filteredSeances = seances.where((s) {
          // Filtre ville / cinéma
          if (_selectedVille != null) {
            final cinemaNamesForVille = _cinemas
                .where((c) => c.ville == _selectedVille)
                .map((c) => c.nom)
                .toSet();
            if (s.cinemaNom == null || !cinemaNamesForVille.contains(s.cinemaNom)) {
              return false;
            }
          }
          if (_selectedCinemaName != null) {
            if (s.cinemaNom != _selectedCinemaName) return false;
          }
          // Filtre date (même jour)
          if (_selectedDate != null && s.dateHeure != null) {
            final d = s.dateHeure!;
            final sameDay = d.year == _selectedDate!.year &&
                d.month == _selectedDate!.month &&
                d.day == _selectedDate!.day;
            if (!sameDay) return false;
          }
          return true;
        }).toList();

        if (_selectedVille == null &&
            _selectedCinemaName == null &&
            _selectedDate == null) {
          // Pas de filtre sur les séances : garder le film même sans séance filtrée
          withSeances.add(_FilmWithSeances(film: film, seances: seances));
        } else if (filteredSeances.isNotEmpty) {
          withSeances.add(_FilmWithSeances(film: film, seances: filteredSeances));
        }
      }

      if (mounted) {
        setState(() {
          _results = withSeances;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
          _results = [];
        });
      }
    }
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _genre = null;
      _selectedVille = null;
      _selectedCinemaName = null;
      _selectedDate = null;
    });
    _runSearch();
  }

  @override
  Widget build(BuildContext context) {
    final villes = _villes;
    final cinemasForVille = _cinemasForVille;
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Recherche avancée'),
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
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Tous'),
                      selected: _contentType == _SearchContentType.all,
                      onSelected: (_) {
                        setState(() => _contentType = _SearchContentType.all);
                        _runSearch();
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Films'),
                      selected: _contentType == _SearchContentType.films,
                      onSelected: (_) {
                        setState(() => _contentType = _SearchContentType.films);
                        _runSearch();
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Événements'),
                      selected: _contentType == _SearchContentType.events,
                      onSelected: (_) {
                        setState(() => _contentType = _SearchContentType.events);
                        _runSearch();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _runSearch(),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un film ou un événement...',
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
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Tous les genres'),
                      selected: _genre == null,
                      onSelected: (_) {
                        setState(() => _genre = null);
                        _runSearch();
                      },
                    ),
                    ..._genres.map(
                      (g) => ChoiceChip(
                        label: Text(g),
                        selected: _genre == g,
                        onSelected: (_) {
                          setState(() => _genre = g);
                          _runSearch();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        dropdownColor: const Color(0xFF1f1f1f),
                        decoration: _dropdownDecoration('Ville'),
                        value: _selectedVille,
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('Toutes les villes'),
                          ),
                          ...villes.map(
                            (v) => DropdownMenuItem<String>(
                              value: v,
                              child: Text(v),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedVille = value;
                            _selectedCinemaName = null;
                          });
                          _runSearch();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        dropdownColor: const Color(0xFF1f1f1f),
                        decoration: _dropdownDecoration('Cinéma'),
                        value: _selectedCinemaName,
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('Tous les cinémas'),
                          ),
                          ...cinemasForVille.map(
                            (c) => DropdownMenuItem<String>(
                              value: c.nom,
                              child: Text(c.nom),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedCinemaName = value);
                          _runSearch();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today_rounded, size: 18),
                        label: Text(
                          _selectedDate == null
                              ? 'Toutes les dates'
                              : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    TextButton.icon(
                      onPressed: _resetFilters,
                      icon: const Icon(Icons.refresh_rounded, size: 18, color: Colors.white70),
                      label: const Text('Réinitialiser', style: TextStyle(color: Colors.white70)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF1f1f1f),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildResults() {
    if (_contentType == _SearchContentType.events) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event_available_rounded, size: 64, color: Colors.white.withValues(alpha: 0.8)),
              const SizedBox(height: 16),
              const Text(
                'Recherche d\'événements',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'L\'interface est prête, la recherche sera connectée\nau module \"Événements\" dès que la base sera créée.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                'Erreur lors de la recherche',
                style: TextStyle(color: Colors.red.shade300, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _runSearch,
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.white.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text(
              'Aucun résultat trouvé.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Modifiez vos filtres (ville, cinéma, date, genre).',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _runSearch,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final item = _results[index];
          return _SearchResultCard(item: item);
        },
      ),
    );
  }
}

class _FilmWithSeances {
  _FilmWithSeances({required this.film, required this.seances});

  final Film film;
  final List<Seance> seances;
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.item});

  final _FilmWithSeances item;

  @override
  Widget build(BuildContext context) {
    final film = item.film;
    final seances = item.seances;
    return Card(
      color: const Color(0xFF1f1f1f),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => context.push('/films/${film.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
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
              ),
              if (film.genre != null) ...[
                const SizedBox(height: 4),
                Text(
                  film.genre!,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                ),
              ],
              const SizedBox(height: 6),
              Text(
                '${film.duree} min',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
              ),
              const SizedBox(height: 8),
              if (seances.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: seances.take(4).map((s) {
                    final cinema = s.cinemaNom ?? 'Cinéma';
                    final salle = s.salleCode ?? '';
                    String label = cinema;
                    if (salle.isNotEmpty) label = '$cinema • $salle';
                    if (s.dateHeure != null) {
                      final d = s.dateHeure!;
                      final hh = d.hour.toString().padLeft(2, '0');
                      final mm = d.minute.toString().padLeft(2, '0');
                      label = '$label • $hh:$mm';
                    }
                    return Chip(
                      label: Text(label, style: const TextStyle(fontSize: 11)),
                      backgroundColor: const Color(0xFF2a2a2a),
                    );
                  }).toList(),
                )
              else
                Text(
                  'Aucune séance trouvée avec ces filtres.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

