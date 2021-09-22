DROP PROCEDURE [Workflow].[Proc_Promotion_GetHtmlData]
GO

CREATE PROCEDURE [Workflow].[Proc_Promotion_GetHtmlData]
	@InstanceId uniqueidentifier
AS
DECLARE @ApplyType NVARCHAR(100)
DECLARE @SAPCode NVARCHAR(200)
DECLARE @DealerName NVARCHAR(2000)
DECLARE @SumAdjustNum DECIMAL(14,2)
DECLARE @FlowType NVARCHAR(200)
DECLARE @Ratio DECIMAL(10,4)

SELECT @ApplyType = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId
DECLARE @Rate DECIMAL(10,4)
SELECT @Rate=Rate FROM [interface].[MDM_ExchangeRate] WHERE [FROM]='CNY' AND [TO]='USD'	

IF ISNULL(@Rate,0)=0
BEGIN
	SET @Rate=1;
END

--模版信息，必须放在第一个查询结果，且只有固定的两个字段，名称不能变
SELECT @ApplyType AS TemplateName, 'Header,PromotionDetail,Attachment' AS TableNames


	SELECT  @SumAdjustNum=convert(DECIMAL(14,2),sum(b.AdjustNum/ISNULL(b.Ratio,1)))
	FROM  Promotion.T_Pro_Flow a
		INNER JOIN Promotion.T_Pro_Flow_Detail b ON a.FlowId = b.FlowId
	WHERE a.InstanceID = @InstanceId
	and b.AdjustNum<>0
	and ISNULL(b.Ratio,1)<>0
	
	SELECT @DealerName=STUFF(REPLACE(REPLACE((
	SELECT DISTINCT DMA_ChineseName AS RESULT FROM (
	SELECT CASE c.DMA_DealerType WHEN 'T2' THEN D.DMA_ChineseName ELSE C.DMA_ChineseName END AS DMA_ChineseName
	FROM  Promotion.T_Pro_Flow a
		INNER JOIN Promotion.T_Pro_Flow_Detail b ON a.FlowId = b.FlowId
		INNER JOIN DealerMaster c ON b.DealerId = c.DMA_ID
		LEFT JOIN DealerMaster D ON B.LPID = D.DMA_ID
	WHERE a.InstanceID = @InstanceId
	and b.AdjustNum<>0
	and ISNULL(b.Ratio,1)<>0
	GROUP BY CASE c.DMA_DealerType WHEN 'T2' THEN D.DMA_ChineseName ELSE C.DMA_ChineseName END,CASE c.DMA_DealerType WHEN 'T2' THEN D.DMA_SAP_Code ELSE C.DMA_SAP_Code END
	) TB
	FOR XML AUTO), '<TB RESULT="', ','), '"/>', ''), 1, 1, '')
	
	SELECT @SAPCode=STUFF(REPLACE(REPLACE((
	SELECT DISTINCT DMA_SAP_Code AS RESULT FROM (
	SELECT CASE c.DMA_DealerType WHEN 'T2' THEN D.DMA_SAP_Code ELSE C.DMA_SAP_Code END DMA_SAP_Code
	FROM  Promotion.T_Pro_Flow a
		INNER JOIN Promotion.T_Pro_Flow_Detail b ON a.FlowId = b.FlowId
		INNER JOIN DealerMaster c ON b.DealerId = c.DMA_ID
		LEFT JOIN DealerMaster D ON B.LPID = D.DMA_ID
	WHERE a.InstanceID = @InstanceId
	and b.AdjustNum<>0
	and ISNULL(b.Ratio,1)<>0
	GROUP BY CASE c.DMA_DealerType WHEN 'T2' THEN D.DMA_ChineseName ELSE C.DMA_ChineseName END,CASE c.DMA_DealerType WHEN 'T2' THEN D.DMA_SAP_Code ELSE C.DMA_SAP_Code END
	) TB
	FOR XML AUTO), '<TB RESULT="', ','), '"/>', ''), 1, 1, '')
	
