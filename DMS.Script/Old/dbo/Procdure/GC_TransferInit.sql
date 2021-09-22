DROP Procedure [dbo].[GC_TransferInit]
GO



Create Procedure [dbo].[GC_TransferInit]
    @UserId uniqueidentifier,
    @ImportType NVARCHAR(20),   
    @IsValid NVARCHAR(20) = 'Success' OUTPUT

AS
		
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

Declare @DealerID uniqueidentifier
Declare @DealerType nvarchar(5)
Declare @dealertp nvarchar(5)
--创建临时表
create table #mmbo_Transfer (
   TRN_ID					uniqueidentifier     not null,
   TRN_TransferNumber		nvarchar(50)		collate Chinese_PRC_CI_AS null,
   TRN_FromDealer_DMA_ID	uniqueidentifier   NOT  null,
   TRN_Status				nvarchar(50)         collate Chinese_PRC_CI_AS null,
   TRN_ToDealer_DMA_ID	uniqueidentifier   NOT  null,
   TRN_Type				nvarchar(50)         collate Chinese_PRC_CI_AS null,
   TRN_Description				nvarchar(2000)         collate Chinese_PRC_CI_AS null,
   TRN_Reverse_TRN_ID	uniqueidentifier    null,
   TRN_TransferDate         datetime             null,
   TRN_ProductLine_BUM_ID	uniqueidentifier   NOT  null,
   TRN_Transfer_USR_UserID	uniqueidentifier   NOT  null,
   TRN_WarehouseType		nvarchar(50)         collate Chinese_PRC_CI_AS not null,
   primary key (TRN_ID)
)

create table #mmbo_TransferLine (
   TRL_TRN_ID				uniqueidentifier     not null,
   TRL_TransferPart_PMA_ID	uniqueidentifier     not null,
   TRL_ID					uniqueidentifier      not  null,
   TRL_LineNbr				int        null,
   TRL_LOT_ID				uniqueidentifier NULL,
   TRL_LOT_Number			nvarchar(50) collate Chinese_PRC_CI_AS  null,
   TRL_FromWarehouse_WHM_ID	uniqueidentifier NULL,
   TRL_ToWarehouse_WHM_ID	uniqueidentifier NULL,
   TRL_TransferQty			float null,
    primary key (TRL_ID)
)


create table #mmbo_TransferLot (
   [TLT_TRL_ID] [uniqueidentifier] NOT NULL,
	[TLT_LOT_ID] [uniqueidentifier] NOT NULL,
	[TLT_ID] [uniqueidentifier] NOT NULL,
	[TLT_TransferLotQty] [float] NOT NULL,
	[IAL_QRLOT_ID] [uniqueidentifier] NULL,
	[IAL_QRLotNumber] [nvarchar](50) NULL,
    primary key (TLT_ID)
)

 select  @dealertp=Substring(IDENTITY_CODE,Len(IDENTITY_CODE)-2,3) from Lafite_IDENTITY where Id=@UserId
 
 
 


/*先将错误标志设为0*/
UPDATE TransferInit SET TRI_ErrorFlag = 0,TRI_TransferQty_ErrMsg= null WHERE TRI_USER = @UserId

--检查经销商是否存在
UPDATE TransferInit SET TRI_ErrorFlag = 1, TRI_ErrorDescription =  N'经销商不存在'
WHERE TRI_USER = @UserId
and TRI_DMA_ID is null

--获取经销商
Select top 1 @DealerID=  TRI_DMA_ID from TransferInit WHERE TRI_USER = @UserId
select @DealerType=  DMA_DealerType from DealerMaster where DMA_ID = @DealerID
if @dealertp='_99'
begin
UPDATE TransferInit SET TRI_WHMFrom_ID = WHM_ID,TRI_WHMTypeFrom = (CASE WHEN WHM_Type = 'DefaultWH' THEN 'Normal' ELSE WHM_Type END)
FROM Warehouse WHERE WHM_Name = TRI_WarehouseFrom and WHM_DMA_ID = TRI_DMA_ID
AND TRI_USER = @UserId

UPDATE TransferInit SET TRI_WHMTo_ID = WHM_ID,TRI_WHMTypeTo = (CASE WHEN WHM_Type = 'DefaultWH' THEN 'Normal' ELSE WHM_Type END)
FROM Warehouse WHERE WHM_Name = TRI_WarehouseTo and WHM_DMA_ID = TRI_DMA_ID
AND TRI_USER = @UserId

end
else
begin
--检查仓库是否存在
UPDATE TransferInit SET TRI_WHMFrom_ID = WHM_ID,TRI_WHMTypeFrom =  WHM_Type 
FROM Warehouse WHERE WHM_Name = TRI_WarehouseFrom and WHM_DMA_ID = TRI_DMA_ID
AND TRI_USER = @UserId

