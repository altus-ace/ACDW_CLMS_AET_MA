CREATE PROCEDURE [adw].[Load_Pdw_01_ClaimHeader_01_Deduplicate]
	(@MaxLoadDate DATE)
AS
	--@DataDate points SHOULD BE Uncommented after the first Run
	-- Claims Dedup: Use this table to remove any duplicated input rows, they will be duplicated and versioned.. 
	-- Ensure records loaded tallies with cclf1 records (validation)
    

    DECLARE @AuditId INT;    
    DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 9	  -- AST load
    DECLARE @ClientKey INT	 = 3; -- AetnaMa
    DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = '[ACDW_CLMS_AET_MA].[adi].[ClaimAetMA]'
    DECLARE @DestName VARCHAR(100) = 'ast.PstDeDupClmsHdr'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
--    DECLARE @DataDate DATE ;
--	SELECT  @DataDate = MAX(DataDate)--Uncomment after first run
--	FROM [adi].[ClaimAetMA];
--	select @DATaDate;
  
	SELECT @InpCnt = COUNT(*) 
	FROM (SELECT ch.ClaimAetMAKey, ch.src_clm_id, ch.OriginalFileName, LoadDate,								--Select lastest srv_stsrt date
	           ROW_NUMBER() OVER(PARTITION BY ch.src_clm_id ORDER BY ch.LoadDate DESC, ch.src_claim_line_id_2 ASC, ch.OriginalFileName ASC) arn			
	    FROM [adi].[ClaimAetMA] ch
		WHERE 	ch.src_subscriber_id <> '********'
	    --WHERE ch.DataDate <= @DataDate Uncomment after first run
	    ) s
	WHERE s.arn = 1
	     -- AND DataDate <= @DataDate; -- count all rows Uncomment after first run
	--select @InpCnt
	SELECT @InpCnt--, @DataDate Uncomment after first run
--	EXEC amd.sp_AceEtlAudit_Open 
--        @AuditID = @AuditID OUTPUT
--        , @AuditStatus = @JobStatus
--        , @JobType = @JobType
--        , @ClientKey = @ClientKey
--        , @JobName = @JobName
--        , @ActionStartTime = @ActionStart
--        , @InputSourceName = @SrcName
--        , @DestinationName = @DestName
--        , @ErrorName = @ErrorName
--        ;
	
	CREATE TABLE #OutputTbl (ID INT NOT NULL PRIMARY KEY);	

	TRUNCATE TABLE ast.ClaimHeader_01_Deduplicate;
	
	-- start tran
	
	INSERT INTO ast.ClaimHeader_01_Deduplicate(SrcAdiKey, SeqClaimId, OriginalFileName, LoadDate)
	OUTPUT inserted.SrcAdiKey INTO #OutputTbl(ID)	
	SELECT s.ClaimAetMAKey, s.src_clm_id, s.OriginalFileName, s.LoadDate
	FROM (SELECT ch.ClaimAetMAKey, ch.src_clm_id, ch.OriginalFileName, LoadDate, ch.src_claim_line_id_2
			,ROW_NUMBER() OVER(PARTITION BY ch.src_clm_id ORDER BY ch.LoadDate DESC, ch.src_claim_line_id_2 ASC, ch.OriginalFileName ASC) arn			
			FROM [adi].[ClaimAetMA] ch
			WHERE 	ch.src_subscriber_id <> '********'				
	    ) s
	WHERE s.arn = 1
	      AND s.LoadDate <= @MaxLoadDate; --Uncomment after first run

    SELECT @OutCnt = COUNT(*) FROM #OutputTbl;
    SET @ActionStart  = GETDATE();
    SET @JobStatus =2  -- complete
    
--	EXEC amd.sp_AceEtlAudit_Close 
--        @Audit_Id = @AuditID
--        , @ActionStopTime = @ActionStart
--        , @SourceCount = @InpCnt		  
--        , @DestinationCount = @OutCnt
--        , @ErrorCount = @ErrCnt
--        , @JobStatus = @JobStatus
--	   ;

	  
