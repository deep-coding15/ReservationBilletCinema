import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ============================================================
// MODÈLES LOCAUX (à remplacer par les classes Serverpod générées)
// ============================================================

class SalleModel {
  final int? id;
  final int cinemaId;
  final String codeSalle;
  final int capacite;
  final List<String>? equipements;

  SalleModel({
    this.id,
    required this.cinemaId,
    required this.codeSalle,
    required this.capacite,
    this.equipements,
  });

  SalleModel copyWith({
    int? id,
    int? cinemaId,
    String? codeSalle,
    int? capacite,
    List<String>? equipements,
  }) {
    return SalleModel(
      id: id ?? this.id,
      cinemaId: cinemaId ?? this.cinemaId,
      codeSalle: codeSalle ?? this.codeSalle,
      capacite: capacite ?? this.capacite,
      equipements: equipements ?? this.equipements,
    );
  }
}

class CinemaModel {
  final int? id;
  final String nom;
  final String? adresse;
  final String? ville;

  CinemaModel({this.id, required this.nom, this.adresse, this.ville});
}

// ============================================================
// DONNÉES MOCKÉES
// ============================================================

final _mockCinemas = [
  CinemaModel(id: 1, nom: 'Cinéma Rif', adresse: 'Centre-ville', ville: 'Tétouan'),
  CinemaModel(id: 2, nom: 'Cinéma Dawliz', adresse: 'Bd Mohammed V', ville: 'Tanger'),
  CinemaModel(id: 3, nom: 'Mégarama', adresse: 'Twin Center', ville: 'Casablanca'),
];

final _mockSalles = [
  SalleModel(id: 1, cinemaId: 1, codeSalle: 'A1', capacite: 180, equipements: ['2D', '3D', 'Dolby Atmos']),
  SalleModel(id: 2, cinemaId: 1, codeSalle: 'B1', capacite: 80, equipements: ['2D', 'Air conditionné']),
  SalleModel(id: 3, cinemaId: 2, codeSalle: 'IMAX1', capacite: 250, equipements: ['IMAX', '4DX', 'Écran géant']),
  SalleModel(id: 4, cinemaId: 2, codeSalle: 'VIP1', capacite: 40, equipements: ['2D', 'Sièges VIP']),
  SalleModel(id: 5, cinemaId: 3, codeSalle: 'S1', capacite: 300, equipements: ['2D', '3D', 'THX']),
  SalleModel(id: 6, cinemaId: 3, codeSalle: 'PMR1', capacite: 60, equipements: ['2D', 'PMR']),
];

// ============================================================
// PROVIDERS RIVERPOD
// ============================================================

final sallesRefreshProvider = StateProvider<int>((ref) => 0);

final sallesListProvider = FutureProvider<List<SalleModel>>((ref) async {
  ref.watch(sallesRefreshProvider);
  // TODO: remplacer par client.adminSalles.getSalles() quand Serverpod est prêt
  await Future.delayed(const Duration(milliseconds: 400));
  return List<SalleModel>.from(_mockSalles);
});

