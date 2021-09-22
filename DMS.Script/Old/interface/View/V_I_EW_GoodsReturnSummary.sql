DROP view [interface].[V_I_EW_GoodsReturnSummary]
GO



CREATE view [interface].[V_I_EW_GoodsReturnSummary]
as 
 
 SELECT 
        DMA_ChineseName AS Dealer,
        IAH_Inv_Adj_Nbr AS ReturnNo,
        CONVERT(varchar(100), IAH_CreatedDate, 112) AS ReturnDate,
        --Lafite_IDENTITY.IDENTITY_NAME AS N'退货人',
        convert(nvarchar(20),VALUE1)  AS RStatus,
        --IAH_UserDescription N'退货原因',
        --IAH_AuditorNotes N'审批意见',
        ATTRIBUTE_NAME as ProductLine,
        --Warehouse.WHM_Name N'仓库',
        --Product.PMA_UPN AS N'产品型号',
        --ISNULL(LotMaster.LTM_LotNumber, ajlot.IAL_LotNumber) AS  N'产品序列号/批号',
        --case when CFN_Property6 = '0' then CONVERT(varchar(6), ISNULL(LotMaster.LTM_ExpiredDate, ajlot.IAL_ExpiredDate), 112) else CONVERT(varchar(100), ISNULL(LotMaster.LTM_ExpiredDate, ajlot.IAL_ExpiredDate), 112) END AS N'有效期',
        --Product.PMA_UnitOfMeasure AS N'单位',
        --ISNULL(Lot.LOT_OnHandQty, dbo.fn_getCurrentInventoryQtyByLotNumber(Warehouse.WHM_DMA_ID, detail.IAD_PMA_ID, ajlot.IAL_LotNumber,Warehouse.WHM_ID)) AS N'库存数量',
        --CONVERT(varchar(100), LotMaster.LTM_CreatedDate, 112) as N'入库时间',
        SUM(ajlot.IAL_LotQty) AS Qty
        ,SUM (dbo.[fn_GetPriceByDealerForBSCPO](DMA_ID,CFN_ID,'Dealer')) as Amount
        FROM InventoryAdjustHeader head with(nolock) 
        --LEFT OUTER JOIN Lafite_IDENTITY ON Lafite_IDENTITY.id = head.IAH_CreatedBy_USR_UserID
        left join InventoryAdjustDetail detail with(nolock)  on detail.IAD_IAH_ID=head.IAH_ID
        left join InventoryAdjustLot ajlot with(nolock)  on ajlot.IAL_IAD_ID = detail.IAD_ID
        left JOIN Product with(nolock)  ON detail.IAD_PMA_ID = Product.PMA_ID
        left JOIN CFN with(nolock)  ON Product.PMA_CFN_ID = CFN.CFN_ID
        left join DealerMaster with(nolock)  on head.IAH_DMA_ID=DMA_ID 
        --left  JOIN Warehouse ON ajlot.IAL_WHM_ID = Warehouse.WHM_ID
        --LEFT OUTER JOIN Lot ON ajlot.IAL_LOT_ID = Lot.LOT_ID
        --LEFT OUTER JOIN LotMaster ON Lot.LOT_LTM_ID = LotMaster.LTM_ID
        left join View_ProductLine v on v.Id=CFN.CFN_ProductLine_BUM_ID
        left join Lafite_DICT d with(nolock)  on d.DICT_KEY=IAH_Status and DICT_TYPE= 'CONST_AdjustQty_Status'
        WHERE IAH_Reason = 'Return' 
        and DMA_DealerType in ('T1','LP')
        and VALUE1<>'草稿'
        group by  DMA_ChineseName, 
        IAH_Inv_Adj_Nbr ,
        CONVERT(varchar(100), IAH_CreatedDate, 112), 
        --Lafite_IDENTITY.IDENTITY_NAME ,
        VALUE1 ,ATTRIBUTE_NAME


GO


