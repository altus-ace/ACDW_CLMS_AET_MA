CREATE TABLE [dbo].[z_tmp_LoadDates] (
    [URN]        INT          IDENTITY (1, 1) NOT NULL,
    [LoadDate]   DATE         NULL,
    [RecStatus]  VARCHAR (1)  DEFAULT ('N') NULL,
    [CreateDate] DATE         DEFAULT (sysdatetime()) NULL,
    [CreateBy]   VARCHAR (30) DEFAULT (suser_sname()) NULL
);

