CREATE TABLE [ast].[bk_ClaimHeader_01_Deduplicate] (
    [SrcAdiKey]        INT           NOT NULL,
    [SeqClaimId]       VARCHAR (50)  NOT NULL,
    [OriginalFileName] VARCHAR (100) NOT NULL,
    [LoadDate]         DATE          NOT NULL,
    [CreatedDate]      DATETIME2 (7) NOT NULL,
    [CreatedBy]        VARCHAR (20)  NOT NULL
);

