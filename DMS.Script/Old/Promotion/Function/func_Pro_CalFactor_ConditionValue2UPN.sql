DROP FUNCTION [Promotion].[func_Pro_CalFactor_ConditionValue2UPN]
GO

CREATE FUNCTION [Promotion].[func_Pro_CalFactor_ConditionValue2UPN](
	@HIERTYPE NVARCHAR(50),
	@HIERID NVARCHAR(MAX)
	)
RETURNS @temp TABLE
	(
        UPN NVARCHAR (50)	--UPNµÄCODE
	)
AS
BEGIN
	DECLARE @ExistsTable TABLE
		(
			HierType NVARCHAR(20),
			HierId NVARCHAR(50)
		)
	
	IF @HIERTYPE = 'UPN'
	BEGIN
		INSERT INTO @ExistsTable(HierType,HierId) 
			SELECT 'UPN',ColA from Promotion.func_Pro_Utility_getStringSplit(@HIERID)
	END

	IF @HIERTYPE = 'HIER'
	BEGIN
		INSERT INTO @ExistsTable(HierType,HierId) 
				SELECT ColA,ColB from func_Pro_Utility_getStringSplit(@HIERID)
	END
	
	INSERT INTO @temp(UPN) 
	SELECT CFN_CustomerFaceNbr FROM dbo.CFN A 
	WHERE EXISTS (SELECT 1 FROM @ExistsTable WHERE CASE HierType WHEN 'UPN' THEN A.CFN_CustomerFaceNbr
													WHEN 'LEVEL1' THEN A.CFN_Level1Code 
													WHEN 'LEVEL2' THEN A.CFN_Level2Code 
													WHEN 'LEVEL3' THEN A.CFN_Level3Code 
													WHEN 'LEVEL4' THEN A.CFN_Level4Code 
													WHEN 'LEVEL5' THEN A.CFN_Level5Code  ELSE '' END = HierId)
	
	 
	RETURN
END


GO


