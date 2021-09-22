DROP PROCEDURE [Promotion].[Proc_Interface_PolicyFactorRuleDelete]
GO




/**********************************************
	���ܣ������������ع���
	���ߣ�GrapeCity
	������ʱ�䣺	2015-11-24
	���¼�¼˵����
	1.���� 2015-11-24
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_PolicyFactorRuleDelete]
	@PolicyFactConditionId NVARCHAR(10) ,	--�������ر��
	@ConditionValueDelete NVARCHAR(200) ,	--ɾ��ֵ
	@CurrUser NVARCHAR(36)					--�û�
AS
BEGIN
	CREATE TABLE #TAMP(
		ID NVARCHAR(500)	
	)
	DECLARE @ConditionValue NVARCHAR(MAX)
	DECLARE @iValue NVARCHAR(500)
	SELECT @ConditionValue=ISNULL(ConditionValue,'') FROM Promotion.PRO_POLICY_FACTOR_CONDITION_UI A WHERE A.PolicyFactorConditionId=@PolicyFactConditionId AND A.CurrUser=@CurrUser
	
	INSERT INTO #TAMP (ID)
	SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@ConditionValue,'|') WHERE VAL NOT IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@ConditionValueDelete,'|'))
	
	SET @ConditionValue=''
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
	SELECT ID FROM #TAMP
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @iValue
    WHILE @@FETCH_STATUS = 0        
        BEGIN 
          SET @ConditionValue=(ISNULL(@ConditionValue,'')+@iValue+'|')
        FETCH NEXT FROM @PRODUCT_CUR INTO @iValue
        END
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR ;
    
    UPDATE Promotion.PRO_POLICY_FACTOR_CONDITION_UI SET ConditionValue=@ConditionValue WHERE PolicyFactorConditionId=@PolicyFactConditionId AND CurrUser=@CurrUser
END


GO


