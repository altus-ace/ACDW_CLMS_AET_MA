

CREATE PROCEDURE [adw].[Load_Pdw_15_ClmsMemsCCLF8_V1]
AS 
    -- insert Claims.Members
    INSERT INTO adw.Claims_Member
           ([SUBSCRIBER_ID]
           ,[DOB]
           ,[MEMB_LAST_NAME]
           ,[MEMB_MIDDLE_INITIAL]
           ,[MEMB_FIRST_NAME]           
           ,Gender
           ,[MEMB_ZIP]           
		   
           )
    SELECT 
	   m.MedicareBeneficiaryID	as SUBSCRIBER_ID		    
	   ,m.BirthDTS			    as DOB				    
	   ,m.MiddleNM				as MEMB_LAST_NAME		    
	   ,m.LastNM				as MEMB_MIDDLE_INITIAL	    
	   ,m.FirstNM				as MEMB_FIRST_NAME	    
	   ,m.SexCD					as GENDER			    
	   ,m.ZipCD					as MEMB_ZIP			    
	   
    FROM adi.Steward_MSSPBeneficiaryDemographic m
