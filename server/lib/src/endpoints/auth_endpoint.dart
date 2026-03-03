import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AuthEndpoint extends Endpoint {
  Future<void> saveProfile(
      Session session, {
        required String nom,
        required String email,
        String? telephone,
        DateTime? dateNaissance,
      }) async {
    final existing = await Utilisateur.db.findFirstRow(
      session,
      where: (u) => u.email.equals(email),
    );
    if (existing != null) return;

    await Utilisateur.db.insertRow(
      session,
      Utilisateur(
        nom: nom,
        email: email,
        telephone: telephone,
        dateNaissance: dateNaissance,
        statut: 'actif',
      ),
    );
  }
}