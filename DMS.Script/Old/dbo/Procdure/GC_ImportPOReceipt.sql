DROP Procedure [dbo].[GC_ImportPOReceipt]
GO

/*
DECLARE @IsValid NVARCHAR(20)
EXEC [GC_ImportPOReceipt] 'b3c064c1-902e-44c1-8a5a-b0bc569cd80f',@IsValid output
select @IsValid
*/

CREATE Procedure [dbo].[GC_ImportPOReceipt]
    @UserId uniqueidentifier,
    @IsValid NVARCHAR(20) = 'Success' OUTPUT
AS
    DECLARE @ErrorCount INTEGER
		DECLARE @Vender_DMA_ID uniqueidentifier
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

--ɾ����ʱ���е�����
delete from tmpPORImportHeader
delete from tmpPORImportLine
delete from tmpPORImportLot

--�õ�����˼����Ϊ�����̣���ID
SELECT TOP 1 @Vender_DMA_ID = DMA_ID FROM DealerMaster WHERE (DMA_HostCompanyFlag = 1)

/*��Ʒ��ʱ��*/
create table #tmp_product(
PMA_ID uniqueidentifier,
PMA_UPN nvarchar(50),
PMA_CFN_ID uniqueidentifier
primary key (PMA_ID)
)

--���˴��û��ϴ��ķ������ݵ��뵽������¼��
--����OrderNo��ArticleNo��Batch��ShippingDate��DelivQty��SAPAccount�������ֶ������Ϊ����Ψһ�ı�־,ֻ���벻���ڵ�����
INSERT INTO DeliveryNote (DNL_ID,
                          DNL_LineNbrInFile,
                          DNL_ShipToDealerCode,
                          DNL_SAPCode,
                          DNL_PONbr,
                          DNL_DeliveryNoteNbr,
                          DNL_CFN,
                          --DNL_UPN,
                          DNL_LotNumber,
                          DNL_ExpiredDate,
                          --DNL_DN_UnitOfMeasure,
                          --DNL_ReceiveUnitOfMeasure,
                          --DNL_ShipQty,
                          DNL_ReceiveQty,
                          DNL_ShipmentDate,
                          DNL_ImportFileName,
                          --DNL_OrderType,
                          --DNL_UnitPrice,
                          --DNL_SubTotal,
                          --DNL_ShipmentType,
                          DNL_CreatedDate,
                          --DNL_SAPSalesOrderID,
                          --DNL_SAPSOLine,
                          DNL_CreateUser,
                          DNL_Carrier,
                          DNL_TrackingNo,
                          DNL_ShipType,
                          DNL_Note
                          )
     SELECT a.DIL_ID,
            a.DIL_LineNbr,
            a.DIL_SAPCode,
            a.DIL_SAPCode,
            a.DIL_OrderNo,
            a.DIL_SapDeliveryNo,
            a.DIL_ArticleNo,
            --ProDeliveryNote.DNL_UPN,
            a.DIL_LotNumber,
            a.DIL_ExpiredDate,
            --ProDeliveryNote.DNL_DN_UnitOfMeasure,
            --ProDeliveryNote.DNL_ReceiveUnitOfMeasure,
            --ProDeliveryNote.DNL_ShipQty,
            a.DIL_DeliveryQty,
            a.DIL_ShippingDate,
            a.DIL_FileName,
            --ProDeliveryNote.DNL_OrderType,
            --ProDeliveryNote.DNL_UnitPrice,
            --MIN (ProDeliveryNote.DNL_SubTotal),
            --ProDeliveryNote.DNL_ShipmentType,
            getdate(),
            --ProDeliveryNote.DNL_SAPSalesOrderID,
            --ProDeliveryNote.DNL_DeliveryNoteNbr,
            @UserId,
            a.DIL_Carrier,
            a.DIL_TrackingNo,
            a.DIL_ShipType,
            a.DIL_Note
       FROM DeliveryInit a where DIL_USER = @UserId and DIL_ErrorFlag = 0
       and not exists (select 1 from DeliveryNote b where b.DNL_SAPCode = a.DIL_SAPCode
       and b.DNL_PONbr = a.DIL_OrderNo and b.DNL_CFN = a.DIL_ArticleNo
       and b.DNL_LotNumber = a.DIL_LotNumber and b.DNL_ShipmentDate = a.DIL_ShippingDate
       and b.DNL_ReceiveQty = a.DIL_DeliveryQty)

