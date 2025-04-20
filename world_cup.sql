-- Fichier SQL pour la base de données de la Coupe du Monde de football
-- Création des tables pour le schéma normalisé

-- Table des pays
CREATE TABLE pays (
    id_pays SERIAL PRIMARY KEY,
    nom_pays VARCHAR(100) NOT NULL,
    code_pays VARCHAR(3) UNIQUE NOT NULL,
    continent VARCHAR(50) NOT NULL
);

-- Table des stades
CREATE TABLE stade (
    id_stade SERIAL PRIMARY KEY,
    nom_stade VARCHAR(100) NOT NULL,
    ville VARCHAR(100) NOT NULL,
    capacite INTEGER NOT NULL,
    id_pays INTEGER REFERENCES pays(id_pays)
);

-- Table des éditions de la Coupe du Monde
CREATE TABLE edition_coupe_monde (
    id_edition SERIAL PRIMARY KEY,
    annee INTEGER NOT NULL,
    pays_hote INTEGER REFERENCES pays(id_pays),
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    nombre_equipes INTEGER NOT NULL
);

-- Table des équipes
CREATE TABLE equipe (
    id_equipe SERIAL PRIMARY KEY,
    id_pays INTEGER REFERENCES pays(id_pays),
    id_edition INTEGER REFERENCES edition_coupe_monde(id_edition),
    nom_entraineur VARCHAR(100) NOT NULL,
    nombre_joueurs INTEGER NOT NULL
);

-- Table des joueurs
CREATE TABLE joueur (
    id_joueur SERIAL PRIMARY KEY,
    id_equipe INTEGER REFERENCES equipe(id_equipe),
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE NOT NULL,
    numero_maillot INTEGER NOT NULL,
    poste VARCHAR(50) NOT NULL
);

-- Table des arbitres
CREATE TABLE arbitre (
    id_arbitre SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    id_pays INTEGER REFERENCES pays(id_pays),
    type_arbitre VARCHAR(50) NOT NULL -- principal ou assistant
);

-- Table des matchs
CREATE TABLE match (
    id_match SERIAL PRIMARY KEY,
    id_edition INTEGER REFERENCES edition_coupe_monde(id_edition),
    id_stade INTEGER REFERENCES stade(id_stade),
    date_match DATE NOT NULL,
    rang_competition VARCHAR(50) NOT NULL, -- phase de poule, 1/8, 1/4, etc.
    id_arbitre_principal INTEGER REFERENCES arbitre(id_arbitre),
    id_arbitre_assistant1 INTEGER REFERENCES arbitre(id_arbitre),
    id_arbitre_assistant2 INTEGER REFERENCES arbitre(id_arbitre),
    id_arbitre_assistant3 INTEGER REFERENCES arbitre(id_arbitre)
);

-- Table des participations aux matchs
CREATE TABLE participation_match (
    id_match INTEGER REFERENCES match(id_match),
    id_equipe INTEGER REFERENCES equipe(id_equipe),
    score INTEGER NOT NULL,
    PRIMARY KEY (id_match, id_equipe)
);

-- Table des sanctions
CREATE TABLE sanction (
    id_sanction SERIAL PRIMARY KEY,
    id_joueur INTEGER REFERENCES joueur(id_joueur),
    id_match INTEGER REFERENCES match(id_match),
    type_sanction VARCHAR(20) NOT NULL, -- jaune ou rouge
    minute_sanction INTEGER NOT NULL
);

-- Insertion des données d'exemple
-- Insertion des pays
INSERT INTO pays (nom_pays, code_pays, continent) VALUES
('France', 'FRA', 'Europe'),
('Brésil', 'BRA', 'Amérique du Sud'),
('Allemagne', 'GER', 'Europe'),
('Argentine', 'ARG', 'Amérique du Sud'),
('Espagne', 'ESP', 'Europe'),
('Italie', 'ITA', 'Europe'),
('Angleterre', 'ENG', 'Europe'),
('Portugal', 'POR', 'Europe'),
('Pays-Bas', 'NED', 'Europe'),
('Belgique', 'BEL', 'Europe'),
('Maroc', 'MAR', 'Afrique'),
('Sénégal', 'SEN', 'Afrique'),
('Japon', 'JPN', 'Asie'),
('Corée du Sud', 'KOR', 'Asie'),
('États-Unis', 'USA', 'Amérique du Nord');

-- Insertion des stades
INSERT INTO stade (nom_stade, ville, capacite, id_pays) VALUES
('Stade de France', 'Saint-Denis', 80000, 1),
('Maracanã', 'Rio de Janeiro', 78838, 2),
('Allianz Arena', 'Munich', 75000, 3),
('Estadio Monumental', 'Buenos Aires', 70074, 4),
('Camp Nou', 'Barcelone', 99354, 5),
('San Siro', 'Milan', 80018, 6),
('Wembley', 'Londres', 90000, 7),
('Estádio da Luz', 'Lisbonne', 64642, 8),
('Johan Cruyff Arena', 'Amsterdam', 55500, 9),
('Stade Roi Baudouin', 'Bruxelles', 50093, 10);

-- Insertion des éditions de la Coupe du Monde
INSERT INTO edition_coupe_monde (annee, pays_hote, date_debut, date_fin, nombre_equipes) VALUES
(2018, 1, '2018-06-14', '2018-07-15', 32),
(2022, 2, '2022-11-20', '2022-12-18', 32),
(2014, 2, '2014-06-12', '2014-07-13', 32),
(2010, 11, '2010-06-11', '2010-07-11', 32),
(2006, 3, '2006-06-09', '2006-07-09', 32);

