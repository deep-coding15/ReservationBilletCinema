BEGIN;

-- 1. Création de vos tables (si elles n'existent pas encore)
CREATE TABLE IF NOT EXISTS "films" (
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

CREATE INDEX IF NOT EXISTS "idx_films_date" ON "films" USING btree ("date_debut", "date_fin");

CREATE TABLE IF NOT EXISTS "seances" (
    "id" bigserial PRIMARY KEY,
    "film_id" bigint NOT NULL,
    "salle_id" bigint NOT NULL,
    "date_heure" timestamp without time zone NOT NULL,
    "langue" text NOT NULL DEFAULT 'VF'::text,
    "type_projection" text NOT NULL DEFAULT '2D'::text,
    "places_disponibles" bigint NOT NULL,
    "prix" double precision NOT NULL,
    "type_seance" text NOT NULL DEFAULT 'standard'::text,
    "created_at" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS "idx_seances_film" ON "seances" USING btree ("film_id");
CREATE INDEX IF NOT EXISTS "idx_seances_salle" ON "seances" USING btree ("salle_id");
CREATE INDEX IF NOT EXISTS "idx_seances_date" ON "seances" USING btree ("date_heure");

-- 2. Mise à jour des versions pour TOUS les modules (Crucial pour éviter l'erreur 42P07)
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('cinema_reservation', '20260303113245719', now())
    ON CONFLICT ("module") DO UPDATE SET "version" = '20260303113245719', "timestamp" = now();

INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module") DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260129181124635', now())
    ON CONFLICT ("module") DO UPDATE SET "version" = '20260129181124635', "timestamp" = now();

INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module") DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();

COMMIT;
