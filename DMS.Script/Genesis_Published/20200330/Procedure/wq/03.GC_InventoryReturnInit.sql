
/****** Object:  StoredProcedure [dbo].[GC_InventoryReturnInit]    Script Date: 2020/3/26 17:06:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
订单导入
*/
ALTER Procedure [dbo].[GC_InventoryReturnInit]
    @UserId uniqueidentifier,
	@SubCompanyId UNIQUEIDENTIFIER,
    @BrandId uniqueidentifier,
    @ImportType NVARCHAR(20),   
    @IsValid NVARCHAR(20) = 'Success' OUTPUT
AS
		
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

Declare @DealerID uniqueidentifier
Declare @DealerType nvarchar(5)

--创建临时表
create table #mmbo_InventoryAdjustHeader (
   IAH_ID					uniqueidentifier     not null,
   IAH_Reason				nvarchar(50)         collate Chinese_PRC_CI_AS null,
   IAH_Inv_Adj_Nbr			nvarchar(30)		collate Chinese_PRC_CI_AS null,
   IAH_DMA_ID				uniqueidentifier   NOT  null,
   IAH_ApprovalDate         datetime             null,
   IAH_CreatedDate          datetime            NOT null,
   IAH_Approval_USR_UserID  uniqueidentifier     null,
   IAH_AuditorNotes			nvarchar(2000)         collate Chinese_PRC_CI_AS      null,
   IAH_UserDescription      nvarchar(2000)         collate Chinese_PRC_CI_AS     null,
   IAH_Status				nvarchar(50)         collate Chinese_PRC_CI_AS null,
   IAH_CreatedBy_USR_UserID uniqueidentifier     null,
   IAH_Reverse_IAH_ID		uniqueidentifier     null,
   IAH_ProductLine_BUM_ID   uniqueidentifier             null,
   IAH_WarehouseType		nvarchar(50)         collate Chinese_PRC_CI_AS not null,
   PRIMARY KEY(IAH_ID)
)

create table #mmbo_InventoryAdjustDetail (
   IAD_Quantity         float     not null,
   IAD_ID				uniqueidentifier     not null,
   IAD_PMA_ID			uniqueidentifier     not null,
   IAD_IAH_ID			uniqueidentifier        null,
   IAD_LineNbr          int        null
   PRIMARY KEY(IAD_ID)
)

CREATE TABLE #mmbo_InventoryAdjustLot (
	IAL_IAD_ID uniqueidentifier NOT NULL,
	IAL_ID uniqueidentifier NOT NULL,
	IAL_LotQty float NOT NULL,
	IAL_LOT_ID uniqueidentifier NULL,
	IAL_WHM_ID uniqueidentifier NULL,
	IAL_LotNumber nvarchar(50) NULL,
	IAL_ExpiredDate datetime NULL,
	IAL_PRH_ID uniqueidentifier NULL,
	IAL_UnitPrice decimal(18, 6) NULL,
	IAL_DMA_ID uniqueidentifier NULL,
	IAL_QRLOT_ID uniqueidentifier NULL,
	IAL_QRLotNumber nvarchar(50) NULL,
	IAL_Remark nvarchar(500) NULL,
	[IAL_QRCode] [nvarchar](50) NULL,
	[IAL_Lot]	[nvarchar](50) NULL,
	[IAL_DOM]	[nvarchar](50) NULL,
	[IAL_ERPNbr]	[nvarchar](50) NULL,
	[IAL_ERPLineNbr]	[nvarchar](50) NULL,
	PRIMARY KEY(IAL_ID)
)

CREATE TABLE #TEMP
(
	RHeadId uniqueidentifier,
	RDetailId uniqueidentifier,
	RLotId uniqueidentifier,
	ProductLineId uniqueidentifier,
	DealerId uniqueidentifier,
	WhmId uniqueidentifier,
	WhmType nvarchar(50) collate Chinese_PRC_CI_AS,
	ReturnType nvarchar(50) collate Chinese_PRC_CI_AS,
	CfnId uniqueidentifier,
	PmaId uniqueidentifier,
	InvId uniqueidentifier,
	LtmId uniqueidentifier,
	LotId uniqueidentifier,
	LotNumber nvarchar(50) COLLATE Chinese_PRC_CI_AS null,
	ExpiredDate datetime,
	POReceiptId uniqueidentifier,
	POReceiptPurchaseOrderNo nvarchar(100) collate Chinese_PRC_CI_AS,
	Qty decimal(18,6),
	UnitPrice decimal(18,2),
	QRCode nvarchar(50) NULL,
	Lot	nvarchar(50) NULL,
	DOM	nvarchar(50) NULL,
	ERPNbr	[nvarchar](50) NULL,
	ERPLineNbr	[nvarchar](50) NULL
)


/*先将错误标志设为0*/
UPDATE InventoryReturnInit SET IRI_ErrorFlag = 0,IRI_ReturnQty_ErrMsg= null WHERE IRI_USER = @UserId

--检查经销商是否存在
UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1,IRI_ErrorDescription = N'经销商不存在,'
WHERE IRI_USER = @UserId
AND IRI_DMA_ID IS NULL

--获取经销商
SELECT TOP 1 @DealerID = IRI_DMA_ID FROM InventoryReturnInit WHERE IRI_USER = @UserId
SELECT @DealerType = DMA_DealerType FROM DealerMaster WHERE DMA_ID = @DealerID

