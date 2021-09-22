DROP procedure [interface].[P_I_EW_InitPoint_Approval]
GO

CREATE procedure [interface].[P_I_EW_InitPoint_Approval]
(
	@FlowId int ,
	@EWorkFlowNo nvarchar(30),
	@Status nvarchar(30),
	@ApprovalType int  --0代表接收到后回传，1代表审批结果
)
as 
begin
	DECLARE @SysUserId uniqueidentifier	
	DECLARE @DivisionName nvarchar(200)
	DECLARE	@ProductLineId uniqueidentifier
	DECLARE	@PointUseRangeType nvarchar(200)
	DECLARE	@PointUseRange nvarchar(max)
	DECLARE	@FlowNo nvarchar(200)
	DECLARE	@UseRangeCondition nvarchar(200)
	DECLARE	@DMA_ID uniqueidentifier
	DECLARE	@PointExpiredDate Datetime
	DECLARE	@Point DECIMAL(18,4)
	DECLARE @DLid INT
	DECLARE	@rkDescription nvarchar(max)
	DECLARE	@PointType nvarchar(200)
	Create table #tamp
	(
		DivisionName nvarchar(200),
		ProductLineId uniqueidentifier,
		PointUseRangeType nvarchar(200),
		PointUseRange nvarchar(max),
		FlowNo nvarchar(200),
		UseRangeCondition nvarchar(200),
		DMA_ID uniqueidentifier,
		PointExpiredDate Datetime,
		Point DECIMAL(18,4),
		rkDescription nvarchar(max),
		PointType nvarchar(200)
	)

	Update promotion.pro_initpoint_flow set Status = @Status where FlowID = @FlowId	
	
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
    VALUES (NEWID(),NEWID(),@SysUserId,GETDATE(),@Status,'eWorkflow'+@Status +'积分导入申请-'+CONVERT(NVARCHAR,@FlowId))
    
    IF @Status='审批通过'
    BEGIN
		INSERT into #tamp(DivisionName,ProductLineId,PointUseRangeType,PointUseRange,FlowNo,UseRangeCondition,DMA_ID,PointExpiredDate,rkDescription,PointType,Point)
		SELECT C.DivisionName,
		C.ProductLineID,
		A.PointUseRangeType,
		A.PointUseRange,
		A.FlowNo,
		A.UseRangeCondition 
		,CASE WHEN D.DMA_DealerType='T2' THEN D.DMA_Parent_DMA_ID ELSE D.DMA_ID END
		,CONVERT(NVARCHAR(10),b.PointExpiredDate,120)
		,A.[Description]
		,a.PointType
		,SUM(b.Point/ISNULL(b.Ratio,1))
		FROM PROMOTION.pro_initpoint_flow A 
		INNER JOIN PROMOTION.Pro_InitPoint_Flow_Detail B ON A.FlowId=B.FlowId
		INNER JOIN V_DivisionProductLineRelation C ON C.IsEmerging='0' AND A.BU=C.ProductLineName
		INNER JOIN DealerMaster D ON B.DealerId=D.DMA_ID
		WHERE A.FlowId=@FlowId
		GROUP BY C.DivisionName,C.ProductLineID,A.PointUseRangeType,A.PointUseRange,FlowNo,UseRangeCondition ,CASE WHEN D.DMA_DealerType='T2' THEN D.DMA_Parent_DMA_ID ELSE D.DMA_ID END,
		CONVERT(NVARCHAR(10),B.PointExpiredDate,120),A.[Description],A.PointType
		UNION
		SELECT C.DivisionName,
		C.ProductLineID,
		A.PointUseRangeType,
		A.PointUseRange,
		A.FlowNo,
		A.UseRangeCondition 
		, D.DMA_ID
		,CONVERT(NVARCHAR(10),b.PointExpiredDate,120)
		,A.[Description]
		,a.PointType
		,SUM(b.Point)
		FROM PROMOTION.pro_initpoint_flow A 
		INNER JOIN PROMOTION.Pro_InitPoint_Flow_Detail B ON A.FlowId=B.FlowId
		INNER JOIN V_DivisionProductLineRelation C ON C.IsEmerging='0' AND A.BU=C.ProductLineName
		INNER JOIN DealerMaster D ON B.DealerId=D.DMA_ID
		WHERE A.FlowId=@FlowId and d.DMA_DealerType='T2'
		GROUP BY C.DivisionName,C.ProductLineID,A.PointUseRangeType,A.PointUseRange,FlowNo,UseRangeCondition ,D.DMA_ID,
		CONVERT(NVARCHAR(10),B.PointExpiredDate,120),A.[Description],A.PointType
		
		DECLARE @iCURSOR CURSOR;
		SET @iCURSOR = CURSOR FOR SELECT DivisionName,ProductLineID,PointUseRangeType,PointUseRange,FlowNo,UseRangeCondition,DMA_ID,PointExpiredDate,Point,rkDescription,PointType FROM #tamp
		OPEN @iCURSOR 	
		FETCH NEXT FROM @iCURSOR INTO @DivisionName,@ProductLineID,@PointUseRangeType,@PointUseRange,@FlowNo,@UseRangeCondition,@DMA_ID,@PointExpiredDate,@Point,@rkDescription,@PointType
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @DLid=NULL;
			IF @PointUseRangeType='BU'--全产品线
			BEGIN
				SELECT @PointUseRange=STUFF(REPLACE(REPLACE((
					SELECT DISTINCT 'Level1,'+A.CFN_Level1Code RESULT FROM CFN A WHERE A.CFN_ProductLine_BUM_ID=@ProductLineID
				FOR XML AUTO), '<A RESULT="', '|'), '"/>', ''), 1, 1, '')
				SET @UseRangeCondition='3';
			END
			
			INSERT INTO Promotion.PRO_DEALER_POINT(DEALERID,PointType,BU,CreateTime,ModifyDate,Remark1)
				VALUES(@DMA_ID,'Point',@DivisionName,GETDATE(),GETDATE(),@rkDescription)
			SELECT @DLid=SCOPE_IDENTITY()
			
			INSERT INTO Promotion.PRO_DEALER_POINT_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
			VALUES(@DLid,@UseRangeCondition,'包含',@PointUseRange)
			
			INSERT INTO Promotion.PRO_DEALER_POINT_SUB(DLid,ValidDate,PointAmount,OrderAmount,OtherAmount,CreateTime,ModifyDate,Status,Remark1)
			VALUES(@DLid,@PointExpiredDate,@Point,0,0,getdate(),getdate(),'1',@FlowNo)
			
			INSERT INTO Promotion.PRO_DEALER_POINT_LOG(DLid,DLFrom,DEALERID,Amount,LogDate,Remark)
			VALUES(@DLid,@PointType,@DMA_ID,@Point,getdate(),@FlowNo)
			
			FETCH NEXT FROM @iCURSOR INTO @DivisionName,@ProductLineID,@PointUseRangeType,@PointUseRange,@FlowNo,@UseRangeCondition,@DMA_ID,@PointExpiredDate,@Point,@rkDescription,@PointType
		END	
		CLOSE @iCURSOR
		DEALLOCATE @iCURSOR
		
    END
end


GO


