DROP proc [dbo].[GC_ShipmentInit]
GO





CREATE proc [dbo].[GC_ShipmentInit]
   (@UserId uniqueidentifier,
    @IsImport int,
    @IsValid NVARCHAR(20) = 'Success' OUTPUT
    )
 AS
 DECLARE @PmId UNIQUEIDENTIFIER
 DECLARE @ExpData nvarchar(20)
 DECLARE @LotNumber nvarchar(50)
 DECLARE @QrCode nvarchar(20)
 DECLARE @LtmId UNIQUEIDENTIFIER
 DECLARE @SPIID UNIQUEIDENTIFIER
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN


/*�Ƚ������־��Ϊ0*/
Update ShipmentInit set SPI_ErrorFlag=0,SPI_DMA_ID=null,SPI_HOS_ID=null,
SPI_CFN_ID=null,SPI_BUM_ID=null,SPI_WHM_ID=null,SPI_PMA_ID=null,SPI_CAH_ID=NULL
 where SPI_USER=@UserId 
--
Update ShipmentInit SET SPI_ShipmentDate_ErrMsg=NULL
WHERE SPI_USER=@UserId 
--���¾�������Ϣ
Update ShipmentInit set SPI_DMA_ID=Corp_ID
from Lafite_IDENTITY
where Id=@UserId and SPI_USER=@UserId 
--���ҽԺ�Ƿ����
Update ShipmentInit set SPI_HOS_ID=Hospital.HOS_ID,SPI_HospitalCode=HOS_Key_Account
from Hospital
where Hospital.HOS_HospitalName=ShipmentInit.SPI_HospitalName
and SPI_USER=@UserId and ShipmentInit.SPI_HospitalCode_ErrMsg is null

Update ShipmentInit set SPI_HospitalName_ErrMsg='ҽԺ������'
where SPI_HOS_ID is null and SPI_HospitalName_ErrMsg is null and SPI_HospitalName is not null and SPI_USER=@UserId

 --����90��δ�ϴ����������ϱ�����
 Update ShipmentInit SET SPI_ShipmentDate_ErrMsg = '����90��δ�ϴ����������ϱ�����'
 --SELECT * FROM ShipmentInit
where  (select * from dbo.GC_Fn_ShipmentFileUpload(SPI_DMA_ID)) > 0
AND SPI_USER=@UserId

--�����������
Update ShipmentInit set SPI_ShipmentDate_ErrMsg='�������ڲ��ܴ��ڽ���'
where SPI_ShipmentDate_ErrMsg is null and SPI_USER=@UserId and convert(nvarchar(10),SPI_ShipmentDate,121)>GETDATE()

Update ShipmentInit set  SPI_ShipmentDate_ErrMsg='��������Ӧ����'+dbo.fn_GetShipmentMinDate()
where SPI_ShipmentDate_ErrMsg is null and SPI_USER=@UserId and convert(nvarchar(10),SPI_ShipmentDate,121)<dbo.fn_GetShipmentMinDate()




declare @CFN_Property6 int
--����Ʒ�Ƿ����
Update ShipmentInit 
set SPI_CFN_ID=CFN.CFN_ID,
SPI_BUM_ID=CFN_ProductLine_BUM_ID,
SPI_PMA_ID=Product.PMA_ID,SPI_UOM=CFN.CFN_Property3,@CFN_Property6=CFN_Property6
from CFN
INNER JOIN Product ON Product.PMA_CFN_ID = CFN.CFN_ID
where CFN.CFN_CustomerFaceNbr=SPI_ArticleNumber  and SPI_USER=@UserId
and SPI_ArticleNumber_ErrMsg is null

Update ShipmentInit set  SPI_ArticleNumber_ErrMsg='��Ʒ������'
where SPI_ArticleNumber_ErrMsg is null and SPI_USER=@UserId and 
(SPI_CFN_ID is null or SPI_BUM_ID is null or SPI_PMA_ID is null)



