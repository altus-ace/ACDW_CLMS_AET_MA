
CREATE PROCEDURE [adw].[Transform_Pdw_11_HdrsAggPaidFromPartBDetail]
AS 
	/* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 12	  -- AST load
	DECLARE @ClientKey INT	 = 16; -- mssp
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Claims_Headers'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Details'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM adw.Claims_Diags d
        ;

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
	CREATE TABLE #OutputTbl (ID VARCHAR(50) PRIMARY KEY NOT NULL);	

      
	UPDATE ch			
		set ch.TOTAL_PAID_AMT = SumDetails.SumPaidAmt
		--SELECT ch.SEQ_CLAIM_ID, ch.SUBSCRIBER_ID, SumDetails.SumPaidAmt
	OUTPUT inserted.SEQ_CLAIM_ID INTO #OutputTbl(id)
	FROM adw.Claims_Headers ch 
	   JOIN (SELECT cd.SUBSCRIBER_ID, cd.SEQ_CLAIM_ID, SUM(cd.PAID_AMT) SumPaidAmt
			 FROM adw.Claims_Details cd --ON ch.SEQ_CLAIM_ID = cd.SEQ_CLAIM_ID
			 --JOIN (SELECT cl.SEQ_CLAIM_ID, cl.BENE_PTNT_STUS_CD
	   --			 FROM adw.Claims_Headers cl
			 --	 JOIN ast.pstDeDupClms_PartDPharma d ON cl.SEQ_CLAIM_ID = d.urn
				--) PartDDetails 
			 --ON cd.SEQ_CLAIM_ID = PartDDetails.ClaimID
			 --AND cd.SUBSCRIBER_ID = PartDDetails.MedicareBeneficiaryID					 
		  GROUP BY cd.SEQ_CLAIM_ID, cd.SUBSCRIBER_ID
		  ) SumDetails
	    ON CH.seq_claim_id = SumDetails.SEQ_CLAIM_ID
		;    

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
