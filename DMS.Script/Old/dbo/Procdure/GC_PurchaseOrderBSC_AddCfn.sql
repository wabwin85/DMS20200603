DROP PROCEDURE [dbo].[GC_PurchaseOrderBSC_AddCfn]
GO

/*
订单批量添加产品
*/
CREATE PROCEDURE [dbo].[GC_PurchaseOrderBSC_AddCfn]
   @PohId                UNIQUEIDENTIFIER,
   @DealerId             UNIQUEIDENTIFIER,
   @CfnString            NVARCHAR (MAX),
   @DealerType           NVARCHAR (100),
   @OrderType            NVARCHAR (20),
   @SpecialPriceId       NVARCHAR (100),
   @RtnVal               NVARCHAR (20) OUTPUT,
   @RtnMsg               NVARCHAR (1000) OUTPUT
AS

   --insert into hua values(@PohId,@DealerId,@CfnString,@DealerType,@OrderType,@SpecialPriceId)
   DECLARE @ErrorCount   INTEGER
   DECLARE @CfnId   UNIQUEIDENTIFIER
   DECLARE @ArticleNumber   NVARCHAR (200)
   DECLARE @cfnPrice   DECIMAL (18, 6)
   DECLARE @UOM   NVARCHAR (100)
   DECLARE @CurRegNo nvarchar(500)
   DECLARE @CurValidDateFrom datetime 
   DECLARE @CurValidDataTo datetime
   DECLARE @CurManuName nvarchar(500)
   DECLARE @LastRegNo nvarchar(500)
   DECLARE @LastValidDateFrom datetime
   DECLARE @LastValidDataTo datetime
   DECLARE @LastManuName nvarchar(500)
   DECLARE @CurGMKind nvarchar(200)
   DECLARE @CurGMCatalog nvarchar(200)
   DECLARE @QTY DECIMAL (18, 2)
   DECLARE @PRICETYPE nvarchar(200)
	if(ISNULL(@OrderType,'') = '')
	begin
		SELECT @OrderType = POH_OrderType FROM PurchaseOrderHeader WHERE POH_ID = @PohId
	end
	IF (EXISTS(SELECT 1 FROM DealerMaster A WHERE A.DMA_ID=@DealerId AND A.DMA_DealerType='T2'))
	BEGIN
		SELECT @PRICETYPE = CASE WHEN @OrderType IN ('Consignment','ConsignmentSales','SCPO') THEN 'DealerConsignment' ELSE CASE WHEN @OrderType IN ('PRO','CRPO') then 'Base' else 'Dealer' end end
	END
	ELSE
	BEGIN
		SELECT @PRICETYPE = CASE WHEN @OrderType IN ('Consignment','ConsignmentSales','SCPO') THEN 'DealerConsignment' ELSE  'Dealer' END
	END
   /*将传递进来的CFNID字符串转换成纵表*/
   DECLARE
      CfnCursor CURSOR FOR SELECT B.CFN_ID,
                                  B.CFN_CustomerFaceNbr,
                                  CFNP_Price AS Price,
                                  CFN_Property3 AS UOM,
                                  REG.CurRegNo,
                                  REG.CurValidDateFrom,
                                  REG.CurValidDataTo,
                                  REG.CurManuName,
                                  REG.LastRegNo,
                                  REG.LastValidDateFrom,
                                  REG.LastValidDataTo,
                                  REG.LastManuName,
                                  REG.CurGMKind,
                                  REG.CurGMCatalog,
                                  A.Col2 AS QTY
                             FROM dbo.GC_Fn_SplitStringToMultiColsTable (
                                     @CfnString,
                                     ',',
                                     '@') A
                                  INNER JOIN CFN B ON (B.CFN_ID = A.COL1)
                                  INNER JOIN CFNPRICE CP ON (B.CFN_ID = CP.CFNP_CFN_ID AND CFNP_GROUP_ID = @DealerId AND CFNP_PRICETYPE = @PRICETYPE)
                                  LEFT join MD.V_INF_UPN_REG AS REG ON (B.CFN_CustomerFaceNbr = REG.CurUPN)

   DECLARE @Price   DECIMAL (18, 6)
   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''

      OPEN CfnCursor
      FETCH NEXT FROM CfnCursor
        INTO @CfnId, @ArticleNumber, @cfnPrice, @UOM, @CurRegNo, @CurValidDateFrom, @CurValidDataTo, @CurManuName, 
             @LastRegNo, @LastValidDateFrom, @LastValidDataTo, @LastManuName, @CurGMKind, @CurGMCatalog,@QTY

      WHILE @@FETCH_STATUS = 0
      BEGIN
         --或去产品注册证相关信息
         
         
         
         --检查产品授权
         IF dbo.GC_Fn_CFN_CheckDealerAuth (@DealerId, @CfnId) = 1
            BEGIN
               --检查是否可订购
               --IF dbo.GC_Fn_CFN_CheckDealerCanOrder (@DealerId, @CfnId) = 1
               --   BEGIN
               --取得产品标准单价(价格从参数中获取)
               --SELECT @Price = CFNP_Price FROM CFNPrice WHERE CFNP_CFN_ID = @CfnId AND CFNP_PriceType = 'Base' AND CFNP_DeletedFlag = 0
               --SELECT @Price = dbo.fn_GetPriceByDealerForPO (@DealerId, @CfnId)

               --如果是交接订单，则需要特殊处理,不需要合并
              
               IF (@OrderType = 'Transfer' OR @OrderType = 'ClearBorrowManual')
                  BEGIN
                     IF EXISTS
                           (SELECT 1
                              FROM PurchaseOrderDetail
                             WHERE     POD_POH_ID = @PohId
                                   AND POD_CFN_ID = @CfnId
                                   AND POD_LotNumber IS NULL)
                        UPDATE PurchaseOrderDetail
                           SET POD_CFN_Price = @cfnPrice,
                               POD_RequiredQty = POD_RequiredQty + @QTY,
                               POD_Amount = (POD_RequiredQty + @QTY) * @cfnPrice,
                               POD_Tax =
                                  (POD_RequiredQty + @QTY) * @cfnPrice * 0,
                               POD_UOM = @UOM
                         WHERE POD_POH_ID = @PohId AND POD_CFN_ID = @CfnId AND POD_LotNumber IS NULL
                     ELSE
                        --新增产品，默认数量1
                        INSERT INTO PurchaseOrderDetail (POD_ID,
                                                         POD_POH_ID, 
                                                         POD_CFN_ID,
                                                         POD_CFN_Price,
                                                         POD_UOM,
                                                         POD_RequiredQty,
                                                         POD_Amount,
                                                         POD_Tax,
                                                         POD_ReceiptQty,
                                                         POD_CurRegNo,
                                                         POD_CurValidDateFrom,
                                                         POD_CurValidDataTo,
                                                         POD_CurManuName,
                                                         POD_LastRegNo,
                                                         POD_LastValidDateFrom,
                                                         POD_LastValidDataTo,
                                                         POD_LastManuName,
                                                         POD_CurGMKind,
                                                         POD_CurGMCatalog)
                        VALUES (NEWID (),
                                @PohId,
                                @CfnId,
                                @cfnPrice,
                                @UOM,
                                @QTY,
                                @cfnPrice*@QTY,
                                0,
                                0,
                                @CurRegNo,
                                @CurValidDateFrom,
                                @CurValidDataTo,
                                @CurManuName,
                                @LastRegNo,
                                @LastValidDateFrom,
                                @LastValidDataTo,
                                @LastManuName,
                                @CurGMKind,
                                @CurGMCatalog)
                  END
               ELSE IF (@OrderType = 'SpecialPrice')
				BEGIN
					IF EXISTS
                           (SELECT 1
                              FROM PurchaseOrderDetail
                             WHERE     POD_POH_ID = @PohId
                                   AND POD_CFN_ID = @CfnId
                                   AND POD_CFN_Price = @cfnPrice)
                        UPDATE PurchaseOrderDetail
                           SET POD_CFN_Price = @cfnPrice,
                               POD_RequiredQty = POD_RequiredQty + @QTY,
                               POD_Amount = (POD_RequiredQty + @QTY) * @cfnPrice,
                               POD_Tax =
                                  (POD_RequiredQty + @QTY) * @cfnPrice * 0,
                               POD_UOM = @UOM
                         WHERE POD_POH_ID = @PohId AND POD_CFN_ID = @CfnId AND POD_CFN_Price = @cfnPrice
                     ELSE
                        --新增产品，默认数量1
                        INSERT INTO PurchaseOrderDetail (POD_ID,
                                                         POD_POH_ID, 
                                                         POD_CFN_ID,
                                                         POD_CFN_Price,
                                                         POD_UOM,
                                                         POD_RequiredQty,
                                                         POD_Amount,
                                                         POD_Tax,
                                                         POD_ReceiptQty,
                                                         POD_CurRegNo,
                                                         POD_CurValidDateFrom,
                                                         POD_CurValidDataTo,
                                                         POD_CurManuName,
                                                         POD_LastRegNo,
                                                         POD_LastValidDateFrom,
                                                         POD_LastValidDataTo,
                                                         POD_LastManuName,
                                                         POD_CurGMKind,
                                                         POD_CurGMCatalog)
                        VALUES (NEWID (),
                                @PohId,
                                @CfnId,
                                @cfnPrice,
                                @UOM,
                                @QTY,
                                @cfnPrice*@QTY,
                                0,
                                0,
                                @CurRegNo,
                                @CurValidDateFrom,
                                @CurValidDataTo,
                                @CurManuName,
                                @LastRegNo,
                                @LastValidDateFrom,
                                @LastValidDataTo,
                                @LastManuName,
                                @CurGMKind,
                                @CurGMCatalog)
				END
               ELSE
                  BEGIN
                     --检查产品是否已经添加
                     IF EXISTS
                           (SELECT 1
                              FROM PurchaseOrderDetail
                             WHERE     POD_POH_ID = @PohId
                                   AND POD_CFN_ID = @CfnId)
                        --若已经添加该产品，则根据单价和数量计算金额小计及税金小计
                        UPDATE PurchaseOrderDetail
                           SET POD_CFN_Price = @cfnPrice,
                               POD_RequiredQty = POD_RequiredQty + @QTY,
                               POD_Amount = (POD_RequiredQty + @QTY) * @cfnPrice,
                               POD_Tax =
                                  (POD_RequiredQty + @QTY) * @cfnPrice * 0,
                               POD_UOM = @UOM
                         WHERE POD_POH_ID = @PohId AND POD_CFN_ID = @CfnId
                     ELSE
                        --新增产品，默认数量1
                        INSERT INTO PurchaseOrderDetail (POD_ID,
                                                         POD_POH_ID,
                                                         POD_CFN_ID,
                                                         POD_CFN_Price,
                                                         POD_UOM,
                                                         POD_RequiredQty,
                                                         POD_Amount,
                                                         POD_Tax,
                                                         POD_ReceiptQty,
                                                         POD_CurRegNo,
                                                         POD_CurValidDateFrom,
                                                         POD_CurValidDataTo,
                                                         POD_CurManuName,
                                                         POD_LastRegNo,
                                                         POD_LastValidDateFrom,
                                                         POD_LastValidDataTo,
                                                         POD_LastManuName,
                                                         POD_CurGMKind,
                                                         POD_CurGMCatalog)
                        VALUES (NEWID (),
                                @PohId,
                                @CfnId,
                                @cfnPrice,
                                @UOM,
                                @QTY,
                                @cfnPrice*@QTY,
                                0,
                                0,
                                @CurRegNo,
                                @CurValidDateFrom,
                                @CurValidDataTo,
                                @CurManuName,
                                @LastRegNo,
                                @LastValidDateFrom,
                                @LastValidDataTo,
                                @LastManuName,
                                @CurGMKind,
                                @CurGMCatalog)
                  END
            --END
            --ELSE
            --   SET @RtnMsg = @RtnMsg + @ArticleNumber + '不可订购<BR/>'
            END
         ELSE
            SET @RtnMsg = @RtnMsg + @ArticleNumber + '授权未通过<BR/>'

         FETCH NEXT FROM CfnCursor
           INTO @CfnId, @ArticleNumber, @cfnPrice, @UOM, @CurRegNo, @CurValidDateFrom, @CurValidDataTo, @CurManuName, 
                @LastRegNo, @LastValidDateFrom, @LastValidDataTo, @LastManuName, @CurGMKind, @CurGMCatalog,@QTY
      END

      CLOSE CfnCursor
      DEALLOCATE CfnCursor

      IF (@SpecialPriceId IS NOT NULL AND @SpecialPriceId <> '')
         UPDATE PurchaseOrderHeader
            SET POH_PointType = @SpecialPriceId
          WHERE POH_ID = @PohId

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


