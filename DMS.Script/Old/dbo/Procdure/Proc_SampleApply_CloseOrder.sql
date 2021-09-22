DROP procedure [dbo].[Proc_SampleApply_CloseOrder]
GO



CREATE procedure [dbo].[Proc_SampleApply_CloseOrder]
 @HeaderId uniqueidentifier ,
 @UserName nvarchar(200)
as

begin 

	--修改样品申请单状态
	update SampleApplyHead set ApplyStatus = 'Complete'
	where SampleApplyHeadId = @HeaderId

	--获取订单是否被锁定
	declare @Islock int
	declare @ApplyId uniqueidentifier
	declare @DmaId uniqueidentifier
	declare @BumId uniqueidentifier
	declare @DmaName nvarchar(200)
	declare @OrderNo nvarchar(200)
	declare @OrderDate datetime
	declare @productNumber int
	declare @orderPrice decimal(18,6)
	declare @MailAddress nvarchar(200)

	select @Islock = POH_IsLocked,@ApplyId = POH_ID ,@OrderNo = POH_OrderNo,@DmaId = POH_DMA_ID,@DmaName = DMA_ChineseName,@OrderDate = POH_SubmitDate,@BumId = POH_ProductLine_BUM_ID
	from SampleApplyHead t1,PurchaseOrderHeader t2,DealerMaster t3
	where t1.ApplyNo = t2.POH_OrderNo
	and t2.POH_DMA_ID = t3.DMA_ID
	and SampleApplyHeadId = @HeaderId

	
	if(@Islock = 0)
	begin
		--修改申请单状态为申请关闭 
		--update t2
		--set t2.POH_OrderStatus = 'ApplyComplete'
		--from SampleApplyHead t1,PurchaseOrderHeader t2
		--where t1.ApplyNo = t2.POH_OrderNo
		--and SampleApplyHeadId = @HeaderId

		--订单操作日志
		INSERT INTO ScoreCardLog
		  (SCL_ID, SCL_ESC_ID, SCL_OperUser, SCL_OperDate, SCL_OperType, SCL_OperNote)
		VALUES
		  (NEWID(), @HeaderId, @UserName, GETDATE(), '申请关闭', '')
		
		insert into PurchaseOrderLog(POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
		values (NEWID(),@ApplyId,'00000000-0000-0000-0000-000000000000',GETDATE(),'ApplyComplete','')
		
		--发送邮件
		
		select @productNumber = SUM(t3.POD_RequiredQty),@orderPrice = SUM(t3.POD_Amount)
		from SampleApplyHead t1,PurchaseOrderHeader t2,PurchaseOrderDetail t3
		where t1.ApplyNo = t2.POH_OrderNo
		and t2.POH_ID = t3.POD_POH_ID
		and SampleApplyHeadId = @HeaderId
		
		DECLARE CUR_MAIL CURSOR  
		FOR
		SELECT  MDA_MailAddress AS MailAddress
		  FROM Client C, MailDeliveryAddress M
		  WHERE     C.CLT_ID = M.MDA_MailTo
		  AND C.CLT_Corp_Id IN
		  (SELECT DMA_parent_DMA_ID
		  FROM DealerMaster
		  WHERE DMA_ID = @DmaId)
		  AND M.MDA_ProductLineID = @BumId
		  AND M.MDA_MailType = 'Order'
		  AND M.MDA_ActiveFlag = 1
		  OPEN CUR_MAIL
		FETCH NEXT FROM CUR_MAIL INTO @MailAddress
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
		INSERT INTO MailMessageQueue
           SELECT newid(),'email','',t4.EMAIL1,REPLACE(REPLACE(MMT_Subject,'{#Dealer}',@DmaName),'{#OrderNo}',@OrderNo),
                   replace(replace(replace(replace(replace(MMT_Body,'{#Dealer}',@DmaName),'{#OrderDate}',Convert(nvarchar(20),GETDATE(),120)),'{#OrderNo}',@OrderNo),'{#OrderAmount}',@orderPrice),'{#ProductNumber}',@productNumber) AS MMT_Body,
                   'Waiting',getdate(),null
             from dealermaster t2, MailMessageTemplate t3,Lafite_IDENTITY t4
            where  t2.DMA_ID = @DmaId
				and t2.DMA_SAP_Code +'_01' = t4.IDENTITY_CODE
              and t3.MMT_Code='EMAIL_ORDER_APPLYCOMPLETE'
              	
              FETCH NEXT FROM CUR_MAIL INTO @MailAddress
		
			END
		CLOSE CUR_MAIL
		DEALLOCATE CUR_MAIL
	end

end



GO


