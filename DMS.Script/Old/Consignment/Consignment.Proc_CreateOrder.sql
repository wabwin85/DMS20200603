IF OBJECT_ID ('Consignment.Proc_CreateOrder') IS NOT NULL
	DROP PROCEDURE Consignment.Proc_CreateOrder
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
1. 功能名称：寄售订单创建（KB、KA、ZTKA、ZTKB）
2. 更能描述：
	根据单据类型创建符合要求的订单，具体如下：
  1、KE订单: 不在这里调用，单独有一个SP，定时执行。全部根据寄售转销售申请单生成
  2、KB订单：
     a、寄售申请生成KB订单：直接根据寄售申请生成KB订单（传入的是寄售申请单，类型是：ConsignApply）
     b、通过KE订单生成KB订单（传入的是KE订单，类型是：KEOrderSubmit）
          I、先判断能否查找到对应的寄售合同：KE订单 -> 发货单（同经销商） -> 订单(同经销商) ->寄售申请单（CAH_POH_OrderNo）-> 寄售合同(CAH_CM_ID -> consignment.ContractHead)
          II、无法通过第一点找到寄售合同，但是可以追溯到之前KB订单的（同时需满足：非强制寄售买断、经销商寄售买断且选择的是需要补货）
  3、KA订单：
     a、退货：根据WMS返回结果生成（调用入口放在SP:GC_Interface_AutoUpdateBSCGoodsReturn中）
     b、投诉：根据MFlow返回的状态来创建KA订单（）
  
  4、ZTKA、ZTKB
     根据寄售转移单获取：Consignment.TransferHead
	
3. 参数描述：
	@OrderType 创建订单类型(KB、KA、ZT(因为ZTKA和ZTKB是一起生成的))
	@BillType 功能类型：寄售申请(ConsignApply)，寄售补货(KEOrderSubmit)，寄售退货(ConsignReturn)，投诉退换货(ComplainReturn)，寄售买断(CTS)，强制寄售买断(MCTS)，寄售销售(ConsignSales)，寄售发货(ConsignShipment)，寄售转移(ConsignTransfer)
	@BillNo 单据号
	@IsActiveImmediately 订单创建好后是否自动提交
	@IsSendBack 寄售退货未被确认数据是否返回原仓库（暂去除）
	@RtnVal 执行状态：Success、Failure
	@RtnMsg 错误描述
