-- exec [adw].[ClaimsLoadFromTest_Transforms] 1
CREATE PROCEDURE [adw].[ClaimsLoadFromTest_Transforms] (
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
    /* DISABLE  Indexes for truncate and INsert  */
    ALTER INDEX [ndx_clmsMappingWork_CatSvcProvTypeClmPart] ON [ast].[ClmsMappingWork] DISABLE;
    ALTER INDEX [ndx_ClmsMappingWork_claimPartType] ON [ast].[ClmsMappingWork] DISABLE;
    
    /* truncate clmsMappingWork */
    TRUNCATE TABLE  ast.ClmsMappingWork;
    INSERT INTO ast.ClmsMappingWork (SEQ_CLAIM_ID, ClaimType, billType, Category_Of_Svc, Prov_type, NewProvType, ClaimPartType, ClaimTYpeCode)
    SELECT h.SEQ_CLAIM_ID, h.CLAIM_TYPE, h.BILL_TYPE, h.CATEGORY_OF_SVC, h.PROV_TYPE, '' NewProvType
	   , CASE WHEN (CLAIM_TYPE IN ('MED-UB','UBH-INST')) THEN 'PartA'
	      WHEN (CLAIM_TYPE IN ('MED-HCFA','UBH-PROF')) THEN 'PartB' --'MED-UB','UBH-INST','DENTAL','VISION')
		 WHEN (CLAIM_TYPE IN ('PHARMACY', 'PHARM')) THEN 'PartD'
		 ELSE 'other' END AS ClaimPartType
	   ,CASE WHEN ((h.CATEGORY_OF_SVC = 'INPATIENT' ) AND (CLAIM_TYPE IN ('MED-UB','UBH-INST'))) THEN '60'
	     WHEN ((h.CATEGORY_OF_SVC = 'OUTPATIENT') AND (CLAIM_TYPE IN ('MED-UB','UBH-INST')))THEN '40'
		WHEN ((h.CATEGORY_OF_SVC = 'OUTPATIENT') AND (CLAIM_TYPE IN ('MED-HCFA','UBH-PROF')))THEN '40'
		WHEN ((h.CATEGORY_OF_SVC = 'PHYSICIAN')  AND (CLAIM_TYPE IN ('MED-HCFA','UBH-PROF')))THEN '71'		
		  ELSE '99' END																	as ClaimTypeCD    		        
    FROM adw.Claims_Headers H
    ;
    /* Rebuild indexes */     
    ALTER INDEX [ndx_clmsMappingWork_CatSvcProvTypeClmPart] ON [ast].[ClmsMappingWork] REBUILD;
    ALTER INDEX [ndx_ClmsMappingWork_claimPartType] ON [ast].[ClmsMappingWork] REBUILD;

    /* update catOfSvc */
    --SELECT c.*    , mcs.*
    --declare @clientkey int = 1;
    IF @Clientkey <> 1
    BEGIN 
	   Update c set c.Category_Of_Svc = mcs.CatOfSvc
	   FROM ast.ClmsMappingWork c
    		  JOIN ast.clmMapCatOfSvc mcs ON LEFT (c.BillType , 2) = mcs.BillType
	   WHERE c.ClaimPartType <> 'PartB'
		  and c.Category_Of_Svc <> mcs.CatOfSvc
	   ;
	   /* update Claim_Type to claim_type Code */
	   --SELECT c.*    , mcs.*
	   Update c set c.ClaimType  = mcs.ClaimType
	   FROM ast.ClmsMappingWork c
	   	   JOIN ast.clmMapCatOfSvc mcs ON LEFT (c.BillType , 2) = mcs.BillType
	   WHERE c.ClaimPartType <> 'PartB'
		  and c.ClaimType  <> mcs.ClaimType
	   ;
    END;
    if @ClientKey in (1)
    BEGIN 
	   -- UPdate ClaimTYpe = CLaim Type COde
	   /* Part a Trans*/	   
	   --select c.claimType, mcs.ClaimType
	   UPDATE c SET c.ClaimType = mcs.ClaimType
	   FROM ast.ClmsMappingWork c	   
		  JOIN ast.clmMapCatOfSvc mcs 
			 ON c.Category_Of_Svc = mcs.CatOfSvc
				and LEFT (c.BillType , 2) = mcs.BillType
	   WHERE c.ClaimPartType = 'PartA'
		  AND c.ClaimType <> ClaimTYpeCode

	   /* Part B Trans*/
	   --SELECT c.SEQ_CLAIM_ID, c.ClaimType, mpt.ProvType, mcs.ClaimType, mcs.*, c.*, mpt.*
	   UPDATE c SET c.claimType = mcs.ClaimType 
	   FROM ast.ClmsMappingWork c
		  LEFT JOIN ast.clmMapProvType mpt 
			 ON c.Category_Of_Svc = mpt.CatOfSvc
	   			and C.Prov_type = mpt.ProvTypeDesc	
		  LEFT JOIN ast.clmMapCatOfSvc mcs 
			 ON c.Category_Of_Svc = mcs.CatOfSvc
				and c.ClaimPartType = mcs.ClaimPartType
				and mpt.ProvType = mcs.ProvType								
	   WHERE c.ClaimPartType = 'PartB'		
	     and c.ClaimTYpe <> mcs.ClaimType		
	   
		
	   /* Part d Trans*/
	   --SELECT *
	   UPDATE c set c.ClaimType = '01'
	   FROM ast.ClmsMappingWork c	   
	   where c.ClaimPartType = 'PartD'		  
			 
    END;  
    
    SELECT c.ClaimType, c.ClaimPartType,  count(*) cnt 
    FROM ast.ClmsMappingWork c
    group by c.ClaimType, c.ClaimPartType 

    /* update ADW with Changes from Claim_Type to claim_type Code */
    --SELECT *
    UPDATE h SET h.CLAIM_TYPE = c.ClaimType
    FROM ast.ClmsMappingWork c
	   Join adw.Claims_Headers H ON c.SEQ_CLAIM_ID = h.SEQ_CLAIM_ID 
    WHERE c.ClaimType <>  h.CLAIM_TYPE;


    SELECT distinct hdr.PROV_TYPE, Map.NewProvType
    --UPDATE hdr set hdr.PROV_TYPE = map.NewProvType
    FROM adw.Claims_Headers Hdr
	   JOIN (SELECT t.BillType, t.CATEGORY_OF_SVC, t.ClaimType srcClaimType, t.PROV_TYPE, t.SEQ_CLAIM_ID, t.ClaimPartType, t.ClaimTypeCode NewClaimType, t.NewProvType
			 , cs.CatOfSvc    AS NewCatOfSvc
		  FROM ast.ClmsMappingWork t    
			 JOIN ast.clmMapCatOfSvc cs 
			 ON  t.ClaimPartType = cs.ClaimPartType
				and t.NewProvType = cs.ProvType
    				AND t.ClaimTYpeCode = CS.ClaimType) Map 
		  ON Hdr.SEQ_CLAIM_ID = Map.SEQ_CLAIM_ID
			 