--检查仓库是否存在
UPDATE InventoryReturnInit SET IRI_WHM_ID = WHM_ID
FROM Warehouse WHERE WHM_Name = IRI_Warehouse
AND WHM_DMA_ID = @DealerID
AND IRI_USER = @UserId

UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1,IRI_Warehouse_ErrMsg = N'仓库不存在,'
WHERE IRI_WHM_ID IS NULL AND IRI_USER = @UserId AND IRI_Warehouse_ErrMsg IS NULL

--检查产品是否存在
UPDATE InventoryReturnInit SET IRI_CFN_ID = CFN_ID
FROM CFN WHERE CFN_CustomerFaceNbr = IRI_ArticleNumber
AND IRI_USER = @UserId

UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1,IRI_ArticleNumber_ErrMsg = N'产品不存在,'
WHERE IRI_CFN_ID IS NULL AND IRI_USER = @UserId AND IRI_ArticleNumber_ErrMsg IS NULL

--检查产品是否已分类（是否对应产品线）
UPDATE IRI SET IRI_BUM_ID = CFN_ProductLine_BUM_ID--(CASE WHEN CFNS_BUM_ID IS NULL THEN CFN_ProductLine_BUM_ID ELSE CFNS_BUM_ID END)
FROM InventoryReturnInit IRI INNER JOIN CFN ON CFN_ID = IRI_CFN_ID 
--left join CFNSHARE on CFN_ID = CFNS_CFN_ID AND CFNS_PROPERTY1 = 1
WHERE IRI_CFN_ID IS NOT NULL
AND IRI_USER = @UserId
AND Exists (select 1 from View_ProductLine where ATTRIBUTE_TYPE='Product_Line' ---分子公司品牌验证
AND ISNULL(SubCompanyId,'')=ISNULL(@SubCompanyId,'') AND ISNULL(BrandId,'')=ISNULL(@BrandId,'')
AND Id = CFN.CFN_ProductLine_BUM_ID)

UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1,IRI_ArticleNumber_ErrMsg =  N'产品未分类(无对应产品线),'
WHERE IRI_BUM_ID IS NULL AND IRI_USER = @UserId AND IRI_ArticleNumber_ErrMsg IS NULL

CREATE TABLE #AuthTemp
(
	DealerId UNIQUEIDENTIFIER,
	BumId UNIQUEIDENTIFIER,
	AuthCount INT
)

INSERT INTO #AuthTemp
SELECT DAT_DMA_ID,DAT_ProductLine_BUM_ID,COUNT(1) FROM DealerAuthorizationTable 
WHERE EXISTS(
	SELECT IRI_DMA_ID,IRI_BUM_ID FROM InventoryReturnInit
	WHERE IRI_USER = @UserId
	AND IRI_DMA_ID IS NOT NULL
	AND IRI_CFN_ID IS NOT NULL 
	AND IRI_BUM_ID IS NOT NULL
	AND DAT_DMA_ID = IRI_DMA_ID
	AND DAT_ProductLine_BUM_ID = IRI_BUM_ID
)
AND DAT_Type = 'Return'
GROUP BY DAT_DMA_ID,DAT_ProductLine_BUM_ID

UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1,IRI_ArticleNumber_ErrMsg =  N'授权未通过,' 
FROM CFN
            WHERE IRI_USER = @UserId
			AND IRI_CFN_ID = CFN_ID
			AND IRI_DMA_ID IS NOT NULL
			AND IRI_CFN_ID IS NOT NULL 
			AND IRI_BUM_ID IS NOT NULL
			AND IRI_ArticleNumber_ErrMsg IS NULL
            AND NOT EXISTS(
				SELECT 1 FROM DealerAuthorizationTable
				INNER JOIN Cache_PartsClassificationRec ON PCT_ProductLine_BUM_ID = DAT_ProductLine_BUM_ID
				INNER JOIN CfnClassification CCF ON PCT_ID = CCF.ClassificationId
				WHERE DAT_PMA_ID != DAT_ProductLine_BUM_ID
				AND DAT_DMA_ID = IRI_DMA_ID
				AND DAT_ProductLine_BUM_ID = IRI_BUM_ID
				AND PCT_ParentClassification_PCT_ID = DAT_PMA_ID
				AND CCF.CfnCustomerFaceNbr=CFN_CustomerFaceNbr
				AND CFN_DeletedFlag = 0
				AND ((DAT_Type = 'Return' AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,GETDATE())))
						OR (ISNULL((SELECT AuthCount FROM #AuthTemp WHERE BumId = DAT_DMA_ID AND DealerId = DAT_DMA_ID),0) = 0 
						AND (DAT_Type IN ('Normal','Temp') AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DATEADD(DAY,-1,CONVERT(DATETIME,CONVERT(CHAR(8),DATEADD(MONTH,(DATEPART(QUARTER,DAT_EndDate)+2)*3-MONTH(DAT_EndDate)-2,DAT_EndDate),120)+'01')),DATEADD(DAY,-1,GETDATE())))
					)
				)
				UNION
				SELECT 1 FROM DealerAuthorizationTable
				INNER JOIN Cache_PartsClassificationRec ON PCT_ProductLine_BUM_ID = DAT_ProductLine_BUM_ID
				INNER JOIN CfnClassification CCF ON PCT_ID = CCF.ClassificationId
				WHERE DAT_PMA_ID = DAT_ProductLine_BUM_ID
				AND DAT_DMA_ID = IRI_DMA_ID
				AND DAT_ProductLine_BUM_ID = IRI_BUM_ID
				AND DAT_PMA_ID = PCT_ProductLine_BUM_ID
				AND CCF.CfnCustomerFaceNbr=CFN_CustomerFaceNbr
				AND CFN_DeletedFlag = 0
				AND ((DAT_Type = 'Return' AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,GETDATE())))
						OR (ISNULL((SELECT AuthCount FROM #AuthTemp WHERE BumId = DAT_DMA_ID AND DealerId = DAT_DMA_ID),0) = 0 
						AND (DAT_Type IN ('Normal','Temp') AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DATEADD(DAY,-1,CONVERT(DATETIME,CONVERT(CHAR(8),DATEADD(MONTH,(DATEPART(QUARTER,DAT_EndDate)+2)*3-MONTH(DAT_EndDate)-2,DAT_EndDate),120)+'01')),DATEADD(DAY,-1,GETDATE())))
					)
				)
            )


