import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/events/data/models/evenement.dart';
import 'package:reservation_billet_cinema/features/events/data/repositories/events_repository.dart';

/// Page détail d'un événement : infos + bouton Réserver billets.
class EventDetailPage extends ConsumerStatefulWidget {
  const EventDetailPage({super.key, required this.eventId});

  final int eventId;

  @override
  ConsumerState<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends ConsumerState<EventDetailPage> {
  Evenement? _event;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(eventsRepositoryProvider);
    try {
      final e = await repo.getEventById(widget.eventId);
      if (mounted) {
        setState(() { _event = e; _loading = false; });
      }
    } catch (e) {
      if (mounted) {
        setState(() { _loading = false; _error = e.toString(); });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0d0d0d),
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
          title: const Text('Détail événement'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }
    if (_error != null || _event == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0d0d0d),
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
          title: const Text('Détail événement'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error ?? 'Événement introuvable', style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(onPressed: () => context.pop(), child: const Text('Retour')),
              ],
            ),
          ),
        ),
      );
    }

    final e = _event!;
    final dateStr = '${e.dateHeure.day.toString().padLeft(2, '0')}/${e.dateHeure.month.toString().padLeft(2, '0')}/${e.dateHeure.year}';
    final timeStr = '${e.dateHeure.hour.toString().padLeft(2, '0')}:${e.dateHeure.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: const Text('Détail événement'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (e.affiche != null && e.affiche!.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    e.affiche!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  ),
                ),
              )
            else
              _placeholder(),
            const SizedBox(height: 20),
            Text(
              e.titre,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            if (e.categorie != null) ...[
              const SizedBox(height: 8),
              Chip(
                label: Text(e.categorie!, style: const TextStyle(color: Colors.white)),
                backgroundColor: AppColors.primary.withValues(alpha: 0.6),
              ),
            ],
            const SizedBox(height: 16),
            _infoRow(Icons.location_on_rounded, e.lieuDisplay),
            if (e.ville != null) _infoRow(Icons.location_city_rounded, e.ville!),
            _infoRow(Icons.calendar_today_rounded, '$dateStr à $timeStr'),
            _infoRow(Icons.confirmation_number_rounded, '${e.prix.toStringAsFixed(0)} DH — ${e.placesDisponibles} places'),
            if (e.description != null && e.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Description', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(e.description!, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: e.placesDisponibles > 0
                    ? () => context.push(
                          '/events/${e.id}/reservation',
                          extra: e,
                        )
                    : null,
                icon: const Icon(Icons.confirmation_number_rounded),
                label: Text(e.placesDisponibles > 0 ? 'Réserver des billets' : 'Complet'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.white70),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Icon(Icons.event_rounded, size: 64, color: Colors.white38)),
    );
  }
}
