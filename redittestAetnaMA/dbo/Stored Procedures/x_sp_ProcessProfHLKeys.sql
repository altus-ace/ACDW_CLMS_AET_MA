


CREATE PROCEDURE [dbo].[x_sp_ProcessProfHLKeys]
(   
	 @SrcTblName				VARCHAR(100)		
	,@SrcLoadDate				DATE		
	,@TgtTblName				VARCHAR(100)	
)
AS
BEGIN
-- Declare Global Variables for mapping
DECLARE @LoadDate				VARCHAR(50)		= '[DataDate]'
DECLARE @SrcTblKey			VARCHAR(50)		= '[ProfessionalClaimKey]'
DECLARE @ClientMbrKey		VARCHAR(50)		= '[PatientID]'
DECLARE @ClaimID				VARCHAR(50)		= '[ClaimID]'
DECLARE @AndWhere				VARCHAR(50)		= 'AND ClaimRecordID	= ''CLM'''
DECLARE @UpdateJoin			VARCHAR(100)	= 'ON		a.PatientID = b.' +  @ClientMbrKey + ' AND	a.ClaimID	= b.' +  @ClaimID + ' '

-- Get Distinct Values for LoadDate.  RecStatus (New, Existing)
DECLARE @SQLLoadDate			NVARCHAR(max);
SET @SQLLoadDate	 = '
		DROP TABLE IF EXISTS ' + @TgtTblName + '
		CREATE TABLE ' + @TgtTblName + ' ( 
			 URN							INT IDENTITY NOT NULL 
			,SrcLoadDate				DATE 
			,SrcTblKey					INT
			,PatientID					VARCHAR(50)
			,ClaimID						VARCHAR(50)
			,RecStatus					VARCHAR(1) DEFAULT ' + char(39) + 'N' + char(39) +'
			,RecLoadID					VARCHAR(10)
			,RecUpdateID				VARCHAR(10)
			,RecStatusDate				DATE DEFAULT (sysdatetime())
			,CreateDate					DATE DEFAULT (sysdatetime())
			,CreateBy					VARCHAR(30) DEFAULT (suser_sname()))
		DROP TABLE IF EXISTS dbo.z_tmp_LoadDates
		CREATE TABLE dbo.z_tmp_LoadDates  ( 
			 URN							INT IDENTITY NOT NULL 
			,LoadDate					DATE 
			,RecStatus					VARCHAR(1) DEFAULT ' + char(39) + 'N' + char(39) +'
			,CreateDate					DATE DEFAULT (sysdatetime())
			,CreateBy					VARCHAR(30) DEFAULT (suser_sname()))
		INSERT INTO dbo.z_tmp_LoadDates (LoadDate) 
		SELECT DISTINCT ' + @LoadDate	 + ' FROM ' + @SrcTblName + ' ORDER BY ' + @LoadDate + ' ASC '
EXEC dbo.sp_executesql @SQLLoadDate	

/*** Loop Thru each row and create pivot table ***/
DECLARE @SQLUpdateInsertRec		NVARCHAR(max);
DECLARE @SQLInner				VARCHAR(max)	= ''
DECLARE @SQLi					VARCHAR(max);
DECLARE @c						INT = 1;
DECLARE @cRTotal				BIGINT = 0;
DECLARE @cRowCnt				BIGINT = 0;

-- get a count of total rows to process 
SELECT @cRowCnt = COUNT(0) FROM dbo.z_tmp_LoadDates;
WHILE  @c <= @cRowCnt
BEGIN
DECLARE @RecLoadDate					VARCHAR(15)	= (SELECT LoadDate FROM dbo.z_tmp_LoadDates WHERE urn = @c)
DECLARE @RecLoadID					VARCHAR(25) = (SELECT CONCAT('ID',urn) FROM dbo.z_tmp_LoadDates WHERE urn = @c)
DECLARE @PrevRecLoadID				VARCHAR(25) = CASE WHEN @c = 1 THEN 'ID0' ELSE (SELECT  CONCAT('ID',urn) FROM dbo.z_tmp_LoadDates WHERE urn = @c-1) END
-- create SQL statement 
SET NOCOUNT ON;
BEGIN
	SET @SQLUpdateInsertRec =	'
		UPDATE ' + @TgtTblName + '
		SET RecStatus = '+ char(39) + 'U' + char(39) +', RecStatusDate = (sysdatetime()), RecUpdateID = ' + char(39) + @RecLoadID + char(39) + ' ' + '
		FROM ' + @TgtTblName + ' a JOIN ' + @SrcTblName+ ' b ' + @UpdateJoin + '
		--ON		a.PatientID = b.' +  @ClientMbrKey + '
		--AND	a.ClaimID	= b.' +  @ClaimID + '
		WHERE ' + @LoadDate + '=' + char(39) + @RecLoadDate + char(39) + ' ' + @AndWhere + ' 
		AND a.RecLoadID = ' + char(39) + @PrevRecLoadID + char(39) + '
		INSERT INTO ' + @TgtTblName + '
		(SrcLoadDate, SrcTblKey, PatientID, ClaimID, RecLoadID)
		SELECT ' + @LoadDate + ', ' + @SrcTblKey + ', ' + @ClientMbrKey + ', ' + @ClaimID + ', ' + char(39) + @RecLoadID  + char(39)+'
		FROM ' + @SrcTblName + ' 
		WHERE ' + @LoadDate + '=' + char(39) + @RecLoadDate + char(39) + ' ' + @AndWhere + ' '
END

	SET @cRTotal += @c
	SET @c = @c + 1 
	--PRINT @SQLUpdateInsertRec 
	EXEC dbo.sp_executesql @SQLUpdateInsertRec 

END

END

/***
EXEC dbo.x_sp_ProcessProfHLKeys '[adi].[Steward_BCBS_ProfessionallClaim]','01-01-2021','dbo.z_tmp_ProfHLKeyTbl'

SELECT DISTINCT SrcLoadDate, RecStatus, count(*) as CntRec FROM dbo.z_tmp_ProfHLKeyTbl GROUP BY SrcLoadDate, RecStatus ORDER BY SrcLoadDate, RecStatus
SELECT TOP 1000 * FROM dbo.z_tmp_ProfHLKeyTbl
***/

