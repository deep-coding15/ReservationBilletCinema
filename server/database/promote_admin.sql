-- ============================================================
-- Promouvoir un utilisateur en administrateur (pour les tests)
-- ============================================================
-- Une seule table **users** avec colonne **role** ('admin' ou 'client').
-- Ce script met à jour role = 'admin' pour l'email donné.
--
-- 1) L'utilisateur doit déjà exister (inscription via l'app avec cet email).
-- 2) Remplacez 'admin@test.com' par l'email du compte à promouvoir.
-- 3) Exécuter : psql -U postgres -d cinema_reservation -f promote_admin.sql
-- ============================================================

DO $$
DECLARE
  v_email TEXT := 'da805632@gmail.com';
  v_auth_user_id TEXT;
  v_updated INT;
BEGIN
  -- Récupérer l'identifiant auth Serverpod pour cet email
  SELECT "authUserId"::TEXT INTO v_auth_user_id
  FROM serverpod_auth_idp_email_account
  WHERE email = v_email
  LIMIT 1;

  IF v_auth_user_id IS NULL THEN
    RAISE NOTICE 'Aucun compte auth trouvé pour %. Inscrivez-vous d''abord avec cet email dans l''app.', v_email;
    RETURN;
  END IF;

  -- Mettre à jour ou créer l'entrée users (authUserId doit être renseigné)
  UPDATE users
  SET "authUserId" = v_auth_user_id
  WHERE email = v_email;

  IF NOT FOUND THEN
    -- Créer l'entrée users si elle n'existe pas (après inscription, saveProfile peut avoir créé avec authUserId vide)
    INSERT INTO users ("authUserId", nom, email, statut, role)
    VALUES (v_auth_user_id, 'Admin', v_email, 'actif', 'client')
    ON CONFLICT (email) DO UPDATE SET "authUserId" = EXCLUDED."authUserId";
  END IF;

  -- Donner le rôle admin
  UPDATE users SET role = 'admin' WHERE email = v_email;
  GET DIAGNOSTICS v_updated = ROW_COUNT;

  IF v_updated > 0 THEN
    RAISE NOTICE 'Compte % promu en administrateur (role = admin).', v_email;
  ELSE
    RAISE NOTICE 'Aucun utilisateur trouvé pour %.', v_email;
  END IF;
END $$;
