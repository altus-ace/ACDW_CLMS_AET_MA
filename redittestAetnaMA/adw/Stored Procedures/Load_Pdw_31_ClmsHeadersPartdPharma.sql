
CREATE PROCEDURE [adw].[Load_Pdw_31_ClmsHeadersPartdPharma]
AS 
	/* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 8	  -- ADW load
	DECLARE @ClientKey INT	 = 16; -- mssp
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPartDClaimLineItem'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Headers'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM adi.Steward_MSSPPartDClaimLineItem c
	   JOIN ast.pstDeDupClms_PartDPharma d ON c.MSSPPartDClaimLineItemKey = d.urn
	

	EXEC amd.sp_AceEtlAudit_Open 
        @AuditID = @AuditID OUTPUT
        , @AuditStatus = @JobStatus
        , @JobType = @JobType
        , @ClientKey = @ClientKey
        , @JobName = @JobName
        , @ActionStartTime = @ActionStart
        , @InputSourceName = @SrcName
        , @DestinationName = @DestName
        , @ErrorName = @ErrorName
        ;
	CREATE TABLE #OutputTbl (ID VARCHAR(50) NOT NULL PRIMARY KEY);	

    -- Insert claims headers for Steward_MSSPPartBPhysicianClaimLineItem
    INSERT INTO adw.Claims_Headers
           ( SEQ_CLAIM_ID           
			,SUBSCRIBER_ID          
			,CLAIM_NUMBER           
			,CATEGORY_OF_SVC        
			,PAT_CONTROL_NO         
			,ICD_PRIM_DIAG          
			,PRIMARY_SVC_DATE       
			,SVC_TO_DATE            
			,CLAIM_THRU_DATE        
			,POST_DATE              
			,CHECK_DATE             
			,CHECK_NUMBER           
			,DATE_RECEIVED                     
			,ADJUD_DATE             
			,SVC_PROV_ID            
			,SVC_PROV_FULL_NAME     
			,SVC_PROV_NPI           
			,PROV_SPEC              
			,PROV_TYPE              
			,PROVIDER_PAR_STAT      
			,ATT_PROV_ID            
			,ATT_PROV_FULL_NAME     
			,ATT_PROV_NPI           
			,REF_PROV_ID            
			,REF_PROV_FULL_NAME     
			,VENDOR_ID              
			,VEND_FULL_NAME         
			,IRS_TAX_ID             
			,DRG_CODE               
			,BILL_TYPE              
			,ADMISSION_DATE         
			,AUTH_NUMBER            
			,ADMIT_SOURCE_CODE      
			,ADMIT_HOUR             
			,DISCHARGE_HOUR         
			,PATIENT_STATUS         
			,CLAIM_STATUS           
			,PROCESSING_STATUS      
			,CLAIM_TYPE             
			,TOTAL_BILLED_AMT       
			,TOTAL_PAID_AMT         
			,CalcdTotalBilledAmount 
			,BENE_PTNT_STUS_CD      
			,DISCHARGE_DISPO        
			,SrcAdiTableName
			,SrcAdiKey              
			,LoadDate               
			)  
	OUTPUT Inserted.[SEQ_CLAIM_ID] INTO #OutputTbl(ID)		   
    SELECT 		
		 c.ClaimID				AS SEQ_CLAIM_ID					-- SEQ_CLAIM_ID          
		,c.MedicareBeneficiaryID	AS SUBSCRIBER_ID				-- SUBSCRIBER_ID         
		,c.ClaimID				AS CLAIM_NUMBER					-- CLAIM_NUMBER          
		,case (c.ClaimTypeCD)
			when '01'	then 'PHARMACY'		--Part D - Original without resubmitted PDE
			WHEN '02'	then 'PHARMACY'		--Part D - Adjusted PDE
			WHEN '03'	then 'PHARMACY'		--Part D - Deleted Claims
			WHEN '04'	then 'PHARMACY'		--Part D - Resubmitted PDE
			ELSE 'PHARMACY' END AS CATEGORY_OF_SVC				-- CATEGORY_OF_SVC       
		,''						AS PAT_CONTROL_NO		  		-- PAT_CONTROL_NO        
		,''						AS ICD_PRIM_DIAG				-- ICD_PRIM_DIAG         
		,c.PrescriptionFillDTS	AS PRIMARY_SVC_DATE				-- PRIMARY_SVC_DATE      
		,''						AS SVC_TO_DATE			  		-- SVC_TO_DATE           
		,''						AS CLAIM_THRU_DATE		  		-- CLAIM_THRU_DATE       
		,CASE WHEN (c.ProcessingDTS = '1000-01-01') 
			THEN CONVERT(DATETIME, '1900/1/1' ) 
			ELSE c.ProcessingDTS end 
								AS POST_DATE			  		-- POST_DATE             
		,''						AS CHECK_DATE			  		-- CHECK_DATE            
		,''						AS CHECK_NUMBER			  		-- CHECK_NUMBER          
		,''						AS DATE_RECEIVED				-- DATE_RECEIVED         
		,''						AS ADJUD_DATE			  		-- ADJUD_DATE            
		,CASE WHEN 
			(c.PharmacyIdentifierTypeCD = 01) THEN c.PharmacyID				
			ELSE '' END			AS SVC_PROV_ID			  		-- SVC_PROV_ID           
		,''						AS SVC_PROV_FULL_NAME			-- SVC_PROV_FULL_NAME    
		,PharmacyID				AS SVC_PROV_NPI					-- SVC_PROV_NPI          
		,''						AS PROV_SPEC			  		-- PROV_SPEC             
		,'RX' + c.PharmacyServiceTypeCD	AS PROV_TYPE			  		-- PROV_TYPE             
		,''						AS PROVIDER_PAR_STAT			-- PROVIDER_PAR_STAT     
		,''						AS ATT_PROV_ID			  		-- ATT_PROV_ID           
		,''						AS ATT_PROV_FULL_NAME			-- ATT_PROV_FULL_NAME    
		,''						AS ATT_PROV_NPI			  		-- ATT_PROV_NPI          
		,''						AS REF_PROV_ID			  		-- REF_PROV_ID           
		,''						AS REF_PROV_FULL_NAME			-- REF_PROV_FULL_NAME    
		,CASE WHEN 
			(c.PharmacyIdentifierTypeCD = 11) THEN c.PharmacyID				
			ELSE '' END			AS VENDOR_ID					-- VENDOR_ID             
		,''						AS VEND_FULL_NAME		  		-- VEND_FULL_NAME        
		,''						AS IRS_TAX_ID			  		-- IRS_TAX_ID            
		,''						AS DRG_CODE				  		-- DRG_CODE              
		,''						AS BILL_TYPE			  		-- BILL_TYPE             
		,c.PrescriptionFillDTS	AS ADMISSION_DATE				-- ADMISSION_DATE        
		,''						AS AUTH_NUMBER			  		-- AUTH_NUMBER           
		,''						AS ADMIT_SOURCE_CODE			-- ADMIT_SOURCE_CODE     
		,''						AS ADMIT_HOUR			  		-- ADMIT_HOUR            
		,''						AS DISCHARGE_HOUR		  		-- DISCHARGE_HOUR        
		,''						AS PATIENT_STATUS		  		-- PATIENT_STATUS        
		,''						AS CLAIM_STATUS			  		-- CLAIM_STATUS          
		,c.AdjustmentTypeCD		AS PROCESSING_STATUS			-- PROCESSING_STATUS     
		,c.ClaimTypeCD			AS CLAIM_TYPE					-- CLAIM_TYPE            
		,''						AS TOTAL_BILLED_AMT				-- TOTAL_BILLED_AMT      
		,''						AS TOTAL_PAID_AMT		  		-- TOTAL_PAID_AMT        
		,''						AS CalcdTotalBilledAmount		-- CalcdTotalBilledAmount
		,''						AS BENE_PTNT_STUS_CD			-- BENE_PTNT_STUS_CD     
		,''						AS DISCHARGE_DISPO		  		-- DISCHARGE_DISPO       
		,'Steward_MSSPPartDClaimLineItem' AS SrcAdiTableName
		, c.MSSPPartDClaimLineItemKey AS SrcAdiKey		-- SrcAdiKey             
		, GetDate()				AS LoadDate						-- LoadDate              
																
    FROM adi.Steward_MSSPPartDClaimLineItem c
	   JOIN ast.pstDeDupClms_PartDPharma d ON c.MSSPPartDClaimLineItemKey = d.urn    
    ;

	SELECT @OutCnt = COUNT(*) FROM #OutputTbl; 
	SET @ActionStart = GETDATE();    
	SET @JobStatus =2  -- complete
    
	EXEC amd.sp_AceEtlAudit_Close 
        @AuditId = @AuditID
        , @ActionStopTime = @ActionStart
        , @SourceCount = @InpCnt		  
        , @DestinationCount = @OutCnt
        , @ErrorCount = @ErrCnt
        , @JobStatus = @JobStatus
