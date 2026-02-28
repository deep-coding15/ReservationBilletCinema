# Base de données - Reservation Billet Cinema

## Où sont définies les tables

- **Fichier :** `server/database/schema.sql`
- Ce fichier contient toutes les `CREATE TABLE` pour PostgreSQL.

## Comment créer les tables

1. Créer la base (une seule fois) :
   ```bash
   createdb -U postgres cinema_reservation_db
   ```

2. Exécuter le schéma :
   ```bash
   psql -U postgres -d cinema_reservation_db -f server/database/schema.sql
   ```
   (À lancer depuis la racine du projet, ou adapter le chemin vers `schema.sql`.)

3. Vérifier : dans `server/config/development.yaml`, les paramètres `database` doivent correspondre (host, port, name, username, password).

## Tables créées

- `utilisateurs` — comptes spectateurs
- `administrateurs` — lien utilisateur / rôle admin
- `cinemas` — salles de cinéma
- `salles` — salles par cinéma
- `films` — programmation films
- `seances` — séances (film + salle + date/heure)
- `categorie_sieges`, `sieges` — sièges par salle
- `reservations`, `reservation_sieges` — réservations et sièges réservés
- `paiements` — paiements
- `billets` — e-billets (QR)
- `favoris` — cinémas favoris
- `option_supplementaires`, `reservation_options` — options (snacks, etc.)
- `codes_promo` — codes promo
- `faq` — FAQ
- `demandes_support` — support client
