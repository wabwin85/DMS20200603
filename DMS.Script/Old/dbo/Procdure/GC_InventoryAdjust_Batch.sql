DROP Procedure [dbo].[GC_InventoryAdjust_Batch]
GO


/*
经销商库存调整批处理
*/
CREATE Procedure [dbo].[GC_InventoryAdjust_Batch]
	@DealerId uniqueidentifier,
    @WarehouseId uniqueidentifier,
	@Reason nvarchar(50)
AS

SET NOCOUNT ON

BEGIN TRY	

BEGIN TRAN

	CREATE TABLE #TMP_DATA
	(
		DMA_ID uniqueidentifier,
		WHM_ID uniqueidentifier,
		BUM_ID uniqueidentifier,
		PMA_ID uniqueidentifier,
		LOT_ID uniqueidentifier,
		LotNumber nvarchar(20),
		ExpiredDate datetime,
		OnHandQty float
	)
	
	create table #TMP_HEADER (
	   HEADER_ID               uniqueidentifier     not null,
	   DMA_ID           uniqueidentifier     not null,
	   Reason           nvarchar(50)         collate Chinese_PRC_CI_AS null,
	   CreatedDate      datetime             not null,
	   CreatedUser uniqueidentifier     not null,
	   UserDescription  nvarchar(2000)       collate Chinese_PRC_CI_AS null,
	   Status           nvarchar(50)         collate Chinese_PRC_CI_AS null,
	   BUM_ID uniqueidentifier     null,
	   primary key (HEADER_ID)
	)
	
	create table #TMP_LINE (
	   LINE_ID               uniqueidentifier     not null,
	   HEADER_ID           uniqueidentifier     not null,
	   PMA_ID           uniqueidentifier     not null,
	   Quantity         float                not null,
	   LineNbr          int                  null,
	   primary key (LINE_ID)
	)

	create table #TMP_DETAIL (
	   DETAIL_ID               uniqueidentifier     not null,
	   LINE_ID           uniqueidentifier     not null,
	   LotQty           float                not null,
	   LOT_ID           uniqueidentifier     null,
	   WHM_ID           uniqueidentifier     null,
	   LotNumber        nvarchar(20)         collate Chinese_PRC_CI_AS null,
	   ExpiredDate      datetime             null,
	   primary key (DETAIL_ID)
	)

	--将经销商制定仓库的库存信息放入临时表
	INSERT INTO #TMP_DATA
	select @DealerId,@WarehouseId,c.CFN_ProductLine_BUM_ID,i.INV_PMA_ID,l.LOT_ID,lm.LTM_LotNumber,
	lm.LTM_ExpiredDate,l.LOT_OnHandQty 
	from Inventory as i
	inner join Lot as l on l.LOT_INV_ID = i.INV_ID
	inner join LotMaster as lm on l.LOT_LTM_ID = lm.LTM_ID
	inner join Product as p on i.INV_PMA_ID = p.PMA_ID
	inner join CFN as c on p.PMA_CFN_ID = c.CFN_ID
	where i.INV_WHM_ID = @WarehouseId
	and l.LOT_OnHandQty <> 0
	
	--根据产品线生成表头
	INSERT INTO #TMP_HEADER
	SELECT NEWID(),DMA_ID,@Reason,GETDATE(),'b3c064c1-902e-44c1-8a5a-b0bc569cd80f','系统批处理','Draft',BUM_ID
	FROM (SELECT DMA_ID,BUM_ID FROM #TMP_DATA GROUP BY DMA_ID,BUM_ID) AS HEADER
	
	--根据产品型号生成行
	INSERT INTO #TMP_LINE
	SELECT NEWID(),HEADER.HEADER_ID,PMA_ID,QTY,ROW_NUMBER() OVER (ORDER BY PMA_ID)
	FROM (SELECT DMA_ID,BUM_ID,PMA_ID,SUM(OnHandQty) AS QTY FROM #TMP_DATA GROUP BY DMA_ID,BUM_ID,PMA_ID) AS LINE
	INNER JOIN #TMP_HEADER AS HEADER
	ON HEADER.DMA_ID = LINE.DMA_ID AND HEADER.BUM_ID = LINE.BUM_ID
	
	--根据批次生成明细
	INSERT INTO #TMP_DETAIL
	SELECT NEWID(),LINE.LINE_ID,OnHandQty,DETAIL.LOT_ID,DETAIL.WHM_ID,DETAIL.LotNumber,DETAIL.ExpiredDate
	FROM #TMP_DATA AS DETAIL,#TMP_LINE AS LINE,#TMP_HEADER AS HEADER
	WHERE HEADER.HEADER_ID = LINE.HEADER_ID
	AND HEADER.DMA_ID = DETAIL.DMA_ID
	AND HEADER.BUM_ID = DETAIL.BUM_ID
	AND LINE.PMA_ID = DETAIL.PMA_ID
	
	--生成单据（草稿）
	INSERT INTO InventoryAdjustHeader (IAH_ID,IAH_DMA_ID,IAH_Reason,IAH_CreatedDate,IAH_CreatedBy_USR_UserID,
	IAH_UserDescription,IAH_Status,IAH_ProductLine_BUM_ID)
	SELECT HEADER_ID,DMA_ID,Reason,CreatedDate,CreatedUser,UserDescription,Status,BUM_ID
	FROM #TMP_HEADER
	
	INSERT INTO InventoryAdjustDetail (IAD_ID,IAD_IAH_ID,IAD_PMA_ID,IAD_Quantity,IAD_LineNbr)
	SELECT LINE_ID,HEADER_ID,PMA_ID,Quantity,LineNbr FROM #TMP_LINE
	
	INSERT INTO InventoryAdjustLot (IAL_ID,IAL_IAD_ID,IAL_LOT_ID,IAL_WHM_ID,IAL_LotQty,IAL_LotNumber,IAL_ExpiredDate)
	SELECT DETAIL_ID,LINE_ID,LOT_ID,WHM_ID,LotQty,LotNumber,ExpiredDate FROM #TMP_DETAIL
	
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    return -1
    
END CATCH




GO


