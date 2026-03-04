import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/features/auth/presentation/providers/auth_provider.dart';
import 'package:reservation_billet_cinema/features/profil/presentation/providers/profil_provider.dart';

class ProfilPage extends ConsumerStatefulWidget {
  const ProfilPage({super.key});

  @override
  ConsumerState<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends ConsumerState<ProfilPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(profilProvider.notifier).loadProfil());
  }

  @override
  Widget build(BuildContext context) {
    final profilState = ref.watch(profilProvider);
    final utilisateur = profilState.utilisateur;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.7, -0.6),
                radius: 1.2,
                colors: [Color(0xFF2A0A0A), Color(0xFF0D0D1A)],
              ),
            ),
          ),
          SafeArea(
            child: profilState.isLoading
                ? const Center(
                child: CircularProgressIndicator(
                    color: Color(0xFFE50914)))
                : CustomScrollView(
              slivers: [
                // ── Header ──────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Mon Profil',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800)),
                            IconButton(
                              onPressed: () =>
                                  context.go('/profil/edit'),
                              icon: const Icon(Icons.edit_outlined,
                                  color: Colors.white70),
                              style: IconButton.styleFrom(
                                backgroundColor:
                                Colors.white.withOpacity(0.08),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        // Avatar
                        Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFE50914),
                                  Color(0xFFB20710)
                                ]),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFE50914)
                                    .withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              utilisateur?.nom.isNotEmpty == true
                                  ? utilisateur!.nom[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          utilisateur?.nom ?? 'Chargement...',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          utilisateur?.email ?? '',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // ── Infos ────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('Informations'),
                        const SizedBox(height: 12),
                        _infoCard([
                          _infoRow(Icons.email_outlined, 'Email',
                              utilisateur?.email ?? '-'),
                          _divider(),
                          _infoRow(Icons.phone_outlined, 'Téléphone',
                              utilisateur?.telephone ?? '-'),
                          _divider(),
                          _infoRow(
                              Icons.cake_outlined,
                              'Date de naissance',
                              utilisateur?.dateNaissance != null
                                  ? '${utilisateur!.dateNaissance!.day.toString().padLeft(2, '0')}/${utilisateur.dateNaissance!.month.toString().padLeft(2, '0')}/${utilisateur.dateNaissance!.year}'
                                  : '-'),
                        ]),
                        const SizedBox(height: 24),

                        // ── Favoris ───────────────────────────────────
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            _sectionTitle('Cinémas favoris'),
                            TextButton(
                              onPressed: () =>
                                  context.go('/profil/favoris'),
                              child: const Text('Voir tout',
                                  style: TextStyle(
                                      color: Color(0xFFE50914),
                                      fontSize: 13)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        profilState.favoris.isEmpty
                            ? _emptyCard(
                            Icons.favorite_border,
                            'Aucun cinéma favori',
                            'Ajoutez des cinémas à vos favoris')
                            : _infoCard([
                          Text(
                              '${profilState.favoris.length} cinéma(s) favori(s)',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14)),
                        ]),
                        const SizedBox(height: 24),

                        // ── Historique ────────────────────────────────
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            _sectionTitle('Historique'),
                            TextButton(
                              onPressed: () =>
                                  context.go('/profil/historique'),
                              child: const Text('Voir tout',
                                  style: TextStyle(
                                      color: Color(0xFFE50914),
                                      fontSize: 13)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _emptyCard(
                            Icons.history,
                            'Aucune réservation',
                            'Vos réservations apparaîtront ici'),
                        const SizedBox(height: 32),

                        // ── Déconnexion ───────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              await ref
                                  .read(authProvider.notifier)
                                  .logout();
                              if (mounted) context.go('/auth/login');
                            },
                            icon: const Icon(Icons.logout_rounded,
                                color: Colors.redAccent, size: 18),
                            label: const Text('Se déconnecter',
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color:
                                  Colors.redAccent.withOpacity(0.4),
                                  width: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700));
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border:
        Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(children: children),
    );
  }

  Widget _emptyCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border:
        Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white30, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              Text(subtitle,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 18),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4), fontSize: 11)),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
        color: Colors.white.withOpacity(0.08), height: 20, thickness: 1);
  }
}