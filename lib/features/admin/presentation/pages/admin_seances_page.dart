import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/core/network/serverpod_provider.dart';
import 'dart:convert';

final seancesRefreshProvider = StateProvider<int>((ref) => 0);

final seancesListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(seancesRefreshProvider);
  final client = ref.read(serverpodClientProvider);
  final List<String> result = await client.adminSeances.getSeances();
  return result.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
});

final filmsDisponiblesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final client = ref.read(serverpodClientProvider);
  final List<String> result = await client.adminSeances.getFilmsDisponibles();
  return result.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
});

final sallesDisponiblesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final client = ref.read(serverpodClientProvider);
  final List<String> result = await client.adminSeances.getSallesDisponibles();
  return result.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
});

class AdminSeancesPage extends ConsumerStatefulWidget {
  const AdminSeancesPage({super.key});
  @override
  ConsumerState<AdminSeancesPage> createState() => _AdminSeancesPageState();
}

class _AdminSeancesPageState extends ConsumerState<AdminSeancesPage> {
  String _searchQuery = '';
  String _selectedFiltre = 'Tous';
  static const List<String> _filtres = [
    'Tous',
    "Aujourd'hui",
    'Demain',
    'Cette semaine'
  ];

  void _refresh() =>
      ref
          .read(seancesRefreshProvider.notifier)
          .state++;

  List<Map<String, dynamic>> _filter(List<Map<String, dynamic>> seances) {
    return seances.where((s) {
      final titre = (s['filmTitre'] ?? '').toString().toLowerCase();
      final salle = (s['salleCode'] ?? '').toString().toLowerCase();
      final matchSearch = _searchQuery.isEmpty ||
          titre.contains(_searchQuery.toLowerCase()) ||
          salle.contains(_searchQuery.toLowerCase());
      bool matchDate = true;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dh = s['dateHeure'] != null
          ? DateTime.tryParse(s['dateHeure'])
          : null;
      if (dh != null) {
        final seanceDay = DateTime(dh.year, dh.month, dh.day);
        if (_selectedFiltre == "Aujourd'hui") {
          matchDate = seanceDay == today;
        } else if (_selectedFiltre == 'Demain') {
          matchDate = seanceDay == today.add(const Duration(days: 1));
        } else if (_selectedFiltre == 'Cette semaine') {
          matchDate =
              seanceDay.isAfter(today.subtract(const Duration(days: 1))) &&
                  seanceDay.isBefore(today.add(const Duration(days: 7)));
        }
      }
      return matchSearch && matchDate;
    }).toList()
      ..sort((a, b) {
        final da = DateTime.tryParse(a['dateHeure'] ?? '') ?? DateTime(2099);
        final db = DateTime.tryParse(b['dateHeure'] ?? '') ?? DateTime(2099);
        return da.compareTo(db);
      });
  }

