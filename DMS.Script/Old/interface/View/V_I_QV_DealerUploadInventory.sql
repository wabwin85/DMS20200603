DROP view [interface].[V_I_QV_DealerUploadInventory]
GO



CREATE view [interface].[V_I_QV_DealerUploadInventory]

as

SELECT CAST(left(a.DID_Period,4) as int) as Year
	,CAST(RIGHT(a.DID_Period,2) as int) as Month 
	,b.DMA_SAP_Code as SAPID
	,w.WHM_Code as WHM_Code
	,p.PMA_UPN as UPN
	,CASE 
		WHEN charindex('@@', LTM_LotNumber) > 0
			THEN substring(LTM_LotNumber, 1, charindex('@@', LTM_LotNumber) - 1)
		ELSE LTM_LotNumber
		END AS LOT
	,lm.LTM_ExpiredDate as ExpDate
	,CAST(a.DID_UploadDate AS DATE) AS UploadDate
	,sum(a.DID_Qty) as QTY
FROM dbo.DealerInventoryData a
left JOIN DealerMaster b on a.DID_DMA_ID=b.DMA_ID
left JOIN Warehouse w on a.DID_WHM_ID=w.WHM_ID
left JOIN LotMaster lm on a.DID_LTM_ID=lm.LTM_ID
left JOIN Product p on a.DID_PMA_ID=p.PMA_ID
GROUP BY  CAST(left(a.DID_Period,4) as int)
,CAST(RIGHT(a.DID_Period,2) as int)
	,b.DMA_SAP_Code
	,w.WHM_Code
	,p.PMA_UPN
	,CASE 
		WHEN charindex('@@', LTM_LotNumber) > 0
			THEN substring(LTM_LotNumber, 1, charindex('@@', LTM_LotNumber) - 1)
		ELSE LTM_LotNumber
		END 
	,lm.LTM_ExpiredDate
	,CAST(a.DID_UploadDate AS DATE)  
  


GO


