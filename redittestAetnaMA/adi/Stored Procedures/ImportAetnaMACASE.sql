-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportAetnaMACASE](
 	@OriginalFileName varchar(100) ,
	@SrcFileName varchar(100)  ,
	--@LoadDate date NOT ,
	--@CreatedDate date NOT ,
	@CreatedBy varchar(50)  ,
	--@LastUpdatedDate datetime NOT ,
	@LastUpdatedBy varchar(50) ,
	@Last_Name varchar(50) ,
	@First_Name [varchar](50) ,
	@mem_dob varchar(10) ,
	@member_id [varchar](50) ,
	@mem_cumb_id [varchar](50) ,
	@card_id [varchar](50) ,
	@atr_begin [varchar](50) ,
	@atr_end [varchar](50) ,
	@attr_tax_id [varchar](50) ,
	@attr_prvdr_id [varchar](50) ,
	@attr_npi [varchar](20) ,
	@attr_prvdr_Name [varchar](50) ,
	@attr_spec_cd [varchar](10) ,
	@MED_CASE_START_DT varchar(10) ,
	@MED_CASE_STOP_DT varchar(10) ,
	@LOS_DAY_CNT INT ,
	@POS [varchar](50) ,
	@medical_case_id [varchar](50) ,
	@readm_indicator [varchar](50) ,
	@readm_case_id [varchar](50) ,
	@MED_CS_ADMIT_TY_CD [varchar](50) ,
	@transfer_flag [varchar](50) ,
	@transfer_id [varchar](50) ,
	@MED_CASE_PMNT_CD [varchar](50) ,
	@DSCHRG_STATUS_CD [varchar](50) ,
	@TOTAL_PD_DAY_CNT INT ,
	@TOTAL_PAID_AMT varchar(10) ,
	@ACU_FCLTY_PD_AMT varchar(10) ,
	@N_A_FCLTY_PD_AMT varchar(10) ,
	@Facility_Par [varchar](50) ,
	@Facility_id [varchar](50) ,
	@Facility_NPI [varchar](20) ,
	@Facilty_Name [varchar](50) ,
	@Facilty_Spec [varchar](50) ,
	@Mg_Spclst_id [varchar](50) ,
	@Mg_Spclst_NPI [varchar](20) ,
	@Mg_Spclst_Name [varchar](50) ,
	@Mg_Spclst_Spec [varchar](50) ,
	@ICD9_DX_CTG_CD [varchar](50) ,
	@ICD9_DX_GROUP_NBR [varchar](50) ,
	@icd9_dx_cd [varchar](50) ,
	@PRCDR_CTG_CD [varchar](50) ,
	@PRCDR_GROUP_NBR [varchar](50) ,
	@prcdr_cd [varchar](50) ,
	@mdc_cd [varchar](50) ,
	@DG_CD [varchar](50) ,
	@IDRG_CD [varchar](50) ,
	@DRG_CD [varchar](50) ,
	@Avoid_ER [varchar](50) ,
	@er_visits [varchar](50) ,
	@Impact_IP [varchar](50) ,
	@ip_visits [varchar](50) ,
	@MED_SURGICAL_CD [varchar](10) ,
	@observation_ind [varchar](10) ,
	@masking_indicator [varchar](50) 

   
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 BEGIN
 INSERT INTO [adi].[AetnaMA_CASE]
   (
      [OriginalFileName]
      ,[SrcFileName]
      ,[LoadDate]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[Last_Name]
      ,[First_Name]
      ,[mem_dob]
      ,[member_id]
      ,[mem_cumb_id]
      ,[card_id]
      ,[atr_begin]
      ,[atr_end]
      ,[attr_tax_id]
      ,[attr_prvdr_id]
      ,[attr_npi]
      ,[attr_prvdr_Name]
      ,[attr_spec_cd]
      ,[MED_CASE_START_DT]
      ,[MED_CASE_STOP_DT]
      ,[LOS_DAY_CNT]
      ,[POS]
      ,[medical_case_id]
      ,[readm_indicator]
      ,[readm_case_id]
      ,[MED_CS_ADMIT_TY_CD]
      ,[transfer_flag]
      ,[transfer_id]
      ,[MED_CASE_PMNT_CD]
      ,[DSCHRG_STATUS_CD]
      ,[TOTAL_PD_DAY_CNT]
      ,[TOTAL_PAID_AMT]
      ,[ACU_FCLTY_PD_AMT]
      ,[N_A_FCLTY_PD_AMT]
      ,[Facility_Par]
      ,[Facility_id]
      ,[Facility_NPI]
      ,[Facilty_Name]
      ,[Facilty_Spec]
      ,[Mg_Spclst_id]
      ,[Mg_Spclst_NPI]
      ,[Mg_Spclst_Name]
      ,[Mg_Spclst_Spec]
      ,[ICD9_DX_CTG_CD]
      ,[ICD9_DX_GROUP_NBR]
      ,[icd9_dx_cd]
      ,[PRCDR_CTG_CD]
      ,[PRCDR_GROUP_NBR]
      ,[prcdr_cd]
      ,[mdc_cd]
      ,[DG_CD]
      ,[IDRG_CD]
      ,[DRG_CD]
      ,[Avoid_ER]
      ,[er_visits]
      ,[Impact_IP]
      ,[ip_visits]
      ,[MED_SURGICAL_CD]
      ,[observation_ind]
      ,[masking_indicator]   
  )


     VALUES
   (
   @OriginalFileName ,
	@SrcFileName  ,
	GETDATE(),
	--@LoadDate date NOT ,
	GETDATE(),
	--@CreatedDate date NOT ,
	@CreatedBy   ,
	GETDATE(),
	--@LastUpdatedDate datetime NOT ,
	@LastUpdatedBy  ,
	@Last_Name  ,
	@First_Name  ,
	CASE WHEN @mem_dob =''
	THEN NULL
	ELSE CONVERT(DATE,@mem_dob)
	END,
	@member_id  ,
	@mem_cumb_id  ,
	@card_id  ,
	@atr_begin  ,
	@atr_end  ,
	@attr_tax_id  ,
	@attr_prvdr_id  ,
	@attr_npi  ,
	@attr_prvdr_Name  ,
	@attr_spec_cd  ,
	CASE WHEN @MED_CASE_START_DT =''
	THEN NULL
	ELSE CONVERT(DATE,@MED_CASE_START_DT)
	END,
	CASE WHEN @MED_CASE_STOP_DT =''
	THEN NULL
	ELSE CONVERT(DATE,@MED_CASE_START_DT)
	END,	  
	@LOS_DAY_CNT  ,
	@POS  ,
	@medical_case_id  ,
	@readm_indicator  ,
	@readm_case_id  ,
	@MED_CS_ADMIT_TY_CD  ,
	@transfer_flag  ,
	@transfer_id  ,
	@MED_CASE_PMNT_CD  ,
	@DSCHRG_STATUS_CD  ,
	@TOTAL_PD_DAY_CNT  ,
	CASE WHEN @TOTAL_PAID_AMT =''
	THEN NULL
	ELSE CONVERT(MONEY,@TOTAL_PAID_AMT)
	END,
    CASE WHEN @ACU_FCLTY_PD_AMT =''
	THEN NULL
	ELSE CONVERT(MONEY,@ACU_FCLTY_PD_AMT)
	END,	 
    CASE WHEN @N_A_FCLTY_PD_AMT =''
	THEN NULL
	ELSE CONVERT(MONEY,@N_A_FCLTY_PD_AMT)
	END,	  
	@Facility_Par  ,
	@Facility_id  ,
	@Facility_NPI  ,
	@Facilty_Name  ,
	@Facilty_Spec  ,
	@Mg_Spclst_id  ,
	@Mg_Spclst_NPI  ,
	@Mg_Spclst_Name  ,
	@Mg_Spclst_Spec  ,
	@ICD9_DX_CTG_CD  ,
	@ICD9_DX_GROUP_NBR  ,
	@icd9_dx_cd  ,
	@PRCDR_CTG_CD  ,
	@PRCDR_GROUP_NBR  ,
	@prcdr_cd  ,
	@mdc_cd  ,
	@DG_CD  ,
	@IDRG_CD  ,
	@DRG_CD  ,
	@Avoid_ER  ,
	@er_visits  ,
	@Impact_IP  ,
	@ip_visits  ,
	@MED_SURGICAL_CD  ,
	@observation_ind  ,
	@masking_indicator 
 )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, 'ACECARDW.adi.copUhcPcor', '';

END




