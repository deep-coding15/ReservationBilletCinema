import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_billet_cinema/core/router/app_router.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';

void main() {
  // Afficher les erreurs de rendu à l'écran au lieu d'un écran blanc
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.red.shade900,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Text(
              details.exceptionAsString(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  };
  // Affichage dans la console au lancement (visible dans le terminal Flutter)
  debugPrint('>>> CinePass FRONTEND : demarrage...');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CinePass',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: goRouter,
    );
  }
}