--���ֿ��Ƿ����
Update ShipmentInit set SPI_WHM_ID=WHM_ID
from Warehouse
where Warehouse.WHM_Name=ShipmentInit.SPI_Warehouse and SPI_Warehouse_ErrMsg is null and SPI_USER=@UserId
and Warehouse.WHM_DMA_ID=SPI_DMA_ID and Warehouse.WHM_Type<>'SystemHold'

Update ShipmentInit set SPI_Warehouse_ErrMsg='�ֿⲻ���ڻ���ʹ����;��'
where SPI_WHM_ID is null and SPI_Warehouse_ErrMsg is null and SPI_Warehouse is not null and SPI_USER=@UserId

Update ShipmentInit set SPI_SaleType=
(case when WHM_Type='DefaultWH' or WHM_Type='Normal' or WHM_Type='Frozen' then '1'
 when WHM_Type='Consignment' or WHM_Type='LP_Consignment' then '2'
 when WHM_Type='Borrow' or  WHM_Type='LP_Borrow' then '3' else ''  end)
from Warehouse
where  Warehouse.WHM_Name=ShipmentInit.SPI_Warehouse and SPI_Warehouse_ErrMsg is null
and SPI_USER=@UserId
and Warehouse.WHM_DMA_ID=SPI_DMA_ID


--���ҽԺ��Ȩ
UPDATE ShipmentInit SET SPI_HospitalName_ErrMsg = '��ǰҽԺδ��Ȩ'
WHERE SPI_USER = @UserId AND SPI_HospitalName_ErrMsg IS NULL 
AND SPI_ShipmentDate IS NOT NULL
AND SPI_DMA_ID IS NOT NULL
AND SPI_BUM_ID IS NOT NULL
AND SPI_HOS_ID IS NOT NULL
AND NOT EXISTS(
		SELECT 1 FROM DealerAuthorizationTable DA
				INNER JOIN HospitalList ON DA.DAT_ID = HospitalList.HLA_DAT_ID
				INNER JOIN Hospital ON HospitalList.HLA_HOS_ID = Hospital.HOS_ID
				WHERE DA.DAT_DMA_ID = ShipmentInit.SPI_DMA_ID 
				AND DA.DAT_ProductLine_BUM_ID = ShipmentInit.SPI_BUM_ID
				AND DA.DAT_Type IN ('Normal','Temp','Shipment')
				AND CONVERT(NVARCHAR(100), CONVERT(DATETIME,ShipmentInit.SPI_ShipmentDate), 112)
				BETWEEN CONVERT(NVARCHAR(100), HLA_StartDate, 112)
				AND CONVERT(NVARCHAR(100), HLA_EndDate, 112)
				AND Hospital.HOS_ID = SPI_HOS_ID 
				AND Hospital.Hos_ActiveFlag = 1
				AND Hospital.HOS_DeletedFlag = 0
		)	
		
--TODO: ����Ʒ��Ȩ
CREATE TABLE #AuthTemp
(
	DealerId UNIQUEIDENTIFIER,
	BumId UNIQUEIDENTIFIER,
	AuthCount INT
)

INSERT INTO #AuthTemp
SELECT DAT_DMA_ID,DAT_ProductLine_BUM_ID,COUNT(1) FROM DealerAuthorizationTable 
WHERE EXISTS(
	SELECT SPI_DMA_ID,SPI_BUM_ID FROM ShipmentInit
	WHERE SPI_USER = @UserId
	AND SPI_DMA_ID IS NOT NULL
	AND SPI_CFN_ID IS NOT NULL 
	AND SPI_BUM_ID IS NOT NULL
	AND DAT_DMA_ID = SPI_DMA_ID
	AND DAT_ProductLine_BUM_ID = SPI_BUM_ID
)
AND DAT_Type = 'Shipment'
GROUP BY DAT_DMA_ID,DAT_ProductLine_BUM_ID