UPDATE TransferInit SET TRI_WHMTo_ID = WHM_ID,TRI_WHMTypeTo =  WHM_Type 
FROM Warehouse WHERE WHM_Name = TRI_WarehouseTo and WHM_DMA_ID = TRI_DMA_ID
AND TRI_USER = @UserId
end



UPDATE TransferInit SET TRI_ErrorFlag = 1, TRI_WarehouseFrom_ErrMsg = N'移出仓库必须是医院库类型,'
WHERE TRI_WHMTypeTo <> 'Normal' AND TRI_USER = @UserId AND TRI_WarehouseFrom_ErrMsg IS NULL 

UPDATE TransferInit SET TRI_ErrorFlag = 1, TRI_WarehouseFrom_ErrMsg = N'移出仓库不存在,'
WHERE TRI_WHMFrom_ID IS NULL AND TRI_USER = @UserId AND TRI_WarehouseFrom_ErrMsg IS NULL

UPDATE TransferInit SET TRI_ErrorFlag = 1, TRI_WarehouseTo_ErrMsg = N'移入仓库不存在,'
WHERE TRI_WHMTo_ID IS NULL AND TRI_USER = @UserId AND TRI_WarehouseTo_ErrMsg IS NULL



UPDATE TransferInit SET TRI_ErrorFlag = 1,TRI_WarehouseFrom_ErrMsg = N'移出与移入仓库类型不一致,', 
TRI_WarehouseTo_ErrMsg = N'移出与移入仓库类型不一致,'
WHERE TRI_WHMTypeFrom <> TRI_WHMTypeTo  AND TRI_WarehouseTo_ErrMsg IS NULL
AND TRI_WarehouseFrom_ErrMsg IS NULL 


--检查产品是否存在
UPDATE TransferInit SET TRI_CFN_ID = CFN_ID
FROM CFN WHERE CFN_CustomerFaceNbr = TRI_ArticleNumber
AND TRI_USER = @UserId

UPDATE TransferInit SET TRI_ErrorFlag = 1, TRI_ArticleNumber_ErrMsg = N'产品不存在,'
WHERE TRI_CFN_ID IS NULL AND TRI_USER = @UserId AND TRI_ArticleNumber_ErrMsg IS NULL

--检查产品是否已分类（是否对应产品线）
UPDATE TRI SET TRI_BUM_ID = (CASE WHEN CFNS_BUM_ID IS NULL THEN CFN_ProductLine_BUM_ID ELSE CFNS_BUM_ID END)
FROM TransferInit TRI inner join CFN on CFN_ID = TRI_CFN_ID 
left join CFNSHARE on CFN_ID = CFNS_CFN_ID AND CFNS_PROPERTY1 = 1
WHERE TRI_CFN_ID IS NOT NULL
AND TRI_USER = @UserId

UPDATE TransferInit SET TRI_ErrorFlag = 1, TRI_ArticleNumber_ErrMsg =  N'产品未分类(无对应产品线),'
WHERE TRI_BUM_ID IS NULL AND TRI_USER = @UserId AND TRI_ArticleNumber_ErrMsg IS NULL


--检查产品批号是否正确
UPDATE TransferInit SET TRI_ErrorFlag = 1, TRI_LotNumber_ErrMsg = N'产品批号不存在,'
WHERE (TRI_LotNumber IS NOT NULL OR  TRI_LotNumber<>'')
  AND TRI_USER = @UserId 
  AND TRI_LotNumber_ErrMsg IS NULL
  AND TRI_ArticleNumber_ErrMsg IS NULL
  AND Not Exists 
  (SELECT 1
     FROM cfn t1, Product t2, LotMaster t3
    WHERE  t1.CFN_ID = t2.PMA_CFN_ID
       AND t2.PMA_ID = t3.LTM_Product_PMA_ID
       AND t3.LTM_LotNumber = TransferInit.TRI_LotNumber and t1.CFN_CustomerFaceNbr = TransferInit.TRI_ArticleNumber
   )
   

--校验移库数量
Update TransferInit set TRI_ErrorFlag = 1, TRI_TransferQty_ErrMsg = N'库存数量小于移库数量,'
from 
(select TRI_USER,TRI_ArticleNumber,TRI_LotNumber,sum(convert(decimal(18,6),TRI_TransferQty)) as TransferQty,
	TRI_DMA_ID,TRI_CFN_ID,TRI_BUM_ID,TRI_WHMFrom_ID 
	from TransferInit
	where TRI_USER = @UserId
	group by TRI_USER,TRI_ArticleNumber,TRI_LotNumber,TRI_DMA_ID,TRI_CFN_ID,TRI_BUM_ID,TRI_WHMFrom_ID
	) t1,Product t2,Inventory t3,LotMaster t4,Lot t5
