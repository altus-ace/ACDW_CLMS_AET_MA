
CREATE VIEW		[adw].[vw_SSRS_TrendsRptByTIN]

AS

SELECT			a.AttribTIN										AS	PracticeTIN
				,b.PCP_PRACTICE_TIN_NAME						AS  PracticeName
				,a.AttribNPI									AS	NPI
				,b.PCP_LAST_NAME + ' ' + PCP_FIRST_NAME			AS	ProviderName
				,a.ProviderChapter								AS	Chapter
				,COUNT(DISTINCT a.ClientMemberKey)				AS	MemberCountCompliant
				,YEAR(a.LstAWVDate)								AS	PrimarySVCDate_Year
				,MONTH(a.LstAWVDate)							AS	PrimarySVCDate_Month
FROM			adw.vw_Dashboard_CY_AWV_Needed a
JOIN			lst.List_PCP b
ON				a.AttribNPI = b.PCP_NPI
GROUP BY		a.AttribTIN,b.PCP_PRACTICE_TIN_NAME
				,b.PCP_LAST_NAME + ' ' + PCP_FIRST_NAME
				,a.ProviderChapter
				,YEAR(a.LstAWVDate)
				,MONTH(a.LstAWVDate)
				,a.AttribNPI			



