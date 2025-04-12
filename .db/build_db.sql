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


CREATE TABLE IF NOT EXISTS Fournisseurs (fid int PRIMARY KEY, nom_four varchar(30));

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


CREATE TABLE IF NOT EXISTS Entrepots (eid int PRIMARY KEY, rue_entre varchar(60), ville_entre varchar(30), code_postal_entre char(6), province_entre enum('BC', 'ON', 'QC'), pays_entre varchar(20));

INSERT INTO Entrepots VALUES (1, '7607 Main St', 'Toronto', 'A1A1A1', 'ON', 'Canada');
INSERT INTO Entrepots VALUES (2, '64 Broadway', 'Vancouver', 'B2B2B2', 'BC', 'Canada');
INSERT INTO Entrepots VALUES (3, '78 King St', 'Montreal', 'C3C3C3', 'QC', 'Canada');


CREATE TABLE IF NOT EXISTS Utilisateurs (uid int NOT NULL AUTO_INCREMENT PRIMARY KEY, courriel_util varchar(100) NOT NULL UNIQUE, prenom_util varchar(30) NOT NULL, nom_util varchar(30) NOT NULL, rue_util varchar(60), ville_util varchar(30), code_postal_util char(6), province_util enum('AB','BC','MB','NB','NL','NT','NS','NU','ON','PE','QC','SK','YT'), pays_util varchar(20), telephone_util bigint, eid_util int, FOREIGN KEY (eid_util) REFERENCES Entrepots(eid));

INSERT INTO Utilisateurs VALUES (1, 'john.doe@gmail.com', 'john', 'doe', '142 Heritage Dr', 'Waterloo', 'E4E4E4', 'ON', 'Canada', 2041234567, 2);
INSERT INTO Utilisateurs VALUES (2, 'sarah_92@yahoo.com', 'sarah', 'doe', '9875 Stonebridge Ln', 'Thunder Bay', 'G5G5G5', 'ON', 'Canada', 2049876543, 1);
INSERT INTO Utilisateurs VALUES (3, 'michael123@hotmail.com', 'michael', 'doe', '9074 Horizon Blvd', 'Barrie', 'H6H6H6', 'ON', 'Canada', 3062345678, 2);
INSERT INTO Utilisateurs VALUES (4, 'emma.watson@outlook.com', 'emma', 'watson', '15 Silver Birch Ave', 'Sudbury', 'J7J7J7', 'ON', 'Canada', 3068765432, 2);
INSERT INTO Utilisateurs VALUES (5, 'david.smith@icloud.com', 'david', 'smith', '2987 Windermere Rd', 'Laval', 'K8K8K8', 'QC', 'Canada', 4033456789, 2);
INSERT INTO Utilisateurs VALUES (6, 'charlie_brown@aol.com', 'charlie', 'brown', '2310 Blueberry Ln', 'Sherbrooke', 'L9L9L9', 'QC', 'Canada', 4037654321, 2);
INSERT INTO Utilisateurs VALUES (7, 'olivia.jones@gmail.com', 'olivia', 'jones', '2097 Redwood Dr', 'Trois-Rivières', 'M1M1M1', 'QC', 'Canada', 4164567890, 3);
INSERT INTO Utilisateurs VALUES (8, 'lucas_miller@yahoo.ca', 'lucas', 'miller', '76 Sycamore St', 'Saguenay', 'N2N2N2', 'QC', 'Canada', 4166543210, 1);
INSERT INTO Utilisateurs VALUES (9, 'sophia_wilson@hotmail.com', 'sophia', 'wilson', '54 Ashwood Ave', 'Gatineau', 'P3P3P3', 'QC', 'Canada', 4185678901, 1);
INSERT INTO Utilisateurs VALUES (10, 'liam.anderson@protonmail.com', 'liam', 'anderson', '1-87 Juniper St', 'Saint John', 'R4R4R4', 'NB', 'Canada', 4185432109, 1);
INSERT INTO Utilisateurs VALUES (11, 'noah_thomas@live.com', 'noah', 'thomas', '78A Magnolia Ct', 'Moncton', 'S5S5S5', 'NB', 'Canada', 5146789012, 2);
INSERT INTO Utilisateurs VALUES (12, 'isabella.moore@ymail.com', 'isabella', 'moore', '3456 Firwood Dr', 'Drummondville', 'T6T6T6', 'QC', 'Canada', 5144321098, 1);
INSERT INTO Utilisateurs VALUES (13, 'ethan.harris@gmail.com', 'ethan', 'harris', '876 Evergreen Blvd', 'Granby', 'V7V7V7', 'QC', 'Canada', 6047890123, 1);
INSERT INTO Utilisateurs VALUES (14, 'ava_clark@yahoo.com', 'ava', 'clark', '8001 Orchard Ln', 'Belleville', 'X8X8X8', 'ON', 'Canada', 6043210987, 3);
INSERT INTO Utilisateurs VALUES (15, 'james_walker@outlook.com', 'james', 'walker', '743 Meadowbrook Rd', 'Chilliwack', 'Y9Y9Y9', 'BC', 'Canada', 6138901234, 3);
INSERT INTO Utilisateurs VALUES (16, 'mia.rodriguez@hotmail.com', 'mia', 'rodriguez', '124 Foxglove Dr', 'Red Deer', 'A2B3C4', 'AB', 'Canada', 6132109876, 1);
INSERT INTO Utilisateurs VALUES (17, 'benjamin_hall@icloud.com', 'benjamin', 'hall', '3256 Crimson Maple Rd', 'Lethbridge', 'D5E6F7', 'AB', 'Canada', 9029012345, 2);
INSERT INTO Utilisateurs VALUES (18, 'amelia.young@gmail.com', 'amelia', 'young', '12 Summit Ave', 'Medicine Hat', 'G8H9J1', 'AB', 'Canada', 9021098765, 2);
INSERT INTO Utilisateurs VALUES (19, 'alexander.king@yahoo.ca', 'alexander', 'king', '4 Starview Ln', 'Prince George', 'K2L3M4', 'BC', 'Canada', 4036783456, 1);
INSERT INTO Utilisateurs VALUES (20, 'charlotte.scott@live.com', 'charlotte', 'scott', '27 Northgate Dr', 'Sault Ste. Marie', 'N5P6R7', 'ON', 'Canada', 4169876543, 2);


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