UPDATE ShipmentInit SET SPI_ArticleNumber_ErrMsg = '��ǰ��Ʒδ��Ȩ' FROM CFN
WHERE SPI_USER = @UserId 
AND SPI_CFN_ID IS NOT NULL 
AND SPI_ArticleNumber_ErrMsg IS NULL 
AND SPI_HOS_ID IS NOT NULL
AND SPI_BUM_ID IS NOT NULL
AND SPI_DMA_ID IS NOT NULL
AND SPI_CFN_ID = CFN_ID
AND NOT EXISTS(
		SELECT 1 FROM DealerAuthorizationTable DA
				INNER JOIN HospitalList ON DA.DAT_ID = HospitalList.HLA_DAT_ID
				INNER JOIN Cache_PartsClassificationRec CP ON PCT_ProductLine_BUM_ID = DA.DAT_ProductLine_BUM_ID
				
				INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
				
				WHERE DA.DAT_DMA_ID = ShipmentInit.SPI_DMA_ID 
				AND DA.DAT_ProductLine_BUM_ID = ShipmentInit.SPI_BUM_ID
				AND DA.DAT_Type IN ('Normal','Temp','Shipment')
				AND 
				(
					(
						DA.DAT_Type = 'Shipment' 
						AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),CONVERT(DATETIME,ShipmentInit.SPI_ShipmentDate),120)) 
						BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,CONVERT(DATETIME,ShipmentInit.SPI_ShipmentDate)))
					)
					OR 
					(
						--����������Ȩ��Ʒ����Shipment������Ȩ����ô���ԡ�Normal���͡�Temp��ֻ��Shipment������Ȩ
						ISNULL((SELECT AuthCount FROM #AuthTemp WHERE BumId = DAT_ProductLine_BUM_ID AND DealerId = DAT_DMA_ID),0) = 0 
						AND (DA.DAT_Type IN ('Normal','Temp') AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),CONVERT(DATETIME,ShipmentInit.SPI_ShipmentDate),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,CONVERT(DATETIME,ShipmentInit.SPI_ShipmentDate))))
					)
				)
				AND
				(
					(
						DA.DAT_PMA_ID = DA.DAT_ProductLine_BUM_ID 
						AND DA.DAT_ProductLine_BUM_ID = CFN.CFN_ProductLine_BUM_ID
					)
					OR
					(
						DA.DAT_PMA_ID != DA.DAT_ProductLine_BUM_ID
						AND CP.PCT_ParentClassification_PCT_ID = DA.DAT_PMA_ID
						AND CP.PCT_ID = CCF.ClassificationId
					)
				)
				AND CFN.CFN_ProductLine_BUM_ID = ShipmentInit.SPI_BUM_ID
				AND CFN_DeletedFlag = 0
				AND HLA_HOS_ID = SPI_HOS_ID
				AND CONVERT(NVARCHAR(100), CONVERT(DATETIME,ShipmentInit.SPI_ShipmentDate), 112)
				BETWEEN CONVERT(NVARCHAR(100), HLA_StartDate, 112)
				AND CONVERT(NVARCHAR(100), HLA_EndDate, 112)
		)

--У���ά��
UPDATE ShipmentInit SET SPI_QrCode_ErrMsg='������д��ά��' WHERE SPI_USER=@UserId  AND SPI_QrCode=''

--��ȫ������ΪNULL����ֹ�޸���ϸ��ԭ�ȵ�LTMID�����������Ƕ�ά�������û�и��µ�����
update ShipmentInit set SPI_LTM_ID = null where SPI_USER=@UserId

--���²�Ʒ��Ч��
Update ShipmentInit set SPI_ExpiredDate=convert(nvarchar(10),LTM_ExpiredDate,121),
 SPI_LTM_ID=LTM_ID
from Inventory,Lot,LotMaster
where SPI_USER=@UserId 
and SPI_WHM_ID = INV_WHM_ID 
and INV_ID = LOT_INV_ID
and LOT_LTM_ID =LTM_ID
and LTM_LotNumber= SPI_LotNumber + '@@' + SPI_QrCode

