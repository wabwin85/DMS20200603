DROP Procedure [dbo].[GC_PurchaseOrder_AfterClearBorrowSubmit]
GO

/*
接口日志处理
*/
CREATE Procedure [dbo].[GC_PurchaseOrder_AfterClearBorrowSubmit]
	@POH_ID uniqueidentifier,
	@RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
 DECLARE @NEWPOH_ID uniqueidentifier
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
--写入主表
SET @NEWPOH_ID=NEWID();
INSERT INTO PurchaseOrderHeader(POH_ID,POH_OrderNo,POH_ProductLine_BUM_ID,POH_DMA_ID,
POH_VendorID,POH_TerritoryCode,POH_RDD,POH_ContactPerson,POH_Contact,POH_ContactMobile,
POH_Consignee,POH_ShipToAddress,POH_ConsigneePhone,POH_Remark,POH_InvoiceComment,
POH_CreateType,POH_CreateUser,POH_CreateDate,POH_UpdateUser,POH_UpdateDate,
POH_SubmitUser,POH_SubmitDate,POH_LastBrowseUser,POH_LastBrowseDate,POH_OrderStatus,
POH_LatestAuditDate,POH_IsLocked,POH_SAP_OrderNo,
POH_SAP_ConfirmDate,POH_LastVersion,POH_OrderType,POH_VirtualDC,POH_SpecialPriceID,
POH_WHM_ID,POH_POH_ID,POH_SalesAccount,POH_PointType)
SELECT @NEWPOH_ID,POH_OrderNo+'KB',POH_ProductLine_BUM_ID,POH_DMA_ID,
POH_VendorID,POH_TerritoryCode,POH_RDD,POH_ContactPerson,POH_Contact,POH_ContactMobile,
POH_Consignee,POH_ShipToAddress,POH_ConsigneePhone,POH_Remark,POH_InvoiceComment,
POH_CreateType,POH_CreateUser,POH_CreateDate,POH_UpdateUser,POH_UpdateDate,
POH_SubmitUser,POH_SubmitDate,POH_LastBrowseUser,POH_LastBrowseDate,POH_OrderStatus,
POH_LatestAuditDate,POH_IsLocked,POH_SAP_OrderNo,
POH_SAP_ConfirmDate,POH_LastVersion,'Consignment',POH_VirtualDC,POH_SpecialPriceID,
POH_WHM_ID,POH_POH_ID,POH_SalesAccount,POH_PointType FROM PurchaseOrderHeader WHERE POH_ID=@POH_ID
--写入明显明细表

INSERT INTO PurchaseOrderDetail(POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_UOM,POD_RequiredQty,POD_Amount,POD_Tax,POD_ReceiptQty,
POD_Status,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,
POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,POD_QRCode)
SELECT NEWID(),@NEWPOH_ID,POD_CFN_ID,0,POD_UOM,sum(POD_RequiredQty),0,POD_Tax,POD_ReceiptQty,
POD_Status,null,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,
POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,null
 FROM PurchaseOrderDetail
WHERE POD_POH_ID=@POH_ID group by POD_CFN_ID,POD_UOM,POD_Tax,POD_ReceiptQty,
POD_Status,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,
POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog
	
--写入接口表
INSERT INTO PurchaseOrderInterface(POI_ID,POI_BatchNbr,POI_RecordNbr,POI_POH_ID
,POI_POH_OrderNo,POI_Status,POI_ProcessType,POI_CreateUser,POI_CreateDate,
POI_UpdateUser,POI_UpdateDate,POI_ClientID)
SELECT NEWID(), '','',POH_ID,POH_OrderNo,'Pending','Manual','00000000-0000-0000-0000-000000000000',
GETDATE(),'00000000-0000-0000-0000-000000000000',GETDATE(),'EAI' 
FROM PurchaseOrderHeader WHERE POH_ID=@NEWPOH_ID
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
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
    
END CATCH
GO