--��δ�����ջ����ݵļ�¼���еĴ�����Ϣ����Ʒ�ߡ���Ʒ�������Ȩ����ʼ��
update DeliveryNote set DNL_ProblemDescription = null,DNL_ProductLine_BUM_ID = NULL, 
DNL_ProductCatagory_PCT_ID = NULL,DNL_Authorized = 0,DNL_BUName = null
where DNL_POReceiptLot_PRL_ID IS NULL

--��龭����
update DeliveryNote set DNL_DealerID_DMA_ID = DealerMaster.DMA_ID , DNL_HandleDate = getdate()
from DealerMaster where DealerMaster.DMA_SAP_Code = DeliveryNote.DNL_SAPCode
and DeliveryNote.DNL_DealerID_DMA_ID IS NULL and DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL

--����Ʒ�ͺ�
update DeliveryNote set DNL_CFN_ID = CFN.CFN_ID , DNL_HandleDate = getdate()
from CFN where CFN.CFN_CustomerFaceNbr = DeliveryNote.DNL_CFN
and DeliveryNote.DNL_CFN_ID IS NULL and DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL

--���²�Ʒ�ߺͲ�Ʒ���ࣨÿ�ζ�Ҫ���¸��£�
update DeliveryNote set DNL_ProductLine_BUM_ID = CFN.CFN_ProductLine_BUM_ID , DNL_ProductCatagory_PCT_ID = CCF.ClassificationId , DNL_HandleDate = getdate()
from CFN 
inner join CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
where CFN.CFN_ID = DeliveryNote.DNL_CFN_ID
and DeliveryNote.DNL_CFN_ID IS NOT NULL 
--AND DeliveryNote.DNL_ProductLine_BUM_ID IS NULL 
and DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
and ccf.ClassificationId in (select ProducPctId from GC_FN_GetDealerAuthProductSub(DeliveryNote.DNL_DealerID_DMA_ID))

--����BU
UPDATE DeliveryNote SET DNL_BUName = attribute_name
from Lafite_ATTRIBUTE where Id in (
select rootID from Cache_OrganizationUnits 
where attributeID = Convert(varchar(36),DeliveryNote.DNL_ProductLine_BUM_ID))
and ATTRIBUTE_TYPE = 'BU'
and DeliveryNote.DNL_ProductLine_BUM_ID is not null
and DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
	
/*���UPNΪ�������CFN�õ���һ����Ʒ��UPN*/
UPDATE DeliveryNote SET DNL_UPN = 
(SELECT TOP 1 PMA_UPN FROM Product WHERE PMA_CFN_ID = DeliveryNote.DNL_CFN_ID) , DNL_HandleDate = getdate() 
WHERE DeliveryNote.DNL_CFN_ID IS NOT NULL AND DeliveryNote.DNL_UPN IS NULL 
AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL

/*���UPN�Ծ�Ϊ�գ������CFN����*/
UPDATE DeliveryNote SET DNL_UPN = 'UPN.' + DNL_CFN , DNL_HandleDate = getdate() 
WHERE DeliveryNote.DNL_CFN_ID IS NOT NULL AND DeliveryNote.DNL_UPN IS NULL 
AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL	
	
/*���������ڵ�Product*/
INSERT INTO #tmp_product (PMA_ID, PMA_UPN, PMA_CFN_ID) 
SELECT NEWID(), DNL_UPN, DNL_CFN_ID FROM (
SELECT DISTINCT DNL_UPN, DNL_CFN_ID FROM DeliveryNote 
WHERE DeliveryNote.DNL_CFN_ID IS NOT NULL AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
AND NOT EXISTS (SELECT 1 FROM Product 
WHERE Product.PMA_UPN = DeliveryNote.DNL_UPN)) AS a

INSERT INTO Product (PMA_ID, PMA_UPN, PMA_CFN_ID) 
SELECT PMA_ID, PMA_UPN, PMA_CFN_ID FROM #tmp_product

--����Product
update DeliveryNote set DNL_Product_PMA_ID = Product.PMA_ID , DNL_HandleDate = getdate() 
from Product where Product.PMA_UPN = DeliveryNote.DNL_UPN
and DeliveryNote.DNL_UPN IS NOT NULL AND DeliveryNote.DNL_Product_PMA_ID IS NULL
AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL

