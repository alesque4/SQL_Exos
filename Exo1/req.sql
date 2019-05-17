# Exo 1 - select

select NOM,PRENOM
from employes;

select distinct NOM_CATEGORIE 
from categories;

select NOM, PRENOM, DATE_NAISSANCE, IFNULL(COMMISSION, 0)
from employes;

select distinct FONCTION
from employes;

select distinct PAYS
from clients;

select distinct VILLE
from clients;

# EXO 2

select NOM_PRODUIT, QUANTITE*PRIX_UNITAIRE
from produits;

select NOM, PRENOM,
DATEDIFF(NOW(), DATE_NAISSANCE)/365, 
DATEDIFF(NOW(), DATE_EMBAUCHE)/365
from employes;

select NOM, "gagne", SALAIRE*12 + IFNULL(COMMISSION, 0)*2, "par an."
from employes;

# EXO 3 - COnditions

select SOCIETE, PAYS
from clients
where VILLE like "Toulouse";

select NOM, PRENOM, FONCTION
from employes
where REND_COMPTE like 2;

select NOM, PRENOM, FONCTION
from employes
where FONCTION not like "Représentant(e)";

select NOM, PRENOM, FONCTION
from employes
where SALAIRE < 3500;

select  SOCIETE, VILLE, PAYS
from clients
where FAX IS NULL;

select NOM, PRENOM, FONCTION
from employes
where REND_COMPTE IS NULL;

# Exo 4 - Tris

select NOM, PRENOM
from employes
order by NOM desc;

select SOCIETE
from clients
order by PAYS;

select SOCIETE
from clients
order by PAYS, VILLE;

#Exo 5 - Jointures

select NOM, PRENOM, FONCTION, SALAIRE
from employes
where salaire >= 2500 and salaire <= 3500;

select NOM_PRODUIT, SOCIETE, NOM_CATEGORIE, QUANTITE
from fournisseurs inner join produits inner join categories
on fournisseurs.NO_FOURNISSEUR = produits.NO_FOURNISSEUR
	and produits.CODE_CATEGORIE = categories.CODE_CATEGORIE
    and not produits.CODE_CATEGORIE in (1,3,5,7);
    
select NOM_PRODUIT, SOCIETE, NOM_CATEGORIE, QUANTITE
from fournisseurs inner join produits inner join categories
on fournisseurs.NO_FOURNISSEUR = produits.NO_FOURNISSEUR
	and produits.CODE_CATEGORIE = categories.CODE_CATEGORIE
where (fournisseurs.NO_FOURNISSEUR between 1 and 3
		or produits.CODE_CATEGORIE between 1 and 3)
    and (quantite like "%boîtes%"
		or quantite like "%cartons%");

select distinct NOM
from employes inner join commandes inner join clients
on employes.NO_EMPLOYE = commandes.NO_EMPLOYE
	and commandes.CODE_CLIENT = clients.CODE_CLIENT
where VILLE = "Paris";

select distinct NOM_PRODUIT, SOCIETE
from fournisseurs inner join produits inner join categories
on fournisseurs.NO_FOURNISSEUR = produits.NO_FOURNISSEUR
	and produits.CODE_CATEGORIE = categories.CODE_CATEGORIE
where produits.CODE_CATEGORIE in (1,4,7);

select e.NOM, e.PRENOM, s.NOM, s.PRENOM
from employes e left outer join employes s
on e.REND_COMPTE = s.NO_EMPLOYE;

# Exo 6 - fonctions

select sum(SALAIRE + COMMISSION)
from employes;

select avg(SALAIRE + COMMISSION)
from employes;

select max(SALAIRE), min(COMMISSION)
from employes;

#Q4 ???

#Exo 7 - Group by

select sum(SALAIRE), FONCTION
from employes
group by FONCTION;

select commandes.NO_COMMANDE, count(REF_PRODUIT)
from commandes inner join details_commandes
on commandes.NO_COMMANDE = details_commandes.NO_COMMANDE
group by commandes.NO_COMMANDE
having count(REF_PRODUIT) > 5;

select NO_FOURNISSEUR, 
	sum(IFNULL(UNITES_STOCK, 0) * produits.PRIX_UNITAIRE),
    sum(IFNULL(UNITES_COMMANDEES, 0) * produits.PRIX_UNITAIRE)
from produits
group by NO_FOURNISSEUR
having NO_FOURNISSEUR between 3 and 6;

