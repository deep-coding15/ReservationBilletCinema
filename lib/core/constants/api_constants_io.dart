import 'dart:io';

/// URL du backend Serverpod (Android / iOS / Desktop).
/// Sur téléphone réel : remplace [serverHostForMobile] par l'IP de ton PC
/// (ex: 192.168.1.50). Trouve-la avec ipconfig (Windows) ou ifconfig (Mac/Linux).
const String serverHostForMobile = '192.168.1.100';

const int serverPort = 8080;

String get baseUrl {
  if (Platform.isAndroid || Platform.isIOS) {
    return 'http://$serverHostForMobile:$serverPort';
  }
  return 'http://localhost:$serverPort';
}
