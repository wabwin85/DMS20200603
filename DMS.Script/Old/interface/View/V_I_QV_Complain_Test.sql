DROP VIEW [interface].[V_I_QV_Complain_Test]
GO



CREATE VIEW [interface].[V_I_QV_Complain_Test]
AS
SELECT ComplainNbr --投诉单号
	,CreatedDate	--投诉时间
	,SAPID	
	,A.DMSCode
	,A.DivisionID
	,ProductLineName
	,UPN  
	,LOT  
	,QRCode
	,ExpiredDate	
	,ReturnNum	
	,NewUPN	--换新UPN
	,A.NewLot	--换新lot
	,A.NewQRCode	--换新qr
	,NewExpiredDate	--换新效期
	,WHM_ID		--仓库
	,WHMType	--产品物权
	,DN AS BSCComplainNbr	--波科全球投诉号
	,DN2 AS 'DN号'	--DN
	,ReturnType	--投诉类型
	,VALUE1 AS Status		--投诉流程状态
	,(
		SELECT max(pol_operdate)
		FROM PurchaseOrderLog
		WHERE POL_POH_ID = DC_ID
			AND POL_OperNote = 'eWorkflow提交投诉退货申请'
		) AS BSCCreateDate	--'波科发起投诉日期'
	,(
		SELECT max(pol_operdate)
		FROM PurchaseOrderLog
		WHERE POL_POH_ID = DC_ID
			AND POL_OperNote LIKE 'eWorkflow修改状态为:投诉已确认，请返回投诉产品%'
		) AS QACreateDate	--'波科QA投诉上报日期'
	,(
		SELECT max(pol_operdate)
		FROM PurchaseOrderLog
		WHERE POL_POH_ID = DC_ID
			AND POL_OperNote = 'eWorkflow修改状态为：投诉产品已收到'
		) AS BSCReceiptDate		--'投诉产品已收到日期'
	,(
		SELECT max(pol_operdate)
		FROM PurchaseOrderLog
		WHERE POL_POH_ID = DC_ID
			AND POL_OperNote = 'eWorkflow确认投诉换货类型'
		) AS QAConfirmDate	--'BU/QA最终确认时间'
	,(
		SELECT max(pol_operdate)
		FROM PurchaseOrderLog
		WHERE POL_POH_ID = DC_ID
			AND POL_OperNote = 'eWorkflow缺货'
		) AS BSCStockOutDate	--'波科确认库存无法满足的日期'
	,(
		SELECT max(pol_operdate)
		FROM PurchaseOrderLog
		WHERE POL_POH_ID = DC_ID
			AND POL_OperNote IN (
				'eWorkflow修改状态为：波科货物已发送'
				,'eWorkflow修改状态为：波科已换货给平台/T1'
				)
		) AS BSCExchangeDate	--'波科已换货给平台/T1'
	,(
		SELECT max(pol_operdate)
		FROM PurchaseOrderLog
		WHERE POL_POH_ID = DC_ID
			AND POL_OperNote = 'eWorkflow已完成审批'
		) AS BSCRefundDate	--'波科已退款给平台/T1'
	,CONVERT(DATETIME,NULL) AS BUApprovalDate	--BU审批日期
	,CONVERT(DATETIME,NULL) AS LPApprovalDate	--平台已换货或寄送退款协议给T2
