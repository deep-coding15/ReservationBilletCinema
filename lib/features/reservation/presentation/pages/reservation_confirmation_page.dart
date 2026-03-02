import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';

/// Page confirmation après réservation réussie.
class ReservationConfirmationPage extends StatelessWidget {
  const ReservationConfirmationPage({super.key, this.result});

  final ReservationResult? result;

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Confirmation'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Réservation introuvable.')),
      );
    }

    final r = result!;
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        title: const Text('Réservation confirmée'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_rounded, size: 80, color: Colors.green.shade400),
            const SizedBox(height: 24),
            const Text(
              'Merci pour votre réservation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF1f1f1f),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _RowLabel(label: 'N° réservation', value: '#${r.reservationId}'),
                    const SizedBox(height: 12),
                    _RowLabel(label: 'Montant total', value: '${r.montantTotal.toStringAsFixed(0)} DH'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.go('/billets'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Voir mes billets'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text('Retour à l\'accueil', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}

class _RowLabel extends StatelessWidget {
  const _RowLabel({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 14)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
