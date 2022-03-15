-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 15, 2022 at 02:15 PM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.2

CREATE DATABASE `greengarden` /*!40100 COLLATE 'utf8mb4_general_ci' */;
USE greengarden;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `greengarden`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE ` afficherClientSpe` (IN `id` INT)  BEGIN

SELECT * FROM client,commercial WHERE client.commercial_num = commercial.commercial_num AND client_num = id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `afficherClientCom` (IN `com` INT)  BEGIN

SELECT * FROM client,commercial WHERE commercial.Commercial_num = client.Commercial_num AND client.Commercial_num = com;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `afficherClients` ()  BEGIN
SELECT * FROM client;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `afficherEcartDate` (IN `com` INT)  BEGIN

select DATEDIFF(facture.Facture_date,commande.Commande_date) AS diffDate 
FROM commande,facture 
WHERE commande.commande_num = facture.commande_num
AND commande.commande_num = com;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `afficherEtat` (IN `com` INT)  BEGIN
SELECT Commande_etat FROM commande WHERE commande_num = com;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ajouterArticle` (IN `ref` INT, IN `photo` VARCHAR(50), IN `puht` INT, IN `libCourt` VARCHAR(50), IN `libLong` VARCHAR(50), IN `cat` INT, IN `quant` INT, IN `fourn` VARCHAR(50))  BEGIN

DECLARE numArticle INT;

INSERT INTO article VALUES ("",ref,photo,puht,libCourt,libLong,cat);
SELECT Article_num into numArticle FROM article ORDER BY article_num ASC limit 1;

INSERT INTO stock VALUES ("",quant,fourn,numArticle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ajouterCommande` (IN `idCommande` INT, IN `idUser` INT, IN `idArticle` INT, IN `quantite` INT)  BEGIN

INSERT INTO acheter VALUES (idCommande,idUser,idArticle,quantite);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ajouterParticulier` (IN `nom` VARCHAR(50), IN `prenom` VARCHAR(50), IN `tel` INT, IN `mail` VARCHAR(50), IN `sexe` VARCHAR(50), IN `pseudo` VARCHAR(50), IN `news` VARCHAR(50), IN `mdp` VARCHAR(50), IN `cp` INT, IN `adresse` VARCHAR(50))  BEGIN

DECLARE com INT;
SELECT commercial_num into com FROM commercial_dispo;

INSERT INTO client VALUES ("",nom,prenom,tel,mail,sexe,pseudo,news,mdp,cp,adresse,com);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ajouterPro` (IN `nom` VARCHAR(50), IN `prenom` VARCHAR(50), IN `tel` INT, IN `mail` VARCHAR(50), IN `sexe` VARCHAR(50), IN `pseudo` VARCHAR(50), IN `news` VARCHAR(50), IN `mdp` VARCHAR(50), IN `cp` INT, IN `adresse` VARCHAR(50))  BEGIN

DECLARE com INT;
SELECT commercial_num into com FROM commercial_dispo;

INSERT INTO client VALUES ("",nom,prenom,tel,mail,sexe,pseudo,news,mdp,cp,adresse,com);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `chiffreAffaires` ()  BEGIN

SELECT stock_fournisseur,sum(article.article_puht * acheter_quantite) AS chiffre_affaires
FROM stock,article,acheter 
WHERE stock.article_num = article.article_num 
AND article.article_num = acheter.article_num
GROUP BY stock_fournisseur;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `creerCommande` ()  BEGIN

INSERT INTO commande VALUES ("", DATE( NOW() ), "en cours");

SELECT * FROM commande ORDER BY commande_num DESC LIMIT 1;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editerFacture` (IN `cli` INT, IN `com` INT, IN `adresse` VARCHAR(50), IN `nego` INT)  BEGIN

DECLARE somme_reglement int;
DECLARE id_com int;

SELECT commande_num INTO id_com FROM acheter WHERE commande_num = com AND Client_num = cli GROUP BY commande_num;

SELECT SUM(acheter_quantite * article_puht) INTO somme_reglement FROM acheter,article WHERE acheter.article_num = article.article_num AND client_num = cli AND commande_num = com;

INSERT INTO facture VALUES ("",DATE( NOW() ),adresse,somme_reglement,nego,id_com);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editerLivraison` (IN `adresse` VARCHAR(50), IN `com` INT)  BEGIN

INSERT INTO livraison VALUES ("",adresse,DATE( NOW() ),com);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listeChiffreType` ()  BEGIN

SELECT client.Coeff_num, SUM(acheter.acheter_quantite * article.Article_puht) AS total
FROM client,acheter,article 
WHERE client.Client_num = acheter.Client_num
AND article.Article_num = acheter.Article_num
GROUP BY coeff_num;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listeCommandeClient` (IN `cli` INT)  BEGIN

