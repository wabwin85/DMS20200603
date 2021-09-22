DROP FUNCTION [Promotion].[func_Interface_FactorCondition_ListNew]
GO


/**********************************************
 功能:获取因素约束条件
 作者：Grapecity
 最后更新时间： 2015-11-23
 更新记录说明：
 1.创建 2015-11-23
**********************************************/
CREATE FUNCTION [Promotion].[func_Interface_FactorCondition_ListNew](
	@ProductLineId NVARCHAR(36),@SubBU NVARCHAR(30),@ConditionId INT,@CurrUser NVARCHAR(36)
	)
RETURNS @temp TABLE
	(
		Code nvarchar(50),
		Id nvarchar(50),
		Name nvarchar(500)
	)
AS
BEGIN
	--UPN
	IF @ConditionId=1
	BEGIN
		INSERT INTO @temp (Code,Id,Name)
		SELECT A.CFN_CustomerFaceNbr,A.CFN_CustomerFaceNbr+'|',A.CFN_CustomerFaceNbr+'-'+ISNULL(A.CFN_ChineseName,'') FROM CFN A INNER JOIN CfnClassification CCF ON A.CFN_CustomerFaceNbr=CCF.CfnCustomerFaceNbr WHERE A.CFN_Property4 IN ('0','1') 
		AND A.CFN_ProductLine_BUM_ID=@ProductLineId 
		AND ( ISNULL(@SubBU,'')='' 
			OR (exists (select 1 from CfnClassification ccf where ccf.CfnCustomerFaceNbr=CFN_CustomerFaceNbr and ccf.ClassificationId in  (SELECT TAB.CA_ID FROM(SELECT DISTINCT CC_Code,CA_ID FROM V_ProductClassificationStructure) TAB WHERE CC_Code=@SubBU)))
			OR (A.CFN_ProductLine_BUM_ID IN (SELECT TAB.CA_ID FROM(SELECT DISTINCT CC_Code,CA_ID FROM V_ProductClassificationStructure) TAB WHERE CC_Code=@SubBU))
			)
	END
	--套装
	IF @ConditionId=2
	BEGIN
		INSERT INTO @temp (Code,Id,Name)
		SELECT CONVERT(NVARCHAR(10),A.BundleId),CONVERT(NVARCHAR(10),A.BundleId)+'|',A.BundleName FROM Promotion.Pro_Bundle_Setting A INNER JOIN V_DivisionProductLineRelation B ON A.BU=B.DivisionName AND B.IsEmerging='0' 
		WHERE B.ProductLineID=@ProductLineId
	END
	--产品组
	IF @ConditionId=3
	BEGIN
		INSERT INTO @temp (Code,Id,Name)
		SELECT DISTINCT ('LEVEL1,'+ A.CFN_Level1Code),('LEVEL1,'+ A.CFN_Level1Code+'|'),A.CFN_Level1Desc+'(LEVEL1,'+ A.CFN_Level1Code+')' FROM CFN A 
		INNER JOIN CfnClassification CCF ON A.CFN_CustomerFaceNbr=CCF.CfnCustomerFaceNbr
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId 
		AND ( ISNULL(@SubBU,'')='' 
		--OR (A.CFN_ProductCatagory_PCT_ID IN (SELECT DISTINCT TAB.CA_ID FROM V_ProductClassificationStructure TAB WHERE TAB.CC_Code=@SubBU))
		--OR (A.CFN_ProductLine_BUM_ID IN (SELECT DISTINCT TAB2.CA_ID FROM V_ProductClassificationStructure TAB2 WHERE TAB2.CC_Code=@SubBU))
		OR EXISTS(SELECT 1 FROM V_ProductClassificationStructure TAB WHERE TAB.CC_Code=@SubBU AND TAB.CA_ID=CCF.ClassificationId)
		OR EXISTS(SELECT 1 FROM V_ProductClassificationStructure TAB2 WHERE TAB2.CC_Code=@SubBU AND TAB2.CA_ID=A.CFN_ProductLine_BUM_ID)
		)
		UNION
		SELECT DISTINCT ('LEVEL2,'+ A.CFN_Level2Code),('LEVEL2,'+ A.CFN_Level2Code+'|'),A.CFN_Level2Desc+'(LEVEL2,'+ A.CFN_Level2Code+')' FROM CFN A 
		INNER JOIN CfnClassification CCF ON A.CFN_CustomerFaceNbr=CCF.CfnCustomerFaceNbr
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId 
		AND ( ISNULL(@SubBU,'')='' 
		--OR (A.CFN_ProductCatagory_PCT_ID IN (SELECT DISTINCT TAB.CA_ID FROM V_ProductClassificationStructure TAB  WHERE TAB.CC_Code=@SubBU))
		--OR (A.CFN_ProductLine_BUM_ID IN (SELECT DISTINCT TAB2.CA_ID FROM V_ProductClassificationStructure TAB2  WHERE TAB2.CC_Code=@SubBU))
		OR EXISTS(SELECT 1 FROM V_ProductClassificationStructure TAB WHERE TAB.CC_Code=@SubBU AND TAB.CA_ID=CCF.ClassificationId)
		OR EXISTS(SELECT 1 FROM V_ProductClassificationStructure TAB2 WHERE TAB2.CC_Code=@SubBU AND TAB2.CA_ID=A.CFN_ProductLine_BUM_ID)
		)
		UNION
		SELECT DISTINCT ('LEVEL3,'+ A.CFN_Level3Code),('LEVEL3,'+ A.CFN_Level3Code+'|'),A.CFN_Level3Desc+'(LEVEL3,'+ A.CFN_Level3Code+')' FROM CFN A 
		INNER JOIN CfnClassification CCF ON A.CFN_CustomerFaceNbr=CCF.CfnCustomerFaceNbr
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId 
		AND ( ISNULL(@SubBU,'')='' 
		--OR (A.CFN_ProductCatagory_PCT_ID IN (SELECT DISTINCT TAB.CA_ID FROM V_ProductClassificationStructure TAB  WHERE TAB.CC_Code=@SubBU))
		--OR (A.CFN_ProductLine_BUM_ID IN (SELECT DISTINCT TAB2.CA_ID FROM V_ProductClassificationStructure TAB2  WHERE TAB2.CC_Code=@SubBU))
		OR EXISTS(SELECT 1 FROM V_ProductClassificationStructure TAB WHERE TAB.CC_Code=@SubBU AND TAB.CA_ID=CCF.ClassificationId)
		OR EXISTS(SELECT 1 FROM V_ProductClassificationStructure TAB2 WHERE TAB2.CC_Code=@SubBU AND TAB2.CA_ID=A.CFN_ProductLine_BUM_ID)
		)
		UNION
		SELECT DISTINCT ('LEVEL4,'+ A.CFN_Level4Code),('LEVEL4,'+ A.CFN_Level4Code+'|'),A.CFN_Level4Desc+'(LEVEL4,'+ A.CFN_Level4Code+')' FROM CFN A 
		INNER JOIN CfnClassification CCF ON A.CFN_CustomerFaceNbr=CCF.CfnCustomerFaceNbr
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId 
		AND ( ISNULL(@SubBU,'')='' 
		--OR (A.CFN_ProductCatagory_PCT_ID IN (SELECT DISTINCT TAB.CA_ID FROM V_ProductClassificationStructure TAB  WHERE TAB.CC_Code=@SubBU))
		--OR (A.CFN_ProductLine_BUM_ID IN (SELECT DISTINCT TAB2.CA_ID FROM V_ProductClassificationStructure TAB2  WHERE TAB2.CC_Code=@SubBU))
		OR EXISTS(SELECT 1 FROM V_ProductClassificationStructure TAB WHERE TAB.CC_Code=@SubBU AND TAB.CA_ID=ccf.ClassificationId)
		OR EXISTS(SELECT 1 FROM V_ProductClassificationStructure TAB2 WHERE TAB2.CC_Code=@SubBU AND TAB2.CA_ID=A.CFN_ProductLine_BUM_ID)
		)
		UNION
		SELECT DISTINCT ('LEVEL5,'+ A.CFN_Level5Code),('LEVEL5,'+ A.CFN_Level5Code+'|'),A.CFN_Level5Desc+'(LEVEL5,'+ A.CFN_Level5Code+')' FROM CFN A 
		INNER JOIN CfnClassification CCF ON A.CFN_CustomerFaceNbr=CCF.CfnCustomerFaceNbr
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId 
		AND ( ISNULL(@SubBU,'')='' 
		--OR (A.CFN_ProductCatagory_PCT_ID IN (SELECT DISTINCT TAB.CA_ID FROM V_ProductClassificationStructure TAB  WHERE TAB.CC_Code=@SubBU))
		--OR (A.CFN_ProductLine_BUM_ID IN (SELECT DISTINCT TAB2.CA_ID FROM V_ProductClassificationStructure TAB2  WHERE TAB2.CC_Code=@SubBU))
		OR EXISTS(SELECT 1 FROM V_ProductClassificationStructure TAB WHERE TAB.CC_Code=@SubBU AND TAB.CA_ID=ccf.ClassificationId)
		OR EXISTS(SELECT 1 FROM V_ProductClassificationStructure TAB2 WHERE TAB2.CC_Code=@SubBU AND TAB2.CA_ID=A.CFN_ProductLine_BUM_ID)
		)
	END
	--医院
	IF @ConditionId=4
	BEGIN
		INSERT INTO @temp (Code,Id,Name)
		SELECT A.HOS_Key_Account,A.HOS_Key_Account+'|',(A.HOS_HospitalName+'('+A.HOS_Key_Account+')') 
		FROM Hospital A WHERE A.HOS_ActiveFlag='1' AND A.HOS_DeletedFlag='0'
	END
	--省份
	IF @ConditionId=5
	BEGIN
		INSERT INTO @temp (Code,Id,Name)
		SELECT A.TER_Description,A.TER_Description+'|',A.TER_Description
		FROM Territory A WHERE A.TER_Type='Province'
	END
	--城市
	IF @ConditionId=6
	BEGIN
		INSERT INTO @temp (Code,Id,Name)
		SELECT A.TER_Description,A.TER_Description+'|',A.TER_Description
		FROM Territory A WHERE A.TER_Type='City'
	END
	--经销商
	IF @ConditionId=7
	BEGIN
		RETURN
	END
	
	RETURN
END


GO


