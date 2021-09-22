DROP PROCEDURE [dbo].[GC_PurchaseOrder_AfterShipment]
GO

CREATE PROCEDURE [dbo].[GC_PurchaseOrder_AfterShipment]
	@ShipmentNbr nvarchar(50),
	@ShipmentType nvarchar(30),
	@RtnVal nvarchar(20) OUTPUT,
	@RtnMsg  nvarchar(MAX)  OUTPUT
as	
SET NOCOUNT ON
BEGIN TRY

BEGIN TRAN
	DECLARE @SysUserId uniqueidentifier
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	DECLARE @VENDORID uniqueidentifier
	
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
	
	SELECT @VENDORID = DMA_Parent_DMA_ID from DealerMaster,ShipmentHeader
	where DMA_ID = SPH_Dealer_DMA_ID
	and SPH_ShipmentNbr = @ShipmentNbr
	
	insert into #tmp_PurchaseOrderHeader(POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_VendorID,POH_OrderType,POH_CreateType,
	POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_WHM_ID,POH_SubmitDate,POH_SubmitUser,POH_Remark)	
	select NEWID(),SPH_ProductLine_BUM_ID,SPH_Dealer_DMA_ID,@VENDORID,@ShipmentType,'Manual',SPH_Shipment_User,
		GETDATE(),CASE WHEN @ShipmentType = 'ClearBorrowManual' then 'Draft' else 'Submitted' end,0,0,SLT_WHM_ID,GETDATE(),SPH_Shipment_User,@ShipmentNbr
	from (
	select distinct SPH_ProductLine_BUM_ID,SPH_Dealer_DMA_ID,
	SPH_Shipment_User,SLT_WHM_ID
	from ShipmentHeader,ShipmentLine,ShipmentLot
	where SPH_ID = SPL_SPH_ID
	and SPL_ID = SLT_SPL_ID
	and sph_ShipmentNbr = @ShipmentNbr
	) tab
	
	----更新BUNAME
	--UPDATE #tmp_PurchaseOrderHeader SET POH_BU_NAME = attribute_name
	--from Lafite_ATTRIBUTE where Id in (
	--select rootID from Cache_OrganizationUnits 
	--where attributeID = Convert(varchar(36),#tmp_PurchaseOrderHeader.POH_ProductLine_BUM_ID))
	--and ATTRIBUTE_TYPE = 'BU'
	
	--生成单据号
	DECLARE @m_DmaId uniqueidentifier
	DECLARE @m_ProductLine uniqueidentifier
	DECLARE @m_Id uniqueidentifier
	DECLARE @m_OrderNo nvarchar(50)

	DECLARE	curHandleOrderNo CURSOR 
	FOR SELECT POH_ID,POH_DMA_ID,POH_ProductLine_BUM_ID FROM #tmp_PurchaseOrderHeader where POH_OrderStatus = 'Submitted'

	OPEN curHandleOrderNo
	FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_ProductLine

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC dbo.[GC_GetNextAutoNumberForPO] @m_DmaId,'Next_PurchaseOrder',@m_ProductLine, @ShipmentType, @m_OrderNo output
		UPDATE #tmp_PurchaseOrderHeader SET POH_OrderNo = @m_OrderNo WHERE POH_ID = @m_Id
		FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_ProductLine
	END

	CLOSE curHandleOrderNo
	DEALLOCATE curHandleOrderNo
	
	--根据仓库，更新收货地址
	update #tmp_PurchaseOrderHeader set POH_ShipToAddress = WHM_Address
	from Warehouse where WHM_ID = POH_WHM_ID
  
	--更新承运商
	update #tmp_PurchaseOrderHeader set POH_TerritoryCode = DMA_Certification
	from DealerMaster where DMA_ID = POH_DMA_ID
  
  
	--根据创建人，更新联系人信息
	update #tmp_PurchaseOrderHeader set POH_ContactPerson = DST_ContactPerson,POH_Contact=DST_Contact,POH_ContactMobile=DST_ContactMobile,POH_Consignee=DST_Consignee,POH_ConsigneePhone=DST_ConsigneePhone
	from DealerShipTo where POH_CreateUser = DST_Dealer_User_ID
	
	--插入临时订单明细表(如果是警戒库存，则仍然按照安全库存标准进行更新)
	  insert into #tmp_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
				POD_Tax,POD_ReceiptQty,POD_UOM,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,
        POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
        POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
	  select newid(),POH_ID,CFN_ID,0,cast(round(SLT_LotShippedQty,2) as numeric(10)),0,0,0 ,CFN_Property3,LTM_LotNumber,
	         SPH_ShipmentNbr,SPH_Hospital_HOS_ID,SLT_WHM_ID,LotMaster.LTM_ExpiredDate,'','',
           REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
           REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog
	  from #tmp_PurchaseOrderHeader 
         inner join ShipmentHeader on (POH_DMA_ID = SPH_Dealer_DMA_ID)
         inner join ShipmentLine on (SPH_ID = SPL_SPH_ID)
         inner join ShipmentLot on (SPL_ID = SLT_SPL_ID and POH_WHM_ID =SLT_WHM_ID)
         inner join Product on (SPL_Shipment_PMA_ID = PMA_ID)
         inner join CFN on (PMA_CFN_ID = CFN_ID)
         inner join Lot on (ISNULL(SLT_QRLOT_ID,SLT_LOT_ID) = LOT_ID)
         inner join LotMaster on (LOT_LTM_ID = LTM_ID)
         left join MD.V_INF_UPN_REG AS REG ON (CFN.CFN_CustomerFaceNbr = REG.CurUPN)
	  where SPH_ShipmentNbr=@ShipmentNbr
	  
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
	  

		--插入订单主表和明细表
		insert into PurchaseOrderHeader(POH_ID,
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
		   POH_POH_ID) select POH_ID,
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
		
		insert into PurchaseOrderDetail(POD_ID, POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_RequiredQty, POD_Amount, POD_Tax, POD_ReceiptQty, POD_Status, POD_LotNumber, POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3, POD_CurRegNo, POD_CurValidDateFrom, POD_CurValidDataTo, POD_CurManuName, POD_LastRegNo, POD_LastValidDateFrom, POD_LastValidDataTo, POD_LastManuName, POD_CurGMKind, POD_CurGMCatalog,POD_QRCode)
     select POD_ID, POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_RequiredQty, POD_Amount, POD_Tax, POD_ReceiptQty, POD_Status, 
      CASE WHEN charindex('@@',POD_LotNumber) > 0
            THEN substring(POD_LotNumber,1,charindex('@@',POD_LotNumber)-1)
            ELSE POD_LotNumber
            END AS Lot, 
     POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3, POD_CurRegNo, POD_CurValidDateFrom, POD_CurValidDataTo, POD_CurManuName, POD_LastRegNo, POD_LastValidDateFrom, POD_LastValidDataTo, POD_LastManuName, POD_CurGMKind, POD_CurGMCatalog ,
     CASE WHEN charindex('@@',POD_LotNumber) > 0
            THEN substring(POD_LotNumber,charindex('@@',POD_LotNumber)+2,len(POD_LotNumber))
            ELSE ''
            END AS QRCode
       from #tmp_PurchaseOrderDetail
		
		--UPDATE BY KAICHUN.HUA 20170207
		IF(@ShipmentType = 'ClearBorrowManual')
		BEGIN
			UPDATE A SET   a.POD_Field2=[dbo].[fn_GetConsignmentDiscount](C.POH_DMA_ID,'Lot',a.POD_CFN_ID,a.POD_LotNumber)
			FROM PurchaseOrderDetail  A 
			INNER JOIN 	PurchaseOrderHeader C ON A.POD_POH_ID=C.POH_ID
			INNER JOIN #tmp_PurchaseOrderDetail B ON A.POD_ID=B.POD_ID
			
			UPDATE A SET   A.POD_CFN_Price=a.POD_CFN_Price* CONVERT(decimal(18,5),a.POD_Field2),
			a.POD_Amount=a.POD_Amount*CONVERT(decimal(18,5),a.POD_Field2)
			FROM PurchaseOrderDetail  A 
			INNER JOIN 	PurchaseOrderHeader C ON A.POD_POH_ID=C.POH_ID
			INNER JOIN #tmp_PurchaseOrderDetail B ON A.POD_ID=B.POD_ID
			
		END
		

		--插入订单操作日志
		INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
		SELECT NEWID(),POH_ID,POH_CreateUser,GETDATE(),'Generate',NULL FROM #tmp_PurchaseOrderHeader
		
		--插入接口表
		INSERT INTO PurchaseOrderInterface
		SELECT NEWID(),'','',POH_ID,POH_OrderNo,'Pending','Manual',NULL,POH_CreateUser,GETDATE(),POH_CreateUser,GETDATE(),CLT_ID
		FROM #tmp_PurchaseOrderHeader left join Client
		on POH_VendorID = CLT_Corp_Id
		WHERE POH_OrderStatus = 'Submitted'
		
		IF(@ShipmentType = 'ClearBorrowManual')
		BEGIN
			--写入AutoGenLog表
			insert into PurchaseOrderHeader_AutoGenLog
			select POH_ID,
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
			   'ClearBorrow',
			   POH_SAP_ConfirmDate,
			   POH_LastVersion,
			   POH_OrderType,
			   POH_VirtualDC,
			   POH_SpecialPriceID,
			   POH_WHM_ID ,
			   POH_POH_ID ,
			   null
			from #tmp_PurchaseOrderHeader 
			
			insert into PurchaseOrderDetail_AutoGenLog
			select POD_ID, POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_RequiredQty, POD_Amount, POD_Tax, POD_ReceiptQty, POD_Status, POD_LotNumber, POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3 
			from #tmp_PurchaseOrderDetail
			
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


