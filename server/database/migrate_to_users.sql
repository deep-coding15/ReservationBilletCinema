-- ============================================================
-- Une seule table USERS avec rôle (admin ou client)
-- ============================================================
-- 1) Ajoute la colonne role à la table utilisateurs
-- 2) Met à jour les rôles à partir de la table administrateurs
-- 3) Supprime la table administrateurs
-- 4) Renomme utilisateurs en users
--
-- Exécuter : psql -U postgres -d cinema_reservation -f migrate_to_users.sql
-- ============================================================

-- Ajouter la colonne role (défaut client)
ALTER TABLE utilisateurs
  ADD COLUMN IF NOT EXISTS role VARCHAR(50) DEFAULT 'client';

-- Donner le rôle admin à ceux qui sont dans administrateurs
UPDATE utilisateurs u
SET role = 'admin'
FROM administrateurs a
WHERE a.utilisateur_id = u.id;

-- Valeur par défaut pour les lignes sans rôle
UPDATE utilisateurs SET role = 'client' WHERE role IS NULL;

-- Supprimer la table administrateurs
DROP TABLE IF EXISTS administrateurs CASCADE;

-- Renommer la table en users
ALTER TABLE utilisateurs RENAME TO users;

-- Contrainte pour limiter les valeurs de role (optionnel)
ALTER TABLE users
  ADD CONSTRAINT users_role_check
  CHECK (role IN ('admin', 'client'));
