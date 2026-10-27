

-- afficher toutes les fonctionnalités et indiquer dans quelle application elle figure.

-- jointure interne
-- seulement les fonctionnalités qui ont des applications
SELECT fonctionnalite, nom_application FROM fonctionnalites
INNER JOIN applications ON id_application_ref = id_application
;

-- toutes les applications, si ces dernières ont des fonctionnalités, on les affiche
-- via une jointure externe
SELECT id_fonctionnalite
     , fonctionnalite
     , nom_application
     , id_application
FROM applications
LEFT JOIN fonctionnalites ON id_application_ref = id_application
;


SELECT id_fonctionnalite
     , fonctionnalite
     , nom_application
     , id_application
FROM applications
FULL JOIN fonctionnalites ON id_application_ref = id_application
WHERE fonctionnalite IS NULL
;



-- toutes les applications, si ces dernières ont des fonctionnalités, on les affiche
-- autre manière de trouver les applications sans fonctionnalité
-- via une sous-requête
SELECT * FROM applications
WHERE id_application NOT IN (
    -- liste de valeurs (applications qui ont au moins 1 fonctionnalité)
    SELECT DISTINCT id_application
    FROM fonctionnalites
    INNER JOIN applications ON id_application_ref = id_application
)
;

-- toutes les fonctionnalités, si on a une info sur son application, on l'affiche
-- via une jointure externe
SELECT id_fonctionnalite
     , fonctionnalite
     , id_application
     , nom_application
FROM fonctionnalites
LEFT JOIN applications ON id_application_ref = id_application
WHERE nom_application IS NULL
;




SELECT id_fonctionnalite
     , fonctionnalite
     , id_application
     , nom_application
FROM fonctionnalites
FULL JOIN applications ON id_application_ref = id_application
;











-- fonctionnalités avec applications (INNER)
SELECT id_fonctionnalite
     , fonctionnalite
     , nom_application
     , id_application
FROM fonctionnalites
INNER JOIN applications ON id_application_ref = id_application

UNION

-- fonctionnalités sans application (LEFT)
SELECT id_fonctionnalite
     , fonctionnalite
     , nom_application
     , id_application
FROM fonctionnalites
LEFT JOIN applications ON id_application_ref = id_application
WHERE nom_application IS NULL

UNION

-- applications sans fonctionnalité (LEFT)
SELECT id_fonctionnalite
     , fonctionnalite
     , nom_application
     , id_application
FROM applications
LEFT JOIN fonctionnalites ON id_application_ref = id_application
WHERE fonctionnalite IS NULL
;


















insert into applications (code_application, nom_application)
values ('CL', 'Cardiologs')
;

insert into fonctionnalites (code_fonctionnalite, fonctionnalite, id_application_ref)
values ('ABC', 'Je sers à rien', NULL)
;

