DROP Procedure [dbo].[GC_InventoryReturnConsignmentInit]
GO



/*
��������
*/
CREATE Procedure [dbo].[GC_InventoryReturnConsignmentInit]
    @UserId uniqueidentifier,
    @ImportType NVARCHAR(20),   
    @IsValid NVARCHAR(20) = 'Success' OUTPUT
AS
		
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

Declare @DealerID uniqueidentifier
Declare @DealerType nvarchar(5)
Declare @AdjustHeaderId uniqueidentifier

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
   primary key (IAH_ID)
)

create table #mmbo_InventoryAdjustDetail (
   IAD_Quantity         float     not null,
   IAD_ID				uniqueidentifier     not null,
   IAD_PMA_ID			uniqueidentifier     not null,
   IAD_IAH_ID			uniqueidentifier        null,
   IAD_LineNbr          int        null,
   IAD_LOT_ID			uniqueidentifier NULL,
   IAD_LOT_Number		nvarchar(50) collate Chinese_PRC_CI_AS  null,
   IAD_WHM_ID			uniqueidentifier NULL,
   IAD_BUM_ID			uniqueidentifier NULL,
   IAD_ExpiredDate		datetime null,
   IAD_PRH_ID			uniqueidentifier NULL,
    primary key (IAD_ID)
)

/*�Ƚ������־��Ϊ0*/
UPDATE InventoryReturnConsignmentInit SET IRC_ErrorFlag = 0,IRC_ReturnQty_ErrMsg= null WHERE IRC_USER = @UserId

--��龭�����Ƿ����
UPDATE InventoryReturnConsignmentInit SET IRC_ErrorFlag = 1, IRC_ErrorDescription =  N'�����̲�����'
WHERE IRC_USER = @UserId
and IRC_DMA_ID is null

--��ȡ������
Select top 1 @DealerID=  IRC_DMA_ID from InventoryReturnConsignmentInit WHERE IRC_USER = @UserId
select @DealerType=  DMA_DealerType from DealerMaster where DMA_ID = @DealerID

--���ֿ��Ƿ����
UPDATE InventoryReturnConsignmentInit SET IRC_WHM_ID = WHM_ID
FROM Warehouse WHERE WHM_Name = IRC_Warehouse
AND WHM_DMA_ID = @DealerID
AND IRC_USER = @UserId

UPDATE InventoryReturnConsignmentInit SET IRC_ErrorFlag = 1, IRC_Warehouse_ErrMsg = N'�ֿⲻ����,'
WHERE IRC_WHM_ID IS NULL AND IRC_USER = @UserId AND IRC_Warehouse_ErrMsg IS NULL

--����Ʒ�Ƿ����
UPDATE InventoryReturnConsignmentInit SET IRC_CFN_ID = CFN_ID
FROM CFN WHERE CFN_CustomerFaceNbr = IRC_ArticleNumber
AND IRC_USER = @UserId

UPDATE InventoryReturnConsignmentInit SET IRC_ErrorFlag = 1, IRC_ArticleNumber_ErrMsg = N'��Ʒ������,'
WHERE IRC_CFN_ID IS NULL AND IRC_USER = @UserId AND IRC_ArticleNumber_ErrMsg IS NULL

--����Ʒ�Ƿ��ѷ��ࣨ�Ƿ��Ӧ��Ʒ�ߣ�
UPDATE IRI SET IRC_BUM_ID = (CASE WHEN CFNS_BUM_ID IS NULL THEN CFN_ProductLine_BUM_ID ELSE CFNS_BUM_ID END)
FROM InventoryReturnConsignmentInit IRI inner join CFN on CFN_ID = IRC_CFN_ID 
left join CFNSHARE on CFN_ID = CFNS_CFN_ID AND CFNS_PROPERTY1 = 1
WHERE IRC_CFN_ID IS NOT NULL
AND IRC_USER = @UserId

UPDATE InventoryReturnConsignmentInit SET IRC_ErrorFlag = 1, IRC_ArticleNumber_ErrMsg =  N'��Ʒδ����(�޶�Ӧ��Ʒ��),'
WHERE IRC_BUM_ID IS NULL AND IRC_USER = @UserId AND IRC_ArticleNumber_ErrMsg IS NULL