/* XXXXX		 THIS IS good from Here	    XXXXX */
    
    SELECT distinct hdr.PROV_SPEC
    FROM adw.Claims_Headers Hdr
 --[lst].[LIST_PROV_SPECIALTY_CODES]  
 
  
    --SELECT distinct hdr.DRG_CODE
    update hdr set hdr.DRG_CODE = null
    FROM adw.Claims_Headers Hdr
    where hdr.DRG_CODE = 'NO_APR'
--[lst].[List_DRG]

    SELECT distinct hdr.CLAIM_STATUS
    FROM ACDW_CLMS_SHCN_MSSP.adw.Claims_Headers Hdr
-- Expected Values ( ) Not needed  
    
    SELECT distinct hdr.DISCHARGE_DISPO, 'No value in source FILE'
    FROM adw.Claims_Headers Hdr
    
    select * 
    from [lst].[LIST_Disch_Disposition]
-- no value in adi? NO COLUMN IN src file

    SELECT distinct hdr.BILL_TYPE, Len(hdr.Bill_TYPE) LengthBillType
    FROM adw.Claims_Headers Hdr
    ORDER BY LengthBillType desc
-- 2 or 3 digit -- Good

    SELECT distinct hdr.CMS_CertificationNumber, LEN(hdr.CMS_CertificationNumber) CMS_Cert_Length
    FROM adw.Claims_Headers Hdr
