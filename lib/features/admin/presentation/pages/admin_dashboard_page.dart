import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/admin/data/repositories/admin_repository.dart';

/// Tableau de bord administrateur : indicateurs et raccourcis.
class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  int _filmsCount = 0;
  int _eventsCount = 0;
  int _seancesCount = 0;
  int _usersCount = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    final adminRepo = ref.read(adminRepositoryProvider);
    try {
      final stats = await adminRepo.getDashboardStats();
      if (mounted) {
        setState(() {
          _filmsCount = stats['filmsCount'] ?? 0;
          _eventsCount = stats['eventsCount'] ?? 0;
          _seancesCount = stats['seancesCount'] ?? 0;
          _usersCount = stats['usersCount'] ?? 0;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = _userFriendlyError(e);
        });
      }
    }
  }

  static String _userFriendlyError(Object e) {
    final s = e.toString();
    if (s.contains('deserialization') || s.contains('dynamic')) {
      return 'Erreur de données reçues du serveur. Vérifiez que le backend est à jour et redémarrez-le.';
    }
    if (s.contains('SocketException') || s.contains('Connection') || s.contains('Failed host')) {
      return 'Impossible de joindre le serveur. Démarrez le backend (demarrer_backend.bat) puis réessayez.';
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0d0d0d),
            Color(0xFF1a0a0e),
            Color(0xFF2d0d12),
          ],
        ),
      ),
      child: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vue d\'ensemble',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _StatCard(
                            icon: Icons.movie_rounded,
                            label: 'Films à l\'affiche',
                            value: '$_filmsCount',
                            onTap: () => context.go('/admin/films'),
                          ),
                          _StatCard(
                            icon: Icons.event_rounded,
                            label: 'Événements',
                            value: '$_eventsCount',
                            onTap: () => context.go('/admin/evenements'),
                          ),
                          _StatCard(
                            icon: Icons.schedule_rounded,
                            label: 'Séances',
                            value: '$_seancesCount',
                            onTap: () => context.go('/admin/seances'),
                          ),
                          _StatCard(
                            icon: Icons.people_rounded,
                            label: 'Utilisateurs',
                            value: '$_usersCount',
                            onTap: () => context.go('/admin/utilisateurs'),
                          ),
                        ],
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(_error!, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.start),
                              ),
                              TextButton(onPressed: _load, child: const Text('Réessayer')),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1f1f1f),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.primary, size: 32),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
