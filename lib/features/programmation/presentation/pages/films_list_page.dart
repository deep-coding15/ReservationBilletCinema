import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/programmation/data/repositories/films_repository.dart';

/// Page Films : d'abord les cinémas (filtre par ville), puis les films du cinéma choisi (filtres date, genre, type séance).
class FilmsListPage extends ConsumerStatefulWidget {
  const FilmsListPage({super.key});

  @override
  ConsumerState<FilmsListPage> createState() => _FilmsListPageState();
}

class _FilmsListPageState extends ConsumerState<FilmsListPage> {
  List<Cinema> _cinemas = [];
  String? _selectedVille;
  Cinema? _selectedCinema;

  List<Film> _films = [];
  Map<int, List<Seance>> _seancesByFilm = {};
  DateTime? _filterDate;
  String? _filterGenre;
  String? _filterTypeSeance;

  bool _loading = false;
  String? _error;

  static const List<String> _genres = [
    'Action', 'Comédie', 'Drame', 'Science-fiction',
    'Thriller', 'Animation', 'Aventure', 'Horreur',
  ];
  static const List<String> _typesSeance = ['2D', '3D', 'VF', 'VOSTFR'];

  @override
  void initState() {
    super.initState();
    _loadCinemas();
  }

  List<String> get _villes {
    final set = <String>{};
    for (final c in _cinemas) {
      if (c.ville != null && c.ville!.isNotEmpty) set.add(c.ville!);
    }
    return set.toList()..sort();
  }

  /// Cinémas filtrés (côté client aussi, au cas où l'API ne filtre pas).
  List<Cinema> get _filteredCinemas {
    if (_selectedVille == null || _selectedVille!.isEmpty) return _cinemas;
    final q = _selectedVille!.toLowerCase();
    return _cinemas.where((c) => (c.ville ?? '').toLowerCase().contains(q)).toList();
  }

  Future<void> _loadCinemas() async {
    setState(() { _loading = true; _error = null; });
    final repo = ref.read(filmsRepositoryProvider);
    try {
      final list = await repo.getCinemas(ville: _selectedVille);
      if (mounted) {
        setState(() { _cinemas = list; _loading = false; });
      }
    } catch (e) {
      if (mounted) {
        setState(() { _loading = false; _error = e.toString(); });
      }
    }
  }

