import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:reservation_billet_cinema/core/network/serverpod_provider.dart';

// ============================================================
// MODÈLE LOCAL (Pour l'affichage UI)
// ============================================================

class ReservationModel {
  final int? id;
  final int utilisateurId;
  final int seanceId;
  final DateTime? dateReservation;
  final double montantTotal;
  final String statut;
  final String? filmTitre;
  final String? salleCode;

  ReservationModel({
    this.id,
    required this.utilisateurId,
    required this.seanceId,
    this.dateReservation,
    required this.montantTotal,
    required this.statut,
    this.filmTitre,
    this.salleCode,
  });

  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      id: map['id'],
      utilisateurId: map['utilisateurId'],
      seanceId: map['seanceId'],
      dateReservation: map['dateReservation'] != null ? DateTime.tryParse(map['dateReservation']) : null,
      montantTotal: (map['montantTotal'] as num).toDouble(),
      statut: map['statut'],
      filmTitre: map['filmTitre'],
      salleCode: map['salleCode'],
    );
  }
}

// ============================================================
// PROVIDERS RIVERPOD
// ============================================================

final reservationsRefreshProvider = StateProvider<int>((ref) => 0);

final reservationsListProvider = FutureProvider<List<ReservationModel>>((ref) async {
  ref.watch(reservationsRefreshProvider);
  final client = ref.read(serverpodClientProvider);
  final List<String> result = await client.adminReservations.getReservations();
  return result.map((s) => ReservationModel.fromMap(jsonDecode(s))).toList();
});

// ============================================================
// PAGE PRINCIPALE — RÉSERVATIONS EN TEMPS RÉEL (ADMIN)
// ============================================================

class AdminReservationsPage extends ConsumerStatefulWidget {
  const AdminReservationsPage({super.key});

  @override
  ConsumerState<AdminReservationsPage> createState() =>
      _AdminReservationsPageState();
}

