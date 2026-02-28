import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Modèle Billet (e-billet).
class Billet extends SerializationEntity {
  final int? id;
  final int reservationId;
  final DateTime dateEmission;
  final bool estValide;
  final String typeBillet;
  final String? qrCode;

  Billet({
    this.id,
    required this.reservationId,
    required this.dateEmission,
    this.estValide = true,
    this.typeBillet = 'electronique',
    this.qrCode,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'reservationId': reservationId,
        'dateEmission': dateEmission.toIso8601String(),
        'estValide': estValide,
        'typeBillet': typeBillet,
        'qrCode': qrCode,
      };

  factory Billet.fromJson(Map<String, dynamic> json) => Billet(
        id: json['id'] as int?,
        reservationId: json['reservationId'] as int,
        dateEmission: DateTime.parse(json['dateEmission'] as String),
        estValide: json['estValide'] as bool? ?? true,
        typeBillet: json['typeBillet'] as String? ?? 'electronique',
        qrCode: json['qrCode'] as String?,
      );
}
