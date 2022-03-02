
CREATE FUNCTION [adw].[AceCleanPhoneNumber] 
(
	-- Add the parameters for the function here
	@PhoneNumber varchar(100)
)
RETURNS VARCHAR(25)
AS
BEGIN
		
	-- Declare the return variable here	
	DECLARE @OutPhone VARCHAR(25);

	SET @PhoneNumber = REPLACE(@PhoneNumber,'-', '');
	SET @PhoneNumber = REPLACE(@PhoneNumber,'(', '');
	SET @PhoneNumber = REPLACE(@PhoneNumber,')', '');
	SET @PhoneNumber = REPLACE(@PhoneNumber,' ', '');

	
	IF (SUBSTRING(@PhoneNumber,1,1) = '1') 
	   BEGIN
		  SET  @PhoneNumber = SUBSTRING(@PhoneNumber, 2, LEN(@PhoneNUmber));
	   END    
	
	if (try_convert(numeric(36,0), @PhoneNumber) is null) 
	   	BEGIN
		  SET @PhoneNumber = null
	   	END

	SELECT @OutPhone = CASE WHEN (@PhoneNumber = '0000000000') THEN null ELSE @PhoneNumber END;
	
	-- Return the result of the function
	RETURN @OutPhone;

END