*/
CREATE PROCEDURE [Consignment].[Proc_CreateOrder](
     @OrderType NVARCHAR(50)
    ,@BillType NVARCHAR(100)
    ,@BillNo  NVARCHAR(100)
    ,@IsActiveImmediately  NVARCHAR(50)
   -- ,@IsSendBack NVARCHAR(50)
    ,@RtnVal NVARCHAR(20) OUTPUT
	  ,@RtnMsg NVARCHAR(1000) OUTPUT
)
AS
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
BEGIN
    Declare @NewOrderNo Nvarchar(30)
    Declare @NewOrderType Nvarchar(30)
    DECLARE @SysUserId uniqueidentifier
	  DECLARE @VENDORID uniqueidentifier
    DECLARE @AutoSubmitDate nvarchar(20)
    
    SET @SysUserId = '00000000-0000-0000-0000-000000000000'
    SET @VENDORID = 'fb62d945-c9d7-4b0f-8d26-4672d2c728b7'  --BSC(HQ) Vendor必定是波科
    SET @AutoSubmitDate = GETDATE()
    
    --新建订单临时表
  	CREATE TABLE #tmp_PurchaseOrderHeader (
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
		POH_SalesAccount nvarchar(50) collate Chinese_PRC_CI_AS NULL,
    POH_PointType nvarchar(100) collate Chinese_PRC_CI_AS NULL,
    POH_IsUsePro nvarchar(5) collate Chinese_PRC_CI_AS NULL,
    POH_DcType nvarchar(20) collate Chinese_PRC_CI_AS NULL,
    POH_SendHospital nvarchar(200) collate Chinese_PRC_CI_AS NULL,
    POH_SendAddress nvarchar(500) collate Chinese_PRC_CI_AS NULL,
    POH_SendWMSFlg int NULL,    
    POH_BU_NAME nvarchar(50) collate Chinese_PRC_CI_AS NULL,   
		primary key (POH_ID)
	)

	CREATE TABLE #tmp_PurchaseOrderDetail (
		POD_ID               uniqueidentifier     not null,
		POD_POH_ID           uniqueidentifier     null,
		POD_CFN_ID           uniqueidentifier     null,
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
	
  CREATE TABLE #tmp_PurchaseOrderDetail_WithQR (
		POD_ID               uniqueidentifier     not null,
		POD_POH_ID           uniqueidentifier     null,
		POD_CFN_ID           uniqueidentifier     null,
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
    POD_QRCode nvarchar(50) collate Chinese_PRC_CI_AS NULL,
    POD_ConsignmentDay int null,
    POD_ConsignmentContractID uniqueidentifier,
		primary key (POD_ID)
	)
  

  
  -- KB订单(KB订单不需要考虑拆单)
  --     a、寄售申请生成KB订单：直接根据寄售申请生成KB订单（传入的是寄售申请单，类型是：ConsignApply）
  --     b、通过KE订单生成KB订单（传入的是KE订单，类型是：KEOrderSubmit）
  --          I、先判断能否查找到对应的寄售合同：KE订单 -> 发货单（同经销商） -> 订单(同经销商) ->寄售申请单（CAH_POH_OrderNo）-> 寄售合同(CAH_CM_ID -> consignment.ContractHead)
  --          II、无法通过第一点找到寄售合同，但是可以追溯到之前KB订单的（同时需满足：非强制寄售买断、经销商寄售买断且选择的是需要补货）
    
  IF (@OrderType = 'KB') 
    BEGIN
      IF (@BillType ='ConsignmentApply')
        BEGIN
          --确定OrderType(寄售订单，对应Lafite_DICT表中的CONST_Order_Type)
          SET @NewOrderType = 'Consignment'       
          
          --寄售申请单单号去掉首字母'R',结尾处添加寄售天数和'L'	        
          SELECT @NewOrderNo = SUBSTRING(@BillNo,CHARINDEX('R',@BillNo)+1,LEN(@BillNo)-CHARINDEX('R',@BillNo))+ISNULL(Convert(nvarchar(5),CAH_CM_ConsignmentDay),'0')+'L'
          FROM ConsignmentApplyHeader(nolock) where CAH_OrderNo=@BillNo
          
         
          
          --将订单号更新到寄售申请单中
	        UPDATE ConsignmentApplyHeader SET CAH_POH_OrderNo = @NewOrderNo WHERE CAH_OrderNo=@BillNo          
          
          --寄售订单的自动生成-订单主信息
        	INSERT INTO #tmp_PurchaseOrderHeader
                 (POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_VendorID,POH_OrderType,POH_CreateType,
                	POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_WHM_ID,POH_SubmitDate,POH_SubmitUser,POH_Remark,
                	POH_ShipToAddress,POH_Consignee,POH_ConsigneePhone,POH_OrderNo,POH_RDD)	
        	SELECT NEWID() AS POH_ID,CAH_ProductLine_Id,CAH_DMA_ID,  
                 CASE WHEN CAH_ConsignmentFrom = 'Otherdealers' THEN CAH_ConsignmentId ELSE @VENDORID END, --寄售销商的ID                
        		     @NewOrderType,'Manual',CAH_CreateUser,
        		     GETDATE(),'Submitted',0,0,
                 (SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = CAH_DMA_ID AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1),
                 CONVERT(datetime,@AutoSubmitDate),@SysUserId,
                 CAH_OrderNo,CAH_ShipToAddress,CAH_Consignee,CAH_ConsigneePhone,@NewOrderNo
                 --,CAH_SalesName,CAH_SalesEmail,CAH_SalesPhone
                 ,CAH_RDD
        		FROM ConsignmentApplyHeader(nolock) 
        	WHERE CAH_OrderNo=@BillNo
          
         
          
          --更新承运商
        	UPDATE #tmp_PurchaseOrderHeader SET POH_TerritoryCode = DMA_Certification
        	FROM DealerMaster(nolock) WHERE DMA_ID = POH_DMA_ID
          
          Update #tmp_PurchaseOrderHeader 
             set POH_ContactPerson = DST_ContactPerson,POH_Contact=DST_Contact,POH_ContactMobile=DST_ContactMobile,POH_Consignee=DST_Consignee,POH_ConsigneePhone=DST_ConsigneePhone
    	      from DealerShipTo(nolock) where POH_CreateUser = DST_Dealer_User_ID
          
          --插入临时订单明细表
        	INSERT INTO #tmp_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
        			POD_Tax,POD_ReceiptQty,POD_UOM,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,
        	POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
        	POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
            SELECT NEWID(),POH_ID,CFN_ID,0,Qty,0,0,0 ,CFN_Property3,LTM_LotNumber,
        	         CAH_OrderNo,CAH_Hospital_Id,WhmId,null,'','',
                   REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
                   REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog
          	FROM (    
            SELECT PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LotMaster.LTM_LotNumber,CAH.CAH_OrderNo,CFN.CFN_CustomerFaceNbr,
                   CAH.CAH_Hospital_Id,(SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = CAH.CAH_DMA_ID AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1) AS WhmId,
        		   CAST(ROUND(SUM(ISNULL(CAD_Qty,0)),2) AS NUMERIC(10)) AS Qty
              FROM #tmp_PurchaseOrderHeader AS PO 
        	  INNER JOIN ConsignmentApplyHeader AS CAH(nolock) ON PO.POH_Remark = CAH.CAH_OrderNo AND PO.POH_DMA_ID = CAH.CAH_DMA_ID AND PO.POH_ProductLine_BUM_ID = CAH.CAH_ProductLine_Id
        	  INNER JOIN ConsignmentApplyDetails AS CAD(nolock) ON CAH.CAH_ID = CAD.CAD_CAH_ID AND CAH.CAH_CAH_ID IS NULL
        	  INNER JOIN CFN(nolock) ON CAD.CAD_CFN_ID = CFN_ID 
        	  INNER JOIN Product(nolock) ON PMA_CFN_ID = CFN_ID
        	  LEFT JOIN LotMaster(nolock) ON LTM_LotNumber = CAD_LotNumber AND LTM_Product_PMA_ID = PMA_ID
          	  WHERE CAH_OrderNo=@BillNo
          	 GROUP BY PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LotMaster.LTM_LotNumber,CAH.CAH_OrderNo,CFN.CFN_CustomerFaceNbr,CAH.CAH_Hospital_Id,CAH.CAH_DMA_ID
             ) tab LEFT join MD.V_INF_UPN_REG AS REG ON (tab.CFN_CustomerFaceNbr = REG.CurUPN)
          
          --插入临时二维码订单明细表
        	INSERT INTO #tmp_PurchaseOrderDetail_WithQR (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
        			POD_Tax,POD_ReceiptQty,POD_UOM,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,
        	POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
        	POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,POD_ConsignmentDay,POD_ConsignmentContractID)
            SELECT NEWID(),POH_ID,CFN_ID,0,Qty,0,0,0 ,CFN_Property3,LTM_LotNumber,
        	         CAH_OrderNo,CAH_Hospital_Id,WhmId,null,'','',
                   REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
                   REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog,tab.CAH_CM_ConsignmentDay,tab.CAH_CM_ID
          	FROM (    
            SELECT PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LotMaster.LTM_LotNumber,CAH.CAH_OrderNo,CFN.CFN_CustomerFaceNbr,
                   CAH.CAH_Hospital_Id,(SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = CAH.CAH_DMA_ID AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1) AS WhmId,CAH.CAH_CM_ConsignmentDay,CAH.CAH_CM_ID,
        		   CAST(ROUND(SUM(ISNULL(CAD_Qty,0)),2) AS NUMERIC(10)) AS Qty
              FROM #tmp_PurchaseOrderHeader AS PO 
        	  INNER JOIN ConsignmentApplyHeader AS CAH(nolock) ON PO.POH_Remark = CAH.CAH_OrderNo AND PO.POH_DMA_ID = CAH.CAH_DMA_ID AND PO.POH_ProductLine_BUM_ID = CAH.CAH_ProductLine_Id
        	  INNER JOIN ConsignmentApplyDetails AS CAD(nolock) ON CAH.CAH_ID = CAD.CAD_CAH_ID AND CAH.CAH_CAH_ID IS NULL
        	  INNER JOIN CFN(nolock) ON CAD.CAD_CFN_ID = CFN_ID 
        	  INNER JOIN Product(nolock) ON PMA_CFN_ID = CFN_ID
        	  LEFT JOIN LotMaster(nolock) ON LTM_LotNumber = CAD_LotNumber AND LTM_Product_PMA_ID = PMA_ID
          	  WHERE CAH_OrderNo=@BillNo
          	 GROUP BY PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LotMaster.LTM_LotNumber,CAH.CAH_OrderNo,CFN.CFN_CustomerFaceNbr,CAH.CAH_Hospital_Id,CAH.CAH_DMA_ID,CAH.CAH_CM_ConsignmentDay,CAH.CAH_CM_ID
             ) tab LEFT join MD.V_INF_UPN_REG AS REG ON (tab.CFN_CustomerFaceNbr = REG.CurUPN)
    
          
        END
      
      ELSE IF (@BillType ='KEOrderSubmit') 
        BEGIN
          --创建新的POH_ID
          Declare @NewKEOID uniqueidentifier
          
          CREATE TABLE #tmp_IsKB_QR (
              		POD_ID          uniqueidentifier     NOT NULL,
              		POD_POH_ID      uniqueidentifier     NULL,
              		POD_CFN_ID      uniqueidentifier     NULL,
              		POD_RequiredQty decimal(18,6)        NULL,
              		POD_LotNumber		nvarchar(50)		     Collate Chinese_PRC_CI_AS null,
              		POD_QRCode      nvarchar(50)         Collate Chinese_PRC_CI_AS NULL,
                  POD_ConsignmentDay int null,
                  POD_ConsignmentContractID uniqueidentifier,
                  POD_ShipmentNbr		nvarchar(50)		 collate Chinese_PRC_CI_AS null
              	)
          
          CREATE TABLE #tmp_IsKB_QR_FromKB (
              		POD_ID          uniqueidentifier     NOT NULL,
              		POD_POH_ID      uniqueidentifier     NULL,
              		POD_CFN_ID      uniqueidentifier     NULL,
              		POD_RequiredQty decimal(18,6)        NULL,
              		POD_LotNumber		nvarchar(50)		     Collate Chinese_PRC_CI_AS null,
              		POD_QRCode      nvarchar(50)         Collate Chinese_PRC_CI_AS NULL,
                  POD_ConsignmentDay int null,
                  POD_ConsignmentContractID uniqueidentifier,
                  POD_ShipmentNbr		nvarchar(50)		 collate Chinese_PRC_CI_AS null
              	)
          
          --先判断能否查找到对应的寄售合同：KE订单(按明细二维码) -> 发货单（同经销商） -> 订单(同经销商) ->寄售申请单（CAH_POH_OrderNo）-> 寄售合同(CAH_CM_ID -> consignment.ContractHead,isKB代表是否自动补货)
          INSERT INTO #tmp_IsKB_QR(POD_ID,POD_POH_ID,POD_CFN_ID,POD_RequiredQty,POD_LotNumber,POD_QRCode,POD_ConsignmentDay,POD_ConsignmentContractID,POD_ShipmentNbr)
          SELECT PDQKE.POD_ID, PDQKE.POD_POH_ID,PDQKE.POD_CFN_ID,PDQKE.POD_RequiredQty,PDQKE.POD_LotNumber,PDQKE.POD_QRCode, CAH.CAH_CM_ConsignmentDay, CAH.CAH_CM_ID,PDQKE.POD_ShipmentNbr
            FROM POReceiptHeader RH(nolock), POReceipt RD(nolock), POReceiptLot RT(nolock), PurchaseOrderHeader PHKE(nolock), PurchaseOrderDetail_WithQR PDQKE(nolock), PurchaseOrderHeader PHF(nolock),
                 ConsignmentApplyHeader CAH(nolock),  Consignment.ContractHeader CCH(nolock)
           WHERE PHKE.POH_OrderNo = @BillNo and PHKE.POH_ID = PDQKE.POD_POH_ID
             AND RH.PRH_ID = RD.POR_PRH_ID and RD.POR_ID = RT.PRL_POR_ID
             AND PDQKE.POD_LotNumber + '@@' + isnull(PDQKE.POD_QRCode,'') = RT.PRL_LotNumber and RH.PRH_Dealer_DMA_ID = PHKE.POH_DMA_ID  
             AND RH.PRH_PurchaseOrderNbr = PHF.POH_OrderNo AND CAH.CAH_POH_OrderNo = PHF.POH_OrderNo AND CCH.CCH_ID = CAH.CAH_CM_ID 
             AND CCH.CCH_IsKB = 1
          
             
           INSERT INTO #tmp_IsKB_QR_FromKB(POD_ID,POD_POH_ID,POD_CFN_ID,POD_RequiredQty,POD_LotNumber,POD_QRCode,POD_ConsignmentDay,POD_ConsignmentContractID)
              SELECT PDQKE.POD_ID, PDQKE.POD_POH_ID,PDQKE.POD_CFN_ID,PDQKE.POD_RequiredQty,PDQKE.POD_LotNumber,PDQKE.POD_QRCode,null,null
                FROM POReceiptHeader RH(nolock), POReceipt RD(nolock), POReceiptLot RT(nolock), PurchaseOrderHeader PHKE(nolock),
                     PurchaseOrderDetail_WithQR PDQKE(nolock), PurchaseOrderHeader PHF(nolock)
               WHERE PHKE.POH_OrderNo = @BillNo and PHKE.POH_ID = PDQKE.POD_POH_ID
                 AND RH.PRH_ID = RD.POR_PRH_ID and RD.POR_ID = RT.PRL_POR_ID
                 --AND PHF.POH_ID = PHQ.POD_POH_ID
                 AND PDQKE.POD_LotNumber + '@@' + isnull(PDQKE.POD_QRCode,'') = RT.PRL_LotNumber and RH.PRH_Dealer_DMA_ID = PHKE.POH_DMA_ID  
                 AND RH.PRH_PurchaseOrderNbr = PHF.POH_OrderNo AND PHF.POH_OrderType = 'Consignment'
                 AND NOT Exists (select 1 
                                   from InventoryAdjustHeader IAH(nolock), InventoryAdjustDetail IAD(nolock), InventoryAdjustLot IAL(nolock) 
                                  where IAH.IAH_Reason='ForceCTOS' and IAH.IAH_ID = IAD.IAD_IAH_ID and IAD.IAD_ID = IAL.IAL_IAD_ID and IAL.IAL_LotNumber = PDQKE.POD_LotNumber + '@@' + isnull(PDQKE.POD_QRCode,'')
                                    AND IAH.IAH_DMA_ID = PHKE.POH_DMA_ID )
                 AND NOT Exists (select 1 from #tmp_IsKB_QR NeedAdd where NeedAdd.POD_QRCode = PDQKE.POD_QRCode)
          
          select  t1.POD_QRCode,PHQ.POD_ConsignmentDay,PHQ.POD_ConsignmentContractID into #tmp_QRCode_ContractInfo
          from #tmp_IsKB_QR_FromKB t1,POReceiptHeader RH(nolock), POReceipt RD(nolock), POReceiptLot RT(nolock),PurchaseOrderHeader PHKE(nolock), 
               PurchaseOrderHeader PHF(nolock), PurchaseOrderDetail_WithQR PHQ(nolock)
          where RH.PRH_ID = RD.POR_PRH_ID and RD.POR_ID = RT.PRL_POR_ID and t1.POD_POH_ID = PHKE.POH_ID
          and t1.POD_LotNumber + '@@' + isnull(t1.POD_QRCode,'')= RT.PRL_LotNumber and RH.PRH_Dealer_DMA_ID = PHKE.POH_DMA_ID 
          AND RH.PRH_PurchaseOrderNbr = PHF.POH_OrderNo AND PHF.POH_OrderType = 'Consignment'
          AND PHF.POH_ID = PHQ.POD_POH_ID
          group by t1.POD_QRCode,PHQ.POD_ConsignmentDay,PHQ.POD_ConsignmentContractID 
         
          
          
          update src set src.POD_ConsignmentDay=tag.POD_ConsignmentDay, src.POD_ConsignmentContractID = tag.POD_ConsignmentContractID
          from #tmp_IsKB_QR_FromKB src, #tmp_QRCode_ContractInfo tag
          where src.POD_QRCode = tag.POD_QRCode and src.POD_ConsignmentDay is null
          
          insert into #tmp_IsKB_QR
          SELECT * FROM #tmp_IsKB_QR_FromKB
          
		  delete from #tmp_IsKB_QR where pod_consignmentContractID is null 

          IF (SELECT count(*) FROM #tmp_IsKB_QR) > 0
            BEGIN
              
              SET @NewKEOID = newid()             
              
              --根据KE订单生成KB订单
              INSERT INTO #tmp_PurchaseOrderHeader(POH_ID, POH_OrderNo, POH_ProductLine_BUM_ID, POH_DMA_ID, POH_VendorID, POH_TerritoryCode, POH_RDD, POH_ContactPerson,
                     POH_Contact, POH_ContactMobile, POH_Consignee, POH_ShipToAddress, POH_ConsigneePhone, POH_Remark, POH_InvoiceComment, POH_CreateType, POH_CreateUser, 
                     POH_CreateDate, POH_UpdateUser, POH_UpdateDate, POH_SubmitUser, POH_SubmitDate, POH_LastBrowseUser, POH_LastBrowseDate, POH_OrderStatus, POH_LatestAuditDate,
                     POH_IsLocked, POH_SAP_OrderNo, POH_SAP_ConfirmDate, POH_LastVersion, POH_OrderType, POH_VirtualDC, POH_SpecialPriceID, POH_WHM_ID, POH_POH_ID, POH_SalesAccount, 
                     POH_PointType, POH_IsUsePro, POH_DcType, POH_SendHospital, POH_SendAddress, POH_SendWMSFlg)
              SELECT @NewKEOID, POH_OrderNo+'KB', POH_ProductLine_BUM_ID, POH_DMA_ID, POH_VendorID, POH_TerritoryCode, POH_RDD, POH_ContactPerson, POH_Contact, 
                     POH_ContactMobile, POH_Consignee, POH_ShipToAddress, POH_ConsigneePhone, POH_Remark, POH_InvoiceComment, POH_CreateType, POH_CreateUser,
                     POH_CreateDate, POH_UpdateUser, POH_UpdateDate, POH_SubmitUser, POH_SubmitDate, POH_LastBrowseUser, POH_LastBrowseDate, 
                     'Submitted', POH_LatestAuditDate, POH_IsLocked, POH_SAP_OrderNo, POH_SAP_ConfirmDate, POH_LastVersion, 'Consignment', POH_VirtualDC, POH_SpecialPriceID, 
                     POH_WHM_ID, POH_POH_ID, POH_SalesAccount, POH_PointType, POH_IsUsePro, POH_DcType, POH_SendHospital, POH_SendAddress, POH_SendWMSFlg
                FROM PurchaseOrderHeader(nolock) where POH_ID in (select POD_POH_ID from #tmp_IsKB_QR)
              
              --明细信息，按产品型号汇总
              INSERT INTO #tmp_PurchaseOrderDetail(POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_UOM,POD_RequiredQty,POD_Amount,POD_Tax,POD_ReceiptQty,
                     POD_Status,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,
                     POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
              SELECT NEWID(),@NewKEOID,POD.POD_CFN_ID,0,POD.POD_UOM,sum(POD.POD_RequiredQty),0,POD.POD_Tax,0,
                     POD.POD_Status,null,null,POD.POD_HOS_ID,POD.POD_WH_ID,'','','',POD.POD_CurRegNo,POD.POD_CurValidDateFrom,POD.POD_CurValidDataTo,
                     POD.POD_CurManuName,POD.POD_LastRegNo,POD.POD_LastValidDateFrom,POD.POD_LastValidDataTo,POD.POD_LastManuName,POD.POD_CurGMKind,POD.POD_CurGMCatalog
                FROM PurchaseOrderDetail_WithQR AS POD(nolock), #tmp_IsKB_QR AS PODQR
               WHERE POD.POD_ID = PODQR.POD_ID
                 and not exists (select 1 from inventoryAdjustHeader IAH(nolock) where IAH.IAH_Inv_Adj_Nbr=PODQR.POD_ShipmentNbr and IAH.IAH_Reason='ForceCTOS' )
               group by POD.POD_POH_ID,POD.POD_CFN_ID,POD.POD_CFN_Price,POD.POD_UOM,POD.POD_Tax,
                     POD.POD_Status,POD.POD_HOS_ID,POD.POD_WH_ID,POD.POD_CurRegNo,POD.POD_CurValidDateFrom,POD.POD_CurValidDataTo,
                     POD.POD_CurManuName,POD.POD_LastRegNo,POD.POD_LastValidDateFrom,POD.POD_LastValidDataTo,POD.POD_LastManuName,POD.POD_CurGMKind,POD.POD_CurGMCatalog
                     
              --二维码订单明细信息
              INSERT INTO #tmp_PurchaseOrderDetail_WithQR(POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_UOM,POD_RequiredQty,POD_Amount,POD_Tax,POD_ReceiptQty,
                     POD_Status,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,
                     POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,POD_QRCode, POD_ConsignmentDay,POD_ConsignmentContractID)
              SELECT NEWID(),@NewKEOID,POD.POD_CFN_ID,0,POD.POD_UOM,sum(POD.POD_RequiredQty),0,POD.POD_Tax,0,
                     POD.POD_Status,null,PODQR.POD_ShipmentNbr,POD.POD_HOS_ID,POD.POD_WH_ID,'','','',POD.POD_CurRegNo,POD.POD_CurValidDateFrom,POD.POD_CurValidDataTo,
                     POD.POD_CurManuName,POD.POD_LastRegNo,POD.POD_LastValidDateFrom,POD.POD_LastValidDataTo,POD.POD_LastManuName,POD.POD_CurGMKind,POD.POD_CurGMCatalog,POD.POD_QRCode,PODQR.POD_ConsignmentDay,
                     PODQR.POD_ConsignmentContractID
                FROM PurchaseOrderDetail_WithQR AS POD(nolock), #tmp_IsKB_QR AS PODQR                
               WHERE POD.POD_ID = PODQR.POD_ID
                 and not exists (select 1 from inventoryAdjustHeader IAH(nolock) where IAH.IAH_Inv_Adj_Nbr=PODQR.POD_ShipmentNbr and IAH.IAH_Reason='ForceCTOS' )
               group by POD.POD_POH_ID,POD.POD_CFN_ID,POD.POD_CFN_Price,POD.POD_UOM,POD.POD_Tax,
                     POD.POD_Status,POD.POD_HOS_ID,POD.POD_WH_ID,POD.POD_CurRegNo,POD.POD_CurValidDateFrom,POD.POD_CurValidDataTo,
                     POD.POD_CurManuName,POD.POD_LastRegNo,POD.POD_LastValidDateFrom,POD.POD_LastValidDataTo,POD.POD_LastManuName,POD.POD_CurGMKind,POD.POD_CurGMCatalog,POD.POD_QRCode,PODQR.POD_ConsignmentDay,PODQR.POD_ConsignmentContractID,PODQR.POD_ShipmentNbr
                
              
            END         
          
        END
        
    END
 
  IF (@OrderType = 'KA') 
    BEGIN
      Declare @rtnDmaId uniqueidentifier
      Declare @rtnProdLine uniqueidentifier
      IF @BillType ='ConsignReturn'
        BEGIN
          -- a、退货：根据WMS返回结果生成（调用入口放在SP:GC_Interface_AutoUpdateBSCGoodsReturn中）
          --确定OrderType(寄售订单，对应Lafite_DICT表中的CONST_Order_Type)
         
          
          SET @NewOrderType = 'ConsignmentReturn'      
          
          
          select @rtnDmaId = IAH_DMA_ID, @rtnProdLine = IAH_ProductLine_BUM_ID
            from InventoryAdjustHeader(nolock) where IAH_Reason in ('Return','Exchange') and IAH_Inv_Adj_Nbr=@BillNo
                    
          --获取订单编号(规则是在原有寄售转移单后面加KA)     
          EXEC  dbo.GC_GetNextAutoNumberForPO 
                @rtnDmaId,
                N'Next_PurchaseOrder',
                @rtnProdLine,
                @NewOrderType,
                @NewOrderNo out;          
              
          --ZTKA订单的自动生成-订单主信息(To-Dealer)
        	INSERT INTO #tmp_PurchaseOrderHeader
                 (POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_VendorID,POH_OrderType,POH_CreateType,
                	POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_WHM_ID,POH_SubmitDate,POH_SubmitUser,POH_Remark,
                	POH_ShipToAddress,POH_Consignee,POH_ConsigneePhone,POH_OrderNo,POH_RDD)	
        	
           SELECT NEWID() AS POH_ID,H.IAH_ProductLine_BUM_ID ,H.IAH_DMA_ID ,@VENDORID,@NewOrderType,'Manual',@SysUserId,getdate(),'Submitted',0,0,
                  (SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = H.IAH_DMA_ID AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1),
                   CONVERT(datetime,@AutoSubmitDate),@SysUserId,            
                  @BillNo,null,null,null,@NewOrderNo,getdate() AS RDD
            FROM InventoryAdjustHeader H(nolock)
           WHERE H.IAH_Inv_Adj_Nbr =@BillNo AND H.IAH_Reason in ('Return','Exchange')
          
          --根据仓库，更新收货地址(LP)
        	update t2 set POH_ShipToAddress = SWA_WH_Address
        	from SAPWarehouseAddress t1(nolock), #tmp_PurchaseOrderHeader t2
          where t1.SWA_DMA_ID  = t2.POH_DMA_ID 
          
          --更新承运商
        	UPDATE #tmp_PurchaseOrderHeader SET POH_TerritoryCode = DMA_Certification
        	FROM DealerMaster(nolock) WHERE DMA_ID = POH_DMA_ID
          
          --根据创建人，更新联系人信息
        	update #tmp_PurchaseOrderHeader 
             set POH_ContactPerson = DST_ContactPerson,POH_Contact=DST_Contact,POH_ContactMobile=DST_ContactMobile,POH_Consignee=DST_Consignee,POH_ConsigneePhone=DST_ConsigneePhone
        	  from DealerShipTo(nolock) where POH_CreateUser = DST_Dealer_User_ID
          
          --插入临时订单明细表
        	INSERT INTO #tmp_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
        			POD_Tax,POD_ReceiptQty,POD_UOM,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,
        	POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
        	POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
            SELECT NEWID(),POH_ID,CFN_ID,0,Qty,0,0,0 ,CFN_Property3,LTM_LotNumber,
        	         IAH_Inv_Adj_Nbr,null,WhmId,null,'','',
                   REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
                   REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog
          	FROM (    
            SELECT PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LM.LTM_LotNumber,H.IAH_Inv_Adj_Nbr,CFN.CFN_CustomerFaceNbr,
                   (SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = H.IAH_DMA_ID AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1) AS WhmId,
        		   CAST(ROUND(SUM(ISNULL(D.IAL_LotQty ,0)),2) AS NUMERIC(10)) AS Qty
              FROM #tmp_PurchaseOrderHeader AS PO 
        	  INNER JOIN InventoryAdjustHeader AS H(nolock) ON PO.POH_Remark = H.IAH_Inv_Adj_Nbr AND PO.POH_DMA_ID = H.IAH_DMA_ID AND PO.POH_ProductLine_BUM_ID = H.IAH_ProductLine_BUM_ID
        	  INNER JOIN InventoryAdjustDetail AS L(nolock) ON H.IAH_ID = L.IAD_IAH_ID 
        	  INNER JOIN InventoryAdjustLot AS D(nolock) ON L.IAD_ID = D.IAL_IAD_ID
        	  INNER JOIN Product(nolock) ON PMA_ID = L.IAD_PMA_ID
            INNER JOIN CFN(nolock) ON Product.pma_CFN_ID = CFN.CFN_ID
            INNER JOIN Lot(nolock) ON LOT_ID = D.IAL_LOT_ID
        	  INNER JOIN V_LotMaster AS LM ON LOT_LTM_ID = LTM_ID AND LTM_Product_PMA_ID = PMA_ID
          	WHERE H.IAH_Inv_Adj_Nbr =@BillNo
          	 GROUP BY PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LM.LTM_LotNumber,H.IAH_Inv_Adj_Nbr,CFN.CFN_CustomerFaceNbr,H.IAH_DMA_ID
             ) tab LEFT join MD.V_INF_UPN_REG AS REG ON (tab.CFN_CustomerFaceNbr = REG.CurUPN)
            
           
        	
          --插入临时订单二维码明细表
        	INSERT INTO #tmp_PurchaseOrderDetail_WithQR (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
        			POD_Tax,POD_ReceiptQty,POD_UOM,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,
        	POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
        	POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,POD_QRCode)
            SELECT NEWID(),POH_ID,CFN_ID,0,Qty,0,0,0 ,CFN_Property3,LTM_LotNumber,
        	         IAH_Inv_Adj_Nbr,null,WhmId,null,'','',
                   REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
                   REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog,LTM_QRCode
          	FROM (    
            SELECT PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LM.LTM_LotNumber,H.IAH_Inv_Adj_Nbr,CFN.CFN_CustomerFaceNbr,LM.LTM_QRCode,
                   (SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = H.IAH_DMA_ID AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1) AS WhmId,
        		       CAST(ROUND(SUM(ISNULL(D.IAL_LotQty,0)),2) AS NUMERIC(10)) AS Qty
              FROM #tmp_PurchaseOrderHeader AS PO 
        	  INNER JOIN InventoryAdjustHeader AS H(nolock) ON PO.POH_Remark = H.IAH_Inv_Adj_Nbr AND PO.POH_DMA_ID = H.IAH_DMA_ID AND PO.POH_ProductLine_BUM_ID = H.IAH_ProductLine_BUM_ID
        	  INNER JOIN InventoryAdjustDetail AS L(nolock) ON H.IAH_ID = L.IAD_IAH_ID 
        	  INNER JOIN InventoryAdjustLot AS D(nolock) ON L.IAD_ID = D.IAL_IAD_ID
        	  INNER JOIN Product(nolock) ON PMA_ID = L.IAD_PMA_ID
            INNER JOIN CFN(nolock) ON Product.pma_CFN_ID = CFN.CFN_ID
            INNER JOIN Lot(nolock) ON LOT_ID = D.IAL_LOT_ID
        	  INNER JOIN V_LotMaster AS LM ON LOT_LTM_ID = LM.LTM_ID AND LTM_Product_PMA_ID = PMA_ID
          	WHERE H.IAH_Inv_Adj_Nbr =@BillNo
          	 GROUP BY PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LM.LTM_LotNumber,H.IAH_Inv_Adj_Nbr,CFN.CFN_CustomerFaceNbr,H.IAH_DMA_ID,LM.LTM_QRCode
             ) tab LEFT join MD.V_INF_UPN_REG AS REG ON (tab.CFN_CustomerFaceNbr = REG.CurUPN)
          
        END
      IF @BillType = 'ComplainReturn'
        BEGIN
          -- b、投诉：根据MFlow审批节点来创建KA订单（调用入口放在SP:GC_Interface_AutoUpdateBSCGoodsReturn中）
          --确定OrderType(寄售订单，对应Lafite_DICT表中的CONST_Order_Type)
         
          
          SET @NewOrderType = 'ConsignmentReturn'      
          
          
          
          SELECT @rtnDmaId=DC_CorpId,@rtnProdLine = CFN.CFN_ProductLine_BUM_ID  from (
          SELECT DC_CorpId,UPN  from Dealercomplain(nolock) where DC_ComplainNbr=@BillNo
          union
          SELECT DC_CorpId,Serial from DealercomplainCRM(nolock) where DC_ComplainNbr=@BillNo
          ) cpList , CFN 
          where cpList.UPN = CFN.CFN_CustomerFaceNbr
          
         
                    
          --获取订单编号(规则是在原有寄售转移单后面加KA)     
          EXEC  dbo.GC_GetNextAutoNumberForPO 
                @rtnDmaId,
                N'Next_PurchaseOrder',
                @rtnProdLine,
                @NewOrderType,
                @NewOrderNo out;          
              
          --ZTKA订单的自动生成-订单主信息(To-Dealer)
        	INSERT INTO #tmp_PurchaseOrderHeader
                 (POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_VendorID,POH_OrderType,POH_CreateType,
                	POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_WHM_ID,POH_SubmitDate,POH_SubmitUser,POH_Remark,
                	POH_ShipToAddress,POH_Consignee,POH_ConsigneePhone,POH_OrderNo,POH_RDD)	
        	
           SELECT NEWID() AS POH_ID,CFN.CFN_ProductLine_BUM_ID,DC_CorpId AS DMA_ID,@VENDORID,@NewOrderType,'Manual',@SysUserId,getdate(),'Submitted',0,0,
                  (SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = cpList.DC_CorpId AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1),
                   CONVERT(datetime,@AutoSubmitDate),@SysUserId,            
                  @BillNo,null,null,null,@NewOrderNo,getdate() AS RDD                  
             FROM (
                  SELECT DC_CorpId,UPN  from Dealercomplain(nolock) where DC_ComplainNbr=@BillNo
                  union
                  SELECT DC_CorpId,Serial from DealercomplainCRM(nolock) where DC_ComplainNbr=@BillNo
                  ) cpList , CFN 
                  where cpList.UPN = CFN.CFN_CustomerFaceNbr
         
          
          --根据仓库，更新收货地址(LP)
        	update t2 set POH_ShipToAddress = SWA_WH_Address
        	from SAPWarehouseAddress t1(nolock), #tmp_PurchaseOrderHeader t2
          where t1.SWA_DMA_ID  = t2.POH_DMA_ID 
          
          --更新承运商
        	UPDATE #tmp_PurchaseOrderHeader SET POH_TerritoryCode = DMA_Certification
        	FROM DealerMaster(nolock) WHERE DMA_ID = POH_DMA_ID
          
          --根据创建人，更新联系人信息
        	update #tmp_PurchaseOrderHeader 
             set POH_ContactPerson = DST_ContactPerson,POH_Contact=DST_Contact,POH_ContactMobile=DST_ContactMobile,POH_Consignee=DST_Consignee,POH_ConsigneePhone=DST_ConsigneePhone
        	  from DealerShipTo(nolock) where POH_CreateUser = DST_Dealer_User_ID
          
          --插入临时订单明细表
        	INSERT INTO #tmp_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
        			POD_Tax,POD_ReceiptQty,POD_UOM,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,
        	POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
        	POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
            SELECT NEWID(),POH_ID,CFN_ID,0,Qty,0,0,0 ,CFN_Property3,Lot,
        	         DC_ComplainNbr,null,WhmId,null,'','',
                   REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
                   REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog
          	FROM (    
            SELECT PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,cpList.Lot,cpList.DC_ComplainNbr,CFN.CFN_CustomerFaceNbr,
                   (SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = cpList.DC_CorpId AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1) AS WhmId,
        		       CAST(ROUND(SUM(ISNULL(cpList.ReturnNum ,0)),2) AS NUMERIC(10)) AS Qty
              FROM #tmp_PurchaseOrderHeader AS PO 
        	  INNER JOIN (
                  SELECT DC_ComplainNbr,DC_CorpId,UPN,ReturnNum,CASE WHEN charindex('@@',LOT) > 0  THEN substring(LOT,1,charindex('@@',LOT)-1) ELSE LOT END AS Lot 
                  from Dealercomplain(nolock) where DC_ComplainNbr=@BillNo
                  union
                  SELECT DC_ComplainNbr,DC_CorpId,Serial,Convert(decimal(18,2),1/ConvertFactor),CASE WHEN charindex('@@',LOT) > 0  THEN substring(LOT,1,charindex('@@',LOT)-1) ELSE LOT END AS Lot 
                  from DealercomplainCRM(nolock) where DC_ComplainNbr=@BillNo
                  ) cpList ON (PO.POH_Remark = cpList.DC_ComplainNbr AND PO.POH_DMA_ID = cpList.DC_CorpId )       	 
            INNER JOIN CFN ON (cpList.UPN = CFN.CFN_CustomerFaceNbr AND PO.POH_ProductLine_BUM_ID = CFN.CFN_ProductLine_BUM_ID)
          	 GROUP BY PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,cpList.Lot,CFN.CFN_CustomerFaceNbr,cpList.DC_CorpId,cpList.DC_ComplainNbr
             ) tab LEFT join MD.V_INF_UPN_REG AS REG ON (tab.CFN_CustomerFaceNbr = REG.CurUPN)
            
         
        	
          --插入临时订单二维码明细表
        	INSERT INTO #tmp_PurchaseOrderDetail_WithQR (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
        			POD_Tax,POD_ReceiptQty,POD_UOM,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,
        	POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
        	POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,POD_QRCode)
          SELECT NEWID(),POH_ID,CFN_ID,0,Qty,0,0,0 ,CFN_Property3,Lot,
        	         DC_ComplainNbr,null,WhmId,null,'','',
                   REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
                   REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog,QRCode
          	FROM (    
            SELECT PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,cpList.Lot,cpList.DC_ComplainNbr,CFN.CFN_CustomerFaceNbr,
                   (SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = cpList.DC_CorpId AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1) AS WhmId,cpList.QRCode,
        		       CAST(ROUND(SUM(ISNULL(cpList.ReturnNum ,0)),2) AS NUMERIC(10)) AS Qty
              FROM #tmp_PurchaseOrderHeader AS PO 
        	  INNER JOIN (
                  SELECT DC_ComplainNbr,DC_CorpId,UPN,ReturnNum,
                  CASE WHEN charindex('@@',LOT) > 0  THEN substring(LOT,1,charindex('@@',LOT)-1) ELSE LOT END AS Lot,
                  CASE WHEN charindex('@@',LOT) > 0 THEN substring(LOT,charindex('@@',LOT)+2,len(LOT)) ELSE '' END AS QRCode
                  from Dealercomplain(nolock) where DC_ComplainNbr=@BillNo
                  union
                  SELECT DC_ComplainNbr,DC_CorpId,Serial,Convert(decimal(18,2),1/ConvertFactor),
                  Lot,
                  QrCode
                  from DealercomplainCRM(nolock) where DC_ComplainNbr=@BillNo
                  ) cpList ON (PO.POH_Remark = cpList.DC_ComplainNbr AND PO.POH_DMA_ID = cpList.DC_CorpId )       	 
            INNER JOIN CFN ON (cpList.UPN = CFN.CFN_CustomerFaceNbr AND PO.POH_ProductLine_BUM_ID = CFN.CFN_ProductLine_BUM_ID)
          	 GROUP BY PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,cpList.Lot,CFN.CFN_CustomerFaceNbr,cpList.DC_CorpId,cpList.DC_ComplainNbr,cpList.QRCode
             ) tab LEFT join MD.V_INF_UPN_REG AS REG ON (tab.CFN_CustomerFaceNbr = REG.CurUPN)
        END
    END
	  
  IF (@OrderType = 'ZT') 
    BEGIN
     
      
      --根据寄售转移单获取：Consignment.TransferHeader
    
          

      --确定OrderType(寄售订单，对应Lafite_DICT表中的CONST_Order_Type)
      SET @NewOrderType = 'ZTKB'       
          
      --获取订单编号(规则是在原有寄售转移单后面加ZTKA、ZTKB)	 
      SET @NewOrderNo = @BillNo + 'ZTKB'
                
          
      --ZTKA订单的自动生成-订单主信息(To-Dealer)
    	INSERT INTO #tmp_PurchaseOrderHeader
             (POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_VendorID,POH_OrderType,POH_CreateType,
            	POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_WHM_ID,POH_SubmitDate,POH_SubmitUser,POH_Remark,
            	POH_ShipToAddress,POH_Consignee,POH_ConsigneePhone,POH_OrderNo,POH_RDD)	
       SELECT NEWID() AS POH_ID,H.TH_ProductLine_BUM_ID,H.TH_DMA_ID_To,@VENDORID,@NewOrderType,'Manual',@SysUserId,getdate(),'Submitted',0,0,
              (SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = H.TH_DMA_ID_To AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1),
               CONVERT(datetime,@AutoSubmitDate),@SysUserId,             
              @BillNo,null,null,null,@NewOrderNo,getdate() AS RDD
        FROM Consignment.TransferHeader H(nolock)
       WHERE H.TH_No=@BillNo
    
      
      --根据仓库，更新收货地址(LP)
    	update t2 set POH_ShipToAddress = SWA_WH_Address
    	from SAPWarehouseAddress t1(nolock), #tmp_PurchaseOrderHeader t2
      where t1.SWA_DMA_ID  = t2.POH_DMA_ID 
      
      --更新承运商
    	UPDATE #tmp_PurchaseOrderHeader SET POH_TerritoryCode = DMA_Certification
    	FROM DealerMaster WHERE DMA_ID = POH_DMA_ID
      
      --根据创建人，更新联系人信息
    	update #tmp_PurchaseOrderHeader 
         set POH_ContactPerson = DST_ContactPerson,POH_Contact=DST_Contact,POH_ContactMobile=DST_ContactMobile,POH_Consignee=DST_Consignee,POH_ConsigneePhone=DST_ConsigneePhone
    	  from DealerShipTo(nolock) where POH_CreateUser = DST_Dealer_User_ID
      
      --插入临时订单明细表
    	INSERT INTO #tmp_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
    			POD_Tax,POD_ReceiptQty,POD_UOM,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,
    	POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
    	POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
        SELECT NEWID(),POH_ID,CFN_ID,0,Qty,0,0,0 ,CFN_Property3,LTM_LotNumber,
    	         TH_No,null,WhmId,null,'','',
               REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
               REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog
      	FROM (    
        SELECT PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LM.LTM_LotNumber,H.TH_No,CFN.CFN_CustomerFaceNbr,
               (SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = H.TH_DMA_ID_To AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1) AS WhmId,
    		   CAST(ROUND(SUM(ISNULL(D.TC_QTY,0)),2) AS NUMERIC(10)) AS Qty
          FROM #tmp_PurchaseOrderHeader AS PO 
    	  INNER JOIN Consignment.TransferHeader AS H(nolock) ON PO.POH_Remark = H.TH_No AND PO.POH_DMA_ID = H.TH_DMA_ID_To AND PO.POH_ProductLine_BUM_ID = H.TH_ProductLine_BUM_ID
    	  INNER JOIN Consignment.TransferDetail AS L(nolock) ON H.TH_ID = L.TD_TH_ID 
    	  INNER JOIN Consignment.TransferConfirm AS D(nolock) ON L.TD_ID = D.TC_TD_ID
    	  INNER JOIN Product(nolock) ON PMA_ID = D.TC_PMA_ID
        INNER JOIN CFN(nolock) ON Product.PMA_CFN_ID = CFN.CFN_ID
        INNER JOIN Lot(nolock) ON LOT_ID = D.TC_LOT_ID
    	  INNER JOIN V_LotMaster AS LM ON LOT_LTM_ID = LTM_ID --AND LTM_Product_PMA_ID = PMA_ID
      	WHERE H.TH_No=@BillNo
      	 GROUP BY PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LM.LTM_LotNumber,H.TH_No,CFN.CFN_CustomerFaceNbr,H.TH_DMA_ID_To
         ) tab LEFT join MD.V_INF_UPN_REG AS REG ON (tab.CFN_CustomerFaceNbr = REG.CurUPN)
    	
      INSERT INTO #tmp_PurchaseOrderDetail_WithQR (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
    			POD_Tax,POD_ReceiptQty,POD_UOM,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,
    	POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
    	POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,POD_QRCode)
        SELECT NEWID(),POH_ID,CFN_ID,0,Qty,0,0,0 ,CFN_Property3,LTM_LotNumber,
    	         TH_No,null,WhmId,null,'','',
               REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
               REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog,LTM_QrCode
      	FROM (    
        SELECT PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LM.LTM_LotNumber,H.TH_No,CFN.CFN_CustomerFaceNbr,LM.LTM_QrCode,
               (SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = H.TH_DMA_ID_To AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1) AS WhmId,
    		   CAST(ROUND(SUM(ISNULL(D.TC_QTY,0)),2) AS NUMERIC(10)) AS Qty
          FROM #tmp_PurchaseOrderHeader AS PO 
    	  INNER JOIN Consignment.TransferHeader AS H(nolock) ON PO.POH_Remark = H.TH_No AND PO.POH_DMA_ID = H.TH_DMA_ID_To AND PO.POH_ProductLine_BUM_ID = H.TH_ProductLine_BUM_ID
    	  INNER JOIN Consignment.TransferDetail AS L(nolock) ON H.TH_ID = L.TD_TH_ID 
    	  INNER JOIN Consignment.TransferConfirm AS D(nolock) ON L.TD_ID = D.TC_TD_ID
    	  INNER JOIN Product(nolock) ON PMA_ID = D.TC_PMA_ID
        INNER JOIN CFN(nolock) ON Product.PMA_CFN_ID = CFN.CFN_ID
        INNER JOIN Lot(nolock) ON LOT_ID = D.TC_LOT_ID
    	  INNER JOIN V_LotMaster AS LM ON LOT_LTM_ID = LTM_ID --AND LTM_Product_PMA_ID = PMA_ID
      	WHERE H.TH_No=@BillNo
      	 GROUP BY PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LM.LTM_LotNumber,H.TH_No,CFN.CFN_CustomerFaceNbr,H.TH_DMA_ID_To,LM.LTM_QrCode
         ) tab LEFT join MD.V_INF_UPN_REG AS REG ON (tab.CFN_CustomerFaceNbr = REG.CurUPN)
    	
    
  
      
      --对移出经销商来说，是ZTKA订单
      SET @NewOrderType = 'ZTKA'       
          
      --获取订单编号(规则是在原有寄售转移单后面加ZTKA、ZTKB)	 
      SET @NewOrderNo = @BillNo + 'ZTKA'
      
                
      
          
      --ZTKB订单的自动生成-订单主信息(From-Dealer)
    	INSERT INTO #tmp_PurchaseOrderHeader
             (POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_VendorID,POH_OrderType,POH_CreateType,
            	POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_WHM_ID,POH_SubmitDate,POH_SubmitUser,POH_Remark,
            	POH_ShipToAddress,POH_Consignee,POH_ConsigneePhone,POH_OrderNo,POH_RDD)	
    	
       SELECT NEWID() AS POH_ID,H.TH_ProductLine_BUM_ID,H.TH_DMA_ID_From,@VENDORID,@NewOrderType,'Manual',@SysUserId,getdate(),'Submitted',0,0,
              (SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = H.TH_DMA_ID_From AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1),
               CONVERT(datetime,@AutoSubmitDate),@SysUserId,             
              @BillNo,null,null,null,@NewOrderNo,getdate() AS RDD
        FROM Consignment.TransferHeader H(nolock)
       WHERE H.TH_No=@BillNo
      
      --根据仓库，更新收货地址
    	update t2 set POH_ShipToAddress = SWA_WH_Address
    	from SAPWarehouseAddress t1(nolock), #tmp_PurchaseOrderHeader t2
      where t1.SWA_DMA_ID  = t2.POH_DMA_ID 
      
      --更新承运商
    	UPDATE #tmp_PurchaseOrderHeader SET POH_TerritoryCode = DMA_Certification
    	FROM DealerMaster(nolock) WHERE DMA_ID = POH_DMA_ID
      
      --根据创建人，更新联系人信息
    	update #tmp_PurchaseOrderHeader 
         set POH_ContactPerson = DST_ContactPerson,POH_Contact=DST_Contact,POH_ContactMobile=DST_ContactMobile,POH_Consignee=DST_Consignee,POH_ConsigneePhone=DST_ConsigneePhone
    	  from DealerShipTo(nolock) where POH_CreateUser = DST_Dealer_User_ID
      
      --插入临时订单明细表
    	INSERT INTO #tmp_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
    			POD_Tax,POD_ReceiptQty,POD_UOM,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,
    	POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
    	POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
        SELECT NEWID(),POH_ID,CFN_ID,0,Qty,0,0,0 ,CFN_Property3,LTM_LotNumber,
    	         TH_No,null,WhmId,null,'','',
               REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
               REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog
      	FROM (    
        SELECT PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LM.LTM_LotNumber,H.TH_No,CFN.CFN_CustomerFaceNbr,
               (SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = H.TH_DMA_ID_From AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1) AS WhmId,
    		   CAST(ROUND(SUM(ISNULL(D.TC_QTY,0)),2) AS NUMERIC(10)) AS Qty
          FROM #tmp_PurchaseOrderHeader AS PO 
    	  INNER JOIN Consignment.TransferHeader AS H(nolock) ON PO.POH_Remark = H.TH_No AND PO.POH_DMA_ID = H.TH_DMA_ID_From AND PO.POH_ProductLine_BUM_ID = H.TH_ProductLine_BUM_ID
    	  INNER JOIN Consignment.TransferDetail AS L(nolock) ON H.TH_ID = L.TD_TH_ID 
    	  INNER JOIN Consignment.TransferConfirm AS D(nolock) ON L.TD_ID = D.TC_TD_ID
    	  INNER JOIN Product(nolock) ON PMA_ID = D.TC_PMA_ID
        INNER JOIN CFN(nolock) ON Product.PMA_CFN_ID = CFN.CFN_ID
        INNER JOIN Lot(nolock) ON LOT_ID = D.TC_LOT_ID
    	  INNER JOIN V_LotMaster AS LM ON LOT_LTM_ID = LM.LTM_ID --AND LM.LTM_Product_PMA_ID = PMA_ID
      	WHERE H.TH_No=@BillNo
      	 GROUP BY PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LM.LTM_LotNumber,H.TH_No,CFN.CFN_CustomerFaceNbr,H.TH_DMA_ID_From
         ) tab LEFT join MD.V_INF_UPN_REG AS REG ON (tab.CFN_CustomerFaceNbr = REG.CurUPN)
      
      
      
    	--插入临时订单二维码明细表
    	INSERT INTO #tmp_PurchaseOrderDetail_WithQR (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
    			POD_Tax,POD_ReceiptQty,POD_UOM,POD_LotNumber,POD_ShipmentNbr,POD_HOS_ID,POD_WH_ID,POD_Field1,POD_Field2,POD_Field3,
    	    POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
    	    POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog,POD_QRCode)
        SELECT NEWID(),POH_ID,CFN_ID,0,Qty,0,0,0 ,CFN_Property3,LTM_LotNumber,
    	         TH_No,null,WhmId,null,'','',
               REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
               REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog,LTM_QrCode
      	FROM (    
        SELECT PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LM.LTM_LotNumber,H.TH_No,CFN.CFN_CustomerFaceNbr,LM.LTM_QrCode,
               (SELECT TOP 1 WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = H.TH_DMA_ID_From AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1) AS WhmId,
    		       CAST(ROUND(SUM(ISNULL(D.TC_QTY,0)),2) AS NUMERIC(10)) AS Qty
          FROM #tmp_PurchaseOrderHeader AS PO 
    	  INNER JOIN Consignment.TransferHeader AS H(nolock) ON PO.POH_Remark = H.TH_No AND PO.POH_DMA_ID = H.TH_DMA_ID_From AND PO.POH_ProductLine_BUM_ID = H.TH_ProductLine_BUM_ID
    	  INNER JOIN Consignment.TransferDetail AS L(nolock) ON H.TH_ID = L.TD_TH_ID 
    	  INNER JOIN Consignment.TransferConfirm AS D(nolock) ON L.TD_ID = D.TC_TD_ID
    	  INNER JOIN Product(nolock) ON PMA_ID = D.TC_PMA_ID
        INNER JOIN CFN(nolock) ON Product.PMA_CFN_ID = CFN.CFN_ID
        INNER JOIN Lot(nolock) ON LOT_ID = D.TC_LOT_ID
    	  INNER JOIN V_LotMaster AS LM ON LOT_LTM_ID = LM.LTM_ID --AND LM.LTM_Product_PMA_ID = PMA_ID
      	WHERE H.TH_No=@BillNo
      	 GROUP BY PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LM.LTM_LotNumber,H.TH_No,CFN.CFN_CustomerFaceNbr,H.TH_DMA_ID_From,LM.LTM_QrCode
         ) tab LEFT join MD.V_INF_UPN_REG AS REG ON (tab.CFN_CustomerFaceNbr = REG.CurUPN)
      
          
      SELECT * FROM #tmp_PurchaseOrderHeader    
      SELECT * FROM #tmp_PurchaseOrderDetail
      SELECT * FROM #tmp_PurchaseOrderDetail_WithQR
    END
    
