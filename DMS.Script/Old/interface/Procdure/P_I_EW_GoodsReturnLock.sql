DROP Procedure [interface].[P_I_EW_GoodsReturnLock]
GO

/*
ƽ̨�˻�ȷ�����ݴ���
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

	--�����˻����Ų�ѯ�����Ƿ���ڣ��ҵ���״̬�����Ǵ�����
	SELECT @OrderId = IAH_ID FROM InventoryAdjustHeader WHERE IAH_Inv_Adj_Nbr = @ReturnNo AND IAH_Reason in ('Return','Exchange') AND IAH_Status = 'Submitted'
	IF @@ROWCOUNT = 0
		RAISERROR ('�˻����Ų����ڻ򵥾��ѱ�����',16,1);
		
	--��¼������־
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Submit','eWorkflow�ύ�˻�����')

	--��¼��־
	INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_Message,IL_ClientID,IL_BatchNbr) 
	VALUES (NEWID(),'P_I_EW_GoodsReturnLock',GETDATE(),GETDATE(),'Success','�ӿڵ��óɹ���ReturnNo = '+@ReturnNo,'SYS',@BatchNbr)

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN

	--��¼��־
	INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_Message,IL_ClientID,IL_BatchNbr) 
	VALUES (NEWID(),'P_I_EW_GoodsReturnLock',GETDATE(),GETDATE(),'Failure','�ӿڵ���ʧ�ܣ�ReturnNo = '+@ReturnNo+' ������Ϣ��' + ERROR_MESSAGE(),'SYS',@BatchNbr)

    return -1
    
END CATCH

GO


