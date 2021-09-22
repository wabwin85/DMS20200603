
/****** Object:  StoredProcedure [Workflow].[Proc_ConsignmentTransfer_GetHtmlData]    Script Date: 2019/12/17 18:04:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Workflow].[Proc_ConsignmentTransfer_GetHtmlData]
	@InstanceId uniqueidentifier
AS
DECLARE @ApplyType NVARCHAR(100)
SELECT @ApplyType = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

--模版信息，必须放在第一个查询结果，且只有固定的两个字段，名称不能变
SELECT @ApplyType AS TemplateName, 'Header,TransferConfirm' AS TableNames

--数据信息
--表头
SELECT TH_No AS [No],d.ProductLineName,C.DMA_ChineseShortName AS FromDealer,b.DMA_ChineseShortName AS ToDealerName ,TH_Remark AS Remark,li.IDENTITY_NAME AS SalesName
,T.CCH_BeginDate AS BeginDate,T.CCH_EndDate AS EndDate,
CCH_ConsignmentDay AS ConsignmentDay,CCH_DelayNumber AS DelayNumber
,CASE WHEN CCH_IsFixedMoney =1 THEN '是' ELSE '否' END IsFixedMoney
,CASE WHEN CCH_IsFixedQty =1 THEN '是' ELSE '否' END IsFixedQty
,CASE WHEN CCH_IsKB =1 THEN '是' ELSE '否' END IsKB
,CASE WHEN CCH_IsUseDiscount =1 THEN '是' ELSE '否' END IsUseDiscount
,CCH_Remark AS ContractRemark,CCH_Name AS ContractName
FROM Consignment.TransferHeader A 
INNER JOIN DealerMaster B ON A.TH_DMA_ID_To =B.DMA_ID
INNER JOIN DealerMaster C ON C.DMA_ID=A.TH_DMA_ID_From
INNER JOIN V_DivisionProductLineRelation D ON D.IsEmerging='0' AND D.ProductLineID=A.TH_ProductLine_BUM_ID
INNER JOIN Consignment.ContractHeader T ON T.CCH_ID=A.TH_CCH_ID
LEFT JOIN Lafite_IDENTITY li ON li.IDENTITY_CODE=A.TH_SalesAccount
WHERE A.TH_ID=@InstanceId

--确认明细
SELECT E.WHM_Name AS WarehouseName,f.PMA_UPN AS UPN,LotMaster.LTM_LotNumber AS LotNumber,c.TC_QTY AS QTY
,G.IDENTITY_NAME AS ConfirmUser,c.TC_ConfirmDate AS ConfirmDate
FROM 
Consignment.TransferHeader A 
INNER JOIN Consignment.TransferDetail B ON A.TH_ID=B.TD_TH_ID
INNER JOIN Consignment.TransferConfirm C ON B.TD_ID=C.TC_TD_ID
INNER JOIN Warehouse E ON E.WHM_ID=C.TC_WHM_ID
INNER JOIN Product F ON F.PMA_ID=C.TC_PMA_ID
INNER JOIN Lot ON LOT.LOT_ID=C.TC_LOT_ID
INNER JOIN LotMaster ON LOT.LOT_LTM_ID=LotMaster.LTM_ID
LEFT JOIN Lafite_IDENTITY G ON G.Id=C.TC_ConfirmUser
WHERE A.TH_ID=@InstanceId

