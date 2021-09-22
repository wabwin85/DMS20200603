
DROP PROC [interface].[P_Stage_BeforeUpdateInventory]
GO

CREATE PROC [interface].[P_Stage_BeforeUpdateInventory]
AS
BEGIN

	--库存移动类型
	SELECT TRN_ID,OperType
	INTO #TO
	FROM(
		SELECT t1.TRN_ID
			,t2.POL_OperType  AS OperType
			,ROW_NUMBER() OVER(PARTITION BY t2.POL_POH_ID ORDER BY t2.POL_OperDate DESC) AS RID
		FROM Transfer t1(NOLOCK)
			,PurchaseOrderLog t2(NOLOCK)
		WHERE t1.TRN_ID = t2.POL_POH_ID 
			AND t2.POL_OperType IN ('Generate', 'CreateShipment', 'Submit')
			AND t2.POL_OperDate>=GETDATE()-2
		) a WHERE RID=1
		
	DELETE Interface.Stage_V_DealerInvTransferOperType
	WHERE TRN_ID IN (SELECT TRN_ID FROM #TO)
	
	INSERT INTO Interface.Stage_V_DealerInvTransferOperType
	SELECT TRN_ID,OperType,GETDATE(),'Zengj3' FROM #TO
	
	DROP TABLE #TO


	--库存移动数据来源
	SELECT QRC_QRCode,DataSrc
	INTO #TD
	FROM(
		SELECT QRC_QRCode
			,isnull(QRC_BarCode2, 'FWRW') AS DataSrc
			,ROW_NUMBER() OVER(PARTITION BY QRC_QRCode ORDER BY QRC_CreateDate DESC) AS RID
		FROM interface.T_I_WC_DealerBarcodeQRcodeScan(NOLOCK)
		WHERE QRC_BarCode1 IN ('移库')
			AND QRC_CreateDate>=GETDATE()-2
	)A WHERE RID=1
	
	DELETE Interface.Stage_V_DealerInvTransferDataSrc
	WHERE QRC_QRCode IN (SELECT QRC_QRCode FROM #TD)
	
	INSERT INTO Interface.Stage_V_DealerInvTransferDataSrc
	SELECT QRC_QRCode,DataSrc,GETDATE(),'Zengj3' FROM #TD
	
	DROP TABLE #TD	


	--库存接收时间
	SELECT H.PRH_Dealer_DMA_ID
			,L.POR_SAP_PMA_ID
			,T.PRL_LotNumber
			,MAX(ISNULL(PRH_ReceiptDate, POL_OperDate)) AS ReceiptDate
	INTO #TR
	FROM POReceiptHeader H(NOLOCK)
	INNER JOIN POReceipt L(NOLOCK)
		ON H.PRH_ID = L.POR_PRH_ID
	INNER JOIN POReceiptLot T(NOLOCK)
		ON L.POR_ID = T.PRL_POR_ID
	LEFT JOIN purchaseorderlog (NOLOCK) PL	
		ON  pl.POL_POH_ID=H. PRH_ID AND PL.POL_OperType='Confirm'
	where H.PRH_Status = 'Complete'
		AND (PRH_ReceiptDate>=GETDATE()-2 OR POL_OperDate>=GETDATE()-2)
	GROUP BY POR_SAP_PMA_ID
		,PRH_Dealer_DMA_ID
		,PRL_LotNumber
	
	DELETE Interface.Stage_V_Receipt_UPNLOT_MaxReceiptDate
	FROM Interface.Stage_V_Receipt_UPNLOT_MaxReceiptDate A
	INNER JOIN #TR R
		ON A.WHM_ID=R.PRH_Dealer_DMA_ID
		AND A.PMA_ID=R.POR_SAP_PMA_ID
		AND A.LotNumber=R.PRL_LotNumber
		
	INSERT INTO Interface.Stage_V_Receipt_UPNLOT_MaxReceiptDate
	SELECT PRH_Dealer_DMA_ID,POR_SAP_PMA_ID,PRL_LotNumber,ReceiptDate,GETDATE(),'Zengj3' FROM #TR
	
	DROP TABLE #TR
	

	--库存移库时间
	SELECT L.TRL_ToWarehouse_WHM_ID
		,L.TRL_TransferPart_PMA_ID
		,LM.LTM_LotNumber
		,max(TF.TRN_TransferDate) AS TransferDate
	INTO #tt
	FROM [Transfer] TF(NOLOCK)
		,TransferLine L(NOLOCK)
		,TransferLot T(NOLOCK)
		,Lot LT(NOLOCK)
		,LotMaster LM(NOLOCK)
	WHERE TF.TRN_ID = L.TRL_TRN_ID 
		AND L.TRL_ID = T.TLT_TRL_ID 
		AND ISNULL(T.IAL_QRLOT_ID, T.TLT_LOT_ID) = LT.LOT_ID 
		AND LT.LOT_LTM_ID = LM.LTM_ID 
		AND TF.TRN_Type IN ('Transfer', 'TransferConsignment')
		AND TF.TRN_TransferDate>=GETDATE()-2
	GROUP BY L.TRL_TransferPart_PMA_ID
		,L.TRL_ToWarehouse_WHM_ID
		,LM.LTM_LotNumber
		
	DELETE Interface.Stage_V_Transfer_UPNLOT_MaxTransferDate
	FROM Interface.Stage_V_Transfer_UPNLOT_MaxTransferDate a
	INNER JOIN #TT T
		ON A.WHM_ID=T.TRL_ToWarehouse_WHM_ID
		AND A.PMA_ID=T.TRL_TransferPart_PMA_ID
		AND A.LotNumber=T.LTM_LotNumber
		
	INSERT INTO Interface.Stage_V_Transfer_UPNLOT_MaxTransferDate
	SELECT TRL_ToWarehouse_WHM_ID,TRL_TransferPart_PMA_ID,LTM_LotNumber,TransferDate,GETDATE(),'Zengj3' FROM #TT
	
	DROP TABLE #TT

END



GO


