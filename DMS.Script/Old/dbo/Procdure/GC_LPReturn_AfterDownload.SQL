DROP Procedure [dbo].[GC_LPReturn_AfterDownload]
GO


/*
根据批处理号批量更新AdjustInterface的状态（成功或失败）
InventoryAdjustHeader的状态（仅成功时状态更新为已进入SAP）
PurchaseOrderLog中记录日志
以及邮件和短信队列中新增记录（仅成功时）
*/
CREATE Procedure [dbo].[GC_LPReturn_AfterDownload]
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
			UPDATE AdjustInterface SET AI_Status = 'Success', AI_UpdateDate = GETDATE()
		    WHERE AI_BatchNbr = @BatchNbr			

			IF @DealerType = 'LP'
				BEGIN
					--更新InventoryAdjustHeader的状态为已进入SAP(已生成接口)
					--UPDATE InventoryAdjustHeader SET IAH_Status = 'Uploaded'
					--WHERE IAH_ID IN (SELECT AI_IAH_ID FROM AdjustInterface WHERE AI_BatchNbr = @BatchNbr)
					--AND IAH_DMA_ID = @DealerId
					--记录订单操作日志
					INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
					SELECT NEWID(),AI_IAH_ID,@SysUserId,GETDATE(),'Download',NULL
					FROM AdjustInterface WHERE AI_BatchNbr = @BatchNbr
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
				END
		    ELSE IF @DealerType = 'T2'
		    	BEGIN
					--更新PurchaseOrderHeader的状态为已进入SAP(已生成接口)
					--UPDATE InventoryAdjustHeader SET IAH_Status = 'Uploaded'
					--WHERE IAH_ID IN (SELECT AI_IAH_ID FROM AdjustInterface WHERE AI_BatchNbr = @BatchNbr)
					
					--记录订单操作日志
					INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
					SELECT NEWID(),IAH_ID,@SysUserId,GETDATE(),'Download',NULL
					FROM AdjustInterface 
					INNER JOIN InventoryAdjustHeader ON IAH_ID = AI_IAH_ID
					INNER JOIN DealerMaster ON IAH_DMA_ID = DMA_ID
					WHERE AI_BatchNbr = @BatchNbr AND DMA_Parent_DMA_ID = @DealerId
		    	END	    		
		END
	ELSE
		BEGIN
			UPDATE AdjustInterface SET AI_Status = 'Failure', AI_UpdateDate = GETDATE()
		    WHERE AI_BatchNbr = @BatchNbr
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


