DROP Procedure [interface].[P_I_EW_GoodsReturnLock]
GO

/*
平台退货确认数据处理
*/
CREATE Procedure [interface].[P_I_EW_GoodsReturnLock]
	@ReturnNo NVARCHAR(30)
AS
	DECLARE @SysUserId uniqueidentifier
	DECLARE @OrderId uniqueidentifier
	DECLARE @BatchNbr NVARCHAR(30)
SET NOCOUNT ON

BEGIN TRY
	SET @BatchNbr = ''
	EXEC dbo.GC_GetNextAutoNumberForInt 'SYS','P_I_EW_GoodsReturnLock',@BatchNbr OUTPUT

	SET @SysUserId = '00000000-0000-0000-0000-000000000000'

BEGIN TRAN

	--根据退货单号查询单据是否存在，且单据状态必须是待审批
	SELECT @OrderId = IAH_ID FROM InventoryAdjustHeader WHERE IAH_Inv_Adj_Nbr = @ReturnNo AND IAH_Reason in ('Return','Exchange') AND IAH_Status = 'Submitted'
	IF @@ROWCOUNT = 0
		RAISERROR ('退货单号不存在或单据已被处理',16,1);
		
	--记录单据日志
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Submit','eWorkflow提交退货申请')

	--记录日志
	INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_Message,IL_ClientID,IL_BatchNbr) 
	VALUES (NEWID(),'P_I_EW_GoodsReturnLock',GETDATE(),GETDATE(),'Success','接口调用成功：ReturnNo = '+@ReturnNo,'SYS',@BatchNbr)

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN

	--记录日志
	INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_Message,IL_ClientID,IL_BatchNbr) 
	VALUES (NEWID(),'P_I_EW_GoodsReturnLock',GETDATE(),GETDATE(),'Failure','接口调用失败：ReturnNo = '+@ReturnNo+' 错误信息：' + ERROR_MESSAGE(),'SYS',@BatchNbr)

    return -1
    
END CATCH

GO