FROM (
	SELECT DC.DC_ID
		,DC.DC_CreatedDate AS CreatedDate
		,'BSC' AS ComplainType
		,DC.DC_Status
		,DC.DC_CorpId AS DealerID
		,LI.IDENTITY_NAME
		,DC.DC_ComplainNbr AS ComplainNbr
		,UPN
		,substring(LOT, 1, charindex('@', lot, 1) - 1) AS LOT
		,substring(LOT, charindex('@', lot, 1) + 2, len(lot) - charindex('@', lot, 1) - 1) AS QRCode
		,LTM_ExpiredDate AS ExpiredDate
		,COMPLAINTID AS DN
		,CarrierNumber
		,CASE 
			WHEN CONFIRMRETURNTYPE = 10
				THEN '换货'
			ELSE CASE 
					WHEN CONFIRMRETURNTYPE = 11
						THEN '退款'
					ELSE '只退不换'
					END
			END AS ReturnType
		,DM.DMA_SAP_Code AS SAPID
		,HOS_Key_Account AS DMSCode
		,ld.VALUE1
		,ReturnNum
		,DN AS DN2
		,w.WHM_ID
		,ld2.VALUE1 AS WHMType
		,vd.DivisionCode AS DivisionID
		,ProductLineName
		,PMA_UPN AS NewUPN
		,CASE WHEN PMA_UPN IS NOT NULL THEN (CASE 
			WHEN ISNULL(PRL_LotNumber, '') <> ''
				THEN substring(PRL_LotNumber, 1, charindex('@', PRL_LotNumber, 1) - 1)
			ELSE ''
			END) ELSE NULL END AS NewLot
		,CASE WHEN PMA_UPN IS NOT NULL THEN (CASE 
			WHEN ISNULL(PRL_LotNumber, '') <> ''
				THEN substring(PRL_LotNumber, charindex('@', PRL_LotNumber, 1) + 2, len(PRL_LotNumber) - charindex('@', PRL_LotNumber, 1) - 1)
			ELSE 'NoQR'
			END) ELSE NULL END AS NewQRCode
		,PRL_ExpiredDate AS NewExpiredDate
	FROM DealerComplain DC
	INNER JOIN DealerMaster DM ON DC.DC_CorpId = DM.DMA_ID
	INNER JOIN Lafite_DICT LD ON DC_Status = LD.DICT_KEY
	INNER JOIN Lafite_IDENTITY LI ON DC.DC_CreatedBy = LI.Id
	INNER JOIN CFN ON UPN = CFN_CustomerFaceNbr
	INNER JOIN V_DivisionProductLineRelation vd ON CFN_ProductLine_BUM_ID = ProductLineID
	LEFT JOIN Hospital ON DC.DISTRIBUTORCUSTOMER = HOS_Key_Account
	INNER JOIN LotMaster ON LOT = LTM_LotNumber
	LEFT JOIN Warehouse w ON w.WHM_ID = dc.WHM_ID
	LEFT JOIN Lafite_DICT ld2 ON w.WHM_Type = ld2.DICT_KEY
		AND ld2.DICT_TYPE = 'MS_WarehouseType'
	LEFT JOIN POReceiptHeader PRH ON CASE 
			WHEN dc.DN IS NULL
				OR dc.DN = ''
				THEN 'NoDN'
			ELSE dc.DN
			END = PRH_SAPShipmentID
	LEFT JOIN POReceipt por ON PRH_ID = por.POR_PRH_ID
	LEFT JOIN POReceiptLot ON POR_ID = PRL_POR_ID
	LEFT JOIN Product ON POR_SAP_PMA_ID = PMA_ID
	WHERE ld.DICT_TYPE = 'CONST_QAComplainReturn_Status'
	
	UNION
	
	SELECT  DC.DC_ID
		,DC.DC_CreatedDate AS CreatedDate
		,'CRM' AS ComplainType
		,DC.DC_Status
		,DC.DC_CorpId AS DealerID
		,LI.IDENTITY_NAME
		,DC.DC_ComplainNbr AS ComplainNbr
		,Model AS UPN
		,substring(LOT, 1, charindex('@', lot, 1) - 1) AS LOT
		,substring(LOT, charindex('@', lot, 1) + 2, len(lot) - charindex('@', lot, 1) - 1) AS QRCode
		,LTM_ExpiredDate AS ExpiredDate
		,IAN AS DN
		,CarrierNumber
		,CASE 
			WHEN CONFIRMRETURNTYPE = 1
				THEN '换货'
			ELSE CASE 
					WHEN CONFIRMRETURNTYPE = 2
						THEN '退款'
					ELSE '只退不换'
					END
			END AS ReturnType
		,DM.DMA_SAP_Code AS SAPID
		,HOS_Key_Account AS DMSCode
		,ld.VALUE1
		,Returned
		,DN AS DN2
		,w.WHM_ID
		,ld2.VALUE1 AS WHMType
		,19 AS DivisionID
		,'心脏节律管理' AS ProductLineName
		,PMA_UPN AS NewUPN
		,CASE WHEN PMA_UPN IS NOT NULL THEN (CASE 
			WHEN ISNULL(PRL_LotNumber, '') <> ''
				THEN substring(PRL_LotNumber, 1, charindex('@', PRL_LotNumber, 1) - 1)
			ELSE ''
			END) ELSE NULL END AS NewLOT
		,CASE WHEN PMA_UPN IS NOT NULL THEN (CASE 
			WHEN ISNULL(PRL_LotNumber, '') <> ''
				THEN substring(PRL_LotNumber, charindex('@', PRL_LotNumber, 1) + 2, len(PRL_LotNumber) - charindex('@', PRL_LotNumber, 1) - 1)
			ELSE ''
			END) ELSE NULL END AS NewQRCode
		,PRL_ExpiredDate AS NewExpiredDate
	FROM DealerComplainCRM DC
	INNER JOIN DealerMaster DM ON DC.DC_CorpId = DM.DMA_ID
	INNER JOIN Lafite_DICT LD ON DC_Status = LD.DICT_KEY
	INNER JOIN Lafite_IDENTITY LI ON DC.DC_CreatedBy = LI.Id
	LEFT JOIN Hospital ON DC.DISTRIBUTORCUSTOMER = HOS_Key_Account
	INNER JOIN LotMaster ON LOT = LTM_LotNumber
	LEFT JOIN Warehouse w ON w.WHM_ID = dc.WHMID
	LEFT JOIN Lafite_DICT ld2 ON w.WHM_Type = ld2.DICT_KEY
		AND ld2.DICT_TYPE = 'MS_WarehouseType'
	LEFT JOIN POReceiptHeader PRH ON CASE 
			WHEN dc.DN IS NULL
				OR dc.DN = ''
				THEN 'NoDN'
			ELSE dc.DN
			END = PRH_SAPShipmentID
	LEFT JOIN POReceipt por ON PRH_ID = por.POR_PRH_ID
	LEFT JOIN POReceiptLot ON POR_ID = PRL_POR_ID
	LEFT JOIN Product ON POR_SAP_PMA_ID = PMA_ID
	WHERE ld.DICT_TYPE = 'CONST_QAComplainReturn_Status'
	) A



GO


