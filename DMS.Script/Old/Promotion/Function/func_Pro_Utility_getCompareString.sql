DROP FUNCTION [Promotion].[func_Pro_Utility_getCompareString]
GO



/**********************************************
 功能:取得比较符号的字符串
 作者：Grapecity
 最后更新时间： 2015-08-28
 更新记录说明：
 1.创建 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_Utility_getCompareString](
	@JudgeValue NVARCHAR(50),	
	@LogicSymbol NVARCHAR(10),		
	@Value1 NVARCHAR(50),				
	@Value2 NVARCHAR(50)		
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX)
	
	IF @LogicSymbol = '=' 	SET @iReturn = @JudgeValue + '=' + @Value1
	IF @LogicSymbol = '>' 	SET @iReturn = @JudgeValue + '>' + @Value1
	IF @LogicSymbol = '>=' 	SET @iReturn = @JudgeValue + '>=' + @Value1
	IF @LogicSymbol = '<' 	SET @iReturn = @JudgeValue + '<' + @Value1
	IF @LogicSymbol = '<=' 	SET @iReturn = @JudgeValue + '<=' + @Value1
	IF @LogicSymbol = '>= AND <' 	SET @iReturn = @Value1 +'<=' + @JudgeValue + '<' + @Value2
	IF @LogicSymbol = '>= AND <=' 	SET @iReturn = @Value1 +'<=' + @JudgeValue + '<=' + @Value2
	IF @LogicSymbol = '> AND <' 	SET @iReturn = @Value1 +'<' + @JudgeValue + '<' + @Value2
	IF @LogicSymbol = '> AND <=' 	SET @iReturn = @Value1 +'<' + @JudgeValue + '<=' + @Value2
	
	return @iReturn
END



GO


