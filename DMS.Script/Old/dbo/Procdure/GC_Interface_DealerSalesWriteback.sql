DROP PROCEDURE [dbo].[GC_Interface_DealerSalesWriteback]
GO


CREATE PROCEDURE [dbo].[GC_Interface_DealerSalesWriteback]
   @BatchNbr NVARCHAR (30),
   @ClientID NVARCHAR (50),
   @IsValid NVARCHAR (20) OUTPUT,
   @RtnMsg NVARCHAR (4000) OUTPUT
AS
   DECLARE @ErrorCount    INTEGER
   DECLARE @SysUserId     UNIQUEIDENTIFIER
   DECLARE @DealerId uniqueidentifier
   DECLARE @OrderType nvarchar(50)
   SET  NOCOUNT ON

BEGIN TRY
      BEGIN TRAN
      SET @IsValid = 'Success'
      SET @RtnMsg = ''
      SET @SysUserId = '00000000-0000-0000-0000-000000000000'
      SET @OrderType = 'ClearBorrowManual'  --��ָ������

	--�������۵���ID
	update InterfaceDealerSalesWriteback
	set IDW_ShipmentID = SPH_ID
	from ShipmentHeader 
	where IDW_SalesNo = SPH_ShipmentNbr
	and IDW_BatchNbr = @BatchNbr
	
	--У�����۵����Ƿ���ȷ
	update InterfaceDealerSalesWriteback
	set IDW_ErrorMsg = N'���۵������д����ȷ'
	where IDW_ShipmentID = '00000000-0000-0000-0000-000000000000'
	and IDW_BatchNbr = @BatchNbr

	 --У���������۵�����Ƿ����ڸ�ƽ̨����
	update t1
	set t1.IDW_ErrorMsg = N'�����۵���Ų������������'
	--select *
	from InterfaceDealerSalesWriteback t1
	left join ShipmentHeader t2
	on t1.IDW_SalesNo = t2.SPH_ShipmentNbr
	left join DealerMaster t3
	on t2.SPH_Dealer_DMA_ID = t3.DMA_ID
	left join Client t4
	on t3.DMA_Parent_DMA_ID = t4.CLT_Corp_Id 
	and t4.CLT_ID = @ClientID
	where t1.IDW_BatchNbr = @BatchNbr
	and t4.CLT_Corp_Id is null
	and (t1.IDW_ErrorMsg is null or t1.IDW_ErrorMsg = '')

	

	 --У���������۵�����Ƿ��Ѿ����
	update t1
	set t1.IDW_ErrorMsg = N'�����۵�����ѱ����'
	--select *
	from InterfaceDealerSalesWriteback t1
	left join ShipmentHeader t2
	on t1.IDW_SalesNo = t2.SPH_ShipmentNbr
	left join DealerMaster t3
	on t2.SPH_Dealer_DMA_ID = t3.DMA_ID
	left join Client t4
	on t3.DMA_Parent_DMA_ID = t4.CLT_Corp_Id 
	and t4.CLT_ID = @ClientID
	where t1.IDW_BatchNbr = @BatchNbr
	and t2.SPH_Status = 'Reversed'
	and (t1.IDW_ErrorMsg is null or t1.IDW_ErrorMsg = '')
  
  --У���Ƿ��Ѿ����˵�6��������
  --����6�������ջ�ȡ�ϸ��µĵ�һ��������
  Declare @FirstDayLastMonth Datetime
  select @FirstDayLastMonth = DATEADD(mm, DATEDIFF(mm,0,Convert(datetime,min(t1.CDD_Calendar+Right('00' + cast(t1.cdd_date1 as nvarchar(2)),2))))-1, 0) 
  from CalendarDate t1,(select Convert(nvarchar(8), max( IDW_ImportDate),112) AS Date from InterfaceDealerSalesWriteback where IDW_BatchNbr = @BatchNbr) t2
  where convert(int,t1.CDD_Calendar+Right('00' + cast(t1.cdd_date1 as nvarchar(2)),2))>=Convert(int,t2.Date)
  
  --������۵�����������С���ϸ��µĵ�һ�������գ��򱨴�
 
  update t1
	set t1.IDW_ErrorMsg = N'��ǰ�����ѳ�����6�������գ����ܳ���ϸ��µ����۵�'
	--select *
	from InterfaceDealerSalesWriteback t1
	left join ShipmentHeader t2
	on t1.IDW_SalesNo = t2.SPH_ShipmentNbr
	left join DealerMaster t3
	on t2.SPH_Dealer_DMA_ID = t3.DMA_ID
	left join Client t4
	on t3.DMA_Parent_DMA_ID = t4.CLT_Corp_Id 
	and t4.CLT_ID = @ClientID
	where t1.IDW_BatchNbr = @BatchNbr
	and t2.SPH_ShipmentDate < @FirstDayLastMonth
	and (t1.IDW_ErrorMsg is null or t1.IDW_ErrorMsg = '')
    
	--У���Ƿ��ж�Ӧ����ָ�����Ŷ���
     Declare @cnt int
     select @cnt = COUNT(*) from InterfaceDealerSalesWriteback t1
	  left join PurchaseOrderHeader t2
	  on t1.IDW_SalesNo = t2.POH_Remark
	  and t2.POH_OrderType=@OrderType
	  where t2.POH_ID is not null
	  and t1.IDW_BatchNbr = @BatchNbr
	
	--���������������壬���������ж��ֹ���ָ�����Ŷ�����״̬
	IF (@cnt > 0)
	BEGIN
		declare @status nvarchar(20);
		select @status = POH_OrderStatus from InterfaceDealerSalesWriteback t1
		  inner join PurchaseOrderHeader t2
		  on t1.IDW_SalesNo = t2.POH_Remark
		  and t2.POH_OrderType=@OrderType
		where t1.IDW_BatchNbr = @BatchNbr
		  
		--�ݸ�״̬ʱ���ɵ��ţ��������õ��ݣ��ǲݸ�״̬��������
		IF(@status = 'Draft')
		BEGIN
			DECLARE @m_DmaId uniqueidentifier
			DECLARE @m_ProductLine uniqueidentifier
			DECLARE @m_Id uniqueidentifier
			DECLARE @m_OrderNo nvarchar(50)

			DECLARE	curHandleOrderNo CURSOR 
			FOR SELECT POH_ID,POH_DMA_ID,POH_ProductLine_BUM_ID FROM InterfaceDealerSalesWriteback,PurchaseOrderHeader WHERE IDW_SalesNo = POH_Remark and IDW_BatchNbr = @BatchNbr

			OPEN curHandleOrderNo
			FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_ProductLine

			WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC dbo.[GC_GetNextAutoNumberForPO] @m_DmaId,'Next_PurchaseOrder',@m_ProductLine, @OrderType, @m_OrderNo output
				UPDATE PurchaseOrderHeader SET POH_OrderNo = @m_OrderNo,POH_OrderStatus = 'Revoked' WHERE POH_ID = @m_Id
				FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_ProductLine
			END

			CLOSE curHandleOrderNo
			DEALLOCATE curHandleOrderNo
		END
		ELSE
		BEGIN
			update InterfaceDealerSalesWriteback
			set IDW_ErrorMsg = N'�����۵���Ų��ܳ��'
			where IDW_BatchNbr = @BatchNbr
			and (IDW_ErrorMsg is null or IDW_ErrorMsg = '')
		END
		select * from client
		
		
	END
	
	
 COMMIT TRAN	
	
SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @IsValid = 'Failure'
	
	--��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
    
END CATCH


GO


