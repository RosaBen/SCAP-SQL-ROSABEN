-- ---------------------------------------------------------------------
-- Moteur : MySQL
-- Auteur : Guillaume Mangione
-- Date de création : 09/2018
-- Date de modification : 03/2019
-- Base de données : agricole_db
--
-- Permet de gérer la comptabilité des surfaces agricoles des cultivateurs d'un canton.
--
-- Questions :
-- Avez-vous des suggestions d'amélioration de la structure présentée ?
-- Respecte-t-elle les formes normales ? Si oui, lesquelles ?
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- Réinitialisation (ou création) de la base de données et des schémas.

DROP DATABASE IF EXISTS agricole_db;
CREATE DATABASE IF NOT EXISTS agricole_db
    DEFAULT CHARACTER SET utf8
    DEFAULT COLLATE utf8_general_ci;

USE agricole_db;



-- ---------------------------------------------------------------------
-- Suppression des tables si existantes.

DROP TABLE IF EXISTS exploitation,
                     comptable,
                     agence,
                     commune;

-- Définition du moteur de stockage pour MySQL : InnoDB.
-- Configuration valable pour MySQL 5.7 ou supérieur.
SET @storage_engine = 'InnoDB';


-- ---------------------------------------------------------------------
-- Création de la structure des tables.
CREATE TABLE commune
(
    id_commune               INTEGER         NOT NULL PRIMARY KEY,
    nom_commune              VARCHAR(250)    NOT NULL,
    code_postal              CHAR(5)         NOT NULL
);


CREATE TABLE agence
(
    id_agence                INTEGER        NOT NULL PRIMARY KEY,
    nom_agence               VARCHAR(250)   NOT NULL,
    directeur                VARCHAR(50)    NOT NULL,
    id_commune_agence        INTEGER        NOT NULL,
    CONSTRAINT fk_commune_agence FOREIGN KEY (id_commune_agence) REFERENCES commune (id_commune)
);

CREATE TABLE comptable
(
    id_comptable             INTEGER        NOT NULL PRIMARY KEY,
    nom_comptable            VARCHAR(50)    NOT NULL,
    prenom_comptable         VARCHAR(50)    NOT NULL,
    date_arrivee             DATE           NOT NULL,
    poste_telephonique       VARCHAR(20)    NOT NULL,
    id_agence_comptable      INTEGER        NOT NULL,
    CONSTRAINT fk_agence_comptable FOREIGN KEY (id_agence_comptable) REFERENCES agence (id_agence)
);

CREATE TABLE exploitation
(
    id_exploitation                INTEGER        NOT NULL PRIMARY KEY,
    nom_exploitation               VARCHAR(250)   NOT NULL,
    nom_responsable                VARCHAR(50)    NOT NULL,
    numero_telephone               VARCHAR(20)    NOT NULL,
    SAU                            FLOAT          NOT NULL,
    id_commune_exploitation        INTEGER        NOT NULL,
    id_comptable_exploitation      INTEGER        NOT NULL,
    CONSTRAINT fk_commune_exploitation FOREIGN KEY (id_commune_exploitation) REFERENCES commune (id_commune),
    CONSTRAINT fk_comptable_exploitation FOREIGN KEY (id_comptable_exploitation) REFERENCES comptable (id_comptable)
);

-- La base de données est vide.
-- Vous pouvez commencer à ajouter des données avec des commandes INSERT.