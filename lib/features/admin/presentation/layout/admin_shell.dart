import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';

/// Layout admin : drawer + contenu, thème sombre rouge/noir.
class AdminShell extends StatelessWidget {
  const AdminShell({
    super.key,
    required this.currentPath,
    required this.child,
  });

  final String currentPath;
  final Widget child;

  static String _titleForPath(String path) {
    if (path == '/admin' || path == '/admin/dashboard') return 'Tableau de bord';
    if (path.startsWith('/admin/films')) return 'Films';
    if (path.startsWith('/admin/seances')) return 'Séances';
    if (path.startsWith('/admin/evenements')) return 'Événements';
    if (path.startsWith('/admin/utilisateurs')) return 'Utilisateurs';
    return 'Administration';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(_titleForPath(currentPath)),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home_rounded, size: 20),
            label: const Text('Retour à l\'app'),
          ),
        ],
      ),
      drawer: _AdminDrawer(currentPath: currentPath),
      body: child,
    );
  }
}

class _AdminDrawer extends StatelessWidget {
  const _AdminDrawer({required this.currentPath});

  final String currentPath;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF121212),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1a0a0e),
                    AppColors.primaryDark.withValues(alpha: 0.5),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    'Administration',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Tile(
              icon: Icons.dashboard_rounded,
              label: 'Tableau de bord',
              selected: currentPath == '/admin' || currentPath == '/admin/dashboard',
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/dashboard');
              },
            ),
            _Tile(
              icon: Icons.movie_rounded,
              label: 'Films',
              selected: currentPath.startsWith('/admin/films'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/films');
              },
            ),
            _Tile(
              icon: Icons.schedule_rounded,
              label: 'Séances',
              selected: currentPath.startsWith('/admin/seances'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/seances');
              },
            ),
            _Tile(
              icon: Icons.event_rounded,
              label: 'Événements',
              selected: currentPath.startsWith('/admin/evenements'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/evenements');
              },
            ),
            _Tile(
              icon: Icons.people_rounded,
              label: 'Utilisateurs',
              selected: currentPath.startsWith('/admin/utilisateurs'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/utilisateurs');
              },
            ),
            const Divider(color: Colors.white24, height: 1),
            _Tile(
              icon: Icons.home_rounded,
              label: 'Retour à l\'application',
              selected: false,
              onTap: () {
                Navigator.pop(context);
                context.go('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
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
    return ListTile(
      leading: Icon(icon, color: selected ? AppColors.primary : Colors.white70, size: 24),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.white70,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: selected,
      onTap: onTap,
    );
  }
}
