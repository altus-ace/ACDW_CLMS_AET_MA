CREATE TABLE [ast].[bk_ClaimHeader_02_ClaimSuperKey] (
    [clmSKey]                 VARCHAR (50)  NOT NULL,
    [PRVDR_OSCAR_NUM]         VARCHAR (6)   NULL,
    [BENE_EQTBL_BIC_HICN_NUM] VARCHAR (22)  NULL,
    [CLM_FROM_DT]             DATE          NULL,
    [CLM_THRU_DT]             DATE          NULL,
    [LoadDate]                DATE          NOT NULL,
    [CreatedDate]             DATETIME2 (7) NOT NULL,
    [CreatedBy]               VARCHAR (20)  NOT NULL
);