--检查产品批号是否正群
UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1, IRI_LotNumber_ErrMsg = N'产品批号不存在或批次号的二维码填写错误,',IRI_QrCode_ErrMsg=N'产品批号不存在或批次号的二维码填写错误,'
WHERE (IRI_LotNumber IS NOT NULL OR IRI_LotNumber<>'')
  AND IRI_USER = @UserId 
  AND IRI_LotNumber_ErrMsg IS NULL
  AND IRI_ArticleNumber_ErrMsg IS NULL
  AND ISNULL(IRI_QrCode,'NoQR')<>'NoQR'
  AND NOT EXISTS
  (SELECT 1
     FROM CFN t1, Product t2, LotMaster t3
    WHERE  t1.CFN_ID = t2.PMA_CFN_ID
       AND t2.PMA_ID = t3.LTM_Product_PMA_ID
       AND  t3.LTM_LotNumber= InventoryReturnInit.IRI_LotNumber+'@@'+InventoryReturnInit.IRI_QrCode AND t1.CFN_CustomerFaceNbr = InventoryReturnInit.IRI_ArticleNumber
   )
   
   
--Edit By SongWeiming on 2017-02-26 不再校验订单号，改为校验是否有价格，价格为0的不能导入系统
--如果没有填写订单号，自动获取最近的一张订单号
--UPDATE IRI
--SET IRI.IRI_PurchaseOrderNbr = (SELECT TOP 1 PRH_PurchaseOrderNbr FROM POReceiptHeader t1,POReceipt t2,POReceiptLot t3,Product t4
--WHERE t1.PRH_ID = t2.POR_PRH_ID
--AND t2.POR_ID = t3.PRL_POR_ID
--AND t2.POR_SAP_PMA_ID = t4.PMA_ID
--AND t3.PRL_LotNumber = IRI.IRI_LotNumber
--AND t4.PMA_CFN_ID = IRI.IRI_CFN_ID
--AND t1.PRH_Dealer_DMA_ID = @DealerID
--ORDER BY t1.PRH_ReceiptDate DESC
--) 
--FROM InventoryReturnInit IRI
--WHERE IRI_CFN_ID IS NOT NULL
--AND IRI_PurchaseOrderNbr IS NULL
--AND IRI.IRI_USER = @UserId

--检查订单号是否存在 
--UPDATE InventoryreturnInit SET IRI_PRH_ID = PRH_ID
--FROM (SELECT MAX(CONVERT(NVARCHAR(100),PRH_ID)) PRH_ID,PRH_PurchaseOrderNbr,MAX(PRH_ReceiptDate) PRH_ReceiptDate
--FROM PoreceiptHeader
--GROUP BY PRH_PurchaseOrderNbr) PRH
--WHERE PRH_PurchaseOrderNbr = IRI_PurchaseOrderNbr
--AND IRI_User =@UserId

--UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1, IRI_PurchaseOrderNbr_ErrMsg = N'订单号不存在,'
--WHERE IRI_PurchaseOrderNbr IS NOT NULL AND IRI_PRH_ID IS NULL 
--AND IRI_USER = @UserId AND IRI_PurchaseOrderNbr_ErrMsg IS NULL

--增加校验价格
update InventoryReturnInit set IRI_PurchaseOrderNbr = '0' where IRI_User =@UserId

UPDATE InventoryreturnInit SET IRI_PurchaseOrderNbr= Convert(nvarchar(20),isnull(dbo.fn_GetPriceForDealerRetrun( IRI_DMA_ID,IRI_CFN_ID, IRI_LotNumber + '@@' + IRI_QrCode,@SubCompanyId,@BrandId,'4'),0))
where IRI_ErrorDescription is null 
and IRI_ArticleNumber_ErrMsg is null
and IRI_LotNumber_ErrMsg is null
and IRI_QrCode_ErrMsg is null
AND IRI_User =@UserId



UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1, IRI_PurchaseOrderNbr_ErrMsg = N'无法获取此产品的退货价格,'
WHERE Convert(decimal(18,2),IRI_PurchaseOrderNbr) = 0 
AND IRI_ErrorDescription is null 
and IRI_ArticleNumber_ErrMsg is null
and IRI_LotNumber_ErrMsg is null
and IRI_QrCode_ErrMsg is null
AND IRI_User =@UserId 
AND IRI_PurchaseOrderNbr_ErrMsg IS NULL

--End Edit By SongWeiming on 2017-02-26


--校验仓库中是否有产品存在
UPDATE t1
SET t1.IRI_ArticleNumber_ErrMsg = N'该仓库中不存在此产品,'
FROM InventoryReturnInit t1
LEFT JOIN Product ON IRI_CFN_ID = PMA_CFN_ID
LEFT JOIN Inventory ON IRI_WHM_ID = INV_WHM_ID AND INV_PMA_ID = PMA_ID
WHERE IRI_USER = @UserId
AND INV_ID IS NULL
AND IRI_ArticleNumber_ErrMsg IS NULL

--校验是否存在重复的相同批号的产品
UPDATE t1
SET t1.IRI_LotNumber_ErrMsg = N'该单据中相同仓库中同批号产品存在重复,'
FROM InventoryReturnInit t1
WHERE IRI_USER = @UserId
  AND IRI_LotNumber_ErrMsg IS NULL
  AND EXISTS(
SELECT 1 FROM (
SELECT IRI_CFN_ID,IRI_DMA_ID,IRI_WHM_ID,IRI_LotNumber,IRI_QrCode
FROM InventoryReturnInit t1
LEFT JOIN Product ON IRI_CFN_ID = PMA_CFN_ID
LEFT JOIN Inventory ON IRI_WHM_ID = INV_WHM_ID AND INV_PMA_ID = PMA_ID
WHERE IRI_USER = @UserId
AND INV_ID IS NOT NULL
AND IRI_LotNumber_ErrMsg IS NULL
GROUP BY IRI_CFN_ID,IRI_DMA_ID,IRI_WHM_ID,IRI_LotNumber,IRI_QrCode HAVING COUNT(1) > 1
) tab WHERE tab.IRI_CFN_ID = t1.IRI_CFN_ID 
AND tab.IRI_DMA_ID = t1.IRI_DMA_ID 
AND tab.IRI_LotNumber = t1.IRI_LotNumber 
AND tab.IRI_QrCode = t1.IRI_QrCode 
AND tab.IRI_WHM_ID = t1.IRI_WHM_ID
) 

--校验退货数量
UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1,IRI_ReturnQty_ErrMsg = N'库存数量小于退货数量,'
FROM 
(SELECT IRI_USER,IRI_ArticleNumber,IRI_LotNumber,SUM(CONVERT(DECIMAL(18,6),IRI_ReturnQty)) AS ReturnQty,
	IRI_DMA_ID,IRI_CFN_ID,IRI_BUM_ID,IRI_WHM_ID,IRI_QrCode
	FROM InventoryReturnInit
	WHERE IRI_USER = @UserId
	GROUP BY IRI_USER,IRI_ArticleNumber,IRI_LotNumber,IRI_DMA_ID,IRI_CFN_ID,IRI_BUM_ID,IRI_WHM_ID,IRI_QrCode
	) t1
		INNER JOIN Product t2 ON t1.IRI_CFN_ID = t2.PMA_CFN_ID
		LEFT JOIN Inventory t3 ON t1.IRI_WHM_ID = t3.INV_WHM_ID AND t3.INV_PMA_ID = t2.PMA_ID
		LEFT JOIN LotMaster t4 ON t2.PMA_ID = t4.LTM_Product_PMA_ID AND t1.IRI_LotNumber+'@@'+t1.IRI_QrCode = t4.LTM_LotNumber
		LEFT JOIN Lot t5 ON t4.LTM_ID = t5.LOT_LTM_ID AND t3.INV_ID = t5.LOT_INV_ID
WHERE InventoryReturnInit.IRI_USER = @UserId
AND InventoryReturnInit.IRI_ArticleNumber = t1.IRI_ArticleNumber
AND InventoryReturnInit.IRI_LotNumber = t1.IRI_LotNumber
AND InventoryReturnInit.IRI_QrCode = t1.IRI_QrCode
AND InventoryReturnInit.IRI_WHM_ID = t1.IRI_WHM_ID
AND (t1.ReturnQty > t5.LOT_OnHandQty OR t5.LOT_OnHandQty IS NULL)

UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1,IRI_ReturnQty_ErrMsg = N'退货数量不能大于1'
FROM (SELECT IRI_USER,IRI_ArticleNumber,IRI_LotNumber,SUM(CONVERT(DECIMAL(18,6),IRI_ReturnQty)) AS ReturnQty,
	IRI_DMA_ID,IRI_CFN_ID,IRI_BUM_ID,IRI_WHM_ID,IRI_QrCode
	FROM InventoryReturnInit
	WHERE IRI_USER = @UserId
	GROUP BY IRI_USER,IRI_ArticleNumber,IRI_LotNumber,IRI_DMA_ID,IRI_CFN_ID,IRI_BUM_ID,IRI_WHM_ID,IRI_QrCode
	) t1
