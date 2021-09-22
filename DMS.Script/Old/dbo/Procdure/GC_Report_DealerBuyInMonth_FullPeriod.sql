DROP PROCEDURE [dbo].[GC_Report_DealerBuyInMonth_FullPeriod]
GO



CREATE PROCEDURE [dbo].[GC_Report_DealerBuyInMonth_FullPeriod] 

AS
BEGIN

	SET NOCOUNT ON;


	--Çå³ý»º´æ±í
	EXEC('TRUNCATE TABLE Report_DealerBuyInMonth')


	INSERT INTO Report_DealerBuyInMonth
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
		COP_Month,
		M01,
		M02,
		M03,
		M04,
		M05,
		M06,
		M07,
		M08,
		M09,
		M10,
		M11,
		M12,
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
		COP_Month,
		M01,
		M02,
		M03,
		M04,
		M05,
		M06,
		M07,
		M08,
		M09,
		M10,
		M11,
		M12,
		Total
FROM
(
SELECT	
		PRH_Dealer_DMA_ID,
		PMA_CFN_ID,
		COP_Year,
		COP_Period as COP_Month,
		sum(Case COP_Period when '01M' then PRL_ReceiptQty else 0 end) as M01,
		sum(Case COP_Period when '02M' then PRL_ReceiptQty else 0 end) as M02,
		sum(Case COP_Period when '03M' then PRL_ReceiptQty else 0 end) as M03,
		sum(Case COP_Period when '04M' then PRL_ReceiptQty else 0 end) as M04,
		sum(Case COP_Period when '05M' then PRL_ReceiptQty else 0 end) as M05,
		sum(Case COP_Period when '06M' then PRL_ReceiptQty else 0 end) as M06,
		sum(Case COP_Period when '07M' then PRL_ReceiptQty else 0 end) as M07,
		sum(Case COP_Period when '08M' then PRL_ReceiptQty else 0 end) as M08,
		sum(Case COP_Period when '09M' then PRL_ReceiptQty else 0 end) as M09,
		sum(Case COP_Period when '10M' then PRL_ReceiptQty else 0 end) as M10,
		sum(Case COP_Period when '11M' then PRL_ReceiptQty else 0 end) as M11,
		sum(Case COP_Period when '12M' then PRL_ReceiptQty else 0 end) as M12,
		sum(PRL_ReceiptQty) as Total
FROM POReceiptHeader 
	inner join POReceipt on POReceipt.POR_PRH_ID = POReceiptHeader.PRH_ID
	inner join POReceiptLot on POReceiptLot.PRL_POR_ID = POReceipt.POR_ID
	inner join Product on Product.PMA_ID = POReceipt.POR_SAP_PMA_ID
	inner join COP on COP.COP_Type='M' and POReceiptHeader.PRH_ReceiptDate >= COP.COP_StartDate and POReceiptHeader.PRH_ReceiptDate < DateAdd(day, 1, COP.COP_EndDate)
WHERE PRH_Type = 'PurchaseOrder'
 and (PRH_Status = 'Complete')
group by 
		PRH_Dealer_DMA_ID,
		PMA_CFN_ID,
		COP_Year,
		COP_Period
) m
	inner join CFN on CFN.CFN_ID = m.PMA_CFN_ID
	inner join PartTreeLevel on PartTreeLevel.LastLevelID = CFN.CFN_ProductCatagory_PCT_ID
	inner join View_ProductLine on View_ProductLine.Id = PartTreeLevel.ProductLine_BUM_ID
	

END

GO


