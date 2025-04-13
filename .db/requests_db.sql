DROP PROCEDURE IF EXISTS ChercherProduit;
DROP PROCEDURE IF EXISTS ChercherProduitNoCategories;
DROP PROCEDURE IF EXISTS ChangerMdp;
DROP PROCEDURE IF EXISTS AfficherItem;
DROP PROCEDURE IF EXISTS AjouterPanier;
DROP PROCEDURE IF EXISTS MAJPanier;
DROP PROCEDURE IF EXISTS EnleverPanier;
DROP FUNCTION IF EXISTS AfficherTotal;
DROP PROCEDURE IF EXISTS AfficherInfosUtilisateur;
DROP PROCEDURE IF EXISTS VerifierConnexion;
DROP PROCEDURE IF EXISTS PasserCommande;
DROP PROCEDURE IF EXISTS MettreAJourUtilisateur;
DROP PROCEDURE IF EXISTS CreerCompte;
DROP PROCEDURE IF EXISTS CreerLivraison;
DROP PROCEDURE IF EXISTS AfficherInfosProduit;
DROP PROCEDURE IF EXISTS RemplirInfosCommande;
DROP PROCEDURE IF EXISTS TrouverUidParEmail;


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
        CREATE TEMPORARY TABLE IF NOT EXISTS Liste (id int, n varchar(50), f varchar(30), d varchar(500), p decimal(5, 2), i varchar(200), c varchar(30));
        OPEN curs;
        lect: LOOP
            FETCH curs INTO id_p, nom_p, nom_f, desc_p, prix_p, image_p, cate_p;
            IF lect_comp THEN
                LEAVE lect;
            END IF;
            INSERT INTO Liste VALUES (id_p, nom_p, nom_f,desc_p, prix_p, image_p, cate_p);
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
        CREATE TEMPORARY TABLE IF NOT EXISTS Liste (id int, n varchar(50), f varchar(30), d varchar(500), p decimal(5, 2), i varchar(200), c varchar(30));
        OPEN curs;
        lect: LOOP
            FETCH curs INTO id_p, nom_p, nom_f, desc_p, prix_p, image_p, cate_p;
            IF lect_comp THEN
                LEAVE lect;
            END IF;
            INSERT INTO Liste VALUES (id_p, nom_p, nom_f,desc_p, prix_p, image_p, cate_p);
        END LOOP lect;
	    CLOSE curs;
    SELECT * FROM Liste;

    /*SELECT P.nom_prod, F.nom_four, P.description_prod, P.prix_prod, P.image_prod, P.categorie_prod
    FROM Fournisseurs F INNER JOIN Produits P ON F.fid = P.fid WHERE P.nom_prod LIKE "%touch%" OR F.nom_four LIKE "Sm%";*/

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE #Nick #Modifier par David
    ChangerMdp(IN mdp varchar(64), IN id int)
BEGIN
    UPDATE MotHacher SET mdp_util = mdp WHERE mid = id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE #L-P
    AfficherItem(IN util_id int, IN prod_id int)
BEGIN
      SELECT P.pid, P.nom_prod, F.nom_four, P.description_prod, P.prix_prod, P.image_prod, P.categorie_prod, D.quantite FROM Fournisseurs F INNER JOIN Produits P ON F.fid = P.fid INNER JOIN dispoprods D ON P.pid = D.pid WHERE P.pid = prod_id AND D.eid =(SELECT eid_util FROM utilisateurs WHERE uid = util_id);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE #Original: Nick Modif: L-P
    AjouterPanier(IN util_id int, IN prod_id int, IN qte int)
BEGIN
    DECLARE newQte int DEFAULT 0;
    IF EXISTS (SELECT * FROM panier WHERE uid = util_id AND pid = prod_id) THEN
      SET newQte := qte + (SELECT qte FROM panier WHERE uid = util_id AND pid = prod_id);
      UPDATE panier SET qte = newQte WHERE uid = util_id AND pid = prod_id;
    ELSE
      INSERT INTO panier VALUES (util_id, prod_id, qte);
    END IF;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE #L-P
    MAJPanier(IN util_id int, IN prod_id int, IN newQte int)
BEGIN
      UPDATE panier SET qte = newQte WHERE uid = util_id AND pid = prod_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE #L-P
    EnleverPanier(IN util_id int, IN prod_id int)
BEGIN
      DELETE FROM panier WHERE uid = util_id AND pid = prod_id;
END//
DELIMITER ;

DELIMITER // #Nick
CREATE FUNCTION AfficherTotal (util_id int) RETURNS DECIMAL(6, 2) DETERMINISTIC
BEGIN
    DECLARE pid_p INT;
    DECLARE qte_p INT;
    DECLARE total DECIMAL(6, 2) DEFAULT 0;
    DECLARE lect_comp BOOL DEFAULT FALSE;
    DECLARE curs CURSOR FOR SELECT P.pid, P.qte FROM Panier P WHERE P.uid = util_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET lect_comp = TRUE;

    OPEN curs;
    lect: LOOP
        FETCH curs INTO pid_p, qte_p;
        IF lect_comp THEN
            LEAVE lect;
        END IF;
        SET total := total + ((SELECT P.prix_prod FROM Produits P WHERE P.pid = pid_p) * qte_p);
    END LOOP lect;
	  CLOSE curs;
    RETURN total;
