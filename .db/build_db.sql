DROP TABLE IF EXISTS Panier;
DROP TABLE IF EXISTS DispoProds;
DROP TABLE IF EXISTS LigneComms;
DROP TABLE IF EXISTS Produits;
DROP TABLE IF EXISTS Fournisseurs;
DROP TABLE IF EXISTS Livraisons;
DROP TABLE IF EXISTS Commandes;
DROP TABLE IF EXISTS MotHacher;
DROP TABLE IF EXISTS Utilisateurs;
DROP TABLE IF EXISTS Entrepots;

DROP TRIGGER IF EXISTS CalculerTotal;
DROP TRIGGER IF EXISTS TransformerPanier;
DROP TRIGGER IF EXISTS VerifierCourriel;
DROP TRIGGER IF EXISTS VerifierFournisseur;


CREATE TABLE IF NOT EXISTS Fournisseurs (fid int PRIMARY KEY, nom_four varchar(30));

DELIMITER // #Nick
CREATE TRIGGER VerifierFournisseur BEFORE INSERT ON Fournisseurs FOR EACH ROW
BEGIN
    DECLARE lect_comp BOOL DEFAULT FALSE;
    DECLARE nom char(30);

    DECLARE curs CURSOR FOR SELECT F.nom_four FROM Fournisseurs F;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET lect_comp = TRUE;

    OPEN curs;
    lect: LOOP
        FETCH curs INTO nom;
        IF lect_comp THEN
            LEAVE lect;
        END IF;
        IF NEW.nom_four = nom THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Fournisseur existe deja';
        END IF;
    END LOOP lect;
	  CLOSE curs;
END//
DELIMITER ;

INSERT INTO Fournisseurs VALUES (48291, 'HP');
INSERT INTO Fournisseurs VALUES (17536, 'LG');
INSERT INTO Fournisseurs VALUES (93842, 'Sony');
INSERT INTO Fournisseurs VALUES (26057, 'Samsung');
INSERT INTO Fournisseurs VALUES (71483, 'Apple');
INSERT INTO Fournisseurs VALUES (52904, 'Dell');
INSERT INTO Fournisseurs VALUES (31678, 'Lenovo');
INSERT INTO Fournisseurs VALUES (85021, 'Asus');
INSERT INTO Fournisseurs VALUES (69357, 'Acer');
INSERT INTO Fournisseurs VALUES (14720, 'Microsoft');
INSERT INTO Fournisseurs VALUES (80463, 'Intel');
INSERT INTO Fournisseurs VALUES (37219, 'AMD');
INSERT INTO Fournisseurs VALUES (26540, 'Nvidia');
INSERT INTO Fournisseurs VALUES (91875, 'Panasonic');
INSERT INTO Fournisseurs VALUES (63028, 'Toshiba');
INSERT INTO Fournisseurs VALUES (45792, 'Philips');
INSERT INTO Fournisseurs VALUES (58631, 'Canon');
INSERT INTO Fournisseurs VALUES (32907, 'Nike');
INSERT INTO Fournisseurs VALUES (74185, 'Adidas');
INSERT INTO Fournisseurs VALUES (20369, 'Puma');


CREATE TABLE IF NOT EXISTS Entrepots (eid int PRIMARY KEY, rue_entre varchar(60), ville_entre varchar(30), code_postal_entre char(6), province_entre enum('BC', 'ON', 'QC'));

INSERT INTO Entrepots VALUES (1, '7607 Main St', 'Toronto', 'A1A1A1', 'ON');
INSERT INTO Entrepots VALUES (2, '64 Broadway', 'Vancouver', 'B2B2B2', 'BC');
INSERT INTO Entrepots VALUES (3, '78 King St', 'Montreal', 'C3C3C3', 'QC');


CREATE TABLE IF NOT EXISTS Utilisateurs (uid int NOT NULL AUTO_INCREMENT PRIMARY KEY, courriel_util varchar(100) NOT NULL UNIQUE, prenom_util varchar(30) NOT NULL, nom_util varchar(30) NOT NULL, rue_util varchar(60), ville_util varchar(30), code_postal_util char(6), province_util enum('AB','BC','MB','NB','NL','NT','NS','NU','ON','PE','QC','SK','YT'), telephone_util bigint, eid_util int, FOREIGN KEY (eid_util) REFERENCES Entrepots(eid), INDEX (courriel_util) );

DELIMITER // #Nick
CREATE TRIGGER VerifierCourriel BEFORE INSERT ON Utilisateurs FOR EACH ROW
BEGIN
    DECLARE lect_comp BOOL DEFAULT FALSE;
    DECLARE courriel char(100);

    DECLARE curs CURSOR FOR SELECT U.courriel_util FROM Utilisateurs U;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET lect_comp = TRUE;

    OPEN curs;
    lect: LOOP
        FETCH curs INTO courriel;
        IF lect_comp THEN
            LEAVE lect;
        END IF;
        IF NEW.courriel_util = courriel THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Courriel deja utilise';
        END IF;
    END LOOP lect;
	  CLOSE curs;
END//
DELIMITER ;

INSERT INTO Utilisateurs VALUES (1, 'john.doe@gmail.com', 'john', 'doe', '142 Heritage Dr', 'Waterloo', 'E4E4E4', 'ON', 2041234567, 2);
INSERT INTO Utilisateurs VALUES (2, 'sarah_92@yahoo.com', 'sarah', 'doe', '9875 Stonebridge Ln', 'Thunder Bay', 'G5G5G5', 'ON', 2049876543, 1);
INSERT INTO Utilisateurs VALUES (3, 'michael123@hotmail.com', 'michael', 'doe', '9074 Horizon Blvd', 'Barrie', 'H6H6H6', 'ON', 3062345678, 2);
INSERT INTO Utilisateurs VALUES (4, 'emma.watson@outlook.com', 'emma', 'watson', '15 Silver Birch Ave', 'Sudbury', 'J7J7J7', 'ON', 3068765432, 2);
INSERT INTO Utilisateurs VALUES (5, 'david.smith@icloud.com', 'david', 'smith', '2987 Windermere Rd', 'Laval', 'K8K8K8', 'QC', 4033456789, 2);
INSERT INTO Utilisateurs VALUES (6, 'charlie_brown@aol.com', 'charlie', 'brown', '2310 Blueberry Ln', 'Sherbrooke', 'L9L9L9', 'QC', 4037654321, 2);
INSERT INTO Utilisateurs VALUES (7, 'olivia.jones@gmail.com', 'olivia', 'jones', '2097 Redwood Dr', 'Trois-Rivières', 'M1M1M1', 'QC', 4164567890, 3);
INSERT INTO Utilisateurs VALUES (8, 'lucas_miller@yahoo.ca', 'lucas', 'miller', '76 Sycamore St', 'Saguenay', 'N2N2N2', 'QC', 4166543210, 1);
INSERT INTO Utilisateurs VALUES (9, 'sophia_wilson@hotmail.com', 'sophia', 'wilson', '54 Ashwood Ave', 'Gatineau', 'P3P3P3', 'QC', 4185678901, 1);
INSERT INTO Utilisateurs VALUES (10, 'liam.anderson@protonmail.com', 'liam', 'anderson', '1-87 Juniper St', 'Saint John', 'R4R4R4', 'NB', 4185432109, 1);
INSERT INTO Utilisateurs VALUES (11, 'noah_thomas@live.com', 'noah', 'thomas', '78A Magnolia Ct', 'Moncton', 'S5S5S5', 'NB', 5146789012, 2);
INSERT INTO Utilisateurs VALUES (12, 'isabella.moore@ymail.com', 'isabella', 'moore', '3456 Firwood Dr', 'Drummondville', 'T6T6T6', 'QC', 5144321098, 1);
INSERT INTO Utilisateurs VALUES (13, 'ethan.harris@gmail.com', 'ethan', 'harris', '876 Evergreen Blvd', 'Granby', 'V7V7V7', 'QC', 6047890123, 1);
INSERT INTO Utilisateurs VALUES (14, 'ava_clark@yahoo.com', 'ava', 'clark', '8001 Orchard Ln', 'Belleville', 'X8X8X8', 'ON', 6043210987, 3);
INSERT INTO Utilisateurs VALUES (15, 'james_walker@outlook.com', 'james', 'walker', '743 Meadowbrook Rd', 'Chilliwack', 'Y9Y9Y9', 'BC', 6138901234, 3);
INSERT INTO Utilisateurs VALUES (16, 'mia.rodriguez@hotmail.com', 'mia', 'rodriguez', '124 Foxglove Dr', 'Red Deer', 'A2B3C4', 'AB', 6132109876, 1);
INSERT INTO Utilisateurs VALUES (17, 'benjamin_hall@icloud.com', 'benjamin', 'hall', '3256 Crimson Maple Rd', 'Lethbridge', 'D5E6F7', 'AB', 9029012345, 2);
INSERT INTO Utilisateurs VALUES (18, 'amelia.young@gmail.com', 'amelia', 'young', '12 Summit Ave', 'Medicine Hat', 'G8H9J1', 'AB', 9021098765, 2);
INSERT INTO Utilisateurs VALUES (19, 'alexander.king@yahoo.ca', 'alexander', 'king', '4 Starview Ln', 'Prince George', 'K2L3M4', 'BC', 4036783456, 1);
INSERT INTO Utilisateurs VALUES (20, 'charlotte.scott@live.com', 'charlotte', 'scott', '27 Northgate Dr', 'Sault Ste. Marie', 'N5P6R7', 'ON', 4169876543, 2);

CREATE TABLE IF NOT EXISTS MotHacher(mid int PRIMARY KEY, mdp_util varchar(64) NOT NULL, FOREIGN KEY(mid) REFERENCES Utilisateurs(uid));