-- ������к��Ƿ����
--Update ShipmentInit set SPI_LotNumber_ErrMsg='���кŲ�����'
--where SPI_LotNumber_ErrMsg is null and SPI_USER=@UserId and  SPI_LTM_ID is null


UPDATE ShipmentInit SET SPI_QrCode_ErrMsg='���кŻ��ά�벻����',SPI_LotNumber_ErrMsg ='���кŻ��ά�벻����'
WHERE SPI_USER=@UserId AND SPI_LTM_ID is null

update spi
set  SPI_QrCode_ErrMsg = '�˲ֿ�Ķ�ά�벻��ΪNoQR'
--select *
from ShipmentInit spi,Warehouse
where SPI_WHM_ID = WHM_ID
and WHM_Type not in  ('Normal','Frozen')
and WHM_Code not like '%NoQR%'
and SPI_QrCode='NoQR'
and SPI_USER=@UserId
and SPI_QrCode_ErrMsg is null

--not exists(
--select 1 from V_LotMaster where
--     V_LotMaster.LTM_QrCode=ShipmentInit.SPI_QrCode
--     and V_LotMaster.LTM_LotNumber=ShipmentInit.SPI_LOtNumber
--     and SPI_USER=@UserId) AND SPI_QrCode!='NoQR'
     
 UPDATE   ShipmentInit SET SPI_Qty_ErrMsg='����ά��Ĳ�Ʒ�������ô���1' WHERE SPI_USER=@UserId 
  and convert(float,SPI_Qty)>1  and SPI_USER=@UserId AND SPI_QrCode!='NoQR'
     
     --�鿴��ʷ���ε������Ƿ�����ύ������
    --;WITH T AS 
    --(
    --select sum(ShipmentLot.SLT_LOtShippedQty) as 
    --SumQty,LTM_LotNumber 
    --from ShipmentHeader,ShipmentLine,ShipmentLot,Lot,LotMaster where 
    -- ShipmentHeader.SPH_ID=ShipmentLine.SPL_SPH_ID 
    -- and ShipmentHeader.SPH_Status='Complete' 
    -- and ShipmentLot.SLT_SPL_ID=ShipmentLine.SPL_ID
    -- and isnull(ShipmentLot.SLT_QRLOT_ID,ShipmentLot.SLT_LOT_ID)=Lot.Lot_id
    -- and LOT_LTM_ID=LotMaster.LTM_ID
    -- group by LotMaster.LTM_LotNumber
    --)
    -- UPDATE ShipmentInit SET SPI_Qty_ErrMsg='�����β�Ʒ��������'
    -- from T
    --  where T.LTM_LotNumber = spi_LotNumber+'@@' + SPI_QrCode
    --  and SumQty + convert(float,spi_Qty)> 1
    -- and spi_user = @UserId
    -- and spi_QrCode!='NoQR'


-- DECLARE
--      ShpCursor CURSOR FOR (select distinct SPI_ID  SPI_PMA_ID,  SPI_LotNumber=SPI_LotNumber+'@@'+SPI_QrCode,SPI_ExpiredDate
--       from ShipmentInit where SPI_USER=@UserId and SPI_LTM_ID is not null)
--      OPEN ShpCursor;--���α�
--      FETCH NEXT FROM ShpCursor INTO @SPIID, @PmId ,@LotNumber ,@ExpData
--      WHILE @@FETCH_STATUS = 0
--  BEGIN
--    SELECT * FROM 
-- FETCH NEXT FROM ShpCursor INTO @PmId ,@LotNumber ,@ExpData
--  END
--     CLOSE ShpCursor; --����α�ر��α�
--	DEALLOCATE ShpCursor; --�ͷ��α�
	


 --��Ч��Ӧ������������
--Update ShipmentInit set SPI_LotShipmentDate_ErrMsg='����д��Ч�ڲ�Ʒ����������'
--where dbo.fn_GetEnabledFlag(@CFN_Property6,SPI_ExpiredDate,SPI_ShipmentDate)=N'��'
--and SPI_USER=@UserId  and SPI_ShipmentDate_ErrMsg is null
--and SPI_LotShipmentDate is null

