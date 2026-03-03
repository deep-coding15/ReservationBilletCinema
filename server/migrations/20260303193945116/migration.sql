BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "utilisateurs" (
    "id" bigserial PRIMARY KEY,
    "nom" text NOT NULL,
    "email" text NOT NULL,
    "telephone" text,
    "mot_de_passe_hash" text NOT NULL,
    "preferences" json,
    "statut" text NOT NULL DEFAULT 'actif'::text,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "idx_utilisateur_email" ON "utilisateurs" USING btree ("email");


--
-- MIGRATION VERSION FOR cinema_reservation
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('cinema_reservation', '20260303193945116', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260303193945116', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260129181124635', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181124635', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
