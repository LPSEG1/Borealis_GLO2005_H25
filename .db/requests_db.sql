DROP PROCEDURE IF EXISTS ChercherProduit;
DROP PROCEDURE IF EXISTS ChercherProduitNoCategories;
DROP PROCEDURE IF EXISTS ChangerMdp;
DROP PROCEDURE IF EXISTS ChangerMdp;
DROP PROCEDURE IF EXISTS AjouterPanier;
DROP PROCEDURE IF EXISTS AfficherInfosUtilisateur;
DROP PROCEDURE IF EXISTS VerifierConnexion;


DELIMITER //
CREATE PROCEDURE #Original: Nick | Modifications: L-P
	ChercherProduit(IN keyword varchar(100), IN category varchar(30))
BEGIN
    DECLARE id_p int;
    DECLARE nom_f varchar(30);
    DECLARE nom_p varchar(50);
    DECLARE desc_p varchar(500);
    DECLARE prix_p decimal(5, 2);
    DECLARE image_p varchar(200);
    DECLARE cate_p varchar(30);
    DECLARE lect_comp bool DEFAULT FALSE;

      DECLARE curs CURSOR FOR SELECT P.pid, P.nom_prod, F.nom_four, P.description_prod, P.prix_prod, P.image_prod, P.categorie_prod
      FROM Fournisseurs F INNER JOIN Produits P ON F.fid = P.fid WHERE P.nom_prod LIKE CONCAT ('%',keyword,'%') AND P.categorie_prod = category OR F.nom_four LIKE CONCAT ('%',keyword,'%');

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET lect_comp = TRUE;

        DROP TEMPORARY TABLE IF EXISTS Liste;
        CREATE TEMPORARY TABLE IF NOT EXISTS Liste (n varchar(50), f varchar(30), d varchar(500), p decimal(5, 2), i varchar(200), c varchar(30));
        OPEN curs;
        lect: LOOP
            FETCH curs INTO id_p, nom_p, nom_f, desc_p, prix_p, image_p, cate_p;
            IF lect_comp THEN
                LEAVE lect;
            END IF;
            INSERT INTO Liste VALUES (nom_p, nom_f,desc_p, prix_p, image_p, cate_p);
        END LOOP lect;
	    CLOSE curs;
    SELECT * FROM Liste;

    /*SELECT P.nom_prod, F.nom_four, P.description_prod, P.prix_prod, P.image_prod, P.categorie_prod
    FROM Fournisseurs F INNER JOIN Produits P ON F.fid = P.fid WHERE P.nom_prod LIKE "%touch%" AND P.categorie_prod = "Jouet" OR F.nom_four LIKE "Sm%";*/

END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE #Original: Nick | Modifications: L-P
	ChercherProduitNoCategories(IN keyword varchar(100))
BEGIN
    DECLARE id_p int;
    DECLARE nom_f varchar(30);
    DECLARE nom_p varchar(50);
    DECLARE desc_p varchar(500);
    DECLARE prix_p decimal(5, 2);
    DECLARE image_p varchar(200);
    DECLARE cate_p varchar(30);
    DECLARE lect_comp bool DEFAULT FALSE;

      DECLARE curs CURSOR FOR SELECT P.pid, P.nom_prod, F.nom_four, P.description_prod, P.prix_prod, P.image_prod, P.categorie_prod
      FROM Fournisseurs F INNER JOIN Produits P ON F.fid = P.fid WHERE P.nom_prod LIKE CONCAT ('%',keyword,'%') OR F.nom_four LIKE CONCAT ('%',keyword,'%');

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET lect_comp = TRUE;

        DROP TEMPORARY TABLE IF EXISTS Liste;
        CREATE TEMPORARY TABLE IF NOT EXISTS Liste (n varchar(50), f varchar(30), d varchar(500), p decimal(5, 2), i varchar(200), c varchar(30));
        OPEN curs;
        lect: LOOP
            FETCH curs INTO id_p, nom_p, nom_f, desc_p, prix_p, image_p, cate_p;
            IF lect_comp THEN
                LEAVE lect;
            END IF;
            INSERT INTO Liste VALUES (nom_p, nom_f,desc_p, prix_p, image_p, cate_p);
        END LOOP lect;
	    CLOSE curs;
    SELECT * FROM Liste;

    /*SELECT P.nom_prod, F.nom_four, P.description_prod, P.prix_prod, P.image_prod, P.categorie_prod
    FROM Fournisseurs F INNER JOIN Produits P ON F.fid = P.fid WHERE P.nom_prod LIKE "%touch%" OR F.nom_four LIKE "Sm%";*/

