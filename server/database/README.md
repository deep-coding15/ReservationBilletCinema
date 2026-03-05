# Base de données PostgreSQL - Reservation Billet Cinema

On utilise **PostgreSQL** (local ou sur un serveur à vous). Pas de Supabase ni Neon.

- **Schéma des tables :** `server/database/schema.sql`
- **Données de démo (optionnel) :** `server/database/seed_films.sql` — films, cinémas, salles, séances pour tester l’app.

---

## Où sont stockés les mots de passe ?

**Il n'y a pas de colonne mot de passe dans la table `users`.** C'est voulu : la connexion est gérée par **Serverpod Auth**.

- **Mots de passe (hash)** : table **`serverpod_auth_idp_email_account`**, colonne **`passwordHash`**.
- **Lien avec l'app** : chaque compte auth a un `authUserId` (UUID) ; la table **`users`** a la colonne **`authUserId`** qui fait le lien. Profil métier (nom, email, rôle) = table `users` ; identifiant + mot de passe hash = tables Serverpod Auth.

Les tables d'auth sont créées par les **migrations Serverpod** (voir section 3).

---

## Comment l'admin est détecté (rôle en base)

**Une seule table `users`** : chaque compte est une ligne avec une colonne **`role`** qui vaut `'admin'` ou `'client'`.

- **users** : id, authUserId, nom, email, telephone, dateNaissance, preferences, statut, **role** (`'admin'` ou `'client'`).

Si `role = 'admin'`, l'app affiche un bouton **« Espace admin »** en haut à droite (barre de navigation) ; un clic mène vers `/admin` (tableau de bord, Films, Séances, Événements, Utilisateurs). Sinon = client (pas de bouton).

**Pour tester en tant qu'admin :**
1. Inscrivez-vous ou connectez-vous une fois avec votre email dans l'app.
2. Dans `server/database/promote_admin.sql`, remplacez `'admin@test.com'` par votre email.
3. Exécutez le script :
   - **Si `psql` est dans le PATH :**  
     `psql -U postgres -d cinema_reservation -f server/database/promote_admin.sql`
   - **Sinon (Windows) :** depuis PowerShell, dans le dossier `server/database` :  
     `.\promote_admin.ps1`  
     (le script cherche `psql` dans `C:\Program Files\PostgreSQL\17\bin`, etc.)
4. Reconnectez-vous : l’icône « Espace admin » apparaît en haut à droite.

### Migrer depuis l’ancienne structure (utilisateurs + administrateurs)

Si votre base a encore les tables `utilisateurs` et `administrateurs`, exécuter **une fois** :

```powershell
psql -U postgres -d cinema_reservation -f server/database/migrate_to_users.sql
```

Cela ajoute la colonne `role`, recopie les admins, supprime la table `administrateurs` et renomme `utilisateurs` en `users`.

---

## Liens entre les tables (cinéma, films, salles, séances, etc.)

### Vue d’ensemble

```
cinemas (1) ──────< salles (N)     Une salle appartient à un cinéma (cinema_id).
    │                    │
    │                    ├──────< sieges (N)     Les sièges sont dans une salle (salle_id).
    │                    │
    │                    └──────< seances (N)    Une séance a lieu dans une salle (salle_id).
    │
films (1) ──────────────< seances (N)   Une séance projette un film (film_id).
                                              Donc : séance = un film, à une date/heure, dans une salle.

users (1) ──────────────< reservations (N)   Une réservation est faite par un user (utilisateur_id).
    │
reservations (1) ──────< reservation_sieges (N)   On réserve des sièges pour une séance (siege_id).
    │
    └── seance_id (une résa = une séance)
```

### Détail des liens

