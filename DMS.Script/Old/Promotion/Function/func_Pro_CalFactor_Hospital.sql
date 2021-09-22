DROP FUNCTION [Promotion].[func_Pro_CalFactor_Hospital]
GO



/**********************************************
 功能:取得条件因素“医院”（临时表）
 作者：Grapecity
 最后更新时间： 2015-08-28
 更新记录说明：
 1.创建 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_CalFactor_Hospital](
	@PolicyFactorId INT
	)
RETURNS @temp TABLE
	(
		OperTag NVARCHAR(10),
		HospitalId NVARCHAR (50)
	)
AS
BEGIN
	DECLARE @ConditionId INT
	DECLARE @ConditionName NVARCHAR(20)
	DECLARE @ConditionValue NVARCHAR(MAX)
	DECLARE @OperTag NVARCHAR(50)
	
	DECLARE @ExistsTable TABLE
	(
		ConditionType NVARCHAR(20),
		ConditionId NVARCHAR(50)
	)
	
	DECLARE @ExceptTable TABLE
	(
		ConditionType NVARCHAR(20),
		ConditionId NVARCHAR(50)
	)
	
	--循环当前因素涉及的条件选项
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT B.ConditionId,C.ConditionName,B.ConditionValue,B.OperTag 
		FROM Promotion.PRO_POLICY_FACTOR A,Promotion.PRO_POLICY_FACTOR_CONDITION B,Promotion.PRO_CONDTION C
		WHERE A.PolicyFactorId = B.PolicyFactorId AND B.ConditionId = C.ConditionId AND A.PolicyFactorId = @PolicyFactorId 
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @ConditionId,@ConditionName,@ConditionValue,@OperTag
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @OperTag = '包含' 
			INSERT INTO @ExistsTable(ConditionType,ConditionId) 
				SELECT @ConditionName,ColA from Promotion.func_Pro_Utility_getStringSplit(@ConditionValue)
		
		IF @OperTag = '不包含'
			INSERT INTO @ExceptTable(ConditionType,ConditionId) 
				SELECT @ConditionName,ColA from Promotion.func_Pro_Utility_getStringSplit(@ConditionValue)
		
		FETCH NEXT FROM @iCURSOR INTO @ConditionId,@ConditionName,@ConditionValue,@OperTag
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
	INSERT INTO @temp(OperTag,HospitalId) 
	SELECT 'INCLUDE',A.HOS_Key_Account FROM dbo.Hospital A
	WHERE EXISTS (SELECT 1 FROM @ExistsTable 
		WHERE CASE ConditionType WHEN '省份' THEN A.HOS_Province
			WHEN '城市' THEN A.HOS_City
			WHEN '医院' THEN A.HOS_Key_Account ELSE '' END = ConditionId)
									 
	INSERT INTO @temp(OperTag,HospitalId) 
	SELECT 'EXCLUDE',A.HOS_Key_Account FROM dbo.Hospital A
	WHERE EXISTS (SELECT 1 FROM @ExceptTable 
		WHERE CASE ConditionType WHEN '省份' THEN A.HOS_Province
			WHEN '城市' THEN A.HOS_City
			WHEN '医院' THEN A.HOS_Key_Account ELSE '' END = ConditionId)
	
	RETURN
END



GO


