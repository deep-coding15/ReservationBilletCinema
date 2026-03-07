# Installation après clonage (pour les membres de l’équipe)

Ce guide permet d’avoir **exactement la même version** que le dépôt après un `git clone` de [https://github.com/deep-coding15/ReservationBilletCinema](https://github.com/deep-coding15/ReservationBilletCinema), **sans erreurs de types manquants** (`ReservationResult`, `Siege`, `Favori`, `Client.reservations`).

---

## Structure des modèles (`server/lib/src/models/`)

Les modèles partagés (API / protocole) sont définis dans **`server/lib/src/models/`** en YAML (`.spy.yaml`), pour les trois parcours : visiteur non inscrit, visiteur inscrit, admin.

- **`models/films/`** : `film`, `cinema`, `salle`, `seance`
- **`models/reservations/`** : `siege`, `reservation_result`, `reservation`, `billet`
- **`models/events/`** : `evenement`, `reservation_evenement`
- **Racine** : `utilisateur`, `favori`

Après modification d’un `.spy.yaml`, exécuter **`dart run serverpod_cli:generate`** depuis **`server/`**.

---

## Important : ne pas lancer `serverpod generate` après le clonage

Le code **généré** (dossier `server/lib/src/generated/` et package `client/`) est **déjà versionné**.  
Si tu lances `serverpod generate` après un clone et que la commande échoue (par ex. « Endpoint analysis skipped due to invalid Dart syntax »), le client peut être réécrit de façon incomplète et tu auras des erreurs du type :

- `Type 'ReservationResult' not found`
- `Type 'Siege' not found`
- `The getter 'reservations' isn't defined for the type 'Client'`
- `'Favori' is imported from both ...`

**À faire :** après un clone, **ne pas exécuter `serverpod generate`**. Utilise uniquement les étapes ci‑dessous.  
**Si tu l’as déjà lancé et que l’app ne compile plus :** restaure le code généré :

```bash
git checkout -- client/
git checkout -- server/lib/src/generated/
```

Puis refais `flutter pub get` et `cd server && dart pub get`.

---

## Étapes dans l’ordre

### 1. Cloner le dépôt

```bash
git clone https://github.com/deep-coding15/ReservationBilletCinema.git
cd ReservationBilletCinema
```

### 2. Installer les dépendances (sans `serverpod generate`)

```bash
flutter pub get
cd server
dart pub get
cd ..
```

### 3. Configurer la base de données PostgreSQL

- Créer la base (une fois) :

```bash
psql -U postgres -c "CREATE DATABASE cinema_reservation;"
```

- Appliquer le schéma et les données de démo :

```bash
psql -U postgres -d cinema_reservation -f server/database/schema.sql
psql -U postgres -d cinema_reservation -f server/database/seed_films.sql
```

- Créer le fichier des mots de passe (obligatoire pour le serveur) :

```bash
# Windows (CMD)
copy server\config\passwords.yaml.example server\config\passwords.yaml

# Windows (PowerShell) ou Linux / macOS
cp server/config/passwords.yaml.example server/config/passwords.yaml
```

- Éditer `server/config/passwords.yaml` et `server/config/development.yaml` si besoin (utilisateur PostgreSQL, mot de passe, port).

### 4. Migrations Serverpod (optionnel)

Tu peux lancer une fois :

```bash
cd server
dart run bin/main.dart --apply-migrations
cd ..
```

Il est possible qu’un **WARNING** s’affiche sur la table `users` (colonnes différentes du schéma Serverpod). Tu peux l’ignorer si tu as appliqué `schema.sql` : l’app fonctionne avec ce schéma. Ne pas relancer `serverpod generate` pour « corriger » ce warning.

### 5. Lancer le backend puis l’app

- Terminal 1 (backend) :

```bash
cd server
dart run bin/main.dart
```

- Terminal 2 (Flutter) :

```bash
flutter run -d chrome
```

(ou un autre device : `flutter run` puis choisir Android / iOS.)

---

## Résumé des commandes (copier‑coller)

```bash
git clone https://github.com/deep-coding15/ReservationBilletCinema.git
cd ReservationBilletCinema

flutter pub get
cd server && dart pub get && cd ..

psql -U postgres -c "CREATE DATABASE cinema_reservation;"
psql -U postgres -d cinema_reservation -f server/database/schema.sql
psql -U postgres -d cinema_reservation -f server/database/seed_films.sql

copy server\config\passwords.yaml.example server\config\passwords.yaml
```

Ensuite : configurer `server/config/passwords.yaml` et `development.yaml`, puis lancer le serveur et Flutter comme ci‑dessus.

---

## Quand lancer `serverpod generate` ?

Uniquement **si tu modifies toi‑même** les modèles ou endpoints côté serveur (fichiers dans `server/lib/src/`). Dans ce cas :

1. Faire les changements.
2. Lancer `serverpod generate` **depuis le dossier `server`**.
3. Vérifier que la commande se termine **sans erreur**.
4. Faire `flutter pub get` à la racine.

Si `serverpod generate` affiche « Endpoint analysis skipped due to invalid Dart syntax », il ne faut pas committer le nouveau client généré : remettre l’ancien avec `git checkout -- client/ server/lib/src/generated/` et corriger d’abord la syntaxe Dart indiquée.
