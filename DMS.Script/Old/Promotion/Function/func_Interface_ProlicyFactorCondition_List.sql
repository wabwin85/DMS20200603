DROP FUNCTION [Promotion].[func_Interface_ProlicyFactorCondition_List]
GO

CREATE FUNCTION [Promotion].[func_Interface_ProlicyFactorCondition_List](
	@PolicyFactorConditionId NVARCHAR(10),@ProductLineId NVARCHAR(36),@SubBU NVARCHAR(30),@KeyValue NVARCHAR(200),@CurrUser NVARCHAR(36)
	)
RETURNS @temp TABLE
	(
		Id nvarchar(50),
		Name nvarchar(500)
	)
AS
BEGIN
	DECLARE @ConditionValue NVARCHAR(MAX)
	DECLARE @PolicyFactorId INT
	DECLARE @FactConditionId INT
	SELECT @PolicyFactorId=PolicyFactorId,@FactConditionId=ConditionId,@ConditionValue=ConditionValue FROM Promotion.PRO_POLICY_FACTOR_CONDITION_UI A WHERE A.PolicyFactorConditionId=@PolicyFactorConditionId AND A.CurrUser=@CurrUser
	--UPN
	IF @FactConditionId=1
	BEGIN
		INSERT INTO @temp (Id,Name)
		SELECT A.CFN_CustomerFaceNbr,A.CFN_CustomerFaceNbr+'-'+A.CFN_ChineseName FROM CFN A INNER JOIN CfnClassification CCF ON A.CFN_CustomerFaceNbr=CCF.CfnCustomerFaceNbr WHERE A.CFN_Property4 IN ('0','1') 
		AND A.CFN_ProductLine_BUM_ID=@ProductLineId AND ( ISNULL(@SubBU,'')='' OR (CCF.ClassificationId IN (SELECT TAB.CA_ID FROM(SELECT DISTINCT CC_Code,CA_ID FROM V_ProductClassificationStructure) TAB WHERE CC_Code=@SubBU)))
		AND NOT EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColA=A.CFN_CustomerFaceNbr)
		AND (ISNULL(@KeyValue,'')='' OR (A.CFN_CustomerFaceNbr LIKE '%'+@KeyValue+'%' OR A.CFN_ChineseName LIKE '%'+@KeyValue+'%'))
	END
	--套装
	IF @FactConditionId=2
	BEGIN
		RETURN
	END
	--产品组
	IF @FactConditionId=3
	BEGIN
		INSERT INTO @temp (Id,Name)
		SELECT DISTINCT ('LEVEL1,'+ A.CFN_Level1Code+'|'),A.CFN_Level1Desc+'(LEVEL1,'+ A.CFN_Level1Code+')' FROM CFN A 
		INNER JOIN CfnClassification CCF ON A.CFN_CustomerFaceNbr=CCF.CfnCustomerFaceNbr
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId AND ( ISNULL(@SubBU,'')='' OR (CCF.ClassificationId IN (SELECT TAB.CA_ID FROM(SELECT DISTINCT CC_Code,CA_ID FROM V_ProductClassificationStructure) TAB WHERE CC_Code=@SubBU)))
		AND NOT EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level1Code)
		AND (ISNULL(@KeyValue,'')='' OR (A.CFN_Level1Code +A.CFN_Level1Desc+'LEVEL1') LIKE '%'+@KeyValue+'%')
		UNION
		SELECT DISTINCT ('LEVEL2,'+ A.CFN_Level2Code+'|'),A.CFN_Level2Desc+'(LEVEL2,'+ A.CFN_Level2Code+')' FROM CFN A 
		INNER JOIN CfnClassification CCF ON A.CFN_CustomerFaceNbr=CCF.CfnCustomerFaceNbr
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId AND ( ISNULL(@SubBU,'')='' OR (ccf.ClassificationId IN (SELECT TAB.CA_ID FROM(SELECT DISTINCT CC_Code,CA_ID FROM V_ProductClassificationStructure) TAB WHERE CC_Code=@SubBU)))
		AND NOT EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level2Code)
		AND (ISNULL(@KeyValue,'')='' OR (A.CFN_Level2Code +A.CFN_Level2Desc+'LEVEL2') LIKE '%'+@KeyValue+'%')
		UNION
		SELECT DISTINCT ('LEVEL3,'+ A.CFN_Level3Code+'|'),A.CFN_Level3Desc+'(LEVEL3,'+ A.CFN_Level3Code+')' FROM CFN A 
		INNER JOIN CfnClassification CCF ON A.CFN_CustomerFaceNbr=CCF.CfnCustomerFaceNbr
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId AND ( ISNULL(@SubBU,'')='' OR (CCF.ClassificationId IN (SELECT TAB.CA_ID FROM(SELECT DISTINCT CC_Code,CA_ID FROM V_ProductClassificationStructure) TAB WHERE CC_Code=@SubBU)))
		AND NOT EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level3Code)
		AND (ISNULL(@KeyValue,'')='' OR (A.CFN_Level3Code +A.CFN_Level3Desc+'LEVEL3') LIKE '%'+@KeyValue+'%')
		UNION
		SELECT DISTINCT ('LEVEL4,'+ A.CFN_Level4Code+'|'),A.CFN_Level4Desc+'(LEVEL4,'+ A.CFN_Level4Code+')' FROM CFN A 
		INNER JOIN CfnClassification CCF ON A.CFN_CustomerFaceNbr=CCF.CfnCustomerFaceNbr
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId AND ( ISNULL(@SubBU,'')='' OR (ccf.ClassificationId IN (SELECT TAB.CA_ID FROM(SELECT DISTINCT CC_Code,CA_ID FROM V_ProductClassificationStructure) TAB WHERE CC_Code=@SubBU)))
		AND NOT EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level4Code)
		AND (ISNULL(@KeyValue,'')='' OR (A.CFN_Level4Code +A.CFN_Level4Desc+'LEVEL4') LIKE '%'+@KeyValue+'%')
		UNION
		SELECT DISTINCT ('LEVEL5,'+ A.CFN_Level5Code+'|'),A.CFN_Level5Desc+'(LEVEL5,'+ A.CFN_Level5Code+')' FROM CFN A 
		INNER JOIN CfnClassification CCF ON A.CFN_CustomerFaceNbr=CCF.CfnCustomerFaceNbr
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId AND ( ISNULL(@SubBU,'')='' OR (ccf.ClassificationId IN (SELECT TAB.CA_ID FROM(SELECT DISTINCT CC_Code,CA_ID FROM V_ProductClassificationStructure) TAB WHERE CC_Code=@SubBU)))
		AND NOT EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level5Code)
		AND (ISNULL(@KeyValue,'')='' OR (A.CFN_Level5Code +A.CFN_Level5Desc+'LEVEL5') LIKE '%'+@KeyValue+'%')
	END
	--医院
	IF @FactConditionId=4
	BEGIN
		INSERT INTO @temp (Id,Name)
		SELECT A.HOS_Key_Account,(A.HOS_HospitalName+'('+A.HOS_Key_Account+')') 
		FROM Hospital A WHERE A.HOS_ActiveFlag='1' AND A.HOS_DeletedFlag='0'
		AND  NOT EXISTS (SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColA=A.HOS_Key_Account)
		AND (ISNULL(@KeyValue,'')='' OR (A.HOS_Key_Account +A.HOS_HospitalName +A.HOS_HospitalNameEN) LIKE '%'+@KeyValue+'%')
	END
	--省份
	IF @FactConditionId=5
	BEGIN
		INSERT INTO @temp (Id,Name)
		SELECT A.TER_Description,A.TER_Description
		FROM Territory A WHERE A.TER_Type='Province'
		AND  NOT EXISTS (SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColA=A.TER_Description)
		AND (ISNULL(@KeyValue,'')='' OR A.TER_Description  LIKE '%'+@KeyValue+'%')
	END
	--城市
	IF @FactConditionId=6
	BEGIN
		INSERT INTO @temp (Id,Name)
		SELECT A.TER_Description,A.TER_Description
		FROM Territory A WHERE A.TER_Type='City'
		AND  NOT EXISTS (SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColA=A.TER_Description)
		AND (ISNULL(@KeyValue,'')='' OR A.TER_Description  LIKE '%'+@KeyValue+'%')
	END
	--经销商
	IF @FactConditionId=7
	BEGIN
		RETURN
	END
	--采购方式
	IF @FactConditionId=8
	BEGIN
		INSERT INTO @temp(Id,Name) SELECT '寄售','寄售' WHERE '寄售' NOT IN (SELECT B.ColA FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B) AND (ISNULL(@KeyValue,'')='' OR '寄售' LIKE '%'+@KeyValue+'%');
		INSERT INTO @temp(Id,Name) SELECT '批发','批发' WHERE '批发' NOT IN (SELECT B.ColA FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B) AND (ISNULL(@KeyValue,'')='' OR '批发' LIKE '%'+@KeyValue+'%');
	END
	--部门
	IF @FactConditionId=9
	BEGIN
		INSERT INTO @temp(Id,Name) SELECT '红海','红海' WHERE '红海' NOT IN (SELECT B.ColA FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B) AND (ISNULL(@KeyValue,'')='' OR '红海' LIKE '%'+@KeyValue+'%');
		INSERT INTO @temp(Id,Name) SELECT '蓝海','蓝海' WHERE '蓝海' NOT IN (SELECT B.ColA FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B) AND (ISNULL(@KeyValue,'')='' OR '蓝海' LIKE '%'+@KeyValue+'%');
	END
	
	RETURN
END



GO


