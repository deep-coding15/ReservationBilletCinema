# 🎬 Reservation Billet Cinema

Application **mobile multi-plateforme** (Android, iOS, Web) de réservation de billets de cinéma et d'événements — **Flutter + Serverpod + PostgreSQL**. Développement avec **Android Studio**.

---

## 🏗 Structure du projet

```
ReservationBilletCinema/
├── lib/                          # App Flutter (client)
│   ├── core/                     # Thème, routes, constantes, erreurs
│   │   ├── theme/
│   │   ├── router/
│   │   ├── constants/
│   │   └── errors/
│   ├── shared/                   # Widgets et services partagés
│   │   ├── widgets/
│   │   └── services/
│   ├── features/                 # Fonctionnalités (feature-first)
│   │   ├── auth/
│   │   ├── home/
│   │   ├── programmation/        # Films, détails, horaires
│   │   ├── reservation/          # Séances, sièges
│   │   ├── paiement/
│   │   ├── billets/
│   │   ├── profil/
│   │   ├── admin/
│   │   └── support/
│   └── main.dart
│
├── server/                       # Backend Serverpod (Dart)
│   ├── lib/
│   │   ├── src/
│   │   │   ├── endpoints/        # API (ex: films, réservations)
│   │   │   └── models/           # Utilisateur, Cinema, Film, Salle, Seance, etc.
│   │   └── server.dart
│   ├── bin/main.dart
│   └── config/
│       └── development.yaml      # PostgreSQL, port
│
├── client/                       # Package client Serverpod (pour Flutter)
│   └── lib/
│
├── android/ | ios/ | web/
└── pubspec.yaml
```

Chaque feature Flutter suit **Clean Architecture** :
- `data/` — repositories, data sources (appels API)
- `domain/` — entities, repositories (interfaces), use cases
- `presentation/` — pages, widgets, providers (Riverpod)

---

## 🚀 Stack technique

| Couche      | Technologie |
|------------|-------------|
| **Frontend** | Flutter 3.x, Dart 3.x, Riverpod, GoRouter, Dio |
| **Backend**  | Serverpod (Dart) |
| **Base de données** | PostgreSQL |
| **Migrations** | Serverpod (générées depuis les modèles) |

---

## 📦 Installation

### Prérequis

- Flutter 3.x + Dart 3.x
- **Android Studio** (pour Android / émulateur)
- PostgreSQL installé
- Serverpod CLI : `dart pub global activate serverpod_cli`

### Lancer l’app (multi-plateforme)

- **Android** : ouvrir le projet dans Android Studio, lancer un émulateur (AVD) ou connecter un appareil, puis `flutter run` et choisir l’appareil Android.
- **Web** : `flutter run` puis choisir **Chrome** (ou Edge) si Windows desktop n’est pas configuré (Visual Studio).
- **iOS** : sur Mac avec Xcode, `flutter run` sur simulateur ou appareil.

### 1. Cloner et installer les dépendances

```bash
git clone https://github.com/deep-coding15/ReservationBilletCinema.git
cd ReservationBilletCinema
flutter pub get
```

### 2. Configurer PostgreSQL (local ou votre serveur)

Créer la base PostgreSQL et exécuter `server/database/schema.sql`. Configurer `server/config/development.yaml` et `server/config/passwords.yaml`. Voir `server/database/README.md` et `server/SETUP.md`.

**Après chaque `git pull`** (pour récupérer les changements de la base) : `cd server` puis `dart run bin/main.dart --apply-migrations`.

### 3. Lancer l’app Flutter

```bash
flutter run
```

### 4. Générer le code Serverpod (une fois)

```bash
cd server
serverpod generate
```

(CLI : `dart pub global activate serverpod_cli`. Windows : ajouter au PATH : `%LOCALAPPDATA%\Pub\Cache\bin`.)

### 5. Lancer le backend

```bash
cd server
dart run bin/main.dart
```

(Migrations : `dart run bin/main.dart --apply-migrations`.)

---

## 📌 Conventions

- **Feature-first** : une feature = un dossier sous `lib/features/`.
- Pas d’accès direct à la couche Data depuis l’UI ; tout passe par un UseCase / Repository.
- Les providers Riverpod sont dans `presentation/providers`.
- Branches : `feature/<nom>`, `DouaeElassal`, etc. — PR avant merge sur `main`.

---

## 🔮 Roadmap

- [ ] Authentification (login, register, JWT)
- [ ] Liste films / événements (API Serverpod)
- [ ] Détails film, horaires, séances
- [ ] Sélection sièges (plan interactif)
- [ ] Paiement (Stripe, code promo)
- [ ] E-billets et QR
- [ ] Profil, favoris, historique
- [ ] Tableau de bord admin, rapports

---

## 👩‍💻 Équipe

Cahier des charges — Année 2025–2026.  
Branche de travail : **DouaeElassal**.
