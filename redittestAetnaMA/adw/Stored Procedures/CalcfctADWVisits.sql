


CREATE PROCEDURE [adw].[CalcfctADWVisits]
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
-- temp
--DECLARE @RunDate				DATE = '01-15-2021'
--DECLARE @KPIStartDate		DATE = '01-01-2020'
--DECLARE @KPIEndDate			DATE = '12-31-2020'
-- end temp
DECLARE @PrevYearDate [Date] = CASE WHEN month(@RunDate) IN (1,2,3) THEN (SELECT CAST(DATEADD(year, -2, @RunDate) AS DATE))
	ELSE (SELECT CAST(DATEADD(year, -1, @RunDate) AS DATE)) END 
DECLARE @CodeSetDate		DATE = @KPIStartDate

--DROP TABLE #tmpAWVVisits
CREATE TABLE #tmpAWVVisits (
	 CatGrp					VARCHAR(10)
	,QMDate					DATE
	,ClientKey				VARCHAR(2)
	,PrimSvcDate			DATE
	,QMMsrID					VARCHAR(50)
	,QmCntCat				VARCHAR(50)
	,ClientMemberKey		VARCHAR(50)
	,SeqClaimID				VARCHAR(50)
	,AddressedFlg			INT
	,AWV_CODE				VARCHAR(20)
	,AWV_TYPE				VARCHAR(30)
	)
INSERT INTO #tmpAWVVisits
-- Population of Members that AWV has either been captured through a claim or addressed by emr data
SELECT * FROM (
-- From QM_ResultByValueCodeDetails_History, to get AWV_CODE & AWV_TYPE
SELECT 'Claims' as CatGrp, b.QmDate, b.ClientKey, b.valueCodePrimarySvcDate as PrimSvcDate, b.QMMsrID, b.QMCntCat, b.ClientMemberKey, b.SEQ_CLAIM_ID, a.Addressed, b.ValueCode as AWV_CODE
  ,CASE	WHEN b.ValueCode = 'G0438' THEN 'Initial'
			WHEN b.ValueCode = 'G0439' THEN 'Subsequent'
			WHEN b.ValueCode = 'G0402' THEN 'Welcome'
			WHEN b.ValueCode = 'G0468' THEN 'FQHC AWV'
			ELSE 'Other' END AS AWV_TYPE
FROM [adw].[QM_ResultByValueCodeDetails_History] b 
JOIN adw.QM_ResultByMember_History a
	ON		b.ClientMemberKey		= a.ClientMemberKey
	AND	b.QmMsrID				= a.QmMsrId
	AND	b.QmCntCat				= a.QmCntCat
	AND	b.QMDate					= a.QMDate
	AND	b.QmCntCat = 'NUM'
WHERE		b.QmMsrID LIKE '%ACE%AWV%'
	AND	b.QmDate = @RunDate
UNION
-- From QM_ResultByMember_History, to get AddressFlag, and default in AWV_CODE & AWV_TYPE
SELECT 'NonClaims' as CatGrp, a.QmDate, a.ClientKey, b.AddressedDate as PrimSvcDate, a.QMMsrID, a.QMCntCat, a.ClientMemberKey, 'ExtSrc', a.Addressed, 'ExtSrc' as AWV_CODE, 'NonClaim' as AWV_TYPE
FROM adw.QM_ResultByMember_History a  
JOIN adw.QM_Addressed b
	ON  a.ClientMemberKey		= b.ClientMemberKey
	AND a.QmDate					= b.QMDate
	AND a.QmMsrId					= b.QmMsrId
WHERE		a.QmMsrID LIKE '%ACE%AWV%'
	AND	a.QmDate = @RunDate
	AND	a.QmCntCat = 'COP'
	AND	a.Addressed = 1
	) m

INSERT INTO [adw].[FctAWVVisits]
         (
          [SrcFileName]
         ,[LoadDate]
         ,[DataDate]
         ,[ClientKey]
         ,[ClientMemberKey]
         ,[EffectiveAsOfDate]
         ,[ClaimID]
         ,[PrimaryServiceDate]
		   ,[AWVType]
		   ,[AWVCode]
         ,[SVCProviderNPI]
         ,[SVCProviderName]
         ,[SVCProviderSpecialty]
		   ,[AttribNPI]
		   ,[AttribTIN])

