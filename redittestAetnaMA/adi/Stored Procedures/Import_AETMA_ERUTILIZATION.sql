

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[Import_AETMA_ERUTILIZATION](
    @OriginalFileName varchar (100)  ,
	@SrcFileName varchar (100)  ,
	@LoadDate varchar(10)   ,
	--@CreatedDate date   ,
	@CreatedBy varchar (50)  ,
--	@LastUpdatedDate datetime   ,
	@LastUpdatedBy varchar (50)  ,
	@ProviderGroupNumber varchar(20) ,
	@ProviderGroupName varchar(20) ,
	@SubgroupName varchar(20) ,
	@TIN varchar(20) ,
	@TINName varchar(50) ,
	@PIN varchar(20) ,
	@ProviderName varchar(50) ,
	@GroupIndicator varchar(20) ,
	@LocalMarketCode varchar(20) ,
	@LocalMarket varchar(50) ,
	@Legacy varchar(20) ,
	@BaselineInd varchar(20) ,
	@MemberID varchar(50) ,
	@Member varchar(50) ,
	@Year_Month varchar(20) ,
	@StartDate varchar(10) ,
	@EndDate varchar(10) ,
	@Year varchar(20) ,
	@Month varchar(20) ,
	@Diagnosis varchar(50) ,
	@MedicalCaseID varchar(20) ,
	@ServiceProviderID varchar(20) ,
	@ServiceProviderName varchar(50) ,
	@ERVisit varchar(20) ,
	@ObservationIndicator varchar(20) ,
	@Data_As_Of varchar(10)
	
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--IF(@ReportGroup != '')
	BEGIN
    INSERT INTO [adi].[AETMA_ERUTILIZATION]
   (
       [OriginalFileName]
      ,[SrcFileName]
      ,[LoadDate]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[ProviderGroupNumber]
      ,[ProviderGroupName]
      ,[SubgroupName]
      ,[TIN]
      ,[TINName]
      ,[PIN]
      ,[ProviderName]
      ,[GroupIndicator]
      ,[LocalMarketCode]
      ,[LocalMarket]
      ,[Legacy]
      ,[BaselineInd]
      ,[MemberID]
      ,[Member]
      ,[Year_Month]
      ,[StartDate]
      ,[EndDate]
      ,[Year]
      ,[Month]
      ,[Diagnosis]
      ,[MedicalCaseID]
      ,[ServiceProviderID]
      ,[ServiceProviderName]
      ,[ERVisit]
      ,[ObservationIndicator]
      ,[Data_As_Of]
  )


     VALUES
   (
     @OriginalFileName   ,
	@SrcFileName  ,
	@LoadDate    ,
	GETDATE(),
	--@CreatedDate date   ,
	@CreatedBy   ,
--	@LastUpdatedDate datetime   ,
    GETDATE(),
	@LastUpdatedBy   ,
	@ProviderGroupNumber  ,
	@ProviderGroupName  ,
	@SubgroupName  ,
	@TIN  ,
	@TINName  ,
	@PIN  ,
	@ProviderName  ,
	@GroupIndicator  ,
	@LocalMarketCode  ,
	@LocalMarket  ,
	@Legacy  ,
	@BaselineInd  ,
	@MemberID  ,
	@Member  ,
	@Year_Month  ,
	CASE WHEN @StartDate =''
    THEN NULL
	ELSE CONVERT(DATE,@StartDate)
	END,
	CASE WHEN @EndDate =''
    THEN NULL
	ELSE CONVERT(DATE,@EndDate)
	END,
	@Year  ,
	@Month  ,
	@Diagnosis  ,
	@MedicalCaseID  ,
	@ServiceProviderID  ,
	@ServiceProviderName  ,
	@ERVisit  ,
	@ObservationIndicator  ,
	CASE WHEN @Data_As_Of =''
    THEN NULL
	ELSE CONVERT(DATE, @Data_As_Of)
	END	
	 
   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, 'ACECARDW.adi.copUhcPcor', '';

END