| Table | Lien | Explication |
|-------|------|-------------|
| **cinemas** | — | Entité de base : un lieu (nom, adresse, ville). |
| **salles** | `cinema_id` → cinemas(id) | Chaque **salle** appartient à **un cinéma**. Un cinéma a **plusieurs salles** (Salle 1, Salle 2, …). |
| **films** | — | Entité indépendante : un film (titre, durée, dates d’affiche, etc.). **Pas de lien direct** avec les cinémas. |
| **seances** | `film_id` → films(id) | Une **séance** = **un film** projeté à une date/heure. |
| **seances** | `salle_id` → salles(id) | Une **séance** a lieu dans **une salle**. Donc une séance relie **film + salle + date/heure** (et prix, langue, 2D/3D, etc.). |
| **sieges** | `salle_id` → salles(id) | Les **sièges** sont dans une **salle**. Chaque salle a un ensemble de sièges (numéro, type, catégorie). |
| **reservations** | `utilisateur_id` → users(id) | Une **réservation** est faite par **un utilisateur**. |
| **reservations** | `seance_id` → seances(id) | Une **réservation** concerne **une séance** (donc un film, une salle, une date). |
| **reservation_sieges** | `reservation_id` → reservations(id), `siege_id` → sieges(id) | Pour une réservation, on attache les **sièges** réservés (ex. A1, A2). |

### En résumé

- **Cinéma** → a plusieurs **salles** (chaque salle a un `cinema_id`).
- **Salle** → a plusieurs **sièges** et plusieurs **séances** (chaque séance a un `salle_id`).
- **Film** → n’est pas lié au cinéma ; il est lié aux **séances** (chaque séance a un `film_id`).
- **Séance** = **1 film** + **1 salle** + date/heure + prix, etc. C’est le “créneau” qu’on réserve.
- **Réservation** = **1 user** + **1 séance** + une liste de **sièges** (via `reservation_sieges`).

### Événements (hors cinéma classique)

- **evenements** : peut être lié à un cinéma (`cinema_id` optionnel) ou à un autre lieu (adresse, ville).
- **reservations_evenements** : un **user** réserve un **événement** (nb billets, montant), sans choix de siège dans ce schéma.

---

## Règle importante : tout le monde lance les migrations

Pour que **tout le monde ait la même forme (structure) de base** :

- Dès qu’il y a un **changement dans le schéma** (nouvelles tables, nouvelles colonnes, etc.), le fichier `schema.sql` est mis à jour dans le dépôt.
- **Chacun** doit appliquer ces changements sur sa base en **lançant les migrations** (ou en exécutant le `schema.sql` à jour).

Comme ça, la structure de la base reste identique pour toute l’équipe.

---

## 1. Créer la base PostgreSQL (une fois)

### Option A : PostgreSQL installé sur ta machine

```bash
# Créer la base
createdb -U postgres cinema_reservation

# Appliquer le schéma (tables, colonnes)
psql -U postgres -d cinema_reservation -f server/database/schema.sql
```

Sous Windows (si `psql` est dans le PATH) :

```powershell
psql -U postgres -c "CREATE DATABASE cinema_reservation;"
psql -U postgres -d cinema_reservation -f server/database/schema.sql
```

### Option B : PostgreSQL sur un serveur (même chose, en changeant host)

Une personne peut installer PostgreSQL sur une machine ou un VPS ; les autres mettent dans `development.yaml` le **host** (IP ou nom du serveur) au lieu de `localhost`. Ensuite chacun exécute le `schema.sql` (ou les migrations) contre cette base pour avoir la même structure.

---

## 2. Configurer le serveur Serverpod

Dans **`server/config/development.yaml`** :

```yaml
database:
  host: localhost    # ou l’IP du serveur PostgreSQL si partagé
  port: 5432
  name: cinema_reservation
  user: postgres
  requireSsl: false
```

Dans **`server/config/passwords.yaml`** (copier depuis `passwords.yaml.example`) :

```yaml
development:
  database: 'VOTRE_MOT_DE_PASSE_POSTGRESQL'
  # ...
```

---

## 3. Lancer les migrations à chaque changement de schéma

Dès que `schema.sql` (ou les migrations Serverpod) change dans le dépôt :

