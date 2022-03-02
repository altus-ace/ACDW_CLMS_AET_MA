CREATE TABLE [ast].[ClmsMappingWork] (
    [SEQ_CLAIM_ID]    VARCHAR (50) NOT NULL,
    [ClaimType]       VARCHAR (20) NULL,
    [BillType]        CHAR (10)    NULL,
    [Category_Of_Svc] VARCHAR (20) NULL,
    [Prov_type]       VARCHAR (15) NULL,
    [NewProvType]     CHAR (5)     NULL,
    [ClaimPartType]   CHAR (7)     NULL,
    [ClaimTYpeCode]   CHAR (5)     NULL,
    PRIMARY KEY CLUSTERED ([SEQ_CLAIM_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_clmsMappingWork_CatSvcProvTypeClmPart]
    ON [ast].[ClmsMappingWork]([Category_Of_Svc] ASC, [Prov_type] ASC, [ClaimPartType] ASC)
    INCLUDE([SEQ_CLAIM_ID], [ClaimType], [BillType], [NewProvType], [ClaimTYpeCode]);


GO
CREATE NONCLUSTERED INDEX [ndx_ClmsMappingWork_claimPartType]
    ON [ast].[ClmsMappingWork]([ClaimPartType] ASC)
    INCLUDE([SEQ_CLAIM_ID], [ClaimType], [BillType], [Category_Of_Svc], [Prov_type], [NewProvType], [ClaimTYpeCode]);

