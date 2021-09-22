DROP Procedure [dbo].[GC_InventoryAdjustInit]
GO

USE [BSC_Prd]
GO
/****** Object:  StoredProcedure [dbo].[GC_InventoryAdjustInit]    Script Date: 2018/3/23 18:09:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER Procedure [dbo].[GC_InventoryAdjustInit]
    @UserId uniqueidentifier,
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
   IAD_QRCode     nvarchar(50) collate Chinese_PRC_CI_AS  null,
   IAD_Group_IAD_ID     uniqueidentifier     null,
    primary key (IAD_ID)
)


/*先将错误标志设为0*/
UPDATE InventoryAdjustInit SET IAI_ErrorFlag = 0,IAI_ReturnQty_ErrMsg= null WHERE IAI_USER = @UserId

--获取经销商
UPDATE InventoryAdjustInit
SET IAI_DMA_ID = DMA_ID
FROM DealerMaster 
WHERE ltrim(rtrim(InventoryAdjustInit.IAI_SAPCode)) = ltrim(rtrim(DealerMaster.DMA_SAP_Code))
AND IAI_USER = @UserId

--检查经销商是否存在
UPDATE InventoryAdjustInit SET IAI_ErrorFlag = 1, IAI_SAPCodeErrMsg =  N'经销商不存在'
WHERE IAI_USER = @UserId
and IAI_DMA_ID is null

--检查仓库是否存在
UPDATE InventoryAdjustInit SET IAI_WHM_ID = WHM_ID
FROM Warehouse WHERE ltrim(rtrim(WHM_Name)) = ltrim(rtrim(IAI_Warehouse))
AND WHM_DMA_ID = IAI_DMA_ID
AND IAI_USER = @UserId

UPDATE InventoryAdjustInit SET IAI_ErrorFlag = 1, IAI_Warehouse_ErrMsg = N'仓库不存在,'
WHERE IAI_WHM_ID IS NULL AND IAI_USER = @UserId AND IAI_Warehouse_ErrMsg IS NULL

--检查出入库类型
UPDATE InventoryAdjustInit SET IAI_ErrorFlag = 1, IAI_AdjustType_ErrMsg =  N'类型不正确'
WHERE IAI_USER = @UserId
and IAI_AdjustType not in ('其他出库','其他入库')

--检查产品是否存在
UPDATE InventoryAdjustInit SET IAI_CFN_ID = CFN_ID
FROM CFN WHERE CFN_CustomerFaceNbr = IAI_ArticleNumber
AND IAI_USER = @UserId

UPDATE InventoryAdjustInit SET IAI_ErrorFlag = 1, IAI_ArticleNumber_ErrMsg = N'产品不存在,'
WHERE IAI_CFN_ID IS NULL AND IAI_USER = @UserId AND IAI_ArticleNumber_ErrMsg IS NULL

--检查产品是否已分类（是否对应产品线）
UPDATE IAI SET IAI_BUM_ID = CFN_ProductLine_BUM_ID--(CASE WHEN CFNS_BUM_ID IS NULL THEN CFN_ProductLine_BUM_ID ELSE CFNS_BUM_ID END)
FROM InventoryAdjustInit IAI inner join CFN on CFN_ID = IAI_CFN_ID 
--left join CFNSHARE on CFN_ID = CFNS_CFN_ID AND CFNS_PROPERTY1 = 1
WHERE IAI_CFN_ID IS NOT NULL
AND IAI_USER = @UserId

UPDATE InventoryAdjustInit SET IAI_ErrorFlag = 1, IAI_ArticleNumber_ErrMsg =  N'产品未分类(无对应产品线),'
WHERE IAI_BUM_ID IS NULL AND IAI_USER = @UserId AND IAI_ArticleNumber_ErrMsg IS NULL

