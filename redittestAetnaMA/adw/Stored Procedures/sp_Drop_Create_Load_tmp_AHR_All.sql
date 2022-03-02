

CREATE PROCEDURE [adw].[sp_Drop_Create_Load_tmp_AHR_All]
	(
	@ClientKeyID	VARCHAR(2),
	@RunDate		DATE
	)
AS

BEGIN

EXEC [adw].[sp_Drop_Create_Load_tmp_AHR_HL7_Population] @ClientKeyID,@RunDate
WAITFOR DELAY '00:00:05'; 
EXEC [adw].[sp_Drop_Create_Load_tmp_AHR_HL7_Report_Header] @ClientKeyID,@RunDate
EXEC [adw].[sp_Drop_Create_Load_tmp_AHR_HL7_Report_Detail_IP]  @ClientKeyID,@RunDate
EXEC [adw].[sp_Drop_Create_Load_tmp_AHR_HL7_Report_Detail_ER]  @ClientKeyID,@RunDate
EXEC [adw].[sp_Drop_Create_Load_tmp_AHR_HL7_Report_Detail_Phy] @ClientKeyID,@RunDate
WAITFOR DELAY '00:00:10'; 
EXEC [adw].[sp_Drop_Create_Load_tmp_AHR_HL7_Report_Detail_Dx]  @ClientKeyID,@RunDate
WAITFOR DELAY '00:00:10'; 
EXEC [adw].[sp_Drop_Create_Load_tmp_AHR_HL7_Report_Detail_Rx]  @ClientKeyID,@RunDate
WAITFOR DELAY '00:00:05'; 
EXEC [adw].[LoadQmResultHistoryIntoQmResultCL]  @ClientKeyID,@RunDate
WAITFOR DELAY '00:00:05'; 
EXEC [adw].[sp_Drop_Create_Load_tmp_AHR_HL7_Report_Detail_CG]  @ClientKeyID,@RunDate

END

/***
EXEC [adw].[sp_Drop_Create_Load_tmp_AHR_All] 16,'04-15-2021'

SELECT DISTINCT SubscriberNo FROM [dbo].[tmp_AHR_HL7_Report_Header]
INTERSECT
SELECT DISTINCT Subscriber_ID FROM [dbo].[tmp_AHR_HL7_Report_Detail_CG]
INTERSECT
SELECT DISTINCT Subscriber_ID FROM [dbo].[tmp_AHR_HL7_Report_Detail_Dx]
INTERSECT
SELECT DISTINCT Subscriber_ID FROM [dbo].[tmp_AHR_HL7_Report_Detail_IP]
INTERSECT
SELECT DISTINCT Subscriber_ID FROM [dbo].[tmp_AHR_HL7_Report_Detail_ER]
INTERSECT
SELECT DISTINCT ClientMemberKey FROM [dbo].[tmp_AHR_HL7_Report_Detail_Phy]
INTERSECT
SELECT DISTINCT Subscriber_ID FROM [dbo].[tmp_AHR_HL7_Report_Detail_Rx]
--INTERSECT
--SELECT DISTINCT ClientMemberKey FROM [adw].[FctAWVVisits]

***/
