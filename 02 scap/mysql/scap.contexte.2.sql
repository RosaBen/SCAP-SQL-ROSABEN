-- ---------------------------------------------------------------------
-- Moteur : MySQL (5.7.1)
-- Auteur : Guillaume Mangione <guillaume.mangione@tuta.io>
-- Date de création : 03/2019
-- Date de modification : 02/2020
-- Base de données : scap_db
-- Version : 1.1
--
-- Base de données permettant le suivi des inscriptions aux CMA
-- (Cours Municipaux pour Adultes), de la Mairie de Paris.
-- Gestion des auditeurs et leurs inscriptions aux cours.
-- Une évolution a été demandée,
-- il faut pouvoir conserver les données existantes dans cette modification de structure.
--
-- IMPORTANT :
-- Il faut avoir exécuté auparavant le script de création de bdd : scap_db.1.sql
-- ---------------------------------------------------------------------


USE scap_db;


-- Au cas où la table existerait déjà.
DROP TABLE IF EXISTS Telephones;

-- 2.6 Évolution de la structure de base de données.
CREATE TABLE Telephones
(
    idTelephone             INTEGER         NOT NULL PRIMARY KEY AUTO_INCREMENT,
    numero                  VARCHAR(20)     NOT NULL UNIQUE,
    principal               BOOLEAN         NULL,
    idTelephoneAuditeur     INTEGER         NOT NULL,
    CONSTRAINT fk_telephone_auditeur FOREIGN KEY (idTelephoneAuditeur) REFERENCES Auditeurs (idAuditeur)
);

-- 2.7 Rapatriement des numéros de téléphones dans la Table dédiée.
INSERT INTO Telephones (numero, idTelephoneAuditeur)
    SELECT telephone, idAuditeur
    FROM Auditeurs;

-- Suppression de l'ancienne colonne numéros de téléphones d'Auditeurs.
ALTER TABLE Auditeurs
DROP telephone;

-- Affichage de la nouvelle structure concernée par l'évolution.
DESC Auditeurs;
DESC Telephones;

-- Affichage des données.
SELECT * FROM Auditeurs a
LEFT JOIN Telephones t ON t.idTelephoneAuditeur = a.idAuditeur;

