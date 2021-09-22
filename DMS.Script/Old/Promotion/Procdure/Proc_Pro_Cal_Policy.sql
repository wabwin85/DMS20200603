
DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Policy] 
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Policy] 
	@PolicyId INT
AS
BEGIN TRY
	DECLARE @CalModule NVARCHAR(20)
	DECLARE @PolicyFactorId INT
	DECLARE @isError NVARCHAR(10)
	
--STEP0检查是否可执行	
	EXEC PROMOTION.Proc_Pro_Cal_Policy_CheckBeforeRun @PolicyId,@isError OUTPUT
	IF @isError <> 'Y' RETURN
	
	UPDATE Promotion.PRO_POLICY SET StartTime = GETDATE() WHERE PolicyId = @PolicyId
	
--STEP1取得政策参数
	SELECT @CalModule = CalModule 
	FROM Promotion.PRO_POLICY WHERE PolicyId = @PolicyId
	
--STEP2移动数据
	IF @CalModule = '正式'
		EXEC Promotion.Proc_Pro_MoveData @PolicyId,'REP','TMP'
	ELSE
		EXEC Promotion.Proc_Pro_MoveData @PolicyId,'REP','CAL'
	
--STEP3放入经销商或经销商医院
	EXEC PROMOTION.Proc_Pro_Cal_InitDealerHospital @PolicyId

--STEP4前置处理
	EXEC PROMOTION.Proc_Pro_Cal_Policy_Before @PolicyId 
	
--STEP5计算因素
	--循环当前可计算因素
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT A.PolicyFactorId FROM PROMOTION.PRO_POLICY_FACTOR A,PROMOTION.PRO_FACTOR B
			WHERE A.FactId = B.FactId AND B.FactType = '条件因素' AND A.PolicyId = @PolicyId ORDER BY B.SortNo 
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @PolicyFactorId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC PROMOTION.Proc_Pro_Cal_Fact @PolicyFactorId
		
		FETCH NEXT FROM @iCURSOR INTO @PolicyFactorId
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
--STEP5.1计算因素后处理
	Print 'STEP5.1计算因素后处理'
	EXEC PROMOTION.Proc_Pro_Cal_Fact_After @PolicyId 
	
--STEP6规则计算
	Print 'STEP6规则计算'
	EXEC PROMOTION.Proc_Pro_Cal_Rule @PolicyId 
	
--STEP7后置处理
	Print 'STEP7后置处理'
	EXEC PROMOTION.Proc_Pro_Cal_Policy_After @PolicyId 

--STEP8更新政策表及LOG日志
	EXEC PROMOTION.Proc_Pro_Cal_Log @PolicyId,'成功',''
	
	PRINT 'Policyid = '+CONVERT(NVARCHAR,@PolicyId) +' Caculate Success!' 
	
END TRY
BEGIN CATCH
	DECLARE @error_number INT
    DECLARE @error_serverity INT
    DECLARE @error_state INT
    DECLARE @error_message NVARCHAR(256)
    DECLARE @error_line INT
    DECLARE @error_procedure NVARCHAR(256)
    DECLARE @vError NVARCHAR(1000)
    
    --ROLLBACK TRAN 
    SET @error_number = ERROR_NUMBER()
    SET @error_serverity = ERROR_SEVERITY()
    SET @error_state = ERROR_STATE()
    SET @error_message = ERROR_MESSAGE()
    SET @error_line = ERROR_LINE()
    SET @error_procedure = ERROR_PROCEDURE()
    SET @vError = ISNULL(@error_procedure, '') + '第'
        + CONVERT(NVARCHAR(10), ISNULL(@error_line, '')) + '行出错[错误号：'
        + CONVERT(NVARCHAR(10), ISNULL(@error_number, '')) + ']，'
        + ISNULL(@error_message, '')
    
    PRINT 'Policyid = '+CONVERT(NVARCHAR,@PolicyId) +' Caculate Failed!' 
        
    EXEC PROMOTION.Proc_Pro_Cal_Log @PolicyId,'失败',@vError
        
    --RAISERROR(@vError,@error_serverity,@error_state)
END CATCH

GO


