


CREATE VIEW [ast].[vw_EMR_MemberCrosswalk]

AS

WITH CTE_mbrCrsWlk
AS
	(
			SELECT DISTINCT	(SELECT CONVERT(DATE,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))) AS  EffectiveDate
							, (SELECT ClientKey FROM lst.List_Client)  AS ClientKey
							, '''' + mbr.MEMBER_ID + ''''														AS [Source]
							,CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0), mbr.MEMBER_ID))	AS [Target]
			FROM			ACECAREDW.adi.MbrAetMaTx mbr
					
	
	)
	
	SELECT	EffectiveDate
			,ClientKey
			,[Source]
			,[Target]
	FROM	CTE_mbrCrsWlk
			

			
