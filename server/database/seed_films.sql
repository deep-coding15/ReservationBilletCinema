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

-- Films supplémentaires pour tests
INSERT INTO films (id, titre, synopsis, genre, duree, realisateur, affiche, note_moyenne, date_debut, date_fin)
VALUES
  (4, 'Gladiator 2', 'Lucius doit entrer dans l''arène pour défendre Rome et sa famille.', 'Action', 148, 'Ridley Scott', 'https://image.tmdb.org/t/p/w500/2uAbb3RjG4gOZPb6K2qN2wYgJMh.jpg', 4.2, CURRENT_DATE - 5, CURRENT_DATE + 45),
  (5, 'Wicked', 'L''histoire des sorcières d''Oz avant qu''Elphaba ne devienne la Méchante Sorcière.', 'Comédie musicale', 165, 'Jon M. Chu', 'https://placehold.co/300x450/2d1b4e/eee?text=Wicked', 4.5, CURRENT_DATE - 2, CURRENT_DATE + 60),
  (6, 'Saw XI', 'Un nouveau chapitre du jeu mortel de Jigsaw.', 'Horreur', 118, 'Kevin Greutert', 'https://placehold.co/300x450/1a0a0a/eee?text=Saw+XI', 3.8, CURRENT_DATE, CURRENT_DATE + 21)
ON CONFLICT (id) DO NOTHING;

-- Séances supplémentaires (plus de créneaux pour tester)
INSERT INTO seances (film_id, salle_id, date_heure, langue, type_projection, places_disponibles, prix)
SELECT 2, id, CURRENT_TIMESTAMP + INTERVAL '4 hours', 'VOSTFR', '2D', 120, 48 FROM salles WHERE cinema_id = 1 AND code_salle = 'Salle 1' LIMIT 1;
INSERT INTO seances (film_id, salle_id, date_heure, langue, type_projection, places_disponibles, prix)
SELECT 3, id, CURRENT_TIMESTAMP + INTERVAL '1 day' + INTERVAL '6 hours', 'VF', '2D', 200, 42 FROM salles WHERE cinema_id = 2 AND code_salle = 'Salle A' LIMIT 1;
INSERT INTO seances (film_id, salle_id, date_heure, langue, type_projection, places_disponibles, prix)
SELECT 4, id, CURRENT_TIMESTAMP + INTERVAL '2 days', 'VF', '2D', 120, 50 FROM salles WHERE cinema_id = 1 AND code_salle = 'Salle 1' LIMIT 1;

-- Options supplémentaires (snacks, boissons)
INSERT INTO option_supplementaires (id, nom, prix, categorie)
VALUES
  (1, 'Popcorn moyen', 15, 'snack'),
  (2, 'Popcorn grand', 22, 'snack'),
  (3, 'Boisson 33 cl', 8, 'boisson'),
  (4, 'Boisson 50 cl', 12, 'boisson'),
  (5, 'Combo Popcorn + Boisson', 28, 'combo')
ON CONFLICT (id) DO NOTHING;

-- Codes promo pour tests
INSERT INTO codes_promo (id, code, type, valeur, date_debut, date_fin, actif)
VALUES
  (1, 'BIENVENUE10', 'pourcentage', 10, CURRENT_DATE - 30, CURRENT_DATE + 90, true),
  (2, 'CINE20', 'pourcentage', 20, CURRENT_DATE - 7, CURRENT_DATE + 7, true),
  (3, 'MOI5', 'fixe', 5, CURRENT_DATE, CURRENT_DATE + 60, true)
ON CONFLICT (id) DO NOTHING;

-- FAQ (questions fréquentes)
INSERT INTO faq (id, question, reponse, categorie, ordre)
VALUES
  (1, 'Comment annuler une réservation ?', 'Rendez-vous dans « Mes billets », sélectionnez la réservation et cliquez sur « Annuler ». Les annulations sont possibles jusqu''à 2 h avant la séance.', 'reservation', 1),
  (2, 'Puis-je modifier mes places après achat ?', 'Oui, tant qu''il reste des places et au moins 2 h avant la séance. Allez dans « Mes billets » puis « Modifier la réservation ».', 'reservation', 2),
  (3, 'Quels moyens de paiement sont acceptés ?', 'Carte bancaire, PayPal et paiement mobile (Apple Pay, Google Pay) sont acceptés sur l''application.', 'paiement', 1),
  (4, 'Où trouver mon billet avec QR code ?', 'Après confirmation, votre e-billet apparaît dans « Mes billets ». Présentez le QR code à l''entrée de la salle.', 'billets', 1),
  (5, 'Comment contacter le support ?', 'Via l''onglet FAQ & Aide : formulaire de contact ou numéro indiqué. Nous répondons sous 24 h ouvrées.', 'support', 1)
ON CONFLICT (id) DO NOTHING;

-- Événements (dans un cinéma ou autre lieu)
INSERT INTO evenements (id, titre, description, categorie, lieu_type, cinema_id, lieu_nom, adresse, ville, date_heure, prix, places_disponibles, affiche)
VALUES
  (1, 'Concert Jazz & Blues', 'Soirée jazz avec orchestre live.', 'Concert', 'cinema', 1, NULL, NULL, 'Tétouan', CURRENT_TIMESTAMP + INTERVAL '5 days' + INTERVAL '20 hours', 80, 120, 'https://placehold.co/400x225/2d1b4e/eee?text=Jazz'),
  (2, 'Stand-up Mohamed El Morabiti', 'One-man-show humour.', 'Stand-up', 'autre', NULL, 'Salle Ibn Battouta', 'Avenue Youssef Ben Tachfine', 'Tanger', CURRENT_TIMESTAMP + INTERVAL '7 days' + INTERVAL '21 hours', 120, 200, 'https://placehold.co/400x225/1a2e1a/eee?text=Stand-up'),
  (3, 'Avant-première Dune 2', 'Projection exclusive en VOSTFR.', 'Avant-première', 'cinema', 2, NULL, NULL, 'Tanger', CURRENT_TIMESTAMP + INTERVAL '3 days' + INTERVAL '19 hours', 60, 200, 'https://placehold.co/400x225/1a0a0a/eee?text=Dune+2')
ON CONFLICT (id) DO NOTHING;
