DROP PROCEDURE [Promotion].[Proc_PolicyGroupClosing]
GO


/**********************************************
 ����:eWorkFlow����ͨ������ô�SP����ɶ�Ӧ���ߵĹ���
 ���ߣ�Grapecity
 ������ʱ�䣺 2015-11-23
 ���¼�¼˵����
 1.���� 2015-11-23
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_PolicyGroupClosing](
	@StingPolicyId NVARCHAR(max),
	@iReturn NVARCHAR(2000) = '' output 
	)
AS
BEGIN
	DECLARE @PolicyId INT;
	
	--����
	
	DECLARE @iCURSORClose CURSOR;
	SET @iCURSORClose = CURSOR FOR SELECT DISTINCT CONVERT(INT,val) AS PolicyId FROM dbo.GC_Fn_SplitStringToTable(@StingPolicyId,',')
	OPEN @iCURSORClose 	
	FETCH NEXT FROM @iCURSORClose INTO @PolicyId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--���ʲ����棬��˼�ʹ��������ʧ�ܣ�Ҳ��Ϊ����������
		EXEC PROMOTION.Proc_Pro_Cal_Policy_Closing @PolicyId
		
		FETCH NEXT FROM @iCURSORClose INTO @PolicyId
	END	
	CLOSE @iCURSORClose
	DEALLOCATE @iCURSORClose

	
	SET @iReturn ='Success'
	RETURN 
END


GO


