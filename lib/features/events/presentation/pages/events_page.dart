import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/events/data/models/evenement.dart';
import 'package:reservation_billet_cinema/features/events/data/repositories/events_repository.dart';

/// Page liste des événements : filtres par ville et date (application dynamique sans bouton).
class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  final _villeController = TextEditingController();
  Timer? _debounce;
  List<Evenement> _events = [];
  String? _filterVille;
  DateTime? _filterDate;
  bool _loading = false;
  String? _error;

  static const _debounceDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _villeController.addListener(_onVilleChanged);
    _load();
  }

  void _onVilleChanged() {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      if (!mounted) return;
      setState(() {
        _filterVille = _villeController.text.trim().isEmpty ? null : _villeController.text.trim();
      });
      _load();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _villeController.removeListener(_onVilleChanged);
    _villeController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    final repo = ref.read(eventsRepositoryProvider);
    try {
      final list = await repo.getEvents(ville: _filterVille, date: _filterDate);
      if (mounted) {
        setState(() { _events = list; _loading = false; });
      }
    } catch (e) {
      if (mounted) {
        setState(() { _loading = false; _error = e.toString(); _events = []; });
      }
    }
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
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text('Événements'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filtrer par ville', style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                TextField(
                  controller: _villeController,
                  decoration: InputDecoration(
                    hintText: 'Ex: Tanger, Tétouan... (filtre instantané)',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                    prefixIcon: const Icon(Icons.location_city_rounded, color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF1f1f1f),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),
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
                    const SizedBox(width: 12),
                    TextButton.icon(
                      onPressed: () {
                        _debounce?.cancel();
                        _villeController.clear();
                        setState(() { _filterVille = null; _filterDate = null; });
                        _load();
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 18, color: Colors.white70),
                      label: const Text('Réinitialiser', style: TextStyle(color: Colors.white70)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  List<Evenement> get _filteredEvents {
    var list = _events;
    if (_filterVille != null && _filterVille!.isNotEmpty) {
      final q = _filterVille!.toLowerCase();
      list = list.where((e) => (e.ville ?? '').toLowerCase().contains(q) ||
          (e.lieuNom ?? '').toLowerCase().contains(q) ||
          (e.adresse ?? '').toLowerCase().contains(q)).toList();
    }
    if (_filterDate != null) {
      list = list.where((e) =>
          e.dateHeure.year == _filterDate!.year &&
          e.dateHeure.month == _filterDate!.month &&
          e.dateHeure.day == _filterDate!.day).toList();
    }
    return list;
  }

  Widget _buildList() {
    final displayList = _filteredEvents;
    if (_loading && _events.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_error != null && _events.isEmpty) {
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
              FilledButton(onPressed: _load, child: const Text('Réessayer')),
            ],
          ),
        ),
      );
    }
    if (displayList.isEmpty) {
      return const Center(
        child: Text('Aucun événement pour ces critères.', style: TextStyle(color: Colors.white70)),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: displayList.length,
        itemBuilder: (context, i) {
          final e = displayList[i];
          return Card(
            color: const Color(0xFF1f1f1f),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.5),
                child: const Icon(Icons.event_rounded, color: Colors.white),
              ),
              title: Text(e.titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (e.categorie != null) Text(e.categorie!, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                  Text(e.lieuDisplay, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                  Text(
                    '${e.dateHeure.day.toString().padLeft(2, '0')}/${e.dateHeure.month.toString().padLeft(2, '0')} ${e.dateHeure.hour.toString().padLeft(2, '0')}:${e.dateHeure.minute.toString().padLeft(2, '0')} — ${e.prix.toStringAsFixed(0)} DH',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white54),
              onTap: () => context.push('/events/${e.id}'),
            ),
          );
        },
      ),
    );
  }
}
