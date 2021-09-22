DROP PROCEDURE [Promotion].[Proc_InitPoint_GetEWorkFlowHtml]
GO

CREATE PROCEDURE [Promotion].[Proc_InitPoint_GetEWorkFlowHtml](
	@FlowId NVARCHAR(10) 
	)
AS 
BEGIN
	DECLARE @Return NVARCHAR(max)
	DECLARE @Description NVARCHAR(500)
	DECLARE @BU NVARCHAR(20)
	DECLARE @PointType NVARCHAR(20)
	DECLARE @PointUseRangeType NVARCHAR(20)
	DECLARE @PointUseRange NVARCHAR(max)
	DECLARE @DealerName NVARCHAR(200)
	DECLARE @SumAdjustNum DECIMAL(14,2)
	DECLARE @MarketType NVARCHAR(20)
	
	SET @Return = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #BFBFBF;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #BFBFBF;background-color: #F2F2F2;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #BFBFBF;background-color: #ffffff;}</style>'
	
	SELECT @Description = isnull([Description],''),@BU = BU,@PointType = PointType,@PointUseRangeType = PointUseRangeType,@PointUseRange = case when PointUseRangeType='BU' then '全产品线' else PointUseRange end
	,@MarketType=CASE WHEN MarketType IS NULL THEN '' WHEN MarketType=0 THEN '普通市场' WHEN MarketType=1 THEN '新兴市场' ELSE '不分红蓝海' END
	FROM Promotion.Pro_InitPoint_Flow WHERE FlowId=@FlowId
	
	SELECT @DealerName=STUFF(REPLACE(REPLACE((
	SELECT DISTINCT DMA_ChineseName AS RESULT FROM (
	SELECT (B.DMA_ChineseName+'-'+B.DMA_SAP_Code) DMA_ChineseName FROM Promotion.Pro_InitPoint_Flow_Detail A
	INNER JOIN DealerMaster C ON A.DealerId=c.DMA_ID
	INNER JOIN DealerMaster B ON B.DMA_ID=C.DMA_Parent_DMA_ID
	WHERE  C.DMA_DealerType='T2'   AND A.FlowId=@FlowId
	UNION
	SELECT (C.DMA_ChineseName+'-'+C.DMA_SAP_Code) FROM Promotion.Pro_InitPoint_Flow_Detail A
	INNER JOIN DealerMaster C ON A.DealerId=c.DMA_ID 
	WHERE  C.DMA_DealerType IN('T1','LP') AND A.FlowId=@FlowId	) A
	FOR XML AUTO), '<A RESULT="', ','), '"/>', ''), 1, 1, '')
	
	SELECT @SumAdjustNum=SUM(Point/(ISNULL(Ratio,1.0000)))  FROM Promotion.Pro_InitPoint_Flow_Detail A WHERE FlowId=@FlowId
	
	SET @Return += '<table class="gridtable" width="800"><tr><td colspan="4" style="background-color: #95B3D7"><b>基本信息</b></td></tr>'
	SET @Return += '<tr><th width="150">所属产品线</th><td width="250">'+@BU+'</td><th width="150">市场类型</th><td width="250">'+@MarketType+'</td></tr>'
	SET @Return += '<tr><th width="150">积分类型</th><td>'+@PointType+'</td><th width="150">赠送类型</th><td width="250">积分</td></tr>'
	SET @Return += '<tr><th width="150">客户名称</th><td  colspan="3">'+ISNULL(@DealerName,'')+'</td></tr>'
	
	
	SET @Return += '<tr><th width="150">积分总额￥（不含税）</th><td width="250">'+CONVERT(NVARCHAR, CONVERT(DECIMAL(14,2),ISNULL(@SumAdjustNum,0.0000)/1.17))+'</td><th width="150">积分总额$（不含税）</th><td width="250">'+CONVERT(NVARCHAR,CONVERT(DECIMAL(14,2),(ISNULL(@SumAdjustNum,0.0000)/1.1700)/6.1700))+'</td></tr>'
	
	--SET @Return += '<tr><th width="150">积分使用范围类型</th><td width="250">'+@PointUseRangeType+'</td><th width="150">描述</th><td width="250">'+@Description+'</td></tr>'
	SET @Return += '<tr><th width="150">积分使用范围</th><td width="250" colspan="3">'+@PointUseRange+'</td></tr>'
	SET @Return += '<tr><th width="150">描述</th><td width="250" colspan="3">'+@Description+'</td></tr>'
	SET @Return += '<tr><th width="150">附件</th><td width="250" colspan="3">'+'<a target=''_blank'' href=''https://bscdealer.cn/API.aspx?PageId=80&InstanceID='+CONVERT(NVARCHAR(10),@FlowId)+'''>查看附件</a></td></tr>'
	SET @Return += '</table>'
	SET @Return += '<br/>'
	SET @Return += '<br/>'
	
	SET @Return += '<table class="gridtable" width="800"><tr><td colspan="4" style="background-color: #95B3D7"><b>积分明细 （1积分=1RMB 含税）</b></td></tr>'	
	SET @Return +='<tr><th>经销商</th><th>积分</th><th>加价率</th><th>积分失效时间</th>'
	SET @Return +='</tr>'
		
	DECLARE @DealerCode NVARCHAR(200);
	DECLARE @Point NVARCHAR(50);
	DECLARE @Ratio NVARCHAR(50);
	DECLARE @ExpiredDate NVARCHAR(50);
	
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT c.DMA_SAP_Code+'-'+c.DMA_ChineseName ,
		isnull(convert(NVARCHAR,convert(DECIMAL(14,4),a.Point)),'') Point,
		isnull(convert(NVARCHAR,convert(DECIMAL(14,4),a.Ratio)),'') Ratio,
		isnull(convert(NVARCHAR(10),a.PointExpiredDate,121),'') PointExpiredDate
		FROM Promotion.Pro_InitPoint_Flow_Detail a
		INNER JOIN DealerMaster c ON a.DealerId = c.DMA_ID
		WHERE a.FlowId = @FlowId
		ORDER BY DMA_ChineseName
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @DealerCode,@Point,@Ratio,@ExpiredDate
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Return +='<tr>'
		SET @Return += '<td>'+isnull(@DealerCode,'')+'</td>'
		SET @Return += '<td>'+isnull(@Point,'')+'</td>'
		SET @Return += '<td>'+isnull(@Ratio,'')+'</td>'
		SET @Return += '<td>'+isnull(@ExpiredDate,'')+'</td>'
		SET @Return +='</tr>'
		FETCH NEXT FROM @iCURSOR INTO @DealerCode,@Point,@Ratio,@ExpiredDate
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	SET @Return += '</table>'	
	
	update promotion.pro_initpoint_flow set htmlstr=@Return where flowid =@FlowId
	--select @Return as HTMLStr 
END





GO


