import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ============================================================
// MODÈLES LOCAUX (mockés)
// ============================================================
class SeanceItem {
  final int? id;
  final int filmId;
  final int salleId;
  final String filmTitre;
  final String salleCode;
  final String cinemanom;
  final DateTime dateHeure;
  final String langue;
  final String typeProjection;
  final int placesDisponibles;
  final int capaciteTotale;
  final double prix;
  final String typeSeance;

  SeanceItem({
    this.id,
    required this.filmId,
    required this.salleId,
    required this.filmTitre,
    required this.salleCode,
    required this.cinemanom,
    required this.dateHeure,
    required this.langue,
    required this.typeProjection,
    required this.placesDisponibles,
    required this.capaciteTotale,
    required this.prix,
    required this.typeSeance,
  });

  double get tauxRemplissage =>
      ((capaciteTotale - placesDisponibles) / capaciteTotale) * 100;

  SeanceItem copyWith({
    int? id,
    int? filmId,
    int? salleId,
    String? filmTitre,
    String? salleCode,
    String? cinemanom,
    DateTime? dateHeure,
    String? langue,
    String? typeProjection,
    int? placesDisponibles,
    int? capaciteTotale,
    double? prix,
    String? typeSeance,
  }) {
    return SeanceItem(
      id: id ?? this.id,
      filmId: filmId ?? this.filmId,
      salleId: salleId ?? this.salleId,
      filmTitre: filmTitre ?? this.filmTitre,
      salleCode: salleCode ?? this.salleCode,
      cinemanom: cinemanom ?? this.cinemanom,
      dateHeure: dateHeure ?? this.dateHeure,
      langue: langue ?? this.langue,
      typeProjection: typeProjection ?? this.typeProjection,
      placesDisponibles: placesDisponibles ?? this.placesDisponibles,
      capaciteTotale: capaciteTotale ?? this.capaciteTotale,
      prix: prix ?? this.prix,
      typeSeance: typeSeance ?? this.typeSeance,
    );
  }
}

// ============================================================
// DONNÉES MOCKÉES
// ============================================================
final List<SeanceItem> _mockSeances = [
  SeanceItem(id: 1, filmId: 1, salleId: 1, filmTitre: 'Dune: Deuxième Partie',
      salleCode: 'Salle 1', cinemanom: 'CinePass Tétouan',
      dateHeure: DateTime(2026, 3, 1, 10, 0), langue: 'VF',
      typeProjection: '2D', placesDisponibles: 75, capaciteTotale: 120,
      prix: 42.0, typeSeance: 'standard'),
  SeanceItem(id: 2, filmId: 1, salleId: 2, filmTitre: 'Dune: Deuxième Partie',
      salleCode: 'IMAX', cinemanom: 'CinePass Tétouan',
      dateHeure: DateTime(2026, 3, 1, 14, 30), langue: 'VOST',
      typeProjection: 'IMAX', placesDisponibles: 22, capaciteTotale: 150,
      prix: 85.0, typeSeance: 'premium'),
  SeanceItem(id: 3, filmId: 2, salleId: 3, filmTitre: 'Oppenheimer',
      salleCode: 'Salle 2', cinemanom: 'CinePass Tétouan',
      dateHeure: DateTime(2026, 3, 1, 12, 0), langue: 'VF',
      typeProjection: '2D', placesDisponibles: 12, capaciteTotale: 110,
      prix: 42.0, typeSeance: 'standard'),
  SeanceItem(id: 4, filmId: 3, salleId: 4, filmTitre: 'Le Comte de Monte-Cristo',
      salleCode: 'Salle VIP', cinemanom: 'CinePass Tétouan',
      dateHeure: DateTime(2026, 3, 1, 16, 0), langue: 'VF',
      typeProjection: '3D', placesDisponibles: 2, capaciteTotale: 30,
      prix: 120.0, typeSeance: 'vip'),
  SeanceItem(id: 5, filmId: 2, salleId: 1, filmTitre: 'Oppenheimer',
      salleCode: 'Salle 1', cinemanom: 'CinePass Tétouan',
      dateHeure: DateTime(2026, 3, 2, 19, 0), langue: 'VOST',
      typeProjection: '2D', placesDisponibles: 55, capaciteTotale: 120,
      prix: 42.0, typeSeance: 'standard'),
  SeanceItem(id: 6, filmId: 1, salleId: 3, filmTitre: 'Dune: Deuxième Partie',
      salleCode: 'Salle 3', cinemanom: 'CinePass Tanger',
      dateHeure: DateTime(2026, 3, 2, 21, 30), langue: 'VF',
      typeProjection: '3D', placesDisponibles: 88, capaciteTotale: 100,
      prix: 60.0, typeSeance: 'standard'),
];