--产品线是否有授权
--update InventoryAdjustInit SET  iaI_ErrorFlag = 1, IAI_ArticleNumber_ErrMsg =  N'没有设定此产品线的授权'
-- WHERE IAI_USER = @UserId
--   and NOT EXISTS (select 1 from (select b.*
--							  from V_DealerContractMaster a
--							  inner join (select distinct CC_Code,CC_ID,CA_Code,CA_ID,CC_ProductLineID,CC_Division from V_ProductClassificationStructure) pc
--							  on CONVERT(nvarchar(10), a.Division)=pc.CC_Division and pc.CC_ID=a.CC_ID
--							  inner join DealerAuthorizationTable b on b.DAT_DMA_ID=a.DMA_ID and pc.CC_ProductLineID=b.DAT_ProductLine_BUM_ID and b.DAT_PMA_ID=pc.CA_ID
--							  where a.ActiveFlag='1') AS DAT,Lafite_ATTRIBUTE AS LA 
--                    where DAT.DAT_ProductLine_BUM_ID = LA.Id and DAT.DAT_DMA_ID = InventoryAdjustInit.IAI_DMA_ID
--                      and InventoryAdjustInit.IAI_BUM_ID = LA.Id and LA.ATTRIBUTE_TYPE='Product_Line')
--   and IAI_ArticleNumber_ErrMsg is null


--update InventoryAdjustInit SET IAI_ErrorFlag = 1 ,IAI_QRCodeErrMsg = N'二维码不能存在,'
--where IAI_USER = @UserId and not exists (select 1 from LotMaster l where l.LTM_LotNumber like IAI_QRCodeode )

--检查产品批号是否正群
UPDATE InventoryAdjustInit SET IAI_ErrorFlag = 1, IAI_LotNumber_ErrMsg = N'产品批号不存在,' ,IAI_QRCodeErrMsg='二维码不存在'
WHERE (case when  isnull(InventoryAdjustInit.IAI_QRCode,'' ) != '' 
then InventoryAdjustInit.IAI_LotNumber+'@@'+InventoryAdjustInit.IAI_QRCode else
  InventoryAdjustInit.IAI_LotNumber+'@@NoQR' end IS NOT NULL OR  case when  isnull(InventoryAdjustInit.IAI_QRCode,'' ) != '' 
then InventoryAdjustInit.IAI_LotNumber+'@@'+InventoryAdjustInit.IAI_QRCode else
  InventoryAdjustInit.IAI_LotNumber+'@@NoQR' end <>'')
  AND IAI_USER = @UserId 
  AND IAI_LotNumber_ErrMsg IS NULL
  AND IAI_ArticleNumber_ErrMsg IS NULL
  and IAI_QRCodeErrMsg IS NULL
  AND Not Exists 
  (SELECT 1
     FROM cfn t1, Product t2, LotMaster t3
    WHERE  t1.CFN_ID = t2.PMA_CFN_ID
       AND t2.PMA_ID = t3.LTM_Product_PMA_ID
       AND case when  isnull(InventoryAdjustInit.IAI_QRCode,'' ) != '' 
then InventoryAdjustInit.IAI_LotNumber+'@@'+InventoryAdjustInit.IAI_QRCode else
  InventoryAdjustInit.IAI_LotNumber+'@@NoQR'  end = t3.LTM_LotNumber  and t1.CFN_CustomerFaceNbr = InventoryAdjustInit.IAI_ArticleNumber
   )
  AND IAI_AdjustType='其他出库'

----如果没有填写订单号，自动获取最近的一张订单号
--update IAI
--set IAI.IAI_PurchaseOrderNbr = (select top 1 PRH_PurchaseOrderNbr from POReceiptHeader t1 ,POReceipt t2,POReceiptLot t3,Product t4
--where t1.PRH_ID = t2.POR_PRH_ID
--and t2.POR_ID = t3.PRL_POR_ID
--and t2.POR_SAP_PMA_ID = t4.PMA_ID
--and t3.PRL_LotNumber=IAI.IAI_LotNumber
--and t4.PMA_UPN = IAI.IAI_ArticleNumber
--and t1.PRH_Dealer_DMA_ID = @DealerID
--order by t1.PRH_ReceiptDate desc
--) 
--from InventoryAdjustInit IAI
--where IAI_CFN_ID is not null
--and IAI_PurchaseOrderNbr is null

----检查订单号是否存在
--update InventoryAdjustInit SET IAI_PRH_ID = PRH_ID
--FROM (SELECT MAX(CONVERT(NVARCHAR(100),PRH_ID)) PRH_ID,PRH_PurchaseOrderNbr,MAX(PRH_ReceiptDate) PRH_ReceiptDate
--from PoreceiptHeader
--group by PRH_PurchaseOrderNbr) PRH
--WHERE PRH_PurchaseOrderNbr = IAI_PurchaseOrderNbr
--AND IAI_User =@UserId

