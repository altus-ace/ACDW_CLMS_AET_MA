


CREATE PROCEDURE [ast].[pstCopTransformStaging]
    @QMDATE DATE
    , @CLientKey INT
AS
    /* add transformations as they come up
    */
    ---CHECK THIS BEFORE YOU RUN THE NEXT TIME
	
	  BEGIN
	  /*Set QMMsrID to null where Measure exist but requirement says to ignore*/
	  --SELECT	QmMsrId,QmCntCat,astRowStatus
	  --FROM		ast.QM_ResultByMember_History qm
	  UPDATE  ACECAREDW.ast.QM_ResultByMember_History
	  SET QmMsrId = NULL 
	  WHERE		ClientKey = @ClientKey
	  AND	QMDate = @QMDate
	  AND	QmCntCat = 'UNK'
	  AND QmMsrId IS NOT NULL

	  END;

	  BEGIN

	  /*Will invalidate QMs with PCD (AETMA_MA_D,AETMA_MA_S,AETMA_MPM_A) less than the required PCD Values*/
	 -- SELECT DISTINCT QmMsrId,srcQMID,QmCntCat FROM	 ACECAREDW.ast.QM_ResultByMember_History
	  UPDATE ACECAREDW.ast.QM_ResultByMember_History
	  SET srcQMID = NULL 
	  WHERE	 QMDate = @QMDate
	  AND	 ClientKey = @ClientKey
	  AND QmMsrId IS NULL-- AND QmCntCat = 'UNK'
	  AND	srcQMID LIKE '%AET%'
	  AND	QmCntCat = 'UNK'
	  

	  END

	  /*this wont return what i want cos i nulled it out.
	  check to see when its not null out.
	  *//*
	  select QmCntCat,QmMsrId,srcQMID,MeasureID,Measure
	  from	ACECAREDW.ast.QM_ResultByMember_History a
	  join ACECAREDW.ast.vw_AetnaMaCareOpsUnpivotedFromAdi b
	  on  a.adiKey = b.skey
	  and a.QmMsrId = b.MeasureID
	  WHERE	 QMDate = '2021-10-15'
	  AND	 ClientKey = 3
	  --and QmCntCat = 'unk'*/

	  /*
	  this down here should take care of  /*When QMMsrID is Null and QMCNTCAT is set as Unk*/
	  in the PROCEDURE [ast].[pstCopValidateStaging]
	  
	  */