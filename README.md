# 🎬 Cinema Booking App

Application mobile Flutter de réservation de tickets de cinéma, construite avec une architecture Clean Architecture + Feature First.

## 🏗 Architecture

Le projet suit :

- Clean Architecture

- Feature-first organization

- Riverpod pour state management & dependency injection

- Dio pour les appels réseau

- GoRouter pour la navigation

Structure :
```scss
lib/
├── core/
├── features/
├── shared/
└── main.dart
```

Chaque feature contient :
```scss
feature/
├── data/
├── domain/
└── presentation/
```

## 🧠 Architecture Flow
UI → Provider (Riverpod) → UseCase → Repository → DataSource

- UI ne dépend pas de Data

- Domain est indépendant de Flutter

- Data implémente les abstractions du Domain

## 🚀 Stack Technique

- Flutter

- Riverpod

- Dio

- GoRouter

- Freezed (future)

- JSON Serializable

## 📦 Installation
- git clone https://github.com/deep-coding15/ReservationBilletCinema.git
- cd ReservationBilletCinema
- flutter pub get
- flutter run

## 📌 Conventions

- Feature-first organization

- Aucun accès direct Data depuis UI

- Toute logique métier passe par un UseCase

- Les Providers sont définis dans presentation/providers

## 🔮 Roadmap

- Authentication

- Movies listing (API integration)

- Movie details

- Seat selection

- Booking flow

- Payment integration

- Profile management

## 👩‍💻 Collaboration

- Branche principale : main

- Feature branch naming : feature/<feature-name>

- Pull request obligatoire avant merge