-- ---------------------------------------------------------------------
-- Moteur : MariaDB
-- Version : 10.4.28
-- Auteur : Guillaume Mangione
-- Date de création : 10/2019
-- Date de mise à jour : 04/2024
-- Base de données : security_db
--
-- Permet de gérer la sécurité des accès aux applications d'une organisation
-- en fonction des profils utilisateurs.
-- On trouve également une gestion d'historique des attributions de droits.
--
-- Ce script s'effectue en 2 phases,
-- construction des tables, puis des règles d'intégrité référentielle.
-- Le résultat de ce script est le même que celui du fichier security_db.sql

-- Ici, les clés primaires sont AUTO_INCREMENT mais les INSERT de données se font en
-- indiquant explicitement les valeurs au niveau des identifiants.
-- * AUTO_INCREMENT:  laisse libre la saisie manuelle de l'identifiant
-- * PRIMARY KEY:     interdit le doublon de valeur, l'AUTO_INCREMENT permet d'assurer cette contrainte.
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- Réinitialisation (ou création) de la base de données et des schémas.

DROP DATABASE IF EXISTS security_db;

CREATE DATABASE IF NOT EXISTS security_db
   DEFAULT CHARACTER SET utf8
   DEFAULT COLLATE utf8_general_ci;


USE security_db;



-- ---------------------------------------------------------------------
-- Suppression des tables si existantes.

DROP TABLE IF EXISTS attribuer,
                     disposer,
                     fonctionnalites,
                     applications,
                     employes,
                     profils;

-- optionnel
-- SHOW WARNINGS;

-- Définition du moteur de stockage pour MySQL : InnoDB.
-- Configuration valable pour MySQL 5.7 ou supérieur.
SET @storage_engine = 'InnoDB';

-- optionnel
-- SELECT CONCAT('storage engine: ', @storage_engine) as INFO;



-- ---------------------------------------------------------------------
-- Création de la structure des tables.

CREATE TABLE applications
(
     id_application          INTEGER           NOT NULL PRIMARY KEY AUTO_INCREMENT
   , code_application        CHAR(3)           NOT NULL UNIQUE
   , nom_application         VARCHAR(50)       NULL
);

CREATE TABLE attribuer
(
     id_attribution          INTEGER           NOT NULL PRIMARY KEY AUTO_INCREMENT
   , id_attributeur_ref      INTEGER           NOT NULL
   , id_profil_ref           INTEGER           NOT NULL
   , id_fonctionnalite_ref   INTEGER           NOT NULL
   , date_action             DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP
   , type_action             VARCHAR(10)       NOT NULL DEFAULT 'appliquer'
   , CONSTRAINT chk_type_action CHECK (type_action IN ('appliquer', 'retirer'))
);

CREATE TABLE disposer
(
    id_disposer              INTEGER           NOT NULL PRIMARY KEY AUTO_INCREMENT
  , id_profil_ref            INTEGER           NOT NULL
  , id_employe_ref           INTEGER           NOT NULL
  , date_disposition         DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP
  , date_confiscation        DATETIME          NULL
);

CREATE TABLE employes
(
     id_employe              INTEGER           NOT NULL PRIMARY KEY AUTO_INCREMENT
   , nom_session             VARCHAR(50)       NOT NULL UNIQUE
   , mot_de_passe            VARCHAR(100)      NOT NULL
   , nom                     VARCHAR(40)       NOT NULL
   , prenom                  VARCHAR(40)       NOT NULL
   , email                   VARCHAR(255)      NOT NULL UNIQUE
   , matricule               CHAR(8)           NOT NULL UNIQUE
   , actif                   BOOLEAN           NOT NULL DEFAULT TRUE
   , verrou                  BOOLEAN           NOT NULL DEFAULT FALSE
);

CREATE TABLE fonctionnalites
(
     id_fonctionnalite       INTEGER           NOT NULL PRIMARY KEY AUTO_INCREMENT
   , code_fonctionnalite     CHAR(5)           NOT NULL UNIQUE
   , fonctionnalite          VARCHAR(50)       NULL
   , id_application_ref      INTEGER           NULL
);

CREATE TABLE profils
(
     id_profil               INTEGER           NOT NULL PRIMARY KEY AUTO_INCREMENT
   , code_profil             CHAR(3)           NOT NULL UNIQUE
   , profil                  VARCHAR(100)      NOT NULL
);


-- Avec ce principe de création de tables sans contraintes de référence (FK) : Importations de données de masse plus libre.


-- ---------------------------------------------------------------------
-- Ajout des contraintes référentielles

ALTER TABLE fonctionnalites
ADD CONSTRAINT fk_fonctionnalite_application FOREIGN KEY (id_application_ref) REFERENCES applications (id_application)
;

ALTER TABLE disposer
ADD CONSTRAINT fk_profil_disposer FOREIGN KEY (id_profil_ref) REFERENCES profils (id_profil),
ADD CONSTRAINT fk_employe_disposer FOREIGN KEY (id_employe_ref) REFERENCES employes (id_employe)
;

