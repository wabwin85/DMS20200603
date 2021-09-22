
DROP PROCEDURE [Promotion].[Proc_Pro_EWorkFlowFinish]
GO


CREATE PROCEDURE [Promotion].[Proc_Pro_EWorkFlowFinish](
	@FlowId INT,	--主键ID
	@Status nvarchar(20),
	@WFCode nvarchar(20),
	@iReturn NVARCHAR(2000) = '' output 
	)
AS
BEGIN

	SELECT @WFCode =A.WFCode FROM Promotion.T_Pro_Flow A WHERE FlowId = @FlowId
	
	IF NOT EXISTS (SELECT 1 FROM Promotion.T_Pro_Flow WHERE FlowId = @FlowId AND STATUS ='审批中')
	BEGIN
		SET @iReturn ='DMS促销申请记录有误!'
		PRINT @iReturn
		
		INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
		SELECT 0,'审批','错误',NULL,GETDATE(),GETDATE(),'FlowId='+CONVERT(NVARCHAR,@FlowId)+' '+@iReturn
		
		RETURN
	END
	IF (@Status= '审批通过')
	BEGIN
	SELECT @iReturn = STUFF(REPLACE(REPLACE((
		SELECT DISTINCT C.PolicyNo FROM Promotion.T_Pro_Flow a,Promotion.T_Pro_Flow_Detail b,Promotion.Pro_Policy C
		WHERE a.FlowId = @FlowId
		AND a.FlowId = b.FlowId AND b.PolicyId = c.PolicyId
		AND (a.AccountMonth <> c.CalPeriod OR NOT (C.CalModule ='正式' AND C.CalStatus = '成功'))
		FOR XML AUTO), '<C PolicyNo="',';'), '"/>', ''), 1, 1, '')
	IF ISNULL(@iReturn,'') <> ''
	BEGIN
		SET @iReturn = 'DMS促销申请记录中有部分政策与申请不一致，政策编号：' + @iReturn
		PRINT @iReturn
		
		INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
		SELECT 0,'审批','错误',NULL,GETDATE(),GETDATE(),'FlowId='+CONVERT(NVARCHAR,@FlowId)+' '+@iReturn
		
		RETURN
	END
	
	--根据审批表中的记录更新每个政策动态表中的调整数量
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @PolicyId INT;
	DECLARE @TempTableName NVARCHAR(50);
	DECLARE @CalPeriod NVARCHAR(50);
	DECLARE @CalType NVARCHAR(50);
	DECLARE @ProType NVARCHAR(50);
	SELECT @ProType=A.FlowType FROM Promotion.T_Pro_Flow A WHERE A.FlowId=@FlowId
	
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT DISTINCT C.PolicyId,C.CalPeriod,C.CalType,C.TempTableName
		FROM Promotion.T_Pro_Flow a,Promotion.T_Pro_Flow_Detail b,Promotion.Pro_Policy C
		WHERE a.FlowId = @FlowId
		AND a.FlowId = b.FlowId AND b.PolicyId = c.PolicyId
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @PolicyId,@CalPeriod,@CalType,@TempTableName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ProType='积分'
		BEGIN
			SET @SQL = N'UPDATE C SET FinalPoints'+@CalPeriod+' = B.AdjustNum  ,ValidDate'+@CalPeriod+' =A.EndDate  ,Ratio'+@CalPeriod+' =b.Ratio
			FROM '+@TempTableName+' C,Promotion.T_Pro_Flow a,Promotion.T_Pro_Flow_Detail b
			WHERE A.FlowId = b.FlowId AND a.FlowId = '+CONVERT(NVARCHAR,@FlowId)+' AND b.PolicyId = '+CONVERT(NVARCHAR,@PolicyId)+'
			AND C.DealerId = b.DealerId '+CASE @CalType WHEN 'ByDealer' THEN '' ELSE ' AND C.HospitalId = B.HospitalId' END
		END
		ELSE
		BEGIN
		SET @SQL = N'UPDATE C SET FinalLargess'+@CalPeriod+' = B.AdjustNum
			FROM '+@TempTableName+' C,Promotion.T_Pro_Flow a,Promotion.T_Pro_Flow_Detail b
			WHERE A.FlowId = b.FlowId AND a.FlowId = '+CONVERT(NVARCHAR,@FlowId)+' AND b.PolicyId = '+CONVERT(NVARCHAR,@PolicyId)+'
			AND C.DealerId = b.DealerId '+CASE @CalType WHEN 'ByDealer' THEN '' ELSE ' AND C.HospitalId = B.HospitalId' END
		END	
		BEGIN TRY
			EXEC(@SQL)	
		END TRY
		BEGIN CATCH
			SET @iReturn ='在更新政策计算表调整数时出错：政策流水号：'+CONVERT(NVARCHAR,@PolicyId)
			PRINT @iReturn
			
			INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
			SELECT 0,'审批','错误',NULL,GETDATE(),GETDATE(),'FlowId='+CONVERT(NVARCHAR,@FlowId)+' '+@iReturn
			
			RETURN
		END CATCH		
		
		FETCH NEXT FROM @iCURSOR INTO @PolicyId,@CalPeriod,@CalType,@TempTableName
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	 
	--关帐
	/*
	DECLARE @iCURSORClose CURSOR;
	SET @iCURSORClose = CURSOR FOR SELECT DISTINCT b.PolicyId
		FROM Promotion.T_Pro_Flow a,Promotion.T_Pro_Flow_Detail b
		WHERE a.FlowId = @FlowId AND a.FlowId = b.FlowId
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
	*/
	
	
	UPDATE Promotion.T_Pro_Flow SET STATUS = '审批通过',ModifyBy = 'eWorkFlow',ModifyDate = getdate(),WFCode=@WFCode
	WHERE FlowId = @FlowId
	
	END
	ELSE
	BEGIN
		UPDATE Promotion.T_Pro_Flow SET STATUS = '审批拒绝',ModifyBy = 'eWorkFlow',ModifyDate = getdate(),WFCode=@WFCode
		WHERE FlowId = @FlowId
	END
	
	SET @iReturn ='Success'
	RETURN 
END


GO


