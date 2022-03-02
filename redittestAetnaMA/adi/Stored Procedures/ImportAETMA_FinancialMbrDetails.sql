-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportAETMA_FinancialMbrDetails](
    @OriginalFileName varchar(100)  ,
	@SrcFileName varchar(100)  ,
	@LoadDate varchar(10)   ,
	--@CreatedDate date   ,
	@CreatedBy varchar(50)  ,
--	@LastUpdatedDate datetime   ,
	@LastUpdatedBy varchar (50)  ,
	@ReportGroup [varchar](50) ,
	@ReportGroupName [varchar](50) ,
	@SubgroupNumber [varchar](50) ,
	@SubgroupName [varchar](50) ,
	@TIN [varchar](12) ,
	@TINName [varchar](50) ,
	@PVN [varchar](50) ,
	@PIN [varchar](50) ,
	@ProviderName [varchar](50) ,
	@EffectiveMonth [varchar](50) ,
	@Legacy [varchar](50) ,
	@SRCMemberID [varchar](50) ,
	@LastName [varchar](50) ,
	@FirstName [varchar](50) ,
	@Age [varchar](10) ,
	@AgeBand [varchar](50) ,
	@Gender [varchar](10) ,
	@Product [varchar](50) ,
	@CMSContract [varchar](50) ,
	@PBPID [varchar](50) ,
	@LineBusiness [varchar](50) ,
	@RiskScore_Projected [varchar](50) ,
	@Revenue [varchar](50) ,
	@MedicalRxCost [varchar](50) ,
	@MedicalCostFundPer [varchar](50) ,
	@RevenueNoPartD [varchar](50) ,
	@MedicalRxCostNoPartD [varchar](50) ,
	@EffectiveYear [varchar](10) ,
	@EffectiveMonthName [varchar](10) ,
	@EffectiveDate varchar(10) ,
	@TINReportName [varchar](50) ,
	@ProviderReportName [varchar](50) ,
	@MemberMonths [varchar](10) ,
	@AsofDate varchar(10) ,
	@Target  [varchar](50) ,
	@LocalMarketName  [varchar](50) ,
	@MarketAvgRiskScore_Projected [varchar](50) ,
	@MarketMedicalRxCost_PMPM [varchar](50) ,
	@MarketRevenue_PMPM [varchar](50) ,
	@MarketMedicalCostFund [varchar](50) ,
	@MarketMedical_RxCostNoPartD_PMPM [varchar](50) ,
	@MarketRevenueNo_PartD_PMPM [varchar](50) ,
	@MarketMedicalCostFund_NoPartD [varchar](50) ,
   	@ProviderFirstName [varchar](50),
	@ProviderMiddleName [varchar](50),
	@ProviderLastName [varchar](50),
	@NPI [varchar](20) ,
	@Chapter [varchar](20) 
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF(@ReportGroup != '')
	BEGIN
    INSERT INTO [adi].[AETMAFinancialMemberDetails]
   (
       [OriginalFileName]
      ,[SrcFileName]
      ,[LoadDate]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[ReportGroup]
      ,[ReportGroupName]
      ,[SubgroupNumber]
      ,[SubgroupName]
      ,[TIN]
      ,[TINName]
      ,[PVN]
      ,[PIN]
      ,[ProviderName]
      ,[EffectiveMonth]
      ,[Legacy]
      ,[SRCMemberID]
      ,[LastName]
      ,[FirstName]
      ,[Age]
      ,[AgeBand]
      ,[Gender]
      ,[Product]
      ,[CMSContract]
      ,[PBPID]
      ,[LineBusiness]
      ,[RiskScore_Projected]
      ,[Revenue]
      ,[MedicalRxCost]
      ,[MedicalCostFundPer]
      ,[RevenueNoPartD]
      ,[MedicalRxCostNoPartD]
      ,[EffectiveYear]
      ,[EffectiveMonthName]
      ,[EffectiveDate]
      ,[TINReportName]
      ,[ProviderReportName]
      ,[MemberMonths]
      ,[AsofDate]
      ,[Target]
      ,[LocalMarketName]
      ,[MarketAvgRiskScore_Projected]
      ,[MarketMedicalRxCost_PMPM]
      ,[MarketMedicalCostFund]
      ,[MarketMedical_RxCostNoPartD_PMPM]
      ,[MarketRevenueNo_PartD_PMPM]
      ,[MarketMedicalCostFund_NoPartD] 
	  ,[MarketRevenue_PMPM]
	  ,[ProviderFirstName]
      ,[ProviderMiddleName]
      ,[ProviderLastName]
      ,[NPI]
      ,[Chapter]
  )


     VALUES
   (
    @OriginalFileName  ,
	@SrcFileName   ,
	DATEADD(mm, DATEDIFF(mm,0, GETDATE()), 0)  ,
	GETDATE(),
	--@Created    ,
	@CreatedBy  ,
	--@LastUpd time   ,
	GETDATE(),
	@LastUpdatedBy ,
	@ReportGroup  ,
	@ReportGroupName  ,
	@SubgroupNumber  ,
	@SubgroupName  ,
	@TIN  ,
	@TINName  ,
	@PVN  ,
	@PIN  ,
	@ProviderName  ,
	@EffectiveMonth  ,
	@Legacy  ,
	@SRCMemberID  ,
	@LastName  ,
	@FirstName  ,
	@Age  ,
	@AgeBand  ,
	@Gender  ,
	@Product  ,
	@CMSContract  ,
	@PBPID  ,
	@LineBusiness  ,
	@RiskScore_Projected  ,
	CASE WHEN @Revenue = ''
	THEN NULL
	ELSE CONVERT(money, @Revenue)
	END ,	
	CASE WHEN @MedicalRxCost = ''
	THEN NULL
	ELSE CONVERT(money, @MedicalRxCost)
	END ,
	@MedicalCostFundPer  ,
	@RevenueNoPartD  ,
	@MedicalRxCostNoPartD  ,
	@EffectiveYear  ,
	@EffectiveMonthName  ,
	CASE WHEN @EffectiveDate = ''
	THEN NULL
	ELSE CONVERT(DATE,@EffectiveDate )
	END ,
	@TINReportName  ,
	@ProviderReportName  ,
	@MemberMonths  ,
	CASE WHEN @AsofDate   = ''
	THEN NULL
	ELSE CONVERT(DATE, @AsofDate  )
	END ,

	@Target   ,
	@LocalMarketName   ,
	@MarketAvgRiskScore_Projected  ,
	CASE WHEN @MarketMedicalRxCost_PMPM =''
	THEN NULL
	ELSE CONVERT(money, @MarketMedicalRxCost_PMPM)
	END ,
	CASE WHEN @MarketMedicalCostFund =''
	THEN NULL
	ELSE CONVERT(decimal(18,2), @MarketMedicalCostFund)
	END ,
	CASE WHEN @MarketMedical_RxCostNoPartD_PMPM =''
	THEN NULL
	ELSE CONVERT(money, @MarketMedical_RxCostNoPartD_PMPM)
	END ,
	CASE WHEN @MarketRevenueNo_PartD_PMPM  =''
	THEN NULL
	ELSE CONVERT(money, @MarketRevenueNo_PartD_PMPM )
	END ,	
	CASE WHEN @MarketMedicalCostFund_NoPartD =''
	THEN NULL
	ELSE CONVERT(decimal(18,2),	@MarketMedicalCostFund_NoPartD)
	END ,	 

	CASE WHEN @MarketRevenue_PMPM =''
	THEN NULL
	ELSE CONVERT(money, @MarketRevenue_PMPM)
	END ,		
	@ProviderFirstName ,
	@ProviderMiddleName ,
	@ProviderLastName ,
	@NPI  ,
	@Chapter  
   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, 'ACECARDW.adi.copUhcPcor', '';

END