--����Ʒ�����Ƿ���Ⱥ
UPDATE InventoryReturnConsignmentInit SET IRC_ErrorFlag = 1, IRC_LotNumber_ErrMsg = N'��Ʒ���Ų�����,'
WHERE (IRC_LotNumber IS NOT NULL OR  IRC_LotNumber<>'')
  AND IRC_USER = @UserId 
  AND IRC_LotNumber_ErrMsg IS NULL
  AND IRC_ArticleNumber_ErrMsg IS NULL
  AND Not Exists 
  (SELECT 1
     FROM cfn t1, Product t2, LotMaster t3
    WHERE  t1.CFN_ID = t2.PMA_CFN_ID
       AND t2.PMA_ID = t3.LTM_Product_PMA_ID
       AND t3.LTM_LotNumber = InventoryReturnConsignmentInit.IRC_LotNumber and t1.CFN_CustomerFaceNbr = InventoryReturnConsignmentInit.IRC_ArticleNumber
   )



--���û����д�����ţ��Զ���ȡ�����һ�Ŷ�����
update IRC
set IRC.IRC_PurchaseOrderNbr = (select top 1 PRH_PurchaseOrderNbr from POReceiptHeader t1 ,POReceipt t2,POReceiptLot t3,Product t4
where t1.PRH_ID = t2.POR_PRH_ID
and t2.POR_ID = t3.PRL_POR_ID
and t2.POR_SAP_PMA_ID = t4.PMA_ID
and t3.PRL_LotNumber=IRC.IRC_LotNumber
and t4.PMA_UPN = IRC.IRC_ArticleNumber
and t1.PRH_Dealer_DMA_ID = @DealerID
order by t1.PRH_ReceiptDate desc
) 
from InventoryReturnConsignmentInit IRC
where IRC_CFN_ID is not null
and IRC_PurchaseOrderNbr is null

--��鶩�����Ƿ����
UPDATE InventoryReturnConsignmentInit SET IRC_PRH_ID = PRH_ID
FROM POReceiptHeader WHERE PRH_PurchaseOrderNbr = IRC_PurchaseOrderNbr
AND IRC_USER = @UserId

UPDATE InventoryReturnConsignmentInit SET IRC_ErrorFlag = 1, IRC_PurchaseOrderNbr_ErrMsg = N'�����Ų�����,'
WHERE IRC_PurchaseOrderNbr IS NOT NULL AND IRC_PRH_ID IS NULL 
AND IRC_USER = @UserId AND IRC_PurchaseOrderNbr_ErrMsg IS NULL

--У��ֿ����Ƿ��в�Ʒ����
update t1
set t1.IRC_ArticleNumber_ErrMsg = N'�òֿ��в����ڴ˲�Ʒ'
from InventoryReturnConsignmentInit t1
left join Product on IRC_CFN_ID = PMA_CFN_ID
left join Inventory on IRC_WHM_ID = INV_WHM_ID and INV_PMA_ID = PMA_ID
where IRC_USER=@UserId
and INV_ID is null
and IRC_ArticleNumber_ErrMsg is null

--У���Ƿ�����ظ�����ͬ���ŵĲ�Ʒ
update t1
set t1.IRC_LotNumber_ErrMsg = N'�õ�������ͬ�ֿ���ͬ���Ų�Ʒ�����ظ�'
from InventoryReturnConsignmentInit t1
where IRC_USER = @UserId
  and IRC_LotNumber_ErrMsg is null
  and exists (
select 1 from (
select IRC_CFN_ID, IRC_DMA_ID , IRC_WHM_ID, IRC_LotNumber
from InventoryReturnConsignmentInit t1
left join Product on IRC_CFN_ID = PMA_CFN_ID
left join Inventory on IRC_WHM_ID = INV_WHM_ID and INV_PMA_ID = PMA_ID
where IRC_USER = @UserId
and INV_ID is not null
and IRC_LotNumber_ErrMsg is null
group by IRC_CFN_ID, IRC_DMA_ID , IRC_WHM_ID, IRC_LotNumber having COUNT(*)>1
) tab where tab.IRC_CFN_ID= t1.IRC_CFN_ID and tab.IRC_DMA_ID=t1.IRC_DMA_ID and tab.IRC_LotNumber=t1.IRC_LotNumber and tab.IRC_WHM_ID=t1.IRC_WHM_ID
)

