DROP PROCEDURE [Promotion].[Proc_Pro_ImportResult4EWorkFlowPoint] 
GO


/**********************************************
	功能：界面导入审批文件(积分)
	作者：GrapeCity
	最后更新时间：	2016-03-07
	更新记录说明：
	1.创建 2016-03-07
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_ImportResult4EWorkFlowPoint] 
	@UserId UNIQUEIDENTIFIER,	--用户ID
	@Description NVARCHAR(200),	--界面描述输入框
	@MarketType INT,	--市场类型
	@Reason NVARCHAR(200),	--价格类型原因
	@BeginDate DATETIME,	--有效期开始
	@EndDate DATETIME,	--有效期终止
	@ApproveRole NVARCHAR(200),--确定流程必审角色
	@AttachmentId NVARCHAR(50),--所属附件主键
	@FormXml NVARCHAR(MAX),		--导入文件的XML
	@Return NVARCHAR(1000) OUTPUT,	--返回参数
	@ReFlowId NVARCHAR(100) OUTPUT,	--返回参数
	@ReQty NVARCHAR(100) OUTPUT	--返回参数
AS
BEGIN TRY 	
	
	SET @ReFlowId='';
	SET @ReQty='';
	--根据传入XML生成中间表
	DECLARE @iForm INT   
            EXEC sp_xml_preparedocument @iForm OUTPUT, @FormXml   
            SELECT  BU,
            		AccountMonth,
            		PolicyNo,
            		--DealerId,
            		SAPCode,
            		DealerName,
            		HospitalId,
            		HospitalName,
            		PointType,
            		PointValidDate,
            		OraNum,
            		AdjustNum,
            		Ratio
            INTO    #ImportResult
            FROM    OPENXML(@iForm,'/DocumentElement/Table',2)  
   WITH(   
	BU NVARCHAR(20),
	AccountMonth NVARCHAR(20),
	PolicyNo NVARCHAR(50),
	--DealerId NVARCHAR(100),
	SAPCode NVARCHAR(100),
	DealerName NVARCHAR(50),
	HospitalId NVARCHAR(100),
	HospitalName NVARCHAR(50),
	PointType NVARCHAR(50),
	PointValidDate NVARCHAR(50),
	OraNum NVARCHAR(50),
	AdjustNum NVARCHAR(50),
	Ratio NVARCHAR(50)
     )   
     
    ALTER TABLE #ImportResult ADD LpId UNIQUEIDENTIFIER;
    ALTER TABLE #ImportResult ADD LargessDesc NVARCHAR(4000);
    ALTER TABLE #ImportResult ADD DealerId NVARCHAR(100);
    
    	
	DECLARE @iStr NVARCHAR(1000)
	DECLARE @SQL NVARCHAR(MAX);
	
	--**********************************校验*********************************************************
	DELETE #ImportResult WHERE isnull(BU,'')='' and ISNULL(AccountMonth,'')='' and ISNULL(PolicyNo,'')='' and ISNULL(DealerName,'')=''
	IF EXISTS (SELECT * FROM #ImportResult WHERE isnull(BU,'')='' OR ISNULL(AccountMonth,'')=''
 		OR ISNULL(PolicyNo,'')='' OR ISNULL(DealerName,'')='' OR ISNULL(AdjustNum,'')='' OR ISNULL(SAPCode,'')=''
 		OR ISNULL(PointType,'')='' OR ISNULL(PointValidDate,'')='' )
	BEGIN
		SET @Return = '所有字段不能为空！'
		RETURN 
	END
	
	IF EXISTS (SELECT * FROM #ImportResult WHERE isnumeric(OraNum)=0)
	BEGIN
		SET @Return = '原数量必须是数字！'
		RETURN 
	END
	
	IF EXISTS (SELECT * FROM #ImportResult WHERE isnumeric(AdjustNum)=0)
	BEGIN
		SET @Return = '调整数量必须是数字！'
		RETURN 
	END
	
	IF EXISTS (SELECT * FROM #ImportResult WHERE isnumeric(Ratio)=0)
	BEGIN
		SET @Return = '加价率必须是数字！'
		RETURN 
	END
	
	IF EXISTS (SELECT * FROM #ImportResult WHERE PointType NOT IN ('Money','Point'))
	BEGIN
		SET @Return = '积分类型只能是Money或Point！'
		RETURN 
	END
	
	IF EXISTS (SELECT * FROM #ImportResult WHERE isDate(PointValidDate)=0)
	BEGIN
		SET @Return = '积分有效期必须是日期格式！'
		RETURN 
	END
	
	IF EXISTS (SELECT BU,ACCOUNTMONTH,COUNT(*) FROM (
		SELECT DISTINCT BU,ACCOUNTMONTH FROM #ImportResult a) T 
		GROUP BY BU,ACCOUNTMONTH HAVING COUNT(*) > 1)
	BEGIN
		SET @Return = '同时只能导入相同的BU和帐期！'
		RETURN 
	END
	
	IF EXISTS (SELECT Period,COUNT(*) FROM (
		SELECT DISTINCT B.Period FROM #ImportResult a,Promotion.Pro_Policy B WHERE A.PolicyNo = B.PolicyNo) T 
		GROUP BY Period HAVING COUNT(*) > 1)
	BEGIN
		SET @Return = '导入的政策结算类型要统一是季度或月度！'
		RETURN 
	END
	
	SELECT @iStr = STUFF(REPLACE(REPLACE((
	SELECT DISTINCT PolicyNo FROM #ImportResult a WHERE NOT EXISTS (SELECT 1 FROM Promotion.Pro_policy WHERE PolicyNo = a.PolicyNo)
		FOR XML AUTO), '<a PolicyNo="',';'), '"/>', ''), 1, 1, '')
	IF ISNULL(@iStr,'') <> ''
	BEGIN
		SET @Return = '政策编号不存在：'+@iStr
		RETURN
	END
	
	SELECT @iStr = STUFF(REPLACE(REPLACE((
	SELECT DISTINCT PolicyNo FROM #ImportResult a WHERE NOT EXISTS (SELECT 1 FROM Promotion.Pro_policy WHERE PolicyNo = a.PolicyNo AND BU = A.BU)
		FOR XML AUTO), '<a PolicyNo="',';'), '"/>', ''), 1, 1, '')
	IF ISNULL(@iStr,'') <> ''
	BEGIN
		SET @Return = '政策所属的BU不正确：'+@iStr
		RETURN
	END
	
	SELECT @iStr = STUFF(REPLACE(REPLACE((
	SELECT DISTINCT PolicyNo FROM #ImportResult a WHERE NOT EXISTS (SELECT 1 FROM Promotion.Pro_policy WHERE PolicyNo = a.PolicyNo AND CalPeriod = A.AccountMonth)
		FOR XML AUTO), '<a PolicyNo="',';'), '"/>', ''), 1, 1, '')
	IF ISNULL(@iStr,'') <> ''
	BEGIN
		SET @Return = '政策所属的帐期不正确：'+@iStr
		RETURN
	END
	
	SELECT @iStr = STUFF(REPLACE(REPLACE((
	SELECT DISTINCT PolicyNo FROM #ImportResult a WHERE NOT EXISTS (SELECT 1 FROM Promotion.Pro_policy WHERE PolicyNo = a.PolicyNo AND ifCalPurchaseAR = (case when A.PointType='Point' then 'N' else 'Y' end))
		FOR XML AUTO), '<a PolicyNo="',';'), '"/>', ''), 1, 1, '')
	IF ISNULL(@iStr,'') <> ''
	BEGIN
		SET @Return = '政策的积分类型不正确：'+@iStr
		RETURN
	END
	
	/*
	SELECT @iStr = STUFF(REPLACE(REPLACE((
	SELECT DISTINCT DealerName FROM #ImportResult a WHERE NOT EXISTS (SELECT 1 FROM DealerMaster 
		WHERE DMA_ChineseName = A.DealerName)
		FOR XML AUTO), '<a DealerName="',';'), '"/>', ''), 1, 1, '')
	IF ISNULL(@iStr,'') <> ''
	BEGIN
		SET @Return = '经销商名称不正确：'+@iStr
		RETURN
	END
	ELSE
	BEGIN
		--更新经销商ID,上级经销商ID
		UPDATE A SET DealerId = B.DMA_ID,LpId = B.DMA_Parent_DMA_ID
		FROM #ImportResult A,DealerMaster B
		WHERE A.DealerName = B.DMA_ChineseName
	END
	*/
	
	--更新经销商ID,上级经销商ID
	UPDATE A SET LpId = B.DMA_Parent_DMA_ID,DealerId=B.DMA_ID
	FROM #ImportResult A,DealerMaster B
	WHERE A.SAPCode = B.DMA_SAP_Code
	
	/*
	SELECT @iStr = STUFF(REPLACE(REPLACE((
	SELECT DISTINCT HospitalName FROM #ImportResult a WHERE isnull(HospitalName,'')<>'' AND NOT EXISTS (SELECT 1 FROM Hospital 
		WHERE HOS_HospitalName = A.HospitalName)
		FOR XML AUTO), '<a HospitalName="',';'), '"/>', ''), 1, 1, '')
	IF ISNULL(@iStr,'') <> ''
	BEGIN
		SET @Return = '医院称不正确：'+@iStr
		RETURN
	END
	ELSE
	BEGIN
		--更新医院ID
		UPDATE A SET HospitalId = B.HOS_Key_Account
		FROM #ImportResult A,Hospital B
		WHERE A.HospitalName = B.HOS_HospitalName
	END
	*/
	
	--不能导入已在审批中或审批通过的政策
	SELECT @iStr = STUFF(REPLACE(REPLACE((
		SELECT DISTINCT a.PolicyNo FROM #ImportResult a WHERE EXISTS (	
		SELECT * FROM Promotion.T_Pro_Flow X,Promotion.T_Pro_Flow_Detail Y,Promotion.Pro_Policy Z,DealerMaster M
		WHERE X.FlowId = Y.FlowId AND X.AccountMonth = a.AccountMonth AND Y.PolicyId = Z.PolicyId 
		AND Z.PolicyNo = a.PolicyNo AND X.Status NOT IN ('审批拒绝','撤销') AND A.SAPCode=M.DMA_SAP_Code AND Y.DealerId=M.DMA_ID)
		FOR XML AUTO), '<a PolicyNo="',';'), '"/>', ''), 1, 1, '')
	IF ISNULL(@iStr,'') <> ''
	BEGIN
		SET @Return = '已存在提交过相同经销商的政策：'+@iStr
		RETURN
	END
		
	--政策中的经销商必须与初始数据一致
	CREATE TABLE #TMP_NOT_ALIGN_COUNT
	(
		PolicyNo NVARCHAR(100)
	)
	CREATE TABLE #TMP_NOT_ALIGN_AMOUNT
	(
		PolicyNo NVARCHAR(100)
	)
	
	DECLARE @PolicyNo NVARCHAR(100)
	DECLARE @CalPeriod NVARCHAR(20);
	DECLARE @CalType NVARCHAR(20);
	DECLARE @TempTableName NVARCHAR(50);
	
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT DISTINCT A.PolicyNo,B.TempTableName,B.CalPeriod,B.CalType 
		FROM #ImportResult A,Promotion.Pro_Policy B WHERE A.PolicyNo = B.PolicyNo
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @PolicyNo,@TempTableName,@CalPeriod,@CalType
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL = N'INSERT INTO #TMP_NOT_ALIGN_COUNT(PolicyNo) 
			SELECT '''+@PolicyNo+''' WHERE  EXISTS (SELECT * FROM #ImportResult A
			WHERE PolicyNo = '''+@PolicyNo+''' AND CONVERT(DECIMAL(18,4),A.OraNum)<>0 AND NOT EXISTS (SELECT 1 FROM '+@TempTableName+' 
				WHERE DealerId = A.DealerId '+CASE @CalType WHEN 'ByDealer' THEN '' ELSE ' AND HospitalId = A.HospitalId' END+'))'
		PRINT @SQL
		BEGIN TRY
			EXEC(@SQL)	
		END TRY
		BEGIN CATCH
			PRINT 'ERROR AT '+CONVERT(NVARCHAR,@PolicyNo)
		END CATCH		
		
		--SET @SQL = N'INSERT INTO #TMP_NOT_ALIGN_AMOUNT(PolicyNo) 
		--	SELECT '''+@PolicyNo+''' WHERE EXISTS (
		--		SELECT * FROM '+@TempTableName+' A,#ImportResult B
		--		WHERE B.PolicyNo = '''+@PolicyNo+''' AND A.DealerId = B.DealerId '
		--		+CASE @CalType WHEN 'ByDealer' THEN '' ELSE ' AND HospitalId = A.HospitalId' END+'
		--		AND Points'+@CalPeriod+' <> convert(DECIMAL(18,4),b.OraNum))'
		--PRINT @SQL
		--BEGIN TRY
		--	EXEC(@SQL)	
		--END TRY
		--BEGIN CATCH
		--	PRINT 'ERROR AT '+CONVERT(NVARCHAR,@PolicyNo)
		--END CATCH	
		
		FETCH NEXT FROM @iCURSOR INTO @PolicyNo,@TempTableName,@CalPeriod,@CalType
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
	SELECT @iStr = STUFF(REPLACE(REPLACE((
		SELECT PolicyNo FROM #TMP_NOT_ALIGN_COUNT a
		FOR XML AUTO), '<a PolicyNo="',';'), '"/>', ''), 1, 1, '')
	IF ISNULL(@iStr,'') <> ''
	BEGIN
		SET @Return = '如下政策导入的经销商与系统中已结算的经销商不符:'+@iStr
		RETURN
	END
	
	--SELECT @iStr = STUFF(REPLACE(REPLACE((
	--	SELECT PolicyNo FROM #TMP_NOT_ALIGN_AMOUNT a
	--	FOR XML AUTO), '<a PolicyNo="',';'), '"/>', ''), 1, 1, '')
	--IF ISNULL(@iStr,'') <> ''
	--BEGIN
	--	SET @Return = '如下政策原积分与系统中已结算的不符:'+@iStr
	--	RETURN
	--END
	
	--更新积分描述
	UPDATE A SET LargessDesc = case when len(Promotion.func_Pro_PolicyToHtml_Factor_Product(B.UseRangePolicyFactorId,null)) > 2000 then SUBSTRING(Promotion.func_Pro_PolicyToHtml_Factor_Product(B.UseRangePolicyFactorId,null),0,2000) else Promotion.func_Pro_PolicyToHtml_Factor_Product(B.UseRangePolicyFactorId,null) end
	FROM #ImportResult A,Promotion.PRO_POLICY_LARGESS B,Promotion.Pro_Policy C
	WHERE A.PolicyNo = c.PolicyNo AND B.PolicyId = c.PolicyId 
	
	--**********************************放入正式表*********************************************************
	DECLARE @FlowId INT;
	
	BEGIN TRAN
		INSERT INTO Promotion.T_Pro_Flow(Description,BU,Period,AccountMonth,Status,CreateBy,CreateTime,HtmlStr,FlowType,MarketType,Reason,BeginDate,EndDate,SettlementStatus,InstanceId)
		SELECT TOP 1 @Description,B.BU,B.Period,A.AccountMonth,'草稿',@UserId,GETDATE(),'','积分',@MarketType,@Reason,@BeginDate,@EndDate,'待结账',NEWID()
		FROM #ImportResult A,Promotion.Pro_Policy B
		WHERE A.PolicyNo = B.PolicyNo
		
		SELECT @FlowId = SCOPE_IDENTITY()
		
		INSERT INTO Promotion.T_Pro_Flow_Detail(FlowId,PolicyId,LargessDesc,LPId,DealerId,HospitalId,OraNum,AdjustNum,ValidDate,Ratio)
		SELECT @FlowId,B.PolicyId,A.LargessDesc,A.LPId,A.DealerId,A.HospitalId,A.OraNum,A.AdjustNum,@EndDate,A.Ratio
		FROM #ImportResult A,Promotion.Pro_Policy B
		WHERE A.PolicyNo = B.PolicyNo
		
		UPDATE Promotion.PRO_Attachment SET PAT_PolicyId=@FlowId WHERE PAT_GiftId=@AttachmentId;
		
		DECLARE @HtmlStr  NVARCHAR(MAX)
		EXEC PROMOTION.Proc_Pro_GetEWorkFlowHtml @FlowId,@HtmlStr OUTPUT
		
		UPDATE Promotion.T_Pro_Flow SET HtmlStr = @HtmlStr WHERE FlowId = @FlowId
		
		DECLARE @Qty  decimal(14, 2);
		SELECT @Qty=SUM(AdjustNum) FROM Promotion.T_Pro_Flow_Detail WHERE FlowId = @FlowId
		
		SET @ReQty= CONVERT(NVARCHAR(10),@Qty);
		SET @Return = 'Success'
		SET @ReFlowId=CONVERT(NVARCHAR(10),@FlowId);
	COMMIT TRAN

END TRY
BEGIN CATCH
	SET @Return = 'Failed:'+ERROR_MESSAGE()
	SET @ReFlowId='';
	SET @ReQty='';
	ROLLBACK TRAN
END CATCH

