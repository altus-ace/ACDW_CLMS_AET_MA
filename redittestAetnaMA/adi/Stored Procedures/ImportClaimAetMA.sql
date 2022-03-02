-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportClaimAetMA](
    @OriginalFileName varchar(100) ,
	@SrcFileName varchar(100) ,
	@DataDate varchar(10),
	@FileDate varchar(10),
	--@LoadDate date NOT ,
	--CreatedDate date NOT ,
	@CreatedBy varchar(50),
	--LastUpdatedDate datetime NOT ,
	@LastUpdatedBy varchar(50),
	@ps_unique_id [varchar](50) NULL,
	@customer_nbr [varchar](50) NULL,
	@group_nbr [varchar](50) NULL,
	@idn_indicator [varchar](5) NULL,
	@subgroup_nbr [varchar](50) NULL,
	@account_nbr [varchar](50) NULL,
	@file_id [varchar](50) NULL,
	@clm_ln_type_cd [varchar](5) NULL,
	@non_prfrrd_srv_cd_1 [varchar](5) NULL,
	@plsp_prod_cd [varchar](5) NULL,
	@product_ln_cd [varchar](5) NULL,
	@classification_cd [varchar](5) NULL,
	@bnft_pkg_id [varchar](50) NULL,
	@plan_id [varchar](50) NULL,
	@non_prfrrd_srv_cd_2 [varchar](5) NULL,
	@fund_ctg_cd [varchar](5) NULL,
	@src_subscriber_id [varchar](50) NULL,
	@emp_last_nm [varchar](50) NULL,
	@emp_first_nm [varchar](50) NULL,
	@emp_gender [varchar](10) NULL,
	@subscriber_brth_dt [date] NULL,
	@subs_zip_cd [varchar](5) NULL,
	@subs_st_postal_cd [varchar](5) NULL,
	@coverage_type_cd [varchar](5) NULL,
	@ssn_nbr [varchar](20) NULL,
	@member_id [varchar](50) NULL,
	@src_clm_mbr_id [varchar](50) NULL,
	@mem_last_nm [varchar](50) NULL,
	@mem_first_nm [varchar](50) NULL,
	@mem_gender [varchar](10) NULL,
	@mbr_rtp_type_cd [varchar](5) NULL,
	@birth_dt [date] NULL,
	@src_clm_id [varchar](50) NULL,
	@src_claim_line_id_1 [varchar](5) NULL,
	@prev_clm_seg_id [varchar](5) NULL,
	@derived_tcn_nbr [varchar](50) NULL,
	@src_claim_line_id_2 [varchar](5) NULL,
	@claim_line_id [varchar](5) NULL,
	@ntwk_srv_area_id [varchar](50) NULL,
	@paid_prvdr_nsa_id [varchar](50) NULL,
	@srv_capacity_cd [varchar](50) NULL,
	@tax_id_format_cd_1 [varchar](5) NULL,
	@tax_id_nbr_1 [varchar](50) NULL,
	@print_nm_1 [varchar](50) NULL,
	@tax_id_format_cd_2 [varchar](5) NULL,
	@tax_id_nbr_2 [varchar](50) NULL,
	@srv_prvdr_id [varchar](50) NULL,
	@print_nm_2 [varchar](50) NULL,
	@address_line_1_txt [varchar](100) NULL,
	@address_line_2_txt [varchar](100),
	@city_nm [varchar](50) NULL,
	@state_postal_cd [varchar](10) NULL,
	@zip_cd [varchar](10) NULL,
	@provider_type_cd [varchar](10) NULL,
	@specialty_cd [varchar](10) NULL,
	@payee_cd [varchar](5) NULL,
	@paid_prvdr_par_cd [varchar](5) NULL,
	@received_dt [date] NULL,
	@adjn_dt [date] NULL,
	@srv_start_dt [date] NULL,
	@srv_stop_dt [date] NULL,
	@paid_dt_or_adjn_dt [date] NULL,
	@FILLER_11 [varchar](50) NULL,
	@FILLER_12 [varchar](50) NULL,
	@FILLER_13 [varchar](50) NULL,
	@mdc_cd [varchar](5) NULL,
	@drg_cd [varchar](5) NULL,
	@prcdr_cd [varchar](5) NULL,
	@prcdr_modifier_cd_1 [varchar](5) NULL,
	@prcdr_type_cd [varchar](5) NULL,
	@ICD10_Indicator [varchar](5) NULL,
	@MED_COST_SUBCTG_CD [varchar](5) NULL,
	@prcdr_group_nbr [varchar](50) NULL,
	@type_srv_cd [varchar](5) NULL,
	@srv_benefit_cd [varchar](5) NULL,
	@tooth_1_nbr [varchar](50) NULL,
	@plc_srv_cd [varchar](5) NULL,
	@dschrg_status_cd [varchar](5) NULL,
	@revenue_cd [varchar](5) NULL,
	@hcfa_bill_type_cd [varchar](5) NULL,
	@unit_cnt [varchar](5) NULL,
	@src_unit_cnt [varchar](5) NULL,
	@src_billed_amt [money] NULL,
	@billed_amt [money] NULL,
	@not_covered_amt_1 [money] NULL,
	@not_covered_amt_2 [money] NULL,
	@not_covered_amt_3 [money] NULL,
	@clm_ln_msg_cd_1 [varchar](5) NULL,
	@clm_ln_msg_cd_2 [varchar](5) NULL,
	@clm_ln_msg_cd_3 [varchar](5) NULL,
	@covered_amt [money] NULL,
	@allowed_amt [money] NULL,
	@Dummy [varchar](10) NULL,
	@srv_copay_amt [money] NULL,
	@src_srv_copay_amt [money] NULL,
	@deductible_amt [money] NULL,
	@coinsurance_amt [money] NULL,
	@src_coins_amt [money] NULL,
	@bnft_payable_amt [money] NULL,
	@paid_amt [money] NULL,
	@cob_paid_amt [money] NULL,
	@ahf_bfd_amt [money] NULL,
	@ahf_paid_amt [money] NULL,
	@negot_savings_amt [money] NULL,
	@r_c_savings_amt [money] NULL,
	@cob_savings_amt [money] NULL,
	@src_cob_svngs_amt [money] NULL,
	@pri_payer_cvg_cd [varchar](5) NULL,
	@cob_type_cd [varchar](5) NULL,
	@cob_cd [varchar](5) NULL,
	@prcdr_cd_ndc [varchar](50) NULL,
	@src_clm_mbr_id_2 [varchar](50) NULL,
	@clm_ln_status_cd [varchar](5) NULL,
	@src_member_id [varchar](50) NULL,
	@reversal_cd [varchar](5) NULL,
	@admit_cnt [varchar](5) NULL,
	@admin_savings_amt [money] NULL,
	@adj_prvdr_dsgnn_cd [varchar](5) NULL,
	@aex_plan_dsgntn_cd [varchar](5) NULL,
	@benefit_tier_cd [varchar](5) NULL,
	@aex_prvdr_spctg_cd [varchar](5) NULL,
	@prod_distnctn_cd [varchar](5) NULL,
	@billed_eligible_amt [money] NULL,
	@SPCLTY_CTG_CLS_CD [varchar](5) NULL,
	@poa_cd_1 [varchar](5) NULL,
	@poa_cd_2 [varchar](5) NULL,
	@poa_cd_3 [varchar](5) NULL,
	@FILLER_21 [varchar](50) NULL,
	@FILLER_22 [varchar](50) NULL,
	@FILLER_23 [varchar](50) NULL,
	@pricing_mthd_cd [varchar](5) NULL,
	@type_class_cd [varchar](5) NULL,
	@specialty_ctg_cd [varchar](5) NULL,
	@srv_prvdr_npi [varchar](50) NULL,
	@ttl_ded_met_ind [varchar](50) NULL,
	@ttl_interest_amt [money] NULL,
	@ttl_surcharge_amt [money] NULL,
	@SRV_SPCLTY_CTG_CD [varchar](5) NULL,
	@HCFA_PLC_SRV_CD [varchar](5) NULL,
	@HCFA_ADMIT_SRC_CD [varchar](5) NULL,
	@HCFA_ADMIT_TYPE_CD [varchar](5) NULL,
	@SRC_ADMIT_DT [date] NULL,
	@SRC_DISCHARGE_DT [date] NULL,
	@prcdr_modifier_cd_2 [varchar](50) NULL,
	@prcdr_modifier_cd_3 [varchar](50) NULL,
	@poa_cd_4 [varchar](5) NULL,
	@poa_cd_5 [varchar](5) NULL,
	@poa_cd_6 [varchar](5) NULL,
	@poa_cd_7 [varchar](5) NULL,
	@poa_cd_8 [varchar](5) NULL,
	@poa_cd_9 [varchar](5) NULL,
	@poa_cd_10 [varchar](5) NULL,
	@pri_icd9_dx_cd [varchar](5) NULL,
	@icd9_dx_cd_2 [varchar](5) NULL,
	@icd9_dx_cd_3 [varchar](5) NULL,
	@icd9_dx_cd_4 [varchar](5) NULL,
	@icd9_dx_cd_5 [varchar](5) NULL,
	@icd9_dx_cd_6 [varchar](5) NULL,
	@icd9_dx_cd_7 [varchar](5) NULL,
	@icd9_dx_cd_8 [varchar](5) NULL,
	@icd9_dx_cd_9 [varchar](5) NULL,
	@icd9_dx_cd_10 [varchar](5) NULL,
	@icd9_prcdr_cd_1 [varchar](5) NULL,
	@icd9_prcdr_cd_2 [varchar](5) NULL,
	@icd9_prcdr_cd_3 [varchar](5) NULL,
	@icd9_prcdr_cd_4 [varchar](5) NULL,
	@icd9_prcdr_cd_5 [varchar](5) NULL,
	@icd9_prcdr_cd_6 [varchar](5) NULL,
	@ahf_det_order_cd [varchar](5) NULL,
	@ahf_mbr_coins_amt [money] NULL,
	@ahf_mbr_copay_amt [money] NULL,
	@ahf_mbr_ded_amt [money] NULL,
	@hcfa_admit_type_cd_2 [varchar](5) NULL,
	@FILLER_31 [varchar](5) NULL,
	@ORG_CD varchar(100),
	@EndMark char(1) 
   
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 BEGIN
 INSERT INTO [adi].[ClaimAetMA]
   (
    [OriginalFileName] ,
	[SrcFileName] ,
	[LoadDate] ,
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate] ,
	[LastUpdatedBy] ,
	[ps_unique_id] ,
	[customer_nbr] ,
	[group_nbr] ,
	[idn_indicator] ,
	[subgroup_nbr] ,
	[account_nbr] ,
	[file_id] ,
	[clm_ln_type_cd] ,
	[non_prfrrd_srv_cd_1] ,
	[plsp_prod_cd] ,
	[product_ln_cd] ,
	[classification_cd] ,
	[bnft_pkg_id] ,
	[plan_id] ,
	[non_prfrrd_srv_cd_2] ,
	[fund_ctg_cd] ,
	[src_subscriber_id] ,
	[emp_last_nm] ,
	[emp_first_nm] ,
	[emp_gender] ,
	[subscriber_brth_dt] ,
	[subs_zip_cd] ,
	[subs_st_postal_cd] ,
	[coverage_type_cd] ,
	[ssn_nbr] ,
	[member_id] ,
	[src_clm_mbr_id] ,
	[mem_last_nm] ,
	[mem_first_nm] ,
	[mem_gender] ,
	[mbr_rtp_type_cd] ,
	[birth_dt] ,
	[src_clm_id] ,
	[src_claim_line_id_1] ,
	[prev_clm_seg_id] ,
	[derived_tcn_nbr] ,
	[src_claim_line_id_2] ,
	[claim_line_id] ,
	[ntwk_srv_area_id] ,
	[paid_prvdr_nsa_id] ,
	[srv_capacity_cd] ,
	[tax_id_format_cd_1] ,
	[tax_id_nbr_1] ,
	[print_nm_1] ,
	[tax_id_format_cd_2] ,
	[tax_id_nbr_2] ,
	[srv_prvdr_id] ,
	[print_nm_2] ,
	[address_line_1_txt] ,
	[address_line_2_txt] ,
	[city_nm] ,
	[state_postal_cd] ,
	[zip_cd] ,
	[provider_type_cd] ,
	[specialty_cd] ,
	[payee_cd] ,
	[paid_prvdr_par_cd] ,
	[received_dt] ,
	[adjn_dt] ,
	[srv_start_dt] ,
	[srv_stop_dt] ,
	[paid_dt_or_adjn_dt] ,
	[FILLER_11] ,
	[FILLER_12] ,
	[FILLER_13] ,
	[mdc_cd] ,
	[drg_cd] ,
	[prcdr_cd] ,
	[prcdr_modifier_cd_1] ,
	[prcdr_type_cd] ,
	[ICD10_Indicator] ,
	[MED_COST_SUBCTG_CD] ,
	[prcdr_group_nbr] ,
	[type_srv_cd] ,
	[srv_benefit_cd] ,
	[tooth_1_nbr] ,
	[plc_srv_cd] ,
	[dschrg_status_cd] ,
	[revenue_cd] ,
	[hcfa_bill_type_cd] ,
	[unit_cnt] ,
	[src_unit_cnt] ,
	[src_billed_amt] ,
	[billed_amt] ,
	[not_covered_amt_1] ,
	[not_covered_amt_2] ,
	[not_covered_amt_3] ,
	[clm_ln_msg_cd_1] ,
	[clm_ln_msg_cd_2] ,
	[clm_ln_msg_cd_3] ,
	[covered_amt] ,
	[allowed_amt] ,
	[Dummy] ,
	[srv_copay_amt] ,
	[src_srv_copay_amt] ,
	[deductible_amt] ,
	[coinsurance_amt] ,
	[src_coins_amt] ,
	[bnft_payable_amt] ,
	[paid_amt] ,
	[cob_paid_amt] ,
	[ahf_bfd_amt] ,
	[ahf_paid_amt] ,
	[negot_savings_amt] ,
	[r_c_savings_amt] ,
	[cob_savings_amt] ,
	[src_cob_svngs_amt] ,
	[pri_payer_cvg_cd] ,
	[cob_type_cd] ,
	[cob_cd] ,
	[prcdr_cd_ndc] ,
	[src_clm_mbr_id_2] ,
	[clm_ln_status_cd] ,
	[src_member_id] ,
	[reversal_cd] ,
	[admit_cnt] ,
	[admin_savings_amt] ,
	[adj_prvdr_dsgnn_cd] ,
	[aex_plan_dsgntn_cd] ,
	[benefit_tier_cd] ,
	[aex_prvdr_spctg_cd] ,
	[prod_distnctn_cd] ,
	[billed_eligible_amt] ,
	[SPCLTY_CTG_CLS_CD] ,
	[poa_cd_1] ,
	[poa_cd_2] ,
	[poa_cd_3] ,
	[FILLER_21] ,
	[FILLER_22] ,
	[FILLER_23] ,
	[pricing_mthd_cd] ,
	[type_class_cd] ,
	[specialty_ctg_cd] ,
	[srv_prvdr_npi] ,
	[ttl_ded_met_ind] ,
	[ttl_interest_amt] ,
	[ttl_surcharge_amt] ,
	[SRV_SPCLTY_CTG_CD] ,
	[HCFA_PLC_SRV_CD] ,
	[HCFA_ADMIT_SRC_CD] ,
	[HCFA_ADMIT_TYPE_CD] ,
	[SRC_ADMIT_DT] ,
	[SRC_DISCHARGE_DT] ,
	[prcdr_modifier_cd_2] ,
	[prcdr_modifier_cd_3] ,
	[poa_cd_4] ,
	[poa_cd_5] ,
	[poa_cd_6] ,
	[poa_cd_7] ,
	[poa_cd_8] ,
	[poa_cd_9] ,
	[poa_cd_10] ,
	[pri_icd9_dx_cd] ,
	[icd9_dx_cd_2] ,
	[icd9_dx_cd_3] ,
	[icd9_dx_cd_4] ,
	[icd9_dx_cd_5] ,
	[icd9_dx_cd_6] ,
	[icd9_dx_cd_7] ,
	[icd9_dx_cd_8] ,
	[icd9_dx_cd_9] ,
	[icd9_dx_cd_10] ,
	[icd9_prcdr_cd_1] ,
	[icd9_prcdr_cd_2] ,
	[icd9_prcdr_cd_3] ,
	[icd9_prcdr_cd_4] ,
	[icd9_prcdr_cd_5] ,
	[icd9_prcdr_cd_6] ,
	[ahf_det_order_cd] ,
	[ahf_mbr_coins_amt],
	[ahf_mbr_copay_amt] ,
	[ahf_mbr_ded_amt] ,
	[hcfa_admit_type_cd_2] ,
	[FILLER_31] ,
	[ORG_CD] ,
	[EndMark] ,
    [DataDate],
    [FileDate]
  )


     VALUES
   (
    @OriginalFileName  ,
	@SrcFileName  ,
    DATEADD(mm, DATEDIFF(mm,0, GETDATE()), 0),
	--@LoadDate date NOT ,
	GETDATE(),
	--CreatedDate date NOT ,
	@CreatedBy ,
	GETDATE(),
	--LastUpdatedDate datetime NOT ,
	@LastUpdatedBy ,
	@ps_unique_id ,
	@customer_nbr ,
	@group_nbr ,
	@idn_indicator ,
	@subgroup_nbr ,
	@account_nbr ,
	@file_id ,
	@clm_ln_type_cd ,
	@non_prfrrd_srv_cd_1 ,
	@plsp_prod_cd ,
	@product_ln_cd ,
	@classification_cd ,
	@bnft_pkg_id ,
	@plan_id ,
	@non_prfrrd_srv_cd_2 ,
	@fund_ctg_cd ,
	@src_subscriber_id ,
	@emp_last_nm ,
	@emp_first_nm ,
	@emp_gender ,
	CASE WHEN @subscriber_brth_dt = ''
	THEN NULL
	ELSE CONVERT(DATE, @subscriber_brth_dt)
	END,
	@subs_zip_cd ,
	@subs_st_postal_cd ,
	@coverage_type_cd ,
	@ssn_nbr ,
	@member_id ,
	@src_clm_mbr_id ,
	@mem_last_nm ,
	@mem_first_nm ,
	@mem_gender ,
	@mbr_rtp_type_cd ,
	@birth_dt ,
	@src_clm_id ,
	@src_claim_line_id_1 ,
	@prev_clm_seg_id ,
	@derived_tcn_nbr ,
	@src_claim_line_id_2 ,
	@claim_line_id ,
	@ntwk_srv_area_id ,
	@paid_prvdr_nsa_id ,
	@srv_capacity_cd ,
	@tax_id_format_cd_1 ,
	@tax_id_nbr_1 ,
	@print_nm_1 ,
	@tax_id_format_cd_2 ,
	@tax_id_nbr_2 ,
	@srv_prvdr_id ,
	@print_nm_2 ,
	@address_line_1_txt ,
	@address_line_2_txt ,
	@city_nm ,
	@state_postal_cd ,
	@zip_cd ,
	@provider_type_cd ,
	@specialty_cd ,
	@payee_cd ,
	@paid_prvdr_par_cd ,
	CASE WHEN @received_dt  = ''
	THEN NULL
	ELSE CONVERT(DATE, @received_dt)
	END,
	CASE WHEN @adjn_dt  = ''
	THEN NULL
	ELSE CONVERT(DATE, @adjn_dt)
	END,
	CASE WHEN @srv_start_dt  = ''
	THEN NULL
	ELSE CONVERT(DATE, @srv_start_dt)
	END, 
	CASE WHEN @srv_stop_dt  = ''
	THEN NULL
	ELSE CONVERT(DATE, @srv_stop_dt)
	END, 
	CASE WHEN @paid_dt_or_adjn_dt = ''
	THEN NULL
	ELSE CONVERT(DATE, @paid_dt_or_adjn_dt)
	END, 
	@FILLER_11 ,
	@FILLER_12 ,
	@FILLER_13 ,
	@mdc_cd ,
	@drg_cd ,
	@prcdr_cd ,
	@prcdr_modifier_cd_1 ,
	@prcdr_type_cd ,
	@ICD10_Indicator ,
	@MED_COST_SUBCTG_CD ,
	@prcdr_group_nbr ,
	@type_srv_cd ,
	@srv_benefit_cd ,
	@tooth_1_nbr ,
	@plc_srv_cd ,
	@dschrg_status_cd ,
	@revenue_cd ,
	@hcfa_bill_type_cd ,
	@unit_cnt ,
	@src_unit_cnt ,
	CASE WHEN @src_billed_amt  = ''
	THEN NULL
	ELSE CONVERT(money, @src_billed_amt )
	END, 
	CASE WHEN @billed_amt = ''
	THEN NULL
	ELSE CONVERT(money, @billed_amt)
	END, 
	CASE WHEN 	@not_covered_amt_1 = ''
	THEN NULL
	ELSE CONVERT(money, 	@not_covered_amt_1)
	END, 
	CASE WHEN 	@not_covered_amt_2 = ''
	THEN NULL
	ELSE CONVERT(money, 	@not_covered_amt_2)
	END, 
    CASE WHEN 	@not_covered_amt_3 = ''
	THEN NULL
	ELSE CONVERT(money, 	@not_covered_amt_3)
	END, 
	@clm_ln_msg_cd_1 ,
	@clm_ln_msg_cd_2 ,
	@clm_ln_msg_cd_3 ,
	CASE WHEN @covered_amt  = ''
	THEN NULL
	ELSE CONVERT(money,@covered_amt)
	END,
	CASE WHEN @allowed_amt  = ''
	THEN NULL
	ELSE CONVERT(money,@allowed_amt)
	END,
	@Dummy ,
	CASE WHEN @srv_copay_amt  = ''
	THEN NULL
	ELSE CONVERT(money,@srv_copay_amt )
	END,
	CASE WHEN @src_srv_copay_amt = ''
	THEN NULL
	ELSE CONVERT(money,@src_srv_copay_amt)
	END,
	 CASE WHEN 	@deductible_amt = ''
	THEN NULL
	ELSE CONVERT(money,	@deductible_amt)
	END,
    CASE WHEN @coinsurance_amt = ''
	THEN NULL
	ELSE CONVERT(money,	@coinsurance_amt)
	END,
	CASE WHEN @src_coins_amt  = ''
	THEN NULL
	ELSE CONVERT(money,	@src_coins_amt)
	END,
	CASE WHEN @bnft_payable_amt  = ''
	THEN NULL
	ELSE CONVERT(money,	@bnft_payable_amt)
	END,
	CASE WHEN @paid_amt   = ''
	THEN NULL
	ELSE CONVERT(money,	@paid_amt)
	END, 
	CASE WHEN 	@cob_paid_amt   = ''
	THEN NULL
	ELSE CONVERT(money,	@cob_paid_amt)
	END, 
	CASE WHEN @ahf_bfd_amt  = ''
	THEN NULL
	ELSE CONVERT(money,	@ahf_bfd_amt)
	END, 
	CASE WHEN @ahf_paid_amt   = ''
	THEN NULL
	ELSE CONVERT(money,	@ahf_paid_amt )
	END, 
	CASE WHEN @negot_savings_amt  = ''
	THEN NULL
	ELSE CONVERT(money,	@negot_savings_amt)
	END,   
	CASE WHEN @r_c_savings_amt  = ''
	THEN NULL
	ELSE CONVERT(money,	@r_c_savings_amt)
	END, 
	CASE WHEN	@cob_savings_amt = ''
	THEN NULL
	ELSE CONVERT(money,	@cob_savings_amt)
	END, 
	CASE WHEN @src_cob_svngs_amt = ''
	THEN NULL
	ELSE CONVERT(money,@src_cob_svngs_amt)
	END, 
	 
	@pri_payer_cvg_cd ,
	@cob_type_cd ,
	@cob_cd ,
	@prcdr_cd_ndc ,
	@src_clm_mbr_id_2 ,
	@clm_ln_status_cd ,
	@src_member_id ,
	@reversal_cd ,
	@admit_cnt ,
	CASE WHEN @admin_savings_amt = ''
	THEN NULL
	ELSE CONVERT(money, @admin_savings_amt)
	END, 
	@adj_prvdr_dsgnn_cd ,
	@aex_plan_dsgntn_cd ,
	@benefit_tier_cd ,
	@aex_prvdr_spctg_cd ,
	@prod_distnctn_cd ,
	CASE WHEN @billed_eligible_amt  = ''
	THEN NULL
	ELSE CONVERT(money, @billed_eligible_amt)
	END,
	
	@SPCLTY_CTG_CLS_CD ,
	@poa_cd_1 ,
	@poa_cd_2 ,
	@poa_cd_3 ,
	@FILLER_21 ,
	@FILLER_22 ,
	@FILLER_23 ,
	@pricing_mthd_cd ,
	@type_class_cd ,
	@specialty_ctg_cd ,
	@srv_prvdr_npi ,
	@ttl_ded_met_ind ,
	CASE WHEN @ttl_interest_amt  = ''
	THEN NULL
	ELSE CONVERT(money, @ttl_interest_amt )
	END,
	CASE WHEN @ttl_surcharge_amt  = ''
	THEN NULL
	ELSE CONVERT(money, @ttl_surcharge_amt )
	END,
	
	@SRV_SPCLTY_CTG_CD ,
	@HCFA_PLC_SRV_CD ,
	@HCFA_ADMIT_SRC_CD ,
	@HCFA_ADMIT_TYPE_CD ,
	@SRC_ADMIT_DT ,
	@SRC_DISCHARGE_DT ,
	@prcdr_modifier_cd_2 ,
	@prcdr_modifier_cd_3 ,
	@poa_cd_4 ,
	@poa_cd_5 ,
	@poa_cd_6 ,
	@poa_cd_7 ,
	@poa_cd_8 ,
	@poa_cd_9 ,
	@poa_cd_10 ,
	@pri_icd9_dx_cd ,
	@icd9_dx_cd_2 ,
	@icd9_dx_cd_3 ,
	@icd9_dx_cd_4 ,
	@icd9_dx_cd_5 ,
	@icd9_dx_cd_6 ,
	@icd9_dx_cd_7 ,
	@icd9_dx_cd_8 ,
	@icd9_dx_cd_9 ,
	@icd9_dx_cd_10 ,
	@icd9_prcdr_cd_1 ,
	@icd9_prcdr_cd_2 ,
	@icd9_prcdr_cd_3 ,
	@icd9_prcdr_cd_4 ,
	@icd9_prcdr_cd_5 ,
	@icd9_prcdr_cd_6 ,
	@ahf_det_order_cd ,
	CASE WHEN @ahf_mbr_coins_amt  = ''
	THEN NULL
	ELSE CONVERT(money, @ahf_mbr_coins_amt )
	END,
	CASE WHEN @ahf_mbr_copay_amt   = ''
	THEN NULL
	ELSE CONVERT(money, @ahf_mbr_copay_amt )
	END,	
	CASE WHEN @ahf_mbr_ded_amt   = ''
	THEN NULL
	ELSE CONVERT(money, @ahf_mbr_ded_amt )
	END,	
	@hcfa_admit_type_cd_2 ,
	@FILLER_31 ,
	@ORG_CD ,
	@EndMark ,
	CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate)
	END,
	CASE WHEN @FileDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @FileDate)
	END
   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, 'ACECARDW.adi.copUhcPcor', '';

END




