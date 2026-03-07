import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/events/data/extensions/evenement_extension.dart';
import 'package:reservation_billet_cinema/features/events/data/repositories/events_repository.dart';

/// Liste des événements (admin).
class AdminEventsPage extends ConsumerStatefulWidget {
  const AdminEventsPage({super.key});

  @override
  ConsumerState<AdminEventsPage> createState() => _AdminEventsPageState();
}

class _AdminEventsPageState extends ConsumerState<AdminEventsPage> {
  List<Evenement> _events = [];
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
      final repo = ref.read(eventsRepositoryProvider);
      final list = await repo.getEvents();
      if (mounted) setState(() { _events = list; _loading = false; });
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
                    itemCount: _events.length,
                    itemBuilder: (context, i) {
                      final e = _events[i];
                      return Card(
                        color: const Color(0xFF1f1f1f),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.event_rounded, color: AppColors.primary, size: 28),
                          title: Text(e.titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          subtitle: Text(
                            '${e.lieuDisplay} • ${e.prix.toStringAsFixed(0)} DH',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white54),
                          onTap: () => context.push('/events/${e.id}'),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
