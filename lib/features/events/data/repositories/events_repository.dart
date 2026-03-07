import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/network/serverpod_provider.dart';

class EventsRepository {
  EventsRepository(this._client);

  final Client _client;

  Future<List<Evenement>> getEvents({String? ville, DateTime? date}) async {
    return _client.events.getEvents(ville: ville, date: date);
  }

  Future<Evenement?> getEventById(int id) async {
    return _client.events.getEventById(id);
  }

  /// Crée une réservation pour un événement (même logique que cinéma).
  Future<Map<String, dynamic>> createEventReservation({
    required int eventId,
    required int nbBillets,
    required double montantTotal,
    int utilisateurId = 1,
  }) async {
    return _client.events.createEventReservation(
      eventId: eventId,
      nbBillets: nbBillets,
      montantTotal: montantTotal,
      utilisateurId: utilisateurId,
    ) as Map<String, dynamic>;
  }
}

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  final client = ref.watch(serverpodClientProvider);
  return EventsRepository(client);
});
