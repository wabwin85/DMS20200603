SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
/*
��������
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

--������ʱ��
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
)


/*�Ƚ������־��Ϊ0*/
UPDATE InventoryReturnInit SET IRI_ErrorFlag = 0,IRI_ReturnQty_ErrMsg= null WHERE IRI_USER = @UserId

--��龭�����Ƿ����
UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1,IRI_ErrorDescription = N'�����̲�����,'
WHERE IRI_USER = @UserId
AND IRI_DMA_ID IS NULL

--��ȡ������
SELECT TOP 1 @DealerID = IRI_DMA_ID FROM InventoryReturnInit WHERE IRI_USER = @UserId
SELECT @DealerType = DMA_DealerType FROM DealerMaster WHERE DMA_ID = @DealerID

--���ֿ��Ƿ����
UPDATE InventoryReturnInit SET IRI_WHM_ID = WHM_ID
FROM Warehouse WHERE WHM_Name = IRI_Warehouse
AND WHM_DMA_ID = @DealerID
AND IRI_USER = @UserId

UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1,IRI_Warehouse_ErrMsg = N'�ֿⲻ����,'
WHERE IRI_WHM_ID IS NULL AND IRI_USER = @UserId AND IRI_Warehouse_ErrMsg IS NULL

--����Ʒ�Ƿ����
UPDATE InventoryReturnInit SET IRI_CFN_ID = CFN_ID
FROM CFN WHERE CFN_CustomerFaceNbr = IRI_ArticleNumber
AND IRI_USER = @UserId

UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1,IRI_ArticleNumber_ErrMsg = N'��Ʒ������,'
WHERE IRI_CFN_ID IS NULL AND IRI_USER = @UserId AND IRI_ArticleNumber_ErrMsg IS NULL

--����Ʒ�Ƿ��ѷ��ࣨ�Ƿ��Ӧ��Ʒ�ߣ�
UPDATE IRI SET IRI_BUM_ID = CFN_ProductLine_BUM_ID--(CASE WHEN CFNS_BUM_ID IS NULL THEN CFN_ProductLine_BUM_ID ELSE CFNS_BUM_ID END)
FROM InventoryReturnInit IRI INNER JOIN CFN ON CFN_ID = IRI_CFN_ID 
--left join CFNSHARE on CFN_ID = CFNS_CFN_ID AND CFNS_PROPERTY1 = 1
WHERE IRI_CFN_ID IS NOT NULL
AND IRI_USER = @UserId
AND Exists (select 1 from View_ProductLine where ATTRIBUTE_TYPE='Product_Line' ---���ӹ�˾Ʒ����֤
AND ISNULL(SubCompanyId,'')=ISNULL(@SubCompanyId,'') AND ISNULL(BrandId,'')=ISNULL(@BrandId,'')
AND Id = CFN.CFN_ProductLine_BUM_ID)

UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1,IRI_ArticleNumber_ErrMsg =  N'��Ʒδ����(�޶�Ӧ��Ʒ��),'
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

UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1,IRI_ArticleNumber_ErrMsg =  N'��Ȩδͨ��,' 
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


--����Ʒ�����Ƿ���Ⱥ
UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1, IRI_LotNumber_ErrMsg = N'��Ʒ���Ų����ڻ����κŵĶ�ά����д����,',IRI_QrCode_ErrMsg=N'��Ʒ���Ų����ڻ����κŵĶ�ά����д����,'
WHERE (IRI_LotNumber IS NOT NULL OR IRI_LotNumber<>'')
  AND IRI_USER = @UserId 
  AND IRI_LotNumber_ErrMsg IS NULL
  AND IRI_ArticleNumber_ErrMsg IS NULL
  AND NOT EXISTS
  (SELECT 1
     FROM CFN t1, Product t2, LotMaster t3
    WHERE  t1.CFN_ID = t2.PMA_CFN_ID
       AND t2.PMA_ID = t3.LTM_Product_PMA_ID
       AND  t3.LTM_LotNumber= InventoryReturnInit.IRI_LotNumber+'@@'+InventoryReturnInit.IRI_QrCode AND t1.CFN_CustomerFaceNbr = InventoryReturnInit.IRI_ArticleNumber
   )
   
   
