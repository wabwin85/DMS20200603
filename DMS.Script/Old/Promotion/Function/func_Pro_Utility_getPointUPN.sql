DROP FUNCTION [Promotion].[func_Pro_Utility_getPointUPN]
GO

CREATE FUNCTION [Promotion].[func_Pro_Utility_getPointUPN](
	@DLID INT
	)
RETURNS @temp TABLE
	(
        UPN NVARCHAR (50)	--UPN的CODE
	)
AS
BEGIN

	DECLARE @ConditionId INT
	DECLARE @ConditionValue NVARCHAR(MAX)
	DECLARE @OperTag NVARCHAR(50)
	
	DECLARE @ExistsTable TABLE
	(
		HierType NVARCHAR(20),
		HierId NVARCHAR(50)
	)
	
	DECLARE @ExceptTable TABLE
	(
		HierType NVARCHAR(20),
		HierId NVARCHAR(50)
	)
	
	--循环当前因素涉及的条件选项
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT B.ConditionId,B.ConditionValue,B.OperTag 
			FROM Promotion.PRO_DEALER_POINT a,Promotion.PRO_DEALER_POINT_DETAIL b
			WHERE a.DLid = b.DLid AND a.DLid = @DLID
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @ConditionId,@ConditionValue,@OperTag
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @OperTag = '包含' 
		BEGIN
			IF @ConditionId = 1
				INSERT INTO @ExistsTable(HierType,HierId) 
				SELECT 'UPN',ColA from func_Pro_Utility_getStringSplit(@ConditionValue)
			ELSE
				INSERT INTO @ExistsTable(HierType,HierId) 
				SELECT ColA,ColB from func_Pro_Utility_getStringSplit(@ConditionValue)
		END
		
		IF @OperTag = '不包含'
		BEGIN
			IF @ConditionId = 1
				INSERT INTO @ExceptTable(HierType,HierId) 
				SELECT 'UPN',ColA from func_Pro_Utility_getStringSplit(@ConditionValue)
			ELSE
				INSERT INTO @ExceptTable(HierType,HierId) 
				SELECT ColA,ColB from func_Pro_Utility_getStringSplit(@ConditionValue)
		END
		
		FETCH NEXT FROM @iCURSOR INTO @ConditionId,@ConditionValue,@OperTag
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
	INSERT INTO @temp(UPN) 
	SELECT CFN_CustomerFaceNbr FROM dbo.CFN A 
	WHERE EXISTS (SELECT 1 FROM @ExistsTable WHERE CASE HierType WHEN 'UPN' THEN A.CFN_CustomerFaceNbr
													WHEN 'LEVEL1' THEN A.CFN_Level1Code 
													WHEN 'LEVEL2' THEN A.CFN_Level2Code 
													WHEN 'LEVEL3' THEN A.CFN_Level3Code 
													WHEN 'LEVEL4' THEN A.CFN_Level4Code 
													WHEN 'LEVEL5' THEN A.CFN_Level5Code  ELSE '' END = HierId)
		AND NOT EXISTS (SELECT 1 FROM @ExceptTable WHERE CASE HierType WHEN 'UPN' THEN A.CFN_CustomerFaceNbr
													WHEN 'LEVEL1' THEN A.CFN_Level1Code 
													WHEN 'LEVEL2' THEN A.CFN_Level2Code 
													WHEN 'LEVEL3' THEN A.CFN_Level3Code 
													WHEN 'LEVEL4' THEN A.CFN_Level4Code 
													WHEN 'LEVEL5' THEN A.CFN_Level5Code  ELSE '' END = HierId)
	
	RETURN
END


GO


