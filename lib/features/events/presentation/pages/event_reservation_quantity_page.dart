import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/auth/presentation/providers/auth_provider.dart';
import 'package:reservation_billet_cinema/features/reservation/data/models/recap_data.dart';

/// Choisir le nombre de billets pour un événement, puis aller au récap (type + options par billet).
class EventReservationQuantityPage extends ConsumerStatefulWidget {
  const EventReservationQuantityPage({
    super.key,
    required this.eventId,
    required this.titre,
    required this.prixUnitaire,
    required this.placesDisponibles,
  });

  final int eventId;
  final String titre;
  final double prixUnitaire;
  final int placesDisponibles;

  @override
  ConsumerState<EventReservationQuantityPage> createState() => _EventReservationQuantityPageState();
}

class _EventReservationQuantityPageState extends ConsumerState<EventReservationQuantityPage> {
  late int _nbBillets;

  @override
  void initState() {
    super.initState();
    _nbBillets = 1;
  }

  @override
  Widget build(BuildContext context) {
    if (!ref.read(authProvider).isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/auth/login');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connectez-vous pour réserver des billets.')),
          );
        }
      });
      return Scaffold(
        appBar: AppBar(title: const Text('Réservation'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }
    final max = widget.placesDisponibles.clamp(1, 20);

    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: const Text('Réserver des billets'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.titre,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.prixUnitaire.toStringAsFixed(0)} DH / billet • ${widget.placesDisponibles} places disponibles',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
            ),
            const SizedBox(height: 32),
            const Text(
              'Nombre de billets',
              style: TextStyle(color: AppColors.neon, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton.filled(
                  onPressed: _nbBillets > 1 ? () => setState(() => _nbBillets--) : null,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '$_nbBillets',
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton.filled(
                  onPressed: _nbBillets < max ? () => setState(() => _nbBillets++) : null,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final data = EventRecapData(
                    eventId: widget.eventId,
                    titre: widget.titre,
                    prixUnitaire: widget.prixUnitaire,
                    placesDisponibles: widget.placesDisponibles,
                    numberOfTickets: _nbBillets,
                  );
                  context.push('/reservation-event', extra: data);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.neon,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Continuer — type & options par billet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