SELECT commande.Commande_date,client.Client_num,facture.Facture_reglement,commande.Commande_etat FROM commande,client,facture,acheter 
WHERE facture.commande_num = commande.commande_num
AND commande.commande_num = acheter.commande_num
AND acheter.client_num = client.Client_num
AND client.client_num = cli
GROUP by client_num;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listePourAnnee` (IN `annee` INT)  BEGIN

SELECT article.article_ref,article.Article_libelle_court,acheter.acheter_quantite,stock.Stock_fournisseur 
FROM stock,acheter,article,commande 
WHERE stock.Article_num = article.Article_num 
AND article.Article_num = acheter.Article_num 
AND acheter.commande_num = commande.commande_num 
AND year(commande.commande_date) = annee;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `majArticle` (IN `id` INT, IN `ref` INT, IN `photo` VARCHAR(50), IN `puht` INT, IN `libCourt` VARCHAR(50), IN `libLong` VARCHAR(50), IN `cat` INT, IN `quant` INT, IN `fourn` VARCHAR(50))  BEGIN

UPDATE article SET Article_ref = ref,
Article_photo = photo,
Article_puht = puht,
Article_libelle_court = libCourt,
Article_libelle_long = libLong,
categorie_num = cat
WHERE Article_num = id;

UPDATE stock SET Stock_quantite = quant,
Stock_fournisseur = fourn
WHERE Article_num = id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `majClient` (IN `id` INT, IN `nom` VARCHAR(50), IN `pre` VARCHAR(50), IN `tel` VARCHAR(50), IN `mail` VARCHAR(50), IN `sexe` VARCHAR(50), IN `pseudo` VARCHAR(50), IN `news` VARCHAR(50), IN `mdp` VARCHAR(50), IN `cp` INT, IN `adresse` VARCHAR(50), IN `coeff` INT, IN `com` INT)  BEGIN

UPDATE client SET 
CLient_nom = nom,
CLient_prenom = pre,
CLient_tel = tel,
CLient_email = mail,
CLient_sexe = sexe,
CLient_pseudo = pseudo,
CLient_news = news,
CLient_mdp = mdp,
Client_cp = cp,
CLient_adresse = adresse,
Coeff_num = coeff,
Commercial_num = com
WHERE Client_num = id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `supprimerArticle` (IN `art` INT)  BEGIN


DELETE FROM stock WHERE Article_num = art;
DELETE from article WHERE Article_num = art;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `supprimerClient` (IN `cli` INT)  BEGIN

DELETE from client WHERE client_num = cli;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `supprimerCommande` (IN `com` INT, IN `cli` INT)  BEGIN

DELETE FROM acheter WHERE commande_num = com and client_num = cli;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `acheter`
--

CREATE TABLE `acheter` (
  `commande_num` int(11) NOT NULL,
  `Client_num` int(11) NOT NULL,
  `Article_num` int(11) NOT NULL,
  `acheter_quantite` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `acheter`
--

INSERT INTO `acheter` (`commande_num`, `Client_num`, `Article_num`, `acheter_quantite`) VALUES
(2, 2, 7, 6),
(2, 2, 8, 2),
(2, 2, 16, 3),
(2, 2, 19, 5),
(2, 2, 32, 4),
(2, 2, 36, 5),
(2, 2, 38, 3),
(2, 2, 42, 7),
(2, 2, 45, 1),
(2, 2, 46, 9),
(6, 6, 3, 3),
(6, 6, 5, 7),
(6, 6, 16, 7),
(6, 6, 18, 2),
(6, 6, 24, 4),
(6, 6, 26, 8),
(6, 6, 38, 8),
(6, 6, 42, 7),
(6, 6, 43, 7),
(6, 6, 47, 6),
(10, 11, 3, 2),
(10, 11, 9, 7),
(10, 11, 13, 6),
(10, 11, 14, 7),
(10, 11, 17, 6),
(10, 11, 24, 1),
(10, 11, 27, 3),
(10, 11, 36, 2),
(10, 11, 44, 8),
(10, 11, 46, 8);

-- --------------------------------------------------------

--
-- Table structure for table `article`
--

CREATE TABLE `article` (
  `Article_num` int(11) NOT NULL,
  `Article_ref` int(11) DEFAULT NULL,
  `Article_photo` varchar(50) DEFAULT NULL,
  `Article_puht` int(11) DEFAULT NULL,
  `Article_libelle_court` varchar(50) DEFAULT NULL,
  `Article_libelle_long` varchar(50) DEFAULT NULL,
  `Categorie_num` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `article`
--

INSERT INTO `article` (`Article_num`, `Article_ref`, `Article_photo`, `Article_puht`, `Article_libelle_court`, `Article_libelle_long`, `Categorie_num`) VALUES
(1, 9959, 'https://yahoo.com', 8, 'vel, vulputate eu, odio. Phasellus', 'eleifend nec, malesuada ut, sem. Nulla interdum. C', 2),
(2, 7528, 'http://baidu.com', 12, 'pharetra nibh. Aliquam ornare, libero', 'sit amet ante. Vivamus non lorem vitae odio sagitt', 3),
(3, 5841, 'https://twitter.com', 19, 'lacus. Ut nec urna et', 'parturient montes, nascetur ridiculus mus. Proin v', 3),
(4, 1291, 'http://whatsapp.com', 10, 'sem. Nulla interdum. Curabitur dictum.', 'cursus non, egestas a, dui. Cras pellentesque. Sed', 5),
(5, 7330, 'http://facebook.com', 13, 'aliquet odio. Etiam ligula tortor,', 'ac nulla. In tincidunt congue turpis. In condiment', 4),
(6, 3811, 'http://youtube.com', 30, 'adipiscing lacus. Ut nec urna', 'amet, consectetuer adipiscing elit. Curabitur sed ', 3),
(7, 4567, 'https://yahoo.com', 13, 'ut erat. Sed nunc est,', 'mus. Proin vel arcu eu odio tristique pharetra. Qu', 3),
(8, 767, 'https://google.com', 23, 'lobortis quis, pede. Suspendisse dui.', 'Maecenas malesuada fringilla est. Mauris eu turpis', 4),
(9, 3156, 'http://bbc.co.uk', 29, 'risus. Donec egestas. Aliquam nec', 'fringilla ornare placerat, orci lacus vestibulum l', 2),
(10, 190, 'https://google.com', 19, 'purus gravida sagittis. Duis gravida.', 'cursus non, egestas a, dui. Cras pellentesque. Sed', 4),
(11, 1196, 'https://wikipedia.org', 24, 'Quisque libero lacus, varius et,', 'feugiat. Sed nec metus facilisis lorem tristique a', 1),
(12, 7979, 'http://wikipedia.org', 13, 'eget, volutpat ornare, facilisis eget,', 'suscipit nonummy. Fusce fermentum fermentum arcu. ', 2),
(13, 10690, 'https://baidu.com', 24, 'malesuada id, erat. Etiam vestibulum', 'ipsum dolor sit amet, consectetuer adipiscing elit', 1),
(14, 1577, 'http://zoom.us', 23, 'Nunc ullamcorper, velit in aliquet', 'natoque penatibus et magnis dis parturient montes,', 3),
(15, 164, 'https://pinterest.com', 29, 'tortor. Integer aliquam adipiscing lacus.', 'eu nibh vulputate mauris sagittis placerat. Cras d', 4),
(16, 3513, 'https://bbc.co.uk', 7, 'ultrices, mauris ipsum porta elit,', 'sit amet ante. Vivamus non lorem vitae odio sagitt', 1),
(17, 8077, 'https://twitter.com', 29, 'lorem, sit amet ultricies sem', 'urna justo faucibus lectus, a sollicitudin orci se', 1),
(18, 4556, 'https://whatsapp.com', 29, 'libero at auctor ullamcorper, nisl', 'sodales purus, in molestie tortor nibh sit amet or', 1),
(19, 610, 'https://google.com', 25, 'scelerisque dui. Suspendisse ac metus', 'Donec est. Nunc ullamcorper, velit in aliquet lobo', 2),
(20, 4338, 'http://instagram.com', 29, 'odio. Aliquam vulputate ullamcorper magna.', 'augue eu tellus. Phasellus elit pede, malesuada ve', 5),
(21, 223, 'http://baidu.com', 14, 'pede blandit congue. In scelerisque', 'Sed eu nibh vulputate mauris sagittis placerat. Cr', 3),
(22, 3762, 'https://guardian.co.uk', 13, 'sed sem egestas blandit. Nam', 'tempor diam dictum sapien. Aenean massa. Integer v', 3),
(23, 8674, 'https://naver.com', 9, 'netus et malesuada fames ac', 'quam, elementum at, egestas a, scelerisque sed, sa', 2),
(24, 1491, 'http://baidu.com', 13, 'sem eget massa. Suspendisse eleifend.', 'feugiat tellus lorem eu metus. In lorem. Donec ele', 3),
(25, 538, 'http://facebook.com', 21, 'eu, placerat eget, venenatis a,', 'velit egestas lacinia. Sed congue, elit sed conseq', 4),
(26, 6292, 'https://cnn.com', 17, 'orci lobortis augue scelerisque mollis.', 'rutrum lorem ac risus. Morbi metus. Vivamus euismo', 4),
(27, 3023, 'https://youtube.com', 10, 'ut dolor dapibus gravida. Aliquam', 'semper auctor. Mauris vel turpis. Aliquam adipisci', 2),
(28, 7901, 'https://cnn.com', 20, 'non, lobortis quis, pede. Suspendisse', 'Donec non justo. Proin non massa non ante bibendum', 5),
(29, 7795, 'http://pinterest.com', 24, 'in faucibus orci luctus et', 'sit amet, faucibus ut, nulla. Cras eu tellus eu au', 5),
(30, 4467, 'http://baidu.com', 12, 'fringilla mi lacinia mattis. Integer', 'Mauris blandit enim consequat purus. Maecenas libe', 1),
(31, 4482, 'https://yahoo.com', 22, 'mauris, rhoncus id, mollis nec,', 'neque. Nullam ut nisi a odio semper cursus. Intege', 3),
(32, 612, 'https://yahoo.com', 25, 'elit fermentum risus, at fringilla', 'Sed dictum. Proin eget odio. Aliquam vulputate ull', 3),
(33, 8030, 'http://twitter.com', 14, 'diam dictum sapien. Aenean massa.', 'iaculis nec, eleifend non, dapibus rutrum, justo. ', 2),
(34, 5119, 'https://google.com', 6, 'ut, nulla. Cras eu tellus', 'vulputate eu, odio. Phasellus at augue id ante dic', 2),
(35, 8688, 'https://cnn.com', 19, 'nonummy ultricies ornare, elit elit', 'tellus id nunc interdum feugiat. Sed nec metus fac', 3),
(36, 6583, 'http://wikipedia.org', 29, 'luctus sit amet, faucibus ut,', 'ultrices a, auctor non, feugiat nec, diam. Duis mi', 5),
(37, 4522, 'https://twitter.com', 6, 'cursus. Integer mollis. Integer tincidunt', 'convallis, ante lectus convallis est, vitae sodale', 2),
(38, 3795, 'http://bbc.co.uk', 12, 'condimentum eget, volutpat ornare, facilisis', 'lacinia. Sed congue, elit sed consequat auctor, nu', 4),
(39, 4047, 'https://baidu.com', 26, 'sagittis semper. Nam tempor diam', 'ipsum. Suspendisse sagittis. Nullam vitae diam. Pr', 2),
(40, 7052, 'http://google.com', 28, 'est ac mattis semper, dui', 'neque venenatis lacus. Etiam bibendum fermentum me', 3),
(41, 5793, 'https://netflix.com', 29, 'erat neque non quam. Pellentesque', 'aliquet molestie tellus. Aenean egestas hendrerit ', 5),
(42, 5867, 'https://twitter.com', 11, 'semper auctor. Mauris vel turpis.', 'purus sapien, gravida non, sollicitudin a, malesua', 4),
(43, 519, 'http://netflix.com', 20, 'et ipsum cursus vestibulum. Mauris', 'Fusce fermentum fermentum arcu. Vestibulum ante ip', 3),
(44, 4074, 'https://yahoo.com', 6, 'pede. Praesent eu dui. Cum', 'purus. Duis elementum, dui quis accumsan convallis', 3),
(45, 4447, 'http://pinterest.com', 17, 'sit amet, consectetuer adipiscing elit.', 'pede, malesuada vel, venenatis vel, faucibus id, l', 4),
(46, 6374, 'http://walmart.com', 22, 'euismod enim. Etiam gravida molestie', 'in aliquet lobortis, nisi nibh lacinia orci, conse', 2),
(47, 3520, 'http://bbc.co.uk', 8, 'condimentum eget, volutpat ornare, facilisis', 'ipsum. Phasellus vitae mauris sit amet lorem sempe', 2),
(48, 8872, 'https://nytimes.com', 20, 'Maecenas ornare egestas ligula. Nullam', 'eleifend egestas. Sed pharetra, felis eget varius ', 3),
(49, 1567, 'http://guardian.co.uk', 14, 'ligula. Aenean euismod mauris eu', 'Etiam ligula tortor, dictum eu, placerat eget, ven', 3),
(50, 6533, 'https://twitter.com', 25, 'mattis. Cras eget nisi dictum', 'Nunc sed orci lobortis augue scelerisque mollis. P', 2),
(51, 3861, 'https://zoom.us', 8, 'vel, vulputate eu, odio. Phasellus', 'at, velit. Pellentesque ultricies dignissim lacus.', 5),
(52, 8241, 'https://yahoo.com', 14, 'convallis est, vitae sodales nisi', 'amet, faucibus ut, nulla. Cras eu tellus eu augue ', 4),
(53, 7746, 'https://google.com', 18, 'erat. Vivamus nisi. Mauris nulla.', 'ultricies ligula. Nullam enim. Sed nulla ante, iac', 2),
(54, 1901, 'https://yahoo.com', 8, 'non, egestas a, dui. Cras', 'diam. Duis mi enim, condimentum eget, volutpat orn', 4),
(55, 8749, 'http://google.com', 6, 'sociis natoque penatibus et magnis', 'Nulla tempor augue ac ipsum. Phasellus vitae mauri', 3),
(56, 8445, 'http://reddit.com', 6, 'neque vitae semper egestas, urna', 'rutrum magna. Cras convallis convallis dolor. Quis', 3),
(57, 7550, 'https://walmart.com', 14, 'tempus eu, ligula. Aenean euismod', 'Morbi non sapien molestie orci tincidunt adipiscin', 4),
(58, 10575, 'http://instagram.com', 16, 'rhoncus. Proin nisl sem, consequat', 'cursus. Integer mollis. Integer tincidunt aliquam ', 4),
(59, 1435, 'https://ebay.com', 14, 'porttitor interdum. Sed auctor odio', 'Pellentesque tincidunt tempus risus. Donec egestas', 3),
(60, 5505, 'http://walmart.com', 26, 'mauris. Morbi non sapien molestie', 'turpis vitae purus gravida sagittis. Duis gravida.', 4),
(61, 827, 'https://instagram.com', 6, 'mauris, rhoncus id, mollis nec,', 'molestie. Sed id risus quis diam luctus lobortis. ', 2),
(62, 7952, 'https://ebay.com', 16, 'et magnis dis parturient montes,', 'vitae odio sagittis semper. Nam tempor diam dictum', 5),
(63, 3914, 'http://zoom.us', 13, 'nisl arcu iaculis enim, sit', 'metus. In nec orci. Donec nibh. Quisque nonummy ip', 3),
(64, 4381, 'http://youtube.com', 27, 'dis parturient montes, nascetur ridiculus', 'lorem, eget mollis lectus pede et risus. Quisque l', 5),
(65, 4541, 'http://facebook.com', 7, 'Nunc sollicitudin commodo ipsum. Suspendisse', 'feugiat. Lorem ipsum dolor sit amet, consectetuer ', 4),
(66, 36, 'https://zoom.us', 27, 'condimentum. Donec at arcu. Vestibulum', 'dolor. Fusce feugiat. Lorem ipsum dolor sit amet, ', 4),
(67, 1290, 'https://wikipedia.org', 9, 'nec orci. Donec nibh. Quisque', 'magna nec quam. Curabitur vel lectus. Cum sociis n', 1),
(68, 844, 'https://youtube.com', 25, 'quis, pede. Praesent eu dui.', 'Donec sollicitudin adipiscing ligula. Aenean gravi', 2),
(69, 641, 'http://youtube.com', 10, 'non nisi. Aenean eget metus.', 'Nunc sed orci lobortis augue scelerisque mollis. P', 2),
(70, 8387, 'https://baidu.com', 29, 'ullamcorper, nisl arcu iaculis enim,', 'Nunc mauris elit, dictum eu, eleifend nec, malesua', 4),
(71, 9537, 'http://instagram.com', 29, 'mi felis, adipiscing fringilla, porttitor', 'arcu. Aliquam ultrices iaculis odio. Nam interdum ', 4),
(72, 7837, 'https://netflix.com', 27, 'Phasellus vitae mauris sit amet', 'aliquet libero. Integer in magna. Phasellus dolor ', 3),
(73, 4944, 'http://wikipedia.org', 5, 'egestas ligula. Nullam feugiat placerat', 'faucibus orci luctus et ultrices posuere cubilia C', 5),
(74, 4687, 'https://netflix.com', 27, 'nonummy ultricies ornare, elit elit', 'venenatis a, magna. Lorem ipsum dolor sit amet, co', 3),
(75, 6555, 'https://facebook.com', 16, 'nibh dolor, nonummy ac, feugiat', 'elementum, lorem ut aliquam iaculis, lacus pede sa', 3),
(76, 4240, 'http://nytimes.com', 29, 'non nisi. Aenean eget metus.', 'mauris ipsum porta elit, a feugiat tellus lorem eu', 3),
(77, 10845, 'http://youtube.com', 21, 'neque vitae semper egestas, urna', 'facilisis, magna tellus faucibus leo, in lobortis ', 4),
(78, 1175, 'http://pinterest.com', 24, 'ipsum cursus vestibulum. Mauris magna.', 'orci tincidunt adipiscing. Mauris molestie pharetr', 2),
(79, 5972, 'https://zoom.us', 26, 'Aliquam ornare, libero at auctor', 'vulputate, nisi sem semper erat, in consectetuer i', 3),
(80, 7771, 'http://wikipedia.org', 10, 'neque non quam. Pellentesque habitant', 'non arcu. Vivamus sit amet risus. Donec egestas. A', 2),
(81, 9995, 'https://twitter.com', 22, 'volutpat. Nulla facilisis. Suspendisse commodo', 'luctus felis purus ac tellus. Suspendisse sed dolo', 4),
(82, 818, 'http://bbc.co.uk', 18, 'elit, dictum eu, eleifend nec,', 'senectus et netus et malesuada fames ac turpis ege', 5),
(83, 3149, 'http://ebay.com', 13, 'dui, semper et, lacinia vitae,', 'sem, vitae aliquam eros turpis non enim. Mauris qu', 2),
(84, 10474, 'http://yahoo.com', 30, 'senectus et netus et malesuada', 'Nullam velit dui, semper et, lacinia vitae, sodale', 4),
(85, 1439, 'https://baidu.com', 7, 'ipsum dolor sit amet, consectetuer', 'penatibus et magnis dis parturient montes, nascetu', 2),
(86, 10380, 'http://netflix.com', 29, 'volutpat. Nulla facilisis. Suspendisse commodo', 'lectus sit amet luctus vulputate, nisi sem semper ', 5),
(87, 10528, 'https://youtube.com', 10, 'sociis natoque penatibus et magnis', 'consequat auctor, nunc nulla vulputate dui, nec te', 5),
(88, 6431, 'http://reddit.com', 12, 'Mauris magna. Duis dignissim tempor', 'Vivamus nisi. Mauris nulla. Integer urna. Vivamus ', 5),
(89, 8767, 'https://instagram.com', 19, 'a, aliquet vel, vulputate eu,', 'rutrum eu, ultrices sit amet, risus. Donec nibh en', 5),
(90, 6930, 'https://netflix.com', 25, 'est ac mattis semper, dui', 'Etiam vestibulum massa rutrum magna. Cras convalli', 3),
(91, 1299, 'https://guardian.co.uk', 28, 'iaculis quis, pede. Praesent eu', 'nisi magna sed dui. Fusce aliquam, enim nec tempus', 3),
(92, 7689, 'http://naver.com', 17, 'Fusce feugiat. Lorem ipsum dolor', 'mattis ornare, lectus ante dictum mi, ac mattis ve', 3),
(93, 7688, 'http://netflix.com', 18, 'amet risus. Donec egestas. Aliquam', 'arcu. Vivamus sit amet risus. Donec egestas. Aliqu', 2),
(94, 10660, 'https://naver.com', 15, 'natoque penatibus et magnis dis', 'mi lorem, vehicula et, rutrum eu, ultrices sit ame', 4),
(95, 5803, 'https://twitter.com', 5, 'eu odio tristique pharetra. Quisque', 'feugiat metus sit amet ante. Vivamus non lorem vit', 1),
(96, 7875, 'https://pinterest.com', 23, 'eu eros. Nam consequat dolor', 'lacinia vitae, sodales at, velit. Pellentesque ult', 4),
(97, 10290, 'https://whatsapp.com', 10, 'auctor odio a purus. Duis', 'Fusce mollis. Duis sit amet diam eu dolor egestas ', 2),
(98, 9823, 'https://google.com', 11, 'ornare placerat, orci lacus vestibulum', 'egestas rhoncus. Proin nisl sem, consequat nec, mo', 1),
(99, 8297, 'http://whatsapp.com', 29, 'nulla. In tincidunt congue turpis.', 'molestie arcu. Sed eu nibh vulputate mauris sagitt', 2),
(100, 8810, 'https://pinterest.com', 10, 'tempor lorem, eget mollis lectus', 'ac libero nec ligula consectetuer rhoncus. Nullam ', 2);

-- --------------------------------------------------------

--
-- Stand-in structure for view `article_stock`
-- (See below for the actual view)
--
CREATE TABLE `article_stock` (
`Article_num` int(11)
,`Article_ref` int(11)
,`Article_photo` varchar(50)
,`Article_libelle_court` varchar(50)
,`Article_libelle_long` varchar(50)
,`Categorie_num` int(11)
,`Stock_quantite` varchar(50)
,`Stock_fournisseur` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `categorie`
--

CREATE TABLE `categorie` (
  `Categorie_num` int(11) NOT NULL,
  `Categorie_nom` varchar(50) DEFAULT NULL,
  `Categorie_num_1` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `categorie`
--

INSERT INTO `categorie` (`Categorie_num`, `Categorie_nom`, `Categorie_num_1`) VALUES
(1, 'ete', NULL),
(2, 'hiver', NULL),
(3, 'jardin', 1),
(4, 'exterieur', 2),
(5, 'jardin', 2);

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `Client_num` int(11) NOT NULL,
  `Client_nom` varchar(50) DEFAULT NULL,
  `Client_prenom` varchar(50) DEFAULT NULL,
  `Client_tel` varchar(50) DEFAULT NULL,
  `Client_email` varchar(50) DEFAULT NULL,
  `Client_sexe` varchar(50) DEFAULT NULL,
  `Client_pseudo` varchar(50) DEFAULT NULL,
  `Client_news` varchar(50) DEFAULT NULL,
  `Client_mdp` varchar(50) DEFAULT NULL,
  `Client_cp` int(11) DEFAULT NULL,
  `Client_adresse` varchar(50) DEFAULT NULL,
  `Coeff_num` int(11) DEFAULT NULL,
  `Commercial_num` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`Client_num`, `Client_nom`, `Client_prenom`, `Client_tel`, `Client_email`, `Client_sexe`, `Client_pseudo`, `Client_news`, `Client_mdp`, `Client_cp`, `Client_adresse`, `Coeff_num`, `Commercial_num`) VALUES
(1, 'Acton', 'Hop', '07 84 87 21 37', 'imperdiet.nec@yahoo.ca', 'False', 'Mark', 'false', 'XWX38OWU5CU', 85176, 'P.O. Box 542, 5069 Ante Ave', 1, 4),
(2, 'Dieter', 'Lucy', '04 27 74 52 68', 'rhoncus.nullam@outlook.edu', 'True', 'Damian', 'false', 'ONJ49KJS4QC', 26386, 'Ap #834-4354 Purus, Avenue', 1, 6),
(3, 'Travis', 'Maryam', '02 29 36 29 73', 'ut@yahoo.couk', 'True', 'Julie', 'false', 'TUN69KCO2QY', 86565, '806-2788 Quisque Street', 1, 2),
(4, 'Brett', 'Lee', '05 59 58 72 11', 'lacus.cras@hotmail.edu', 'False', 'Levi', 'true', 'HEO84SZP2QR', 67179, 'P.O. Box 814, 6797 Enim. St.', 2, 2),
(5, 'Rina', 'Bruno', '07 24 16 73 60', 'nunc.quisque@aol.edu', 'True', 'Ezekiel', 'true', 'ZNM70HRD5TB', 20662, 'P.O. Box 563, 9131 Lectus Avenue', 2, 2),
(6, 'Victor', 'Cecilia', '04 24 85 57 06', 'cubilia.curae.phasellus@protonmail.ca', 'True', 'Christen', 'true', 'ULX82MEU3XO', 42476, '9823 Eu Road', 1, 6),
(7, 'Victor', 'Keiko', '03 40 43 21 01', 'ligula.consectetuer.rhoncus@icloud.com', 'True', 'Robin', 'false', 'PLR29ZUV1YD', 73300, '427 Mauris Rd.', 1, 4),
(8, 'Wynter', 'Jayme', '07 64 20 55 64', 'scelerisque.neque@yahoo.org', 'False', 'Laura', 'false', 'WBD30RVT0HE', 50590, 'P.O. Box 175, 9415 Facilisis Street', 2, 7),
(9, 'Eve', 'Eagan', '06 79 44 14 23', 'metus.vivamus@icloud.ca', 'True', 'Damian', 'false', 'BBK13CRE9QT', 68091, '789-1886 Aliquam, Av.', 2, 4),
(10, 'Carla', 'Tashya', '06 16 44 01 34', 'erat@yahoo.edu', 'True', 'Isadora', 'true', 'ZGD65KAB2TO', 85170, 'Ap #520-4339 Ultrices Ave', 1, 7),
(11, 'Melissa', 'Kyla', '07 97 67 88 56', 'arcu.vestibulum.ante@protonmail.couk', 'True', 'Armando', 'true', 'RCT28HYJ3WQ', 19896, 'P.O. Box 330, 9300 Enim, Rd.', 2, 2),
(12, 'Keegan', 'Gwendolyn', '05 66 34 31 48', 'nulla.tincidunt@protonmail.ca', 'False', 'Rebecca', 'true', 'VLS19FEE3TB', 68227, '101-4948 Libero Street', 1, 2),
(13, 'Jana', 'Odessa', '01 75 26 47 25', 'sed.dictum.eleifend@outlook.edu', 'True', 'Hedley', 'false', 'MJC74TND1JV', 78923, '7714 Sed Av.', 1, 4),
(14, 'Kerry', 'Marcia', '02 34 25 72 30', 'elit.dictum@hotmail.com', 'False', 'Denton', 'true', 'QSA17BOS3KB', 52244, 'Ap #954-5900 Morbi Avenue', 2, 7),
(15, 'Caryn', 'Fulton', '07 76 09 88 66', 'iaculis.enim@aol.couk', 'False', 'Finn', 'true', 'ORZ44DDC8JM', 77361, 'Ap #227-7295 Lectus Rd.', 2, 2),
(16, 'Rogan', 'Guinevere', '02 71 51 92 21', 'purus.in.molestie@aol.edu', 'True', 'Paula', 'true', 'JEP95NXI2PB', 54280, 'Ap #736-6258 Orci St.', 2, 4),
(17, 'Clementine', 'Lee', '06 71 71 65 51', 'risus@aol.couk', 'True', 'Noelani', 'true', 'WIP34MFB9HN', 29957, '665-2400 Quisque Avenue', 2, 5),
(18, 'Elvis', 'Melanie', '07 70 87 54 20', 'aliquam.erat@protonmail.net', 'False', 'Unity', 'false', 'MES49DPW3HC', 45951, '901-7173 Eros Rd.', 1, 3),
(19, 'Plato', 'Tyrone', '05 52 88 24 64', 'justo.faucibus.lectus@google.org', 'False', 'Eliana', 'false', 'IOC92QLC7ND', 55115, 'Ap #450-1453 Sit Road', 1, 3),
(20, 'Morgan', 'Philip', '02 36 56 82 54', 'lacus@protonmail.net', 'False', 'Melinda', 'true', 'IHM25TUH2ON', 56173, '335-8741 Dolor Rd.', 2, 6),
(21, 'Aristotle', 'Berk', '03 67 58 85 69', 'dui.suspendisse@hotmail.com', 'True', 'Sylvia', 'true', 'CDB51HQG6HJ', 46667, 'P.O. Box 942, 3687 Dis Avenue', 2, 2),
(22, 'Naida', 'Quinn', '03 35 26 82 14', 'magna.duis@hotmail.net', 'True', 'Fitzgerald', 'true', 'KQF17FCS7IQ', 66972, '928-5259 Lacus. Rd.', 2, 7),
(23, 'Kieran', 'Neil', '05 62 45 21 16', 'nulla.semper@google.couk', 'False', 'Samson', 'true', 'OKG75PFG9NB', 92761, '358-455 Eros St.', 1, 3),
(24, 'Alma', 'Vaughan', '03 53 43 45 56', 'pede@aol.com', 'True', 'Aphrodite', 'false', 'XPZ74GEA1WW', 81813, 'Ap #837-6860 Urna. Avenue', 1, 3),
(25, 'Miranda', 'Garth', '09 97 95 34 15', 'donec.dignissim@google.org', 'True', 'Bell', 'false', 'UHK80XDZ6LH', 32291, 'Ap #223-3106 Tincidunt Road', 1, 7),
(26, 'Ethan', 'Pandora', '07 57 41 04 73', 'malesuada@protonmail.couk', 'True', 'Katell', 'false', 'NJB44GXT6FT', 79460, '649-2111 Quam. Road', 2, 3),
(27, 'Emerson', 'Cynthia', '07 26 76 20 34', 'nunc@hotmail.edu', 'True', 'Tanner', 'true', 'OXO16JJG6LJ', 76885, 'P.O. Box 212, 7854 Semper Avenue', 2, 4),
(28, 'Channing', 'Barry', '03 28 23 53 64', 'pede.praesent.eu@icloud.ca', 'True', 'Deacon', 'false', 'GUG64TBG7JX', 87904, 'P.O. Box 520, 2785 Venenatis Av.', 1, 2),
(29, 'Edan', 'Baxter', '06 25 59 18 73', 'magnis.dis.parturient@hotmail.com', 'True', 'Warren', 'true', 'YBV06WWB3YK', 57233, 'Ap #313-9301 Cum Rd.', 2, 3),
(30, 'Jacob', 'Carl', '05 92 05 75 34', 'magna@yahoo.couk', 'True', 'Craig', 'true', 'RXM30PEE0UV', 10980, '637 Nunc Avenue', 2, 1),
(31, 'Neil', 'Azalia', '05 14 45 30 22', 'nibh.lacinia@google.org', 'False', 'Marcia', 'false', 'IXB35PHQ3NK', 35912, '402-5297 Vulputate, St.', 2, 6),
(32, 'Kellie', 'Paki', '06 75 17 62 80', 'nec.orci@hotmail.ca', 'False', 'Ebony', 'false', 'COT21RNO3PY', 73938, '203-3959 Vitae St.', 1, 2),
(33, 'Maisie', 'Rhoda', '05 40 41 67 37', 'egestas@icloud.ca', 'True', 'Damian', 'false', 'LFW65OPR3BI', 45681, '901-9661 Magna, Av.', 2, 3),
(34, 'Phelan', 'Kamal', '08 77 46 31 45', 'nec.tellus@google.ca', 'False', 'Cullen', 'false', 'YYD71CRM5BN', 28859, '7379 Malesuada. Av.', 2, 2),
(35, 'Stewart', 'Galena', '05 17 94 39 74', 'tortor.at@protonmail.org', 'False', 'Dante', 'true', 'CVM11NOJ6ED', 80246, 'Ap #751-2842 Lacinia St.', 1, 2),
(36, 'Barclay', 'Gail', '02 11 98 40 33', 'vel.arcu@outlook.ca', 'True', 'Kirk', 'true', 'VDB67KXP5EO', 58920, '3460 Nec Rd.', 1, 2),
(37, 'Joshua', 'Shellie', '06 88 73 52 66', 'lacus.quisque@aol.net', 'True', 'Travis', 'true', 'QAW21UIU0BL', 82649, 'P.O. Box 532, 5715 Vivamus Avenue', 2, 4),
(38, 'Orli', 'Elmo', '07 47 20 45 84', 'cras@google.org', 'True', 'Piper', 'false', 'EPL53ESM6OV', 49252, '549-8535 Hendrerit Av.', 2, 4),
(39, 'Stuart', 'Cynthia', '04 27 49 65 76', 'nec.ante@hotmail.edu', 'True', 'Jena', 'false', 'ROQ16SBS8QF', 77379, '155-8603 Quis St.', 1, 3),
(40, 'Craig', 'Aristotle', '05 15 48 81 67', 'tincidunt@protonmail.couk', 'False', 'Marvin', 'false', 'FOQ74AXP2VV', 21919, 'Ap #190-3187 Maecenas St.', 1, 1),
(41, 'Fritz', 'Elvis', '02 11 46 88 84', 'cursus.integer@aol.org', 'True', 'Brittany', 'false', 'CQR27HOX4FT', 29286, '8763 Risus Rd.', 2, 3),
(42, 'Hamish', 'Pamela', '04 64 56 04 42', 'mollis.lectus.pede@google.org', 'False', 'Kiayada', 'true', 'ZBJ29PEO3ZM', 72545, 'Ap #627-6790 Cras Rd.', 2, 4),
(43, 'Logan', 'Walker', '09 09 91 65 65', 'nisi.cum@yahoo.org', 'False', 'Shea', 'false', 'GDD37DKQ2MT', 53318, '2374 Consectetuer, Road', 2, 4),
(44, 'Reuben', 'Wade', '04 68 93 28 97', 'et.libero@hotmail.ca', 'False', 'Justine', 'false', 'BUP82SQN7BS', 89318, '123-5580 Rutrum, Rd.', 1, 2),
(45, 'Faith', 'Janna', '03 73 32 01 79', 'ipsum@aol.edu', 'False', 'Deanna', 'false', 'UXT82DAO6NB', 29806, '7105 Lacus. Av.', 2, 2),
(46, 'Cecilia', 'Jack', '09 85 18 81 93', 'eu.elit.nulla@yahoo.net', 'False', 'Quinlan', 'true', 'VQF28NTX2OA', 84880, 'Ap #118-8083 Quam Avenue', 1, 5),
(47, 'Zelenia', 'Porter', '08 85 78 91 23', 'nunc.lectus.pede@hotmail.com', 'False', 'Grady', 'false', 'LVN54TKG3YJ', 37181, '3001 Laoreet St.', 1, 3),
(48, 'Travis', 'Joseph', '04 55 68 09 94', 'mauris@yahoo.edu', 'True', 'Colorado', 'true', 'TOE45DGS4YG', 86978, '878-7196 In, Av.', 1, 3),
(49, 'Chadwick', 'Mark', '06 48 37 48 50', 'velit@outlook.couk', 'True', 'Sage', 'true', 'DQV86QYX4YS', 72473, '3511 Accumsan St.', 2, 3),
(50, 'Berk', 'Aidan', '04 33 68 39 25', 'praesent@yahoo.edu', 'True', 'Quon', 'false', 'FFK98EIF8WX', 77578, '385-7100 Amet Avenue', 1, 7),
(51, 'Cullen', 'Davis', '07 57 43 36 49', 'ante.dictum.cursus@google.edu', 'False', 'Aiko', 'false', 'HUU33UXT2EK', 58173, 'Ap #902-4809 Bibendum Avenue', 2, 4),
(52, 'Athena', 'Rhiannon', '05 98 76 36 16', 'ante.dictum@icloud.org', 'False', 'Clementine', 'false', 'XNT15KED6YF', 86309, 'Ap #912-9977 Sapien. St.', 2, 4),
(53, 'Ferris', 'Honorato', '02 16 35 84 49', 'sem.magna@yahoo.ca', 'False', 'Tashya', 'true', 'IFJ42GYQ6AQ', 24773, '600-2210 Cras Avenue', 1, 7),
(54, 'Sylvester', 'Anjolie', '07 74 21 81 72', 'duis.volutpat@aol.edu', 'False', 'Rhoda', 'false', 'NMR83PJJ1IN', 67846, '309-6047 Non, St.', 2, 5),
(55, 'Ulysses', 'Bo', '08 48 45 87 35', 'nullam@aol.net', 'True', 'Vaughan', 'true', 'PQS90LUO0HJ', 16890, '3679 Eu Ave', 2, 5),
(56, 'Kitra', 'Daquan', '05 25 62 44 92', 'enim.nisl@yahoo.net', 'False', 'Steel', 'false', 'TLQ04EBH2UX', 87628, '464-4189 A, Avenue', 1, 2),
(57, 'Clio', 'Hadley', '06 24 30 56 68', 'dui.semper@aol.couk', 'True', 'Richard', 'false', 'XRZ28SUU2JX', 87383, '122-1409 Tincidunt, Avenue', 2, 7),
(58, 'Brody', 'Bryar', '02 00 48 56 81', 'sed.auctor@aol.com', 'True', 'Vladimir', 'false', 'OBT08JUS2OX', 88917, '8528 Sagittis. Street', 2, 2),
(59, 'Berk', 'Lois', '08 54 63 78 33', 'risus.in@outlook.ca', 'True', 'Hedda', 'false', 'TVY82ASK5QB', 75112, 'Ap #322-4785 Quisque St.', 1, 5),
(60, 'Francesca', 'Channing', '07 06 45 33 90', 'phasellus.libero@aol.edu', 'False', 'Griffin', 'true', 'MNZ11VJK0WA', 18105, 'Ap #377-4670 Nulla Street', 2, 4),
(61, 'Desiree', 'Rylee', '03 82 73 27 47', 'dui.cras@icloud.couk', 'True', 'Slade', 'false', 'XDL39KXU3FY', 62556, '555-5054 Conubia Av.', 1, 3),
(62, 'Grady', 'Alvin', '09 91 06 37 46', 'vel.nisl.quisque@icloud.couk', 'False', 'Jolie', 'true', 'GTO86AWE4YH', 88330, 'Ap #870-6760 Venenatis St.', 1, 7),
(63, 'Roary', 'Paki', '03 63 66 57 44', 'vehicula@hotmail.edu', 'True', 'Guy', 'true', 'UTT16SOJ7EU', 47530, 'Ap #668-4078 Sem Street', 1, 2),
(64, 'Nehru', 'Samantha', '01 08 07 64 46', 'quis@google.net', 'True', 'McKenzie', 'true', 'YOL84CWZ9SV', 59497, '888-7817 Massa Rd.', 1, 3),
(65, 'Dante', 'Mona', '08 50 91 66 14', 'aliquet@google.edu', 'False', 'Charity', 'true', 'FIC77NQA5QQ', 22575, 'P.O. Box 857, 8314 Odio. Rd.', 2, 4),
(66, 'Evelyn', 'Chaney', '06 16 20 94 01', 'non.dapibus.rutrum@hotmail.net', 'True', 'Mark', 'true', 'TKF43QQW8JR', 52784, 'Ap #576-2832 Lectus. Street', 1, 3),
(67, 'Caesar', 'Angela', '06 38 57 57 85', 'rhoncus.proin.nisl@protonmail.edu', 'True', 'Carson', 'true', 'RIB92JLX2XR', 27710, '1550 Tincidunt Rd.', 1, 1),
(68, 'Kadeem', 'Jasmine', '03 09 09 15 18', 'sit.amet@outlook.com', 'False', 'Bradley', 'false', 'QXT83QBP7XE', 21716, 'Ap #812-9024 Nulla. Street', 2, 3),
(69, 'Leandra', 'Caleb', '02 34 48 17 17', 'eros@aol.net', 'True', 'Julian', 'false', 'VZY54JVT3VW', 88641, 'Ap #855-4657 Turpis Road', 2, 4),
(70, 'Stella', 'Kai', '03 65 59 92 51', 'neque.vitae@yahoo.ca', 'True', 'Ian', 'true', 'HTS92YLM8RP', 87880, 'P.O. Box 820, 7423 Euismod Avenue', 1, 1),
(71, 'Ursula', 'Cassandra', '03 36 26 75 42', 'ac.nulla@aol.ca', 'False', 'Barbara', 'false', 'EFN11EVE5GF', 61901, '6563 Tincidunt Rd.', 2, 3),
(72, 'Anastasia', 'Stone', '07 46 70 28 30', 'bibendum.sed@aol.org', 'True', 'Hamish', 'true', 'GAK74YXM1PP', 92273, 'P.O. Box 177, 9166 Penatibus St.', 1, 5),
(73, 'Damon', 'Laura', '07 80 76 90 25', 'sociis@protonmail.couk', 'True', 'Ignatius', 'true', 'DHF91SOW8LB', 41147, 'Ap #715-9672 Ligula. Ave', 2, 6),
(74, 'Ivana', 'Nissim', '09 18 21 14 75', 'condimentum@hotmail.edu', 'True', 'Steven', 'false', 'LWM06PVH5RH', 62606, '373-5641 Sem Road', 2, 7),
(75, 'Keane', 'Branden', '05 75 58 52 35', 'luctus.sit.amet@hotmail.com', 'False', 'Jordan', 'true', 'LKT54TRY7BE', 53280, '581-3671 Nunc Street', 1, 2),
(76, 'Zachery', 'Rhoda', '07 48 25 39 40', 'lacus.ut.nec@outlook.org', 'False', 'Lewis', 'false', 'VSQ65SVT0NH', 75160, 'Ap #509-5785 Molestie Rd.', 1, 4),
(77, 'Brenden', 'Keaton', '03 52 82 43 68', 'eu@hotmail.org', 'True', 'Kennan', 'true', 'SHJ60QPJ9JK', 45932, '5246 Elit. Road', 1, 6),
(78, 'Merrill', 'Latifah', '05 38 27 85 21', 'eget.ipsum@yahoo.couk', 'True', 'Armando', 'false', 'HTP69IVQ9JK', 76454, 'Ap #966-6542 Ornare. Road', 1, 3),
(79, 'Karen', 'Ariana', '05 36 58 57 14', 'tellus.id@protonmail.net', 'False', 'John', 'false', 'IIP58BEP7IG', 53096, '493-325 Turpis Av.', 1, 2),
(80, 'Driscoll', 'Dai', '02 61 66 67 34', 'integer@protonmail.couk', 'False', 'Athena', 'false', 'BGQ43QDY7HG', 51191, '700-5702 Odio. Av.', 2, 4),
(81, 'Paul', 'Yuri', '07 68 08 09 57', 'risus.donec.nibh@google.couk', 'False', 'Beau', 'false', 'MQX52RQJ4QQ', 48087, 'P.O. Box 917, 8590 Elit Ave', 2, 3),
(82, 'Nero', 'Helen', '06 52 28 38 35', 'a.neque@protonmail.net', 'False', 'Hillary', 'true', 'VVF02JBV1BL', 44084, 'Ap #887-3547 Vel Street', 2, 6),
(83, 'Herrod', 'Henry', '09 67 79 10 82', 'accumsan.sed@aol.edu', 'False', 'Flavia', 'true', 'IPQ10YSY2EQ', 75854, '2318 Eu, Rd.', 2, 6),
(84, 'Odysseus', 'Carla', '08 08 26 92 84', 'aliquet.phasellus.fermentum@outlook.edu', 'True', 'Geraldine', 'false', 'UYU52NKC0ST', 25351, 'Ap #203-6299 Euismod Rd.', 1, 1),
(85, 'Jemima', 'Lois', '07 37 24 76 68', 'primis.in@icloud.org', 'False', 'Thaddeus', 'false', 'DGN90XDS0TP', 17058, 'Ap #326-5174 Cursus Road', 1, 5),
(86, 'Jada', 'Sharon', '08 02 88 58 67', 'sit@hotmail.org', 'True', 'Odette', 'true', 'YNS13SOT3DV', 45761, 'Ap #435-1567 Mollis St.', 2, 5),
(87, 'Quinn', 'Rinah', '04 12 83 32 84', 'ut.tincidunt@google.org', 'True', 'Rigel', 'true', 'UIG64BGL2JL', 34211, 'P.O. Box 583, 4294 Sem St.', 1, 6),
(88, 'Curran', 'Sebastian', '08 81 52 97 12', 'nisi.aenean.eget@google.edu', 'True', 'Ava', 'false', 'RUK83CTU5KU', 74822, 'Ap #633-9071 Non Rd.', 2, 5),
(89, 'Chanda', 'Merritt', '01 36 22 87 83', 'magnis.dis.parturient@yahoo.ca', 'True', 'Leonard', 'false', 'OLD17OUX4CQ', 69667, '402-3525 Dignissim St.', 2, 3),
(90, 'Inez', 'Lev', '04 48 85 54 82', 'orci@google.ca', 'False', 'Phelan', 'true', 'WLG74DBQ5SK', 92668, '713-3678 Sit Street', 2, 2),
(91, 'Coby', 'Kelly', '04 61 29 21 22', 'ut@icloud.edu', 'True', 'Eleanor', 'false', 'IWB00TAO0KQ', 90942, 'Ap #688-8129 Scelerisque, Street', 2, 7),
(92, 'Erin', 'Phelan', '07 67 33 94 94', 'vulputate.dui.nec@aol.com', 'False', 'Christopher', 'true', 'LNY34QTO0XN', 60665, 'P.O. Box 234, 8196 Nullam Av.', 2, 3),
(93, 'Nadine', 'Raya', '06 75 88 73 66', 'phasellus.in.felis@outlook.org', 'False', 'Kasper', 'false', 'LVE45KBG1LW', 11891, 'Ap #911-3000 Ante Rd.', 2, 6),
(94, 'Travis', 'Gil', '03 43 88 44 17', 'sed@google.edu', 'True', 'Kathleen', 'true', 'NMT72SLL6HM', 67553, 'Ap #547-9032 Natoque Av.', 2, 3),
(95, 'Blake', 'Rahim', '06 35 65 78 21', 'sit.amet@icloud.net', 'False', 'Lillian', 'true', 'CGY86ZNL4IX', 46147, 'P.O. Box 328, 7554 Elit. Rd.', 1, 5),
(96, 'Deirdre', 'Zahir', '05 67 72 76 17', 'ut@outlook.org', 'True', 'Echo', 'false', 'ZSG85SSD2PG', 32052, 'Ap #667-6199 Velit. Street', 2, 5),
(97, 'Moana', 'Bernard', '02 96 49 21 14', 'venenatis@google.com', 'False', 'Ingrid', 'false', 'VQN03CDH3TO', 85449, 'Ap #751-453 Sem. St.', 2, 7),
(98, 'Grant', 'Caldwell', '08 34 88 27 71', 'velit.sed@google.ca', 'False', 'Hamish', 'true', 'MQD65WYS1MA', 75530, '215-5991 Sed Rd.', 1, 2),
(99, 'Portia', 'Phoebe', '04 49 01 07 84', 'risus.nunc@hotmail.net', 'True', 'Elton', 'true', 'HIV61GBH2DX', 66225, '634-4015 Ultricies St.', 2, 5),
(100, 'Sopoline', 'Camille', '08 25 53 19 75', 'mollis@aol.com', 'True', 'Merritt', 'false', 'ICD07CYT2DA', 27524, '327 Turpis St.', 2, 2);

-- --------------------------------------------------------

--
-- Table structure for table `coefficient`
--

CREATE TABLE `coefficient` (
  `Coeff_num` int(11) NOT NULL,
  `coeff_tva` decimal(20,2) DEFAULT NULL,
  `coeff_coeff` decimal(20,2) DEFAULT NULL,
  `Coeff_type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `coefficient`
