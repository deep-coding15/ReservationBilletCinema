import 'api_constants_io.dart' if (dart.library.html) 'api_constants_web.dart' as _impl;

/// Constantes API (URL du backend Serverpod).
/// Sur téléphone : modifie [serverHostForMobile] dans api_constants_io.dart
/// avec l'IP de ton PC (ipconfig sous Windows) pour que l'app atteigne le serveur.
class ApiConstants {
  static String get baseUrl => _impl.baseUrl;
}
