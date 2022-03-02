CREATE PROCEDURE ast.ProfileClaims_CreateStgDetails 
AS
BEGIN

    IF OBJECT_ID(N'ast.ProfileClaims_tgDetails') IS NOT NULL 
    BEGIN
       DROP TABLE ast.ProfileClaims_tgDetails;
    END;
 
    /** 0 Staging Table **/
    SELECT  TOP 100000
    	 ClaimAetMAKey
    	,LoadDate
    	,member_id
    	,[SUBSCRIBER_ID_ClientMemberKey] as ClientMemberKey		-- Match ClientMemberKey in fctMembership
    	--,src_member_id
    	,seq_claim_id
    	,srcClaimLineID1
    	,srcClaimLineID2
    	,ReferrersToPreviousClaim
    	,provider_type_cd
    	,specialty_cd
    	,srv_prvdr_npi
    	,spcltyCtgClsCd
    	,srv_start_dt
    	,srv_stop_dt
    	,src_admit_dt
    	,src_discharge_dt
    	,dschrg_status_cd
    	,drg_cd
    	,prcdr_cd
    	,med_cost_subctg_cd
    	,prcdr_group_nbr
    	,plc_srv_cd
    	,plcSrvCd
    	,hcfa_bill_type_cd
    	,paid_amt
    	,typeClassCd
    	,specialtyCtgCd
    	,specialtyCtgType
    	,hcfa_plc_srv_cd
    	,hcfaadmitsrccd
    	,hcfaadmittype
    	,revenueCd
    	,prcdr_cd_ndc
    	,pri_icd9_dx_cd
    	,'-' as	HLFlg
    	,'-' as	DLFlg
    	,'-' as	AFlg
    	,'-' as	BFlg
    	,'-' as	CFlg
    INTO ast.ProfileClaims_tgDetails
    FROM adi.vw_GetAdiClaims


    BEGIN
    /** 1 Assign HDFlg **/
    UPDATE ast.ProfileClaims_tgDetails
    	SET HLFlg = '1'
    	WHERE ClaimAetMAKey IN (
    		SELECT ClaimAetMAKey
    		FROM (
    			SELECT seq_claim_id, ClaimAetMAKey, row_number() over (partition by seq_claim_id, loadDate order by srcClaimLineID1, srcClaimLineID2 asc) as rn
    			FROM ast.ProfileClaims_tgDetails) m
    		WHERE rn = 1
    		)
    
    /** 2 Assign DLFlg **/
    UPDATE ast.ProfileClaims_tgDetails
    	SET DLFlg = '1'
    	WHERE ClaimAetMAKey IN (
    		SELECT ClaimAetMAKey
    		FROM (
    			SELECT seq_claim_id, ClaimAetMAKey, row_number() over (partition by seq_claim_id, loadDate order by srcClaimLineID1, srcClaimLineID2 asc) as rn
    			FROM ast.ProfileClaims_tgDetails) m
    		WHERE rn <> 1
    		)
    END
END
;
