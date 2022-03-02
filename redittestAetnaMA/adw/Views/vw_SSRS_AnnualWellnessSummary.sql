

CREATE	VIEW		[adw].[vw_SSRS_AnnualWellnessSummary]
AS

SELECT				*,CASE WHEN RATE > Target THEN 0 ELSE CONVERT (DECIMAL(10,2),(Target - Rate)*MemberCount) END AS MembersToHitTarget
FROM				(
SELECT				a.AttribTIN																		AS	PracticeTIN
					,b.PCP_PRACTICE_TIN_NAME														AS	PracticeName
					,a.AttribNPI																	AS	NPI
					,b.PCP_FIRST_NAME + ' ' + PCP_LAST_NAME											AS	ProviderName
					,a.ProviderChapter																AS	Chapter
					,COUNT(a.ClientMemberKey)														AS	MemberCount
					,CASE WHEN CompliantStatus = 'Y' THEN (SELECT COUNT(DISTINCT ClientMemberKey) WHERE CompliantStatus = 'Y') END		AS	AWVCompliant
					,CASE WHEN CompliantStatus = 'N' THEN (SELECT COUNT(DISTINCT ClientMemberKey) WHERE CompliantStatus = 'N') END		AS	AWVNonCompliant
					,CONVERT 
						(
						FLOAT,COUNT
						(CASE WHEN CompliantStatus = 'Y' THEN 1 END))
						/COUNT(DISTINCT ClientMemberKey)					AS	RATE
					,0.70													AS	Target
					,a.EffectiveAsofDate
FROM				adw.vw_Dashboard_CY_AWV_Needed a
JOIN				lst.list_pcp b
ON					a.AttribNPI = b.PCP_NPI
GROUP BY			a.AttribTIN
					,b.PCP_PRACTICE_TIN_NAME							
					,a.AttribNPI										
					,b.PCP_FIRST_NAME + ' ' + PCP_LAST_NAME				
					,a.ProviderChapter
					,a.CompliantStatus
					,a.EffectiveAsofDate	
					)z	
