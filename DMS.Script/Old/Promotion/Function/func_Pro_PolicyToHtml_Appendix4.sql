DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Appendix4]
GO

CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Appendix4](
	@PolicyId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX);
	
	DECLARE @ACCOUNTMONTH NVARCHAR(200)
	DECLARE @DEALERTYPE NVARCHAR(200)
	DECLARE @DEALERNAME NVARCHAR(200)
	DECLARE @RATIO NVARCHAR(200)
	
	SET @iReturn = ''
	
	--写表头
	SET @iReturn +='<tr><th style="text-align: center;">帐期</th><th style="text-align: center;">经销类型</th><th style="text-align: center;">经销商或平台</th><th style="text-align: center;">加价率</th></tr>'
	
	--写数据
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT CASE ISNULL(A.ACCOUNTMONTH,'') WHEN '' THEN '所有帐期' ELSE A.ACCOUNTMONTH END ACCOUNTMONTH,
			B.DMA_DealerType DealerType,B.DMA_ChineseName+'('+ISNULL(B.DMA_SAP_Code,'')+')' DEALERNAME,
			CONVERT(NVARCHAR,A.RATIO) RATIO
			FROM Promotion.PRO_POLICY_POINTRATIO A,dbo.DealerMaster B
			WHERE A.DEALERID = B.DMA_ID AND A.POLICYID = @PolicyId
			ORDER BY B.DMA_SAP_Code,A.ACCOUNTMONTH
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @ACCOUNTMONTH,@DEALERTYPE,@DEALERNAME,@RATIO
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @iReturn +='<tr>'
		SET @iReturn +='<td>'+@ACCOUNTMONTH+'</td>' 
		SET @iReturn +='<td>'+@DEALERTYPE+'</td>' 
		SET @iReturn +='<td>'+@DEALERNAME+'</td>' 
		SET @iReturn +='<td style="text-align: right;">'+@RATIO+'</td>'  
		SET @iReturn +='</tr>'
		FETCH NEXT FROM @iCURSOR INTO @ACCOUNTMONTH,@DEALERTYPE,@DEALERNAME,@RATIO
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
	RETURN @iReturn
END


GO


