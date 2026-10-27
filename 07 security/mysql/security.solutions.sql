-- ---------------------------------------------------------------------
-- Base de données : security_db
-- Moteur : MySQL
-- Version : 5.7.11
--
-- Vous devez auparavant avoir chargé le contexte (security.contexte.1.sql).
--
-- ---------------------------------------------------------------------

USE security_db;

SHOW tables FROM security_db;



-- ---------------------------------------------------------------------
-- MAJ DES DONNÉES


-- INSERT
-- 01. Veuillez vous inscrire dans la table 'employés'.
-- Suggestion de mot de passe 'toto' en SHA1 : 0b9c2625dc21ef05f6ad4ddf47c5f203837aa32c
-- Vous pouvez utiliser un identifiant strictement supérieur à 6 ou utiliser une sous-requête.
INSERT INTO employes (nom_session, mot_de_passe, nom, prenom, email, matricule, verrou, actif)
VALUES (
        'veinardq',
        '0b9c2625dc21ef05f6ad4ddf47c5f203837aa32c',
        'Quentin',
        'Veinard',
        'quentin.veinard@apple.com',
        'QV84564',
        FALSE,
        TRUE)
;
SELECT * FROM employes
;

-- Subtilité d'une sous-requête en MySQL qui utilise la même table que la table cible.
INSERT INTO employes (id_employe, nom_session, mot_de_passe, nom, prenom, email, matricule, verrou, actif)
SELECT MAX(id_employe) + 1,
        'duranta',
        '0b9c2625dc21ef05f6ad4ddf47c5f203837aa32c',
        'Durand',
        'Arnaud',
        'arnaud.durant@apple.com',
        'AD84564',
        FALSE,
        TRUE
FROM employes
;

-- Vérification : Êtes-vous bien dans la table ?
SELECT * FROM employes
;



-- DELETE
-- 02. Retirer le profil 'Opérateur' à Yann Frein (nom de session : freiny).
-- Aide : Il faut supprimer dans 'disposer' 1 ligne avec un prédicat de 2 conditions :
-- WHERE <condition1_profil_ope> AND <condition2_employe_freiny>

DELETE FROM disposer
WHERE id_profil_ref = 3 AND id_employe_ref = 4
;

-- Ici, cette solution propose de retrouver l'identifiant à partir des valeurs, à l'aide de sous-requêtes
DELETE FROM disposer
WHERE id_profil_ref = (SELECT id_profil FROM profils WHERE code_profil LIKE 'OPE') -- id:3
AND id_employe_ref = (SELECT id_employe FROM employes WHERE nom_session LIKE 'freiny') -- id:4
;



-- Vérification : On voit bien que 'freiny' n'a plus que le profil 'Paramétreur' :
-- Bon, ici, il faut se servir de jointures....
SELECT e.nom_session, p.code_profil, p.profil FROM disposer d
INNER JOIN employes e ON e.id_employe = d.id_employe_ref
INNER JOIN profils p ON p.id_profil = d.id_profil_ref
;



-- UPDATE
-- 03. On constate des fautes d'orthographe sur 2 fonctionnalités, veuillez les corriger :
-- Pour A02, lire 'réel' au lieu de 'r2el'.
-- Pour O03, lire 'Acc2s main courante' au lieu de 'Accès main courante'.
-- Aide : Il faut effectuer 2 requêtes et utiliser WHERE <colonne> LIKE <valeur>.
UPDATE fonctionnalites
SET fonctionnalite = 'Suivi d''activité en temps réel'
WHERE code_fonctionnalite LIKE 'A02'
;

UPDATE fonctionnalites
SET fonctionnalite = 'Accès main courante'
WHERE code_fonctionnalite LIKE 'O03'
;

-- Vérification : Les libellés des 2 fonctionnalités sont correctement renommées :
SELECT * FROM fonctionnalites
WHERE code_fonctionnalite IN ('A02', 'O03', 'O05', 'O05')
;



