-- ---------------------------------------------------------------------
-- Moteur : Postgresql (14.2)
-- Auteur : Guillaume Mangione <guillaume.mangione@tuta.io>
-- Date de création : 01/2022
-- Base de données : scap_db
-- Version : 1.0
--
-- Base de données permettant le suivi des inscriptions aux SCAP
-- (Cours pour Adultes de Paris), de la Mairie de Paris.
-- Gestion des auditeurs et leurs inscriptions aux cours.
--
-- Utile:
-- Ici, ce script est utilisé via un conteneur Docker.
-- Vous pourrez installer une instance PostgreSQL sur votre ordinateur, selon votre OS.
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
-- IMPORTANT : Création de base de données
-- Sur Postgres, la création d'une base de données implique une création physique sur le disque dur (hardware).
-- Cela occasionne une impossibilité de créer un script intégral (database + tables).
-- Vous devrez donc créer une base de données avant d'exécuter ce script.
-- ---------------------------------------------------------------------



DROP TABLE IF EXISTS
    Auditeurs
  , LieuxFormations
  , Formateurs
  , Domaines
  , Gestionnaires
  , Cours
  , Inscriptions
  , Suivre
  ;

CREATE TABLE Auditeurs
(
    idAuditeur       SERIAL UNIQUE,
    numeroCarte      INTEGER NOT NULL UNIQUE,
    nom              VARCHAR(30) NOT NULL,
    prenom           VARCHAR(30) NOT NULL,
    adresseMail      VARCHAR(255) NOT NULL UNIQUE,
    dateNaissance    TIMESTAMP NULL,
    lieuNaissance	 TIMESTAMP NULL,
    telephone        VARCHAR(20) NULL,
    cp               CHAR(5) NULL,
    ville            VARCHAR(120) NULL
);

