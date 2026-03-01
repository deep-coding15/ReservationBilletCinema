# Mise en place du serveur Serverpod

## 1. Base de données

- **Cloud (Neon/Supabase) :** exécuter `server/database/schema.sql` dans le SQL Editor, puis dans `config/development.yaml` mettre `database.host`, `database.port: 5432`, `database.name`, `database.user`, et `database.requireSsl: true`. Le mot de passe dans `config/passwords.yaml` → section `development.database`.
- **Local :** créer la base `cinema_reservation`, exécuter `schema.sql`. Dans `config/development.yaml` mettre `database.port: 5432` (le template utilise 8090 pour Docker). Copier `config/passwords.yaml.example` en `config/passwords.yaml` et mettre le mot de passe PostgreSQL dans `development.database`.

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

Ou avec migrations appliquées automatiquement :

```bash
dart run bin/main.dart --apply-migrations
```

## 4. App Flutter

L’app à la racine du repo utilise le client : `cinema_reservation_client` (path: `client/`). Après `serverpod generate`, faire `flutter pub get` à la racine.
