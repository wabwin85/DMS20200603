DROP PROCEDURE [dbo].[GC_PurchaseOrder_AutoGenConsignmentClearBorrow]
GO



CREATE PROCEDURE [dbo].[GC_PurchaseOrder_AutoGenConsignmentClearBorrow]	

	@SphId uniqueidentifier,
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
    SET @VENDORID = 'fb62d945-c9d7-4b0f-8d26-4672d2c728b7'  --BSC(HQ)
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
   POH_BU_NAME nvarchar(50) null,
   primary key (POH_ID)
)

create table #tmp_PurchaseOrderDetail (
   POD_ID               uniqueidentifier     not null,
   POD_POH_ID           uniqueidentifier     not null,
   POD_CFN_ID           uniqueidentifier     not null,
   POD_CFN_Price        decimal(18,6)        null,
   POD_UOM              nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POD_RequiredQty      decimal(18,6)        null,
   POD_Amount           decimal(18,6)        null,
   POD_Tax              decimal(18,6)        null,
   POD_ReceiptQty       decimal(18,6)        null,
   POD_Status           nvarchar(50)         collate Chinese_PRC_CI_AS null,
   POD_LotNumber		nvarchar(50)		 collate Chinese_PRC_CI_AS null,
   POD_ShipmentNbr		nvarchar(50)		 collate Chinese_PRC_CI_AS null,
   POD_HOS_ID		uniqueidentifier		 null,
   POD_WH_ID		uniqueidentifier		 null,
   POD_Field1		nvarchar(50)		 collate Chinese_PRC_CI_AS null,
   POD_Field2		nvarchar(50)		 collate Chinese_PRC_CI_AS null,
   POD_Field3		nvarchar(50)		 collate Chinese_PRC_CI_AS null,
   POD_CurRegNo nvarchar(500)    collate Chinese_PRC_CI_AS NULL,
   POD_CurValidDateFrom datetime NULL,
   POD_CurValidDataTo datetime NULL,
   POD_CurManuName nvarchar(500) collate Chinese_PRC_CI_AS NULL,
   POD_LastRegNo nvarchar(500) collate Chinese_PRC_CI_AS NULL,
   POD_LastValidDateFrom datetime NULL,
   POD_LastValidDataTo datetime NULL,
   POD_LastManuName nvarchar(500) collate Chinese_PRC_CI_AS NULL,
   POD_CurGMKind nvarchar(200) collate Chinese_PRC_CI_AS NULL,
   POD_CurGMCatalog nvarchar(200) collate Chinese_PRC_CI_AS NULL,
   primary key (POD_ID)
)

create table #tmp_ShipmentHeader (
  [SPH_ID] uniqueidentifier NOT NULL,
  [SPH_Hospital_HOS_ID] uniqueidentifier NULL,
  [SPH_ShipmentNbr] nvarchar(30) NULL,
  [SPH_Dealer_DMA_ID] uniqueidentifier NOT NULL,
  [SPH_ShipmentDate] datetime NULL,
  [SPH_Status] nvarchar(50) NOT NULL,
  [SPH_Reverse_SPH_ID] uniqueidentifier NULL,
  [SPH_NoteForPumpSerialNbr] nvarchar(2000) NULL,
  [SPH_Type] nvarchar(50) NULL,
  [SPH_ProductLine_BUM_ID] uniqueidentifier NULL,
  [SPH_Shipment_User] uniqueidentifier NULL,
  [SPH_InvoiceNo] nvarchar(2000) NULL,
  [SPH_UpdateDate] datetime NULL,
  [SPH_SubmitDate] datetime NULL,
  [SPH_Office] nvarchar(200) NULL,
  [SPH_InvoiceTitle] nvarchar(200) NULL,
  [SPH_InvoiceDate] datetime NULL,
  [SPH_IsAuth] bit NULL,
  [SPH_InvoiceFirstDate] datetime NULL,
  [DMA_Parent_DMA_ID] uniqueidentifier NULL,
  [WHM_ID] uniqueidentifier NULL,
  primary key (SPH_ID)
)

