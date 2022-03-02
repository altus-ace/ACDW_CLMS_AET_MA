

CREATE PROCEDURE [amd].[sp_AceEtlAudit_Close](
      @audit_id int
    , @ActionStopTime DATETIME 
    , @SourceCount int = 0
    , @DestinationCount int = 0
    , @ErrorCount int = 0    
    , @JobStatus tinyInt = 2
	)
AS 
BEGIN

EXEC [AceMetaData].[amd].[sp_AceEtlAudit_Close] @audit_id, @ActionStopTime, @SourceCount, @DestinationCount,  @ErrorCount, @JobStatus    
--@AuditStatus, @JobType, @ClientKey, @JobName, @ActionStartTime, @InputSourceName, @DestinationName, @ErrorName
--SELECT @AuditID = @@IDENTITY;
 
END
--EXEC [AceMetaData].[amd].[sp_AceEtlAudit_Open]
--EXEC [AceMetaData].[amd].[sp_AceEtlAudit_Close]
--EXEC [AceMetaData].[amd].[sp_AceEtlAudit_sp_AceEtlAuditLogError]
