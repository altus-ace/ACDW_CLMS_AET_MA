
CREATE PROCEDURE [adw].[Load_Pdw_03_LatestEffectiveClmsHeader]
AS 
	/* PURPOSE: Get Latest Claims Header Seq_claims_id 
			 1. take all claims that are deduplicated, and have a seq Claim id
			 2. order by activity_date desc 
			 */

	DECLARE @LoadDate DATE = GETDATE()
	DECLARE @lLoadDate Date;
	SET @lLoadDate = @LoadDate;

	/* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 9	  -- AST load
	DECLARE @ClientKey INT	 = 3; -- mssp
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.ClaimAetMA'
    DECLARE @DestName VARCHAR(100) = 'ast.ClaimHeader_03_LatestEffectiveClaimsHeader'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT	@InpCnt = COUNT(*) 
	FROM			(	SELECT	 clmSKey,PRVDR_OSCAR_NUM , SrcAdiKey,ClaimAetMAKey
						FROM	 ast.ClaimHeader_02_ClaimSuperKey src
						JOIN	 adi.ClaimAetMA b
						ON	     src.clmSKey = b.src_clm_id
						JOIN    ast.ClaimHeader_01_Deduplicate c
						ON	  	 b.ClaimAetMAKey = c.SrcAdiKey 
					)LastEffective
			 

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
    TRUNCATE TABLE ast.ClaimHeader_03_LatestEffectiveClaimsHeader;
    
    INSERT INTO ast.ClaimHeader_03_LatestEffectiveClaimsHeader (clmSKey, clmHdrURN)
	OUTPUT INSERTED.clmSKey INTO #OutputTbl(ID)
    SELECT clmSKey, ClaimAetMAKey
    FROM      (			-- get the superkey, don't rank, just pass all 
						SELECT	 src.clmSKey, src.PRVDR_OSCAR_NUM , deDup.SrcAdiKey, adi.ClaimAetMAKey						
						FROM	 ast.ClaimHeader_02_ClaimSuperKey src
							JOIN	 adi.ClaimAetMA adi ON	     src.clmSKey = adi.src_clm_id
							JOIN    ast.ClaimHeader_01_Deduplicate deDup ON		 adi.ClaimAetMAKey = deDup.SrcAdiKey 
			  )LastEffective
	ORDER BY SrcAdiKey, ClaimAetMAKey
	
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

	  
	   
	