WHERE InventoryReturnInit.IRI_USER = t1.IRI_USER
AND InventoryReturnInit.IRI_ArticleNumber = t1.IRI_ArticleNumber
AND InventoryReturnInit.IRI_LotNumber = t1.IRI_LotNumber
AND InventoryReturnInit.IRI_QrCode = t1.IRI_QrCode
AND t1.ReturnQty > 1
AND InventoryReturnInit.IRI_ReturnQty_ErrMsg IS NULL
AND ISNULL(InventoryReturnInit.IRI_QrCode,'NoQR')!='NoQR'
--检查二维码是否存在

--UPDATE InventoryReturnInit SET IRI_QrCode_ErrMsg='二维码不存在'
--where not exists(select 1 from QRCodeMaster where InventoryReturnInit.IRI_QrCode=QRCodeMaster.QRM_QRCode and QRCodeMaster.QRM_Status='1')
--and IRI_QrCode_ErrMsg is null
--检查二维码是否重复
UPDATE  t1 SET t1.IRI_ErrorFlag = 1,t1.IRI_QrCode_ErrMsg = N'二维码重复'
FROM InventoryReturnInit t1
WHERE t1.IRI_USER = @UserId
AND t1.IRI_QrCode_ErrMsg IS NULL
AND EXISTS (SELECT 1 FROM InventoryReturnInit Inv WHERE t1.IRI_QrCode=Inv.IRI_QrCode
AND Inv.IRI_USER = @UserId
GROUP BY INV.IRI_QrCode HAVING COUNT(*)>1)

--检查二维码是否在该经销商历史订单中出现过
--UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1, IRI_QrCode_ErrMsg = N'二维码在历史退货单中出现过'
--  WHERE IRI_USER = @UserId
--  AND InventoryReturnInit.IRI_QrCode_ErrMsg IS NULL
--  AND EXISTS (SELECT 1 FROM
--		(SELECT CASE WHEN CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) > 0 THEN SUBSTRING(LotMaster.LTM_LotNumber, CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) + 2, LEN(LotMaster.LTM_LotNumber) - CHARINDEX('@@', LotMaster.LTM_LotNumber, 0)) ELSE 'NoQR' END AS QrCode,
--			SUM(ISNULL(InventoryAdjustLot.IAL_LotQty,0)) AS TotalQty from InventoryAdjustHeader 
--			INNER JOIN InventoryAdjustDetail ON InventoryAdjustHeader.IAH_ID = InventoryAdjustDetail.IAD_IAH_ID
--			INNER JOIN InventoryAdjustLot ON InventoryAdjustDetail.IAD_ID = InventoryAdjustLot.IAL_IAD_ID
--			INNER JOIN Lot ON ISNULL(InventoryAdjustLot.IAL_QRLOT_ID,InventoryAdjustLot.IAL_LOT_ID) = Lot.LOT_ID
--			INNER JOIN LotMaster ON LotMaster.LTM_ID = Lot.LOT_LTM_ID 
--			WHERE InventoryAdjustHeader.IAH_DMA_ID = @DealerID
--			AND InventoryAdjustHeader.IAH_Status IN ('Submitted','Accept')
--			AND InventoryAdjustHeader.IAH_Reason = 'Return'
--			GROUP BY CASE WHEN CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) > 0 THEN SUBSTRING(LotMaster.LTM_LotNumber, CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) + 2, LEN(LotMaster.LTM_LotNumber) - CHARINDEX('@@', LotMaster.LTM_LotNumber, 0)) ELSE 'NoQR' END
--		) T
--		WHERE InventoryReturnInit.IRI_QrCode <> 'NoQR'
--		AND T.QrCode = InventoryReturnInit.IRI_QrCode
--		AND (T.TotalQty + ISNULL(InventoryReturnInit.IRI_ReturnQty,0)) > 1
--		)

UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1
WHERE IRI_USER = @UserId
AND (IRI_ArticleNumber_ErrMsg IS NOT NULL OR IRI_LotNumber_ErrMsg IS NOT NULL OR IRI_Warehouse_ErrMsg IS NOT NULL OR IRI_ReturnQty_ErrMsg IS NOT NULL OR IRI_QrCode_ErrMsg IS NOT NULL or IRI_PurchaseOrderNbr_ErrMsg is not null)

--检查是否存在错误
IF (SELECT COUNT(*) FROM InventoryReturnInit WHERE IRI_ErrorFlag = 1 AND IRI_USER = @UserId) > 0
	BEGIN
		/*如果存在错误，则返回Error*/
		SET @IsValid = 'Error'
	END