--Update ShipmentInit set SPI_Remark_ErrMsg='����д��Ч�ڲ�Ʒ�ı�ע'
--where dbo.fn_GetEnabledFlag(@CFN_Property6,SPI_ExpiredDate,SPI_ShipmentDate)=N'��'
--and SPI_USER=@UserId  and SPI_ShipmentDate_ErrMsg is null
--and SPI_Remark is null

Update t1 set  SPI_ShipmentDate_ErrMsg='��Ʒ��Ч�ڲ���С���������ڣ�'
FROM ShipmentInit t1,CFN t2
where SPI_ShipmentDate_ErrMsg is null and t1.SPI_CFN_ID = t2.CFN_ID
and SPI_USER=@UserId 
and CASE WHEN t2.CFN_Property6 = 0 then dateadd(month, datediff(month, 0, dateadd(month,1,SPI_ExpiredDate)), 0)
                                    ELSE dateadd(day,1,SPI_ExpiredDate) END <= SPI_ShipmentDate 
   

Update t1 set  SPI_ShipmentDate_ErrMsg='��Ʒ��Ч��С�ڵ�ǰ��������Ӹ���,����ҳ���ϲ�����'
FROM ShipmentInit t1,CFN t2
where SPI_ShipmentDate_ErrMsg is null and t1.SPI_CFN_ID = t2.CFN_ID
and SPI_USER=@UserId 
and CASE WHEN t2.CFN_Property6 = 0 then dateadd(month, datediff(month, 0, dateadd(month,1,SPI_ExpiredDate)), 0)
                                    ELSE dateadd(day,1,SPI_ExpiredDate) END < getdate()

--������������Ƿ���ȷ
--Update ShipmentInit set SPI_Qty_ErrMsg='���������д�'
--from Product
--where SPI_Qty_ErrMsg is null and SPI_USER=@UserId and
--  Product.PMA_ID=SPI_PMA_ID and
-- Product.PMA_ConvertFactor*convert(decimal(18,6),SPI_Qty)
-- <>FLOOR(Product.PMA_ConvertFactor*convert(decimal(18,6),SPI_Qty))
 
--������������ڲֿ����Ƿ����
	Update ShipmentInit SET SPI_LotNumber_ErrMsg=N'�����β�Ʒ�����ڲֿ���'	
	Where SPI_LotNumber_ErrMsg is null and SPI_USER=@UserId
	and not exists (select 1 from Lot inner join Inventory inv on INV_ID=LOT_INV_ID
	where LOT_LTM_ID=SPI_LTM_ID and INV_WHM_ID=SPI_WHM_ID
	and INV_PMA_ID=SPI_PMA_ID)

	--������������ڲֿ��������Ƿ��㹻
	UPDATE ShipmentInit SET SPI_Qty_ErrMsg = N'�����β�Ʒ�ڲֿ�����������'
	FROM (SELECT SPI_WHM_ID,SPI_PMA_ID,
	SPI_LTM_ID,SUM(convert(decimal(18,6),SPI_Qty)) AS 
	SNL_LotQty, MAX(Lot.LOT_OnHandQty) AS LOT_OnHandQty 
	FROM ShipmentInit
	INNER JOIN Lot ON Lot.LOT_LTM_ID = SPI_LTM_ID 
	INNER JOIN Inventory INV ON INV.INV_ID = Lot.LOT_INV_ID AND 
	INV.INV_WHM_ID = SPI_WHM_ID
	AND INV.INV_PMA_ID = SPI_PMA_ID
	WHERE SPI_Qty_ErrMsg IS NULL and SPI_USER=@UserId
	GROUP BY SPI_WHM_ID,SPI_PMA_ID,SPI_LTM_ID) AS T
	WHERE ShipmentInit.SPI_Qty_ErrMsg IS NULL AND ShipmentInit.SPI_USER = @UserId
	AND T.SPI_WHM_ID = ShipmentInit.SPI_WHM_ID 
	AND T.SPI_PMA_ID = ShipmentInit.SPI_PMA_ID 
	AND T.SPI_LTM_ID = ShipmentInit.SPI_LTM_ID
	AND T.LOT_OnHandQty - T.SNL_LotQty < 0

