import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Modèle Reservation.
class Reservation extends SerializationEntity {
  final int? id;
  final int utilisateurId;
  final int seanceId;
  final DateTime dateReservation;
  final double montantTotal;
  final String statut;

  Reservation({
    this.id,
    required this.utilisateurId,
    required this.seanceId,
    required this.dateReservation,
    required this.montantTotal,
    this.statut = 'en_attente',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'utilisateurId': utilisateurId,
        'seanceId': seanceId,
        'dateReservation': dateReservation.toIso8601String(),
        'montantTotal': montantTotal,
        'statut': statut,
      };

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
        id: json['id'] as int?,
        utilisateurId: json['utilisateurId'] as int,
        seanceId: json['seanceId'] as int,
        dateReservation: DateTime.parse(json['dateReservation'] as String),
        montantTotal: (json['montantTotal'] as num).toDouble(),
        statut: json['statut'] as String? ?? 'en_attente',
      );
}
