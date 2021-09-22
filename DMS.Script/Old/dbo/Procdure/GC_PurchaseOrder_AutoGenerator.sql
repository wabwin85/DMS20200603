DROP Procedure [dbo].[GC_PurchaseOrder_AutoGenerator]
GO

/*
经销商订单自动生成预处理，统计经销商待订购的产品至临时表
*/
CREATE Procedure [dbo].[GC_PurchaseOrder_AutoGenerator]
	@AGType NVARCHAR(10),
  @RtnVal NVARCHAR(20) OUTPUT
AS

SET NOCOUNT ON
DECLARE @SysUserId     UNIQUEIDENTIFIER
DECLARE @AlertInvRate  Decimal(4,2)

BEGIN TRY
	TRUNCATE TABLE DealerOrderNumber
BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
  
	CREATE TABLE #TMP_DATA
	(
		DMA_ID uniqueidentifier,
		CFN_ID uniqueidentifier,
		BUM_ID uniqueidentifier,
    WHM_ID uniqueidentifier,
		SafetyQty DECIMAL(18,6),
    AlertQty DECIMAL(18,6),
		OnHandQty DECIMAL(18,6),
		HiddenQty DECIMAL(18,6),
    Price DECIMAL(18,6),
    WHM_TYPE NVARCHAR(20),
    DETAIL_ID uniqueidentifier,
    HEAD_ID uniqueidentifier,
    ORDER_TYPE NVARCHAR(20)    
	)

  create table #mmbo_PurchaseOrderHeader (
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
   POH_InvoiceComment   nvarchar(200)        null,
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
   POH_OrderType nvarchar(50) null,
   POH_VirtualDC nvarchar(50) null,
   POH_SpecialPriceID uniqueidentifier null,
   POH_WHM_ID uniqueidentifier null,
   POH_POH_ID uniqueidentifier null,
   constraint PK_mmbo_PurchaseOrderHeader primary key nonclustered (POH_ID)
)