--Edit By SongWeiming on 2017-02-26 ����У�鶩���ţ���ΪУ���Ƿ��м۸񣬼۸�Ϊ0�Ĳ��ܵ���ϵͳ
--���û����д�����ţ��Զ���ȡ�����һ�Ŷ�����
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

--��鶩�����Ƿ���� 
--UPDATE InventoryreturnInit SET IRI_PRH_ID = PRH_ID
--FROM (SELECT MAX(CONVERT(NVARCHAR(100),PRH_ID)) PRH_ID,PRH_PurchaseOrderNbr,MAX(PRH_ReceiptDate) PRH_ReceiptDate
--FROM PoreceiptHeader
--GROUP BY PRH_PurchaseOrderNbr) PRH
--WHERE PRH_PurchaseOrderNbr = IRI_PurchaseOrderNbr
--AND IRI_User =@UserId

--UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1, IRI_PurchaseOrderNbr_ErrMsg = N'�����Ų�����,'
--WHERE IRI_PurchaseOrderNbr IS NOT NULL AND IRI_PRH_ID IS NULL 
--AND IRI_USER = @UserId AND IRI_PurchaseOrderNbr_ErrMsg IS NULL

--����У��۸�
update InventoryReturnInit set IRI_PurchaseOrderNbr = '0' where IRI_User =@UserId

UPDATE InventoryreturnInit SET IRI_PurchaseOrderNbr= Convert(nvarchar(20),isnull(dbo.fn_GetPriceForDealerRetrun( IRI_DMA_ID,IRI_CFN_ID, IRI_LotNumber + '@@' + IRI_QrCode,@SubCompanyId,@BrandId,'4'),0))
where IRI_ErrorDescription is null 
and IRI_ArticleNumber_ErrMsg is null
and IRI_LotNumber_ErrMsg is null
and IRI_QrCode_ErrMsg is null
AND IRI_User =@UserId



UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1, IRI_PurchaseOrderNbr_ErrMsg = N'�޷���ȡ�˲�Ʒ���˻��۸�,'
WHERE Convert(decimal(18,2),IRI_PurchaseOrderNbr) = 0 
AND IRI_ErrorDescription is null 
and IRI_ArticleNumber_ErrMsg is null
and IRI_LotNumber_ErrMsg is null
and IRI_QrCode_ErrMsg is null
AND IRI_User =@UserId 
AND IRI_PurchaseOrderNbr_ErrMsg IS NULL

--End Edit By SongWeiming on 2017-02-26


--У��ֿ����Ƿ��в�Ʒ����
UPDATE t1
SET t1.IRI_ArticleNumber_ErrMsg = N'�òֿ��в����ڴ˲�Ʒ,'
FROM InventoryReturnInit t1
LEFT JOIN Product ON IRI_CFN_ID = PMA_CFN_ID
LEFT JOIN Inventory ON IRI_WHM_ID = INV_WHM_ID AND INV_PMA_ID = PMA_ID
WHERE IRI_USER = @UserId
AND INV_ID IS NULL
AND IRI_ArticleNumber_ErrMsg IS NULL

--У���Ƿ�����ظ�����ͬ���ŵĲ�Ʒ
UPDATE t1
SET t1.IRI_LotNumber_ErrMsg = N'�õ�������ͬ�ֿ���ͬ���Ų�Ʒ�����ظ�,'
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

--У���˻�����
UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1,IRI_ReturnQty_ErrMsg = N'�������С���˻�����,'
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

UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1,IRI_ReturnQty_ErrMsg = N'�˻��������ܴ���1'
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
--����ά���Ƿ����

