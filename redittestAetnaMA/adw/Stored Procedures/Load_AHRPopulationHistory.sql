

CREATE PROCEDURE [adw].[Load_AHRPopulationHistory]
	(
	@ClientKeyID	VARCHAR(2),
	@RunDate		DATE
	)
AS    
BEGIN
    SET NOCOUNT ON;

INSERT INTO [adw].[AHR_Population_History]
           (
           [SrcFileName]
           ,[AdiTableName]
		   ,[AdiKey]
           ,[LoadDate]
           ,[DataDate]
           ,[ClientKey]
		   ,[ACE_ID]
           ,[ClientMemberKey]
			  ,[HICN]
			  ,[MBI]
           ,[EffectiveAsOfDate]
           ,[FirstName]
           ,[LastName]
           ,[Sex]
           ,[DOB]
           --,[CurrentRS]
           --,[CurrentDisplayGaps]
           --,[CurrentGaps]
           ,[Age]
           ,[TIN]
           ,[TIN_NAME]
           ,[NPI]
           ,[NPI_NAME]
		   ,[PRIM_SPECIALTY]
           ,[RUN_DATE]
           ,[RUN_YEAR]
           ,[RUN_MTH]
           ,[ToSend]
           ,[SentDate])
	SELECT 
			'[dbo].[tmp_AHR_HL7_Population]'
			,'[dbo].[tmp_AHR_HL7_Population]'
			,p.ID
			,GETDATE()
			,p.LOADDATE					AS DataDate
			,@ClientKeyID							
			,p.[ACE_ID]							
			,p.[SUBSCRIBER_ID]
			,p.[SUBSCRIBER_ID]
			,p.[SUBSCRIBER_ID]
			,@RunDate
			,p.[FIRSTNAME]						
			,p.[LASTNAME]					
			,p.[GENDER]	
			,p.[DOB]
			--,0						AS [CurrentRS]
			--,0						AS [CurrentDisplayGaps]
			--,0						AS [CurrentGaps]
			,DATEDIFF(yy,p.DOB, getdate())			AS [Age]
			,p.AttribTIN
			,pcp.[PCP_PRACTICE_TIN_NAME]
			,p.AttribNPI
			,CONCAT(pcp.[PCP_FIRST_NAME],' ',pcp.PCP_LAST_NAME)
			,PCP.PRIM_SPECIALTY						AS [PRIM_SPECIALTY]
			,@RunDate
			,DATEPART(yy, @RunDate) AS [RUN_YEAR]
			,DATEPART(mm, @RunDate) AS [RUN_MTH]
			,'Y'					AS [ToSend]
			,GETDATE()				AS [SentDate]						
	FROM [dbo].[tmp_AHR_HL7_Population] p
	LEFT JOIN lst.List_PCP pcp
		ON p.AttribNPI = pcp.PCP_NPI
END;												

/***
EXEC [adw].[Load_AHRPopulationHistory] 16,'10-30-2020'

SELECT *
FROM [adw].[AHR_Population_History]
***/
