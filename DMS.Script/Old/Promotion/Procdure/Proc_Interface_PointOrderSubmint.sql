DROP PROCEDURE [Promotion].[Proc_Interface_PointOrderSubmint]
GO


/**********************************************
	功能：积分订单提交
	作者：GrapeCity
	最后更新时间：	2016-03-30
	更新记录说明：
	1.创建 2016-03-30
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_PointOrderSubmint]
	@POH_ID NVARCHAR(36),
	@RtnVal NVARCHAR(200) OUTPUT,
	@RtnMsg NVARCHAR(MAX) OUTPUT
WITH EXEC AS CALLER
AS	
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	--1. 重新绑定积分
	DECLARE @DMA_ID NVARCHAR(36)
	DECLARE @ProductLineId NVARCHAR(36)
	DECLARE @PointType NVARCHAR(100)
	DECLARE @DMA_Type NVARCHAR(20)
	
	SELECT @DMA_ID=A.POH_DMA_ID,@ProductLineId=A.POH_ProductLine_BUM_ID,@PointType=POH_PointType,@DMA_Type=c.DMA_DealerType FROM PurchaseOrderHeader A  
	INNER JOIN V_DivisionProductLineRelation B ON A.POH_ProductLine_BUM_ID=B.ProductLineID AND B.IsEmerging='0'  
	INNER JOIN DealerMaster C ON A.POH_DMA_ID=C.DMA_ID
	WHERE POH_ID=@POH_ID;
	
	IF @DMA_Type <>'T2'
	BEGIN
		EXEC PROMOTION.Proc_Interface_PointOrderCheck @POH_ID,@DMA_ID,@ProductLineId,@PointType,@RtnMsg
		
		--2. 扣减积分池
		UPDATE C SET C.OrderAmount=(ISNULL(OrderAmount,0)+D.SumAmount),C.ModifyDate=GETDATE()
		FROM Promotion.PRO_DEALER_POINT_SUB C,
		(SELECT A.PointDetailId,ISNULL(SUM(A.Amount),0) SumAmount FROM Promotion.PurchaseOrderPoint A 
		INNER JOIN PurchaseOrderDetail B ON A.POD_ID=B.POD_ID WHERE B.POD_POH_ID=@POH_ID GROUP BY PointDetailId) D WHERE C.id=D.PointDetailId
		
		--3. 记录Loge
		INSERT INTO Promotion.PRO_DEALER_POINT_LOG(DLid,DLFrom,DEALERID,MXID,Amount,LogDate)
		SELECT A.PointDetailId,'订单',C.POH_DMA_ID,C.POH_ID,-A.Amount,GETDATE() FROM Promotion.PurchaseOrderPoint A 
		INNER JOIN PurchaseOrderDetail B ON A.POD_ID=B.POD_ID 
		INNER JOIN PurchaseOrderHeader C ON C.POH_ID=B.POD_POH_ID
		WHERE B.POD_POH_ID=@POH_ID 
	END
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(MAX)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @RtnMsg = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	
    return -1
END CATCH


GO