-- DELETE
-- 04. Supprimez le profil 'Stationnaire' à l'aide de son code 'STA'.
-- Aide : WHERE <colonne> LIKE <valeur>
DELETE FROM profils WHERE code_profil LIKE 'STA'
;

-- ou : DELETE FROM profils WHERE codeProfil = 'STA';

-- Vérification : On voit bien que le profil 'Stationnaire' avec le code 'STA' n'existe plus.
SELECT p.code_profil, p.profil, COUNT(d.id_employe_ref) AS 'Nbre employés' FROM profils p
LEFT JOIN disposer d ON p.id_profil = d.id_profil_ref
GROUP BY p.code_profil, p.profil
ORDER BY 3 DESC
;



-- INSERT
-- 05. Ajoutez la fonctionnalité suivante, pour l'application correspondante.
-- A03 : Impression
-- Aide : Requête imbriquée pour récupérer l'ID de l'application 'Appels'.
INSERT INTO fonctionnalites (code_fonctionnalite, fonctionnalite, id_application_ref)
VALUES ('A03', 'Impression',
        (SELECT id_application FROM applications
         WHERE nom_application LIKE 'Appels')
        )
;

-- Vérification : La nouvelle fonctionnalité 'Impression' est disponible pour l'application 'Appels' :
SELECT * FROM fonctionnalites f 
INNER JOIN applications a ON a.id_application = f.id_application_ref
WHERE f.code_fonctionnalite LIKE 'A%'
;



-- INSERT
-- 06. Ajoutez-vous le profil 'Administrateur'.
-- Tentez d'utiliser le code employé vous concernant (sous-requête) pour récupérer votre identifiant.
INSERT INTO disposer (id_profil_ref, id_employe_ref)
VALUES ((SELECT id_profil FROM profils WHERE code_profil LIKE 'ADM'),
        (SELECT id_employe FROM employes WHERE nom_session LIKE 'veinardq'))
;

-- Vérification : Liste des administrateurs où vous devriez figurer :
SELECT e.id_employe, e.nom_session, p.code_profil, p.profil FROM disposer d
INNER JOIN profils p ON p.id_profil = d.id_profil_ref
INNER JOIN employes e ON e.id_employe = d.id_employe_ref
WHERE p.code_profil LIKE 'ADM'
;



-- UPDATE
-- 07. L'employé 'Yann Frein' peut maintenant être déverrouillé et rendu de nouveau actif.
-- Aide : Attention au sens de lecture des booléens, et il faut appliquer 2 modifications.
UPDATE employes
    SET actif = TRUE,
        verrou = FALSE
WHERE nom_session LIKE 'freiny'
;

-- Vérification : Yann Frein est actif et déverrouillé.
SELECT prenom, nom,
       IF(actif, 'compte actif', 'compte inactif') AS 'Actif / Inactif',
       IF(verrou, 'compte verrouillé', 'compte déverrouillé') AS 'Verrouillé / Déverrouillé'
FROM employes
WHERE nom_session LIKE 'freiny'
;



-- UPDATE
-- 08. L'application 'Régulation Médicale' doit être renommée en 'Coordination Médicale'.
UPDATE applications
    SET nom_application = 'Coordination Médicale'
WHERE nom_application LIKE 'Régulation Médicale';

-- Vérification : On lit bien 'Coordination' au lieu de 'Régulation'.
SELECT id_application,
       IF(nom_application LIKE '%Médicale', '  ==> ', '') AS '',
       nom_application AS 'Nom d''application',
       IF(nom_application LIKE '%Médicale', '  <== ', '') AS ''
FROM applications
;



-- INSERT
-- 09. Attribuez la fonctionnalité 'Suivi des Opérations' pour le profil 'Régulateur'.
-- Aide : Il faut ajouter cette donnée dans la table 'attribuer'.
-- Vous n'êtes pas obligés de donner les informations sur les actions, on laisse par défaut.
INSERT INTO attribuer (id_attributeur, id_profil_ref, id_fonctionnalite_ref)
VALUES  ((SELECT id_employe FROM employes WHERE nom_session = 'veinardq'),
         (SELECT id_profil FROM profils WHERE code_profil LIKE 'REG'),
         (SELECT id_fonctionnalite FROM fonctionnalites WHERE code_fonctionnalite LIKE 'O04'))