ELSE
	BEGIN
		/*如果不存在错误，则返回Success*/		
		SET @IsValid = 'Success'
		
    /*上传按钮不写正式表，导入按钮才写*/
		IF @ImportType = 'Import'
		BEGIN
			INSERT INTO #TEMP 
				SELECT NULL,NULL,NEWID(),IRI_BUM_ID,IRI_DMA_ID,IRI_WHM_ID,NULL,NULL,IRI_CFN_ID,NULL,NULL,NULL,NULL,IRI_LotNumber+'@@'+IRI_QrCode,NULL,IRI_PRH_ID,IRI_PurchaseOrderNbr,IRI_ReturnQty,null,NULL,NULL,NULL,NULL,NULL
				FROM InventoryReturnInit 
				WHERE IRI_USER = @UserId

				UPDATE #TEMP SET WhmType = WHM_Type FROM Warehouse WHERE WHM_ID = WhmId
				
				UPDATE #TEMP SET ReturnType = 'Consignment' WHERE WhmType IN ('Consignment','LP_Consignment')

				UPDATE #TEMP SET ReturnType = 'Normal' WHERE WhmType NOT IN ('Consignment','LP_Consignment')

				UPDATE #TEMP SET PmaId = PMA_ID FROM Product WHERE PMA_CFN_ID= CfnId
				
				UPDATE #TEMP SET InvId = INV_ID FROM Inventory WHERE INV_WHM_ID = WhmId AND INV_PMA_ID = PmaId

				UPDATE #TEMP SET LtmId = LTM_ID,ExpiredDate = LTM_ExpiredDate ,QRCode=LotMaster.LTM_QRCode,	Lot=LotMaster.LTM_Lot,DOM=LotMaster.LTM_Type
				FROM LotMaster WHERE LTM_LotNumber = LotNumber
				
				UPDATE #TEMP SET LotId = LOT_ID	FROM Lot WHERE LOT_LTM_ID = LtmId AND LOT_INV_ID = InvId
				
				--插入临时退货主表
				INSERT INTO #mmbo_InventoryAdjustHeader (IAH_ID,IAH_Reason,IAH_Inv_Adj_Nbr,IAH_DMA_ID,IAH_ApprovalDate,IAH_CreatedDate,
				IAH_Approval_USR_UserID,IAH_AuditorNotes,IAH_UserDescription,IAH_Status,IAH_CreatedBy_USR_UserID,IAH_Reverse_IAH_ID,IAH_ProductLine_BUM_ID,IAH_WarehouseType)
				SELECT NEWID(),'Return',NULL,DealerId,NULL,GETDATE(),NULL,NULL,NULL,'Draft',@UserId,NULL,ProductLineId,ReturnType
				FROM #TEMP
				GROUP BY DealerId,ProductLineId,ReturnType

				UPDATE #TEMP SET RHeadId = IAH_ID FROM #mmbo_InventoryAdjustHeader 
				WHERE DealerId = IAH_DMA_ID 
				AND ProductLineId = IAH_ProductLine_BUM_ID
				AND ReturnType = IAH_WarehouseType
				
				--插入临时退货明细表
				INSERT INTO #mmbo_InventoryAdjustDetail (IAD_Quantity,IAD_ID,IAD_PMA_ID,IAD_IAH_ID,IAD_LineNbr)
				SELECT SUM(Qty),NEWID(),PmaId,RHeadId,ROW_NUMBER () OVER (PARTITION BY RHeadId ORDER BY PmaId) FROM #TEMP
				GROUP BY RHeadId,PmaId

				UPDATE #TEMP SET RDetailId = IAD_ID FROM #mmbo_InventoryAdjustDetail
				WHERE RHeadId = IAD_IAH_ID
				AND PmaId = IAD_PMA_ID
				
				--更新价格
				UPDATE #TEMP SET UnitPrice = dbo.fn_GetPriceForDealerRetrun(DealerId,CfnId,LotNumber,@SubCompanyId,@BrandId,'4')

				--更新ERP行号
				IF(@DealerType<>'T2')
				BEGIN
					UPDATE t
					SET t.ERPNbr=prl.PRL_ERPNbr,
					t.ERPLineNbr=prl.PRL_ERPLineNbr,
					t.ExpiredDate = CASE WHEN prl.PRL_ExpiredDate IS NULL THEN t.ExpiredDate ELSE prl.PRL_ExpiredDate END,
					t.DOM = CASE ISNULL(prl.PRL_DOM,'') WHEN '' THEN t.DOM ELSE prl.PRL_DOM END,
					t.UnitPrice = CASE ISNULL(prl.PRL_ERPAmount,0) WHEN 0 THEN t.UnitPrice ELSE prl.PRL_ERPAmount END
					FROM #TEMP t
					INNER JOIN POReceiptLot prl ON prl.PRL_LotNumber = t.LotNumber
					INNER JOIN dbo.POReceipt por ON prl.PRL_POR_ID=por.POR_ID
					INNER JOIN dbo.POReceiptHeader prh ON por.POR_PRH_ID = prh.PRH_ID
					INNER JOIN View_ProductLine vp ON vp.Id = prh.PRH_ProductLine_BUM_ID
					WHERE vp.SubCompanyId=@SubCompanyId
					AND vp.BrandId =@BrandId
					AND prh.PRH_Dealer_DMA_ID = DealerId
					AND por.POR_SAP_PMA_ID = t.PmaId
				END
				--插入临时退货批次表
				INSERT INTO #mmbo_InventoryAdjustLot
				SELECT RDetailId,RLotId,Qty,LotId,WhmId,LotNumber,ExpiredDate,POReceiptId,UnitPrice ,NULL,NULL,NULL,NULL,QRCode,Lot,DOM,ERPNbr,ERPLineNbr FROM #TEMP
				
				

				INSERT INTO InventoryAdjustHeader (IAH_ID, IAH_Reason, IAH_Inv_Adj_Nbr, IAH_DMA_ID, IAH_ApprovalDate, IAH_CreatedDate, IAH_Approval_USR_UserID, IAH_AuditorNotes, IAH_UserDescription, IAH_Status, IAH_CreatedBy_USR_UserID, IAH_Reverse_IAH_ID, IAH_ProductLine_BUM_ID, IAH_WarehouseType, IAH_RSM)
				SELECT IAH_ID, IAH_Reason, IAH_Inv_Adj_Nbr, IAH_DMA_ID, IAH_ApprovalDate, IAH_CreatedDate, IAH_Approval_USR_UserID, IAH_AuditorNotes, IAH_UserDescription, IAH_Status, IAH_CreatedBy_USR_UserID, IAH_Reverse_IAH_ID, IAH_ProductLine_BUM_ID, IAH_WarehouseType, 'return_user1' FROM #mmbo_InventoryAdjustHeader
								
				INSERT INTO InventoryAdjustDetail 
				SELECT * FROM #mmbo_InventoryAdjustDetail
								
				INSERT INTO InventoryAdjustLot
				SELECT * FROM #mmbo_InventoryAdjustLot


				--插入订单操作日志
				INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
				SELECT NEWID(),IAH_ID,IAH_CreatedBy_USR_UserID,GETDATE(),(CASE WHEN @ImportType = 'Import' THEN 'ExcelImport' ELSE 'ForceImport' END),NULL FROM #mmbo_InventoryAdjustHeader
			
				--清除中间表的数据
				DELETE FROM InventoryReturnInit WHERE IRI_USER = @UserId
		END
	END
	

