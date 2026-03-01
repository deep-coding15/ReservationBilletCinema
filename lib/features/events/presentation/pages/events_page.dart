import 'package:flutter/material.dart';

/// Page liste des événements (concerts, spectacles, etc.).
class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Événements'),
        backgroundColor: const Color(0xFFc41e3a),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Événements à venir — à implémenter'),
      ),
    );
  }
}