;

-- Vérification : On voit la nouvelle fonctionnalité 'Suivi des Opérations' pour le 'Régulateur' :
SELECT a.id_attributeur, p.code_profil, p.profil, f.fonctionnalite,
CONCAT(a.type_action, ' par ', e.nom_session) AS 'Action réalisée par'
FROM attribuer a 
INNER JOIN profils p ON p.id_profil = a.id_profil_ref
INNER JOIN fonctionnalites f ON f.id_fonctionnalite = a.id_fonctionnalite_ref
INNER JOIN employes e ON e.id_employe = a.id_attributeur
WHERE p.code_profil LIKE 'REG'
ORDER BY p.code_profil ASC
;



-- INSERT
-- 10. Attribuez les fonctionnalités au profil 'Contrôleur' dans l'énoncé (security.sujet.pdf).
-- Rappel des droits restants à attribuer : 
-- - Contrôleur, fonctionnalités : M02, M04, A01, A02, O01-O04
-- C'est avec votre identifiant employés que l'on stockera ces attributions (sous-requête).
-- Tentez de ne pas utiliser directement les ID mais en recherchant via les codes ou nom de session.
-- Aide : Tentez de réaliser une transaction (;) par fonctionnalité pour vous simplifier la tâche.
INSERT INTO attribuer (id_attributeur_ref, id_profil_ref, id_fonctionnalite_ref)
VALUES  (
            (SELECT id_employe FROM employes WHERE nom_session LIKE 'veinardq'),
            (SELECT id_profil FROM profils WHERE code_profil LIKE 'CTR'),
            (SELECT id_fonctionnalite FROM fonctionnalites WHERE code_fonctionnalite LIKE 'M02')
        ),
        (
            (SELECT id_employe FROM employes WHERE nom_session LIKE 'veinardq'),
            (SELECT id_profil FROM profils WHERE code_profil LIKE 'CTR'),
            (SELECT id_fonctionnalite FROM fonctionnalites WHERE code_fonctionnalite LIKE 'M04')
        ),
        (
            (SELECT id_employe FROM employes WHERE nom_session LIKE 'veinardq'),
            (SELECT id_profil FROM profils WHERE code_profil LIKE 'CTR'),
            (SELECT id_fonctionnalite FROM fonctionnalites WHERE code_fonctionnalite LIKE 'A01')
        ),
        (
            (SELECT id_employe FROM employes WHERE nom_session LIKE 'veinardq'),
            (SELECT id_profil FROM profils WHERE code_profil LIKE 'CTR'),
            (SELECT id_fonctionnalite FROM fonctionnalites WHERE code_fonctionnalite LIKE 'A02')
        ),
        (
            (SELECT id_employe FROM employes WHERE nom_session LIKE 'veinardq'),
            (SELECT id_profil FROM profils WHERE code_profil LIKE 'CTR'),
            (SELECT id_fonctionnalite FROM fonctionnalites WHERE code_fonctionnalite LIKE 'O01')
        ),
        (
            (SELECT id_employe FROM employes WHERE nom_session LIKE 'veinardq'),
            (SELECT id_profil FROM profils WHERE code_profil LIKE 'CTR'),
            (SELECT id_fonctionnalite FROM fonctionnalites WHERE code_fonctionnalite LIKE 'O02')
        ),
        (
            (SELECT id_employe FROM employes WHERE nom_session LIKE 'veinardq'),
            (SELECT id_profil FROM profils WHERE code_profil LIKE 'CTR'),
            (SELECT id_fonctionnalite FROM fonctionnalites WHERE code_fonctionnalite LIKE 'O03')
        ),
        (
            (SELECT id_employe FROM employes WHERE nom_session LIKE 'veinardq'),
            (SELECT id_profil FROM profils WHERE code_profil LIKE 'CTR'),
            (SELECT id_fonctionnalite FROM fonctionnalites WHERE code_fonctionnalite LIKE 'O04')            
        )