final cinemasListProvider = FutureProvider<List<CinemaModel>>((ref) async {
  // TODO: remplacer par client.adminSalles.getCinemas()
  await Future.delayed(const Duration(milliseconds: 200));
  return List<CinemaModel>.from(_mockCinemas);
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

  List<SalleModel> _filterSalles(List<SalleModel> salles) {
    return salles.where((s) {
      final matchSearch = _searchQuery.isEmpty ||
          s.codeSalle.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCinema = _selectedCinemaFilter == null ||
          s.cinemaId.toString() == _selectedCinemaFilter;
      return matchSearch && matchCinema;
    }).toList();
  }

  void _refresh() {
    ref.read(sallesRefreshProvider.notifier).state++;
  }

  void _showSalleDialog({SalleModel? salle, required List<CinemaModel> cinemas}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SalleFormDialog(
        salle: salle,
        cinemas: cinemas,
        onSave: (salleData) async {
          // TODO: appeler client.adminSalles.createSalle(salleData) ou updateSalle
          _refresh();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Salle "${salleData.codeSalle}" ${salle == null ? 'ajoutée' : 'modifiée'} avec succès'),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
      ),
    );
  }

  void _deleteSalle(SalleModel salle) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Confirmer la suppression',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Voulez-vous vraiment supprimer la salle "${salle.codeSalle}" ?\nCette action supprimera toutes les séances associées.',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () {
              Navigator.pop(context);
              // TODO: appeler client.adminSalles.deleteSalle(salle.id!)
              _refresh();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Salle "${salle.codeSalle}" supprimée'),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                ));
              }
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

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
        title: const Text(
          'Gestion des Salles',
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
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: cinemasAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (cinemas) => FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE5193C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () => _showSalleDialog(cinemas: cinemas),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Nouvelle salle',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
      body: sallesAsync.when(
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
        data: (salles) {
          final filtered = _filterSalles(salles);
          return cinemasAsync.when(
            loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFFE5193C))),
            error: (_, __) => const SizedBox.shrink(),
            data: (cinemas) {
              final cinemaMap = {for (var c in cinemas) c.id: c};
              return Column(
                children: [
                  _SallesStatsBar(
                    totalSalles: salles.length,
                    filteredSalles: filtered.length,
                    totalCapacite:
                    salles.fold(0, (sum, s) => sum + s.capacite),
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
                        const SizedBox(width: 12),
                        _CinemaFilterDropdown(
                          cinemas: cinemas,
                          selectedId: _selectedCinemaFilter,
                          onChanged: (v) =>
                              setState(() => _selectedCinemaFilter = v),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? _EmptyState(
                        onAdd: () =>
                            _showSalleDialog(cinemas: cinemas))
                        : ListView.builder(
                      padding:
                      const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) => _SalleCard(
                        salle: filtered[i],
                        cinema: cinemaMap[filtered[i].cinemaId],
                        onEdit: () => _showSalleDialog(
                            salle: filtered[i], cinemas: cinemas),
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
// WIDGETS
// ============================================================

class _SallesStatsBar extends StatelessWidget {
  final int totalSalles;
  final int filteredSalles;
  final int totalCapacite;
  const _SallesStatsBar(
      {required this.totalSalles,
        required this.filteredSalles,
        required this.totalCapacite});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          _StatChip(
              icon: Icons.weekend_outlined,
              label: '$totalSalles salles',
              color: const Color(0xFFE5193C)),
          const SizedBox(width: 8),
          _StatChip(
              icon: Icons.people_outline,
              label: '$totalCapacite places total',
              color: const Color(0xFF4C9EEB)),
          const SizedBox(width: 8),
          if (filteredSalles != totalSalles)
            _StatChip(
                icon: Icons.filter_list,
                label: '$filteredSalles résultats',
                color: Colors.amber.shade600),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _StatChip(
      {required this.icon, required this.label, required this.color});

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
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _CinemaFilterDropdown extends StatelessWidget {
  final List<CinemaModel> cinemas;
  final String? selectedId;
  final ValueChanged<String?> onChanged;
  const _CinemaFilterDropdown(
      {required this.cinemas,
        required this.selectedId,
        required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedId,
          dropdownColor: const Color(0xFF1A1A2E),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
          hint: const Text('Tous les cinémas',
              style: TextStyle(color: Colors.white54, fontSize: 14)),
          items: [
            const DropdownMenuItem<String?>(
                value: null,
                child: Text('Tous les cinémas',
                    style: TextStyle(color: Colors.white70))),
            ...cinemas.map((c) => DropdownMenuItem<String?>(
                value: c.id.toString(), child: Text(c.nom))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SalleCard extends StatelessWidget {
  final SalleModel salle;
  final CinemaModel? cinema;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _SalleCard(
      {required this.salle,
        required this.cinema,
        required this.onEdit,
        required this.onDelete});

  Color _capaciteColor() {
    if (salle.capacite >= 200) return const Color(0xFFE5193C);
    if (salle.capacite >= 100) return const Color(0xFF4C9EEB);
    return Colors.green.shade400;
  }

  String _capaciteLabel() {
    if (salle.capacite >= 200) return 'Grande salle';
    if (salle.capacite >= 100) return 'Salle moyenne';
    return 'Petite salle';
  }

  @override
  Widget build(BuildContext context) {
    final color = _capaciteColor();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Icon(Icons.weekend_outlined, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Salle ${salle.codeSalle}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 8),
                        _Tag(label: _capaciteLabel(), color: color),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (cinema != null)
                      Text(
                        '${cinema!.nom}${cinema!.ville != null ? ' · ${cinema!.ville}' : ''}',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.55),
                            fontSize: 13),
                      ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _Tag(
                            icon: Icons.people_outline,
                            label: '${salle.capacite} places',
                            color: Colors.white54),
                        if (salle.equipements != null &&
                            salle.equipements!.isNotEmpty)
                          ...salle.equipements!.take(3).map((e) =>
                              _Tag(label: e, color: const Color(0xFF4C9EEB))),
                        if (salle.equipements != null &&
                            salle.equipements!.length > 3)
                          _Tag(
                              label: '+${salle.equipements!.length - 3}',
                              color: Colors.white38),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      color: const Color(0xFF4C9EEB),
                      onPressed: onEdit),
                  IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: Colors.red.shade400,
                      onPressed: onDelete),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  const _Tag({required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 3)
          ],
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.weekend_outlined, size: 64, color: Colors.white12),
          const SizedBox(height: 16),
          const Text('Aucune salle trouvée',
              style: TextStyle(color: Colors.white38, fontSize: 16)),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE5193C)),
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Ajouter une salle'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DIALOG FORMULAIRE
// ============================================================

class SalleFormDialog extends StatefulWidget {
  final SalleModel? salle;
  final List<CinemaModel> cinemas;
  final void Function(SalleModel) onSave;
  const SalleFormDialog(
      {super.key, this.salle, required this.cinemas, required this.onSave});

  @override
  State<SalleFormDialog> createState() => _SalleFormDialogState();
}

class _SalleFormDialogState extends State<SalleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late TextEditingController _codeCtrl;
  late TextEditingController _capaciteCtrl;
  int? _selectedCinemaId;

  static const List<String> _equipementsDisponibles = [
    '2D', '3D', 'IMAX', '4DX', 'Dolby Atmos', 'THX',
    'Écran géant', 'Sièges VIP', 'PMR', 'Air conditionné',
  ];
  List<String> _selectedEquipements = [];

  @override
  void initState() {
    super.initState();
    final s = widget.salle;
    _codeCtrl = TextEditingController(text: s?.codeSalle ?? '');
    _capaciteCtrl = TextEditingController(text: s?.capacite.toString() ?? '');
    _selectedCinemaId = s?.cinemaId ??
        (widget.cinemas.isNotEmpty ? widget.cinemas.first.id : null);
    _selectedEquipements = List<String>.from(s?.equipements ?? []);
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _capaciteCtrl.dispose();
    super.dispose();
  }

  void _toggleEquipement(String eq) {
    setState(() {
      if (_selectedEquipements.contains(eq)) {
        _selectedEquipements.remove(eq);
      } else {
        _selectedEquipements.add(eq);
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCinemaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Veuillez sélectionner un cinéma'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    final salle = SalleModel(
      id: widget.salle?.id,
      cinemaId: _selectedCinemaId!,
      codeSalle: _codeCtrl.text.trim().toUpperCase(),
      capacite: int.tryParse(_capaciteCtrl.text) ?? 0,
      equipements:
      _selectedEquipements.isEmpty ? null : _selectedEquipements,
    );
    setState(() => _isSaving = true);
    Navigator.pop(context);
    widget.onSave(salle);
  }

  InputDecoration _inputDecoration(String label,
      {String? hint, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.25)),
      prefixIcon:
      icon != null ? Icon(icon, color: Colors.white38, size: 20) : null,
      filled: true,
      fillColor: const Color(0xFF0F0F1A),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5193C))),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.salle != null;
    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 620),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
              decoration: const BoxDecoration(
                  border:
                  Border(bottom: BorderSide(color: Color(0xFF2A2A3E)))),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: const Color(0xFFE5193C).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.weekend_outlined,
                        color: Color(0xFFE5193C), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(isEdit ? 'Modifier la salle' : 'Nouvelle salle',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  IconButton(
                      icon: const Icon(Icons.close, color: Colors.white54),
                      onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cinéma
                      DropdownButtonFormField<int>(
                        value: _selectedCinemaId,
                        dropdownColor: const Color(0xFF1A1A2E),
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Cinéma *',
                            icon: Icons.location_city_outlined),
                        items: widget.cinemas
                            .map((c) => DropdownMenuItem<int>(
                            value: c.id,
                            child: Text(
                                '${c.nom}${c.ville != null ? ' · ${c.ville}' : ''}')))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedCinemaId = v),
                        validator: (v) =>
                        v == null ? 'Sélectionnez un cinéma' : null,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _codeCtrl,
                              style: const TextStyle(color: Colors.white),
                              textCapitalization:
                              TextCapitalization.characters,
                              decoration: _inputDecoration('Code salle *',
                                  hint: 'Ex: A1, IMAX1', icon: Icons.tag),
                              validator: (v) =>
                              v == null || v.trim().isEmpty
                                  ? 'Le code est requis'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _capaciteCtrl,
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration(
                                  'Capacité (places) *',
                                  hint: 'Ex: 150',
                                  icon: Icons.people_outline),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Requis';
                                final n = int.tryParse(v);
                                if (n == null || n <= 0) return 'Entier > 0';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Équipements
                      const Text('Équipements',
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _equipementsDisponibles
                            .map((eq) => _EquipementChip(
                          label: eq,
                          selected: _selectedEquipements.contains(eq),
                          onTap: () => _toggleEquipement(eq),
                        ))
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      // Catégories de sièges (informatif)
                      const Text('Catégories de sièges',
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      _CategorieSiegesInfo(),
                    ],
                  ),
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              decoration: const BoxDecoration(
                  border:
                  Border(top: BorderSide(color: Color(0xFF2A2A3E)))),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white60,
                            side: const BorderSide(color: Color(0xFF2A2A3E)),
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annuler')),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFE5193C),
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: _isSaving ? null : _submit,
                        child: _isSaving
                            ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                            : Text(
                            isEdit
                                ? 'Enregistrer les modifications'
                                : 'Ajouter la salle',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700))),
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

class _EquipementChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _EquipementChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFE5193C).withOpacity(0.15)
              : const Color(0xFF0F0F1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? const Color(0xFFE5193C)
                : Colors.white.withOpacity(0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              const Icon(Icons.check, size: 13, color: Color(0xFFE5193C)),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? const Color(0xFFE5193C) : Colors.white54,
                fontSize: 12,
                fontWeight:
                selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorieSiegesInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const categories = [
      {'label': 'Standard', 'icon': Icons.chair_outlined, 'color': Colors.white54},
      {'label': 'VIP', 'icon': Icons.star_outline, 'color': Color(0xFFE5193C)},
      {'label': 'PMR', 'icon': Icons.accessible_outlined, 'color': Color(0xFF4C9EEB)},
    ];
    return Row(
      children: categories.map((cat) {
        final color = cat['color'] as Color;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Icon(cat['icon'] as IconData, color: color, size: 20),
                const SizedBox(height: 4),
                Text(cat['label'] as String,
                    style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}