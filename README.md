# 🎬 Reservation Billet Cinema

Application multi-plateforme (Android, iOS, Web) de réservation de billets de cinéma et d'événements — **Flutter + Serverpod + PostgreSQL**.

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
- PostgreSQL installé
- Serverpod CLI : `dart pub global activate serverpod_cli`

### 1. Cloner et installer les dépendances

```bash
git clone https://github.com/deep-coding15/ReservationBilletCinema.git
cd ReservationBilletCinema
flutter pub get
```

### 2. Configurer PostgreSQL

Créer la base : `createdb cinema_reservation_db`  
Modifier `server/config/development.yaml` avec vos identifiants (host, username, password).

### 3. Lancer l’app Flutter

```bash
flutter run
```

### 4. Lancer le backend (optionnel pour le dev UI)

```bash
cd server
dart pub get
dart run bin/main.dart
```

Pour un projet Serverpod complet généré par la CLI :

```bash
serverpod create cinema_reservation
# Puis copier les dossiers server/ et client/ générés si besoin.
```

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
