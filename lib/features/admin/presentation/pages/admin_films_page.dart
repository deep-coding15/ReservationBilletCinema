import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/programmation/data/repositories/films_repository.dart';

/// Liste des films (admin).
class AdminFilmsPage extends ConsumerStatefulWidget {
  const AdminFilmsPage({super.key});

  @override
  ConsumerState<AdminFilmsPage> createState() => _AdminFilmsPageState();
}

class _AdminFilmsPageState extends ConsumerState<AdminFilmsPage> {
  List<Film> _films = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final repo = ref.read(filmsRepositoryProvider);
      final list = await repo.getFilms();
      if (mounted) setState(() { _films = list; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0d0d0d), Color(0xFF1a0a0e)],
        ),
      ),
      child: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton(onPressed: _load, child: const Text('Réessayer')),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  color: AppColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _films.length,
                    itemBuilder: (context, i) {
                      final f = _films[i];
                      return Card(
                        color: const Color(0xFF1f1f1f),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: f.affiche != null && f.affiche!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(f.affiche!, width: 56, height: 84, fit: BoxFit.cover),
                                )
                              : Container(
                                  width: 56,
                                  height: 84,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.movie_rounded, color: Colors.white54),
                                ),
                          title: Text(f.titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          subtitle: Text(
                            '${f.genre ?? ""} • ${f.duree} min',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white54),
                          onTap: () => context.push('/films/${f.id}'),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
