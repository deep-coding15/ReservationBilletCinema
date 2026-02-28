import 'package:flutter/material.dart';

/// Page FAQ et support.
class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: const Center(child: Text('FAQ et contact support — à implémenter')),
    );
  }
}
