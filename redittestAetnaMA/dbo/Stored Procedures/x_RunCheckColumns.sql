CREATE PROCEDURE dbo.x_RunCheckColumns
--(@ChkID			VARCHAR(50))
AS
DECLARE @tmpParameters	TABLE(
	 URN				INT IDENTITY NOT NULL
	,ChkID			VARCHAR(50)
	,ChkField		VARCHAR(50)
	,ChkOperator	VARCHAR(50)
	,ChkValue		VARCHAR(1000))
INSERT INTO @tmpParameters
	(ChkID		
	,ChkField	
	,ChkOperator
	,ChkValue)
SELECT ChkID, ChkField, ChkOperator, ChkValue FROM #tmpParameters 

DECLARE @CodeVer				VARCHAR(5)	= '1'
DECLARE @SQL					NVARCHAR(4000)
DECLARE @i						INT			= 1
DECLARE @rTotal				BIGINT		= 0
DECLARE @RowCnt				BIGINT		= 0

SELECT @RowCnt = count(0) FROM @tmpParameters
WHILE @i <= @RowCnt
BEGIN
DECLARE @ChkID				VARCHAR(50)		= (SELECT ChkID		 FROM @tmpParameters WHERE URN = @i)
DECLARE @ChkField			VARCHAR(50)		= (SELECT ChkField	 FROM @tmpParameters WHERE URN = @i)
DECLARE @ChkOperator		VARCHAR(50)		= (SELECT ChkOperator FROM @tmpParameters WHERE URN = @i)
DECLARE @ChkValue			VARCHAR(1000)	= (SELECT REPLACE(ChkValue,'|','''')	 FROM @tmpParameters	WHERE URN = @i)

SET NOCOUNT ON;
SET @SQL='
BEGIN 
UPDATE #tmpStgDetails
	SET ' + @ChkID + '_Flg = 1
	WHERE ClaimAetMAKey IN (
		SELECT ClaimAetMAKey
		FROM (
			SELECT seq_claim_id, ClaimAetMAKey
			FROM #tmpStgDetails
			WHERE HLFlg = 1
				AND ' + @ChkField + ' ' + @ChkOperator + '(' + @ChkValue + ')
			) m
			)
END
'
--PRINT @SQL
EXEC dbo.sp_executesql @SQL
SET @rTotal	+= @i
SET @i= @i + 1
END
