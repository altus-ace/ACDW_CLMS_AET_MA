CREATE TABLE [dbo].[tmp_LIST_TABLES_Validation] (
    [URN]              INT          IDENTITY (1, 1) NOT NULL,
    [TABLE_NAME]       VARCHAR (50) NULL,
    [ACTIVE]           VARCHAR (1)  NULL,
    [CHK_MetaData1]    VARCHAR (1)  NULL,
    [CHK_MetaData2]    VARCHAR (1)  NULL,
    [CHK_MetaData3]    VARCHAR (1)  NULL,
    [CHK_MetaData4]    VARCHAR (1)  NULL,
    [NumRecords]       INT          NULL,
    [LastUpdate]       DATE         NULL,
    [Tbl_LastModified] DATE         NULL
);

