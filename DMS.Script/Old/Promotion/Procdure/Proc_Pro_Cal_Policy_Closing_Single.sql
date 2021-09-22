DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_Closing_Single] 
GO


/**********************************************
	���ܣ������������߹���
	���ߣ�GrapeCity
	������ʱ�䣺	2015-08-31
	���¼�¼˵����
	1.���� 2015-08-31
	2.�޸� 2015-12-01 ��������װ���߼�
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_Closing_Single] 
	@PolicyId INT
AS
BEGIN TRY
	DECLARE @Period NVARCHAR(10);
	DECLARE @StartDate NVARCHAR(10);
	DECLARE @CurrentPeriod NVARCHAR(10);
	DECLARE @BU NVARCHAR(20);
	DECLARE @SUBBU NVARCHAR(20);
	DECLARE @runPeriod NVARCHAR(10);
	DECLARE @CalModule NVARCHAR(10);
	DECLARE @CalStatus NVARCHAR(10);
	DECLARE @ifConvert NVARCHAR(10);
	DECLARE @TMPTable NVARCHAR(50);
	DECLARE @PolicyStyle NVARCHAR(50);
	DECLARE @UseRangePolicyFactorId INT;
	DECLARE @ifCalRebateAR NVARCHAR(50);
	DECLARE @ValidDateColumn NVARCHAR(50);
	DECLARE @RatioColumn NVARCHAR(50);
	DECLARE @ValidDate2 DATETIME; --ƽ̨������Ч�ڣ������߱��е���ȡ��
	DECLARE @PointUseRange NVARCHAR(50);	--ƽ̨����ʹ�÷�Χ��BU,PRODUCT
	DECLARE @BUUseRange NVARCHAR(200);	--ƽ̨��BU�Ļ���ʹ�÷�Χ
	
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @SUM_STRING NVARCHAR(MAX);
	DECLARE @MSG NVARCHAR(100);
	
	SELECT 
		@Period = Period,
		@StartDate = StartDate,
		@CurrentPeriod = CurrentPeriod, --��ʱ��ֵ��ʵ���ϸ��ڼ�
		@CalModule = CalModule,
		@CalStatus = CalStatus,
		@ifConvert = ifConvert,
		@BU = BU,
		@SUBBU = ISNULL(SUBBU,''),
		@PolicyStyle = PolicyStyle,
		@ifCalRebateAR = ifCalRebateAR,
		@ValidDate2 = Promotion.func_Pro_Utility_getPointValidDate(Period,CalPeriod,PointValidDateType2,PointValidDateDuration2,PointValidDateAbsolute2),
		@PointUseRange = PointUseRange
	FROM Promotion.PRO_POLICY WHERE PolicyId = @PolicyId
	  
	--�õ���ǰ������ڼ�
	IF ISNULL(@CurrentPeriod,'') = ''
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate)
	END
	ELSE
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)
	END
	
	--��ʽ�����
	SET @TMPTable = Promotion.func_Pro_Utility_getPolicyTableName(@PolicyId,'TMP')
	
	IF NOT (@CalModule = '��ʽ' AND @CalStatus = '�ɹ�')
	BEGIN
		INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
		SELECT @PolicyId,'��ʽ','����ʧ��',@runPeriod,GETDATE(),GETDATE(),'��[��ʽ]+[�ɹ�]���޷�����!'
		PRINT 'PolicyId='+CONVERT(NVARCHAR,@PolicyId)+',��[��ʽ]+[�ɹ�]���޷�����!'
		
		RETURN
	END
	
--��ʼ����	
	BEGIN TRAN
	--***********�����߱��е�CurrentPeriod��CalStatus�����£�******************************************************************
	UPDATE Promotion.PRO_POLICY SET 
		CurrentPeriod = @runPeriod,
		CalStatus = '�ѹ���',
		StartTime = GETDATE(),
		EndTime = GETDATE()
	WHERE PolicyId = @PolicyId
	
	--****************************************������ʷ*************************************************************************
	EXEC Promotion.Proc_Pro_MoveData_MoveHis @PolicyId
	
	--******************************���¼�����е��ۼ���Ʒ�ֶ�(Ҳ�����ǻ���)*************************************************
	SET @SQL = 'UPDATE '+@TMPTable+' SET LargessTotal = LargessTotal +' + 'FinalLargess' + @runPeriod +','
		+'PointsTotal = PointsTotal +' + 'FinalPoints' + @runPeriod 
	PRINT @SQL
	EXEC(@SQL)
	 
	--******************************�ƶ�����ʽ��*******************************************************************************
	EXEC Promotion.Proc_Pro_MoveData @PolicyId,'TMP','REP'
	
	--******************************��ռ����********************************************************************************
	SET @SQL = 'DELETE FROM '+@TMPTable
	PRINT @SQL
	EXEC(@SQL)
	
	SET @MSG = '��'+@runPeriod+'�������ѳɹ���'
	INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
	SELECT @PolicyId,'��ʽ','���˳ɹ�',@runPeriod,GETDATE(),GETDATE(),@MSG
	
	PRINT 'Policyid = '+CONVERT(NVARCHAR,@PolicyId) +' Closing Success!' 
	
	COMMIT TRAN
END TRY
BEGIN CATCH
	DECLARE @error_number INT
    DECLARE @error_serverity INT
    DECLARE @error_state INT
    DECLARE @error_message NVARCHAR(256)
    DECLARE @error_line INT
    DECLARE @error_procedure NVARCHAR(256)
    DECLARE @vError NVARCHAR(1000)
    
    ROLLBACK TRAN
    
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
    
    PRINT 'Policyid = '+CONVERT(NVARCHAR,@PolicyId) +' Closing Failed!' 
    
    INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
		SELECT @PolicyId,'����','ʧ��',@runPeriod,GETDATE(),GETDATE(),@vError
        
END CATCH

GO


