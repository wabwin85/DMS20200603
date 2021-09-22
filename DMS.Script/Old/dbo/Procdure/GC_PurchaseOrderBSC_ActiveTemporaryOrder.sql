DROP PROCEDURE [dbo].[GC_PurchaseOrderBSC_ActiveTemporaryOrder]
GO

/*
将临时订单转换为正式订单
*/
CREATE PROCEDURE [dbo].[GC_PurchaseOrderBSC_ActiveTemporaryOrder]
   @PohId        UNIQUEIDENTIFIER,
   @RtnVal       NVARCHAR (20) OUTPUT,
   @RtnMsg       NVARCHAR (1000) OUTPUT
AS
   DECLARE @ErrorCount   INTEGER
   DECLARE @OrderNo   NVARCHAR (30)
   DECLARE @RowCnt   INTEGER
   DECLARE @RowCntPending   INTEGER
   DECLARE @OldPohId   UNIQUEIDENTIFIER

   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''


      --更新单据编号
      SELECT @OrderNo = POH_OrderNo,
             @OldPohId = POH_POH_ID
      FROM PurchaseOrderHeader
      WHERE POH_ID = @PohId

      IF (charindex ('V', @OrderNo) > 0)
         UPDATE PurchaseOrderHeader
            SET POH_OrderNo =
                     substring (@OrderNo, 1, charindex ('V', @OrderNo) )
                   + CONVERT (
                        NVARCHAR (30),
                          CONVERT (
                             INTEGER,
                             substring (@OrderNo,
                                        charindex ('V', @OrderNo) + 1,
                                        len (@OrderNo)))
                        + 1)
          WHERE POH_ID = @PohId
      ELSE
         UPDATE PurchaseOrderHeader
            SET POH_OrderNo = POH_OrderNo + 'V1'
          WHERE POH_ID = @PohId
      
      
      --更新订单Create Type
      UPDATE PurchaseOrderHeader SET POH_CreateType = 'Manual' WHERE POH_ID = @PohId
      
      UPDATE PurchaseOrderInterface
         SET POI_Status = 'Cancelled'
       WHERE POI_POH_ID = @OldPohId AND POI_Status = 'Pending'
     
       
      Declare @LastVersion int
      SELECT @LastVersion=POH_LastVersion
           FROM PurchaseOrderHeader
          WHERE POH_ID = @OldPohId
      
      INSERT INTO PurchaseOrderHeaderHistory 
         SELECT POH_ID, POH_OrderNo, POH_ProductLine_BUM_ID, POH_DMA_ID, POH_VendorID, POH_TerritoryCode, POH_RDD, POH_ContactPerson, POH_Contact, POH_ContactMobile, POH_Consignee, POH_ShipToAddress, POH_ConsigneePhone, POH_Remark, POH_InvoiceComment, POH_CreateType, POH_CreateUser, POH_CreateDate, POH_UpdateUser, POH_UpdateDate, POH_SubmitUser, POH_SubmitDate, POH_LastBrowseUser, POH_LastBrowseDate, POH_OrderStatus, POH_LatestAuditDate, POH_IsLocked, POH_SAP_OrderNo, POH_SAP_ConfirmDate, POH_LastVersion,getdate(), POH_OrderType, POH_VirtualDC, POH_SpecialPriceID, POH_WHM_ID, POH_POH_ID
           FROM PurchaseOrderHeader
          WHERE POH_ID = @OldPohId

      INSERT INTO PurchaseOrderDetailHistory
         SELECT POD_ID, POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_RequiredQty, POD_Amount, POD_Tax, POD_ReceiptQty, POD_Status,@LastVersion,getdate(), POD_LotNumber
           FROM PurchaseOrderDetail
          WHERE POD_POH_ID = @OldPohId

      DELETE FROM PurchaseOrderDetail
       WHERE POD_POH_ID = @OldPohId

      DELETE FROM PurchaseOrderHeader
       WHERE POH_ID = @OldPohId
       

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


