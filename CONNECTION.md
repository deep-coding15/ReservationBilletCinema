# Connexion Backend ↔ Base de données ↔ Frontend

## Schéma

```
[Frontend Flutter]  ----HTTP (port 8090)---->  [Backend Serverpod]  ----PostgreSQL (5432)---->  [Base cinema_reservation]
```

## 1. Frontend → Backend

- **Fichiers** : `lib/core/constants/api_constants.dart`, `api_constants_web.dart`, `api_constants_io.dart`
- **URL** : `http://localhost:8090` (web et desktop)
- **Mobile** (Android émulateur) : `http://10.0.2.2:8090` (modifiable dans `api_constants_io.dart` → `serverHostForMobile`)
- Le client Serverpod est créé dans `lib/core/network/serverpod_provider.dart` avec `ApiConstants.baseUrl`.

## 2. Backend → Base de données

- **Fichier** : `server/config/development.yaml`
  - `database.host` : `localhost`
  - `database.port` : `5432`
  - `database.name` : `cinema_reservation`
  - `database.user` : `postgres`
- **Mot de passe** : `server/config/passwords.yaml` → `development.database` (ne pas commiter ce fichier).

## 3. Vérifier que tout est connecté

1. **Base** : PostgreSQL doit avoir la base `cinema_reservation` (schéma + seeds appliqués).
2. **Backend** : `cd server` puis `dart run bin/main.dart` → doit afficher "Webserver listening on http://localhost:8090" (ou port configuré).
3. **Frontend** : `flutter run -d chrome` (ou autre device) → l’app appelle `http://localhost:8090` pour les films/événements.

## Création de la base (PostgreSQL 17)

Pour recréer la base avec toutes les tables et les données de démo : (1) Arrêter le backend ; (2) DROP puis CREATE DATABASE cinema_reservation ; (3) `cd server` puis `dart run bin/main.dart --apply-migrations` ; (4) appliquer schema.sql et seed_films.sql avec psql ; (5) relancer le serveur.

## Dépannage

- **"Impossible de charger les données"** : le backend n’est pas démarré ou pas joignable sur le port 8090.
- **Erreur de connexion PostgreSQL** : vérifier `passwords.yaml` et que la base `cinema_reservation` existe (`psql -U postgres -l`).
- **"Database does not match" au démarrage** : refaire la création de la base (drop/create DB, --apply-migrations, schema.sql, seed_films.sql) puis relancer le serveur.
