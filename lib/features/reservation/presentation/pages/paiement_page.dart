import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/reservation/data/models/recap_data.dart';
import 'package:reservation_billet_cinema/features/reservation/data/repositories/reservation_repository.dart';
import 'package:reservation_billet_cinema/features/events/data/repositories/events_repository.dart';

/// Page paiement : affiche le montant et confirme la réservation (film ou événement).
class PaiementPage extends ConsumerStatefulWidget {
  const PaiementPage({super.key, this.recapData, this.eventRecapData});

  final ReservationRecapData? recapData;
  final EventRecapData? eventRecapData;

  @override
  ConsumerState<PaiementPage> createState() => _PaiementPageState();
}

class _PaiementPageState extends ConsumerState<PaiementPage> {
  bool _loading = false;

  Future<void> _confirmPaiement() async {
    final eventData = widget.eventRecapData;
    final filmData = widget.recapData;

    if (eventData != null) {
      // Réservation événement (même logique que cinéma).
      setState(() => _loading = true);
      final repo = ref.read(eventsRepositoryProvider);
      try {
        final map = await repo.createEventReservation(
          eventId: eventData.eventId,
          nbBillets: eventData.numberOfTickets,
          montantTotal: eventData.total,
        );
        if (mounted) {
          final result = ReservationResult(
            reservationId: map['reservationId'] as int,
            montantTotal: (map['montantTotal'] as num).toDouble(),
          );
          context.go('/reservation/confirmation', extra: result);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _loading = false);
      }
      return;
    }

    if (filmData == null || filmData.siegeIds.isEmpty) return;
    setState(() => _loading = true);
    final repo = ref.read(reservationRepositoryProvider);
    try {
      final result = await repo.createReservation(
        seanceId: filmData.seance.id,
        siegeIds: filmData.siegeIds,
      );
      if (mounted) {
        context.go('/reservation/confirmation', extra: result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventData = widget.eventRecapData;
    final filmData = widget.recapData;
    if (eventData == null && filmData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0d0d0d),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
          title: const Text('Paiement'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Données manquantes.', style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    final lines = eventData?.lines ?? filmData!.lines;
    final total = eventData?.total ?? filmData!.total;

    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Paiement'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xFF1f1f1f),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (eventData != null)
                      Text(
                        '${eventData.titre} • ${eventData.numberOfTickets} billet(s)',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      )
                    else
                      Text(
                        '${filmData!.seance.cinemaNom ?? 'Cinéma'} • ${filmData.siegeIds.length} place(s)',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    if (lines.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${lines.length} billet(s) — types: ${lines.map((l) => l.typeBillet).join(", ")}',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                      ),
                      if (lines.any((l) => l.options.isNotEmpty))
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Options: ${lines.expand((l) => l.options).toSet().join(", ")}',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                          ),
                        ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Montant total', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        Text(
                          '${total.toStringAsFixed(0)} DH',
                          style: const TextStyle(color: AppColors.neon, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Mode de paiement',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Card(
              color: const Color(0xFF1f1f1f),
              child: ListTile(
                leading: const Icon(Icons.credit_card_rounded, color: AppColors.neon),
                title: const Text('Carte bancaire', style: TextStyle(color: Colors.white)),
                subtitle: Text('Paiement sécurisé', style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _loading ? null : _confirmPaiement,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Confirmer le paiement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
