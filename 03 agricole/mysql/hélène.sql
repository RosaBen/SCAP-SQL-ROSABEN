-- ----------------------------------------------------------------------
-- Allez, aidons Hélène pour ce TP...
-- Il faut créer tous les scripts SQL pour construire la base de données Agricole

-- HELP: 
-- vous devez vous appuyer sur le modèle de données (MPD) disponible dans le dossier 'common'
-- ----------------------------------------------------------------------
-- exemple de conventions:
-- * tables: au singulier, snake_case, fr
-- * colonnes: snake_case, fr
-- * contraintes: snake_case, pattern: [type_constrainte + nom_table + nom_colonnes]
-- ----------------------------------------------------------------------

-- création de la base de données

CREATE DATABASE helene_db;

-- se connecter à la base de données
USE helene_db;


-- création des tables
-- attention, l'ordre des tables a son importance:
-- si une clé étrangère référence une clé primaire d'une autre table,
-- il faut que cette dernière soit déjà créée...

CREATE TABLE IF NOT EXISTS commune (
    id_commune INTEGER NOT NULL
  , cp CHAR(5) NOT NULL
    -- todo...
  , CONSTRAINT pk_commune_id_commune PRIMARY KEY (id_commune)
)



-- BIG HELP:
-- vous pouvez vous inspirer du script 'agricole.solution.sql'