CREATE TABLE LieuxFormations
(
    idLieuFormation SERIAL UNIQUE,
    intitule        VARCHAR(50) NOT NULL UNIQUE,
    adresse         VARCHAR(150) NOT NULL,
    cp              CHAR(5) NOT NULL,
    ville           VARCHAR(120) NOT NULL,
    pmr             BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE Formateurs
(
    idFormateur      SERIAL UNIQUE,
    matricule        INTEGER NOT NULL UNIQUE,
    estEnseignant    BOOLEAN NOT NULL DEFAULT FALSE,
    nom              VARCHAR(30) NOT NULL,
    prenom           VARCHAR(30) NOT NULL,
    adresseMail      VARCHAR(255) NOT NULL UNIQUE,
    telephone        VARCHAR(20) NULL,
    adresse          VARCHAR(150) NOT NULL,
    cp               CHAR(5) NOT NULL,
    ville            VARCHAR(120) NOT NULL,
    responsable      INTEGER NULL
);

CREATE TABLE Domaines
(
    idDomaine        SERIAL UNIQUE,
    domaine          VARCHAR(250) NOT NULL,
    idDomaineParent  INTEGER NULL
);

ALTER TABLE Domaines
    ADD CONSTRAINT fk_domaine_parent FOREIGN KEY (idDomaineParent) REFERENCES Domaines (idDomaine);

CREATE TABLE Gestionnaires
(
    idGestionnaire	      SERIAL,
    nom                   VARCHAR(30) NOT NULL,
    prenom                VARCHAR(30) NOT NULL,
    adresseMail           VARCHAR(255) NOT NULL UNIQUE,
    telephone             VARCHAR(20) NULL,
    idDomaineResponsable  INTEGER NOT NULL,
    CONSTRAINT fk_domaine_responsable FOREIGN KEY (idDomaineResponsable) REFERENCES Domaines (idDomaine)
);

CREATE TABLE Cours
(
    idCours               SERIAL UNIQUE,
    enonce                VARCHAR(250) NOT NULL UNIQUE,
    duree                 SMALLINT NOT NULL,
    nbSessions            SMALLINT NOT NULL,
    tarif                 FLOAT NOT NULL,
    description           TEXT NULL,
    idLieuFormationCours  INTEGER NOT NULL,
    idFormateurCours      INTEGER NOT NULL,
    idDomaineCours        INTEGER NOT NULL,
    CONSTRAINT fk_lieu_formation_cours FOREIGN KEY (idLieuFormationCours) REFERENCES LieuxFormations (idLieuFormation),
    CONSTRAINT fk_formateur_cours FOREIGN KEY (idFormateurCours) REFERENCES Formateurs (idFormateur),
    CONSTRAINT fk_domaine_cours FOREIGN KEY (idDomaineCours) REFERENCES Domaines (idDomaine)
);

CREATE TABLE Inscriptions
(
    idAuditeurInscription  INTEGER NOT NULL,
    idCoursInscription     INTEGER NOT NULL,
    datePreInscription     TIMESTAMP NULL,
    dateInscription        TIMESTAMP NULL,
    motivation             TEXT NOT NULL,
    reglement              BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_auditeur_inscription FOREIGN KEY (idAuditeurInscription) REFERENCES Auditeurs (idAuditeur),
    CONSTRAINT fk_cours_inscription FOREIGN KEY (idCoursInscription) REFERENCES Cours (idCours),
    CONSTRAINT pk_inscription PRIMARY KEY (idAuditeurInscription, idCoursInscription)
);

CREATE TABLE Suivre
(
    idSuivre              SERIAL UNIQUE,
    idAuditeurSuivre      INTEGER NOT NULL,
    idCoursSuivre         INTEGER NOT NULL,
    etat                  CHAR(1) NOT NULL DEFAULT 'P'
);


-- ---------------------------------------------------------------------
-- Insertion de données.

INSERT INTO Domaines (idDomaine, domaine, idDomaineParent)
VALUES
    (  1, 'Accompagnement professionnel', NULL),
    (  2, 'Communication', 1),
    (  3, 'Compétences techniques', 1),
    (  4, 'Emploi', 1),
    (  5, 'Mieux être', 1),
    (  6, 'Organisation', 1),
    (  7, 'Artisanat et métiers d''art', NULL),
    (  8, 'Métiers de la mode et du textile', 7),
    (  9, 'Broderie', 8),
    ( 10, 'Chapellerie, modiste', 8),
    ( 11, 'Couture / Modélisme',	8),
    ( 12, 'Formations en journée', 11),
    ( 13, 'Compétences clefs métier', 12),
    ( 14, 'Retouches de vêtements', 12),
    ( 15, 'Vêtements d''enfant', 12),
    ( 16, 'Vêtements féminins', 12),
    ( 17, 'Initiation', 16),
    ( 18, 'Perfectionnement', 16),
    ( 19, 'Vêtements masculins', 12),
    ( 20, 'Formations en soirée', 11),
    ( 21, 'Formations spécifiques', 20),
    ( 22, 'Logiciel professionnel', 20),
    ( 23, 'Vêtements féminins (coupe-à-plat)', 20),
    ( 24, 'Vêtements féminins (moulage)', 20),
    ( 25, 'Vêtements masculins', 20),
    ( 26, 'Design textile', 8),
    ( 27, 'Logiciels spécifiques', 26),
    ( 28, 'Préparations aux diplômes', 27),
    ( 29, 'Sessions complémentaires', 27),
    ( 30, 'Stylisme de mode', 27),
    ( 31, 'Métiers de la Restauration', 7),
    ( 32, 'Préparation aux diplômes', 31),
    ( 33, 'Métiers de la Tapisserie', 7),
    ( 34, 'Métiers du Bijou', 7),
    ( 35, 'Métiers du Bois', 7),
    ( 36, 'Métiers du Cuir', 7),
    ( 37, 'Métiers du Verre', 7),
    ( 38, 'Arts appliqués, architecture et communication', NULL),
    ( 39, 'Fondamentaux : techniques de représentation', 38),
    ( 40, 'Architecture, aménagement et décoration d''espaces', 38),
    ( 41, 'Aménagement et décoration d''espace', 40),
    ( 42, 'Logiciels d''architecture et de dessin', 40),
    ( 43, 'Métiers de la communication visuelle et du multimédia', 38),
    ( 44, 'Communication numérique', 43),
    ( 45, 'Formations en journée', 44),
    ( 46, 'Formations en soirée', 44),
    ( 47, 'Animation et vidéo', 46),
    ( 48, 'Communication WEB', 46),
    ( 49, 'PAO', 46),
    ( 50, 'La chaîne graphique', 49),
    ( 51, 'Logiciels de traitement numérique', 49),
    ( 52, 'Communication visuelle - création - graphisme et typographie', 43),
    ( 53, 'Formations complémentaires', 43),
    ( 54, 'Gravure', 43),
    ( 55, 'Illustration', 43),
    ( 56, 'Photographie', 43),
    ( 57, 'Rough et story board', 43),
    ( 58, 'Sérigraphie', 43),
    ( 59, 'Préparation aux diplômes et aux concours d''entrée', 38),
    ( 60, 'Enseignement général', NULL),
    ( 61, 'Préparation aux diplômes', 60),
    ( 62, 'Préparation au Baccalauréat', 61),
    ( 63, 'Préparation au baccalauréat général', 61),
    ( 64, 'Préparation au Diplôme National du Brevet (DNB)', 60),
    ( 65, 'Entreprise', NULL),
    ( 66, 'Comptabilité - Gestion', 65),
    ( 67, 'Comptabilité et fiscalité', 66),
    ( 68, 'Gestion de projets', 66),
    ( 69, 'Gestion en ressources humaines', 66),
    ( 70, 'Gestion financière et contrôle de gestion', 66),
    ( 71, 'Logiciels spécifiques', 66),
    ( 72, 'Préparation aux diplômes', 66),
    ( 73, 'BAC Pro', 72),
    ( 74, 'BTS', 72),
    ( 75, 'Assistant manager', 74),
    ( 76, 'Comptabilité et gestion', 74),
    ( 77, 'Management des unités commerciales', 74),
    ( 78, 'Diplôme de Comptabilité et de Gestion (DCG)', 72),
    ( 79, 'Création d''entreprises ou d''associations', 65),
    ( 80, 'Définir son projet de création d''entreprise', 79),
    ( 81, 'Accompagnement', 79),
    ( 82, 'Associatif et non lucratif', 79),
    ( 83, 'Communication et marketing', 79),
    ( 84, 'Droit ou règlementation', 79),
    ( 85, 'Finance et stratégie', 79),
    ( 86, 'Parcours complet de création d''entreprise', 79),
    ( 87, 'Spécialisations métiers ou secteurs', 79),
    ( 88, 'Environnement', NULL),
    ( 89, 'Cours annuels', 88),
    ( 90, 'Cours semestriels', 88),
    ( 91, 'Préparations aux diplômes', 88),
    ( 92, 'Français', NULL),
    ( 93, 'Formations avec pédagogies adaptées aux personnes en situation de handicap', 88),
    ( 94, 'Français pour francophones', 88),
    ( 95, 'Français pour francophones faiblement scolarisés DANS LEUR PAYS D''ORIGINE', 4),
    ( 96, 'FOF 120 heures', 95),
    ( 97, 'FOF 180 heures', 95),
    ( 98, 'FOF avec approche du support informatique [FOF SI] 180h', 95),
    ( 99, 'FOF et informatique', 95),
    (100, 'FOF écrit et FOF vocabulaire', 95),
    (101, 'Français pour francophones faiblement scolarisés EN FRANCE', 94),
    (102, 'Français pour non francophones', 88),
    (103, 'Français pour non francophones faiblement scolarisés', 102),
    (104, 'FOA Alpha, public non francophone ne maîtrisant aucun système d''écriture', 103),
    (105, 'FOA, public non francophone maîtrisant une langue à alphabet latin [FOA L]', 103),
    (106, 'FOA, public non francophone ne maîtrisant aucune langue à alphabet latin [FOA NL]',  103),
    (107, 'FOA, Niveau 3', 103),
    (108, 'FOA, renforcement de l''écrit', 103),
    (109, 'FOA, renforcement phonétique du français', 103),
    (110, 'Préparation à diplôme', 103),
    (111, 'Français pour non francophones scolarisés, Français Langue Etrangère [FLE]', 102),
    (112, 'FLE Présentiel + Distanciel', 111),
    (113, 'FLE Ecrit', 111),
    (114, 'FLE Oral', 111),
    (115, 'FLE Oral et Ecrit', 111),
    (116, 'Cours du soir', 115),
    (117, '2 fois par semaine : 60h', 116),
    (118, '3 fois par semaine : 90h', 116),
    (119, '4 fois par semaine : 120h', 116),
    (120, 'Cours en journée', 115),
    (121, '2 fois par semaine : 60h', 120),
    (122, '4 fois par semaine : 120h', 120),
    (123, 'FLE à visée spécifique', 111),
    (124, 'Préparation à diplômes', 111),
    (125, 'Informatique et Métiers du Web', NULL),
    (126, 'Bureautique et internet', 125),
    (127, 'Les fondamentaux', 126),
    (128, 'Bureautique : informatique personnelle et professionnelle', 126),
    (129, 'Excel', 128),
    (130, 'Sessions intensives en journée', 129),
    (131, '30 heures sur 10 semaines', 129),
    (132, 'Word', 128),
    (133, 'Sessions intensives en journée', 132),
    (134, '30 heures sur 10 semaines', 132),
    (135, 'Les autres logiciels de la suite Office', 128),
    (136, 'Sessions intensives en journée', 135),
    (137, '30 heures sur 10 semaines', 135),
    (138, '45 heures sur 15 semaines', 135),
    (139, 'Communication digitale : les réseaux sociaux et webmarketing', 126),
    (140, 'Création de sites internet et programmation Web', 126),
    (141, 'Créations de site internet', 140),
    (142, 'Programmation Web', 140),
    (143, 'Préparation à diplôme', 126),
    (144, 'Métiers de l''informatique', 125),
    (145, 'Programmation', 144),
    (146, 'Réseaux locaux', 144),
    (147, 'Système et réseaux sur Mac ou PC', 144),
    (148, 'Langues étrangères', NULL),
    (149, 'Allemand', 148),
    (150, 'Cours à visée générale', 149),
    (151, 'Cours annuels (1 fois 2 heures par semaine)', 150),
    (152, 'Cours semestriels', 150),
    (153, '1 fois 2 heures par semaine', 152),
    (154, '2 fois 2 heures par semaine', 152),
    (155, 'Cours à visée spécifique', 149),
    (156, 'Préparation à diplômes', 149),
    (157, 'Anglais', 148),
    (158, 'Cours présentiel + distanciel', 157),
    (159, 'Cours à visée générale', 157),
    (160, 'Cours annuels (1 fois 2 heures par semaine)', 159),
    (161, 'Cours semestriels (2 fois 2 heures par semaine)', 159),
    (162, 'Sessions étalées sur 2 à 10 semaines', 159),
    (163, '30 heures', 162),
    (164, '60 heures', 162),
    (165, 'Cours à visée professionnelle', 157),
    (166, 'Cours à visée spécifique', 157),
    (167, 'Préparation à diplômes', 157),
    (168, 'Arabe', 148),
    (169, 'Cours à visée générale', 168),
    (170, 'Cours annuels (1 fois 2 heures par semaine)', 169),
    (171, 'Cours semestriels (2 fois 2 heures par semaine)', 169),
    (172, 'Cours à visée spécifique', 168),
    (173, 'Préparation à diplômes', 168),
    (174, 'Espagnol', 148),
    (175, 'Cours présentiel + distanciel', 174),
    (176, 'Cours à visée générale', 174),
    (177, 'Cours annuels (1 fois 2 heures par semaine)', 176),
    (178, 'Cours semestriels', 176),
    (179, '1 fois 2 heures par semaine', 178),
    (180, '2 fois 2 heures par semaine', 178),
    (181, 'Sessions 30 heures étalées sur 2 semaines', 176),
    (182, 'Cours à visée spécifique', 174),
    (183, 'Préparation à diplômes', 174),
    (184, 'Italien', 148),
    (185, 'Cours à visée générale', 184),
    (186, 'Cours annuels (1 fois 2 heures par semaine)', 185),
    (187, 'Cours semestriels (2 fois 2 heures par semaine)', 185),
    (188, 'Cours à visée professionnelle', 184),
    (189, 'Cours à visée spécifique', 184),
    (190, 'Langues d''Asie', 148),
    (191, 'Chinois', 190),
    (192, 'Cours à visée générale', 191),
    (193, 'Cours annuels (1 fois 2 heures par semaine)', 192),
    (194, 'Cours semestriels (2 fois 2 heures par semaine)', 192),
    (195, 'Cours à visée professionnelle', 191),
    (196, 'Cours à visée spécifique', 191),
    (197, 'Coréen', 190),
    (198, 'Japonais', 190),
    (199, 'Cours à visée générale', 198),
    (200, 'Cours annuels (1 fois 2 heures par semaine)', 199),
    (201, 'Cours semestriels orientés communication orale', 199),
    (202, '1 fois 2 heures par semaine', 201),
    (203, '2 fois 2 heures par semaine', 201),
    (204, 'Cours à visée professionnelle', 198),
    (205, 'Vietnamien', 190),
    (206, 'Portugais', 148),
    (207, 'Cours à visée générale', 206),
    (208, 'Cours annuels (1 fois 2 heures par semaine)', 207),
    (209, 'Cours semestriels (1 fois 2 heures par semaine)', 207),
    (210, 'Cours semestriels (2 fois 2 heures par semaine)', 207),
    (211, 'Cours à visée spécifique', 206),
    (212, 'Préparation à diplômes', 206),
    (213, 'Russe', 148),
    (214, 'Cours à visée générale', 213),
    (215, 'Cours annuels (1 fois 2 heures par semaine)', 214),
    (216, 'Cours semestriels (2 fois 2 heures par semaine)', 214),
    (217, 'Cours à visée spécifique', 213),
    (218, 'Métiers de l''administration', NULL),
    (219, 'Préparation aux concours administratifs', 218),
    (220, 'Sanitaire et social', NULL),
    (221, 'Techniques industrielles', NULL),
    (222, 'Domotique', 221),
    (223, 'Formation sur véhicules anciens et de collections', 221),
    (224, 'Mentions complémentaires', 221),
    (225, 'Préparation au BAC Pro', 221),
    (226, 'Energies', 225),
    (227, 'BAC Pro Maintenance des Equipements Industriels (MEI)', 226),
    (228, 'BAC Pro Métiers de l''ELectricité et des Environnements Connectés (MELEC)', 226),
    (229, 'Matières générales des préparations aux BAC Pro', 225),
    (230, 'Mécanique', 225),
    (231, 'Préparation au CAP', 221),
    (232, 'Chaudronnerie', 231),
    (233, 'Energies', 231),
    (234, 'Matières générales des préparation aux CAP', 231),
    (235, 'Mécanique', 231);

INSERT INTO LieuxFormations (idLieuFormation, intitule, adresse, cp, ville)
VALUES
    ( 1, 'Neuve St Pierre (4e)', '15 rue Neuve Saint-Pierre', 75004, 'Paris'),
    ( 2, 'Servan (11e)', '29 rue Servan', 75011, 'Paris'),
    ( 3, 'François Truffaut (3e)', '28 rue Debelleyme', 75003, 'Paris'),
    ( 4, 'Alesia (14e)', '188 rue d''Alesia', 75014, 'Paris'),
    ( 5, 'Victoire (9e)', '16 rue de la Victoire', 75009, 'Paris'),
    ( 6, 'Belleville (11e)', '77 boulevard de Belleville', 75011, 'Paris'),
    ( 7, 'Faubourg St Denis (10e)', '34 rue du Faubourg Saint-Denis', 75010, 'Paris'),
    ( 8, 'Moussy (4e)', '9 rue de Moussy', 75004, 'Paris'),
    ( 9, 'Arbalète (14e)', '41 rue de l''Arbalète', 75014, 'Paris'),
    (10, 'Daumesnil (12e)', '253T avenue Daumesnil', 75012, 'Paris'),
    (11, 'Motte Picquet (7e)', '10 avenue de la Motte Picquet', 75007, 'Paris'),
    (12, 'Quatre Fils (3e)', '10B rue des Quatre Fils', 75003, 'Paris'),
    (13, 'Keller (11e)', '4 rue Keller', 75011, 'Paris'),
    (14, 'Château des Rentiers 177*', '177 rue du Château des Rentiers', 75013, 'Paris'),
    (15, 'Jeanne d''Arc (13e)', '30 place Jeanne d''Arc', 75013, 'Paris'),
    (16, 'Fagon (13e)', '13 rue Fagon', 75013, 'Paris'),
    (17, 'Arbre Sec (1er)', '15 rue de l''Arbre Sec', 75001, 'Paris'),
    (18, 'St Maur (10e)', '200 rue Saint Maur', 75010, 'Paris'),
    (19, 'Armand Carrel', '45 rue Armand Carrel', 75019, 'Paris'),
    (20, 'Bruxelles (9e)', '32 rue de Bruxelles', 75009, 'Paris'),
    (21, 'Bouvines (11e)', '4 avenue de Bouvines', 75011, 'Paris'),
    (22, 'Baudelaire (12e)', '8 rue Charles Baudelaire', 75012, 'Paris'),
    (23, 'Bignon (12e)', '4 rue Bignon', 75012, 'Paris'),
    (24, 'Littré (6e)', '6 rue Littré', 75006, 'Paris'),
    (25, 'Brossolette (5e)', '2 rue Pierre Brossolette', 75005, 'Paris'),
    (26, 'Florence (8e)', '4 rue de Florence', 75008, 'Paris'),
    (27, 'Plaine (20e)', '11 rue de la Plaine', 75020, 'Paris'),
    (28, 'Etienne Marcel (2e)', '20 rue Etienne Marcel', 75002, 'Paris');

INSERT INTO Formateurs (idFormateur, matricule, nom, prenom, estEnseignant, adresseMail, telephone, adresse, cp, ville)
VALUES
    (1, 12345, 'Mangione', 'Guillaume', false, 'guillaume.mangione@gmail.com', '0631311405', 'rue de Plaisance', 94130, 'Nogent-sur-Marne');

INSERT INTO Cours (idCours, enonce, description, duree, nbSessions, tarif, idLieuFormationCours, idFormateurCours, idDomaineCours)
VALUES
    (1, 'Concevoir et manipuler des bases de données', 'Toute personne qui souhaite apprendre à concevoir une base de données et/ou connaître les grands principes du SQL.', 45, 15, 228.0, 21, 1, 142),
    (2, 'Programmer en PHP : s''initier', '', 45, 15, 228, 21, 1, 142),
    (3, 'Approfondir le SQL', 'Pour étendre vos connaissances en SQL de ce que vous avez pu voir dans le cours ''Concevoir et manipuler des bases de données''', 30, 10, 186.0, 21, 1, 142);

INSERT INTO Auditeurs (idAuditeur, numeroCarte, nom, prenom, adresseMail, telephone)
VALUES
    (1, 123456, '?', 'Toto', 'toto@mail.com', '06.05.04.03.02'),
    (2, 234567, 'Arthod', 'Martin', 'm.arthod@outlook.com', '06.07.10.55.48');

select * from LIeuxFormations;



-- ---------------------------------------------------------------------
-- Affichage de la description des tables principales.
SELECT table_name
     , column_name
    , data_type
FROM information_schema.columns
WHERE table_name IN ('Auditeurs', 'Cours', 'LieuxFormations', 'Formateurs', 'Domaines');
