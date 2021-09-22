DROP Procedure [dbo].[GC_PurchaseOrder_AddCfnSet]
GO

/*
订单批量添加成套产品
*/
CREATE Procedure [dbo].[GC_PurchaseOrder_AddCfnSet]
    @PohId uniqueidentifier,
	@DealerId uniqueidentifier,
	@CfnString NVARCHAR(1000),
    @RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(1000) OUTPUT
AS
    DECLARE @ErrorCount INTEGER
	DECLARE @CfnId uniqueidentifier
	DECLARE @CfnQty decimal(18,6)
	DECLARE @ArticleNumber NVARCHAR(200)
	/*将传递进来的CFNID字符串转换成纵表*/
	DECLARE CfnCursor CURSOR FOR 
		SELECT C.CFN_ID,C.CFN_CustomerFaceNbr AS ArticleNumber,SUM(S.SET_QTY*D.CSD_Default_Quantity) AS CFN_QTY
		FROM (SELECT 
				LEFT(VAL,CHARINDEX('|',VAL)-1) AS SET_ID,
				CONVERT(DECIMAL(18,6),SUBSTRING(VAL,CHARINDEX('|',VAL)+1,LEN(VAL)-CHARINDEX('|',VAL))) AS SET_QTY
				FROM dbo.GC_Fn_SplitStringToTable(@CfnString,',') A) AS S
		INNER JOIN CFNSetDetail AS D ON D.CSD_CFNS_ID = S.SET_ID
		INNER JOIN CFN C ON C.CFN_ID = D.CSD_CFN_ID
		GROUP BY C.CFN_ID,C.CFN_CustomerFaceNbr
	DECLARE @Price decimal(18,6)	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	OPEN CfnCursor
	FETCH NEXT FROM CfnCursor INTO @CfnId,@ArticleNumber,@CfnQty
	WHILE @@FETCH_STATUS = 0
		BEGIN
			--检查产品授权
			IF dbo.GC_Fn_CFN_CheckDealerAuth(@DealerId,@CfnId) = 1
				BEGIN
					--检查是否可订购
					IF dbo.GC_Fn_CFN_CheckDealerCanOrder(@DealerId,@CfnId) = 1
						BEGIN
							--取得产品标准价格
							--SELECT @Price = CFNP_Price FROM CFNPrice WHERE CFNP_CFN_ID = @CfnId AND CFNP_PriceType = 'Base' AND CFNP_DeletedFlag = 0						
							SELECT @Price = dbo.fn_GetPriceByDealerForPO(@DealerId,@CfnId)
							--检查产品是否已经添加
							IF EXISTS (SELECT 1 FROM PurchaseOrderDetail WHERE POD_POH_ID = @PohId AND POD_CFN_ID = @CfnId)
								--若已经添加该产品，则累加数量和金额
								UPDATE PurchaseOrderDetail 
									SET POD_CFN_Price = @Price,
										POD_RequiredQty = POD_RequiredQty + @CfnQty,
										POD_Amount = (POD_RequiredQty + @CfnQty) * @Price,
										POD_Tax = (POD_RequiredQty + @CfnQty) * @Price * 0.17
								WHERE POD_POH_ID = @PohId AND POD_CFN_ID = @CfnId
							ELSE
								--新增产品，默认数量1
								INSERT INTO PurchaseOrderDetail(POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_UOM,POD_RequiredQty,POD_Amount,POD_Tax,POD_ReceiptQty)
								VALUES (NEWID(),@PohId,@CfnId,@Price,NULL,@CfnQty,@CfnQty*@Price,@CfnQty*@Price*0.17,0)
						END
					ELSE
						SET @RtnMsg = @RtnMsg + @ArticleNumber + '不可订购<BR/>'
				END
			ELSE
				SET @RtnMsg = @RtnMsg + @ArticleNumber + '授权未通过<BR/>'
			FETCH NEXT FROM CfnCursor INTO @CfnId,@ArticleNumber,@CfnQty
		END
	CLOSE CfnCursor
	DEALLOCATE CfnCursor
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    return -1
    
END CATCH
GO


