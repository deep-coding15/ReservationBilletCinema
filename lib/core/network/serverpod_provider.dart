import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/constants/api_constants.dart';

/// Client Serverpod partagé : connecte l'app Flutter au backend.
/// Utilise [ApiConstants.baseUrl] (http://localhost:8080 en dev).
final serverpodClientProvider = Provider<Client>((ref) {
  return Client(ApiConstants.baseUrl);
});
