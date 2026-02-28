import 'package:flutter/material.dart';

/// Page mes billets (e-billets, QR).
class BilletsPage extends StatelessWidget {
  const BilletsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes billets')),
      body: const Center(child: Text('E-billets et QR — à implémenter')),
    );
  }
}
