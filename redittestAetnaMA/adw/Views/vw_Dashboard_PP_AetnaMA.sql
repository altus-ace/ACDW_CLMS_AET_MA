




CREATE VIEW [adw].[vw_Dashboard_PP_AetnaMA]
AS 

with cteFIN
as (
SELECT DISTINCT
    FIN.TIN,
	FIN.TINName,
	FIN.PIN,
	FIN.ProviderName,
	FIN.EffectiveYear,
	MONTH(FIN.EffectiveDate) as EffectiveMonth,
	--FIN.EffectiveDate,
	SUM(isnull(Cast ([MemberMonths] as INT),0)) as MemberMonths,
	AVG(isnull(Cast (FIN.RiskScore_Projected as Decimal(15,0)),0)) as RiskScore,
	SUM(ISNULL(CAST ([MedicalRxCost] AS decimal(15,2)),0)) AS MedicalRxCost,
	SUM(ISNULL(CAST (MedicalRxCostNoPartD AS decimal(15,2)),0)) as MedicalRxCostNoPartD
FROM [ACDW_CLMS_AET_MA].[adi].[AETMA_Financial_MbrDetails] fin
	WHERE FIN.AsofDate= (SELECT MAX(AsofDate) from [ACDW_CLMS_AET_MA].[adi].[AETMA_Financial_MbrDetails])
GROUP BY FIN.PIN,
FIN.ProviderName,
FIN.TIN,
FIN.TINName,
FIN.EffectiveYear,
FIN.EffectiveDate
), 
cteER
AS (

SELECT 
	ER.PIN,
	ER.ProviderName,
	ER.TIN,
	ER.TINName,
	YEAR(ER.StartDate) as EffectiveYear,
	MONTH(ER.StartDate) AS EffectiveMonth,
	SUM(isnull(Cast (ER.ERVisit as Decimal(15,0)),0)) as ERVisits
FROM [ACDW_CLMS_AET_MA].[adi].[AETMA_ERUTILIZATION] ER
WHERE ER.Data_As_Of= (SELECT MAX(Data_As_Of) from [ACDW_CLMS_AET_MA].[adi].[AETMA_ERUTILIZATION])
GROUP BY ER.PIN,
	ER.ProviderName,
	ER.TIN,
	ER.TINName,
	YEAR(ER.StartDate),  
	MONTH(ER.StartDate)
),
cteIP
AS (
SELECT 
	IP.PIN,
	IP.ProviderName,
	IP.TIN,
	IP.TINName,
	YEAR(IP.StartDate) as EffectiveYear,
	MONTH(IP.StartDate) AS EffectiveMonth,
	SUM(isnull(Cast (IP.Admits as INT),0)) as IPAdmits
FROM [ACDW_CLMS_AET_MA].[adi].[AETMA_IPUTILIZATION] IP
WHERE IP.Data_As_Of= (SELECT MAX(Data_As_Of) from [ACDW_CLMS_AET_MA].[adi].[AETMA_IPUTILIZATION])
GROUP BY IP.PIN,
	IP.ProviderName,
	IP.TIN,
	IP.TINName,
	YEAR(IP.StartDate),  --EffectiveYear,
	MONTH(IP.StartDate)-- AS EffectiveMonth,
)

SELECT DISTINCT
		TIN, 
		TINName,
		PIN,
		ProviderName,
		MedicalRxCost,
		MedicalRxCostNoPartD,
		MemberMonths,
		IPAdmits,
	    ERVisits	
		,SUM(ERVisits) / SUM(MemberMonths) * 12000 as EDK
		,SUM(IPAdmits) / SUM(MemberMonths) * 12000 as ADK
		,SUM(MedicalRxCost) / SUM(MemberMonths) AS PMPM
		,RiskScore
		,EffectiveYear
		,EffectiveMonth
		--,EffectiveDate
FROM (
	SELECT FIN.*
		,ISNULL(ER.ERVisits,0) AS ERVisits
		,ISNULL(IP.IPAdmits,0) as IPAdmits
	FROM CTEFIN FIN
	LEFT JOIN CTEER ER
	ON FIN.PIN = ER.PIN
	AND FIN.EffectiveYear = ER.EffectiveYear
	AND FIN.EffectiveMonth = ER.EffectiveMonth
	LEFT JOIN cteIP IP
	on FIN.PIN = IP.PIN
	AND FIN.EffectiveYear = IP.EffectiveYear
	AND FIN.EffectiveMonth = IP.EffectiveMonth
) m
GROUP BY TIN, 
		TINName,
		PIN,
		ProviderName,
		MedicalRxCost,
		MemberMonths,
		IPAdmits,
	    ERVisits,
		EffectiveYear,
		EffectiveMonth,
		RiskScore,
		MedicalRxCostNoPartD

