






CREATE VIEW [dbo].[vw_SSRS_ProviderGap_Aetna]
AS
    -- OBJECTIVE: Gets care gaps for a provider for the Current month (active members only, with current PCP etc)
     SELECT DISTINCT src.[ClientMemberKey],
            CASE 
                 WHEN [QmMsrId] = 'DHTX_AWV'
                 THEN 'PCP Visit'      
                 WHEN [QmMsrId] = 'DHTX_CBP'
                 THEN 'Controlling Blood Pressure'      
                 WHEN [QmMsrId] = 'DHTX_CDC_E'
                 THEN 'Diabetes Retinal Screen'      
                 WHEN [QmMsrId] = 'DHTX_CDC_G_9'
                 THEN 'Diabetes Hba1c Control'      
                 WHEN [QmMsrId] = 'DHTX_CDC_N'
                 THEN 'Diabetes Kidney Monitoring'      
                 WHEN [QmMsrId] = 'DHTX_HYP_MGT'
                 THEN 'Controlling BP Reason'      
                 WHEN [QmMsrId] = 'DHTX_SPD'
                 THEN 'Diabetes Statin Use'      
                 else QM_DESC end as  [QmMsr_Tb_Desc],
            src.[QmMsrId], 
            src.[QMDate], 
            src.LOB, 
            src.QM_DESC AS MeasureDesc,		  
            CASE
                WHEN src.[QmCntCat] = 'DEN'
                THEN 1
                ELSE 0
            END AS MbrDEN,
            CASE
                WHEN src.[QmCntCat] = 'NUM'
                THEN 1
                ELSE 0
            END AS MbrNUM,
            CASE
                WHEN src.[QmCntCat] = 'COP'
                THEN 1
                ELSE 0
            END AS MbrCOP, 
            src.[AGE], 
            src.[PCP_PRACTICE_TIN], 
            src.[PCP_PRACTICE_NAME], 		  
		  src.DATE_OF_BIRTH,
		  src.GENDER,
		  src.MEMBER_HOME_PHONE,		   
		  src.PCP_NAME, 
		  src.NPI,
		  src.[PCP_PHONE], 		  
		  src.[MEMBER NAME],
            src.NPI AS PCP_NPI,             
            CASE
                WHEN src.MeasureID IS NULL
                THEN 'Not Contracted'
                ELSE 'Contracted'
            END AS 'Contract?',
            CASE
                WHEN src.ClientMemberKey IS NULL
                THEN 'NOT ACE_MBR'
                ELSE 'ACE MBR'
            END AS 'ACE MBR?', 
            src.clientshortname AS Client,             
		  src.ClientKey
     FROM(SELECT 
                QM.[ClientMemberKey], 
                QM.clientkey, 
                QM.[QmMsrId], 
                --QM.[QmCntCat], 
			 CASE WHEN (QM.QmMsrId = 'UHC_CDC_G_9' AND qm.QmCntCat = 'NUM') THEN 'COP'
						WHEN (QM.QmMsrId = 'UHC_CDC_G_9' AND qm.QmCntCat = 'COP') THEN 'NUM'
						ELSE qm.QmCntCat END qmCntCat,
                QM.[QMDate],
               /* CASE
                    WHEN lstPlnMap.TargetValue IN('MMP', 'MMP NF', 'MMP  NF', 'MMP Waiver')
                    THEN 'MMP'
                    WHEN lstPlnMap.TargetVALUE IN('STARKIDS', 'STARKIDS IDD')
                    THEN 'STARKIDS'
                    WHEN lstPlnMap.TargetVALUE IN('STARPLUS IDD', 'STARPLUS NHC', 'STARPLUS NHR', 'TX-STAR+PLUS', 'TX STAR+PLUS 111', 'TX STAR+PLUS 120', 'TX STAR+PLUS 123', 'TX STAR+PLUS 901')
                    THEN 'STARPLUS'
                    WHEN lstPlnMap.TargetVALUE IN('TX-CHIP', 'TX-CHIP Pregnant Women')
                    THEN 'TX-CHIP'
                    WHEN lstPlnMap.TargetVALUE IN('TX-STAR', 'TX-STAR Pregnant Women')
                    THEN 'TX-STAR'
				else ActiveMembers.SUBGRP_NAME*/
                '' LOB, 
                LQM.QM, 
                LQM.QM_DESC, 
                ActiveMembers.[AGE],
			 ActiveMembers.DATE_OF_BIRTH,
			 ActiveMembers.GENDER,
			 ActiveMembers.MEMBER_HOME_PHONE,
                ActiveMembers.[PCP_PRACTICE_TIN], 
                ActiveMembers.[PCP_PRACTICE_NAME], 
			 ActiveMembers.PCP_NAME, 
                ActiveMembers.NPI,
                ActiveMembers.[PCP_PHONE],                 
			 ActiveMembers.MEMBER_LAST_NAME	+ ', ' + ActiveMembers.MEMBER_FIRST_NAME AS 'MEMBER NAME',
                CareOpToPlan.MeasureID,                                 
                Client.ClientShortName     ---- SELECT *
    FROM ACDW_CLMS_AET_MA.[adw].[QM_ResultByMember_History]  QM 
	       JOIN ACECAREDW.dbo.vw_ActiveMembers ActiveMembers  -- SELECT * FROM dbo.vw_ActiveMembers ActiveMembers  WHERE CLIENTKEY = 3
	   	   ON QM.ClientMemberKey = ActiveMembers.MEMBER_ID 
	       JOIN lst.List_Client Client ON Client.ClientKey = qm.ClientKey
    	       JOIN ACEMasterData.lst.LIST_QM_Mapping LQM 
	   	   ON LQM.QM = QM.[QmMsrId]
	   		  AND QM.QMDate BETWEEN LQM.EffectiveDate AND LQM.ExpirationDate    	   
	       /*JOIN (SELECT LstPlanMapping.lstPlanMappingKey, lstPlanMapping.SourceValue, lstPlanMapping.TargetValue, lstPlanMapping.EffectiveDate, lstPlanMapping.ExpirationDate
	   			 FROM lst.lstPlanMapping LstPlanMapping
	   			 WHERE LstPlanMapping.TargetSystem = 'CS_AHS' ) lstPlnMap 
	   		ON ActiveMembers.SUBGRP_ID = lstPlnMap.TargetValue AND QM.QMDate BETWEEN lstPlnMap.EffectiveDate and lstPlnMap.ExpirationDate*/
	       JOIN ACEMasterData.[lst].[lstCareOpToPlan] CareOpToPlan --where active = 'Y' and clientkey = 1 order by measureID, csPlan
	   	   ON QM.[QmMsrId] = CareOpToPlan.[MeasureID] 
	   		--  AND CareOpToPlan.CsPlan = lstPlnMap.TargetValue
	   		  AND CareOpToPlan.ACTIVE = 'Y'
	   		  AND qm.QMDate BETWEEN CareOpToPlan.EffectiveDate and CareOpToPlan.ExpirationDate
	   		  AND QM.ClientKey = CareOpToPlan.ClientKey     
    WHERE LQM.ACTIVE = 'Y'	  
	   AND NOT QM.QmMsrID IN ('UHC_FUH_30_0617','UHC_FUH_30_1864','UHC_FUH_7_0617','UHC_FUH_7_1864', 'UHC_URI')     	   
	   AND qm.ClientKey = Client.ClientKey	  	   
	   --AND qm.QMDate  >= DATEFROMPARTS(Year(getdate()), 1,1)
	   AND qm.QMDate  >= (SELECT MAX(QMDATE) 
							FROM [adw].[QM_ResultByMember_History])

	   )  SRC	   

