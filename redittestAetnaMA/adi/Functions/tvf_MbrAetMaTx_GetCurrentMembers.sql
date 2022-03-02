

CREATE function [adi].[tvf_MbrAetMaTx_GetCurrentMembers](@LoadDate DATE )
    RETURNS TABLE
AS RETURN 
(
    /* purpose: returns a list of current members.
    AetMa is sent in sets of trailing 24 months load states. It also includes a future load state for LoadMonth + 1.
    To get the current data, 
	   1. we need to calculate a current month date from the EffectiveMonth value.
	   2. we need to make sure the month is the same as the load date
	   3. Calc First day of load Month
	   4. Filter results for only rows equal to first day of load month
	   */
    --DECLARE @LOaddate date = '08/28/2019';   
    --DECLARE @FirstDayLoadMonth DATE = DateFromParts(Year(@LoadDate), Month(@LoadDate), 1);
    --DECLARE @LoadDate DATE  = '01/02/2020'
    SELECT src.ClientMemberKey, 
       src.EffectiveMonth, 
       src.CurrentLoadingEffectiveMonth, 
       src.adiKey, 
       src.adiTableName, 
       src.LoadDate
	   ,src.DataDate
    FROM(SELECT CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0), c.MEMBER_ID)) AS ClientMemberKey, 
               c.EffectiveMonth, 
               DATEFROMPARTS(SUBSTRING(c.EffectiveMonth, 1, 4), SUBSTRING(c.EffectiveMonth, 5, 2), 1) CurrentLoadingEffectiveMonth, 
               c.mbrAetMaTxKey AS adiKey, 
               'adi.MbrAetMaTx' AS adiTableName, 
               c.LoadDate AS LoadDate
			   ,c.DataDate --- select top 2 *
        FROM ACECAREDW.adi.MbrAetMaTx c
        --WHERE c.CreatedDate = @LoadDate
	   WHERE c.LoadDate = @LoadDate
	   ) src
    WHERE src.CurrentLoadingEffectiveMonth = DateFromParts(Year(@LoadDate), Month(@LoadDate), 1)
	   -- @FirstDayLoadMonth ;
	   /* Previously we used the max effective data set, this incorrect for our business 
	   (SELECT MAX(s.LastClientUpdateDate)
		  FROM (SELECT distinct DATEFROMPARTS(SUBSTRING(c.EffectiveMonth, 1, 4), SUBSTRING(c.EffectiveMonth, 5, 2), 1) LastClientUpdateDate
				FROM adi.MbrAetMaTx c
				--WHERE c.CreatedDate = @LoadDate
				WHERE c.LoadDate = @LoadDate
				)s)*/
				
)