--  IF (@OrderType = 'KB') 
--    BEGIN
--      --判断是否为强制寄售买断的单据（查看PurchaseOrderDetail_WithQR表的POD_ShipmentNbr字段）
--      --如果对应的单据号是强制寄售买断，则删除记录，如果最后WithQR表没有记录，则直接删除Detail表和Header表的记录
--      DELETE FROM #tmp_PurchaseOrderDetail_WithQR where exists (select 1 from inventoryAdjustHeader IAH where IAH.IAH_Inv_Adj_Nbr=POD_ShipmentNbr and IAH.IAH_Reason='ForceCTOS' )
--      
--      IF (select count(*) from #tmp_PurchaseOrderDetail_WithQR) = 0
--        BEGIN
--          DELETE FROM #tmp_PurchaseOrderDetail
--          DELETE FROM #tmp_PurchaseOrderHeader          
--        END
--    
--    END

  --删除数量是0的记录
  DELETE FROM #tmp_PurchaseOrderDetail WHERE POD_RequiredQty = 0
  DELETE FROM #tmp_PurchaseOrderDetail_WithQR WHERE POD_RequiredQty = 0	
  DELETE FROM #tmp_PurchaseOrderHeader WHERE POH_ID NOT IN (SELECT POD_POH_ID FROM #tmp_PurchaseOrderDetail )
 
  --写入正式订单表
  BEGIN  
  INSERT INTO PurchaseOrderHeader (POH_ID,
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
								   POH_POH_ID,
                   POH_SendWMSFlg,
                   POH_DcType)
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
	   POH_POH_ID,
     0,
     'Deliver'
	FROM #tmp_PurchaseOrderHeader
  
  INSERT INTO PurchaseOrderDetail (
     POD_ID
    ,POD_POH_ID
    ,POD_CFN_ID
    ,POD_CFN_Price
    ,POD_UOM
    ,POD_RequiredQty
    ,POD_Amount
    ,POD_Tax
    ,POD_ReceiptQty
    ,POD_Status
    ,POD_LotNumber
    ,POD_ShipmentNbr
    ,POD_HOS_ID
    ,POD_WH_ID
    ,POD_Field1
    ,POD_Field2
    ,POD_Field3
    ,POD_CurRegNo
    ,POD_CurValidDateFrom
    ,POD_CurValidDataTo
    ,POD_CurManuName
    ,POD_LastRegNo
    ,POD_LastValidDateFrom
    ,POD_LastValidDataTo
    ,POD_LastManuName
    ,POD_CurGMKind
    ,POD_CurGMCatalog    
  ) SELECT 
     POD_ID
    ,POD_POH_ID
    ,POD_CFN_ID
    ,POD_CFN_Price
    ,POD_UOM
    ,POD_RequiredQty
    ,POD_Amount
    ,POD_Tax
    ,POD_ReceiptQty
    ,POD_Status
    ,POD_LotNumber
    ,POD_ShipmentNbr
    ,POD_HOS_ID
    ,POD_WH_ID
    ,POD_Field1
    ,POD_Field2
    ,POD_Field3
    ,POD_CurRegNo
    ,POD_CurValidDateFrom
    ,POD_CurValidDataTo
    ,POD_CurManuName
    ,POD_LastRegNo
    ,POD_LastValidDateFrom
    ,POD_LastValidDataTo
    ,POD_LastManuName
    ,POD_CurGMKind
    ,POD_CurGMCatalog
  FROM #tmp_PurchaseOrderDetail
  
  
  INSERT INTO PurchaseOrderDetail_WithQR (
     POD_ID
    ,POD_POH_ID
    ,POD_CFN_ID
    ,POD_CFN_Price
    ,POD_UOM
    ,POD_RequiredQty
    ,POD_Amount
    ,POD_Tax
    ,POD_ReceiptQty
    ,POD_Status
    ,POD_LotNumber
    ,POD_ShipmentNbr
    ,POD_HOS_ID
    ,POD_WH_ID
    ,POD_Field1
    ,POD_Field2
    ,POD_Field3
    ,POD_CurRegNo
    ,POD_CurValidDateFrom
    ,POD_CurValidDataTo
    ,POD_CurManuName
    ,POD_LastRegNo
    ,POD_LastValidDateFrom
    ,POD_LastValidDataTo
    ,POD_LastManuName
    ,POD_CurGMKind
    ,POD_CurGMCatalog
    ,POD_QRCode
    ,POD_ConsignmentDay
    ,POD_ConsignmentContractID
  ) SELECT 
     POD_ID
    ,POD_POH_ID
    ,POD_CFN_ID
    ,POD_CFN_Price
    ,POD_UOM
    ,POD_RequiredQty
    ,POD_Amount
    ,POD_Tax
    ,POD_ReceiptQty
    ,POD_Status
    ,POD_LotNumber
    ,POD_ShipmentNbr
    ,POD_HOS_ID
    ,POD_WH_ID
    ,POD_Field1
    ,POD_Field2
    ,POD_Field3
    ,POD_CurRegNo
    ,POD_CurValidDateFrom
    ,POD_CurValidDataTo
    ,POD_CurManuName
    ,POD_LastRegNo
    ,POD_LastValidDateFrom
    ,POD_LastValidDataTo
    ,POD_LastManuName
    ,POD_CurGMKind
    ,POD_CurGMCatalog
    ,POD_QRCode
    ,POD_ConsignmentDay
    ,POD_ConsignmentContractID
  FROM #tmp_PurchaseOrderDetail_WithQR
  
  INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),POH_ID,POH_CreateUser,GETDATE(),'Generate','自动生成'+@OrderType+'订单' FROM #tmp_PurchaseOrderHeader
  
  END
  
  --写入接口表（KB订单使用EAI接口，KA、ZT订单使用Process Runner）
  IF @OrderType IN ('KB','ZT')
    BEGIN
      --插入接口表
    	IF @OrderType IN ('KB')
        INSERT INTO PurchaseOrderInterface
      	SELECT NEWID(),'','',POH_ID,POH_OrderNo,'Pending','Manual',NULL,POH_CreateUser,GETDATE(),POH_CreateUser,GETDATE(),CLT_ID
      	FROM #tmp_PurchaseOrderHeader left join Client ON POH_VendorID = CLT_Corp_Id      
      
      IF @OrderType IN ('KB','ZT')
        INSERT INTO PurchaseOrderInterface
      	SELECT NEWID(),'','',POH_ID,POH_OrderNo,'Pending','Manual',NULL,POH_CreateUser,GETDATE(),POH_CreateUser,GETDATE(),CLT_ID
      	FROM #tmp_PurchaseOrderHeader left join Client ON POH_DMA_ID = CLT_Corp_Id 
        WHERE POH_ORDERType in ('ZTKB','Consignment')
      
    END

  IF @OrderType IN ('KA','ZT')
    BEGIN
      --遍历获取订单，然后调用ProcessRunner接口
      	DECLARE @m_pohId uniqueidentifier
      	DECLARE @m_RtnVal nvarchar(20);
        DECLARE @m_RtnMsg nvarchar(4000);
        
      	DECLARE	curOrder CURSOR 
      	FOR SELECT POH_ID FROM #tmp_PurchaseOrderHeader

      	OPEN curOrder
      	FETCH NEXT FROM curOrder INTO @m_pohId

      	WHILE @@FETCH_STATUS = 0
      	BEGIN
      		EXEC dbo.[GC_Interface_ProcessRunner_PurchaseOrder] @m_pohId,@m_RtnVal out,@m_RtnMsg out;      		
      		FETCH NEXT FROM curOrder INTO @m_pohId
      	END

      	CLOSE curOrder
      	DEALLOCATE curOrder
      
      
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

