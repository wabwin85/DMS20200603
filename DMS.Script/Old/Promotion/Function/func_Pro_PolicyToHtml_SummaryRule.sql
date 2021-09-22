DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_SummaryRule]
GO

/**********************************************
 功能:传入PolicyId,UserId 获取政策规则)
 作者：Grapecity
 最后更新时间： 2017-11-15
 更新记录说明：
 1.创建 2017-11-15
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_SummaryRule]
(
	@PolicyId INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX);
	DECLARE @RuleCondition NVARCHAR(200);
	DECLARE @RuleResult NVARCHAR(200);
	DECLARE @RuleDesc NVARCHAR(200);
	DECLARE @RSUM INT;
	DECLARE @TCount INT;
	SET @iReturn = ''
	
	SELECT @RSUM = COUNT(*)
	FROM   Promotion.PRO_POLICY_RULE
	WHERE  PolicyId = @PolicyId
	
	SET @TCount = 0;
	
	IF @RSUM > 0
	BEGIN
	    SET @iReturn += '<ul style="padding-left: 25px;">';
	    
	    DECLARE @iCURSOR_Rule CURSOR  ;
	    SET @iCURSOR_Rule =  CURSOR FOR 
	    SELECT Promotion.func_Pro_PolicyToHtml_Rule_Condition(RuleId),
	           Promotion.func_Pro_PolicyToHtml_Rule_Result(RuleId),
	           RuleDesc
	    FROM   Promotion.PRO_POLICY_RULE
	    WHERE  PolicyId = @PolicyId
	    
	    OPEN @iCURSOR_Rule 
	    FETCH NEXT FROM @iCURSOR_Rule INTO @RuleCondition,@RuleResult,@RuleDesc
	    WHILE @@FETCH_STATUS = 0
	    BEGIN
	        SET @iReturn += '<li type="disc">';
	        
	        IF @RSUM > 1
	        BEGIN
	            SET @TCount += 1;
	            SET @iReturn += ('完成目标' + CONVERT(NVARCHAR(10), @TCount) + '：')
	        END	        
	        
	        IF ISNULL(@RuleDesc, '') <> ''
	        BEGIN
	            SET @RuleResult = ISNULL(@RuleResult, '') + '</br>描述：' + @RuleDesc + '';
	        END
	        
	        SET @iReturn += @RuleResult;
	        
	        SET @iReturn += '</li>';
	        
	        FETCH NEXT FROM @iCURSOR_Rule INTO @RuleCondition,@RuleResult,@RuleDesc
	    END 
	    CLOSE @iCURSOR_Rule
	    DEALLOCATE @iCURSOR_Rule
	    
	    SET @iReturn += '</ul>';
	END
	
	RETURN @iReturn
END