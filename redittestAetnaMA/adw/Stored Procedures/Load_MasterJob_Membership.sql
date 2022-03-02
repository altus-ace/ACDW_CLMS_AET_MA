



CREATE PROCEDURE [adw].[Load_MasterJob_Membership](@DataDate DATE
												,@LoadType VARCHAR(1)
												,@ClientID INT
												,@EffectiveDate DATE
												,@EffectiveMonth VARCHAR(7)
												,@MbrShipDataDate DATE
												,@AsOfDate DATE
												,@LoadDate DATE
												--,@LoadDateFrmStg DATE
												,@RwExpirationDate DATE)

AS

	BEGIN

		EXECUTE [adi].[ValidateMemberShip]

	END


	BEGIN
		/*Process load into staging*/
		EXECUTE [ast].[stg_01_pls_ProcessMbrMemberLoadFrmStaging]
							@EffectiveDate
							,@LoadDate
							,@ClientID;
	
	END
	

	BEGIN

		EXECUTE [ast].[stg_02_Pts_ProcessMbrMemberTransformationInStaging]
						@MbrShipDataDate
						,@EffectiveDate;
	END
	
	BEGIN
		/*Process Members MRN and updating staging*/
		EXECUTE [ast].[stg_03_Pts_RunMpiForMbrMember];
	
	END
	
	
	BEGIN
		/*Process Load DIMs*/
		EXECUTE	[adw].[PdwMbr_01_LoadHistory]@DaTaDate,@LoadType,@ClientID;
		EXECUTE	[adw].[PdwMbr_02_LoadMember]@DaTaDate,@LoadType,@ClientID,@EffectiveDate;
		EXECUTE	[adw].[PdwMbr_03_LoadDemo]@DaTaDate,@ClientID;
		EXECUTE	[adw].[PdwMbr_04_LoadPhone]@DaTaDate,@ClientID;
		EXECUTE	[adw].[PdwMbr_05_LoadAddress]@DaTaDate,@ClientID;
		EXECUTE	[adw].[PdwMbr_06_LoadPcp]@DaTaDate,@ClientID;
		EXECUTE	[adw].[PdwMbr_08_LoadPlan]@DaTaDate,@ClientID;
		EXECUTE	[adw].[PdwMbr_09_LoadCSPlan]@DaTaDate,@ClientID;
		EXECUTE	[adw].[PdwMbr_11_LoadEmail] @DaTaDate,@ClientID;
	
	END
	
	BEGIN
			/*Validate and Load Failed MemberShip */
		EXECUTE [ast].[stg_04_Validate_stg_Membership]
					@MbrShipDataDate
					,@EffectiveDate;

	END

	BEGIN

			/*To processed immediately after Dim tables are loaded*/
	EXECUTE	[ast].[stg_05_PupdAllLineageRowsInAdiAndStg] @MbrShipDataDate
	END
	

	BEGIN
		
		/*Management SP to load FctMembership Table*/
		EXECUTE [adw].[p_Pdw_Master_ProcessFctMembership] @AsOfDate
														  ,@ClientID
														  ,@DataDate
														  ,@LoadDate
														  ,@RwExpirationDate

	END

	
	
	
	
