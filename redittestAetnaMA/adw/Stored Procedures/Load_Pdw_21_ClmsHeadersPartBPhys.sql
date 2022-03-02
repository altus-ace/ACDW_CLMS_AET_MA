
CREATE PROCEDURE [adw].[Load_Pdw_21_ClmsHeadersPartBPhys]
AS 
	/* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 8	  -- ADW load
	DECLARE @ClientKey INT	 = 16; -- mssp
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPartBPhysicianClaimLineItem'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Headers'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM adi.Steward_MSSPPartBPhysicianClaimLineItem c
	   JOIN ast.pstDeDupClms_PartBPhys d ON c.MSSPPartBPhysicianClaimLineItemKey = d.urn
	WHERE c.LineNBR = 1 

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
		  c.ClaimID							AS SEQ_CLAIM_ID				       
		, c.MedicareBeneficiaryID			AS Subscriber_ID			       
		, ControlNBR						AS Claim_Number 			       
		/* align to part a super key: due to the absence of the oscar key, it is not possible to create a equvalant super key
			, c.CertificationNBR +'.'+c.MedicareBeneficiaryID+'.'+convert(varchar(10), c.ClaimStartDTS,101)+'.'+CONVERT(varchar(10), c.ClaimEndDTS,101) AS Claim_Number		 
				-- use this as it's function is similar to the composite natural key used on the other tables  
		*/
		,CASE c.ClaimTypeCD 																											
			WHEN '70' THEN 'PHYSICIAN'																		
			WHEN '71' THEN 'PHYSICIAN'											
			WHEN '72' THEN 'PHYSICIAN'										
			ELSE c.ClaimTypeCD	END			AS CATEGORY_OF_SVC			
		, c.UmbrellaHealthInsuranceClaimNBR	AS pat_Control_No			
		, c.PrincipalICDDiagnosisCD			AS ICD_PRIM_DIAG			
		, c.ClaimStartDTS					AS PRIMARY_SVC_DATE			
		, c.ClaimEndDTS						AS Service_to_date			
		, c.ClaimEndDTS						AS Claim_Thru_date			
		, c.ProcessingDTS					AS POST_DATE				
		, ''								AS CHECK_DATE				
		, ''								AS CHECK_NUMBER				
		, ''								AS DATE_RECEIVED			
		, ''								AS ADJUD_DATE				
		, ''								AS SVC_PROV_ID				
		, ''								AS SVC_PROV_FULL_NAME		
		, c.RenderingProviderNPI			AS SVC_PROV_NPI				
		, c.ProviderSpecialtyCD				AS PROV_SPEC				
		, c.RenderingProviderTypeCD			AS PROV_TYPE        		
		, ''								AS PROVIDER_PAR_STAT		
		, ''								AS ATT_PROV_ID				
		, ''								AS ATT_PROV_FULL_NAME		
		, ''								AS ATT_PROV_NPI				
		, ''								AS REF_PROV_ID				
		, ''								AS REF_PROV_FULL_NAME		
		, c.RenderingProviderNPI			AS VENDOR_ID				
		, ''								AS VEND_FULL_NAME			
		, c.ClaimTaxID						AS IRS_TAX_ID				
		, ''								AS DRG_CODE					
		, c.PlaceOfServiceCD				AS BILL_TYPE				
		, c.ClaimStartDTS					AS ADMISSION_DATE			
		, ''								AS AUTH_NUMBER				
		, ''								AS ADMIT_SOURCE_CODE		
		, ''								AS ADMIT_HOUR				
		, ''								AS DISCHARGE_HOUR			
		, ''								AS PATIENT_STATUS			
		, c.CarrierPaymentDispositionCD		AS CLAIM_STATUS				
		, c.AdjustmentTypeCD				AS PROCESSING_STATUS		
	    , c.ClaimTypeCD						AS CLAIM_TYPE				
	   	, ''								AS TOTAL_BILLED_AMT			
	   	, c.PaymentAMT						AS TOTAL_PAID_AMT			
		, ''								AS CalcdTotalBilledAmount	
		, ''								AS BENE_PTNT_STUS_CD		
		, ''								AS DISCHARGE_DISPO		
		, 'Steward_MSSPPartBPhysicianClaimLineItem' AS SrcAdiTableName
		, c.MSSPPartBPhysicianClaimLineItemKey AS srcAdiKey				
		, GetDate()							AS LoadDate					
    FROM adi.Steward_MSSPPartBPhysicianClaimLineItem c
	   JOIN ast.pstDeDupClms_PartBPhys d ON c.MSSPPartBPhysicianClaimLineItemKey = d.urn
    WHERE c.LineNBR = 1 
		--and DataDate = (select max(DataDate) from adi.Steward_MSSPPartBPhysicianClaimLineItem) THIS DOESN'T MAKE SENSE removed.
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