--UPDATE InventoryReturnInit SET IRI_QrCode_ErrMsg='��ά�벻����'
--where not exists(select 1 from QRCodeMaster where InventoryReturnInit.IRI_QrCode=QRCodeMaster.QRM_QRCode and QRCodeMaster.QRM_Status='1')
--and IRI_QrCode_ErrMsg is null
--����ά���Ƿ��ظ�
UPDATE  t1 SET t1.IRI_ErrorFlag = 1,t1.IRI_QrCode_ErrMsg = N'��ά���ظ�'
FROM InventoryReturnInit t1
WHERE t1.IRI_USER = @UserId
AND t1.IRI_QrCode_ErrMsg IS NULL
AND EXISTS (SELECT 1 FROM InventoryReturnInit Inv WHERE t1.IRI_QrCode=Inv.IRI_QrCode
AND Inv.IRI_USER = @UserId
GROUP BY INV.IRI_QrCode HAVING COUNT(*)>1)

--����ά���Ƿ��ڸþ�������ʷ�����г��ֹ�
--UPDATE InventoryReturnInit SET IRI_ErrorFlag = 1, IRI_QrCode_ErrMsg = N'��ά������ʷ�˻����г��ֹ�'
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

--����Ƿ���ڴ���
IF (SELECT COUNT(*) FROM InventoryReturnInit WHERE IRI_ErrorFlag = 1 AND IRI_USER = @UserId) > 0
	BEGIN
		/*������ڴ����򷵻�Error*/
		SET @IsValid = 'Error'
	END