  void _showDialog({Map<String, dynamic>? seance}) async {
    try {
      // On récupère les données du serveur
      final films = await ref.read(filmsDisponiblesProvider.future);
      final salles = await ref.read(sallesDisponiblesProvider.future);

      if (!mounted) return;

      // On affiche la boîte de dialogue seulement si les données sont là
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => SeanceFormDialog(
          seance: seance,
          films: films,
          salles: salles,
          onSave: (data) async {
            final client = ref.read(serverpodClientProvider);
            try {
              if (seance == null) {
                await client.adminSeances.createSeance(
                  filmId: data['filmId'],
                  salleId: data['salleId'],
                  dateHeure: data['dateHeure'],
                  langue: data['langue'],
                  typeProjection: data['typeProjection'],
                  placesDisponibles: data['placesDisponibles'],
                  prix: data['prix'],
                  typeSeance: data['typeSeance'],
                );
                if (mounted) _snack('Séance créée en BD !', Colors.green.shade700);
              } else {
                await client.adminSeances.updateSeance(
                  id: seance['id'],
                  filmId: data['filmId'],
                  salleId: data['salleId'],
                  dateHeure: data['dateHeure'],
                  langue: data['langue'],
                  typeProjection: data['typeProjection'],
                  placesDisponibles: data['placesDisponibles'],
                  prix: data['prix'],
                  typeSeance: data['typeSeance'],
                );
                if (mounted) _snack('Séance modifiée', Colors.green.shade700);
              }
              _refresh();
            } catch (e) {
              if (mounted) _snack('Erreur lors de l\'enregistrement : $e', Colors.red.shade700);
            }
          },
        ),
      );
    } catch (e) {
      // Si ça bloque ici, on affiche l'erreur dans un bandeau rouge
      if (mounted) {
        _snack('Impossible de charger les films/salles : $e', Colors.red.shade800);
      }
    }
  }


  void _delete(Map<String, dynamic> seance) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer la séance', style: TextStyle(color: Colors.white)),
        content: Text('Supprimer la séance de "${seance['filmTitre']}" ?',
            style: TextStyle(color: Colors.white.withOpacity(0.7))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(serverpodClientProvider).adminSeances.deleteSeance(seance['id']);
                _refresh();
                if (mounted) _snack('Séance supprimée', Colors.red.shade600);
              } catch (e) {
                if (mounted) _snack('Erreur : $e', Colors.red.shade700);
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
    final async = ref.watch(seancesListProvider);
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
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white70), onPressed: _refresh),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE5193C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () => _showDialog(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Nouvelle séance', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFE5193C))),
        error: (err, _) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text('Erreur : $err', textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE5193C)),
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ]),
        ),
        data: (seances) {
          final filtered = _filter(seances);
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(children: [
                _StatChip(icon: Icons.event, label: '${seances.length} séances',
                    color: const Color(0xFFE5193C)),
                const SizedBox(width: 8),
                _StatChip(icon: Icons.today, label: '${_countToday(seances)} aujourd\'hui',
                    color: const Color(0xFF60A5FA)),
                const SizedBox(width: 8),
                _StatChip(icon: Icons.people, label: '${_totalBillets(seances)} billets',
                    color: const Color(0xFF4ADE80)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Rechercher film, salle...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
                      prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.4), size: 20),
                      filled: true, fillColor: const Color(0xFF1A1A2E),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(12)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFiltre,
                      dropdownColor: const Color(0xFF1A1A2E),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
                      items: _filtres.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                      onChanged: (v) => setState(() => _selectedFiltre = v!),
                    ),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.event_busy, size: 64, color: Colors.white12),
                const SizedBox(height: 16),
                const Text('Aucune séance trouvée',
                    style: TextStyle(color: Colors.white38, fontSize: 16)),
                const SizedBox(height: 12),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE5193C)),
                  onPressed: () => _showDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter une séance'),
                ),
              ]))
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: filtered.length,
                itemBuilder: (ctx, i) => _SeanceCard(
                  seance: filtered[i],
                  onEdit: () => _showDialog(seance: filtered[i]),
                  onDelete: () => _delete(filtered[i]),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  int _countToday(List<Map<String, dynamic>> seances) {
    final now = DateTime.now();
    return seances.where((s) {
      final dh = DateTime.tryParse(s['dateHeure'] ?? '');
      return dh != null && dh.year == now.year && dh.month == now.month && dh.day == now.day;
    }).length;
  }

  int _totalBillets(List<Map<String, dynamic>> seances) {
    return seances.fold(0, (sum, s) {
      final cap = (s['capaciteTotale'] as num?)?.toInt() ?? 0;
      final dispo = (s['placesDisponibles'] as num?)?.toInt() ?? 0;
      return sum + (cap - dispo);
    });
  }
}

class _SeanceCard extends StatelessWidget {
  final Map<String, dynamic> seance;
  final VoidCallback onEdit, onDelete;
  const _SeanceCard({required this.seance, required this.onEdit, required this.onDelete});

