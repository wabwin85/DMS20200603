DROP Procedure [dbo].[GC_LPConsignmentSalesData_AfterDownload]
GO






CREATE Procedure [dbo].[GC_LPConsignmentSalesData_AfterDownload]
    @RtnVal NVARCHAR(20) OUTPUT,
	@BatchNbr NVARCHAR(30),
	@ClientID NVARCHAR(50),
	@Success NVARCHAR(50)
AS
	DECLARE @DealerType NVARCHAR(30)
	DECLARE @DealerId uniqueidentifier
	DECLARE @SysUserId uniqueidentifier

SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	--根据ClientID得到DealerType
	SELECT @DealerId = DealerMaster.DMA_ID ,@DealerType = DealerMaster.DMA_DealerType FROM DealerMaster 
	INNER JOIN Client ON Client.CLT_Corp_Id = DealerMaster.DMA_ID
	WHERE Client.CLT_ID = @ClientID

	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	
	IF @Success = 'Success'
		BEGIN
			UPDATE SalesInterface SET SI_Status = 'Success', SI_UpdateDate = GETDATE()
		    WHERE SI_BatchNbr = @BatchNbr			

			--IF @DealerType = 'LP'
			--	BEGIN
				
					--更新ShipmentHeader的状态为已进入SAP(已生成接口)
					--UPDATE ShipmentHeader SET SPH_Status = 'Uploaded'
					--WHERE SPH_ID IN (SELECT SI_SPH_ID FROM SalesInterface WHERE SI_BatchNbr = @BatchNbr)
					----记录订单操作日志
					--INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
					--SELECT NEWID(),SI_SPH_ID,@SysUserId,GETDATE(),'Download',NULL
					--FROM SalesInterface WHERE SI_BatchNbr = @BatchNbr
					--发送邮件
					/*
					INSERT INTO MailMessageProcess (MMP_ID,MMP_Code,MMP_ProcessId,MMP_Status,MMP_CreateDate)
					SELECT NEWID(),'EMAIL_SEND_INVOICE',T.HeaderId,'Waiting',GETDATE()
					FROM (SELECT SendInvoiceData.SID_ID AS HeaderId FROM SendInvoiceData 
					INNER JOIN SendInvoiceInit ON SendInvoiceInit.SII_SAPCode = SendInvoiceData.SID_SAPCode
					AND SendInvoiceInit.SII_DMA_ChineseName = SendInvoiceData.SID_DMA_ChineseName
					AND SendInvoiceInit.SII_InvoiceNo = SendInvoiceData.SID_InvoiceNo
					AND SendInvoiceInit.SII_Carrier = SendInvoiceData.SID_Carrier
					AND SendInvoiceInit.SII_TrackingNo = SendInvoiceData.SID_TrackingNo
					AND SendInvoiceInit.SII_USER = @UserId) AS T
					*/
					--发送短信
					/*
					INSERT INTO ShortMessageProcess (SMP_ID,SMP_Code,SMP_ProcessId,SMP_Status,SMP_CreateDate)
					SELECT NEWID(),'SMS_SEND_INVOICE',T.HeaderId,'Waiting',GETDATE()
					FROM (SELECT SendInvoiceData.SID_ID AS HeaderId FROM SendInvoiceData 
					INNER JOIN SendInvoiceInit ON SendInvoiceInit.SII_SAPCode = SendInvoiceData.SID_SAPCode
					AND SendInvoiceInit.SII_DMA_ChineseName = SendInvoiceData.SID_DMA_ChineseName
					AND SendInvoiceInit.SII_InvoiceNo = SendInvoiceData.SID_InvoiceNo
					AND SendInvoiceInit.SII_Carrier = SendInvoiceData.SID_Carrier
					AND SendInvoiceInit.SII_TrackingNo = SendInvoiceData.SID_TrackingNo
					AND SendInvoiceInit.SII_USER = @UserId) AS T
     				*/
				--END
		  --  ELSE IF @DealerType = 'T2'
		  --  	BEGIN 
					--更新ShipmentHeader的状态为已进入SAP(已生成接口)
					--UPDATE ShipmentHeader SET SPH_Status = 'Uploaded'
					--WHERE SPH_ID IN (SELECT SI_SPH_ID  FROM SalesInterface WHERE SI_BatchNbr = @BatchNbr)
					--AND POH_VendorID = @DealerId
					--记录订单操作日志
					INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
					SELECT NEWID(),SI_SPH_ID,@SysUserId,GETDATE(),'Download',NULL
					FROM SalesInterface 
					INNER JOIN ShipmentHeader ON SPH_ID = SI_SPH_ID
					WHERE SI_BatchNbr = @BatchNbr 
					--AND POH_VendorID = @DealerId
		    	--END	    		
		END
	ELSE
		BEGIN
			UPDATE SalesInterface SET SI_Status = 'Failure', SI_UpdateDate = GETDATE()
		    WHERE SI_BatchNbr = @BatchNbr
		END		

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


