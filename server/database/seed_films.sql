-- Données de démonstration pour Films & séances et réservations (optionnel).
-- Exécuter après schema.sql et les migrations Serverpod.
-- Une seule fois : psql -U postgres -d cinema_reservation -f seed_films.sql

-- Utilisateur par défaut (pour réservations sans auth)
INSERT INTO utilisateurs (id, nom, email, mot_de_passe_hash)
VALUES (1, 'Invité', 'invite@demo.local', 'demo_hash_non_securise')
ON CONFLICT (id) DO NOTHING;

-- Cinémas
INSERT INTO cinemas (id, nom, adresse, ville)
VALUES (1, 'Cinéma Ritz', 'Place du 9 Avril', 'Tétouan'),
       (2, 'Mega Mall Cinéma', 'Bd d''Espagne', 'Tanger')
ON CONFLICT (id) DO NOTHING;

-- Salles
INSERT INTO salles (cinema_id, code_salle, capacite)
VALUES (1, 'Salle 1', 120), (1, 'Salle 2', 80), (2, 'Salle A', 200)
ON CONFLICT (cinema_id, code_salle) DO NOTHING;

-- Films à l'affiche
INSERT INTO films (id, titre, synopsis, genre, duree, realisateur, affiche, date_debut, date_fin)
VALUES
  (1, 'Dune 2', 'Paul Atreides unit ses forces avec les Fremen pour se venger.', 'Science-fiction', 166, 'Denis Villeneuve', 'https://image.tmdb.org/t/p/w500/8b8R8l7BpynSWW5bH4F0KSUJ5w.jpg', CURRENT_DATE - 7, CURRENT_DATE + 30),
  (2, 'Oppenheimer', 'Le physicien Robert Oppenheimer et le projet Manhattan.', 'Drame', 180, 'Christopher Nolan', 'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XLOskHmBzZdAh6yx.jpg', CURRENT_DATE - 14, CURRENT_DATE + 14),
  (3, 'The Batman', 'Batman affronte le Sphinx à Gotham.', 'Action', 176, 'Matt Reeves', 'https://image.tmdb.org/t/p/w500/74xTEgt7R36FpsooM4XEMeX5Hri.jpg', CURRENT_DATE - 3, CURRENT_DATE + 21)
ON CONFLICT (id) DO NOTHING;

-- Mise à jour des affiches si les films existaient déjà sans image
UPDATE films SET affiche = 'https://image.tmdb.org/t/p/w500/8b8R8l7BpynSWW5bH4F0KSUJ5w.jpg' WHERE id = 1 AND (affiche IS NULL OR affiche = '');
UPDATE films SET affiche = 'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XLOskHmBzZdAh6yx.jpg' WHERE id = 2 AND (affiche IS NULL OR affiche = '');
UPDATE films SET affiche = 'https://image.tmdb.org/t/p/w500/74xTEgt7R36FpsooM4XEMeX5Hri.jpg' WHERE id = 3 AND (affiche IS NULL OR affiche = '');

-- Séances à venir (adapter les salle_id si vos salles ont d'autres id)
INSERT INTO seances (film_id, salle_id, date_heure, langue, type_projection, places_disponibles, prix)
SELECT 1, id, CURRENT_TIMESTAMP + INTERVAL '2 hours', 'VF', '2D', 120, 45 FROM salles WHERE cinema_id = 1 AND code_salle = 'Salle 1' LIMIT 1;
INSERT INTO seances (film_id, salle_id, date_heure, langue, type_projection, places_disponibles, prix)
SELECT 1, id, CURRENT_TIMESTAMP + INTERVAL '5 hours', 'VOSTFR', '2D', 80, 50 FROM salles WHERE cinema_id = 1 AND code_salle = 'Salle 2' LIMIT 1;
INSERT INTO seances (film_id, salle_id, date_heure, langue, type_projection, places_disponibles, prix)
SELECT 2, id, CURRENT_TIMESTAMP + INTERVAL '1 day', 'VF', '2D', 120, 45 FROM salles WHERE cinema_id = 1 AND code_salle = 'Salle 1' LIMIT 1;
INSERT INTO seances (film_id, salle_id, date_heure, langue, type_projection, places_disponibles, prix)
SELECT 3, id, CURRENT_TIMESTAMP + INTERVAL '3 hours', 'VF', '2D', 200, 40 FROM salles WHERE cinema_id = 2 AND code_salle = 'Salle A' LIMIT 1;

-- Sièges (plan de salle) : numéros 1 à 80 par salle
INSERT INTO sieges (salle_id, numero, type)
SELECT s.id, n.n::text, 'standard'
FROM salles s
CROSS JOIN generate_series(1, 80) AS n(n)
WHERE NOT EXISTS (SELECT 1 FROM sieges WHERE salle_id = s.id LIMIT 1);