create table #mmbo_PurchaseOrderDetail (
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
   POD_LotNumber		nvarchar(50)		 null,
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
   constraint PK_mmbo_PurchaseOrderDetail primary key nonclustered (POD_ID)
)
	
  select @AlertInvRate=convert(decimal(4,2),value1) 
  from Lafite_DICT where DICT_TYPE='CONST_ALERT_INV_RATE' and DICT_KEY='Rate'
  
  --警戒库存自动补货与安全库存自动补货采用不同的方式  
  --生成可以自动订购的产品记录，要剔除未授权的产品和不可订购的产品
	IF @AGType = 'Safety'
    --二级经销商寄售库不需要自动补货
    INSERT INTO #TMP_DATA
  	SELECT IS_Dealer_DMA_ID AS DMA_ID,
           IS_CFN_ID AS CFN_ID,
           NULL AS BUM_ID,
           IS_WHM_ID AS WHM_ID,
           IS_Qty AS SafetyQty,
           0 AS AlertQty,
  	       0 AS OnHandQty,
           0 AS HiddenQty,
           NULL AS Price,
           NULL AS WHM_TYPE,
           newid() AS DETAIL_ID,
           NULL AS HEAD_ID,
           NULL AS ORDER_TYPE
  	FROM InventorySafety 
  	WHERE IS_Dealer_DMA_ID IN (SELECT DOS_DMA_ID FROM DealerOrderSetting WHERE DOS_IsOpen = 1)
  	  AND IS_Qty > 0 
      AND dbo.GC_Fn_CFN_CheckDealerAuth(IS_Dealer_DMA_ID,IS_CFN_ID) = 1
  	  AND IS_WHM_ID IN (SELECT WHM_ID FROM Warehouse WHERE WHM_TYPE IN ('Consignment','DefaultWH','Normal'))
	ELSE 
    INSERT INTO #TMP_DATA
  	SELECT IS_Dealer_DMA_ID AS DMA_ID,
           IS_CFN_ID AS CFN_ID,
           NULL AS BUM_ID,
           IS_WHM_ID AS WHM_ID,
           IS_Qty AS SafetyQty,
           IS_Qty * @AlertInvRate AS AlertQty,
  	       0 AS OnHandQty,
           0 AS HiddenQty,
           NULL AS Price,
           NULL AS WHM_TYPE,
           newid() AS DETAIL_ID,
           NULL AS HEAD_ID,
           NULL AS ORDER_TYPE
  	FROM InventorySafety 
  	WHERE IS_Dealer_DMA_ID IN (SELECT DOS_DMA_ID FROM DealerOrderSetting WHERE DOS_IsOpen = 1)
  	  AND IS_Qty * @AlertInvRate > 0 
      AND IS_CFN_ID IN (select CFN_ID from cfn where CFN_Property1 = 'A')
      AND dbo.GC_Fn_CFN_CheckDealerAuth(IS_Dealer_DMA_ID,IS_CFN_ID) = 1
  	  AND IS_WHM_ID IN (SELECT WHM_ID FROM Warehouse WHERE WHM_TYPE IN ('Consignment','DefaultWH','Normal'))
  
  
	--更新产品线
	UPDATE #TMP_DATA SET #TMP_DATA.BUM_ID = CFN.CFN_ProductLine_BUM_ID
	FROM CFN WHERE CFN.CFN_ID = #TMP_DATA.CFN_ID
	
  --更新仓库类别、订单类别 （在途仓库、借货库不补货，寄售库、普通库补货；寄售库包括：Consignment；普通库包括：DefaultWH、Normal）
  update #TMP_DATA set WHM_TYPE = 'Consignment',ORDER_TYPE = 'Consignment'
  WHERE WHM_ID IN (SELECT WHM_ID FROM Warehouse WHERE WHM_TYPE IN ('Consignment'))
  
  update #TMP_DATA set WHM_TYPE = 'Normal',ORDER_TYPE = 'Normal'
  WHERE WHM_TYPE IS NULL
  
  
	--更新产品的单价
	UPDATE Tmp SET Tmp.Price = Price.CFNP_Price
  from #TMP_DATA AS Tmp, CFNPrice AS Price where Tmp.DMA_ID = Price.CFNP_Group_ID
  and Tmp.CFN_ID = Price.CFNP_CFN_ID and Tmp.WHM_TYPE = 'Normal' and Price.CFNP_PriceType = 'Dealer'
  
  UPDATE Tmp SET Tmp.Price = Price.CFNP_Price
  from #TMP_DATA AS Tmp, CFNPrice AS Price where Tmp.DMA_ID = Price.CFNP_Group_ID
  and Tmp.CFN_ID = Price.CFNP_CFN_ID and Tmp.WHM_TYPE = 'Consignment' and Price.CFNP_PriceType = 'DealerConsignment'
  
  --删除没有价格的产品（无价格产品不参与自动补货）
  Delete from #TMP_DATA WHERE Price IS NULL
  
	
  
	--更新现有库存
	UPDATE #TMP_DATA SET OnHandQty = ISNULL(H.OnHandQty,0)
	FROM (SELECT W.WHM_DMA_ID AS DMA_ID,P.PMA_CFN_ID AS CFN_ID,W.WHM_ID,SUM(INV.INV_OnHandQuantity) AS OnHandQty
	FROM Inventory AS INV
	INNER JOIN Product AS P ON INV.INV_PMA_ID = P.PMA_ID
	INNER JOIN Warehouse AS W ON INV.INV_WHM_ID = W.WHM_ID
	GROUP BY W.WHM_DMA_ID,P.PMA_CFN_ID,W.WHM_ID) AS H
	WHERE H.DMA_ID = #TMP_DATA.DMA_ID 
	AND H.CFN_ID = #TMP_DATA.CFN_ID
  AND H.WHM_ID = #TMP_DATA.WHM_ID
	
	--更新隐性库存
	--1、订单状态为草稿、已提交、已同意、已生成接口、已进入SAP、已确认
	UPDATE #TMP_DATA SET HiddenQty = ISNULL(H.HiddenQty,0)
	FROM (SELECT H.POH_DMA_ID AS DMA_ID,D.POD_CFN_ID AS CFN_ID,H.POH_WHM_ID AS WHM_ID,SUM(D.POD_RequiredQty) AS HiddenQty 
	FROM PurchaseOrderDetail AS D
	INNER JOIN PurchaseOrderHeader AS H ON H.POH_ID = D.POD_POH_ID
	WHERE H.POH_OrderStatus IN ('Draft','Submitted','Approved','Uploaded','Confirmed')
	GROUP BY H.POH_DMA_ID,D.POD_CFN_ID,H.POH_WHM_ID) AS H
	WHERE H.DMA_ID = #TMP_DATA.DMA_ID 
	AND H.CFN_ID = #TMP_DATA.CFN_ID
  AND H.WHM_ID = #TMP_DATA.WHM_ID
	
	--2、订单状态为部分发货，统计未发货数量
	UPDATE #TMP_DATA SET #TMP_DATA.HiddenQty = #TMP_DATA.HiddenQty + ISNULL(H.HiddenQty,0)
	FROM (SELECT H.POH_DMA_ID AS DMA_ID,D.POD_CFN_ID AS CFN_ID,H.POH_WHM_ID AS WHM_ID,SUM(D.POD_RequiredQty-D.POD_ReceiptQty) AS HiddenQty 
	FROM PurchaseOrderDetail AS D
	INNER JOIN PurchaseOrderHeader AS H ON H.POH_ID = D.POD_POH_ID
	WHERE H.POH_OrderStatus = 'Delivering'
	GROUP BY H.POH_DMA_ID,D.POD_CFN_ID,H.POH_WHM_ID) AS H
	WHERE H.DMA_ID = #TMP_DATA.DMA_ID 
	AND H.CFN_ID = #TMP_DATA.CFN_ID
	AND H.WHM_ID = #TMP_DATA.WHM_ID
  
	--3、收货单中未收货的部分
	UPDATE #TMP_DATA SET #TMP_DATA.HiddenQty = #TMP_DATA.HiddenQty + ISNULL(H.HiddenQty,0)
	FROM (SELECT H.PRH_Dealer_DMA_ID AS DMA_ID,P.PMA_CFN_ID AS CFN_ID,H.PRH_WHM_ID AS WHM_ID,SUM(L.POR_ReceiptQty) AS HiddenQty 
	FROM POReceipt AS L
	INNER JOIN POReceiptHeader AS H ON L.POR_PRH_ID = H.PRH_ID
	INNER JOIN Product AS P ON L.POR_SAP_PMA_ID = P.PMA_ID
	WHERE H.PRH_Status IN ('Waiting','WaitingForDelivery')
	GROUP BY H.PRH_Dealer_DMA_ID,P.PMA_CFN_ID,H.PRH_WHM_ID) AS H
	WHERE H.DMA_ID = #TMP_DATA.DMA_ID 
	AND H.CFN_ID = #TMP_DATA.CFN_ID
  AND H.WHM_ID = #TMP_DATA.WHM_ID	
 
  --删除不需要自动补货的记录
	IF @AGType = 'Safety'  
    DELETE FROM #TMP_DATA WHERE SafetyQty - OnHandQty - HiddenQty <= 0 
  ELSE
    DELETE FROM #TMP_DATA WHERE AlertQty - OnHandQty - HiddenQty <= 0
  
 
  --插入临时订单主表
	insert into #mmbo_PurchaseOrderHeader(POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_OrderType,POH_CreateType,
	POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_WHM_ID)	
   SELECT newid(),A.BUM_ID,A.DMA_ID,A.ORDER_TYPE,'Manual',@SysUserId,getdate(),'Draft',0,0,WHM_ID
   from (SELECT DISTINCT DMA_ID,BUM_ID,WHM_ID,ORDER_TYPE from #TMP_DATA) A
  
  --根据仓库，更新收货地址
  update #mmbo_PurchaseOrderHeader set POH_ShipToAddress = WHM_Address
	from Warehouse where WHM_ID = POH_WHM_ID
  
  --更新承运商
  update #mmbo_PurchaseOrderHeader set POH_TerritoryCode = DMA_Certification
	from DealerMaster where DMA_ID = POH_DMA_ID
  
  --更新创建人
  update #mmbo_PurchaseOrderHeader SET POH_CreateUser = DST_User_ID
  FROM (SELECT DST_Dealer_DMA_ID AS DST_DMA_ID,
       CONVERT (UNIQUEIDENTIFIER,max (CONVERT (NVARCHAR (100), DST_Dealer_User_ID))) AS DST_User_ID       
  FROM DealerShipTo
 WHERE DST_IsDefault = 1
GROUP BY DST_Dealer_DMA_ID) AS DST
 WHERE POH_DMA_ID = DST_DMA_ID
  
  --根据创建人，更新联系人信息
  update #mmbo_PurchaseOrderHeader set POH_ContactPerson = DST_ContactPerson,POH_Contact=DST_Contact,POH_ContactMobile=DST_ContactMobile,POH_Consignee=DST_Consignee,POH_ConsigneePhone=DST_ConsigneePhone
	from DealerShipTo where POH_CreateUser = DST_Dealer_User_ID
 
  --插入临时订单明细表(如果是警戒库存，则仍然按照安全库存标准进行更新)
  insert into #mmbo_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
			POD_Tax,POD_ReceiptQty,POD_UOM,
      POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
      POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
  select newid(),Header.POH_ID,data.CFN_ID,data.Price,SafetyQty - OnHandQty - HiddenQty,price*(SafetyQty - OnHandQty),0,0 ,cfn.CFN_Property3,
         REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
         REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog
  from #mmbo_PurchaseOrderHeader AS Header
  INNER join #TMP_DATA AS data 
    on (Header.POH_ProductLine_BUM_ID = Data.BUM_ID and Header.POH_DMA_ID = data.DMA_ID and Header.POH_WHM_ID = data.WHM_ID
        and Header.POH_OrderType = data.ORDER_TYPE )
  INNER join CFN as cfn on (data.CFN_ID = cfn.CFN_ID)
  LEFT join MD.V_INF_UPN_REG AS REG ON (cfn.CFN_CustomerFaceNbr = REG.CurUPN)
 
  --更新订单编号
  update t1 set t1.POH_OrderNo=t2.orderno,POH_Remark='系统自动生成自动补货订单'
    from #mmbo_PurchaseOrderHeader t1,
        (select Poh_ID,
                replace(convert(char(10),getdate(),120),'-','')+replace(convert(char(8),getdate(),114),':','')+
                RIGHT( REPLICATE('0', 5) + Convert(nvarchar(10),(ROW_NUMBER() OVER(ORDER BY Poh_ID desc))), 5) as orderno 
           from #mmbo_PurchaseOrderHeader) t2
   where t1.POH_ID = t2.POH_ID
    
  --插入订单主表和明细表
	insert into PurchaseOrderHeader(POH_ID, POH_OrderNo, POH_ProductLine_BUM_ID, POH_DMA_ID, POH_VendorID, POH_TerritoryCode, POH_RDD, POH_ContactPerson, POH_Contact, POH_ContactMobile, POH_Consignee, POH_ShipToAddress, POH_ConsigneePhone, POH_Remark, POH_InvoiceComment, POH_CreateType, POH_CreateUser, POH_CreateDate, POH_UpdateUser, POH_UpdateDate, POH_SubmitUser, POH_SubmitDate, POH_LastBrowseUser, POH_LastBrowseDate, POH_OrderStatus, POH_LatestAuditDate, POH_IsLocked, POH_SAP_OrderNo, POH_SAP_ConfirmDate, POH_LastVersion, POH_OrderType, POH_VirtualDC, POH_SpecialPriceID, POH_WHM_ID, POH_POH_ID)
	select POH_ID, POH_OrderNo, POH_ProductLine_BUM_ID, POH_DMA_ID, POH_VendorID, POH_TerritoryCode, POH_RDD, POH_ContactPerson, POH_Contact, POH_ContactMobile, POH_Consignee, POH_ShipToAddress, POH_ConsigneePhone, POH_Remark, POH_InvoiceComment, POH_CreateType, POH_CreateUser, POH_CreateDate, POH_UpdateUser, POH_UpdateDate, POH_SubmitUser, POH_SubmitDate, POH_LastBrowseUser, POH_LastBrowseDate, POH_OrderStatus, POH_LatestAuditDate, POH_IsLocked, POH_SAP_OrderNo, POH_SAP_ConfirmDate, POH_LastVersion, POH_OrderType, POH_VirtualDC, POH_SpecialPriceID, POH_WHM_ID, POH_POH_ID from #mmbo_PurchaseOrderHeader
	insert into PurchaseOrderDetail(POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_UOM,POD_RequiredQty,POD_Amount,POD_Tax,POD_ReceiptQty,POD_Status,POD_LotNumber,POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
  select POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_UOM,POD_RequiredQty,POD_Amount,POD_Tax,POD_ReceiptQty,POD_Status,POD_LotNumber,POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog 
    from #mmbo_PurchaseOrderDetail

	--插入订单操作日志
	IF @AGType = 'Safety'
    INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
  	SELECT NEWID(),POH_ID,@SysUserId,GETDATE(),'SafetyGenerate','系统自动生成' FROM #mmbo_PurchaseOrderHeader
  ELSE
	  INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
  	SELECT NEWID(),POH_ID,@SysUserId,GETDATE(),'AlertGenerate','系统自动生成' FROM #mmbo_PurchaseOrderHeader
	
  --处理自动补货邮件到处理表
  INSERT INTO MailMessageProcess (MMP_ID,MMP_Code,MMP_ProcessId,MMP_Status,MMP_CreateDate)
	SELECT NEWID(),'EMAIL_ORDER_AUTOGENERATE',POH.POH_DMA_ID,'Waiting',GETDATE()
	FROM (select distinct POH_DMA_ID from #mmbo_PurchaseOrderHeader) AS POH
  
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    return -1
    
END CATCH
GO


