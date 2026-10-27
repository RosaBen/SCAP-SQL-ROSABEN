-- ---------------------------------------------------------------------
-- Moteur : SQL Server 2019
-- Auteur : Guillaume Mangione <guillaume.mangione@tuta.io>
-- Date de création : 04/2021
-- Date de modification : 05/2021
-- Base de données : scap_db
-- Version : 2
--
-- Base de données permettant le suivi des inscriptions aux CMA
-- (Cours Municipaux pour Adultes), de la Mairie de Paris.
-- Gestion des auditeurs et leurs inscriptions aux cours.
-- Une évolution a été demandée,
-- il faut pouvoir conserver les données existantes dans cette modification de structure.
--
-- IMPORTANT :
-- Il faut avoir exécuté auparavant le script de création de bdd : scap_db.2.sql
-- ---------------------------------------------------------------------


USE [scap_db];


-- ---------------------------------------------------------------------
-- Suppression des tables si existantes.

IF OBJECT_ID('dbo.Telephones', 'U') IS NOT NULL
    DROP TABLE dbo.Telephones;
GO



-- 2.6 Évolution de la structure de base de données.
CREATE TABLE Telephones
(
    idTelephone             INTEGER         NOT NULL IDENTITY PRIMARY KEY,
    numero                  VARCHAR(20)     NOT NULL UNIQUE,
    principal               BIT             NULL,
    idTelephoneAuditeur     INTEGER         NOT NULL,
    CONSTRAINT fk_telephone_auditeur FOREIGN KEY (idTelephoneAuditeur) REFERENCES Auditeurs (idAuditeur)
);

-- 2.7 Rapatriement des numéros de téléphones dans la Table dédiée.
INSERT INTO Telephones (numero, idTelephoneAuditeur)
    SELECT telephone, idAuditeur
    FROM Auditeurs;

-- Suppression de l'ancienne colonne numéros de téléphones d'Auditeurs.
ALTER TABLE dbo.Auditeurs
DROP COLUMN telephone;

-- Affichage des données.
SELECT * FROM Auditeurs a
LEFT JOIN Telephones t ON t.idTelephoneAuditeur = a.idAuditeur;


-- ---------------------------------------------------------------------
-- Affichage de la structure de la base de données.

-- Description via une procédure stockée.
EXEC sp_help Auditeurs;

-- Description via les tables système.
SELECT * FROM information_schema.columns 
WHERE table_name = 'Telephones'
ORDER BY ordinal_position;