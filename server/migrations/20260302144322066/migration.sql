BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "favoris" (
    "id" bigserial PRIMARY KEY,
    "utilisateurId" bigint NOT NULL,
    "cinemaId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "favori_unique_idx" ON "favoris" USING btree ("utilisateurId", "cinemaId");

--
-- ACTION DROP TABLE
--
DROP TABLE "utilisateurs" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "utilisateurs" (
    "id" bigserial PRIMARY KEY,
    "authUserId" text NOT NULL,
    "nom" text NOT NULL,
    "email" text NOT NULL,
    "telephone" text,
    "dateNaissance" timestamp without time zone,
    "preferences" json,
    "statut" text NOT NULL DEFAULT 'actif'::text
);

-- Indexes
CREATE UNIQUE INDEX "utilisateur_email_idx" ON "utilisateurs" USING btree ("email");
CREATE UNIQUE INDEX "utilisateur_auth_idx" ON "utilisateurs" USING btree ("authUserId");


--
-- MIGRATION VERSION FOR cinema_reservation
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('cinema_reservation', '20260302144322066', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260302144322066', "timestamp" = now();

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
