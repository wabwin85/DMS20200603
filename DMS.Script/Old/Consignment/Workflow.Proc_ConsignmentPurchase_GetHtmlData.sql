
/*
1. 功能名称：寄售买断发起MFlow
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [Workflow].[Proc_ConsignmentPurchase_GetHtmlData]
	@InstanceId uniqueidentifier
AS
DECLARE @ApplyType NVARCHAR(100)
SELECT @ApplyType = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

--模版信息，必须放在第一个查询结果，且只有固定的两个字段，名称不能变
SELECT @ApplyType AS TemplateName, 'Header,ADDProduct' AS TableNames


--寄售买断信息
select IAH_Inv_Adj_Nbr,IDENTITY_NAME,IAH_CreatedDate,D.VALUE1 AS IAH_Status,DMA_ChineseName,
ProductLineName,T.VALUE1,Name as SaleRep,IAH_UserDescription
from InventoryAdjustHeader 
left join Lafite_IDENTITY on Lafite_IDENTITY.Id=InventoryAdjustHeader.IAH_CreatedBy_USR_UserID
left join DealerMaster on DealerMaster.DMA_ID=InventoryAdjustHeader.IAH_DMA_ID
left join V_DivisionProductLineRelation on V_DivisionProductLineRelation.ProductLineID=InventoryAdjustHeader.IAH_ProductLine_BUM_ID
left join Lafite_DICT AS T on T.DICT_KEY=InventoryAdjustHeader.IAH_Reason and T.DICT_TYPE='CONST_AdjustQty_Type'
left join Lafite_DICT AS D on D.DICT_KEY=InventoryAdjustHeader.IAH_Status and D.DICT_TYPE='CONST_AdjustQty_Status'
left join interface.T_I_QV_SalesRep as S on S.UserAccount=InventoryAdjustHeader.SaleRep
where IAH_ID=@InstanceId


--添加产品
select Warehouse.WHM_Name as WarehouseName,Product.PMA_UPN as UPN,CFN.CFN_ChineseName as ChineseName,Product.PMA_ConvertFactor,
substring(i.IAL_LotNumber,1,CHARINDEX('@@',i.IAL_LotNumber,0)-1) AS LotNumber,
substring(i.IAL_LotNumber,CHARINDEX('@@',i.IAL_LotNumber,0)+2,LEN(i.IAL_LotNumber)-CHARINDEX('@@',i.IAL_LotNumber,0)) as QRCode,
case when CFN_Property6 = '0' then CONVERT(varchar(8), IAL_ExpiredDate, 112) else CONVERT(varchar(100), IAL_ExpiredDate, 112) END AS LotExpiredDate,
PMA_UnitOfMeasure as UnitOfMeasure,
SUM(Convert(decimal(18,0),Lot.LOT_OnHandQty)) AS LotInvQty,
IAL_LotQty,
Convert(decimal(18,2),IAL_UnitPrice)as Price,
sum(IAL_LotQty*IAL_UnitPrice) as SumPrice,
i.IAL_Remark as Remark
from InventoryAdjustLot i
left join Warehouse on Warehouse.WHM_ID=i.IAL_WHM_ID
left join InventoryAdjustDetail on InventoryAdjustDetail.IAD_ID=i.IAL_IAD_ID
left join Product on Product.PMA_ID=InventoryAdjustDetail.IAD_PMA_ID
left join CFN on CFN.CFN_ID=Product.PMA_CFN_ID
left join Lot on Lot.LOT_ID=i.IAL_LOT_ID
left join InventoryAdjustHeader on InventoryAdjustHeader.IAH_ID=InventoryAdjustDetail.IAD_IAH_ID
where IAL_IAD_ID in (select IAD_ID from InventoryAdjustDetail
where IAD_IAH_ID=@InstanceId)
group by Warehouse.WHM_Name,Product.PMA_UPN,CFN.CFN_ChineseName,Product.PMA_ConvertFactor,i.IAL_LotNumber,CFN.CFN_Property6,IAL_ExpiredDate,Product.PMA_UnitOfMeasure,
InventoryAdjustHeader.IAH_Status,Lot.LOT_OnHandQty,Lot.LOT_OnHandQty,Lot.LOT_OnHandQty,IAL_LotQty,IAL_UnitPrice,IAL_Remark

