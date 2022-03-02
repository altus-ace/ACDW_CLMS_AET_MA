

CREATE PROCEDURE adw.Pdw_AetnaMAQM_AWV--'2021-01-22',3
					(@QMDate DATE,@ClientKey INT )

AS


SET NOCOUNT ON

	BEGIN

	BEGIN TRY
	BEGIN TRAN  
			
						DECLARE @AuditId INT;    
						DECLARE @JobStatus tinyInt = 1    
						DECLARE @JobType SmallInt = 9
						DECLARE @JobName VARCHAR(100) = 'AetnaMA_AWV';
						DECLARE @ActionStart DATETIME2 = GETDATE();
						DECLARE @SrcName VARCHAR(100) = 'tvf_ActiveMembers'
						DECLARE @DestName VARCHAR(100) = 'ACECAREDW.[adw].[QM_ResultByMember_History]'
						DECLARE @ErrorName VARCHAR(100) = 'NA';
						DECLARE @InpCnt INT = -1;
						DECLARE @OutCnt INT = -1;
						DECLARE @ErrCnt INT = -1;
	SELECT				@InpCnt = COUNT(a.pstQM_ResultByMbr_HistoryKey)    
	FROM				ACECAREDW.ast.QM_ResultByMember_History  a
	WHERE				QMDate = @QMDate  
	
	SELECT				@InpCnt, @QMDate
	
	
	EXEC				amd.sp_AceEtlAudit_Open 
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
	CREATE TABLE		#OutputTbl (ID INT NOT NULL );
	
	--Step 1
	---Process into staging from tvf_ActiveMembers

	INSERT INTO 		[ACECAREDW].ast.[QM_ResultByMember_History](
						ClientKey
						,ClientMemberKey
						,QmMsrId
						,QmCntCat
						,QMDate
						,CreateDate
						,CreateBy
						,AdiKey
						,astRowStatus
						,adiTableName
						,LoadDate
						,srcFileName)
			--	DECLARE @QMDate DATE = '2021-01-22' DECLARE @CLIENTKEY INT = 3
	SELECT				a.ClientKey										AS ClientKey
						,a.CLIENT_SUBSCRIBER_ID							AS ClientMemberKey
						,(	SELECT	QM									 
							FROM	AceMasterData.lst.LIST_QM_Mapping 	 
							WHERE	Clientkey = 3						 
							AND		QM = 'AETNA_MA_AWV'					 
						)												AS QmMsrId
						,'DEN'											AS QmCntCat
						,@QMDate										AS QMDate
						,GETDATE()										AS CreateDate
						,SUSER_SNAME()									AS CreateBy
						,mbrMemberKey									AS AdiKey
						,'P'											AS astRowStatus
						,'tvf_ActiveMembers'							AS adiTableName
						,@QMDate
						,'tvf_ActiveMembers'
	FROM				ACECAREDW.dbo.tvf_Activemembers(GETDATE()) a
	WHERE				ClientKey = @ClientKey
	UNION
	SELECT				a.ClientKey
						,a.CLIENT_SUBSCRIBER_ID
						,(	SELECT	QM	
							FROM	AceMasterData.lst.LIST_QM_Mapping 
							WHERE	Clientkey = 3
							AND		QM = 'AETNA_MA_AWV'
						)QmMsrId
						,'COP' QmCntCat
						,@QMDate		AS QMDate
						,GETDATE()		AS CreateDate
						,SUSER_SNAME()	AS CreateBy
						,mbrMemberKey   AS AdiKey
						,'P'											AS astRowStatus
						,'tvf_ActiveMembers'							AS adiTableName
						,@QMDate
						,'tvf_ActiveMembers'
	FROM				ACECAREDW.dbo.tvf_Activemembers(GETDATE()) a
	WHERE				ClientKey = @ClientKey
	
	--Step 2
	--Process into DW

	INSERT	INTO		[ACECAREDW].[adw].[QM_ResultByMember_History]
						(ClientKey
						,ClientMemberKey
						,QmMsrId
						,QmCntCat
						,QMDate
						,CreateDate
						,CreateBy
						,AdiKey)
	OUTPUT				inserted.QM_ResultByMbr_HistoryKey INTO #OutputTbl(ID)
	SELECT				ClientKey
						, ClientMemberKey
						,QmMsrId
						,QmCntCat
						,QMDate
						,CreateDate
						,CreateBy
						,AdiKey
	FROM				[ACECAREDW].[ast].[QM_ResultByMember_History]  
	WHERE				ClientKey = @ClientKey 
	AND					QMDate = @QMDate

	
	
	SELECT				@OutCnt = COUNT(*) FROM #OutputTbl;
	SET					@ActionStart  = GETDATE();
	SET					@JobStatus =2  
	    				
	EXEC				amd.sp_AceEtlAudit_Close 
						@AuditId = @AuditID
						, @ActionStopTime = @ActionStart
						, @SourceCount = @InpCnt		  
						, @DestinationCount = @OutCnt
						, @ErrorCount = @ErrCnt
						, @JobStatus = @JobStatus

	COMMIT
	END TRY

	BEGIN CATCH
	EXECUTE [dbo].[usp_QM_Error_handler]
	END CATCH

	END    

	