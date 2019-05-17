# Afficher les commandes d'avant le 01/08/2017 qui ont une somme sup à 11000
# et qui contiennent des produits des fournisseurs français.(32 lignes)

select commandes.NO_COMMANDE, sum(details_commandes.PRIX_UNITAIRE*details_commandes.QUANTITE) as somme, commandes.DATE_COMMANDE
from commandes inner join details_commandes inner join produits inner join fournisseurs
	on commandes.NO_COMMANDE = details_commandes.NO_COMMANDE
    and details_commandes.REF_PRODUIT = produits.REF_PRODUIT
    and produits.NO_FOURNISSEUR = fournisseurs.NO_FOURNISSEUR
where datediff(commandes.DATE_COMMANDE, cast('2017/08/01' as datetime)) < 0
	and fournisseurs.PAYS = "FRANCE"
group by commandes.NO_COMMANDE
having somme > 11000;

# Afficher la liste des fournisseurs qui nous fournissent plus de 4 produits différents. (2 lignes)

select SOCIETE
from fournisseurs inner join produits
	on fournisseurs.NO_FOURNISSEUR = produits.NO_FOURNISSEUR
group by fournisseurs.NO_FOURNISSEUR
having count(REF_PRODUIT) > 4;

# Afficher pour les clients brésiliens le montant total de commandes ainsi que le pourcentage
# sur les ventes totales. (Afficher aussi les ventes totales) (1 ligne)

select SOCIETE, ClientTotal, (
	select sum(details_commandes.PRIX_UNITAIRE*details_commandes.QUANTITE) as somme
	from details_commandes inner join commandes inner join clients
		on details_commandes.NO_COMMANDE = commandes.NO_COMMANDE
		and commandes.CODE_CLIENT = clients.CODE_CLIENT
	where clients.PAYS = "Brésil"
	)as Total, (ClientTotal/(
	select sum(details_commandes.PRIX_UNITAIRE*details_commandes.QUANTITE) as somme
	from details_commandes inner join commandes inner join clients
		on details_commandes.NO_COMMANDE = commandes.NO_COMMANDE
		and commandes.CODE_CLIENT = clients.CODE_CLIENT
	where clients.PAYS = "Brésil"
	))*100 as pourcentage
	from clients inner join (
		select clients.CODE_CLIENT, sum(details_commandes.PRIX_UNITAIRE*details_commandes.QUANTITE) as ClientTotal
		from details_commandes inner join commandes inner join clients
			on details_commandes.NO_COMMANDE = commandes.NO_COMMANDE
			and commandes.CODE_CLIENT = clients.CODE_CLIENT
		where clients.PAYS = "Brésil"
		group by clients.CODE_CLIENT
        ) ClTab
		on clients.CODE_CLIENT = ClTab.CODE_CLIENT;
        
# Le nombre des commandes et la somme des frais de port pour chaque client et par année et par mois.
# Il faut afficher uniquement les clients qui ont commandé plus de 3 fois dans le mois et
# dont leur frais de port dans le mois est supérieur à 1000€.(33 lignes)


