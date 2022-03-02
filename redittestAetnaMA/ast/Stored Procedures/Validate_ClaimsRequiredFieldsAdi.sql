-- exec [ast].[Validate_ClaimsRequiredFieldsAdi] 3
CREATE PROCEDURE [ast].[Validate_ClaimsRequiredFieldsAdi] (
    @ClientKey INT 
    )
AS 
BEGIN 
    /* Objective: 
    1. for required columns in claims CHECK IF it matches the List table domain
	   a. return the not matching
    2. for 

    */
    
    --declare @clientkey int = 1;
    SELECT 'Look up distinct value for each required field from the Adi'
    Select 'If needed use decoder table to get to a meaningful domain'
    SELECT ' Fields that must be profiled: '
    union select     'DONE Claims_Member	GENDER'
    union select     'DONE Claims_Headers	PROV_SPEC'
    union select     'DONE Claims_Headers	DRG_CODE'
    union select     'DONE Claims_Headers	CLAIM_STATUS'
    union select     'DONE Claims_Details	PROCEDURE_CODE'
    union select     'DONE Claims_Details	REVENUE_CODE'
    union select     'DONE Claims_Details	PLACE_OF_SVC_CODE1'
    union select     'DONE Claims_Details	NDC_CODE'								
    union select     'DONE Claims_Diags		diagCode'
    union select     'DONE Claims_Procs		ProcCode'
    union select     'DONE Claims_Headers	CATEGORY_OF_SVC'						--
    union select     'DONE Claims_Headers	CLAIM_TYPE'						---
    union select     'DONE Claims_Headers	DISCHARGE_DISPO'
    union select     'DONE Claims_Headers	BILL_TYPE  '
    union select     'DONE Claims_Headers	DRG_CODE '
    union select     'NOT APPLICABLE Claims_Headers	CMS_CertificationNumber'	-- 0
    union select     'NOT NEEDED Claims_Headers	VENDOR_ID '					--- 0
    union select	 'DONE CLM_LN_MSG_CD'
    union select	 'DONE MED_COST_SUBCTG_CD'
    union select	 'DONE PRCDR_GROUP_NBR'
    union select	 'DONE PRCDR_TYPE_CD'
    union select	 'DONE Claim_Type'
    union select	 'NOT APPLICABLE RenderingProvider'							-- 0
    select 'P:\Information Technology\00_Work Folder\Onboarding\Aetna MA\Layout_Files\file_layout changes_09082020\VBC_Record_Layout_Claim_File.xlsx'
    select 'P:\Information Technology\00_Work Folder\Onboarding\Aetna MA\Technical Docs\ACE_ETL_ST_248_AetnaMAClaims_v4.xlsx'
	
