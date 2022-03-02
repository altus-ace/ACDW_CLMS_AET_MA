
-- =============================================
-- Author:		Si Nguyen
-- Create date: 10/16/19
-- Description:	Get Activities by Member from Altruista
-- =============================================
CREATE FUNCTION [adw].[2020_tvf_Get_AHSActivitiesWkly]
	(	
		@StartDate			DATE,
		@EndDate			DATE
	)
RETURNS TABLE 
AS
RETURN 
(

SELECT ClientKey, DATEPART(ww,ActivityCreatedDate) as Wk
       ,DATEADD(dd, -(DATEPART(dw, ActivityCreatedDate)-1), ActivityCreatedDate) WkStart
       ,DATEADD(dd, 7-(DATEPART(dw, ActivityCreatedDate)), ActivityCreatedDate) WkEnd
       ,CareActivityTypeName
       ,count(*) as CntAct
FROM [ACDW_CLMS_SHCN_MSSP].[adw].[mbrActivities] 
WHERE ActivityCreatedDate BETWEEN @StartDate	AND @EndDate
	AND CareActivityTypeName IS NOT NULL
GROUP BY ClientKey, DATEPART(ww,ActivityCreatedDate)
       ,DATEADD(dd, -(DATEPART(dw, ActivityCreatedDate)-1), ActivityCreatedDate) 
       ,DATEADD(dd, 7-(DATEPART(dw, ActivityCreatedDate)), ActivityCreatedDate)
       ,CareActivityTypeName 
--ORDER BY DATEPART(ww,ActivityCreatedDate)
--       ,DATEADD(dd, -(DATEPART(dw, ActivityCreatedDate)-1), ActivityCreatedDate) 
--       ,DATEADD(dd, 7-(DATEPART(dw, ActivityCreatedDate)), ActivityCreatedDate)
--       ,CareActivityTypeName
)

/***
Usage:
SELECT * FROM [adw].[2020_tvf_Get_AHSActivitiesWkly] ('2020-06-01','2020-10-01')
ORDER BY ClientKey, Wk
***/



