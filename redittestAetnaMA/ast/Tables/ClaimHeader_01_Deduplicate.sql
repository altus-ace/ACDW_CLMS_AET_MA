CREATE TABLE [ast].[ClaimHeader_01_Deduplicate] (
    [SrcAdiKey]        INT           NOT NULL,
    [SeqClaimId]       VARCHAR (50)  NOT NULL,
    [OriginalFileName] VARCHAR (100) NOT NULL,
    [LoadDate]         DATE          NOT NULL,
    [CreatedDate]      DATETIME2 (7) CONSTRAINT [df_astPstCclf1_DeDupClmsHdr_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]        VARCHAR (20)  CONSTRAINT [df_astPstCclf1_DeDupClmsHdr_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([SrcAdiKey] ASC)
);

