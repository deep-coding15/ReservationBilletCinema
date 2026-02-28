import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Page d'accueil (liste films / événements, recherche).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservation Billet Cinema'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profil'),
          ),
        ],
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.movie),
            title: Text('Films à l\'affiche'),
            subtitle: Text('Parcourir et réserver'),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Rechercher'),
            onTap: () => context.go('/films'),
          ),
        ],
      ),
    );
  }
}
