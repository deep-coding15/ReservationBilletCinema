import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/network/serverpod_provider.dart';

/// Repository réservations : sièges, créneaux réservés, création.
class ReservationRepository {
  ReservationRepository(this._client);

  final Client _client;

  Future<List<Siege>> getSiegesBySalle(int salleId) =>
      _client.reservations.getSiegesBySalle(salleId);

  Future<List<int>> getReservedSiegeIdsForSeance(int seanceId) =>
      _client.reservations.getReservedSiegeIdsForSeance(seanceId);

  Future<ReservationResult> createReservation({
    required int seanceId,
    required List<int> siegeIds,
    int utilisateurId = 1,
  }) =>
      _client.reservations.createReservation(
        seanceId: seanceId,
        siegeIds: siegeIds,
        utilisateurId: utilisateurId,
      );
}

final reservationRepositoryProvider = Provider<ReservationRepository>((ref) {
  final client = ref.watch(serverpodClientProvider);
  return ReservationRepository(client);
});
