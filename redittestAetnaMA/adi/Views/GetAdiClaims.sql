






CREATE VIEW [adi].[GetAdiClaims]
AS 
SELECT 
    --c.*   ,
    c.ps_unique_id	AS ps_unique_id_L1   ,
    c.customer_nbr	AS customer_nbr_L2   ,
    c.group_nbr	AS group_nbr_L3	    ,
    c.subgroup_nbr	AS subgroup_nbr_L5   ,
    c.account_nbr   AS account_nbr_L6    ,
    c.plan_id		AS PlanCode, ISNULL(pm.TargetValue,'') as AcePlanName,
    c.file_id		AS file_id_SrcSystem, fileid.CODE_DESC file_id_SrcSystemName,
    c.clm_ln_type_cd , ClmLnType.CODE_DESC ClmLnType,
    c.non_prfrrd_srv_cd_1, nonPrfrrdSrvCd1.CODE_DESC NonPrfrdSvcCd1,
    c.plsp_prod_cd, PlspProdCd.CODE_DESC PlspProdCode,
    c.product_ln_cd, ProductLnCd.CODE_DESC ProductLnCd, 
    c.classification_cd, ClassificationCd.CODE_DESC ClassificationCd,
    --c.bnft_pkg_id, all values = '0'0000
    c.non_prfrrd_srv_cd_2, nonPrfrrdSrvCd2.CODE_DESC NonPrfrdSvcCd2, 
    c.fund_ctg_cd,
    c.src_subscriber_id Subscriber_id,
    --c.emp_last_nm, c.emp_First_nm, c.emp_gender, c.SubScriber_brth_dt, c.subs_zip_cd, c.Sub_st_postal_cd ignore for MA
    --c.src_clm_mbr_id ignore for ma all are blank
    c.coverage_type_cd, CoverageTypeCd.CODE_DESC CoverageTypeCd,
    --c.ssn_nbr, -- masked
	c.member_id, 
    CASE WHEN (LEFT(c.member_id,6) = '000000') THEN Right(c.member_id, len(c.member_id)-6) 
	   WHEN (LEFT(c.member_id,2) = '00') THEN Right(c.member_id, len(c.member_id)-2) 
	   ELSE c.member_id END  AS SUBSCRIBER_ID_ClientMemberKey,
    --c.src_clm_mbr_id, c.src_clm_mbr_id_2, -- ignore as all are blank
    c.mem_last_nm, c.mem_first_nm, c.mem_gender,
    c.mbr_rtp_type_cd, mbrRtpTypeCd.CODE_DESC mbrRtpTypeCd,
    c.birth_dt AS MEMBER_DOB,
    c.src_clm_id SEQ_CLAIM_ID,
    c.src_claim_line_id_1 , 
    c.prev_clm_seg_id ReferrersToPreviousClaim, 
    --c.derived_tcn_nbr,   -- all null
    c.src_claim_line_id_2 ,
    --c.claim_line_id  'Aetna Expense Batch id' ,  ignore for now...
    --c.ntwk_srv_area_id,  -- service area id, not used by ACE
    --c.paid_prvdr_nsa_id, IGNORE it IS NOT RELEVANT TO ACE
    --c.srv_capacity_cd, srvCapacityCd.CODE_DESC, --ignore all values are ''
    c.tax_id_format_cd_1, c.tax_id_nbr_1, --c.print_nm_1, ignore doctor info
    c.tax_id_format_cd_2, c.tax_id_nbr_2, -- c.print_nm_2, c.srv_prvdr_id, c.address_line_1_txt, c. address_line_2_txt, c.city_nm, c.state_postal_cd, c.zip_cd,  ignore doctor info
    c.provider_type_cd, providerTypeCd.CODE_DESC providerTypeCd,
    c.specialty_cd,specialtyCd.CODE_DESC specialtyCd, 
    c.payee_cd, payeeCd.CODE_DESC payeeCd,
    c.paid_prvdr_par_cd, --paidPrvdrParCd.Code_Desc paidPrvdrParCd , no lookup values
    c.received_dt ReceivedDate,
    c.adjn_dt AdjudicatedDate,
    c.srv_start_dt	,
    c.srv_stop_dt	,
    c.paid_dt_or_adjn_dt,
    -- c.Filler11, c.Filler12, c.Filler13
    c.mdc_cd,mdcCd.CODE_DESC mdcCd,
    c.drg_cd, ISNULL(drgCd.CODE_DESC, '') drgCd  ,
    c.prcdr_cd, prcdrCd.CODE_DESC prcdrCd,
    c.prcdr_modifier_cd_1, ISNULL(PrcdrModCd1.CODE_DESC, '') PrcdrModCd1,
    c.prcdr_type_cd, prcdrTypeCd.CODE_DESC prcdrTypeCd ,
    --c.ICD10_Indicator ignore all are
    c.MED_COST_SUBCTG_CD, MedCostSubctgCd.CODE_DESC MedCostSubctgCd  ,
    c.prcdr_group_nbr, prcdrGroupNbr.CODE_DESC prcdrGroupNbr,
    c.type_srv_cd, typeSrvCd.CODE_DESC typeSrvCd,
    c.srv_benefit_cd, --srvBenefitCd.CODE_DESC srvBenefitCd,  doesn't have lookup
    --    c.tooth_1_nbr,  ignore we don't do dental
    c.plc_srv_cd, plcSrvCd.CODE_DESC plcSrvCd,
    c.dschrg_status_cd, isnull(dschrgStatusCd.CODE_DESC, '') dschrgStatusCd,
    c.revenue_cd, ISNULL(revenueCd.CODE_DESC, '') revenueCd,
    c.hcfa_bill_type_cd, ISNULL(hcfaBillTypeCd.CODE_DESC, '')  hcfaBillTypeCd,
    c.unit_cnt, 
    c.src_unit_cnt, 
    c.src_billed_amt, -- may have penny starting p0oint
    c.billed_amt, 
    c.not_covered_amt_1, 
    c.not_covered_amt_2, 
    c.not_covered_amt_3, 
    c.clm_ln_msg_cd_1, isNull(clmLnMsgCd1.CODE_DESC, '') clmLnMsgCd1,
    c.clm_ln_msg_cd_2, isNull(clmLnMsgCd2.CODE_DESC, '') clmLnMsgCd2,
    c.clm_ln_msg_cd_3, isNull(clmLnMsgCd3.CODE_DESC, '') clmLnMsgCd3,
    c.covered_amt, 
    c.allowed_amt, 
    -- c.Dummy,  dummy ha!
    c.srv_copay_amt, 
    c.src_srv_copay_amt, 
    c.deductible_amt, 
    c.coinsurance_amt, 
    c.src_coins_amt, 
    c.bnft_payable_amt, 
    c.paid_amt, 
    c.cob_paid_amt, 
    c.ahf_bfd_amt, 
    c.ahf_paid_amt, 
    c.negot_savings_amt, 
    c.r_c_savings_amt, 
    c.cob_savings_amt, 
    c.src_cob_svngs_amt, 
    c.pri_payer_cvg_cd,	   isnull(priPayerCvgCd.CODE_DESC,'') priPayerCvgCd,
    c.cob_type_cd,		   isnull(cobTypeCd.CODE_DESC,'') cobTypeCd ,
    c.cob_cd,			   isnull(cobCd.CODE_DESC,'') cobCd,
    RTRIM(LTRIM(c.prcdr_cd_ndc)) AS prcdr_cd_ndc 		,		   isnull(prcdrCdNdc.CODE_DESC,'') prcdrCdNdc ,
    c.src_clm_mbr_id_2, 
    c.clm_ln_status_cd,	   isNull(clmLnStatusCd.CODE_DESC,'') clmLnStatusCd,
    c.src_member_id,
    c.reversal_cd,		   isNull(reversalCd.CODE_DESC,'') reversalCd,
    c.admit_cnt, 
    c.admin_savings_amt, 
    c.adj_prvdr_dsgnn_cd,   isnull(adjPrvdrDsgnnCd.CODE_DESC,'')  adjPrvdrDsgnnCd,
    c.aex_plan_dsgntn_cd,   isnull(aexPlanDsgntnCd.CODE_DESC,'') aexPlanDsgntnCd, 
    c.benefit_tier_cd,	   isnull(benefitTierCd.CODE_DESC,'') benefitTierCd, 
    c.aex_prvdr_spctg_cd,   isnull(aexPrvdrSpctgCd.CODE_DESC,'') aexPrvdrSpctgCd,
    c.prod_distnctn_cd,	   isnull(prodDistnctnCd.CODE_DESC,'') prodDistnctnCd,
    c.billed_eligible_amt, 
    c.SPCLTY_CTG_CLS_CD,     ISNULL(SpcltyCtgClsCd.CODE_DESC,'') SpcltyCtgClsCd,
    --          c.FILLER_21, 
    --          c.FILLER_22, 
    --          c.FILLER_23, 
    c.pricing_mthd_cd,  isnull(pricingMthdCd.CODE_DESC,'')  pricingMthdCd ,
    c.type_class_cd,    isnull(typeClassCd.CODE_DESC,'') typeClassCd ,
    c.specialty_ctg_cd, isnull(specialtyCtgCd.CODE_DESC,'') specialtyCtgCd,specialtyCtgCd.LKUP_DESC SpecialtyCtgType, specialtyCtgCd.LKUP_VALUE specialtyCtgTypeCd,
    c.srv_prvdr_npi, 
    c.ttl_ded_met_ind, 
    c.ttl_interest_amt, 
    c.ttl_surcharge_amt, 
    c.SRV_SPCLTY_CTG_CD,    isNull(srvSpcltyCtgCd.CODE_DESC,'') srvSpcltyCtgCd,
    c.HCFA_PLC_SRV_CD,	    isNull(hcfaPlcSrvCd.CODE_DESC,'') hcfaPlcSrvCd,
    c.HCFA_ADMIT_SRC_CD,    isNull(hcfaAdmitSrcCd.CODE_DESC,'') hcfaAdmitSrcCd,
    c.HCFA_ADMIT_TYPE_CD,   isNull(hcfaAdmitType.CODE_DESC,'') hcfaAdmitType,
    c.SRC_ADMIT_DT, 
    c.SRC_DISCHARGE_DT, 
    c.prcdr_modifier_cd_2, ISNULL(PrcdrModCd2.CODE_DESC, '') PrcdrModCd2,
    c.prcdr_modifier_cd_3,  ISNULL(PrcdrModCd3.CODE_DESC, '') PrcdrModCd3,
    c.poa_cd_1, 
    c.poa_cd_2, 
    c.poa_cd_3, 
    c.poa_cd_4, 
    c.poa_cd_5, 
    c.poa_cd_6, 
    c.poa_cd_7, 
    c.poa_cd_8, 
    c.poa_cd_9, 
    c.poa_cd_10, 
    c.pri_icd9_dx_cd, 
    c.icd9_dx_cd_2, 
    c.icd9_dx_cd_3, 
    c.icd9_dx_cd_4, 
    c.icd9_dx_cd_5, 
    c.icd9_dx_cd_6, 
    c.icd9_dx_cd_7, 
    c.icd9_dx_cd_8, 
    c.icd9_dx_cd_9, 
    c.icd9_dx_cd_10, 
    c.icd9_prcdr_cd_1, 
    c.icd9_prcdr_cd_2, 
    c.icd9_prcdr_cd_3, 
    c.icd9_prcdr_cd_4, 
    c.icd9_prcdr_cd_5, 
    c.icd9_prcdr_cd_6, 
    c.ahf_det_order_cd,	   ISNULL(ahfDetOrderCd.CODE_DESC,'') ahfDetOrderCd ,
    c.ahf_mbr_coins_amt, 
    c.ahf_mbr_copay_amt, 
    c.ahf_mbr_ded_amt, 
    c.hcfa_admit_type_cd_2, ISNULL(hcfaAdmitType2.CODE_DESC,'') hcfaAdmitType2,
    -- c.FILLER_31, 
    c.ORG_CD,			   ISNULL(ordCd.CODE_DESC,'') ordCd ,
    -- c.EndMark,  not data
    c.DataDate, 
    c.FileDate    , 
    c.LoadDate, 
    c.CreatedDate, 
    c.CreatedBy, 
    c.LastUpdatedDate, 
    c.LastUpdatedBy, 
    c.OriginalFileName, 
    c.SrcFileName, 
    c.ClaimAetMAKey