--UPDATE InventoryAdjustInit SET IAI_ErrorFlag = 1, IAI_PurchaseOrderNbr_ErrMsg = N'订单号不存在,'
--WHERE IAI_PurchaseOrderNbr IS NOT NULL AND IAI_PRH_ID IS NULL 
--AND IAI_USER = @UserId AND IAI_PurchaseOrderNbr_ErrMsg IS NULL
--检查产品批号是否带有二维码
--UPDATE InventoryAdjustInit SET IAI_ErrorFlag = 1, IAI_LotNumber_ErrMsg = N'产品批号必须要有二维码,'
--WHERE  IAI_USER = @UserId 
--  AND IAI_LotNumber not like '%@@%'

--校验仓库中是否有产品存在
update t1
set t1.IAI_ArticleNumber_ErrMsg = N'该仓库中不存在此产品'
from InventoryAdjustInit t1
left join Product on IAI_CFN_ID = PMA_CFN_ID
left join Inventory on IAI_WHM_ID = INV_WHM_ID and INV_PMA_ID = PMA_ID
where IAI_USER=@UserId
and INV_ID is null
and IAI_ArticleNumber_ErrMsg is null
and IAI_AdjustType = '其他出库'

--校验是否存在重复的相同批号的产品
update t1
set t1.IAI_LotNumber_ErrMsg = N'该单据中相同仓库中同批号产品存在重复'
from InventoryAdjustInit t1
where IAI_USER = @UserId
  and IAI_LotNumber_ErrMsg is null
  and exists (
select 1 from (
select IAI_CFN_ID, IAI_DMA_ID , IAI_WHM_ID,case when isnull(IAI_QRCode,'' ) != '' 
then IAI_LotNumber+'@@'+IAI_QRCode else
  IAI_LotNumber+'@@NoQR' end  as lotQrcode,IAI_AdjustType
from InventoryAdjustInit t1
left join Product on IAI_CFN_ID = PMA_CFN_ID
left join Inventory on IAI_WHM_ID = INV_WHM_ID and INV_PMA_ID = PMA_ID
where IAI_USER = @UserId
and INV_ID is not null
and IAI_LotNumber_ErrMsg is null
group by IAI_CFN_ID, IAI_DMA_ID , IAI_WHM_ID, case when isnull(IAI_QRCode,'' ) != '' 
then IAI_LotNumber+'@@'+IAI_QRCode else
  IAI_LotNumber+'@@NoQR' end,IAI_AdjustType having COUNT(*)>1
) tab where tab.IAI_CFN_ID= t1.IAI_CFN_ID and tab.IAI_DMA_ID=t1.IAI_DMA_ID and tab.lotQrcode=case when isnull(t1.IAI_QRCode,'' ) != '' 
then t1.IAI_LotNumber+'@@'+t1.IAI_QRCode else
  t1.IAI_LotNumber+'@@NoQR' end  and tab.IAI_WHM_ID=t1.IAI_WHM_ID
and tab.IAI_AdjustType = t1.IAI_AdjustType
) 

UPDATE InventoryAdjustInit set IAI_ErrorFlag = 1, IAI_ReturnQty_ErrMsg = N'调整数量不能小于0'
WHERE IAI_USER = @UserId
AND CONVERT(float,IAI_ReturnQty) < 0

