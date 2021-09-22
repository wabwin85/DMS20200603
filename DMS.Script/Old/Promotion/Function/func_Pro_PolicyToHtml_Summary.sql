DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Summary]
GO

CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Summary]
(
	@PolicyId  INT,
	@HtmlType  NVARCHAR(20) --TemplatePreview/TemplateSummary/EkpInfo
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @EmptyStr NVARCHAR(100);
	SET @EmptyStr = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
	DECLARE @PencilStr NVARCHAR(100);
	SET @PencilStr = '&nbsp;<i class=''fa fa-pencil''></i>';
	
	DECLARE @iReturn NVARCHAR(MAX);
	SET @iReturn = '';
	
	DECLARE @PolicyName NVARCHAR(100);
	DECLARE @StartDate DATETIME;
	DECLARE @EndDate DATETIME;
	DECLARE @Period NVARCHAR(5);
	DECLARE @Acquisition BIT;
	DECLARE @BaseUrl NVARCHAR(100);
	
	SELECT @PolicyName = ISNULL(PolicyName, ''),
	       @StartDate = CONVERT(DATETIME, StartDate + '01'),
	       @EndDate = DATEADD(MONTH, 1, CONVERT(DATETIME, EndDate + '01')) -1,
	       @Period = CASE 
	                      WHEN ISNULL(PolicyStyle, '') = '即时买赠' THEN '即时'
	                      ELSE ISNULL(Period, '')
	                 END,
	       @Acquisition = CASE WHEN ifCalPurchaseAR = 'Y' THEN 1 ELSE 0 END
	FROM   Promotion.PRO_POLICY
	WHERE  PolicyId = @PolicyId
	
	SELECT @BaseUrl = VALUE1
	FROM   Lafite_DICT
	WHERE  DICT_TYPE = 'CONST_CONTRACT_ContractBaseUrl'
	       AND DICT_KEY = 'BaseUrl'
	
	--PolicyName
	BEGIN
		IF @HtmlType = 'TemplatePreview'
		BEGIN
		    IF @PolicyName = ''
		    BEGIN
		        SET @iReturn += '<div class="size-24 center"><span class="empty">' + @EmptyStr + '</span></div>';
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<div class="size-24 center"><span class="filled">' + @PolicyName + '</span></div>';
		    END
		END
		ELSE 
		IF @HtmlType = 'TemplateSummary'
		BEGIN
		    SET @iReturn += '<div class="size-24 center"><span class="edit" data-target="Basic">';
		    IF @PolicyName = ''
		    BEGIN
		        SET @iReturn += '<span class="empty">' + @EmptyStr + '</span>' + @PencilStr ;
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<span class="filled">' + @PolicyName + '</span>' + @PencilStr;
		    END
		    SET @iReturn += '</span></div>';
		END
	END
	
	--Row Declare
	BEGIN
		IF @HtmlType <> 'EkpInfo'
		BEGIN
		    SET @iReturn += '<ol class="size-16" style="padding-left: 30px; list-style-type: cjk-ideographic;">';
		END
		ELSE
		BEGIN
		    SET @iReturn += '<ol style="padding-left: 30px; list-style-type: cjk-ideographic; font-size: 16px; margin: 0px;">';
		END
	END
	
	--1 适用产品
	BEGIN
		DECLARE @ProductStr NVARCHAR(2000);
		SET @ProductStr = Promotion.func_Pro_PolicyToHtml_SummaryProduct(@PolicyId)
		
		SET @iReturn += '<li>适用产品：'
		
		IF @HtmlType = 'TemplatePreview'
		BEGIN
		    IF @ProductStr = ''
		    BEGIN
		        SET @iReturn += '<span class="empty">' + @EmptyStr + '</span>';
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<span class="filled">' + @ProductStr + '</span>';
		    END
		END
		ELSE 
		IF @HtmlType = 'TemplateSummary'
		BEGIN
		    SET @iReturn += '<span class="edit" data-target="Factor">';
		    IF @ProductStr = ''
		    BEGIN
		        SET @iReturn += '<span class="empty">' + @EmptyStr + '</span>' + @PencilStr;
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<span class="filled">' + @ProductStr + '</span>' + @PencilStr;
		    END
		    SET @iReturn += '</span>';
		END
		ELSE
		BEGIN
		    SET @iReturn += @ProductStr;
		END
		
		SET @iReturn += '</li>';
	END
	
	--2 适用期限
	BEGIN
		DECLARE @StartDateStr NVARCHAR(100);
		DECLARE @EndDateStr NVARCHAR(100);
		SET @StartDateStr = ISNULL(
		        CONVERT(NVARCHAR(4), DATEPART(YEAR, @StartDate)) + '年' + CONVERT(NVARCHAR(2), DATEPART(MONTH, @StartDate)) + '月' + CONVERT(NVARCHAR(2), DATEPART(DAY, @StartDate)) + '日',
		        ''
		    );
		SET @EndDateStr = ISNULL(
		        CONVERT(NVARCHAR(4), DATEPART(YEAR, @EndDate)) + '年' + CONVERT(NVARCHAR(2), DATEPART(MONTH, @EndDate)) + '月' + CONVERT(NVARCHAR(2), DATEPART(DAY, @EndDate)) + '日',
		        ''
		    );
		
		SET @iReturn += '<li>适用期限：'
		
		IF @HtmlType = 'TemplatePreview'
		BEGIN
		    IF @StartDateStr = ''
		       OR @EndDateStr = ''
		    BEGIN
		        SET @iReturn += '<span class="empty">' + @StartDateStr + '&nbsp;至&nbsp;' + @EndDateStr + '</span>';
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<span class="filled">' + @StartDateStr + '&nbsp;至&nbsp;' + @EndDateStr + '</span>';
		    END
		END
		ELSE 
		IF @HtmlType = 'TemplateSummary'
		BEGIN
		    SET @iReturn += '<span class="edit" data-target="Basic">';
		    IF @StartDateStr = ''
		       OR @EndDateStr = ''
		    BEGIN
		        SET @iReturn += '<span class="empty">' + @StartDateStr + '&nbsp;至&nbsp;' + @EndDateStr + '</span>' + @PencilStr;
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<span class="filled">' + @StartDateStr + '&nbsp;至&nbsp;' + @EndDateStr + '</span>' + @PencilStr;
		    END
		    SET @iReturn += '</span>';
		END
		ELSE
		BEGIN
		    SET @iReturn += @StartDateStr + '&nbsp;至&nbsp;' + @EndDateStr;
		END
		
		SET @iReturn += '</li>';
	END
	
	--3 考核周期
	BEGIN
		SET @iReturn += '<li>考核周期：'
		
		IF @HtmlType = 'TemplatePreview'
		BEGIN
		    IF @Period = ''
		    BEGIN
		        SET @iReturn += '<span class="empty">' + @EmptyStr + '</span>';
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<span class="filled">' + @Period + '</span>';
		    END
		END
		ELSE 
		IF @HtmlType = 'TemplateSummary'
		BEGIN
		    SET @iReturn += '<span class="edit" data-target="Basic">';
		    IF @Period = ''
		    BEGIN
		        SET @iReturn += '<span class="empty">' + @EmptyStr + '</span>' + @PencilStr;
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<span class="filled">' + @Period + '</span>' + @PencilStr;
		    END
		    SET @iReturn += '</span>';
		END
		ELSE
		BEGIN
		    SET @iReturn += @Period;
		END
		
		SET @iReturn += '</li>';
	END
	
	--4 适用经销商
	BEGIN
		DECLARE @DealerStr NVARCHAR(2000);
		SET @DealerStr = Promotion.func_Pro_PolicyToHtml_Dealer(@PolicyId)
		
		SET @iReturn += '<li>适用经销商：'
		
		IF @HtmlType = 'TemplatePreview'
		BEGIN
		    IF @DealerStr = ''
		    BEGIN
		        SET @iReturn += '<span class="empty">' + @EmptyStr + '</span>';
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<span class="filled">' + @DealerStr + '</span>';
		    END
		END
		ELSE 
		IF @HtmlType = 'TemplateSummary'
		BEGIN
		    SET @iReturn += '<span class="edit" data-target="Dealer">';
		    IF @DealerStr = ''
		    BEGIN
		        SET @iReturn += '<span class="empty">' + @EmptyStr + '</span>' + @PencilStr;
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<span class="filled">' + @DealerStr + '</span>' + @PencilStr;
		    END
		    SET @iReturn += '</span>';
		END
		ELSE
		BEGIN
		    SET @iReturn += @DealerStr;
		END
		
		SET @iReturn += '</li>';
	END
	
	--5 适用区域
	BEGIN
		DECLARE @AreaStr NVARCHAR(2000);
		SET @AreaStr = Promotion.func_Pro_PolicyToHtml_Factor_Hospital(null, @PolicyId)
		
		SET @iReturn += '<li>适用区域：'
		
		IF @HtmlType = 'TemplatePreview'
		BEGIN
		    IF @AreaStr = ''
		    BEGIN
		        SET @iReturn += '<span class="filled">授权经销商对应医院</span>';
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<span class="filled">' + @AreaStr + '</span>';
		    END
		END
		ELSE 
		IF @HtmlType = 'TemplateSummary'
		BEGIN
		    SET @iReturn += '<span class="edit" data-target="Factor">';
		    IF @AreaStr = ''
		    BEGIN
		        SET @iReturn += '<span class="filled">授权经销商对应医院</span>' + @PencilStr;
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<span class="filled">' + @AreaStr + '</span>' + @PencilStr;
		    END
		    SET @iReturn += '</span>';
		END
		ELSE
		BEGIN
		    IF @AreaStr = ''
		    BEGIN
		    SET @iReturn += '授权经销商对应医院';
		    END
		    ELSE
		    BEGIN
		    SET @iReturn += @AreaStr;
		    END
		END
		
		SET @iReturn += '</li>';
	END
	
	--6 政策方案
	SET @iReturn += '<li>政策方案：';
	SET @iReturn += '<ol style="padding-left: 25px;">';
	
	--6.1 政策规则
	BEGIN
		DECLARE @RuleStr NVARCHAR(2000);
		SET @RuleStr = Promotion.func_Pro_PolicyToHtml_SummaryRule(@PolicyId)
		
		SET @iReturn += '<li>政策规则：'
		
		IF @HtmlType = 'TemplatePreview'
		BEGIN
		    IF @RuleStr = ''
		    BEGIN
		        SET @iReturn += '<span class="empty">' + @EmptyStr + '</span>';
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<div class="filled" style="padding: 5px;">' + @RuleStr;
		    END
		END
		ELSE 
		IF @HtmlType = 'TemplateSummary'
		BEGIN
		    SET @iReturn += '&nbsp;<span class="edit" data-target="Rule"><i class=''fa fa-pencil''></i></span><br />';
		    IF @RuleStr = ''
		    BEGIN
		        SET @iReturn += '<div class="empty edit" style="padding-left: 5px;" data-target="Rule">无</div>';
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<div class="filled edit" style="padding: 5px;" data-target="Rule"><table class="gridtable">' + @RuleStr + '</table></div>';
		    END
		END
		ELSE
		BEGIN
		    SET @iReturn += @RuleStr;
		END
		
		SET @iReturn += '</li>';
	END
	
	--6.2 返利情况
	BEGIN
		DECLARE @RebateStr NVARCHAR(2000);
		IF @Acquisition = 1
		BEGIN
			SET @RebateStr = '使用用积分订购或赠品的产品算达成算返利';
		END
		ELSE
		BEGIN
			SET @RebateStr = '使用用积分订购或赠品的产品不算达成不算返利';
		END
		
		SET @iReturn += '<li>返利情况：'
		
		IF @HtmlType = 'TemplatePreview'
		BEGIN
		    IF @RebateStr = ''
		    BEGIN
		        SET @iReturn += '<span class="empty">' + @EmptyStr + '</span>';
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<span class="filled">' + @RebateStr + '</span>';
		    END
		END
		ELSE 
		IF @HtmlType = 'TemplateSummary'
		BEGIN
		    SET @iReturn += '<span class="edit" data-target="Basic">';
		    IF @RebateStr = ''
		    BEGIN
		        SET @iReturn += '<span class="empty">' + @EmptyStr + '</span>' + @PencilStr;
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<span class="filled">' + @RebateStr + '</span>' + @PencilStr;
		    END
		    SET @iReturn += '</span>';
		END
		ELSE
		BEGIN
		    SET @iReturn += @RebateStr;
		END
		
		SET @iReturn += '</li>';
	END
	
	--6.3 平台奖励
	BEGIN
		SET @iReturn += '<li>平台奖励：平台奖励通过二级经销商传递给出</li>';
	END
	
	--6.4 考核目标
	BEGIN
		DECLARE @TagetStr NVARCHAR(MAX);
		DECLARE @TagetStr1 NVARCHAR(MAX);
		DECLARE @TagetStr3 NVARCHAR(MAX);
		SET @TagetStr1 = Promotion.func_Pro_PolicyToHtml_Appendix1(@PolicyId)
		SET @TagetStr3 = Promotion.func_Pro_PolicyToHtml_Appendix3(@PolicyId)
		SET @TagetStr = @TagetStr1 + CASE WHEN @TagetStr1 = '' THEN '' ELSE '<br />' END + @TagetStr3
		
		SET @iReturn += '<li>考核目标：'
		
		IF @HtmlType = 'TemplatePreview'
		BEGIN
		    IF @TagetStr = ''
		    BEGIN
		        SET @iReturn += '<div class="filled" style="padding-left: 5px;">无</div>';
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<div class="filled" style="padding: 5px;"><table class="gridtable">' + @TagetStr + '</table></div>';
		    END
		END
		ELSE 
		IF @HtmlType = 'TemplateSummary'
		BEGIN
		    SET @iReturn += '&nbsp;<span class="edit" data-target="Factor"><i class=''fa fa-pencil''></i></span><br />';
		    
		    IF @TagetStr = ''
		    BEGIN
		        SET @iReturn += '<div class="filled edit" style="padding-left: 5px;" data-target="Factor">无</div>';
		    END
		    ELSE
		    BEGIN
		        SET @iReturn += '<div class="filled edit" style="padding: 5px;" data-target="Factor"><table class="gridtable">' + @TagetStr + '</table></div>';
		    END
		END
		ELSE
		BEGIN
		    SET @iReturn += '见附录1，附录3';
		END
		
		SET @iReturn += '</li>';
	END
	
	SET @iReturn += '</ol>';
	SET @iReturn += '</li>';
	
	--7 附件
	IF @HtmlType IN ('TemplatePreview', 'TemplateSummary')
	BEGIN
	    DECLARE @AttachmentStr NVARCHAR(2000);
	    DECLARE @HasAttachment BIT;
	    DECLARE @AttachmentName NVARCHAR(200);
	    DECLARE @AttachmentURL NVARCHAR(500);
	    
	    SET @AttachmentStr = '';
	    IF EXISTS(
	           SELECT 1
	           FROM   Promotion.PRO_Attachment
	           WHERE  PAT_PolicyId = @PolicyId
	       )
	    BEGIN
	        SET @HasAttachment = 1;
	    END
	    ELSE
	    BEGIN
	        SET @HasAttachment = 0;
	    END
	    
	    DECLARE @Cur_Attachment CURSOR  ;
	    SET @Cur_Attachment =  CURSOR FOR 
	    SELECT PAT_Name,
	           PAT_Url
	    FROM   Promotion.PRO_Attachment
	    WHERE  PAT_PolicyId = @PolicyId
	    ORDER BY
	           PAT_UploadDate
	    
	    OPEN @Cur_Attachment
	    FETCH NEXT FROM @Cur_Attachment INTO @AttachmentName,@AttachmentURL
	    WHILE @@FETCH_STATUS = 0
	    BEGIN
	        SET @AttachmentStr += '<li>' + @AttachmentName + '</li>';
	        --SET @AttachmentStr += '<li><a href="' + @BaseUrl + 'Pages/Download.aspx?downloadname=' + @AttachmentName + '&filename=' + @AttachmentURL + '&downtype=Promotion">' + @AttachmentName + 
	        --    '</a></li>';
	        
	        FETCH NEXT FROM @Cur_Attachment INTO @AttachmentName,@AttachmentURL
	    END
	    CLOSE @Cur_Attachment
	    DEALLOCATE @Cur_Attachment ;
	    
	    SET @iReturn += '<li>附件：'
	    
	    IF @HtmlType = 'TemplatePreview'
	    BEGIN
	        IF @HasAttachment = 0
	        BEGIN
	            SET @iReturn += '<div class="filled" style="padding-left: 5px;">无</div>';
	        END
	        ELSE
	        BEGIN
	            SET @iReturn += '<div class="filled" style="padding: 5px;"><ol style="padding-left: 25px;">' + @AttachmentStr + '</ol></div>';
	        END
	    END
	    ELSE 
	    IF @HtmlType = 'TemplateSummary'
	    BEGIN
	        SET @iReturn += '&nbsp;<span class="edit" data-target="Attachment"><i class=''fa fa-pencil''></i></span>';
	        
	        IF @HasAttachment = 0
	        BEGIN
	            SET @iReturn += '<div class="filled edit" style="padding-left: 5px;" data-target="Attachment">无</div>';
	        END
	        ELSE
	        BEGIN
	            SET @iReturn += '<div class="filled edit" data-target="Attachment"><ol style="padding-left: 25px;">' + @AttachmentStr + '</ol></div>';
	        END
	    END
	    
	    SET @iReturn += '</li>';
	END
	
	SET @iReturn += '</ol>';
	
	RETURN @iReturn
END
GO