  String _formatDate(DateTime d) {
    const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    return '${days[d.weekday - 1]} ${d.day} ${months[d.month - 1]}';
  }
  String _formatHeure(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}h${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final dh = DateTime.tryParse(seance['dateHeure'] ?? '') ?? DateTime.now();
    final now = DateTime.now();
    final isToday = DateTime(dh.year, dh.month, dh.day) == DateTime(now.year, now.month, now.day);
    final isPast = dh.isBefore(now);
    final cap = (seance['capaciteTotale'] as num?)?.toInt() ?? 1;
    final dispo = (seance['placesDisponibles'] as num?)?.toInt() ?? 0;
    final taux = ((cap - dispo) / cap) * 100;
    Color tauxColor = taux >= 80 ? const Color(0xFF4ADE80)
        : taux >= 50 ? const Color(0xFFF59E0B) : Colors.red.shade400;
    final typeSeance = seance['typeSeance'] ?? 'standard';
    final typeColor = typeSeance == 'vip' ? const Color(0xFFF59E0B)
        : typeSeance == 'premium' ? const Color(0xFFA78BFA) : const Color(0xFF60A5FA);
    final typeProj = seance['typeProjection'] ?? '2D';
    final projColor = typeProj == 'IMAX' ? const Color(0xFF4ADE80)
        : typeProj == '3D' ? const Color(0xFFE5193C) : Colors.white54;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isToday ? const Color(0xFFE5193C).withOpacity(0.3) : Colors.white.withOpacity(0.06)),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
              width: 64,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isToday ? const Color(0xFFE5193C).withOpacity(0.12) : const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(_formatHeure(dh), style: TextStyle(
                    color: isToday ? const Color(0xFFE5193C) : Colors.white,
                    fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(_formatDate(dh), textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 10)),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(seance['filmTitre'] ?? '',
                      style: TextStyle(
                          color: isPast ? Colors.white.withOpacity(0.4) : Colors.white,
                          fontSize: 14, fontWeight: FontWeight.w700),
                      maxLines: 1, overflow: TextOverflow.ellipsis)),
                  if (isPast) _Badge(label: 'Terminé', color: Colors.grey.shade600),
                  if (isToday && !isPast) _Badge(label: 'En cours', color: const Color(0xFF4ADE80)),
                ]),
                const SizedBox(height: 4),
                Text('${seance['salleCode']} — ${seance['cinemanom']}',
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                const SizedBox(height: 8),
                Wrap(spacing: 6, runSpacing: 4, children: [
                  _Tag(label: seance['langue'] ?? 'VF', color: Colors.white54),
                  _Tag(label: typeProj, color: projColor),
                  _Tag(label: typeSeance.toUpperCase(), color: typeColor),
                  _Tag(label: '${(seance['prix'] as num?)?.toStringAsFixed(0) ?? '0'} MAD',
                      color: const Color(0xFF4ADE80), icon: Icons.payments_outlined),
                ]),
              ]),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${taux.toStringAsFixed(0)}%',
                  style: TextStyle(color: tauxColor, fontSize: 16, fontWeight: FontWeight.w800)),
              Text('${cap - dispo}/$cap',
                  style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 11)),
              const SizedBox(height: 6),
              SizedBox(width: 60,
                  child: ClipRRect(borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(value: taux / 100,
                          backgroundColor: const Color(0xFF1A1A2E),
                          valueColor: AlwaysStoppedAnimation(tauxColor), minHeight: 5))),
              const SizedBox(height: 8),
              Row(children: [
                _ActionBtn(icon: Icons.edit_outlined, color: const Color(0xFF60A5FA), onTap: onEdit),
                const SizedBox(width: 4),
                _ActionBtn(icon: Icons.delete_outline, color: Colors.red.shade400, onTap: onDelete),
              ]),
            ]),
          ]),
        ),
      ),
    );
  }
}

class SeanceFormDialog extends StatefulWidget {
  final Map<String, dynamic>? seance;
  final List<Map<String, dynamic>> films;
  final List<Map<String, dynamic>> salles;
  final void Function(Map<String, dynamic>) onSave;
  const SeanceFormDialog({super.key, this.seance, required this.films,
    required this.salles, required this.onSave});
  @override
  State<SeanceFormDialog> createState() => _SeanceFormDialogState();
}