  Future<void> _loadFilmsForCinema() async {
    if (_selectedCinema == null) return;
    setState(() { _loading = true; _error = null; _films = []; _seancesByFilm = {}; });
    final repo = ref.read(filmsRepositoryProvider);
    try {
      final seances = await repo.getSeancesByCinema(
        _selectedCinema!.id!,
        date: _filterDate,
      );
      final filmIds = seances.map((s) => s.filmId).toSet();
      final Map<int, List<Seance>> byFilm = {};
      for (final s in seances) {
        byFilm.putIfAbsent(s.filmId, () => []).add(s);
      }
      final List<Film> films = [];
      for (final id in filmIds) {
        final f = await repo.getFilmById(id);
        if (f != null) films.add(f);
      }
      if (mounted) {
        setState(() {
          _films = films;
          _seancesByFilm = byFilm;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() { _loading = false; _error = e.toString(); });
      }
    }
  }

  List<Film> get _filteredFilms {
    var list = _films;
    if (_filterGenre != null && _filterGenre!.isNotEmpty) {
      list = list.where((f) => f.genre == _filterGenre).toList();
    }
    if (_filterTypeSeance != null && _filterTypeSeance!.isNotEmpty) {
      list = list.where((f) {
        final seances = _seancesByFilm[f.id!] ?? [];
        return seances.any((s) =>
          s.typeProjection == _filterTypeSeance || s.langue == _filterTypeSeance);
      }).toList();
    }
    return list;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _filterDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _filterDate = picked);
      await _loadFilmsForCinema();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(_selectedCinema == null ? Icons.menu_rounded : Icons.arrow_back_rounded),
          onPressed: () {
            if (_selectedCinema != null) {
              setState(() {
                _selectedCinema = null;
                _films = [];
                _seancesByFilm = {};
                _filterDate = null;
                _filterGenre = null;
                _filterTypeSeance = null;
              });
            } else {
              Scaffold.of(context).openDrawer();
            }
          },
        ),
        title: Text(_selectedCinema == null
            ? 'Films'
            : 'Films — ${_selectedCinema!.nom}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _selectedCinema == null ? _buildCinemasBody() : _buildFilmsBody(),
    );
  }

  Widget _buildCinemasBody() {
    if (_loading && _cinemas.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_error != null && _cinemas.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: _loadCinemas, child: const Text('Réessayer')),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choisir une ville',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String?>(
                value: _selectedVille,
                dropdownColor: const Color(0xFF1f1f1f),
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1f1f1f),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _selectedVille != null ? AppColors.neon : Colors.white24,
                      width: _selectedVille != null ? 2 : 1,
                    ),
                  ),
                ),
                hint: Text('Toutes les villes', style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Toutes les villes', style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                  ),
                  ..._villes.map((v) => DropdownMenuItem<String?>(
                    value: v,
                    child: Text(v, style: const TextStyle(color: Colors.white)),
                  )),
                ],
                onChanged: (v) {
                  setState(() => _selectedVille = v);
                  _loadCinemas(); // Appliqué instantanément à la sélection
                },
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              const Text(
                'Cinémas disponibles',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredCinemas.isEmpty
              ? const Center(child: Text('Aucun cinéma trouvé.', style: TextStyle(color: Colors.white70)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredCinemas.length,
                  itemBuilder: (context, i) {
                    final c = _filteredCinemas[i];
                    return Card(
                      color: const Color(0xFF1f1f1f),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.movie_filter_rounded, color: Colors.white),
                        ),
                        title: Text(c.nom, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        subtitle: Text(c.ville ?? '', style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
                        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white54),
                        onTap: () {
                          setState(() => _selectedCinema = c);
                          _loadFilmsForCinema();
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilmsBody() {
    if (_loading && _films.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_error != null && _films.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: _loadFilmsForCinema, child: const Text('Réessayer')),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today_rounded, size: 18),
                      label: Text(
                        _filterDate == null
                            ? 'Toutes les dates'
                            : '${_filterDate!.day.toString().padLeft(2, '0')}/${_filterDate!.month.toString().padLeft(2, '0')}/${_filterDate!.year}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _chip('Tous genres', _filterGenre == null, () => setState(() => _filterGenre = null)),
                    ..._genres.map((g) => _chip(g, _filterGenre == g, () => setState(() => _filterGenre = g))),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _chip('Tous', _filterTypeSeance == null, () => setState(() => _filterTypeSeance = null)),
                    ..._typesSeance.map((t) => _chip(t, _filterTypeSeance == t, () => setState(() => _filterTypeSeance = t))),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredFilms.isEmpty
              ? const Center(child: Text('Aucun film pour ce cinéma / ces filtres.', style: TextStyle(color: Colors.white70)))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: _filteredFilms.length,
                  itemBuilder: (context, i) {
                    final film = _filteredFilms[i];
                    final seances = _seancesByFilm[film.id!] ?? [];
                    return _FilmCard(
                      film: film,
                      seances: seances,
                      onTap: () => context.push('/films/${film.id}', extra: _selectedCinema),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black87 : Colors.white70,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: selected,
        onSelected: (_) => onTap(),
        backgroundColor: const Color(0xFF1f1f1f),
        selectedColor: AppColors.neon,
        side: BorderSide(
          color: selected ? AppColors.neon : Colors.white24,
          width: selected ? 2 : 1,
        ),
      ),
    );
  }
}

class _FilmCard extends StatelessWidget {
  const _FilmCard({required this.film, required this.seances, required this.onTap});

  final Film film;
  final List<Seance> seances;
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
                        errorBuilder: (_, Object e, Object? st) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      film.titre,
                      style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (film.genre != null) ...[
                      const SizedBox(height: 4),
                      Text(film.genre!, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                    ],
                    const SizedBox(height: 4),
                    Text('${film.duree} min', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                    if (seances.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: seances.take(3).map((s) {
                          final time = s.dateHeure != null
                              ? '${s.dateHeure!.hour.toString().padLeft(2, '0')}:${s.dateHeure!.minute.toString().padLeft(2, '0')}'
                              : '';
                          return Chip(
                            label: Text('${s.salleCode ?? ""} $time', style: const TextStyle(fontSize: 11)),
                            backgroundColor: const Color(0xFF2a2a2a),
                          );
                        }).toList(),
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

  Widget _placeholder() {
    return Container(
      width: 90,
      height: 130,
      color: AppColors.primary.withValues(alpha: 0.3),
      child: Icon(Icons.movie_rounded, size: 40, color: Colors.white.withValues(alpha: 0.5)),
    );
  }
}
