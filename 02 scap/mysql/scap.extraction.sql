-- ---------------------------------------------------------------------
-- Moteur : MySQL (5.7.1)
-- Auteur : Guillaume Mangione <guillaume.mangione@gmail.com>
-- Base de données : cma_db_1.0
-- Date de création : 03/2019
-- Date de modification :
--   05/2021 - Notes utiles + prise en compte de la casse.
--   01/2022 - Refonte du sujet avec correctif modèles et questions
--
-- Permet d'extraire des données de la base au format CSV.
-- Ce script est à utiliser en ligne de commande (depuis un shell).
-- Depuis phpMyAdmin, des fonctionnalités permettent déjà d'extraire des données en CSV.
-- Notes :
-- * Le chemin d'export devra être modifié selon votre OS.
-- * Avec Linux, les objets SQL peuvent être sensibles à la casse (majuscules différents des minuscules).
-- * Avec Linux, le dossier cible doit disposer des droits en écriture (sudo chmod o+w /home/guillaume/Documents).
-- ---------------------------------------------------------------------
use cma_db;

-- Extraction des domaines.
SELECT idDomaine
     , domaine
     , idDomaineParent
FROM
  Domaines
  -- INTO OUTFILE 'C:\\Users\\Toto\\Documents\\sql\\pratique\\02 scap\\scap.domaines.csv' -- Windows
  INTO OUTFILE '/home/toto/Documents/sql/pratique/02 scap/common/scap.data.domaines.csv' -- Mac OS / Linux
  CHARACTER SET utf8
  FIELDS
    ENCLOSED BY ''
    TERMINATED BY ';'
    ESCAPED BY ''
  LINES
    TERMINATED BY '\n';

-- Extraction des lieux de formations.
SELECT idLieuFormation
     , intitule
     , adresse
     , cp
     , ville
FROM
  LieuxFormations
  -- INTO OUTFILE 'C:\\Users\\Toto\\Documents\\sql\\pratique\\02 scap\\scap.lieux.csv' -- Windows
  INTO OUTFILE '/home/toto/Documents/sql/pratique/02 scap/common/scap.data.lieux.csv' -- Mac OS / Linux
  CHARACTER SET utf8
  FIELDS
    ENCLOSED BY ''
    TERMINATED BY ';'
    ESCAPED BY ''
  LINES
    TERMINATED BY '\n';