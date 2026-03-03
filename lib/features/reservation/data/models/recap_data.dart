import 'package:cinema_reservation_client/cinema_reservation_client.dart';

/// Une ligne = un billet (une place) avec son type et ses options.
class TicketLine {
  const TicketLine({
    this.typeBillet = 'Normal',
    this.options = const [],
  });

  final String typeBillet;
  final List<String> options;

  TicketLine copyWith({String? typeBillet, List<String>? options}) {
    return TicketLine(
      typeBillet: typeBillet ?? this.typeBillet,
      options: options ?? List.from(this.options),
    );
  }

  /// Coefficients : Normal 100%, VIP 1.5x. VIP = options incluses automatiquement.
  static const Map<String, double> typeModifiers = {
    'Normal': 1.0,
    'VIP': 1.5,
  };

  static const List<String> typeNames = ['Normal', 'VIP'];

  /// Options incluses automatiquement pour VIP.
  static const List<String> vipIncludedOptions = ['Popcorn', 'Boisson', 'Parking'];

  static double modifierFor(String type) => typeModifiers[type] ?? 1.0;
}

/// Prix des options supplémentaires (par unité).
const Map<String, double> kOptionPrices = {
  'Popcorn': 15,
  'Boisson': 8,
  'Parking': 10,
};

/// Données récap réservation CINÉMA : une ligne par place (type + options par billet).
class ReservationRecapData {
  ReservationRecapData({
    required this.seance,
    required this.siegeIds,
    List<TicketLine>? lines,
  }) : lines = lines ?? List.generate(siegeIds.length, (_) => const TicketLine());

  final Seance seance;
  final List<int> siegeIds;
  final List<TicketLine> lines;

  double get basePrixUnitaire => seance.prix;

  double lineTotal(int index) {
    if (index < 0 || index >= lines.length) return 0;
    final line = lines[index];
    final typeCoef = TicketLine.modifierFor(line.typeBillet);
    final placePrix = basePrixUnitaire * typeCoef;
    // VIP : options incluses automatiquement ; Normal : options cochées par l'user
    final opts = line.typeBillet == 'VIP' ? TicketLine.vipIncludedOptions : line.options;
    final optionsPrix = opts.fold<double>(0, (s, o) => s + (kOptionPrices[o] ?? 0));
    return placePrix + optionsPrix;
  }

  double get total {
    double sum = 0;
    for (var i = 0; i < lines.length; i++) {
      sum += lineTotal(i);
    }
    return sum;
  }

  ReservationRecapData copyWith({
    Seance? seance,
    List<int>? siegeIds,
    List<TicketLine>? lines,
  }) {
    return ReservationRecapData(
      seance: seance ?? this.seance,
      siegeIds: siegeIds ?? this.siegeIds,
      lines: lines ?? List.from(this.lines),
    );
  }
}

/// Données récap réservation ÉVÉNEMENT : même logique (type + options par billet).
class EventRecapData {
  EventRecapData({
    required this.eventId,
    required this.titre,
    required this.prixUnitaire,
    required this.placesDisponibles,
    required this.numberOfTickets,
    List<TicketLine>? lines,
  }) : lines = lines ?? List.generate(numberOfTickets, (_) => const TicketLine());

  final int eventId;
  final String titre;
  final double prixUnitaire;
  final int placesDisponibles;
  final int numberOfTickets;
  final List<TicketLine> lines;

  double lineTotal(int index) {
    if (index < 0 || index >= lines.length) return 0;
    final line = lines[index];
    final typeCoef = TicketLine.modifierFor(line.typeBillet);
    final placePrix = prixUnitaire * typeCoef;
    final opts = line.typeBillet == 'VIP' ? TicketLine.vipIncludedOptions : line.options;
    final optionsPrix = opts.fold<double>(0, (s, o) => s + (kOptionPrices[o] ?? 0));
    return placePrix + optionsPrix;
  }

  double get total {
    double sum = 0;
    for (var i = 0; i < lines.length; i++) {
      sum += lineTotal(i);
    }
    return sum;
  }

  EventRecapData copyWith({List<TicketLine>? lines}) {
    return EventRecapData(
      eventId: eventId,
      titre: titre,
      prixUnitaire: prixUnitaire,
      placesDisponibles: placesDisponibles,
      numberOfTickets: numberOfTickets,
      lines: lines ?? List.from(this.lines),
    );
  }
}
