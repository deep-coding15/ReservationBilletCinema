import 'package:serverpod_client/serverpod_client.dart';

/// Client Serverpod pour l'app Flutter.
/// Une fois le serveur généré avec `serverpod generate`, remplacer
/// par le client généré (Client('http://localhost:8080/')) et les appels
/// du type client.example.hello('Douae').
class ReservationBilletCinemaClient {
  ReservationBilletCinemaClient(this.serverUrl);

  final String serverUrl;
  late final Client _client = Client(serverUrl);

  Client get rawClient => _client;

  /// Exemple : appeler un endpoint après génération Serverpod.
  /// client.example.hello(session, 'Douae');
}
