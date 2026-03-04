import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint profil : récupération, mise à jour, favoris, historique.
class ProfilEndpoint extends Endpoint {
  // ── HELPER : récupérer l'email via authUserId ────────────────────────────
  Future<String?> _getEmail(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;

    final result = await session.db.unsafeQuery(
      'SELECT email FROM serverpod_auth_idp_email_account WHERE "authUserId" = \'${authInfo.userIdentifier}\'',
    );

    if (result.isEmpty) return null;
    return result.first.first as String?;
  }

  // ── HELPER : récupérer l'utilisateur connecté ────────────────────────────
  Future<Utilisateur?> _getUtilisateur(Session session) async {
    final email = await _getEmail(session);
    if (email == null) return null;

    return await Utilisateur.db.findFirstRow(
      session,
      where: (u) => u.email.equals(email),
    );
  }

  // ── GET PROFIL ───────────────────────────────────────────────────────────
  Future<Utilisateur?> getProfil(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) throw Exception('Non authentifié');
    return await _getUtilisateur(session);
  }

  // ── UPDATE PROFIL ────────────────────────────────────────────────────────
  Future<Utilisateur?> updateProfil(
      Session session, {
        required String nom,
        required String telephone,
        List<String>? preferences,
      }) async {
    final authInfo = session.authenticated;
    if (authInfo == null) throw Exception('Non authentifié');

    final utilisateur = await _getUtilisateur(session);
    if (utilisateur == null) return null;

    final updated = utilisateur.copyWith(
      nom: nom,
      telephone: telephone,
      preferences: preferences,
    );

    return await Utilisateur.db.updateRow(session, updated);
  }

  // ── GET FAVORIS ──────────────────────────────────────────────────────────
  Future<List<Favori>> getFavoris(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) throw Exception('Non authentifié');

    final utilisateur = await _getUtilisateur(session);
    if (utilisateur == null) return [];

    return await Favori.db.find(
      session,
      where: (f) => f.utilisateurId.equals(utilisateur.id!),
    );
  }

  // ── AJOUTER FAVORI ───────────────────────────────────────────────────────
  Future<void> ajouterFavori(Session session, {required int cinemaId}) async {
    final authInfo = session.authenticated;
    if (authInfo == null) throw Exception('Non authentifié');

    final utilisateur = await _getUtilisateur(session);
    if (utilisateur == null) return;

    final existing = await Favori.db.findFirstRow(
      session,
      where: (f) =>
      f.utilisateurId.equals(utilisateur.id!) &
      f.cinemaId.equals(cinemaId),
    );
    if (existing != null) return;

    await Favori.db.insertRow(
      session,
      Favori(utilisateurId: utilisateur.id!, cinemaId: cinemaId),
    );
  }

  // ── SUPPRIMER FAVORI ─────────────────────────────────────────────────────
  Future<void> supprimerFavori(Session session, {required int cinemaId}) async {
    final authInfo = session.authenticated;
    if (authInfo == null) throw Exception('Non authentifié');

    final utilisateur = await _getUtilisateur(session);
    if (utilisateur == null) return;

    final favori = await Favori.db.findFirstRow(
      session,
      where: (f) =>
      f.utilisateurId.equals(utilisateur.id!) &
      f.cinemaId.equals(cinemaId),
    );
    if (favori == null) return;

    await Favori.db.deleteRow(session, favori);
  }

  // ── HISTORIQUE ───────────────────────────────────────────────────────────
  Future<List<dynamic>> getHistoriqueReservations(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) throw Exception('Non authentifié');
    return [];
  }
}