INSERT INTO MotHacher VALUES(1, 'bfd0597f58625059e71350c28691ffb623cffe52d4d40284e315e2b8dd71a3f1');
INSERT INTO MotHacher VALUES(2, '4b299beecafc15c61a2cb8cef86152f1cfeb081ccdeee1281cd49c42706590c8');
INSERT INTO MotHacher VALUES(3, 'b66beb2879fb3091909e1439c318982f52c64297154e8d90fdb2d5937f22bf68');
INSERT INTO MotHacher VALUES(4, 'ea0f502a203f7e7ce033fe2cea85d6451c2a3f19c7e7c4c4259ccd5580b60535');
INSERT INTO MotHacher VALUES(5, '6292d395a1f5efcf18be8bf51c696c241f950531a5b5035d36de0d7a88416604');
INSERT INTO MotHacher VALUES(6, '4878889a9e905548d94aada4acbf9a18b1d308dc071cc875d9713ee9bf90629d');
INSERT INTO MotHacher VALUES(7, 'ae2e41654399d5c9bffd90d3934f90ee07b60f21b91aead53cf3c9705db00b2c');
INSERT INTO MotHacher VALUES(8, 'cf4d8246df923a57dd1c9fa1a9f1d500b73ed2ca236933331a39d5635a2ddbb5');
INSERT INTO MotHacher VALUES(9, '13257966d65b6ca7f54259b2419e1c6f661d2803bdfb5ae4dae5b5a659c9cf91');
INSERT INTO MotHacher VALUES(10, '814ec940beeef4b4b93c61aef1b9bd1658026d4f0a54967d8be5349378387263');
INSERT INTO MotHacher VALUES(11, '3b2e16f77fe17088f4dda90e789f0eea660acc41116c5d18012d3119eef09a8d');
INSERT INTO MotHacher VALUES(12, '7f52ce642674314a5d899532c91ca9eedf7962c920febc6807d5af227365872e');
INSERT INTO MotHacher VALUES(13, 'e6deb73238fe8b8c980d931987434598a61af8186708dcb0f47c7f6909d95e75');
INSERT INTO MotHacher VALUES(14, '36c0ce96e5240fb49013d61b27c598a622fd81ba9deca5e84f552f92aa80298d');
INSERT INTO MotHacher VALUES(15, '3ba91700e97704d60abab96d93a16d547b3eddc483a644c513b4b35852479e35');
INSERT INTO MotHacher VALUES(16, 'd56c4820591a3004135b7159be5e2a68eb8c82d0994077606a3fe3516ee47496');
INSERT INTO MotHacher VALUES(17, '92d0f6ffcc610606b5f74dc063abb1950175404dfcbae7745367550bcc3ca17f');
INSERT INTO MotHacher VALUES(18, '8d2ac26c6fead643d86935fadc29cc04f68e02068ed46555a1cb0090db2cdf09');
INSERT INTO MotHacher VALUES(19, 'cb5ebdd6d19c006d99a5a12b8db2369c905d19db68ee6556e4c64b05ac0861c8');
INSERT INTO MotHacher VALUES(20, '468b4aa0a99527ff9ccd02231a03629d11cfa3b9f003a5c307c69bfb3045dbd8');


CREATE TABLE IF NOT EXISTS Produits (pid int PRIMARY KEY, nom_prod varchar(50), prix_prod decimal(5, 2), unite_prod int, categorie_prod enum('Aliment', 'Automobile', 'Cosmétiques', 'Électronique', 'Jouet', 'Maison', 'Vêtements'), description_prod varchar(500), image_prod varchar(200), vedette bool, fid int NOT NULL, FOREIGN KEY (fid) REFERENCES Fournisseurs(fid), INDEX (vedette));

INSERT INTO Produits VALUES (123456, 'Smartphone X', 495.99, 1, 'Aliment', 'A high-quality product designed for everyday use.', NULL, False, 63028);
INSERT INTO Produits VALUES (654321, 'Gaming Laptop Z', 335.99, 2, 'Automobile', 'Experience the next level of innovation and style.', NULL, False, 71483);
INSERT INTO Produits VALUES (789012, 'Wireless Earbuds', 607.99, 6, 'Électronique', 'Perfect for home, office, or on-the-go needs.', NULL, False, 48291);
INSERT INTO Produits VALUES (345678, '4K Smart TV', 633.99, 12, 'Jouet', 'A must-have item with outstanding performance.', NULL, False, 69357);
INSERT INTO Produits VALUES (901234, 'Bluetooth Speaker', 532.99, 2, 'Maison', 'Designed with precision and durability in mind.', NULL, False, 74185);
INSERT INTO Produits VALUES (567892, 'Coffee Maker', 280.99, 1, 'Vêtements', 'Compact, lightweight, and easy to use.', NULL, False, 91875);
INSERT INTO Produits VALUES (234567, 'Electric Scooter', 853.99, 6, 'Aliment', 'Combining elegance with cutting-edge technology.', NULL, False, 58631);
INSERT INTO Produits VALUES (890123, 'Robot Vacuum', 381.99, 12, 'Électronique', 'An essential item for modern living.', NULL, False, 58631);
INSERT INTO Produits VALUES (456789, 'Graphic Card RTX', 603.99, 1, 'Jouet', 'Enhance your experience with superior quality.', NULL, False, 52904);
INSERT INTO Produits VALUES (678901, 'Mechanical Keyboard', 776.99, 6, 'Maison', 'The ultimate companion for your daily routine.', NULL, False, 80463);
INSERT INTO Produits VALUES (345123, 'Smartwatch Pro', 101.99, 2, 'Automobile', 'Built for convenience and long-lasting reliability.', NULL, False, 91875);
INSERT INTO Produits VALUES (987654, 'Noise-Canceling Headphones', 551.99, 12, 'Vêtements', 'Perfect for both professionals and casual users.', NULL, False, 17536);
INSERT INTO Produits VALUES (210987, 'Air Purifier', 852.99, 6, 'Aliment', 'Crafted to offer maximum comfort and efficiency.', NULL, False, 80463);
INSERT INTO Produits VALUES (543210, 'Portable Power Bank', 625.99, 1, 'Jouet', 'A stylish solution to your everyday challenges.', NULL, False, 14720);
INSERT INTO Produits VALUES (678345, 'DSLR Camera', 656.99, 12, 'Électronique', 'Innovative design meets high-performance features.', NULL, False, 85021);
INSERT INTO Produits VALUES (890456, 'Fitness Tracker', 21.99, 2, 'Maison', 'Engineered for efficiency and simplicity.', NULL, False, 48291);
INSERT INTO Produits VALUES (123789, 'Microwave Oven', 891.99, 1, 'Automobile', 'The ultimate companion for your daily routine.', NULL, False, 32907);
INSERT INTO Produits VALUES (456012, 'Gaming Mouse', 462.99, 6, 'Vêtements', 'Delivering top-tier performance at an affordable price.', NULL, False, 26540);
INSERT INTO Produits VALUES (789345, 'Smart LED Bulb', 46.99, 12, 'Aliment', 'An essential item for modern living.', NULL, False, 32907);
INSERT INTO Produits VALUES (234890, 'Streaming Device', 769.99, 2, 'Électronique', 'Upgrade your lifestyle with this premium item.', NULL, False, 85021);
INSERT INTO Produits VALUES (567123, 'Adjustable Desk Chair', 742.99, 6, 'Jouet', 'Seamlessly integrates into any setup or space.', NULL, False, 63028);
INSERT INTO Produits VALUES (901678, 'Cordless Vacuum', 142.99, 12, 'Maison', 'Reliable and durable, making it a great investment.', NULL, False, 48291);
INSERT INTO Produits VALUES (345012, 'External Hard Drive', 209.99, 1, 'Automobile', 'Bringing functionality and aesthetics together.', NULL, False, 85021);
INSERT INTO Produits VALUES (678234, 'USB-C Hub', 700.99, 2, 'Vêtements', 'A game-changing product with smart features.', NULL, False, 20369);
INSERT INTO Produits VALUES (890567, 'Smart Thermostat', 630.99, 6, 'Aliment', 'Combining affordability with high-end quality.', NULL, False, 48291);
INSERT INTO Produits VALUES (123901, 'Car Dash Cam', 734.99, 12, 'Jouet', 'Designed for effortless and enjoyable use.', NULL, False, 48291);
INSERT INTO Produits VALUES (456234, 'Wireless Charger', 227.99, 1, 'Électronique', 'A sleek and modern addition to your collection.', NULL, False, 52904);
INSERT INTO Produits VALUES (789678, 'Home Security Camera', 915.99, 2, 'Maison', 'The perfect gift for any occasion.', NULL, False, 17536);
INSERT INTO Produits VALUES (234123, 'Electric Toothbrush', 835.99, 12, 'Automobile', 'Created with attention to detail and excellence.', NULL, False, 17536);
INSERT INTO Produits VALUES (567890, 'Waterproof Bluetooth Speaker', 238.99, 6, 'Vêtements', 'Your go-to choice for convenience and style.', NULL, False, 17536);
INSERT INTO Produits VALUES (901456, 'High-Speed Router', 942.99, 1, 'Aliment', 'Versatile, stylish, and built to last.', NULL, False, 32907);
INSERT INTO Produits VALUES (345679, 'Professional Tripod', 634.99, 6, 'Électronique', 'An innovative solution to everyday needs.', NULL, False, 91875);
INSERT INTO Produits VALUES (678931, 'Portable Projector', 825.99, 2, 'Jouet', 'Designed to exceed your expectations.', NULL, False, 31678);
INSERT INTO Produits VALUES (890234, 'Wireless Doorbell', 518.99, 12, 'Maison', 'Performance-driven with a user-friendly interface.', NULL, False, 14720);
INSERT INTO Produits VALUES (123567, 'Standing Desk', 550.99, 6, 'Automobile', 'A powerful yet compact product for all users.', NULL, False, 48291);
INSERT INTO Produits VALUES (456784, 'Mini Fridge', 697.99, 1, 'Vêtements', 'Crafted with premium materials and technology.', NULL, False, 31678);
INSERT INTO Produits VALUES (729015, 'Smart Lock', 487.99, 12, 'Aliment', 'Reliable and efficient, ensuring customer satisfaction.', NULL, False, 58631);
INSERT INTO Produits VALUES (234345, 'Portable Air Conditioner', 156.99, 2, 'Jouet', 'Designed for ease of use and maximum comfort.', NULL, False, 31678);
INSERT INTO Produits VALUES (567678, 'Infrared Thermometer', 457.99, 1, 'Électronique', 'The best in class for performance and design.', NULL, False, 63028);
INSERT INTO Produits VALUES (901890, 'Ergonomic Office Chair', 570.99, 6, 'Maison', 'Take your experience to the next level with this.', NULL, False, 26057);
INSERT INTO Produits VALUES (345901, 'Compact Soundbar', 210.99, 12, 'Automobile', 'A carefully designed product for long-term use.', NULL, False, 69357);
INSERT INTO Produits VALUES (678123, 'Smart Ceiling Fan', 971.99, 2, 'Vêtements', 'Exceptional quality at a reasonable price.', NULL, False, 20369);
INSERT INTO Produits VALUES (893446, 'Cordless Hair Clippers', 423.99, 6, 'Aliment', 'Make every moment better with this amazing item.', NULL, False, 74185);
INSERT INTO Produits VALUES (123234, 'Portable Ice Maker', 862.99, 12, 'Électronique', 'An innovative must-have for any household.', NULL, False, 26057);
INSERT INTO Produits VALUES (456567, 'Handheld Steamer', 157.99, 1, 'Jouet', 'Simplify your life with this smart solution.', NULL, False, 52904);
INSERT INTO Produits VALUES (789890, 'Smart Light Strip', 11.99, 2, 'Maison', 'A stylish and functional addition to your lifestyle.', NULL, False, 26057);
INSERT INTO Produits VALUES (234678, 'WiFi Mesh System', 231.99, 6, 'Automobile', 'Packed with powerful features for great results.', NULL, False, 85021);
INSERT INTO Produits VALUES (567901, 'Smart Plug', 990.99, 12, 'Vêtements', 'Designed for those who appreciate quality and style.', NULL, False, 93842);
INSERT INTO Produits VALUES (901238, 'Touchscreen Monitor', 852.99, 1, 'Jouet', 'A timeless product with modern capabilities.', NULL, False, 58631);
INSERT INTO Produits VALUES (345456, 'Noise Reduction Earplugs', 125.99, 6, 'Électronique', 'Experience the perfect blend of form and function.', NULL, False, 37219);
INSERT INTO Produits VALUES (984396, 'Shampooing & Revitalisant 2 en 1 pine mint', 13.99, 15, 'Cosmétiques', 'Notre tout nouveau Shampooing & Revitalisant 2 en 1 100 % naturel est un mélange parfait des meilleurs ingrédients de la nature pour vous offrir une expérience de soins capillaires extraordinaire. Comme une promenade au cœur de la forêt boréale canadienne. Une combinaison de pin frais, de gaulthérie et de menthe rafraîchissante.', 'product984396.webp', False, 17536);

