DROP PROCEDURE [dbo].[GC_ReturnAdjustSubmit_Before]
GO


/*使用业务层的事物统一管理*/
CREATE PROCEDURE [dbo].[GC_ReturnAdjustSubmit_Before]
	@AdjustId uniqueidentifier,
	@AdjustNo nvarchar(200),
	@AdjustDesc nvarchar(2000),
	@DealerId uniqueidentifier,
	@ProductLineId uniqueidentifier,
	@AdjustType nvarchar(50),
	@ApplyType nvarchar(50),
	@UserId uniqueidentifier,
	@UserName  nvarchar(50),
	@RtnVal nvarchar(50) OUTPUT,
	@RtnMsg nvarchar(2000) OUTPUT 
AS	
SET NOCOUNT ON
BEGIN TRY

	DECLARE @SysUserId uniqueidentifier
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	DECLARE @DealerType NVARCHAR(50)
	DECLARE @OrderStatus NVARCHAR(50)
	
	DECLARE @SubmitBeginDate DATETIME
	DECLARE @SubmitEndDate DATETIME

	DECLARE @ExpBeginDate DATETIME
	DECLARE @ExpEndDate DATETIME
	
	SELECT @DealerType = DMA_DealerType FROM DealerMaster WHERE DMA_ID = @DealerId
	SELECT @OrderStatus = IAH_Status FROM InventoryAdjustHeader WHERE IAH_ID = @AdjustId
	
	----更新价格(提交时取最新的价格)
	--IF (@AdjustType = 'Return' OR @AdjustType = 'Exchange') AND @ApplyType = '4'
	--	BEGIN
	--		UPDATE C SET C.IAL_UnitPrice = dbo.fn_GetPriceForDealerRetrun(@DealerId ,PMA_CFN_ID,IAL_LotNumber, @ApplyType) 
	--		FROM InventoryAdjustHeader A
	--		INNER JOIN InventoryAdjustDetail B ON A.IAH_ID = B.IAD_IAH_ID
	--		INNER JOIN InventoryAdjustLot C ON B.IAD_ID = C.IAL_IAD_ID
	--		INNER JOIN Product D ON D.PMA_ID = B.IAD_PMA_ID
	--		WHERE A.IAH_ID = @AdjustId

	--	END
		
		SELECT @SubmitBeginDate = MIN(DRP_SubmitBeginDate),
			@SubmitEndDate = MIN(DRP_SubmitEndDate),
			@ExpBeginDate = MIN(DRP_ExpBeginDate),
			@ExpEndDate = MIN(DRP_ExpEndDate)
			FROM dbo.DealerReturnPosition
			WHERE DRP_IsActived = 1
				--AND DRP_IsInit = 1
				AND DRP_DMA_ID = @DealerId
				AND DRP_BUM_ID = @ProductLineId
				AND DRP_Type In ('调整数据','初始数据')
				AND YEAR(DRP_SubmitBeginDate)=(CASE WHEN datepart(quarter,GETDATE() )>1 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1 END)
				
		--目前只检验退货类型为：“合同约定条款内的”的数据校验
		--非退货类型为：“合同约定条款内的”的单据均返回成功
		--T2是不允许有“合同约定条款内的”的单据提交的
		--不允许有0价格或者无价格的库存产品提交
		--不允许未过期的库存产品提交
		--产品效期距提交日期有2季度及以上，需要上传附件文件
		--提交时间必须是在提交范围内
		--退货产品有效期必须是在效期范围内
		IF (@AdjustType = 'Return' OR @AdjustType = 'Exchange') AND @ApplyType = '4'
			BEGIN
				IF @OrderStatus != 'Draft'
					BEGIN
						SET @RtnVal = 'Error'
						SET @RtnMsg = '单据已提交，请刷新页面'
						RETURN 1
					END
				ELSE IF @DealerType = 'T2'
					BEGIN
						SET @RtnVal = 'Error'
						SET @RtnMsg = '只适用于平台和一级经销商'
						RETURN 1
					END
				ELSE IF (SELECT COUNT(1) FROM InventoryAdjustHeader,InventoryAdjustDetail,InventoryAdjustLot 
							WHERE IAH_ID = IAD_IAH_ID AND IAD_ID = IAL_IAD_ID 
							AND IAH_ID = @AdjustId AND ISNULL(IAL_UnitPrice,0) = 0) > 0
					BEGIN
						SET @RtnVal = 'Error'
						SET @RtnMsg = '不允许有0价格或者无价格的产品'
						RETURN 1
					END
				ELSE IF (SELECT COUNT(1) FROM InventoryAdjustHeader,InventoryAdjustDetail,InventoryAdjustLot
							WHERE IAH_ID = IAD_IAH_ID AND IAD_ID = IAL_IAD_ID 
							AND IAH_ID = @AdjustId AND CONVERT(NVARCHAR(10),IAL_ExpiredDate,112) > CONVERT(NVARCHAR(10),GETDATE(),112)) > 0
					BEGIN
						SET @RtnVal = 'Error'
						SET @RtnMsg = '[合同约定条款内的]的退换货申请单中只允许提交过效期的产品'
						RETURN 1
					END
				ELSE IF GETDATE() < @SubmitBeginDate OR GETDATE() > @SubmitEndDate
					BEGIN
						SET @RtnVal = 'Error'
						SET @RtnMsg = '当前提交时间不在合同设置范围内'
						RETURN 1
					END
				ELSE IF (SELECT COUNT(1) FROM InventoryAdjustHeader,InventoryAdjustDetail,InventoryAdjustLot
							WHERE IAH_ID = IAD_IAH_ID AND IAD_ID = IAL_IAD_ID 
							AND IAH_ID = @AdjustId 
							AND (CONVERT(NVARCHAR(10),IAL_ExpiredDate,112) < CONVERT(NVARCHAR(10),@ExpBeginDate,112)
							OR CONVERT(NVARCHAR(10),IAL_ExpiredDate,112) > CONVERT(NVARCHAR(10),@ExpEndDate,112))) > 0
					BEGIN
						PRINT 'Error'
						SET @RtnVal = 'Error'
						SET @RtnMsg = '产品效期不在合同规定的范围内'
						RETURN 1
					END
				ELSE IF (SELECT COUNT(1) FROM InventoryAdjustHeader,InventoryAdjustDetail,InventoryAdjustLot
							WHERE IAH_ID = IAD_IAH_ID AND IAD_ID = IAL_IAD_ID 
							AND IAH_ID = @AdjustId AND DATEDIFF(QUARTER,IAL_ExpiredDate,GETDATE()) >= 2) > 0
						AND (SELECT COUNT(1) FROM Attachment WHERE AT_Main_ID = @AdjustId AND AT_Type = 'ReturnAdjust') = 0
					BEGIN
						SET @RtnVal = 'Error'
						SET @RtnMsg = '[合同约定条款内的]的退换货申请单中存在距离当前时间大于等于2个季度的产品，需要上传附件文件'
						RETURN 1
					END
				ELSE 
					BEGIN
						--总的退货额度金额
						DECLARE @TotalAmount DECIMAL(18,6)
						--此单据总的退货金额
						DECLARE @ReturnAmount DECIMAL(18,6)

						SET @TotalAmount = 0
						SET @ReturnAmount = 0

						SELECT @TotalAmount = ISNULL(SUM(ISNULL(DRP_DetailAmount,0)),0) FROM DealerReturnPosition
						WHERE DRP_BUM_ID = @ProductLineId
							AND DRP_DMA_ID = @DealerId
							AND DRP_IsActived = 1

						SELECT @ReturnAmount = ISNULL(SUM(ISNULL(IAL_LotQty,0)*ISNULL(IAL_UnitPrice,0)),0) FROM InventoryAdjustHeader
						INNER JOIN InventoryAdjustDetail ON IAH_ID = IAD_IAH_ID
						INNER JOIN InventoryAdjustLot ON IAD_ID = IAL_IAD_ID
						WHERE IAH_ID = @AdjustId

						IF @TotalAmount < @ReturnAmount
							BEGIN
								SET @RtnVal = 'Error'
								SET @RtnMsg = '本次退货总金额超过了退货额度'
								RETURN 1
							END 
						ELSE 
							BEGIN
								INSERT INTO [dbo].[DealerReturnPosition]
										   ([DRP_ID]
										   ,[DRP_DMA_ID]
										   ,[DRP_BUM_ID]
										   ,[DRP_Year]
										   ,[DRP_Quarter]
										   ,[DRP_DetailAmount]
										   ,[DRP_IsInit]
										   ,[DRP_ReturnId]
										   ,[DRP_ReturnNo]
										   ,[DRP_ReturnLotId]
										   ,[DRP_Sku]
										   ,[DRP_LotNumber]
										   ,[DRP_QrCode]
										   ,[DRP_ReturnQty]
										   ,[DRP_Price]
										   ,[DRP_Type]
										   ,[DRP_Desc]
										   ,[DRP_REV1]
										   ,[DRP_REV2]
										   ,[DRP_REV3]
										   ,[DRP_CreateDate]
										   ,[DRP_CreateUser]
										   ,[DRP_CreateUserName]
										   ,[DRP_IsActived])
								SELECT NEWID(),
										@DealerId,
										@ProductLineId,
										YEAR(GETDATE()),
										DATEPART(QUARTER,GETDATE()),
										-1*ISNULL(IAL_LotQty,0)*ISNULL(IAL_UnitPrice,0),
										0,
										@AdjustId,
										@AdjustNo,
										IAL_ID,
										CFN_CustomerFaceNbr,
										CASE WHEN CHARINDEX('@@',IAL_LotNumber) > 0 THEN substring(IAL_LotNumber,1,CHARINDEX('@@',IAL_LotNumber)-1) ELSE IAL_LotNumber END,
										CASE WHEN CHARINDEX('@@',IAL_LotNumber) > 0 THEN substring(IAL_LotNumber,CHARINDEX('@@',IAL_LotNumber)+2,LEN(IAL_LotNumber)-CHARINDEX('@@',IAL_LotNumber)) ELSE 'NoQR' END,
										IAL_LotQty,
										IAL_UnitPrice,
										'退货提交',
										'退货提交扣减',
										@AdjustDesc,
										NULL,
										NULL,
										GETDATE(),
										@UserId,
										@UserName,
										1
									FROM InventoryAdjustHeader
										INNER JOIN InventoryAdjustDetail ON IAH_ID = IAD_IAH_ID
										INNER JOIN InventoryAdjustLot ON IAD_ID = IAL_IAD_ID
										INNER JOIN Product ON PMA_ID = IAD_PMA_ID
										INNER JOIN CFN ON CFN_ID = PMA_CFN_ID
									WHERE IAH_ID = @AdjustId
							END
			
					END
			END
		ELSE 
			BEGIN
				SET @RtnVal = 'Success'
				SET @RtnMsg = ''
				RETURN 1
			END

SET NOCOUNT OFF
RETURN 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    SET @RtnVal = 'Failure'
    
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '1行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	
    return -1
    
END CATCH

GO