ELSE
	BEGIN
		/*��������ڴ����򷵻�Success*/		
		SET @IsValid = 'Success'
		
    /*�ϴ���ť��д��ʽ�����밴ť��д*/
		IF @ImportType = 'Import'
		BEGIN
			INSERT INTO #TEMP 
				SELECT NULL,NULL,NEWID(),IRI_BUM_ID,IRI_DMA_ID,IRI_WHM_ID,NULL,NULL,IRI_CFN_ID,NULL,NULL,NULL,NULL,IRI_LotNumber+'@@'+IRI_QrCode,NULL,IRI_PRH_ID,IRI_PurchaseOrderNbr,IRI_ReturnQty,null,NULL,NULL,NULL
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
				
				--������ʱ�˻�����
				INSERT INTO #mmbo_InventoryAdjustHeader (IAH_ID,IAH_Reason,IAH_Inv_Adj_Nbr,IAH_DMA_ID,IAH_ApprovalDate,IAH_CreatedDate,
				IAH_Approval_USR_UserID,IAH_AuditorNotes,IAH_UserDescription,IAH_Status,IAH_CreatedBy_USR_UserID,IAH_Reverse_IAH_ID,IAH_ProductLine_BUM_ID,IAH_WarehouseType)
				SELECT NEWID(),'Return',NULL,DealerId,NULL,GETDATE(),NULL,NULL,NULL,'Draft',@UserId,NULL,ProductLineId,ReturnType
				FROM #TEMP
				GROUP BY DealerId,ProductLineId,ReturnType

				UPDATE #TEMP SET RHeadId = IAH_ID FROM #mmbo_InventoryAdjustHeader 
				WHERE DealerId = IAH_DMA_ID 
				AND ProductLineId = IAH_ProductLine_BUM_ID
				AND ReturnType = IAH_WarehouseType
				
				--������ʱ�˻���ϸ��
				INSERT INTO #mmbo_InventoryAdjustDetail (IAD_Quantity,IAD_ID,IAD_PMA_ID,IAD_IAH_ID,IAD_LineNbr)
				SELECT SUM(Qty),NEWID(),PmaId,RHeadId,ROW_NUMBER () OVER (PARTITION BY RHeadId ORDER BY PmaId) FROM #TEMP
				GROUP BY RHeadId,PmaId

				UPDATE #TEMP SET RDetailId = IAD_ID FROM #mmbo_InventoryAdjustDetail
				WHERE RHeadId = IAD_IAH_ID
				AND PmaId = IAD_PMA_ID
				
				--���¼۸�
				UPDATE #TEMP SET UnitPrice = dbo.fn_GetPriceForDealerRetrun(DealerId,CfnId,LotNumber,@SubCompanyId,@BrandId,'4')

				--������ʱ�˻����α�
				INSERT INTO #mmbo_InventoryAdjustLot
				SELECT RDetailId,RLotId,Qty,LotId,WhmId,LotNumber,ExpiredDate,POReceiptId,UnitPrice ,NULL,NULL,NULL,NULL,QRCode,Lot,DOM FROM #TEMP
				
				
				INSERT INTO InventoryAdjustHeader (IAH_ID, IAH_Reason, IAH_Inv_Adj_Nbr, IAH_DMA_ID, IAH_ApprovalDate, IAH_CreatedDate, IAH_Approval_USR_UserID, IAH_AuditorNotes, IAH_UserDescription, IAH_Status, IAH_CreatedBy_USR_UserID, IAH_Reverse_IAH_ID, IAH_ProductLine_BUM_ID, IAH_WarehouseType, IAH_RSM)
				SELECT IAH_ID, IAH_Reason, IAH_Inv_Adj_Nbr, IAH_DMA_ID, IAH_ApprovalDate, IAH_CreatedDate, IAH_Approval_USR_UserID, IAH_AuditorNotes, IAH_UserDescription, IAH_Status, IAH_CreatedBy_USR_UserID, IAH_Reverse_IAH_ID, IAH_ProductLine_BUM_ID, IAH_WarehouseType, NULL FROM #mmbo_InventoryAdjustHeader
								
				INSERT INTO InventoryAdjustDetail 
				SELECT * FROM #mmbo_InventoryAdjustDetail
								
				INSERT INTO InventoryAdjustLot
				SELECT * FROM #mmbo_InventoryAdjustLot


				--���붩��������־
				INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
				SELECT NEWID(),IAH_ID,IAH_CreatedBy_USR_UserID,GETDATE(),(CASE WHEN @ImportType = 'Import' THEN 'ExcelImport' ELSE 'ForceImport' END),NULL FROM #mmbo_InventoryAdjustHeader
			
				--����м�������
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
		
		--������ʱ�˻�����
		INSERT INTO #mmbo_InventoryAdjustHeader (IAH_ID,IAH_Reason,IAH_Inv_Adj_Nbr,IAH_DMA_ID,IAH_ApprovalDate,IAH_CreatedDate,
		IAH_Approval_USR_UserID,IAH_AuditorNotes,IAH_UserDescription,IAH_Status,IAH_CreatedBy_USR_UserID,IAH_Reverse_IAH_ID,IAH_ProductLine_BUM_ID,IAH_WarehouseType)
		SELECT NEWID(),'Return',NULL,DealerId,NULL,GETDATE(),NULL,NULL,NULL,'Draft',@UserId,NULL,ProductLineId,ReturnType
		FROM #TEMP
		GROUP BY DealerId,ProductLineId,ReturnType

		UPDATE #TEMP SET RHeadId = IAH_ID FROM #mmbo_InventoryAdjustHeader 
		WHERE DealerId = IAH_DMA_ID 
		AND ProductLineId = IAH_ProductLine_BUM_ID
		AND ReturnType = IAH_WarehouseType
		
		--������ʱ�˻���ϸ��
		INSERT INTO #mmbo_InventoryAdjustDetail (IAD_Quantity,IAD_ID,IAD_PMA_ID,IAD_IAH_ID,IAD_LineNbr)
		SELECT SUM(Qty),NEWID(),PmaId,RHeadId,ROW_NUMBER () OVER (PARTITION BY RHeadId ORDER BY PmaId) 
		FROM #TEMP
		WHERE Qty>0
		GROUP BY RHeadId,PmaId

		UPDATE #TEMP SET RDetailId = IAD_ID FROM #mmbo_InventoryAdjustDetail
		WHERE RHeadId = IAD_IAH_ID
		AND PmaId = IAD_PMA_ID
		
		--���¼۸�
		UPDATE #TEMP SET UnitPrice = dbo.fn_GetPriceForDealerRetrun(DealerId,CfnId,LotNumber,@SubCompanyId,@BrandId,'4')

		--������ʱ�˻����α�
		INSERT INTO #mmbo_InventoryAdjustLot
		SELECT RDetailId,RLotId,Qty,LotId,WhmId,LotNumber,ExpiredDate,POReceiptId,UnitPrice ,NULL,NULL,NULL,NULL,QRCode,Lot,DOM FROM #TEMP WHERE Qty>0
	
		
		INSERT INTO InventoryAdjustHeader (IAH_ID, IAH_Reason, IAH_Inv_Adj_Nbr, IAH_DMA_ID, IAH_ApprovalDate, IAH_CreatedDate, IAH_Approval_USR_UserID, IAH_AuditorNotes, IAH_UserDescription, IAH_Status, IAH_CreatedBy_USR_UserID, IAH_Reverse_IAH_ID, IAH_ProductLine_BUM_ID, IAH_WarehouseType, IAH_RSM)
		SELECT IAH_ID, IAH_Reason, IAH_Inv_Adj_Nbr, IAH_DMA_ID, IAH_ApprovalDate, IAH_CreatedDate, IAH_Approval_USR_UserID, IAH_AuditorNotes, '���ۺ�ͬ��ֹ��ϵͳ�Զ��ύ', IAH_Status, IAH_CreatedBy_USR_UserID, IAH_Reverse_IAH_ID, IAH_ProductLine_BUM_ID, IAH_WarehouseType, NULL FROM #mmbo_InventoryAdjustHeader
						
		INSERT INTO InventoryAdjustDetail 
		SELECT * FROM #mmbo_InventoryAdjustDetail
						
		INSERT INTO InventoryAdjustLot
		SELECT * FROM #mmbo_InventoryAdjustLot
		
		
	
			--״̬���
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
			--ά���˻������
			UPDATE InventoryAdjustHeader SET IAH_Inv_Adj_Nbr=@SubmintNo WHERE IAH_ID=@IAH_ID

			--������
			EXEC Consignment.Proc_InventoryAdjust 'ConsignReturn',@SubmintNo,'Frozen','',''

			SELECT @Clientid=B.CLT_ID FROM DealerMaster A 
			INNER JOIN Client B ON A.DMA_Parent_DMA_ID=B.CLT_Corp_Id
			WHERE A.DMA_ID=@IAH_DMA_ID


			--ά���ӿڱ�
			 INSERT INTO AdjustInterface
			  (AI_ID,AI_BatchNbr,AI_RecordNbr,AI_IAH_ID,AI_IAH_AdjustNo,AI_Status,AI_ProcessType,AI_FileName,AI_CreateUser,AI_CreateDate,AI_UpdateUser,AI_UpdateDate,AI_ClientID)
			  VALUES(NEWID(),'','',@IAH_ID,@SubmintNo,'Pending','System','00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000',GETDATE(),NULL,NULL,@Clientid)

				FETCH NEXT FROM @PRODUCT_CUR INTO @IAH_ID,@IAH_DMA_ID,@BU
			END
			CLOSE @PRODUCT_CUR
			DEALLOCATE @PRODUCT_CUR ;	

	


		--���붩��������־
		INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
		SELECT NEWID(),IAH_ID,IAH_CreatedBy_USR_UserID,GETDATE(),(CASE WHEN @ImportType = 'Import' THEN 'ExcelImport' ELSE 'ForceImport' END),NULL FROM #mmbo_InventoryAdjustHeader
	
		--����м�������
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

      --��¼������־��ʼ
      DECLARE @error_line   INT
      DECLARE @error_number   INT
      DECLARE @error_message   NVARCHAR (256)
      DECLARE @vError   NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError =
               '��'
             + CONVERT (NVARCHAR (10), @error_line)
             + '����[�����'
             + CONVERT (NVARCHAR (10), @error_number)
             + '],'
             + @error_message
      --SET @RtnMsg = @vError
      --EXEC dbo.GC_Interface_Log 'Confirmation', 'Failure', @vError

      RETURN @vError
    
END CATCH




GO