--校验退货数量
Update InventoryAdjustInit set IAI_ErrorFlag = 1, IAI_ReturnQty_ErrMsg = N'库存数量小于出库数量'
from 
(select IAI_USER,IAI_ArticleNumber,case when isnull(IAI_QRCode,'' ) != '' 
then IAI_LotNumber+'@@'+IAI_QRCode else
  IAI_LotNumber+'@@NoQR' end  as lotQrcode,sum(convert(decimal(18,6),IAI_ReturnQty)) as ReturnQty,
	IAI_DMA_ID,IAI_CFN_ID,IAI_BUM_ID,IAI_WHM_ID 
	from InventoryAdjustInit
	where IAI_USER = @UserId
	and InventoryAdjustInit.IAI_AdjustType = '其他出库'
	group by IAI_USER,IAI_ArticleNumber,case when isnull(IAI_QRCode,'' ) != '' 
   then IAI_LotNumber+'@@'+IAI_QRCode else
   IAI_LotNumber+'@@NoQR' end ,IAI_DMA_ID,IAI_CFN_ID,IAI_BUM_ID,IAI_WHM_ID
	) t1
	INNER JOIN Product t2 ON t1.IAI_CFN_ID = t2.PMA_CFN_ID
	LEFT JOIN Inventory t3 ON t1.IAI_WHM_ID = t3.INV_WHM_ID AND t3.INV_PMA_ID = t2.PMA_ID
	LEFT JOIN LotMaster t4 ON t2.PMA_ID = t4.LTM_Product_PMA_ID AND t1.lotQrcode = t4.LTM_LotNumber
	LEFT JOIN Lot t5 ON t4.LTM_ID = t5.LOT_LTM_ID AND t5.LOT_INV_ID = t3.INV_ID
where InventoryAdjustInit.IAI_USER = t1.IAI_USER
and InventoryAdjustInit.IAI_ArticleNumber = t1.IAI_ArticleNumber
and case when isnull(InventoryAdjustInit.IAI_QRCode,'' ) != '' 
then InventoryAdjustInit.IAI_LotNumber+'@@'+InventoryAdjustInit.IAI_QRCode else
InventoryAdjustInit.IAI_LotNumber+'@@NoQR' end= t1.lotQrcode
and InventoryAdjustInit.IAI_WHM_ID = t1.IAI_WHM_ID
and InventoryAdjustInit.IAI_AdjustType = '其他出库'
--and t1.ReturnQty > t5.LOT_OnHandQty
and (t1.ReturnQty > t5.LOT_OnHandQty OR t5.LOT_OnHandQty IS NULL)
and InventoryAdjustInit.IAI_ReturnQty_ErrMsg is null

--检查UPN + LOT组合是否存在
Update IAI set IAI_ErrorFlag = 1, IAI_LotNumber_ErrMsg = N'UPN + LOT组合不存在' ,IAI_QRCodeErrMsg=N'UPN + LOT组合不存在'
--select * 
from InventoryAdjustInit IAI 
where NOt exists (select 1 from LotMaster LM, product P where case when  isnull(IAI_QRCode,'' ) != '' 
then IAI_LotNumber+'@@'+IAI_QRCode else
  IAI_LotNumber+'@@NoQR' end = LM.LTM_LotNumber and LM.LTM_Product_PMA_ID= P.PMA_ID and P.PMA_CFN_ID = IAI.IAI_CFN_ID )
  and not EXISTS (select 1 from LotMaster LM , product P where IAI.IAI_LotNumber = LM.LTM_LotNumber and LM.LTM_Product_PMA_ID= P.PMA_ID and P.PMA_CFN_ID = IAI.IAI_CFN_ID)
and IAI_USER=@UserId
and IAI_AdjustType = '其他入库'
and IAI_LotNumber_ErrMsg is null
and IAI_QRCodeErrMsg is null


UPDATE InventoryAdjustInit SET IAI_ErrorFlag = 1
WHERE IAI_USER = @UserId
AND (IAI_ArticleNumber_ErrMsg IS NOT NULL OR IAI_LotNumber_ErrMsg IS NOT NULL
 OR IAI_Warehouse_ErrMsg IS NOT NULL OR IAI_ReturnQty_ErrMsg IS NOT NULL
 or IAI_QRCodeErrMsg is not null or IAI_SAPCodeErrMsg is not null or IAI_QRCodeErrMsg is not null)

