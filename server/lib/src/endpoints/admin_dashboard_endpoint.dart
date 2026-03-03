import 'dart:convert';
import 'package:serverpod/serverpod.dart';

class AdminDashboardEndpoint extends Endpoint {
  
  Future<String> getDashboardStats(Session session) async {
    // 1. Revenus (Aujourd'hui, Semaine, Mois)
    final revenusQuery = await session.db.unsafeQuery("""
      SELECT 
        SUM(CASE WHEN date_reservation >= CURRENT_DATE THEN montant_total ELSE 0 END) as jour,
        SUM(CASE WHEN date_reservation >= CURRENT_DATE - INTERVAL '7 days' THEN montant_total ELSE 0 END) as semaine,
        SUM(CASE WHEN date_reservation >= date_trunc('month', CURRENT_DATE) THEN montant_total ELSE 0 END) as mois,
        COUNT(CASE WHEN date_reservation >= CURRENT_DATE THEN id ELSE NULL END) as billets_jour
      FROM reservations 
      WHERE statut = 'confirmee'
    """);
    final revRow = revenusQuery.first.toList();

    // 2. Graphique 7 derniers jours
    final chartQuery = await session.db.unsafeQuery("""
      SELECT 
        to_char(date_reservation, 'Dy') as jour,
        SUM(montant_total) as montant
      FROM reservations
      WHERE statut = 'confirmee' 
        AND date_reservation >= CURRENT_DATE - INTERVAL '6 days'
      GROUP BY date_trunc('day', date_reservation), jour
      ORDER BY date_trunc('day', date_reservation) ASC
    """);
    final chartData = chartQuery.map((r) => {'jour': r.toList()[0], 'montant': r.toList()[1]}).toList();

    // 3. Films Populaires
    final filmsQuery = await session.db.unsafeQuery("""
      SELECT f.titre, COUNT(r.id) as billets, SUM(r.montant_total) as recette
      FROM reservations r
      JOIN seances s ON r.seance_id = s.id
      JOIN films f ON s.film_id = f.id
      WHERE r.statut = 'confirmee'
      GROUP BY f.titre
      ORDER BY billets DESC
      LIMIT 5
    """);
    final filmsPopulaires = filmsQuery.map((r) {
      final row = r.toList();
      return {'titre': row[0], 'billets': row[1], 'recette': row[2]};
    }).toList();

    // 4. Séances du jour
    final seancesQuery = await session.db.unsafeQuery("""
      SELECT f.titre, s.date_heure, sa.code_salle, (sa.capacite - s.places_disponibles) as vendus, sa.capacite
      FROM seances s
      JOIN films f ON s.film_id = f.id
      JOIN salles sa ON s.salle_id = sa.id
      WHERE s.date_heure::date = CURRENT_DATE
      ORDER BY s.date_heure ASC
    """);
    final seancesJour = seancesQuery.map((r) {
      final row = r.toList();
      return {
        'film': row[0], 
        'heure': row[1].toString().substring(11, 16), 
        'salle': row[2], 
        'places': row[3], 
        'total': row[4]
      };
    }).toList();

    // 5. Compteurs divers
    final countUsers = await session.db.unsafeQuery("SELECT COUNT(*) FROM utilisateurs");
    final countFilms = await session.db.unsafeQuery("SELECT COUNT(*) FROM films WHERE date_fin >= CURRENT_DATE");

    return jsonEncode({
      'revenus': {
        'jour': revRow[0] ?? 0.0,
        'semaine': revRow[1] ?? 0.0,
        'mois': revRow[2] ?? 0.0,
        'billetsJour': revRow[3] ?? 0,
      },
      'graphique': chartData,
      'filmsPopulaires': filmsPopulaires,
      'seancesJour': seancesJour,
      'counts': {
        'utilisateurs': countUsers.first.toList()[0],
        'filmsActifs': countFilms.first.toList()[0],
      }
    });
  }
}
