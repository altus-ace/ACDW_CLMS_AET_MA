


CREATE PROCEDURE [adi].[ValidateMembership]

AS
		---Keep Updating
		---Data Count for respective Load --
		SELECT		TOP 1 COUNT(*)RecCnt, DataDate
					,a.MbrLoadStatus
					,a.LoadDate
		INTO		#DataDate
		FROM		ACECAREDW.adi.MbrAetMaTx  a
		WHERE		MbrLoadStatus = 0
		GROUP BY	DataDate,a.MbrLoadStatus 
					,a.LoadDate 
		ORDER BY	DataDate DESC ,a.LoadDate DESC

		/*Step 1 - Check for count record for the Effective Month*/

		DECLARE @LoadDate DATE = (SELECT	LoadDate
									FROM	#DataDate) 

		DECLARE @DataDate DATE = (SELECT	DataDate
									FROM	#DataDate) 

		DECLARE @EffectiveMonth VARCHAR(7) = (SELECT MAX(EffectiveMonth) 
												FROM ACECAREDW.adi.MbrAetMaTx 
												WHERE EffectiveMonth NOT IN (SELECT MAX(EffectiveMonth) FROM ACECAREDW.adi.MbrAetMaTx)
											) 
		DECLARE @ClientKey INT = 3

		SELECT	@DataDate AS DataDate , @EffectiveMonth AS EffectiveMonth
				,@LoadDate AS LoadDate
				
		/*Total Cnt of records for the Effective Month*/
		SELECT	COUNT(*)TotalRecCntToBeProcessedIntoAst
		FROM	ACECAREDW.adi.MbrAetMaTx
		WHERE	DataDate = @DataDate
		AND		EffectiveMonth = @EffectiveMonth
		AND		LoadDate = @LoadDate
		
		/*All counts*/
		SELECT		COUNT(*)	--DISTINCT [Attributed_Provider_NPI_Number]
					--,MEMBER_ID,EffectiveMonth  
					--,Line_of_Business
					--,SourceValue,TargetValue
					--,NPI
		FROM		ACECAREDW.adi.MbrAetMaTx adi
		LEFT JOIN  (	SELECT SourceValue,TargetValue,TargetSystem 
						FROM lst.lstPlanMapping 
						WHERE ClientKey = 3 
						AND TargetSystem = 'ACDW_Plan' 
						AND ACTIVE = 'Y')pln
		ON			adi.Line_of_Business = pln.SourceValue
		LEFT JOIN	(   SELECT		DISTINCT NPI, AttribTIN
						FROM		[ACECAREDW].adw.tvf_AllClient_ProviderRoster (@ClientKey,@LoadDate,1) ) b
		ON			adi.[Attributed_Provider_NPI_Number] = b.NPI
		WHERE		adi.DataDate = @DataDate
		AND			adi.LoadDate = @LoadDate
		AND			adi.EffectiveMonth = @EffectiveMonth

		/*Counts to be processed into adw*/
		SELECT		COUNT(DISTINCT MEMBER_ID)ValidRecordsToBeProcessedIntoAdw
		FROM		ACECAREDW.adi.MbrAetMaTx adi
		LEFT JOIN  (	SELECT SourceValue,TargetValue,TargetSystem 
						FROM lst.lstPlanMapping 
						WHERE ClientKey = @ClientKey 
						AND TargetSystem = 'ACDW_Plan' 
						AND ACTIVE = 'Y')pln
		ON			adi.Line_of_Business = pln.SourceValue
		LEFT JOIN	(   SELECT		DISTINCT NPI, AttribTIN
						FROM		[ACECAREDW].adw.tvf_AllClient_ProviderRoster (@ClientKey,@LoadDate,1) ) pr
		ON			adi.[Attributed_Provider_NPI_Number] = pr.NPI
		WHERE		adi.DataDate = @DataDate
		AND			adi.LoadDate = @LoadDate
		AND			adi.EffectiveMonth = @EffectiveMonth
		AND			pln.SourceValue IS NOT NULL
		AND			pr.NPI IS NOT NULL

		/*Checking to see if assigned NPIs are captured in the PR*/
	DECLARE @MappingTypeKey INT = 22
	SELECT	DISTINCT AttribTIN ,Source AS AttribTIN_Doesnt_Exist_in_PR,Destination
	FROM	(	SELECT	Source,Destination
				FROM	lst.ListAceMapping
				WHERE	ClientKey = @ClientKey
				AND		MappingTypeKey = @MappingTypeKey
			)aceplMap
	LEFT JOIN (SELECT AttribTIN 
				FROM ACECAREDW.adw.tvf_AllClient_ProviderRoster(@ClientKey, @LoadDate,1)
			  )pr
	ON		 aceplMap.Source = pr.AttribTIN
	WHERE	pr.AttribTIN IS NULL

	/*Invalid Plan*/
	SELECT		DISTINCT adi.Line_of_Business
				,pln.SourceValue
				,pln.TargetValue-- SELECT *
	FROM		ACECAREDW.adi.MbrAetCom adi--- WHERE  Line_of_Business = ''
	LEFT JOIN  (	SELECT SourceValue,TargetValue,TargetSystem 
					FROM lst.lstPlanMapping 
					WHERE ClientKey = @ClientKey 
					AND TargetSystem = 'ACDW_Plan' 
					AND @LoadDate BETWEEN EffectiveDate and ExpirationDate
					)pln
	ON			adi.Line_of_Business = pln.SourceValue 
	WHERE		pln.SourceValue IS NULL
		
	/*
	SELECT	 adikey,prvnpi, prvtin, srcNPI,srcTIN,stgrowstatus
			 ,MstrMrnKey,DataDate,loaddate,EffectiveDate
			 ,MbrnpiFlg,MbrPlnFlg,MbrFlgCount,NPIReplacedFlg
			 ,plnClientPlanEffective
			 ,plnClientPlanEndDate --- 2021-10-31
			 ,plnProductPlan,plnProductSubPlan,plnProductSubPlanName,CsplnProductSubPlanName --- 1621 --- 1376
			 ,prvClientEffective,prvClientExpiration,ClientSubscriberID,*
	FROM	 ast.mbrstg2_mbrdata 
	WHERE	 LoadDate = '2022-02-01' ---- AND npiReplacedFlg = 1
	AND		 stgrowstatus  = 'Valid'


	SELECT	stgRowStatus,* 
	FROM	ast.MbrStg2_PhoneAddEmail
	WHERE	LoadDate = '2022-02-01'
	AND		 stgrowstatus  = 'Valid' ---- 1376
	
	SELECT * 
	FROM ACECAREDW.dbo.TmpAllMemberMonths 
	WHERE MemberMonth = '2022-02-01' and CLientKey = 3
	
	
	*/

	SELECT	 count(*),ClientSubscriberID
	FROM	 ast.mbrstg2_mbrdata 
	WHERE	 LoadDate = '2022-01-01'---- and ClientSubscriberId = '10147423880098'
	group by  ClientSubscriberID
			 having COUNT(*)>1