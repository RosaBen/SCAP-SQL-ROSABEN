-- ---------------------------------------------------------------------
-- Moteur : MariaDB
-- Version : 10.4.24
-- Auteur : Guillaume Mangione
-- Date de création : 10/2019
-- Date de mise à jour : 04/2024
-- Base de données : security_db
--
-- date          auteur        description
-- ----------    -----------   ----------------------------------
-- 2024-04-23    mangione      INSERT dans archivage...
--
--
-- Contexte
-- L'outil informatique qui administre les accès aux applications dispose d'une interface qui n'est pas du tout conviviale.
-- Impossible de modifier le code sans risquer effets de bord.
-- Pour faciliter les opérations des administrateurs applicatifs, il est envisagé de nettoyer la table 'disposer' dans la base de ddonnées
-- Elle doit concerver l'intégralité des opérations réalisées sur l'outil informatique d'administration, c'est ce qui sature l'UI.
-- Stocker les opérations dans une table nommée 'disposer_archivage'
--   On voudrait en profiter pour connaître le nombre de jours que l'employé a eu acès à un profil.
--   Elle doit contenir les attributs suivants : 
--   id_archivage, code_profil, nom_session, date_disposition, date_confiscation, date_enregistrement, nb_jours
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
-- Création de la table disposer_archivage

DROP TABLE IF EXISTS disposer_archivage;
CREATE TABLE disposer_archivage
(
    id_archivage             INTEGER           NOT NULL PRIMARY KEY AUTO_INCREMENT
  , code_profil              CHAR(3)           NOT NULL
  , nom_session              VARCHAR(50)       NOT NULL
  , date_disposition         DATETIME          NOT NULL
  , date_confiscation        DATETIME          NOT NULL
  , date_enregistrement      DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP
  , nb_jours                 SMALLINT          NOT NULL
);

-- La nouvelle table est-elle bien créée ?
SHOW TABLES;

-- Afficahge de la structure de la table créée
DESC disposer_archivage;



-- ---------------------------------------------------------------------
-- Insertion des données de la table disposer quand une date de confiscation a été inscrite

INSERT INTO disposer_archivage (
    code_profil
  , nom_session
  , date_disposition
  , date_confiscation
  , date_enregistrement
  , nb_jours
)
    SELECT p.code_profil
         , e.nom_session
         , d.date_disposition
         , d.date_confiscation
         , CURRENT_TIMESTAMP
         , DATEDIFF(d.date_confiscation, d.date_disposition)
    FROM disposer d
    INNER JOIN profils p ON p.id_profil = d.id_profil_ref
    INNER JOIN employes e ON e.id_employe = d.id_employe_ref
    WHERE d.date_confiscation IS NOT NULL
;



-- ---------------------------------------------------------------------
-- Vérification de l'opération d'importation

SELECT * FROM disposer_archivage;

