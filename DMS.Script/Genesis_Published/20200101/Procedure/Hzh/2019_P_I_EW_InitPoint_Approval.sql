SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
ALTER procedure [interface].[P_I_EW_InitPoint_Approval]
(
	@FlowId int ,
	@EWorkFlowNo nvarchar(30),
	@Status nvarchar(30),
	@ApprovalType INT,  --0代表接收到后回传，1代表审批结果
	@ProductLineId NVARCHAR(50)
)
as 
begin
	DECLARE @SysUserId uniqueidentifier	
	DECLARE @DivisionName nvarchar(200)
	DECLARE	@DivisionCode nvarchar(200)
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
		DivisionCode nvarchar(200),
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
	DECLARE @temp table ( Code NVARCHAR(50) )

	Update promotion.pro_initpoint_flow set Status = @Status where FlowID = @FlowId	
	
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
    VALUES (NEWID(),NEWID(),@SysUserId,GETDATE(),@Status,'eWorkflow'+@Status +'积分导入申请-'+CONVERT(NVARCHAR,@FlowId))
    
    IF @Status='审批通过'
    BEGIN
		INSERT into #tamp(DivisionName,DivisionCode,PointUseRangeType,PointUseRange,FlowNo,UseRangeCondition,DMA_ID,PointExpiredDate,rkDescription,PointType,Point)
		SELECT C.DivisionName,
		C.DivisionCode,
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
		GROUP BY C.DivisionName,C.DivisionCode,A.PointUseRangeType,A.PointUseRange,FlowNo,UseRangeCondition ,CASE WHEN D.DMA_DealerType='T2' THEN D.DMA_Parent_DMA_ID ELSE D.DMA_ID END,
		CONVERT(NVARCHAR(10),B.PointExpiredDate,120),A.[Description],A.PointType
		UNION
		SELECT C.DivisionName,
		C.DivisionCode,
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
		GROUP BY C.DivisionName,C.DivisionCode,A.PointUseRangeType,A.PointUseRange,FlowNo,UseRangeCondition ,D.DMA_ID,
		CONVERT(NVARCHAR(10),B.PointExpiredDate,120),A.[Description],A.PointType
		
		DECLARE @iCURSOR CURSOR;
		SET @iCURSOR = CURSOR FOR SELECT DivisionName,DivisionCode,PointUseRangeType,PointUseRange,FlowNo,UseRangeCondition,DMA_ID,PointExpiredDate,Point,rkDescription,PointType FROM #tamp
		OPEN @iCURSOR 	
		FETCH NEXT FROM @iCURSOR INTO @DivisionName,@DivisionCode,@PointUseRangeType,@PointUseRange,@FlowNo,@UseRangeCondition,@DMA_ID,@PointExpiredDate,@Point,@rkDescription,@PointType
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @DLid=NULL;
			
			INSERT INTO Promotion.PRO_DEALER_POINT(DEALERID,PointType,BU,CreateTime,ModifyDate,Remark1)
			VALUES(@DMA_ID,'Point',@DivisionName,GETDATE(),GETDATE(),@rkDescription)
			SELECT @DLid=SCOPE_IDENTITY()
			
							--PRINT(@DivisionCode)
			IF @PointUseRangeType='BU'--全产品线
			BEGIN
			    --原波科代码
				--SELECT @PointUseRange=STUFF(REPLACE(REPLACE((
				--	SELECT DISTINCT 'Level1,'+CONVERT(NVARCHAR(50),A.ProductLineID1) RESULT FROM interface.T_I_MDS_LocalProductMaster  A WHERE CONVERT(NVARCHAR(10),A.DivisionID)=@DivisionCode
				--FOR XML AUTO), '<A RESULT="', '|'), '"/>', ''), 1, 1, '')
				--原波科代码
				--20191230 add
				DELETE FROM @temp
				INSERT INTO @temp
						(Code )
				SELECT CASE WHEN ISNULL(T_CFN.CFN_Level1Code,'')='' THEN 'UPN,'+T_CFN.CFN_CustomerFaceNbr
				ELSE 'Level1,'+T_CFN.CFN_Level1Code END Code
				 FROM dbo.CFN T_CFN
				WHERE EXISTS(
			    	SELECT 1 FROM dbo.CfnClassification T_CFNClassification 
				    INNER JOIN dbo.V_ProductClassificationStructure V_ClassificationStructure ON T_CFNClassification.ClassificationId=V_ClassificationStructure.CA_ID
				    WHERE T_CFNClassification.CfnCustomerFaceNbr=T_CFN.CFN_CustomerFaceNbr
				    AND V_ClassificationStructure.CC_ProductLineID=@ProductLineId
				    )
			    SELECT @PointUseRange=STUFF((SELECT '|' + Code FROM @temp GROUP BY Code FOR XML PATH('')),1,1,'') 

				SET @UseRangeCondition='3';
						
				INSERT INTO Promotion.PRO_DEALER_POINT_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
				VALUES(@DLid,@UseRangeCondition,'包含',@PointUseRange)
			END
			ELSE
			BEGIN
				INSERT INTO Promotion.PRO_DEALER_POINT_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
				SELECT @DLid,OperTag,RangeType,PointUseRange FROM Promotion.Pro_InitPoint_Flow_UPN WHERE FlowId=@FlowId
			END
			
			INSERT INTO Promotion.PRO_DEALER_POINT_SUB(DLid,ValidDate,PointAmount,OrderAmount,OtherAmount,CreateTime,ModifyDate,Status,Remark1)
			VALUES(@DLid,@PointExpiredDate,@Point,0,0,getdate(),getdate(),'1',@FlowNo)
			
			INSERT INTO Promotion.PRO_DEALER_POINT_LOG(DLid,DLFrom,DEALERID,Amount,LogDate,Remark)
			VALUES(@DLid,@PointType,@DMA_ID,@Point,getdate(),@FlowNo)
			
			FETCH NEXT FROM @iCURSOR INTO @DivisionName,@DivisionCode,@PointUseRangeType,@PointUseRange,@FlowNo,@UseRangeCondition,@DMA_ID,@PointExpiredDate,@Point,@rkDescription,@PointType
		END	
		CLOSE @iCURSOR
		DEALLOCATE @iCURSOR
		
    END
end







GO

