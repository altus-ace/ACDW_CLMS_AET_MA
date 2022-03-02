--------PROCESS SP INDIVIDUALLY TO VALIDATE DEDUP ENTRIES FROM ADI FOR THE CURRENT MONTH

CREATE PROCEDURE [adw].[Load_Pdw_07_DeDupPartBPhys] -----------NOT REQUIRED IN AetnaMA
AS    
    /* THIS IS UNIQUE TO CCLF model to handle PROFESSIONAL Component */
	DECLARE @DataDate DATE;

	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 9	  -- 9: Ast Load, 10: Ast Transform, 11:Ast Validation	
	DECLARE @ClientKey INT	 = 16; -- mssp
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPartBPhysicianClaimLineItem'
    DECLARE @DestName VARCHAR(100) = 'ast.pstDeDupClms_PartBPhys'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
	SELECT ' Warning Part B Claims not implemented as a seperarte process at this time for AetMa. ';
	return;

    SELECT @InpCnt = COUNT(*) 
	FROM (select cl.MSSPPartBPhysicianClaimLineItemKey AS URN, cl.ClaimID, cl.LineNBR, cl.MedicareBeneficiaryID
    		  , cl.UmbrellaHealthInsuranceClaimNBR, cl.ClaimStartDTS, cl.ClaimEndDTS
    		  , cl.ClaimTypeCD--, CLM_CARR_PMT_DNL_CD, CLM_PRCSG_IND_CD, CLM_ADJSMT_TYPE_CD
    		  , cl.DataDate, cl.SrcFileName
    		  , ROW_NUMBER() OVER (partition by cl.ClaimID, cl.LineNBR ORDER BY cl.DataDate Desc) arn
           FROM adi.Steward_MSSPPartBPhysicianClaimLineItem cl				
		   --WHERE DataDate = (select max(DataDate)  from adi.Steward_MSSPPartBPhysicianClaimLineItem)
		   ) s
    WHERE s.arn = 1;
	
	EXEC amd.sp_AceEtlAudit_Open 
        @Audit_ID = @AuditID OUTPUT
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

    TRUNCATE TABLE ast.pstDeDupClms_PartBPhys;

    INSERT INTO ast.pstDeDupClms_PartBPhys (urn)
	OUTPUT inserted.urn INTO #OutputTbl(ID)
    SELECT s.urn
    FROM (select cl.MSSPPartBPhysicianClaimLineItemKey AS URN, cl.ClaimID, cl.LineNBR, cl.MedicareBeneficiaryID
    		  , cl.UmbrellaHealthInsuranceClaimNBR, cl.ClaimStartDTS, cl.ClaimEndDTS
    		  , cl.ClaimTypeCD--, CLM_CARR_PMT_DNL_CD, CLM_PRCSG_IND_CD, CLM_ADJSMT_TYPE_CD
    		  , cl.DataDate, cl.SrcFileName
    		  , ROW_NUMBER() OVER (partition by cl.ClaimID, cl.LineNBR ORDER BY cl.DataDate Desc) arn
           FROM adi.Steward_MSSPPartBPhysicianClaimLineItem cl				
		   --WHERE DataDate = (select max(DataDate)  from adi.Steward_MSSPPartBPhysicianClaimLineItem)
		   ) s
    WHERE s.arn = 1;

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
	   ;
