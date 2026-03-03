import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/network/serverpod_provider.dart';
import 'package:reservation_billet_cinema/features/events/data/models/evenement.dart';

class EventsRepository {
  EventsRepository(this._client);

  final Client _client;

  Future<List<Evenement>> getEvents({String? ville, DateTime? date}) async {
    final list = await _client.events.getEvents(ville: ville, date: date);
    return (list as List).map((e) => Evenement.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Evenement?> getEventById(int id) async {
    final data = await _client.events.getEventById(id);
    if (data == null) return null;
    return Evenement.fromJson(data as Map<String, dynamic>);
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
