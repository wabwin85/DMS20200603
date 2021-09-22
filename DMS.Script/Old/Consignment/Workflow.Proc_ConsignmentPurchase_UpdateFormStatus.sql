
/*
1. 功能名称：寄售买断发起MFlow
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [Workflow].[Proc_ConsignmentPurchase_UpdateFormStatus]
	@InstanceId uniqueidentifier,
	@OperType nvarchar(100),
	@OperName nvarchar(100),
	@UserAccount nvarchar(100),
	@AuditNote nvarchar(MAX)
AS

DECLARE @applyStatus NVARCHAR(100)
SELECT @applyStatus = CASE WHEN @OperType = 'drafter_submit' THEN 'Submitted'
						WHEN @OperType = 'drafter_press' THEN 'Submitted'
						WHEN @OperType = 'drafter_abandon' THEN 'Revoke'
						WHEN @OperType = 'handler_pass' THEN 'Submitted'
						WHEN @OperType = 'handler_refuse' THEN 'Reject'
						WHEN @OperType = 'handler_additionSign' THEN 'Submitted'
						WHEN @OperType = 'sys_complete' THEN 'Complete'
						WHEN @OperType = 'sys_abandon' THEN 'Revoke'
						ELSE NULL END

IF @applyStatus IS NOT NULL
	BEGIN
		UPDATE A SET A.IAH_Status = @applyStatus
		FROM InventoryAdjustHeader A
		WHERE A.IAH_ID = @InstanceId
		DECLARE @BillNo NVARCHAR(50)
		DECLARE @Reason NVARCHAR(50)
		DECLARE @RtnVal NVARCHAR(20)
		DECLARE @RtnMsg NVARCHAR(1000)
		select @BillNo=IAH_Inv_Adj_Nbr,@Reason=IAH_Reason from InventoryAdjustHeader where IAH_ID=@InstanceId
		IF(@applyStatus='Complete')
		  BEGIN
				IF @Reason='CTOS'
				  BEGIN
					exec Consignment.Proc_InventoryAdjust 'CTS',@BillNo,'Adjust',@RtnVal,@RtnMsg          
				  END
				IF @Reason='ForceCTOS'
				  BEGIN
				    exec Consignment.Proc_InventoryAdjust 'MCTS',@BillNo,'Adjust',@RtnVal,@RtnMsg
				  END
        --写入接口表
			  INSERT INTO AdjustInterface    		
        select NEWID(),'','', IAH_ID , IAH_Inv_Adj_Nbr ,'Pending','Manual',NULL,'00000000-0000-0000-0000-000000000000',GETDATE(),'00000000-0000-0000-0000-000000000000',GETDATE(),(select  CLT_ID from Client where CLT_Corp_Id = CASE WHEN DM.DMA_DealerType='T2' THEN DMA_Parent_DMA_ID ELSE DMA_ID END )
        from InventoryAdjustHeader H, DealerMaster DM where IAH_Inv_Adj_Nbr=@BillNo and H.IAH_DMA_ID = DM.DMA_ID
		  END
		IF(@applyStatus='Reject' or @applyStatus='Revoke')
		  BEGIN
		    IF @Reason='CTOS'
				BEGIN
				   exec Consignment.Proc_InventoryAdjust 'CTS',@BillNo,'Cancel',@RtnVal,@RtnMsg
				END
			IF @Reason='ForceCTOS'
				BEGIN
				   exec Consignment.Proc_InventoryAdjust 'MCTS',@BillNo,'Cancel',@RtnVal,@RtnMsg
          
				END		    
		  END
	END