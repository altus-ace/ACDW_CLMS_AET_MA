
CREATE PROCEDURE [adw].[Load_Pdw_24_ClmsDiagsPartBPhys]
AS -- insert claims diags for Steward_MSSPPartBPhysicianClaimLineItem
	/* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 8	  -- AST load
	DECLARE @ClientKey INT	 = 16; -- mssp
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPartBPhysicianClaimLineItem'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Diags'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM adi.Steward_MSSPPartAClaimLineItem cl
		JOIN ast.ClaimHeader_02_ClaimSuperKey ck ON ck.PRVDR_OSCAR_NUM = cl.CMSCertificationNBR
			AND ck.BENE_EQTBL_BIC_HICN_NUM	= cl.MedicareBeneficiaryID
            AND ck.CLM_FROM_DT				= cl.ClaimStartDTS
            AND ck.CLM_THRU_DT				= cl.ClaimEndDTS		  
		JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader lr ON ck.clmSKey = lr.clmSKey
        JOIN adi.Steward_MSSPPartAClaim ch ON lr.clmHdrURN = ch.MSSPPartAClaimKey;

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

     INSERT INTO adw.Claims_Diags
     (	-- URN         loaded by default
		 SEQ_CLAIM_ID  
		,SUBSCRIBER_ID
		,ICD_FLAG 			
		,diagNumber
		,diagCode 
		,diagPoa  
		,LoadDate				
		,SrcAdiTableName
		,SrcAdiKey     
     )					
	 OUTPUT inserted.URN INTO #OutputTbl(ID)
     SELECT src.ClaimID					AS SEQ_CLAIM_ID
            , src.MedicareBeneficiaryID	AS SUBSCRIBER_ID
            , src.[ICDRevisionCD]		AS ICD_FLAG 
            , src.ClmNum				AS diagNum 
            , src.ClmCd					AS diagCode
			, ''						AS DiagPoa
			, GETDATE()					AS LoadDate
			, 'Steward_MSSPPartBPhysicianClaimLineItem ' AS SrcAdiTableName
			, src.srcAdiKey 			AS SrcAdiKey
            FROM
            (
                SELECT srcAdiKey
					, ClaimID
                    , MedicareBeneficiaryID
                    , ICDRevisionCD
                    , ClmNum
                    , ClmCd
                FROM
                (SELECT c.ClaimID, 
					c.MSSPPartBPhysicianClaimLineItemKey AS srcAdiKey, 
					c.MedicareBeneficiaryID, 
					c.ICDRevisionCD, 					
					CONVERT(VARCHAR(50), c.PrincipalICDDiagnosisCD) AS [1],
					 c.ClaimICDDiagnosis01CD AS [2], 
					 c.ClaimICDDiagnosis02CD AS [3], 
					 c.ClaimICDDiagnosis03CD AS [4], 
					 c.ClaimICDDiagnosis04CD AS [5], 
					 c.ClaimICDDiagnosis05CD AS [6], 
					 c.ClaimICDDiagnosis06CD AS [7], 
					 c.ClaimICDDiagnosis07CD AS [8], 
					 c.ClaimICDDiagnosis08CD AS [9],
					c.ClaimICDDiagnosis09CD AS [10],
					c.ClaimICDDiagnosis10CD AS [11],
					c.ClaimICDDiagnosis11CD AS [12],
					c.ClaimICDDiagnosis12CD AS [13]
				FROM adi.Steward_MSSPPartBPhysicianClaimLineItem c
				     JOIN ast.pstDeDupClms_PartBPhys d ON c.MSSPPartBPhysicianClaimLineItemKey = d.urn
				WHERE c.LineNBR = 1
                ) p UNPIVOT(ClmCd FOR ClmNum IN([1], 
                                                [2], 
                                                [3], 
                                                [4], 
                                                [5], 
                                                [6], 
                                                [7], 
                                                [8],
												[9],
												[10],
												[11],
												[12],
												[13])
				) AS unpvt
				WHERE len(unpvt.ClmCd) > 0  -- added to try and suppress zero length diags from being added. The rows contain no info THis is a KLUDGE.
            ) AS src
            WHERE src.clmCd <> '~'
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
	   ;
