DROP PROCEDURE [Workflow].[Proc_IntegralImport_GetHtmlData]
GO

CREATE PROCEDURE [Workflow].[Proc_IntegralImport_GetHtmlData]
	@InstanceId uniqueidentifier
AS
DECLARE @ApplyType NVARCHAR(100)
DECLARE @DealerName NVARCHAR(2000)
DECLARE @Rate DECIMAL(10,4)
SELECT @ApplyType = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

SELECT @Rate=Rate FROM [interface].[MDM_ExchangeRate] WHERE [FROM]='CNY' AND [TO]='USD'	
	
IF ISNULL(@Rate,0)=0
BEGIN
	SET @Rate=1;
END

--ģ����Ϣ��������ڵ�һ����ѯ�������ֻ�й̶��������ֶΣ����Ʋ��ܱ�
SELECT @ApplyType AS TemplateName, 'Header,PointDetail,Attachment' AS TableNames

SELECT @DealerName=STUFF(REPLACE(REPLACE((
	SELECT DISTINCT DMA_ChineseName AS RESULT FROM (
	SELECT (B.DMA_ChineseName+'-'+B.DMA_SAP_Code) DMA_ChineseName FROM Promotion.Pro_InitPoint_Flow_Detail A
	INNER JOIN DealerMaster C ON A.DealerId=c.DMA_ID
	INNER JOIN DealerMaster B ON B.DMA_ID=C.DMA_Parent_DMA_ID
	INNER JOIN Promotion.Pro_InitPoint_Flow D ON D.FlowId=A.FlowId
	WHERE  C.DMA_DealerType='T2'   AND D.InstanceID=@InstanceId
	UNION
	SELECT (C.DMA_ChineseName+'-'+C.DMA_SAP_Code) FROM Promotion.Pro_InitPoint_Flow_Detail A
	INNER JOIN DealerMaster C ON A.DealerId=c.DMA_ID 
	INNER JOIN Promotion.Pro_InitPoint_Flow D ON D.FlowId=A.FlowId
	WHERE  C.DMA_DealerType IN('T1','LP') AND D.InstanceID=@InstanceId	) A
	FOR XML AUTO), '<A RESULT="', ','), '"/>', ''), 1, 1, '')

--������Ϣ
--��ͷ
SELECT top 1 a.FlowNo,BU, 
CASE WHEN  ISNULL(A.MarketType,2)=2 THEN '���ֺ�����' WHEN ISNULL(A.MarketType,2)=1 THEN '�����г�' ELSE '��ͨ�г�' END  AS MarketType,
PointType,
'����' AS GiftType
,@DealerName AS DealerName
,SUM(b.Point/isnull(b.Ratio,1.0)/1.17) TotalRMB
,SUM(b.Point/isnull(b.Ratio,1.0)/1.17)/@Rate TotalUSD
,CASE WHEN PointUseRangeType='BU' THEN 'ȫ��Ʒ��' 
ELSE a.PointUseRange END UserProduct
,[Description] Remark
,'<a target=''_blank'' href=''https://bscdealer.cn/API.aspx?PageId=80&InstanceID='+ +CONVERT(nvarchar(100),a.FlowId)+'''>�鿴����</a></td></tr>' AS N'Attachment'
FROM Promotion.Pro_InitPoint_Flow a 
INNER JOIN Promotion.Pro_InitPoint_Flow_Detail b ON A.FlowId=B.FlowId
WHERE A.InstanceID = @InstanceId
GROUP BY BU,MarketType,PointType,PointUseRangeType,PointUseRange,[Description],A.FlowId,a.FlowNo

--��ϸ��Ϣ
SELECT c.DMA_SAP_Code+'-'+c.DMA_ChineseName AS DealerName ,
		isnull(convert(NVARCHAR,convert(DECIMAL(14,4),a.Point)),'') Point,
		isnull(convert(NVARCHAR,convert(DECIMAL(14,4),a.Ratio)),'') Ratio,
		isnull(convert(NVARCHAR(10),a.PointExpiredDate,121),'') PointExpiredDate
		,row_number () OVER (ORDER BY C.DMA_ChineseName ASC) ROWNUMBER
		FROM Promotion.Pro_InitPoint_Flow_Detail a
		INNER JOIN DealerMaster c ON a.DealerId = c.DMA_ID
		INNER JOIN Promotion.Pro_InitPoint_Flow D ON D.FlowId=A.FlowId
		WHERE D.InstanceID = @InstanceId
		ORDER BY DMA_ChineseName
		

--������Ϣ
EXEC Workflow.Proc_Attachment_GetHtmlData @InstanceId,NULL

GO