// Films et salles disponibles pour le formulaire
const List<Map<String, dynamic>> _mockFilms = [
  {'id': 1, 'titre': 'Dune: Deuxième Partie'},
  {'id': 2, 'titre': 'Oppenheimer'},
  {'id': 3, 'titre': 'Le Comte de Monte-Cristo'},
  {'id': 4, 'titre': 'Avatar 3'},
];

const List<Map<String, dynamic>> _mockSalles = [
  {'id': 1, 'code': 'Salle 1', 'cinema': 'CinePass Tétouan', 'capacite': 120},
  {'id': 2, 'code': 'IMAX', 'cinema': 'CinePass Tétouan', 'capacite': 150},
  {'id': 3, 'code': 'Salle 2', 'cinema': 'CinePass Tétouan', 'capacite': 110},
  {'id': 4, 'code': 'Salle VIP', 'cinema': 'CinePass Tétouan', 'capacite': 30},
  {'id': 5, 'code': 'Salle 3', 'cinema': 'CinePass Tanger', 'capacite': 100},
];

// ============================================================
// PAGE PRINCIPALE
// ============================================================
class AdminSeancesPage extends StatefulWidget {
  const AdminSeancesPage({super.key});

  @override
  State<AdminSeancesPage> createState() => _AdminSeancesPageState();
}

class _AdminSeancesPageState extends State<AdminSeancesPage> {
  List<SeanceItem> _seances = List.from(_mockSeances);
  String _searchQuery = '';
  String _selectedFiltre = 'Tous';
  DateTime? _selectedDate;
  bool _isLoading = false;

  static const List<String> _filtres = [
    'Tous', 'Aujourd\'hui', 'Demain', 'Cette semaine',
  ];

  List<SeanceItem> get _filtered {
    return _seances.where((s) {
      final matchSearch = _searchQuery.isEmpty ||
          s.filmTitre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.salleCode.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchDate = true;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final seanceDay = DateTime(s.dateHeure.year, s.dateHeure.month, s.dateHeure.day);

      if (_selectedFiltre == 'Aujourd\'hui') {
        matchDate = seanceDay == today;
      } else if (_selectedFiltre == 'Demain') {
        matchDate = seanceDay == today.add(const Duration(days: 1));
      } else if (_selectedFiltre == 'Cette semaine') {
        matchDate = seanceDay.isAfter(today.subtract(const Duration(days: 1))) &&
            seanceDay.isBefore(today.add(const Duration(days: 7)));
      }

      return matchSearch && matchDate;
    }).toList()
      ..sort((a, b) => a.dateHeure.compareTo(b.dateHeure));
  }

  void _showSeanceDialog({SeanceItem? seance}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SeanceFormDialog(
        seance: seance,
        films: _mockFilms,
        salles: _mockSalles,
        onSave: (updated) {
          setState(() {
            if (seance == null) {
              _seances.add(updated.copyWith(id: _seances.length + 1));
            } else {
              final idx = _seances.indexWhere((s) => s.id == seance.id);
              if (idx != -1) _seances[idx] = updated;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(seance == null ? 'Séance ajoutée avec succès' : 'Séance modifiée'),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
          ));
        },
      ),
    );
  }

