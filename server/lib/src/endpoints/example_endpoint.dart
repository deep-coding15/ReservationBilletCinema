import 'package:serverpod/serverpod.dart';

/// Endpoint d'exemple. À remplacer par les vrais endpoints (auth, films, réservations, etc.).
class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Bonjour, $name! Bienvenue sur l\'API Reservation Billet Cinema.';
  }
}
