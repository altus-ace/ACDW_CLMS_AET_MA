CREATE PROCEDURE [adw].[Load_Pdw_08_DeDupPartDPharma]
AS    
    
	DECLARE @DataDate DATE;

	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 9	  -- 9: Ast Load, 10: Ast Transform, 11:Ast Validation	
	DECLARE @ClientKey INT	 = 16; -- mssp
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPartDClaimLineItem'
    DECLARE @DestName VARCHAR(100) = 'ast.pstDeDupClms_PartDPharma'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
	SELECT 'Rx Claims Not implemented for AETMA at this time. ';
	RETURN;

    SELECT @InpCnt = COUNT(*) 
	FROM (select adiData.MSSPPartDClaimLineItemKey AS URN, adiData.ClaimID,  adiData.MedicareBeneficiaryID
    		  , adiData.HealthInsuranceClaimNBR, adiData.PrescriptionFillDTS
    		  , ClaimTypeCD--, CLM_CARR_PMT_DNL_CD, CLM_PRCSG_IND_CD, CLM_ADJSMT_TYPE_CD
    		  , DataDate, SrcFileName
    		  , ROW_NUMBER() OVER (partition by ClaimID ORDER BY DataDate Desc) arn
           FROM adi.Steward_MSSPPartDClaimLineItem adiData 				
		   --WHERE DataDate = (SELECT max(DataDate) FROM adi.Steward_MSSPPartBPhysicianClaimLineItem)
		   ) s
    WHERE s.arn = 1;

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
    TRUNCATE TABLE ast.pstDeDupClms_PartDPharma;

    INSERT INTO ast.pstDeDupClms_PartDPharma(urn)
	OUTPUT inserted.urn INTO #OutputTbl(ID)
    SELECT s.urn
    FROM (select adiData.MSSPPartDClaimLineItemKey AS URN, adiData.ClaimID,  adiData.MedicareBeneficiaryID
    		  , adiData.HealthInsuranceClaimNBR, adiData.PrescriptionFillDTS
    		  , ClaimTypeCD--, CLM_CARR_PMT_DNL_CD, CLM_PRCSG_IND_CD, CLM_ADJSMT_TYPE_CD
    		  , DataDate, SrcFileName
    		  , ROW_NUMBER() OVER (partition by ClaimID ORDER BY DataDate Desc) arn
           FROM adi.Steward_MSSPPartDClaimLineItem adiData 				
		   --WHERE DataDate = (SELECT max(DataDate) FROM adi.Steward_MSSPPartBPhysicianClaimLineItem)
		   ) s
    WHERE s.arn = 1;

	SELECT @OutCnt = COUNT(*) FROM #OutputTbl;
	SET @ActionStart = GETDATE();    
	SET @JobStatus =2  -- complete
    
	EXEC amd.sp_AceEtlAudit_Close 
        @Audit_Id = @AuditID
        , @ActionStopTime = @ActionStart
        , @SourceCount = @InpCnt		  
        , @DestinationCount = @OutCnt
        , @ErrorCount = @ErrCnt
        , @JobStatus = @JobStatus
	   ;
