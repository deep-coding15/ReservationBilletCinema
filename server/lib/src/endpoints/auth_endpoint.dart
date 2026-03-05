import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AuthEndpoint extends Endpoint {
  /// Retourne true si l'utilisateur connecté a le rôle admin (table users, colonne role).
  /// Synchronise authUserId sur l'entrée users si trouvée par email (premier login).
  Future<bool> isAdmin(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;

    final authIdStr = authInfo.userIdentifier.toString().trim().toLowerCase();
    var utilisateur = await Utilisateur.db.findFirstRow(
      session,
      where: (u) => u.authUserId.equals(authIdStr),
    );
    if (utilisateur == null) {
      final escaped = authIdStr.replaceAll("'", "''");
      final roleRows = await session.db.unsafeQuery(
        'SELECT role FROM users WHERE LOWER(TRIM("authUserId")) = \'$escaped\' LIMIT 1',
      );
      if (roleRows.isNotEmpty && roleRows.first.isNotEmpty && roleRows.first.first == 'admin') {
        return true;
      }
      if (roleRows.isNotEmpty) return false;
    }
    if (utilisateur == null) {
      final escapedId = authIdStr.replaceAll("'", "''");
      // userIdentifier peut être authUserId OU l'id du compte email selon la version Serverpod
      final emailResult = await session.db.unsafeQuery(
        "SELECT email, \"authUserId\"::text FROM serverpod_auth_idp_email_account "
        "WHERE \"authUserId\"::text = '$escapedId' OR LOWER(\"authUserId\"::text) = LOWER('$escapedId') "
        "OR id::text = '$escapedId' OR LOWER(id::text) = LOWER('$escapedId') LIMIT 1",
      );
      String? email;
      String? resolvedAuthId;
      if (emailResult.isNotEmpty && emailResult.first.length >= 2) {
        email = emailResult.first[0] as String?;
        resolvedAuthId = emailResult.first[1] as String?;
      }
      if (email != null && email.isNotEmpty) {
        utilisateur = await Utilisateur.db.findFirstRow(
          session,
          where: (u) => u.email.equals(email),
        );
        if (utilisateur != null) {
          final toStore = (resolvedAuthId ?? authIdStr).trim().toLowerCase();
          if (utilisateur.authUserId.isEmpty || utilisateur.authUserId.trim().toLowerCase() != toStore) {
            await Utilisateur.db.updateRow(
              session,
              utilisateur.copyWith(authUserId: toStore),
            );
            utilisateur = utilisateur.copyWith(authUserId: toStore);
          }
        }
      }
      if (utilisateur == null && resolvedAuthId != null && resolvedAuthId.isNotEmpty) {
        final roleRows = await session.db.unsafeQuery(
          'SELECT role FROM users WHERE LOWER(TRIM("authUserId")) = \'${resolvedAuthId.trim().toLowerCase().replaceAll("'", "''")}\' LIMIT 1',
        );
        if (roleRows.isNotEmpty && roleRows.first.isNotEmpty && roleRows.first.first == 'admin') {
          return true;
        }
        if (roleRows.isNotEmpty) return false;
      }
    }
    if (utilisateur == null) return false;

    // Une seule table users : le rôle est dans la colonne role ('admin' ou 'client').
    return utilisateur.role == 'admin';
  }

  Future<void> saveProfile(
      Session session, {
        required String nom,
        required String email,
        String? telephone,
        DateTime? dateNaissance,
      }) async {
    // Pas de vérification auth — appelé juste après finishRegistration
    final existing = await Utilisateur.db.findFirstRow(
      session,
      where: (u) => u.email.equals(email),
    );
    if (existing != null) return;

    await Utilisateur.db.insertRow(
      session,
      Utilisateur(
        authUserId: '', // sera mis à jour lors du premier login
        nom: nom,
        email: email,
        telephone: telephone,
        dateNaissance: dateNaissance,
        statut: 'actif',
        role: 'client',
      ),
    );
  }
}