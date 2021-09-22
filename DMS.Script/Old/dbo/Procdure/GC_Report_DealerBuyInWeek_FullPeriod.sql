DROP PROCEDURE [dbo].[GC_Report_DealerBuyInWeek_FullPeriod] 
GO



CREATE PROCEDURE [dbo].[GC_Report_DealerBuyInWeek_FullPeriod] 

AS
BEGIN

	SET NOCOUNT ON;


	--Çå³ý»º´æ±í
	EXEC('TRUNCATE TABLE Report_DealerBuyInWeek')


	INSERT INTO Report_DealerBuyInWeek
(
		DMA_ID,
		CFN_ID,
		ProductLine_BUM_ID,
		ProductLineName,
		L1Name,
		L2Name,
		L3Name,
		L4Name,
		L5Name,
		CFN_Name,
		COP_Year,
		COP_Quarter,
		COP_Week,
		W01,
		W02,
		W03,
		W04,
		W05,
		W06,
		W07,
		W08,
		W09,
		W10,
		W11,
		W12,
		W13,
		W14,
		Total
)
SELECT 
		PRH_Dealer_DMA_ID,
		PMA_CFN_ID,
		PartTreeLevel.ProductLine_BUM_ID,
		View_ProductLine.Attribute_Name as ProductLineName,
		L1Name,
		L2Name,
		L3Name,
		L4Name,
		L5Name,
		CFN_CustomerFaceNbr,
		COP_Year,
		COP_Quarter,
		COP_Week,
		W01,
		W02,
		W03,
		W04,
		W05,
		W06,
		W07,
		W08,
		W09,
		W10,
		W11,
		W12,
		W13,
		W14,
		Total
FROM
(
SELECT	
		PRH_Dealer_DMA_ID,
		PMA_CFN_ID,
		COP_W.COP_Year,
		COP_Q.COP_Period as COP_Quarter,
		COP_W.COP_Period as COP_Week,
		sum(Case COP_W.COP_QW when 'W1' then PRL_ReceiptQty else 0 end) as W01,
		sum(Case COP_W.COP_QW when 'W2' then PRL_ReceiptQty else 0 end) as W02,
		sum(Case COP_W.COP_QW when 'W3' then PRL_ReceiptQty else 0 end) as W03,
		sum(Case COP_W.COP_QW when 'W4' then PRL_ReceiptQty else 0 end) as W04,
		sum(Case COP_W.COP_QW when 'W5' then PRL_ReceiptQty else 0 end) as W05,
		sum(Case COP_W.COP_QW when 'W6' then PRL_ReceiptQty else 0 end) as W06,
		sum(Case COP_W.COP_QW when 'W7' then PRL_ReceiptQty else 0 end) as W07,
		sum(Case COP_W.COP_QW when 'W8' then PRL_ReceiptQty else 0 end) as W08,
		sum(Case COP_W.COP_QW when 'W9' then PRL_ReceiptQty else 0 end) as W09,
		sum(Case COP_W.COP_QW when 'W10' then PRL_ReceiptQty else 0 end) as W10,
		sum(Case COP_W.COP_QW when 'W11' then PRL_ReceiptQty else 0 end) as W11,
		sum(Case COP_W.COP_QW when 'W12' then PRL_ReceiptQty else 0 end) as W12,
		sum(Case COP_W.COP_QW when 'W13' then PRL_ReceiptQty else 0 end) as W13,
		sum(Case COP_W.COP_QW when 'W14' then PRL_ReceiptQty else 0 end) as W14,
		sum(PRL_ReceiptQty) as Total
FROM POReceiptHeader 
	inner join POReceipt on POReceipt.POR_PRH_ID = POReceiptHeader.PRH_ID
	inner join POReceiptLot on POReceiptLot.PRL_POR_ID = POReceipt.POR_ID
	inner join Product on Product.PMA_ID = POReceipt.POR_SAP_PMA_ID
	inner join COP as COP_W on COP_W.COP_Type='W' and POReceiptHeader.PRH_ReceiptDate >= COP_W.COP_StartDate and POReceiptHeader.PRH_ReceiptDate < DateAdd(day, 1, COP_W.COP_EndDate)
	inner join COP as COP_Q on COP_Q.COP_Type='Q' and POReceiptHeader.PRH_ReceiptDate >= COP_Q.COP_StartDate and POReceiptHeader.PRH_ReceiptDate < DateAdd(day, 1, COP_Q.COP_EndDate)
WHERE PRH_Type = 'PurchaseOrder'
 and (PRH_Status = 'Complete')
group by 
		PRH_Dealer_DMA_ID,
		PMA_CFN_ID,
		COP_W.COP_Year,
		COP_Q.COP_Period,
		COP_W.COP_Period
) m
	inner join CFN on CFN.CFN_ID = m.PMA_CFN_ID
	inner join PartTreeLevel on PartTreeLevel.LastLevelID = CFN.CFN_ProductCatagory_PCT_ID
	inner join View_ProductLine on View_ProductLine.Id = PartTreeLevel.ProductLine_BUM_ID
	

END

GO