SELECT @FlowType=FlowType FROM Promotion.T_Pro_Flow WHERE InstanceID = @InstanceId
IF @FlowType='赠品'
	BEGIN
		SET @SumAdjustNum=0;
		
		SELECT top 1 @Ratio=T4.Ratio FROM PROMOTION.T_Pro_Flow t1
		INNER JOIN Promotion.T_Pro_Flow_Detail t2 ON t1.FlowId = t2.FlowId
		INNER JOIN DealerMaster T3 ON T2.DealerId=T3.DMA_ID
		INNER JOIN Promotion.Pro_BU_PointRatio T4 ON T4.PlatFormId=T3.DMA_Parent_DMA_ID AND t4.BU=t1.BU
		WHERE t1.InstanceID=@InstanceId

		SET @Ratio=ISNULL(@Ratio,1);
		
		SELECT @SumAdjustNum=SUM(B.AdjustNum*ISNULL(B.GiftPrice,0)/@Ratio) FROM  Promotion.T_Pro_Flow a
		INNER JOIN Promotion.T_Pro_Flow_Detail b ON a.FlowId = b.FlowId
		WHERE a.InstanceID = @InstanceId
	END
--数据信息
--表头

SELECT [Description],BU, Period, AccountMonth,FlowType,MarketType,Reason, CONVERT(NVARCHAR(10),ISNULL(BeginDate,'2000-01-01'),120) AS BeginDate,CONVERT(NVARCHAR(10),ISNULL(EndDate,'2099-12-31'),120) AS EndDate,@DealerName AS DealerName,@SAPCode AS SAPCode
,CONVERT(DECIMAL(14,2),(@SumAdjustNum/1.17)) AS N'AmountRMB'
,CONVERT(DECIMAL(14,2),(@SumAdjustNum/1.17)/@Rate) AS N'AmountUSD'
,CONVERT(DECIMAL(14,2),(@SumAdjustNum)) AS N'AmountTaxRMB'
,CONVERT(DECIMAL(14,2),(@SumAdjustNum)/@Rate) AS N'AmountTaxUSD'

,'促销结束后，促销结果申请用此类型' SubRemark
,'<a target=''_blank'' href=''https://bscdealer.cn/API.aspx?PageId=70&InstanceID='+ +CONVERT(nvarchar(100),FlowId)+'''>查看附件</a></td></tr>' AS N'Attachment'
FROM Promotion.T_Pro_Flow WHERE InstanceID = @InstanceId



--明细信息
SELECT b.LargessDesc,
		convert(NVARCHAR,convert(DECIMAL(14,2),sum(b.OraNum))) OraNum,
		case when @FlowType='积分' THEN 0.00 ELSE convert(DECIMAL(14,2),convert(DECIMAL(14,2),sum(b.AdjustNum))) END AdjustNum,
		case when @FlowType='积分' THEN 0.00 ELSE convert(DECIMAL(14,2),isnull(b.GiftPrice,0)/ISNULL(@Ratio,1)) END GiftPrice,
		case when @FlowType='积分' THEN convert(NVARCHAR,convert(DECIMAL(14,2),sum(b.AdjustNum)/ REPLACE(ISNULL(b.Ratio,1),0,1))) ELSE sum(b.AdjustNum*(isnull(b.GiftPrice,0)/ISNULL(@Ratio,1))) END AS SumAmount
		,row_number () OVER (ORDER BY b.LargessDesc ASC) ROWNUMBER
		FROM Promotion.T_Pro_Flow a
		INNER JOIN Promotion.T_Pro_Flow_Detail b ON a.FlowId = b.FlowId
		INNER JOIN DealerMaster c ON b.DealerId = c.DMA_ID
		LEFT JOIN DealerMaster D ON B.LPID = D.DMA_ID
		WHERE a.InstanceID = @InstanceId
		AND b.AdjustNum<>0
		GROUP BY b.LargessDesc,convert(DECIMAL(14,2),isnull(b.GiftPrice,0)/ISNULL(@Ratio,1)),b.Ratio
		ORDER BY b.LargessDesc
--附件信息
EXEC Workflow.Proc_Attachment_GetHtmlData @InstanceId,NULL