--У���˻�����
Update InventoryReturnConsignmentInit set IRC_ErrorFlag = 1, IRC_ReturnQty_ErrMsg = N'�������С���˻�����,'
from 
(select IRC_USER,IRC_ArticleNumber,IRC_LotNumber,sum(convert(decimal(18,6),IRC_ReturnQty)) as ReturnQty,
	IRC_DMA_ID,IRC_CFN_ID,IRC_BUM_ID,IRC_PRH_ID 
	from InventoryReturnConsignmentInit
	where IRC_USER = @UserId
	group by IRC_USER,IRC_ArticleNumber,IRC_LotNumber,IRC_DMA_ID,IRC_CFN_ID,IRC_BUM_ID,IRC_PRH_ID
	) t1,Product t2,Inventory t3,LotMaster t4,Lot t5,POReceiptHeader t6
where InventoryReturnConsignmentInit.IRC_USER = t1.IRC_USER
and InventoryReturnConsignmentInit.IRC_ArticleNumber = t1.IRC_ArticleNumber
and InventoryReturnConsignmentInit.IRC_LotNumber = t1.IRC_LotNumber
and InventoryReturnConsignmentInit.IRC_PRH_ID = t6.PRH_ID
and t1.IRC_CFN_ID = t2.PMA_CFN_ID
and t6.PRH_WHM_ID = t3.INV_WHM_ID
and t3.INV_PMA_ID = t2.PMA_ID
and t2.PMA_ID = t4.LTM_Product_PMA_ID
and t4.LTM_ID = t5.LOT_LTM_ID
and t5.LOT_INV_ID = t3.INV_ID
and t1.IRC_LotNumber = t4.LTM_LotNumber
and t1.ReturnQty > t5.LOT_OnHandQty

Update InventoryReturnConsignmentInit set IRC_ErrorFlag = 1, IRC_ReturnQty_ErrMsg = N'�˻��������ܴ���1'
from  (select IRC_USER,IRC_ArticleNumber,IRC_LotNumber,sum(convert(decimal(18,6),IRC_ReturnQty)) as ReturnQty,
	IRC_DMA_ID,IRC_CFN_ID,IRC_BUM_ID,IRC_PRH_ID 
	from InventoryReturnConsignmentInit
	where IRC_USER = @UserId
	group by IRC_USER,IRC_ArticleNumber,IRC_LotNumber,IRC_DMA_ID,IRC_CFN_ID,IRC_BUM_ID,IRC_PRH_ID
	) t1
WHERE InventoryReturnConsignmentInit.IRC_USER = t1.IRC_USER
and InventoryReturnConsignmentInit.IRC_ArticleNumber = t1.IRC_ArticleNumber
and InventoryReturnConsignmentInit.IRC_LotNumber = t1.IRC_LotNumber
AND t1.ReturnQty > 1
and InventoryReturnConsignmentInit.IRC_ReturnQty_ErrMsg is null


UPDATE InventoryReturnConsignmentInit SET IRC_ErrorFlag = 1
WHERE IRC_USER = @UserId
AND (IRC_ArticleNumber_ErrMsg IS NOT NULL OR IRC_LotNumber_ErrMsg IS NOT NULL OR IRC_PurchaseOrderNbr_ErrMsg IS NOT NULL OR IRC_ReturnQty_ErrMsg IS NOT NULL)