CREATE TABLE IF NOT EXISTS Produits (pid int PRIMARY KEY, nom_prod varchar(50), prix_prod decimal(5, 2), unite_prod int, categorie_prod enum('Aliment', 'Automobile', 'Électronique', 'Jouet', 'Maison', 'Vêtements', 'Cosmétiques'), description_prod varchar(500), image_prod varchar(200), vedette bool, fid int NOT NULL, FOREIGN KEY (fid) REFERENCES Fournisseurs(fid));

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
INSERT INTO produits VALUES (984396, 'Shampooing & Revitalisant 2 en 1 pine mint', 13.99, 15, 'Cosmétiques', 'Notre tout nouveau Shampooing & Revitalisant 2 en 1 100 % naturel est un mélange parfait des meilleurs ingrédients de la nature pour vous offrir une expérience de soins capillaires extraordinaire. Comme une promenade au cœur de la forêt boréale canadienne. Une combinaison de pin frais, de gaulthérie et de menthe rafraîchissante.', 'product984396.webp', False, 17536);


CREATE TABLE IF NOT EXISTS Panier (uid int NOT NULL, pid int NOT NULL, qte int NOT NULL, FOREIGN KEY (uid) REFERENCES Utilisateurs(uid), FOREIGN KEY (pid) REFERENCES Produits(pid));

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


CREATE TABLE IF NOT EXISTS Commandes (cid int PRIMARY KEY, date_comm date, prix_total_comm decimal(6, 2), rue_comm varchar(60), ville_comm varchar(30), code_postal_comm char(6), province_comm enum('AB', 'BC', 'MB', 'NB', 'NL', 'NT', 'NS', 'NU', 'ON', 'PE', 'QC', 'SK', 'YT'), pays_comm varchar(20), uid int NOT NULL, FOREIGN KEY (uid) REFERENCES Utilisateurs(uid));
CREATE TABLE IF NOT EXISTS LigneComms (cid int NOT NULL, pid int NOT NULL, quantite int, FOREIGN KEY (cid) REFERENCES Commandes(cid), FOREIGN KEY (pid) REFERENCES Produits(pid));

DELIMITER // #Nick
CREATE TRIGGER CalculerTotal BEFORE INSERT ON Commandes FOR EACH ROW
BEGIN
    DECLARE pid_p INT;
    DECLARE qte_p INT;
    DECLARE total DECIMAL(6, 2) DEFAULT 0;
    DECLARE lect_comp BOOL DEFAULT FALSE;

    DECLARE curs CURSOR FOR SELECT P.pid, P.qte FROM Panier P WHERE P.uid = NEW.uid;

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
END//
DELIMITER ;

