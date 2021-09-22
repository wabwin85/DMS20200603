
DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Policy] 
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Policy] 
	@PolicyId INT
AS
BEGIN TRY
	DECLARE @CalModule NVARCHAR(20)
	DECLARE @PolicyFactorId INT
	DECLARE @isError NVARCHAR(10)
	
--STEP0����Ƿ��ִ��	
	EXEC PROMOTION.Proc_Pro_Cal_Policy_CheckBeforeRun @PolicyId,@isError OUTPUT
	IF @isError <> 'Y' RETURN
	
	UPDATE Promotion.PRO_POLICY SET StartTime = GETDATE() WHERE PolicyId = @PolicyId
	
--STEP1ȡ�����߲���
	SELECT @CalModule = CalModule 
	FROM Promotion.PRO_POLICY WHERE PolicyId = @PolicyId
	
--STEP2�ƶ�����
	IF @CalModule = '��ʽ'
		EXEC Promotion.Proc_Pro_MoveData @PolicyId,'REP','TMP'
	ELSE
		EXEC Promotion.Proc_Pro_MoveData @PolicyId,'REP','CAL'
	
--STEP3���뾭���̻�����ҽԺ
	EXEC PROMOTION.Proc_Pro_Cal_InitDealerHospital @PolicyId

--STEP4ǰ�ô���
	EXEC PROMOTION.Proc_Pro_Cal_Policy_Before @PolicyId 
	
--STEP5��������
	--ѭ����ǰ�ɼ�������
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT A.PolicyFactorId FROM PROMOTION.PRO_POLICY_FACTOR A,PROMOTION.PRO_FACTOR B
			WHERE A.FactId = B.FactId AND B.FactType = '��������' AND A.PolicyId = @PolicyId ORDER BY B.SortNo 
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @PolicyFactorId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC PROMOTION.Proc_Pro_Cal_Fact @PolicyFactorId
		
		FETCH NEXT FROM @iCURSOR INTO @PolicyFactorId
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
--STEP5.1�������غ���
	Print 'STEP5.1�������غ���'
	EXEC PROMOTION.Proc_Pro_Cal_Fact_After @PolicyId 
	
--STEP6�������
	Print 'STEP6�������'
	EXEC PROMOTION.Proc_Pro_Cal_Rule @PolicyId 
	
--STEP7���ô���
	Print 'STEP7���ô���'
	EXEC PROMOTION.Proc_Pro_Cal_Policy_After @PolicyId 

--STEP8�������߱�LOG��־
	EXEC PROMOTION.Proc_Pro_Cal_Log @PolicyId,'�ɹ�',''
	
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
    SET @vError = ISNULL(@error_procedure, '') + '��'
        + CONVERT(NVARCHAR(10), ISNULL(@error_line, '')) + '�г���[����ţ�'
        + CONVERT(NVARCHAR(10), ISNULL(@error_number, '')) + ']��'
        + ISNULL(@error_message, '')
    
    PRINT 'Policyid = '+CONVERT(NVARCHAR,@PolicyId) +' Caculate Failed!' 
        
    EXEC PROMOTION.Proc_Pro_Cal_Log @PolicyId,'ʧ��',@vError
        
    --RAISERROR(@vError,@error_serverity,@error_state)
END CATCH

GO