UPDATE fournisseurs t SET t.nom_four = 'CANADUINO' WHERE t.fid = 26057;
UPDATE produits t SET t.nom_prod = 'Kit d\'automate programmable DIY', t.prix_prod = 79.90, t.description_prod = 'Le CANADUINO MEGA2560 PLC-300 V2 représente la prochaine évolution de notre kit d\'automates programmables DIY à succès, offrant des capacités de connectivité et de communication améliorées tout en conservant les caractéristiques d\'E/S robustes de son prédécesseur.', t.image_prod = 'product123234.webp' WHERE t.pid = 123234;
UPDATE produits t SET t.nom_prod = 'Anneau de 16 LED', t.prix_prod = 3.90, t.categorie_prod = 'Électronique', t.description_prod = 'L\'anneau à 16 LEDs avec 16 LEDs RGB WS2812B entièrement adressables dans un grand boîtier SMD 5050 (5×5 mm). Contrôlable par une connexion série à fil unique à partir d\'un microcontrôleur.', t.image_prod = 'product901890.webp' WHERE t.pid = 901890;
UPDATE produits t SET t.nom_prod = 'Écran graphique OLED', t.prix_prod = 29.90, t.categorie_prod = 'Électronique', t.description_prod = 'L\'écran graphique OLED SSD1309 de 2,42 pouces ne nécessite pas de rétroéclairage, fonctionne dans une plage de température beaucoup plus large que le LCD, est capable de communiquer par I2C et SPI (par défaut) et ne nécessite qu\'une tension d\'alimentation de 2,8 à 3,3V.', t.image_prod = 'product789890.webp' WHERE t.pid = 789890;
UPDATE fournisseurs t SET t.nom_four = 'Article' WHERE t.fid = 14720;
UPDATE produits t SET t.nom_prod = 'Table de nuit 2 tiroirs', t.prix_prod = 599.00, t.description_prod = 'Si la beauté vient de l\'intérieur, alors vos accessoires de chevet doivent vraiment être beaux, car le Lenia est stupéfiant. Minimale et spacieuse, avec un grain de bois naturel, la Lenia s\'intègre parfaitement à tous les styles de décoration tout en faisant sa propre déclaration. Votre collection de baumes et de livres vous remerciera.', t.image_prod = 'product890234.webp' WHERE t.pid = 890234;
UPDATE produits t SET t.nom_prod = 'Table basse en marbre de 43,5 pouces', t.prix_prod = 449.99, t.categorie_prod = 'Maison', t.description_prod = 'Si frais, si cool. Les pieds en bois massif de la table Vena sont surmontés d\'un élégant marbre, ajoutant des lignes nettes et majestueuses à votre espace de vie. Le design classique s\'harmonise avec une grande variété de styles de salon, et la construction robuste vous permettra de traverser les âges.', t.image_prod = 'product543210.webp' WHERE t.pid = 543210;
UPDATE fournisseurs t SET t.nom_four = 'Green Beaver' WHERE t.fid = 17536;
UPDATE produits t SET t.nom_prod = 'Antisudorifique naturel sans aluminium', t.prix_prod = 13.99, t.categorie_prod = 'Cosmétiques', t.description_prod = 'Les cires de jojoba et de mimosa, associées à d\'autres extraits de plantes, permettent de vous maintenir naturellement au sec. Grâce à notre technologie NaturaDriMC, cet antisudorifique 100% naturel sans aluminium vous protège contre la moiteur et les odeurs pendant 24h. Des ingrédients naturels pour que vous puissiez garder la planète et vos aisselles saines.', t.image_prod = 'product234123.webp', t.vedette = 1 WHERE t.pid = 234123;
UPDATE produits t SET t.nom_prod = 'Dentifrice naturel cannelle', t.prix_prod = 6.99, t.categorie_prod = 'Cosmétiques', t.description_prod = 'Changez votre routine avec ce dentifrice à saveur légèrement épicée de cannelle!', t.image_prod = 'product789678.webp' WHERE t.pid = 789678;
UPDATE produits t SET t.nom_prod = 'Baume à lèvres Fraise-Lime', t.prix_prod = 4.99, t.categorie_prod = 'Cosmétiques', t.description_prod = 'Le mélange irrésistiblement doux et pétillant de deux fruits délicieusement rafraîchissants. Nos baumes à lèvres réparent, protègent et soulagent les lèvres extrêmement sèches. Formulés avec de l\'extrait de canneberges antioxydant et du beurre de karité pour hydrater vos lèvres en profondeur', t.image_prod = 'product987654.webp' WHERE t.pid = 987654;
UPDATE produits t SET t.nom_prod = 'Bain moussant pour enfants baies boréales', t.prix_prod = 8.99, t.categorie_prod = 'Cosmétiques', t.description_prod = 'Un bain moussant 100% naturel qui fait beaucoup de bulles pour amuser vos petits à l’heure du bain!', t.image_prod = 'product567890.webp' WHERE t.pid = 567890;
UPDATE fournisseurs t SET t.nom_four = 'Smash + Tess' WHERE t.fid = 20369;
UPDATE produits t SET t.nom_prod = 'Robe en denim', t.prix_prod = 139.99, t.description_prod = 'Une robe de rêve pour le denim!', t.image_prod = 'product678123.webp' WHERE t.pid = 678123;
UPDATE produits t SET t.nom_prod = 'Barboteuse à jambes larges noire', t.prix_prod = 134.99, t.description_prod = 'La barboteuse Tuesday 2.0 possède toutes les caractéristiques que vous connaissez et aimez de la barboteuse OG Tuesday avec quelques détails de style que vous allez adorer.', t.image_prod = 'product678234.webp' WHERE t.pid = 678234;
UPDATE fournisseurs t SET t.nom_four = 'Bebbington Industries' WHERE t.fid = 26540;
UPDATE produits t SET t.nom_prod = 'Nettoyant pour véhicules', t.prix_prod = 15.38, t.categorie_prod = 'Automobile', t.description_prod = 'AUTO WASH est un nettoyant à usage général pour voitures, camions et autres véhicules. AUTO WASH peut être utilisé dans les systèmes de lavage manuel ou mécanique.', t.image_prod = 'product456012.webp' WHERE t.pid = 456012;
UPDATE fournisseurs t SET t.nom_four = 'Little Larch' WHERE t.fid = 31678;
UPDATE produits t SET t.nom_prod = 'Jeu de potions sort de bravoure', t.prix_prod = 15.99, t.categorie_prod = 'Jouet', t.description_prod = 'Notre jeu de potions a été conçu pour susciter des jeux d\'eau attentifs. Versez quelques cuillerées du mélange dans un grand bol, ajoutez de l\'eau et regardez votre potion bouillonner et pétiller.', t.image_prod = 'product456784.webp' WHERE t.pid = 456784;
UPDATE produits t SET t.nom_prod = 'Pâte à modeler pailletée licorne', t.prix_prod = 12.99, t.description_prod = 'Réalisez une création magique avec la pâte à paillettes Licorne.', t.image_prod = 'product234345.webp' WHERE t.pid = 234345;
UPDATE produits t SET t.nom_prod = 'Pâte à modeler limonade', t.prix_prod = 9.99, t.description_prod = 'Notre pâte entièrement naturelle est fabriquée à la main avec des ingrédients d\'origine végétale, des huiles essentielles et des paillettes biodégradables. La pâte limonade est naturellement parfumée aux huiles essentielles de citron.', t.image_prod = 'product678931.webp' WHERE t.pid = 678931;
UPDATE fournisseurs t SET t.nom_four = 'Crokinole Canada' WHERE t.fid = 37219;
UPDATE produits t SET t.nom_prod = 'Tableau de crokinole pour débutants', t.prix_prod = 125.00, t.categorie_prod = 'Jouet', t.description_prod = 'Le jeu de Crokinole pour débutants est parfait pour les nouveaux joueurs qui souhaitent s\'engager dans une partie de Crokinole passionnante et rapide ! La surface est toujours lisse et régulière, et les disques glissent rapidement pendant le jeu.', t.image_prod = 'product345456.webp' WHERE t.pid = 345456;
UPDATE fournisseurs t SET t.nom_four = 'Chapman\'s' WHERE t.fid = 32907;
UPDATE produits t SET t.nom_prod = 'Barre de sorbet patte de tigre', t.prix_prod = 5.99, t.categorie_prod = 'Aliment', t.description_prod = 'Chocolat au lait premium, sorbet à l’orange rafraîchissant, 90calories par portion, saveurs et colorants naturels uniquement. Cette barre satisfait tous les critères en matière de saveur, de gâterie et d’option la plus saine.', t.image_prod = 'product123789.webp' WHERE t.pid = 123789;
UPDATE produits t SET t.nom_prod = 'Sorbet arc-en-ciel (2L)', t.prix_prod = 7.99, t.description_prod = 'Arc-en-ciel est l’un de nos premiers sorbets dans la gamme des sorbets Chapman’s traditionnels. C’est un mélange de framboise sucrée, d’orange rafraîchissante et d’un zeste de lime qui génère une puissance gustative hors du commun.', t.image_prod = 'product789345.webp' WHERE t.pid = 789345;
UPDATE produits t SET t.nom_prod = 'Crème glacée trilogie vanille (500mL)', t.prix_prod = 5.99, t.description_prod = 'Le mélange pionnier des meilleures saveurs de vanille du monde, provenant de trois régions uniques – Madagascar, Tahiti et la Papouasie-Nouvelle-Guinée, rend la trilogie vanille tout sauf ordinaire.', t.image_prod = 'product901456.webp' WHERE t.pid = 901456;
UPDATE fournisseurs t SET t.nom_four = 'Bombardier' WHERE t.fid = 45792;
UPDATE fournisseurs t SET t.nom_four = 'Cavendish Farms' WHERE t.fid = 48291;
UPDATE produits t SET t.nom_prod = 'Frites coupe mince surgelées', t.prix_prod = 3.99, t.categorie_prod = 'Aliment', t.description_prod = 'Ces frites avec pelure sont un véritable favori. Les Frites Drive Thru Restaurant Style des Fermes Cavendish offrent les saveurs d’un dîner au restaurant dans le confort de votre maison. Enrobées pour être encore plus croustillantes, elles peuvent être prêtes en 10 minutes et sauront satisfaire vos envies de Drive Thru, sans avoir à faire la queue. Une délicieuse collation à faire à la maison en un rien de temps!', t.image_prod = 'product123901.webp', t.vedette = 0 WHERE t.pid = 123901;
UPDATE produits t SET t.nom_prod = 'Galettes de pommes de terre à l\'oignon surgelées', t.prix_prod = 4.99, t.categorie_prod = 'Aliment', t.description_prod = 'Un choix savoureux en tout temps, les Galettes de Pommes de Terre à l’Oignon Classiques des Fermes Cavendish s’adressent aux amateurs de pommes de terre rissolées en quête de nouveautés. Faites de vrais oignons et pommes de terre de qualité supérieure et d’un enrobage croustillant, elles sont particulièrement pratiques et polyvalentes. Garnissez-les à votre goût pour une collation rapide ou un repas savoureux.', t.image_prod = 'product890456.webp' WHERE t.pid = 890456;
UPDATE produits t SET t.nom_prod = 'Quartiers de pommes de terre à l\'ail et au romarin', t.prix_prod = 8.99, t.description_prod = 'Les Quartiers de Pommes de Terre à l’Ail et au Romarin Restaurant Style des Fermes Cavendish sont un produit gourmet en toute simplicité. Délicieusement savoureux, ces quartiers avec pelure combinent la saveur fraîche et alléchantes de l’ail et du romarin avec des pommes de terre moelleuses de qualité supérieure. Que vous les serviez en accompagnement, en collation ou intégrés à vos recettes préférées, attendez vous à en redemander! Ces quartiers savoureux sauront rehausser n’importe quel repas.', t.image_prod = 'product890567.webp' WHERE t.pid = 890567;
UPDATE produits t SET t.nom_prod = 'Frites coupe régulière epicée au poivre concassé', t.prix_prod = 3.99, t.categorie_prod = 'Aliment', t.description_prod = 'Ces frites possèdent le croustillant caractéristique de FlavourCrisp que vous aimez tant, rehaussé par le goût épicé classique du poivre concassé! Les Frites Coupe Régulière Croustillantes Épicées au Poivre Concassé FlavourCrisp des Fermes Cavendish sont faites de pommes de terre de qualité supérieure et sont incroyablement simple à préparer. Parfaites seules ou avec votre trempette préférée, elles font également un accompagnement savoureux dont raffoleront tous les amateurs de frites.', t.image_prod = 'product901678.webp' WHERE t.pid = 901678;
UPDATE produits t SET t.nom_prod = 'Bouchées de pommes de terre surgelées', t.prix_prod = 3.99, t.categorie_prod = 'Aliment', t.description_prod = 'Croustillantes et parfaites à tout moment de la journée (ou de la nuit). Prêtes en seulement 5 minutes, passez le temps qu’elles vous font gagner dans la cuisine à rêver à de nouvelles façons de les savourer. Nos produits Quick Crisp sont délicieuses au four, mais elles ont été conçues pour la friteuse à air pour vous permettre de préparer vos plats préférés plus rapidement.', t.image_prod = 'product789012.webp' WHERE t.pid = 789012;
UPDATE produits t SET t.nom_prod = 'Gaufres de pommes de terre surgelées', t.prix_prod = 4.99, t.categorie_prod = 'Aliment', t.description_prod = 'Mi-pommes de terre rissolées, mi-gaufres. 100 % délicieuses! Ces gaufres de pommes de terre rendront le déjeuner irrésistibles au point que vous en rêverez jour et nuit. Servez les le matin en accompagnement de vos aliments du déjeuner préférés, ou l’après midi en collation, ou au souper à la place de vos frites habituelles.', t.image_prod = 'product123567.webp' WHERE t.pid = 123567;
UPDATE fournisseurs t SET t.nom_four = 'Canada Goose' WHERE t.fid = 52904;
UPDATE produits t SET t.nom_prod = 'Manteaux à duvet légers Parka Harrison', t.prix_prod = 895.00, t.categorie_prod = 'Vêtements', t.description_prod = 'Inspiré par les parkas à queue de poisson M65, ce morceau offre une protection fiable en cas de conditions météorologiques imprévisibles.', t.image_prod = 'product456789.webp' WHERE t.pid = 456789;
UPDATE produits t SET t.nom_prod = 'Lunettes de soleil Summit', t.prix_prod = 580.00, t.categorie_prod = 'Vêtements', t.description_prod = 'Des lunettes de protection contre les rayons UV pour les journées ensoleillées, quel que soit l’environnement. Découvrez un monde de couleurs plus intenses avec les verres Sideris.', t.image_prod = 'product456234.webp' WHERE t.pid = 456234;
UPDATE produits t SET t.nom_prod = 'Chaussures de sport en fibre pour femmes ', t.prix_prod = 550.00, t.categorie_prod = 'Vêtements', t.description_prod = 'Notre chaussure de sport Glacier Trail, ultra-polyvalente et multisaison, se renouvelle avec la technologie Dyneema et un revêtement indéchirable pour plus de légèreté et de résistance aux accrocs.', t.image_prod = 'product456567.webp' WHERE t.pid = 456567;
UPDATE fournisseurs t SET t.nom_four = 'Lassonde' WHERE t.fid = 58631;
UPDATE produits t SET t.nom_prod = 'Collation au fruit au pomme fraise melon d\'eau', t.prix_prod = 0.60, t.categorie_prod = 'Aliment', t.description_prod = 'La collation idéale, partout et à tout moment. Avec autant de saveurs au choix, c’est du bonheur sur le pouce pour tous.', t.image_prod = 'product901238.webp' WHERE t.pid = 901238;
UPDATE produits t SET t.nom_prod = 'Jus de pomme royal gala (2L)', t.prix_prod = 4.99, t.description_prod = 'La marque Rougemont offre des jus d\'une qualité incomparable. Nous avons à coeur de vous offrir des boissons délicieuses afin que vous savouriez à chaque gorgée la passion qui nous habite.', t.image_prod = 'product729015.webp' WHERE t.pid = 729015;
UPDATE produits t SET t.nom_prod = 'Jus de fruit bombe-baies (2L)', t.prix_prod = 2.99, t.categorie_prod = 'Aliment', t.description_prod = 'Les délicieuses boissons Fruité vont t’apporter tellement de plaisir que tu ne t\'ennuieras jamais!', t.image_prod = 'product890123.webp' WHERE t.pid = 890123;
UPDATE produits t SET t.nom_prod = 'Jus d\'orange avec pulpe (1.5L)', t.prix_prod = 4.99, t.description_prod = 'Avec un vaste choix de saveurs sans sucre ajouté, plongez dans un jus délicieusement différent chaque jour.', t.image_prod = 'product234567.webp' WHERE t.pid = 234567;
UPDATE produits t SET t.nom_prod = 'Cache-cernes léger en bâton', t.prix_prod = 34.99, t.categorie_prod = 'Cosmétiques', t.description_prod = 'Ce cache-cernes efficace est composé à 99,9% d’ingrédients d’origine naturelle éprouvés qui illuminent le regard en douceur. Sa formule sérum légère et crémeuse est infusée de phytoglycogène hydratant, de collagène végane et d’extraits d’algues.', t.image_prod = 'product123456.webp' WHERE t.pid = 123456;
UPDATE produits t SET t.nom_prod = 'Bâton solaire minéral pour enfants fps 30', t.prix_prod = 22.99, t.categorie_prod = 'Cosmétiques', t.description_prod = 'Spécifiquement formulé sans odeur pour les nez délicats et sensibles aux odeurs, notre bâton de crème solaire pour enfants sans odeur offre une couverture UVA/UVB à large spectre.', t.image_prod = 'product567123.webp' WHERE t.pid = 567123;
UPDATE produits t SET t.nom_prod = '2 en 1 shampoing et gel nettoyant', t.prix_prod = 12.99, t.categorie_prod = 'Cosmétiques', t.description_prod = 'Simplifiez votre routine de soins avec le shampoing et gel douche – Saule noir et tremble d’ATTITUDE. Formulé à partir de 97,6% d’ingrédients d’origine naturelle, cet essentiel pour la douche sera votre meilleur allié pour vos matins pressés.', t.image_prod = 'product567678.webp' WHERE t.pid = 567678;
UPDATE produits t SET t.nom_prod = 'Nettoyant multi surfaces', t.prix_prod = 5.99, t.categorie_prod = 'Maison', t.description_prod = 'Grâce à sa formule non toxique qui contient des ingrédients à base de plantes et de minéraux comme la saponine, un agent nettoyant naturel, toute votre maison sera d\'une propreté éclatante!', t.image_prod = 'product345678.webp', t.fid = 63028 WHERE t.pid = 345678;
UPDATE fournisseurs t SET t.nom_four = 'CanaKit' WHERE t.fid = 69357;
UPDATE produits t SET t.nom_prod = 'Kit de démarrage Raspberry Pi 5 8GB', t.prix_prod = 209.99, t.categorie_prod = 'Électronique', t.description_prod = 'Préparez-vous à entrer dans une nouvelle ère d\'innovation, de créativité et de possibilités infinies avec le tout nouveau kit de démarrage exclusif CanaKit Raspberry Pi 5 - incluant la version la plus rapide du Raspberry Pi, le Raspberry Pi 5 ! La prochaine évolution de la mini-informatique est arrivée.', t.image_prod = 'product345901.webp' WHERE t.pid = 345901;
UPDATE fournisseurs t SET t.nom_four = 'Clek' WHERE t.fid = 71483;
UPDATE produits t SET t.nom_prod = 'Siège de voiture convertible', t.prix_prod = 779.99, t.description_prod = 'Le siège auto convertible Clek Foonf est conçu pour offrir des performances révolutionnaires en matière de sécurité face à l\'avant et une utilisation prolongée face à l\'arrière, ce qui permet à la plupart des enfants de rester face à l\'arrière jusqu\'à leur quatrième anniversaire.', t.image_prod = 'product654321.webp' WHERE t.pid = 654321;
UPDATE fournisseurs t SET t.nom_four = 'Laduvet Nordique' WHERE t.fid = 74185;
UPDATE produits t SET t.nom_prod = 'Drap élastique - menthe givrée', t.prix_prod = 169.00, t.categorie_prod = 'Maison', t.description_prod = 'L’élastique 360° de 1” de large maintient le drap bien en place. Vous ne vous réveillerez plus au milieu de la nuit avec un drap incontrôlable et un matelas apparent à découvert.', t.image_prod = 'product893446.webp' WHERE t.pid = 893446;
UPDATE produits t SET t.nom_prod = 'Oreiller de laine', t.prix_prod = 179.00, t.description_prod = 'Voici un gros oreiller joli et confortable fabriqué au Québec avec de la laine canadienne de qualité supérieure. La laine provient des moutons d’une ferme familiale canadienne. La confection de l’enveloppe de coton de l’oreiller ainsi que le remplissage de l’oreiller sont faits dans notre atelier. C’est un oreiller volumineux qui remplira très bien l’une des belles taies d’oreiller Laduvet Nordique pour un look de chambre d’hôtel 5 étoiles.', t.image_prod = 'product901234.webp' WHERE t.pid = 901234;
UPDATE fournisseurs t SET t.nom_four = 'Peace By Chocolate' WHERE t.fid = 80463;
UPDATE produits t SET t.nom_prod = 'Barre de chocolat au lait et crème à l\'érable', t.prix_prod = 6.25, t.description_prod = 'Elbows up: canadien pour «se protéger» ou «se défendre». Supportez notre compagnie 100% canadienne avec cette barre de chocolat au lait et à la crème d\'érable.', t.image_prod = 'product210987.webp' WHERE t.pid = 210987;
UPDATE produits t SET t.nom_prod = 'Barres de chocolats au lait et aux noisettes', t.prix_prod = 5.20, t.categorie_prod = 'Aliment', t.description_prod = 'Notre délicieuse barre de la paix. Composée de chocolat au lait crémeux et de morceaux de noisettes croquants, elle est parfaite pour ajouter un peu de paix à votre journée ! La paix est belle dans toutes les langues !', t.image_prod = 'product678901.webp' WHERE t.pid = 678901;
UPDATE fournisseurs t SET t.nom_four = 'Agropur' WHERE t.fid = 85021;
UPDATE produits t SET t.nom_prod = 'Mochi à la crème glacée vanille', t.prix_prod = 6.99, t.categorie_prod = 'Aliment', t.description_prod = 'Natrel vous offre une touche de plus avec cette irrésistible gourmandise glacée d’inspiration japonaise qui se déguste du bout des doigts. Laissez-vous charmer par ce petit plaisir à la fois raffiné et gourmand. Goûtez les nouveaux mochis à la vanille fait avec de la crème glacée aux grains de vanille, enrobés d’une pâte de riz légèrement sucrée.', t.image_prod = 'product678345.webp' WHERE t.pid = 678345;
UPDATE produits t SET t.nom_prod = 'Barre de cheddar vieilli 3 ans (200g)', t.prix_prod = 11.99, t.categorie_prod = 'Aliment', t.description_prod = 'Le meilleur cheddar vieilli au monde... Cheddar à pâte ferme vieilli pendant 3 ans, dont la texture ferme et satinée se marie à des arômes prononcés à la fois fruités et légèrement piquants.', t.image_prod = 'product234890.webp' WHERE t.pid = 234890;
UPDATE produits t SET t.nom_prod = 'Lait aux fraises 1% (473mL)', t.prix_prod = 2.99, t.categorie_prod = 'Aliment', t.description_prod = 'Envie d\'essayer une touche de fraises dans votre lait ? Le lait partiellement écrémé aux fraises de Québon additionné de vitamines A et D est une excellente source de protéines et combine les éléments nutritifs du lait au délicieux goût des fraises.', t.image_prod = 'product345012.webp' WHERE t.pid = 345012;
UPDATE produits t SET t.nom_prod = 'Fromage Oka original (190g)', t.prix_prod = 11.49, t.categorie_prod = 'Aliment', t.description_prod = 'Le grand classique, le OKA Original est, encore aujourd’hui, affiné dans les caves de la Fromagerie Oka. Sa croûte lavée de teinte ambrée en fait saliver plusieurs, que vous décidiez de la manger ou non. Avec son goût subtil de beurre et son parfum distinctif, le OKA Original est toujours fabriqué dans le respect de la recette originale transmise par les moines de l’Abbaye d’Oka. Rien de moins.', t.image_prod = 'product234678.webp' WHERE t.pid = 234678;
UPDATE fournisseurs t SET t.nom_four = 'Flo' WHERE t.fid = 93842;
UPDATE produits t SET t.nom_prod = 'Borne de recharge pour voiture électrique', t.prix_prod = 799.00, t.categorie_prod = 'Automobile', t.description_prod = 'Rehaussant la barre avec une garantie de cinq ans, les bornes de recharge de niveau 2 FLO Maison sont conçues pour durer plus longtemps.', t.image_prod = 'product567901.webp' WHERE t.pid = 567901;
UPDATE fournisseurs t SET t.nom_four = 'Paderno' WHERE t.fid = 91875;
UPDATE produits t SET t.nom_prod = 'Ensemble de couteaux 14 pièces', t.prix_prod = 399.99, t.categorie_prod = 'Maison', t.description_prod = 'Les couteaux entièrement forgés avec support PADERNO Highland de 14 pièces sont conçus avec soin pour offrir une durabilité optimale, une utilisation professionnelle et un style contemporain.', t.image_prod = 'product567892.webp' WHERE t.pid = 567892;
UPDATE produits t SET t.nom_prod = 'Moule à gâteau voûté à bord étroit', t.prix_prod = 58.99, t.categorie_prod = 'Maison', t.description_prod = 'Moule à gâteau voûté à bord étroit PADERNO offrant une performance de cuisson exceptionnelle', t.image_prod = 'product345123.webp' WHERE t.pid = 345123;
UPDATE produits t SET t.nom_prod = 'Poêle en fonte émaillée 12 pouces', t.prix_prod = 69.99, t.categorie_prod = 'Maison', t.description_prod = 'La poêle en fonte émaillée bleu atlantique de PADERNO est un joyau culinaire, faite en fonte épaisse pour distribuer uniformément la chaleur et en assurer la conservation optimale. Sa forme unique permet de verser de façon contrôlée et offre une plus grande capacité, tandis que la poignée auxiliaire permet de la soulever facilement, ce qui la rend pratique et élégante dans n’importe quelle cuisine. ', t.image_prod = 'product345679.webp' WHERE t.pid = 345679;


