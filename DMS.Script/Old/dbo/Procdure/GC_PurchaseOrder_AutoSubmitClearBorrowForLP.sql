DROP PROCEDURE [dbo].[GC_PurchaseOrder_AutoSubmitClearBorrowForLP]	
GO

/*
* 自动提交清指定批号订单
*/
CREATE PROCEDURE [dbo].[GC_PurchaseOrder_AutoSubmitClearBorrowForLP]	
	@RtnVal nvarchar(20) OUTPUT,
	@RtnMsg  nvarchar(2000)  OUTPUT
as	
SET NOCOUNT ON
BEGIN TRY

BEGIN TRAN
	DECLARE @SysUserId uniqueidentifier
  DECLARE @VENDORID uniqueidentifier
  DECLARE @OrderType nvarchar(50)
 
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'  
	SET @OrderType = 'ClearBorrowManual'  --清指定批号
 
	create table #tmp_PurchaseOrderHeader (
   POH_ID               uniqueidentifier     not null,
   POH_OrderNo          nvarchar(30)         collate Chinese_PRC_CI_AS null,
   POH_ProductLine_BUM_ID uniqueidentifier     null,
   POH_DMA_ID           uniqueidentifier     null,
   POH_VendorID         nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_TerritoryCode    nvarchar(200)        null,
   POH_RDD              datetime             null,
   POH_ContactPerson    nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_Contact          nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_ContactMobile    nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_Consignee        nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_ShipToAddress    nvarchar(200)        collate Chinese_PRC_CI_AS null,
   POH_ConsigneePhone   nvarchar(200)        collate Chinese_PRC_CI_AS null,
   POH_Remark           nvarchar(400)        collate Chinese_PRC_CI_AS null,
   POH_InvoiceComment   nvarchar(200)        collate Chinese_PRC_CI_AS null,
   POH_CreateType       nvarchar(20)         not null,
   POH_CreateUser       uniqueidentifier     not null,
   POH_CreateDate       datetime             not null,
   POH_UpdateUser       uniqueidentifier     null,
   POH_UpdateDate       datetime             null,
   POH_SubmitUser       uniqueidentifier     null,
   POH_SubmitDate       datetime             null,
   POH_LastBrowseUser   uniqueidentifier     null,
   POH_LastBrowseDate   datetime             null,
   POH_OrderStatus      nvarchar(20)         collate Chinese_PRC_CI_AS not null,
   POH_LatestAuditDate  datetime             null,
   POH_IsLocked         bit                  not null,
   POH_SAP_OrderNo      nvarchar(50)         null,
   POH_SAP_ConfirmDate  datetime             null,
   POH_LastVersion      int                  not null,
   POH_OrderType nvarchar(50) collate Chinese_PRC_CI_AS null,
   POH_VirtualDC nvarchar(50) null,
   POH_SpecialPriceID uniqueidentifier null,
   POH_WHM_ID uniqueidentifier null,
   POH_POH_ID uniqueidentifier null,   
   ERROR_FLAG bit,
   ERROR_MSG nvarchar(2000) null, 
   primary key (POH_ID)
  )
  
  --获取需要自动提交的单据
  INSERT #tmp_PurchaseOrderHeader
  SELECT POH_ID,
			POH_OrderNo,
			POH_ProductLine_BUM_ID,
			POH_DMA_ID,
			POH_VendorID,
			POH_TerritoryCode,
			POH_RDD,
			POH_ContactPerson,
			POH_Contact,
			POH_ContactMobile,
			POH_Consignee,
			POH_ShipToAddress,
			POH_ConsigneePhone,
			POH_Remark,
			POH_InvoiceComment,
			POH_CreateType,
			POH_CreateUser,
			POH_CreateDate,
			POH_UpdateUser,
			POH_UpdateDate,
			POH_SubmitUser,
			POH_SubmitDate,
			POH_LastBrowseUser,
			POH_LastBrowseDate,
			POH_OrderStatus,
			POH_LatestAuditDate,
			POH_IsLocked,
			POH_SAP_OrderNo,
			POH_SAP_ConfirmDate,
			POH_LastVersion,
			POH_OrderType,
			POH_VirtualDC,
			POH_SpecialPriceID,
			POH_WHM_ID,
			POH_POH_ID,0 AS ERROR_FLAG,null AS ERROR_MSG
    FROM PurchaseOrderHeader
   WHERE     POH_OrderType IN ('ClearBorrowManual')
       AND POH_CreateType = 'Manual'
       AND POH_OrderStatus = 'Draft'
       AND POH_DMA_ID IN (SELECT DMA_ID FROM DealerMaster WHERE DMA_DealerType = 'LP')
       AND CONVERT (NVARCHAR (8), POH_SubmitDate, 112) = CONVERT (NVARCHAR (8), getdate (), 112)
       AND POH_ID IN (SELECT POH_ID FROM PurchaseOrderHeader_AutoGenLog WHERE (POH_SAP_OrderNo <> 'ClearBorrow' or POH_SAP_OrderNo is null))

  --判断是否可以自动提交
  --判断收货地址是否存在、判断收货仓库是否存在、判断明细是否存在、判断承运商是否存在
  UPDATE #tmp_PurchaseOrderHeader
     SET ERROR_MSG = isnull(ERROR_MSG,'')+N'收货地址不正确,',ERROR_FLAG = 1
   WHERE POH_ShipToAddress IS NULL OR 
     NOT Exists (select 1 from SAPWarehouseAddress 
                     where SWA_DMA_ID=#tmp_PurchaseOrderHeader.POH_DMA_ID 
                       and #tmp_PurchaseOrderHeader.POH_ShipToAddress=SWA_WH_Address)
                       
  UPDATE #tmp_PurchaseOrderHeader
     SET ERROR_MSG = isnull(ERROR_MSG,'')+N'收货仓库没有选择,',ERROR_FLAG = 1
   WHERE POH_WHM_ID IS NULL 
  
  UPDATE #tmp_PurchaseOrderHeader
     SET ERROR_MSG = isnull(ERROR_MSG,'')+N'没有明细行数据,',ERROR_FLAG = 1
   WHERE NOT EXISTS (select 1 from PurchaseOrderDetail POD where POD.POD_POH_ID=#tmp_PurchaseOrderHeader.POH_ID )
   
  UPDATE #tmp_PurchaseOrderHeader
     SET ERROR_MSG = isnull(ERROR_MSG,'')+N'没有承运商信息,',ERROR_FLAG = 1
   WHERE POH_TerritoryCode IS NULL
  
	
	--生成单据号
	DECLARE @m_DmaId uniqueidentifier
	DECLARE @m_ProductLine uniqueidentifier
	DECLARE @m_Id uniqueidentifier
	DECLARE @m_OrderNo nvarchar(50)

	DECLARE	curHandleOrderNo CURSOR 
	FOR SELECT POH_ID,POH_DMA_ID,POH_ProductLine_BUM_ID FROM #tmp_PurchaseOrderHeader WHERE ERROR_FLAG=0

	OPEN curHandleOrderNo
	FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_ProductLine

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC dbo.[GC_GetNextAutoNumberForPO] @m_DmaId,'Next_PurchaseOrder',@m_ProductLine, @OrderType, @m_OrderNo output
				
		--判断是否修改过价格，如果修改过，则加上后缀S
		IF((select count(*) as cnt
		  from (
		  select 1 as cnt from (
		  select sum(t1.POD_CFN_Price) as Price1, sum(t2.POD_CFN_Price) as Price2 from PurchaseOrderDetail t1,PurchaseOrderDetail_AutoGenLog t2
		  where t1.POD_ID = t2.POD_ID
		  and t1.POD_POH_ID = @m_Id
		  ) tab
		  where Price1 <> Price2
		  union
		  select 1 from (
		  select sum(t1.POD_CFN_Price) as Price1, sum(t2.POD_CFN_Price) as Price2,T3.CFN_ProductLine_BUM_ID as BUM1,t4.CFN_ProductLine_BUM_ID as BUM2 from PurchaseOrderDetail t1,PurchaseOrderDetail_AutoGenLog t2,
		  CFN t3,CFN t4
		  where t1.POD_POH_ID = t2.POD_POH_ID
		  and t1.POD_CFN_ID = T3.CFN_ID
		  AND T2.POD_CFN_ID = T4.CFN_ID
		  and t1.POD_POH_ID = @m_Id
		  group by T3.CFN_ProductLine_BUM_ID,t4.CFN_ProductLine_BUM_ID
		  ) tab
		  where (Price1 <> Price2 or BUM1 <> BUM2)
		  union
		  select 1 from (
		  select t2.POD_CFN_Price as Price1, CFNP_Price as Price2 from PurchaseOrderHeader t1,PurchaseOrderDetail t2,CFNPrice t3
		  where t1.POH_ID = t2.POD_POH_ID
		  and t1.POH_DMA_ID = t3.CFNP_Group_ID
		  and t2.POD_CFN_ID = t3.CFNP_CFN_ID
		  and t3.CFNP_PriceType = 'Dealer'
		  and t1.POH_ID = @m_Id
		  ) tab
		  where (Price1 <> Price2)
		  ) tab2) > 0)
		  BEGIN
			  UPDATE #tmp_PurchaseOrderHeader SET POH_OrderNo = @m_OrderNo+'S' WHERE POH_ID = @m_Id
		  END
		  ELSE 
		  BEGIN
			  UPDATE #tmp_PurchaseOrderHeader SET POH_OrderNo = @m_OrderNo WHERE POH_ID = @m_Id
		  END
          
		
		FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_ProductLine
	END

	CLOSE curHandleOrderNo
	DEALLOCATE curHandleOrderNo
	
	 
	
	--插入订单主表和明细表	
  update t1 
    set t1.POH_OrderNo =t2.POH_OrderNo,t1.POH_SubmitDate=getdate(),t1.POH_SubmitUser=@SysUserId, t1.POH_OrderStatus='Submitted'
  from PurchaseOrderHeader t1, #tmp_PurchaseOrderHeader t2
  where t1.POH_ID=t2.POH_ID and t2.ERROR_FLAG=0  
  
	--插入订单操作日志
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),POH_ID,POH_CreateUser,GETDATE(),'Generate','系统自动提交订单' FROM #tmp_PurchaseOrderHeader WHERE ERROR_FLAG=0
    
  --插入接口表
	INSERT INTO PurchaseOrderInterface
	SELECT NEWID(),'','',POH_ID,POH_OrderNo,'Pending','Manual',NULL,POH_CreateUser,GETDATE(),POH_CreateUser,GETDATE(),CLT_ID
	FROM #tmp_PurchaseOrderHeader left join Client
	on POH_VendorID = CLT_Corp_Id
  WHERE #tmp_PurchaseOrderHeader.ERROR_FLAG=0
    
  INSERT INTO PurchaseOrderInterface
	SELECT NEWID(),'','',POH_ID,POH_OrderNo,'Pending','Manual',NULL,POH_CreateUser,GETDATE(),POH_CreateUser,GETDATE(),CLT_ID
	FROM #tmp_PurchaseOrderHeader left join Client
	on POH_DMA_ID = CLT_Corp_Id
  WHERE #tmp_PurchaseOrderHeader.ERROR_FLAG=0
  
  --记录日志
  insert into PurchaseOrderHeader_AutoSubmitLog
  Select *,getdate() from #tmp_PurchaseOrderHeader  
  
  --正确的订单发邮件通知BSC相关人员
  INSERT INTO MailMessageQueue
     select newid(),'email','',MDA_MailAddress,replace(replace(MMT_Subject,'{#Dealer}',DM.DMA_ChineseName),'{#OrderNo}',POAS.POH_OrderNo),
        replace(replace(replace(replace(replace(replace(MMT_Body,'{#Dealer}',DM.DMA_ChineseName),'{#OrderNo}',POAS.POH_OrderNo),'{#OrderDate}',Convert(nvarchar(10),getdate(),20)+' '+Convert(nvarchar(10),getdate(),08)),'{#OrderAmount}',(select Convert(nvarchar(20),Convert(decimal(18,2),sum(POD.POD_Amount ))) from PurchaseOrderDetail AS POD where POD.POD_POH_ID=POAS.POH_ID )),'{#ProductNumber}',(select Convert(nvarchar(20),convert(int,sum(POD.POD_RequiredQty ))) from PurchaseOrderDetail AS POD where POD.POD_POH_ID=POAS.POH_ID )),'{#Summary}',ContentTable.HTMLTable),
        'Waiting',getdate(),null
   from #tmp_PurchaseOrderHeader AS POAS,Client C, MailDeliveryAddress M, DealerMaster AS DM,
        (
     
     select poh_id, Header+replace(replace(replace(StringHTML,'{#template1}','<TR><TD style="BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'),'{#template2}','</TD><TD style="BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'),'{#template3}','</TD></TR>')+Tail AS HTMLTable
      from (
             select POAS.POH_ID, '<TABLE style="BACKGROUND: #ccccff; border:1px solid" cellSpacing="3" cellPadding="0"><TBODY><TR><TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt"><STRONG><SPAN style="FONT-FAMILY: 宋体">Division</SPAN></STRONG></TD><TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt"><STRONG><SPAN style="FONT-FAMILY: 宋体">Level2</SPAN></STRONG></TD><TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt"><STRONG><SPAN style="FONT-FAMILY: 宋体">Qty</SPAN></STRONG></TD><TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt"><STRONG><SPAN style="FONT-FAMILY: 宋体">Amount</SPAN></STRONG></TD></TR>' AS Header,
                    [StringHTML] = STUFF((  select ' '+[StringHTML] 
                                              from (
                                                    select '{#template1}'
                                                           + div.ATTRIBUTE_NAME 
                                                           + '{#template2}'
                                                           + CFN.CFN_Level2Desc
                                                           + '{#template2}'
                                                           + convert(nvarchar(20),convert(int,sum(detail.POD_RequiredQty)))
                                                           + '{#template2}'
                                                           + convert(nvarchar(20),convert(decimal(18,2),sum(detail.POD_Amount)))
                                                           + '{#template3}' AS StringHTML
                                                        from PurchaseOrderDetail detail
                                                        inner join CFN on CFN.CFN_ID = detail.POD_CFN_ID
                                                        inner join (select b.ATTRIBUTE_NAME, c.AttributeID from View_BU b
                                                        inner join Cache_OrganizationUnits c on c.RootID = b.Id and c.AttributeType = 'Product_Line') as div
                                                        on div.AttributeID = CFN.CFN_ProductLine_BUM_ID
                                                        where detail.POD_POH_ID = POAS.POH_ID
                                                        group by div.ATTRIBUTE_NAME,CFN.CFN_Level2Desc
                                                   ) StringTab
                                               FOR XML PATH('')), 1, 1, ''),
                  '<TR><TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">&nbsp;</TD><TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt"><STRONG><SPAN style="FONT-FAMILY: 宋体">Total</SPAN></STRONG></TD><TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt"><STRONG><SPAN style="FONT-FAMILY: 宋体">'
                  + (select Convert(nvarchar(20),convert(int,sum(POD.POD_RequiredQty ))) from PurchaseOrderDetail AS POD where POD.POD_POH_ID=POAS.POH_ID )
                  + '</SPAN></STRONG></TD><TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt"><STRONG><SPAN style="FONT-FAMILY: 宋体">'
                  + (select Convert(nvarchar(20),Convert(decimal(18,2),sum(POD.POD_Amount ))) from PurchaseOrderDetail AS POD where POD.POD_POH_ID=POAS.POH_ID )
                  + 'RMB</SPAN></STRONG></TD></TR></TBODY></TABLE>' AS Tail                       
       from #tmp_PurchaseOrderHeader AS POAS      
      ) BodyHTML
           ) AS ContentTable,MailMessageTemplate
where C.CLT_ID = M.MDA_MailTo AND M.MDA_ProductLineID = POAS.POH_ProductLine_BUM_ID
      AND M.MDA_MailType = 'Order'  
      AND M.MDA_ActiveFlag = 1
      and MDA_MailTo='EAI'
      and DM.DMA_ID=POAS.POH_DMA_ID
      and ContentTable.poh_id=POAS.poh_id
      and MMT_Code='EMAIL_ORDER_SUBMIT'
      and ERROR_FLAG=0
  
  
  --错误信息发邮件给平台相关人员
  if Exists (select 1 from #tmp_PurchaseOrderHeader where ERROR_FLAG=1)
    BEGIN
      INSERT INTO MailMessageQueue     
      SELECT newid(),'email','',MA.MDA_MailAddress,replace(MMT_Subject,'{#GenDate}',Convert(nvarchar(10),getdate(),20)),
                   replace(replace(MMT_Body,'{#GenDate}',Convert(nvarchar(10),getdate(),20)),'{#RowNum}',convert(VARCHAR(10),RowNum)) AS MMT_Body,
                   'Waiting',getdate(),null
      from (
      select POH_DMA_ID,count(*) AS RowNum from #tmp_PurchaseOrderHeader where ERROR_FLAG=1 group by POH_DMA_ID) AS POH,Client ,
      MailDeliveryAddress AS MA,MailMessageTemplate AS MT
      where Client.CLT_Corp_Id=POH.POH_DMA_ID
      and Client.CLT_ID = MA.MDA_MailTo and MA.MDA_MailType='OrderAutoSubmitError'
      and MT.MMT_Code='EMAIL_ORDER_ERROR_AUTOSUBMITCLEARBORROW'
    END
  
		
		--在日志中写入销售单生成清指定批号订单的日志【销售】
--    INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
--     select NEWID(),SPH.SPH_ID,POH_CreateUser,GETDATE(),'GenClearBorrow','系统自动生成清指定批号订单：'+isnull(PO.POH_OrderNo,'')
--       from #tmp_PurchaseOrderHeader AS PO ,#tmp_ShipmentHeader AS SPH
--       where PO.POH_Remark = SPH.SPH_ShipmentNbr
--        PO.POH_DMA_ID = SPH.DMA_Parent_DMA_ID
--        and SPH.WHM_ID = PO.POH_WHM_ID
--        and PO.POH_ProductLine_BUM_ID = SPH.SPH_ProductLine_BUM_ID

    --在日志中写入销售单生成清指定批号订单的日志【发货】
--    INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
--     select NEWID(),PRH.PRH_ID,POH_CreateUser,GETDATE(),'GenClearBorrow','系统自动生成清指定批号订单：'+isnull(PO.POH_OrderNo,'')
--       from #tmp_PurchaseOrderHeader AS PO ,#tmp_POReceiptHeader AS PRH
--       where PO.POH_Remark = PRH.PRH_SAPShipmentID
      

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


