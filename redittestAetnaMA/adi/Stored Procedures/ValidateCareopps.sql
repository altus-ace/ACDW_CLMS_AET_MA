

CREATE PROCEDURE [adi].[ValidateCareopps]

AS

	/* Checking for Max Dates*/
	SELECT	COUNT(*)RecCnt
			,DataDate AS DataDate_plsCareopps_copAetMaCareopps
			,CopStgLoadStatus
	FROM	[ACECAREDW].[adi].[copAetMaCareopps] 
	WHERE	CopStgLoadStatus = 0
	GROUP BY DataDate,CopStgLoadStatus
	ORDER BY DataDate DESC
	

	
	/*A: Validation*/
	DECLARE @DataDate DATE = (
					SELECT	MAX(DataDate)
					FROM	[ACECAREDW].[adi].[copAetMaCareopps]
					)
	SELECT	DISTINCT Measures AS MeasuresInAdiAndLookUpTableForplsCareopps_AllMeasures
			, Source,Destination
	FROM	(	/*List of all Pivoted Columns*/
				SELECT	[Readmissions-AllCause] ,[MedicationReconciliationPostDischarge],[Breast ScreeningCompliance],[ColorectalScreeningCompliance]
					 ,[AceiArbAdherence],[Acei ArbPDCYTD],[DiabetesEyeExam],[DiabetesNephropathyScreening],[DiabetesLdlControl],[DiabetesLdlLevel],[DiabetesMedicationAdherence]
					 ,[DiabetesMedicationPDCYTD],[DiabetesControlledHbA1c],[DiabetesHba1C Level],[StatinUseInDiabetics]
					 ,[StatinMedicationAdherence],[StatinMedicationPDCYTD],[OsteoporosisManagement],[RheumatoidArthritisManagement]
					 ,[AdultBMIAssessment],[OfficeVisits],[LastOfficeVisit],[OfficeVisits-Chronic1stHalf]
					 ,[Office Visits-Chronic2ndHalf],[Last OfficeVisit-Chronic] ,[AnnualFluVaccine],[ControllingHighBloodPressure]
					 ,[StatinTherapyCardiovascularDisease]
				FROM	[ACECAREDW].[adi].[copAetMaCareopps]  adi
				WHERE	DataDate = @DataDate
			)adi
	UNPIVOT
			(Metrics FOR Measures IN ([Readmissions-AllCause] ,[MedicationReconciliationPostDischarge],[Breast ScreeningCompliance],[ColorectalScreeningCompliance]
					 ,[AceiArbAdherence],[Acei ArbPDCYTD],[DiabetesEyeExam],[DiabetesNephropathyScreening],[DiabetesLdlControl],[DiabetesLdlLevel],[DiabetesMedicationAdherence]
					 ,[DiabetesMedicationPDCYTD],[DiabetesControlledHbA1c],[DiabetesHba1C Level],[StatinUseInDiabetics]
					 ,[StatinMedicationAdherence],[StatinMedicationPDCYTD],[OsteoporosisManagement],[RheumatoidArthritisManagement]
					 ,[AdultBMIAssessment],[OfficeVisits],[LastOfficeVisit],[OfficeVisits-Chronic1stHalf]
					 ,[Office Visits-Chronic2ndHalf],[Last OfficeVisit-Chronic] ,[AnnualFluVaccine],[ControllingHighBloodPressure]
					 ,[StatinTherapyCardiovascularDisease]))pvt
	JOIN (SELECT	Destination,Source
					FROM	lst.ListAceMapping
					WHERE	ClientKey = 3
					AND		MappingTypeKey = 14
					AND ACTIVE = 'Y') lstAce
	ON	pvt.Measures = lstAce.Source

	/*B: Show me Measures not in the look up Table*/
		SELECT	DISTINCT Measures AS MeasuresInAdiAndLookUpTableForplsCareopps_AllMeasures
			, Source,Destination
	FROM	(	/*List of all Pivoted Columns*/
				SELECT	[Readmissions-AllCause] ,[MedicationReconciliationPostDischarge],[Breast ScreeningCompliance],[ColorectalScreeningCompliance]
					 ,[AceiArbAdherence],[Acei ArbPDCYTD],[DiabetesEyeExam],[DiabetesNephropathyScreening],[DiabetesLdlControl],[DiabetesLdlLevel],[DiabetesMedicationAdherence]
					 ,[DiabetesMedicationPDCYTD],[DiabetesControlledHbA1c],[DiabetesHba1C Level],[StatinUseInDiabetics]
					 ,[StatinMedicationAdherence],[StatinMedicationPDCYTD],[OsteoporosisManagement],[RheumatoidArthritisManagement]
					 ,[AdultBMIAssessment],[OfficeVisits],[LastOfficeVisit],[OfficeVisits-Chronic1stHalf]
					 ,[Office Visits-Chronic2ndHalf],[Last OfficeVisit-Chronic] ,[AnnualFluVaccine],[ControllingHighBloodPressure]
					 ,[StatinTherapyCardiovascularDisease]
				FROM	[ACECAREDW].[adi].[copAetMaCareopps]  adi
				WHERE	DataDate = @DataDate
			)adi
	UNPIVOT
			(Metrics FOR Measures IN ([Readmissions-AllCause] ,[MedicationReconciliationPostDischarge],[Breast ScreeningCompliance],[ColorectalScreeningCompliance]
					 ,[AceiArbAdherence],[Acei ArbPDCYTD],[DiabetesEyeExam],[DiabetesNephropathyScreening],[DiabetesLdlControl],[DiabetesLdlLevel],[DiabetesMedicationAdherence]
					 ,[DiabetesMedicationPDCYTD],[DiabetesControlledHbA1c],[DiabetesHba1C Level],[StatinUseInDiabetics]
					 ,[StatinMedicationAdherence],[StatinMedicationPDCYTD],[OsteoporosisManagement],[RheumatoidArthritisManagement]
					 ,[AdultBMIAssessment],[OfficeVisits],[LastOfficeVisit],[OfficeVisits-Chronic1stHalf]
					 ,[Office Visits-Chronic2ndHalf],[Last OfficeVisit-Chronic] ,[AnnualFluVaccine],[ControllingHighBloodPressure]
					 ,[StatinTherapyCardiovascularDisease]))pvt
	LEFT JOIN (SELECT	Destination,Source
					FROM	lst.ListAceMapping
					WHERE	ClientKey = 3
					AND		MappingTypeKey = 14
					AND		ACTIVE = 'Y') lstAce
	ON	pvt.Measures = lstAce.Source
	WHERE	lstAce.Source IS NULL


	/*
	
	---Staging
		
		
	SELECT COUNT(*)RecCnt
			,astRowStatus
			,QmMsrId,QmCntCat
			,MbrCareOpToPlnFlg
			,MbrCOPInContractFlg
			,MbrActiveFlg -- SELECT DISTINCT QmMsrId
	FROM	ast.QM_ResultByMember_History
	WHERE	QMDate = '2022-01-15'
	AND		astRowStatus = 'Exported' -- 'Valid'  --
	GROUP BY astRowStatus
			,QmMsrId,QmCntCat
			,MbrCareOpToPlnFlg
			,MbrCOPInContractFlg
			,MbrActiveFlg
	ORDER BY QmMsrId,QmCntCat
		
	--ADW

	SELECT          COUNT(*)
                       ,[QmMsrId]
                       ,[QmCntCat]  --- SELECT DISTINCT QmMsrId
       FROM            [adw].[QM_ResultByMember_History]
       WHERE           QMDate = '2022-01-15'
       AND             ClientKey = 3
       GROUP BY        [QmMsrId]
                       ,[QmCntCat]
       ORDER BY        [QmMsrId],[QmCntCat]

	SELECT	*
	FROM	adw.QM_ResultByValueCodeDetails_History
	WHERE	QMDate = '2022-01-15'

	SELECT	COUNT(*)
			,MbrActiveFlg
			,MbrCareOpToPlnFlg
			,MbrCOPInContractFlg
	FROM	adw.FailedCareOpps
	WHERE   QMDate = '2022-01-15'
	GROUP BY MbrActiveFlg
			,MbrCareOpToPlnFlg
			,MbrCOPInContractFlg
	*/

	