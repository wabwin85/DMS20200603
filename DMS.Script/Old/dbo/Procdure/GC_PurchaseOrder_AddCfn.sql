DROP Procedure [dbo].[GC_PurchaseOrder_AddCfn]
GO

/*
订单批量添加产品
*/
CREATE Procedure [dbo].[GC_PurchaseOrder_AddCfn]
    @PohId uniqueidentifier,
	@DealerId uniqueidentifier,
	@CfnString NVARCHAR(1000),
    @RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(1000) OUTPUT
AS
    DECLARE @ErrorCount INTEGER
	DECLARE @CfnId uniqueidentifier
	DECLARE @ArticleNumber NVARCHAR(200)
	/*将传递进来的CFNID字符串转换成纵表*/
	DECLARE CfnCursor CURSOR FOR 
		SELECT B.CFN_ID,B.CFN_CustomerFaceNbr 
		FROM dbo.GC_Fn_SplitStringToTable(@CfnString,',') A
		INNER JOIN CFN B ON B.CFN_ID = A.VAL
	DECLARE @Price decimal(18,6)	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	OPEN CfnCursor
	FETCH NEXT FROM CfnCursor INTO @CfnId,@ArticleNumber
	WHILE @@FETCH_STATUS = 0
		BEGIN
			--检查产品授权
			IF dbo.GC_Fn_CFN_CheckDealerAuth(@DealerId,@CfnId) = 1
				BEGIN
					--检查是否可订购
					IF dbo.GC_Fn_CFN_CheckDealerCanOrder(@DealerId,@CfnId) = 1
						BEGIN
							--取得产品标准单价
							--SELECT @Price = CFNP_Price FROM CFNPrice WHERE CFNP_CFN_ID = @CfnId AND CFNP_PriceType = 'Base' AND CFNP_DeletedFlag = 0						
							SELECT @Price = dbo.fn_GetPriceByDealerForPO(@DealerId,@CfnId)
							--检查产品是否已经添加
							IF EXISTS (SELECT 1 FROM PurchaseOrderDetail WHERE POD_POH_ID = @PohId AND POD_CFN_ID = @CfnId)
								--若已经添加该产品，则根据单价和数量计算金额小计及税金小计
								UPDATE PurchaseOrderDetail 
									SET POD_CFN_Price = @Price,
										POD_RequiredQty = POD_RequiredQty + 1,
										POD_Amount = (POD_RequiredQty + 1) * @Price,
										POD_Tax = (POD_RequiredQty + 1) * @Price * 0.17
								WHERE POD_POH_ID = @PohId AND POD_CFN_ID = @CfnId
							ELSE
								--新增产品，默认数量1
								INSERT INTO PurchaseOrderDetail(POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_UOM,POD_RequiredQty,POD_Amount,POD_Tax,POD_ReceiptQty)
								VALUES (NEWID(),@PohId,@CfnId,@Price,NULL,1,@Price,@Price*0.17,0)
						END
					ELSE
						SET @RtnMsg = @RtnMsg + @ArticleNumber + '不可订购<BR/>'
				END
			ELSE
				SET @RtnMsg = @RtnMsg + @ArticleNumber + '授权未通过<BR/>'
			FETCH NEXT FROM CfnCursor INTO @CfnId,@ArticleNumber
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


