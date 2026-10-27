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

-- Il faut avoir exécuté auparavant le script : scap_db.1.sql



-- Au cas où la table existerait déjà.
DROP TABLE IF EXISTS Telephones;

-- 2.6 Évolution de la structure de base de données.
CREATE TABLE Telephones
(
    idTelephone             SERIAL UNIQUE,
    numero                  VARCHAR(20) NOT NULL UNIQUE,
    principal               BOOLEAN NULL,
    idTelephoneAuditeur     INTEGER NOT NULL,
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
SELECT table_name
     , column_name
    , data_type
FROM information_schema.columns
WHERE table_name IN ('Auditeurs', 'Telephones');


-- Affichage des données.
SELECT * FROM Auditeurs a
LEFT JOIN Telephones t ON t.idTelephoneAuditeur = a.idAuditeur;

