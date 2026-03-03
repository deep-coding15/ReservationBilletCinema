import 'dart:io';

/// URL du backend Serverpod (Android / iOS / Desktop).
///
/// - Émulateur Android dans Android Studio : mets '10.0.2.2' (adresse du PC vu par l'émulateur).
/// - Téléphone réel (même Wi‑Fi que le PC) : mets l'IP de ton PC (ipconfig → IPv4, ex: '192.168.1.45').
/// - Voir TEST_ANDROID_STUDIO.md pour le détail.
const String serverHostForMobile = '10.0.2.2';

const int serverPort = 8090;

String get baseUrl {
  if (Platform.isAndroid || Platform.isIOS) {
    return 'http://$serverHostForMobile:$serverPort';
  }
  return 'http://localhost:$serverPort';
}
