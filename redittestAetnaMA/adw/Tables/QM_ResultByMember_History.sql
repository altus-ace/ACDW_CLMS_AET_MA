CREATE TABLE [adw].[QM_ResultByMember_History] (
    [QM_ResultByMbr_HistoryKey] INT           IDENTITY (1, 1) NOT NULL,
    [ClientKey]                 INT           NOT NULL,
    [ClientMemberKey]           VARCHAR (50)  NOT NULL,
    [QmMsrId]                   VARCHAR (100) NULL,
    [QmCntCat]                  VARCHAR (10)  NOT NULL,
    [QMDate]                    DATE          CONSTRAINT [DF_QM_ResultByMbr_History_QmDate] DEFAULT (CONVERT([date],getdate())) NULL,
    [CreateDate]                DATETIME      CONSTRAINT [DF_QM_ResultByMbr_History_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreateBy]                  VARCHAR (50)  CONSTRAINT [DF_QM_ResultByMbr_History_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]           DATETIME      CONSTRAINT [df_AdwQM_ResultByMember_History_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]             VARCHAR (50)  CONSTRAINT [df_AdwQM_ResultByMember_History_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [AdiKey]                    INT           NULL,
    [adiTableName]              VARCHAR (100) NULL,
    [Addressed]                 INT           NULL,
    [QmMeasYear]                CHAR (4)      DEFAULT ('1900') NULL,
    [QMMbrEffectiveDate]        DATE          DEFAULT ('1900-01-01') NULL,
    PRIMARY KEY CLUSTERED ([QM_ResultByMbr_HistoryKey] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Skey', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'QM_ResultByMember_History', @level2type = N'COLUMN', @level2name = N'QM_ResultByMbr_HistoryKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK: Client', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'QM_ResultByMember_History', @level2type = N'COLUMN', @level2name = N'ClientKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Client Member Key', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'QM_ResultByMember_History', @level2type = N'COLUMN', @level2name = N'ClientMemberKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID of Care OP/Measure', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'QM_ResultByMember_History', @level2type = N'COLUMN', @level2name = N'QmMsrId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'DEN: In Denom, Num: in Numerator, COP: is care op', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'QM_ResultByMember_History', @level2type = N'COLUMN', @level2name = N'QmCntCat';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date QM Is effective for', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'QM_ResultByMember_History', @level2type = N'COLUMN', @level2name = N'QMDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Adi Source Row Primary Key value', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'QM_ResultByMember_History', @level2type = N'COLUMN', @level2name = N'AdiKey';

