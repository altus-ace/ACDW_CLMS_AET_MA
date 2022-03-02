﻿CREATE TABLE [adi].[AetnaMA_CASE] (
    [ClaimMACaseKey]     INT           IDENTITY (1, 1) NOT NULL,
    [OriginalFileName]   VARCHAR (100) NOT NULL,
    [SrcFileName]        VARCHAR (100) NOT NULL,
    [LoadDate]           DATE          NOT NULL,
    [CreatedDate]        DATE          CONSTRAINT [DF_adiAetnaMA_CASE_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]          VARCHAR (50)  CONSTRAINT [DF_adiAetnaMA_CASE_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]    DATETIME      CONSTRAINT [DF_adiAetnaMA_CASE_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]      VARCHAR (50)  CONSTRAINT [DF_adiAetnaMA_CASE_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [Last_Name]          VARCHAR (50)  NULL,
    [First_Name]         VARCHAR (50)  NULL,
    [mem_dob]            DATE          NULL,
    [member_id]          VARCHAR (50)  NULL,
    [mem_cumb_id]        VARCHAR (50)  NULL,
    [card_id]            VARCHAR (50)  NULL,
    [atr_begin]          VARCHAR (50)  NULL,
    [atr_end]            VARCHAR (50)  NULL,
    [attr_tax_id]        VARCHAR (50)  NULL,
    [attr_prvdr_id]      VARCHAR (50)  NULL,
    [attr_npi]           VARCHAR (20)  NULL,
    [attr_prvdr_Name]    VARCHAR (50)  NULL,
    [attr_spec_cd]       VARCHAR (10)  NULL,
    [MED_CASE_START_DT]  DATE          NULL,
    [MED_CASE_STOP_DT]   DATE          NULL,
    [LOS_DAY_CNT]        INT           NULL,
    [POS]                VARCHAR (50)  NULL,
    [medical_case_id]    VARCHAR (50)  NULL,
    [readm_indicator]    VARCHAR (50)  NULL,
    [readm_case_id]      VARCHAR (50)  NULL,
    [MED_CS_ADMIT_TY_CD] VARCHAR (50)  NULL,
    [transfer_flag]      VARCHAR (50)  NULL,
    [transfer_id]        VARCHAR (50)  NULL,
    [MED_CASE_PMNT_CD]   VARCHAR (50)  NULL,
    [DSCHRG_STATUS_CD]   VARCHAR (50)  NULL,
    [TOTAL_PD_DAY_CNT]   INT           NULL,
    [TOTAL_PAID_AMT]     MONEY         NULL,
    [ACU_FCLTY_PD_AMT]   MONEY         NULL,
    [N_A_FCLTY_PD_AMT]   MONEY         NULL,
    [Facility_Par]       VARCHAR (50)  NULL,
    [Facility_id]        VARCHAR (50)  NULL,
    [Facility_NPI]       VARCHAR (20)  NULL,
    [Facilty_Name]       VARCHAR (50)  NULL,
    [Facilty_Spec]       VARCHAR (50)  NULL,
    [Mg_Spclst_id]       VARCHAR (50)  NULL,
    [Mg_Spclst_NPI]      VARCHAR (20)  NULL,
    [Mg_Spclst_Name]     VARCHAR (50)  NULL,
    [Mg_Spclst_Spec]     VARCHAR (50)  NULL,
    [ICD9_DX_CTG_CD]     VARCHAR (50)  NULL,
    [ICD9_DX_GROUP_NBR]  VARCHAR (50)  NULL,
    [icd9_dx_cd]         VARCHAR (50)  NULL,
    [PRCDR_CTG_CD]       VARCHAR (50)  NULL,
    [PRCDR_GROUP_NBR]    VARCHAR (50)  NULL,
    [prcdr_cd]           VARCHAR (50)  NULL,
    [mdc_cd]             VARCHAR (50)  NULL,
    [DG_CD]              VARCHAR (50)  NULL,
    [IDRG_CD]            VARCHAR (50)  NULL,
    [DRG_CD]             VARCHAR (50)  NULL,
    [Avoid_ER]           VARCHAR (50)  NULL,
    [er_visits]          VARCHAR (50)  NULL,
    [Impact_IP]          VARCHAR (50)  NULL,
    [ip_visits]          VARCHAR (50)  NULL,
    [MED_SURGICAL_CD]    VARCHAR (10)  NULL,
    [observation_ind]    VARCHAR (10)  NULL,
    [masking_indicator]  VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([ClaimMACaseKey] ASC)
);

