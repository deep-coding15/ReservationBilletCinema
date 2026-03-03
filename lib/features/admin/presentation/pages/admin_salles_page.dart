import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_billet_cinema/core/network/serverpod_provider.dart';
import 'dart:convert';

// ============================================================
// PROVIDERS RIVERPOD — Connexion Backend
// ============================================================

final sallesRefreshProvider = StateProvider<int>((ref) => 0);

final sallesListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(sallesRefreshProvider);
  final client = ref.read(serverpodClientProvider);
  final List<String> result = await client.adminSalles.getSalles();
  return result.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
});

final cinemasListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final client = ref.read(serverpodClientProvider);
  final List<String> result = await client.adminSalles.getCinemas();
  return result.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
});

// ============================================================
// PAGE PRINCIPALE — GESTION DES SALLES (ADMIN)
// ============================================================

class AdminSallesPage extends ConsumerStatefulWidget {
  const AdminSallesPage({super.key});

  @override
  ConsumerState<AdminSallesPage> createState() => _AdminSallesPageState();
}

class _AdminSallesPageState extends ConsumerState<AdminSallesPage> {
  String _searchQuery = '';
  String? _selectedCinemaFilter;

  List<Map<String, dynamic>> _filterSalles(List<Map<String, dynamic>> salles) {
    return salles.where((s) {
      final matchSearch = _searchQuery.isEmpty ||
          (s['codeSalle'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCinema = _selectedCinemaFilter == null ||
          s['cinemaId'].toString() == _selectedCinemaFilter;
      return matchSearch && matchCinema;
    }).toList();
  }

  void _refresh() {
    ref.read(sallesRefreshProvider.notifier).state++;
  }

  void _showSalleDialog({Map<String, dynamic>? salle, required List<Map<String, dynamic>> cinemas}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SalleFormDialog(
        salle: salle,
        cinemas: cinemas,
        onSave: (salleData) async {
          final client = ref.read(serverpodClientProvider);
          try {
            if (salle == null) {
              await client.adminSalles.createSalle(
                cinemaId: salleData['cinemaId'],
                codeSalle: salleData['codeSalle'],
                capacite: salleData['capacite'],
                equipements: (salleData['equipements'] as List?)?.map((e) => e.toString()).toList(),
              );
            } else {
              await client.adminSalles.updateSalle(
                id: salle['id'],
                cinemaId: salleData['cinemaId'],
                codeSalle: salleData['codeSalle'],
                capacite: salleData['capacite'],
                equipements: (salleData['equipements'] as List?)?.map((e) => e.toString()).toList(),
              );
            }
            _refresh();
            if (mounted) {
              _snack('Salle "${salleData['codeSalle']}" ${salle == null ? 'ajoutée' : 'modifiée'} !', Colors.green);
            }
          } catch (e) {
            if (mounted) _snack('Erreur : $e', Colors.red);
          }
        },
      ),
    );
  }

  void _deleteSalle(Map<String, dynamic> salle) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Confirmer la suppression', style: TextStyle(color: Colors.white)),
        content: Text('Supprimer la salle "${salle['codeSalle']}" ?',
            style: TextStyle(color: Colors.white.withOpacity(0.7))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(serverpodClientProvider).adminSalles.deleteSalle(salle['id']);
                _refresh();
                if (mounted) _snack('Salle supprimée', Colors.red);
              } catch (e) {
                if (mounted) _snack('Erreur : $e', Colors.red);
              }
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _snack(String msg, Color color) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating));

  @override
  Widget build(BuildContext context) {
    final sallesAsync = ref.watch(sallesListProvider);
    final cinemasAsync = ref.watch(cinemasListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Gestion des Salles',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white70), onPressed: _refresh),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: cinemasAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (cinemas) => FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE5193C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () => _showSalleDialog(cinemas: cinemas),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Nouvelle salle', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
      body: sallesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFE5193C))),
        error: (err, _) => Center(child: _ErrorView(error: err.toString(), onRetry: _refresh)),
        data: (salles) {
          final filtered = _filterSalles(salles);
          return cinemasAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFE5193C))),
            error: (_, __) => const SizedBox.shrink(),
            data: (cinemas) {
              return Column(
                children: [
                  _SallesStatsBar(
                    totalSalles: salles.length,
                    filteredSalles: filtered.length,
                    totalCapacite: salles.fold(0, (sum, s) => sum + (s['capacite'] as num).toInt()),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Rechercher par code salle...',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                              prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                              filled: true, fillColor: const Color(0xFF1A1A2E),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onChanged: (v) => setState(() => _searchQuery = v),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _CinemaFilterDropdown(
                          cinemas: cinemas,
                          selectedId: _selectedCinemaFilter,
                          onChanged: (v) => setState(() => _selectedCinemaFilter = v),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? _EmptyState(onAdd: () => _showSalleDialog(cinemas: cinemas))
                        : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) => _SalleCard(
                        salle: filtered[i],
                        onEdit: () => _showSalleDialog(salle: filtered[i], cinemas: cinemas),
                        onDelete: () => _deleteSalle(filtered[i]),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// ============================================================
// WIDGETS AUXILIAIRES (PAGE SALLES)
// ============================================================

class _SallesStatsBar extends StatelessWidget {
  final int totalSalles, filteredSalles, totalCapacite;
  const _SallesStatsBar({required this.totalSalles, required this.filteredSalles, required this.totalCapacite});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          _StatChip(icon: Icons.weekend_outlined, label: '$totalSalles salles', color: const Color(0xFFE5193C)),
          const SizedBox(width: 8),
          _StatChip(icon: Icons.people_outline, label: '$totalCapacite places', color: const Color(0xFF4C9EEB)),
          if (filteredSalles != totalSalles) ...[
            const SizedBox(width: 8),
            _StatChip(icon: Icons.filter_list, label: '$filteredSalles résultats', color: Colors.amber.shade600),
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon; final String label; final Color color;
  const _StatChip({required this.icon, required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.3))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: color), const SizedBox(width: 6),
      Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _CinemaFilterDropdown extends StatelessWidget {
  final List<Map<String, dynamic>> cinemas;
  final String? selectedId;
  final ValueChanged<String?> onChanged;
  const _CinemaFilterDropdown({required this.cinemas, required this.selectedId, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedId,
          dropdownColor: const Color(0xFF1A1A2E),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
          hint: const Text('Tous les cinémas', style: TextStyle(color: Colors.white54, fontSize: 14)),
          items: [
            const DropdownMenuItem<String?>(value: null, child: Text('Tous les cinémas', style: TextStyle(color: Colors.white70))),
            ...cinemas.map((c) => DropdownMenuItem<String?>(value: c['id'].toString(), child: Text(c['nom']))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SalleCard extends StatelessWidget {
  final Map<String, dynamic> salle;
  final VoidCallback onEdit, onDelete;
  const _SalleCard({required this.salle, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final cap = (salle['capacite'] as num).toInt();
    final color = cap >= 200 ? const Color(0xFFE5193C) : (cap >= 100 ? const Color(0xFF4C9EEB) : Colors.green.shade400);
    final label = cap >= 200 ? 'Grande salle' : (cap >= 100 ? 'Salle moyenne' : 'Petite salle');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.2))),
      child: InkWell(
        onTap: onEdit, borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.3))),
                child: Icon(Icons.weekend_outlined, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text('Salle ${salle['codeSalle']}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    _Tag(label: label, color: color),
                  ]),
                  const SizedBox(height: 4),
                  Text(salle['cinemaNom'] ?? 'Cinéma inconnu', style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 6, runSpacing: 4, children: [
                    _Tag(icon: Icons.people_outline, label: '$cap places', color: Colors.white54),
                    if (salle['equipements'] != null)
                      ...(salle['equipements'] as List).take(3).map((e) => _Tag(label: e.toString(), color: const Color(0xFF4C9EEB))),
                  ]),
                ]),
              ),
              Column(children: [
                IconButton(icon: const Icon(Icons.edit_outlined, size: 20), color: const Color(0xFF4C9EEB), onPressed: onEdit),
                IconButton(icon: const Icon(Icons.delete_outline, size: 20), color: Colors.red.shade400, onPressed: onDelete),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label; final Color color; final IconData? icon;
  const _Tag({required this.label, required this.color, this.icon});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (icon != null) ...[Icon(icon, size: 11, color: color), const SizedBox(width: 3)],
      Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.weekend_outlined, size: 64, color: Colors.white12),
      const SizedBox(height: 16),
      const Text('Aucune salle trouvée', style: TextStyle(color: Colors.white38, fontSize: 16)),
      const SizedBox(height: 12),
      FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE5193C)), onPressed: onAdd, icon: const Icon(Icons.add), label: const Text('Ajouter une salle')),
    ]),
  );
}

