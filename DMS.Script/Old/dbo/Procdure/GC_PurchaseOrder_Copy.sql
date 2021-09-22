DROP  PROCEDURE [dbo].[GC_PurchaseOrder_Copy]
GO


/*
订单复制
*/
CREATE PROCEDURE [dbo].[GC_PurchaseOrder_Copy]
   @PohId           UNIQUEIDENTIFIER,
   @DealerId        UNIQUEIDENTIFIER,
   @UserId          UNIQUEIDENTIFIER,
   @PriceType       NVARCHAR (100),
   @RtnVal          NVARCHAR (20) OUTPUT,
   @RtnMsg          NVARCHAR (1000) OUTPUT
AS
   DECLARE @ErrorCount   INTEGER
   DECLARE @InstanceId   UNIQUEIDENTIFIER

   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''

      SET @InstanceId = NEWID ()

      --复制表头信息录
      INSERT INTO PurchaseOrderHeader (POH_ID,
                                       POH_OrderNo,
                                       POH_ProductLine_BUM_ID,
                                       POH_DMA_ID,
                                       POH_VendorID,
                                       POH_TerritoryCode,
                                       POH_RDD,
                                       POH_ContactPerson,
                                       POH_Contact,
                                       POH_ContactMobile,
                                       POH_Consignee,
                                       POH_ShipToAddress,
                                       POH_ConsigneePhone,
                                       POH_Remark,
                                       POH_InvoiceComment,
                                       POH_CreateType,
                                       POH_CreateUser,
                                       POH_CreateDate,
                                       POH_UpdateUser,
                                       POH_UpdateDate,
                                       POH_SubmitUser,
                                       POH_SubmitDate,
                                       POH_LastBrowseUser,
                                       POH_LastBrowseDate,
                                       POH_OrderStatus,
                                       POH_LatestAuditDate,
                                       POH_IsLocked,
                                       POH_SAP_OrderNo,
                                       POH_SAP_ConfirmDate,
                                       POH_LastVersion,
                                       POH_OrderType,
                                       POH_VirtualDC,
                                       POH_SpecialPriceID,
                                       POH_WHM_ID,
                                       POH_POH_ID,
									   POH_DcType,
									   POH_SendAddress,
									   POH_SendHospital)
         SELECT @InstanceId,
                NULL,
                POH_ProductLine_BUM_ID,
                POH_DMA_ID,
                POH_VendorID,
                POH_TerritoryCode,                                       --承运商
                NULL,
                POH_ContactPerson,
                POH_Contact,
                POH_ContactMobile,
                POH_Consignee,
                POH_ShipToAddress,                                      --收货地址
                POH_ConsigneePhone,
                '复制订单[' + POH_OrderNo + ']',
                POH_InvoiceComment,
                'Manual',
                @UserId,
                GETDATE (),
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                'Draft',
                NULL,
                0,
                NULL,
                NULL,
                0,
                POH_OrderType,                                          --订单类型
                POH_VirtualDC,
                POH_SpecialPriceID,
                POH_WHM_ID,                                               --仓库
                NULL
				POH_DcType,
				POH_SendAddress,
				POH_SendHospital
           FROM PurchaseOrderHeader
          WHERE POH_ID = @PohId


      --更新订单联系人信息
      UPDATE PurchaseOrderHeader
         SET POH_ContactPerson = DST_ContactPerson,
             POH_Contact = DST_Contact,
             POH_ContactMobile = DST_ContactMobile,
             POH_Consignee = DST_Consignee,
             POH_ConsigneePhone = DST_ConsigneePhone
        FROM DealerShipTo
       WHERE DST_Dealer_DMA_ID = @DealerId AND POH_ID = @InstanceId
      
      --更新订单对象
     UPDATE PurchaseOrderHeader
        SET POH_VendorID = DMA_Parent_DMA_ID
       FROM DealerMaster
      WHERE DMA_ID = @DealerId AND POH_ID = @InstanceId
      
      --更新收货信息
      --UPDATE PurchaseOrderHeader
      --   SET POH_ShipToAddress = DMA_ShipToAddress
      --  FROM DealerMaster
      -- WHERE DMA_ID = @DealerId AND POH_ID = @InstanceId

      --复制明细行
      IF (@PriceType = 'DealerSpecial')
         INSERT INTO PurchaseOrderDetail (POD_ID,
                                          POD_POH_ID,
                                          POD_CFN_ID,
                                          POD_CFN_Price,
                                          POD_UOM,
                                          POD_RequiredQty,
                                          POD_Amount,
                                          POD_Tax,
                                          POD_ReceiptQty,
                                          POD_Status,
                                          POD_LotNumber,
                                          POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,
                                          POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,POD_QRCode)
            SELECT NEWID (),
                   @InstanceId,
                   POD_CFN_ID,
                   POD_CFN_Price,
                   POD_UOM,
                   POD_RequiredQty,
                   POD_Amount,
                   POD_Tax,
                   0,
                   POD_Status,
                   POD_LotNumber,
                   POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,
                   POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,POD_QRCode
              FROM PurchaseOrderDetail
             WHERE POD_POH_ID = @PohId
      ELSE
         INSERT INTO PurchaseOrderDetail (POD_ID,
                                          POD_POH_ID,
                                          POD_CFN_ID,
                                          POD_CFN_Price,
                                          POD_UOM,
                                          POD_RequiredQty,
                                          POD_Amount,
                                          POD_Tax,
                                          POD_ReceiptQty,
                                          POD_Status,
                                          POD_LotNumber,
                                          POD_Field2,
                                          POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,
                                          POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,POD_QRCode)
            SELECT NEWID (),
                   @InstanceId,
                   POD_CFN_ID,
                   POD_CFN_Price,
                   POD_UOM,
                   POD_RequiredQty,
                   POD_CFN_Price * POD_RequiredQty AS POD_Amount,
                   POD_CFN_Price * POD_RequiredQty * 0 AS POD_Tax,
                   0,
                   POD_Status,
                   POD_LotNumber,
                   POD_Field2,
                   POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,
                   POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,POD_QRCode
              FROM (SELECT POD_CFN_ID,
                           dbo.fn_GetPriceByDealerForBSCPO (@DealerId,
                                                            POD_CFN_ID,
                                                            @PriceType)
                              AS POD_CFN_Price,
                           POD_UOM,
                           POD_RequiredQty,
                           POD_Status,
                           POD_LotNumber,
                           POD_Field2,
                           POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,
                           POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,POD_QRCode
                      FROM PurchaseOrderDetail
                     WHERE     POD_POH_ID = @PohId
                           AND dbo.GC_Fn_CFN_CheckDealerAuth (@DealerId,
                                                              POD_CFN_ID) = 1
                           AND dbo.GC_Fn_CFN_CheckBSCDealerCanOrder (
                                  @DealerId,
                                  POD_CFN_ID,
                                  @PriceType) = 1) AS T

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


