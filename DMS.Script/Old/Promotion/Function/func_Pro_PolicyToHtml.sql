DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml]
GO

CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml]
(
	@PolicyId INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX);	
	
	IF EXISTS(
	       SELECT 1
	       FROM   Promotion.PRO_POLICY
	       WHERE  PolicyId = @PolicyId
	   )
	BEGIN
	    SET @iReturn = '';
	    --SET @iReturn = '<style type="text/css">div.des{word-break:break-all;margin:0px;padding:5px;font-family: verdana,arial,sans-serif;font-size:11px;line-height:22px;width:68%;height:auto;border:solid 1px #666666;}table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
	    
	    --政策概要*******************************************************************************************
	    DECLARE @PolicyName NVARCHAR(100);
	    DECLARE @PolicyNo NVARCHAR(50);
	    DECLARE @PolicyType NVARCHAR(10);
	    DECLARE @PolicyStyle NVARCHAR(100);
	    DECLARE @PolicySubStyle NVARCHAR(100);	
	    DECLARE @Bu NVARCHAR(20);
	    DECLARE @TopValueDesc NVARCHAR(50);
	    DECLARE @PolicyGroupName NVARCHAR(100);
	    DECLARE @Period NVARCHAR(5);
	    DECLARE @StartDate DATETIME;
	    DECLARE @EndDate DATETIME;
	    DECLARE @PointValidDateType NVARCHAR(100);
	    DECLARE @PointValidDateDuration NVARCHAR(100);
	    DECLARE @PointValidDateAbsolute NVARCHAR(100);
	    DECLARE @PointValidDateType2 NVARCHAR(100);
	    DECLARE @PointValidDateDuration2 NVARCHAR(100);
	    DECLARE @PointValidDateAbsolute2 NVARCHAR(100);
	    DECLARE @PointUseRange NVARCHAR(MAX);
	    DECLARE @PointUseRange2 NVARCHAR(MAX);
	    DECLARE @Description NVARCHAR(500);
	    DECLARE @OtherMemo NVARCHAR(1000);
	    DECLARE @YTDOption NVARCHAR(200); 
	    DECLARE @TopType NVARCHAR(20);
	    
	    DECLARE @StartDateStr NVARCHAR(100);
	    DECLARE @EndDateStr NVARCHAR(100);
	    DECLARE @PointSummary NVARCHAR(2000); 
	    DECLARE @RatioSummary NVARCHAR(2000); 
	    DECLARE @BaseUrl NVARCHAR(100);
	    
	    DECLARE @PolicyFactorId INT;
	    DECLARE @FactName NVARCHAR(100);
	    
	    SELECT @PolicyName = ISNULL(A.PolicyName, ''),
	           @PolicyNo = ISNULL(A.PolicyNo, ''),
	           @PolicyType = ISNULL(A.PolicyType, ''),
	           @PolicyStyle = ISNULL(A.PolicyStyle, ''),
	           @PolicySubStyle = ISNULL(A.PolicySubStyle, ''),
	           @Bu = A.BU + CASE ISNULL(A.SubBu, '')
	                             WHEN '' THEN ''
	                             ELSE '-' + (
	                                      SELECT CC_NameCN
	                                      FROM   interface.ClassificationContract
	                                      WHERE  CC_Code = A.SubBu
	                                  )
	                        END,
	           @TopType = ISNULL(A.TopType, ''),
	           @TopValueDesc = CASE ISNULL(A.TopType, '')
	                                WHEN '' THEN '无'
	                                WHEN 'Policy' THEN '封顶' + CONVERT(NVARCHAR, CONVERT(DECIMAL(10, 2), A.TopValue))
	                                ELSE '参见:附录2'
	                           END,
	           @PolicyGroupName = ISNULL(A.PolicyGroupName, ''),
	           @Period = ISNULL(
	               CASE 
	                    WHEN ISNULL(A.PolicyStyle, '') = '即时买赠' THEN ''
	                    ELSE A.Period
	               END,
	               ''
	           ),
	           @StartDate = CONVERT(DATETIME, A.StartDate + '01'),
	           @EndDate = DATEADD(MONTH, 1, CONVERT(DATETIME, A.EndDate + '01')) -1,
	           @PointValidDateType = ISNULL(A.PointValidDateType, ''),
	           @PointValidDateDuration = CASE 
	                                          WHEN A.PointValidDateDuration IS NOT NULL THEN CONVERT(NVARCHAR, A.PointValidDateDuration) + '个月'
	                                          ELSE ''
	                                     END,
	           @PointValidDateAbsolute = CASE 
	                                          WHEN A.PointValidDateAbsolute IS NOT NULL THEN CONVERT(NVARCHAR(10), A.PointValidDateAbsolute, 121)
	                                          ELSE ''
	                                     END,
	           @PointValidDateType2 = ISNULL(A.PointValidDateType2, ''),
	           @PointValidDateDuration2 = CASE 
	                                           WHEN A.PointValidDateDuration2 IS NOT NULL THEN CONVERT(NVARCHAR, A.PointValidDateDuration2) + '个月'
	                                           ELSE ''
	                                      END,
	           @PointValidDateAbsolute2 = CASE 
	                                           WHEN A.PointValidDateAbsolute2 IS NOT NULL THEN CONVERT(NVARCHAR(10), A.PointValidDateAbsolute2, 121)
	                                           ELSE ''
	                                      END,
	           @PointUseRange2 = ISNULL(A.PointUseRange, ''),
	           @OtherMemo = CASE ISNULL(A.ifAddLastLeft, '')
	                             WHEN 'Y' THEN '上期余量计入本期考核'
	                             ELSE '上期余量不累计计算(' + CASE ISNULL(A.CarryType, '')
	                                                               WHEN 'Round' THEN '四舍五入'
	                                                               WHEN 'Ceiling' THEN '往上取整'
	                                                               WHEN 'Floor' THEN '往下取整'
	                                                               WHEN 'KeepValue' THEN '保留原值'
	                                                               ELSE ''
	                                                          END + ')'
	                        END + '，'
	           + CASE ISNULL(A.ifMinusLastGift, '')
	                  WHEN 'Y' THEN '本期考核量中扣除上期赠品'
	                  ELSE '赠品不从考核量中扣除'
	             END 
	           + CASE ISNULL(A.ifConvert, '')
	                  WHEN 'Y' THEN '，赠品转为积分'
	                  ELSE ''
	             END
	           + CASE ISNULL(A.ifCalRebateAR, '')
	                  WHEN 'Money' THEN '，算完成算返利'
	                  WHEN 'Point' THEN '，不算完成不算返利'
	                  ELSE ''
	             END 
	           + CASE ISNULL(A.ifCalPurchaseAR, '')
	                  WHEN 'Y' THEN '，赠送计入商业采购达成'
	                  ELSE '，赠送不计入商业采购达成'
	             END,
	           @YTDOption = CASE ISNULL(A.YTDOption, 'N')
	                             WHEN 'N' THEN ''
	                             WHEN 'YTD' THEN '满足年度指标开始奖励(年度指标设置在第一帐期)'
	                             WHEN 'YTDRTN' THEN '满足当前帐期指标即奖励，满足YTD指标补历史奖励'
	                             ELSE ''
	                        END
	    FROM   Promotion.PRO_POLICY A
	    WHERE  PolicyId = @PolicyId
	    
	    SELECT @PointUseRange = ISNULL(
	               Promotion.func_Pro_PolicyToHtml_Factor_Product(A.UseRangePolicyFactorId, NULL),
	               ''
	           )
	    FROM   Promotion.PRO_POLICY_LARGESS A
	    WHERE  PolicyId = @PolicyId
	    
	    SET @StartDateStr = ISNULL(
	            CONVERT(NVARCHAR(4), DATEPART(YEAR, @StartDate)) + '年' + CONVERT(NVARCHAR(2), DATEPART(MONTH, @StartDate)) + '月' + CONVERT(NVARCHAR(2), DATEPART(DAY, @StartDate)) + '日',
	            ''
	        );
	    SET @EndDateStr = ISNULL(
	            CONVERT(NVARCHAR(4), DATEPART(YEAR, @EndDate)) + '年' + CONVERT(NVARCHAR(2), DATEPART(MONTH, @EndDate)) + '月' + CONVERT(NVARCHAR(2), DATEPART(DAY, @EndDate)) + '日',
	            ''
	        );
	    
	    SET @OtherMemo = ISNULL(@OtherMemo, '') + CASE ISNULL(@OtherMemo, '')
	                                                   WHEN '' THEN ''
	                                                   ELSE '。<br/>'
	                                              END + @YTDOption
	    
	    SET @OtherMemo = CASE 
	                          WHEN ISNULL(@PolicyStyle, '') = '即时买赠' THEN ''
	                          ELSE ISNULL(@OtherMemo, '')
	                     END
	    
	    SELECT @BaseUrl = VALUE1
	    FROM   Lafite_DICT
	    WHERE  DICT_TYPE = 'CONST_CONTRACT_ContractBaseUrl'
	           AND DICT_KEY = 'BaseUrl'
	    
	    SET @iReturn += '<h2 style="text-align: center;"><b>' + @PolicyName + '</b></h2>';
	    
	    --政策概要************************************************************************************************
	    SET @iReturn += '<h4><font color="#FF0000">政策概要</font></h4>';
	    SET @iReturn += '<div class="des"><div style="padding: 5px;">';
	    SET @iReturn += Promotion.func_Pro_PolicyToHtml_Summary(@PolicyId, 'EkpInfo');	
	    SET @iReturn += '</div></div>';
	    
	    --概述************************************************************************************************
	    SET @iReturn += '<h4>概述</h4>'
	    SET @iReturn += '<table class="gridtable">'
	    SET @iReturn += '<tr><th>政策编号</th><td>' + @PolicyNo + '</td></tr>'
	    SET @iReturn += '<tr><th>促销方式</th><td>' + @PolicyType + '</td></tr>'
	    SET @iReturn += '<tr><th>政策分类</th><td>' + @PolicyStyle + '</td></tr>'
	    SET @iReturn += '<tr><th>政策子类</th><td>' + @PolicySubStyle + '</td></tr>'
	    SET @iReturn += '<tr><th>部门</th><td>' + @Bu + '</td></tr>'
	    SET @iReturn += '<tr><th>封顶值</th><td>' + @TopValueDesc + '</td></tr>'
	    SET @iReturn += '<tr><th>政策名称</th><td>' + @PolicyName + '</td></tr>'
	    SET @iReturn += '<tr><th>归类名称</th><td>' + @PolicyGroupName + '</td></tr>'
	    SET @iReturn += '<tr><th>考核周期</th><td>' + @Period + '</td></tr>'
	    SET @iReturn += '<tr><th>适用期限</th><td>' + @StartDateStr + '&nbsp;至&nbsp;' + @EndDateStr + '</td></tr>'
	    IF @PolicySubStyle IN ('促销赠品转积分', '满额送固定积分', '金额百分比积分')
	    BEGIN
	        SET @PointSummary = '经销商积分：' + CASE @PointValidDateType
	                                                  WHEN 'Always' THEN '积分始终有效，'
	                                                  WHEN 'AbsoluteDate' THEN '积分使用有效期至' + @PointValidDateAbsolute + '，'
	                                                  WHEN 'AccountMonth' THEN '积分在结算后的' + @PointValidDateDuration + '内使用，'
	                                                  ELSE ''
	                                             END
	            + '使用范围：' + @PointUseRange + '。'
	        
	        SET @PointSummary += '平台积分：' + CASE @PointValidDateType2
	                                                 WHEN 'Always' THEN '积分始终有效，'
	                                                 WHEN 'AbsoluteDate' THEN '积分使用有效期至' + @PointValidDateAbsolute2 + '，'
	                                                 WHEN 'AccountMonth' THEN '积分在结算后的' + @PointValidDateDuration2 + '内使用，'
	                                                 ELSE ''
	                                            END
	            + '使用范围：' + CASE @PointUseRange2
	                                  WHEN 'BU' THEN '本BU所有产品'
	                                  ELSE '与经销商积分使用范围一致'
	                             END + '。'
	        
	        IF NOT EXISTS (
	               SELECT 1
	               FROM   Promotion.PRO_POLICY_POINTRATIO
	               WHERE  PolicyId = @PolicyId
	           )
	        BEGIN
	            SET @RatioSummary = '使用平台统一加价率'
	        END
	        ELSE
	        BEGIN
	            SET @RatioSummary = '参见:附录4。不符合附录的情况则使用平台统一加价率。'
	        END
	        
	        SET @iReturn += '<tr><th>积分说明</th><td>' + @PointSummary + '</td></tr>'
	        SET @iReturn += '<tr><th>加价率说明</th><td>' + @RatioSummary + '</td></tr>'
	    END
	    
	    SET @iReturn += '<tr><th>政策描述</th><td>无</td></tr>'
	    SET @iReturn += '<tr><th>其他说明</th><td>' + @OtherMemo + '</td></tr>'
	    SET @iReturn += '<tr><th>附件上传</th><td><a target="_blank"  href="' + @BaseUrl + 'API.aspx?PageId=60&InstanceID=' + @PolicyNo + '">上传附件</a></td></tr>'
	    SET @iReturn += '</table>'
	    
	    --附件信息************************************************************************************************
	    IF EXISTS(
	           SELECT 1
	           FROM   Promotion.PRO_Attachment
	           WHERE  PAT_PolicyId = @PolicyId
	       )
	    BEGIN
	        DECLARE @AttachmentName NVARCHAR(200);
	        DECLARE @AttachmentURL NVARCHAR(500);
	        DECLARE @Nber NVARCHAR(10);
	        SET @iReturn += '<h4>附件</h4><table class="gridtable">'
	        
	        DECLARE @PRODUCT_CUR CURSOR ;
	        SET @PRODUCT_CUR = CURSOR FOR 
	        SELECT PAT_Name,
	               PAT_Url,
	               ROW_NUMBER() OVER(ORDER BY PAT_UploadDate DESC)
	        FROM   Promotion.PRO_Attachment
	        WHERE  PAT_PolicyId = @PolicyId
	        
	        OPEN @PRODUCT_CUR
	        FETCH NEXT FROM @PRODUCT_CUR INTO @AttachmentName,@AttachmentURL,@Nber
	        WHILE @@FETCH_STATUS = 0
	        BEGIN
	            SET @iReturn += '<tr><th>附件' + @Nber + '</th><td><a href="' + @BaseUrl + 'Pages/Download.aspx?downloadname=' + @AttachmentName + '&filename=' + @AttachmentURL + 
	                '&downtype=Promotion">' + @AttachmentName + '</a></td></tr>'
	            
	            FETCH NEXT FROM @PRODUCT_CUR INTO @AttachmentName,@AttachmentURL,@Nber
	        END
	        CLOSE @PRODUCT_CUR
	        DEALLOCATE @PRODUCT_CUR ;
	        SET @iReturn += '</table>'
	    END
	    
	    --适用范围************************************************************************************************
	    SET @iReturn += '<h4>适用范围</h4><table class="gridtable">'
	    SET @iReturn += '<tr><th>经销商</th><td>' + Promotion.func_Pro_PolicyToHtml_Dealer(@PolicyId) + '</td></tr></table>'
	    
	    --涉及因素************************************************************************************************
	    SET @iReturn += '<h4>涉及参数</h4><table class="gridtable">'
	    
	    IF EXISTS(
	           SELECT 1
	           FROM   Promotion.PRO_POLICY_FACTOR
	           WHERE  PolicyId = @PolicyId
	       )
	    BEGIN
	        DECLARE @iCURSOR_Factor CURSOR ;
	        SET @iCURSOR_Factor =  CURSOR FOR 
	        SELECT A.PolicyFactorId,
	               B.FactName + '[编号' + CONVERT(NVARCHAR, A.PolicyFactorId) + ']' FactName
	        FROM   Promotion.PRO_POLICY_FACTOR A,
	               Promotion.PRO_FACTOR B
	        WHERE  A.FactId = B.FactId
	               AND PolicyId = @PolicyId
	        
	        OPEN @iCURSOR_Factor 
	        FETCH NEXT FROM @iCURSOR_Factor INTO @PolicyFactorId,@FactName
	        WHILE @@FETCH_STATUS = 0
	        BEGIN
	            SET @iReturn += '<tr><th>' + @FactName + '</th><td>' + Promotion.func_Pro_PolicyToHtml_Factor(@PolicyFactorId) + '</td></tr>'
	            
	            FETCH NEXT FROM @iCURSOR_Factor INTO @PolicyFactorId,@FactName
	        END 
	        CLOSE @iCURSOR_Factor
	        DEALLOCATE @iCURSOR_Factor
	        SET @iReturn += '</table>'
	    END
	    
	    --促销规则************************************************************************************************
	    IF EXISTS (
	           SELECT 1
	           FROM   Promotion.PRO_POLICY_RULE
	           WHERE  PolicyId = @PolicyId
	       )
	    BEGIN
	        DECLARE @RuleCondition NVARCHAR(MAX);
	        DECLARE @RuleResult NVARCHAR(MAX);
	        DECLARE @RuleDesc NVARCHAR(MAX);
	        
	        SET @iReturn += '<h4>促销规则</h4><table class="gridtable">'
	        
	        DECLARE @iCURSOR_Rule CURSOR ;
	        SET @iCURSOR_Rule =  CURSOR FOR 
	        SELECT Promotion.func_Pro_PolicyToHtml_Rule_Condition(RuleId),
	               Promotion.func_Pro_PolicyToHtml_Rule_Result(RuleId),
	               RuleDesc
	        FROM   Promotion.PRO_POLICY_RULE
	        WHERE  PolicyId = @PolicyId
	        
	        OPEN @iCURSOR_Rule 
	        FETCH NEXT FROM @iCURSOR_Rule INTO @RuleCondition,@RuleResult,@RuleDesc
	        WHILE @@FETCH_STATUS = 0
	        BEGIN
	            IF ISNULL(@RuleDesc, '') <> ''
	            BEGIN
	                SET @RuleResult = ISNULL(@RuleResult, '') + '</br> 描述：' + @RuleDesc + '';
	            END
	            
	            SET @iReturn += '<tr><th>' + @RuleCondition + '</th><td>' + @RuleResult + '</td></tr>'
	            
	            FETCH NEXT FROM @iCURSOR_Rule INTO @RuleCondition,@RuleResult,@RuleDesc
	        END 
	        CLOSE @iCURSOR_Rule
	        DEALLOCATE @iCURSOR_Rule
	        SET @iReturn += '</table>'
	    END
	    
	    --附录1(指定产品医院植入指标)*****************************************************************************
	    IF EXISTS (
	           SELECT *
	           FROM   Promotion.PRO_POLICY a,
	                  Promotion.PRO_POLICY_factor b,
	                  Promotion.Pro_Hospital_PrdSalesTaget c
	           WHERE  a.PolicyId = b.PolicyId
	                  AND b.PolicyFactorId = c.PolicyFactorId
	                  AND a.PolicyId = @PolicyId
	       )
	    BEGIN
	        SET @iReturn += '<h4>附录1</h4><table class="gridtable">'
	        SET @iReturn += Promotion.func_Pro_PolicyToHtml_Appendix1(@PolicyId)
	        SET @iReturn += '</table>'
	    END
	    
	    --附录2(封顶值)*********************************************************************************************
	    IF ISNULL(@TopType, '') IN ('Dealer', 'Hospital', 'DealerPeriod', 'HospitalPeriod')
	    BEGIN
	        SET @iReturn += '<h4>附录2</h4><table class="gridtable">'
	        SET @iReturn += Promotion.func_Pro_PolicyToHtml_Appendix2(@PolicyId)
	        SET @iReturn += '</table>'
	    END
	    
	    --附录3(指定产品经销商采购指标)******************************************************************************
	    IF EXISTS (
	           SELECT *
	           FROM   Promotion.PRO_POLICY a,
	                  Promotion.PRO_POLICY_factor b,
	                  Promotion.Pro_Dealer_PrdPurchase_Taget c
	           WHERE  a.PolicyId = b.PolicyId
	                  AND b.PolicyFactorId = c.PolicyFactorId
	                  AND a.PolicyId = @PolicyId
	       )
	    BEGIN
	        SET @iReturn += '<h4>附录3</h4><table class="gridtable">'
	        SET @iReturn += Promotion.func_Pro_PolicyToHtml_Appendix3(@PolicyId)
	        SET @iReturn += '</table>'
	    END
	    
	    --附录4(加价率)******************************************************************************
	    IF EXISTS (
	           SELECT *
	           FROM   Promotion.PRO_POLICY_POINTRATIO
	           WHERE  PolicyId = @PolicyId
	       )
	    BEGIN
	        SET @iReturn += '<h4>附录4</h4><table class="gridtable">'
	        SET @iReturn += Promotion.func_Pro_PolicyToHtml_Appendix4(@PolicyId)
	        SET @iReturn += '</table>'
	    END
	    
	    --附录5(经销商固定积分表)******************************************************************
	    IF EXISTS (
	           SELECT *
	           FROM   Promotion.Pro_Dealer_Std_Point
	           WHERE  PolicyId = @PolicyId
	       )
	    BEGIN
	        SET @iReturn += '<h4>附录5</h4><table class="gridtable">'
	        SET @iReturn += Promotion.func_Pro_PolicyToHtml_Appendix5(@PolicyId)
	        SET @iReturn += '</table>'
	    END
	END
	
	SET @iReturn += '</div>'
	RETURN @iReturn
END
GO