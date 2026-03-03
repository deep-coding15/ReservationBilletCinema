# Tester l'app dans Android Studio (émulateur ou téléphone)

## 1. Lancer le serveur sur ton PC (obligatoire)

Sans ça, l'app ne peut pas charger les films ni les événements.

**PowerShell :**
```powershell
cd C:\Users\daurinia\ReservationBilletCinema-work\server
dart run bin/main.dart
```
Laisse cette fenêtre ouverte. Tu dois voir que le serveur écoute (port 8080).

---

## 2. Choisir comment tester : émulateur OU téléphone

### Option A — Émulateur Android (recommandé pour débloquer)

L’émulateur et ton PC sont le même ordinateur, donc pas de souci de Wi‑Fi.

1. **Ouvrir le projet dans Android Studio**
   - Fichier → Ouvrir → choisis le dossier `ReservationBilletCinema-work` (la racine du projet Flutter, là où il y a `pubspec.yaml`).

2. **Créer un appareil virtuel (AVD) si tu n’en as pas**
   - Outils → **Device Manager** (ou icône téléphone/tablette dans la barre d’outils).
   - Clique **Create Device**.
   - Choisis un modèle (ex. Pixel 6) → Next.
   - Choisis une image système (ex. **Tiramisu** API 33) → télécharge si besoin → Next → Finish.

3. **Configurer l’app pour l’émulateur**
   - Ouvre le fichier :  
     `lib/core/constants/api_constants_io.dart`
   - Remplace l’IP par l’adresse spéciale de l’émulateur :
   ```dart
   const String serverHostForMobile = '10.0.2.2';
   ```
   - `10.0.2.2` = « le PC qui fait tourner l’émulateur » (ton serveur).

4. **Lancer l’app**
   - En bas à droite d’Android Studio : liste des appareils. Choisis ton **émulateur**.
   - Menu **Run** → **Run 'main.dart'** (ou bouton vert Play).
   - L’app se lance sur l’émulateur et doit se connecter au serveur.

---

### Option B — Téléphone Android réel (Infinix, etc.)

1. **Activer le mode développeur et le débogage USB**
   - Paramètres → À propos du téléphone → tape 7 fois sur « Numéro de build ».
   - Retour → Options pour les développeurs → activer **Débogage USB**.

2. **Brancher le téléphone en USB**
   - Autorise le débogage sur le téléphone si demandé.

3. **Trouver l’IP de ton PC**
   - Sur le PC, PowerShell : `ipconfig`
   - Section **Wi‑Fi** (ou **Carte Ethernet**) → **Adresse IPv4** (ex. `192.168.1.45`).

4. **Configurer l’app pour le téléphone**
   - Ouvre `lib/core/constants/api_constants_io.dart`.
   - Remplace par l’IP de ton PC :
   ```dart
   const String serverHostForMobile = '192.168.1.45';  // ton IP à toi
   ```

5. **Même Wi‑Fi**
   - PC et téléphone doivent être sur le **même réseau Wi‑Fi**.

6. **Lancer l’app**
   - Dans Android Studio, appareil = ton téléphone (il doit apparaître en haut ou en bas).
   - Run → Run 'main.dart'.

---

## 3. iPhone / iOS

- Les **simulateurs iOS** ne tournent que sur **Mac** (Xcode).
- Sur **Windows**, tu ne peux pas ajouter un appareil iPhone ni lancer le simulateur iOS. Tu peux uniquement tester **Android** (émulateur ou téléphone).

---

## 4. Récap

| Où tu lances l'app | Valeur à mettre dans `api_constants_io.dart` |
|--------------------|-----------------------------------------------|
| **Émulateur Android** | `'10.0.2.2'` |
| **Téléphone Android (même Wi‑Fi que le PC)** | IP de ton PC (ex. `'192.168.1.45'`) |
| **Windows / Chrome (depuis ton PC)** | Pas besoin, l'app utilise déjà `localhost`. |

Si tu es bloqué : commence par **Option A (émulateur)** avec `10.0.2.2` et le serveur lancé sur le PC.
