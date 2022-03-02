
CREATE VIEW	[adw].[vw_SSRS_AWVWorklist]

AS

SELECT			a.AttribTIN										AS PracticeTin																				
				,b.PCP_PRACTICE_TIN_NAME						AS PracticeName
				,a.AttribNPI									AS NPI
				,b.PCP_LAST_NAME + ' ' + PCP_FIRST_NAME			AS ProviderName
				,a.ProviderChapter								AS Chapter
				,a.ClientMemberKey
				,a.LastName + ' ' + FirstName					AS MemberName
				,a.MemberCellPhone
				,a.MemberHomePhone
				,a.MemberHomeAddress
				,a.MemberHomeAddress1
				,a.MemberHomeCity
				,a.MemberHomeState
				,a.MemberHomeZip
				,a.MemberPhone
				,a.LstAWVDate
FROM			adw.vw_Dashboard_CY_AWV_Needed a
JOIN			lst.List_PCP b
ON				a.AttribNPI = b.PCP_NPI
WHERE			a.CompliantStatus = 'N'
AND				a.Expired = 'N'