INSERT INTO Commandes VALUES (1, '2025-01-16', NULL, '24 Queen St', 'Calgary', 'S8T9V1', 'QC', 'Canada', 14);
INSERT INTO Commandes VALUES (2, '2025-01-17', NULL, '5637 Maple Ave', 'Edmonton', 'X2Y3A4', 'QC', 'Canada', 2);
INSERT INTO Commandes VALUES (3, '2025-01-18', NULL, '2409 Elm St', 'Ottawa', 'B5C6D7', 'QC', 'Canada', 17);
INSERT INTO Commandes VALUES (4, '2025-01-19', NULL, '546 Cedar Rd', 'Winnipeg', 'E8F9G1', 'QC', 'Canada', 18);
INSERT INTO Commandes VALUES (5, '2025-01-20', NULL, '234 Pine Dr', 'Quebec City', 'H2J3K4', 'QC', 'Canada', 11);
INSERT INTO Commandes VALUES (6, '2025-01-21', NULL, '901 Oak Blvd', 'Halifax', 'L5M6N7', 'QC', 'Canada', 1);
INSERT INTO Commandes VALUES (7, '2025-01-22', NULL, '234 Birch Ln', 'Victoria', 'P8R9S1', 'QC', 'Canada', 15);
INSERT INTO Commandes VALUES (8, '2025-01-25', NULL, '17 Spruce Ct', 'Saskatoon', 'T2V3X4', 'QC', 'Canada', 6);
INSERT INTO Commandes VALUES (9, '2025-01-26', NULL, '23 Willow Way', 'Regina', 'Y5A6B7', 'QC', 'Canada', 9);
INSERT INTO Commandes VALUES (10, '2025-01-27', NULL, '80 Chestnut St', 'St John', 'C8D9E1', 'QC', 'Canada', 19);
INSERT INTO Commandes VALUES (11, '2025-01-29', NULL, '21 River Rd', 'Charlottetown', 'F2G3H4', 'QC', 'Canada', 10);
INSERT INTO Commandes VALUES (12, '2025-01-30', NULL, '24 Sunset Ave', 'Fredericton', 'J5K6L7', 'QC', 'Canada', 20);
INSERT INTO Commandes VALUES (13, '2025-02-01', NULL, '56 Highland Dr', 'Whitehorse', 'M8N9P1', 'QC', 'Canada', 13);
INSERT INTO Commandes VALUES (14, '2025-02-02', NULL, '34 Lakeshore Rd', 'Yellowknife', 'R2S3T4', 'QC', 'Canada', 5);
INSERT INTO Commandes VALUES (15, '2025-02-02', NULL, '94 Victoria St', 'Iqaluit', 'V5X6Y7', 'QC', 'Canada', 7);
INSERT INTO Commandes VALUES (16, '2025-02-04', NULL, '129 Church St', 'Mississauga', 'A8B9C1', 'QC', 'Canada', 4);
INSERT INTO Commandes VALUES (17, '2025-02-06', NULL, '1 Front St', 'Brampton', 'D2E3F4', 'QC', 'Canada', 3);
INSERT INTO Commandes VALUES (18, '2025-02-08', NULL, '23 Bay St', 'Hamilton', 'G5H6J7', 'QC', 'Canada', 8);
INSERT INTO Commandes VALUES (19, '2025-02-11', NULL, '61 Water St', 'Kitchener', 'K8L9M1', 'QC', 'Canada', 12);
INSERT INTO Commandes VALUES (20, '2025-02-14', NULL, '700 Park Ave', 'London', 'N2P3R4', 'QC', 'Canada', 16);


#PART 2
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

INSERT INTO Commandes VALUES (21, '2025-02-16', NULL, '32 Mountain Rd', 'Markham', 'S5T6V7', 'QC', 'Canada', 11);
INSERT INTO Commandes VALUES (22, '2025-02-26', NULL, '44 Valley View Dr', 'Vaughan', 'X8Y9A1', 'QC', 'Canada', 20);
INSERT INTO Commandes VALUES (23, '2025-03-02', NULL, '1122 College St', 'Surrey', 'B2C3D4', 'QC', 'Canada', 15);
INSERT INTO Commandes VALUES (24, '2025-03-03', NULL, '9021 University Ave', 'Burnaby', 'E5F6G7', 'QC', 'Canada', 14);
INSERT INTO Commandes VALUES (25, '2025-03-08', NULL, '11 Railway Ave', 'Richmond', 'H8J9K1', 'QC', 'Canada', 7);
INSERT INTO Commandes VALUES (26, '2025-03-10', NULL, '80 Harbour St', 'Abbotsford', 'L2M3N4', 'QC', 'Canada', 8);
INSERT INTO Commandes VALUES (27, '2025-03-11', NULL, '32 Meadow Ln', 'Kelowna', 'P5R6S7', 'QC', 'Canada', 13);INSERT INTO Commandes VALUES (28, '2025-03-12', NULL, '74 Glenwood Dr', 'Kamloops', 'T8V9X1', 'QC', 'Canada', 2);
INSERT INTO Commandes VALUES (29, '2025-03-14', NULL, '999 Country Club Rd', 'Nanaimo', 'Y2A3B4', 'QC', 'Canada', 4);
INSERT INTO Commandes VALUES (30, '2025-03-15', NULL, '542 College St', 'Guelph', 'C5D6E7', 'QC', 'Canada', 6);


