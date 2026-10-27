-- ---------------------------------------------------------------------
-- Base de données : security_db
-- Moteur : MySQL
-- Version : 5.7.11
--
-- Vous devez auparavant avoir chargé le contexte (security.contexte.sql).
--
-- ---------------------------------------------------------------------

USE security_db;

SHOW tables FROM security_db;



-- ---------------------------------------------------------------------
-- MAJ DES DONNÉES


-- INSERT
-- 01. Veuillez vous inscrire dans la table 'employés'.
-- Suggestion de mot de passe 'toto' en SHA1 : 0b9c2625dc21ef05f6ad4ddf47c5f203837aa32c
-- Pour voir le résultat d'un 'hachage', vous pouvez faire ceci : SELECT SHA1('toto')
-- Vous pouvez utiliser un identifiant strictement supérieur à 6 ou utiliser une sous-requête.



-- DELETE
-- 02. Retirer le profil 'Opérateur' à Yann Frein (nom de session : freiny).
-- Aide : Il faut supprimer dans 'disposer' 1 ligne avec un prédicat de 2 conditions :
-- WHERE <condition1_profil_ope> AND <condition2_employe_freiny>

-- Information: Cette table d'association pourrait très bien supprimer 'logiquement' le profil à un utilisateur,
-- en inscrivant seulement une 'date_confiscation'. Cette date pourrait être utilisée pour savoir si l'utilisateur,
-- dispose toujours de ce droit. Au regard de la date du jour (SELECT NOW() ou SELECT CURRENT_TIMESTAMP())


-- UPDATE
-- 03. On constate des fautes d'orthographe sur 2 fonctionnalités, veuillez les corriger :
-- Pour A02, lire 'réel' au lieu de 'r2el'.
-- Pour O03, lire 'Acc2s main courante' au lieu de 'Accès main courante'.
-- Aide : Il faut effectuer 2 requêtes et utiliser WHERE <colonne> LIKE <valeur>.



-- DELETE
-- 04. Supprimez le profil 'Stationnaire' à l'aide de son code 'STA'.
-- Aide : WHERE <colonne> LIKE <valeur>



-- INSERT
-- 05. Ajoutez la fonctionnalité suivante, pour l'application correspondante.
-- A03 : Impression
-- Aide : Requête imbriquée pour récupérer l'ID de l'application 'Appels'.



-- INSERT
-- 06. Ajoutez-vous le profil 'Administrateur'.
-- Tentez d'utiliser le code employé vous concernant (sous-requête) pour récupérer votre identifiant.



-- UPDATE
-- 07. L'employé 'Yann Frein' peut maintenant être déverrouillé et rendu de nouveau actif.
-- Aide : Attention au sens de lecture des booléens, et il faut appliquer 2 modifications.



-- UPDATE
-- 08. L'application 'Régulation Médicale' doit être renommée en 'Coordination Médicale'.



-- INSERT
-- 09. Attribuez la fonctionnalité 'Suivi des Opérations' pour le profil 'Régulateur'.
-- Aide : Il faut ajouter cette donnée dans la table 'attribuer'.
-- Vous n'êtes pas obligés de donner les informations sur les actions, on laisse par défaut.



-- INSERT
-- 10. Attribuez les fonctionnalités au profil 'Contrôleur' dans l'énoncé (security.sujet.pdf).
-- Rappel des droits restants à attribuer : 
-- - Contrôleur, fonctionnalités : M02, M04, A01, A02, O01-O04
-- C'est avec votre identifiant employés que l'on stockera ces attributions (sous-requête).
-- Tentez de ne pas utiliser directement les ID mais en recherchant via les codes ou nom de session.
-- Aide : Tentez de réaliser une transaction (;) par fonctionnalité pour vous simplifier la tâche.



-- INSERT - seulement pour les vieilles versions de MySQL
-- 11. Si vous tentez d'ajouter la fonctionnalité 'Visualisation d'un bilan' (R01) pour le profil 'Médecin'
-- tout en indiquant le type d'action 'nouveau', que constatez-vous ?
-- INFO : Selon le SGBDR utilisé et sa version, l'opération peut ne pas aboutir...
-- MySQL 5.7 autorise l'insertion alors qu'il ne le devrait pas
-- Aide : Regardez les contraintes au niveau de la création de la table 'attribuer'.

-- Le contrainte CHECK devrait nous interdire l'action 'supprimer', cependant...
-- Avec la version 5.7.11 de MySQL
-- seules les actions 'appliquer' et 'retirer' devraient être autorisées dans cette colonne.
-- On constate que cette contrainte est bien interprétée par le moteur mais non appliquée.



