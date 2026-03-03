/// Script pour vérifier que seed_films.sql a été exécuté et que les affiches sont présentes.
/// Exécuter : dart run scripts/verify_seed.dart
/// (Le serveur Serverpod doit être démarré et la base configurée)

import 'package:cinema_reservation_client/cinema_reservation_client.dart';

void main() async {
  final client = Client('http://localhost:8090/');
  try {
    final films = await client.films.getFilms();
    print('=== Films (${films.length}) ===');
    var filmsOk = 0;
    for (final f in films) {
      final hasAffiche = f.affiche != null && f.affiche!.isNotEmpty;
      if (hasAffiche) filmsOk++;
      final preview = hasAffiche ? f.affiche!.length > 45 ? '${f.affiche!.substring(0, 45)}...' : f.affiche! : '-';
      print('  ${f.id}. ${f.titre} | affiche: ${hasAffiche ? "OUI" : "NON"} $preview');
    }
    if (films.isEmpty) {
      print('\n⚠️  Aucun film. Exécutez seed_films.sql :');
      print('   psql -U postgres -d cinema_reservation -f server/database/seed_films.sql');
    } else if (filmsOk < films.length) {
      print('\n⚠️  $filmsOk/${films.length} films ont une affiche. Relancez seed_films.sql.');
    } else {
      print('\n✓ Tous les films ont une affiche.');
    }
  } catch (e) {
    print('Erreur: $e');
    print('Assurez-vous que le serveur Serverpod tourne (port 8090) et que la base est migrée.');
  }
}