ALTER TABLE attribuer
ADD CONSTRAINT fk_attributeur FOREIGN KEY (id_attributeur_ref) REFERENCES employes (id_employe),
ADD CONSTRAINT fk_profil_cible FOREIGN KEY (id_profil_ref) REFERENCES profils (id_profil),
ADD CONSTRAINT fk_fonctionnalite_cible FOREIGN KEY (id_fonctionnalite_ref) REFERENCES fonctionnalites (id_fonctionnalite)
;

ALTER TABLE disposer
ADD CONSTRAINT chk_disposition_puis_confiscation CHECK (date_disposition < date_confiscation)
;

-- ---------------------------------------------------------------------
-- Ajout de quelques données de base.

INSERT INTO applications (id_application, nom_application, code_application)
VALUES (1, 'Appels', 'APP'),
       (2, 'Opérations', 'OPE'),
       (3, 'Régulation Médicale', 'REG'),
       (4, 'Supervision', 'SUP'),
       (5, 'Paramétrage', 'PAR'),
       (6, 'Moyens', 'MOY'),
       (7, 'Hôpitaux', 'HOP')
;


-- info: 2 fautes volontaires (id: 2 et 4).
INSERT INTO fonctionnalites (id_fonctionnalite, code_fonctionnalite, fonctionnalite, id_application_ref)
VALUES ( 1, 'A01', 'Historique d''appels', 1),
       ( 2, 'A02', 'Suivi d''activité en temps r2el', 1), --     <-- Faute volontaire qu'il faudra corriger par un exercice
       ( 3, 'O01', 'Renforts', 2),
       ( 4, 'O02', 'Contrôleur d''événements', 2),
       ( 5, 'O03', 'Acc2s main courante', 2), --                 <-- Faute volontaire qu'il faudra corriger par un exercice
       ( 6, 'O04', 'Suivi des opérations', 2),
       ( 7, 'R01', 'Visualisation d''un bilan', 3),
       ( 8, 'R02', 'Envoi d''un renfort médical', 3),
       ( 9, 'R03', 'Recherche d''un patient', 3),
       (10, 'R04', 'Statistiques', 3),
       (11, 'R05', 'Suivi des AR', 3),
       (12, 'R06', 'Suivi patient', 3),
       (13, 'S01', 'Gestion des utilisateurs', 4),
       (14, 'S02', 'Gestion des profils', 4),
       (15, 'S03', 'Gestion des droits utilisateur', 4),
       (16, 'S04', 'Réactivation d''un utilisateur', 4),
       (17, 'S05', 'Etat des connexions en cours', 4),
       (18, 'S06', 'Cartographie opérationnelle', 4),
       (19, 'P01', 'Gestion des codes motifs d''appels', 5),
       (20, 'P02', 'Gestion des adresses', 5),
       (21, 'P03', 'Gestion des moyens', 5),
       (22, 'P04', 'Gestion des règles opérationnelles', 5),
       (23, 'M01', 'accès moyens niveau 1', 6),
       (24, 'M02', 'accès moyens niveau 2', 6),
       (25, 'M03', 'accès moyens niveau 3', 6),
       (26, 'M04', 'gestion d''un moyen', 6),
       (27, 'M05', 'gestion des disponibilités', 6),
       (28, 'M06', 'gestion des status', 6)
;

INSERT INTO profils (id_profil, code_profil, profil)
VALUES (1, 'ADM', 'Administrateur'),
       (2, 'PAR', 'Paramétreur'),
       (3, 'OPE', 'Opérateur'),
       (4, 'REG', 'Régulateur'),
       (5, 'MED', 'Médecin'),
       (6, 'IDE', 'Infirmier'),
       (7, 'STA', 'Stationnaire'),
       (8, 'CTR', 'Contrôleur')
;

-- le champ 'mot_de_passe est obtenu par le résultat d'une fonction de hachage (SHA1)
-- SELECT SHA1('mon_mot_de_passe'); -- donne le résultat suivant : 18d73442367ccc65a826443db10ff40e2a73454e
INSERT INTO employes (id_employe, nom_session, mot_de_passe, nom, prenom, email, matricule, actif, verrou)
VALUES (1, 'mangioneg', '85d800c576b360a0ac4259c0ce15ac125f17adc8', 'Mangione', 'Guillaume', 'guillaume.mangione@org.com', 'GM78794', TRUE, FALSE),
       (2, 'hillm', '29589141d0019d89d4576e8f4393ca7164ea774b', 'Hill', 'Martin', 'martin.hill@org.com', 'MH95889', TRUE, TRUE),
       (3, 'stibouto', '407dc369781d06691f2300890f267340c9ab5e12', 'Stibout', 'Olivier', 'olivier.stibout@org.com', 'OS97865', TRUE, FALSE),
       (4, 'freiny', 'd82eb6d01ef1905b3f6bb5ebb71d55c13e5dd8b7', 'Frein', 'Yann', 'yann.frein@org.com', 'YF74553', FALSE, TRUE),
       (5, 'cassinyt', '63e885ca488b7659504b5878d017e2a196f4475e', 'Cassiny', 'Tom', 'tom.cassiny@zmail.com', 'TC82463', FALSE, FALSE),
       (6, 'maillarty', '19b6e599441f4bd9aaa684708ed3ef7f95e05586', 'Maillart', 'Yohann', 'y.maillart@mailo.com', 'YM98342' , TRUE, FALSE)