;

-- Vérifications : Liste des fonctionnalités du profil 'Contrôleur' :
SELECT p.code_profil, p.profil, f.code_fonctionnalite
FROM attribuer a 
INNER JOIN profils p ON p.id_profil = a.id_profil_ref
INNER JOIN fonctionnalites f ON f.id_fonctionnalite = a.id_fonctionnalite_ref
INNER JOIN employes e ON e.id_employe = a.id_attributeur_ref
WHERE p.code_profil LIKE 'CTR'
ORDER BY f.code_fonctionnalite ASC
;



-- INSERT - seulement pour les vieilles versions de MySQL
-- 11. Si vous tentez d'ajouter la fonctionnalité 'Visualisation d'un bilan' (R01) pour le profil 'Médecin'
-- tout en indiquant le type d'action 'nouveau', que constatez-vous ?
-- INFO : Selon le SGBDR utilisé et sa version, l'opération peut ne pas aboutir...
-- MySQL 5.7 autorise l'insertion alors qu'il ne le devrait pas
-- Aide : Regardez les contraintes au niveau de la création de la table 'attribuer'.
INSERT INTO attribuer (id_attributeur_ref, id_profil_ref, id_fonctionnalite_ref, type_action)
VALUES  ((SELECT id_employe FROM employes WHERE nom_session LIKE 'veinardq'),
         (SELECT id_profil FROM profils WHERE code_profil LIKE 'MED'),
         (SELECT id_fonctionnalite FROM fonctionnalites WHERE code_fonctionnalite LIKE 'R01'),
         'nouveau')
;

-- Vérification : On voit que l'attribution avec l'action 'nouveau' est BIZARREMENT créée !
SELECT * FROM attribuer a
INNER JOIN profils p ON p.id_profil = a.id_profil_ref
WHERE p.code_profil LIKE 'MED'
;

-- Le contrainte CHECK devrait nous interdire l'action 'supprimer', cependant...
-- Avec la version 5.7.11 de MySQL
-- seules les actions 'appliquer' et 'retirer' devraient être autorisées dans cette colonne.
-- On constate que cette contrainte est bien interprétée par le moteur mais non appliquée.



-- DELETE
-- 12. Le stagiaire 'Yohann Maillart' a terminé son stage, il vous est demandé de le supprimer définitivement de la base de données.
-- Aide : Attention à ne pas oublier le WHERE <colonne> LIKE <valeur>
DELETE FROM employes
WHERE nom_session LIKE 'maillarty';

-- Vérification : Il n'existe plus le stagiaire 'Maillart Yohann' :
SELECT id_employe, nom, prenom FROM employes
ORDER BY nom, prenom
;



-- DELETE
-- 13. Si l'on veut supprimer définitivement 'Tom Cassiny' cette fois-ci, que ce passe-t-il ?
-- Pouvez-vous corriger les règles dans la base de données pour que la suppression de ses droits soit également appliquée ?
-- Aide : Regardez le cours sur les contraintes d'intégrités référentielles et voyez le quel mode à appliquer sur l'évolution de la base de données.
-- Aide suite : Où pouvons-nous trouver les références de l'employé ? Autrement dit, combien y'a-t-il de tables qui s'en servent ?

DELETE FROM employes
WHERE nomSession LIKE 'cassinyt'
;

-- Suppression de la contrainte sur disposer, puis recréation avec les clauses en cascade.
ALTER TABLE disposer
    DROP FOREIGN KEY fk_employe_disposer;

ALTER TABLE disposer
    ADD CONSTRAINT fk_employe_disposer
        FOREIGN KEY (id_employe_ref)
        REFERENCES employes (id_employe)
        ON DELETE CASCADE
        ON UPDATE CASCADE
