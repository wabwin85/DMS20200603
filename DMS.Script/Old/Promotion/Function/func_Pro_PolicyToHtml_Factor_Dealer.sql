DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_Dealer]
GO



/**********************************************
 功能:传入PolicyFactorId,此PolicyFactorId的FactorId肯定是经销商(3)
 作者：Grapecity
 最后更新时间： 2015-08-28
 更新记录说明：
 1.创建 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_Dealer](
	@PolicyFactorId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX);
	DECLARE @INCLUDE NVARCHAR(MAX);
	DECLARE @EXCLUDE NVARCHAR(MAX);
	
	DECLARE @ConditionId INT;
	DECLARE @OperTag NVARCHAR(50);
	DECLARE @ConditionValue NVARCHAR(MAX);
	DECLARE @HospitalName NVARCHAR(MAX);
	
	SET @iReturn = ''
	SET @INCLUDE = NULL
	SET @EXCLUDE = NULL
	
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT A.ConditionId,A.OperTag,A.ConditionValue 
		FROM Promotion.PRO_POLICY_FACTOR_CONDITION A,Promotion.PRO_CONDTION B 
		WHERE PolicyFactorId = @PolicyFactorId AND A.ConditionId = B.ConditionId
		ORDER BY A.OperTag,B.SORTNO
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @ConditionId,@OperTag,@ConditionValue
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @iReturn = '' 
		
		IF @ConditionId = 7 --经销商
			SET @iReturn = REPLACE(@ConditionValue,'|','，')
			
		IF @OperTag = '包含'
			SET @INCLUDE = ISNULL(@INCLUDE,'包含:') + @iReturn +'，'
		ELSE
			SET @EXCLUDE = ISNULL(@EXCLUDE,'不包含:') + @iReturn +'，'
			
		FETCH NEXT FROM @iCURSOR INTO @ConditionId,@OperTag,@ConditionValue
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
	SET @iReturn = CASE ISNULL(@INCLUDE,'') WHEN '' THEN '' ELSE LEFT(@INCLUDE,LEN(@INCLUDE)-1) END 
		+ CASE ISNULL(@EXCLUDE,'') WHEN '' THEN '' ELSE '；' END
		+ CASE ISNULL(@EXCLUDE,'') WHEN '' THEN '' ELSE LEFT(@EXCLUDE,LEN(@EXCLUDE)-1) END 
	 
	RETURN @iReturn
END



GO