```bash
cd server
dart run bin/main.dart --apply-migrations
```

Ou, si vous utilisez uniquement le fichier SQL :

```bash
psql -U postgres -d cinema_reservation -f server/database/schema.sql
```

(Attention : réexécuter tout le `schema.sql` peut nécessiter des `DROP TABLE` ou un script de migration selon votre façon de travailler. Avec Serverpod, privilégier `--apply-migrations` pour les changements incrémentaux.)

---

## En résumé

| Action | À faire |
|--------|--------|
| **Nouvelle structure** (tables, colonnes modifiées dans le repo) | Tout le monde lance les migrations (ou applique le nouveau `schema.sql`) pour garder la même forme de base. |
| **Nouvelles données** (films, séances, réservations) | Rien à migrer : les données sont dans la base, il suffit de lancer l’app et d’utiliser l’API. |

— **PostgreSQL uniquement, pas Supabase/Neon.**  
— **Même schéma pour tous : chacun lance les migrations après un changement de structure.**

---

## 4. Données de démo (films avec affiches)

Après le schéma, exécuter **une fois** le seed pour avoir des films (avec images TMDB), séances, événements et sièges :

```powershell
cd server/database
.\apply_seed.ps1
```

Ou à la main (depuis la racine du projet) :

```powershell
psql -U postgres -d cinema_reservation -f server/database/schema.sql
psql -U postgres -d cinema_reservation -f server/database/seed_films.sql
```

Tu peux relancer le seed pour mettre à jour les affiches sans doublon. **Sans ces seeds, l’app affichera « Aucun film à l’affiche » et « Aucun événement à venir ».**

### Vérifier que les affiches sont bien chargées

Avec le serveur Serverpod démarré (`dart run bin/main.dart` dans `server/`) :

```powershell
dart run scripts/verify_seed.dart
```

Le script affiche la liste des films et indique si chacun a une affiche.

### Créer un compte administrateur (pour tests)

1. Inscris-toi une fois dans l'app avec l'email choisi (ex. `admin@test.com`).
2. Dans `server/database/promote_admin.sql`, mets à jour la variable `v_email` si besoin (par défaut `admin@test.com`).
3. Exécute : `psql -U postgres -d cinema_reservation -f server/database/promote_admin.sql`
4. Connecte-toi dans l'app avec ce compte : tu seras redirigé vers l'espace admin (`/admin`).

---

## 5. Voir les tables et exporter la base en SQL

### Voir la liste des tables

Avec **psql** (remplacer le chemin si PostgreSQL est installé ailleurs) :

```powershell
& "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d cinema_reservation -c "\dt"
```

Ou en ouvrant une session psql puis en tapant `\dt` :

```powershell
& "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d cinema_reservation
# Dans psql :
# \dt          → liste des tables
# \d nom_table → structure d'une table
# \q           → quitter
```

### Exporter la base vers un fichier SQL

Script fourni : **`server/database/export_db.ps1`**

- **Export complet** (schéma + données) vers un fichier daté dans `server/database/` :
  ```powershell
  cd server/database
  .\export_db.ps1
  ```
- **Vers un fichier précis** :
  ```powershell
  .\export_db.ps1 -OutFile "C:\backup\cinema_reservation.sql"
  ```
- **Schéma uniquement** (pas les données) :
  ```powershell
  .\export_db.ps1 -SchemaOnly -OutFile "C:\backup\schema_only.sql"
  ```
- **Données uniquement** :
  ```powershell
  .\export_db.ps1 -DataOnly -OutFile "C:\backup\data_only.sql"
  ```

À la main avec **pg_dump** :

```powershell
& "C:\Program Files\PostgreSQL\17\bin\pg_dump.exe" -U postgres -d cinema_reservation -f "C:\chemin\export.sql"
```

PostgreSQL demandera le mot de passe de l’utilisateur `postgres`. Le fichier généré peut servir de sauvegarde ou à recréer la base ailleurs.