-- Insertion des équipes
INSERT INTO equipe (id_pays, id_edition, nom_entraineur, nombre_joueurs) VALUES
(1, 1, 'Didier Deschamps', 23),
(2, 1, 'Tite', 23),
(3, 1, 'Joachim Löw', 23),
(4, 1, 'Jorge Sampaoli', 23),
(5, 1, 'Fernando Hierro', 23),
(1, 2, 'Didier Deschamps', 23),
(2, 2, 'Tite', 23),
(3, 2, 'Hansi Flick', 23),
(4, 2, 'Lionel Scaloni', 23),
(5, 2, 'Luis Enrique', 23);

-- Insertion des joueurs
INSERT INTO joueur (id_equipe, nom, prenom, date_naissance, numero_maillot, poste) VALUES
(1, 'Lloris', 'Hugo', '1986-12-26', 1, 'Gardien'),
(1, 'Pavard', 'Benjamin', '1996-03-28', 2, 'Défenseur'),
(1, 'Kimpembe', 'Presnel', '1995-08-13', 3, 'Défenseur'),
(1, 'Varane', 'Raphaël', '1993-04-25', 4, 'Défenseur'),
(1, 'Umtiti', 'Samuel', '1993-11-14', 5, 'Défenseur'),
(1, 'Pogba', 'Paul', '1993-03-15', 6, 'Milieu'),
(1, 'Griezmann', 'Antoine', '1991-03-21', 7, 'Attaquant'),
(1, 'Lemar', 'Thomas', '1995-11-12', 8, 'Milieu'),
(1, 'Giroud', 'Olivier', '1986-09-30', 9, 'Attaquant'),
(1, 'Mbappé', 'Kylian', '1998-12-20', 10, 'Attaquant');

-- Insertion des arbitres
INSERT INTO arbitre (nom, prenom, id_pays, type_arbitre) VALUES
('Turpin', 'Clément', 1, 'principal'),
('Frappart', 'Stéphanie', 1, 'principal'),
('Oliver', 'Michael', 7, 'principal'),
('Taylor', 'Anthony', 7, 'principal'),
('Marciniak', 'Szymon', 1, 'principal'),
('Dias', 'Artur', 8, 'assistant'),
('Soares', 'Bruno', 8, 'assistant'),
('Nielsen', 'Kim', 9, 'assistant'),
('Hernandez', 'Alejandro', 5, 'assistant'),
('Gonzalez', 'Juan', 5, 'assistant');

-- Insertion des matchs
INSERT INTO match (id_edition, id_stade, date_match, rang_competition, id_arbitre_principal, id_arbitre_assistant1, id_arbitre_assistant2, id_arbitre_assistant3) VALUES
(1, 1, '2018-06-16', 'Phase de poule', 1, 6, 7, 8),
(1, 2, '2018-06-17', 'Phase de poule', 2, 6, 7, 9),
(1, 3, '2018-06-18', 'Phase de poule', 3, 8, 9, 10),
(1, 4, '2018-06-19', 'Phase de poule', 4, 7, 8, 10),
(1, 5, '2018-06-20', 'Phase de poule', 5, 6, 9, 10);

-- Insertion des participations aux matchs
INSERT INTO participation_match (id_match, id_equipe, score) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 0),
(2, 4, 1),
(3, 5, 3),
(3, 1, 1);

-- Insertion des sanctions
INSERT INTO sanction (id_joueur, id_match, type_sanction, minute_sanction) VALUES
(1, 1, 'jaune', 45),
(2, 1, 'rouge', 78),
(3, 2, 'jaune', 23),
(4, 2, 'jaune', 67),
(5, 3, 'rouge', 89);

-- Requêtes d'exemple pour répondre aux questions

-- Question 1: Quels sont les joueurs qui ont reçu le plus de cartons rouges ?
SELECT j.nom, j.prenom, COUNT(*) as nombre_cartons_rouges
FROM joueur j
JOIN sanction s ON j.id_joueur = s.id_joueur
WHERE s.type_sanction = 'rouge'
GROUP BY j.id_joueur, j.nom, j.prenom
ORDER BY nombre_cartons_rouges DESC;

-- Question 2: Quels sont les pays qui ont organisé le plus de Coupes du Monde ?
SELECT p.nom_pays, COUNT(*) as nombre_organisations
FROM pays p
JOIN edition_coupe_monde e ON p.id_pays = e.pays_hote
GROUP BY p.id_pays, p.nom_pays
ORDER BY nombre_organisations DESC;

-- Question 3: Quels sont les stades qui ont accueilli le plus de matchs ?
SELECT s.nom_stade, COUNT(*) as nombre_matchs
FROM stade s
JOIN match m ON s.id_stade = m.id_stade
GROUP BY s.id_stade, s.nom_stade
ORDER BY nombre_matchs DESC;

-- Question 4: Quels sont les arbitres qui ont officié le plus de matchs ?
SELECT a.nom, a.prenom, 
       (SELECT COUNT(*) FROM match WHERE id_arbitre_principal = a.id_arbitre) +
       (SELECT COUNT(*) FROM match WHERE id_arbitre_assistant1 = a.id_arbitre) +
       (SELECT COUNT(*) FROM match WHERE id_arbitre_assistant2 = a.id_arbitre) +
       (SELECT COUNT(*) FROM match WHERE id_arbitre_assistant3 = a.id_arbitre) as nombre_matchs
FROM arbitre a
ORDER BY nombre_matchs DESC; 