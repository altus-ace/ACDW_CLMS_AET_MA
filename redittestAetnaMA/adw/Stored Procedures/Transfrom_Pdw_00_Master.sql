/****** Object:  StoredProcedure [adw].[DataAdj_RevCodeLength]    Script Date: 10/26/2018 3:29:44 PM ******/
CREATE PROCEDURE [adw].[Transfrom_Pdw_00_Master]
AS

    /* these jobs need to be folded into the ETL to the model. */

    EXEC	 adw.Transfrom_Pdw_01_DiagDot ;
    EXEC	 adw.[DataAdj_DrgCode] ;
    EXEC	 adw.[DataAdj_RevCodeLength];
    --EXEC	  adw.DataAdj_SubscriberId;
	EXEC	adw.Transform_Pdw_11_HdrsAggPaidFromPartBDetail;