;

-- Suppression de la contrainte sur attribuer, puis recréation avec les clauses en cascade.
ALTER TABLE attribuer
    DROP FOREIGN KEY fk_attributeur;

ALTER TABLE attribuer
    ADD CONSTRAINT fk_attributeur
        FOREIGN KEY (id_attributeur_ref)
        REFERENCES employes (id_employe)
        ON DELETE CASCADE
        ON UPDATE CASCADE
;

-- Suppression possible avec un effet cascade.
DELETE FROM employes
WHERE nom_session LIKE 'cassinyt'
;

-- Vérification : L'employé n'existe plus.
SELECT e.id_employe, e.nom_session, p.code_profil, p.profil
FROM disposer d
INNER JOIN profils p ON p.id_profil = d.id_profil_ref
INNER JOIN employes e ON e.id_employe= d.id_employe_ref
ORDER BY e.nom_session
;



-- ---------------------------------------------------------------------
-- RECHERCHES SIMPLES
-- Vous pouvez - à partir d'ici - recharger le contexte 'security_db.sql' ainsi que les vues.


-- 14. Afficher la liste des applications triées par ordre alphabétique selon leur nom.
SELECT * FROM applications
ORDER BY nom_application ASC
;


-- 15. Afficher seulement les codes et fonctionnalités.
SELECT code_fonctionnalite, fonctionnalite
FROM fonctionnalites
;


-- 16. Afficher cette même liste de fonctionnalités,
-- par ordre décroissant sur leur identifiant d'application.
SELECT code_fonctionnalite, fonctionnalite FROM fonctionnalites
ORDER BY id_application_ref DESC
;


-- 17. Afficher cette même liste de fonctionnalités,
-- par ordre décroissant sur leur identifiant d'application et sur le code fonctionnalité par ordre croissant.
SELECT code_fonctionnalite, fonctionnalite FROM fonctionnalites
ORDER BY id_application_ref DESC, code_fonctionnalite ASC
;


-- 18. Afficher la liste des employés actifs et dont le compte est verrouillé.
-- Ne faire apparaître que le nom, et les informations sur l'état (actif + verrou).
SELECT nom_session, actif, verrou
FROM employes
WHERE actif = TRUE
AND verrou = TRUE
;


-- 19. Afficher la liste des employés actifs et qui ne sont pas administrateurs.
-- Utilisez la vue v_droits_employes.
SELECT * FROM v_droits_employes
WHERE actif IS TRUE
  AND profil NOT LIKE 'admin%'
;


-- 20. Afficher la liste des fonctionnalités pour chaque profil en utilisant la vue.
-- La vue doit déjà avoir auparavant été créée (v_acces_profils).
SELECT * FROM v_acces_profils
;


-- 21. On ne veut afficher de cette liste, que le type d'action et les intitulés des fonctionnalités et profils.
-- Le tout doit être trié par ordre chronologique, du plus ancien au plus récent.
SELECT type_action, fonctionnalite, profil, date_action
FROM v_acces_profils
ORDER BY date_action ASC
;


-- 22. On constate que la fonctionnalité 'Suivi des Opérations' a été appliquée 2 fois par l'administrateur le 4 mai 2020.
-- Ce qui créé des doublons dans la liste, merci de trouver une solution pour retirer ces derniers.
SELECT DISTINCT type_action, fonctionnalite, profil
FROM v_acces_profils
ORDER BY date_action ASC
;


-- 23. Afficher la liste des fonctionnalités commençant par 'Suivi'
-- Il faut préférer l'usage du mot clé LIKE, voir le cours sur les 'Prédicats'.
SELECT * FROM fonctionnalites
WHERE fonctionnalite LIKE 'Suivi%'
;


