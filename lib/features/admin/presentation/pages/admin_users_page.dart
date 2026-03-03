import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:reservation_billet_cinema/core/network/serverpod_provider.dart';

// ============================================================
// PROVIDERS
// ============================================================
final usersRefreshProvider = StateProvider<int>((ref) => 0);

final usersListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(usersRefreshProvider);
  final client = ref.read(serverpodClientProvider);
  final List<String> result = await client.adminUsers.getUtilisateurs();
  return result.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
});

// ============================================================
// PAGE PRINCIPALE
// ============================================================
class AdminUsersPage extends ConsumerStatefulWidget {
  const AdminUsersPage({super.key});
  @override
  ConsumerState<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends ConsumerState<AdminUsersPage> {
  String _searchQuery = '';
  String _statutFilter = 'tous';

  void _refresh() => ref.read(usersRefreshProvider.notifier).state++;

  List<Map<String, dynamic>> _filter(List<Map<String, dynamic>> users) {
    return users.where((u) {
      final matchSearch = _searchQuery.isEmpty ||
          u['nom'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u['email'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (u['telephone']?.toString().contains(_searchQuery) ?? false);
      final matchStatut = _statutFilter == 'tous' || u['statut'] == _statutFilter;
      return matchSearch && matchStatut;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final asyncUsers = ref.watch(usersListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Gestion Utilisateurs',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white70), onPressed: _refresh),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche et filtres
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Rechercher nom, email ou tél...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.search, color: Colors.white38),
                      filled: true, fillColor: const Color(0xFF1A1A2E),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                const SizedBox(width: 12),
                _StatutDropdown(
                  value: _statutFilter,
                  onChanged: (v) => setState(() => _statutFilter = v!),
                ),
              ],
            ),
          ),
          // Liste des utilisateurs
          Expanded(
            child: asyncUsers.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFE5193C))),
              error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: Colors.red))),
              data: (users) {
                final filtered = _filter(users);
                if (filtered.isEmpty) return const Center(child: Text('Aucun utilisateur trouvé', style: TextStyle(color: Colors.white38)));

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) => _UserCard(
                    user: filtered[i],
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

class _UserCard extends ConsumerWidget {
  final Map<String, dynamic> user;
  final VoidCallback onAction;
  const _UserCard({required this.user, required this.onAction});

  void _showHistoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Historique : ${user['nom']}', style: const TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: FutureBuilder<List<String>>(
            future: ref.read(serverpodClientProvider).adminUsers.getHistoriqueAchats(user['id']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: Color(0xFFE5193C))));
              }
              if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}', style: const TextStyle(color: Colors.red));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('Aucun achat trouvé', style: TextStyle(color: Colors.white54), textAlign: TextAlign.center),
                );
              }

              final history = snapshot.data!.map((s) => jsonDecode(s)).toList();
              return ListView.separated(
                shrinkWrap: true,
                itemCount: history.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.white10),
                itemBuilder: (c, i) {
                  final item = history[i];
                  final date = item['date'] != null ? DateTime.tryParse(item['date']) : null;
                  final dateStr = date != null ? '${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}' : 'N/A';
                  
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item['filmTitre'] ?? 'Film inconnu', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    subtitle: Text('$dateStr • ${item['montant']} MAD', style: const TextStyle(color: Colors.white54, fontSize: 13)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (item['statut'] == 'confirmee' ? Colors.green : Colors.orange).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(item['statut'].toString().toUpperCase(), 
                        style: TextStyle(color: item['statut'] == 'confirmee' ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fermer', style: TextStyle(color: Color(0xFFE5193C)))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSuspendu = user['statut'] == 'suspendu';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSuspendu ? Colors.red.withOpacity(0.3) : Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: isSuspendu ? Colors.red.shade900 : const Color(0xFFE5193C),
          child: Text(user['nom'][0].toUpperCase(), style: const TextStyle(color: Colors.white)),
        ),
        title: Row(
          children: [
            Expanded(child: Text(user['nom'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            _StatutBadge(statut: user['statut']),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.email_outlined, size: 14, color: Colors.white38),
                const SizedBox(width: 6),
                Text(user['email'], style: const TextStyle(color: Colors.white54, fontSize: 13)),
              ],
            ),
            if (user['telephone'] != null && user['telephone'].toString().isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.phone_outlined, size: 14, color: Colors.white38),
                  const SizedBox(width: 6),
                  Text(user['telephone'].toString(), style: const TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white54),
          color: const Color(0xFF1A1A2E),
          onSelected: (val) async {
            final client = ref.read(serverpodClientProvider);
            if (val == 'status') {
              await client.adminUsers.changerStatutUtilisateur(user['id'], isSuspendu ? 'actif' : 'suspendu');
              onAction();
            } else if (val == 'delete') {
              await client.adminUsers.supprimerUtilisateur(user['id']);
              onAction();
            } else if (val == 'history') {
              _showHistoryDialog(context, ref);
            }
          },
          itemBuilder: (ctx) => [
            PopupMenuItem(value: 'history', child: Row(children: const [Icon(Icons.history, size: 18, color: Colors.white70), SizedBox(width: 8), Text('Historique', style: TextStyle(color: Colors.white))])),
            PopupMenuItem(value: 'status', child: Row(children: [Icon(isSuspendu ? Icons.check_circle_outline : Icons.block, size: 18, color: Colors.white70), const SizedBox(width: 8), Text(isSuspendu ? 'Réactiver' : 'Suspendre', style: const TextStyle(color: Colors.white))])),
            const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18, color: Colors.redAccent), SizedBox(width: 8), Text('Supprimer', style: TextStyle(color: Colors.red))])),
          ],
        ),
      ),
    );
  }
}

class _StatutBadge extends StatelessWidget {
  final String statut;
  const _StatutBadge({required this.statut});
  @override
  Widget build(BuildContext context) {
    final isActif = statut == 'actif';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActif ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(statut.toUpperCase(),
          style: TextStyle(color: isActif ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}

class _StatutDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  const _StatutDropdown({required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF1A1A2E),
          style: const TextStyle(color: Colors.white),
          items: const [
            DropdownMenuItem(value: 'tous', child: Text('Tous')),
            DropdownMenuItem(value: 'actif', child: Text('Actifs')),
            DropdownMenuItem(value: 'suspendu', child: Text('Suspendus')),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
