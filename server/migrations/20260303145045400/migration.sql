BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "reservations" (
    "id" bigserial PRIMARY KEY,
    "utilisateur_id" bigint NOT NULL,
    "seance_id" bigint NOT NULL,
    "date_reservation" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "montant_total" double precision NOT NULL,
    "statut" text NOT NULL DEFAULT 'en_attente'::text,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "idx_reservations_user" ON "reservations" USING btree ("utilisateur_id");
CREATE INDEX "idx_reservations_seance" ON "reservations" USING btree ("seance_id");


--
-- MIGRATION VERSION FOR cinema_reservation
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('cinema_reservation', '20260303145045400', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260303145045400', "timestamp" = now();

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