class _ErrorView extends StatelessWidget {
  final String error; final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error_outline, color: Colors.red, size: 48),
      const SizedBox(height: 12),
      Text('Erreur : $error', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white54)),
      const SizedBox(height: 16),
      FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE5193C)), onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Réessayer')),
    ]),
  );
}

// ============================================================
// DIALOG FORMULAIRE (SALLES)
// ============================================================

class SalleFormDialog extends StatefulWidget {
  final Map<String, dynamic>? salle;
  final List<Map<String, dynamic>> cinemas;
  final void Function(Map<String, dynamic>) onSave;
  const SalleFormDialog({super.key, this.salle, required this.cinemas, required this.onSave});

  @override
  State<SalleFormDialog> createState() => _SalleFormDialogState();
}

class _SalleFormDialogState extends State<SalleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeCtrl, _capaciteCtrl;
  int? _selectedCinemaId;
  List<String> _selectedEquipements = [];

  static const List<String> _eqs = ['2D', '3D', 'IMAX', '4DX', 'Dolby Atmos', 'THX', 'Sièges VIP', 'PMR', 'Air conditionné'];

  @override
  void initState() {
    super.initState();
    final s = widget.salle;
    _codeCtrl = TextEditingController(text: s?['codeSalle'] ?? '');
    _capaciteCtrl = TextEditingController(text: s?['capacite']?.toString() ?? '');
    _selectedCinemaId = s != null ? (s['cinemaId'] as num).toInt() : (widget.cinemas.isNotEmpty ? (widget.cinemas.first['id'] as num).toInt() : null);
    _selectedEquipements = s?['equipements'] != null ? List<String>.from(s!['equipements']) : [];
  }

  @override
  void dispose() { _codeCtrl.dispose(); _capaciteCtrl.dispose(); super.dispose(); }

  void _submit() {
    if (!_formKey.currentState!.validate() || _selectedCinemaId == null) return;
    Navigator.pop(context);
    widget.onSave({
      'cinemaId': _selectedCinemaId,
      'codeSalle': _codeCtrl.text.trim().toUpperCase(),
      'capacite': int.tryParse(_capaciteCtrl.text) ?? 0,
      'equipements': _selectedEquipements,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 650),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF2A2A3E)))),
            child: Row(children: [
              const Icon(Icons.weekend_outlined, color: Color(0xFFE5193C), size: 24),
              const SizedBox(width: 12),
              Text(widget.salle == null ? 'Nouvelle salle' : 'Modifier la salle', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: () => Navigator.pop(context)),
            ]),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                DropdownButtonFormField<int>(
                  value: _selectedCinemaId, dropdownColor: const Color(0xFF1A1A2E), style: const TextStyle(color: Colors.white),
                  decoration: _dec('Cinéma *', icon: Icons.location_city),
                  items: widget.cinemas.map((c) => DropdownMenuItem<int>(value: (c['id'] as num).toInt(), child: Text(c['nom']))).toList(),
                  onChanged: (v) => setState(() => _selectedCinemaId = v),
                ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: TextFormField(controller: _codeCtrl, style: const TextStyle(color: Colors.white), decoration: _dec('Code *', hint: 'A1'), validator: (v) => v!.isEmpty ? 'Requis' : null)),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(controller: _capaciteCtrl, style: const TextStyle(color: Colors.white), keyboardType: TextInputType.number, decoration: _dec('Capacité *', hint: '150'), validator: (v) => v!.isEmpty ? 'Requis' : null)),
                ]),
                const SizedBox(height: 20),
                const Text('Équipements', style: TextStyle(color: Colors.white60, fontSize: 13)),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: _eqs.map((e) => _EquipementChip(label: e, selected: _selectedEquipements.contains(e), onTap: () {
                  setState(() => _selectedEquipements.contains(e) ? _selectedEquipements.remove(e) : _selectedEquipements.add(e));
                })).toList()),
              ])),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(children: [
              Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(foregroundColor: Colors.white60), child: const Text('Annuler'))),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: FilledButton(onPressed: _submit, style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE5193C)), child: const Text('Enregistrer'))),
            ]),
          ),
        ]),
      ),
    );
  }

  InputDecoration _dec(String label, {String? hint, IconData? icon}) => InputDecoration(
    labelText: label, hintText: hint, labelStyle: const TextStyle(color: Colors.white60),
    prefixIcon: icon != null ? Icon(icon, color: Colors.white38, size: 20) : null,
    filled: true, fillColor: const Color(0xFF0F0F1A),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white12)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5193C))),
  );
}

class _EquipementChip extends StatelessWidget {
  final String label; final bool selected; final VoidCallback onTap;
  const _EquipementChip({required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: selected ? const Color(0xFFE5193C).withOpacity(0.15) : const Color(0xFF0F0F1A), borderRadius: BorderRadius.circular(8), border: Border.all(color: selected ? const Color(0xFFE5193C) : Colors.white12)),
      child: Text(label, style: TextStyle(color: selected ? const Color(0xFFE5193C) : Colors.white54, fontSize: 12, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
    ),
  );
}