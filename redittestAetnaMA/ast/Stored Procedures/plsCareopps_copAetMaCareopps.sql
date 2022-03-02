

	CREATE PROCEDURE	[ast].[plsCareopps_copAetMaCareopps] ( ---  [ast].[plsCareopps_copAetMaCareopps] '2021-11-15',3,'2021-11-20'  
							@QMDATE DATE
							,@ClientKey INT
							,@DataDate DATE)
	AS


	BEGIN
	BEGIN TRY
	BEGIN TRAN

					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientID INT	 = @ClientKey; 
					DECLARE @JobName VARCHAR(100) = 'AetnaCOMM_CareOpps';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = 'AetnaCOMM_CareOpps'
					DECLARE @DestName VARCHAR(100) = '[ast].[QM_ResultByMember_History]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					DECLARE @OutputTbl TABLE (ID INT) 
	---Step 1a Create a temp table to hold records
		
		IF OBJECT_ID('tempdb..#AetCOP') IS NOT NULL DROP TABLE #AetCOP
		CREATE TABLE  #AetCOP ([pstQM_ResultByMbr_HistoryKey] [int] IDENTITY(1,1) NOT NULL,
								[srcFileName] [varchar](150) NULL,
								[adiTableName] [varchar](100) NOT NULL,	[adiKey] [int] NOT NULL
								,[ClientKey] [int] NOT NULL,[ClientMemberKey] [varchar](50) NOT NULL 
								,[QmMsrId] [varchar](100) NULL
								,[QmCntCat] [varchar](10) NULL,[QMDate] [date] NULL
								,srcQMID VARCHAR(50), srcQMDescription VARCHAR(50))

					SELECT				@InpCnt = COUNT(adiKey)
					FROM				#AetCOP
								
					--SELECT				 @InpCnt  

		EXEC		amd.sp_AceEtlAudit_Open 
					@AuditID = @AuditID OUTPUT
					, @AuditStatus = @JobStatus
					, @JobType = @JobType
					, @ClientKey = @ClientKey
					, @JobName = @JobName
					, @ActionStartTime = @ActionStart
					, @InputSourceName = @SrcName
					, @DestinationName = @DestName
					, @ErrorName = @ErrorName
	
			IF OBJECT_ID('tempdb..#COP') IS NOT NULL DROP TABLE #COP
			/*Create a tmp table to hold population*/
			IF OBJECT_ID('tempdb..#Src') IS NOT NULL DROP TABLE #Src --  Declare @ClientKey int = 3 DECLARE @DataDate DATE = '2021-11-20' DECLARE @QMDATE DATE = '2021-11-15'
			SELECT	ClientMemberKey
					,trf.QmMsrId
					,QmCntCat 
					,QMDATE
					,MbrCOPStatus
					,AdiKey
					,srcFileName
					,DataDate
					,AdiTableName
					,ClientKey
					,trf.Source				AS aceSrcMeasure
					,trf.Destination		AS srcQMID
					,Unpvt.QmMsrId			AS srcQmDescription
					INTO	#Src  ---- DECLARE @DataDate DATE = '2021-11-20' DECLARE @ClientKey INT = 3 DECLARE @QMDATE DATE = '2021-11-15' SELECT *
			FROM   (
			
			SELECT		DISTINCT CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0), adiMembers.MEMBER_ID))  AS ClientMemberKey
						,'    ' AS QmCntCat
						,[MemberFirstName]
						,[MemberLastName]
						,[Readmissions-AllCause],[MedicationReconciliationPostDischarge],[Breast ScreeningCompliance],[ColorectalScreeningCompliance]
						 ,[AceiArbAdherence],[Acei ArbPDCYTD] ,[DiabetesEyeExam] ,[DiabetesNephropathyScreening] ,[DiabetesLdlControl]
						 ,[DiabetesLdlLevel] ,[DiabetesMedicationAdherence] ,[DiabetesMedicationPDCYTD] ,[DiabetesControlledHbA1c]
						 ,[DiabetesHba1C Level] ,[StatinUseInDiabetics] ,[StatinMedicationAdherence] ,[StatinMedicationPDCYTD]
						 ,[OsteoporosisManagement] ,[RheumatoidArthritisManagement] ,[AdultBMIAssessment]
						 ,[OfficeVisits] ,[LastOfficeVisit] ,[OfficeVisits-Chronic1stHalf] ,[Office Visits-Chronic2ndHalf],[Last OfficeVisit-Chronic]
						 ,[AnnualFluVaccine] ,[ControllingHighBloodPressure],[StatinTherapyCardiovascularDisease]
						 ,adi.copAetMaCareoppsKey						AS AdiKey
						 ,adi.[SrcFileName]								AS srcFileName
						 ,adi.[DataDate]								AS DataDate
						,'[ACECAREDW].[adi].[copAetMaCareopps]'			AS AdiTableName
						,(SELECT ClientKey	
							FROM lst.list_client 
							WHERE ClientShortName = 'Aet')				AS ClientKey
						,@QMDATE AS QMDATE -- select *
			FROM		[ACECAREDW].[adi].[copAetMaCareopps]adi  
			INNER JOIN  ACECAREDW.adi.MbrAetMaTx AdiMembers 
			ON		    LTRIM(RTRIM(adiMembers.Member_Source_Member_ID)) = LTRIM(RTRIM(adi.MemberID))
			WHERE		adi.CopStgLoadStatus = 0
			AND			adi.DataDate = @DataDate
					)pvt
			UNPIVOT
					(MbrCOPStatus FOR [QmMsrId] IN ([Readmissions-AllCause] ,[MedicationReconciliationPostDischarge],[Breast ScreeningCompliance],[ColorectalScreeningCompliance]
					 ,[AceiArbAdherence],[Acei ArbPDCYTD],[DiabetesEyeExam],[DiabetesNephropathyScreening],[DiabetesLdlControl],[DiabetesLdlLevel],[DiabetesMedicationAdherence]
					 ,[DiabetesMedicationPDCYTD],[DiabetesControlledHbA1c],[DiabetesHba1C Level],[StatinUseInDiabetics]
					 ,[StatinMedicationAdherence],[StatinMedicationPDCYTD],[OsteoporosisManagement],[RheumatoidArthritisManagement]
					 ,[AdultBMIAssessment],[OfficeVisits],[LastOfficeVisit],[OfficeVisits-Chronic1stHalf]
					 ,[Office Visits-Chronic2ndHalf],[Last OfficeVisit-Chronic] ,[AnnualFluVaccine],[ControllingHighBloodPressure]
					 ,[StatinTherapyCardiovascularDisease]
										)
					 ) AS Unpvt
			LEFT JOIN	 /*Match on the lookup tables for matching values*/
						(	SELECT DISTINCT IsActive
											,Source
											,Destination 
											,MeasureID AS [QmMsrId]
								FROM        [lst].[ListAceMapping] ace
								LEFT JOIN	(SELECT DISTINCT MeasureID
													 ,MeasureDESC
												FROM lst.lstCareOpToPlan
												WHERE ClientKey = @ClientKey 
												AND ACTIVE = 'Y'
											) qm		
								ON		ace.Destination=qm.MeasureID
								WHERE	ClientKey = @ClientKey
								AND		ace.MappingTypeKey = 14
								AND		ace.ACTIVE = 'Y'
						) trf
				ON		Unpvt.QmMsrId = trf.Source
			-- Select * from #src
			/*Clean and transform MbrCOPStatus field*/
			/*Delete Records for population not eligible for the CareGap*/
			BEGIN
			DELETE FROM #Src WHERE MbrCOPStatus = '' /*These are blank because they are not meant to be in the population*/
			END

			/*Create a dataset to identify and delete more records not in the
			 population for 'DiabetesMedicationPDCYTD','StatinMedicationPDCYTD','Acei ArbPDCYTD' */
			SELECT CASE  WHEN MbrCOPStatus LIKE 'Y%' AND QmMsrId IS NOT NULL THEN 'NUM'
						 WHEN MbrCOPStatus LIKE 'N%' AND QmMsrId IS NOT NULL THEN 'COP'
						 WHEN (TRY_convert(NUMERIC(10,2), MbrCOPStatus)>= 0.96) 
							   AND QmMsrId IN ('AETMA_MA_D','AETMA_MA_S','AETMA_MPM_A') 
							   AND QmMsrId IS NOT NULL THEN 'NUM'
						 WHEN (TRY_convert(numeric(10,2), MbrCOPStatus) BETWEEN 0.60 AND 0.95) 
							   AND QmMsrId IN ('AETMA_MA_D','AETMA_MA_S','AETMA_MPM_A') 
							   AND QmMsrId IS NOT NULL THEN 'COP'
				ELSE ''
				END NewMbrCOPStatus
					,MbrCOPStatus
					,ClientMemberKey
					,QmMsrId
					,QmCntCat
					,QMDATE
					,AdiKey
					,srcFileName
					,DataDate
					,AdiTableName
					,ClientKey
					,aceSrcMeasure
					,srcQMID
					,srcQmDescription 
					INTO #COP
			FROM #src  
			/*Then delete identified records not in the DEN*/
			BEGIN
			--SELECT * 
			DELETE
			FROM	#COP 
			WHERE	QmMsrId IN ('AETMA_MPM_A','AETMA_MA_D','AETMA_MA_S') --ORDER BY MbrCOPStatus
			AND MbrCOPStatus <'0.60'
			END

			/**//*
			-- 
			SELECT * FROM #COP WHERE QmMsrId IS NULL AND MbrCOPStatus NOT LIKE '%Y%'
			UNION
			SELECT * FROM #COP WHERE QmMsrId IS NULL AND MbrCOPStatus NOT LIKE '%N%'*/
			-- Select * from #cop
		   /*Calculate for DEN population*/
	  		/*Inserting DEN from the tmp Table*/	
		   BEGIN	
			INSERT INTO	#AetCOP(
							[srcFileName]
							, [adiTableName]
							, [adiKey]
							, [ClientKey]
							, [ClientMemberKey]
							, [QmMsrId]
							, [QmCntCat]
							, [QMDate]
							, srcQMID
							, srcQMDescription)
				SELECT		tmp.SrcFileName
							,tmp.AdiTableName
							,tmp.Adikey
							,tmp.ClientKey
							,tmp.[ClientMemberKey]
							,tmp.QmMsrId
							,'DEN'    AS    QmCntCat
							,tmp.QMDate
							,tmp.srcQMID
							,tmp.srcQmDescription		
				FROM		 #COP tmp
				WHERE		NewMbrCOPStatus IN ('NUM','COP')
			END

			/*Calculating Records for NUM and COP*/
			BEGIN	
					INSERT INTO	#AetCOP(
							[srcFileName]
							, [adiTableName]
							, [adiKey]
							, [ClientKey]
							, [ClientMemberKey]
							, [QmMsrId]
							, [QmCntCat]
							, [QMDate]
							, srcQMID
							, srcQMDescription)
				SELECT		tmp.SrcFileName
							,tmp.AdiTableName
							,tmp.Adikey
							,tmp.ClientKey
							,tmp.[ClientMemberKey]
							,tmp.QmMsrId
							,CASE    WHEN   NewMbrCOPStatus = 'NUM' THEN 'NUM'
									 WHEN   NewMbrCOPStatus = 'COP' THEN 'COP'
							          ELSE  QmCntCat 
									  END				AS   QmCntCat ---,MbrCOPStatus
							,tmp.QMDate
							,tmp.srcQMID
							,tmp.srcQmDescription		
				FROM		 #COP tmp
				WHERE		NewMbrCOPStatus IN ('NUM','COP')
			END

			/*Calculating Records for Invalid Records*/
			BEGIN	
					INSERT INTO	#AetCOP(
							[srcFileName]
							, [adiTableName]
							, [adiKey]
							, [ClientKey]
							, [ClientMemberKey]
							, [QmMsrId]
							, [QmCntCat]
							, [QMDate]
							, srcQMID
							, srcQMDescription)
				SELECT		tmp.SrcFileName
							,tmp.AdiTableName
							,tmp.Adikey
							,tmp.ClientKey
							,tmp.[ClientMemberKey]
							,tmp.QmMsrId
							,QmCntCat 
							,tmp.QMDate
							,tmp.srcQMID
							,tmp.srcQmDescription		
				FROM		 #COP tmp
				WHERE		NewMbrCOPStatus NOT IN ('NUM','COP')
			END
			-- SELECT * FROM #AetCOP
			
			/*Insert into staging*/
			BEGIN

				INSERT INTO		[ast].[QM_ResultByMember_History](
								[astRowStatus]
								, [srcFileName]
								, [adiTableName]
								, [adiKey]
								, [LoadDate]
								, [ClientKey]
								, [ClientMemberKey]
								, [QmMsrId]
								, [QmCntCat]
								, [QMDate]
								, [srcQMID]
								, [srcQmDescription])
				
				SELECT			'Loaded'
								, [srcFileName]
								, [adiTableName]
								, [adiKey]
								, CONVERT(DATE,GETDATE())	AS LoadDate
								, [ClientKey]
								, [ClientMemberKey]
								, [QmMsrId]
								, [QmCntCat]
								, [QMDate]
								, [srcQMID]
								, [srcQmDescription]
				FROM			#AetCOP
			
	
			END

			/*Update adi RowStatus*/
			BEGIN
			UPDATE  [ACECAREDW].[adi].[copAetMaCareopps] 
			SET		CopStgLoadStatus = 1
			WHERE	CopStgLoadStatus = 0
			END

					SET					@ActionStart  = GETDATE();
					SET					@JobStatus =2  
					    				
					EXEC				ACECAREDW.amd.sp_AceEtlAudit_Close 
										@Audit_Id = @AuditID
										, @ActionStopTime = @ActionStart
										, @SourceCount = @InpCnt		  
										, @DestinationCount = @OutCnt
										, @ErrorCount = @ErrCnt
										, @JobStatus = @JobStatus   

		---Validation_Tmp
		SELECT		COUNT(*)
                        ,[QmMsrId]
                        ,[QmCntCat] 
		FROM	#AetCOP
		WHERE           QMDate = @QMDATE
        AND             ClientKey = @ClientKey
        GROUP BY        [QmMsrId]
                        ,[QmCntCat]
        ORDER BY        [QmMsrId],[QmCntCat]
		
		
		DROP TABLE #AetCOP
		DROP TABLE #Src
		DROP TABLE #COP


		COMMIT
		END TRY

		BEGIN CATCH
		EXECUTE [dbo].[usp_QM_Error_handler]
		END CATCH

		END
		
		
		--Validation
		SELECT          COUNT(*)
                        ,[QmMsrId]
                        ,[QmCntCat]
        FROM            [ast].[QM_ResultByMember_History]
        WHERE           QMDate = @QMDATE
        AND             ClientKey = @ClientKey
        GROUP BY        [QmMsrId]
                        ,[QmCntCat]
        ORDER BY        [QmMsrId],[QmCntCat]






 
  
