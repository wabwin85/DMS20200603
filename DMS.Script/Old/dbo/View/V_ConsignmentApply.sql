DROP VIEW [dbo].[V_ConsignmentApply]
GO




CREATE VIEW [dbo].[V_ConsignmentApply]
AS
	SELECT CAH_ID AS 'Id',
	A.DMA_ChineseName AS '����������',
	A.DMA_SAP_Code AS '������SAP���',
	B.ATTRIBUTE_NAME AS '��Ʒ��',
	(SELECT VALUE1 FROM Lafite_DICT(nolock) WHERE DICT_TYPE = 'ConsignmentApply_Order_Type' AND DICT_KEY = CAH_OrderType ) AS '��������',
	CAH_OrderNo AS '���뵥��',
	CONVERT(NVARCHAR(20),CAH_SubmitDate,120) AS '�ύʱ��',
	(SELECT VALUE1 FROM Lafite_DICT(nolock) WHERE DICT_TYPE = 'ConsignmentApply_Order_Status' AND DICT_KEY = CAH_OrderStatus ) AS '����״̬',
	(SELECT VALUE1 FROM Lafite_DICT(nolock) WHERE DICT_TYPE = 'Product_source' AND DICT_KEY = CAH_ConsignmentFrom ) AS '��Ʒ��Դ',
	C.DMA_ChineseName AS '��Դ����������',
	C.DMA_SAP_Code AS '��Դ������SAP���',
	CAH_Hospital_Name AS 'ҽԺ',
	CAH_CM_ConsignmentName AS '���۹���',
	CAH_Reason AS '����ԭ��',
	CAH_Remark AS '��ע˵��',
	CAH_SalesName AS '������������',
	CAH_SalesEmail AS '������������',
	CAH_SalesPhone AS '�������۵绰',
	CAH_Consignee AS '�ջ���',
	CAH_ShipToAddress AS '�ջ���ַ',
	CAH_ConsigneePhone AS '�ջ��˵绰',
	CAH_CM_ConsignmentDay AS '��������',
	CAH_CM_Type AS '��Ч������',
	CAH_CM_ConsignmentDay AS '�����ڴ���',
	CAH_CM_ReturnTime AS '�˻�����',
	CONVERT(NVARCHAR(10),CAH_CM_StartDate,120) AS 'ʱ������-��ʼ',
	CONVERT(NVARCHAR(10),CAH_CM_EndDate,120) AS 'ʱ������-��ֹ',
	CAH_CM_DailyFines AS '���ɽ�ÿ�ս��',
	CAH_CM_LowestMargin AS '��ͱ�֤����',
	CAH_CM_TotalAmount AS '�������ƽ��'
	FROM ConsignmentApplyHeader(nolock)
	INNER JOIN DealerMaster A ON A.DMA_ID = CAH_DMA_ID
	INNER JOIN View_ProductLine B ON B.Id = CAH_ProductLine_Id
	LEFT JOIN DealerMaster C ON C.DMA_ID = CAH_ConsignmentId
	LEFT JOIN Lafite_IDENTITY D ON D.Id = CAH_CreateUser
		



GO