;

INSERT INTO disposer (id_profil_ref, id_employe_ref, date_disposition, date_confiscation)
VALUES (1, 1, '2020-03-11 14:58:07', NULL),
       (8, 2, '2020-03-11 15:48:18', '2020-04-02 08:57:12'),
       (3, 2, '2020-03-12 16:02:58', NULL),
       (5, 3, '2020-03-14 09:34:24', NULL),
       (3, 4, '2020-03-14 09:57:44', NULL),
       (2, 4, '2020-03-16 14:40:12', NULL),
       (8, 2, '2020-04-22 09:17:01', NULL),
       (3, 5, '2020-04-22 10:01:34', '2020-05-03 09:11:01')
;

-- Droits de l'administrateur :
-- Toutes les fonctionnalités sauf M03, M04 et O03 (identifiants 25, 26, 5).
INSERT INTO attribuer (id_attributeur_ref, id_profil_ref, id_fonctionnalite_ref, date_action, type_action)
VALUES  (1, 1,  1, '2020-05-20 08:12:04', 'appliquer'),
        (1, 1,  2, '2020-05-20 08:31:41', 'appliquer'),
        (1, 1,  3, '2020-05-20 08:40:14', 'appliquer'),
        (1, 1,  4, '2020-05-20 08:52:34', 'appliquer'),
        (1, 1,  6, '2020-05-21 08:59:56', 'appliquer'),
        (1, 1,  7, '2020-05-22 09:37:41', 'appliquer'),
        (1, 1,  8, '2020-05-23 09:41:56', 'appliquer'),
        (1, 1,  9, '2020-05-23 09:47:42', 'appliquer'),
        (1, 1, 10, '2020-05-23 09:51:14', 'appliquer'),
        (1, 1, 11, '2020-05-20 09:55:34', 'appliquer'),
        (1, 1, 12, '2020-05-20 10:19:35', 'appliquer'),
        (1, 1, 13, '2020-05-21 10:21:42', 'appliquer'),
        (1, 1, 14, '2020-05-21 10:29:51', 'appliquer'),
        (1, 1, 15, '2020-05-21 10:31:10', 'appliquer'),
        (1, 1, 16, '2020-05-22 10:43:13', 'appliquer'),
        (1, 1, 17, '2020-05-23 10:47:07', 'appliquer'),
        (1, 1, 18, '2020-05-23 10:55:59', 'appliquer'),
        (1, 1, 19, '2020-05-23 11:02:57', 'appliquer'),
        (1, 1, 20, '2020-05-24 11:11:17', 'appliquer'),
        (1, 1, 21, '2020-05-24 11:19:28', 'appliquer'),
        (1, 1, 22, '2020-05-27 11:31:39', 'appliquer'),
        (1, 1, 23, '2020-05-27 11:47:47', 'appliquer'),
        (1, 1, 24, '2020-05-27 11:51:36', 'appliquer'),
        (1, 1, 27, '2020-05-27 11:59:41', 'appliquer'),
        (1, 1, 28, '2020-05-28 12:02:01', 'appliquer')
;

-- ---------------------------------------------------------------------
-- Affichage de la structure des tables.

DESC employes;
DESC profils;
DESC applications;
DESC fonctionnalites;
DESC disposer;
DESC attribuer;



-- ---------------------------------------------------------------------
-- Affichage des données de base.

-- Applications et leurs fonctionnalités.
SELECT fct.id_fonctionnalite, fct.code_fonctionnalite, fct.fonctionnalite, app.nom_application
FROM applications app
INNER JOIN fonctionnalites fct ON fct.id_application_ref = app.id_application;

-- Droits employes.
SELECT e.nom_session, e.matricule, e.actif, e.verrou, p.code_profil, p.profil
FROM disposer d
INNER JOIN employes e ON e.id_employe = d.id_employe_ref
INNER JOIN profils p ON p.id_profil = d.id_profil_ref;

-- Fonctionnalités du profil 'Administrateur'.
SELECT f.fonctionnalite AS 'Fonctionnalités Administrateur', f.code_fonctionnalite,
a.date_action, a.type_action
FROM attribuer a
INNER JOIN profils p ON p.id_profil = a.id_profil_ref
INNER JOIN fonctionnalites f ON f.id_fonctionnalite = a.id_fonctionnalite_ref
ORDER BY a.date_action DESC;



-- ---------------------------------------------------------------------
-- Des vues existent, n'hésitez pas à les exécuter pour en bénéficier, voir les fichiers : 
-- * v_acces_profils.sql
-- * v_drroits_employes.sql
