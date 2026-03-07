# Démarrer CinePass et résoudre les erreurs

## Ordre de démarrage

1. **Libérer les ports** (si le serveur a déjà tourné une fois)  
2. **Lancer le backend**  
3. **Lancer le frontend**

---

## 1. Erreur : "Failed to bind socket, port 8090 (ou 8081, 9083) may already be in use"

**Cause :** Un ancien processus serveur utilise encore les ports.

**Solution :**

- **Option A** – Double-cliquer sur **`liberer_ports_serveur.bat`** à la racine du projet.  
  Puis relancer le backend : `cd server` puis `dart run bin/main.dart`.

- **Option B** – Dans PowerShell, à la racine du projet :
  ```powershell
  cd server
  .\stop_server_ports.ps1
  dart run bin/main.dart
  ```

---

## 2. Avertissement : "The database does not match the target database... Column role mismatch"

**Cause :** Le schéma PostgreSQL (table `users`) ne correspond pas exactement à ce que Serverpod attend.

**Solution (une seule fois) :**

Arrêter le serveur (Ctrl+C), libérer les ports si besoin, puis lancer :

```bash
cd server
dart run bin/main.dart --apply-repair-migration
```

Attendre la fin du message de réparation, puis relancer normalement :

```bash
dart run bin/main.dart
```

---

## 3. Erreur Flutter : "Failed host lookup: 'pub.dev' (No such host is known)"

**Cause :** Problème réseau ou DNS sur ta machine (internet coupé, DNS qui ne résout pas pub.dev, proxy, etc.).

**Solutions possibles :**

1. **Vérifier la connexion internet** (navigateur, ping, etc.).
2. **Changer de réseau** (ex. partage de connexion du téléphone) et réessayer :
   ```bash
   flutter pub get
   flutter run -d chrome
   ```
3. **Tester avec le DNS Google** (adapter selon ton Windows) :
   - Paramètres réseau → carte réseau → IPv4 → DNS : 8.8.8.8 et 8.8.4.4
   - Puis redémarrer le terminal et refaire `flutter pub get`.
4. **Mode hors ligne** (si tu as déjà fait `flutter pub get` une fois avec succès sur ce projet) :
   ```bash
   flutter pub get --offline
   flutter run -d chrome
   ```

---

## Récapitulatif : lancer le projet

1. **Libérer les ports** : double-clic sur `liberer_ports_serveur.bat`.
2. **Backend** : dans un terminal, `cd server` puis `dart run bin/main.dart`. Attendre "serveur demarre" ou équivalent.
3. **Frontend** : dans un autre terminal, à la racine du projet, `flutter run -d chrome` (ou `flutter run -d windows`).
4. Si la base affiche un mismatch : une fois, lancer avec `--apply-repair-migration` comme ci-dessus, puis relancer normalement.
