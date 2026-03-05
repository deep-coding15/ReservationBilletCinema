-- Add column required by Serverpod so backend starts (your schema.sql stays unchanged)
ALTER TABLE utilisateurs ADD COLUMN IF NOT EXISTS "authUserId" text DEFAULT '';
CREATE INDEX IF NOT EXISTS utilisateur_auth_idx ON utilisateurs("authUserId");