-- 24. Afficher les fonctionnalités contenant le mot 'moyen'.
-- Il faut préférer l'usage du mot clé LIKE, voir le cours sur les 'Prédicats'.
-- Que constatez-vous au sujet de la casse ?
SELECT * FROM fonctionnalites
WHERE fonctionnalite LIKE '%moyen%'
;


-- 25. Afficher la liste de tous les droits attribués après le 10 mai (inclu).
-- Utilisez la vue v_acces_profils.
SELECT * FROM v_acces_profils
WHERE date_action > '2020-05-10'
;


-- 26. Afficher la liste des fonctionnalités ayant les codes suivants : A01, O02, R04 et S05.
-- Ne faire apparaître que le code et l'intitulé de la fonctionnalité.
SELECT code_fonctionnalite, fonctionnalite
FROM fonctionnalites
WHERE code_fonctionnalite IN ('A01', 'O02', 'R04', 'S05')
;


-- 27. Quels droits ont été attribués entre le 20 et le 22 mai ?
SELECT * FROM v_acces_profils
WHERE date_action BETWEEN '2020-05-20 00:00:00' AND '2020-05-22 23:59:59'
;


-- 28. Quels sont les employés dont leur adresse mail sont soit 'mailo.com' soit 'tuta.io' ?
-- Il ne faut afficher que leur adresse mail, leur nom et prénom.
SELECT email, nom, prenom FROM employes
WHERE email LIKE '%mailo.com' OR email LIKE '%tuta.io'
;



-- ---------------------------------------------------------------------
-- JOINTURES

-- 29. Pour chaque application, afficher la liste de ses fonctionnalités (intitulé).
SELECT a.code_application
     , a.nom_application
     , f.fonctionnalite
     , f.code_fonctionnalite
FROM applications a
INNER JOIN fonctionnalites f ON f.id_application_ref = a.id_application
ORDER BY a.code_application ASC
;


-- 30. Afficher les fonctionnalités des applications suivantes : Appels, Opérations et Moyens.
-- Faire apparaître le nom de l'application, le code et l'intitulé de la fonctionnalité.
-- La liste doit être triée par ordre alphabétique pour les applications et par code pour les fonctionnalités.
SELECT nom_application, code_fonctionnalite, fonctionnalite
FROM applications AS a
INNER JOIN fonctionnalites f ON a.id_application = f.id_application_ref
WHERE a.nom_application IN ('Appels', 'Opérations', 'Moyens')
ORDER BY nom_application ASC, code_fonctionnalite ASC
;


-- 31. Afficher toutes les applications, et leurs fonctionnalités (intitulé).
-- L'application 'Hôpitaux' n'a aucune fonctionnalité, mais elle doit apparaître.
SELECT a.code_application
     , a.nom_application
     , f.fonctionnalite
     , f.code_fonctionnalite
FROM applications a
LEFT JOIN fonctionnalites f ON f.id_application_ref = a.id_application
ORDER BY a.code_application ASC
;



-- 32. Afficher tous les employés du profil ayant le code 'OPE'.
-- Faire apparaître l'identifiant de l'employé, le nom, le prénom et les informations complètes du profil (code + libellé).
SELECT e.id_employe
     , e.nom
     , e.prenom
     , CONCAT (p.code_profil, ' : ', p.profil) AS 'profil'
FROM disposer d
INNER JOIN employes e ON e.id_employe = d.id_employe_ref
INNER JOIN profils p ON p.id_profil = d.id_profil_ref
WHERE p.code_profil = 'OPE'
;



-- ---------------------------------------------------------------------
-- ENSEMBLES

-- TODO:



-- ---------------------------------------------------------------------
-- SOUS-REQUÊTES

-- ##. Quels sont les profils qui ne sont utilisés par aucun employé (actif) ?
SELECT * FROM profils
WHERE code_profil NOT IN (
    SELECT DISTINCT p.code_profil
    FROM disposer d
    INNER JOIN employes e ON e.id_employe = d.id_employe_ref
    INNER JOIN profils p ON p.id_profil = d.id_profil_ref
    WHERE e.actif IS TRUE
)
;
