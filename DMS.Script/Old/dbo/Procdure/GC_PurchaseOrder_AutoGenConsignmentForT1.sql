DROP PROCEDURE [dbo].[GC_PurchaseOrder_AutoGenConsignmentForT1]	
GO

/*
* 短期寄售申请单生成寄售订单
*/
CREATE PROCEDURE [dbo].[GC_PurchaseOrder_AutoGenConsignmentForT1]	
	@CmId uniqueidentifier,
	@RtnVal nvarchar(20) OUTPUT,
	@RtnMsg  nvarchar(2000)  OUTPUT
AS
SET NOCOUNT ON
BEGIN TRY

BEGIN TRAN
	DECLARE @SysUserId uniqueidentifier
	DECLARE @VENDORID uniqueidentifier
	DECLARE @OrderType nvarchar(50)
	DECLARE @DayInterval int
	DECLARE @AutoSubmitDate nvarchar(20)
	DECLARE @OrderNo nvarchar(100)
	DECLARE @ConsignmentDay nvarchar(100)
	DECLARE @ConsignmentFrom nvarchar(100)

	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	SET @VENDORID = 'fb62d945-c9d7-4b0f-8d26-4672d2c728b7'  --BSC(HQ)
	SET @OrderType = 'Consignment'  --清指定批号
	SET @DayInterval = 0
	
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

	CREATE TABLE #tmp_PurchaseOrderDetail (
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

	--获取单据将提交的日期
	SELECT @AutoSubmitDate = GETDATE()

	SELECT @OrderNo = CAH_OrderNo,@ConsignmentDay = CAH_CM_ConsignmentDay,@ConsignmentFrom = CAH_ConsignmentFrom FROM ConsignmentApplyHeader WHERE CAH_ID = @CmId
	
	IF @ConsignmentFrom = 'Bsc'
		BEGIN
			SET @OrderType = 'Consignment'  --寄售订单
		END
	ELSE IF @ConsignmentFrom = ''
		BEGIN
			SET @OrderType = 'ZTKB'  --短期寄售转移订单
		END
	ELSE
		BEGIN
			SET @OrderType = 'Consignment'  --寄售订单
		END

	--寄售申请单单号去掉首字母'R',结尾处添加寄售天数和'L'
	SELECT @OrderNo = SUBSTRING(@OrderNo,CHARINDEX('R',@OrderNo)+1,LEN(@OrderNo)-CHARINDEX('R',@OrderNo))+ISNULL(@ConsignmentDay,'0')+'L'
	
	--将订单号更新到寄售申请单中
	UPDATE ConsignmentApplyHeader SET CAH_POH_OrderNo = @OrderNo WHERE CAH_ID = @CmId
	
	--寄售订单的自动生成-订单主信息
	INSERT INTO #tmp_PurchaseOrderHeader(POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_VendorID,POH_OrderType,POH_CreateType,
	POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_WHM_ID,POH_SubmitDate,POH_SubmitUser,POH_Remark,
	POH_ShipToAddress,POH_Consignee,POH_ConsigneePhone,POH_OrderNo
	--,POH_ContactPerson,POH_Contact,POH_ContactMobile
	,POH_RDD)	
	SELECT NEWID() AS POH_ID,CAH_ProductLine_Id,CAH_DMA_ID,  
         CASE WHEN CAH_ConsignmentFrom = 'Otherdealers' THEN CAH_ConsignmentId ELSE @VENDORID END, --寄售销商的ID
         --ISNULL(CAH_ConsignmentId,@VENDORID), --寄售销商的ID
		 @OrderType,'Manual',@SysUserId,
		     GETDATE(),'Submitted',0,0,
         (SELECT TOP 1 WHM_ID FROM Warehouse WHERE WHM_DMA_ID = CAH_DMA_ID AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1),
         CONVERT(datetime,@AutoSubmitDate),@SysUserId,
         CAH_OrderNo,CAH_ShipToAddress,CAH_Consignee,CAH_ConsigneePhone,@OrderNo
         --,CAH_SalesName,CAH_SalesEmail,CAH_SalesPhone
         ,CAH_RDD
		FROM ConsignmentApplyHeader 
	WHERE CAH_ID = @CmId
	
	--收货地址、联系人、联系方式从寄售申请单主表中获取
	--根据仓库，更新收货地址
	--UPDATE t2 SET POH_ShipToAddress = SWA_WH_Address
	--FROM SAPWarehouseAddress t1, #tmp_PurchaseOrderHeader t2
	--WHERE t1.SWA_DMA_ID  = t2.POH_DMA_ID 
  
	--根据创建人，更新联系人信息
	--UPDATE #tmp_PurchaseOrderHeader SET POH_ContactPerson = DST_ContactPerson,POH_Contact=DST_Contact,POH_ContactMobile=DST_ContactMobile,POH_Consignee=DST_Consignee,POH_ConsigneePhone=DST_ConsigneePhone
	--FROM DealerShipTo WHERE POH_CreateUser = DST_Dealer_User_ID
	--更新承运商

	UPDATE #tmp_PurchaseOrderHeader SET POH_TerritoryCode = DMA_Certification
	FROM DealerMaster WHERE DMA_ID = POH_DMA_ID
  
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
           CAH.CAH_Hospital_Id,(SELECT TOP 1 WHM_ID FROM Warehouse WHERE WHM_DMA_ID = CAH.CAH_DMA_ID AND WHM_Type='Borrow' AND WHM_ActiveFlag = 1) AS WhmId,
		   CAST(ROUND(SUM(ISNULL(CAD_Qty,0)),2) AS NUMERIC(10)) AS Qty
      FROM #tmp_PurchaseOrderHeader AS PO 
	  INNER JOIN ConsignmentApplyHeader AS CAH ON PO.POH_Remark = CAH.CAH_OrderNo AND PO.POH_DMA_ID = CAH.CAH_DMA_ID AND PO.POH_ProductLine_BUM_ID = CAH.CAH_ProductLine_Id
	  INNER JOIN ConsignmentApplyDetails AS CAD ON CAH.CAH_ID = CAD.CAD_CAH_ID AND CAH.CAH_CAH_ID IS NULL
	  INNER JOIN CFN ON CAD.CAD_CFN_ID = CFN_ID 
	  INNER JOIN Product ON PMA_CFN_ID = CFN_ID
	  LEFT JOIN LotMaster ON LTM_LotNumber = CAD_LotNumber AND LTM_Product_PMA_ID = PMA_ID
  	  WHERE CAH_ID = @CmId
  	 GROUP BY PO.POH_ID,CFN.CFN_ID,CFN.CFN_Property3,LotMaster.LTM_LotNumber,CAH.CAH_OrderNo,CFN.CFN_CustomerFaceNbr,CAH.CAH_Hospital_Id,CAH.CAH_DMA_ID
     ) tab LEFT join MD.V_INF_UPN_REG AS REG ON (tab.CFN_CustomerFaceNbr = REG.CurUPN)
	
	--删除数量是0的记录
	DELETE FROM #tmp_PurchaseOrderDetail WHERE POD_RequiredQty = 0	  
	DELETE FROM #tmp_PurchaseOrderHeader WHERE POH_ID NOT IN (SELECT POD_POH_ID FROM #tmp_PurchaseOrderDetail )
	  
	--更新金额
	UPDATE t2
	SET POD_CFN_Price = CFNP_Price,
		POD_Amount = POD_RequiredQty*CFNP_Price
	FROM #tmp_PurchaseOrderHeader t1,#tmp_PurchaseOrderDetail t2,CFNPrice t3
	WHERE t1.POH_ID = t2.POD_POH_ID
	AND t1.POH_DMA_ID = t3.CFNP_Group_ID
	AND t2.POD_CFN_ID = t3.CFNP_CFN_ID
	AND t3.CFNP_PriceType = 'DealerConsignment'
	  
    --更新产品有效期
    UPDATE t1 SET t1.POD_Field1 = Convert(nvarchar(50),t3.LTM_ExpiredDate,21)
    FROM #tmp_PurchaseOrderDetail t1,Product t2,LotMaster t3
    WHERE t1.POD_CFN_ID = t2.PMA_CFN_ID 
		AND t2.PMA_ID=t3.LTM_Product_PMA_ID 
		AND t1.POD_LotNumber = t3.LTM_LotNumber    

	--插入订单主表和明细表
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
								   POH_POH_ID )
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
	   POH_POH_ID 
	FROM #tmp_PurchaseOrderHeader
	
	INSERT INTO PurchaseOrderDetail(POD_ID, POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_RequiredQty, POD_Amount, POD_Tax, POD_ReceiptQty, POD_Status, POD_LotNumber, POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3, POD_CurRegNo, POD_CurValidDateFrom, POD_CurValidDataTo, POD_CurManuName, POD_LastRegNo, POD_LastValidDateFrom, POD_LastValidDataTo, POD_LastManuName, POD_CurGMKind, POD_CurGMCatalog, POD_QRCode)
	SELECT POD_ID, POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_RequiredQty, POD_Amount, POD_Tax, POD_ReceiptQty, POD_Status, 
	CASE WHEN POD_LotNumber IS NOT NULL AND CHARINDEX('@@',POD_LotNumber) > 0 THEN SUBSTRING(POD_LotNumber,1,CHARINDEX('@@',POD_LotNumber)-1) ELSE POD_LotNumber END AS POD_LotNumber,
	POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3, POD_CurRegNo, POD_CurValidDateFrom, POD_CurValidDataTo, POD_CurManuName, POD_LastRegNo, POD_LastValidDateFrom, POD_LastValidDataTo, POD_LastManuName, POD_CurGMKind, POD_CurGMCatalog,
	CASE WHEN POD_LotNumber IS NULL THEN NULL ELSE 
	CASE WHEN CHARINDEX('@@',POD_LotNumber) > 0 THEN SUBSTRING(POD_LotNumber,CHARINDEX('@@',POD_LotNumber)+2,LEN(POD_LotNumber)-CHARINDEX('@@',POD_LotNumber)) ELSE 'NoQR' END 
	END AS POD_QrCode
	FROM #tmp_PurchaseOrderDetail

	--插入订单操作日志
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),POH_ID,POH_CreateUser,GETDATE(),'Generate',NULL FROM #tmp_PurchaseOrderHeader
    
    --插入备份表
	INSERT INTO PurchaseOrderHeader_AutoGenLog 
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
	   POH_WHM_ID,
	   POH_POH_ID,
	   NULL FROM #tmp_PurchaseOrderHeader

	INSERT INTO PurchaseOrderDetail_AutoGenLog 
	SELECT POD_ID, POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_RequiredQty, POD_Amount, POD_Tax, POD_ReceiptQty, POD_Status, POD_LotNumber, POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3 
	FROM #tmp_PurchaseOrderDetail
    
	--插入接口表
	INSERT INTO PurchaseOrderInterface
	SELECT NEWID(),'','',POH_ID,POH_OrderNo,'Pending','Manual',NULL,POH_CreateUser,GETDATE(),POH_CreateUser,GETDATE(), 'EAI'
	FROM #tmp_PurchaseOrderHeader 

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