CREATE TABLE IF NOT EXISTS DispoProds (eid int NOT NULL, pid int NOT NULL, quantite int, FOREIGN KEY (pid) REFERENCES Produits(pid), FOREIGN KEY (eid) REFERENCES Entrepots(eid));

INSERT INTO DispoProds VALUES (3, 543210, 5);
INSERT INTO DispoProds VALUES (2, 543210, 1);
INSERT INTO DispoProds VALUES (1, 543210, 6);
INSERT INTO DispoProds VALUES (3, 890234, 7);
INSERT INTO DispoProds VALUES (2, 890234, 12);
INSERT INTO DispoProds VALUES (1, 890234, 2);
INSERT INTO DispoProds VALUES (3, 234123, 14);
INSERT INTO DispoProds VALUES (2, 234123, 9);
INSERT INTO DispoProds VALUES (1, 234123, 15);
INSERT INTO DispoProds VALUES (3, 567890, 5);
INSERT INTO DispoProds VALUES (2, 567890, 0);
INSERT INTO DispoProds VALUES (1, 567890, 6);
INSERT INTO DispoProds VALUES (3, 789678, 7);
INSERT INTO DispoProds VALUES (2, 789678, 9);
INSERT INTO DispoProds VALUES (1, 789678, 15);
INSERT INTO DispoProds VALUES (3, 987654, 15);
INSERT INTO DispoProds VALUES (2, 987654, 5);
INSERT INTO DispoProds VALUES (1, 987654, 14);
INSERT INTO DispoProds VALUES (3, 678123, 3);
INSERT INTO DispoProds VALUES (2, 678123, 8);
INSERT INTO DispoProds VALUES (1, 678123, 14);
INSERT INTO DispoProds VALUES (3, 678234, 6);
INSERT INTO DispoProds VALUES (2, 678234, 10);
INSERT INTO DispoProds VALUES (1, 678234, 13);
INSERT INTO DispoProds VALUES (3, 123234, 14);
INSERT INTO DispoProds VALUES (2, 123234, 15);
INSERT INTO DispoProds VALUES (1, 123234, 4);
INSERT INTO DispoProds VALUES (3, 789890, 6);
INSERT INTO DispoProds VALUES (2, 789890, 15);
INSERT INTO DispoProds VALUES (1, 789890, 1);
INSERT INTO DispoProds VALUES (3, 901890, 9);
INSERT INTO DispoProds VALUES (2, 901890, 12);
INSERT INTO DispoProds VALUES (1, 901890, 8);
INSERT INTO DispoProds VALUES (3, 456012, 3);
INSERT INTO DispoProds VALUES (2, 456012, 2);
INSERT INTO DispoProds VALUES (1, 456012, 5);
INSERT INTO DispoProds VALUES (3, 234345, 6);
INSERT INTO DispoProds VALUES (2, 234345, 14);
INSERT INTO DispoProds VALUES (1, 234345, 11);
INSERT INTO DispoProds VALUES (3, 456784, 10);
INSERT INTO DispoProds VALUES (2, 456784, 4);
INSERT INTO DispoProds VALUES (1, 456784, 0);
INSERT INTO DispoProds VALUES (3, 678931, 12);
INSERT INTO DispoProds VALUES (2, 678931, 7);
INSERT INTO DispoProds VALUES (1, 678931, 6);
INSERT INTO DispoProds VALUES (3, 123789, 14);
INSERT INTO DispoProds VALUES (2, 123789, 14);
INSERT INTO DispoProds VALUES (1, 123789, 17);
INSERT INTO DispoProds VALUES (3, 789345, 20);
INSERT INTO DispoProds VALUES (2, 789345, 24);
INSERT INTO DispoProds VALUES (1, 789345, 32);
INSERT INTO DispoProds VALUES (3, 901456, 14);
INSERT INTO DispoProds VALUES (2, 901456, 9);
INSERT INTO DispoProds VALUES (1, 901456, 13);
INSERT INTO DispoProds VALUES (3, 345456, 8);
INSERT INTO DispoProds VALUES (2, 345456, 2);
INSERT INTO DispoProds VALUES (1, 345456, 13);
INSERT INTO DispoProds VALUES (3, 123567, 2);
INSERT INTO DispoProds VALUES (2, 123567, 2);
INSERT INTO DispoProds VALUES (1, 123567, 4);
INSERT INTO DispoProds VALUES (3, 123901, 10);
INSERT INTO DispoProds VALUES (2, 123901, 14);
INSERT INTO DispoProds VALUES (1, 123901, 8);
INSERT INTO DispoProds VALUES (3, 789012, 9);
INSERT INTO DispoProds VALUES (2, 789012, 5);
INSERT INTO DispoProds VALUES (1, 789012, 13);
INSERT INTO DispoProds VALUES (3, 890456, 5);
INSERT INTO DispoProds VALUES (2, 890456, 13);
INSERT INTO DispoProds VALUES (1, 890456, 11);
INSERT INTO DispoProds VALUES (3, 890567, 2);
INSERT INTO DispoProds VALUES (2, 890567, 5);
INSERT INTO DispoProds VALUES (1, 890567, 13);
INSERT INTO DispoProds VALUES (3, 901678, 9);
INSERT INTO DispoProds VALUES (2, 901678, 7);
INSERT INTO DispoProds VALUES (1, 901678, 8);
INSERT INTO DispoProds VALUES (3, 456234, 14);
INSERT INTO DispoProds VALUES (2, 456234, 6);
INSERT INTO DispoProds VALUES (1, 456234, 4);
INSERT INTO DispoProds VALUES (3, 456567, 5);
INSERT INTO DispoProds VALUES (2, 456567, 13);
INSERT INTO DispoProds VALUES (1, 456567, 6);
INSERT INTO DispoProds VALUES (3, 456789, 12);
INSERT INTO DispoProds VALUES (2, 456789, 12);
INSERT INTO DispoProds VALUES (1, 456789, 9);
INSERT INTO DispoProds VALUES (3, 234567, 3);
INSERT INTO DispoProds VALUES (2, 234567, 5);
INSERT INTO DispoProds VALUES (1, 234567, 14);
INSERT INTO DispoProds VALUES (3, 729015, 10);
INSERT INTO DispoProds VALUES (2, 729015, 9);
INSERT INTO DispoProds VALUES (1, 729015, 13);
INSERT INTO DispoProds VALUES (3, 890123, 8);
INSERT INTO DispoProds VALUES (2, 890123, 7);
INSERT INTO DispoProds VALUES (1, 890123, 4);
INSERT INTO DispoProds VALUES (3, 901238, 7);
INSERT INTO DispoProds VALUES (2, 901238, 16);
INSERT INTO DispoProds VALUES (1, 901238, 7);
INSERT INTO DispoProds VALUES (3, 123456, 5);
INSERT INTO DispoProds VALUES (2, 123456, 6);
INSERT INTO DispoProds VALUES (1, 123456, 9);
INSERT INTO DispoProds VALUES (3, 567123, 24);
INSERT INTO DispoProds VALUES (2, 567123, 24);
INSERT INTO DispoProds VALUES (1, 567123, 20);
INSERT INTO DispoProds VALUES (3, 567678, 14);
INSERT INTO DispoProds VALUES (2, 567678, 12);
INSERT INTO DispoProds VALUES (1, 567678, 10);
INSERT INTO DispoProds VALUES (3, 345678, 15);
INSERT INTO DispoProds VALUES (2, 345678, 11);
INSERT INTO DispoProds VALUES (1, 345678, 11);
INSERT INTO DispoProds VALUES (3, 345901, 10);
INSERT INTO DispoProds VALUES (2, 345901, 9);
INSERT INTO DispoProds VALUES (1, 345901, 11);
INSERT INTO DispoProds VALUES (3, 654321, 13);
INSERT INTO DispoProds VALUES (2, 654321, 3);
INSERT INTO DispoProds VALUES (1, 654321, 11);
INSERT INTO DispoProds VALUES (3, 893446, 1);
INSERT INTO DispoProds VALUES (2, 893446, 14);
INSERT INTO DispoProds VALUES (1, 893446, 10);
INSERT INTO DispoProds VALUES (3, 901234, 7);
INSERT INTO DispoProds VALUES (2, 901234, 14);
INSERT INTO DispoProds VALUES (1, 901234, 8);
INSERT INTO DispoProds VALUES (3, 210987, 11);
INSERT INTO DispoProds VALUES (2, 210987, 13);
INSERT INTO DispoProds VALUES (1, 210987, 14);
INSERT INTO DispoProds VALUES (3, 678901, 4);
INSERT INTO DispoProds VALUES (2, 678901, 11);
INSERT INTO DispoProds VALUES (1, 678901, 5);
INSERT INTO DispoProds VALUES (3, 234678, 2);
INSERT INTO DispoProds VALUES (2, 234678, 13);
INSERT INTO DispoProds VALUES (1, 234678, 1);
INSERT INTO DispoProds VALUES (3, 234890, 8);
INSERT INTO DispoProds VALUES (2, 234890, 13);
INSERT INTO DispoProds VALUES (1, 234890, 13);
INSERT INTO DispoProds VALUES (3, 345012, 13);
INSERT INTO DispoProds VALUES (2, 345012, 10);
INSERT INTO DispoProds VALUES (1, 345012, 13);
INSERT INTO DispoProds VALUES (3, 678345, 6);
INSERT INTO DispoProds VALUES (2, 678345, 6);
INSERT INTO DispoProds VALUES (1, 678345, 6);
INSERT INTO DispoProds VALUES (3, 345123, 5);
INSERT INTO DispoProds VALUES (2, 345123, 4);
INSERT INTO DispoProds VALUES (1, 345123, 5);
INSERT INTO DispoProds VALUES (3, 345679, 8);
INSERT INTO DispoProds VALUES (2, 345679, 1);
INSERT INTO DispoProds VALUES (1, 345679, 3);
INSERT INTO DispoProds VALUES (3, 567892, 8);
INSERT INTO DispoProds VALUES (2, 567892, 9);
INSERT INTO DispoProds VALUES (1, 567892, 7);
INSERT INTO DispoProds VALUES (3, 567901, 6);
INSERT INTO DispoProds VALUES (2, 567901, 9);
INSERT INTO DispoProds VALUES (1, 567901, 10);
INSERT INTO DispoProds VALUES (1, 984396, 5);
INSERT INTO DispoProds VALUES (2, 984396, 5);
INSERT INTO DispoProds VALUES (3, 984396, 5);


