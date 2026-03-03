-- Table films (Mise à jour pour correspondre à la réalité de la DB)
CREATE TABLE IF NOT EXISTS films (
    id SERIAL PRIMARY KEY,
    titre varchar NOT NULL,
    synopsis varchar,
    genre varchar,
    duree integer NOT NULL,
    realisateur varchar,
    casting jsonb,
    affiche varchar,
    bande_annonce varchar,
    classification varchar,
    note_moyenne double precision,
    date_debut timestamp without time zone NOT NULL,
    date_fin timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone
);
