





CREATE  FUNCTION [adw].[2020_tvf_Get_KPISumByNPIChapter]
(
 @EffectiveAsOfDate		DATE,
 @KPIEffYear			INT,
 @KPIEffMth				INT
)
RETURNS TABLE
AS RETURN
(
SELECT DISTINCT mm.EffectiveAsOfDate, mm.KPIEffYear, mm.KPIEffMth, mm.AttribNPI, mm.AttribNPIName
	,mm.AttribTIN, mm.AttribTINName
	,pcp.PCP_POD as Chapter
	,mm.KPIValue as MbrMths
	,ISNULL(adm.KPIValue,0) as Admits 
	,ISNULL(CONVERT(int,CAST(adm.KPIValue as float)/mm.KPIValue*1000),0) as AdmitsPK
	,ISNULL(bd.KPIValue,0) as BedDays 
	,ISNULL(CONVERT(int,CAST(bd.KPIValue as float)/mm.KPIValue*1000),0) as BedDaysPK
	,ISNULL(ed.KPIValue,0) as EDVisits 
	,ISNULL(CONVERT(int,CAST(ed.KPIValue as float)/mm.KPIValue*1000),0) as EDVisitsPK
	,ISNULL(edip.KPIValue,0) as EDToIPVisits 
	,ISNULL(CONVERT(int,CAST(edip.KPIValue as float)/mm.KPIValue*1000),0) as EDToIPVisitsPK
	,ISNULL(ra.KPIValue,0) as Readmissions 
	,ISNULL(CONVERT(int,CAST(ra.KPIValue as float)/mm.KPIValue*1000),0) as ReadmissionsPK
	,ISNULL(ho.KPIValue,0) as HospiceVisits 
	,ISNULL(CONVERT(int,CAST(ho.KPIValue as float)/mm.KPIValue*1000),0) as HospiceVisitsPK
	,ISNULL(hh.KPIValue,0) as HHAVisits 
	,ISNULL(CONVERT(int,CAST(hh.KPIValue as float)/mm.KPIValue*1000),0) as HHAVisitsPK
	,ISNULL(lt.KPIValue,0) as LTACVisits 
	,ISNULL(CONVERT(int,CAST(lt.KPIValue as float)/mm.KPIValue*1000),0) as LTACVisitsPK
	,ISNULL(ir.KPIValue,0) as IRFVisits
	,ISNULL(CONVERT(int,CAST(ir.KPIValue as float)/mm.KPIValue*1000),0) as IRFVisitsPK
	,ISNULL(sa.KPIValue,0) as SNFAdmits 
	,ISNULL(CONVERT(int,CAST(sa.KPIValue as float)/mm.KPIValue*1000),0) as SNFAdmitsPK
	,ISNULL(sd.KPIValue,0) as SNFDays 
	,ISNULL(CONVERT(int,CAST(sd.KPIValue as float)/mm.KPIValue*1000),0) as SNFDaysPK
	,ISNULL(awv.KPIValue,0) as AWV
	,CAST((CAST(ISNULL(awv.KPIValue,0) as Float) / mm.KPIValue ) as decimal(5,2)) as AWVPct
	,ISNULL(awvpcp.KPIValue,0) as AWVSeen 
	,ISNULL(CAST((CAST(ISNULL(awvpcp.KPIValue,0) as Float) / awv.KPIValue * 100) as decimal(5,2)),0) as AWVSeenPct
	,ISNULL(tme.KPIValue,0) as TME 
	,ISNULL(CONVERT(int,CAST(tme.KPIValue as float)/mm.KPIValue),0) as PMPM

FROM [adw].[FctMEKPIByNPI] mm
LEFT JOIN (
	SELECT tmp.EffectiveAsOfDate, tmp.KPIEffYear, tmp.KPIEffMth, tmp.AttribNPI
		,tmp.KPIValue 
	FROM [adw].[FctMEKPIByNPI] tmp
	WHERE tmp.KPI_ID = 200
	) adm
ON	mm.AttribNPI = adm.AttribNPI
AND mm.KPIEffYear	 = adm.KPIEffYear 
AND mm.KPIEffMth	 = adm.KPIEffMth
AND mm.EffectiveAsOfDate = adm.EffectiveAsOfDate
LEFT JOIN (
	SELECT tmp.EffectiveAsOfDate, tmp.KPIEffYear, tmp.KPIEffMth, tmp.AttribNPI
		,tmp.KPIValue 
	FROM [adw].[FctMEKPIByNPI] tmp
	WHERE tmp.KPI_ID = 201
	) bd
ON	mm.AttribNPI	 = bd.AttribNPI
AND mm.KPIEffYear	 = bd.KPIEffYear 
AND mm.KPIEffMth	 = bd.KPIEffMth
AND mm.EffectiveAsOfDate = bd.EffectiveAsOfDate
LEFT JOIN (
	SELECT tmp.EffectiveAsOfDate, tmp.KPIEffYear, tmp.KPIEffMth, tmp.AttribNPI
		,tmp.KPIValue 
	FROM [adw].[FctMEKPIByNPI] tmp
	WHERE tmp.KPI_ID = 203
	) ed
ON	mm.AttribNPI	 = ed.AttribNPI
AND mm.KPIEffYear	 = ed.KPIEffYear 
AND mm.KPIEffMth	 = ed.KPIEffMth
AND mm.EffectiveAsOfDate = ed.EffectiveAsOfDate
LEFT JOIN (
	SELECT tmp.EffectiveAsOfDate, tmp.KPIEffYear, tmp.KPIEffMth, tmp.AttribNPI
		,tmp.KPIValue 
	FROM [adw].[FctMEKPIByNPI] tmp
	WHERE tmp.KPI_ID = 204
	) ra
ON	mm.AttribNPI	 = ra.AttribNPI
AND mm.KPIEffYear	 = ra.KPIEffYear 
AND mm.KPIEffMth	 = ra.KPIEffMth
AND mm.EffectiveAsOfDate = ra.EffectiveAsOfDate
LEFT JOIN (
	SELECT tmp.EffectiveAsOfDate, tmp.KPIEffYear, tmp.KPIEffMth, tmp.AttribNPI
		,tmp.KPIValue 
	FROM [adw].[FctMEKPIByNPI] tmp
	WHERE tmp.KPI_ID = 205
	) edip
ON	mm.AttribNPI	 = edip.AttribNPI
AND mm.KPIEffYear	 = edip.KPIEffYear 
AND mm.KPIEffMth	 = edip.KPIEffMth
AND mm.EffectiveAsOfDate = edip.EffectiveAsOfDate
LEFT JOIN (
	SELECT tmp.EffectiveAsOfDate, tmp.KPIEffYear, tmp.KPIEffMth, tmp.AttribNPI
		,tmp.KPIValue 
	FROM [adw].[FctMEKPIByNPI] tmp
	WHERE tmp.KPI_ID = 300
	) ho
ON	mm.AttribNPI	 = ho.AttribNPI
AND mm.KPIEffYear	 = ho.KPIEffYear 
AND mm.KPIEffMth	 = ho.KPIEffMth
AND mm.EffectiveAsOfDate = ho.EffectiveAsOfDate
LEFT JOIN (
	SELECT tmp.EffectiveAsOfDate, tmp.KPIEffYear, tmp.KPIEffMth, tmp.AttribNPI
		,tmp.KPIValue 
	FROM [adw].[FctMEKPIByNPI] tmp
	WHERE tmp.KPI_ID = 301
	) hh
ON	mm.AttribNPI	 = hh.AttribNPI
AND mm.KPIEffYear	 = hh.KPIEffYear 
AND mm.KPIEffMth	 = hh.KPIEffMth
AND mm.EffectiveAsOfDate = hh.EffectiveAsOfDate
LEFT JOIN (
	SELECT tmp.EffectiveAsOfDate, tmp.KPIEffYear, tmp.KPIEffMth, tmp.AttribNPI
		,tmp.KPIValue 
	FROM [adw].[FctMEKPIByNPI] tmp
	WHERE tmp.KPI_ID = 308
	) lt
ON	mm.AttribNPI	 = lt.AttribNPI
AND mm.KPIEffYear	 = lt.KPIEffYear 
AND mm.KPIEffMth	 = lt.KPIEffMth
AND mm.EffectiveAsOfDate = lt.EffectiveAsOfDate
LEFT JOIN (
	SELECT tmp.EffectiveAsOfDate, tmp.KPIEffYear, tmp.KPIEffMth, tmp.AttribNPI
		,tmp.KPIValue 
	FROM [adw].[FctMEKPIByNPI] tmp
	WHERE tmp.KPI_ID = 309
	) ir
ON	mm.AttribNPI	 = ir.AttribNPI
AND mm.KPIEffYear	 = ir.KPIEffYear 
AND mm.KPIEffMth	 = ir.KPIEffMth
AND mm.EffectiveAsOfDate = ir.EffectiveAsOfDate
LEFT JOIN (
	SELECT tmp.EffectiveAsOfDate, tmp.KPIEffYear, tmp.KPIEffMth, tmp.AttribNPI
		,tmp.KPIValue 
	FROM [adw].[FctMEKPIByNPI] tmp
	WHERE tmp.KPI_ID = 302
	) sa
ON	mm.AttribNPI	 = sa.AttribNPI
AND mm.KPIEffYear	 = sa.KPIEffYear 
AND mm.KPIEffMth	 = sa.KPIEffMth
AND mm.EffectiveAsOfDate = sa.EffectiveAsOfDate
LEFT JOIN (
	SELECT tmp.EffectiveAsOfDate, tmp.KPIEffYear, tmp.KPIEffMth, tmp.AttribNPI
		,tmp.KPIValue 
	FROM [adw].[FctMEKPIByNPI] tmp
	WHERE tmp.KPI_ID = 303
	) sd
ON	mm.AttribNPI	 = sd.AttribNPI
AND mm.KPIEffYear	 = sd.KPIEffYear 
AND mm.KPIEffMth	 = sd.KPIEffMth
AND mm.EffectiveAsOfDate = sd.EffectiveAsOfDate
LEFT JOIN (
	SELECT tmp.EffectiveAsOfDate, tmp.KPIEffYear, tmp.KPIEffMth, tmp.AttribNPI
		,tmp.KPIValue 
	FROM [adw].[FctMEKPIByNPI] tmp
	WHERE tmp.KPI_ID = 400
	) awv
ON	mm.AttribNPI	= awv.AttribNPI
AND mm.KPIEffYear	= awv.KPIEffYear 
AND mm.KPIEffMth	= awv.KPIEffMth
AND mm.EffectiveAsOfDate = awv.EffectiveAsOfDate
LEFT JOIN (
	SELECT tmp.EffectiveAsOfDate, tmp.KPIEffYear, tmp.KPIEffMth, tmp.AttribNPI
		,tmp.KPIValue 
	FROM [adw].[FctMEKPIByNPI] tmp
	WHERE tmp.KPI_ID = 401
	) awvpcp
ON	mm.AttribNPI	 = awvpcp.AttribNPI
AND mm.KPIEffYear	 = awvpcp.KPIEffYear 
AND mm.KPIEffMth	 = awvpcp.KPIEffMth
AND mm.EffectiveAsOfDate = awvpcp.EffectiveAsOfDate
LEFT JOIN (
	SELECT tmp.EffectiveAsOfDate, tmp.KPIEffYear, tmp.KPIEffMth, tmp.AttribNPI
		,tmp.KPIValue 
	FROM [adw].[FctMEKPIByNPI] tmp
	WHERE tmp.KPI_ID = 601
	) tme
ON	mm.AttribNPI	 = tme.AttribNPI
AND mm.KPIEffYear	 = tme.KPIEffYear 
AND mm.KPIEffMth	 = tme.KPIEffMth
AND mm.EffectiveAsOfDate = tme.EffectiveAsOfDate
--
LEFT JOIN lst.LIST_PCP pcp
ON mm.AttribNPI = pcp.PCP_NPI
WHERE mm.KPI_ID = 109
AND mm.EffectiveAsOfDate = @EffectiveAsOfDate
AND mm.KPIEffYear = @KPIEffYear 
AND mm.KPIEffMth  =	@KPIEffMth
)

/***
Usage: 
SELECT *
FROM adw.[2020_tvf_Get_KPISumByNPIChapter] ('2020-06-15', 2020, 3)

SELECT Chapter, Sum(MbrMths) as MbrMths, Sum(Admits) as Admits
	FROM adw.[2020_tvf_Get_KPISumByNPIChapter] ('2020-06-15', 2020, 3)
GROUP BY Chapter

***/


