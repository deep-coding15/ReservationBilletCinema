BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "films" (
    "id" bigserial PRIMARY KEY,
    "titre" text NOT NULL,
    "synopsis" text,
    "genre" text,
    "duree" bigint NOT NULL,
    "realisateur" text,
    "casting" json,
    "affiche" text,
    "bande_annonce" text,
    "classification" text,
    "note_moyenne" double precision,
    "date_debut" timestamp without time zone NOT NULL,
    "date_fin" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "idx_films_date" ON "films" USING btree ("date_debut", "date_fin");


--
-- MIGRATION VERSION FOR cinema_reservation
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('cinema_reservation', '20260302225547964', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260302225547964', "timestamp" = now();

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
