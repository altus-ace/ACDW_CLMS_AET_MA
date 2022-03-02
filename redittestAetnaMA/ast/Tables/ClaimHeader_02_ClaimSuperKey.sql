CREATE TABLE [ast].[ClaimHeader_02_ClaimSuperKey] (
    [clmSKey]                 VARCHAR (50)  NOT NULL,
    [PRVDR_OSCAR_NUM]         VARCHAR (50)  NULL,
    [BENE_EQTBL_BIC_HICN_NUM] VARCHAR (50)  NULL,
    [CLM_FROM_DT]             DATE          NULL,
    [CLM_THRU_DT]             DATE          NULL,
    [LoadDate]                DATE          NOT NULL,
    [CreatedDate]             DATETIME2 (7) CONSTRAINT [df_astPstCclfClmKeyLIst_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]               VARCHAR (20)  CONSTRAINT [df_astPstCclfClmKeyLIst_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([clmSKey] ASC)
);

