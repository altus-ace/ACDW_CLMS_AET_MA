




CREATE VIEW [adw].[vw_Dashboard_AetFinIPER]
AS 

SELECT DISTINCT FIN.[AETMA_Financial_MbrDetailsKey]
      ,fin.[OriginalFileName]
      ,fin.[SrcFileName]
      ,fin.[LoadDate]
      ,fin.[CreatedDate]
      ,fin.[CreatedBy]
      ,fin.[LastUpdatedDate]
      ,fin.[LastUpdatedBy]
      ,[ReportGroup]
      ,[ReportGroupName]
      ,[SubgroupNumber]
      ,fin.[SubgroupName]
      ,fin.[TIN]
      ,fin.[TINName]
      ,[PVN]
      ,fin.[PIN] 
      ,fin.[ProviderName]
      ,[EffectiveMonth]
      ,fin.[Legacy]
      ,[SRCMemberID]
      ,Fin.[LastName]
      ,Fin.[FirstName]
      ,[Age]
      ,[AgeBand]
      ,[Gender]
      ,[Product]
      ,[CMSContract]
      ,[PBPID]
      ,[LineBusiness]
      ,[RiskScore_Projected]
      ,[Revenue]
      ,CAST(ISNULL([MedicalRxCost],0) AS decimal(15,2)) AS MedicalRxCost
      ,[MedicalCostFundPer]
      ,CAST(ISNULL([RevenueNoPartD],0) AS decimal(15,2)) RevenueNoPartD
      ,CAST(ISNULL([MedicalRxCostNoPartD],0) AS decimal(15,2)) MedicalRxCostNoPartD
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
	 ,pr.AccountType
     ,'' as Chapter
	 ,ip.Admits
	 ,CONCAT(IP.MemberID, IP.Startdate) as IPMemberID
	 ,IP.StartDate
	 ,IP.EndDate
	 ,IP.Days
	 ,IP.Diagnosis
	 ,IP.ServiceProviderID
	 ,IP.ServiceProviderName
	 ,IP.ProviderType
	 ,IP.InpatientType
	 ,IP.Day_14_Follow_up_OfficeVisit
	  ,ER.ERVisit
	  ,CONCAT(ER.MemberID,ER.StartDate) as ERMemberID
	  ,ER.StartDate as ERStartDate
	  ,ER.EndDate as EREndDate
	  ,ER.Diagnosis as ERDiagnosis
	  ,ER.ServiceProviderID as ERServiceProviderID
	  ,ER.ServiceProviderName as ERServiceProviderName
  FROM [ACDW_CLMS_AET_MA].[adi].[AETMA_Financial_MbrDetails] fin
	LEFT JOIN [ACDW_CLMS_AET_MA].[adi].[AETMA_IPUTILIZATION] IP
		 on --Fin.TIN = ip.TIN
	--  and fin.AsofDate = ip.Data_AS_OF
	--  and fin.PIN = ip.PIN
	   FIN.SRCMemberID = IP.MemberID
	   AND fin.AsofDate = ip.Data_AS_OF
  LEFT JOIN [ACDW_CLMS_AET_MA].[adi].[AETMA_ERUTILIZATION] ER
		  on 
		  --fin.tin = ER.tin
	  --and fin.AsofDate = ER.Data_AS_OF
	  --and fin.PIN = ER.PIN
	   FIN.SRCMemberID = ER.MemberID
	   AND FIN.AsofDate = ER.Data_As_Of--'08/31/2021'
   join ACECAREDW.[adw].[tvf_AllClient_ProviderRoster] (3, GETDATE(),1) pr
		  on Fin.Tin = pr.AttribTIN 
		 
	
