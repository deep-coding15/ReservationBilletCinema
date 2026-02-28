import 'package:flutter/material.dart';

/// Page sélection des sièges (plan interactif).
class SeatSelectionPage extends StatelessWidget {
  const SeatSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choisir les sièges')),
      body: const Center(child: Text('Plan des sièges — à implémenter')),
    );
  }
}
