SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
ALTER PROCEDURE [Consignment].[Proc_Order_AutoGenKE_ForLP]
	@RtnVal nvarchar(20) OUTPUT,
	@RtnMsg  nvarchar(2000)  OUTPUT
as	
SET NOCOUNT ON
BEGIN TRY

BEGIN TRAN
	DECLARE @SysUserId uniqueidentifier
  DECLARE @VENDORID uniqueidentifier
  DECLARE @OrderType nvarchar(50)
  DECLARE @DayInterval int
  DECLARE @AutoSubmitDate nvarchar(20)
  DECLARE @Days int
  
  
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
    SET @VENDORID = 'fb62d945-c9d7-4b0f-8d26-4672d2c728b7'  --BSC(HQ)
	SET @OrderType = 'ClearBorrowManual'  --清指定批号
    SET @DayInterval = 50
	SELECT @Days = convert(Int,VALUE1) from Lafite_DICT(nolock) where DICT_TYPE='CONST_ShortConsignmentDay' and DICT_KEY='LPDays'
	
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
   POH_Remark           nvarchar(4000)        collate Chinese_PRC_CI_AS null,
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
   POH_VirtualDC nvarchar(50) collate Chinese_PRC_CI_AS null,
   POH_SpecialPriceID uniqueidentifier null,
   POH_WHM_ID uniqueidentifier null,
   POH_POH_ID uniqueidentifier null,
   POH_BU_NAME nvarchar(50) collate Chinese_PRC_CI_AS null,
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



  CREATE TABLE #tmp_POReceiptHeader (
    [PRH_ID] uniqueidentifier NOT NULL,
    [PRH_PONumber] nvarchar(30) collate Chinese_PRC_CI_AS NULL,
    [PRH_SAPShipmentID] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
    [PRH_Dealer_DMA_ID] uniqueidentifier NOT NULL,
    [PRH_ReceiptDate] datetime NULL,
    [PRH_SAPShipmentDate] datetime NULL,
    [PRH_Status] nvarchar(50) collate Chinese_PRC_CI_AS NOT NULL,
    [PRH_Vendor_DMA_ID] uniqueidentifier NOT NULL,
    [PRH_Type] nvarchar(50) collate Chinese_PRC_CI_AS NOT NULL,
    [PRH_ProductLine_BUM_ID] uniqueidentifier NULL,
    [PRH_PurchaseOrderNbr] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
    [PRH_Receipt_USR_UserID] uniqueidentifier NULL,
    [PRH_Carrier] nvarchar(20) collate Chinese_PRC_CI_AS NULL,
    [PRH_TrackingNo] nvarchar(100) collate Chinese_PRC_CI_AS NULL,
    [PRH_ShipType] nvarchar(20) collate Chinese_PRC_CI_AS NULL,
    [PRH_Note] nvarchar(500) collate Chinese_PRC_CI_AS NULL,
    [PRH_ArrivalDate] datetime NULL,
    [PRH_DeliveryDate] datetime NULL,
    [PRH_SapDeliveryDate] datetime NULL,
    [PRH_WHM_ID] uniqueidentifier NULL,
    [PRH_FromWHM_ID] uniqueidentifier NULL,
    [DMA_Parent_DMA_ID] uniqueidentifier NULL,
    [IAH_Reverse_IAH_ID] uniqueidentifier NULL
    PRIMARY KEY ([PRH_ID])
  )

  

 --获取单据将提交的日期
 select @AutoSubmitDate= Convert(nvarchar(8),DATEADD(dd, -@DayInterval+7,GETDATE()),112)
 select @AutoSubmitDate = case when Convert(int,substring(@AutoSubmitDate,7,2)) >=CDD_Date3 and Convert(int,substring(@AutoSubmitDate,7,2))<=CDD_Date4 
                               then Convert(nvarchar(8),CD.CDD_Calendar)+right(100 + CDD_Date4+1,2)
                               else @AutoSubmitDate end
   from CalendarDate CD(nolock) where substring(@AutoSubmitDate,1,6) = CD.CDD_Calendar
 

 --将符合条件的寄售转销售数据也写入临时表
 INSERT INTO #tmp_POReceiptHeader([PRH_ID],[PRH_PONumber],[PRH_SAPShipmentID],[PRH_Dealer_DMA_ID],[PRH_ReceiptDate],[PRH_SAPShipmentDate],
  [PRH_Status],[PRH_Vendor_DMA_ID],[PRH_Type],[PRH_ProductLine_BUM_ID],[PRH_PurchaseOrderNbr],[PRH_Receipt_USR_UserID],[PRH_Carrier],
  [PRH_TrackingNo],[PRH_ShipType],[PRH_Note],[PRH_ArrivalDate],[PRH_DeliveryDate],[PRH_SapDeliveryDate],[PRH_WHM_ID],[PRH_FromWHM_ID],[DMA_Parent_DMA_ID],[IAH_Reverse_IAH_ID])
  
  SELECT IAH.IAH_ID,IAH.IAH_Inv_Adj_Nbr,Case when IAH.IAH_Reason='SalesOut' and exists (select 1 from POReceiptHeader(nolock) where PRH_ID= IAH.IAH_Reverse_IAH_ID) then Replace(Replace(Replace(IAH.IAH_UserDescription,'根据[',''),']',''),'系统自动生成','') else IAH.IAH_Inv_Adj_Nbr end AS IAH_Inv_Adj_Nbr, 
         IAH.IAH_DMA_ID,IAH.IAH_ApprovalDate,IAH.IAH_CreatedDate,
         IAH.IAH_Status, DM.DMA_Parent_DMA_ID,IAH.IAH_Reason, IAH.IAH_ProductLine_BUM_ID,IAH.IAH_Inv_Adj_Nbr,IAH.IAH_CreatedBy_USR_UserID,null,
         null,null,IAH.IAH_UserDescription,null,null,null,null,null,DM.DMA_Parent_DMA_ID,IAH.IAH_Reverse_IAH_ID
    FROM InventoryAdjustHeader IAH(nolock), dealermaster AS DM(nolock)
   WHERE IAH.IAH_DMA_ID = DM.DMA_ID
     AND IAH.IAH_Reason IN ('CTOS','ForceCTOS','SalesOut')
     AND IAH.IAH_Status IN ('Accept','Complete')
     AND (IAH.IAH_DMA_ID in (select DMA_ID from DealerMaster(nolock) where DMA_DealerType in ('LP','T1','LS'))
          OR
          DM.DMA_Parent_DMA_ID in (select DMA_ID from DealerMaster(nolock) where DMA_DealerType='LP')
          )         
     AND Convert(nvarchar(8),iah.IAH_CreatedDate,112)> Convert(nvarchar(8),DATEADD(dd, -@DayInterval, getdate()),112)
     AND NOT EXISTS
         (
            Select 1 from Platform_OperLogMaster AS POL(nolock)
            where POL.MainId = IAH.IAH_ID
              and POL.OperType='生成KE订单'  
          ) 
          
     AND NOT EXISTS
         (
           select 1 from PurchaseOrderHeader_AutoGenLog(nolock) where POH_Remark = IAH.IAH_Inv_Adj_Nbr
         )
  
    
  --手工清指定批号订单的自动生成-订单主信息【收货】
  insert into #tmp_PurchaseOrderHeader(POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_VendorID,POH_OrderType,POH_CreateType,
	POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_WHM_ID,POH_SubmitDate,POH_SubmitUser,POH_Remark)
  select NEWID() AS POH_ID,PRH_ProductLine_BUM_ID,
         DMA_ID,  --根据二级经销商取到上级平台的ID
         @VENDORID,@OrderType,'Manual',@SysUserId,
		     GETDATE(),'Draft',0,0,
         (select top 1 WHM_ID from warehouse(nolock) where WHM_DMA_ID=PRH.DMA_ID and  WHM_Type='Borrow'),
         null,@SysUserId,
         --PRH_SAPShipmentID
          [PRH_SAPShipmentID] =  STUFF((  SELECT ','+ Case when PRH_Type='SalesOut' and exists (select 1 from POReceiptHeader AS POH(nolock) where POH.PRH_ID= t.IAH_Reverse_IAH_ID) then Replace(Replace(Replace(PRH_Note,'根据[',''),']',''),'系统自动生成','') else PRH_PurchaseOrderNbr end
                                     FROM #tmp_POReceiptHeader t
                                    WHERE (t.PRH_Vendor_DMA_ID =PRH.DMA_ID OR t.PRH_Dealer_DMA_ID = PRH.DMA_ID)
                                      AND t.PRH_ProductLine_BUM_ID = PRH.PRH_ProductLine_BUM_ID
                                      --AND t.WHM_ID = PRH.WHM_ID
                                      FOR XML PATH('')), 1, 1, '')
	from (
  select DMA_ID,PRH_ProductLine_BUM_ID
  FROM (
  SELECT CASE WHEN DMA_DealerType='T2' then DM.DMA_Parent_DMA_ID ELSE DMA_ID END AS DMA_ID,PRH_ProductLine_BUM_ID
  from #tmp_POReceiptHeader RO, dealerMaster DM(nolock)
  where RO.PRH_Dealer_DMA_ID = DM.DMA_ID
  ) AS tab
  group by DMA_ID,PRH_ProductLine_BUM_ID
  ) AS PRH



	--根据仓库，更新收货地址(LP)
	update t2 set POH_ShipToAddress = SWA_WH_Address
	from SAPWarehouseAddress t1(nolock), #tmp_PurchaseOrderHeader t2
  where t1.SWA_DMA_ID  = t2.POH_DMA_ID 

  
	--更新承运商
	update #tmp_PurchaseOrderHeader set POH_TerritoryCode = DMA_Certification
	from DealerMaster(nolock) where DMA_ID = POH_DMA_ID
  
  
	--根据创建人，更新联系人信息
	update #tmp_PurchaseOrderHeader set POH_ContactPerson = DST_ContactPerson,POH_Contact=DST_Contact,POH_ContactMobile=DST_ContactMobile,POH_Consignee=DST_Consignee,POH_ConsigneePhone=DST_ConsigneePhone
	from DealerShipTo(nolock) where POH_CreateUser = DST_Dealer_User_ID
	

    
    
    
  --插入临时订单明细表【寄售转销售】
	Insert into #tmp_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
				POD_Tax,POD_ReceiptQty,POD_UOM,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,
        POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
        POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)	  
    select newid(),POH_ID,CFN_ID,0,Qty,0,0,0,CFN_Property3,IAL_LotNumber,PRH_SAPShipmentID,null,null,'','','',
           REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
           REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog
  	From (    
    select PO.POH_ID,CFN.CFN_CustomerFaceNbr,CFN.CFN_ID,CFN.CFN_Property3,IAT.IAL_LotNumber,PRH.PRH_SAPShipmentID,cast(round(sum(isnull(IAT.IAL_LotQty,0)),2) as numeric(10,2)) AS Qty
      from #tmp_PurchaseOrderHeader AS PO ,
           #tmp_POReceiptHeader AS PRH ,
           InventoryAdjustDetail AS IAD(nolock), InventoryAdjustLot AS IAT(nolock),
           Product(nolock),CFN(nolock)
  	  --where PO.POH_Remark = PRH.PRH_SAPShipmentID
  	  where (PO.POH_Remark like N'%' +  PRH.PRH_SAPShipmentID + '%' OR PO.POH_Remark = PRH.PRH_SAPShipmentID)
      and PRH.PRH_ID = IAD.IAD_IAH_ID
      and IAD.IAD_ID = IAT.IAL_IAD_ID      
  	  and IAD.IAD_PMA_ID = PMA_ID
  	  and PMA_CFN_ID = CFN_ID
      and exists
          (select 1 from Warehouse WH(nolock)
           where IAT.IAL_WHM_ID = WH.WHM_ID
           and WH.WHM_Type IN ('Consignment','Borrow') )
  	 group by PO.POH_ID,CFN.CFN_CustomerFaceNbr,CFN.CFN_ID,CFN.CFN_Property3,IAT.IAL_LotNumber,PRH.PRH_SAPShipmentID
     ) tab LEFT join MD.V_INF_UPN_REG AS REG ON (tab.CFN_CustomerFaceNbr = REG.CurUPN)
    
    
    --select * from #tmp_PurchaseOrderHeader
    --select * from #tmp_PurchaseOrderDetail
    --删除数量是0的记录
	  delete from #tmp_PurchaseOrderDetail where POD_RequiredQty = 0	  
	  delete from #tmp_PurchaseOrderHeader where POH_ID not in (select POD_POH_ID from #tmp_PurchaseOrderDetail )
	  
	  --更新金额
    update t2
	  --set POD_CFN_Price = CFNP_Price, 
			--POD_Amount = POD_RequiredQty*CFNP_Price
		set POD_CFN_Price =  isnull(dbo.fn_GetCfnPriceByDealer( t1.POH_DMA_ID,t2.POD_CFN_ID,(SELECT SubCompanyId FROM dbo.View_ProductLine
                        WHERE Id=t1.POH_ProductLine_BUM_ID),(SELECT BrandId FROM dbo.View_ProductLine
                        WHERE Id=t1.POH_ProductLine_BUM_ID), 'Dealer',0),0),
            POD_Amount = POD_RequiredQty*isnull(dbo.fn_GetCfnPriceByDealer( t1.POH_DMA_ID,t2.POD_CFN_ID,(SELECT SubCompanyId FROM dbo.View_ProductLine
                                               WHERE Id=t1.POH_ProductLine_BUM_ID),(SELECT BrandId FROM dbo.View_ProductLine
                                               WHERE Id=t1.POH_ProductLine_BUM_ID), 'Dealer',0),0)
	  from #tmp_PurchaseOrderHeader t1,#tmp_PurchaseOrderDetail t2,CFNPrice t3(nolock)
	  where t1.POH_ID = t2.POD_POH_ID
	  and t1.POH_DMA_ID = t3.CFNP_Group_ID
	  and t2.POD_CFN_ID = t3.CFNP_CFN_ID
	  and t3.CFNP_PriceType = 'Dealer'
    
	/*--
    UPDATE A SET  A.POD_Field2=[dbo].[fn_GetConsignmentDiscount](c.POH_DMA_ID,'Lot',a.POD_CFN_ID,a.POD_LotNumber)
  	FROM #tmp_PurchaseOrderDetail  A
  	INNER JOIN #tmp_PurchaseOrderHeader C(nolock) ON A.POD_POH_ID=C.POH_ID
  	*/
    

    

	 
	  
    --更新产品有效期
    update t1 set t1.POD_Field1 = Convert(nvarchar(50),t3.LTM_ExpiredDate,21)
    from #tmp_PurchaseOrderDetail t1,product t2(nolock), LotMaster t3(nolock)
    where t1.POD_CFN_ID = t2.PMA_CFN_ID and t2.PMA_ID=t3.LTM_Product_PMA_ID and t1.POD_LotNumber = t3.LTM_LotNumber

  
    DELETE FROM #tmp_PurchaseOrderHeader where POH_ID not in (select POD_POH_ID from #tmp_PurchaseOrderDetail)
    
    --重新更新Remark
    update H  set H.POH_Remark = STUFF((  SELECT  distinct ','+  [POD_ShipmentNbr]
                                     FROM #tmp_PurchaseOrderDetail t
                                    WHERE t.POD_POH_ID = H.POH_ID
                                      FOR XML PATH('')), 1, 1, '')  
      from #tmp_PurchaseOrderHeader H 
      
    --更新明细  
