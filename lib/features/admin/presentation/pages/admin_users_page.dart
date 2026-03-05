import 'package:flutter/material.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';

/// Page utilisateurs (admin) — à connecter à un endpoint liste utilisateurs.
class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0d0d0d), Color(0xFF1a0a0e)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_rounded, size: 64, color: AppColors.primary.withValues(alpha: 0.7)),
            const SizedBox(height: 20),
            Text(
              'Gestion des utilisateurs',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'Un endpoint admin (liste / recherche utilisateurs) pourra être ajouté côté serveur et connecté ici.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
