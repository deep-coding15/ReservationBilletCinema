import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/auth/presentation/providers/auth_provider.dart';
import 'package:reservation_billet_cinema/features/splash/presentation/pages/splash_page.dart' show kAppName;

/// Shell commun à toutes les pages : barre du haut (avec Espace admin si admin) + drawer + barre du bas.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.currentPath, required this.child});

  final String currentPath;
  final Widget child;

  int _selectedIndex() {
    final loc = currentPath;
    if (loc == '/' || loc.startsWith('/splash')) return 0;
    if (loc.startsWith('/films')) return 1;
    if (loc.startsWith('/events') || loc.startsWith('/reservation-event')) return 2;
    if (loc.startsWith('/billets')) return 3;
    if (loc.startsWith('/profil')) return 4;
    return -1; // pas sur un onglet principal
  }

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/films');
        break;
      case 2:
        GoRouter.of(context).go('/events');
        break;
      case 3:
        GoRouter.of(context).go('/billets');
        break;
      case 4:
        GoRouter.of(context).go('/profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = _selectedIndex();
    final auth = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        title: Text(
          kAppName,
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (!auth.isAuthenticated) ...[
            TextButton(
              onPressed: () => GoRouter.of(context).go('/auth/login'),
              child: const Text('Connexion', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
            TextButton(
              onPressed: () => GoRouter.of(context).go('/auth/register'),
              child: const Text('Inscription', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
            ),
          ],
          if (auth.isAuthenticated)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Tooltip(
                message: 'Ouvrir l\'espace administrateur',
                child: Material(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () => GoRouter.of(context).go('/admin'),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary, size: 22),
                          const SizedBox(width: 8),
                          Text('Admin space', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      drawer: _AppDrawer(shellContext: context),
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_rounded, label: 'Accueil', selected: idx == 0, onTap: () => _onNavTap(context, 0)),
                _NavItem(icon: Icons.movie_rounded, label: 'Films', selected: idx == 1, onTap: () => _onNavTap(context, 1)),
                _NavItem(icon: Icons.event_rounded, label: 'Événements', selected: idx == 2, onTap: () => _onNavTap(context, 2)),
                _NavItem(icon: Icons.confirmation_number_rounded, label: 'Billets', selected: idx == 3, onTap: () => _onNavTap(context, 3)),
                _NavItem(icon: Icons.person_rounded, label: 'Profil', selected: idx == 4, onTap: () => _onNavTap(context, 4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppDrawer extends ConsumerWidget {
  const _AppDrawer({required this.shellContext});

  final BuildContext shellContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return Drawer(
      backgroundColor: const Color(0xFF121212),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1a1a1a),
                    AppColors.primary.withValues(alpha: 0.08),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(color: AppColors.neon.withValues(alpha: 0.2), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accent, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(Icons.movie_filter_rounded, color: AppColors.accent, size: 28),
                  ),
                  const SizedBox(width: 14),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.white, AppColors.neon.withValues(alpha: 0.9)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: Text(
                      kAppName,
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _DrawerTile(icon: Icons.home_rounded, label: 'Accueil', onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(shellContext)?.settings.name != '/') GoRouter.of(shellContext).go('/');
            }),
            _DrawerTile(
              icon: Icons.movie_rounded,
              label: 'Films',
              onTap: () {
                Navigator.pop(context);
                GoRouter.of(shellContext).go('/films');
              },
            ),
            _DrawerTile(
              icon: Icons.event_rounded,
              label: 'Événements',
              onTap: () {
                Navigator.pop(context);
                GoRouter.of(shellContext).go('/events');
              },
            ),
            _DrawerTile(
              icon: Icons.confirmation_number_rounded,
              label: 'Mes billets',
              onTap: () {
                Navigator.pop(context);
                GoRouter.of(shellContext).go('/billets');
              },
            ),
            _DrawerTile(
              icon: Icons.person_rounded,
              label: 'Mon profil',
              onTap: () {
                Navigator.pop(context);
                GoRouter.of(shellContext).go('/profil');
              },
            ),
            if (auth.isAuthenticated)
              _DrawerTile(
                icon: Icons.admin_panel_settings_rounded,
                label: 'Admin space',
                onTap: () {
                  Navigator.pop(context);
                  GoRouter.of(shellContext).go('/admin');
                },
              ),
            const Divider(color: Colors.white24, height: 1),
            _DrawerTile(
              icon: Icons.help_outline_rounded,
              label: 'FAQ & Aide',
              onTap: () {
                Navigator.pop(context);
                GoRouter.of(shellContext).go('/faq');
              },
            ),
            const Spacer(),
            const Divider(color: Colors.white24, height: 1),
            _DrawerTile(
              icon: Icons.logout_rounded,
              label: 'Déconnexion',
              onTap: () {
                Navigator.pop(context);
                GoRouter.of(shellContext).go('/auth/login');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : Colors.white54;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 11, fontWeight: selected ? FontWeight.w600 : FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.neon.withValues(alpha: 0.9), size: 22),
      ),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: onTap,
    );
  }
}