--  	UPDATE A SET  A.POD_Field2=[dbo].[fn_GetConsignmentDiscount](c.POH_DMA_ID,'Lot',a.POD_CFN_ID,a.POD_LotNumber)
--  	FROM #tmp_PurchaseOrderDetail  A
--  	INNER JOIN #tmp_PurchaseOrderHeader C(nolock) ON A.POD_POH_ID=C.POH_ID
--  	
--  	UPDATE A SET   A.POD_CFN_Price= A.POD_CFN_Price*CONVERT(decimal(18,5),a.POD_Field2), a.POD_Amount=a.POD_Amount*CONVERT(decimal(18,5),a.POD_Field2)
--  	FROM #tmp_PurchaseOrderDetail  A
--  	INNER JOIN #tmp_PurchaseOrderHeader C(nolock) ON A.POD_POH_ID=C.POH_ID
    
    UPDATE HD SET HD.POD_Field2=ISNULL((SELECT TOP(1) A.DiscountValue
					FROM dbo.ProductDiscountRule (nolock) A 
					INNER JOIN V_DivisionProductLineRelation B ON B.DivisionCode=A.BU
					INNER JOIN CFN (nolock) ON B.ProductLineID=CFN.CFN_ProductLine_BUM_ID AND CFN.CFN_ID=HD.POD_CFN_ID
					INNER JOIN Product (nolock) C on CFN.CFN_ID=C.PMA_CFN_ID
					INNER JOIN LotMaster D ON D.LTM_Product_PMA_ID=C.PMA_ID and(ISNULL(HD.POD_LotNumber,'')='' OR d.LTM_LotNumber=HD.POD_LotNumber)
					WHERE 
						(ISNULL(A.LeftValue,'')='' OR (ISNULL(A.LeftValue,'')<>'' AND  datediff(DAY,getdate(),D.LTM_ExpiredDate) >= A.LeftValue))
						AND (ISNULL(A.RightValue,'')='' OR (ISNULL(A.RightValue,'')<>'' AND  datediff(DAY,getdate(),D.LTM_ExpiredDate) < A.RightValue))
						AND GETDATE() BETWEEN A.BeginDate AND A.EndDate						
						AND EXISTS (SELECT 1 FROM dbo.ProductDiscountUpn ttt where ttt.ID=a.ID and ttt.UPN=CFN.CFN_CustomerFaceNbr)),1.0)
  	FROM #tmp_PurchaseOrderDetail  HD
  	INNER JOIN #tmp_PurchaseOrderHeader HH ON HD.POD_POH_ID=HH.POH_ID


  	UPDATE A SET   A.POD_CFN_Price= A.POD_CFN_Price*CONVERT(decimal(18,5),a.POD_Field2), a.POD_Amount=a.POD_Amount*CONVERT(decimal(18,5),a.POD_Field2)
  	FROM #tmp_PurchaseOrderDetail  A
  	INNER JOIN #tmp_PurchaseOrderHeader C(nolock) ON A.POD_POH_ID=C.POH_ID

    --SELECT * from #tmp_PurchaseOrderHeader
    --SELECT * from #tmp_PurchaseOrderDetail
  
        
  
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
	   POH_POH_ID )
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
  SELECT newid() AS POD_ID,POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, sum(POD_RequiredQty) AS POD_RequiredQty, sum(POD_Amount) AS POD_Amount, POD_Tax, sum(POD_ReceiptQty) , POD_Status,Lot, POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3, POD_CurRegNo, POD_CurValidDateFrom, POD_CurValidDataTo, POD_CurManuName, POD_LastRegNo, POD_LastValidDateFrom, POD_LastValidDataTo, POD_LastManuName, POD_CurGMKind, POD_CurGMCatalog
  FROM 
  (
  select POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_RequiredQty , POD_Amount, POD_Tax, POD_ReceiptQty, POD_Status, 
         CASE WHEN charindex('@@',POD_LotNumber) > 0
              THEN substring(POD_LotNumber,1,charindex('@@',POD_LotNumber)-1)
              ELSE POD_LotNumber
              END AS Lot,
         '' AS POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3, POD_CurRegNo, POD_CurValidDateFrom, POD_CurValidDataTo, POD_CurManuName, POD_LastRegNo, POD_LastValidDateFrom, POD_LastValidDataTo, POD_LastManuName, POD_CurGMKind, POD_CurGMCatalog
         
    from #tmp_PurchaseOrderDetail
  ) AS Detail 
  group by POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_Tax, POD_Status,Lot,POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3, POD_CurRegNo, POD_CurValidDateFrom, POD_CurValidDataTo, POD_CurManuName, POD_LastRegNo, POD_LastValidDateFrom, POD_LastValidDataTo, POD_LastManuName, POD_CurGMKind, POD_CurGMCatalog
  
    
  insert into PurchaseOrderDetail_WithQR(POD_ID, POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_RequiredQty, POD_Amount, POD_Tax, POD_ReceiptQty, POD_Status, POD_LotNumber, POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3, POD_CurRegNo, POD_CurValidDateFrom, POD_CurValidDataTo, POD_CurManuName, POD_LastRegNo, POD_LastValidDateFrom, POD_LastValidDataTo, POD_LastManuName, POD_CurGMKind, POD_CurGMCatalog,POD_QRCode)
  select POD_ID, POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_RequiredQty, POD_Amount, POD_Tax, POD_ReceiptQty, POD_Status, 
         CASE WHEN charindex('@@',POD_LotNumber) > 0
            THEN substring(POD_LotNumber,1,charindex('@@',POD_LotNumber)-1)
            ELSE POD_LotNumber
            END AS Lot,
         POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3, POD_CurRegNo, POD_CurValidDateFrom, POD_CurValidDataTo, POD_CurManuName, POD_LastRegNo, POD_LastValidDateFrom, POD_LastValidDataTo, POD_LastManuName, POD_CurGMKind, POD_CurGMCatalog,
         CASE WHEN charindex('@@',POD_LotNumber) > 0
            THEN substring(POD_LotNumber,charindex('@@',POD_LotNumber)+2,len(POD_LotNumber))
            ELSE ''
            END AS QRCode
    from #tmp_PurchaseOrderDetail

	--插入订单操作日志
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),POH_ID,POH_CreateUser,GETDATE(),'Generate','自动生成清指定批号订单' FROM #tmp_PurchaseOrderHeader
  
     
  --插入备份表
	insert into PurchaseOrderHeader_AutoGenLog select * from #tmp_PurchaseOrderHeader
	insert into PurchaseOrderDetail_AutoGenLog select POD_ID, POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_RequiredQty, POD_Amount, POD_Tax, POD_ReceiptQty, POD_Status, POD_LotNumber, POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3 from #tmp_PurchaseOrderDetail
    
	
  --在日志中写入销售单生成清指定批号订单的日志【发货】
  INSERT INTO Platform_OperLogMaster(LogId,MainId,OperUser,OperDate,OperType,OperRole,OperNote,DataSource)
	SELECT NEWID(),PRH_ID ,'系统',GETDATE(),'生成KE订单','系统','系统自动生成清指定批号订单','Consign_InventoryAdjustHeaderInfo' FROM #tmp_POReceiptHeader
  
  
      
      

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

