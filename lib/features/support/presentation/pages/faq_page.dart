import 'package:flutter/material.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';

/// Page FAQ et support.
class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text('FAQ & Aide'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('FAQ et contact support — à implémenter', style: TextStyle(color: Colors.white70))),
    );
  }
}
