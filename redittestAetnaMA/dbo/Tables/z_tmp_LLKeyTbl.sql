CREATE TABLE [dbo].[z_tmp_LLKeyTbl] (
    [URN]           INT          IDENTITY (1, 1) NOT NULL,
    [SrcLoadDate]   DATE         NULL,
    [SrcTblKey]     INT          NULL,
    [PatientID]     VARCHAR (50) NULL,
    [ClaimID]       VARCHAR (50) NULL,
    [RecStatus]     VARCHAR (1)  DEFAULT ('N') NULL,
    [RecLoadID]     VARCHAR (10) NULL,
    [RecUpdateID]   VARCHAR (10) NULL,
    [RecStatusDate] DATE         DEFAULT (sysdatetime()) NULL,
    [CreateDate]    DATE         DEFAULT (sysdatetime()) NULL,
    [CreateBy]      VARCHAR (30) DEFAULT (suser_sname()) NULL
);

