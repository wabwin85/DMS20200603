DROP VIEW [dbo].[V_ComplainList]
GO






CREATE VIEW [dbo].[V_ComplainList]
AS
	SELECT DC_ComplainNbr AS ComplainNbr,
			DC_CreatedDate AS ComplainDate,
			dc_status AS ComplainStatus,
			UPN AS ShortUPN,
			UPN,
			CASE WHEN charindex('@@',LOT) > 0 
				THEN substring(LOT,1,charindex('@@',LOT)-1) 
				ELSE LOT
				END AS ComplainLOT,
			CASE WHEN charindex('@@',LOT) > 0
				THEN substring(LOT,charindex('@@',LOT)+2,len(LOT)) 
				ELSE ''
				END AS ComplainQRCode,      
			ReturnNum AS ComplainQty,
			COMPLAINTID AS BscComplainNo,
			DN AS ReceiptNo,
			t2.WHM_Name AS WarehouseName,
			t2.WHM_Type AS WarehousetType,
			t1.DC_CorpId,
			t1.WHM_ID,
			t2.WHM_DMA_ID
		FROM DealerComplain t1
		INNER JOIN Warehouse t2 ON t1.WHM_ID = t2.WHM_ID
	WHERE DC_Status IN ('Delivered', 'DealerCompleted', 'Completed')	
	UNION
	SELECT DC_ComplainNbr AS ComplainNbr,
		   DC_CreatedDate AS ComplainDate,
		   dc_status AS ComplainStatus,
		   Model AS ShortUPN,
		   Serial AS UPN,
		   CASE WHEN charindex('@@',LOT) > 0 
				THEN substring(LOT,1,charindex('@@',LOT)-1) 
				ELSE LOT
				END AS ComplainLOT,
		   CASE WHEN charindex('@@',LOT) > 0
				THEN substring(LOT,charindex('@@',LOT)+2,len(LOT)) 
				ELSE ''
				END AS ComplainQRCode,
		   '1' AS ComplainQty,
		   isnull (IAN, PI) AS BscComplainNo,
		   DN AS ReceiptNo,
		   t2.WHM_Name AS WarehouseName,
		   t2.WHM_Type AS WarehousetType,
		   t1.DC_CorpId,
		   t1.WHMID AS WHM_ID,
		   t2.WHM_DMA_ID
	  FROM DealerComplainCRM t1 
	  INNER JOIN Warehouse t2 ON t1.WHMID = t2.WHM_ID
	WHERE DC_Status IN ('Delivered', 'DealerCompleted', 'Completed')		










GO


