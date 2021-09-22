DROP FUNCTION [Promotion].[func_Interface_InitPoint_FactorConditionSeleted_List]
GO



/**********************************************
 功能:获取赠品导入已选取产品
 作者：Grapecity
 最后更新时间： 2015-11-23
 更新记录说明：
 1.创建 2015-11-23
**********************************************/
CREATE FUNCTION [Promotion].[func_Interface_InitPoint_FactorConditionSeleted_List](
	@FlowId INT
	)
RETURNS @temp TABLE
	(
		Id nvarchar(50),
		Name nvarchar(500)
	)
AS
BEGIN
	DECLARE @ConditionValue NVARCHAR(MAX)
	DECLARE @FactConditionId INT
	SELECT @FactConditionId=UseRangeCondition,@ConditionValue=ISNULL(PointUseRange,'') FROM Promotion.Pro_InitPoint_Flow A WHERE A.FlowId=@FlowId
	--UPN
	IF @FactConditionId=1
	BEGIN
		INSERT INTO @temp (Id,Name)
		SELECT A.CFN_CustomerFaceNbr+'|',A.CFN_CustomerFaceNbr+'-'+ISNULL(A.CFN_ChineseName,'')
		FROM CFN A WHERE A.CFN_Property4 IN ('0','1') 
		AND  EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColA=A.CFN_CustomerFaceNbr)
	END
	--套装
	IF @FactConditionId=2
	BEGIN
		INSERT INTO @temp (Id,Name)
		SELECT CONVERT(NVARCHAR(10),A.BundleId)+'|',ISNULL(A.BundleName,'')
		FROM Promotion.Pro_Bundle_Setting A 
		WHERE  EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColA=CONVERT(NVARCHAR(10),A.BundleId))
	END
	--产品组
	IF @FactConditionId=3
	BEGIN
		INSERT INTO @temp (Id,Name)
		SELECT DISTINCT ('LEVEL1,'+ A.CFN_Level1Code+'|'),A.CFN_Level1Desc+'(LEVEL1,'+ A.CFN_Level1Code+')' FROM CFN A 
		WHERE  EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level1Code AND b.ColA='Level1')
		UNION
		SELECT DISTINCT ('LEVEL2,'+ A.CFN_Level2Code+'|'),A.CFN_Level2Desc+'(LEVEL2,'+ A.CFN_Level2Code+')' FROM CFN A 
		WHERE  EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level2Code AND b.ColA='Level2')
		UNION
		SELECT DISTINCT ('LEVEL3,'+ A.CFN_Level3Code+'|'),A.CFN_Level3Desc+'(LEVEL3,'+ A.CFN_Level3Code+')' FROM CFN A 
		WHERE EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level3Code AND b.ColA='Level3')
		UNION
		SELECT DISTINCT ('LEVEL4,'+ A.CFN_Level4Code+'|'),A.CFN_Level4Desc+'(LEVEL4,'+ A.CFN_Level4Code+')' FROM CFN A 
		WHERE  EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level4Code AND b.ColA='Level4')
		UNION
		SELECT DISTINCT ('LEVEL5,'+ A.CFN_Level5Code+'|'),A.CFN_Level5Desc+'(LEVEL5,'+ A.CFN_Level5Code+')' FROM CFN A 
		WHERE  EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level5Code AND b.ColA='Level5')
	END
	RETURN
END


GO


