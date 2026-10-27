-- 2.8 Questions SQL :

-- 2.8.1 Ajout d'un numéro de téléphone pour l'auditeur id=1.
INSERT INTO Telephones (numero, principal, idTelephoneAuditeur)
VALUES ('01.52.75.54.22', false, 1);

-- 2.8.2 Inscrivez-vous dans la table Auditeurs avec vos informations (vous pouvez renseigner des informations fictives).
INSERT INTO Auditeurs (numero, nom, prenom, adresseMail)
VALUES (548451, 'Durant', 'Louis', 'louis.durant@tutanota.io');

-- 2.8.3 Ajoutez-vous un numéro de téléphone.
INSERT INTO Telephones (numero, principal, idTelephoneAuditeur)
VALUES ('06.31.14.11.10', false, (SELECT idAuditeur FROM Auditeurs WHERE numero = 548451));

-- 2.8.4 Vous suivez actuellement le cours 'Concevoir et manipuler des bases de données', ajoutez-vous dans la table correspondante (aidez-vous du MPD).
INSERT INTO Inscriptions (idAuditeurInscription, idCoursInscription, datePreInscription, dateInscription, motivation, reglement)
VALUES
(
    (SELECT idAuditeur FROM Auditeurs WHERE numero = 548451),
    1,
    '2021-01-24',
    '2021-03-04',
    'Besoin de connaître le SQL pour ma reconversion professionnelle',
    true
);