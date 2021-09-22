DROP  Procedure [dbo].[GC_AutoEmailToRemindDealerUpload]
GO

/*
每月自动发邮件提醒经销商上传销量及库存数据
*/
CREATE Procedure [dbo].[GC_AutoEmailToRemindDealerUpload]
    @RemindType   NVARCHAR(50),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(MAX) OUTPUT
AS
	DECLARE @SysUserId uniqueidentifier
  DECLARE @CurMonthText nvarchar(10)
  DECLARE @NextMonthEndDate nvarchar(10)
  DECLARE @DifDate nvarchar(10)
  DECLARE @CurMonthLast5Day Datetime 
  DECLARE @DifDateBeginOfMon nvarchar(10)
  DECLARE @DifDateEndOfMon nvarchar(10)
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
  
  IF (@RemindType = 'EndOfMonthSalesUpload')
  Begin
    --仅当每月末倒数第5天到下个月的第二个工作日调用下面的程序
    --如果当前是月末倒数5天内，则发邮件  
    select @DifDateEndOfMon = datediff(day,getdate(),DATEADD(DAY,-5,CAST(CONVERT(VARCHAR(7),DATEADD(MONTH,1,GETDATE()),120)+'-01' AS DATETIME)))
    IF(@DifDateEndOfMon <=0)
      BEGIN
        --获取当前月份（12月），获取下月截止日期，获取当前日期与下月截止日期(第二个工作日)之间的天数差    
        select @NextMonthEndDate=Convert(nvarchar(2),Convert(int,Substring(CDD_Calendar,5,2)))+'月'+Convert(nvarchar(2),cdd_Date1)+'日' from CalendarDate where CDD_Calendar=convert(varchar(6),dateadd(mm,1,getdate()),112)    
        select @DifDate = Convert(nvarchar(8),datediff(day,getdate(), Convert(datetime,CDD_Calendar+right('00'+Convert(nvarchar(2),cdd_Date1),2))))+'天' from CalendarDate where CDD_Calendar=convert(varchar(6),dateadd(mm,1,getdate()),112)
        SELECT @CurMonthText = CONVERT (NVARCHAR (8), DATEPART (mm, getdate ())) + '月'
        
        INSERT INTO MailMessageQueue
        select newid(),'email','',isnull(t1.EMAIL1,t1.EMAIL2),t3.MSubject + '【'+ t2.DMA_ChineseName +'】',
               replace(replace(replace(t3.MBody,'{#TotalNumber}',Convert(nvarchar(50),t4.itemNumber)),'{#TotalAmount}',convert(nvarchar(20),convert(money,t4.totalAmount),1)),'{#DealerName}',t2.DMA_ChineseName),
               'Waiting',getdate(),null
        from Lafite_IDENTITY t1, dealermaster t2 ,
            ( select replace(MMT_Subject,'{#Month}',@CurMonthText) AS MSubject,replace(replace(replace(MMT_Body,'{#Month}',@CurMonthText),'{#RemainDays}',@DifDate),'{#EndDate}',@NextMonthEndDate) As MBody from MailMessageTemplate where MMT_Code='EMAIL_DEALER_UPLOAD_ALERT_01') t3,
            (	SELECT Head.SPH_Dealer_DMA_ID,
          			 SUM(ISNULL(Lot.SLT_LotShippedQty,0)) AS itemNumber,
          			 SUM(CONVERT(DECIMAL(18,6),ISNULL(Lot.SLT_LotShippedQty,0))*ISNULL(Lot.SLT_UnitPrice,0)) AS totalAmount
          			FROM ShipmentHeader Head,ShipmentLine Line,ShipmentLot Lot
          			WHERE Head.SPH_ID = Line.SPL_SPH_ID AND SPL_ID = Lot.SLT_SPL_ID		
          			AND Head.SPH_Status <> 'Draft'
                AND CONVERT(VARCHAR(6),Head.SPH_ShipmentDate,112) = CONVERT(VARCHAR(6),getdate(),112)
                group by Head.SPH_Dealer_DMA_ID ) t4
         where t1.BOOLEAN_FLAG=1 and t1.Corp_ID=t2.DMA_ID and t2.DMA_ActiveFlag=1 and t2.DMA_DealerType in ('T1','T2')
              and (t1.EMAIL1 is not null OR t1.EMAIL2 is not null) and (len(t1.EMAIL1) > 1 OR len(t1.EMAIL2)>0) 
              and t1.Corp_ID = t4.SPH_Dealer_DMA_ID
      END
    --如果当前是月初第二个工作日之前，则发邮件
    select @DifDateBeginOfMon = datediff(day,getdate(),Convert(datetime,CDD_Calendar+ right('00'+Convert(nvarchar(2),cdd_Date1),2))) from CalendarDate where CDD_Calendar=convert(varchar(6),getdate(),112)
    IF(@DifDateBeginOfMon >=0) 
      BEGIN            
        select @NextMonthEndDate=Convert(nvarchar(2),Convert(int,Substring(CDD_Calendar,5,2)))+'月'+Convert(nvarchar(2),cdd_Date1)+'日' from CalendarDate where CDD_Calendar=convert(varchar(6),getdate(),112)    
        select @DifDate = Convert(nvarchar(8),datediff(day,getdate(), Convert(datetime,CDD_Calendar+right('00'+Convert(nvarchar(2),cdd_Date1),2))))+'天' from CalendarDate where CDD_Calendar=convert(varchar(6),getdate(),112)
        SELECT @CurMonthText = CONVERT (NVARCHAR (8), DATEPART (mm, dateadd(mm,-1,getdate()))) + '月'
        
        insert into MailMessageQueue
        select newid(),'email','',isnull(t1.EMAIL1,t1.EMAIL2),t3.MSubject + '【'+ t2.DMA_ChineseName +'】',
        replace(replace(replace(t3.MBody,'{#TotalNumber}',Convert(nvarchar(50),t4.itemNumber)),'{#TotalAmount}',convert(nvarchar(20),convert(money,t4.totalAmount),1)),'{#DealerName}',t2.DMA_ChineseName),
        'Waiting',getdate(),null
        from Lafite_IDENTITY t1, dealermaster t2 ,
            ( select replace(MMT_Subject,'{#Month}',@CurMonthText) AS MSubject,replace(replace(replace(MMT_Body,'{#Month}',@CurMonthText),'{#RemainDays}',@DifDate),'{#EndDate}',@NextMonthEndDate) As MBody from MailMessageTemplate where MMT_Code='EMAIL_DEALER_UPLOAD_ALERT_01') t3,
            (	SELECT Head.SPH_Dealer_DMA_ID,
          			 SUM(ISNULL(Lot.SLT_LotShippedQty,0)) AS itemNumber,
          			 SUM(CONVERT(DECIMAL(18,6),ISNULL(Lot.SLT_LotShippedQty,0))*ISNULL(Lot.SLT_UnitPrice,0)) AS totalAmount
          			FROM ShipmentHeader Head,ShipmentLine Line,ShipmentLot Lot
          			WHERE Head.SPH_ID = Line.SPL_SPH_ID AND SPL_ID = Lot.SLT_SPL_ID		
          			AND Head.SPH_Status <> 'Draft'
                AND CONVERT(VARCHAR(6),Head.SPH_ShipmentDate,112) = CONVERT(VARCHAR(6),dateadd(mm,-1,getdate()),112)
                group by Head.SPH_Dealer_DMA_ID ) t4
         where t1.BOOLEAN_FLAG=1 and t1.Corp_ID=t2.DMA_ID and t2.DMA_ActiveFlag=1 and t2.DMA_DealerType in ('T1','T2')
              and (t1.EMAIL1 is not null OR t1.EMAIL2 is not null) and (len(t1.EMAIL1) > 1 OR len(t1.EMAIL2)>0)
              and t1.Corp_ID = t4.SPH_Dealer_DMA_ID
      END
  END
  
  IF (@RemindType = 'EndOfMonthInventoryUpload')
  BEGIN      
      select @DifDateEndOfMon = datediff(day,getdate(),DATEADD(DAY,-1,CAST(CONVERT(VARCHAR(7),DATEADD(MONTH,1,GETDATE()),120)+'-01' AS DATETIME)))
      IF(@DifDateEndOfMon = 0)
        BEGIN         
          select @NextMonthEndDate=Convert(nvarchar(2),Convert(int,Substring(CDD_Calendar,5,2)))+'月'+Convert(nvarchar(2),cdd_Date2)+'日' from CalendarDate where CDD_Calendar=convert(varchar(6),dateadd(mm,1,getdate()),112)    
          select @DifDate = Convert(nvarchar(8),datediff(day,getdate(), Convert(datetime,CDD_Calendar+right('00'+Convert(nvarchar(2),cdd_Date2),2))))+'天' from CalendarDate where CDD_Calendar=convert(varchar(6),dateadd(mm,1,getdate()),112)
          SELECT @CurMonthText = CONVERT (NVARCHAR (8), DATEPART (mm, getdate ())) + '月'
          
          INSERT INTO MailMessageQueue
          select newid(),'email','',isnull(t1.EMAIL1,t1.EMAIL2),t3.MSubject  + '【'+ t2.DMA_ChineseName +'】',
                 replace(replace(replace(replace(t3.MBody,'{#NormalInventory}',Convert(nvarchar(50),t4.itemNumberNormal,1)),'{#ConsignmentInventory}',convert(nvarchar(20),t4.itemNumberConsignment,1)),'{#SysholdInventory}',convert(nvarchar(20),t4.itemNumberSystemHold,1)),'{#DealerName}',t2.DMA_ChineseName),
                 'Waiting',getdate(),null
          from Lafite_IDENTITY t1, dealermaster t2 ,
              ( select replace(MMT_Subject,'{#Month}',@CurMonthText) AS MSubject,replace(MMT_Body,'{#NextMonthEndDate}',@NextMonthEndDate) As MBody from MailMessageTemplate where MMT_Code='EMAIL_DEALER_UPLOAD_ALERT_02') t3,
              (	
                  select WHM_DMA_ID,sum(itemNumberNormal) AS itemNumberNormal,sum(itemNumberConsignment) AS itemNumberConsignment
                         ,sum(itemNumberSystemHold) AS itemNumberSystemHold
                    from (
                    select WHM_DMA_ID,
                           sum(case when type='Normal' then isnull(itemNumber,0) else 0 end) AS itemNumberNormal,
                           sum(case when type='Consignment' then isnull(itemNumber,0) else 0 end) AS itemNumberConsignment,
                           sum(case when type='SystemHold' then isnull(itemNumber,0) else 0 end) AS itemNumberSystemHold
                           from (
                    SELECT W.WHM_DMA_ID,ISNULL(sum (CONVERT (DECIMAL (18, 2), isnull (Inv_onhandQuantity, 0))),0) AS itemNumber,'Normal' AS Type
                    		  FROM Inventory I, Warehouse W
                    		 WHERE I.INV_WHM_ID = W.WHM_ID
                           and W.WHM_Type IN ('Normal', 'DefaultWH')
                           group by W.WHM_DMA_ID
                    union all
                    SELECT W.WHM_DMA_ID,ISNULL(sum (CONVERT (DECIMAL (18, 2), isnull (Inv_onhandQuantity, 0))),0) AS itemNumber,'Consignment' AS Type
                    		  FROM Inventory I, Warehouse W
                    		 WHERE I.INV_WHM_ID = W.WHM_ID
                           and W.WHM_Type IN ('Consignment', 'LP_Consignment','Borrow')
                           group by W.WHM_DMA_ID
                    union all						  
                    SELECT W.WHM_DMA_ID,ISNULL(sum (CONVERT (DECIMAL (18, 2), isnull (Inv_onhandQuantity, 0))),0) AS itemNumber,'SystemHold' AS Type
                    		  FROM Inventory I, Warehouse W
                    		 WHERE I.INV_WHM_ID = W.WHM_ID
                           and W.WHM_Type IN ('SystemHold')
                           group by W.WHM_DMA_ID	
                    ) AS tab group by WHM_DMA_ID,type
                    ) DealerInv
                    group by WHM_DMA_ID
              ) t4
           where t1.BOOLEAN_FLAG=1 and t1.Corp_ID=t2.DMA_ID and t2.DMA_ActiveFlag=1 and t2.DMA_DealerType in ('T1','T2')
                and (t1.EMAIL1 is not null OR t1.EMAIL2 is not null) and (len(t1.EMAIL1) > 1 OR len(t1.EMAIL2)>0) 
                and t1.Corp_ID = t4.WHM_DMA_ID
        END
  
  END
  
COMMIT TRAN
SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
	
	--记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
    
END CATCH
GO


