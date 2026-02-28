import 'package:flutter/material.dart';

/// Tableau de bord administrateur (stats, ventes, programmation).
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tableau de bord Admin')),
      body: const Center(child: Text('Dashboard admin — à implémenter')),
    );
  }
}
