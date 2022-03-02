CREATE TABLE [dbo].[z_tmp_MbrKeyTbl] (
    [URN]             INT          IDENTITY (1, 1) NOT NULL,
    [SrcLoadDate]     DATE         NULL,
    [SrcTblKey]       INT          NULL,
    [ClientMemberKey] VARCHAR (50) NULL,
    [AttribNPI]       VARCHAR (50) NULL,
    [AttribTIN]       VARCHAR (50) NULL,
    [MbrPlan]         VARCHAR (50) NULL,
    [PlanTblKey]      INT          NULL,
    [RecStatus]       VARCHAR (1)  DEFAULT ('N') NULL,
    [RecLoadID]       VARCHAR (10) NULL,
    [RecUpdateID]     VARCHAR (10) NULL,
    [RecStatusDate]   DATE         DEFAULT (sysdatetime()) NULL,
    [CreateDate]      DATE         DEFAULT (sysdatetime()) NULL,
    [CreateBy]        VARCHAR (50) DEFAULT (suser_sname()) NULL
);

