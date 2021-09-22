DROP PROCEDURE [interface].[P_I_EW_DealerEndoOrderApproval]
GO



CREATE PROCEDURE [interface].[P_I_EW_DealerEndoOrderApproval]
@OrderNo nvarchar(50),
@Status nvarchar(50),
@DealerType nvarchar(20),
@ResultValue int = 0 OUTPUT
AS
SET NOCOUNT ON
--发送邮件


BEGIN TRY
BEGIN TRAN


SELECT top 1 @DealerType = t2.DMA_DealerType FROM purchaseorderheader t1, DealerMaster t2
 where POH_OrderNo = @OrderNo and POH_CreateType<>'Temporary'
 and t1.POH_DMA_ID = t2.DMA_ID

if(@DealerType='T2')
	BEGIN
	IF(@Status = 'Reject')
	begin
		INSERT INTO PurchaseOrderLog SELECT NEWID(),POH_ID,'00000000-0000-0000-0000-000000000000',GETDATE(),'Reject', 'RSM审批拒绝' FROM PurchaseOrderHeader WHERE POH_OrderNo=@OrderNo and POH_CreateType<>'Temporary'
	end
	else 
	begin
		INSERT INTO PurchaseOrderLog SELECT NEWID(),POH_ID,'00000000-0000-0000-0000-000000000000',GETDATE(),'Approve','RSM审批确认' FROM PurchaseOrderHeader WHERE POH_OrderNo=@OrderNo and POH_CreateType<>'Temporary'
	end
	
	
	 INSERT INTO MailMessageQueue
		SELECT  newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#OrderNo}',POH_OrderNo),
					   replace(replace(replace(replace(MMT_Body,'{#UploadNo}',
					   POH_OrderNo),'{#Status}',@Status),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),
					   getdate(),20)) AS MMT_Body,
					   'Waiting',getdate(),null
				 from PurchaseOrderHeader t1, dealermaster t2, MailMessageTemplate t3,
					  (
						select t1.MDA_MailAddress from MailDeliveryAddress t1,dealermaster t2, client t3 , PurchaseOrderHeader t4
						where t1.MDA_MailType='Order' and t1.MDA_MailTo=t3.CLT_ID and t2.DMA_Parent_DMA_ID=t3.CLT_Corp_Id and t2.DMA_ID =t4.POH_DMA_ID
						and t4.POH_OrderNo=@OrderNo and t1.MDA_ProductLineID=t4.POH_ProductLine_BUM_ID
					  ) t4,Warehouse t5
				where POH_OrderNo=@OrderNo and t1.POH_DMA_ID=t2.DMA_ID
				  and t3.MMT_Code='EMAIL_T2DEALERORDER_APPROVAL'
				  and t1.POH_WHM_ID =t5.WHM_ID
	END  
ELSE IF(@DealerType='T1')
    BEGIN
	 IF(@Status = 'Reject')
	 BEGIN
		UPDATE PurchaseOrderHeader SET POH_OrderStatus = 'Rejected' WHERE POH_OrderNo=@OrderNo
		
		--记录日志
		INSERT INTO PurchaseOrderLog SELECT NEWID(),POH_ID,'00000000-0000-0000-0000-000000000000',GETDATE(),'Reject','RSM审批拒绝' FROM PurchaseOrderHeader WHERE POH_OrderNo=@OrderNo and POH_CreateType<>'Temporary'
	 
	 END
	 ELSE
	 BEGIN
		 --记录日志
		 INSERT INTO PurchaseOrderLog SELECT NEWID(),POH_ID,'00000000-0000-0000-0000-000000000000',GETDATE(),'Approve','RSM审批确认' FROM PurchaseOrderHeader WHERE POH_OrderNo=@OrderNo and POH_CreateType<>'Temporary'
		 
		 INSERT INTO PurchaseOrderInterface
		 SELECT NEWID(),'','',POH_ID,POH_OrderNo,'Pending','Manual',NULL,POH_CreateUser,GETDATE(),POH_UpdateUser,GETDATE(),'EAI' FROM PurchaseOrderHeader
		 WHERE POH_OrderNo=@OrderNo
		    and not exists (select 1 from PurchaseOrderInterface t1 where t1.POI_POH_OrderNo = PurchaseOrderHeader.POH_OrderNo and t1.POI_Status='Pending' and t1.POI_ClientID = 'EAI' )
		    and POH_OrderStatus ='Submitted'
     END
     
     INSERT INTO MailMessageQueue
		SELECT  newid(),'email','',t4.EMAIL1,replace(MMT_Subject,'{#OrderNo}',POH_OrderNo),
					   replace(replace(replace(replace(MMT_Body,'{#UploadNo}',
					   POH_OrderNo),'{#Status}',@Status),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),
					   getdate(),20)) AS MMT_Body,
					   'Waiting',getdate(),null
					   --select *
				 from PurchaseOrderHeader t1, dealermaster t2, MailMessageTemplate t3,Lafite_IDENTITY t4,Warehouse t5
				where POH_OrderNo=@OrderNo and t1.POH_DMA_ID=t2.DMA_ID
				  and t3.MMT_Code='EMAIL_DEALERORDER_RSMAPPROVAL'
				  and POH_CreateUser = t4.Id
				  and t1.POH_WHM_ID =t5.WHM_ID
		union
		SELECT  newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#OrderNo}',POH_OrderNo),
					   replace(replace(replace(replace(MMT_Body,'{#UploadNo}',
					   POH_OrderNo),'{#Status}',@Status),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),
					   getdate(),20)) AS MMT_Body,
					   'Waiting',getdate(),null
				 from PurchaseOrderHeader t1, dealermaster t2, MailMessageTemplate t3,
					  (
						select t1.MDA_MailAddress from MailDeliveryAddress t1,PurchaseOrderHeader t4
						where t1.MDA_MailType='Order' and t1.MDA_MailTo = 'EAI'
						and t4.POH_OrderNo=@OrderNo and t1.MDA_ProductLineID=t4.POH_ProductLine_BUM_ID
					  ) t4,Warehouse t5
				where POH_OrderNo=@OrderNo and t1.POH_DMA_ID=t2.DMA_ID
				  and t3.MMT_Code='EMAIL_CSDEALERORDER_RSMAPPROVAL'
				  and t1.POH_WHM_ID =t5.WHM_ID
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


