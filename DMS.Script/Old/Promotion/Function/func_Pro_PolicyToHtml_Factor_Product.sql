DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_Product]
GO

CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_Product](
	@PolicyFactorId INT,
	@PolicyId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @INCLUDE NVARCHAR(MAX);
	DECLARE @EXCLUDE NVARCHAR(MAX);
	
	DECLARE @ConditionId INT;
	DECLARE @OperTag NVARCHAR(50);
	DECLARE @ConditionValue NVARCHAR(MAX);
	
	SET @SQL = ''
	SET @INCLUDE = NULL
	SET @EXCLUDE = NULL
	
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT A.ConditionId,A.OperTag,A.ConditionValue 
		FROM Promotion.PRO_POLICY_FACTOR_CONDITION A, Promotion.PRO_POLICY_FACTOR B 
	    WHERE A.PolicyFactorId = B.PolicyFactorId AND (B.PolicyFactorId = @PolicyFactorId OR (B.PolicyId = @PolicyId AND B.FactId = 1))
		ORDER BY A.OperTag,A.ConditionId
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @ConditionId,@OperTag,@ConditionValue
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL = '' 
		
		IF @ConditionId = 1 --UPN
			--SET @SQL = 'UPN('+REPLACE(@ConditionValue,'|','，')+')'
			SELECT	@SQL=STUFF(REPLACE(REPLACE(
			(
				SELECT VAL RESULT FROM (
					select (case ISNULL( CFN.CFN_ChineseName,'') when '' then '' else CFN.CFN_ChineseName+':' End) +CFN.CFN_CustomerFaceNbr VAL  from  dbo.GC_Fn_SplitStringToTable(@ConditionValue,'|') a
					inner join CFN ON A.VAL=CFN.CFN_CustomerFaceNbr
				) A
				FOR XML AUTO
			), '<A RESULT="', ','), '"/>', ''), 1, 1, '')
			SET @SQL='UPN('+@SQL+')';
			
		IF @ConditionId = 2 --套装
			SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_Product_Bundle(REPLACE(@ConditionValue,'|',''))
			
		IF @ConditionId = 3 --产品组
			SET @SQL = STUFF(REPLACE(REPLACE(
					(
					    SELECT Promotion.func_Pro_PolicyToHtml_Factor_Product_PrdGrp(A.COLA,A.COLB) COL
							FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) A
					    FOR XML AUTO
					), '<A COL="', '，'), '"/>', ''), 1, 1, '')
		
		IF @OperTag = '包含'
			SET @INCLUDE = ISNULL(@INCLUDE,'包含:') + @SQL +'，'
		ELSE
			SET @EXCLUDE = ISNULL(@EXCLUDE,'不包含:') + @SQL +'，'
			
		FETCH NEXT FROM @iCURSOR INTO @ConditionId,@OperTag,@ConditionValue
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
	SET @SQL = CASE ISNULL(@INCLUDE,'') WHEN '' THEN '' ELSE LEFT(@INCLUDE,LEN(@INCLUDE)-1) END 
		+ CASE ISNULL(@EXCLUDE,'') WHEN '' THEN '' ELSE '；' END
		+ CASE ISNULL(@EXCLUDE,'') WHEN '' THEN '' ELSE LEFT(@EXCLUDE,LEN(@EXCLUDE)-1) END 
	 
	RETURN @SQL
END


GO


