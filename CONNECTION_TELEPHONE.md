# Tester l'app sur ton téléphone (connexion au serveur)

Sur un **téléphone réel**, "localhost" désigne le téléphone, pas ton PC. L'app doit donc utiliser l'**IP de ton PC** pour joindre le serveur Serverpod.

## Étapes

1. **Lance le serveur sur ton PC**
   ```bash
   cd server
   dart run bin/main.dart
   ```

2. **Trouve l'IP de ton PC**
   - Windows : ouvre une invite de commandes et tape `ipconfig`. Repère l’adresse IPv4 (ex. `192.168.1.50`) de ta carte Wi‑Fi ou Ethernet.
   - Mac/Linux : `ifconfig` ou `ip addr`.

3. **Configure l’app Flutter**
   - Ouvre `lib/core/constants/api_constants_io.dart`.
   - Remplace `192.168.1.100` par **ton IP** dans :
     ```dart
     const String serverHostForMobile = '192.168.1.50';  // ton IP
     ```

4. **Relance l’app sur le téléphone**
   ```bash
   flutter run
   ```
   Choisis ton appareil Android/iOS.

Le téléphone et le PC doivent être sur le **même réseau Wi‑Fi**. Si tu vois "Connection refused", vérifie que le serveur tourne sur le PC et que l’IP dans `api_constants_io.dart` est bien celle du PC.