CREATE TABLE IF NOT EXISTS Livraisons (lid int PRIMARY KEY, date_livr date, transporteur_livr enum('Intelcom', 'Poste Canada', 'Purolator'), cid int NOT NULL, eid int NOT NULL, FOREIGN KEY (cid) REFERENCES Commandes(cid), FOREIGN KEY (eid) REFERENCES Entrepots(eid));

INSERT INTO Livraisons VALUES (1, '2025-01-19', 'Intelcom', 1, 1);
INSERT INTO Livraisons VALUES (2, '2025-01-20', 'Poste Canada', 2, 2);
INSERT INTO Livraisons VALUES (3, '2025-01-21', 'Purolator', 2, 1);
INSERT INTO Livraisons VALUES (4, '2025-01-22', 'Intelcom', 3, 3);
INSERT INTO Livraisons VALUES (5, '2025-01-22', 'Intelcom', 4, 2);
INSERT INTO Livraisons VALUES (6, '2025-01-23', 'Poste Canada', 5, 1);
INSERT INTO Livraisons VALUES (7, '2025-01-23', 'Purolator', 5, 2);
INSERT INTO Livraisons VALUES (8, '2025-01-24', 'Poste Canada', 6, 3);
INSERT INTO Livraisons VALUES (9, '2025-01-28', 'Intelcom', 7, 1);
INSERT INTO Livraisons VALUES (10, '2025-01-28', 'Poste Canada', 8, 3);
INSERT INTO Livraisons VALUES (11, '2025-01-29', 'Purolator', 8, 2);
INSERT INTO Livraisons VALUES (12, '2025-01-30', 'Purolator', 9, 1);
INSERT INTO Livraisons VALUES (13, '2025-02-01', 'Intelcom', 10, 3);
INSERT INTO Livraisons VALUES (14, '2025-02-01', 'Poste Canada', 10, 2);
INSERT INTO Livraisons VALUES (15, '2025-02-03', 'Purolator', 11, 1);
INSERT INTO Livraisons VALUES (16, '2025-02-05', 'Intelcom', 12, 2);
INSERT INTO Livraisons VALUES (17, '2025-02-05', 'Intelcom', 12, 3);
INSERT INTO Livraisons VALUES (18, '2025-02-06', 'Poste Canada', 13, 2);
INSERT INTO Livraisons VALUES (19, '2025-02-08', 'Purolator', 14, 2);
INSERT INTO Livraisons VALUES (20, '2025-02-10', 'Poste Canada', 14, 1);
INSERT INTO Livraisons VALUES (21, '2025-02-16', 'Intelcom', 15, 2);
INSERT INTO Livraisons VALUES (22, '2025-02-17', 'Poste Canada', 16, 1);
INSERT INTO Livraisons VALUES (23, '2025-02-20', 'Purolator', 16, 3);
INSERT INTO Livraisons VALUES (24, '2025-03-01', 'Purolator', 17, 2);
INSERT INTO Livraisons VALUES (25, '2025-03-06', 'Intelcom', 18, 1);
INSERT INTO Livraisons VALUES (26, '2025-03-06', 'Poste Canada', 19, 2);
INSERT INTO Livraisons VALUES (27, '2025-03-12', 'Purolator', 20, 2);
INSERT INTO Livraisons VALUES (28, '2025-03-13', 'Intelcom', 20, 3);
INSERT INTO Livraisons VALUES (29, '2025-03-14', 'Intelcom', 21, 1);
INSERT INTO Livraisons VALUES (30, '2025-03-16', 'Poste Canada', 22, 1);
INSERT INTO Livraisons VALUES (31, '2025-03-19', 'Purolator', 22, 2);
INSERT INTO Livraisons VALUES (32, '2025-03-18', 'Poste Canada', 23, 3);
INSERT INTO Livraisons VALUES (33, '2025-03-20', 'Intelcom', 24, 2);
INSERT INTO Livraisons VALUES (34, '2025-03-22', 'Poste Canada', 25, 1);
INSERT INTO Livraisons VALUES (35, '2025-03-24', 'Purolator', 26, 2);
INSERT INTO Livraisons VALUES (36, '2025-03-25', 'Purolator', 26, 1);
INSERT INTO Livraisons VALUES (37, '2025-03-27', 'Intelcom', 27, 2);
INSERT INTO Livraisons VALUES (38, '2025-03-27', 'Poste Canada', 28, 1);
INSERT INTO Livraisons VALUES (39, '2025-03-28', 'Purolator', 29, 3);
INSERT INTO Livraisons VALUES (40, '2025-03-29', 'Poste Canada', 30, 2);


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
INSERT INTO DispoProds VALUES (1, 123234, 2);
INSERT INTO DispoProds VALUES (3, 789890, 6);
INSERT INTO DispoProds VALUES (2, 789890, 15);
INSERT INTO DispoProds VALUES (1, 789890, 1);
INSERT INTO DispoProds VALUES (3, 901890, 5);
INSERT INTO DispoProds VALUES (2, 901890, 8);
INSERT INTO DispoProds VALUES (1, 901890, 4);
INSERT INTO DispoProds VALUES (3, 456012, 3);
INSERT INTO DispoProds VALUES (2, 456012, 0);
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
INSERT INTO DispoProds VALUES (3, 123789, 10);
INSERT INTO DispoProds VALUES (2, 123789, 10);
INSERT INTO DispoProds VALUES (1, 123789, 13);
INSERT INTO DispoProds VALUES (3, 789345, 10);
INSERT INTO DispoProds VALUES (2, 789345, 14);
INSERT INTO DispoProds VALUES (1, 789345, 12);
INSERT INTO DispoProds VALUES (3, 901456, 14);
INSERT INTO DispoProds VALUES (2, 901456, 9);
INSERT INTO DispoProds VALUES (1, 901456, 13);
INSERT INTO DispoProds VALUES (3, 345456, 8);
INSERT INTO DispoProds VALUES (2, 345456, 2);
INSERT INTO DispoProds VALUES (1, 345456, 13);
INSERT INTO DispoProds VALUES (3, 123567, 2);
INSERT INTO DispoProds VALUES (2, 123567, 2);
INSERT INTO DispoProds VALUES (1, 123567, 4);
INSERT INTO DispoProds VALUES (3, 123901, 7);
INSERT INTO DispoProds VALUES (2, 123901, 14);
INSERT INTO DispoProds VALUES (1, 123901, 3);
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
INSERT INTO DispoProds VALUES (2, 901678, 3);
INSERT INTO DispoProds VALUES (1, 901678, 4);
INSERT INTO DispoProds VALUES (3, 456234, 9);
INSERT INTO DispoProds VALUES (2, 456234, 2);
INSERT INTO DispoProds VALUES (1, 456234, 0);
INSERT INTO DispoProds VALUES (3, 456567, 1);
INSERT INTO DispoProds VALUES (2, 456567, 13);
INSERT INTO DispoProds VALUES (1, 456567, 2);
INSERT INTO DispoProds VALUES (3, 456789, 9);
INSERT INTO DispoProds VALUES (2, 456789, 12);
INSERT INTO DispoProds VALUES (1, 456789, 3);
INSERT INTO DispoProds VALUES (3, 234567, 3);
INSERT INTO DispoProds VALUES (2, 234567, 5);
INSERT INTO DispoProds VALUES (1, 234567, 14);
INSERT INTO DispoProds VALUES (3, 729015, 10);
INSERT INTO DispoProds VALUES (2, 729015, 9);
INSERT INTO DispoProds VALUES (1, 729015, 13);
INSERT INTO DispoProds VALUES (3, 890123, 8);
INSERT INTO DispoProds VALUES (2, 890123, 7);
INSERT INTO DispoProds VALUES (1, 890123, 4);
INSERT INTO DispoProds VALUES (3, 901238, 1);
INSERT INTO DispoProds VALUES (2, 901238, 13);
INSERT INTO DispoProds VALUES (1, 901238, 1);
INSERT INTO DispoProds VALUES (3, 123456, 5);
INSERT INTO DispoProds VALUES (2, 123456, 6);
INSERT INTO DispoProds VALUES (1, 123456, 9);
INSERT INTO DispoProds VALUES (3, 567123, 14);
INSERT INTO DispoProds VALUES (2, 567123, 4);
INSERT INTO DispoProds VALUES (1, 567123, 0);
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
INSERT INTO dispoprods (eid, pid, quantite) VALUES (1, 984396, 5), (2, 984396, 5), (3, 984396, 5);