--����ά���Ƿ�����ʷ�����г��ֹ�
UPDATE ShipmentInit SET SPI_QrCode_ErrMsg=N'��ά���Ѿ�ʹ�ù�'
where SPI_USER = @UserId
AND exists(SELECT 1 FROM ShipmentHeader inner join ShipmentLine on 
                ShipmentHeader.SPH_ID=ShipmentLine.SPL_SPH_ID
                inner join ShipmentLot on ShipmentLine.SPL_ID=ShipmentLot.SLT_SPL_ID
                inner join Lot on ISNULL(ShipmentLot.SLT_QRLOT_ID,ShipmentLot.SLT_LOT_ID)=Lot.LOT_ID
                 inner join LotMaster on LotMaster.LTM_ID=Lot.LOT_LTM_ID
                 WHERE ShipmentInit.SPI_DMA_ID=ShipmentHeader.SPH_Dealer_DMA_ID 
				 AND ShipmentHeader.SPH_Status='Complete' 
				
				 AND (ShipmentInit.SPI_QrCode=CASE WHEN CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) > 0 
												THEN substring(LotMaster.LTM_LotNumber, CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) + 2, LEN(LotMaster.LTM_LotNumber) - CHARINDEX('@@', LotMaster.LTM_LotNumber, 0)) 
											ELSE 'NoQR' END) 
				AND CASE WHEN CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) > 0 
								THEN substring(LotMaster.LTM_LotNumber, CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) + 2, LEN(LotMaster.LTM_LotNumber) - CHARINDEX('@@', LotMaster.LTM_LotNumber, 0)) 
							ELSE 'NoQR' END <> 'NoQR'
                group by ISNULL(ShipmentLot.SLT_QRLOT_ID,ShipmentLot.SLT_LOT_ID) HAVING  SUM(ISNULL(ShipmentLot.SLT_LotShippedQty,0))+ISNULL(ShipmentInit.SPI_Qty,0)>1)
--��Ʒ�۸񾯸�
--if @IsImport=0
--Update ShipmentInit set SPI_Price_ErrMsg='����:���ۼ۵��ڲ�Ʒ�۵�10%'
--where SPI_Price/interface.fn_GetPurchasePrice(SPI_CFN_ID,SPI_SaleType) <0.1
	
/*** --------------------CRMҽԺ�����ظ�UPN&Lot����---------------------***/
	UPDATE ShipmentInit SET SPI_Qty_ErrMsg = N'�����кŵĲ�Ʒֻ��������һ��'
	FROM 
	(SELECT SPI_PMA_ID,SPI_LTM_ID,SUM(convert(decimal(18,6),SPI_Qty)) AS SNL_LotQty
		FROM ShipmentInit
		WHERE SPI_Qty_ErrMsg IS NULL and SPI_USER=@UserId
		and SPI_BUM_ID='97a4e135-74c7-4802-af23-9d6d00fcb2cc' and SPI_ArticleNumber not like '66%' 
		GROUP BY SPI_PMA_ID,SPI_LTM_ID) 
	AS T
	WHERE ShipmentInit.SPI_Qty_ErrMsg IS NULL AND ShipmentInit.SPI_USER = @UserId
	AND T.SPI_PMA_ID = ShipmentInit.SPI_PMA_ID 
	AND T.SPI_LTM_ID = ShipmentInit.SPI_LTM_ID
	AND T.SNL_LotQty>1
	
	Update ShipmentInit set SPI_Qty_ErrMsg='�����кŵĲ�Ʒ�Ѿ����۹�'
	where SPI_Qty_ErrMsg IS NULL and SPI_USER=@UserId
	and dbo.fn_GetCanShipFlag(@CFN_Property6,SPI_LotNumber,SPI_ArticleNumber,SPI_DMA_ID)=N'��'
	