-- DELETE
-- 12. Le stagiaire 'Yohann Maillart' a terminé son stage, il vous est demandé de le supprimer définitivement de la base de données.
-- Aide : Attention à ne pas oublier le WHERE <colonne> LIKE <valeur>



-- DELETE
-- 13. Si l'on veut supprimer définitivement 'Tom Cassiny' cette fois-ci, que ce passe-t-il ?
-- Pouvez-vous corriger les règles dans la base de données pour que la suppression de ses droits soit également appliquée ?
-- Aide : Regardez le cours sur les contraintes d'intégrités référentielles et voyez le quel mode à appliquer sur l'évolution de la base de données.
-- Aide suite : Où pouvons-nous trouver les références de l'employé ? Autrement dit, combien y'a-t-il de tables qui s'en servent ?



-- ---------------------------------------------------------------------
-- RECHERCHES SIMPLES
-- Vous pouvez - à partir d'ici - recharger le contexte 'security.contexte.sql' ainsi que les vues.


-- 14. Afficher la liste des applications triées par ordre alphabétique selon leur nom.


-- 15. Afficher seulement les codes et fonctionnalités.


-- 16. Afficher cette même liste de fonctionnalités,
-- par ordre décroissant sur leur identifiant d'application.


-- 17. Afficher cette même liste de fonctionnalités,
-- par ordre décroissant sur leur identifiant d'application et sur le code fonctionnalité par ordre croissant.


-- 18. Afficher la liste des employés actifs et dont le compte est verrouillé.
-- Ne faire apparaître que le nom, et les informations sur l'état (actif + verrou).


-- 19. Afficher la liste des employés actifs et qui ne sont pas administrateurs.
-- Utilisez la vue v_droits_employes.


-- 20. Afficher la liste des fonctionnalités pour chaque profil en utilisant la vue.
-- La vue doit déjà avoir auparavant été créée (v_acces_profils).


-- 21. On ne veut afficher de cette liste, que le type d'action et les intitulés des fonctionnalités et profils.
-- Le tout doit être trié par ordre chronologique, du plus ancien au plus récent.


-- 22. On constate que la fonctionnalité 'Suivi des Opérations' a été appliquée 2 fois par l'administrateur le 4 mai 2020.
-- Ce qui créé des doublons dans la liste, merci de trouver une solution pour retirer ces derniers.


-- 23. Afficher la liste des fonctionnalités commençant par 'Suivi'
-- Il faut préférer l'usage du mot clé LIKE, voir le cours sur les 'Prédicats'.


-- 24. Afficher les fonctionnalités contenant le mot 'moyen'.
-- Il faut préférer l'usage du mot clé LIKE, voir le cours sur les 'Prédicats'.
-- Que constatez-vous au sujet de la casse ?


-- 25. Afficher la liste de tous les droits attribués après le 10 mai (inclu).
-- Utilisez la vue v_acces_profils.


-- 26. Afficher la liste des fonctionnalités ayant les codes suivants : A01, O02, R04 et S05.
-- Ne faire apparaître que le code et l'intitulé de la fonctionnalité.


-- 27. Quels droits ont été attribués entre le 20 et le 22 mai ?


-- 28. Quels sont les employés dont leur adresse mail sont soit 'mailo.com' soit 'tuta.io' ?
-- Il ne faut afficher que leur adresse mail, leur nom et prénom.



-- ---------------------------------------------------------------------
-- JOINTURES

-- 29. Pour chaque application, afficher la liste de ses fonctionnalités (intitulé).


-- 30. Afficher les fonctionnalités des applications suivantes : Appels, Opérations et Moyens.
-- Faire apparaître le nom de l'application, le code et l'intitulé de la fonctionnalité.
-- La liste doit être triée par ordre alphabétique pour les applications et par code pour les fonctionnalités.


-- 31. Afficher toutes les applications, et leurs fonctionnalités (intitulé).
-- L'application 'Hôpitaux' n'a aucune fonctionnalité, mais elle doit apparaître.


-- 32. Afficher tous les employés du profil ayant le code 'OPE'.
-- Faire apparaître l'identifiant de l'employé, le nom, le prénom et les informations complètes du profil (code + libellé).


-- ---------------------------------------------------------------------
-- ENSEMBLES

-- TODO:



-- ---------------------------------------------------------------------
-- SOUS-REQUÊTES

-- ##. Quels sont les profils qui ne sont utilisés par aucun employé (actif) ?
