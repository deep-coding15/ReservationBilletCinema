// Script pour tester la connexion Flutter/Client -> Serveur Serverpod.
// Lancer depuis la racine : dart run test_server_connection.dart
// (Le serveur doit tourner : cd server && dart run bin/main.dart)

import 'package:cinema_reservation_client/cinema_reservation_client.dart';

void main() async {
  final client = Client('http://localhost:8080');
  try {
    final greeting = await client.greeting.hello('Douae');
    print('OK: ${greeting.message}');
  } catch (e, st) {
    print('ERREUR: $e');
    print(st);
  }
}