select NOM, PRENOM, count(NO_COMMANDE) AS nb_commandes
from employes inner join commandes
on employes.NO_EMPLOYE = commandes.NO_EMPLOYE
group by employes.NO_EMPLOYE
having nb_commandes > 100;

select SOCIETE, count(NO_COMMANDE) as nb_commandes
from clients inner join commandes
on clients.CODE_CLIENT = commandes.CODE_CLIENT
group by clients.CODE_CLIENT
having nb_commandes > 30;

# Exo 8 - Opérations ensemblistes

select SOCIETE, ADRESSE, VILLE
from clients
union
select SOCIETE, ADRESSE, VILLE
from fournisseurs;

select commandes.NO_COMMANDE
from commandes inner join details_commandes inner join produits
on commandes.NO_COMMANDE = details_commandes.NO_COMMANDE
	and details_commandes.REF_PRODUIT = produits.REF_PRODUIT
where CODE_CATEGORIE = 1
	and NO_FOURNISSEUR = 1
    and commandes.NO_COMMANDE in (
		select commandes.NO_COMMANDE
		from commandes inner join details_commandes inner join produits
		on commandes.NO_COMMANDE = details_commandes.NO_COMMANDE
			and details_commandes.REF_PRODUIT = produits.REF_PRODUIT
		where CODE_CATEGORIE = 2
			and NO_FOURNISSEUR = 2);
            
select p.REF_PRODUIT, p.NOM_PRODUIT
from produits as p
where p.REF_PRODUIT not in(
	select distinct p2.REF_PRODUIT
    from produits as p2 inner join details_commandes inner join commandes inner join clients
    on p2.REF_PRODUIT = details_commandes.REF_PRODUIT
		and details_commandes.NO_COMMANDE = commandes.NO_COMMANDE
        and commandes.CODE_CLIENT = clients.CODE_CLIENT
    where VILLE = "Paris");
    
# Exo 9 - Sous_intérrogation

select NOM_PRODUIT, UNITES_STOCK
from produits
where UNITES_STOCK < (
	select avg(UNITES_STOCK)
	from produits
    );
    
select distinct *
from commandes natural join (
	select CODE_CLIENT, avg(PORT) as val
	from commandes natural join clients
	group by CODE_CLIENT) moy
where commandes.PORT > moy.val;
    
select NOM_PRODUIT, UNITES_STOCK, maxi
from produits, (
	select max(UNITES_STOCK) as maxi
	from produits
	where CODE_CATEGORIE = 3
	group by CODE_CATEGORIE
    ) cat3
where UNITES_STOCK > maxi;

select NOM_PRODUIT, SOCIETE, UNITES_STOCK, avgTab.moy
from produits inner join fournisseurs inner join (
	select NO_FOURNISSEUR, UNITES_STOCK as moy
    from produits
    group by NO_FOURNISSEUR
    ) avgTab
    on produits.NO_FOURNISSEUR = fournisseurs.NO_FOURNISSEUR
		and fournisseurs.NO_FOURNISSEUR = avgTab.NO_FOURNISSEUR
where UNITES_STOCK < moy;

select NOM, concat(cast((SALAIRE/parFonction.sommeSalaire)*100 as Integer)," %") as pourcentage, employes.FONCTION
from employes inner join (
	select FONCTION, SUM(SALAIRE) as sommeSalaire
    from employes
    group by FONCTION
	) parFonction
on employes.FONCTION = parFonction.FONCTION
order by pourcentage;

#Exo 9 - Modifications

insert into categories(NOM_CATEGORIE, DESCRIPTION)
values ("Fruits et légumes", "5 par jour !");

insert into fournisseurs
	select 30 as NO_FOURNISSEUR, "Grandma" as SOCIETE, ADRESSE, VILLE, CODE_POSTAL, PAYS, TELEPHONE, FAX
    from fournisseurs
    where SOCIETE = "Grandma Kelly's Homestead";
      
update produits
set NO_FOURNISSEUR = 30
where NO_FOURNISSEUR = 3;

delete from fournisseurs
where NO_FOURNISSEUR = 3;

#Exo 10 - Tables

create table pays(
	CODE_PAYS char(4) primary key,
    NOM_PAYS VARCHAR(40)
);

alter table clients
add courriel varchar(75);

alter table clients
modify courriel varchar(60);

alter table clients
drop column courriel;

create view vue as
	select SOCIETE, ADRESSE, TELEPHONE, VILLE
    from clients
    where VILLE in ("Toulouse", "Strasbourg", "Nantes", "Marseille");
    
select * from vue;