END//
DELIMITER ;

-- Non utilisé #David
-- DELIMITER // #Melqui
-- CREATE PROCEDURE VerifierConnexion(
--    IN courriel VARCHAR(100),
--    IN mot_de_passe VARCHAR(30))
-- BEGIN
--    SELECT uid
--    FROM Utilisateurs
--    WHERE courriel_util = courriel AND mdp_util = mot_de_passe;
-- END//
-- DELIMITER ;


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


DELIMITER // #Original: Melqui | Modifications: David
CREATE PROCEDURE CreerCompte (
    IN email VARCHAR(100),
    IN prenom VARCHAR(30),
    IN nom VARCHAR(30),
    IN rue VARCHAR(60),
    IN ville VARCHAR(30),
    IN code_postal CHAR(6),
    IN province ENUM('AB','BC','MB','NB','NL','NT','NS','NU','ON','PE','QC','SK','YT'),
    IN telephone BIGINT,
    IN entrepot_id INT,
    IN mdp VARCHAR(64)
)
BEGIN
    DECLARE nouvel_mid int;
    # Pour vérifier si le courriel existe déjà ou pas
    IF EXISTS (SELECT 1 FROM Utilisateurs WHERE courriel_util = email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ce courriel est déjà utilisé.';
    ELSE
        # insèrer le nouvel utilisateur
        INSERT INTO Utilisateurs (
            courriel_util,
            prenom_util,
            nom_util,
            rue_util,
            ville_util,
            code_postal_util,
            province_util,
            telephone_util,
            eid_util
        )
        VALUES (
            email,
            prenom,
            nom,
            rue,
            ville,
            code_postal,
            province,
            telephone,
            entrepot_id
        );
        # retourner l'uid du compte créé
        SELECT LAST_INSERT_ID() AS nouvel_uid INTO nouvel_mid;
        # insèrer le nouvel mot de passe de l'utilisateur
        INSERT INTO MotHacher (mid, mdp_util) VALUES(nouvel_mid,mdp);

    END IF;
END //
DELIMITER ;


DELIMITER // #Melqui
CREATE PROCEDURE PasserCommande(
  IN p_uid INT,
  IN p_rue_comm VARCHAR(60),
  IN p_ville_comm VARCHAR(30),
  IN p_code_postal_comm CHAR(6),
  IN p_province_comm ENUM('AB','BC','MB','NB','NL','NT','NS','NU','ON','PE','QC','SK','YT')
)
BEGIN
  DECLARE nouveau_cid INT;
  DECLARE rue_client VARCHAR(60);
  DECLARE ville_client VARCHAR(30);
  DECLARE code_postal_client CHAR(6);
  DECLARE province_client ENUM('AB','BC','MB','NB','NL','NT','NS','NU','ON','PE','QC','SK','YT');

  # gestion erreur si l'utilisateur n'existe pas
  IF NOT EXISTS (SELECT 1 FROM Utilisateurs WHERE uid = p_uid) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utilisateur inexistant.';
  END IF;

  # récupérer l’adresse du compte utilisateur
  SELECT rue_util, ville_util, code_postal_util, province_util
  INTO rue_client, ville_client, code_postal_client, province_client
  FROM Utilisateurs
  WHERE uid = p_uid;

  # utiliser les valeurs fournies ou celles de l'user s'il manque une valeur
  SET p_rue_comm = IFNULL(p_rue_comm, rue_client);
  SET p_ville_comm = IFNULL(p_ville_comm, ville_client);
  SET p_code_postal_comm = IFNULL(p_code_postal_comm, code_postal_client);
  SET p_province_comm = IFNULL(p_province_comm, province_client);

  # générer un nouveau cid automatiquement
  SELECT IFNULL(MAX(cid), 0) + 1 INTO nouveau_cid FROM Commandes;

  # insértion de la commande
  INSERT INTO Commandes (
    cid, date_comm, rue_comm, ville_comm, code_postal_comm, province_comm, uid
  )
  VALUES (
    nouveau_cid, CURRENT_DATE, p_rue_comm, p_ville_comm, p_code_postal_comm, p_province_comm, p_uid
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


DELIMITER // #Ajouter si non dispo
CREATE PROCEDURE CreerLivraison (
  IN incid int,
  IN inprov char(2),
  IN indate date)
  BEGIN
    DECLARE lc_cid int;
    DECLARE lc_pid int;
    DECLARE lc_qte int;
    DECLARE dp_qte int;
    DECLARE prov_eid int;
    DECLARE transpo_id int;
    DECLARE transpo char(12);
    DECLARE lect_comp bool DEFAULT FALSE;

    DECLARE curs CURSOR FOR SELECT LC.cid, LC.pid, LC.quantite FROM lignecomms LC WHERE LC.cid = incid;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET lect_comp = TRUE;

    SET transpo_id := (SELECT FLOOR(1 + (RAND() * 3)));
    IF transpo_id = 1 THEN
      SET transpo := 'Intelcom';
    END IF;
    IF transpo_id = 2 THEN
      SET transpo := 'Poste Canada';
    END IF;
    IF transpo_id = 3 THEN
      SET transpo := 'Purolator';
    END IF;

    IF inprov IN ('QC', 'PE', 'NS', 'NB', 'NL') THEN
      SET prov_eid := 3;
    END IF;
    IF inprov IN ('BC', 'AB', 'YT', 'NT') THEN
      SET prov_eid := 2;
    END IF;
    IF inprov IN ('ON', 'MB', 'SK', 'NU') THEN
      SET prov_eid := 1;
    END IF;

    OPEN curs;
    lect: LOOP
        FETCH curs INTO lc_cid, lc_pid, lc_qte;
        IF lect_comp THEN
            LEAVE lect;
        END IF;
        SET dp_qte := (SELECT DP.quantite FROM dispoprods DP WHERE DP.pid = lc_pid AND DP.eid = prov_eid);
        IF dp_qte - lc_qte >= 0 THEN
          UPDATE dispoprods SET quantite = (dp_qte - lc_qte) WHERE pid = lc_pid AND eid = prov_eid;
        END IF;
    END LOOP lect;
	  CLOSE curs;
    INSERT INTO livraisons (date_livr, transporteur_livr, cid, eid) VALUES (DATE_ADD(indate, INTERVAL 5 DAY), transpo,
                                                                                incid, prov_eid);
END //
DELIMITER ;


DELIMITER //  #Melqui
CREATE PROCEDURE AfficherInfosProduit(
    IN p_pid INT
)
BEGIN
    DECLARE prod_existe INT;
    DECLARE total_stock INT;

    #vérifier si le produit existe
    SELECT COUNT(*) INTO prod_existe FROM Produits WHERE pid = p_pid;
    IF prod_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produit inexistant.';
    END IF;

    #calcul le stock total dans tous les entrepôts (dispoprods)
    SELECT SUM(quantite) INTO total_stock
    FROM dispoprods
    WHERE pid = p_pid;

    #affichage des infos produit avec son fournisseur et le total de stock
    SELECT
        P.nom_prod,
        F.nom_four,
        P.description_prod,
        P.prix_prod,
        P.image_prod,
        P.categorie_prod,
        COALESCE(total_stock, 0) AS stock_total,
        P.unite_produit_MTL,
        P.unite_produit_TOR,
        P.unite_produit_VAN
    FROM Produits P
    JOIN Fournisseurs F ON P.fid = F.fid
    WHERE P.pid = p_pid;
END //
DELIMITER ;

DELIMITER // #melqui
CREATE PROCEDURE RemplirInfosCommande(
    IN p_uid INT
)
BEGIN
    #variables de vérification
    DECLARE util_existe INT;

    # vérifier que l'utilisateur existe
    SELECT COUNT(*) INTO util_existe
    FROM Utilisateurs
    WHERE uid = p_uid;

    IF util_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utilisateur inexistant.';
    END IF;

    # créer la table temporaire pour contenir les infos d'expédition
    DROP TEMPORARY TABLE IF EXISTS InfosCommande;
    CREATE TEMPORARY TABLE InfosCommande (
        prenom VARCHAR(30),
        nom VARCHAR(30),
        rue VARCHAR(60),
        ville VARCHAR(30),
        code_postal CHAR(6),
        province CHAR(2),
        telephone BIGINT,
        entrepot_rue VARCHAR(60),
        entrepot_ville VARCHAR(30),
        entrepot_province CHAR(2)
    );

    #insérer les infos dans la table temporaire
    INSERT INTO InfosCommande
    SELECT
        U.prenom_util,
        U.nom_util,
        U.rue_util,
        U.ville_util,
        U.code_postal_util,
        U.province_util,
        U.telephone_util,
        E.rue_entre,
        E.ville_entre,
        E.province_entre
    FROM Utilisateurs U
    JOIN Entrepots E ON U.eid_util = E.eid
    WHERE U.uid = p_uid;

    # retourner les données
    SELECT * FROM InfosCommande;
END //
DELIMITER ;

DELIMITER // #Melqui
CREATE PROCEDURE TrouverUidParEmail(
    IN p_email VARCHAR(100)
)
BEGIN
    DECLARE uid_result INT;

    # vérifie si l'email existe
    IF NOT EXISTS (SELECT 1 FROM Utilisateurs WHERE courriel_util = p_email)
      THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Courriel introuvable.';
    END IF;

    # récupère le UID associé à l'email
    SELECT uid INTO uid_result
    FROM Utilisateurs
    WHERE courriel_util = p_email;

    # retourne le UID
    SELECT uid_result AS uid;
END //
DELIMITER ;

