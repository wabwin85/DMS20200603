DROP FUNCTION [Promotion].[func_Pro_Utility_getCompareString]
GO



/**********************************************
 ����:ȡ�ñȽϷ��ŵ��ַ���
 ���ߣ�Grapecity
 ������ʱ�䣺 2015-08-28
 ���¼�¼˵����
 1.���� 2015-08-28
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


