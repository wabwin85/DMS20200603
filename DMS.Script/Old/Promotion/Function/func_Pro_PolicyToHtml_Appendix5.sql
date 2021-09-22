DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Appendix5]
GO


/**********************************************
 ����:����PolicyId,ȡ�ø�¼5��HTML(�����̶̹�����)
 ���ߣ�Grapecity
 ������ʱ�䣺 2015-08-28
 ���¼�¼˵����
 1.���� 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Appendix5](
	@PolicyId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX);
	
	DECLARE @DEALERNAME NVARCHAR(200)
	DECLARE @POINTS NVARCHAR(200)
	
	SET @iReturn = ''
	
	--д��ͷ
	SET @iReturn +='<tr><th style="text-align: center;">������</th><th style="text-align: center;">�̶�����</th></tr>'
	
	--д����
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT B.DMA_ChineseName+'('+ISNULL(B.DMA_SAP_Code,'')+')' DEALERNAME,
			CONVERT(NVARCHAR,A.Points) Points
			FROM Promotion.Pro_Dealer_Std_Point a,dbo.DealerMaster B 
			WHERE a.DealerId = B.DMA_ID AND policyId = @PolicyId
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @DEALERNAME,@POINTS
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @iReturn +='<tr>'
		SET @iReturn +='<td>'+@DEALERNAME+'</td>' 
		SET @iReturn +='<td style="text-align: right;">'+@POINTS+'</td>' 
		SET @iReturn +='</tr>'
		FETCH NEXT FROM @iCURSOR INTO @DEALERNAME,@POINTS
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
	RETURN @iReturn
END


GO