IF @ImportType = 'ForceImport'
BEGIN
	INSERT INTO #TEMP 
		SELECT NULL,NULL,NEWID(),IRI_BUM_ID,IRI_DMA_ID,IRI_WHM_ID,NULL,NULL,IRI_CFN_ID,NULL,NULL,NULL,NULL,IRI_LotNumber+'@@'+IRI_QrCode,NULL,IRI_PRH_ID,IRI_PurchaseOrderNbr,IRI_ReturnQty,null,NULL,NULL,NULL
		FROM InventoryReturnInit a
		WHERE IRI_USER = @UserId and a.IRI_ErrorFlag=0

		UPDATE #TEMP SET WhmType = WHM_Type FROM Warehouse WHERE WHM_ID = WhmId
		
		UPDATE #TEMP SET ReturnType = 'Consignment' WHERE WhmType IN ('Consignment','LP_Consignment')

		UPDATE #TEMP SET ReturnType = 'Normal' WHERE WhmType NOT IN ('Consignment','LP_Consignment')

		UPDATE #TEMP SET PmaId = PMA_ID FROM Product WHERE PMA_CFN_ID= CfnId
		
		UPDATE #TEMP SET InvId = INV_ID FROM Inventory WHERE INV_WHM_ID = WhmId AND INV_PMA_ID = PmaId

		UPDATE #TEMP SET LtmId = LTM_ID,ExpiredDate = LTM_ExpiredDate,QRCode=LotMaster.LTM_QRCode,	Lot=LotMaster.LTM_Lot,DOM=LotMaster.LTM_Type FROM LotMaster WHERE LTM_LotNumber = LotNumber
		
		UPDATE #TEMP SET LotId = LOT_ID FROM Lot WHERE LOT_LTM_ID = LtmId AND LOT_INV_ID = InvId
		
		--插入临时退货主表
		INSERT INTO #mmbo_InventoryAdjustHeader (IAH_ID,IAH_Reason,IAH_Inv_Adj_Nbr,IAH_DMA_ID,IAH_ApprovalDate,IAH_CreatedDate,
		IAH_Approval_USR_UserID,IAH_AuditorNotes,IAH_UserDescription,IAH_Status,IAH_CreatedBy_USR_UserID,IAH_Reverse_IAH_ID,IAH_ProductLine_BUM_ID,IAH_WarehouseType)
		SELECT NEWID(),'Return',NULL,DealerId,NULL,GETDATE(),NULL,NULL,NULL,'Draft',@UserId,NULL,ProductLineId,ReturnType
		FROM #TEMP
		GROUP BY DealerId,ProductLineId,ReturnType

		UPDATE #TEMP SET RHeadId = IAH_ID FROM #mmbo_InventoryAdjustHeader 
		WHERE DealerId = IAH_DMA_ID 
		AND ProductLineId = IAH_ProductLine_BUM_ID
		AND ReturnType = IAH_WarehouseType
		
		--插入临时退货明细表
		INSERT INTO #mmbo_InventoryAdjustDetail (IAD_Quantity,IAD_ID,IAD_PMA_ID,IAD_IAH_ID,IAD_LineNbr)
		SELECT SUM(Qty),NEWID(),PmaId,RHeadId,ROW_NUMBER () OVER (PARTITION BY RHeadId ORDER BY PmaId) 
		FROM #TEMP
		WHERE Qty>0
		GROUP BY RHeadId,PmaId

		UPDATE #TEMP SET RDetailId = IAD_ID FROM #mmbo_InventoryAdjustDetail
		WHERE RHeadId = IAD_IAH_ID
		AND PmaId = IAD_PMA_ID
		
		--更新价格
		UPDATE #TEMP SET UnitPrice = dbo.fn_GetPriceForDealerRetrun(DealerId,CfnId,LotNumber,@SubCompanyId,@BrandId,'4')

		--插入临时退货批次表
		INSERT INTO #mmbo_InventoryAdjustLot
		SELECT RDetailId,RLotId,Qty,LotId,WhmId,LotNumber,ExpiredDate,POReceiptId,UnitPrice ,NULL,NULL,NULL,NULL,QRCode,Lot,DOM FROM #TEMP WHERE Qty>0
	
		
		INSERT INTO InventoryAdjustHeader (IAH_ID, IAH_Reason, IAH_Inv_Adj_Nbr, IAH_DMA_ID, IAH_ApprovalDate, IAH_CreatedDate, IAH_Approval_USR_UserID, IAH_AuditorNotes, IAH_UserDescription, IAH_Status, IAH_CreatedBy_USR_UserID, IAH_Reverse_IAH_ID, IAH_ProductLine_BUM_ID, IAH_WarehouseType, IAH_RSM)
		SELECT IAH_ID, IAH_Reason, IAH_Inv_Adj_Nbr, IAH_DMA_ID, IAH_ApprovalDate, IAH_CreatedDate, IAH_Approval_USR_UserID, IAH_AuditorNotes, '寄售合同终止，系统自动提交', IAH_Status, IAH_CreatedBy_USR_UserID, IAH_Reverse_IAH_ID, IAH_ProductLine_BUM_ID, IAH_WarehouseType, NULL FROM #mmbo_InventoryAdjustHeader
						
		INSERT INTO InventoryAdjustDetail 
		SELECT * FROM #mmbo_InventoryAdjustDetail
						
		INSERT INTO InventoryAdjustLot
		SELECT * FROM #mmbo_InventoryAdjustLot
		
		
	
			--状态变更
			UPDATE A SET IAH_Status='Submitted'  
			FROM InventoryAdjustHeader A 
			INNER JOIN  #mmbo_InventoryAdjustHeader B ON A.IAH_ID=B.IAH_ID 
			
			
			Declare @IAH_ID uniqueidentifier
			Declare @IAH_DMA_ID uniqueidentifier
			Declare @SubmintNo Nvarchar(50)
			Declare @Clientid Nvarchar(50)
			Declare @BU Nvarchar(50)
			
			DECLARE @PRODUCT_CUR cursor;
			SET @PRODUCT_CUR=cursor for 
			
			SELECT IAH_ID,IAH_DMA_ID,DivisionName
			FROM #mmbo_InventoryAdjustHeader A
			INNER JOIN V_DivisionProductLineRelation B ON A.IAH_ProductLine_BUM_ID=B.ProductLineID AND B.IsEmerging=0

			OPEN @PRODUCT_CUR
			FETCH NEXT FROM @PRODUCT_CUR INTO @IAH_ID,@IAH_DMA_ID,@BU
			WHILE @@FETCH_STATUS = 0        
			BEGIN
			SET @SubmintNo=''
			EXEC [dbo].[GC_GetNextAutoNumber] @IAH_DMA_ID,'Next_AdjustNbr',@BU,@SubCompanyId,@BrandId,@SubmintNo OUTPUT
			--维护退货单编号
			UPDATE InventoryAdjustHeader SET IAH_Inv_Adj_Nbr=@SubmintNo WHERE IAH_ID=@IAH_ID

			--冻结库存
			EXEC Consignment.Proc_InventoryAdjust 'ConsignReturn',@SubmintNo,'Frozen','',''

			SELECT @Clientid=B.CLT_ID FROM DealerMaster A 
			INNER JOIN Client B ON A.DMA_Parent_DMA_ID=B.CLT_Corp_Id
			WHERE A.DMA_ID=@IAH_DMA_ID


			--维护接口表
			 INSERT INTO AdjustInterface
			  (AI_ID,AI_BatchNbr,AI_RecordNbr,AI_IAH_ID,AI_IAH_AdjustNo,AI_Status,AI_ProcessType,AI_FileName,AI_CreateUser,AI_CreateDate,AI_UpdateUser,AI_UpdateDate,AI_ClientID)
			  VALUES(NEWID(),'','',@IAH_ID,@SubmintNo,'Pending','System','00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000',GETDATE(),NULL,NULL,@Clientid)

				FETCH NEXT FROM @PRODUCT_CUR INTO @IAH_ID,@IAH_DMA_ID,@BU
			END
			CLOSE @PRODUCT_CUR
			DEALLOCATE @PRODUCT_CUR ;	

	


		--插入订单操作日志
		INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
		SELECT NEWID(),IAH_ID,IAH_CreatedBy_USR_UserID,GETDATE(),(CASE WHEN @ImportType = 'Import' THEN 'ExcelImport' ELSE 'ForceImport' END),NULL FROM #mmbo_InventoryAdjustHeader
	
		--清除中间表的数据
		DELETE FROM InventoryReturnInit WHERE IRI_USER = @UserId
END


	
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH  
    
    
    SET  NOCOUNT OFF
      ROLLBACK TRAN
      SET @IsValid = 'Failure'

      --记录错误日志开始
      DECLARE @error_line   INT
      DECLARE @error_number   INT
      DECLARE @error_message   NVARCHAR (256)
      DECLARE @vError   NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError =
               '行'
             + CONVERT (NVARCHAR (10), @error_line)
             + '出错[错误号'
             + CONVERT (NVARCHAR (10), @error_number)
             + '],'
             + @error_message
      --SET @RtnMsg = @vError
      --EXEC dbo.GC_Interface_Log 'Confirmation', 'Failure', @vError

      RETURN @vError
    
END CATCH





