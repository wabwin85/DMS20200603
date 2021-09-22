
/****** Object:  UserDefinedFunction [Promotion].[func_Pro_Utility_getLargessUPN]    Script Date: 2020/3/23 17:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER FUNCTION [Promotion].[func_Pro_Utility_getLargessUPN](
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
			FROM Promotion.PRO_DEALER_LARGESS a,Promotion.PRO_DEALER_LARGESS_DETAIL b
			WHERE a.DLid = b.DLid AND a.DLid = @DLID AND DATEADD(DAY,1,ISNULL(a.[ExpireDate],'2099-12-31'))>GETDATE()
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
	SELECT CFN_CustomerFaceNbr FROM View_LocalProductMaster A  
	INNER JOIN CFN B ON A.UPN=B.CFN_CustomerFaceNbr
	WHERE EXISTS (SELECT 1 FROM @ExistsTable WHERE CASE HierType WHEN 'UPN' THEN A.UPN
	                                                WHEN 'AuthType' THEN A.CA_Code
													WHEN 'Level1' THEN A.ProductLine1 
													WHEN 'Level2' THEN A.ProductLine2 
													WHEN 'Level3' THEN A.ProductLine3 
													WHEN 'Level4' THEN A.ProductLine4 
													WHEN 'Level5' THEN A.ProductLine5  ELSE '' END = HierId)
		AND NOT EXISTS (SELECT 1 FROM @ExceptTable WHERE CASE HierType WHEN 'UPN' THEN  A.UPN
		                                            WHEN 'AuthType' THEN A.CA_Code
													WHEN 'Level1' THEN A.ProductLine1 
													WHEN 'Level2' THEN A.ProductLine2 
													WHEN 'Level3' THEN A.ProductLine3 
													WHEN 'Level4' THEN A.ProductLine4 
													WHEN 'Level5' THEN A.ProductLine5  ELSE '' END = HierId)
	
	RETURN
END