--��龭������Ȩ-�����Ʒʼ��ΪTrue
update DeliveryNote set DNL_Authorized = 1 , DNL_HandleDate = getdate() 
where DeliveryNote.DNL_DealerID_DMA_ID is not null and DeliveryNote.DNL_ProductCatagory_PCT_ID is not null
and DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
and exists (select 1 from CFN where CFN.CFN_ID = DeliveryNote.DNL_CFN_ID and CFN.CFN_Share = 1)
	
--��龭������Ȩ��ÿ�ζ�Ҫ���¸��£�
update DeliveryNote set DNL_Authorized = 1 , DNL_HandleDate = getdate() 
where DeliveryNote.DNL_DealerID_DMA_ID is not null and DeliveryNote.DNL_ProductCatagory_PCT_ID is not null
and DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL and DeliveryNote.DNL_Authorized = 0
and EXISTS (SELECT  1 FROM DealerAuthorizationTable AS DA
INNER JOIN Cache_PartsClassificationRec AS CP ON CP.PCT_ProductLine_BUM_ID = DA.DAT_ProductLine_BUM_ID
INNER JOIN DealerContract AS DC ON DA.DAT_DCL_ID = DC.DCL_ID
WHERE DA.DAT_DMA_ID = DeliveryNote.DNL_DealerID_DMA_ID
AND CONVERT(varchar(100), GETDATE(), 112) BETWEEN CONVERT(varchar(100), DC.DCL_StartDate, 112) AND CONVERT(varchar(100), DC.DCL_StopDate, 112)
--AND CP.PCT_ProductLine_BUM_ID = DeliveryNote.DNL_ProductLine_BUM_ID
AND (( DA.DAT_PMA_ID = DA.DAT_ProductLine_BUM_ID AND DA.DAT_ProductLine_BUM_ID = DeliveryNote.DNL_ProductLine_BUM_ID)
OR ( DA.DAT_PMA_ID != DA.DAT_ProductLine_BUM_ID AND CP.PCT_ParentClassification_PCT_ID = DA.DAT_PMA_ID
AND CP.PCT_ID = DeliveryNote.DNL_ProductCatagory_PCT_ID) ))

/* ���´�����Ϣ */
UPDATE DeliveryNote SET DNL_ProblemDescription = N'�����̲�����'
WHERE DNL_DealerID_DMA_ID IS NULL and DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL

UPDATE DeliveryNote SET DNL_ProblemDescription = 
(CASE WHEN DNL_ProblemDescription IS NULL THEN N'��Ʒ�ͺŲ�����'
	  ELSE DNL_ProblemDescription + N',��Ʒ�ͺŲ�����' END) 
WHERE DNL_CFN_ID IS NULL and DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL

UPDATE DeliveryNote SET DNL_ProblemDescription = 
(CASE WHEN DNL_ProblemDescription IS NULL THEN N'��Ʒ��δ����'
	  ELSE DNL_ProblemDescription + N',��Ʒ��δ����' END) 
WHERE DNL_CFN_ID IS NOT NULL AND DNL_ProductLine_BUM_ID IS NULL
and DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL

UPDATE DeliveryNote SET DNL_ProblemDescription = N'δ����Ȩ'
WHERE DNL_DealerID_DMA_ID IS NOT NULL AND DNL_CFN_ID IS NOT NULL AND DNL_ProductLine_BUM_ID IS NOT NULL
AND DNL_Authorized = 0 and DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
	
--�����̿�����
update DeliveryNote set DNL_ProblemDescription = N'�뾭���̿����ղ�ƥ��'
where DNL_POReceiptLot_PRL_ID IS NULL and DNL_ProblemDescription is null
and exists (select 1 from DealerMaster where DealerMaster.dma_id = DeliveryNote.DNL_DealerID_DMA_ID
and isnull(DealerMaster.DMA_SystemStartDate,convert(datetime,'2999-01-01')) > DeliveryNote.DNL_ShipmentDate)

--������Ĭ�ϲֿ�
update DeliveryNote set DNL_ProblemDescription = N'������Ĭ�ϲֿⲻ����'
where DNL_POReceiptLot_PRL_ID IS NULL and DNL_ProblemDescription is null
and not exists (select 1 from Warehouse where DeliveryNote.DNL_DealerID_DMA_ID = Warehouse.WHM_DMA_ID
and Warehouse.WHM_ActiveFlag = 1 and Warehouse.WHM_Type = N'DefaultWH')

