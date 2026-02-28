import 'package:flutter/material.dart';

/// Page profil utilisateur (infos, favoris, historique).
class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: const Center(child: Text('Profil et paramètres — à implémenter')),
    );
  }
}
