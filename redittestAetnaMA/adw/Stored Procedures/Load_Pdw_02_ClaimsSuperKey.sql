CREATE PROCEDURE [adw].[Load_Pdw_02_ClaimsSuperKey]
/* PURPOSE:  Create a ClaimNumber. : list of business key fields and the calculated seq_claim_id 
		  We also do filtering for "ace valid cliams" here

		  THIS IS AT THE GRAIN OF THE DETAIL
    */
AS 
	DECLARE @LoadDate DATE = GETDATE()
	DECLARE @lLoadDate Date;
	SET @lLoadDate = @LoadDate;

	/* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 9	  -- AST load
	DECLARE @ClientKey INT	 = 3; -- aetnaMA
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.ClaimAetMA'
    DECLARE @DestName VARCHAR(100) = 'ast.pstCclfClmKeyList'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT	@InpCnt = COUNT(*) 
	FROM	adi.ClaimAetMA S
	JOIN	ast.ClaimHeader_01_Deduplicate ddH 
	ON		s.ClaimAetMAKey = ddH.SrcAdiKey ; -- count all rows 
	select @InpCnt
          
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

    TRUNCATE TABLE ast.ClaimHeader_02_ClaimSuperKey;
    /* create list of clmSkeys: these are all related claims grouped on the cms defined relation criteria 
        and bound under varchar(50) key made from concatenation of all the 4 component parts */
    INSERT INTO ast.ClaimHeader_02_ClaimSuperKey(
				clmSKey
				, PRVDR_OSCAR_NUM
				, BENE_EQTBL_BIC_HICN_NUM
				, CLM_FROM_DT
				,CLM_THRU_DT
				,LoadDate)
	OUTPUT Inserted.clmsKey INTO #OutputTbl(ID)
    SELECT   
			LTRIM(s.src_clm_id)		AS clmBigKey 
			--, src_subscriber_id		AS PRVDR_OSCAR_NUM
			, S.srv_prvdr_npi as PrvDr_Oscar_Num
			, CONVERT(VARCHAR(50), CONVERT(numeric(18,0), s.member_id))			AS BENE_EQTBL_BIC_HICN_NUM    
			,S.srv_start_dt
			,S.srv_stop_dt 
			,S.LoadDate
    FROM	adi.ClaimAetMA S
	   JOIN	ast.ClaimHeader_01_Deduplicate ddH 
	   ON		s.ClaimAetMAKey = ddH.SrcAdiKey  
	   ;
	
    
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

	