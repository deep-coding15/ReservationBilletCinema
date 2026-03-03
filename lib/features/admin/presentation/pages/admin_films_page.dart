import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';

// ============================================================
// CLIENT SERVERPOD — connexion au serveur
// ============================================================
final serverpodClientProvider = Provider<Client>((ref) {
  return Client('http://localhost:8080');
});

// ============================================================
// PROVIDERS — récupération depuis la base de données
// ============================================================
final filmsRefreshProvider = StateProvider<int>((ref) => 0);

final filmsListProvider = FutureProvider<List<Film>>((ref) async {
  ref.watch(filmsRefreshProvider);
  final client = ref.watch(serverpodClientProvider);
  return await client.adminFilms.getFilms();
});

// ============================================================
// PAGE
// ============================================================
class AdminFilmsPage extends ConsumerStatefulWidget {
  const AdminFilmsPage({super.key});
  @override
  ConsumerState<AdminFilmsPage> createState() => _AdminFilmsPageState();
}

class _AdminFilmsPageState extends ConsumerState<AdminFilmsPage> {
  String _searchQuery = '';
  String? _selectedGenre;

  static const _genres = [
    'Tous', 'Action', 'Aventure', 'Biographie', 'Comédie',
    'Documentaire', 'Drame', 'Fantaisie', 'Horreur', 'Romance',
    'Science-Fiction', 'Thriller',
  ];

  List<Film> _filter(List<Film> films) => films.where((f) {
    final ms = _searchQuery.isEmpty ||
        f.titre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (f.realisateur?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    final mg = _selectedGenre == null || _selectedGenre == 'Tous' || f.genre == _selectedGenre;
    return ms && mg;
  }).toList();

  void _refresh() => ref.read(filmsRefreshProvider.notifier).state++;

  void _showDialog({Film? film}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => FilmFormDialog(
        film: film,
        onSave: (data) async {
          try {
            final client = ref.read(serverpodClientProvider);
            if (film == null) {
              // Créer un nouveau film
              await client.adminFilms.createFilm(data);
              if (mounted) _snack('Film "${data.titre}" ajouté à la BD !', Colors.green.shade700);
            } else {
              // Mettre à jour un film existant
              await client.adminFilms.updateFilm(data);
              if (mounted) _snack('Film "${data.titre}" modifié', Colors.green.shade700);
            }
            _refresh();
          } catch (e) {
            if (mounted) _snack('Erreur : $e', Colors.red.shade600);
          }
        },
      ),
    );
  }

