DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_Closing_Single] 
GO


/**********************************************
	功能：单个促销政策关账
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
	2.修改 2015-12-01 增加了套装的逻辑
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
	DECLARE @ValidDate2 DATETIME; --平台积分有效期，从政策表中单独取得
	DECLARE @PointUseRange NVARCHAR(50);	--平台积分使用范围：BU,PRODUCT
	DECLARE @BUUseRange NVARCHAR(200);	--平台到BU的积分使用范围
	
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @SUM_STRING NVARCHAR(MAX);
	DECLARE @MSG NVARCHAR(100);
	
	SELECT 
		@Period = Period,
		@StartDate = StartDate,
		@CurrentPeriod = CurrentPeriod, --此时的值其实是上个期间
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
	  
	--得到当前计算的期间
	IF ISNULL(@CurrentPeriod,'') = ''
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate)
	END
	ELSE
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)
	END
	
	--正式计算表
	SET @TMPTable = Promotion.func_Pro_Utility_getPolicyTableName(@PolicyId,'TMP')
	
	IF NOT (@CalModule = '正式' AND @CalStatus = '成功')
	BEGIN
		INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
		SELECT @PolicyId,'正式','关账失败',@runPeriod,GETDATE(),GETDATE(),'非[正式]+[成功]，无法关账!'
		PRINT 'PolicyId='+CONVERT(NVARCHAR,@PolicyId)+',非[正式]+[成功]，无法关账!'
		
		RETURN
	END
	
--开始事务	
	BEGIN TRAN
	--***********将政策表中的CurrentPeriod、CalStatus、更新；******************************************************************
	UPDATE Promotion.PRO_POLICY SET 
		CurrentPeriod = @runPeriod,
		CalStatus = '已关账',
		StartTime = GETDATE(),
		EndTime = GETDATE()
	WHERE PolicyId = @PolicyId
	
	--****************************************备份历史*************************************************************************
	EXEC Promotion.Proc_Pro_MoveData_MoveHis @PolicyId
	
	--******************************更新计算表中的累计赠品字段(也可能是积分)*************************************************
	SET @SQL = 'UPDATE '+@TMPTable+' SET LargessTotal = LargessTotal +' + 'FinalLargess' + @runPeriod +','
		+'PointsTotal = PointsTotal +' + 'FinalPoints' + @runPeriod 
	PRINT @SQL
	EXEC(@SQL)
	 
	--******************************移动到正式表*******************************************************************************
	EXEC Promotion.Proc_Pro_MoveData @PolicyId,'TMP','REP'
	
	--******************************清空计算表********************************************************************************
	SET @SQL = 'DELETE FROM '+@TMPTable
	PRINT @SQL
	EXEC(@SQL)
	
	SET @MSG = '【'+@runPeriod+'】关账已成功！'
	INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
	SELECT @PolicyId,'正式','关账成功',@runPeriod,GETDATE(),GETDATE(),@MSG
	
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
    SET @vError = ISNULL(@error_procedure, '') + '第'
        + CONVERT(NVARCHAR(10), ISNULL(@error_line, '')) + '行出错[错误号：'
        + CONVERT(NVARCHAR(10), ISNULL(@error_number, '')) + ']，'
        + ISNULL(@error_message, '')
    
    PRINT 'Policyid = '+CONVERT(NVARCHAR,@PolicyId) +' Closing Failed!' 
    
    INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
		SELECT @PolicyId,'关账','失败',@runPeriod,GETDATE(),GETDATE(),@vError
        
END CATCH

GO