class _SeanceFormDialogState extends State<SeanceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _prixCtrl, _placesCtrl;
  int? _filmId, _salleId;
  String _langue = 'VF', _typeProjection = '2D', _typeSeance = 'standard';
  DateTime _dateHeure = DateTime.now().add(const Duration(hours: 2));
  static const _langues = ['VF', 'VOST', 'VO', 'VF 3D'];
  static const _typesProjection = ['2D', '3D', 'IMAX', '4DX', 'Dolby'];
  static const _typesSeance = ['standard', 'premium', 'vip', 'avant-premiere'];

  @override
  void initState() {
    super.initState();
    final s = widget.seance;
    _prixCtrl = TextEditingController(text: s?['prix']?.toString() ?? '42');
    _placesCtrl = TextEditingController(text: s?['placesDisponibles']?.toString() ?? '');
    _filmId = s != null ? (s['filmId'] as num?)?.toInt() : null;
    _salleId = s != null ? (s['salleId'] as num?)?.toInt() : null;
    _langue = s?['langue'] ?? 'VF';
    _typeProjection = s?['typeProjection'] ?? '2D';
    _typeSeance = s?['typeSeance'] ?? 'standard';
    if (s?['dateHeure'] != null) {
      _dateHeure = DateTime.tryParse(s!['dateHeure']) ?? DateTime.now().add(const Duration(hours: 2));
    }
    if (_filmId == null && widget.films.isNotEmpty) _filmId = (widget.films.first['id'] as num?)?.toInt();
    if (_salleId == null && widget.salles.isNotEmpty) _salleId = (widget.salles.first['id'] as num?)?.toInt();
  }

  @override
  void dispose() { _prixCtrl.dispose(); _placesCtrl.dispose(); super.dispose(); }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(context: context, initialDate: _dateHeure,
        firstDate: DateTime.now(), lastDate: DateTime(2030),
        builder: (ctx, child) => Theme(data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: Color(0xFFE5193C))), child: child!));
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_dateHeure),
        builder: (ctx, child) => Theme(data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: Color(0xFFE5193C))), child: child!));
    if (time == null) return;
    setState(() => _dateHeure = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_filmId == null || _salleId == null) return;
    final salle = widget.salles.firstWhere((s) => (s['id'] as num?)?.toInt() == _salleId, orElse: () => {});
    final capacite = (salle['capacite'] as num?)?.toInt() ?? 100;
    final places = _placesCtrl.text.isEmpty ? capacite : (int.tryParse(_placesCtrl.text) ?? capacite);
    final dateStr = '${_dateHeure.year}-'
        '${_dateHeure.month.toString().padLeft(2, '0')}-'
        '${_dateHeure.day.toString().padLeft(2, '0')} '
        '${_dateHeure.hour.toString().padLeft(2, '0')}:'
        '${_dateHeure.minute.toString().padLeft(2, '0')}:00';
    Navigator.pop(context);
    widget.onSave({'filmId': _filmId, 'salleId': _salleId, 'dateHeure': dateStr,
      'langue': _langue, 'typeProjection': _typeProjection,
      'placesDisponibles': places, 'prix': double.tryParse(_prixCtrl.text) ?? 42.0,
      'typeSeance': _typeSeance});
  }

  String _formatDateTime(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}'
          ' à ${d.hour.toString().padLeft(2, '0')}h${d.minute.toString().padLeft(2, '0')}';

  InputDecoration _dec(String label, {String? hint, IconData? icon}) => InputDecoration(
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

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.seance != null;
    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 680),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 18, 16, 14),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF2A2A3E)))),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFE5193C).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.event_rounded, color: Color(0xFFE5193C), size: 20)),
              const SizedBox(width: 12),
              Text(isEdit ? 'Modifier la séance' : 'Nouvelle séance',
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context)),
            ]),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Form(key: _formKey, child: Column(children: [
                DropdownButtonFormField<int>(
                  value: _filmId, style: const TextStyle(color: Colors.white, fontSize: 14),
                  dropdownColor: const Color(0xFF1A1A2E),
                  decoration: _dec('Film *', icon: Icons.movie_outlined),
                  items: widget.films.map((f) => DropdownMenuItem<int>(
                      value: (f['id'] as num?)?.toInt(), child: Text(f['titre'] ?? ''))).toList(),
                  onChanged: (v) => setState(() => _filmId = v),
                  validator: (v) => v == null ? 'Requis' : null,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<int>(
                  value: _salleId, style: const TextStyle(color: Colors.white, fontSize: 13),
                  dropdownColor: const Color(0xFF1A1A2E),
                  decoration: _dec('Salle *', icon: Icons.weekend_outlined),
                  items: widget.salles.map((s) => DropdownMenuItem<int>(
                      value: (s['id'] as num?)?.toInt(),
                      child: Text('${s['codeSalle']} — ${s['cinemaNom']} (${s['capacite']} places)',
                          overflow: TextOverflow.ellipsis))).toList(),
                  onChanged: (v) => setState(() => _salleId = v),
                  validator: (v) => v == null ? 'Requis' : null,
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: _pickDateTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(color: const Color(0xFF0F0F1A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(0.12))),
                    child: Row(children: [
                      const Icon(Icons.calendar_month_outlined, color: Colors.white38, size: 20),
                      const SizedBox(width: 10),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Date & Heure *', style: TextStyle(
                            color: Colors.white.withOpacity(0.5), fontSize: 11)),
                        Text(_formatDateTime(_dateHeure), style: const TextStyle(
                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                      ]),
                      const Spacer(),
                      const Icon(Icons.edit_outlined, color: Color(0xFFE5193C), size: 18),
                    ]),
                  ),
                ),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: DropdownButtonFormField<String>(
                    value: _langue, style: const TextStyle(color: Colors.white, fontSize: 14),
                    dropdownColor: const Color(0xFF1A1A2E),
                    decoration: _dec('Langue', icon: Icons.language_outlined),
                    items: _langues.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                    onChanged: (v) => setState(() => _langue = v!),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: DropdownButtonFormField<String>(
                    value: _typeProjection, style: const TextStyle(color: Colors.white, fontSize: 14),
                    dropdownColor: const Color(0xFF1A1A2E),
                    decoration: _dec('Projection', icon: Icons.movie_filter_outlined),
                    items: _typesProjection.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) => setState(() => _typeProjection = v!),
                  )),
                ]),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _typeSeance, style: const TextStyle(color: Colors.white, fontSize: 14),
                  dropdownColor: const Color(0xFF1A1A2E),
                  decoration: _dec('Type de séance', icon: Icons.stars_outlined),
                  items: _typesSeance.map((t) => DropdownMenuItem(value: t,
                      child: Text(t.toUpperCase()))).toList(),
                  onChanged: (v) => setState(() => _typeSeance = v!),
                ),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: TextFormField(controller: _prixCtrl,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: _dec('Prix (MAD) *', hint: '42', icon: Icons.payments_outlined),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Requis';
                        if (double.tryParse(v) == null) return 'Nombre invalide';
                        return null;
                      })),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(controller: _placesCtrl,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: _dec('Places dispo', hint: 'Auto si vide',
                          icon: Icons.event_seat_outlined))),
                ]),
              ])),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFF2A2A3E)))),
            child: Row(children: [
              Expanded(child: OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white60,
                    side: const BorderSide(color: Color(0xFF2A2A3E)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              )),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE5193C),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: _submit,
                child: Text(isEdit ? 'Enregistrer' : 'Créer la séance',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              )),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label; final Color color;
  const _Badge({required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)));
}

class _Tag extends StatelessWidget {
  final String label; final Color color; final IconData? icon;
  const _Tag({required this.label, required this.color, this.icon});
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 10, color: color), const SizedBox(width: 3)],
        Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
      ]));
}

class _ActionBtn extends StatelessWidget {
  final IconData icon; final Color color; final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(width: 30, height: 30,
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(7)),
          child: Icon(icon, size: 16, color: color)));
}

class _StatChip extends StatelessWidget {
  final IconData icon; final String label; final Color color;
  const _StatChip({required this.icon, required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.25))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: color), const SizedBox(width: 5),
        Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
      ]));
}