CREATE TABLE IF NOT EXISTS Panier (uid int NOT NULL, pid int NOT NULL, qte int NOT NULL, FOREIGN KEY (uid) REFERENCES Utilisateurs(uid), FOREIGN KEY (pid) REFERENCES Produits(pid));

INSERT INTO Panier VALUES (1, 567123, 1);
INSERT INTO Panier VALUES (1, 456234, 1);
INSERT INTO Panier VALUES (2, 567123, 1);
INSERT INTO Panier VALUES (1, 456234, 1);
INSERT INTO Panier VALUES (3, 567123, 1);
INSERT INTO Panier VALUES (1, 456234, 1);
INSERT INTO Panier VALUES (4, 567123, 1);
INSERT INTO Panier VALUES (5, 567123, 1);
INSERT INTO Panier VALUES (6, 567123, 1);
INSERT INTO Panier VALUES (7, 567123, 1);
INSERT INTO Panier VALUES (8, 567123, 1);
INSERT INTO Panier VALUES (9, 567123, 1);
INSERT INTO Panier VALUES (11, 567123, 1);
INSERT INTO Panier VALUES (12, 567123, 1);
INSERT INTO Panier VALUES (13, 567123, 1);
INSERT INTO Panier VALUES (14, 567123, 1);
INSERT INTO Panier VALUES (15, 567123, 1);
INSERT INTO Panier VALUES (16, 567123, 1);
INSERT INTO Panier VALUES (17, 567123, 1);
INSERT INTO Panier VALUES (18, 567123, 1);
INSERT INTO Panier VALUES (19, 567123, 1);
INSERT INTO Panier VALUES (20, 567123, 1);
INSERT INTO Panier VALUES (14, 567678, 1);
INSERT INTO Panier VALUES (2, 345123, 2);
INSERT INTO Panier VALUES (2, 678901, 1);
INSERT INTO Panier VALUES (17, 654321, 3);
INSERT INTO Panier VALUES (18, 901456, 2);
INSERT INTO Panier VALUES (11, 123456, 1);
INSERT INTO Panier VALUES (12, 123901, 3);
INSERT INTO Panier VALUES (1, 123789, 3);
INSERT INTO Panier VALUES (15, 678931, 2);
INSERT INTO Panier VALUES (6, 987654, 1);
INSERT INTO Panier VALUES (6, 893446, 3);
INSERT INTO Panier VALUES (9, 456567, 2);
INSERT INTO Panier VALUES (19, 234345, 2);
INSERT INTO Panier VALUES (19, 678123, 1);
INSERT INTO Panier VALUES (10, 567892, 3);
INSERT INTO Panier VALUES (10, 567123, 1);
INSERT INTO Panier VALUES (20, 345679, 3);
INSERT INTO Panier VALUES (20, 789678, 2);
INSERT INTO Panier VALUES (13, 345901, 1);
INSERT INTO Panier VALUES (5, 890456, 2);
INSERT INTO Panier VALUES (5, 890123, 3);
INSERT INTO Panier VALUES (7, 678345, 1);
INSERT INTO Panier VALUES (4, 123234, 2);
INSERT INTO Panier VALUES (4, 567901, 1);
INSERT INTO Panier VALUES (3, 901238, 3);
INSERT INTO Panier VALUES (8, 345456, 2);
INSERT INTO Panier VALUES (12, 456789, 1);
INSERT INTO Panier VALUES (16, 901890, 3);
INSERT INTO Panier VALUES (16, 901678, 3);


