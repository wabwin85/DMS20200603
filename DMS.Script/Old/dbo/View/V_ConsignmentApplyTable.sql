DROP VIEW [dbo].[V_ConsignmentApplyTable]
GO




CREATE VIEW [dbo].[V_ConsignmentApplyTable]
AS
	SELECT CAD_CAH_ID AS 'Id',
	CFN_CustomerFaceNbr AS '��Ʒ�ͺ�', 
	CFN_ChineseName AS '��Ʒ������', 
	CFN_EnglishName AS '��ƷӢ����', 
	CAD_UOM AS '��λ', 
	CAD_Qty AS '��������',
	CAD_LotNumber AS '����'
	FROM ConsignmentApplyDetails(nolock)
	INNER JOIN CFN ON CFN_ID = CAD_CFN_ID
	



GO