END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE #Nick
    ChangerMdp(IN mdp varchar(30), IN id int)
BEGIN
    UPDATE Utilisateurs SET mdp_util = mdp WHERE uid = id;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE #Nick
    AjouterPanier(IN util_id int, IN prod_id int, IN qte int)
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS Panier (uid int, pid int, quantite int);
    INSERT INTO Panier VALUES (util_id, prod_id, qte);
END//
DELIMITER ;


DELIMITER // #Melqui
CREATE PROCEDURE VerifierConnexion(
    IN courriel VARCHAR(100),
    IN mot_de_passe VARCHAR(30))
BEGIN
    SELECT uid
    FROM Utilisateurs
    WHERE courriel_util = courriel AND mdp_util = mot_de_passe;
END//
DELIMITER ;

DELIMITER // #Melqui
CREATE PROCEDURE AfficherInfosUtilisateur(
    IN id_utilisateur INT)
BEGIN
    SELECT
      U.uid AS userID,
      U.courriel_util AS courriel,
      U.prenom_util AS prenom,
        U.nom_util AS nom,
        U.telephone_util AS telephone,
       U.rue_util AS adresse,
        U.code_postal_util AS code_postal,
        U.ville_util AS ville,
      U.province_util AS province,
      U.eid_util AS entrepot_favoris,
      E.rue_entre AS adresse_entrepot,
        E.ville_entre AS ville_entrepot,
        E.province_entre AS province_entrepot
    FROM Utilisateurs U
    JOIN Entrepots E ON U.eid_util = E.eid
    WHERE U.uid = id_utilisateur;
END//
DELIMITER ;

