DROP VIEW [interface].[V_I_QV_Complain_Test]
GO



CREATE VIEW [interface].[V_I_QV_Complain_Test]
AS
SELECT ComplainNbr --Ͷ�ߵ���
	,CreatedDate	--Ͷ��ʱ��
	,SAPID	
	,A.DMSCode
	,A.DivisionID
	,ProductLineName
	,UPN  
	,LOT  
	,QRCode
	,ExpiredDate	
	,ReturnNum	
	,NewUPN	--����UPN
	,A.NewLot	--����lot
	,A.NewQRCode	--����qr
	,NewExpiredDate	--����Ч��
	,WHM_ID		--�ֿ�
	,WHMType	--��Ʒ��Ȩ
	,DN AS BSCComplainNbr	--����ȫ��Ͷ�ߺ�
	,DN2 AS 'DN��'	--DN
	,ReturnType	--Ͷ������
	,VALUE1 AS Status		--Ͷ������״̬
	,(
		SELECT max(pol_operdate)
		FROM PurchaseOrderLog
		WHERE POL_POH_ID = DC_ID
			AND POL_OperNote = 'eWorkflow�ύͶ���˻�����'
		) AS BSCCreateDate	--'���Ʒ���Ͷ������'
	,(
		SELECT max(pol_operdate)
		FROM PurchaseOrderLog
		WHERE POL_POH_ID = DC_ID
			AND POL_OperNote LIKE 'eWorkflow�޸�״̬Ϊ:Ͷ����ȷ�ϣ��뷵��Ͷ�߲�Ʒ%'
		) AS QACreateDate	--'����QAͶ���ϱ�����'
	,(
		SELECT max(pol_operdate)
		FROM PurchaseOrderLog
		WHERE POL_POH_ID = DC_ID
			AND POL_OperNote = 'eWorkflow�޸�״̬Ϊ��Ͷ�߲�Ʒ���յ�'
		) AS BSCReceiptDate		--'Ͷ�߲�Ʒ���յ�����'
	,(
		SELECT max(pol_operdate)
		FROM PurchaseOrderLog
		WHERE POL_POH_ID = DC_ID
			AND POL_OperNote = 'eWorkflowȷ��Ͷ�߻�������'
		) AS QAConfirmDate	--'BU/QA����ȷ��ʱ��'
	,(
		SELECT max(pol_operdate)
		FROM PurchaseOrderLog
		WHERE POL_POH_ID = DC_ID
			AND POL_OperNote = 'eWorkflowȱ��'
		) AS BSCStockOutDate	--'����ȷ�Ͽ���޷����������'
	,(
		SELECT max(pol_operdate)
		FROM PurchaseOrderLog
		WHERE POL_POH_ID = DC_ID
			AND POL_OperNote IN (
				'eWorkflow�޸�״̬Ϊ�����ƻ����ѷ���'
				,'eWorkflow�޸�״̬Ϊ�������ѻ�����ƽ̨/T1'
				)
		) AS BSCExchangeDate	--'�����ѻ�����ƽ̨/T1'
	,(
		SELECT max(pol_operdate)
		FROM PurchaseOrderLog
		WHERE POL_POH_ID = DC_ID
			AND POL_OperNote = 'eWorkflow���������'
		) AS BSCRefundDate	--'�������˿��ƽ̨/T1'
	,CONVERT(DATETIME,NULL) AS BUApprovalDate	--BU��������
	,CONVERT(DATETIME,NULL) AS LPApprovalDate	--ƽ̨�ѻ���������˿�Э���T2
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
				THEN '����'
			ELSE CASE 
					WHEN CONFIRMRETURNTYPE = 11
						THEN '�˿�'
					ELSE 'ֻ�˲���'
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
				THEN '����'
			ELSE CASE 
					WHEN CONFIRMRETURNTYPE = 2
						THEN '�˿�'
					ELSE 'ֻ�˲���'
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
		,'������ɹ���' AS ProductLineName
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


