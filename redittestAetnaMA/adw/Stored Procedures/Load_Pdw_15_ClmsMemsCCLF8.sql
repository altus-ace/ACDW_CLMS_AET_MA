---DONT RUN SP UNTIL VALIDATION FROM ADI
CREATE PROCEDURE [adw].[Load_Pdw_15_ClmsMemsCCLF8]
AS -- insert Claims.Members

	/* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 8	  -- Adw load
	DECLARE @ClientKey INT	 = 3; -- aetna MA
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.ClaimAetMA'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Member'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(DISTINCT src_subscriber_id) 
	FROM   adi.ClaimAetMA cl
	JOIN ast.ClaimHeader_02_ClaimSuperKey ck 
	ON	 cl.src_subscriber_id = ck.PRVDR_OSCAR_NUM SELECT @InpCnt
	
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

    INSERT INTO adw.Claims_Member
           (SUBSCRIBER_ID
		   , IsActiveMember
           ,DOB
           ,MEMB_LAST_NAME
           ,MEMB_MIDDLE_INITIAL
           ,MEMB_FIRST_NAME        
		   ,MEDICAID_NO
		   ,MEDICARE_NO
           ,Gender
           ,MEMB_ZIP
		   ,COMPANY_CODE
		   ,LINE_OF_BUSINESS_DESC
		   ,SrcAdiTableName
		   ,SrcAdiKey
		   ,LoadDate
		   )
	OUTPUT inserted.SUBSCRIBER_ID INTO #OutputTbl(ID)
    SELECT DISTINCT
		 CONVERT(VARCHAR(50), CONVERT(numeric(18,0), LTRIM(RTRIM(m.member_id))))			--,SUBSCRIBER_ID   
		,1									AS IsActiveMember
		,m.subscriber_brth_dt				AS DOB				  	   
		,m.mem_last_nm						AS MEMB_LAST_NAME		    
		,''									AS MEMB_MIDDLE_INITIAL	    
		,m.mem_first_nm						AS MEMB_FIRST_NAME	    
		, ''								AS MEDICAID_NO
		, ''								AS MEDICARE_NO
		,m.mem_gender						AS GENDER			    
		,m.subs_zip_cd						AS MEMB_ZIP			    
		,''									AS COMPANY_CODE
		,''									AS LINE_OF_BUSINESS_DESC
		,'ClaimAetMA'						AS SrcAdiTableName
		, m.ClaimAetMAKey					AS SrcAdiKey
		, GetDate()							AS LoadDate
		-- implicit: CreatedDate, CreatedBy, LastUpdatedDate, LastUpdatedBy		
    FROM adi.ClaimAetMA m    
    JOIN			(
					SELECT * 
					FROM (	
						SELECT   src_subscriber_id, ClaimAetMAKey
									, ROW_NUMBER() OVER(PARTITION BY src_subscriber_id ORDER BY Datadate DESC) RwCnt
						FROM	adi.ClaimAetMA a
						WHERE	a.src_subscriber_id <> '********'
						)b
					WHERE		b.RwCnt = 1
						AND			src_subscriber_id <> ''
					) z
	ON	 m.ClaimAetMAKey = z.ClaimAetMAKey;
	--ORDER BY SUBSCRIBER_ID
	

	SELECT @OutCnt = COUNT(*) FROM #OutputTbl; 
	SET @ActionStart = GETDATE();    
	SET @JobStatus =2  -- complete
    
	EXEC amd.sp_AceEtlAudit_Close 
        @audit_id = @AuditID
        , @ActionStopTime = @ActionStart
        , @SourceCount = @InpCnt		  
        , @DestinationCount = @OutCnt
        , @ErrorCount = @ErrCnt
        , @JobStatus = @JobStatus
	   ;

	