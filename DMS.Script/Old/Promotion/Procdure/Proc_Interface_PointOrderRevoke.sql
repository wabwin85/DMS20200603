DROP PROCEDURE [Promotion].[Proc_Interface_PointOrderRevoke]
GO


/**********************************************
	功能：积分订单撤销
	作者：GrapeCity
	最后更新时间：	2016-03-30
	更新记录说明：
	1.创建 2016-03-30
	2.只能整单撤销
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_PointOrderRevoke]
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
	
	--1. 积分池恢复积分
	UPDATE C SET C.OrderAmount=(ISNULL(OrderAmount,0)-D.SumAmount),C.ModifyDate=GETDATE()
	FROM Promotion.PRO_DEALER_POINT_SUB C,
	(SELECT A.PointDetailId,ISNULL(SUM(A.Amount),0) SumAmount FROM Promotion.PurchaseOrderPoint A 
	INNER JOIN PurchaseOrderDetail B ON A.POD_ID=B.POD_ID WHERE B.POD_POH_ID=@POH_ID GROUP BY PointDetailId) D WHERE C.id=D.PointDetailId
	
	--2. 记录Loge
	INSERT INTO Promotion.PRO_DEALER_POINT_LOG(DLid,DLFrom,DEALERID,MXID,Amount,LogDate)
	SELECT A.PointDetailId,'订单',C.POH_DMA_ID,C.POH_ID,A.Amount,GETDATE() FROM Promotion.PurchaseOrderPoint A 
	INNER JOIN PurchaseOrderDetail B ON A.POD_ID=B.POD_ID 
	INNER JOIN PurchaseOrderHeader C ON C.POH_ID=B.POD_POH_ID
	WHERE B.POD_POH_ID=@POH_ID 
	
	--3. 删除积分使用表
	DELETE A FROM Promotion.PurchaseOrderPoint A INNER JOIN PurchaseOrderDetail B ON A.POD_ID=B.POD_ID WHERE B.POD_POH_ID=@POH_ID
	
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