FROM [adi].[ClaimAetMA] c       
    LEFT JOIN adi.AETNA_CODES FileId ON (CASE WHEN (LEFT (c.file_id, 1) = '0') THEN RIGHT(c.file_id, len(c.file_id) -1) ELSE c.file_id END) = fileid.CODE_VALUE and FileId.code = 'FILE_ID'
    LEFT JOIN adi.AETNA_CODES ClmLnType ON c.clm_ln_type_cd = ClmLnType.CODE_VALUE and ClmLnType.code = 'clm_ln_type_cd'
    LEFT JOIN adi.AETNA_CODES nonPrfrrdSrvCd1 ON c.non_prfrrd_srv_cd_1 = nonPrfrrdSrvCd1.CODE_VALUE and nonPrfrrdSrvCd1.code = 'non_prfrrd_srv_cd'
    LEFT JOIN adi.AETNA_CODES nonPrfrrdSrvCd2 ON c.non_prfrrd_srv_cd_2 = nonPrfrrdSrvCd2.CODE_VALUE and nonPrfrrdSrvCd2.code = 'non_prfrrd_srv_cd'
    LEFT JOIN adi.AETNA_CODES PlspProdCd ON (CASE WHEN (LEFT (c.plsp_prod_cd, 1) = '0') THEN RIGHT(c.plsp_prod_cd, len(c.Plsp_prod_cd) -1) ELSE c.Plsp_Prod_CD END)  = PlspProdCd.CODE_VALUE and PlspProdCd.code = 'plsp_prod_cd'
    LEFT JOIN adi.AETNA_CODES ProductLnCd ON c.product_ln_cd = ProductLnCd.CODE_VALUE and ProductLnCd.code = 'product_ln_cd'
    LEFT JOIN adi.AETNA_CODES ClassificationCd ON c.classification_cd = ClassificationCd.CODE_VALUE and ClassificationCd.code = 'classification_cd'    
    LEFT JOIN adi.AETNA_CODES CoverageTypeCd ON c.coverage_type_cd = CoverageTypeCd.CODE_VALUE and CoverageTypeCd.code = 'coverage_type_cd'    
    LEFT JOIN adi.AETNA_CODES mbrRtpTypeCd ON c.mbr_rtp_type_cd = mbrRtpTypeCd.CODE_VALUE and mbrRtpTypeCd.code = 'mbr_rtp_type_cd'        
    LEFT JOIN adi.AETNA_CODES srvCapacityCd ON c.srv_capacity_cd = srvCapacityCd.CODE_VALUE and srvCapacityCd.code = 'srv_capacity_cd'            
    LEFT JOIN adi.AETNA_CODES providerTypeCd ON c.provider_type_cd= providerTypeCd .CODE_VALUE and providerTypeCd .code = 'provider_type_cd'            
    LEFT JOIN adi.AETNA_CODES specialtyCd ON c.specialty_cd = specialtyCd.CODE_VALUE and specialtyCd.CODE = 'specialty_cd'
    LEFT JOIN adi.AETNA_CODES payeeCd ON c.payee_cd = payeeCd.CODE_VALUE and payeeCd.CODE = 'payee_cd'     
    --LEFT JOIN adi.AETNA_CODES paidPrvdrParCd ON c.paid_prvdr_par_cd = paidPrvdrParCd.CODE_VALUE and paidPrvdrParCd.CODE = 'paid_prvdr_par_cd'    
    LEFT JOIN adi.AETNA_CODES mdcCd ON (CASE WHEN (LEFT (c.mdc_cd, 1) = '0') THEN RIGHT(c.mdc_cd, len(c.mdc_cd) -1) ELSE c.mdc_cd END)  = mdcCd.CODE_VALUE and mdcCd.CODE = 'mdc_cd'     
    LEFT JOIN adi.AETNA_CODES drgCd ON c.drg_cd = drgCd .CODE_VALUE and drgCd .CODE = 'drg_cd'     
    LEFT JOIN adi.AETNA_CODES prcdrCd ON c.prcdr_cd = prcdrCd.CODE_VALUE and prcdrCd.CODE = 'prcdr_cd'     -- needs to be attached to the Proc Code list
    LEFT JOIN adi.AETNA_CODES PrcdrModCd1 ON c.prcdr_Modifier_cd_1 = PrcdrModCd1.CODE_VALUE and PrcdrModCd1.CODE = 'PRCDR_MODIFIER_CD'     
    LEFT JOIN adi.AETNA_CODES prcdrTypeCd ON c.prcdr_type_cd = prcdrTypeCd .CODE_VALUE and prcdrTypeCd .CODE = 'prcdr_type_cd'         
    LEFT JOIN adi.AETNA_CODES PrcdrModCd2 ON c.prcdr_Modifier_cd_2 = PrcdrModCd1.CODE_VALUE and PrcdrModCd2.CODE = 'PRCDR_MODIFIER_CD'     
    LEFT JOIN adi.AETNA_CODES MedCostSubctgCd ON (CASE WHEN (LEFT (c.MED_COST_SUBCTG_CD , 1) = '0') THEN RIGHT(c.MED_COST_SUBCTG_CD , len(c.MED_COST_SUBCTG_CD ) ) ELSE c.MED_COST_SUBCTG_CD  END)= MedCostSubctgCd .CODE_VALUE and MedCostSubctgCd .CODE = 'MED_COST_SUBCTG_CD'     
    LEFT JOIN adi.AETNA_CODES prcdrGroupNbr ON LTRIM(c.prcdr_group_nbr) = prcdrGroupNbr.CODE_VALUE and prcdrGroupNbr.CODE = 'PRCDR_GROUP_NBR'     
    LEFT JOIN adi.AETNA_CODES typeSrvCd ON (CASE WHEN (LEFT (c.type_srv_cd, 1) = '0') THEN RIGHT(c.type_srv_cd, len(c.type_srv_cd) -1) ELSE c.type_srv_cd END) = typeSrvCd.CODE_VALUE and typeSrvCd.CODE = 'type_srv_cd'     
    -- LEFT JOIN adi.AETNA_CODES srvBenefitCd ON c.srv_benefit_cd = srvBenefitCd.CODE_VALUE and srvBenefitCd.CODE = 'srv_benefit_cd'         no lookup values 
    LEFT JOIN adi.AETNA_CODES plcSrvCd ON c.plc_srv_cd = plcSrvCd.CODE_VALUE and plcSrvCd.CODE = 'plc_srv_cd'     
    LEFT JOIN adi.AETNA_CODES dschrgStatusCd ON (CASE WHEN (LEFT (c.dschrg_status_cd, 1) = '0') THEN RIGHT(c.dschrg_status_cd, len(c.dschrg_status_cd) -1) ELSE c.dschrg_status_cd END) = dschrgStatusCd.CODE_VALUE and dschrgStatusCd.CODE = 'dschrg_status_cd'     
    LEFT JOIN adi.AETNA_CODES revenueCd ON c.revenue_cd = revenueCd.CODE_VALUE and revenueCd.CODE = 'revenue_cd'     
    LEFT JOIN adi.AETNA_CODES hcfaBillTypeCd ON c.hcfa_bill_type_cd = hcfaBillTypeCd.CODE_VALUE and hcfaBillTypeCd.CODE = 'hcfa_bill_type_cd'     
    LEFT JOIN adi.AETNA_CODES clmLnMsgCd1 ON c.clm_ln_msg_cd_1 = clmLnMsgCd1.CODE_VALUE and clmLnMsgCd1.CODE = 'clm_ln_msg_cd'     
    LEFT JOIN adi.AETNA_CODES clmLnMsgCd2 ON c.clm_ln_msg_cd_2 = clmLnMsgCd2.CODE_VALUE and clmLnMsgCd2.CODE = 'clm_ln_msg_cd'     
    LEFT JOIN adi.AETNA_CODES clmLnMsgCd3 ON c.clm_ln_msg_cd_3 = clmLnMsgCd3.CODE_VALUE and clmLnMsgCd3.CODE = 'clm_ln_msg_cd'     
    LEFT JOIN adi.AETNA_CODES priPayerCvgCd ON c.pri_payer_cvg_cd = priPayerCvgCd.CODE_VALUE and priPayerCvgCd.CODE = 'pri_payer_cvg_cd'     
    LEFT JOIN adi.AETNA_CODES cobTypeCd ON c.cob_type_cd = cobTypeCd.CODE_VALUE and cobTypeCd.CODE = 'cob_type_cd'     
    LEFT JOIN adi.AETNA_CODES cobCd ON c.cob_cd = cobCd.CODE_VALUE and cobCd.CODE = 'cob_cd'     
    LEFT JOIN adi.AETNA_CODES prcdrCdNdc ON c.prcdr_cd_ndc = prcdrCdNdc.CODE_VALUE and prcdrCdNdc.CODE = 'prcdr_cd_ndc'     
    LEFT JOIN adi.AETNA_CODES clmLnStatusCd ON c.clm_ln_status_cd = clmLnStatusCd.CODE_VALUE and clmLnStatusCd.CODE = 'clm_ln_status_cd'     
    LEFT JOIN adi.AETNA_CODES reversalCd ON c.reversal_cd = reversalCd.CODE_VALUE and reversalCd.CODE = 'reversal_cd'     
    LEFT JOIN adi.AETNA_CODES adjPrvdrDsgnnCd ON c.adj_prvdr_dsgnn_cd = adjPrvdrDsgnnCd.CODE_VALUE and adjPrvdrDsgnnCd.CODE = 'adj_prvdr_dsgnn_cd'     
    LEFT JOIN adi.AETNA_CODES aexPlanDsgntnCd ON c.aex_plan_dsgntn_cd = aexPlanDsgntnCd.CODE_VALUE and aexPlanDsgntnCd.CODE = 'aex_plan_dsgntn_cd'     
    LEFT JOIN adi.AETNA_CODES benefitTierCd ON c.benefit_tier_cd = benefitTierCd.CODE_VALUE and benefitTierCd.CODE = 'benefit_tier_cd'     
    LEFT JOIN adi.AETNA_CODES aexPrvdrSpctgCd ON c.aex_prvdr_spctg_cd = aexPrvdrSpctgCd.CODE_VALUE and aexPrvdrSpctgCd.CODE = 'aex_prvdr_spctg_cd'     
    LEFT JOIN adi.AETNA_CODES prodDistnctnCd ON c.prod_distnctn_cd = prodDistnctnCd.CODE_VALUE and prodDistnctnCd.CODE = 'prod_distnctn_cd'     
    LEFT JOIN adi.AETNA_CODES SpcltyCtgClsCd ON c.SPCLTY_CTG_CLS_CD = SpcltyCtgClsCd.CODE_VALUE and SpcltyCtgClsCd.CODE = 'SPCLTY_CTG_CLS_CD'     
    LEFT JOIN adi.AETNA_CODES pricingMthdCd ON c.pricing_mthd_cd = pricingMthdCd.CODE_VALUE and pricingMthdCd.CODE = 'pricing_mthd_cd'     
    LEFT JOIN adi.AETNA_CODES typeClassCd ON c.type_class_cd = typeClassCd.CODE_VALUE and typeClassCd.CODE = 'type_class_cd'     
    LEFT JOIN adi.AETNA_CODES specialtyCtgCd ON c.specialty_ctg_cd = specialtyCtgCd.CODE_VALUE and specialtyCtgCd.CODE = 'specialty_ctg_cd'     
    LEFT JOIN adi.AETNA_CODES srvSpcltyCtgCd ON c.SRV_SPCLTY_CTG_CD = srvSpcltyCtgCd.CODE_VALUE and srvSpcltyCtgCd.CODE = 'SRV_SPCLTY_CTG_CD'     
    LEFT JOIN adi.AETNA_CODES hcfaPlcSrvCd ON c.HCFA_PLC_SRV_CD = hcfaPlcSrvCd.CODE_VALUE and hcfaPlcSrvCd.CODE = 'HCFA_PLC_SRV_CD'     
    LEFT JOIN adi.AETNA_CODES hcfaAdmitSrcCd ON c.HCFA_ADMIT_SRC_CD = hcfaAdmitSrcCd.CODE_VALUE and hcfaAdmitSrcCd.CODE = 'HCFA_ADMIT_SRC_CD'     
    LEFT JOIN adi.AETNA_CODES hcfaAdmitType ON c.HCFA_ADMIT_TYPE_CD = hcfaAdmitType.CODE_VALUE and hcfaAdmitType.CODE = 'HCFA_ADMIT_TYPE_CD'  
    LEFT JOIN adi.AETNA_CODES PrcdrModCd3 ON c.prcdr_Modifier_cd_3 = PrcdrModCd1.CODE_VALUE and PrcdrModCd3.CODE = 'PRCDR_MODIFIER_CD'     
    LEFT JOIN adi.AETNA_CODES ahfDetOrderCd ON c.ahf_det_order_cd = ahfDetOrderCd.CODE_VALUE and ahfDetOrderCd.CODE = 'ahf_det_order_cd'     
    LEFT JOIN adi.AETNA_CODES hcfaAdmitType2 ON c.HCFA_ADMIT_TYPE_CD = hcfaAdmitType2.CODE_VALUE and hcfaAdmitType2.CODE = 'HCFA_ADMIT_TYPE_CD'  
    LEFT JOIN adi.AETNA_CODES ordCd ON c.ORG_CD = ordCd.CODE_VALUE and ordCd.CODE = 'ORG_CD'     

    LEFT JOIN (SELECT *
	   FROM lst.lstPlanMapping p
	   WHERE p.ClientKey = 3		  
		  and p.TargetSystem = 'acdw') pm ON right(c.plan_id,2) = pm.SourceValue and c.loadDate between pm.EffectiveDate and pm.ExpirationDate
    and c.LoadDate = '2021-12-01'
