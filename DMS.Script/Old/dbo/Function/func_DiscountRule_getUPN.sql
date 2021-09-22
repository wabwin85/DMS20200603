DROP FUNCTION [dbo].[func_DiscountRule_getUPN]
GO


Create FUNCTION [dbo].[func_DiscountRule_getUPN](
	@ID uniqueidentifier
	)
RETURNS @temp TABLE
	(
        UPN NVARCHAR (50)	--UPN��CODE
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
	
	--ѭ����ǰ�����漰������ѡ��
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT B.PctType,B.OperTag,B.PctLevel 
			FROM ProductDiscountRule a,ProductDiscountDetail b
			WHERE a.ID = b.RuleID AND a.ID = @ID
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @ConditionId,@OperTag,@ConditionValue
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @OperTag = '����' 
		BEGIN
			IF @ConditionId = 1
				INSERT INTO @ExistsTable(HierType,HierId) 
				SELECT 'UPN',ColA from promotion.func_Pro_Utility_getStringSplit(@ConditionValue)
			ELSE
				INSERT INTO @ExistsTable(HierType,HierId) 
				SELECT ColA,ColB from promotion.func_Pro_Utility_getStringSplit(@ConditionValue)
		END
		
		IF @OperTag = '������'
		BEGIN
			IF @ConditionId = 1
				INSERT INTO @ExceptTable(HierType,HierId) 
				SELECT 'UPN',ColA from promotion.func_Pro_Utility_getStringSplit(@ConditionValue)
			ELSE
				INSERT INTO @ExceptTable(HierType,HierId) 
				SELECT ColA,ColB from promotion.func_Pro_Utility_getStringSplit(@ConditionValue)
		END
		
		FETCH NEXT FROM @iCURSOR INTO @ConditionId,@OperTag,@ConditionValue
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
		AND EXISTS(SELECT 1 FROM ProductDiscountRule DR INNER JOIN V_DivisionProductLineRelation PR ON CONVERT(NVARCHAR(10),DR.BU)=CONVERT(NVARCHAR(10),PR.DivisionCode) AND PR.IsEmerging='0' AND A.CFN_ProductLine_BUM_ID=PR.ProductLineID AND DR.ID=@ID)
	
	RETURN
END




GO


