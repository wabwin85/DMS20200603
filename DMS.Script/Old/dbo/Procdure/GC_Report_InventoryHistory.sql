DROP procedure [dbo].[GC_Report_InventoryHistory]
GO


create procedure [dbo].[GC_Report_InventoryHistory]
AS
BEGIN

	SET NOCOUNT ON;
  DECLARE @CNT int;
  
    select @CNT = count(*) from ReportInventoryHistory where RIH_Period = convert(varchar(6),DATEADD(mm,-1,getdate()),112)
  
   IF(isnull(@CNT,0) = 0)
   BEGIN
    INSERT INTO ReportInventoryHistory 
    select newid(),
    substring(convert(varchar(6),DATEADD(mm,-1,getdate()),112),1,6) as Period,
    DMA_ID,PMA_ID,WHM_ID,LTM_ID,OnHandQuantity,0 as Amount,'00000000-0000-0000-0000-000000000000',getdate(),'00000000-0000-0000-0000-000000000000',getdate()
    from 
    (
      /*从库存表中取得记录*/
      select dm.DMA_ID, pro.PMA_ID,
          wh.WHM_ID,
          ltm.LTM_ID,
          ltm.LTM_InitialQty,
          ltm.LTM_LotNumber,
          ltm.LTM_ExpiredDate,
          sum(LOT_OnHandQty) as OnHandQuantity
          
      from inventory inv,lot,Warehouse wh,DealerMaster dm,
      product p,cfn,lotmaster ltm,Product pro
      where Lot.LOT_INV_ID = inv.INV_ID
      and inv.INV_WHM_ID = wh.WHM_ID
      and wh.WHM_DMA_ID = dm.DMA_ID
      and inv.INV_PMA_ID = p.PMA_ID
      and p.PMA_CFN_ID = CFN.CFN_ID
      and Lot.LOT_LTM_ID = ltm.LTM_ID
      and pro.PMA_CFN_ID = cfn.CFN_ID
      group by dm.DMA_ID, pro.PMA_ID,
          wh.WHM_ID,
          ltm.LTM_ID,
          ltm.LTM_InitialQty,
          ltm.LTM_LotNumber,
          ltm.LTM_ExpiredDate
    ) tab
    where OnHandQuantity <> 0

    END

END


GO