  void _deleteSeance(SeanceItem seance) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer la séance', style: TextStyle(color: Colors.white)),
        content: Text(
          'Supprimer la séance de "${seance.filmTitre}" du ${_formatDate(seance.dateHeure)} à ${_formatHeure(seance.dateHeure)} ?',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () {
              setState(() => _seances.removeWhere((s) => s.id == seance.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Séance supprimée'),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
              ));
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _formatHeure(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}h${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFF080810),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
          onPressed: () => context.go('/admin/dashboard'),
        ),
        title: const Text('Gestion des Séances',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE5193C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () => _showSeanceDialog(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Nouvelle séance', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Stats ──────────────────────────────────────────
          _buildStats(filtered),

          // ── Filtres ────────────────────────────────────────
          _buildFiltres(),

          // ── Liste ──────────────────────────────────────────
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFE5193C)))
                : filtered.isEmpty
                ? _EmptyState(onAdd: () => _showSeanceDialog())
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: filtered.length,
              itemBuilder: (ctx, i) => _SeanceCard(
                seance: filtered[i],
                onEdit: () => _showSeanceDialog(seance: filtered[i]),
                onDelete: () => _deleteSeance(filtered[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(List<SeanceItem> filtered) {
    final today = DateTime.now();
    final seancesToday = _seances.where((s) =>
    s.dateHeure.year == today.year &&
        s.dateHeure.month == today.month &&
        s.dateHeure.day == today.day).length;
    final totalPlaces = _seances.fold<int>(0, (sum, s) => sum + (s.capaciteTotale - s.placesDisponibles));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _StatChip(icon: Icons.event, label: '${_seances.length} séances', color: const Color(0xFFE5193C)),
          const SizedBox(width: 8),
          _StatChip(icon: Icons.today, label: '$seancesToday aujourd\'hui', color: const Color(0xFF60A5FA)),
          const SizedBox(width: 8),
          _StatChip(icon: Icons.people, label: '$totalPlaces billets vendus', color: const Color(0xFF4ADE80)),
        ],
      ),
    );
  }