  void _delete(Film film) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirmer la suppression', style: TextStyle(color: Colors.white)),
        content: Text('Supprimer "${film.titre}" ?',
            style: TextStyle(color: Colors.white.withOpacity(0.7))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () async {
              try {
                final client = ref.read(serverpodClientProvider);
                if (film.id != null) {
                  await client.adminFilms.deleteFilm(film.id!);
                  Navigator.pop(context);
                  _refresh();
                  if (mounted) _snack('Film supprimé', Colors.red.shade600);
                }
              } catch (e) {
                Navigator.pop(context);
                if (mounted) _snack('Erreur : $e', Colors.red.shade600);
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
    final async = ref.watch(filmsListProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Gestion des Films',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
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
              label: const Text('Nouveau film', style: TextStyle(fontWeight: FontWeight.w600)),
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
        data: (films) {
          final filtered = _filter(films);
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(children: [
                _Chip(icon: Icons.movie_outlined, label: '${films.length} films',
                    color: const Color(0xFFE5193C)),
                const SizedBox(width: 8),
                if (filtered.length != films.length)
                  _Chip(icon: Icons.filter_list, label: '${filtered.length} résultats',
                      color: const Color(0xFF4C9EEB)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Rechercher par titre ou réalisateur...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                      prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                      filled: true, fillColor: const Color(0xFF1A1A2E),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(12)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedGenre ?? 'Tous',
                      dropdownColor: const Color(0xFF1A1A2E),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
                      items: _genres.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (v) => setState(() => _selectedGenre = v),
                    ),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.movie_creation_outlined, size: 64, color: Colors.white12),
                const SizedBox(height: 16),
                const Text('Aucun film trouvé',
                    style: TextStyle(color: Colors.white38, fontSize: 16)),
                const SizedBox(height: 12),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE5193C)),
                  onPressed: () => _showDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter un film'),
                ),
              ]))
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: filtered.length,
                itemBuilder: (ctx, i) => _FilmCard(
                  film: filtered[i],
                  onEdit: () => _showDialog(film: filtered[i]),
                  onDelete: () => _delete(filtered[i]),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

// ============================================================
// CARTE FILM — champs snake_case
// ============================================================
class _FilmCard extends StatelessWidget {
  final Film film;
  final VoidCallback onEdit, onDelete;
  const _FilmCard({required this.film, required this.onEdit, required this.onDelete});

  String _dur(int m) => '${m ~/ 60}h${(m % 60).toString().padLeft(2, '0')}';
  String _date(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  bool get _isActive => DateTime.now().isBefore(film.date_fin);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _isActive
            ? const Color(0xFFE5193C).withOpacity(0.2)
            : Colors.white.withOpacity(0.06)),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 64, height: 90,
              decoration: BoxDecoration(color: const Color(0xFF0F0F1A),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.movie, color: Colors.white24, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(film.titre,
                    style: const TextStyle(color: Colors.white, fontSize: 16,
                        fontWeight: FontWeight.w700),
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _isActive ? Colors.green.shade900.withOpacity(0.7) : Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(_isActive ? 'En affiche' : 'Terminé',
                      style: TextStyle(
                          color: _isActive ? Colors.green.shade300 : Colors.grey.shade400,
                          fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ]),
              const SizedBox(height: 4),
              if (film.realisateur != null)
                Text(film.realisateur!,
                    style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 4, children: [
                if (film.genre != null) _Tag(label: film.genre!, color: const Color(0xFF4C9EEB)),
                _Tag(label: _dur(film.duree), color: Colors.white54, icon: Icons.access_time),
                _Tag(label: film.classification ?? 'T.P', color: Colors.amber.shade600),
                _Tag(label: '★ ${(film.note_moyenne ?? 0).toStringAsFixed(1)}',
                    color: Colors.amber.shade400),
              ]),
              const SizedBox(height: 8),
              Text('${_date(film.date_debut)} → ${_date(film.date_fin)}',
                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
            ])),
            Column(children: [
              IconButton(icon: const Icon(Icons.edit_outlined, size: 20),
                  color: const Color(0xFF4C9EEB), onPressed: onEdit),
              IconButton(icon: const Icon(Icons.delete_outline, size: 20),
                  color: Colors.red.shade400, onPressed: onDelete),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon; final String label; final Color color;
  const _Chip({required this.icon, required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: color), const SizedBox(width: 6),
      Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _Tag extends StatelessWidget {
  final String label; final Color color; final IconData? icon;
  const _Tag({required this.label, required this.color, this.icon});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (icon != null) ...[Icon(icon, size: 11, color: color), const SizedBox(width: 3)],
      Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    ]),
  );
}

// ============================================================
// DIALOG FORMULAIRE — champs snake_case
// ============================================================
class FilmFormDialog extends StatefulWidget {
  final Film? film;
  final void Function(Film) onSave;
  const FilmFormDialog({super.key, this.film, required this.onSave});
  @override
  State<FilmFormDialog> createState() => _FilmFormDialogState();
}

class _FilmFormDialogState extends State<FilmFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titreCtrl, _synopsisCtrl, _dureeCtrl,
      _realisateurCtrl, _castingCtrl, _afficheCtrl, _bandeAnnonceCtrl;
  String _genre = 'Action', _classification = 'Tous publics';
  DateTime _dateDebut = DateTime.now(), _dateFin = DateTime.now().add(const Duration(days: 60));

  static const _genres = ['Action','Aventure','Biographie','Comédie','Documentaire',
    'Drame','Fantaisie','Horreur','Romance','Science-Fiction','Thriller'];
  static const _classifications = ['Tous publics','Interdit moins de 10 ans',
    'Interdit moins de 12 ans','Interdit moins de 16 ans','Interdit moins de 18 ans'];

  @override
  void initState() {
    super.initState();
    final f = widget.film;
    _titreCtrl        = TextEditingController(text: f?.titre ?? '');
    _synopsisCtrl     = TextEditingController(text: f?.synopsis ?? '');
    _dureeCtrl        = TextEditingController(text: f != null ? f.duree.toString() : '');
    _realisateurCtrl  = TextEditingController(text: f?.realisateur ?? '');
    _castingCtrl      = TextEditingController(text: f?.casting?.join(', ') ?? '');
    _afficheCtrl      = TextEditingController(text: f?.affiche ?? '');
    _bandeAnnonceCtrl = TextEditingController(text: f?.bande_annonce ?? '');
    _genre            = f?.genre ?? 'Action';
    _classification   = f?.classification ?? 'Tous publics';
    _dateDebut        = f?.date_debut ?? DateTime.now();
    _dateFin          = f?.date_fin ?? DateTime.now().add(const Duration(days: 60));
  }

  @override
  void dispose() {
    _titreCtrl.dispose(); _synopsisCtrl.dispose(); _dureeCtrl.dispose();
    _realisateurCtrl.dispose(); _castingCtrl.dispose();
    _afficheCtrl.dispose(); _bandeAnnonceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _dateDebut : _dateFin,
      firstDate: DateTime(2020), lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: Color(0xFFE5193C))),
        child: child!,
      ),
    );
    if (picked != null) setState(() => isStart ? _dateDebut = picked : _dateFin = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final casting = _castingCtrl.text.split(',')
        .map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    widget.onSave(Film(
      id: widget.film?.id,
      titre: _titreCtrl.text.trim(),
      synopsis: _synopsisCtrl.text.trim().isEmpty ? null : _synopsisCtrl.text.trim(),
      genre: _genre,
      duree: int.tryParse(_dureeCtrl.text) ?? 90,
      realisateur: _realisateurCtrl.text.trim().isEmpty ? null : _realisateurCtrl.text.trim(),
      casting: casting.isEmpty ? null : casting,
      affiche: _afficheCtrl.text.trim().isEmpty ? null : _afficheCtrl.text.trim(),
      bande_annonce: _bandeAnnonceCtrl.text.trim().isEmpty ? null : _bandeAnnonceCtrl.text.trim(),
      classification: _classification,
      note_moyenne: widget.film?.note_moyenne ?? 0.0,
      date_debut: _dateDebut,
      date_fin: _dateFin,
    ));
    Navigator.pop(context);
  }

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

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.film != null;
    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 700),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF2A2A3E)))),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFE5193C).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.movie_creation_outlined,
                      color: Color(0xFFE5193C), size: 22)),
              const SizedBox(width: 12),
              Text(isEdit ? 'Modifier le film' : 'Nouveau film',
                  style: const TextStyle(color: Colors.white, fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context)),
            ]),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  TextFormField(controller: _titreCtrl, style: const TextStyle(color: Colors.white),
                      decoration: _dec('Titre *', hint: 'Ex: Dune', icon: Icons.title),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null),
                  const SizedBox(height: 14),
                  TextFormField(controller: _synopsisCtrl, style: const TextStyle(color: Colors.white),
                      maxLines: 3, decoration: _dec('Synopsis', icon: Icons.description_outlined)),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(child: _DD(label: 'Genre', value: _genre, items: _genres,
                        onChanged: (v) => setState(() => _genre = v!),
                        icon: Icons.category_outlined)),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _dureeCtrl,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: _dec('Durée (min) *', hint: '120', icon: Icons.access_time),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Requis';
                          if (int.tryParse(v) == null) return 'Entier';
                          return null;
                        })),
                  ]),
                  const SizedBox(height: 14),
                  TextFormField(controller: _realisateurCtrl, style: const TextStyle(color: Colors.white),
                      decoration: _dec('Réalisateur', icon: Icons.person_outline)),
                  const SizedBox(height: 14),
                  TextFormField(controller: _castingCtrl, style: const TextStyle(color: Colors.white),
                      decoration: _dec('Casting (virgules)', icon: Icons.groups_outlined)),
                  const SizedBox(height: 14),
                  _DD(label: 'Classification', value: _classification, items: _classifications,
                      onChanged: (v) => setState(() => _classification = v!),
                      icon: Icons.shield_outlined),
                  const SizedBox(height: 14),
                  TextFormField(controller: _afficheCtrl, style: const TextStyle(color: Colors.white),
                      decoration: _dec('URL Affiche', hint: 'https://', icon: Icons.image_outlined)),
                  const SizedBox(height: 14),
                  TextFormField(controller: _bandeAnnonceCtrl, style: const TextStyle(color: Colors.white),
                      decoration: _dec('URL Bande-annonce', icon: Icons.play_circle_outline)),
                  const SizedBox(height: 14),
                  const Text('Période de diffusion *',
                      style: TextStyle(color: Colors.white60, fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: _DateBtn(label: 'Date début', value: _fmt(_dateDebut),
                        icon: Icons.calendar_today_outlined, onTap: () => _pickDate(true))),
                    const SizedBox(width: 12),
                    Expanded(child: _DateBtn(label: 'Date fin', value: _fmt(_dateFin),
                        icon: Icons.event_outlined, onTap: () => _pickDate(false))),
                  ]),
                ]),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF2A2A3E)))),
            child: Row(children: [
              Expanded(child: OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white60,
                    side: const BorderSide(color: Color(0xFF2A2A3E)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              )),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE5193C),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: _submit,
                child: Text(isEdit ? 'Enregistrer' : 'Ajouter le film',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              )),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _DD extends StatelessWidget {
  final String label, value; final List<String> items;
  final ValueChanged<String?> onChanged; final IconData? icon;
  const _DD({required this.label, required this.value, required this.items,
    required this.onChanged, this.icon});
  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    value: value, style: const TextStyle(color: Colors.white),
    dropdownColor: const Color(0xFF1A1A2E),
    decoration: InputDecoration(labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: icon != null ? Icon(icon, color: Colors.white38, size: 20) : null,
        filled: true, fillColor: const Color(0xFF0F0F1A),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5193C)))),
    items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
    onChanged: onChanged,
  );
}

class _DateBtn extends StatelessWidget {
  final String label, value; final IconData icon; final VoidCallback onTap;
  const _DateBtn({required this.label, required this.value,
    required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(color: const Color(0xFF0F0F1A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.12))),
      child: Row(children: [
        Icon(icon, size: 18, color: Colors.white38), const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14,
              fontWeight: FontWeight.w600)),
        ]),
      ]),
    ),
  );
}


