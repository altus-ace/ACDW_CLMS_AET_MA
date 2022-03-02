CREATE TABLE [ast].[DatesToProcess_AhsExpElig] (
    [Skey]            INT          IDENTITY (1, 1) NOT NULL,
    [ClientKey]       INT          NOT NULL,
    [LoadDate]        DATE         NOT NULL,
    [FirstDayOfMonth] DATE         NOT NULL,
    [LastDayOfMonth]  DATE         NOT NULL,
    [status_Load]     TINYINT      DEFAULT ((0)) NOT NULL,
    [status_CalcELig] TINYINT      DEFAULT ((0)) NOT NULL,
    [CreatedDate]     DATE         DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50) DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Skey] ASC)
);

