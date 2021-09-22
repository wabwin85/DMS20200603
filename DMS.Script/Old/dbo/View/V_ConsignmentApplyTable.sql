DROP VIEW [dbo].[V_ConsignmentApplyTable]
GO




CREATE VIEW [dbo].[V_ConsignmentApplyTable]
AS
	SELECT CAD_CAH_ID AS 'Id',
	CFN_CustomerFaceNbr AS '产品型号', 
	CFN_ChineseName AS '产品中文名', 
	CFN_EnglishName AS '产品英文名', 
	CAD_UOM AS '单位', 
	CAD_Qty AS '申请数量',
	CAD_LotNumber AS '批号'
	FROM ConsignmentApplyDetails(nolock)
	INNER JOIN CFN ON CFN_ID = CAD_CFN_ID
	



GO