class _AdminReservationsPageState
    extends ConsumerState<AdminReservationsPage> {
  String _searchQuery = '';
  DateTime? _dateFilter;
  String _statutFilter = 'tous';

  static const Map<String, String> _statutLabels = {
    'tous': 'Tous',
    'en_attente': 'En attente',
    'confirmee': 'Confirmée',
    'annulee': 'Annulée',
    'remboursee': 'Remboursée',
  };

  List<ReservationModel> _filter(List<ReservationModel> reservations) {
    return reservations.where((r) {
      final matchSearch = _searchQuery.isEmpty ||
          r.id.toString().contains(_searchQuery) ||
          r.utilisateurId.toString().contains(_searchQuery) ||
          (r.filmTitre?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      final matchStatut =
          _statutFilter == 'tous' || r.statut == _statutFilter;
      final matchDate = _dateFilter == null ||
          (r.dateReservation != null &&
              r.dateReservation!.year == _dateFilter!.year &&
              r.dateReservation!.month == _dateFilter!.month &&
              r.dateReservation!.day == _dateFilter!.day);
      return matchSearch && matchStatut && matchDate;
    }).toList();
  }

  void _refresh() {
    ref.read(reservationsRefreshProvider.notifier).state++;
  }

  Future<void> _pickDateFilter() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateFilter ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
            colorScheme:
            const ColorScheme.dark(primary: Color(0xFFE5193C))),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dateFilter = picked);
  }

  void _showReservationDetail(ReservationModel reservation) {
    showDialog(
      context: context,
      builder: (_) => ReservationDetailDialog(
        reservation: reservation,
        onAnnuler: (reservation.statut == 'confirmee' ||
            reservation.statut == 'en_attente')
            ? () => _annulerReservation(reservation)
            : null,
        onRembourser: reservation.statut == 'annulee'
            ? () => _rembourserReservation(reservation)
            : null,
      ),
    );
  }

  void _annulerReservation(ReservationModel reservation) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Annuler la réservation',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Confirmer l\'annulation de la réservation #${reservation.id} ?',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Non')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Colors.orange.shade700),
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              try {
                await ref.read(serverpodClientProvider).adminReservations.annulerReservation(reservation.id!);
                _refresh();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Réservation #${reservation.id} annulée'),
                    backgroundColor: Colors.orange.shade700,
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              } catch (e) {
                if (mounted) _snack('Erreur : $e', Colors.red);
              }
            },
            child: const Text('Annuler la réservation'),
          ),
        ],
      ),
    );
  }

  void _rembourserReservation(ReservationModel reservation) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Effectuer le remboursement',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Confirmer le remboursement de ${reservation.montantTotal.toStringAsFixed(2)} MAD pour la réservation #${reservation.id} ?',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Non')),
          FilledButton(
            style:
            FilledButton.styleFrom(backgroundColor: Colors.green.shade700),
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              try {
                await ref.read(serverpodClientProvider).adminReservations.effectuerRemboursement(reservation.id!);
                _refresh();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Remboursement effectué pour #${reservation.id}'),
                    backgroundColor: Colors.green.shade700,
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              } catch (e) {
                if (mounted) _snack('Erreur : $e', Colors.red);
              }
            },
            child: const Text('Rembourser'),
          ),
        ],
      ),
    );
  }

  void _snack(String msg, Color color) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating));

  @override
  Widget build(BuildContext context) {
    final reservationsAsync = ref.watch(reservationsListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Réservations en temps réel',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            tooltip: 'Actualiser',
            onPressed: _refresh,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: reservationsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFE5193C)),
        ),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text('Erreur : $err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54)),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE5193C)),
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (reservations) {
          final filtered = _filter(reservations);
          return Column(
            children: [
              _ReservationsStatsBar(reservations: reservations),
              _StatutFilterBar(
                selected: _statutFilter,
                labels: _statutLabels,
                onChanged: (s) => setState(() => _statutFilter = s),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Rechercher par N° réservation ou utilisateur...',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.4)),
                          prefixIcon: Icon(Icons.search,
                              color: Colors.white.withOpacity(0.5)),
                          filled: true,
                          fillColor: const Color(0xFF1A1A2E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onChanged: (v) =>
                            setState(() => _searchQuery = v),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _DateFilterButton(
                      date: _dateFilter,
                      onTap: _pickDateFilter,
                      onClear: () => setState(() => _dateFilter = null),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Text(
                      '${filtered.length} réservation${filtered.length > 1 ? 's' : ''}',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const _EmptyState()
                    : ListView.builder(
                  padding:
                  const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) => _ReservationCard(
                    reservation: filtered[i],
                    onTap: () =>
                        _showReservationDetail(filtered[i]),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// WIDGETS
// ============================================================

class _ReservationsStatsBar extends StatelessWidget {
  final List<ReservationModel> reservations;
  const _ReservationsStatsBar({required this.reservations});

  @override
  Widget build(BuildContext context) {
    final total = reservations.length;
    final confirmees =
        reservations.where((r) => r.statut == 'confirmee').length;
    final enAttente =
        reservations.where((r) => r.statut == 'en_attente').length;
    final annulees =
        reservations.where((r) => r.statut == 'annulee').length;
    final revenu = reservations
        .where((r) => r.statut == 'confirmee')
        .fold(0.0, (sum, r) => sum + r.montantTotal);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _StatChip(icon: Icons.receipt_long_outlined, label: '$total total', color: Colors.white54),
            const SizedBox(width: 8),
            _StatChip(icon: Icons.check_circle_outline, label: '$confirmees confirmées', color: Colors.green.shade400),
            const SizedBox(width: 8),
            _StatChip(icon: Icons.hourglass_empty, label: '$enAttente en attente', color: Colors.amber.shade500),
            const SizedBox(width: 8),
            _StatChip(icon: Icons.cancel_outlined, label: '$annulees annulées', color: Colors.red.shade400),
            const SizedBox(width: 8),
            _StatChip(icon: Icons.payments_outlined, label: '${revenu.toStringAsFixed(0)} MAD', color: const Color(0xFFE5193C)),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _StatChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _StatutFilterBar extends StatelessWidget {
  final String selected;
  final Map<String, String> labels;
  final ValueChanged<String> onChanged;
  const _StatutFilterBar({required this.selected, required this.labels, required this.onChanged});

  Color _colorForStatut(String statut) {
    switch (statut) {
      case 'confirmee': return Colors.green.shade400;
      case 'en_attente': return Colors.amber.shade500;
      case 'annulee': return Colors.red.shade400;
      case 'remboursee': return const Color(0xFF4C9EEB);
      default: return Colors.white54;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: labels.entries.map((entry) {
            final isSelected = selected == entry.key;
            final color = _colorForStatut(entry.key);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onChanged(entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.15) : const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? color : Colors.white.withOpacity(0.12),
                    ),
                  ),
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      color: isSelected ? color : Colors.white54,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _DateFilterButton extends StatelessWidget {
  final DateTime? date;
  final VoidCallback onTap;
  final VoidCallback onClear;
  const _DateFilterButton({required this.date, required this.onTap, required this.onClear});

  String _format(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: date != null ? const Color(0xFFE5193C).withOpacity(0.1) : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: date != null ? const Color(0xFFE5193C).withOpacity(0.5) : Colors.white.withOpacity(0.12),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 16,
                color: date != null ? const Color(0xFFE5193C) : Colors.white54),
            const SizedBox(width: 6),
            Text(
              date != null ? _format(date!) : 'Date',
              style: TextStyle(
                color: date != null ? const Color(0xFFE5193C) : Colors.white54,
                fontSize: 13,
                fontWeight: date != null ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (date != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close, size: 14, color: Color(0xFFE5193C)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final ReservationModel reservation;
  final VoidCallback onTap;
  const _ReservationCard({required this.reservation, required this.onTap});

  Color _statutColor() {
    switch (reservation.statut) {
      case 'confirmee': return Colors.green.shade400;
      case 'en_attente': return Colors.amber.shade500;
      case 'annulee': return Colors.red.shade400;
      case 'remboursee': return const Color(0xFF4C9EEB);
      default: return Colors.white54;
    }
  }

  String _statutLabel() {
    switch (reservation.statut) {
      case 'confirmee': return 'Confirmée';
      case 'en_attente': return 'En attente';
      case 'annulee': return 'Annulée';
      case 'remboursee': return 'Remboursée';
      default: return reservation.statut;
    }
  }

  IconData _statutIcon() {
    switch (reservation.statut) {
      case 'confirmee': return Icons.check_circle_outline;
      case 'en_attente': return Icons.hourglass_empty;
      case 'annulee': return Icons.cancel_outlined;
      case 'remboursee': return Icons.replay;
      default: return Icons.help_outline;
    }
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '-';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final color = _statutColor();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_statutIcon(), color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('#${reservation.id}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(width: 8),
                        _StatusBadge(label: _statutLabel(), color: color),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 13, color: Colors.white.withOpacity(0.4)),
                        const SizedBox(width: 4),
                        Text('User #${reservation.utilisateurId}',
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                        const SizedBox(width: 12),
                        Icon(Icons.movie_outlined, size: 13, color: Colors.white.withOpacity(0.4)),
                        const SizedBox(width: 4),
                        Text(reservation.filmTitre ?? 'S#${reservation.seanceId}',
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(_formatDate(reservation.dateReservation),
                        style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 11)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${reservation.montantTotal.toStringAsFixed(2)} MAD',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.white12),
          SizedBox(height: 16),
          Text('Aucune réservation trouvée',
              style: TextStyle(color: Colors.white38, fontSize: 16)),
        ],
      ),
    );
  }
}

// ============================================================
// DIALOG DÉTAIL RÉSERVATION
// ============================================================

class ReservationDetailDialog extends StatelessWidget {
  final ReservationModel reservation;
  final VoidCallback? onAnnuler;
  final VoidCallback? onRembourser;
  const ReservationDetailDialog(
      {super.key, required this.reservation, this.onAnnuler, this.onRembourser});

  String _formatDate(DateTime? d) {
    if (d == null) return '-';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} à ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  Color _statutColor() {
    switch (reservation.statut) {
      case 'confirmee': return Colors.green.shade400;
      case 'en_attente': return Colors.amber.shade500;
      case 'annulee': return Colors.red.shade400;
      case 'remboursee': return const Color(0xFF4C9EEB);
      default: return Colors.white54;
    }
  }

  String _statutLabel() {
    switch (reservation.statut) {
      case 'confirmee': return 'CONFIRMÉE';
      case 'en_attente': return 'EN ATTENTE';
      case 'annulee': return 'ANNULÉE';
      case 'remboursee': return 'REMBOURSÉE';
      default: return reservation.statut.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statutColor();
    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 540),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFF2A2A3E)))),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.receipt_long_outlined, color: color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Réservation #${reservation.id}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(_statutLabel(),
                            style: TextStyle(
                                color: color,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      icon: const Icon(Icons.close, color: Colors.white54),
                      onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _DetailRow(icon: Icons.person_outline, label: 'Utilisateur', value: '#${reservation.utilisateurId}'),
                    _DetailRow(icon: Icons.movie_filter_outlined, label: 'Film', value: reservation.filmTitre ?? 'N/A'),
                    _DetailRow(icon: Icons.weekend_outlined, label: 'Salle', value: reservation.salleCode ?? 'N/A'),
                    _DetailRow(icon: Icons.calendar_today_outlined, label: 'Date réservation', value: _formatDate(reservation.dateReservation)),
                    _DetailRow(
                        icon: Icons.payments_outlined,
                        label: 'Montant total',
                        value: '${reservation.montantTotal.toStringAsFixed(2)} MAD',
                        valueColor: Colors.white),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            // Actions
            if (onAnnuler != null || onRembourser != null)
              Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFF2A2A3E)))),
                child: Row(
                  children: [
                    if (onAnnuler != null)
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.orange.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: onAnnuler,
                          icon: const Icon(Icons.cancel_outlined, size: 18),
                          label: const Text('Annuler',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    if (onAnnuler != null && onRembourser != null)
                      const SizedBox(width: 12),
                    if (onRembourser != null)
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: onRembourser,
                          icon: const Icon(Icons.replay, size: 18),
                          label: const Text('Rembourser',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  const _DetailRow({required this.icon, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white38),
          const SizedBox(width: 12),
          Text('$label : ',
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: valueColor ?? Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