where TransferInit.TRI_USER = t1.TRI_USER
and TransferInit.TRI_ArticleNumber = t1.TRI_ArticleNumber
and TransferInit.TRI_LotNumber = t1.TRI_LotNumber
and TransferInit.TRI_WHMFrom_ID = t1.TRI_WHMFrom_ID
and t1.TRI_CFN_ID = t2.PMA_CFN_ID
and t1.TRI_WHMFrom_ID = t3.INV_WHM_ID
and t3.INV_PMA_ID = t2.PMA_ID
and t2.PMA_ID = t4.LTM_Product_PMA_ID
and t4.LTM_ID = t5.LOT_LTM_ID
and t5.LOT_INV_ID = t3.INV_ID
and t1.TRI_LotNumber = t4.LTM_LotNumber
and t1.TransferQty > t5.LOT_OnHandQty


UPDATE TransferInit SET TRI_ErrorFlag = 1
WHERE TRI_USER = @UserId
AND (TRI_ArticleNumber_ErrMsg IS NOT NULL OR TRI_LotNumber_ErrMsg IS NOT NULL OR TRI_WarehouseFrom_ErrMsg IS NOT NULL OR TRI_WarehouseTo_ErrMsg IS NOT NULL OR TRI_TransferQty_ErrMsg IS NOT NULL)
--带二维码的移库产品数量不得大于1
UPDATE TransferInit SET TRI_TransferQty_ErrMsg=N'移库数量不得大于1,' ,TRI_ErrorFlag = 1
WHERE  convert(float,isnull(TRI_TransferQty,0))>1 AND TRI_USER = @UserId

--
--;WITH T AS 
--    (
--    select sum(TransferLot.TLT_TransferLotQty) as 
--    SumQty,LotMaster.LTM_LotNumber as LotNumber
--    from [Transfer],TransferLine,TransferLot,Lot,LotMaster where 
--     [Transfer].TRN_ID=TransferLine.TRL_TRN_ID 
--     and [Transfer].TRN_Status='Complete' 
--     and TransferLot.TLT_TRL_ID=TransferLine.TRL_ID
--     and isnull(TransferLot.IAL_QRLOT_ID,TransferLot.TLT_LOT_ID)=Lot.Lot_id
--     and LOT_LTM_ID=LotMaster.LTM_ID
--     group by LotMaster.LTM_LotNumber
--    )
--     UPDATE TransferInit SET TRI_TransferQty_ErrMsg='该批次产品数量错误',TRI_ErrorFlag = 1
--     from T
--      where T.LotNumber = TRI_LotNumber 
--      and SumQty + convert(float,isnull(TRI_TransferQty,0))> 1
--     and TRI_USER = @UserId
--     and charindex('@@',TRI_LotNumber)>0
   


