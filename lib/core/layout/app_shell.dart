import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/splash/presentation/pages/splash_page.dart' show kAppName;

/// Shell commun à toutes les pages de l'app (après login) : sidebar (drawer) partout.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      drawer: _AppDrawer(shellContext: context),
      body: child,
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({required this.shellContext});

  final BuildContext shellContext;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1a1a1a),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Icon(Icons.movie_filter_rounded, color: AppColors.accent, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    kAppName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            _DrawerTile(
              icon: Icons.home_rounded,
              label: 'Accueil',
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(shellContext)?.settings.name != '/') GoRouter.of(shellContext).go('/');
              },
            ),
            _DrawerTile(
              icon: Icons.movie_rounded,
              label: 'Films à l\'affiche',
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
              icon: Icons.search_rounded,
              label: 'Rechercher',
              onTap: () {
                Navigator.pop(context);
                GoRouter.of(shellContext).go('/films');
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
      leading: Icon(icon, color: Colors.white70, size: 24),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}
