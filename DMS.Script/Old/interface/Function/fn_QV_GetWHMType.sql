DROP Function [interface].[fn_QV_GetWHMType] 
GO


CREATE Function [interface].[fn_QV_GetWHMType] 
(@DealerId nvarchar(200),
 @UPN nvarchar(50),
 @Lot nvarchar(50)
)
returns  nvarchar(50)
as
Begin
    Declare @Type nvarchar(50)
    
	SELECT top 1 @Type=WHM_Type FROM DealerMaster (nolock)
left join Warehouse (nolock) on WHM_DMA_ID=DMA_ID
left join interface.InventoryDailyBackup(nolock) b on INV_WHM_ID=WHM_ID
left join  interface.LotDailyBackup  (nolock)c on INV_ID=LOT_INV_ID
left join LotMaster  (nolock) on LTM_ID=LOT_LTM_ID
left join Product (nolock) on PMA_ID=INV_PMA_ID
where DMA_ID=@DealerId
and  PMA_UPN=@UPN and LTM_LotNumber=@Lot
and b.INV_BAK_DATE='20140101' and c.LOT_BAK_DATE='20140101'
	
	return @Type

End

GO


