import 'package:cinema_reservation_client/cinema_reservation_client.dart';

/// Extension sur le modèle [Evenement] du protocole pour l'affichage.
extension EvenementDisplay on Evenement {
  /// Lieu affiché (cinéma ou autre lieu).
  String get lieuDisplay {
    if (lieuNom != null && lieuNom!.isNotEmpty) return lieuNom!;
    if (ville != null && ville!.isNotEmpty) return ville!;
    return 'Lieu à préciser';
  }
}