/*** ----------------------------------End---------------------------------------***/

/*** --------------------���ڼ������뵥---------------------***/
Update ShipmentInit SET SPI_ConsignmentNbr_ErrMsg = '���ڼ������뵥�Ų�����'
where not exists (select 1 from ConsignmentApplyHeader where SPI_ConsignmentNbr = CAH_OrderNo)
and isnull(SPI_ConsignmentNbr ,'') <> ''

Update ShipmentInit set SPI_CAH_ID = CAH_ID
from ConsignmentApplyHeader
where CAH_OrderNo = SPI_ConsignmentNbr
and SPI_ConsignmentNbr_ErrMsg is null

Update ShipmentInit set SPI_CAH_ID = CAH_ID
--select *
FROM Warehouse,ConsignmentApplyHeader,ConsignmentApplyDetails,PurchaseOrderHeader,PurchaseOrderDetail,POReceiptHeader,POReceipt,POReceiptLot
where SPI_WHM_ID = WHM_ID
		and CAH_ID = CAD_CAH_ID
		and WHM_Type in ('Borrow','LP_Borrow')
		and CAH_OrderNo = POD_ShipmentNbr
        and CAH_CAH_ID is null
        and POD_POH_ID = POH_ID
        and POH_OrderNo = PRH_PurchaseOrderNbr
        and PRH_ID = POR_PRH_ID
        and POR_ID = PRL_POR_ID
        and SPI_USER= @UserId
        and SPI_CFN_ID = POD_CFN_ID
        and SPI_DMA_ID = CAH_DMA_ID
        and CAH_DMA_ID = POH_DMA_ID
        and SPI_BUM_ID = CAH_ProductLine_Id
        and SPI_LotNumber = PRL_LotNumber
        and isnull(SPI_ConsignmentNbr ,'') = ''
        and SPI_ConsignmentNbr_ErrMsg is null
        
        

--����Ǻ캣�û��Ҳ�Ʒ��ΪEndo�ж����������Ƿ���6���������ڣ������6���������ڵ���Ϊ�ϸ������һ��lijie add
IF(@IsImport=0)
BEGIN
UPDATE ShipmentInit set 
SPI_ShipmentDate=(select   CONVERT(VARCHAR(10),
(dateadd(dd,-day(getdate()),convert(nvarchar(100),getdate(),23))),120)),SPI_ShipmentDate_ErrMsg='���ݲ������ߣ�Endo�캣�����̵��µ�6��������֮ǰ�����ύ���µ�ҽԺ����������ϵͳ�Զ�����д��ʱ�䣺'+SPI_ShipmentDate+'�޸�Ϊ�������һ�졣'
 WHERE SPI_BUM_ID='8f15d92a-47e4-462f-a603-f61983d61b7b'
AND (select count(*) from CalendarDate where CDD_Calendar 
= (select convert(nvarchar(6),getdate(),112)) and CDD_Calendar+ 
RIGHT (REPLICATE ('0', 2) + convert(nvarchar(2),CDD_Date1),2) >=(select convert(nvarchar(8),CONVERT(datetime,SPI_ShipmentDate),112)))>0
AND (EXISTS(SELECT 1 FROM DealerMaster WHERE ShipmentInit.SPI_DMA_ID=DealerMaster.DMA_ID AND DMA_DealerType='T1')
or EXISTS(select  1
      from DealerMaster a inner join DealerMaster b
      on a.DMA_Parent_DMA_ID=b.DMA_ID
      where a.DMA_ID=ShipmentInit.SPI_DMA_ID AND a.DMA_DealerType='T2' AND b.DMA_Taxpayer='�캣')
)
AND MONTH(CONVERT(datetime,SPI_ShipmentDate))>=MONTH(CONVERT(datetime,GETDATE()))
AND SPI_USER=@UserId
END
ELSE
  BEGIN
 UPDATE ShipmentInit set 
   SPI_ShipmentDate=(select   CONVERT(VARCHAR(10),
   (dateadd(dd,-day(getdate()),convert(nvarchar(100),getdate(),23))),120))
 WHERE SPI_BUM_ID='8f15d92a-47e4-462f-a603-f61983d61b7b'