----检查是否存在错误
IF (SELECT COUNT(*) FROM TransferInit WHERE TRI_ErrorFlag = 1 AND TRI_USER = @UserId) > 0
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
			--插入临时订单主表
			insert into #mmbo_Transfer (TRN_ID,TRN_TransferNumber,TRN_FromDealer_DMA_ID,TRN_Status,TRN_ToDealer_DMA_ID,TRN_Type,
			TRN_Description,TRN_Reverse_TRN_ID,TRN_TransferDate,TRN_ProductLine_BUM_ID,TRN_Transfer_USR_UserID,TRN_WarehouseType)
			select newid(),null,TRI_DMA_ID,'Draft',TRI_DMA_ID,
			CASE WHEN TRI_WHMTypeFrom = 'Normal' THEN 'Transfer' ELSE 'TransferConsignment' END AS TRN_Type,
			null,null,GETDATE(),TRI_BUM_ID,TRI_USER,TRI_WHMTypeFrom
			from (select DISTINCT TRI_USER,TRI_BUM_ID,TRI_DMA_ID,TRI_WHMTypeFrom
			from TransferInit WHERE TRI_USER = @UserId) a 
			      
				
			--插入临时订单明细表 交接订单需要LotNumber
			insert into #mmbo_TransferLine (TRL_TRN_ID,TRL_TransferPart_PMA_ID,TRL_ID,TRL_LineNbr,TRL_LOT_ID,TRL_LOT_Number,
			TRL_FromWarehouse_WHM_ID,TRL_ToWarehouse_WHM_ID,TRL_TransferQty)
			select TRN_ID,PMA_ID,TRL_TRN_ID,ROW_NUMBER () OVER (PARTITION BY TRN_ID ORDER BY PMA_ID) AS row_number,
				null,null,TRI_WHMFrom_ID,TRI_WHMTo_ID,TRI_TransferQty
				from (
					select SUM(convert(decimal(18,6),TRI_TransferQty)) as TRI_TransferQty,NEWID() as TRL_TRN_ID,
					t2.PMA_ID,t1.TRI_WHMFrom_ID,T1.TRI_WHMTo_ID,
					TRI_BUM_ID,t6.TRN_ID
					from TransferInit t1,Product t2,Inventory t3,#mmbo_Transfer t6
					where t1.TRI_CFN_ID = t2.PMA_CFN_ID
					and t1.TRI_WHMFrom_ID = t3.INV_WHM_ID
					and t1.TRI_WHMTypeFrom = t6.TRN_WarehouseType
					and t3.INV_PMA_ID = t2.PMA_ID
					and t1.TRI_BUM_ID = t6.TRN_ProductLine_BUM_ID
					and t1.TRI_USER = @UserId
					group by t2.PMA_ID,t1.TRI_WHMFrom_ID,T1.TRI_WHMTo_ID,TRI_BUM_ID,t6.TRN_ID
				) tmp
				
			insert into #mmbo_TransferLot (TLT_TRL_ID,TLT_LOT_ID,TLT_ID,TLT_TransferLotQty,IAL_QRLOT_ID,IAL_QRLotNumber)
			select TRL_ID,LOT_ID,NEWID(),TLT_TransferLotQty,null,null FROM
			(select t6.TRL_ID,t5.LOT_ID,SUM(convert(decimal(18,6),TRI_TransferQty)) AS TLT_TransferLotQty
					from TransferInit t1,Product t2,Inventory t3,LotMaster t4,Lot t5,#mmbo_TransferLine t6,#mmbo_Transfer t7
					where t1.TRI_CFN_ID = t2.PMA_CFN_ID
					and t1.TRI_WHMFrom_ID = t3.INV_WHM_ID
					and t3.INV_PMA_ID = t2.PMA_ID
					and t2.PMA_ID = t4.LTM_Product_PMA_ID
					and t4.LTM_ID = t5.LOT_LTM_ID
					and t5.LOT_INV_ID = t3.INV_ID
					and t1.TRI_LotNumber = t4.LTM_LotNumber
					and t6.TRL_TRN_ID = t7.TRN_ID
					and t1.TRI_BUM_ID = t7.TRN_ProductLine_BUM_ID
					and t6.TRL_TransferPart_PMA_ID = t2.PMA_ID
					and t6.TRL_FromWarehouse_WHM_ID = t1.TRI_WHMFrom_ID
					and t6.TRL_ToWarehouse_WHM_ID = t1.TRI_WHMTo_ID
					and t1.TRI_WHMTypeFrom = t7.TRN_WarehouseType
					and t1.TRI_USER = @UserId
					group by t2.PMA_ID,t1.TRI_WHMFrom_ID,TRL_TRN_ID,t5.LOT_ID,T1.TRI_WHMTo_ID,TRI_BUM_ID,t6.TRL_ID
			) tmp
			
			--插入订单主表和明细表
			insert into [Transfer] select TRN_ID,TRN_TransferNumber,TRN_FromDealer_DMA_ID,TRN_Status,TRN_ToDealer_DMA_ID,TRN_Type,TRN_Description,TRN_Reverse_TRN_ID,TRN_TransferDate,TRN_ProductLine_BUM_ID,TRN_Transfer_USR_UserID from #mmbo_Transfer
			insert into TransferLine select TRL_TRN_ID,TRL_TransferPart_PMA_ID,TRL_ID,TRL_FromWarehouse_WHM_ID,TRL_ToWarehouse_WHM_ID,TRL_TransferQty,TRL_LineNbr from #mmbo_TransferLine
			insert into TransferLot(TLT_TRL_ID,TLT_LOT_ID,TLT_ID,TLT_TransferLotQty,IAL_QRLOT_ID,IAL_QRLotNumber) select TLT_TRL_ID,TLT_LOT_ID,TLT_ID,TLT_TransferLotQty,IAL_QRLOT_ID,IAL_QRLotNumber from #mmbo_TransferLot

			--插入订单操作日志
			INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
			SELECT NEWID(),TRN_ID,TRN_Transfer_USR_UserID,GETDATE(),'ExcelImport',NULL FROM #mmbo_Transfer
			
			--清除中间表的数据
			DELETE FROM TransferInit WHERE TRI_USER = @UserId
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


