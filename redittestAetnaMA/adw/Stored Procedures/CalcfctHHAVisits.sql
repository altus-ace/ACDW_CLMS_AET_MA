



CREATE PROCEDURE [adw].[CalcfctHHAVisits]
	(
	@ClientKeyID				VARCHAR(2),
	@RunDate						DATE,
	@KPIStartDate				DATE,
	@KPIEndDate					DATE,
	@MbrEffectiveDate			DATE
	)
AS    
BEGIN
    SET NOCOUNT ON;

INSERT INTO [adw].[FctHHAVisits]
           (
            [SrcFileName]
           ,[LoadDate]
           ,[DataDate]
           ,[ClientKey]
           ,[ClientMemberKey]
           ,[EffectiveAsOfDate]
           ,[SEQ_ClaimID]
           ,[PrimaryServiceDate]
           ,[AdmissionDate]
           ,[DischargeDate]
           ,[VendorID]
           ,[VendorName]
           ,[FacilityPrefferedFlag]
           ,[LOS]
           ,[ClaimType]
           ,[BillType]
           ,[AttribNPI]
           ,[AttribTIN]
           ,[DetailServiceDate]
           ,[CPTCode]
           ,[RevCode])
	SELECT  CONCAT('[adw].[CalcfctHHAVisits]',@KPIStartDate,'-',@KPIEndDate)				
			,GETDATE()
			,@RunDate
			,a.ClientKey
			,a.ClientMemberKey
			,@RunDate
			,b.SEQ_CLAIM_ID
			,b.PRIMARY_SVC_DATE
			,b.ADMISSION_DATE
			,b.SVC_TO_DATE
			,b.VENDOR_ID
			,vennpi.LegalBusinessName 
			,CASE WHEN e.FacilityName IS NOT NULL THEN 1 ELSE 0 END as PreferredFacilicyFlg
			,CASE WHEN DATEDIFF(dd, b.PRIMARY_SVC_DATE, b.SVC_TO_DATE) = 0 THEN 1 ELSE DATEDIFF(dd, b.PRIMARY_SVC_DATE, b.SVC_TO_DATE) END AS LOS
			,b.CLAIM_TYPE
			,b.BILL_TYPE
			,a.NPI 
			,a.PcpPracticeTIN
			,b.DETAIL_SVC_DATE
			,b.CPT_CODE
			,b.REVENUE_CODE
		FROM [adw].[2020_tvf_Get_ActiveMembersFull]	(@MbrEffectiveDate) a
		JOIN [adw].[2020_tvf_Get_HHAVisits] (@KPIStartDate,DATEADD(month, 3, @KPIEndDate)) b
			ON a.ClientMemberKey = b.SUBSCRIBER_ID
		LEFT JOIN [lst].[lstPreferredFacility] e
			ON b.VENDOR_ID = e.NPI
		LEFT JOIN adw.[2020_tvf_Get_DataFromNPPES] (getdate()) vennpi
			ON b.VENDOR_ID = vennpi.NPI
END;												


/***
EXEC [adw].[CalcfctHHAVisits] 16,'09-15-2020','01-01-2019','06-30-2020','05-15-2020'

SELECT @EffectiveAsOfDate AS EffectiveAsOfDate, SUBSCRIBER_ID AS ClientMemberKey, YEAR(DETAIL_SVC_DATE) AS DetailSvcYr, MONTH(DETAIL_SVC_DATE) AS DetailSvcMth
	,count(distinct DETAIL_SVC_DATE) as CntVisits
FROM [adw].[2020_tvf_Get_HHAVisits] (@PrimarySvcDate_Start,@PrimarySvcDate_End)
GROUP BY SUBSCRIBER_ID, YEAR(DETAIL_SVC_DATE), MONTH(DETAIL_SVC_DATE) 
ORDER BY SUBSCRIBER_ID, YEAR(DETAIL_SVC_DATE) DESC, MONTH(DETAIL_SVC_DATE) DESC

SELECT EffectiveAsOfDate, ClientMemberKey, YEAR([DetailServiceDate]) AS DetailSvcYr, MONTH([DetailServiceDate]) AS DetailSvcMth
	,COUNT(distinct concat(ClientMemberKey, DetailServiceDate)) AS CntVisits
FROM [adw].[FctHHAVisits] 
WHERE EffectiveAsOfDate = '09-15-2020'
and ClientMemberKey = '9QR7WH2UH77'
GROUP BY EffectiveAsOfDate, ClientMemberKey, YEAR([DetailServiceDate]), MONTH([DetailServiceDate]) 
ORDER BY EffectiveAsOfDate, ClientMemberKey, YEAR([DetailServiceDate]), MONTH([DetailServiceDate]) 


SELECT EffectiveAsOfDate, YEAR([PrimaryServiceDate]) AS DetailSvcYr, MONTH([PrimaryServiceDate]) AS DetailSvcMth
	,COUNT(distinct ClientMemberKey) AS CntVisits
FROM [adw].[FctHHAVisits] 
WHERE EffectiveAsOfDate = '09-15-2020'
--and ClientMemberKey = '9QR7WH2UH77'
and claimtype = '10'
GROUP BY EffectiveAsOfDate,  YEAR([PrimaryServiceDate]), MONTH([PrimaryServiceDate]) 
ORDER BY EffectiveAsOfDate,  YEAR([PrimaryServiceDate]), MONTH([PrimaryServiceDate]) 

DELETE  FROM [adw].[FctHHAVisits] 

SELECT CONCAT(ClientMemberKey,PrimaryServiceDate) as CS
FROM adw.fctInpatientVisits
WHERE ClaimType = '10'
AND EffectiveAsOfDate = '09-15-2020'
except
SELECT CONCAT(ClientMemberKey,PrimaryServiceDate) as CS
FROM adw.fctHHAVisits
WHERE ClaimType = '10'
AND EffectiveAsOfDate = '09-15-2020'


declare @RunDate			DATE			= '09-15-2020'
declare @KPIStartDate	DATE		= '01-01-2020'
declare @KPIEndDate		DATE		= '06-30-2020'
select a.ClientMemberKey,b.*
FROM [adw].[2020_tvf_Get_ActiveMembersFull]	(@RunDate) a
		JOIN [adw].[2020_tvf_Get_HHAVisits] (@KPIStartDate,DATEADD(month, 3, @KPIEndDate)) b
		on a.ClientMemberKey = b.SUBSCRIBER_ID
		WHERE B.SUBSCRIBER_ID = '7dc8jr5tp21'
----
declare @ClientMemberKey VARCHAR(20) = '7dc8jr5tp21'
declare @PrimaryServiceDate	DATE	= '2020-06-11'
select *
from adw.FctHHAVisits
where ClientMemberKey =  @ClientMemberKey
and PrimaryServiceDate = @PrimaryServiceDate
select h.*,d.*
from adw.Claims_Headers h
join adw.Claims_Details d
on h.subscriber_id = d.subscriber_id
and h.seq_claim_id = d.seq_claim_id
where h.SUBSCRIBER_ID = @ClientMemberKey
and   h.CLAIM_TYPE = '10'
and   h.PRIMARY_SVC_DATE = @PrimaryServiceDate
select TOP 100 *
from [adi].[Steward_MSSPPartAClaimLineItem]
where MedicareBeneficiaryID  = @ClientMemberKey
and claimTypeCD = '10'
and StartDTS = @PrimaryServiceDate

***/

