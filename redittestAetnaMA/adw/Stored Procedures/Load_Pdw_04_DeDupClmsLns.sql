------Do not process SP until further revised
CREATE PROCEDURE [adw].[Load_Pdw_04_DeDupClmsLns]
AS 
    /* PURPOSE: -- 4. de dup claims details
	    this is ready to be refactored 
		Is it not supposed to be a one to many relationship? this seems to be a one to one relationship....
	   
	   */
	DECLARE @DataDate DATE;

	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 9	  -- 9: Ast Load, 10: Ast Transform, 11:Ast Validation	
	DECLARE @ClientKey INT	 = 3; -- aetna MA
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.ClaimAetMA'
    DECLARE @DestName VARCHAR(100) = 'ast.pstcLnsDeDupUrns'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM			(
					 SELECT cl.ClaimAetMAKey, cl.OriginalFileName, cl.LoadDate, cl.src_clm_id , cl.src_claim_line_id_2
							, ROW_NUMBER() OVER (PARTITION BY cl.src_clm_id, cl.src_claim_line_id_2 ORDER BY cl.LoadDate DESC, cl.OriginalFileName DESC) arn	   
					 FROM adi.ClaimAetMA cl
					 JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader  LatestEffectiveCHeader 
					 ON   cl.ClaimAetMAKey = LatestEffectiveCHeader.clmHdrURN
					) s
    WHERE s.arn = 1; 
	--SELECT @InpCnt
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

	CREATE TABLE #OutputTbl (ID INT NOT NULL );	

    TRUNCATE TABLE ast.pstcLnsDeDupUrns;

    INSERT INTO ast.pstcLnsDeDupUrns (URN)
	OUTPUT INSERTED.URN INTO #OutputTbl(ID)
    SELECT  DISTINCT s.ClaimAetMAKey AS URN	
    FROM			(
					SELECT cl.ClaimAetMAKey, cl.OriginalFileName, cl.LoadDate, cl.src_clm_id , cl.src_claim_line_id_2
						, ROW_NUMBER() OVER (PARTITION BY cl.src_clm_id, cl.src_claim_line_id_2 ORDER BY cl.LoadDate DESC, cl.OriginalFileName DESC) arn	   
					 FROM adi.ClaimAetMA cl
					 JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader  LatestEffectiveCHeader 
					 ON   cl.ClaimAetMAKey = LatestEffectiveCHeader.clmHdrURN
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
	  
		
	


