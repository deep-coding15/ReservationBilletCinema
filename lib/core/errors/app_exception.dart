/// Exception métier de l'application.
class AppException implements Exception {
  AppException(this.message, [this.code]);

  final String message;
  final String? code;

  @override
  String toString() => 'AppException: $message';
}
