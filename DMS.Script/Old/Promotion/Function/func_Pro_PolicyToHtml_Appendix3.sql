DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Appendix3]
GO



/**********************************************
 ����:����PolicyId,ȡ�ø�¼3��HTML(ָ����Ʒ�����̲ɹ�ָ��)
 ���ߣ�Grapecity
 ������ʱ�䣺 2015-08-28
 ���¼�¼˵����
 1.���� 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Appendix3]
(
	@PolicyId INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX);
	DECLARE @Period NVARCHAR(10);
	DECLARE @PolicyFactorId INT;
	DECLARE @TargetLevelCount INT;
	DECLARE @TargetLevelStart INT;
	DECLARE @TargetValue NVARCHAR(50);
	
	DECLARE @MinPeriod NVARCHAR(10);
	DECLARE @MaxPeriod NVARCHAR(10);
	DECLARE @runPeriod NVARCHAR(10);
	
	DECLARE @DealerId UNIQUEIDENTIFIER
	DECLARE @DealerName NVARCHAR(100)
	
	SET @iReturn = ''
	
	IF EXISTS (
	       SELECT 1
	       FROM   Promotion.Pro_Dealer_PrdPurchase_Taget A
	              LEFT JOIN dbo.DealerMaster B
	                   ON  A.DealerId = B.DMA_ID
	       WHERE  PolicyFactorId = @PolicyFactorId
	   )
	BEGIN
	    --ֻȡ��1��PolicyFactorId��Ŀǰ��Ϊ1��������ֻ����1����¼1
	    SELECT TOP 1 
	           @PolicyFactorId = b.PolicyFactorId,
	           @Period = a.Period
	    FROM   Promotion.PRO_POLICY a,
	           Promotion.PRO_POLICY_factor b,
	           Promotion.Pro_Dealer_PrdPurchase_Taget c
	    WHERE  a.PolicyId = b.PolicyId
	           AND b.PolicyFactorId = c.PolicyFactorId
	           AND a.PolicyId = @PolicyId
	    
	    --��á�Ŀ��ֵ���ĸ���
	    SELECT @TargetLevelCount = COUNT(DISTINCT A.TargetLevel),
	           @MinPeriod = MIN(Period),
	           @MaxPeriod = MAX(Period)
	    FROM   Promotion.Pro_Dealer_PrdPurchase_Taget A
	    WHERE  PolicyFactorId = @PolicyFactorId
	    
	    SET @runPeriod = @MinPeriod
	    
	    --д��ͷ(��һ�У�������)
	    SET @iReturn += '<tr><th rowspan=2 style="text-align: center;">������</th>'
	    --д��ͷ(��һ�У��ڼ�)
	    WHILE @runPeriod <= @MaxPeriod
	    BEGIN
	        SET @iReturn += '<th colspan=' + CONVERT(NVARCHAR, @TargetLevelCount) + ' style="text-align: center;">' + @runPeriod + '</th>'
	        SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period, 'NEXT', @runPeriod)
	    END
	    SET @iReturn += '</tr>'
	    
	    --д��ͷ(�ڶ��У�Ŀ��ֵ)
	    SET @iReturn += '<tr>'
	    SET @runPeriod = @MinPeriod
	    WHILE @runPeriod <= @MaxPeriod
	    BEGIN
	        SET @iReturn += CASE 
	                             WHEN @TargetLevelCount >= 1 THEN '<th style="text-align: center;">Ŀ��1</th>'
	                             ELSE ''
	                        END
	            + CASE 
	                   WHEN @TargetLevelCount >= 2 THEN '<th style="text-align: center;">Ŀ��2</th>'
	                   ELSE ''
	              END
	            + CASE 
	                   WHEN @TargetLevelCount >= 3 THEN '<th style="text-align: center;">Ŀ��3</th>'
	                   ELSE ''
	              END
	            + CASE 
	                   WHEN @TargetLevelCount >= 4 THEN '<th style="text-align: center;">Ŀ��4</th>'
	                   ELSE ''
	              END
	            + CASE 
	                   WHEN @TargetLevelCount >= 5 THEN '<th style="text-align: center;">Ŀ��5</th>'
	                   ELSE ''
	              END
	        
	        SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period, 'NEXT', @runPeriod)
	    END
	    SET @iReturn += '</tr>'
	    
	    --д����
	    DECLARE @iCURSOR CURSOR ;
	    SET @iCURSOR =  CURSOR FOR 
	    SELECT DISTINCT DealerId,
	           ISNULL(B.DMA_ChineseName, 'δ֪������') DealerName
	    FROM   Promotion.Pro_Dealer_PrdPurchase_Taget A
	           LEFT JOIN dbo.DealerMaster B
	                ON  A.DealerId = B.DMA_ID
	    WHERE  PolicyFactorId = @PolicyFactorId
	    ORDER BY
	           DealerId
	    
	    OPEN @iCURSOR 
	    FETCH NEXT FROM @iCURSOR INTO @DealerId,@DealerName
	    WHILE @@FETCH_STATUS = 0
	    BEGIN
	        SET @iReturn += '<tr>'
	        SET @iReturn += '<td>' + @DealerName + '</td>' 
	        
	        SET @runPeriod = @MinPeriod
	        WHILE @runPeriod <= @MaxPeriod
	        BEGIN
	            SET @TargetLevelStart = 1
	            WHILE @TargetLevelStart <= @TargetLevelCount
	            BEGIN
	                SET @TargetValue = ''
	                
	                SELECT @TargetValue = CONVERT(NVARCHAR, CONVERT(DECIMAL(14, 2), TargetValue))
	                FROM   Promotion.Pro_Dealer_PrdPurchase_Taget
	                WHERE  PolicyFactorId = @PolicyFactorId
	                       AND DealerId = @DealerId
	                       AND Period = @runPeriod
	                       AND TargetLevel = 'Ŀ��' + CONVERT(NVARCHAR, @TargetLevelStart)
	                
	                SET @iReturn += '<td style="text-align: right;">' + ISNULL(@TargetValue, '') + '</td>' 
	                
	                SET @TargetLevelStart += 1
	            END
	            SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period, 'NEXT', @runPeriod)
	        END
	        
	        SET @iReturn += '</tr>'
	        FETCH NEXT FROM @iCURSOR INTO @DealerId,@DealerName
	    END 
	    CLOSE @iCURSOR
	    DEALLOCATE @iCURSOR
	END
	
	RETURN @iReturn
END
GO