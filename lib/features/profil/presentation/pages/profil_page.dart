import 'package:flutter/material.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';

/// Page profil utilisateur (infos, favoris, historique).
class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text('Mon profil'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Profil et paramètres — à implémenter', style: TextStyle(color: Colors.white70))),
    );
  }
}