DELIMITER // #Melqui
CREATE PROCEDURE CreerCompte (
    IN email VARCHAR(100),
    IN mdp VARCHAR(30),
    IN prenom VARCHAR(30),
    IN nom VARCHAR(30),
    IN rue VARCHAR(60),
    IN ville VARCHAR(30),
    IN code_postal CHAR(6),
    IN province ENUM('BC', 'ON', 'QC'),
    IN pays VARCHAR(20),
    IN telephone BIGINT,
    IN entrepot_id INT
)
BEGIN
    # Pour vérifier si le courriel existe déjà ou pas
    IF EXISTS (SELECT 1 FROM Utilisateurs WHERE courriel_util = email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ce courriel est déjà utilisé.';
    ELSE
        # insèrer le nouvel utilisateur
        INSERT INTO Utilisateurs (
            courriel_util,
            mdp_util,
            prenom_util,
            nom_util,
            rue_util,
            ville_util,
            code_postal_util,
            province_util,
            pays_util,
            telephone_util,
            eid_util
        )
        VALUES (
            email,
            mdp,
            prenom,
            nom,
            rue,
            ville,
            code_postal,
            province,
            pays,
            telephone,
            entrepot_id
        );

        # retourner l'uid du compte créé
        SELECT LAST_INSERT_ID() AS nouvel_uid;
    END IF;
END //
DELIMITER ;

DELIMITER // #Melqui
CREATE PROCEDURE PasserCommande(
  IN p_uid INT,
  IN p_rue_comm VARCHAR(60),
  IN p_ville_comm VARCHAR(30),
  IN p_code_postal_comm CHAR(6),
  IN p_province_comm ENUM('AB','BC','MB','NB','NL','NT','NS','NU','ON','PE','QC','SK','YT'),
  IN p_pays_comm VARCHAR(20)
)
BEGIN
  DECLARE nouveau_cid INT;
  DECLARE rue_client VARCHAR(60);
  DECLARE ville_client VARCHAR(30);
  DECLARE code_postal_client CHAR(6);
  DECLARE province_client ENUM('AB','BC','MB','NB','NL','NT','NS','NU','ON','PE','QC','SK','YT');
  DECLARE pays_client VARCHAR(20);

  # gestion erreur si l'utilisateur n'existe pas
  IF NOT EXISTS (SELECT 1 FROM Utilisateurs WHERE uid = p_uid) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utilisateur inexistant.';
  END IF;

  # récupérer l’adresse du compte utilisateur
  SELECT rue_util, ville_util, code_postal_util, province_util, pays_util
  INTO rue_client, ville_client, code_postal_client, province_client, pays_client
  FROM Utilisateurs
  WHERE uid = p_uid;

  # utiliser les valeurs fournies ou celles de l'user s'il manque une valeur
  SET p_rue_comm = IFNULL(p_rue_comm, rue_client);
  SET p_ville_comm = IFNULL(p_ville_comm, ville_client);
  SET p_code_postal_comm = IFNULL(p_code_postal_comm, code_postal_client);
  SET p_province_comm = IFNULL(p_province_comm, province_client);
  SET p_pays_comm = IFNULL(p_pays_comm, pays_client);

  # générer un nouveau cid automatiquement
  SELECT IFNULL(MAX(cid), 0) + 1 INTO nouveau_cid FROM Commandes;

  # insértion de la commande
  INSERT INTO Commandes (
    cid, date_comm, rue_comm, ville_comm, code_postal_comm, province_comm, pays_comm, uid
  )
  VALUES (
    nouveau_cid, CURRENT_DATE, p_rue_comm, p_ville_comm, p_code_postal_comm, p_province_comm, p_pays_comm, p_uid
  );

END //
DELIMITER ;




DELIMITER // #Melqui
CREATE PROCEDURE MettreAJourUtilisateur(
    IN p_uid INT,
    IN p_email VARCHAR(100),
    IN p_prenom VARCHAR(30),
    IN p_nom VARCHAR(30),
    IN p_telephone BIGINT,
    IN p_rue VARCHAR(60),
    IN p_ville VARCHAR(30),
    IN p_code_postal CHAR(6),
    IN p_province ENUM('AB','BC','MB','NB','NL','NT','NS','NU','ON','PE','QC','SK','YT'),
    IN p_entrepot_id INT
)
BEGIN
    # variables temporaires
    DECLARE verif_util INT;
    DECLARE verif_entrepot INT;

    # vérifie si l'utilisateur existe
    SELECT COUNT(*) INTO verif_util FROM Utilisateurs WHERE uid = p_uid;
    IF verif_util = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utilisateur inexistant.';
    END IF;

    # vérifier si l'entrepôt est valide (s’il est fourni)
    IF p_entrepot_id IS NOT NULL THEN
        SELECT COUNT(*) INTO verif_entrepot FROM Entrepots WHERE eid = p_entrepot_id;
        IF verif_entrepot = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Entrepôt non valide.';
        END IF;
    END IF;

    #MAJ à jour des infos
    #COALESCE: si j’ai une nouvelle valeur, je la mets. sinon, je garde l’ancienne.
    #COALESCE(nouvelle_valeur, valeur_actuelle)
    UPDATE Utilisateurs
    SET
        courriel_util = COALESCE(p_email, courriel_util),
        prenom_util = COALESCE(p_prenom, prenom_util),
        nom_util = COALESCE(p_nom, nom_util),
        telephone_util = COALESCE(p_telephone, telephone_util),
        rue_util = COALESCE(p_rue, rue_util),
        ville_util = COALESCE(p_ville, ville_util),
        code_postal_util = COALESCE(p_code_postal, code_postal_util),
        province_util = COALESCE(p_province, province_util),
        eid_util = COALESCE(p_entrepot_id, eid_util)
    WHERE uid = p_uid;

END //
DELIMITER ;
