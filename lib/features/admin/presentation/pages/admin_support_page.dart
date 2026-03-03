import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:reservation_billet_cinema/core/network/serverpod_provider.dart';

// ============================================================
// PROVIDERS
// ============================================================
final supportRefreshProvider = StateProvider<int>((ref) => 0);

final supportListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(supportRefreshProvider);
  final client = ref.read(serverpodClientProvider);
  final List<String> result = await client.adminSupport.getDemandesSupport();
  return result.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
});

// ============================================================
// PAGE PRINCIPALE
// ============================================================
class AdminSupportPage extends ConsumerStatefulWidget {
  const AdminSupportPage({super.key});
  @override
  ConsumerState<AdminSupportPage> createState() => _AdminSupportPageState();
}

class _AdminSupportPageState extends ConsumerState<AdminSupportPage> {
  String _statutFilter = 'tous';

  void _refresh() => ref.read(supportRefreshProvider.notifier).state++;

  List<Map<String, dynamic>> _filter(List<Map<String, dynamic>> demandes) {
    if (_statutFilter == 'tous') return demandes;
    return demandes.where((d) => d['statut'] == _statutFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final asyncSupport = ref.watch(supportListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Support Client', 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white70), onPressed: _refresh),
        ],
      ),
      body: Column(
        children: [
          _StatutFilterBar(
            selected: _statutFilter,
            onChanged: (v) => setState(() => _statutFilter = v),
          ),
          Expanded(
            child: asyncSupport.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFE5193C))),
              error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: Colors.red))),
              data: (demandes) {
                final filtered = _filter(demandes);
                if (filtered.isEmpty) return const Center(child: Text('Aucune demande trouvée', style: TextStyle(color: Colors.white38)));
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) => _SupportCard(
                    demande: filtered[i],
                    onAction: _refresh,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WIDGETS
// ============================================================

class _SupportCard extends StatelessWidget {
  final Map<String, dynamic> demande;
  final VoidCallback onAction;
  const _SupportCard({required this.demande, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final bool isOuvert = demande['statut'] == 'ouvert';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isOuvert ? Colors.red.withOpacity(0.2) : Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Expanded(child: Text(demande['sujet'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            _StatutBadge(statut: demande['statut']),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(demande['message'], maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person_outline, size: 14, color: Colors.white38),
                const SizedBox(width: 4),
                Text(demande['userName'], style: TextStyle(color: Colors.white38, fontSize: 12)),
                const Spacer(),
                Text(demande['createdAt'].toString().substring(0, 16), style: TextStyle(color: Colors.white24, fontSize: 11)),
              ],
            ),
          ],
        ),
        onTap: () => _showReplyDialog(context),
      ),
    );
  }

  void _showReplyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _ReplyDialog(demande: demande, onAction: onAction),
    );
  }
}

class _ReplyDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic> demande;
  final VoidCallback onAction;
  const _ReplyDialog({required this.demande, required this.onAction});
  @override
  ConsumerState<_ReplyDialog> createState() => _ReplyDialogState();
}

class _ReplyDialogState extends ConsumerState<_ReplyDialog> {
  final _controller = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.demande['reponse'] != null) {
      _controller.text = widget.demande['reponse'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOuvert = widget.demande['statut'] == 'ouvert';

    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(widget.demande['sujet'], style: const TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Message de ${widget.demande['userName']} :', style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 8),
            Text(widget.demande['message'], style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 20),
            const Divider(color: Colors.white10),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              maxLines: 4,
              enabled: isOuvert,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: isOuvert ? 'Tapez votre réponse ici...' : 'Réponse envoyée',
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true, fillColor: const Color(0xFF0F0F1A),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
        if (isOuvert)
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE5193C)),
            onPressed: _loading ? null : () async {
              if (_controller.text.isEmpty) return;
              setState(() => _loading = true);
              try {
                await ref.read(serverpodClientProvider).adminSupport.repondreDemande(widget.demande['id'], _controller.text);
                widget.onAction();
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
              } finally {
                setState(() => _loading = false);
              }
            },
            child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Envoyer la réponse'),
          ),
      ],
    );
  }
}

class _StatutBadge extends StatelessWidget {
  final String statut;
  const _StatutBadge({required this.statut});
  @override
  Widget build(BuildContext context) {
    final bool isOuvert = statut == 'ouvert';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isOuvert ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(statut.toUpperCase(), 
          style: TextStyle(color: isOuvert ? Colors.red : Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}

class _StatutFilterBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _StatutFilterBar({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _filterBtn('tous', 'Toutes'),
          const SizedBox(width: 10),
          _filterBtn('ouvert', 'En attente'),
          const SizedBox(width: 10),
          _filterBtn('ferme', 'Résolues'),
        ],
      ),
    );
  }

  Widget _filterBtn(String val, String label) {
    final bool isSel = selected == val;
    return GestureDetector(
      onTap: () => onChanged(val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFFE5193C) : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(color: isSel ? Colors.white : Colors.white54, fontSize: 13, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }
}
