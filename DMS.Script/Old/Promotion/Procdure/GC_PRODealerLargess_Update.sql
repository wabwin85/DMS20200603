DROP PROCEDURE [Promotion].[GC_PRODealerLargess_Update]
GO




/**********************************************
	功能：扣减赠品池、记录Loge
	作者：GrapeCity
	最后更新时间：	2015-10-15
	更新记录说明：
	1.创建 2015-10-15
**********************************************/
CREATE PROCEDURE [Promotion].[GC_PRODealerLargess_Update]
	@PohId UNIQUEIDENTIFIER ,	--政策因素编号
	@OrderSubType NVARCHAR(100), --Submit:提交订单 ,Revoking:撤销订单 
	@RtnVal         NVARCHAR (20) OUTPUT,
    @RtnMsg         NVARCHAR (1000) OUTPUT
	
AS
	CREATE TABLE #Temp(
	   DLid INT ,
	   QTY DECIMAL (18, 6)
   )
   DECLARE @DealerId   UNIQUEIDENTIFIER
   DECLARE @DealerType nvarchar(50)
SET  NOCOUNT ON

BEGIN TRY
	BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SELECT @DealerId=a.POH_DMA_ID,@DealerType=b.DMA_DealerType FROM PurchaseOrderHeader a 
	inner join DealerMaster b on a.POH_DMA_ID=b.DMA_ID
	  WHERE a.POH_ID=@PohId
	
	
	IF @OrderSubType='Submit' and @DealerType <>'T2'
	BEGIN
		INSERT INTO #Temp (DLid,QTY)
		SELECT a.POD_Field3,SUM(A.POD_RequiredQty) FROM PurchaseOrderDetail A WHERE A.POD_POH_ID=@PohId GROUP BY A.POD_Field3
		
		UPDATE A SET OrderAmount=(OrderAmount +B.QTY)
		FROM Promotion.PRO_DEALER_LARGESS A 
			INNER JOIN #Temp B ON A.DLid=B.DLid
			
		INSERT INTO Promotion.PRO_DEALER_LARGESS_LOG (DLid,DLFrom,DEALERID,MXID,Amount,LogDate)
		SELECT a.POD_Field3,'订单',@DealerId,A.POD_ID,-A.POD_RequiredQty,GETDATE() FROM PurchaseOrderDetail A WHERE A.POD_POH_ID=@PohId
	END
	
	IF @OrderSubType='Revoking' and @DealerType <>'T2'
	BEGIN
		INSERT INTO #Temp (DLid,QTY)
		SELECT a.POD_Field3,-SUM(A.POD_RequiredQty) FROM PurchaseOrderDetail A WHERE A.POD_POH_ID=@PohId GROUP BY A.POD_Field3
		
		UPDATE A SET OrderAmount=(OrderAmount +B.QTY)
		FROM Promotion.PRO_DEALER_LARGESS A 
			INNER JOIN #Temp B ON A.DLid=B.DLid
			
		INSERT INTO Promotion.PRO_DEALER_LARGESS_LOG (DLid,DLFrom,DEALERID,MXID,Amount,LogDate)
		SELECT a.POD_Field3,'订单',@DealerId,A.POD_ID,A.POD_RequiredQty,GETDATE() FROM PurchaseOrderDetail A WHERE A.POD_POH_ID=@PohId
	END
	
	

  COMMIT TRAN
	SET  NOCOUNT OFF
	RETURN 1
END TRY
BEGIN CATCH
	SET  NOCOUNT OFF
	ROLLBACK TRAN
	SET @RtnVal = 'Failure'
	RETURN -1
END CATCH

GO