CREATE TABLE IF NOT EXISTS Commandes (cid int AUTO_INCREMENT PRIMARY KEY, date_comm date, prix_total_comm decimal(6, 2), rue_comm varchar(60), ville_comm varchar(30), code_postal_comm char(6), province_comm enum('AB', 'BC', 'MB', 'NB', 'NL', 'NT', 'NS', 'NU', 'ON', 'PE', 'QC', 'SK', 'YT'), uid int NOT NULL, FOREIGN KEY (uid) REFERENCES Utilisateurs(uid));
CREATE TABLE IF NOT EXISTS LigneComms (cid int NOT NULL, pid int NOT NULL, quantite int, FOREIGN KEY (cid) REFERENCES Commandes(cid), FOREIGN KEY (pid) REFERENCES Produits(pid));
CREATE TABLE IF NOT EXISTS Livraisons (lid int AUTO_INCREMENT PRIMARY KEY, date_livr date, transporteur_livr enum('Intelcom', 'Poste Canada', 'Purolator'), cid int NOT NULL, eid int NOT NULL, FOREIGN KEY (cid) REFERENCES Commandes(cid), FOREIGN KEY (eid) REFERENCES Entrepots(eid));

DELIMITER // #Nick
CREATE TRIGGER CheckCommande BEFORE INSERT ON Commandes FOR EACH ROW
BEGIN
    DECLARE total DECIMAL(6, 2) DEFAULT 0;
    DECLARE prov_eid int;
    DECLARE pid_p INT;
    DECLARE qte_p INT;
    DECLARE lect_comp BOOL DEFAULT FALSE;

    DECLARE curs CURSOR FOR SELECT P.pid, P.qte FROM Panier P WHERE P.uid = NEW.uid;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET lect_comp = TRUE;

    IF NEW.province_comm IN ('QC', 'PE', 'NS', 'NB', 'NL') THEN
      SET prov_eid := 3;
    END IF;
    IF NEW.province_comm IN ('BC', 'AB', 'YT', 'NT') THEN
      SET prov_eid := 2;
    END IF;
    IF NEW.province_comm IN ('ON', 'MB', 'SK', 'NU') THEN
      SET prov_eid := 1;
    END IF;

    OPEN curs;
    lect: LOOP
        FETCH curs INTO pid_p, qte_p;
        IF lect_comp THEN
            LEAVE lect;
        END IF;
        IF ((SELECT DP.quantite FROM DispoProds DP WHERE prov_eid = DP.eid AND pid_p = DP.pid) - qte_p) < 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Article en rupture de stock';
        END IF;
    END LOOP lect;
	  CLOSE curs;

    SET total := (SELECT AfficherTotal (NEW.uid));
    SET NEW.prix_total_comm = total;
