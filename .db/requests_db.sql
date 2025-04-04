DROP PROCEDURE IF EXISTS ChercherProduit;
DROP PROCEDURE IF EXISTS ChangerMdp;
DROP PROCEDURE IF EXISTS ChangerMdp;
DROP PROCEDURE IF EXISTS AjouterPanier;


DELIMITER //
CREATE PROCEDURE #Nick
	ChercherProduit(IN keyword varchar(100), IN category varchar(30))
BEGIN
    DECLARE nom_f varchar(30);
    DECLARE nom_p varchar(50);
    DECLARE desc_p varchar(500);
    DECLARE prix_p decimal(5, 2);
    DECLARE image_p varchar(200);
    DECLARE cate_p varchar(30);
    DECLARE lect_comp bool DEFAULT FALSE;

    DECLARE curs CURSOR FOR SELECT P.nom_prod, F.nom_four, P.description_prod, P.prix_prod, P.image_prod, P.categorie_prod
    FROM Fournisseurs F INNER JOIN Produits P ON F.fid = P.fid WHERE P.nom_prod LIKE keyword AND P.categorie_prod = category OR F.nom_four LIKE keyword;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET lect_comp = TRUE;

        CREATE TEMPORARY TABLE IF NOT EXISTS Liste (n varchar(30), f varchar(50), d varchar(500), p decimal(5, 2), i varchar(200), c varchar(30));
        OPEN curs;
        lect: LOOP
            FETCH curs INTO nom_p, nom_f, desc_p, prix_p, image_p, cate_p;
            INSERT INTO Liste VALUES (nom_p, nom_f,desc_p, prix_p, image_p, cate_p);
            IF lect_comp THEN
                LEAVE lect;
            END IF;
        END LOOP lect;
	    CLOSE curs;
    SELECT * FROM Liste;

    /*SELECT P.nom_prod, F.nom_four, P.description_prod, P.prix_prod, P.image_prod, P.categorie_prod
    FROM Fournisseurs F INNER JOIN Produits P ON F.fid = P.fid WHERE P.nom_prod LIKE "%touch%" AND P.categorie_prod = "Jouet" OR F.nom_four LIKE "Sm%";*/

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