CREATE TABLE #tmp_POReceiptHeader (
  [PRH_ID] uniqueidentifier NOT NULL,
  [PRH_PONumber] nvarchar(30) NULL,
  [PRH_SAPShipmentID] nvarchar(50) NULL,
  [PRH_Dealer_DMA_ID] uniqueidentifier NOT NULL,
  [PRH_ReceiptDate] datetime NULL,
  [PRH_SAPShipmentDate] datetime NULL,
  [PRH_Status] nvarchar(50) NOT NULL,
  [PRH_Vendor_DMA_ID] uniqueidentifier NOT NULL,
  [PRH_Type] nvarchar(50) NOT NULL,
  [PRH_ProductLine_BUM_ID] uniqueidentifier NULL,
  [PRH_PurchaseOrderNbr] nvarchar(50) NULL,
  [PRH_Receipt_USR_UserID] uniqueidentifier NULL,
  [PRH_Carrier] nvarchar(20) NULL,
  [PRH_TrackingNo] nvarchar(100) NULL,
  [PRH_ShipType] nvarchar(20) NULL,
  [PRH_Note] nvarchar(20) NULL,
  [PRH_ArrivalDate] datetime NULL,
  [PRH_DeliveryDate] datetime NULL,
  [PRH_SapDeliveryDate] datetime NULL,
  [PRH_WHM_ID] uniqueidentifier NULL,
  [PRH_FromWHM_ID] uniqueidentifier NULL,
  [DMA_Parent_DMA_ID] uniqueidentifier NULL  
  PRIMARY KEY ([PRH_ID])
)

 
 --将符合条件的销售出库单写入【销售】临时表
 insert into #tmp_ShipmentHeader
 select SPH.SPH_ID, SPH.SPH_Hospital_HOS_ID, SPH.SPH_ShipmentNbr, SPH.SPH_Dealer_DMA_ID, SPH.SPH_ShipmentDate, SPH.SPH_Status, SPH.SPH_Reverse_SPH_ID, SPH.SPH_NoteForPumpSerialNbr, SPH.SPH_Type, SPH.SPH_ProductLine_BUM_ID, SPH.SPH_Shipment_User, SPH.SPH_InvoiceNo, SPH.SPH_UpdateDate, SPH.SPH_SubmitDate, SPH.SPH_Office, SPH.SPH_InvoiceTitle, SPH.SPH_InvoiceDate, SPH.SPH_IsAuth, SPH.SPH_InvoiceFirstDate,DM.DMA_Parent_DMA_ID,WH.WHM_ID  
  from ShipmentHeader SPH,dealermaster AS DM,
       (select WHM_DMA_ID, max(convert(nvarchar(100),WHM_ID)) AS WHM_ID from Warehouse where WHM_Type='Borrow' and WHM_ActiveFlag =1 group by WHM_DMA_ID) AS WH
  where SPH.SPH_Dealer_DMA_ID = DM.DMA_ID and WH.WHM_DMA_ID=DM.DMA_ID 
  and SPH_Status='Complete' --单据状态是已完成
  and SPH_Type in ('Consignment')  --必须是寄售销售
  and exists
    (select 1 from ShipmentLine SPL, ShipmentLot SLT , Warehouse WH
     where SPL.SPL_SPH_ID = SPH.SPH_ID
     and SPL.SPL_ID = SLT.SLT_SPL_ID
     and SLT.SLT_WHM_ID = WH.WHM_ID
     and WH.WHM_Type = N'Consignment' ) --必须是波科寄售库
  and not exists
    (
      Select 1 from  PurchaseOrderLog AS POL
      where POL.POL_POH_ID = SPH.SPH_ID
       and POL.POL_OperType='GenClearBorrow'  
    ) 
  and SPH.SPH_ID = @SphId

  
  --手工清指定批号订单的自动生成-订单主信息【销售】
	insert into #tmp_PurchaseOrderHeader(POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_VendorID,POH_OrderType,POH_CreateType,
	POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_WHM_ID,POH_SubmitDate,POH_SubmitUser,POH_Remark)	
	select NEWID() AS POH_ID,SPH_ProductLine_BUM_ID,
         SPH_Dealer_DMA_ID, 
         @VENDORID,@OrderType,'Manual',@SysUserId,
		     GETDATE(),'Draft',0,0,
         (select top 1 WHM_ID from warehouse where WHM_DMA_ID=PRH.SPH_Dealer_DMA_ID and  WHM_Type='Borrow'),
         getdate(),@SysUserId,
         SPH_ShipmentNbr  
	from (
  select SPH.SPH_ProductLine_BUM_ID,SPH.SPH_Dealer_DMA_ID,SPH_ShipmentNbr
  from  #tmp_ShipmentHeader AS SPH
  group by SPH.SPH_ProductLine_BUM_ID,SPH.SPH_Dealer_DMA_ID,SPH_ShipmentNbr
  ) AS PRH
  
	
	--根据仓库，更新收货地址(LP)
	update t2 set POH_ShipToAddress = SWA_WH_Address
	from SAPWarehouseAddress t1, #tmp_PurchaseOrderHeader t2
  where t1.SWA_DMA_ID  = t2.POH_DMA_ID 
  
 
  
	--更新承运商
	update #tmp_PurchaseOrderHeader set POH_TerritoryCode = DMA_Certification
	from DealerMaster where DMA_ID = POH_DMA_ID
  
  
	--根据创建人，更新联系人信息
	update #tmp_PurchaseOrderHeader set POH_ContactPerson = DST_ContactPerson,POH_Contact=DST_Contact,POH_ContactMobile=DST_ContactMobile,POH_Consignee=DST_Consignee,POH_ConsigneePhone=DST_ConsigneePhone
	from DealerShipTo where POH_CreateUser = DST_Dealer_User_ID
	
	--插入临时订单明细表【销售】
	  insert into #tmp_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
				POD_Tax,POD_ReceiptQty,POD_UOM,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,
        POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
        POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
	  
    select newid(),POH_ID,CFN_ID,0,Qty,0,0,0 ,CFN_Property3,LTM_LotNumber,
	         SPH_ShipmentNbr,null,null,ExpiredDate,'','',
           REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
           REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog
  	From (    
    select PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LotMaster.LTM_LotNumber,SPH.SPH_ShipmentNbr,CFN.CFN_CustomerFaceNbr,
           cast(round(sum(isnull(SLT_LotShippedQty,0)),2) as numeric(10)) AS Qty,LotMaster.LTM_ExpiredDate AS ExpiredDate
      from #tmp_PurchaseOrderHeader AS PO ,#tmp_ShipmentHeader AS SPH ,ShipmentLine AS SPL,ShipmentLot AS SLT,Product,CFN,Lot,LotMaster
  	  where PO.POH_DMA_ID = SPH.SPH_Dealer_DMA_ID
      --and SPH.WHM_ID = PO.POH_WHM_ID
      and PO.POH_ProductLine_BUM_ID = SPH.SPH_ProductLine_BUM_ID	  
      and PO.POH_Remark = SPH.SPH_ShipmentNbr
      and SPH.SPH_ID = SPL.SPL_SPH_ID
  	  and SPL.SPL_ID = SLT.SLT_SPL_ID
  	  and SPL.SPL_Shipment_PMA_ID = PMA_ID
  	  and PMA_CFN_ID = CFN_ID	  
  	  and SLT_LOT_ID = LOT_ID
  	  and LOT_LTM_ID = LTM_ID
      and exists
          (select 1 from Warehouse WH
           where SLT.SLT_WHM_ID = WH.WHM_ID
           and WH.WHM_Type = N'Consignment' ) --必须是波科寄售库
  	 group by PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LotMaster.LTM_LotNumber,SPH.SPH_ShipmentNbr,CFN.CFN_CustomerFaceNbr
     ) tab LEFT join MD.V_INF_UPN_REG AS REG ON (tab.CFN_CustomerFaceNbr = REG.CurUPN)
	
   
     
	  --删除数量是0的记录
	  delete from #tmp_PurchaseOrderDetail where POD_RequiredQty = 0	  
	  delete from #tmp_PurchaseOrderHeader where POH_ID not in (select POD_POH_ID from #tmp_PurchaseOrderDetail )
	  
	  --更新金额
	  update t2
	  set POD_CFN_Price = CFNP_Price,
			POD_Amount = POD_RequiredQty*CFNP_Price
	  from #tmp_PurchaseOrderHeader t1,#tmp_PurchaseOrderDetail t2,CFNPrice t3
	  where t1.POH_ID = t2.POD_POH_ID
	  and t1.POH_DMA_ID = t3.CFNP_Group_ID
	  and t2.POD_CFN_ID = t3.CFNP_CFN_ID
	  and t3.CFNP_PriceType = 'DealerConsignment'
	  
    --更新产品有效期
    update t1 set t1.POD_Field1 = Convert(nvarchar(50),t3.LTM_ExpiredDate,21)
    from #tmp_PurchaseOrderDetail t1,product t2, LotMaster t3
    where t1.POD_CFN_ID = t2.PMA_CFN_ID and t2.PMA_ID=t3.LTM_Product_PMA_ID and t1.POD_LotNumber = t3.LTM_LotNumber    

	--插入订单主表和明细表
	insert into PurchaseOrderHeader select POH_ID,
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
	   POH_Remark ,
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
	   POH_WHM_ID ,
	   POH_POH_ID 
	from #tmp_PurchaseOrderHeader
	
  insert into PurchaseOrderDetail(POD_ID, POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_RequiredQty, POD_Amount, POD_Tax, POD_ReceiptQty, POD_Status, POD_LotNumber, POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3, POD_CurRegNo, POD_CurValidDateFrom, POD_CurValidDataTo, POD_CurManuName, POD_LastRegNo, POD_LastValidDateFrom, POD_LastValidDataTo, POD_LastManuName, POD_CurGMKind, POD_CurGMCatalog)
  select POD_ID, POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_RequiredQty, POD_Amount, POD_Tax, POD_ReceiptQty, POD_Status, POD_LotNumber, POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3, POD_CurRegNo, POD_CurValidDateFrom, POD_CurValidDataTo, POD_CurManuName, POD_LastRegNo, POD_LastValidDateFrom, POD_LastValidDataTo, POD_LastManuName, POD_CurGMKind, POD_CurGMCatalog 
    from #tmp_PurchaseOrderDetail
    
    --UPDATE BY KAICHUN.HUA 20170207
    UPDATE A SET   A.POD_Field2=[dbo].[fn_GetConsignmentDiscount](c.POH_DMA_ID,'Lot',a.POD_CFN_ID,a.POD_LotNumber)
	FROM PurchaseOrderDetail  A
	INNER JOIN PurchaseOrderHeader C ON A.POD_POH_ID=C.POH_ID
	WHERE A.POD_POH_ID IN (SELECT POH_ID FROM #tmp_PurchaseOrderHeader WHERE POH_OrderType='ClearBorrowManual')
	
    UPDATE A SET   A.POD_CFN_Price=A.POD_CFN_Price*CONVERT(decimal(18,5),a.POD_Field2),
	a.POD_Amount=a.POD_Amount*CONVERT(decimal(18,5),a.POD_Field2)
	FROM PurchaseOrderDetail  A
	INNER JOIN PurchaseOrderHeader C ON A.POD_POH_ID=C.POH_ID
	WHERE A.POD_POH_ID IN (SELECT POH_ID FROM #tmp_PurchaseOrderHeader WHERE POH_OrderType='ClearBorrowManual')

	--插入订单操作日志
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),POH_ID,POH_CreateUser,GETDATE(),'Generate',NULL FROM #tmp_PurchaseOrderHeader
    
    

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


