DROP PROCEDURE [Promotion].[Proc_PolicyGroupClosing]
GO


/**********************************************
 功能:eWorkFlow审批通过后调用此SP，完成对应政策的关帐
 作者：Grapecity
 最后更新时间： 2015-11-23
 更新记录说明：
 1.创建 2015-11-23
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_PolicyGroupClosing](
	@StingPolicyId NVARCHAR(max),
	@iReturn NVARCHAR(2000) = '' output 
	)
AS
BEGIN
	DECLARE @PolicyId INT;
	
	--关帐
	
	DECLARE @iCURSORClose CURSOR;
	SET @iCURSORClose = CURSOR FOR SELECT DISTINCT CONVERT(INT,val) AS PolicyId FROM dbo.GC_Fn_SplitStringToTable(@StingPolicyId,',')
	OPEN @iCURSORClose 	
	FETCH NEXT FROM @iCURSORClose INTO @PolicyId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--关帐不可逆，因此即使部分政策失败，也认为审批结束了
		EXEC PROMOTION.Proc_Pro_Cal_Policy_Closing @PolicyId
		
		FETCH NEXT FROM @iCURSORClose INTO @PolicyId
	END	
	CLOSE @iCURSORClose
	DEALLOCATE @iCURSORClose

	
	SET @iReturn ='Success'
	RETURN 
END


GO


