-- ---------------------------------------------------------------------
-- Moteur : MariaDB
-- Version : 10.4.24
-- Auteur : Guillaume Mangione
-- Date de création : 10/2019
-- Date de mise à jour : 04/2024
-- Base de données : security_db
--
-- Vue
-- Permet de récupérer tous les profils de chaque employé.
-- On récupère également l'état du compte de chacun.
-- Verrou : L'employé ne peut plus se connecter.
-- Actif : L'employé est encore en activité dans l'organisation.
--
-- ---------------------------------------------------------------------

CREATE OR REPLACE VIEW v_droits_employes
AS
    SELECT e.nom_session, e.matricule, e.actif, e.verrou, p.code_profil, p.profil
    FROM disposer d
    INNER JOIN employes e ON e.id_employe = d.id_employe_ref
    INNER JOIN profils p ON p.id_profil = d.id_profil_ref
;



-- Exemple d'utilisation de la vue :
SELECT * FROM v_droits_employes;

-- Contrôle de création de la vue :
SHOW FULL TABLES WHERE TABLE_TYPE LIKE 'VIEW';

