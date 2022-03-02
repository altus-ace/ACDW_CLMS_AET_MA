



CREATE PROCEDURE [ast].[stg_04_Validate_stg_Membership](@MbrShipDataDate DATE
														,@EffectiveDate DATE) 
														-- [ast].[stg_04_Validate_stg_Membership]'2021-09-16','2021-10-01'
AS

BEGIN
DECLARE @ClientKey INT = 3

	BEGIN
	/*Updating StgRowStatus MbrStg in staging*/

		UPDATE		ast.MbrStg2_MbrData
		SET			stgRowStatus = 'Exported'
		WHERE		stgRowStatus = 'VALID'
		AND			DataDate = @MbrShipDataDate

	END

	BEGIN
	/*Updating StgRowStatus MbrStgAddressPhone in staging*/

		UPDATE		[ast].[MbrStg2_PhoneAddEmail]
		SET			stgRowStatus = m.stgRowStatus 
		FROM		[ast].[MbrStg2_PhoneAddEmail] ad
		JOIN		(SELECT  MAX(DataDate) DataDate
							,AdiKey,stgRowStatus
					 FROM	ast.MbrStg2_MbrData
					 WHERE	ClientKey = @ClientKey
					 AND	DataDate = @MbrShipDataDate
					 GROUP BY AdiKey,stgRowStatus
									)m
		ON		   ad.AdiKey = m.AdiKey
		WHERE	   ad.DataDate = @MbrShipDataDate

	END


	/*Upload Failed Membership Table*/
	BEGIN
	EXEC [adw].[pdw_Load_FailedMembership]@EffectiveDate

	END

	
		
	--- Checking for Invalid Records
	SELECT		COUNT(*)RecCnt, stgRowStatus
	FROM		ast.MbrStg2_MbrData
	WHERE		DataDate = @MbrShipDataDate
	AND			EffectiveDate = @EffectiveDate
	GROUP BY	stgRowStatus


	--Checking for AceID>1
		SELECT	 COUNT(*) RecCnt, MstrMrnKey
    FROM	 ast.MbrStg2_MbrData
    WHERE	 DataDate =  @MbrShipDataDate 
	GROUP BY MstrMrnKey
	HAVING	 COUNT(*) >1


	END
