DROP PROCEDURE [dbo].[Proc_SaveDpDelivery]
GO

CREATE PROCEDURE [dbo].[Proc_SaveDpDelivery](
    @Upn       NVARCHAR(100),
    @Lot       NVARCHAR(100),
    @Quantity  DECIMAL(18,6),
    @Memo      NVARCHAR(100),
    @SampleNo  NVARCHAR(100)
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
		
		DECLARE @PrhId UNIQUEIDENTIFIER;
		DECLARE @PorId UNIQUEIDENTIFIER;
		DECLARE @PmaId UNIQUEIDENTIFIER;
		DECLARE @PoNum NVARCHAR(100);
		DECLARE @SyncContent NVARCHAR(MAX);
		DECLARE @SampleId UNIQUEIDENTIFIER;
		
		SET @PrhId = NEWID();
		SET @PorId = NEWID();
		SET @PoNum = '';
		SET @SyncContent = '';
		
		SELECT @PmaId = PMA_ID
		FROM   Product
		WHERE  PMA_UPN = @Upn;
		
		SELECT @SampleId = SampleApplyHeadId
		FROM   SampleApplyHead
		WHERE  ApplyNo = @SampleNo
		
		EXEC GC_GetNextAutoNumberForCode 'Next_SampleNbr', @PoNum OUTPUT
		
		INSERT INTO POReceiptHeader_SAPNoQR
		  (PRH_ID, PRH_PONumber, PRH_SAPShipmentID, PRH_Dealer_DMA_ID, PRH_SAPShipmentDate, PRH_Status, PRH_Vendor_DMA_ID, PRH_Type, PRH_ProductLine_BUM_ID, PRH_PurchaseOrderNbr, PRH_WHM_ID, PRH_Note, PRH_InterfaceStatus)
		VALUES
		  (@PrhId, @PoNum, @PoNum, '00000000-0000-0000-0000-000000000000', GETDATE(), 'DP', '00000000-0000-0000-0000-000000000000', 'SampleOrder', '00000000-0000-0000-0000-000000000000', @SampleNo, '00000000-0000-0000-0000-000000000000', @Memo, 'SAMPLE')
		
		INSERT INTO POReceipt_SAPNoQR
		  (POR_ID, POR_SAP_PMA_ID, POR_ReceiptQty, POR_PRH_ID, POR_LineNbr)
		VALUES
		  (@PorId, @PmaId, @Quantity, @PrhId, 1)
		
		INSERT INTO POReceiptLot_SAPNoQR
		  (PRL_POR_ID, PRL_ID, PRL_LotNumber, PRL_ReceiptQty, PRL_ExpiredDate, PRL_WHM_ID)
		VALUES
		  (@PorId, NEWID(), @Lot, @Quantity, GETDATE(), '00000000-0000-0000-0000-000000000000')
		
		SET @SyncContent += '<InterfaceDataSet><Record>';
		SET @SyncContent += '<DeliveryNo>' + @PoNum + '</DeliveryNo>';
		SET @SyncContent += '<DeliveryDate>' + CONVERT(NVARCHAR(19), GETDATE(), 121) + '</DeliveryDate>';
		SET @SyncContent += '<ApplyNo>' + @SampleNo + '</ApplyNo>';
		SET @SyncContent += '<UpnList><UpnItem>';
		SET @SyncContent += '<UpnNo>' + @Upn + '</UpnNo>';
		SET @SyncContent += '<Lot>' + @Lot + '</Lot>';
		SET @SyncContent += '<Qty>' + CONVERT(NVARCHAR(100), CONVERT(FLOAT,@Quantity)) + '</Qty>';
		SET @SyncContent += '<ExpDate></ExpDate>';
		SET @SyncContent += '<OrderNo></OrderNo>';
		SET @SyncContent += '<Status>DP</Status>';
		SET @SyncContent += '</UpnItem></UpnList>';
		SET @SyncContent += '</Record></InterfaceDataSet>';
		
		INSERT INTO SampleSyncStack
		  (SampleHeadId, ApplyType, SampleType, SyncType, SampleNo, SyncContent, SyncStatus, SyncErrCount, SyncMsg, CreateDate)
		VALUES
		  (@SampleId, '申请单', '测试样品', '单据发货', @SampleNo, @SyncContent, 'Wait', 0, '', GETDATE())
		
		--发送邮件
		DECLARE @MAIL_SUBJECT NVARCHAR(200)
		DECLARE @MAIL_BODY NVARCHAR(MAX)
		DECLARE @MAIL_CODE NVARCHAR(50)

		SELECT @MAIL_CODE = 'EMAIL_SAMPLE_NOTIFY_IE'

		IF EXISTS (SELECT 1 FROM MailMessageTemplate WHERE MMT_CODE = @MAIL_CODE)
		AND EXISTS (SELECT 1 FROM MailDeliveryAddress WHERE MDA_MAILTYPE = @MAIL_CODE)
		BEGIN
			SELECT @MAIL_SUBJECT=MMT_SUBJECT, @MAIL_BODY=MMT_BODY FROM MailMessageTemplate WHERE MMT_CODE = @MAIL_CODE
			SELECT @MAIL_SUBJECT = REPLACE(@MAIL_SUBJECT,'{#ApplyNo}',ApplyNo),
				   @MAIL_BODY = REPLACE(REPLACE(REPLACE(REPLACE(@MAIL_BODY,'{#ApplyNo}',ApplyNo),'{#ReceiptUser}',ReceiptUser),'{#ReceiptPhone}',ReceiptPhone),'{#ReceiptAddress}',ReceiptAddress)
			FROM SampleApplyHead WHERE SampleApplyHeadId = @SampleId

			SET @MAIL_BODY = REPLACE(@MAIL_BODY,'{#UPN}',@Upn)
			SET @MAIL_BODY = REPLACE(@MAIL_BODY,'{#QTY}',CONVERT(NVARCHAR(100), CONVERT(FLOAT,@Quantity)))

			INSERT INTO dbo.MailMessageQueue
				(
				MMQ_ID,
				MMQ_QueueNo,
				MMQ_From,
				MMQ_To,
				MMQ_Subject,
				MMQ_Body,
				MMQ_Status,
				MMQ_CreateDate
				)
			SELECT NEWID(),'email','',MDA_MAILADDRESS,@MAIL_SUBJECT,@MAIL_BODY,'Waiting',GETDATE()
			FROM MailDeliveryAddress
			WHERE MDA_MAILTYPE = @MAIL_CODE

		END

		COMMIT TRAN
		RETURN 1
	END TRY
	
	BEGIN CATCH
		ROLLBACK TRAN
		RETURN -1
	END CATCH
END
GO


