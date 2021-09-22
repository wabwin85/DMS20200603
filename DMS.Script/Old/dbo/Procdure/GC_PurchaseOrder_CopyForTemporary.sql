DROP PROCEDURE [dbo].[GC_PurchaseOrder_CopyForTemporary]
GO

/*
��������
*/
CREATE PROCEDURE [dbo].[GC_PurchaseOrder_CopyForTemporary]
   @PohId            UNIQUEIDENTIFIER,
   @InstanceId       UNIQUEIDENTIFIER,
   @RtnVal           NVARCHAR (20) OUTPUT,
   @RtnMsg           NVARCHAR (1000) OUTPUT
AS
   DECLARE @ErrorCount   INTEGER

   SET  NOCOUNT ON

    BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''

      --�����Ʊ�ͷ����ϸ��Ϣ,����У��
      --���Ʊ�ͷ��Ϣ¼
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
                                       POH_POH_ID)
         SELECT @InstanceId,
                POH_OrderNo,
                POH_ProductLine_BUM_ID,
                POH_DMA_ID,
                POH_VendorID,
                POH_TerritoryCode,                                       --������
                POH_RDD,
                POH_ContactPerson,
                POH_Contact,
                POH_ContactMobile,
                POH_Consignee,
                POH_ShipToAddress,                                      --�ջ���ַ
                POH_ConsigneePhone,
                POH_Remark,
                POH_InvoiceComment,
                'Temporary',                                  --POH_CreateType
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
                POH_LastVersion + 1,
                POH_OrderType,
                POH_VirtualDC,
                POH_SpecialPriceID,
                POH_WHM_ID,
                POH_ID                                      --��¼ԭ�е��ݵ�ID�����ύʱʹ��
           FROM PurchaseOrderHeader
          WHERE POH_ID = @PohId



      --������ϸ��
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
                                       POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,POD_QRCode,POD_ShipmentNbr,POD_Field2)
         SELECT NEWID (),
                @InstanceId,
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
                POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,POD_QRCode,POD_ShipmentNbr,POD_Field2
           FROM PurchaseOrderDetail
          WHERE POD_POH_ID = @PohId

      --���Ʋ�����¼
      INSERT INTO PurchaseOrderLog (POL_ID,
                                    POL_POH_ID,
                                    POL_OperUser,
                                    POL_OperDate,
                                    POL_OperType,
                                    POL_OperNote)
         SELECT NEWID () AS POL_ID,
                @InstanceId AS POL_POH_ID,
                POL_OperUser,
                POL_OperDate,
                POL_OperType,
                POL_OperNote
           FROM PurchaseOrderLog
          WHERE POL_POH_ID = @PohId

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


