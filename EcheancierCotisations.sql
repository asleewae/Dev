USE [APP_DB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure	[dbo].[sp_SuiviImp_EcheancierCotisEvt]
	@NumCurrentEvnt int

as

begin

SELECT		Contrats.[N° Adhérent],
			Contrats.[N° Contrat],
			Contrats.[Date de résiliation],
			Contrats.[Dispositions Particulières],
			Contrats.[Date d'effet],
			Contrats.Mutuelle,
			CASE WHEN [Mutuelle] = 0 THEN dbo.[Val](Replace([Dispositions Particulières], ',', '.')) ELSE '' END AS NbBase,
			[Bases Montants].[Montant Base],
			Contrats.[N° Produit],
			Bases.[Base courte],
			cotis.Montantcotis,
			Evènements.[N° Evènement],
			gar,
			hc.hommeCle
FROM		[Bases Montants] INNER JOIN
            Bases ON [Bases Montants].[N° Base] = Bases.[N° Base],
            Contrats INNER JOIN
			Evènements ON Contrats.[N° Adhérent] = Evènements.[N° Assuré] INNER JOIN
            (
				SELECT		Contrats_1.[N° Contrat],
							CASE WHEN mutuelle = 1 THEN [Type Garantie] ELSE ' ' END AS gar
                FROM		[Fournisseurs Garanties Prév] INNER JOIN
							[Contrats Garanties Prév] ON [Contrats Garanties Prév].[Code Garantie] = Convert(varchar(30), [Fournisseurs Garanties Prév].No_Garantie) INNER JOIN
							Contrats AS Contrats_1 ON Contrats_1.[N° Contrat] = [Contrats Garanties Prév].[N° Contrat] INNER JOIN
							Evènements AS Evènements_1 ON Evènements_1.[N° Assuré] = Contrats_1.[N° Adhérent]
                WHERE		Evènements_1.[N° Evènement] = @NumCurrentEvnt
                GROUP BY	Contrats_1.[N° Contrat],
							CASE WHEN mutuelle = 1 THEN [Type Garantie] ELSE ' ' END
			) AS garant ON garant.[N° Contrat] = Contrats.[N° Contrat] INNER JOIN 
			(
				SELECT		Contrats.[N° Contrat],
							Sum(CASE WHEN [cotisations].[mt perçu] = 0 THEN dbo.precalculeech([Lignes Contrats].[N° Base], [Cotisations].[Mt Base], [Cotisations].[Nb Assurés], [Contrats].[TNS], [Cotisations].[Tx Groupe]) ELSE [Cotisations].[Mt perçu] END) AS Montantcotis
				FROM		Evènements INNER JOIN
							Contrats INNER JOIN
							[Lignes Contrats] ON Contrats.[N° Contrat] = [Lignes Contrats].[N° Contrat] INNER JOIN
							Cotisations ON [Lignes Contrats].[N° Lgn Contrat] = Cotisations.[N° Lgn Contrat] ON Evènements.[N° Assuré] = Contrats.[N° Adhérent]
				WHERE		Evènements.[N° Evènement] = @NumCurrentEvnt AND
							Contrats.Gestion <> 3 AND
							Year([Date Cotisation] - Abs([terme Echu])) = Year(evènements.dteffet)
				GROUP BY	Contrats.[N° Contrat]
				HAVING		Sum(CASE WHEN [cotisations].[mt perçu] = 0 THEN dbo.precalculeech([Lignes Contrats].[N° Base], [Cotisations].[Mt Base], [Cotisations].[Nb Assurés], [Contrats].[TNS], [Cotisations].[Tx Groupe]) ELSE [Cotisations].[Mt perçu] END) <> 0
			) AS cotis ON Contrats.[N° Contrat] = cotis.[N° Contrat] LEFT JOIN
			(
				SELECT		[Assurés - Contrats].[N° Assuré],
							Contrats.[N° Contrat],
							[Nom Assuré] + ' ' + [prénom Assuré] AS hommeCle,
							Contrats.[N° Adhérent]
				FROM		Contrats INNER JOIN
							[Assurés - Contrats] ON Contrats.[N° Contrat] = [Assurés - Contrats].[N° Contrat] INNER JOIN
							Assurés ON [Assurés - Contrats].[N° Assuré] = Assurés.[N° Assuré] INNER JOIN
							Evènements ON Contrats.[N° Contrat] = Evènements.[N° Contrat]
				WHERE		(Contrats.[N° Produit] = 718 OR Contrats.[N° Produit] = 733 OR Contrats.[N° Produit] = 735)
				GROUP BY	[Assurés - Contrats].[N° Assuré],
							Contrats.[N° Contrat],
							[Nom Assuré] + ' ' + [prénom Assuré],
							Contrats.[N° Adhérent]
			) AS hc ON hc.[N° Contrat] = Contrats.[N° Contrat]
WHERE		Bases.[N° Base] = 1 AND
			Contrats.Gestion <> 3 AND
			Year(evènements.dteffet) >= Year([Date début]) AND
			Year(evènements.dteffet) <= Year([date fin]) AND
			Year(evènements.dteffet) >= Year(contrats.[Date d'effet]) AND
			Year(evènements.dteffet) <= Year(CASE WHEN contrats.[date de résiliation] Is Null THEN '31/12/2050' ELSE contrats.[Date de résiliation] END)

GROUP BY	Contrats.[N° Adhérent],
			Contrats.[N° Contrat],
			Contrats.[Date de résiliation],
			Contrats.[Dispositions Particulières],
			Contrats.[Date d'effet],
			Contrats.Mutuelle,
			CASE WHEN [Mutuelle] = 0 THEN dbo.[Val](REPLACE([Dispositions Particulières], ',', '.')) ELSE '' END,
			[Bases Montants].[Montant Base],
			Contrats.[N° Produit],
			Bases.[Base courte],
			cotis.Montantcotis,
			Evènements.[N° Evènement],
			gar,
			hc.hommeCle
HAVING		Evènements.[N° Evènement] = @NumCurrentEvnt
;
end