--�����ջ�����
--Header
INSERT INTO tmpPORImportHeader (ID,SAPCusPONbr,SAPShipmentID,DealerDMAID,SAPShipmentDate,[Status],[Type]
,ProductLineBUMID,VendorDMAID,Carrier,TrackingNo,ShipType,Note,BUName)
SELECT NEWID(),DNL_PONbr,DNL_DeliveryNoteNbr,DNL_DealerID_DMA_ID,DNL_ShipmentDate,'Waiting','PurchaseOrder', 
DNL_ProductLine_BUM_ID,ISNULL(@Vender_DMA_ID,'00000000-0000-0000-0000-000000000000'),Carrier,TrackingNo,ShipType,Note,BUName
FROM (SELECT DNL_PONbr, DNL_DeliveryNoteNbr, DNL_DealerID_DMA_ID, DNL_ShipmentDate,DNL_ProductLine_BUM_ID,
DNL_TrackingNo as TrackingNo,max(DNL_BUName) as BUName,max(DNL_Carrier) as Carrier,max(DNL_ShipType) as ShipType,max(DNL_Note) as Note 
FROM DeliveryNote
WHERE DNL_POReceiptLot_PRL_ID IS NULL and DNL_ProblemDescription is null
--and exists (select 1 from DealerMaster where DealerMaster.dma_id = DeliveryNote.DNL_DealerID_DMA_ID
--and DealerMaster.DMA_SystemStartDate is not null and DealerMaster.DMA_SystemStartDate <= DeliveryNote.DNL_ShipmentDate)
group by DNL_PONbr, DNL_DeliveryNoteNbr, DNL_DealerID_DMA_ID, DNL_ShipmentDate,DNL_ProductLine_BUM_ID,DNL_TrackingNo
) AS Header

--Line
INSERT INTO tmpPORImportLine (LineRecID,PMAID,ReceiptQty,HeaderID,LineNbr)
SELECT NEWID(), Line.DNL_Product_PMA_ID, Line.QTY, tmpPORImportHeader.ID
,row_number() OVER (PARTITION BY DNL_PONbr, DNL_DeliveryNoteNbr, DNL_DealerID_DMA_ID, DNL_ShipmentDate,DNL_ProductLine_BUM_ID,DNL_TrackingNo 
ORDER BY DNL_PONbr, DNL_DeliveryNoteNbr, DNL_DealerID_DMA_ID, DNL_ShipmentDate,DNL_ProductLine_BUM_ID,DNL_TrackingNo,DNL_Product_PMA_ID) LineNbr
FROM (SELECT DNL_PONbr, DNL_DeliveryNoteNbr, DNL_DealerID_DMA_ID, DNL_ShipmentDate,DNL_ProductLine_BUM_ID,DNL_TrackingNo
,DNL_Product_PMA_ID,SUM(DNL_ReceiveQty) AS QTY
FROM DeliveryNote
WHERE DNL_POReceiptLot_PRL_ID IS NULL and DNL_ProblemDescription is null
--and exists (select 1 from DealerMaster where DealerMaster.dma_id = DeliveryNote.DNL_DealerID_DMA_ID
--and DealerMaster.DMA_SystemStartDate is not null and DealerMaster.DMA_SystemStartDate <= DeliveryNote.DNL_ShipmentDate)
group by DNL_PONbr, DNL_DeliveryNoteNbr, DNL_DealerID_DMA_ID, DNL_ShipmentDate,DNL_ProductLine_BUM_ID,DNL_TrackingNo,DNL_Product_PMA_ID) AS Line 
INNER JOIN tmpPORImportHeader 
ON  Line.DNL_PONbr = tmpPORImportHeader.SAPCusPONbr
AND Line.DNL_DeliveryNoteNbr = tmpPORImportHeader.SAPShipmentID 
AND Line.DNL_DealerID_DMA_ID = tmpPORImportHeader.DealerDMAID
AND Line.DNL_ShipmentDate = tmpPORImportHeader.SAPShipmentDate 
AND Line.DNL_ProductLine_BUM_ID = tmpPORImportHeader.ProductLineBUMID
AND Line.DNL_TrackingNo = tmpPORImportHeader.TrackingNo