--

INSERT INTO `coefficient` (`Coeff_num`, `coeff_tva`, `coeff_coeff`, `Coeff_type`) VALUES
(1, '20.00', '1.00', 'particulier'),
(2, '5.50', '0.70', 'pro');

-- --------------------------------------------------------

--
-- Table structure for table `commande`
--

CREATE TABLE `commande` (
  `commande_num` int(11) NOT NULL,
  `Commande_date` date DEFAULT NULL,
  `Commande_etat` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `commande`
--

INSERT INTO `commande` (`commande_num`, `Commande_date`, `Commande_etat`) VALUES
(1, '2019-07-21', 'en cours'),
(2, '2015-06-21', 'en cours'),
(3, '2019-08-18', 'en cours'),
(4, '2017-04-17', 'en cours'),
(5, '2020-04-21', 'en cours'),
(6, '2017-04-19', 'en cours'),
(7, '2021-04-21', 'en cours'),
(8, '2018-04-18', 'en cours'),
(9, '2017-04-21', 'en cours'),
(10, '2012-09-20', 'en cours');

-- --------------------------------------------------------

--
-- Table structure for table `commercial`
--

CREATE TABLE `commercial` (
  `Commercial_num` int(11) NOT NULL,
  `Commercial_nom` varchar(50) DEFAULT NULL,
  `Commercial_prenom` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `commercial`
--

INSERT INTO `commercial` (`Commercial_num`, `Commercial_nom`, `Commercial_prenom`) VALUES
(1, 'jean', 'xeno'),
(2, 'michel', 'papin'),
(3, 'amelie', 'blonde'),
(4, 'camille', 'pied'),
(5, 'chloe', 'malade'),
(6, 'cathie', 'pasla'),
(7, 'kiki', 'desbois');

-- --------------------------------------------------------

--
-- Stand-in structure for view `commercial_dispo`
-- (See below for the actual view)
--
CREATE TABLE `commercial_dispo` (
`total` bigint(21)
,`commercial_num` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `facture`
--

CREATE TABLE `facture` (
  `Facture_num` int(11) NOT NULL,
  `Facture_date` date DEFAULT NULL,
  `Facture_adresse` varchar(50) DEFAULT NULL,
  `Facture_reglement` int(11) DEFAULT NULL,
  `Facture_negociation` int(11) DEFAULT NULL,
  `commande_num` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `facture`
--

INSERT INTO `facture` (`Facture_num`, `Facture_date`, `Facture_adresse`, `Facture_reglement`, `Facture_negociation`, `commande_num`) VALUES
(1, '2021-03-15', 'adresse de livraison', 843, 5, 2),
(2, '2020-03-15', 'adresse de livraison', 804, 5, 6),
(3, '2021-03-15', 'adresse de livraison', 1045, 5, 10);

-- --------------------------------------------------------

--
-- Table structure for table `livraison`
--

CREATE TABLE `livraison` (
  `Livraison_num` int(11) NOT NULL,
  `Livraison_adresse` varchar(50) DEFAULT NULL,
  `Livraison_date` varchar(50) DEFAULT NULL,
  `commande_num` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `livraison`
--

INSERT INTO `livraison` (`Livraison_num`, `Livraison_adresse`, `Livraison_date`, `commande_num`) VALUES
(1, 'adresse de livraison', '2022-03-15', 2),
(2, 'adresse de livraison', '2022-03-15', 6),
(3, 'adresse de livraison', '2022-03-15', 10);

-- --------------------------------------------------------

--
-- Table structure for table `stock`
--

CREATE TABLE `stock` (
  `Stock_num` int(11) NOT NULL,
  `Stock_quantite` varchar(50) DEFAULT NULL,
  `Stock_fournisseur` varchar(50) DEFAULT NULL,
  `Article_num` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `stock`
--

INSERT INTO `stock` (`Stock_num`, `Stock_quantite`, `Stock_fournisseur`, `Article_num`) VALUES
(1, '36', 'leclerc', 1),
(2, '39', 'jardiland', 2),
(3, '31', 'bricorama', 3),
(4, '26', 'castorama', 4),
(5, '33', 'castorama', 5),
(6, '33', 'jardiland', 6),
(7, '49', 'jardiland', 7),
(8, '27', 'lidl', 8),
(9, '11', 'leclerc', 9),
(10, '33', 'lidl', 10),
(11, '27', 'bricorama', 11),
(12, '11', 'leclerc', 12),
(13, '16', 'castorama', 13),
(14, '30', 'castorama', 14),
(15, '18', 'jardiland', 15),
(16, '25', 'jardiland', 16),
(17, '30', 'jardiland', 17),
(18, '15', 'bricorama', 18),
(19, '43', 'lidl', 19),
(20, '35', 'bricorama', 20),
(21, '21', 'leclerc', 21),
(22, '31', 'castorama', 22),
(23, '43', 'bricorama', 23),
(24, '15', 'castorama', 24),
(25, '27', 'bricorama', 25),
(26, '34', 'castorama', 26),
(27, '13', 'bricorama', 27),
(28, '48', 'jardiland', 28),
(29, '11', 'leclerc', 29),
(30, '19', 'castorama', 30),
(31, '42', 'leclerc', 31),
(32, '19', 'bricorama', 32),
(33, '11', 'leclerc', 33),
(34, '46', 'bricorama', 34),
(35, '27', 'leclerc', 35),
(36, '11', 'jardiland', 36),
(37, '16', 'castorama', 37),
(38, '49', 'bricorama', 38),
(39, '13', 'leclerc', 39),
(40, '25', 'bricorama', 40),
(41, '31', 'bricorama', 41),
(42, '37', 'bricorama', 42),
(43, '19', 'castorama', 43),
(44, '11', 'lidl', 44),
(45, '12', 'bricorama', 45),
(46, '48', 'bricorama', 46),
(47, '17', 'leclerc', 47),
(48, '18', 'lidl', 48),
(49, '28', 'castorama', 49),
(50, '16', 'bricorama', 50),
(51, '43', 'bricorama', 51),
(52, '20', 'bricorama', 52),
(53, '28', 'jardiland', 53),
(54, '49', 'castorama', 54),
(55, '38', 'bricorama', 55),
(56, '21', 'jardiland', 56),
(57, '16', 'jardiland', 57),
(58, '40', 'leclerc', 58),
(59, '16', 'jardiland', 59),
(60, '28', 'bricorama', 60),
(61, '18', 'castorama', 61),
(62, '41', 'jardiland', 62),
(63, '14', 'lidl', 63),
(64, '31', 'lidl', 64),
(65, '22', 'bricorama', 65),
(66, '28', 'castorama', 66),
(67, '27', 'lidl', 67),
(68, '50', 'bricorama', 68),
(69, '49', 'leclerc', 69),
(70, '11', 'lidl', 70),
(71, '32', 'bricorama', 71),
(72, '11', 'leclerc', 72),
(73, '34', 'bricorama', 73),
(74, '21', 'lidl', 74),
(75, '48', 'lidl', 75),
(76, '23', 'jardiland', 76),
(77, '44', 'jardiland', 77),
(78, '37', 'jardiland', 78),
(79, '26', 'castorama', 79),
(80, '49', 'castorama', 80),
(81, '22', 'leclerc', 81),
(82, '39', 'jardiland', 82),
(83, '12', 'castorama', 83),
(84, '21', 'lidl', 84),
(85, '39', 'bricorama', 85),
(86, '38', 'castorama', 86),
(87, '27', 'lidl', 87),
(88, '43', 'bricorama', 88),
(89, '27', 'bricorama', 89),
(90, '24', 'jardiland', 90),
(91, '44', 'jardiland', 91),
(92, '50', 'bricorama', 92),
(93, '19', 'lidl', 93),
(94, '40', 'lidl', 94),
(95, '28', 'bricorama', 95),
(96, '41', 'lidl', 96),
(97, '31', 'jardiland', 97),
(98, '37', 'bricorama', 98),
(99, '33', 'bricorama', 99),
(100, '35', 'bricorama', 100);

-- --------------------------------------------------------

--
-- Structure for view `article_stock`
--
DROP TABLE IF EXISTS `article_stock`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `article_stock`  AS SELECT `article`.`Article_num` AS `Article_num`, `article`.`Article_ref` AS `Article_ref`, `article`.`Article_photo` AS `Article_photo`, `article`.`Article_libelle_court` AS `Article_libelle_court`, `article`.`Article_libelle_long` AS `Article_libelle_long`, `article`.`Categorie_num` AS `Categorie_num`, `stock`.`Stock_quantite` AS `Stock_quantite`, `stock`.`Stock_fournisseur` AS `Stock_fournisseur` FROM (`article` join `stock`) WHERE `stock`.`Article_num` = `article`.`Article_num` ORDER BY `stock`.`Stock_fournisseur` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `commercial_dispo`
--
DROP TABLE IF EXISTS `commercial_dispo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `commercial_dispo`  AS SELECT count(`client`.`Commercial_num`) AS `total`, `client`.`Commercial_num` AS `commercial_num` FROM `client` GROUP BY `client`.`Commercial_num` ORDER BY count(`client`.`Commercial_num`) ASC LIMIT 0, 1 ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `acheter`
--
ALTER TABLE `acheter`
  ADD PRIMARY KEY (`commande_num`,`Client_num`,`Article_num`),
  ADD KEY `Client_num` (`Client_num`),
  ADD KEY `Article_num` (`Article_num`);

--
-- Indexes for table `article`
--
ALTER TABLE `article`
  ADD PRIMARY KEY (`Article_num`),
  ADD KEY `Categorie_num` (`Categorie_num`);

--
-- Indexes for table `categorie`
--
ALTER TABLE `categorie`
  ADD PRIMARY KEY (`Categorie_num`),
  ADD KEY `Categorie_num_1` (`Categorie_num_1`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`Client_num`),
  ADD KEY `Coeff_num` (`Coeff_num`),
  ADD KEY `Commercial_num` (`Commercial_num`);

--
-- Indexes for table `coefficient`
--
ALTER TABLE `coefficient`
  ADD PRIMARY KEY (`Coeff_num`);

--
-- Indexes for table `commande`
--
ALTER TABLE `commande`
  ADD PRIMARY KEY (`commande_num`);

--
-- Indexes for table `commercial`
--
ALTER TABLE `commercial`
  ADD PRIMARY KEY (`Commercial_num`);

--
-- Indexes for table `facture`
--
ALTER TABLE `facture`
  ADD PRIMARY KEY (`Facture_num`),
  ADD KEY `commande_num` (`commande_num`);

--
-- Indexes for table `livraison`
--
ALTER TABLE `livraison`
  ADD PRIMARY KEY (`Livraison_num`),
  ADD KEY `commande_num` (`commande_num`);

--
-- Indexes for table `stock`
--
ALTER TABLE `stock`
  ADD PRIMARY KEY (`Stock_num`),
  ADD KEY `Article_num` (`Article_num`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `article`
--
ALTER TABLE `article`
  MODIFY `Article_num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `Client_num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `coefficient`
--
ALTER TABLE `coefficient`
  MODIFY `Coeff_num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `commande`
--
ALTER TABLE `commande`
  MODIFY `commande_num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `commercial`
--
ALTER TABLE `commercial`
  MODIFY `Commercial_num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `facture`
--
ALTER TABLE `facture`
  MODIFY `Facture_num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `livraison`
--
ALTER TABLE `livraison`
  MODIFY `Livraison_num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `stock`
--
ALTER TABLE `stock`
  MODIFY `Stock_num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `acheter`
--
ALTER TABLE `acheter`
  ADD CONSTRAINT `acheter_ibfk_1` FOREIGN KEY (`commande_num`) REFERENCES `commande` (`commande_num`),
  ADD CONSTRAINT `acheter_ibfk_2` FOREIGN KEY (`Client_num`) REFERENCES `client` (`Client_num`),
  ADD CONSTRAINT `acheter_ibfk_3` FOREIGN KEY (`Article_num`) REFERENCES `article` (`Article_num`);

--
-- Constraints for table `article`
--
ALTER TABLE `article`
  ADD CONSTRAINT `article_ibfk_1` FOREIGN KEY (`Categorie_num`) REFERENCES `categorie` (`Categorie_num`);

--
-- Constraints for table `categorie`
--
ALTER TABLE `categorie`
  ADD CONSTRAINT `categorie_ibfk_1` FOREIGN KEY (`Categorie_num_1`) REFERENCES `categorie` (`Categorie_num`);

--
-- Constraints for table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `client_ibfk_1` FOREIGN KEY (`Coeff_num`) REFERENCES `coefficient` (`Coeff_num`),
  ADD CONSTRAINT `client_ibfk_2` FOREIGN KEY (`Commercial_num`) REFERENCES `commercial` (`Commercial_num`);

--
-- Constraints for table `facture`
--
ALTER TABLE `facture`
  ADD CONSTRAINT `facture_ibfk_1` FOREIGN KEY (`commande_num`) REFERENCES `commande` (`commande_num`);

--
-- Constraints for table `livraison`
--
ALTER TABLE `livraison`
  ADD CONSTRAINT `livraison_ibfk_1` FOREIGN KEY (`commande_num`) REFERENCES `commande` (`commande_num`);

--
-- Constraints for table `stock`
--
ALTER TABLE `stock`
  ADD CONSTRAINT `stock_ibfk_1` FOREIGN KEY (`Article_num`) REFERENCES `article` (`Article_num`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

Use greengarden;

CREATE USER "visiteur"@"localhost" IDENTIFIED BY "Azerty5+";
CREATE USER "client"@"localhost" IDENTIFIED BY "Azerty6+";
CREATE USER "gestion"@"localhost" IDENTIFIED BY "Azerty7+";
CREATE USER "administrateur"@"localhost" IDENTIFIED BY "Azerty8+";


GRANT SELECT
ON article
TO "visiteur"@"localhost" IDENTIFIED BY "Azerty5+";

GRANT SELECT
ON *
TO "client"@"localhost" IDENTIFIED BY "Azerty6+";
GRANT UPDATE,DELETE,INSERT 
ON acheter
TO "client"@"localhost" IDENTIFIED BY "Azerty6+";

GRANT SELECT,UPDATE,DELETE,INSERT 
ON *
TO "gestion"@"localhost" IDENTIFIED BY "Azerty7+";

GRANT ALL  
ON *
TO "administrateur"@"localhost" IDENTIFIED BY "Azerty8+";


