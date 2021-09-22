DROP  PROCEDURE [dbo].[GC_ConsignmenOrderBSC_AddCfn]
GO

/*
订单批量添加产品
*/
CREATE PROCEDURE [dbo].[GC_ConsignmenOrderBSC_AddCfn]
  @PohId                UNIQUEIDENTIFIER,
   @DealerId             UNIQUEIDENTIFIER,
   @CfnString            NVARCHAR (MAX),
   @DealerType           NVARCHAR (100),
   @OrderType            NVARCHAR (20),
   @SpecialPriceId       NVARCHAR (100),
   @RtnVal               NVARCHAR (20) OUTPUT,
   @RtnMsg               NVARCHAR (1000) OUTPUT
AS
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

   /*将传递进来的CFNID字符串转换成纵表*/
   DECLARE
      CfnCursor CURSOR FOR SELECT B.CFN_ID,
                                  B.CFN_CustomerFaceNbr,
                                  CONVERT (DECIMAL (18, 6), A.Col2) AS Price,
                                  --CASE WHEN A.Col2 = 'null' OR A.Col2 IS NULL THEN CONVERT (DECIMAL (18, 6),0) ELSE A.Col2 END AS Price,
                                  A.Col3 AS UOM,
                                  REG.CurRegNo,
                                  REG.CurValidDateFrom,
                                  REG.CurValidDataTo,
                                  REG.CurManuName,
                                  REG.LastRegNo,
                                  REG.LastValidDateFrom,
                                  REG.LastValidDataTo,
                                  REG.LastManuName,
                                  REG.CurGMKind,
                                  REG.CurGMCatalog
                             FROM dbo.GC_Fn_SplitStringToMultiColsTable (
                                     @CfnString,
                                     ',',
                                     '@') A
                                  INNER JOIN CFN B ON (B.CFN_ID = A.COL1)
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
             @LastRegNo, @LastValidDateFrom, @LastValidDataTo, @LastManuName, @CurGMKind, @CurGMCatalog

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
                              FROM ConsignmentApplyDetails
                             WHERE     CAD_CAH_ID = @PohId
                                   AND CAD_CFN_ID = @CfnId
                                   AND CAD_LotNumber IS NULL)
                        UPDATE ConsignmentApplyDetails
                           SET CAD_Price = @cfnPrice,
                               CAD_Actual_Price=@cfnPrice,
                               CAD_Qty = CAD_Qty + 1,
                               CAD_Amount = (CAD_Qty + 1) * @cfnPrice,
                               --POD_Tax =
                               --   (POD_RequiredQty + 1) * @cfnPrice * 0,
                               CAD_UOM = @UOM
                         WHERE CAD_CAH_ID = @PohId AND CAD_CFN_ID = @CfnId AND CAD_LotNumber IS NULL
                     ELSE
                        --新增产品，默认数量1
                        INSERT INTO ConsignmentApplyDetails (CAD_ID,
                                                         CAD_CAH_ID, 
                                                         CAD_CFN_ID,
                                                         CAD_UOM,
                                                         CAD_Qty,
                                                         CAD_Price,
                                                         CAD_Actual_Price,
                                                         CAD_Amount
                                                         )
                        VALUES (NEWID (),
                                @PohId,
                                @CfnId,
                                @UOM,
                                1,
                                @cfnPrice,
                                @cfnPrice,
                               @cfnPrice
                                )
                  END
               ELSE IF (@OrderType = 'SpecialPrice')
				BEGIN
					IF EXISTS
                           (SELECT 1
                              FROM ConsignmentApplyDetails
                             WHERE     CAD_CAH_ID = @PohId
                                   AND CAD_CFN_ID = @CfnId
                                   AND CAD_Price = @cfnPrice)
                        UPDATE ConsignmentApplyDetails
                           SET CAD_Price = @cfnPrice,
                               CAD_Qty = CAD_Qty + 1,
                               CAD_Amount = (CAD_Qty + 1) * @cfnPrice,
                               --POD_Tax =
                               --   (POD_RequiredQty + 1) * @cfnPrice * 0,
                               CAD_UOM = @UOM
                         WHERE CAD_CAH_ID = @PohId AND CAD_CFN_ID = @CfnId AND CAD_Price = @cfnPrice
                     ELSE
                        --新增产品，默认数量1
                        INSERT INTO ConsignmentApplyDetails (CAD_ID,
                                                         CAD_CAH_ID, 
                                                         CAD_CFN_ID,
                                                         CAD_UOM,
                                                         CAD_Qty,
                                                         CAD_Price,
                                                         CAD_Actual_Price,
                                                         CAD_Amount
                                                          )
                        VALUES (NEWID (),
                                @PohId,
                                @CfnId,
                                @UOM,
                                1,
                                @cfnPrice,
                                @cfnPrice,
                                @cfnPrice
                                )
				END
               ELSE
                  BEGIN
                     --检查产品是否已经添加
                     IF EXISTS
                           (SELECT 1
                              FROM ConsignmentApplyDetails
                             WHERE     CAD_CAH_ID = @PohId
                                   AND CAD_CFN_ID = @CfnId)
                        --若已经添加该产品，则根据单价和数量计算金额小计及税金小计
                        UPDATE ConsignmentApplyDetails
                           SET CAD_Price = @cfnPrice,
                               CAD_Qty = CAD_Qty + 1,
                               CAD_Amount = (CAD_Qty + 1) * @cfnPrice,
                               --POD_Tax =
                               --   (POD_RequiredQty + 1) * @cfnPrice * 0,
                               CAD_UOM = @UOM
                         WHERE CAD_CAH_ID = @PohId AND CAD_CFN_ID = @CfnId
                     ELSE
                        --新增产品，默认数量1
                         INSERT INTO ConsignmentApplyDetails (CAD_ID,
                                                         CAD_CAH_ID, 
                                                         CAD_CFN_ID,
                                                         CAD_UOM,
                                                         CAD_Qty,
                                                         CAD_Price,
                                                         CAD_Actual_Price,
                                                         CAD_Amount
                                                          )
                        VALUES (NEWID (),
                                @PohId,
                                @CfnId,
                                @UOM,
                                1,
                                @cfnPrice,
                                @cfnPrice,
                                @cfnPrice
                                )
                  END
            --END
            --ELSE
            --   SET @RtnMsg = @RtnMsg + @ArticleNumber + '不可订购<BR/>'
            END
         ELSE
            SET @RtnMsg = @RtnMsg + @ArticleNumber + '授权未通过<BR/>'

         FETCH NEXT FROM CfnCursor
           INTO @CfnId, @ArticleNumber, @cfnPrice, @UOM, @CurRegNo, @CurValidDateFrom, @CurValidDataTo, @CurManuName, 
                @LastRegNo, @LastValidDateFrom, @LastValidDataTo, @LastManuName, @CurGMKind, @CurGMCatalog
      END

      CLOSE CfnCursor
      DEALLOCATE CfnCursor

      IF (@SpecialPriceId IS NOT NULL AND @SpecialPriceId <> '')
         UPDATE PurchaseOrderHeader
            SET POH_SpecialPriceID = @SpecialPriceId
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


