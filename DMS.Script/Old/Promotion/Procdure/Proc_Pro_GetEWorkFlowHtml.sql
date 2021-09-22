DROP PROCEDURE [Promotion].[Proc_Pro_GetEWorkFlowHtml]
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_GetEWorkFlowHtml](
	@FlowId INT,	--����ID
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
	
	SET @iReturn += '<table class="gridtable" width="800"><tr><td colspan="4" style="background-color: #95B3D7"><b>������Ϣ</b></td></tr>'
	SET @iReturn += '<tr><th width="150">�۸�����</th><td width="250">����ִ������</td><th width="150">����ԭ��</th><td width="250">'+ISNULL(@PriceTypeRes,'')+'</td></tr>'
	SET @iReturn += '<tr><th>��ʾ</th><td colspan="3">���������󣬴�����������ô�����</td></tr>'
	SET @iReturn += '<tr><th> �ͻ�SAPCode</th><td colspan="3">'+ISNULL(@SAPCode,'')+'</td></tr>'
	SET @iReturn += '<tr><th> �ͻ�����</th><td colspan="3">'+ISNULL(@DealerName,'')+'</td></tr>'
	SET @iReturn += '<tr><th>������Ʒ��</th><td colspan="3">'+@BU+'</td></tr>'
	SET @iReturn += '<tr><th>����</th><td colspan="3">'+@FlowType+'</td></tr>'
	SET @iReturn += '<tr><th>��Ч�ڿ�ʼ</th><td>'+ CONVERT(nvarchar(10),@BeginDate,120)+'</td><th>��Ч����ֹ</th><td>'+CONVERT(nvarchar(10),@EndDate,120)+'</td></tr>'
	IF @FlowType='��Ʒ'
	BEGIN
		SET @SumAdjustNum=0;
		SELECT @SumAdjustNum=SUM(B.AdjustNum*ISNULL(B.GiftPrice,0)) FROM  Promotion.T_Pro_Flow a
		INNER JOIN Promotion.T_Pro_Flow_Detail b ON a.FlowId = b.FlowId
		WHERE a.FlowId = @FlowId
		SET @iReturn += '<tr><th>��Ʒ�ܶ������˰��</th><td>'+CONVERT(NVARCHAR, CONVERT(DECIMAL(14,2),ISNULL(@SumAdjustNum,0.0000)/1.17))+'</td><th>��Ʒ�ܶ�$������˰��</th><td>'+CONVERT(NVARCHAR,CONVERT(DECIMAL(14,2),(ISNULL(@SumAdjustNum,0.0000)/1.1700)/6.1700))+'</td></tr>'
	END
	ELSE
	BEGIN
		SET @iReturn += '<tr><th>�����ܶ������˰��</th><td>'+CONVERT(NVARCHAR, CONVERT(DECIMAL(14,2),ISNULL(@SumAdjustNum,0.0000)/1.17))+'</td><th>�����ܶ�$������˰��</th><td>'+CONVERT(NVARCHAR,CONVERT(DECIMAL(14,2),(ISNULL(@SumAdjustNum,0.0000)/1.1700)/6.1700))+'</td></tr>'
	END
	SET @iReturn += '<tr><th>��������</th><td>'+@Period+'</td><th>��������</th><td>'+@AccountMonth+'</td></tr>'
	SET @iReturn += '<tr><th>Ŀ��</th><td colspan="3">'+@Description+'</td></tr>'
	SET @iReturn += '<tr><th>����</th><td colspan="3">'+'<a target=''_blank'' href=''https://bscdealer.cn/API.aspx?PageId=70&InstanceID='+CONVERT(NVARCHAR(10),@FlowId)+'''>�鿴����</a></td></tr>'
	SET @iReturn += '</table>'
	
	SET @iReturn += '<br/>'
	SET @iReturn += '<br/>'
	IF @FlowType='��Ʒ'
	BEGIN
		SET @iReturn += '<table class="gridtable" width="800"><tr><td colspan="4" style="background-color: #95B3D7"><b> ���Ͳ�Ʒ���۸���ϸ��RMB ��˰��</b></td></tr>'	
	END
	ELSE
	BEGIN
		SET @iReturn += '<table class="gridtable" width="800"><tr><td colspan="2" style="background-color: #95B3D7"><b>������ϸ ��1����=1RMB ��˰��</b></td></tr>'	
	END
	SET @iReturn +='<tr><th width="600">����</th>'
	SET @iReturn +=CASE @FlowType WHEN '��Ʒ' THEN '<th>����</th>' ELSE '<th>����</th>' END
	
	IF @FlowType='��Ʒ'
	BEGIN
		SET @iReturn += '<th>����</th><th>�ܽ��</th>'	
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
		--IF @FlowType = '����'
		--BEGIN
		--	SET @iReturn += '<td>'+isnull(@ValidDate,'')+'</td>'
		--END
		
		IF @FlowType = '��Ʒ'
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


