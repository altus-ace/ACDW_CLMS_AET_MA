CREATE TABLE [dbo].[x_AnalyzeTableOutput] (
    [URN]           INT          IDENTITY (1, 1) NOT NULL,
    [BatchID]       VARCHAR (40) DEFAULT (format(getdate(),'yyyyMMdd-hhmm')) NULL,
    [TableName]     VARCHAR (55) NULL,
    [ColName]       VARCHAR (55) NULL,
    [DistinctValue] VARCHAR (55) NULL,
    [ValueCnt]      INT          NULL,
    [CreatedDate]   DATETIME     DEFAULT (getdate()) NULL,
    [CreatedBy]     VARCHAR (55) DEFAULT ('dbo.x_sp_GetTableColumns') NULL
);

