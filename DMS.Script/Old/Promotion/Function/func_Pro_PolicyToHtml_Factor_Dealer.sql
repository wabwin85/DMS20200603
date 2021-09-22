DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_Dealer]
GO



/**********************************************
 ����:����PolicyFactorId,��PolicyFactorId��FactorId�϶��Ǿ�����(3)
 ���ߣ�Grapecity
 ������ʱ�䣺 2015-08-28
 ���¼�¼˵����
 1.���� 2015-08-28
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
		
		IF @ConditionId = 7 --������
			SET @iReturn = REPLACE(@ConditionValue,'|','��')
			
		IF @OperTag = '����'
			SET @INCLUDE = ISNULL(@INCLUDE,'����:') + @iReturn +'��'
		ELSE
			SET @EXCLUDE = ISNULL(@EXCLUDE,'������:') + @iReturn +'��'
			
		FETCH NEXT FROM @iCURSOR INTO @ConditionId,@OperTag,@ConditionValue
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
	SET @iReturn = CASE ISNULL(@INCLUDE,'') WHEN '' THEN '' ELSE LEFT(@INCLUDE,LEN(@INCLUDE)-1) END 
		+ CASE ISNULL(@EXCLUDE,'') WHEN '' THEN '' ELSE '��' END
		+ CASE ISNULL(@EXCLUDE,'') WHEN '' THEN '' ELSE LEFT(@EXCLUDE,LEN(@EXCLUDE)-1) END 
	 
	RETURN @iReturn
END



GO


