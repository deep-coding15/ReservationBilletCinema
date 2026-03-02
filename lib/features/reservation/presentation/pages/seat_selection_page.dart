import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/reservation/data/repositories/reservation_repository.dart';
import 'package:reservation_billet_cinema/features/reservation/presentation/pages/reservation_confirmation_page.dart';

/// Page sélection des sièges : plan de salle, choix, confirmation.
class SeatSelectionPage extends ConsumerStatefulWidget {
  const SeatSelectionPage({super.key, this.seance});

  final Seance? seance;

  @override
  ConsumerState<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends ConsumerState<SeatSelectionPage> {
  List<Siege> _sieges = [];
  Set<int> _reservedIds = {};
  final Set<int> _selectedIds = {};
  bool _loading = true;
  String? _error;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.seance != null) _load();
  }

  Future<void> _load() async {
    final seance = widget.seance!;
    setState(() {
      _loading = true;
      _error = null;
    });
    final repo = ref.read(reservationRepositoryProvider);
    try {
      final sieges = await repo.getSiegesBySalle(seance.salleId);
      final reserved = await repo.getReservedSiegeIdsForSeance(seance.id);
      if (mounted) {
        setState(() {
          _sieges = sieges;
          _reservedIds = reserved.toSet();
          _loading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _sieges = [];
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  Future<void> _confirmReservation() async {
    if (widget.seance == null || _selectedIds.isEmpty) return;
    setState(() => _submitting = true);
    final repo = ref.read(reservationRepositoryProvider);
    try {
      final result = await repo.createReservation(
        seanceId: widget.seance!.id,
        siegeIds: _selectedIds.toList(),
      );
      if (mounted) {
        context.push('/reservation/confirmation', extra: result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.seance == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0d0d0d),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
          title: const Text('Réservation'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Séance requise pour réserver.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }

    final seance = widget.seance!;
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Choisir les sièges'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(onPressed: _load, child: const Text('Réessayer')),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        color: const Color(0xFF1f1f1f),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline_rounded, color: Colors.white70, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '${seance.cinemaNom ?? ''} — ${seance.salleCode ?? ''} • ${seance.prix.toStringAsFixed(0)} DH / place',
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _LegendItem(color: Color(0xFF2a2a2a), label: 'Disponible'),
                          _LegendItem(color: AppColors.primary, label: 'Sélectionné'),
                          _LegendItem(color: Colors.grey, label: 'Occupé'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _sieges.isEmpty
                          ? const Center(child: Text('Aucun siège configuré pour cette salle.'))
                          : SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                alignment: WrapAlignment.center,
                                children: _sieges.map((s) => _SeatChip(
                                  siege: s,
                                  isReserved: _reservedIds.contains(s.id),
                                  isSelected: _selectedIds.contains(s.id),
                                  onTap: () {
                                    if (_reservedIds.contains(s.id)) return;
                                    setState(() {
                                      if (_selectedIds.contains(s.id)) {
                                        _selectedIds.remove(s.id);
                                      } else {
                                        _selectedIds.add(s.id);
                                      }
                                    });
                                  },
                                )).toList(),
                              ),
                            ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _selectedIds.isEmpty || _submitting
                                ? null
                                : _confirmReservation,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: _submitting
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : Text(
                                    'Réserver ${_selectedIds.length} place(s) — ${(seance.prix * _selectedIds.length).toStringAsFixed(0)} DH',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _SeatChip extends StatelessWidget {
  const _SeatChip({
    required this.siege,
    required this.isReserved,
    required this.isSelected,
    required this.onTap,
  });

  final Siege siege;
  final bool isReserved;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color bg = const Color(0xFF2a2a2a);
    if (isReserved) bg = Colors.grey;
    if (isSelected) bg = AppColors.primary;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: isReserved ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Text(
            siege.numero,
            style: TextStyle(
              color: isReserved ? Colors.white38 : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
