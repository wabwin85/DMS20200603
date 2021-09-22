

/*
1. 功能名称：库存转移发起MFlow
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [Workflow].[Proc_ConsignmentTransfer_UpdateFormStatus]
	@InstanceId uniqueidentifier,
	@OperType nvarchar(100),
	@OperName nvarchar(100),
	@UserAccount nvarchar(100),
	@AuditNote nvarchar(MAX)
AS

DECLARE @applyStatus NVARCHAR(100)
SELECT @applyStatus = CASE WHEN @OperType = 'drafter_submit' THEN 'InApproval'
						WHEN @OperType = 'drafter_press' THEN 'InApproval'
						WHEN @OperType = 'drafter_abandon' THEN 'Deny'
						WHEN @OperType = 'handler_pass' THEN 'InApproval'
						WHEN @OperType = 'handler_refuse' THEN 'Deny'
						WHEN @OperType = 'handler_additionSign' THEN 'InApproval'
						WHEN @OperType = 'sys_complete' THEN 'Completed'
						WHEN @OperType = 'sys_abandon' THEN 'Deny'
						ELSE NULL END

IF @applyStatus IS NOT NULL
	BEGIN
		UPDATE A SET A.TH_Status = @applyStatus
		FROM Consignment.TransferHeader A
		WHERE A.TH_ID = @InstanceId
		
		DECLARE @BillNo NVARCHAR(50)
		DECLARE @RtnVal NVARCHAR(20)
		DECLARE @RtnMsg NVARCHAR(1000)
		select @BillNo=TH_No from Consignment.TransferHeader  where TH_ID=@InstanceId
		IF(@applyStatus='Completed')
		  BEGIN
			--移库
			EXEC Consignment.Proc_InventoryAdjust 'ConsignTransfer',@BillNo,'Adjust',NULL,NULL
			
			--创建订单
			EXEC Consignment.Proc_CreateOrder 'ZT','ConsignTransfer',@BillNo,'1',NULL,NULL
			
			--记录log
			INSERT  INTO Platform_OperLogMaster (LogId,MainId,OperUser,OperUserEN,OperDate,OperType,OperNote,OperRole,DataSource)
			VALUES (NEWID(),@InstanceId,'系统','',GETDATE(),'审批通过','创建虚拟订单及虚拟退货单','系统','Consignment_Transfer')
			
		  END
		IF(@applyStatus='Deny')
		  BEGIN
		    --移库
		    EXEC Consignment.Proc_InventoryAdjust 'ConsignTransfer',@BillNo,'Cancel',NULL,NULL
		    
		    INSERT  INTO Platform_OperLogMaster (LogId,MainId,OperUser,OperUserEN,OperDate,OperType,OperNote,OperRole,DataSource)
			VALUES (NEWID(),@InstanceId,'系统','',GETDATE(),'审批拒绝','','系统','Consignment_Transfer')
		  END
		
		 
	END
	