--Lot                      
INSERT INTO tmpPORImportLot (LotRecID,LineRecID,LotNumber,ReceiptQty,ExpiredDate,WarehouseRecID,DNL_ID)
SELECT NEWID(),tmpPORImportLine.LineRecID,DeliveryNote.DNL_LotNumber,DeliveryNote.DNL_ReceiveQty,DeliveryNote.DNL_ExpiredDate, 
Warehouse.WHM_ID,DeliveryNote.DNL_ID
FROM DeliveryNote,tmpPORImportHeader,tmpPORImportLine,Warehouse
WHERE tmpPORImportHeader.ID = tmpPORImportLine.HeaderID
AND DeliveryNote.DNL_PONbr = tmpPORImportHeader.SAPCusPONbr
AND DeliveryNote.DNL_DeliveryNoteNbr = tmpPORImportHeader.SAPShipmentID 
AND DeliveryNote.DNL_DealerID_DMA_ID = tmpPORImportHeader.DealerDMAID
AND DeliveryNote.DNL_ShipmentDate = tmpPORImportHeader.SAPShipmentDate 
AND DeliveryNote.DNL_ProductLine_BUM_ID = tmpPORImportHeader.ProductLineBUMID
AND DeliveryNote.DNL_TrackingNo = tmpPORImportHeader.TrackingNo
AND DeliveryNote.DNL_Product_PMA_ID = tmpPORImportLine.PMAID
AND DeliveryNote.DNL_DealerID_DMA_ID = Warehouse.WHM_DMA_ID
AND Warehouse.WHM_ActiveFlag = 1 AND Warehouse.WHM_Type = N'DefaultWH' 
AND DNL_POReceiptLot_PRL_ID IS NULL and DNL_ProblemDescription is null
--and exists (select 1 from DealerMaster where DealerMaster.dma_id = DeliveryNote.DNL_DealerID_DMA_ID
--and DealerMaster.DMA_SystemStartDate is not null and DealerMaster.DMA_SystemStartDate <= DeliveryNote.DNL_ShipmentDate)

--���·�������
UPDATE DeliveryNote SET DNL_POReceiptLot_PRL_ID = tmpPORImportLot.LotRecID, DNL_HandleDate = GETDATE()
FROM DeliveryNote INNER JOIN tmpPORImportLot ON DeliveryNote.DNL_ID = tmpPORImportLot.DNL_ID

--���ɵ��ݺ�
DECLARE @DealerDMAID uniqueidentifier
DECLARE @BusinessUnitName nvarchar(20)
DECLARE @ID uniqueidentifier
DECLARE @PONumber nvarchar(50)

DECLARE	curHandlePONumber CURSOR 
FOR SELECT ID,DealerDMAID,BUName,PONumber FROM tmpPORImportHeader
FOR UPDATE of PONumber

OPEN curHandlePONumber
FETCH NEXT FROM curHandlePONumber INTO @ID,@DealerDMAID,@BusinessUnitName,@PONumber

WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		EXEC [GC_GetNextAutoNumber] @DealerDMAID,'Next_POReceiptNbr',@BusinessUnitName, @PONumber output
		UPDATE tmpPORImportHeader
		SET PONumber = @PONumber
		WHERE ID= @ID
	END
	FETCH NEXT FROM curHandlePONumber INTO @ID,@DealerDMAID,@BusinessUnitName,@PONumber
END

CLOSE curHandlePONumber
DEALLOCATE curHandlePONumber

--��������
INSERT INTO POReceiptHeader (PRH_ID, PRH_PONumber, PRH_SAPShipmentID, PRH_Dealer_DMA_ID, PRH_SAPShipmentDate, 
PRH_Status, PRH_Vendor_DMA_ID, PRH_Type, PRH_ProductLine_BUM_ID, PRH_PurchaseOrderNbr,PRH_Carrier,PRH_TrackingNo,PRH_ShipType,PRH_Note)
SELECT ID, PONumber, SAPShipmentID, DealerDMAID, SAPShipmentDate, [Status], VendorDMAID, [Type], ProductLineBUMID, SAPCusPONbr, Carrier,TrackingNo,ShipType,Note 
FROM tmpPORImportHeader

INSERT INTO POReceipt (POR_ID, POR_SAP_PMA_ID, POR_PRH_ID, POR_ReceiptQty, POR_LineNbr, POR_UnitPrice)
SELECT LineRecID, PMAID, HeaderID, ReceiptQty, LineNbr, UnitPrice
FROM tmpPORImportLine

INSERT INTO POReceiptLot (PRL_ID, PRL_POR_ID, PRL_LotNumber, PRL_ReceiptQty, PRL_ExpiredDate, PRL_WHM_ID)
SELECT LotRecID, LineRecID, LotNumber, ReceiptQty, ExpiredDate, WarehouseRecID
FROM tmpPORImportLot

SET @IsValid = 'Success'

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @IsValid = 'Failure'
    return -1
    
END CATCH




GO


