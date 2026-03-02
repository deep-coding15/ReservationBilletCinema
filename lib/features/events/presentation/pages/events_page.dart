import 'package:flutter/material.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';

/// Page liste des événements (concerts, spectacles, etc.).
class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text('Événements'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Événements à venir — à implémenter', style: TextStyle(color: Colors.white70)),
      ),
    );
  }
}
