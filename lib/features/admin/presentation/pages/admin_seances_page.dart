import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/programmation/data/repositories/films_repository.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';

/// Liste des séances par cinéma (admin).
class AdminSeancesPage extends ConsumerStatefulWidget {
  const AdminSeancesPage({super.key});

  @override
  ConsumerState<AdminSeancesPage> createState() => _AdminSeancesPageState();
}

class _AdminSeancesPageState extends ConsumerState<AdminSeancesPage> {
  List<Cinema> _cinemas = [];
  List<Seance> _seances = [];
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
      final cinemas = await repo.getCinemas();
      final allSeances = <Seance>[];
      for (final c in cinemas) {
        final list = await repo.getSeancesByCinema(c.id!);
        allSeances.addAll(list);
      }
      if (mounted) {
        setState(() {
          _cinemas = cinemas;
          _seances = allSeances;
          _loading = false;
        });
      }
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
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_seances.length} séance(s) • ${_cinemas.length} cinéma(s)',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      ..._seances.take(50).map((s) => Card(
                            color: const Color(0xFF1f1f1f),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(Icons.schedule_rounded, color: AppColors.primary),
                              title: Text(
                                'Séance #${s.id} • Salle ${s.salleId}',
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              subtitle: Text(
                                '${s.dateHeure} • ${s.prix} DH • ${s.placesDisponibles} places',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ),
                          )),
                      if (_seances.length > 50)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '... et ${_seances.length - 50} autres',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}
