
CREATE PROCEDURE [adw].[Load_Pdw_22_ClmsDetailsPartBPhys]
AS 
    /* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 8	  -- ADW load
	DECLARE @ClientKey INT	 = 16; -- mssp
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPartBPhysicianClaimLineItem'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Details'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM adi.Steward_MSSPPartBPhysicianClaimLineItem c
        JOIN ast.pstDeDupClms_PartBPhys d 
			ON c.MSSPPartBPhysicianClaimLineItemKey = d.urn;

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
	CREATE TABLE #OutputTbl (ID INT NOT NULL PRIMARY KEY);	
  --SELECT count(*) FROM dbo.Claims_Details d
    INSERT INTO adw.Claims_Details
               ( CLAIM_NUMBER                
				,SUBSCRIBER_ID				
				,SEQ_CLAIM_ID                
				,LINE_NUMBER                 
				,SUB_LINE_CODE               
				,DETAIL_SVC_DATE             
				,SVC_TO_DATE                 
				,PROCEDURE_CODE              
				,MODIFIER_CODE_1             
				,MODIFIER_CODE_2             
				,MODIFIER_CODE_3             
				,MODIFIER_CODE_4             
				,REVENUE_CODE                
				,PLACE_OF_SVC_CODE1          
				,PLACE_OF_SVC_CODE2          
				,PLACE_OF_SVC_CODE3          
				,QUANTITY                    
				,BILLED_AMT                  
				,PAID_AMT                    
				,NDC_CODE                    
				,RX_GENERIC_BRAND_IND        
				,RX_SUPPLY_DAYS              
				,RX_DISPENSING_FEE_AMT       
				,RX_INGREDIENT_AMT           
				,RX_FORMULARY_IND            
				,RX_DATE_PRESCRIPTION_WRITTEN
				,RX_DATE_PRESCRIPTION_FILLED	
				,PRESCRIBING_PROV_TYPE_ID		
				,PRESCRIBING_PROV_ID			
				,BRAND_NAME                  
				,DRUG_STRENGTH_DESC          
				,GPI                         
				,GPI_DESC                    
				,CONTROLLED_DRUG_IND         
				,COMPOUND_CODE            
				,SrcAdiTableName
				,SrcAdiKey                   
				, LoadDate                    				
				)
	OUTPUT Inserted.ClaimsDetailsKey INTO #OutputTbl(ID)	
    SELECT           
        c.ControlNBR							AS CLAIM_NUMBER						--CLAIM_NUMBER                
		, c.MedicareBeneficiaryID				AS SUBSCRIBER_ID					--SUBSCRIBER_ID				
		, c.ClaimID								AS SEQ_CLAIM_ID	    				--SEQ_CLAIM_ID                
        , c.LineNBR								AS LINE_NUMBER						--LINE_NUMBER                 
        , c.LineProcessingIndicatorCD			AS SUB_LINE_CODE    				--SUB_LINE_CODE               
        , c.StartDTS							AS Detail_SvC_DATE					--DETAIL_SVC_DATE             
        , c.EndDTS								AS SVC_TO_DATE						--SVC_TO_DATE                 
        , c.HCPCS								AS Procedure_CODE					--PROCEDURE_CODE              
        , c.HCPCSModifier01CD					AS Modifier_1						--MODIFIER_CODE_1             
        , c.HCPCSModifier02CD					AS Modifier_2						--MODIFIER_CODE_2             
        , c.HCPCSModifier03CD					AS Modifier_3						--MODIFIER_CODE_3             
        , c.HCPCSModifier04CD					AS Modifier_4 						--MODIFIER_CODE_4             
        , ''	 								AS REV_CODE							--REVENUE_CODE                
        , c.PlaceOfServiceCD					AS Place_of_svc_Code1				--PLACE_OF_SVC_CODE1          
		,''										AS PLACE_OF_SVC_CODE2				--PLACE_OF_SVC_CODE2          
		,''										AS PLACE_OF_SVC_CODE3				--PLACE_OF_SVC_CODE3          
        , c.AllowedUnitCNT						AS Quantity							--QUANTITY                    
        , c.PaymentAMT							AS paid_AMT							--BILLED_AMT                  
		, ''									AS BILLED_AMT						--PAID_AMT                    
		, ''									AS NDC_CODE							--NDC_CODE                    
		, ''									AS RX_GENERIC_BRAND_IND				--RX_GENERIC_BRAND_IND        
		, ''									AS RX_SUPPLY_DAYS					--RX_SUPPLY_DAYS              
		, ''									AS RX_DISPENSING_FEE_AMT			--RX_DISPENSING_FEE_AMT       
		, ''									AS RX_INGREDIENT_AMT				--RX_INGREDIENT_AMT           
		, ''									AS RX_FORMULARY_IND					--RX_FORMULARY_IND            
		, ''									AS RX_DATE_PRESCRIPTION_WRITTEN		--RX_DATE_PRESCRIPTION_WRITTEN
		, ''									AS RX_DATE_PRESCRIPTION_FILLED		--RX_DATE_PRESCRIPTION_FILLED	
		, ''									AS PRESCRIBING_PROV_TYPE_ID			--PRESCRIBING_PROV_TYPE_ID		
		, ''									AS PRESCRIBING_PROV_ID				--PRESCRIBING_PROV_ID			
		, ''									AS BRAND_NAME						--BRAND_NAME                  
		, ''									AS DRUG_STRENGTH_DESC				--DRUG_STRENGTH_DESC          
		, ''									AS GPI								--GPI                         
		, ''									AS GPI_DESC							--GPI_DESC                    
		, ''									AS CONTROLLED_DRUG_IND				--CONTROLLED_DRUG_IND         
		, ''									AS COMPOUND_CODE					--COMPOUND_CODE               
		, 'Steward_MSSPPartBPhysicianClaimLineItem' AS SrcAdiTableName
		, c.MSSPPartBPhysicianClaimLineItemKey	AS SrcAdiKey						--SrcAdiKey                   
		, GetDate()								AS LoadDate							--LoadDate                   
    FROM adi.Steward_MSSPPartBPhysicianClaimLineItem c
        JOIN ast.pstDeDupClms_PartBPhys d ON c.MSSPPartBPhysicianClaimLineItemKey = d.urn

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


	-- Use header to update the place of service code 1 & 2
