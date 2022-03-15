# greengarden

Un module de gestion de commandes. Réservé au service commercial, ce module 
doit permettre de :

o Créer de nouvelle commande.
Call creerCommande() ;
Permet de créer un numéro de commande 

o Ajouter des produits dans la commande.
Call ajouterCommande (idCommande,idUser,idArticle,quantité) ;
Permet d’ajouter un article a la commande d’un client, demande en paramètre un numero de commande, un numéro de client, l’id de l’article et la quantité.

o Connaître l'état de la commande (saisie, annulée, en préparation, expédiée, 
facturée, soldée)
call afficherEtat(com) ;
Permet d’afficher l’état de la commande en fonction du numéro de commande renseigné dans les paramètres 

o Consulter les clients en retard de paiement à une date données
??

o Modifier ou annuler une commande avant qu'elle ne soit en préparation.
Call supprimerCommande(com,cli) ;
Permet de supprimer (ou annuler) une commande dans son entièreté en fonction d’un client et d’un numéro de commande en paramètre 

• Un module de gestion des produits :
o Ajouter des produits et leurs caractéristiques (libellé, caractéristiques, prix 
etc.)
Call ajouterArticle(`ref`,`photo`, `puht`, `libCourt`,`libLong` ,`cat`,`quant`,`fourn`) ;
Permet d’ajouter un article dans la table article et stock en saisissant les informations de la table article et stock

o Modifier les produits
call majArticle (id,`ref`,`photo`, `puht`, `libCourt`,`libLong` ,`cat``,`quant`,`fourn`) ;
Même procédure que « ajouterArticle » a la différence qu’il faut target l’article via son ID pour le mettre à jour avec un update.

o Supprimer les produits
call supprimerArticle(art) ;
Supprime un article de la table article et stock via l’ID de l’article demandé en paramètre 

o Ajouter des clients
call ajouterParticulier(nom,prenom,tel,mail,sexe,pseudo,news,mdp,cp,adresse) ;
call ajouterPro(nom,prenom,tel,mail,sexe,pseudo,news,mdp,cp,adresse) ;
2 procédures permettant de créer un particulier ou un professionnel (le coeff num change en fonction du type de client, 1 pour particulier et 2 pour pro)

o Consulter une fiche client spécifique.
Call afficherClientSpecifique(id) ;
Affiche les informations d’un client en fonction de son ID en paramètre 

(o Afficher la liste des clients
CALL afficherClients() ;

o Afficher la liste des clients d'un commercial.
Call afficherClientCom(com) ;
Affiche la liste des clients en fonction de l’id du commercial

o Modifier des fiches clients.
Call majClient(id,nom,pre,tel,mail,sexe,pseudo,news,mdp,cp,adresse,coeff,com) ;
Mettre à jour la fiche d’un utilisateur en fonction de son ID

o Supprimer des fiches clients.
Call supprimerClient(cli) ;
Supprime un client de la table client en fonction de son id demandé en paramètre 

1.2.4 – Pour la sécurité, vous devez prévoir plusieurs profils de connexion et décliner les autorisations nécessaires
Voir la fin du script « greengarden.sql » pour voir la création des comptes utilisateur + attribution des droits.

1.2.6 – Décrivez les procédures que vous mettez en place pour assurer les sauvegardes de la base (MySQLdump)
Voir fichier « sauvegarde et restauration.docx » 

2.1.2 – Exportez les tables principales vers des tableaux d’un tableur de votre choix ainsi que le contenu du résultat de vos requêtes.
Voir dossier tableur

2.1.3 – chiffre d’affaires HT pour l’ensemble et par fournisseur
Call chiffreAffaires()

2.1.4 – Liste des produits commandés pour une année sélectionnée (référence et nom du 
produit, quantité commandée, fournisseur)
CALL listePourAnnee(annee) ;
Afficher les infos en choisissant une année en paramètre 

2.1.5 – Liste des commandes pour un client (date de la commande, référence client, 
montant, état de la commande)
CALL listeCommandeClient(cli) ;
Affiche la commande d’un client, renseigné via son id en paramètre 

2.1.6 – Répartition du chiffre d’affaire HT par type de client
CALL listeChiffreType() ;

2.1.7 – Lister les commandes en cours de livraison
L’état change dans la table commande (à renseigner au moment de la livraison).

2.2.1 – qui renvoie le délai moyen entre la date de commande et la date de facturation
CALL afficherEcartDate(com) ;
Affiche l’écart de date entre la commande et la livraison

2.3.1 – Créez une vue correspondant à la jointure Produits – Fournisseurs
CREATE OR REPLACE VIEW article_stock AS 
SELECT article.Article_num,Article_ref,Article_photo,Article_libelle_court,Article_libelle_long,Categorie_num,Stock_quantite,Stock_fournisseur 
FROM article,stock 
WHERE stock.Article_num = article.Article_num 
ORDER BY stock_fournisseur;