END//
DELIMITER ;

DELIMITER // #Nick
CREATE TRIGGER TransformerPanier AFTER INSERT ON Commandes FOR EACH ROW
BEGIN
    DECLARE pid_p INT;
    DECLARE qte_p INT;
    DECLARE lect_comp BOOL DEFAULT FALSE;

    DECLARE curs CURSOR FOR SELECT P.pid, P.qte FROM Panier P WHERE P.uid = NEW.uid;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET lect_comp = TRUE;

    OPEN curs;
    lect: LOOP
        FETCH curs INTO pid_p, qte_p;
        IF lect_comp THEN
            LEAVE lect;
        END IF;
        INSERT INTO LigneComms VALUES (NEW.cid, pid_p, qte_p);
    END LOOP lect;
	  CLOSE curs;
    DELETE FROM Panier P WHERE NEW.uid = P.uid;
    CALL CreerLivraison (NEW.cid, NEW.province_comm, NEW.date_comm);
END//
DELIMITER ;

INSERT INTO Commandes VALUES (1, '2025-01-16', NULL, '24 Queen St', 'Calgary', 'S8T9V1', 'AB', 14);
INSERT INTO Commandes VALUES (2, '2025-01-17', NULL, '5637 Maple Ave', 'Edmonton', 'X2Y3A4', 'AB', 2);
INSERT INTO Commandes VALUES (3, '2025-01-18', NULL, '2409 Elm St', 'Ottawa', 'B5C6D7', 'ON', 17);
INSERT INTO Commandes VALUES (4, '2025-01-19', NULL, '546 Cedar Rd', 'Winnipeg', 'E8F9G1', 'MB', 18);
INSERT INTO Commandes VALUES (5, '2025-01-20', NULL, '234 Pine Dr', 'Quebec City', 'H2J3K4', 'QC', 11);
INSERT INTO Commandes VALUES (6, '2025-01-21', NULL, '901 Oak Blvd', 'Halifax', 'L5M6N7', 'NS', 1);
INSERT INTO Commandes VALUES (7, '2025-01-22', NULL, '234 Birch Ln', 'Victoria', 'P8R9S1', 'BC', 15);
INSERT INTO Commandes VALUES (8, '2025-01-25', NULL, '17 Spruce Ct', 'Saskatoon', 'T2V3X4', 'SK', 6);
INSERT INTO Commandes VALUES (9, '2025-01-26', NULL, '23 Willow Way', 'Regina', 'Y5A6B7', 'SK', 9);
INSERT INTO Commandes VALUES (10, '2025-01-27', NULL, '80 Chestnut St', 'St John', 'C8D9E1', 'NL', 19);
INSERT INTO Commandes VALUES (11, '2025-01-29', NULL, '21 River Rd', 'Charlottetown', 'F2G3H4', 'PE', 10);
INSERT INTO Commandes VALUES (12, '2025-01-30', NULL, '24 Sunset Ave', 'Fredericton', 'J5K6L7', 'NB', 20);
INSERT INTO Commandes VALUES (13, '2025-02-01', NULL, '56 Highland Dr', 'Whitehorse', 'M8N9P1', 'YT', 13);
INSERT INTO Commandes VALUES (14, '2025-02-02', NULL, '34 Lakeshore Rd', 'Yellowknife', 'R2S3T4', 'NT', 5);
INSERT INTO Commandes VALUES (15, '2025-02-02', NULL, '94 Victoria St', 'Iqaluit', 'V5X6Y7', 'NU', 7);
INSERT INTO Commandes VALUES (16, '2025-02-04', NULL, '129 Church St', 'Mississauga', 'A8B9C1', 'ON', 4);
INSERT INTO Commandes VALUES (17, '2025-02-06', NULL, '1 Front St', 'Brampton', 'D2E3F4', 'ON', 3);
INSERT INTO Commandes VALUES (18, '2025-02-08', NULL, '23 Bay St', 'Hamilton', 'G5H6J7', 'ON', 8);
INSERT INTO Commandes VALUES (19, '2025-02-11', NULL, '61 Water St', 'Kitchener', 'K8L9M1', 'ON', 12);
INSERT INTO Commandes VALUES (20, '2025-02-14', NULL, '700 Park Ave', 'London', 'N2P3R4', 'ON', 16);


