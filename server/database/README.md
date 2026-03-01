# Base de données - Reservation Billet Cinema

## Où sont définies les tables

- **Fichier :** `server/database/schema.sql`
- Ce fichier contient toutes les `CREATE TABLE` pour PostgreSQL.

---

## Base partagée dans le cloud (recommandé pour l’équipe)

1. **Une personne** crée une base gratuite :
   - **Neon** : https://neon.tech → Sign up → New project → noter **host**, **user**, **password**, **database name**.
   - Ou **Supabase** : https://supabase.com → New project → Settings → Database → noter les infos de connexion.

2. **Créer les tables** : sur Neon (SQL Editor) ou Supabase (SQL Editor), coller tout le contenu de `server/database/schema.sql` et exécuter.

3. **Config locale (chaque membre)** :
   - Copier `server/config/development.yaml.example` vers `server/config/development.yaml`.
   - Remplacer les `__...__` par les vraies valeurs (host, nom de la base, user, password).
   - Activer `ssl: true` (déjà présent dans l’exemple). Ne jamais commiter `development.yaml`.

4. **Partage** : la personne qui a créé la base envoie host, user, password et nom de la base aux autres par un canal sécurisé (pas dans Git).

---

## Comment créer les tables (PostgreSQL local)

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
