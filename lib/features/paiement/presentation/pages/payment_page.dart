import 'package:flutter/material.dart';

/// Page paiement (Stripe, code promo).
class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paiement')),
      body: const Center(child: Text('Paiement sécurisé — à implémenter')),
    );
  }
}
