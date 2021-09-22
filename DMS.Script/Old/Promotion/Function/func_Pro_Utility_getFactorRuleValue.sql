DROP FUNCTION [Promotion].[func_Pro_Utility_getFactorRuleValue]
GO




/**********************************************
 功能:传入因素限制KEY值，返回VALUES值
 作者：Grapecity
 最后更新时间： 2016-02-16
 更新记录说明：
 1.创建 2015-02-16
**********************************************/

Create FUNCTION [Promotion].[func_Pro_Utility_getFactorRuleValue](
	@ConditionId INT,@SourceString NVARCHAR(MAX)
	)
RETURNS NVARCHAR(MAX)
WITH
EXECUTE AS CALLER
AS
BEGIN
	DECLARE @SourceValue NVARCHAR (max)
	IF @ConditionId=1
	BEGIN
		SELECT  @SourceValue=STUFF ((SELECT '|' + CFN_ChineseName
								FROM CFN,[Promotion].[func_Pro_Utility_getStringSplit](@SourceString) B 
								WHERE CFN.CFN_CustomerFaceNbr=B.ColA 
						   FOR XML PATH ( '' )),
						  1,
						  1,
						  '')
	END
	ELSE IF @ConditionId=2
	BEGIN
		SELECT  @SourceValue=STUFF ((SELECT '|' + A.BundleName
								FROM Promotion.Pro_Bundle_Setting A,[Promotion].[func_Pro_Utility_getStringSplit](@SourceString) B 
								WHERE CONVERT(NVARCHAR(10),A.BundleId)=B.ColA 
						   FOR XML PATH ( '' )),
						  1,
						  1,
						  '')
	END
	ELSE IF @ConditionId=4
	BEGIN
		SELECT  @SourceValue=STUFF ((SELECT '|' + A.HOS_HospitalName
								FROM Hospital A,[Promotion].[func_Pro_Utility_getStringSplit](@SourceString) B 
								WHERE CONVERT(NVARCHAR(10),A.HOS_Key_Account)=B.ColA 
						   FOR XML PATH ( '' )),
						  1,
						  1,
						  '')
	END
	ELSE
	BEGIN
		SET @SourceValue=@SourceString	;
	END
	
	RETURN @SourceValue;
END


GO