/* 
    1. NEED TO BE GROUP BY to flaten
    2. Need to have a code filter where appropriate, code type value is the field Name in the adi table
    3. left Join to the Lst table when possible so we can evaluate gaps 
*/


    /* add a query for each field */	
    	
    SELECT c.hcfa_bill_type_cd, ac.CODE_DESC, 'The code description maps to the CMS Bill type definition'
    FROM adi.ClaimAetMA c
	   LEFT  JOIN adi.AETNA_CODES ac 
		  ON c.hcfa_bill_type_cd = ac.CODE_VALUE
    WHERE ac.CODE = 'hcfa_bill_type_cd'
    GROUP BY c.hcfa_bill_type_cd, ac.CODE_DESC


    SELECT c.pri_icd9_dx_cd, ac.CODE_DESC	
    FROM adi.ClaimAetMA c
	   LEFT JOIN adi.AETNA_CODES ac on c.pri_icd9_dx_cd = ac.CODE_VALUE
    GROUP BY c.pri_icd9_dx_cd, ac.CODE_DESC

    select distinct * 
    from adi.aetna_codes c
    where c.code = 'REVENUE_CODE'

    select c.mem_gender,CASE WHEN ( c.mem_gender = 'M') THEN 1
							 WHEN ( c.mem_gender = 'F') THEN 2
							 ELSE 3 END 
    FROM adi.ClaimAetMA c
    GROUP BY c.mem_gender
 
    SELECT c.SPECIALTY_CTG_CD,ac.CODE_DESC, provSpec.CodeDesc
    FROM adi.ClaimAetMA c
	   LEFT JOIN adi.AETNA_CODES ac on c.SPECIALTY_CTG_CD = ac.CODE_VALUE
	   LEFT JOIN (SELECT code, codeDesc FROM aceMasterData.[lst].[LIST_PROV_SPECIALTY_CODES]  ) provSpec ON ac.CODE_DESC = provSpec.CodeDesc
    WHERE ac.CODE = 'SPECIALTY_CTG_CD'
    GROUP BY c.SPECIALTY_CTG_CD,ac.CODE_DESC, provSpec.CodeDesc
    ORDER BY c.SPECIALTY_CTG_CD,ac.CODE_DESC

    SELECT c.drg_cd,ac.CODE_DESC, drg.DRG_CODE
    FROM adi.ClaimAetMA c
	   LEFT JOIN adi.AETNA_CODES ac on c.drg_cd = ac.CODE_VALUE 
	   LEFT JOIN (SELECT DISTINCT drg.DRG_CODE FROM aceMasterData.[lst].[List_DRG] drg )drg
		  ON c.drg_cd = drg.DRG_CODE
	WHERE ac.code ='drg_cd'
	GROUP BY c.drg_cd, ac.CODE_DESC, drg.DRG_CODE

	

	SELECT c.clm_ln_status_cd,ac.CODE_DESC
	FROM adi.ClaimAetMA c
	LEFT JOIN adi.AETNA_CODES ac on c.clm_ln_status_cd = ac.CODE_VALUE
	WHERE ac.code ='clm_ln_status_cd'
	GROUP BY c.clm_ln_status_cd, ac.CODE_DESC
	   
    

    select c.revenue_cd,UBREV_DESC 
	FROM adi.ClaimAetMA c
	LEFT JOIN (SELECT UBREV_CODE,UBREV_DESC FROM ACEMasterData.[lst].[List_UBREV]) p
		ON  c.revenue_cd = p.UBREV_CODE
    GROUP BY  c.revenue_cd,UBREV_DESC
	ORDER BY revenue_cd

 	SELECT c.HCFA_PLC_SRV_CD,ac.CODE_DESC,Place_of_Service_Description
	FROM adi.ClaimAetMA c
	LEFT JOIN adi.AETNA_CODES ac on c.HCFA_PLC_SRV_CD = ac.CODE_VALUE
	LEFT JOIN (SELECT DISTINCT Place_Of_Service_Code,Place_of_Service_Description FROM ACEMasterData.[lst].[LIST_Place_of_SVC]) p
		ON c.HCFA_PLC_SRV_CD = p.Place_Of_Service_Code
	WHERE ac.code ='HCFA_PLC_SRV_CD'
	GROUP BY C.HCFA_PLC_SRV_CD, ac.CODE_DESC,Place_of_Service_Description

	select SUBSTRING(c.prcdr_cd_ndc,1,8)as prcdr_cd_ndc,NDC.NDC, ndc.ProductTypeName -- [AceMasterData].[lst].[lstNdcDrugProduct] on replace([ProductNDC],'-','')
    FROM adi.ClaimAetMA c 
	LEFT JOIN ( SELECT *,replace([ProductNDC],'-','') NDC FROM [AceMasterData].[lst].[lstNdcDrugProduct])NDC 
	on ndc.NDC =SUBSTRING(c.prcdr_cd_ndc,1,8)	WHERE C.prcdr_cd_ndc <> ''

	select c.prcdr_cd,CPT_DESC 
	FROM adi.ClaimAetMA c
	LEFT JOIN (SELECT CPT_CODE ValueCode,CPT_DESC FROM AceMasterData.[lst].[List_CPT] )p ON c.prcdr_cd = p.ValueCode  
	GROUP BY  c.prcdr_cd,CPT_DESC
	
	-- this is the icd proc, look in [ClaimsLoadFromTest_Transforms] for list table 
	   

   	SELECT c.TYPE_SRV_CD,ac.CODE_DESC,LKUP_DESC
	FROM adi.ClaimAetMA c
	   LEFT JOIN adi.AETNA_CODES ac on c.TYPE_SRV_CD = ac.CODE_VALUE
	-- do this with Based on this code look up the decoder and bring in the lookup LKUP_DESC
	WHERE ac.code ='TYPE_SRV_CD'
	GROUP BY c.TYPE_SRV_CD, ac.CODE_DESC,LKUP_DESC



	SELECT c.DSCHRG_STATUS_CD,ac.CODE_DESC
	FROM adi.ClaimAetMA c
	LEFT JOIN adi.AETNA_CODES ac on c.DSCHRG_STATUS_CD = ac.CODE_VALUE
	LEFT JOIN (SELECT Disch_Disp_Code,Disch_Disp_Description from aceMasterData.[lst].[LIST_Disch_Disposition]  ) dsch ON ac.CODE_DESC = dsch.Disch_Disp_Description
	WHERE ac.code ='DSCHRG_STATUS_CD'
	GROUP BY c.DSCHRG_STATUS_CD, ac.CODE_DESC

	SELECT c.DRG_CD,ac.CODE_DESC
	FROM adi.ClaimAetMA c
	LEFT JOIN adi.AETNA_CODES ac on c.DRG_CD = ac.CODE_VALUE
	WHERE ac.code ='DRG_CD'
	GROUP BY c.DRG_CD, ac.CODE_DESC

		 
 	SELECT c.src_claim_line_id_1,ac.CODE_DESC
	FROM adi.ClaimAetMA c
	LEFT JOIN adi.AETNA_CODES ac on c.src_claim_line_id_1 = ac.CODE_VALUE
	WHERE CODE ='CLM_LN_MSG_CD'
	GROUP BY c.src_claim_line_id_1, ac.CODE_DESC

	SELECT c.MED_COST_SUBCTG_CD,ac.CODE_DESC
	FROM adi.ClaimAetMA c
	LEFT  JOIN adi.AETNA_CODES ac on c.src_claim_line_id_1 = ac.CODE_VALUE
	WHERE CODE ='MED_COST_SUBCTG_CD'
	GROUP BY c.MED_COST_SUBCTG_CD, ac.CODE_DESC

	SELECT c.prcdr_group_nbr,ac.CODE_DESC
	FROM adi.ClaimAetMA c
	LEFT JOIN adi.AETNA_CODES ac on c.src_claim_line_id_1 = ac.CODE_VALUE
	WHERE CODE ='PRCDR_GROUP_NBR'
	GROUP BY  c.prcdr_group_nbr, ac.CODE_DESC

	
		 
	SELECT c.PRCDR_TYPE_CD,ac.CODE_DESC
	FROM adi.ClaimAetMA c
	LEFT JOIN adi.AETNA_CODES ac on c.PRCDR_TYPE_CD = ac.CODE_VALUE
	GROUP BY C.PRCDR_TYPE_CD , ac.CODE_DESC
		
    SELECT DISTINCT 'No corresponding value' CMS_CertificationNumber
    FROM adi.ClaimAetMA adi
	SELECT DISTINCT 'Need to review adi and find a candidate column' Vendor_id
    SELECT DISTINCT 'Need to review adi and find a candidate column' RenderingProvider
  
END;

