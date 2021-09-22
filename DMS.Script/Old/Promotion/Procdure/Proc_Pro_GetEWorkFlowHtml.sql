DROP PROCEDURE [Promotion].[Proc_Pro_GetEWorkFlowHtml]
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_GetEWorkFlowHtml](
	@FlowId INT,	--主键ID
	@iReturn NVARCHAR(MAX) = '' output 
	)
AS
BEGIN
	DECLARE @Description NVARCHAR(200)
	DECLARE @BU NVARCHAR(200)
	DECLARE @Period NVARCHAR(200)
	DECLARE @AccountMonth NVARCHAR(200)
	DECLARE @FlowType NVARCHAR(200)
	DECLARE @PriceTypeRes NVARCHAR(200)
	DECLARE @MarketType INT
	DECLARE @BeginDate DATETIME
	DECLARE @EndDate DATETIME
	DECLARE @SAPCode NVARCHAR(200)
	DECLARE @DealerName NVARCHAR(200)
	DECLARE @SumAdjustNum DECIMAL(14,2)
	
	SELECT  @SumAdjustNum=convert(DECIMAL(14,2),sum(b.AdjustNum/ISNULL(b.Ratio,1)))
	FROM  Promotion.T_Pro_Flow a
		INNER JOIN Promotion.T_Pro_Flow_Detail b ON a.FlowId = b.FlowId
	WHERE a.FlowId = @FlowId
	and b.AdjustNum<>0
	and ISNULL(b.Ratio,1)<>0
	
	SELECT @DealerName=STUFF(REPLACE(REPLACE((
	SELECT DISTINCT DMA_ChineseName AS RESULT FROM (
	SELECT CASE c.DMA_DealerType WHEN 'T2' THEN D.DMA_ChineseName ELSE C.DMA_ChineseName END AS DMA_ChineseName
	FROM  Promotion.T_Pro_Flow a
		INNER JOIN Promotion.T_Pro_Flow_Detail b ON a.FlowId = b.FlowId
		INNER JOIN DealerMaster c ON b.DealerId = c.DMA_ID
		LEFT JOIN DealerMaster D ON B.LPID = D.DMA_ID
	WHERE a.FlowId = @FlowId
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
	WHERE a.FlowId = @FlowId
	and b.AdjustNum<>0
	and ISNULL(b.Ratio,1)<>0
	GROUP BY CASE c.DMA_DealerType WHEN 'T2' THEN D.DMA_ChineseName ELSE C.DMA_ChineseName END,CASE c.DMA_DealerType WHEN 'T2' THEN D.DMA_SAP_Code ELSE C.DMA_SAP_Code END
	) TB
	FOR XML AUTO), '<TB RESULT="', ','), '"/>', ''), 1, 1, '')
	
	SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #BFBFBF;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #BFBFBF;background-color: #F2F2F2;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #BFBFBF;background-color: #ffffff;}</style>'
	
	SELECT @Description = Description,@BU = BU,@Period = Period,@AccountMonth = AccountMonth,@FlowType =FlowType,@MarketType=MarketType,@PriceTypeRes=Reason,@BeginDate=BeginDate,@EndDate=EndDate
	FROM Promotion.T_Pro_Flow WHERE FlowId=@FlowId
	
	SET @iReturn += '<table class="gridtable" width="800"><tr><td colspan="4" style="background-color: #95B3D7"><b>基本信息</b></td></tr>'
	SET @iReturn += '<tr><th width="150">价格类型</th><td width="250">促销执行申请</td><th width="150">类型原因</th><td width="250">'+ISNULL(@PriceTypeRes,'')+'</td></tr>'
	SET @iReturn += '<tr><th>提示</th><td colspan="3">促销结束后，促销结果申请用此类型</td></tr>'
	SET @iReturn += '<tr><th> 客户SAPCode</th><td colspan="3">'+ISNULL(@SAPCode,'')+'</td></tr>'
	SET @iReturn += '<tr><th> 客户名称</th><td colspan="3">'+ISNULL(@DealerName,'')+'</td></tr>'
	SET @iReturn += '<tr><th>所属产品线</th><td colspan="3">'+@BU+'</td></tr>'
	SET @iReturn += '<tr><th>类型</th><td colspan="3">'+@FlowType+'</td></tr>'
	SET @iReturn += '<tr><th>有效期开始</th><td>'+ CONVERT(nvarchar(10),@BeginDate,120)+'</td><th>有效期终止</th><td>'+CONVERT(nvarchar(10),@EndDate,120)+'</td></tr>'
	IF @FlowType='赠品'
	BEGIN
		SET @SumAdjustNum=0;
		SELECT @SumAdjustNum=SUM(B.AdjustNum*ISNULL(B.GiftPrice,0)) FROM  Promotion.T_Pro_Flow a
		INNER JOIN Promotion.T_Pro_Flow_Detail b ON a.FlowId = b.FlowId
		WHERE a.FlowId = @FlowId
		SET @iReturn += '<tr><th>赠品总额￥（不含税）</th><td>'+CONVERT(NVARCHAR, CONVERT(DECIMAL(14,2),ISNULL(@SumAdjustNum,0.0000)/1.17))+'</td><th>赠品总额$（不含税）</th><td>'+CONVERT(NVARCHAR,CONVERT(DECIMAL(14,2),(ISNULL(@SumAdjustNum,0.0000)/1.1700)/6.1700))+'</td></tr>'
	END
	ELSE
	BEGIN
		SET @iReturn += '<tr><th>积分总额￥（不含税）</th><td>'+CONVERT(NVARCHAR, CONVERT(DECIMAL(14,2),ISNULL(@SumAdjustNum,0.0000)/1.17))+'</td><th>积分总额$（不含税）</th><td>'+CONVERT(NVARCHAR,CONVERT(DECIMAL(14,2),(ISNULL(@SumAdjustNum,0.0000)/1.1700)/6.1700))+'</td></tr>'
	END
	SET @iReturn += '<tr><th>结算周期</th><td>'+@Period+'</td><th>结算帐期</th><td>'+@AccountMonth+'</td></tr>'
	SET @iReturn += '<tr><th>目的</th><td colspan="3">'+@Description+'</td></tr>'
	SET @iReturn += '<tr><th>附件</th><td colspan="3">'+'<a target=''_blank'' href=''https://bscdealer.cn/API.aspx?PageId=70&InstanceID='+CONVERT(NVARCHAR(10),@FlowId)+'''>查看附件</a></td></tr>'
	SET @iReturn += '</table>'
	
	SET @iReturn += '<br/>'
	SET @iReturn += '<br/>'
	IF @FlowType='赠品'
	BEGIN
		SET @iReturn += '<table class="gridtable" width="800"><tr><td colspan="4" style="background-color: #95B3D7"><b> 赠送产品及价格明细（RMB 含税）</b></td></tr>'	
	END
	ELSE
	BEGIN
		SET @iReturn += '<table class="gridtable" width="800"><tr><td colspan="2" style="background-color: #95B3D7"><b>积分明细 （1积分=1RMB 含税）</b></td></tr>'	
	END
	SET @iReturn +='<tr><th width="600">描述</th>'
	SET @iReturn +=CASE @FlowType WHEN '赠品' THEN '<th>数量</th>' ELSE '<th>积分</th>' END
	
	IF @FlowType='赠品'
	BEGIN
		SET @iReturn += '<th>单价</th><th>总金额</th>'	
	END
	
	SET @iReturn +='</tr>'
		
	DECLARE @LargessDesc NVARCHAR(2000);
	
	DECLARE @OraNum NVARCHAR(50);
	DECLARE @AdjustNum NVARCHAR(50);
	DECLARE @ValidDate NVARCHAR(50);
	DECLARE @GiftPrice DECIMAL(14,2);
	
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT b.LargessDesc,
		--CASE c.DMA_DealerType WHEN 'T2' THEN D.DMA_ChineseName ELSE C.DMA_ChineseName END DealerName,
		convert(NVARCHAR,convert(DECIMAL(14,2),sum(b.OraNum))) OraNum,
		convert(NVARCHAR,convert(DECIMAL(14,2),sum(b.AdjustNum))) AdjustNum,
		--convert(NVARCHAR(10),B.ValidDate,121) ValidDate
		convert(DECIMAL(14,2),isnull(b.GiftPrice,0)) GiftPrice
		
		FROM Promotion.T_Pro_Flow a
		INNER JOIN Promotion.T_Pro_Flow_Detail b ON a.FlowId = b.FlowId
		INNER JOIN DealerMaster c ON b.DealerId = c.DMA_ID
		LEFT JOIN DealerMaster D ON B.LPID = D.DMA_ID
		WHERE a.FlowId = @FlowId
		GROUP BY b.LargessDesc,convert(DECIMAL(14,2),isnull(b.GiftPrice,0))--,CASE c.DMA_DealerType WHEN 'T2' THEN D.DMA_ChineseName ELSE C.DMA_ChineseName END,convert(NVARCHAR(10),B.ValidDate,121)
		ORDER BY b.LargessDesc
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @LargessDesc,@OraNum,@AdjustNum,@GiftPrice
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @iReturn +='<tr>'
		SET @iReturn += '<td>'+isnull(@LargessDesc,'')+'</td>'
		--SET @iReturn += '<td>'+isnull(@DealerName,'')+'</td>'
		--SET @iReturn += '<td>'+isnull(@OraNum,'')+'</td>'
		SET @iReturn += '<td>'+isnull(@AdjustNum,'')+'</td>'
		--IF @FlowType = '积分'
		--BEGIN
		--	SET @iReturn += '<td>'+isnull(@ValidDate,'')+'</td>'
		--END
		
		IF @FlowType = '赠品'
		BEGIN
			SET @iReturn += '<td>'+CONVERT(NVARCHAR,@GiftPrice)+'</td>'
			SET @iReturn += '<td>'+CONVERT(NVARCHAR,@GiftPrice*CONVERT(DECIMAL(14,2),@AdjustNum))+'</td>'
		END
		SET @iReturn +='</tr>'
		FETCH NEXT FROM @iCURSOR INTO @LargessDesc,@OraNum,@AdjustNum,@GiftPrice
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	SET @iReturn += '</table>'	
	
	RETURN 
END


GO


