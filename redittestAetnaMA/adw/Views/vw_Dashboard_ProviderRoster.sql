




CREATE VIEW [adw].[vw_Dashboard_ProviderRoster]
AS 
    -- Purpose: creates a Persiste
    SELECT 
	[fctProviderRosterSkey]
      ,[SourceJobName]
      ,[LoadDate]
      ,[DataDate]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[IsActive]
      ,[RowEffectiveDate]
      ,[RowExpirationDate]
      ,[ClientKey]
      ,[LOB]
      ,[ClientProviderID]
      ,[NPI]
      ,[LastName]
      ,[FirstName]
      ,[Degree]
      ,[TIN]
      ,[PrimarySpeciality]
      ,[Sub_Speciality]
      ,[GroupName]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[PrimaryAddress]
      ,[PrimaryCity]
      ,[PrimaryState]
      ,[PrimaryZipcode]
      ,[PrimaryPOD]
      ,[PrimaryQuadrant]
      ,[PrimaryAddressPhoneNum]
      ,[BillingAddress]
      ,[BillingCity]
      ,[BillingState]
      ,[BillingZipcode]
      ,[BillingPOD]
      ,[BillingAddressPhoneNum]
      ,[Comments]
      ,[HealthPlan]
      ,[AccountType]
      ,[NetworkContact]
      ,[Chapter]
FROM [ACDW_CLMS_SHCN_MSSP].[adw].[fctProviderRoster]
WHERE RowEffectiveDate = (select max(RowEffectiveDate) from  [adw].[fctProviderRoster]);


