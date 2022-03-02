


CREATE PROCEDURE [adw].[sp_Drop_Create_Load_tmp_AHR_HL7_Report_Detail_Dx] 
	(
	@ClientKeyID	VARCHAR(2),
	@RunDate		DATE
	)
AS
BEGIN

	SET NOCOUNT ON;

CREATE TABLE #tmpMissingDx(
	[DX_ID] [int]		IDENTITY(3000,1) NOT NULL,
	[SUBSCRIBER_ID]		[varchar](50) NULL,
	[ICD10_Code]			[varchar](11) NULL,
	[ICD10_DESC]			[varchar](max) NULL,
	[HCC_Code]				[varchar](3) NULL,
	[HCC_DESC]				[varchar](max) NULL,
	[PRIMARY_SVC_DATE]	[date]
)
CREATE CLUSTERED INDEX ix_tmpSubcriberIDICDHCC ON #tmpMissingDx ([SUBSCRIBER_ID], [ICD10_Code], [HCC_Code])

IF OBJECT_ID('[dbo].[tmp_AHR_HL7_Report_Detail_Dx]', 'U') IS NOT NULL 
  DROP TABLE [dbo].[tmp_AHR_HL7_Report_Detail_Dx]; 

CREATE TABLE [dbo].[tmp_AHR_HL7_Report_Detail_Dx](
	[ID] [int] IDENTITY(2000,1) NOT NULL,
	[SUBSCRIBER_ID] [varchar](50) NULL,
	[ICD10_Code] [varchar](11) NULL,
	[DESC] [varchar](max) NULL,
	[HCC] [varchar](3) NULL,
	[HCC_Description] [varchar](max) NULL,
	[WEIGHT] [decimal](4, 3) NULL,
	[SVC_PROV_FULL_NAME] [varchar](250) NULL,
	[SVC_PROV_NPI] [varchar](11) NULL,
	[PRIMARY_SVC_DATE] [date] NULL,
	[LOADDATE] [date] NULL,
	[LOADEDBY] [varchar](50) NULL
)

ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_Dx] ADD  DEFAULT (sysdatetime()) FOR [LOADDATE]

ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_Dx] ADD  DEFAULT (suser_sname()) FOR [LOADEDBY]

DECLARE @BeginDate [Date] = ( SELECT CAST(DATEADD(YEAR, -1, @RunDate) AS DATE) )
DECLARE @EndDate [Date] = ( SELECT CONVERT (DATE, @RunDate) ) 

	INSERT INTO #tmpMissingDx 
		(
			[SUBSCRIBER_ID]
			,[ICD10_Code]
			,[ICD10_DESC]
			,[HCC_Code]
			,[PRIMARY_SVC_DATE]
		)
	SELECT DISTINCT
			 a.SUBSCRIBER_ID
			,a.ValueCode
			,b.VALUE_CODE_NAME
			,a.HCC_CODE
			,a.PRIMARY_SVC_DATE
	FROM [adw].[2020_tvf_Get_MissingDxHCC] (@BeginDate, @EndDate,@BeginDate) a
	LEFT JOIN [lst].[LIST_ICD10CM] b
	ON a.ValueCode = b.VALUE_CODE


	INSERT INTO [dbo].[tmp_AHR_HL7_Report_Detail_Dx]
		(
			[SUBSCRIBER_ID]
			,[ICD10_Code]
			,[DESC]
			,[HCC]
			,[HCC_Description]
			--,[PRIMARY_SVC_DATE]
		)
	SELECT DISTINCT
			 a.[SUBSCRIBER_ID]		
			,a.[ICD10_Code]		
			,a.[ICD10_DESC]		
			,a.[HCC_Code]
			,c.HCC_Description			
			--,a.PRIMARY_SVC_DATE
	FROM #tmpMissingDx a
	--GROUP BY a.[SUBSCRIBER_ID]		
	--		,a.[ICD10_Code]		
	--		,a.[ICD10_DESC]		
	--		,a.[HCC_Code]
	LEFT JOIN [lst].[LIST_HCC_CODES] c
	ON a.HCC_CODE = c.HCC_No
	WHERE @RunDate BETWEEN c.EffectiveDate AND c.ExpirationDate
	AND c.Active = 'Y'
END
/***
EXEC [adw].[sp_Drop_Create_Load_tmp_AHR_HL7_Report_Detail_Dx] 20,'04-15-2021'

SELECT *
FROM [dbo].[tmp_AHR_HL7_Report_Detail_Dx]
***/
