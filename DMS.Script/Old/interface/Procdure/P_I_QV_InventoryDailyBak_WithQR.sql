DROP Proc [interface].[P_I_QV_InventoryDailyBak_WithQR]
GO


CREATE Proc [interface].[P_I_QV_InventoryDailyBak_WithQR]

AS

declare @date varchar(8)

set @date=convert(varchar(8),getdate(),112)

INSERT INTO [interface].[T_I_QV_InventoryDailyBak_WithQR](
		[DealerID]
      ,[SAPID]
      ,[UPN]
      ,[QTY]
      ,[WHM_Code]
      ,[Lot]
      ,[QRCode]
      ,[DivisionID]
      ,[InventoryBakDate]
)
SELECT [DealerID]
      ,[SAPID]
      ,[UPN]
      ,[QTY]
      ,[WHM_Code]
      ,[Lot]
      ,[QRCode]
      ,[DivisionID]
      ,[InventoryBakDate]
FROM [interface].[V_I_QV_InventoryDailyBak_WithQR] 
where InventoryBakDate=@date


GO