AND (select count(*) from CalendarDate where CDD_Calendar 
= (select convert(nvarchar(6),getdate(),112)) and CDD_Calendar+ 
RIGHT (REPLICATE ('0', 2) + convert(nvarchar(2),CDD_Date1),2) >=(select convert(nvarchar(8),CONVERT(datetime,SPI_ShipmentDate),112)))>0
AND (EXISTS(SELECT 1 FROM DealerMaster WHERE ShipmentInit.SPI_DMA_ID=DealerMaster.DMA_ID AND DMA_DealerType='T1')
or EXISTS(select  1
      from DealerMaster a inner join DealerMaster b
      on a.DMA_Parent_DMA_ID=b.DMA_ID
      where a.DMA_ID=ShipmentInit.SPI_DMA_ID AND a.DMA_DealerType='T2' AND b.DMA_Taxpayer='�캣')
      )
      AND MONTH(CONVERT(datetime,SPI_ShipmentDate))>=MONTH(CONVERT(datetime,GETDATE()))
      AND SPI_USER=@UserId
 END


 
/*** ----------------------------------End---------------------------------------***/

Update ShipmentInit Set SPI_ErrorFlag=1
where SPI_USER=@UserId
and (SPI_HospitalName_ErrMsg is not null or SPI_ShipmentDate_ErrMsg is not null or
SPI_ArticleNumber_ErrMsg is not null or SPI_LotNumber_ErrMsg is not null or
SPI_Qty_ErrMsg is not null or SPI_Price_ErrMsg is not null or SPI_InvoiceDate_ErrMsg is not null
or SPI_LotShipmentDate_ErrMsg is not null or SPI_Remark_ErrMsg is not null or SPI_QrCode_ErrMsg is not null)



IF (SELECT COUNT(*) FROM ShipmentInit WHERE SPI_ErrorFlag = 1 AND SPI_USER = @UserId) > 0
	BEGIN
		/*������ڴ����򷵻�Error*/
		SET @IsValid = 'Error'
	END
ELSE
  BEGIN
  --�ж������Ƿ����,���������������
--  if @IsImport=1
 
--  begin transaction
--  begin try
-- DECLARE
--      ShpCursor CURSOR FOR (select distinct SPI_ID  SPI_PMA_ID,  SPI_LotNumber=SPI_LotNumber+'@@'+SPI_QrCode,SPI_ExpiredDate
--       from ShipmentInit where SPI_USER=@UserId and SPI_LTM_ID is null)
--      OPEN ShpCursor;--���α�
--      FETCH NEXT FROM ShpCursor INTO @SPIID, @PmId ,@LotNumber ,@ExpData
--      WHILE @@FETCH_STATUS = 0
--  BEGIN
--     SELECT @LtmId= NEWID();
--insert into LotMaster(LTM_ID,LTM_LotNumber,LTM_ExpiredDate,LTM_Product_PMA_ID,LTM_CreatedDate) 
--values(@LtmId,@LotNumber,@ExpData,@PmId,GETDATE())
 
--UPDATE ShipmentInit SET SPI_LTM_ID=@LtmId WHERE SPI_ID=@SPIID
-- FETCH NEXT FROM ShpCursor INTO @PmId ,@LotNumber ,@ExpData
--  END
--     CLOSE ShpCursor; --����α�ر��α�
--	DEALLOCATE ShpCursor; --�ͷ��α�
	
-- commit transaction
-- SET @IsValid = 'Success'
--  end try
--  begin catch
--  rollback transaction
-- SET @IsValid = 'Failure'
-- return -1
-- end catch 
  SET @IsValid = 'Success'
 
end

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @IsValid = 'Failure'
    
    --��¼������־��ʼ
	
	
	return -1
END CATCH






GO