--����Ƿ���ڴ���
IF (SELECT COUNT(*) FROM InventoryReturnConsignmentInit WHERE IRC_ErrorFlag = 1 AND IRC_USER = @UserId) > 0
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
			--������ʱ��������
			insert into #mmbo_InventoryAdjustHeader (IAH_ID,IAH_Reason,IAH_Inv_Adj_Nbr,IAH_DMA_ID,IAH_ApprovalDate,IAH_CreatedDate,
			IAH_Approval_USR_UserID,IAH_AuditorNotes,IAH_UserDescription,IAH_Status,IAH_CreatedBy_USR_UserID,IAH_Reverse_IAH_ID,IAH_ProductLine_BUM_ID,IAH_WarehouseType)
			select newid(),'Return',null,IRC_DMA_ID,NULL,GETDATE(),NULL,NULL,null,'Draft',IRC_USER,null,IRC_BUM_ID,'Consignment'
			from (select DISTINCT IRC_USER,IRC_BUM_ID,IRC_DMA_ID
			from InventoryReturnConsignmentInit where IRC_USER = @UserId) a 
			
			--������ʱ������ϸ�� ���Ӷ�����ҪLotNumber
			insert into #mmbo_InventoryAdjustDetail (IAD_Quantity,IAD_ID,IAD_PMA_ID,IAD_IAH_ID,IAD_LineNbr,IAD_LOT_ID,
			IAD_LOT_Number,IAD_WHM_ID,IAD_BUM_ID,IAD_ExpiredDate,IAD_PRH_ID)
			select IAD_Quantity,IAD_ID,PMA_ID,IAH_ID,ROW_NUMBER () OVER (ORDER BY IAD_ID) AS row_number,
				LOT_ID,IRC_LotNumber,IRC_WHM_ID,IRC_BUM_ID,LTM_ExpiredDate,IRC_PRH_ID
				from (
					select SUM(convert(decimal(18,6),IRC_ReturnQty)) as IAD_Quantity,NEWID() as IAD_ID,t2.PMA_ID,t5.LOT_ID,t1.IRC_LotNumber,t1.IRC_WHM_ID,IRC_BUM_ID,t6.IAH_ID,t4.LTM_ExpiredDate,t1.IRC_PRH_ID
					from InventoryReturnConsignmentInit t1,Product t2,Inventory t3,LotMaster t4,Lot t5,#mmbo_InventoryAdjustHeader t6
					where t1.IRC_CFN_ID = t2.PMA_CFN_ID
					and t1.IRC_WHM_ID = t3.INV_WHM_ID
					and t3.INV_PMA_ID = t2.PMA_ID
					and t2.PMA_ID = t4.LTM_Product_PMA_ID
					and t4.LTM_ID = t5.LOT_LTM_ID
					and t5.LOT_INV_ID = t3.INV_ID
					and t1.IRC_LotNumber = t4.LTM_LotNumber
					and t1.IRC_BUM_ID = t6.IAH_ProductLine_BUM_ID
					and t1.IRC_USER = @UserId
					group by t2.PMA_ID,t5.LOT_ID,t1.IRC_LotNumber,t1.IRC_WHM_ID,IRC_BUM_ID,t6.IAH_ID,t4.LTM_ExpiredDate,t1.IRC_PRH_ID
				) tmp
			
			--���붩���������ϸ��
			insert into InventoryAdjustHeader select * from #mmbo_InventoryAdjustHeader
			insert into InventoryAdjustDetail select IAD_Quantity,IAD_ID,IAD_PMA_ID,IAD_IAH_ID,IAD_LineNbr from #mmbo_InventoryAdjustDetail
			insert into InventoryAdjustLot select IAD_ID,NEWID(),IAD_Quantity,IAD_LOT_ID,IAD_WHM_ID,IAD_LOT_Number,IAD_ExpiredDate,IAD_PRH_ID,0,null,IAD_LOT_ID,IAD_LOT_Number from #mmbo_InventoryAdjustDetail

			
			--���붩��������־
			INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
			SELECT NEWID(),IAH_ID,IAH_CreatedBy_USR_UserID,GETDATE(),'ExcelImport',NULL FROM #mmbo_InventoryAdjustHeader
			
			--����м�������
			DELETE FROM InventoryReturnConsignmentInit WHERE IRC_USER = @UserId
		END
	END
	
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


