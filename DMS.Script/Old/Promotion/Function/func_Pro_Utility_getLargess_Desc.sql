drop FUNCTION [Promotion].[func_Pro_Utility_getLargess_Desc]
GO




CREATE FUNCTION [Promotion].[func_Pro_Utility_getLargess_Desc](
	@DLID INT,
	@TYPE NVARCHAR(10)
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @RETURN NVARCHAR(MAX);
	DECLARE @INCLUDE NVARCHAR(MAX);
	DECLARE @EXCLUDE NVARCHAR(MAX);
	
	DECLARE @ConditionId INT;
	DECLARE @OperTag NVARCHAR(50);
	DECLARE @ConditionValue NVARCHAR(MAX);
	DECLARE @ICOUNT INT;
	
	SET @RETURN = ''
	SET @INCLUDE = NULL
	SET @EXCLUDE = NULL
	
	IF @TYPE = 'LIST'
	BEGIN
		DECLARE @iCURSOR CURSOR;
		SET @iCURSOR = CURSOR FOR SELECT TOP 2 A.ConditionId,A.OperTag,A.ConditionValue 
			FROM Promotion.PRO_DEALER_LARGESS_DETAIL A WHERE DLID = @DLID AND OperTag = '包含'
		OPEN @iCURSOR
		FETCH NEXT FROM @iCURSOR INTO @ConditionId,@OperTag,@ConditionValue
		WHILE @@FETCH_STATUS = 0
		BEGIN			
			IF @ConditionId = 1 --UPN
				SET @RETURN = CASE @RETURN WHEN '' THEN '' ELSE @RETURN+'，' END + REPLACE(@ConditionValue,'|','，')
				
			IF @ConditionId = 2 --套餐 (未开发)
				SET @RETURN = CASE @RETURN WHEN '' THEN '' ELSE @RETURN+'，' END + REPLACE(@ConditionValue,'|','，')
				
			IF @ConditionId = 3 --产品组
				SET @RETURN = CASE @RETURN WHEN '' THEN '' ELSE @RETURN+'，' END + STUFF(REPLACE(REPLACE(
						(
						    SELECT Promotion.func_Pro_Utility_getLargess_Desc_PrdGrp(A.COLA,A.COLB) COL
								FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) A
						    FOR XML AUTO
						), '<A COL="', '，'), '"/>', ''), 1, 1, '')
				
			FETCH NEXT FROM @iCURSOR INTO @ConditionId,@OperTag,@ConditionValue
		END	
		CLOSE @iCURSOR
		DEALLOCATE @iCURSOR
		
		SELECT @ICOUNT = COUNT(*) FROM Promotion.PRO_DEALER_LARGESS_DETAIL A WHERE DLID = @DLID AND OperTag = '包含'
		IF @ICOUNT > 2 OR LEN(@RETURN)>30
		BEGIN
			 SET @RETURN = LEFT(@RETURN,30)+'...'
		END
	END
	ELSE
	BEGIN 
		DECLARE @iCURSOR1 CURSOR;
		SET @iCURSOR1 = CURSOR FOR SELECT A.ConditionId,A.OperTag,A.ConditionValue 
			FROM Promotion.PRO_DEALER_LARGESS_DETAIL A WHERE DLID = @DLID
			ORDER BY A.OperTag,A.ConditionId
		OPEN @iCURSOR1 	
		FETCH NEXT FROM @iCURSOR1 INTO @ConditionId,@OperTag,@ConditionValue
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @RETURN = '' 
			
			IF @ConditionId = 1 --UPN
				SET @RETURN = 'UPN('+REPLACE(@ConditionValue,'|','，')+')'
				
			IF @ConditionId = 2 --套餐 (未开发)
				SET @RETURN = '套餐('+REPLACE(@ConditionValue,'|','，')+')'
				
			IF @ConditionId = 3 --产品组
				SET @RETURN = STUFF(REPLACE(REPLACE(
						(
						    SELECT Promotion.func_Pro_Utility_getLargess_Desc_PrdGrp(A.COLA,A.COLB) COL
								FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) A
						    FOR XML AUTO
						), '<A COL="', '，'), '"/>', ''), 1, 1, '')
			
			IF @OperTag = '包含'
				SET @INCLUDE = ISNULL(@INCLUDE,'包含:') + @RETURN +'，'
			ELSE
				SET @EXCLUDE = ISNULL(@EXCLUDE,'不包含:') + @RETURN +'，'
				
			FETCH NEXT FROM @iCURSOR1 INTO @ConditionId,@OperTag,@ConditionValue
		END	
		CLOSE @iCURSOR1
		DEALLOCATE @iCURSOR1
		
		SET @RETURN = CASE ISNULL(@INCLUDE,'') WHEN '' THEN '' ELSE LEFT(@INCLUDE,LEN(@INCLUDE)-1) END 
			+ CASE ISNULL(@EXCLUDE,'') WHEN '' THEN '' ELSE '；' END
			+ CASE ISNULL(@EXCLUDE,'') WHEN '' THEN '' ELSE LEFT(@EXCLUDE,LEN(@EXCLUDE)-1) END 
	END
	 
	RETURN @RETURN
END




GO


