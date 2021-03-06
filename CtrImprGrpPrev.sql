USE [APP_DB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  procedure	[dbo].[sp_SuiviImp_CtrImprGrpPrev]
	@NumCurrentEvnt	int

as

begin

SELECT DISTINCT	Evènements.[N° Evènement],
				Evènements.[Type Evènement],
				Contrats.[N° Contrat],
				Assurés.[N° Assuré],
				Assurés.[Nom Assuré] + ' ' + ISNULL(Assurés.[Prénom Assuré], '') AS [Nom adhérent],
				Contrats.Indiv,
				Assurés.[Adresse 1 Ass] AS [Adresse 1 Adh],
				Assurés.[Adresse 2 Ass] AS [Adresse 2 Adh],
				Assurés.[CP Ass] AS [CP Adh],
				Assurés.[Ville Ass] AS [Ville Adh],
				Contrats.[Code Fournisseur],
				Fournisseurs.[Nom Fournisseur],
				Contrats.[Contrat Fournisseur],
				Contrats.[Code Courtier],
				Courtiers.[Nom Courtier],
				Courtiers.[Adresse 1 Courtier],
				Courtiers.[Adresse 2 Courtier],
				Courtiers.[CP Courtier],
				Courtiers.[Ville Courtier],
				Courtiers.[Tél Courtier],
				Courtiers.[Fax Courtier],
				Collèges.Collège,
				Collèges.[Libéllé Complément],
				Contrats.[Date d'effet],
				Garanties.[Code Garantie],
				Garanties.[Numéro Garantie],
				Garanties.[Désignation Garantie],
				Périodicité.Périodicité,
				Contrats.[Terme Echu],
				Gestionnaires.[Code Gestionnaire],
				Gestionnaires.[Nom Gestionnaire],
				Gestionnaires.[Adresse 1 Gestionnaire],
				Gestionnaires.[Adresse 2 Gestionnaire], 
				Gestionnaires.[CP Gestionnaire],
				Gestionnaires.[Ville Gestionnaire],
				Gestionnaires.[Tél Gestionnaire],
				Gestionnaires.[Fax Gestionnaire],
				Contrats.[Dispositions Particulières],
				Contrats.[Adhésion Obligatoire],
				Contrats.[Envoi Appel Cot],
				Contrats.[Prlvt Auto],
				Contrats.TNS,
				Contrats.[Code Impression],
				Contrats.[Date d'impression],
				Contrats.TP,
				[Cotisations Appel].[Nom Appel],
				[Cotisations Appel].[Adresse 1 Appel],
				[Cotisations Appel].[Adresse 2 Appel],
				[Cotisations Appel].[CP Appel],
				[Cotisations Appel].[Ville Appel],
				[Cotisations Appel].[Tél Appel],
				[Cotisations Appel].[Fax Appel],
				CtImprNomEntr.[Nom cotis],
				CtImprNomEntr.[Adresse 1 cotis],
				CtImprNomEntr.[Adresse 2 cotis],
				CtImprNomEntr.[CP Cotis],
				CtImprNomEntr.[Ville cotis],
				CtImprNomEntr.RCS,
				Contrats.[N° Clause],
				Contrats.[Frais Prlvt],
				[Correspondance Polices].[police santé],
				Assurés.RCS AS RCSsal,
				[Types Adhérents].Libéllé,
				[Types Adhérents_1].Libéllé AS libel2,
				Assurés.D_Naiss,
				Encaisseurs.[Type encaisseur],
				Encaisseurs.[Nom Encais],
				Encaisseurs.[Adresse Encais],
				Encaisseurs.[CP enc],
				Encaisseurs.[Ville enc],
				Encaisseurs.[Tél Encais],
				Encaisseurs.[Fax Encais],
				Encaisseurs.SIRET,
				Encaisseurs.NAF,
				Encaisseurs.Texte1,
				Encaisseurs.Texte2,
				Encaisseurs.[Nom Commercial],
				Contrats.[Code produit],
				Contrats.[N° Produit],
				Encaisseurs.[Code Encaisseur],
				Contrats.acte_chir,
				Contrats.exclusion_dt_envoi,
				Contrats.exclusion_dt_retour,
				Contrats.exclusion_no_AR,
				Contrats.exclusion_no_clause,
				Assurés.APE,
				Contrats.Mutuelle,
				Produits.[Libéllé produit],
				Encaisseurs.Num_Orias,
				Contrats.College2, 
				Contrats.[Collège Assuré],
				Contrats.[User Cré],
				Contrats.Gestion,
				Contrats.[Date de résiliation],
				[Codes Pays].Libel_pays,
				[Codes Pays].Code_pays,
				Contrats.[Etape Circuit],
				Contrats.Zone_Tarif,
				Contrats.Grille_sante,
				Contrats.CP_Index,
				Courtiers.Origine,
				Contrats.[Frais Relance],
				Contrats.[Frais Relance 2],
				Contrats.[Frais Relance 3],
				min([N° Base]) AS [nobase]

INTO			#temp1

FROM            [Types Adhérents] AS [Types Adhérents_1] RIGHT OUTER JOIN
                Assurés INNER JOIN
                Périodicité RIGHT OUTER JOIN
                Gestionnaires RIGHT OUTER JOIN
                Garanties RIGHT OUTER JOIN
                Fournisseurs RIGHT OUTER JOIN
                Courtiers RIGHT OUTER JOIN
                [Cotisations Appel] RIGHT OUTER JOIN
                Collèges RIGHT OUTER JOIN
                Contrats LEFT OUTER JOIN
                [Correspondance Polices] ON Contrats.[Contrat Fournisseur] = [Correspondance Polices].[police prev] ON Collèges.[Code Collège] = Contrats.[Collège Assuré] ON 
                [Cotisations Appel].[Code Appel] = Contrats.[Code Appel] ON Courtiers.[Code Courtier] = Contrats.[Code Courtier] ON Fournisseurs.[Code Fournisseur] = Contrats.[Code Fournisseur] ON 
                Garanties.[N° Garantie] = Contrats.[N° Garantie] ON Gestionnaires.[Code Gestionnaire] = Contrats.[Code Gestionnaire] ON Périodicité.[N° Périodicité] = Contrats.[N° Périodicité] ON 
                Assurés.[N° Assuré] = Contrats.[N° Adhérent] LEFT OUTER JOIN
                CtImprNomEntr ON Assurés.[N° Assuré] = CtImprNomEntr.No_Assuré_Lien LEFT OUTER JOIN
                [Types Adhérents] ON Assurés.Type_Assuré = [Types Adhérents].[Type Adh] LEFT OUTER JOIN
                Assurés AS Assurés_1 ON CtImprNomEntr.[N° Assuré] = Assurés_1.[N° Assuré] ON [Types Adhérents_1].[Type Adh] = Assurés_1.Type_Assuré LEFT OUTER JOIN
                Encaisseurs ON Contrats.[Code Encaisseur] = Encaisseurs.[Code Encaisseur] INNER JOIN
                Produits ON Contrats.[N° Produit] = Produits.[N° Produit] INNER JOIN
                [Lignes Contrats] ON Périodicité.[N° Périodicité] = [Lignes Contrats].[N° Périodicité] AND Fournisseurs.[Code Fournisseur] = [Lignes Contrats].[Code Fournisseur] AND 
                Contrats.[N° Contrat] = [Lignes Contrats].[N° Contrat] INNER JOIN
                [Types Cotisations] ON [Lignes Contrats].[Type Cotisation] = [Types Cotisations].[Type Cotisation] LEFT OUTER JOIN
                [Codes Pays] ON Assurés.Pays_Resid = [Codes Pays].Code_pays INNER JOIN
				Evènements ON Evènements.[N° Contrat] = Contrats.[N° Contrat]

WHERE			[types cotisations].[type cotisation] <> 'aps' and reversion = 1 AND
				contrats.[Date d'Effet] = [Lignes Contrats].[Date d'effet]

GROUP BY		Evènements.[N° Evènement],
				Evènements.[Type Evènement],
				Contrats.[N° Contrat],
				Assurés.[N° Assuré],
				Assurés.[Nom Assuré] + ' ' + ISNULL(Assurés.[Prénom Assuré], ''), 
				Contrats.Indiv,Assurés.[Adresse 1 Ass],
				Assurés.[Adresse 2 Ass],
				Assurés.[CP Ass], Assurés.[Ville Ass], 
				Contrats.[Code Fournisseur],
				Fournisseurs.[Nom Fournisseur],
				Contrats.[Contrat Fournisseur],
				Contrats.[Code Courtier],
				Courtiers.[Nom Courtier],
				Courtiers.[Adresse 1 Courtier],
				Courtiers.[Adresse 2 Courtier], 
				Courtiers.[CP Courtier],
				Courtiers.[Ville Courtier],
				Courtiers.[Tél Courtier],
				Courtiers.[Fax Courtier],
				Collèges.Collège,
				Collèges.[Libéllé Complément],
				Contrats.[Date d'effet],
				Garanties.[Code Garantie], 
				Garanties.[Numéro Garantie],
				Garanties.[Désignation Garantie],
				Contrats.[Terme Echu],
				Périodicité.Périodicité,
				Gestionnaires.[Code Gestionnaire],
				Gestionnaires.[Nom Gestionnaire],
				Gestionnaires.[Adresse 1 Gestionnaire], 
				Gestionnaires.[Adresse 2 Gestionnaire],
				Gestionnaires.[CP Gestionnaire],
				Gestionnaires.[Ville Gestionnaire],
				Gestionnaires.[Tél Gestionnaire],
				Gestionnaires.[Fax Gestionnaire], 
				Contrats.[Dispositions Particulières],
				Contrats.[Adhésion Obligatoire],
				Contrats.[Envoi Appel Cot],
				Contrats.[Prlvt Auto],
				Contrats.TNS, Contrats.[Code Impression],
				Contrats.[Date d'impression],
				Contrats.TP,
				[Cotisations Appel].[Nom Appel],
				[Cotisations Appel].[Adresse 1 Appel],
				[Cotisations Appel].[Adresse 2 Appel], 
				[Cotisations Appel].[CP Appel],
				[Cotisations Appel].[Ville Appel],
				[Cotisations Appel].[Tél Appel],
				[Cotisations Appel].[Fax Appel],
				CtImprNomEntr.[Nom cotis],
				CtImprNomEntr.[Adresse 1 cotis], 
                CtImprNomEntr.[Adresse 2 cotis],
				CtImprNomEntr.[CP Cotis],
				CtImprNomEntr.[Ville cotis],
				CtImprNomEntr.RCS,
				Contrats.[N° Clause],
				Contrats.[Frais Prlvt],
				[Correspondance Polices].[police santé],
				Assurés.RCS, 
                [Types Adhérents].Libéllé,
				[Types Adhérents_1].Libéllé,
				Assurés.D_Naiss, Encaisseurs.[Type encaisseur],
				Encaisseurs.[Nom Encais],
				Encaisseurs.[Adresse Encais],
				Encaisseurs.[CP enc],
				Encaisseurs.[Ville enc], 
                Encaisseurs.[Tél Encais],
				Encaisseurs.[Fax Encais],
				Encaisseurs.SIRET,
				Encaisseurs.NAF,
				Encaisseurs.Texte1,
				Encaisseurs.Texte2,
				Encaisseurs.[Nom Commercial],
				Contrats.[Code produit],
				Contrats.[N° Produit], 
                Encaisseurs.[Code Encaisseur],
				Contrats.acte_chir,
				Contrats.exclusion_dt_envoi,
				Contrats.exclusion_dt_retour,
				Contrats.exclusion_no_AR,
				Contrats.exclusion_no_clause,
				Assurés.APE, Contrats.Mutuelle,
				Produits.[Libéllé produit], 
                Encaisseurs.Num_Orias,
				Contrats.College2,
				Contrats.[Collège Assuré],
				Contrats.[User Cré],
				Contrats.Gestion,
				Contrats.[Date de résiliation],
				[Codes Pays].Libel_pays,
				[Codes Pays].Code_pays, 
                Contrats.[Etape Circuit],
				Contrats.Zone_Tarif,
				Contrats.Grille_sante,
				Contrats.CP_Index,
				Courtiers.Origine,
				Contrats.[Frais Relance],
				Contrats.[Frais Relance 2],
				Contrats.[Frais Relance 3]

HAVING			Evènements.[N° Evènement] = @NumCurrentEvnt

DECLARE @cols NVARCHAR(max)
SELECT @cols = STUFF(( 
						SELECT DISTINCT	'],[' + Types_Nom_Champ.Nom_Champ
						FROM			Types_Nom_Champ
						WHERE			stockage = 1
						ORDER BY		'],[' + Types_Nom_Champ.Nom_Champ
						FOR XML PATH('')
					), 1, 2, '') + ']'
DECLARE @query NVARCHAR(max)
SET @query = N'
SELECT	' + @cols + ', [N° contrat]
INTO	#temp2
FROM	(
			SELECT	infos_contrat.[N° contrat],	infos_contrat.valeur, Types_Nom_Champ.Nom_Champ
			FROM	infos_contrat INNER JOIN
					Contrats ON infos_contrat.[N° contrat] = Contrats.[N° Contrat] AND infos_contrat.Deffet = Contrats.[Date d''effet] RIGHT OUTER JOIN
					Types_Nom_Champ ON infos_contrat.type_nom_champ = Types_Nom_Champ.No_champ INNER JOIN
					Evènements ON Evènements.[N° contrat] = Contrats.[N° Contrat]
			WHERE   Evènements.[N° Evènement] = '+ CONVERT(nvarchar(30), @NumCurrentEvnt) +' AND Types_Nom_Champ.stockage = 1
		) ct
PIVOT	(min(ct.valeur) for Nom_Champ in (' + @cols + ')) As Pvt;

SELECT	#temp1.*,
		#temp2.*,
		''CFE'' as test,
		Contrats.[Tarification Sur Mesure],
		Logo_Encaisseur.TamponSSRS, 
		Logo_Encaisseur.logoSSRS,
		Produits.logo_ProduitSSRS
FROM	#temp1 INNER JOIN
		#temp2 ON #temp1.[N° Contrat] = #temp2.[N° Contrat] INNER JOIN
		Contrats ON #temp1.[N° Contrat] = Contrats.[N° Contrat] INNER JOIN 
		Logo_Encaisseur ON #temp1.[Code Encaisseur] = Logo_Encaisseur.[encaisseur] INNER JOIN
		Produits ON #temp1.[N° Produit] = Produits.[N° Produit]
;'

EXECUTE(@query)

end