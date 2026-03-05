-- ============================================================
-- Schéma de la base de données - Reservation Billet Cinema
-- PostgreSQL (local ou serveur à vous)
-- ============================================================
-- Les mots de passe ne sont PAS dans cette table : ils sont gérés par
-- Serverpod Auth (table serverpod_auth_idp_email_account, colonne passwordHash).
-- La table users contient uniquement le profil métier (nom, email, role, etc.)
-- et le lien authUserId vers l'auth. Les tables d'auth sont créées par
-- les migrations Serverpod (dart run bin/main.dart --apply-migrations).
-- ============================================================

-- Table users (spectateurs et admins : rôle dans la colonne role)
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    "authUserId" TEXT DEFAULT '',
    nom VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telephone VARCHAR(50),
    "dateNaissance" TIMESTAMP,
    preferences JSONB,
    statut VARCHAR(50) DEFAULT 'actif',
    role VARCHAR(50) DEFAULT 'client' CHECK (role IN ('admin', 'client')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE UNIQUE INDEX IF NOT EXISTS utilisateur_email_idx ON users(email);
CREATE UNIQUE INDEX IF NOT EXISTS utilisateur_auth_idx ON users("authUserId");

-- Table cinémas
CREATE TABLE IF NOT EXISTS cinemas (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    adresse VARCHAR(500),
    ville VARCHAR(255),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table salles
CREATE TABLE IF NOT EXISTS salles (
    id SERIAL PRIMARY KEY,
    cinema_id INTEGER NOT NULL REFERENCES cinemas(id) ON DELETE CASCADE,
    code_salle VARCHAR(50) NOT NULL,
    capacite INTEGER NOT NULL,
    equipements TEXT[],
    UNIQUE(cinema_id, code_salle)
);

-- Table films
CREATE TABLE IF NOT EXISTS films (
    id SERIAL PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    synopsis TEXT,
    genre VARCHAR(100),
    duree INTEGER NOT NULL,
    realisateur VARCHAR(255),
    casting TEXT[],
    affiche VARCHAR(500),
    bande_annonce VARCHAR(500),
    classification VARCHAR(50) DEFAULT 'Tous publics',
    note_moyenne DOUBLE PRECISION DEFAULT 0,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table séances
CREATE TABLE IF NOT EXISTS seances (
    id SERIAL PRIMARY KEY,
    film_id INTEGER NOT NULL REFERENCES films(id) ON DELETE CASCADE,
    salle_id INTEGER NOT NULL REFERENCES salles(id) ON DELETE CASCADE,
    date_heure TIMESTAMP NOT NULL,
    langue VARCHAR(20) DEFAULT 'VF',
    type_projection VARCHAR(50) DEFAULT '2D',
    places_disponibles INTEGER NOT NULL,
    prix DOUBLE PRECISION NOT NULL,
    type_seance VARCHAR(50) DEFAULT 'standard',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table catégories de sièges
CREATE TABLE IF NOT EXISTS categorie_sieges (
    id SERIAL PRIMARY KEY,
    type VARCHAR(100) NOT NULL,
    description TEXT,
    tarif DOUBLE PRECISION NOT NULL
);

-- Table sièges
CREATE TABLE IF NOT EXISTS sieges (
    id SERIAL PRIMARY KEY,
    salle_id INTEGER NOT NULL REFERENCES salles(id) ON DELETE CASCADE,
    numero VARCHAR(20) NOT NULL,
    type VARCHAR(50) DEFAULT 'standard',
    categorie_siege_id INTEGER REFERENCES categorie_sieges(id),
    UNIQUE(salle_id, numero)
);

-- Table réservations
CREATE TABLE IF NOT EXISTS reservations (
    id SERIAL PRIMARY KEY,
    utilisateur_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    seance_id INTEGER NOT NULL REFERENCES seances(id) ON DELETE CASCADE,
    date_reservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    montant_total DOUBLE PRECISION NOT NULL,
    statut VARCHAR(50) DEFAULT 'en_attente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table réservation_sièges
CREATE TABLE IF NOT EXISTS reservation_sieges (
    id SERIAL PRIMARY KEY,
    reservation_id INTEGER NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    siege_id INTEGER NOT NULL REFERENCES sieges(id) ON DELETE CASCADE,
    UNIQUE(reservation_id, siege_id)
);

-- Table paiements
CREATE TABLE IF NOT EXISTS paiements (
    id SERIAL PRIMARY KEY,
    reservation_id INTEGER NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    montant DOUBLE PRECISION NOT NULL,
    methode VARCHAR(100) NOT NULL,
    statut VARCHAR(50) DEFAULT 'en_attente',
    info_paiement_sauvegardee BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table billets
CREATE TABLE IF NOT EXISTS billets (
    id SERIAL PRIMARY KEY,
    reservation_id INTEGER NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    date_emission TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    est_valide BOOLEAN DEFAULT TRUE,
    type_billet VARCHAR(50) DEFAULT 'electronique',
    qr_code VARCHAR(500),
    UNIQUE(reservation_id)
);

-- Table favoris
CREATE TABLE IF NOT EXISTS favoris (
    id SERIAL PRIMARY KEY,
    utilisateur_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    cinema_id INTEGER NOT NULL REFERENCES cinemas(id) ON DELETE CASCADE,
    UNIQUE(utilisateur_id, cinema_id)
);

-- Table options supplémentaires
CREATE TABLE IF NOT EXISTS option_supplementaires (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prix DOUBLE PRECISION NOT NULL,
    categorie VARCHAR(100)
);

-- Table réservation_options
CREATE TABLE IF NOT EXISTS reservation_options (
    id SERIAL PRIMARY KEY,
    reservation_id INTEGER NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    option_id INTEGER NOT NULL REFERENCES option_supplementaires(id) ON DELETE CASCADE,
    quantite INTEGER DEFAULT 1
);

-- Table codes promo
CREATE TABLE IF NOT EXISTS codes_promo (
    id SERIAL PRIMARY KEY,
    code VARCHAR(100) NOT NULL UNIQUE,
    type VARCHAR(50),
    valeur DOUBLE PRECISION NOT NULL,
    date_debut DATE,
    date_fin DATE,
    actif BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table FAQ
CREATE TABLE IF NOT EXISTS faq (
    id SERIAL PRIMARY KEY,
    question TEXT NOT NULL,
    reponse TEXT NOT NULL,
    categorie VARCHAR(100),
    ordre INTEGER DEFAULT 0
);

-- Table demandes de support
CREATE TABLE IF NOT EXISTS demandes_support (
    id SERIAL PRIMARY KEY,
    utilisateur_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sujet VARCHAR(255),
    message TEXT NOT NULL,
    statut VARCHAR(50) DEFAULT 'ouvert',
    reponse TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table événements (dans un cinéma ou autre lieu)
CREATE TABLE IF NOT EXISTS evenements (
    id SERIAL PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    description TEXT,
    categorie VARCHAR(100),
    lieu_type VARCHAR(50) DEFAULT 'cinema',
    cinema_id INTEGER REFERENCES cinemas(id) ON DELETE SET NULL,
    lieu_nom VARCHAR(255),
    adresse VARCHAR(500),
    ville VARCHAR(255),
    date_heure TIMESTAMP NOT NULL,
    prix DOUBLE PRECISION NOT NULL DEFAULT 0,
    places_disponibles INTEGER NOT NULL DEFAULT 0,
    affiche VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_evenements_ville ON evenements(ville);
CREATE INDEX IF NOT EXISTS idx_evenements_date ON evenements(date_heure);

-- Réservations événements (même logique que cinéma : type + options par billet côté app)
CREATE TABLE IF NOT EXISTS reservations_evenements (
    id SERIAL PRIMARY KEY,
    utilisateur_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    evenement_id INTEGER NOT NULL REFERENCES evenements(id) ON DELETE CASCADE,
    nb_billets INTEGER NOT NULL,
    montant_total DOUBLE PRECISION NOT NULL,
    statut VARCHAR(50) DEFAULT 'en_attente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_reservations_evenements_user ON reservations_evenements(utilisateur_id);
CREATE INDEX IF NOT EXISTS idx_reservations_evenements_event ON reservations_evenements(evenement_id);

-- Index
CREATE INDEX IF NOT EXISTS idx_films_date ON films(date_debut, date_fin);
CREATE INDEX IF NOT EXISTS idx_seances_film ON seances(film_id);
CREATE INDEX IF NOT EXISTS idx_seances_salle ON seances(salle_id);
CREATE INDEX IF NOT EXISTS idx_seances_date ON seances(date_heure);
CREATE INDEX IF NOT EXISTS idx_reservations_user ON reservations(utilisateur_id);
CREATE INDEX IF NOT EXISTS idx_reservations_seance ON reservations(seance_id);
CREATE INDEX IF NOT EXISTS idx_cinemas_ville ON cinemas(ville);
