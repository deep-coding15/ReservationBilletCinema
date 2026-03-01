# Mise en place du serveur Serverpod

On utilise **PostgreSQL** (local ou sur un serveur à vous). Pas de Supabase ni Neon.

## 1. Base de données (PostgreSQL)

- Créer la base : `createdb -U postgres cinema_reservation` (ou via pgAdmin / autre outil).
- Appliquer le schéma : `psql -U postgres -d cinema_reservation -f server/database/schema.sql`.
- Dans `config/development.yaml` : `database.host` (localhost ou IP du serveur), `port: 5432`, `name: cinema_reservation`, `user: postgres`, `requireSsl: false`.
- Copier `config/passwords.yaml.example` en `config/passwords.yaml` et mettre le mot de passe PostgreSQL dans `development.database`.

## 2. Génération du code

Depuis la racine du projet (où se trouvent `server/` et `client/`) :

```bash
cd server
serverpod generate
```

(Pour que `serverpod` soit reconnu, ajouter au PATH : `%LOCALAPPDATA%\Pub\Cache\bin`)

## 3. Lancer le serveur

```bash
cd server
dart run bin/main.dart
```

Ou avec migrations appliquées automatiquement (utile après un changement de schéma) :

```bash
dart run bin/main.dart --apply-migrations
```

**Règle équipe :** à chaque changement de structure (tables, colonnes) dans le dépôt, **tout le monde** lance les migrations (`--apply-migrations` ou réexécute le `schema.sql`) pour garder la même forme de base.

## 4. App Flutter

L’app à la racine du repo utilise le client : `cinema_reservation_client` (path: `client/`). Après `serverpod generate`, faire `flutter pub get` à la racine.