-- 6 digit, no mapping

    
    /* TRIM NPIs to 10 char */
    UPDATE hdr SET hdr.VENDOR_ID = right(hdr.VENDOR_ID, 10)
    FROM adw.Claims_Headers Hdr
    WHERE LEFT(hdr.VENDOR_ID, 2) = '00'
    /* Match NPIs, that are not V codes*/
    SELECT distinct hdr.VENDOR_ID, p.NPI , 'lst.List_NPPES_NPI' MatchTable
    FROM adw.Claims_Headers Hdr
	   LEFT JOIN (SELECT Npi FROM AceMasterData.[lst].[LIST_NPPES_NPI] N) p ON hdr.Vendor_id = p.NPI
    WHERE LEFT (hdr.VENDOR_ID,1) <> 'V'
    /* select out v Codes to review */
    SELECT distinct hdr.VENDOR_ID, p.NPI, 'lst.List_NPPES_NPI' MatchTable, 'Vendor ID not an NPI' Reason
    FROM adw.Claims_Headers Hdr
	   LEFT JOIN (SELECT Npi FROM AceMasterData.[lst].[LIST_NPPES_NPI] N) p ON hdr.Vendor_id = p.NPI
    WHERE LEFT (hdr.VENDOR_ID,1) = 'V'
    


    SELECT distinct d.PROCEDURE_CODE, p.ValueCode, 'lst.List_CPT' MatchTable
    FROM adw.Claims_Details d
	   LEFT JOIN (SELECT CPT_CODE ValueCode FROM AceMasterData.[lst].[List_CPT] )p ON d.PROCEDURE_CODE = p.ValueCode   

    SELECT top 1 *, 'List_HPCPS' MatchType
    FROM AceMasterData.[lst].[List_HCPCS] h

    SELECT distinct d.REVENUE_CODE, p.UBREV_CODE, 'ACEMasterData.[lst].[List_UBREV]' matchTable
    FROM adw.Claims_Details d
	   LEFT JOIN (SELECT UBREV_CODE FROM ACEMasterData.[lst].[List_UBREV]) p
		ON d.REVENUE_CODE = p.UBREV_CODE
    ORDER BY p.UBREV_CODE

    SELECT distinct d.PLACE_OF_SVC_CODE1, p.Place_Of_Service_Code, 'ACEMasterData.[lst].[LIST_Place_of_SVC]' MatchTable
    FROM adw.Claims_Details d
	 LEFT JOIN (SELECT DISTINCT Place_Of_Service_Code FROM ACEMasterData.[lst].[LIST_Place_of_SVC]) p
		ON d.PLACE_OF_SVC_CODE1 = p.Place_Of_Service_Code
	ORDER BY p.Place_of_Service_Code
	-- Good

    SELECT DISTINCT  LEFT(d.NDC_CODE,8), REPLACE(p.PRODUCTNDC,'-','') ProdNdc, 'ACEMasterData.lst.lstNdcDrugProduct' MatchTable
    FROM adw.Claims_Details d 
	 LEFT JOIN (SELECT DISTINCT PRODUCTNDC FROM ACEMasterData.lst.lstNdcDrugProduct) p
		ON LEFT(d.NDC_CODE,8) = REPLACE(p.PRODUCTNDC,'-','')
	 WHERE ndc_code <> 'N/A'
	 Order BY ProdNdc
	 -- Missing values in p, Check List Table

    SELECT distinct d.diagCode, d.diagCodeWithoutDot, p.VALUE_CODE, 'ACEMasterData.lst.LIST_ICD10CM' MatchTable
    FROM adw.Claims_Diags d
	 LEFT JOIN (SELECT DISTINCT VALUE_CODE FROM ACEMasterData.lst.LIST_ICD10CM) p
		ON d.diagCodeWithoutDot = p.VALUE_CODE
    ORDER BY p.VALUE_CODE 
		-- Good
    
    SELECT distinct d.ProcCode, p.ICD10PCS_Code
    FROM adw.Claims_Procs d  
	 LEFT JOIN (SELECT DISTINCT ICD10PCS_Code FROM ACEMasterData.lst.LIST_ICD10PCS) p
		ON d.ProcCode = p.ICD10PCS_Code
		-- Missing values in p, Check List Table
    ORDER BY p.ICD10PCS_Code

    UPDATE m SET m.Gender = CASE WHEN (m.Gender = 'M') THEN 1
							 WHEN (m.Gender = 'F') THEN 2
							 ELSE 3 END 
    /* SELECT m.Gender, CASE WHEN (m.Gender = 'M') THEN 1
							 WHEN (m.Gender = 'F') THEN 2
							 ELSE 3 END 
							 */
    FROM adw.Claims_Member m	 
 
	 -- Expected Values (1 M, 2 F, 3 U ) 
	 -- Transform issue, adi has value 1 M, 2 F, 3 U
    
END;

