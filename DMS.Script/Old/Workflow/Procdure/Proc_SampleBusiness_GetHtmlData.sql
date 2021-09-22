DROP PROCEDURE [Workflow].[Proc_SampleBusiness_GetHtmlData]
GO


CREATE PROCEDURE [Workflow].[Proc_SampleBusiness_GetHtmlData]
	@InstanceId uniqueidentifier
AS
DECLARE @ApplyType NVARCHAR(100)
--SELECT @ApplyType = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

DECLARE @ApplyNo NVARCHAR(50)
SELECT @ApplyNo = ApplyNo,@ApplyType = SampleType from SampleApplyHead where SampleApplyHeadId=@InstanceId

if(@ApplyType ='��ҵ��Ʒ')
--ģ����Ϣ��������ڵ�һ����ѯ�������ֻ�й̶��������ֶΣ����Ʋ��ܱ�
begin
SELECT 'SampleBusiness' AS TemplateName, 'Header,SampleUPN,SampleTrace' AS TableNames
end
else
begin
SELECT 'SampleTest' AS TemplateName, 'Header,SampleUPN,SampleDelivery,SampleTrace' AS TableNames
end
--������Ϣ
--��ͷ
SELECT SampleType AS SampleType,ApplyQuantity AS ApplyQuantity,ISNULL(CONVERT(NVARCHAR(100),RemainQuantity),'') AS RemainQuantity,ApplyDate AS ApplyDate,ApplyNo AS ApplyNo,ApplyUser AS ApplyUser,ProcessUser,ApplyDept AS ApplyDept,ApplyDivision AS ApplyDivision,CustType AS CustType,CustName AS CustName,SampleApplyHead.ArrivalDate AS ArrivalDate,ApplyPurpose AS ApplyPurpose,ApplyCost AS ApplyCost,IrfNo AS IrfNo,HospName AS HospName,HpspAddress AS HpspAddress,TrialDoctor AS TrialDoctor,ReceiptUser AS ReceiptUser,ReceiptPhone AS ReceiptPhone,ReceiptAddress AS ReceiptAddress,DealerName AS DealerName,ApplyMemo AS ApplyMemo,case when ConfirmItem1 ='true' then 'checked=checked' else '' end AS ConfirmItem1,case when ConfirmItem2 ='true' then 'checked=checked' else '' end AS ConfirmItem2,ISNULL(ConfirmItem3,'')AS ConfirmItem3,
(SELECT VALUE1 FROM Lafite_DICT WHERE DICT_TYPE = 'CONST_Sample_State' AND DICT_KEY = ApplyStatus) AS ApplyStatus,SampleApplyHead.CostCenter AS CostCenter,
Division,Ra,Priority,SampleTesting.CostCenter AS Cost,Priority,SampleTesting.ArrivalDate AS  ArrivalDate2,[Certificate],Irf
      FROM SampleApplyHead
      left join SampleTesting on SampleApplyHeadId = SampleHeadId
WHERE SampleApplyHeadId = @InstanceId

--��Ʒ��Ϣ
SELECT UpnNo,ProductName,ProductDesc,Convert(decimal(18,2),ApplyQuantity) AS ApplyQuantity,ISNULL(CONVERT(NVARCHAR(100),Cost),'') AS Cost,ProductMemo FROM SampleUpn WHERE SampleHeadId=@InstanceId ORDER BY SortNo

IF(@ApplyType <> '��ҵ��Ʒ')
BEGIN
	--������Ϣ
	SELECT D.PMA_UPN UpnNo,E.CFN_ChineseName ProductName,E.CFN_Description ProductDesc,
	Convert(decimal(18,2),C.PRL_ReceiptQty) AS DeliveryQuantity,C.PRL_LotNumber Lot,
	CASE A.PRH_Status
		WHEN 'Waiting' THEN '�ѷ���'
		WHEN 'Complete' THEN 'RAȷ���ջ�'
		WHEN 'DP' THEN 'DPȷ�ϲɹ�'
		WHEN 'IE' THEN 'IEȷ�����'
		WHEN 'CS' THEN 'SSȷ�Ϸ���'
		WHEN 'RA' THEN 'RAȷ�Ϸ���'
		ELSE '' END DeliveryStatus,
	A.PRH_Note ProductMemo
            FROM   POReceiptHeader_SAPNoQR A,
                   POReceipt_SAPNoQR B,
                   POReceiptLot_SAPNoQR C,
                   Product D,
                   CFN E
            WHERE  A.PRH_ID = B.POR_PRH_ID
                   AND B.POR_ID = C.PRL_POR_ID
                   AND B.POR_SAP_PMA_ID = D.PMA_ID
                   AND D.PMA_CFN_ID = E.CFN_ID
                   AND A.PRH_PurchaseOrderNbr = @ApplyNo
END

--��Ʒ׷����Ϣ
SELECT * FROM dbo.Func_GetSampleTrace(@InstanceId)




GO


