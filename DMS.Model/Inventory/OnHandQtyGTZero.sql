USE [DMS]
GO
/****** Object:  Trigger [tU_Lot]    Script Date: 07/21/2009 12:31:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Trigger [tU_Lot]    Script Date: 07/21/2009 12:32:21 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tU_Lot]'))
DROP TRIGGER [dbo].[tU_Lot]
GO

create trigger [tU_Lot] on [dbo].[Lot] for UPDATE as
begin

  if update(LOT_OnHandQty)
	if (select LOT_OnHandQty FROM inserted) < 0
  begin
	DECLARE @errmsg nvarchar(500)
	SELECT @errmsg = N'批次/序列号：'+LTM_LotNumber+N'的数量不足' FROM LotMaster,inserted WHERE LTM_ID = LOT_LTM_ID
	raiserror 81000 @errmsg
	rollback transaction	
  end

  return
error:
    raiserror 83000 'Error Occur'
    rollback transaction
end


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Trigger [tU_Inventory]    Script Date: 07/21/2009 12:34:02 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tU_Inventory]'))
DROP TRIGGER [dbo].[tU_Inventory]
GO

CREATE trigger [tU_Inventory] on [dbo].[Inventory] for UPDATE as
begin

  if update(INV_OnHandQuantity)
	if (select INV_OnHandQuantity FROM inserted) < 0
  begin
	DECLARE @errmsg nvarchar(500)
	SELECT @errmsg = N'仓库：'+WHM_Name+N'中的物料' FROM Warehouse,inserted WHERE WHM_ID = INV_WHM_ID
	SELECT @errmsg = @errmsg + PMA_Name+N'库存不足。' FROM Product,inserted WHERE PMA_ID = INV_PMA_ID

	--SELECT @errmsg = Convert(nvarchar(40),INV_WHM_ID) + Convert(nvarchar(40),INV_PMA_ID) + 'on hand qty < 0 ' FROM inserted
	raiserror 81000 @errmsg
	rollback transaction	
  end

  return
error:
    raiserror 83000 'Error Occur'
    rollback transaction
end