  Widget _buildFiltres() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Rechercher film, salle...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
                prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.4), size: 20),
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          const SizedBox(width: 10),
          // Filtre date
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFiltre,
                dropdownColor: const Color(0xFF1A1A2E),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
                items: _filtres
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedFiltre = v!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WIDGET — CARTE SÉANCE
// ============================================================
class _SeanceCard extends StatelessWidget {
  final SeanceItem seance;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SeanceCard({
    required this.seance,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDate(DateTime d) {
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    return '${days[d.weekday - 1]} ${d.day} ${months[d.month - 1]}';
  }

  String _formatHeure(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}h${d.minute.toString().padLeft(2, '0')}';

  Color get _typeColor {
    switch (seance.typeSeance) {
      case 'vip': return const Color(0xFFF59E0B);
      case 'premium': return const Color(0xFFA78BFA);
      default: return const Color(0xFF60A5FA);
    }
  }

  Color get _projColor {
    switch (seance.typeProjection) {
      case 'IMAX': return const Color(0xFF4ADE80);
      case '3D': return const Color(0xFFE5193C);
      default: return Colors.white54;
    }
  }

  Color get _tauxColor {
    final t = seance.tauxRemplissage;
    if (t >= 80) return const Color(0xFF4ADE80);
    if (t >= 50) return const Color(0xFFF59E0B);
    return Colors.red.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final taux = seance.tauxRemplissage;
    final isToday = () {
      final now = DateTime.now();
      return seance.dateHeure.year == now.year &&
          seance.dateHeure.month == now.month &&
          seance.dateHeure.day == now.day;
    }();
    final isPast = seance.dateHeure.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isToday
              ? const Color(0xFFE5193C).withOpacity(0.3)
              : Colors.white.withOpacity(0.06),
        ),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Date/Heure bloc
              Container(
                width: 64,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isToday
                      ? const Color(0xFFE5193C).withOpacity(0.12)
                      : const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatHeure(seance.dateHeure),
                      style: TextStyle(
                        color: isToday ? const Color(0xFFE5193C) : Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(seance.dateHeure),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.45),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Infos principales
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            seance.filmTitre,
                            style: TextStyle(
                              color: isPast
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isPast)
                          _Badge(label: 'Terminé', color: Colors.grey.shade600),
                        if (isToday && !isPast)
                          _Badge(label: 'En cours', color: const Color(0xFF4ADE80)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${seance.salleCode} — ${seance.cinemanom}',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5), fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _Tag(label: seance.langue, color: Colors.white54),
                        _Tag(label: seance.typeProjection, color: _projColor),
                        _Tag(label: seance.typeSeance.toUpperCase(), color: _typeColor),
                        _Tag(
                          label: '${seance.prix.toStringAsFixed(0)} MAD',
                          color: const Color(0xFF4ADE80),
                          icon: Icons.payments_outlined,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Taux remplissage + actions
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${taux.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: _tauxColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${seance.capaciteTotale - seance.placesDisponibles}/${seance.capaciteTotale}',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.35), fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: taux / 100,
                        backgroundColor: const Color(0xFF1A1A2E),
                        valueColor: AlwaysStoppedAnimation(_tauxColor),
                        minHeight: 5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _ActionBtn(
                        icon: Icons.edit_outlined,
                        color: const Color(0xFF60A5FA),
                        onTap: onEdit,
                      ),
                      const SizedBox(width: 4),
                      _ActionBtn(
                        icon: Icons.delete_outline,
                        color: Colors.red.shade400,
                        onTap: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
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
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 3),
          ],
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(icon, size: 16, color: color),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w600)),
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
          Icon(Icons.event_busy, size: 64, color: Colors.white12),
          const SizedBox(height: 16),
          const Text('Aucune séance trouvée',
              style: TextStyle(color: Colors.white38, fontSize: 16)),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE5193C)),
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Ajouter une séance'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DIALOG — FORMULAIRE SÉANCE
// ============================================================
class SeanceFormDialog extends StatefulWidget {
  final SeanceItem? seance;
  final List<Map<String, dynamic>> films;
  final List<Map<String, dynamic>> salles;
  final void Function(SeanceItem) onSave;

  const SeanceFormDialog({
    super.key,
    this.seance,
    required this.films,
    required this.salles,
    required this.onSave,
  });

  @override
  State<SeanceFormDialog> createState() => _SeanceFormDialogState();
}

class _SeanceFormDialogState extends State<SeanceFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _prixCtrl;
  late TextEditingController _placesCtrl;

  int? _selectedFilmId;
  int? _selectedSalleId;
  String _langue = 'VF';
  String _typeProjection = '2D';
  String _typeSeance = 'standard';
  DateTime _dateHeure = DateTime.now().add(const Duration(hours: 2));

  static const List<String> _langues = ['VF', 'VOST', 'VO', 'VF 3D'];
  static const List<String> _typesProjection = ['2D', '3D', 'IMAX', '4DX', 'Dolby'];
  static const List<String> _typesSeance = ['standard', 'premium', 'vip', 'avant-premiere'];

  @override
  void initState() {
    super.initState();
    final s = widget.seance;
    _prixCtrl = TextEditingController(text: s?.prix.toString() ?? '42');
    _placesCtrl = TextEditingController(text: s?.placesDisponibles.toString() ?? '');
    _selectedFilmId = s?.filmId ?? widget.films.first['id'] as int;
    _selectedSalleId = s?.salleId ?? widget.salles.first['id'] as int;
    _langue = s?.langue ?? 'VF';
    _typeProjection = s?.typeProjection ?? '2D';
    _typeSeance = s?.typeSeance ?? 'standard';
    _dateHeure = s?.dateHeure ?? DateTime.now().add(const Duration(hours: 2));
  }

  @override
  void dispose() {
    _prixCtrl.dispose();
    _placesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateHeure,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: Color(0xFFE5193C))),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateHeure),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: Color(0xFFE5193C))),
        child: child!,
      ),
    );
    if (time == null) return;

    setState(() {
      _dateHeure = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFilmId == null || _selectedSalleId == null) return;

    final film = widget.films.firstWhere((f) => f['id'] == _selectedFilmId);
    final salle = widget.salles.firstWhere((s) => s['id'] == _selectedSalleId);
    final capacite = salle['capacite'] as int;
    final placesDisponibles = int.tryParse(_placesCtrl.text) ?? capacite;

    final seance = SeanceItem(
      id: widget.seance?.id,
      filmId: _selectedFilmId!,
      salleId: _selectedSalleId!,
      filmTitre: film['titre'] as String,
      salleCode: salle['code'] as String,
      cinemanom: salle['cinema'] as String,
      dateHeure: _dateHeure,
      langue: _langue,
      typeProjection: _typeProjection,
      placesDisponibles: placesDisponibles,
      capaciteTotale: capacite,
      prix: double.tryParse(_prixCtrl.text) ?? 42.0,
      typeSeance: _typeSeance,
    );

    Navigator.pop(context);
    widget.onSave(seance);
  }

  String _formatDateTime(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} à ${d.hour.toString().padLeft(2, '0')}h${d.minute.toString().padLeft(2, '0')}';

  InputDecoration _dec(String label, {String? hint, IconData? icon}) {
    return InputDecoration(
      labelText: label, hintText: hint,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.25)),
      prefixIcon: icon != null ? Icon(icon, color: Colors.white38, size: 20) : null,
      filled: true, fillColor: const Color(0xFF0F0F1A),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5193C))),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.seance != null;

    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 680),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 18, 16, 14),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFF2A2A3E)))),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5193C).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.event_rounded,
                        color: Color(0xFFE5193C), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(isEdit ? 'Modifier la séance' : 'Nouvelle séance',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
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
                padding: const EdgeInsets.all(22),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Film
                      _FormDropdown<int>(
                        label: 'Film *',
                        value: _selectedFilmId,
                        items: widget.films
                            .map((f) => DropdownMenuItem<int>(
                            value: f['id'] as int,
                            child: Text(f['titre'] as String)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedFilmId = v),
                        icon: Icons.movie_outlined,
                      ),
                      const SizedBox(height: 14),

                      // Salle
                      _FormDropdown<int>(
                        label: 'Salle *',
                        value: _selectedSalleId,
                        items: widget.salles
                            .map((s) => DropdownMenuItem<int>(
                            value: s['id'] as int,
                            child: Text('${s['code']} — ${s['cinema']} (${s['capacite']} places)')))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedSalleId = v),
                        icon: Icons.weekend_outlined,
                      ),
                      const SizedBox(height: 14),

                      // Date & Heure
                      GestureDetector(
                        onTap: _pickDateTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F0F1A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white.withOpacity(0.12)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined,
                                  color: Colors.white38, size: 20),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date & Heure *',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 11)),
                                  Text(_formatDateTime(_dateHeure),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const Spacer(),
                              Icon(Icons.edit_outlined,
                                  color: const Color(0xFFE5193C), size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Langue + Type projection
                      Row(
                        children: [
                          Expanded(
                            child: _FormDropdown<String>(
                              label: 'Langue',
                              value: _langue,
                              items: _langues
                                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                                  .toList(),
                              onChanged: (v) => setState(() => _langue = v!),
                              icon: Icons.language_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _FormDropdown<String>(
                              label: 'Projection',
                              value: _typeProjection,
                              items: _typesProjection
                                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                  .toList(),
                              onChanged: (v) => setState(() => _typeProjection = v!),
                              icon: Icons.movie_filter_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Type séance
                      _FormDropdown<String>(
                        label: 'Type de séance',
                        value: _typeSeance,
                        items: _typesSeance
                            .map((t) => DropdownMenuItem(value: t, child: Text(t.toUpperCase())))
                            .toList(),
                        onChanged: (v) => setState(() => _typeSeance = v!),
                        icon: Icons.stars_outlined,
                      ),
                      const SizedBox(height: 14),

                      // Prix + Places
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _prixCtrl,
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              decoration: _dec('Prix (MAD) *',
                                  hint: 'Ex: 42', icon: Icons.payments_outlined),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Requis';
                                if (double.tryParse(v) == null) return 'Nombre';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _placesCtrl,
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              decoration: _dec('Places dispo',
                                  hint: 'Auto si vide',
                                  icon: Icons.event_seat_outlined),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFF2A2A3E)))),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white60,
                        side: const BorderSide(color: Color(0xFF2A2A3E)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFE5193C),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _submit,
                      child: Text(
                        isEdit ? 'Enregistrer' : 'Créer la séance',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
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

// Widget dropdown générique pour le formulaire
class _FormDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final IconData? icon;

  const _FormDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      dropdownColor: const Color(0xFF1A1A2E),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: icon != null ? Icon(icon, color: Colors.white38, size: 20) : null,
        filled: true,
        fillColor: const Color(0xFF0F0F1A),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5193C))),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}