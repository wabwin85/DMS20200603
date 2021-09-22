DROP FUNCTION [Promotion].[func_Interface_InitPoint_UseRange_List]
GO

create FUNCTION [Promotion].[func_Interface_InitPoint_UseRange_List](
	@FactConditionId NVARCHAR(10),@ProductLineId NVARCHAR(36),@FlowId int,@KeyValue NVARCHAR(200),@CurrUser NVARCHAR(36)
	)
RETURNS @temp TABLE
	(
		Id nvarchar(50),
		Name nvarchar(500)
	)
AS
BEGIN
	DECLARE @ConditionValue NVARCHAR(MAX)
	
	select @ConditionValue = PointUseRange from Promotion.Pro_InitPoint_Flow where FlowId = @FlowId
	
	--UPN
	IF @FactConditionId=1
	BEGIN
		INSERT INTO @temp (Id,Name)
		SELECT A.CFN_CustomerFaceNbr+'|',A.CFN_CustomerFaceNbr+'-'+ISNULL(A.CFN_ChineseName,'') FROM CFN A WHERE A.CFN_Property4 IN ('0','1') 
		AND A.CFN_ProductLine_BUM_ID=@ProductLineId --AND ( ISNULL(@SubBU,'')='' OR (A.CFN_ProductCatagory_PCT_ID IN (SELECT TAB.CA_ID FROM(SELECT DISTINCT CC_Code,CA_ID FROM V_ProductClassificationStructure) TAB WHERE CC_Code=@SubBU)))
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
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId --AND ( ISNULL(@SubBU,'')='' OR (A.CFN_ProductCatagory_PCT_ID IN (SELECT TAB.CA_ID FROM(SELECT DISTINCT CC_Code,CA_ID FROM V_ProductClassificationStructure) TAB WHERE CC_Code=@SubBU)))
		AND NOT EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level1Code)
		AND (ISNULL(@KeyValue,'')='' OR (A.CFN_Level1Code +A.CFN_Level1Desc+'LEVEL1') LIKE '%'+@KeyValue+'%')
		UNION
		SELECT DISTINCT ('LEVEL2,'+ A.CFN_Level2Code+'|'),A.CFN_Level2Desc+'(LEVEL2,'+ A.CFN_Level2Code+')' FROM CFN A 
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId --AND ( ISNULL(@SubBU,'')='' OR (A.CFN_ProductCatagory_PCT_ID IN (SELECT TAB.CA_ID FROM(SELECT DISTINCT CC_Code,CA_ID FROM V_ProductClassificationStructure) TAB WHERE CC_Code=@SubBU)))
		AND NOT EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level2Code)
		AND (ISNULL(@KeyValue,'')='' OR (A.CFN_Level2Code +A.CFN_Level2Desc+'LEVEL2') LIKE '%'+@KeyValue+'%')
		UNION
		SELECT DISTINCT ('LEVEL3,'+ A.CFN_Level3Code+'|'),A.CFN_Level3Desc+'(LEVEL3,'+ A.CFN_Level3Code+')' FROM CFN A 
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId --AND ( ISNULL(@SubBU,'')='' OR (A.CFN_ProductCatagory_PCT_ID IN (SELECT TAB.CA_ID FROM(SELECT DISTINCT CC_Code,CA_ID FROM V_ProductClassificationStructure) TAB WHERE CC_Code=@SubBU)))
		AND NOT EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level3Code)
		AND (ISNULL(@KeyValue,'')='' OR (A.CFN_Level3Code +A.CFN_Level3Desc+'LEVEL3') LIKE '%'+@KeyValue+'%')
		UNION
		SELECT DISTINCT ('LEVEL4,'+ A.CFN_Level4Code+'|'),A.CFN_Level4Desc+'(LEVEL4,'+ A.CFN_Level4Code+')' FROM CFN A 
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId --AND ( ISNULL(@SubBU,'')='' OR (A.CFN_ProductCatagory_PCT_ID IN (SELECT TAB.CA_ID FROM(SELECT DISTINCT CC_Code,CA_ID FROM V_ProductClassificationStructure) TAB WHERE CC_Code=@SubBU)))
		AND NOT EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level4Code)
		AND (ISNULL(@KeyValue,'')='' OR (A.CFN_Level4Code +A.CFN_Level4Desc+'LEVEL4') LIKE '%'+@KeyValue+'%')
		UNION
		SELECT DISTINCT ('LEVEL5,'+ A.CFN_Level5Code+'|'),A.CFN_Level5Desc+'(LEVEL5,'+ A.CFN_Level5Code+')' FROM CFN A 
		WHERE A.CFN_ProductLine_BUM_ID=@ProductLineId --AND ( ISNULL(@SubBU,'')='' OR (A.CFN_ProductCatagory_PCT_ID IN (SELECT TAB.CA_ID FROM(SELECT DISTINCT CC_Code,CA_ID FROM V_ProductClassificationStructure) TAB WHERE CC_Code=@SubBU)))
		AND NOT EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level5Code)
		AND (ISNULL(@KeyValue,'')='' OR (A.CFN_Level5Code +A.CFN_Level5Desc+'LEVEL5') LIKE '%'+@KeyValue+'%')
	END
	
	
	RETURN
END


GO


