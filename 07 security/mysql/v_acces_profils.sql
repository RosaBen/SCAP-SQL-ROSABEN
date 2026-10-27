-- ---------------------------------------------------------------------
-- Moteur : MariaDB
-- Version : 10.4.24
-- Auteur : Guillaume Mangione
-- Date de création : 10/2019
-- Date de mise à jour : 04/2024
-- Base de données : security_db
--
-- Vue
-- Permet de récupérer toutes les fonctionnalités de chaque profil.
--
-- ---------------------------------------------------------------------

CREATE OR REPLACE VIEW v_acces_profils
AS
    SELECT p.code_profil, p.profil
         , f.fonctionnalite, f.code_fonctionnalite
         , a.date_action, a.type_action
    FROM attribuer a
    INNER JOIN profils p ON p.id_profil = a.id_profil_ref
    INNER JOIN fonctionnalites f ON f.id_fonctionnalite = a.id_fonctionnalite_ref
;


-- Exemple d'utilisation de la vue :
SELECT * FROM v_acces_profils;


-- Contrôle de création de la vue :
SHOW FULL TABLES WHERE Table_type LIKE 'VIEW';
