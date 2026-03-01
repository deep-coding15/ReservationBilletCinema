# Base de données PostgreSQL - Reservation Billet Cinema

On utilise **PostgreSQL** (local ou sur un serveur à vous). Pas de Supabase ni Neon.

- **Schéma des tables :** `server/database/schema.sql`

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
