import 'package:flutter/material.dart';

/// Page liste des films (recherche, filtres).
class FilmsListPage extends StatelessWidget {
  const FilmsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Films')),
      body: const Center(child: Text('Liste des films — à implémenter')),
    );
  }
}
