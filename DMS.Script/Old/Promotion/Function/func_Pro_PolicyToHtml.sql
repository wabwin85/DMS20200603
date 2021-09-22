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
	    
	    --���߸�Ҫ*******************************************************************************************
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
	                                WHEN '' THEN '��'
	                                WHEN 'Policy' THEN '�ⶥ' + CONVERT(NVARCHAR, CONVERT(DECIMAL(10, 2), A.TopValue))
	                                ELSE '�μ�:��¼2'
	                           END,
	           @PolicyGroupName = ISNULL(A.PolicyGroupName, ''),
	           @Period = ISNULL(
	               CASE 
	                    WHEN ISNULL(A.PolicyStyle, '') = '��ʱ����' THEN ''
	                    ELSE A.Period
	               END,
	               ''
	           ),
	           @StartDate = CONVERT(DATETIME, A.StartDate + '01'),
	           @EndDate = DATEADD(MONTH, 1, CONVERT(DATETIME, A.EndDate + '01')) -1,
	           @PointValidDateType = ISNULL(A.PointValidDateType, ''),
	           @PointValidDateDuration = CASE 
	                                          WHEN A.PointValidDateDuration IS NOT NULL THEN CONVERT(NVARCHAR, A.PointValidDateDuration) + '����'
	                                          ELSE ''
	                                     END,
	           @PointValidDateAbsolute = CASE 
	                                          WHEN A.PointValidDateAbsolute IS NOT NULL THEN CONVERT(NVARCHAR(10), A.PointValidDateAbsolute, 121)
	                                          ELSE ''
	                                     END,
	           @PointValidDateType2 = ISNULL(A.PointValidDateType2, ''),
	           @PointValidDateDuration2 = CASE 
	                                           WHEN A.PointValidDateDuration2 IS NOT NULL THEN CONVERT(NVARCHAR, A.PointValidDateDuration2) + '����'
	                                           ELSE ''
	                                      END,
	           @PointValidDateAbsolute2 = CASE 
	                                           WHEN A.PointValidDateAbsolute2 IS NOT NULL THEN CONVERT(NVARCHAR(10), A.PointValidDateAbsolute2, 121)
	                                           ELSE ''
	                                      END,
	           @PointUseRange2 = ISNULL(A.PointUseRange, ''),
	           @OtherMemo = CASE ISNULL(A.ifAddLastLeft, '')
	                             WHEN 'Y' THEN '�����������뱾�ڿ���'
	                             ELSE '�����������ۼƼ���(' + CASE ISNULL(A.CarryType, '')
	                                                               WHEN 'Round' THEN '��������'
	                                                               WHEN 'Ceiling' THEN '����ȡ��'
	                                                               WHEN 'Floor' THEN '����ȡ��'
	                                                               WHEN 'KeepValue' THEN '����ԭֵ'
	                                                               ELSE ''
	                                                          END + ')'
	                        END + '��'
	           + CASE ISNULL(A.ifMinusLastGift, '')
	                  WHEN 'Y' THEN '���ڿ������п۳�������Ʒ'
	                  ELSE '��Ʒ���ӿ������п۳�'
	             END 
	           + CASE ISNULL(A.ifConvert, '')
	                  WHEN 'Y' THEN '����ƷתΪ����'
	                  ELSE ''
	             END
	           + CASE ISNULL(A.ifCalRebateAR, '')
	                  WHEN 'Money' THEN '��������㷵��'
	                  WHEN 'Point' THEN '��������ɲ��㷵��'
	                  ELSE ''
	             END 
	           + CASE ISNULL(A.ifCalPurchaseAR, '')
	                  WHEN 'Y' THEN '�����ͼ�����ҵ�ɹ����'
	                  ELSE '�����Ͳ�������ҵ�ɹ����'
	             END,
	           @YTDOption = CASE ISNULL(A.YTDOption, 'N')
	                             WHEN 'N' THEN ''
	                             WHEN 'YTD' THEN '�������ָ�꿪ʼ����(���ָ�������ڵ�һ����)'
	                             WHEN 'YTDRTN' THEN '���㵱ǰ����ָ�꼴����������YTDָ�겹��ʷ����'
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
	            CONVERT(NVARCHAR(4), DATEPART(YEAR, @StartDate)) + '��' + CONVERT(NVARCHAR(2), DATEPART(MONTH, @StartDate)) + '��' + CONVERT(NVARCHAR(2), DATEPART(DAY, @StartDate)) + '��',
	            ''
	        );
	    SET @EndDateStr = ISNULL(
	            CONVERT(NVARCHAR(4), DATEPART(YEAR, @EndDate)) + '��' + CONVERT(NVARCHAR(2), DATEPART(MONTH, @EndDate)) + '��' + CONVERT(NVARCHAR(2), DATEPART(DAY, @EndDate)) + '��',
	            ''
	        );
	    
	    SET @OtherMemo = ISNULL(@OtherMemo, '') + CASE ISNULL(@OtherMemo, '')
	                                                   WHEN '' THEN ''
	                                                   ELSE '��<br/>'
	                                              END + @YTDOption
	    
	    SET @OtherMemo = CASE 
	                          WHEN ISNULL(@PolicyStyle, '') = '��ʱ����' THEN ''
	                          ELSE ISNULL(@OtherMemo, '')
	                     END
	    
	    SELECT @BaseUrl = VALUE1
	    FROM   Lafite_DICT
	    WHERE  DICT_TYPE = 'CONST_CONTRACT_ContractBaseUrl'
	           AND DICT_KEY = 'BaseUrl'
	    
	    SET @iReturn += '<h2 style="text-align: center;"><b>' + @PolicyName + '</b></h2>';
	    
	    --���߸�Ҫ************************************************************************************************
	    SET @iReturn += '<h4><font color="#FF0000">���߸�Ҫ</font></h4>';
	    SET @iReturn += '<div class="des"><div style="padding: 5px;">';
	    SET @iReturn += Promotion.func_Pro_PolicyToHtml_Summary(@PolicyId, 'EkpInfo');	
	    SET @iReturn += '</div></div>';
	    
	    --����************************************************************************************************
	    SET @iReturn += '<h4>����</h4>'
	    SET @iReturn += '<table class="gridtable">'
	    SET @iReturn += '<tr><th>���߱��</th><td>' + @PolicyNo + '</td></tr>'
	    SET @iReturn += '<tr><th>������ʽ</th><td>' + @PolicyType + '</td></tr>'
	    SET @iReturn += '<tr><th>���߷���</th><td>' + @PolicyStyle + '</td></tr>'
	    SET @iReturn += '<tr><th>��������</th><td>' + @PolicySubStyle + '</td></tr>'
	    SET @iReturn += '<tr><th>����</th><td>' + @Bu + '</td></tr>'
	    SET @iReturn += '<tr><th>�ⶥֵ</th><td>' + @TopValueDesc + '</td></tr>'
	    SET @iReturn += '<tr><th>��������</th><td>' + @PolicyName + '</td></tr>'
	    SET @iReturn += '<tr><th>��������</th><td>' + @PolicyGroupName + '</td></tr>'
	    SET @iReturn += '<tr><th>��������</th><td>' + @Period + '</td></tr>'
	    SET @iReturn += '<tr><th>��������</th><td>' + @StartDateStr + '&nbsp;��&nbsp;' + @EndDateStr + '</td></tr>'
	    IF @PolicySubStyle IN ('������Ʒת����', '�����͹̶�����', '���ٷֱȻ���')
	    BEGIN
	        SET @PointSummary = '�����̻��֣�' + CASE @PointValidDateType
	                                                  WHEN 'Always' THEN '����ʼ����Ч��'
	                                                  WHEN 'AbsoluteDate' THEN '����ʹ����Ч����' + @PointValidDateAbsolute + '��'
	                                                  WHEN 'AccountMonth' THEN '�����ڽ�����' + @PointValidDateDuration + '��ʹ�ã�'
	                                                  ELSE ''
	                                             END
	            + 'ʹ�÷�Χ��' + @PointUseRange + '��'
	        
	        SET @PointSummary += 'ƽ̨���֣�' + CASE @PointValidDateType2
	                                                 WHEN 'Always' THEN '����ʼ����Ч��'
	                                                 WHEN 'AbsoluteDate' THEN '����ʹ����Ч����' + @PointValidDateAbsolute2 + '��'
	                                                 WHEN 'AccountMonth' THEN '�����ڽ�����' + @PointValidDateDuration2 + '��ʹ�ã�'
	                                                 ELSE ''
	                                            END
	            + 'ʹ�÷�Χ��' + CASE @PointUseRange2
	                                  WHEN 'BU' THEN '��BU���в�Ʒ'
	                                  ELSE '�뾭���̻���ʹ�÷�Χһ��'
	                             END + '��'
	        
	        IF NOT EXISTS (
	               SELECT 1
	               FROM   Promotion.PRO_POLICY_POINTRATIO
	               WHERE  PolicyId = @PolicyId
	           )
	        BEGIN
	            SET @RatioSummary = 'ʹ��ƽ̨ͳһ�Ӽ���'
	        END
	        ELSE
	        BEGIN
	            SET @RatioSummary = '�μ�:��¼4�������ϸ�¼�������ʹ��ƽ̨ͳһ�Ӽ��ʡ�'
	        END
	        
	        SET @iReturn += '<tr><th>����˵��</th><td>' + @PointSummary + '</td></tr>'
	        SET @iReturn += '<tr><th>�Ӽ���˵��</th><td>' + @RatioSummary + '</td></tr>'
	    END
	    
	    SET @iReturn += '<tr><th>��������</th><td>��</td></tr>'
	    SET @iReturn += '<tr><th>����˵��</th><td>' + @OtherMemo + '</td></tr>'
	    SET @iReturn += '<tr><th>�����ϴ�</th><td><a target="_blank"  href="' + @BaseUrl + 'API.aspx?PageId=60&InstanceID=' + @PolicyNo + '">�ϴ�����</a></td></tr>'
	    SET @iReturn += '</table>'
	    
	    --������Ϣ************************************************************************************************
	    IF EXISTS(
	           SELECT 1
	           FROM   Promotion.PRO_Attachment
	           WHERE  PAT_PolicyId = @PolicyId
	       )
	    BEGIN
	        DECLARE @AttachmentName NVARCHAR(200);
	        DECLARE @AttachmentURL NVARCHAR(500);
	        DECLARE @Nber NVARCHAR(10);
	        SET @iReturn += '<h4>����</h4><table class="gridtable">'
	        
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
	            SET @iReturn += '<tr><th>����' + @Nber + '</th><td><a href="' + @BaseUrl + 'Pages/Download.aspx?downloadname=' + @AttachmentName + '&filename=' + @AttachmentURL + 
	                '&downtype=Promotion">' + @AttachmentName + '</a></td></tr>'
	            
	            FETCH NEXT FROM @PRODUCT_CUR INTO @AttachmentName,@AttachmentURL,@Nber
	        END
	        CLOSE @PRODUCT_CUR
	        DEALLOCATE @PRODUCT_CUR ;
	        SET @iReturn += '</table>'
	    END
	    
	    --���÷�Χ************************************************************************************************
	    SET @iReturn += '<h4>���÷�Χ</h4><table class="gridtable">'
	    SET @iReturn += '<tr><th>������</th><td>' + Promotion.func_Pro_PolicyToHtml_Dealer(@PolicyId) + '</td></tr></table>'
	    
	    --�漰����************************************************************************************************
	    SET @iReturn += '<h4>�漰����</h4><table class="gridtable">'
	    
	    IF EXISTS(
	           SELECT 1
	           FROM   Promotion.PRO_POLICY_FACTOR
	           WHERE  PolicyId = @PolicyId
	       )
	    BEGIN
	        DECLARE @iCURSOR_Factor CURSOR ;
	        SET @iCURSOR_Factor =  CURSOR FOR 
	        SELECT A.PolicyFactorId,
	               B.FactName + '[���' + CONVERT(NVARCHAR, A.PolicyFactorId) + ']' FactName
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
	    
	    --��������************************************************************************************************
	    IF EXISTS (
	           SELECT 1
	           FROM   Promotion.PRO_POLICY_RULE
	           WHERE  PolicyId = @PolicyId
	       )
	    BEGIN
	        DECLARE @RuleCondition NVARCHAR(MAX);
	        DECLARE @RuleResult NVARCHAR(MAX);
	        DECLARE @RuleDesc NVARCHAR(MAX);
	        
	        SET @iReturn += '<h4>��������</h4><table class="gridtable">'
	        
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
	                SET @RuleResult = ISNULL(@RuleResult, '') + '</br> ������' + @RuleDesc + '';
	            END
	            
	            SET @iReturn += '<tr><th>' + @RuleCondition + '</th><td>' + @RuleResult + '</td></tr>'
	            
	            FETCH NEXT FROM @iCURSOR_Rule INTO @RuleCondition,@RuleResult,@RuleDesc
	        END 
	        CLOSE @iCURSOR_Rule
	        DEALLOCATE @iCURSOR_Rule
	        SET @iReturn += '</table>'
	    END
	    
	    --��¼1(ָ����ƷҽԺֲ��ָ��)*****************************************************************************
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
	        SET @iReturn += '<h4>��¼1</h4><table class="gridtable">'
	        SET @iReturn += Promotion.func_Pro_PolicyToHtml_Appendix1(@PolicyId)
	        SET @iReturn += '</table>'
	    END
	    
	    --��¼2(�ⶥֵ)*********************************************************************************************
	    IF ISNULL(@TopType, '') IN ('Dealer', 'Hospital', 'DealerPeriod', 'HospitalPeriod')
	    BEGIN
	        SET @iReturn += '<h4>��¼2</h4><table class="gridtable">'
	        SET @iReturn += Promotion.func_Pro_PolicyToHtml_Appendix2(@PolicyId)
	        SET @iReturn += '</table>'
	    END
	    
	    --��¼3(ָ����Ʒ�����̲ɹ�ָ��)******************************************************************************
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
	        SET @iReturn += '<h4>��¼3</h4><table class="gridtable">'
	        SET @iReturn += Promotion.func_Pro_PolicyToHtml_Appendix3(@PolicyId)
	        SET @iReturn += '</table>'
	    END
	    
	    --��¼4(�Ӽ���)******************************************************************************
	    IF EXISTS (
	           SELECT *
	           FROM   Promotion.PRO_POLICY_POINTRATIO
	           WHERE  PolicyId = @PolicyId
	       )
	    BEGIN
	        SET @iReturn += '<h4>��¼4</h4><table class="gridtable">'
	        SET @iReturn += Promotion.func_Pro_PolicyToHtml_Appendix4(@PolicyId)
	        SET @iReturn += '</table>'
	    END
	    
	    --��¼5(�����̶̹����ֱ�)******************************************************************
	    IF EXISTS (
	           SELECT *
	           FROM   Promotion.Pro_Dealer_Std_Point
	           WHERE  PolicyId = @PolicyId
	       )
	    BEGIN
	        SET @iReturn += '<h4>��¼5</h4><table class="gridtable">'
	        SET @iReturn += Promotion.func_Pro_PolicyToHtml_Appendix5(@PolicyId)
	        SET @iReturn += '</table>'
	    END
	END
	
	SET @iReturn += '</div>'
	RETURN @iReturn
END
GO