


/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */

CREATE VIEW [dbo].[vw_Exp_AH_Membership]
AS

    /* version history:
    04/26/2020 - Created temp view for AHS initial export - RA
    10/19/2020: GK = Added support to use the RwEff/RwExp date to get the latest state of the membership, export active 0 and 1.
    01/28/2021: GK : added to BCBS catelog 
    02/25/2021: GK: PV ask to use the where mbr.SubgrpName <> 'COMM_Market is unknown' -- bcbs filter (these members do not have a valid plan)
	   to suppress the members with invalid plans from being sent to ahs
    */
	SELECT 
			m.[ClientMemberKey]
			,m.[Exp_CLIENT_ID]								
			,m.[Exp_MEDICAID_ID]					
			,m.[Exp_MEMBER_FIRST_NAME]				
			,m.[Exp_MEMBER_MI]						
			,m.[Exp_MEMBER_LAST_NAME]				
			,m.[Exp_DATE_OF_BIRTH]					
			,m.[Exp_MEMBER_GENDER]					
			,m.[Exp_HOME_ADDRESS]					
			,m.[Exp_HOME_CITY]						
			,m.[Exp_HOME_STATE]						
			,m.[Exp_HOME_ZIPCODE]					
			,m.[Exp_MAILING_ADDRESS]				
			,m.[Exp_MAILING_CITY]					
			,m.[Exp_MAILING_STATE]					
			,m.[Exp_MAILING_ZIP]					
			,m.[Exp_HOME_PHONE]						
			,m.[Exp_ADDITIONAL_PHONE]				
			,m.[Exp_CELL_PHONE]						
			,m.[Exp_Language]						
			,m.[Exp_Ethnicity]						
			,m.[Exp_Race]							
			,m.[Exp_Email]							
			,m.[Exp_MEDICARE_ID]					
			,m.[Exp_MEMBER_ORG_EFF_DATE]			
			,m.[Exp_MEMBER_CONT_EFF_DATE]			
			,m.[Exp_MEMBER_CUR_EFF_DATE]			
			,m.[Exp_MEMBER_CUR_TERM_DATE]			
			,m.[Exp_RESP_FIRST_NAME]				
			,m.[Exp_RESP_LAST_NAME]					
			,m.[Exp_RESP_RELATIONSHIP]				
			,m.[Exp_RESP_ADDRESS]					
			,m.[Exp_RESP_ADDRESS2]					
			,m.[Exp_RESP_CITY]						
			,m.[Exp_RESP_STATE]						
			,m.[Exp_RESP_ZIP]						
			,m.[Exp_RESP_PHONE]						
			,m.[Exp_PRIMARY_RISK_FACTOR]			
			,m.[Exp_COUNT_OPEN_CARE_OPPS]			
			,m.[Exp_INP_ADMITS_LAST_12_MOS]			
			,m.[Exp_LAST_INP_DISCHARGE]				
			,m.[Exp_POST_DISCHARGE_FUP_VISIT]		
			,m.[Exp_INP_FUP_WITHIN_7_DAYS]			
			,m.[Exp_ER_VISITS_LAST_12_MOS]			
			,m.[Exp_LAST_ER_VISIT]					
			,m.[Exp_POST_ER_FUP_VISIT]				
			,m.[Exp_ER_FUP_WITHIN_7_DAYS]			
			,m.[Exp_LAST_PCP_VISIT]					
			,m.[Exp_LAST_PCP_PRACTICE_SEEN]			
			,m.[Exp_LAST_BH_VISIT]					
			,m.[Exp_LAST_BH_PRACTICE_SEEN]			
			,m.[Exp_TOTAL_COSTS_LAST_12_MOS]		
			,m.[Exp_INP_COSTS_LAST_12_MOS]			
			,m.[Exp_ER_COSTS_LAST_12_MOS]			
			,m.[Exp_OUTP_COSTS_LAST_12_MOS]			
			,m.[Exp_PHARMACY_COSTS_LAST_12_MOS]		
			,m.[Exp_PRIMARY_CARE_COSTS_LAST_12_MOS]	
			,m.[Exp_BEHAVIORAL_COSTS_LAST_12_MOS]	
			,m.[Exp_OTHER_OFFICE_COSTS_LAST_12_MOS]	
			,m.[Exp_NEXT_PREVENTATIVE_VISIT_DUE]	
			,m.[Exp_ACE_ID]							
			,m.[Exp_carrier_Member_ID] 
		  , m.ClientKey
		  , m.AhsExpMembershipKey Skey    
	FROM [adw].[AhsExpMembership] m
	where m.exported	= 0;

