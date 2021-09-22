DROP PROCEDURE [interface].[P_I_EW_DealerEndoConsign2SalesApproval]
GO



CREATE PROCEDURE [interface].[P_I_EW_DealerEndoConsign2SalesApproval]
@OrderNo nvarchar(50),
@Status nvarchar(50),
@DealerType nvarchar(20),
@ResultValue int = 0 OUTPUT
AS
SET NOCOUNT ON


BEGIN TRY
BEGIN TRAN
 DECLARE @CentID nvarchar(50)

	   SELECT TOP 1 @CentID=client.CLT_ID FROM DealerMaster INNER JOIN client ON DealerMaster.DMA_Parent_DMA_ID=client.CLT_Corp_Id
	   INNER JOIN InventoryAdjustHeader ON InventoryAdjustHeader.IAH_DMA_ID=DealerMaster.DMA_ID
	   WHERE InventoryAdjustHeader.IAH_Inv_Adj_Nbr = @OrderNo and InventoryAdjustHeader.IAH_Reason='CTOS'

SELECT top 1 @DealerType = t2.DMA_DealerType FROM InventoryAdjustHeader t1, DealerMaster t2
 where t1.IAH_Inv_Adj_Nbr = @OrderNo and IAH_Reason='CTOS'
 and t1.IAH_DMA_ID = t2.DMA_ID

if(@DealerType='T2')
	BEGIN
	IF(@Status = 'Reject')
	begin
	--将该订单状态改为拒绝
	UPDATE InventoryAdjustHeader SET IAH_Status='Reject' WHERE IAH_Inv_Adj_Nbr=@OrderNo AND IAH_Reason='CTOS'
	--写入日志
	INSERT INTO PurchaseOrderLog SELECT NEWID(),IAH_ID,'00000000-0000-0000-0000-000000000000',GETDATE(),'Reject', 'RSM审批拒绝' FROM InventoryAdjustHeader WHERE IAH_Inv_Adj_Nbr=@OrderNo and IAH_Reason='CTOS'
	end
	else 
	begin
	--将订单状态改为待批
	UPDATE InventoryAdjustHeader SET IAH_Status='Submitted' WHERE IAH_Inv_Adj_Nbr=@OrderNo AND IAH_Reason='CTOS'
	--将审批通过的订单写入接口表
	INSERT INTO AdjustInterface SELECT NEWID(),'','',IAH_ID,IAH_Inv_Adj_Nbr,'Pending','Manual',NULL,IAH_CreatedBy_USR_UserID,GETDATE(),IAH_CreatedBy_USR_UserID,GETDATE(),@CentID FROM InventoryAdjustHeader WHERE IAH_Inv_Adj_Nbr=@OrderNo and IAH_Reason='CTOS'
	--写入日志
	INSERT INTO PurchaseOrderLog SELECT NEWID(),IAH_ID,'00000000-0000-0000-0000-000000000000',GETDATE(),'Approve','RSM审批确认' FROM InventoryAdjustHeader WHERE IAH_Inv_Adj_Nbr=@OrderNo and IAH_Reason='CTOS'
	end
	 INSERT INTO MailMessageQueue
		SELECT  newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#OrderNo}',IAH_Inv_Adj_Nbr),
					   replace(replace(replace(replace(MMT_Body,'{#UploadNo}',
					   IAH_Inv_Adj_Nbr),'{#Status}',@Status),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),
					   getdate(),20)) AS MMT_Body,
					   'Waiting',getdate(),null
				 from InventoryAdjustHeader t1, dealermaster t2, MailMessageTemplate t3,
					  (
						select t1.MDA_MailAddress from MailDeliveryAddress t1,dealermaster t2, client t3 , InventoryAdjustHeader t4
						where t1.MDA_MailType='Order' and t1.MDA_MailTo=t3.CLT_ID and t2.DMA_Parent_DMA_ID=t3.CLT_Corp_Id and t2.DMA_ID =t4.IAH_DMA_ID
						and t4.IAH_Inv_Adj_Nbr=@OrderNo and t1.MDA_ProductLineID=t4.IAH_ProductLine_BUM_ID
					  ) t4 
				where IAH_Inv_Adj_Nbr=@OrderNo and t1.IAH_DMA_ID=t2.DMA_ID
				  and t3.MMT_Code='EMAIL_DEALERENDOCONSIGN2SALES_APPROVAL'
				 
	END  

COMMIT TRAN
              
SET NOCOUNT OFF
SET @ResultValue = 0
return 0
END TRY
BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SELECT ERROR_MESSAGE()
    SET @ResultValue = -1
    return -1
    
END CATCH


GO


