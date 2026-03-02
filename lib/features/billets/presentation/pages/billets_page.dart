import 'package:flutter/material.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';

/// Page mes billets (e-billets, QR).
class BilletsPage extends StatelessWidget {
  const BilletsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text('Mes billets'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('E-billets et QR — à implémenter', style: TextStyle(color: Colors.white70))),
    );
  }
}
