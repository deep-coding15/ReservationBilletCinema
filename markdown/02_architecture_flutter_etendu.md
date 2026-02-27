# 🏗 1️⃣ Dossiers globaux supplémentaires
En plus de core/ et config/, je te recommande :
```scss
lib/
├── config/
├── core/
├── shared/
├── features/
├── app/
└── main.dart
```

## 📂 app/
Responsable de :

- Injection globale (Riverpod overrides)

- Initialisation services (Firebase, Supabase, API)

- Bootstrap app

Exemple :
```scss
app/
├── app.dart
├── providers.dart
└── dependency_injection.dart
```

## 📂 shared/
Tout ce qui est UI partagé entre plusieurs features :

```scss
shared/
├── widgets/
├── components/
├── dialogs/
├── loaders/
└── extensions/
```

Exemple :

- CustomButton

- AppTextField

- ErrorDialog

- LoadingOverlay

⚠️ Rien de métier ici.

# 🎬 2️⃣ FEATURES COMPLETES POUR L'APP
On va découper le projet en modules indépendants.

## 🔵 1. auth
Responsable :

- Login

- Register

- Logout

- Forgot password

- Token management

**features/auth/**

## 🔵 2. user
Responsable :

- Profil utilisateur

- Modification infos

- Historique réservations

- Programme fidélité

**features/user/**

## 🔵 3. movies
Responsable :

- Liste films

- Détails film

- Recherche

- Filtres

**features/movies/**

## 🔵 4. cinemas
Responsable :

- Liste cinémas

- Localisation

- Détails cinéma

- Salles disponibles

**features/cinemas/**

## 🔵 5. showtimes (séances)
Responsable :

- Séances par film

- Séances par cinéma

- Disponibilité temps réel

**features/showtimes/**

## 🔵 6. booking
Responsable :

- Sélection sièges

- Plan de salle

- Création réservation

- Gestion panier

**features/booking/**

## 🔵 7. payment
Responsable :

- Paiement carte

- Code promo

- Confirmation paiement

- WebView paiement

**features/payment/**

## 🔵 8. tickets
Responsable :

- Génération QR code

- Liste billets

- Détails billet

- Validation état

**features/tickets/**

## 🔵 9. snacks (optionnel mais pro)
Responsable :

- Catalogue snacks

- Ajout panier

- Pré-commande

**features/snacks/**

## 🔵 10. reviews
Responsable :

- Notes films

- Commentaires

- Consultation avis

**features/reviews/**

## 🔵 11. notifications
Responsable :

- Push notifications

- Rappels

- Promotions

**features/notifications/**

# 🧱 Structure interne d’une feature
Chaque feature :

```scss
feature_name/
├── data/
│    ├── data_sources/
│    ├── models/
│    └── repository/
├── domain/
│    ├── entities/
│    ├── repository/
│    └── usecases/
└── presentation/
├── providers/
├── pages/
└── widgets/
```

Toujours la même structure.

# 🧠 Organisation complète recommandée

```scss
lib/
├── app/
├── config/
│    ├── routes/
│    └── theme/
├── core/
│    ├── error/
│    ├── network/
│    ├── usecases/
│    └── constants/
├── shared/
│    ├── widgets/
│    ├── dialogs/
│    └── components/
├── features/
│    ├── auth/
│    ├── user/
│    ├── movies/
│    ├── cinemas/
│    ├── showtimes/
│    ├── booking/
│    ├── payment/
│    ├── tickets/
│    ├── snacks/
│    ├── reviews/
│    └── notifications/
└── main.dart
```

🎯 Minimum viable version/product
Pour version académique :

- auth

- movies

- showtimes

- booking

- payment

- tickets

- user

Les autres peuvent être ajoutés plus tard.