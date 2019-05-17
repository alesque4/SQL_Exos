#Exo supplémentaire

#1-Selectionner les commandes avec des produits des fournisseurs allemands (233)?

select commandes.NO_COMMANDE, SOCIETE
from commandes inner join details_commandes inner join produits inner join fournisseurs
	on commandes.NO_COMMANDE = details_commandes.NO_COMMANDE
	and details_commandes.REF_PRODUIT = produits.REF_PRODUIT
	and produits.NO_FOURNISSEUR = fournisseurs.NO_FOURNISSEUR
where PAYS = "Allemagne"
group by commandes.NO_COMMANDE;

#2-Selectionner le nom des clients  qui ont des commandes supérieur à 50 000
#(plusieurs lignes pour une commandes dans details_commandes. Prix * quantite) (14)

select commandes.NO_COMMANDE, SOCIETE, sum(PRIX_UNITAIRE*QUANTITE) as prix
from clients inner join commandes inner join details_commandes
on clients.CODE_CLIENT = commandes.CODE_CLIENT
	and commandes.NO_COMMANDE = details_commandes.NO_COMMANDE
group by NO_COMMANDE
having prix >= 50000;

#3-Selectionner le nom des employés qui ont fait une commande pour un clients Francais en 2017 (6)

select NOM
from clients inner join commandes inner join employes
on clients.CODE_CLIENT = commandes.CODE_CLIENT
	and commandes.NO_EMPLOYE = employes.NO_EMPLOYE
where clients.PAYS = "France"
	and YEAR(DATE_COMMANDE) = 2017;
    
#4-Lister les produits du plus vendu au moins vendu

select NOM_PRODUIT, sum(details_commandes.QUANTITE)
from produits inner join details_commandes
on produits.REF_PRODUIT = details_commandes.REF_PRODUIT
group by produits.REF_PRODUIT
order by sum(details_commandes.QUANTITE) desc;

#5-Selectionner le client qui a fait le plus de commande

select tabNbCommandes.NOM, tabNbCommandes.PRENOM, max(tabNbCommandes.nbCommandes) as Ventes_max
from (
	select employes.NO_EMPLOYE, NOM, PRENOM, count(NO_COMMANDE) as nbCommandes
	from employes inner join commandes 
	on employes.NO_EMPLOYE = commandes.NO_EMPLOYE
	group by employes.NO_EMPLOYE
    order by nbCommandes desc
    ) tabNbCommandes;

#6-Afficher les employés et leur salaire. 
# Ajouter 1000 au employés qui on effectuer + de 10 commandes et
# 500 a ceux qui ont fait plus de 5 commandes en 2017

select NOM, PRENOM, SALAIRE
from employes;

select NO_EMPLOYE, SALAIRE from empVue;

update employes
set SALAIRE = SALAIRE - 500
where NO_EMPLOYE in(
	select commandes.NO_EMPLOYE
	from (select * from employes) emp inner join commandes 
	on emp.NO_EMPLOYE = commandes.NO_EMPLOYE
    where YEAR(commandes.DATE_COMMANDE) = 2017
	group by emp.NO_EMPLOYE
    having count(NO_COMMANDE) >= 5
		and count(NO_COMMANDE) < 10
	);
     
update employes
set SALAIRE = SALAIRE + 1000
where NO_EMPLOYE in(1,3,4);
     
select commandes.NO_EMPLOYE
	from employes inner join commandes 
	on employes.NO_EMPLOYE = commandes.NO_EMPLOYE
    where YEAR(commandes.DATE_COMMANDE) = 2017
	group by employes.NO_EMPLOYE
    having count(NO_COMMANDE) > 10;
    
#7-Afficher le meilleur employé en 2017 (chiffre d'affaire --> prix * quantité)

select NOM, PRENOM, max(CA) as CA
from(
	select NOM, PRENOM, sum(PRIX_UNITAIRE*QUANTITE) as CA
	from employes inner join commandes inner join details_commandes
		on employes.NO_EMPLOYE = commandes.NO_EMPLOYE
		and commandes.NO_COMMANDE = details_commandes.NO_COMMANDE
	where year(commandes.DATE_COMMANDE) = 2017
	group by employes.NO_EMPLOYE
	order by CA DESC
    ) CAtab;

#8-Le fournisseur qui a le plus de produits 'boissons'

select * from categories;

select SOCIETE, max(nbRef) as "nombres de références"
from(
	select SOCIETE, count(REF_PRODUIT) as nbRef
	from fournisseurs inner join produits inner join categories
		on fournisseurs.NO_FOURNISSEUR = produits.NO_FOURNISSEUR
		and produits.CODE_CATEGORIE = categories.CODE_CATEGORIE
	where NOM_CATEGORIE = "Boissons"
	group by fournisseurs.NO_FOURNISSEUR
	order by nbRef desc
    ) nbRefTab;