--DECLARE @RunDate				DATE = '01-15-2021'
--DECLARE @KPIStartDate		DATE = '01-01-2020'
--DECLARE @KPIEndDate			DATE = '12-31-2020'
--DECLARE @PrevYearDate [Date] = CASE WHEN month(@RunDate) IN (1,2,3) THEN (SELECT CAST(DATEADD(year, -2, @RunDate) AS DATE))
--	ELSE (SELECT CAST(DATEADD(year, -1, @RunDate) AS DATE)) END 

SELECT  CONCAT('[adw].[CalcfctAWVVisits] ',@KPIStartDate,'-',@KPIEndDate) as [SrcFileName]
	,GETDATE()						as [LoadDate]
	,@RunDate						as DataDate
	,t.ClientKey
	,t.ClientMemberKey
	,@RunDate						as EffectiveAsOfDate
	,t.SeqClaimID
	,t.PrimSvcDate					-- From Claims (tvf_Get_AWVisits) and Addressed (AddressedDate)
	,t.AWV_TYPE
	,t.AWV_CODE
	,c.SVC_PROV_NPI
	,svcnpi.LegalBusinessName	as LBN
	,c.PROV_SPEC
	,a.NPI							AS AttribNPI
	,a.PcpPracticeTIN				AS AttribTIN
	--,t.AddressedFlg AS tAddress
FROM #tmpAWVVisits	t
-- Claims based AWV 
LEFT JOIN  [adw].[2020_tvf_Get_AWVisits]	(@KPIStartDate,@PrevYearDate,@RunDate) c
	ON		t.ClientMemberKey		= c.SUBSCRIBER_ID
	AND	t.SeqClaimID			= c.SEQ_CLAIM_ID
-- Current Membership
LEFT JOIN  [adw].[2020_tvf_Get_ActiveMembersFull]	(@MbrEffectiveDate) a
	ON		t.ClientKey				= a.ClientKey
	AND	t.ClientMemberKey		= a.ClientMemberKey
-- Update Service Name
LEFT JOIN adw.[2020_tvf_Get_DataFromNPPES] (getdate()) svcnpi
	ON c.SVC_PROV_NPI = svcnpi.NPI


WAITFOR DELAY '00:00:02'; 
UPDATE [adw].[FctAWVVisits]
	SET LastAWVKey =  lstawv.FctAWVVisitsSkey,
		LastAWVDate = lstawv.PrimaryServiceDate,
		LastAWVNPI =  lstawv.SVCProviderNPI
	FROM [adw].[FctAWVVisits] a, (SELECT ClientMemberKey, FctAWVVisitsSkey, PrimaryServiceDate, SVCProviderNPI FROM [adw].[2020_tvf_Get_MembersLastAWVisit] (getdate())) lstawv
	WHERE a.ClientMemberKey = lstawv.ClientMemberKey
	
END;												

/***
EXEC [adw].[CalcfctADWVisits] 16,'01-15-2021','01-01-2020','09-30-2020','01-15-2021'

SELECT * --DISTINCT(ClientMemberKey) as DstMbr--, PrimaryServiceDate
FROM [adw].[FctAWVVisits]
WHERE EffectiveAsOfDate = '01-15-2021'
AND CONVERT(DATE,CreatedDate) = '01-29-2021' --'01-13-2021'
--AND AWVtype = 'NonClaim'
ORDER BY PrimaryServiceDate

select *
from adw.QM_ResultByValueCodeDetails_History where SEQ_CLAIM_ID= '91686116403'
select *
from adw.fctAWVVisits where ClaimId = '91686116403'
select * 
FROM #tmpAWVVisits where SeqClaimId = '91686116403'

Select *
	,c.PRIMARY_SVC_DATE 
--		,CASE WHEN (CASE WHEN c.PRIMARY_SVC_DATE IS NOT NULL THEN c.PRIMARY_SVC_DATE ELSE d.AddressedDate  END) IS NULL THEN '1900-01-01'
--	ELSE (CASE WHEN c.PRIMARY_SVC_DATE IS NOT NULL THEN c.PRIMARY_SVC_DATE ELSE d.AddressedDate  END) END as PrimSvcDate  
FROM [adw].[2020_tvf_Get_AWVisits]	('01-01-2020','03-31-2020','01-01-2020') c
WHERE c.SEQ_CLAIM_ID = '91686116403'
***/