#PART 2
INSERT INTO Panier VALUES (11, 678234, 2);
INSERT INTO Panier VALUES (11, 789345, 1);
INSERT INTO Panier VALUES (20, 234123, 1);
INSERT INTO Panier VALUES (15, 345012, 3);
INSERT INTO Panier VALUES (15, 789345, 1);
INSERT INTO Panier VALUES (14, 456012, 2);
INSERT INTO Panier VALUES (14, 789345, 1);
INSERT INTO Panier VALUES (7, 234567, 2);
INSERT INTO Panier VALUES (7, 789345, 1);
INSERT INTO Panier VALUES (8, 123567, 1);
INSERT INTO Panier VALUES (13, 789890, 3);
INSERT INTO Panier VALUES (13, 234678, 1);
INSERT INTO Panier VALUES (2, 890567, 2);
INSERT INTO Panier VALUES (4, 567123, 3);
INSERT INTO Panier VALUES (6, 729015, 1);
INSERT INTO Panier VALUES (6, 901234, 2);
INSERT INTO Panier VALUES (6, 567678, 1);
INSERT INTO Panier VALUES (2, 345123, 2);
INSERT INTO Panier VALUES (2, 678901, 1);
INSERT INTO Panier VALUES (17, 654321, 3);
INSERT INTO Panier VALUES (18, 901456, 2);
INSERT INTO Panier VALUES (11, 123456, 1);
INSERT INTO Panier VALUES (12, 123901, 3);
INSERT INTO Panier VALUES (1, 123789, 3);
INSERT INTO Panier VALUES (15, 678931, 2);
INSERT INTO Panier VALUES (6, 987654, 1);
INSERT INTO Panier VALUES (6, 893446, 3);
INSERT INTO Panier VALUES (9, 456567, 2);
INSERT INTO Panier VALUES (19, 234345, 2);
INSERT INTO Panier VALUES (19, 678123, 1);
INSERT INTO Panier VALUES (10, 789345, 1);
INSERT INTO Panier VALUES (10, 567892, 3);
INSERT INTO Panier VALUES (20, 789345, 1);
INSERT INTO Panier VALUES (20, 345679, 3);
INSERT INTO Panier VALUES (20, 789678, 2);
INSERT INTO Panier VALUES (13, 345901, 1);
INSERT INTO Panier VALUES (5, 890456, 2);
INSERT INTO Panier VALUES (5, 890123, 3);
INSERT INTO Panier VALUES (7, 678345, 1);
INSERT INTO Panier VALUES (4, 123234, 2);
INSERT INTO Panier VALUES (4, 567901, 1);
INSERT INTO Panier VALUES (3, 901238, 3);
INSERT INTO Panier VALUES (3, 789345, 1);
INSERT INTO Panier VALUES (8, 345456, 2);
INSERT INTO Panier VALUES (8, 789345, 1);
INSERT INTO Panier VALUES (12, 456789, 1);
INSERT INTO Panier VALUES (16, 901890, 3);
INSERT INTO Panier VALUES (16, 789345, 1);
INSERT INTO Panier VALUES (16, 901678, 3);

INSERT INTO Commandes VALUES (21, '2025-02-16', NULL, '32 Mountain Rd', 'Markham', 'S5T6V7', 'ON', 11);
INSERT INTO Commandes VALUES (22, '2025-02-26', NULL, '44 Valley View Dr', 'Vaughan', 'X8Y9A1', 'ON', 20);
INSERT INTO Commandes VALUES (23, '2025-03-02', NULL, '1122 College St', 'Surrey', 'B2C3D4', 'BC', 15);
INSERT INTO Commandes VALUES (24, '2025-03-03', NULL, '9021 University Ave', 'Burnaby', 'E5F6G7', 'BC', 14);
INSERT INTO Commandes VALUES (25, '2025-03-08', NULL, '11 Railway Ave', 'Richmond', 'H8J9K1', 'BC', 7);
INSERT INTO Commandes VALUES (26, '2025-03-10', NULL, '80 Harbour St', 'Abbotsford', 'L2M3N4', 'BC', 8);
INSERT INTO Commandes VALUES (27, '2025-03-11', NULL, '32 Meadow Ln', 'Kelowna', 'P5R6S7', 'BC', 13);
INSERT INTO Commandes VALUES (28, '2025-03-12', NULL, '74 Glenwood Dr', 'Kamloops', 'T8V9X1', 'BC', 2);
INSERT INTO Commandes VALUES (29, '2025-03-14', NULL, '999 Country Club Rd', 'Nanaimo', 'Y2A3B4', 'BC', 4);
INSERT INTO Commandes VALUES (30, '2025-03-15', NULL, '542 College St', 'Guelph', 'C5D6E7', 'ON', 6);
INSERT INTO Commandes VALUES (31, '2025-01-18', NULL, '2409 Elm St', 'Ottawa', 'B5C6D7', 'ON', 17);
INSERT INTO Commandes VALUES (32, '2025-01-19', NULL, '546 Cedar Rd', 'Winnipeg', 'E8F9G1', 'MB', 18);
INSERT INTO Commandes VALUES (33, '2025-01-21', NULL, '901 Oak Blvd', 'Halifax', 'L5M6N7', 'NS', 1);
INSERT INTO Commandes VALUES (34, '2025-01-26', NULL, '23 Willow Way', 'Regina', 'Y5A6B7', 'SK', 9);
INSERT INTO Commandes VALUES (35, '2025-01-27', NULL, '80 Chestnut St', 'St John', 'C8D9E1', 'NL', 19);
INSERT INTO Commandes VALUES (36, '2025-01-29', NULL, '21 River Rd', 'Charlottetown', 'F2G3H4', 'PE', 10);
INSERT INTO Commandes VALUES (37, '2025-02-02', NULL, '34 Lakeshore Rd', 'Yellowknife', 'R2S3T4', 'NT', 5);
INSERT INTO Commandes VALUES (38, '2025-02-06', NULL, '1 Front St', 'Brampton', 'D2E3F4', 'ON', 3);
INSERT INTO Commandes VALUES (39, '2025-02-11', NULL, '61 Water St', 'Kitchener', 'K8L9M1', 'ON', 12);
INSERT INTO Commandes VALUES (40, '2025-02-14', NULL, '700 Park Ave', 'London', 'N2P3R4', 'ON', 16);


#PART 3
INSERT INTO Panier VALUES (11, 678234, 2);
INSERT INTO Panier VALUES (20, 234123, 1);
INSERT INTO Panier VALUES (15, 345012, 3);
INSERT INTO Panier VALUES (14, 456012, 2);
INSERT INTO Panier VALUES (7, 234567, 2);
INSERT INTO Panier VALUES (8, 123567, 1);
INSERT INTO Panier VALUES (13, 789890, 3);
INSERT INTO Panier VALUES (13, 234678, 1);
INSERT INTO Panier VALUES (2, 890567, 2);
INSERT INTO Panier VALUES (4, 567123, 3);
INSERT INTO Panier VALUES (6, 729015, 1);
INSERT INTO Panier VALUES (6, 901234, 2);
INSERT INTO Panier VALUES (6, 567678, 1);
INSERT INTO Panier VALUES (2, 345123, 2);
INSERT INTO Panier VALUES (2, 678901, 1);
INSERT INTO Panier VALUES (17, 654321, 3);
INSERT INTO Panier VALUES (18, 901456, 2);
INSERT INTO Panier VALUES (11, 123456, 1);
INSERT INTO Panier VALUES (12, 123901, 3);
INSERT INTO Panier VALUES (1, 123789, 3);
INSERT INTO Panier VALUES (15, 678931, 2);
INSERT INTO Panier VALUES (6, 987654, 1);
INSERT INTO Panier VALUES (6, 893446, 3);
INSERT INTO Panier VALUES (9, 456567, 2);
INSERT INTO Panier VALUES (19, 234345, 2);
INSERT INTO Panier VALUES (19, 678123, 1);
INSERT INTO Panier VALUES (10, 567892, 3);
INSERT INTO Panier VALUES (20, 345679, 3);
INSERT INTO Panier VALUES (20, 789678, 2);
INSERT INTO Panier VALUES (13, 345901, 1);
INSERT INTO Panier VALUES (5, 890456, 2);
INSERT INTO Panier VALUES (5, 890123, 3);
INSERT INTO Panier VALUES (7, 678345, 1);
INSERT INTO Panier VALUES (4, 123234, 2);
INSERT INTO Panier VALUES (4, 567901, 1);
INSERT INTO Panier VALUES (3, 901238, 3);
INSERT INTO Panier VALUES (8, 345456, 2);
INSERT INTO Panier VALUES (12, 456789, 1);
INSERT INTO Panier VALUES (16, 901890, 3);
INSERT INTO Panier VALUES (16, 901678, 3);


CREATE TABLE IF NOT EXISTS Pays (province enum('AB', 'BC', 'MB', 'NB', 'NL', 'NT', 'NS', 'NU', 'ON', 'PE', 'QC', 'SK', 'YT'), pays varchar(20));

INSERT INTO Pays VALUES ('AB', 'Canada');
INSERT INTO Pays VALUES ('BC', 'Canada');
INSERT INTO Pays VALUES ('MB', 'Canada');
INSERT INTO Pays VALUES ('NB', 'Canada');
INSERT INTO Pays VALUES ('NL', 'Canada');
INSERT INTO Pays VALUES ('NT', 'Canada');
INSERT INTO Pays VALUES ('NS', 'Canada');
INSERT INTO Pays VALUES ('NU', 'Canada');
INSERT INTO Pays VALUES ('ON', 'Canada');
INSERT INTO Pays VALUES ('PE', 'Canada');
INSERT INTO Pays VALUES ('QC', 'Canada');
INSERT INTO Pays VALUES ('SK', 'Canada');
INSERT INTO Pays VALUES ('YT', 'Canada');
