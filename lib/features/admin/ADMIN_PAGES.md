# Pages admin (selon maquettes)

## Accès
- **URL** : `/#/admin` ou `/#/admin/dashboard`
- **Depuis l’app** : menu (drawer) → « Espace admin » ou icône admin en bas à droite.

## Layout
- **Fichier** : `lib/features/admin/presentation/layout/admin_shell.dart`
- Barre rouge, menu latéral (drawer), titre dynamique, lien « Retour à l’app ».

## Routes et pages

| Route | Nom de route | Page | Fichier |
|-------|--------------|------|---------|
| `/admin` | — | Tableau de bord | `admin_dashboard_page.dart` |
| `/admin/dashboard` | `admin-dashboard` | Tableau de bord | `admin_dashboard_page.dart` |
| `/admin/films` | `admin-films` | Films | `admin_films_page.dart` |
| `/admin/seances` | `admin-seances` | Séances | `admin_seances_page.dart` |
| `/admin/evenements` | `admin-evenements` | Événements | `admin_events_page.dart` |
| `/admin/utilisateurs` | `admin-utilisateurs` | Utilisateurs | `admin_users_page.dart` |

## Fichiers des pages
- `lib/features/admin/presentation/pages/admin_dashboard_page.dart` — Vue d’ensemble (cartes Films, Événements, Séances, Utilisateurs)
- `lib/features/admin/presentation/pages/admin_films_page.dart` — Liste des films
- `lib/features/admin/presentation/pages/admin_seances_page.dart` — Liste des séances par cinéma
- `lib/features/admin/presentation/pages/admin_events_page.dart` — Liste des événements
- `lib/features/admin/presentation/pages/admin_users_page.dart` — Utilisateurs (à brancher sur un endpoint)

## Définition des routes
- `lib/core/router/app_router.dart` : routes sous `/admin` avec `AdminShell` et `ShellRoute`.