--检查是否存在错误
IF (SELECT COUNT(*) FROM InventoryAdjustInit WHERE IAI_ErrorFlag = 1 AND IAI_USER = @UserId) > 0
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
			--写入LotMaster
			CREATE TABLE #TmpLotMaster (
			[LTM_InitialQty] float NULL,
			[LTM_ExpiredDate] datetime NULL,
			[LTM_LotNumber] nvarchar(50)  collate Chinese_PRC_CI_AS NOT NULL , 
			[LTM_ID] uniqueidentifier NOT NULL,
			[LTM_CreatedDate] datetime NOT NULL,
			[LTM_PRL_ID] uniqueidentifier NULL,
			[LTM_Product_PMA_ID] uniqueidentifier NULL,
			[LTM_Type] nvarchar(30) collate Chinese_PRC_CI_AS NULL,
			[LTM_RelationID] uniqueidentifier NULL)


			insert into #TmpLotMaster
			select 1,null, case when  isnull(t1.IAI_QRCode,'' ) != '' then t1.IAI_LotNumber+'@@'+t1.IAI_QRCode else
            t1.IAI_LotNumber+'@@NoQR' end ,newid(),getdate(),null,t2.PMA_ID,null,null
			from InventoryAdjustInit t1, product t2
			 where IAI_USER=@UserId
			 and t1.IAI_ArticleNumber = t2.PMA_UPN
			 and t1.IAI_AdjustType = '其他入库'
			 group by t2.PMA_ID,t1.IAI_LotNumber,case when  isnull(t1.IAI_QRCode,'' ) != '' then t1.IAI_LotNumber+'@@'+t1.IAI_QRCode else
            t1.IAI_LotNumber+'@@NoQR' end
			 
			
			 
			  
			 update TLM SET TLM.LTM_ExpiredDate = LM.LTM_ExpiredDate, TLM.LTM_Type = LM.LTM_Type			 
			 from #TmpLotMaster TLM, LotMaster LM
			 where TLM.LTM_Product_PMA_ID=LM.LTM_Product_PMA_ID
			 and  TLM.LTM_LotNumber=LM.LTM_LotNumber
              


			  
			insert into LotMaster            
			select * 
			from #TmpLotMaster TLM 
			where NOT EXISTS (select 1 from LotMaster LM where TLM.LTM_Product_PMA_ID = LM.LTM_Product_PMA_ID and TLM.LTM_LotNumber = LM.LTM_LotNumber)         
			          
			   
						
			
			
			--插入临时订单主表
			insert into #mmbo_InventoryAdjustHeader (IAH_ID,IAH_Reason,IAH_Inv_Adj_Nbr,IAH_DMA_ID,IAH_ApprovalDate,IAH_CreatedDate,
			IAH_Approval_USR_UserID,IAH_AuditorNotes,IAH_UserDescription,IAH_Status,IAH_CreatedBy_USR_UserID,IAH_Reverse_IAH_ID,IAH_ProductLine_BUM_ID,IAH_WarehouseType)
			select newid(),DICT_KEY,null,IAI_DMA_ID,NULL,GETDATE(),NULL,NULL,null,'Draft',IAI_USER,null,IAI_BUM_ID,'Normal'
			from (select DISTINCT IAI_USER,IAI_BUM_ID,IAI_DMA_ID,IAI_AdjustType
			from InventoryAdjustInit where IAI_USER = @UserId) a 
			inner join Lafite_DICT b on a.IAI_AdjustType = b.VALUE1 and b.DICT_TYPE = 'CONST_AdjustQty_Type'
			
			--新增其他入库类型的Inventory和Lot表
			--update by Hua kaichun 
			insert into Inventory(INV_OnHandQuantity,INV_ID,INV_WHM_ID,INV_PMA_ID)
			select 0,newid(),IAI_WHM_ID,PMA_ID from (
			select distinct t1.IAI_WHM_ID,t2.PMA_ID
			from InventoryAdjustInit t1
			,Product t2
			where t1.IAI_CFN_ID = t2.PMA_CFN_ID
			and not exists (select 1 from Inventory t3 where t1.IAI_WHM_ID = t3.INV_WHM_ID and t3.INV_PMA_ID = t2.PMA_ID)
			) tab
			--end 

			--新增其他入库类型的Inventory和Lot表
			create table #lot
			(
				LOT_ID uniqueidentifier not null,
				LOT_DMA_ID uniqueidentifier not null,
				LOT_WHM_ID uniqueidentifier not null,
				LOT_PMA_ID uniqueidentifier not null,
				LOT_CFN_ID uniqueidentifier not null,
				LOT_LotNumber nvarchar(50) collate Chinese_PRC_CI_AS  null
			)
			
			insert into #lot
			select INV_ID,IAI_DMA_ID,IAI_WHM_ID,PMA_ID,IAI_CFN_ID,
						case when  isnull(IAI_QRCode,'' ) != '' 
             then IAI_LotNumber+'@@'+IAI_QRCode else
             IAI_LotNumber+'@@NoQR' end 
			from InventoryAdjustInit,Product,Inventory
			where IAI_USER = @UserId
			and IAI_CFN_ID = PMA_CFN_ID
			and INV_WHM_ID = IAI_WHM_ID
			and INV_PMA_ID = PMA_ID
			and IAI_AdjustType ='其他入库'
			and not exists (select 1 from Inventory,Lot,LotMaster 
							where INV_ID = LOT_INV_ID
							and LOT_LTM_ID = LTM_ID
							and INV_PMA_ID = PMA_ID 
							and IAI_WHM_ID = INV_WHM_ID
							--and IAI_LotNumber = LTM_LotNumber
              and  case when  isnull(IAI_QRCode,'' ) != '' 
             then IAI_LotNumber+'@@'+IAI_QRCode else
             IAI_LotNumber+'@@NoQR' end = LTM_LotNumber
              )
              
      
      insert into Lot
			select NEWID(),t3.LTM_ID,0,t1.LOT_ID
			from #lot t1,InventoryAdjustInit t2,LotMaster t3
			where t1.LOT_DMA_ID = t2.IAI_DMA_ID
			and t1.LOT_WHM_ID = t2.IAI_WHM_ID
			and t1.LOT_CFN_ID = t2.IAI_CFN_ID
			and t1.LOT_LotNumber = case when  isnull(t2.IAI_QRCode,'' ) != '' 
             then t2.IAI_LotNumber+'@@'+t2.IAI_QRCode else
             t2.IAI_LotNumber+'@@NoQR' end
			and  t1.LOT_LotNumber = t3.LTM_LotNumber
      --and t2.IAI_LotNumber = t3.LTM_LotNumber
			and t2.IAI_USER = @UserId
			and t2.IAI_AdjustType ='其他入库'
			and not exists (select 1 from lot lt where lt.LOT_LTM_ID=t3.LTM_ID and lt.LOT_INV_ID=t1.LOT_ID)
      
      
			
			      
			--插入临时订单明细表 
      insert into #mmbo_InventoryAdjustDetail (IAD_Quantity,IAD_ID,IAD_PMA_ID,IAD_IAH_ID,IAD_LineNbr,IAD_LOT_ID,
			IAD_LOT_Number,IAD_WHM_ID,IAD_BUM_ID,IAD_ExpiredDate,IAD_PRH_ID,IAD_QRCode)
      
	     select IAD_Quantity,IAD_ID,PMA_ID,IAH_ID,ROW_NUMBER () OVER (ORDER BY IAD_ID) AS row_number,
				LOT_ID,
                IAI_LotNumber
                ,IAI_WHM_ID,IAI_BUM_ID,LTM_ExpiredDate,IAI_PRH_ID,IAI_LotNumber
				from (
					select SUM(convert(decimal(18,6),IAI_ReturnQty)) as IAD_Quantity,
					NEWID() as IAD_ID,
					t2.PMA_ID,
					t5.LOT_ID,
					case when  isnull(t1.IAI_QRCode,'' ) != '' 
                 then t1.IAI_LotNumber+'@@'+t1.IAI_QRCode else
                 t1.IAI_LotNumber+'@@NoQR' end as IAI_LotNumber,
					t1.IAI_WHM_ID,IAI_BUM_ID,t7.IAH_ID,t4.LTM_ExpiredDate,t1.IAI_PRH_ID
					from InventoryAdjustInit t1,Product t2,Inventory t3,LotMaster t4,Lot t5,Lafite_DICT t6,#mmbo_InventoryAdjustHeader t7
					where t1.IAI_CFN_ID = t2.PMA_CFN_ID
					and t1.IAI_WHM_ID = t3.INV_WHM_ID
					and t3.INV_PMA_ID = t2.PMA_ID
					and t2.PMA_ID = t4.LTM_Product_PMA_ID
					and t4.LTM_ID = t5.LOT_LTM_ID
					and t5.LOT_INV_ID = t3.INV_ID
					and  case when  isnull(t1.IAI_QRCode,'' ) != '' 
                 then t1.IAI_LotNumber+'@@'+t1.IAI_QRCode else
                 t1.IAI_LotNumber+'@@NoQR' end = t4.LTM_LotNumber
					and t1.IAI_AdjustType = t6.VALUE1
					and t6.DICT_TYPE = 'CONST_AdjustQty_Type'
					and t6.DICT_KEY = t7.IAH_Reason
					and t1.IAI_BUM_ID = t7.IAH_ProductLine_BUM_ID
					and t1.IAI_DMA_ID = t7.IAH_DMA_ID
					and t1.IAI_USER = @UserId
					group by t2.PMA_ID,t5.LOT_ID,case when isnull(t1.IAI_QRCode,'' ) != '' 
                 then t1.IAI_LotNumber+'@@'+t1.IAI_QRCode else
                 t1.IAI_LotNumber+'@@NoQR' end,t1.IAI_WHM_ID,IAI_BUM_ID,t7.IAH_ID,t4.LTM_ExpiredDate,t1.IAI_PRH_ID
				) tmp
		
			--插入订单主表和明细表
			insert into InventoryAdjustHeader 
			([IAH_ID]
           ,[IAH_Reason]
           ,[IAH_Inv_Adj_Nbr]
           ,[IAH_DMA_ID]
           ,[IAH_ApprovalDate]
           ,[IAH_CreatedDate]
           ,[IAH_Approval_USR_UserID]
           ,[IAH_AuditorNotes]
           ,[IAH_UserDescription]
           ,[IAH_Status]
           ,[IAH_CreatedBy_USR_UserID]
           ,[IAH_Reverse_IAH_ID]
           ,[IAH_ProductLine_BUM_ID]
           ,[IAH_WarehouseType])
			SELECT IAH_ID					  
			,IAH_Reason				  
			,IAH_Inv_Adj_Nbr			
			,IAH_DMA_ID				  
			,IAH_ApprovalDate          
			,IAH_CreatedDate           
			,IAH_Approval_USR_UserID   
			,IAH_AuditorNotes		  
			,IAH_UserDescription       
			,IAH_Status				  
			,IAH_CreatedBy_USR_UserID  
			,IAH_Reverse_IAH_ID		  
			,IAH_ProductLine_BUM_ID    
			,IAH_WarehouseType 
			FROM #mmbo_InventoryAdjustHeader
			
			select IAD_PMA_ID,IAD_IAH_ID,newid() AS IAD_Group_IAD_ID into #tmpIAD from #mmbo_InventoryAdjustDetail group by IAD_PMA_ID,IAD_IAH_ID
			
			update t1 set t1.IAD_Group_IAD_ID = t2.IAD_Group_IAD_ID
			from #mmbo_InventoryAdjustDetail t1,#tmpIAD t2 
			where t1.IAD_IAH_ID =t2.IAD_IAH_ID and t1.IAD_PMA_ID =t2.IAD_PMA_ID
			
			insert into InventoryAdjustDetail select sum(IAD_Quantity),IAD_Group_IAD_ID,IAD_PMA_ID,IAD_IAH_ID,ROW_NUMBER() over(order by IAD_PMA_ID) 
			from #mmbo_InventoryAdjustDetail  group by IAD_Group_IAD_ID,IAD_PMA_ID,IAD_IAH_ID
			
			insert into InventoryAdjustLot (IAL_IAD_ID,IAL_ID,IAL_LotQty,IAL_LOT_ID,IAL_WHM_ID,IAL_LotNumber,IAL_ExpiredDate,IAL_PRH_ID,IAL_UnitPrice, IAL_QRLotNumber ) 
			select IAD_Group_IAD_ID,NEWID(),IAD_Quantity,IAD_LOT_ID,IAD_WHM_ID,IAD_LOT_Number,IAD_ExpiredDate,IAD_PRH_ID,0 ,IAD_QRCode 
			from #mmbo_InventoryAdjustDetail

			--插入订单操作日志
			INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
			SELECT NEWID(),IAH_ID,IAH_CreatedBy_USR_UserID,GETDATE(),'ExcelImport',NULL FROM #mmbo_InventoryAdjustHeader
			
			--清除中间表的数据
			DELETE FROM InventoryAdjustInit WHERE IAI_USER = @UserId
		END
	END
	
COMMIT TRAN

SET NOCOUNT OFF


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

   END CATCH
















