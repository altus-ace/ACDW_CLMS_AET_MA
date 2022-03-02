CREATE TABLE [lst].[lstClinicalPrograms] (
    [CreatedDate]        DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedBy]          VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]    DATETIME      DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]      VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [DataDate]           DATE          NULL,
    [SrcFileName]        VARCHAR (50)  NULL,
    [lstAhsProgramsKey]  INT           IDENTITY (1, 1) NOT NULL,
    [ProgramName]        VARCHAR (100) NOT NULL,
    [ProgramDescription] VARCHAR (250) NOT NULL,
    [ProgramDesc_Short]  VARCHAR (100) NOT NULL,
    [ACTIVE]             CHAR (1)      DEFAULT ('Y') NULL,
    [EffectiveDate]      DATE          DEFAULT (getdate()) NULL,
    [ExpirationDate]     DATE          DEFAULT ('2099-12-31') NULL,
    PRIMARY KEY CLUSTERED ([lstAhsProgramsKey] ASC)
);

