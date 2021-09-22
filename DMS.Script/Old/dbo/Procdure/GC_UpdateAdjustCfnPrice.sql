DROP PROCEDURE [dbo].[GC_UpdateAdjustCfnPrice]
GO

/*使用数据库事物控制*/
CREATE PROCEDURE [dbo].[GC_UpdateAdjustCfnPrice]
	@AdjustId uniqueidentifier,
	@DealerId uniqueidentifier,
	@ProductLineId uniqueidentifier,
	@AdjustType nvarchar(50),
	@ApplyType nvarchar(50),
	@UserId uniqueidentifier,
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
	
	SELECT @DealerType = DMA_DealerType FROM DealerMaster WHERE DMA_ID = @DealerId
	SELECT @OrderStatus = IAH_Status FROM InventoryAdjustHeader WHERE IAH_ID = @AdjustId
	
	--更新价格(提交时取最新的价格)
	IF (@AdjustType = 'Return' OR @AdjustType = 'Exchange') --AND @ApplyType = '4'
		BEGIN
			UPDATE C SET C.IAL_UnitPrice = dbo.fn_GetPriceForDealerRetrun(@DealerId ,PMA_CFN_ID,IAL_LotNumber, @ApplyType) 
			FROM InventoryAdjustHeader A
			INNER JOIN InventoryAdjustDetail B ON A.IAH_ID = B.IAD_IAH_ID
			INNER JOIN InventoryAdjustLot C ON B.IAD_ID = C.IAL_IAD_ID
			INNER JOIN Product D ON D.PMA_ID = B.IAD_PMA_ID
			WHERE A.IAH_ID = @AdjustId

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


