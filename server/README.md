# Backend Serverpod - Reservation Billet Cinema

Backend en Dart (Serverpod) pour l'application de réservation de billets de cinéma.

## Prérequis

- Dart 3.x
- PostgreSQL installé et démarré
- Serverpod CLI : `dart pub global activate serverpod_cli`

## Configuration

1. Créer la base PostgreSQL : `createdb cinema_reservation_db`
2. Modifier `config/development.yaml` avec vos identifiants PostgreSQL.

## Lancer le serveur

```bash
cd server
dart run bin/main.dart
```

Ou avec la CLI Serverpod (si le projet a été créé avec `serverpod create`) :

```bash
serverpod run
```

## Structure

- `lib/src/models/` — Modèles (Utilisateur, Cinema, Film, Salle, Seance, Reservation, Billet)
- `lib/src/endpoints/` — Endpoints API (à compléter : auth, films, seances, reservations, etc.)
- `config/` — Configuration développement / production

## Migrations

Les migrations Serverpod mettent à jour le schéma PostgreSQL à partir des modèles.
Après avoir modifié les modèles, exécuter (depuis le projet server) :

```bash
serverpod migrate
```
