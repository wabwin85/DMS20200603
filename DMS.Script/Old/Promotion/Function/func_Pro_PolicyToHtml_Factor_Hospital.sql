DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_Hospital]
GO

/**********************************************
 功能:传入PolicyFactorId,此PolicyFactorId的FactorId肯定是医院(2)
 作者：Grapecity
 最后更新时间： 2015-08-28
 更新记录说明：
 1.创建 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_Hospital](
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
	DECLARE @HospitalName NVARCHAR(MAX);
	
	SET @SQL = ''
	SET @INCLUDE = NULL
	SET @EXCLUDE = NULL
	
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT A.ConditionId,A.OperTag,A.ConditionValue 
		FROM Promotion.PRO_POLICY_FACTOR_CONDITION A,Promotion.PRO_CONDTION B, Promotion.PRO_POLICY_FACTOR C
	    WHERE A.PolicyFactorId = C.PolicyFactorId AND A.ConditionId = B.ConditionId AND (C.PolicyFactorId = @PolicyFactorId OR (C.PolicyId = @PolicyId AND C.FactId = 2))
		ORDER BY A.OperTag,B.SORTNO
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @ConditionId,@OperTag,@ConditionValue
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL = '' 
		
		IF @ConditionId = 5 --省份
			SET @SQL = REPLACE(@ConditionValue,'|','，')
			
		IF @ConditionId = 6 --城市
			SET @SQL = REPLACE(@ConditionValue,'|','，')
			
		IF @ConditionId = 4 --医院
		BEGIN			
			SET @SQL = STUFF(REPLACE(REPLACE(
					(
					    SELECT HOS_HospitalName FROM dbo.Hospital A 
					    	WHERE A.HOS_Key_Account IN (SELECT COLA
							FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue))
					    FOR XML AUTO
					), '<A HOS_HospitalName="', '，'), '"/>', ''), 1, 1, '')
		END
		
		IF @OperTag = '包含'
			SET @INCLUDE = ISNULL(@INCLUDE,'包含:') + @SQL
		ELSE
			SET @EXCLUDE = ISNULL(@EXCLUDE,'不包含:') + @SQL
			
		FETCH NEXT FROM @iCURSOR INTO @ConditionId,@OperTag,@ConditionValue
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
	SET @SQL = CASE ISNULL(@INCLUDE,'') WHEN '' THEN '' ELSE LEFT(@INCLUDE,LEN(@INCLUDE)-1) END 
		+ CASE ISNULL(@EXCLUDE,'') WHEN '' THEN '' ELSE CASE ISNULL(@INCLUDE,'') WHEN '' THEN '' ELSE '；' END END
		+ CASE ISNULL(@EXCLUDE,'') WHEN '' THEN '' ELSE LEFT(@EXCLUDE,LEN(@EXCLUDE)-1) END 
	 
	RETURN @SQL
END



GO


