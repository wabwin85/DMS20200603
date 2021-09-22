DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Dealer]
GO



/**********************************************
 功能:传入PolicyId,取得经销商HTML
 作者：Grapecity
 最后更新时间： 2015-08-28
 更新记录说明：
 1.创建 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Dealer](
	@PolicyId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iBuSubBU NVARCHAR(20);
	DECLARE @iInclude NVARCHAR(MAX);
	DECLARE @iExclude NVARCHAR(MAX);
	DECLARE @iReturn NVARCHAR(MAX);
	
	SET @iReturn = ''
	
	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY WHERE PolicyId = @PolicyId AND CalType = 'ByHospital')
	BEGIN
		SET @iReturn += '授权医院对应经销商'
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT * FROM Promotion.PRO_DEALER WHERE PolicyId = @PolicyId AND WithType = 'ByAuth' AND OperType='包含')
		BEGIN
			SELECT @iBuSubBU = BU+CASE ISNULL(SUBBU,'') WHEN '' THEN '' ELSE '-'+(SELECT CC_NameCN FROM interface.ClassificationContract WHERE CC_Code=SUBBU) END 
				FROM Promotion.PRO_POLICY WHERE PolicyId = @PolicyId
			SET @iReturn += @iBuSubBU +'的授权经销商'
		END
	
		SET @iInclude = STUFF(REPLACE(REPLACE(
			(
				SELECT DISTINCT A.DMA_SAP_Code+A.DMA_ChineseName  AS DMA_ChineseName FROM dbo.DealerMaster A,Promotion.PRO_DEALER B 
				WHERE A.DMA_ID = B.DEALERID AND B.WithType = 'ByDealer' AND B.OperType = '包含' AND B.PolicyId = @PolicyId 
				FOR XML AUTO
			), '<A DMA_ChineseName="', '，'), '"/>', ''), 1, 1, '')
			
		IF ISNULL(@iInclude,'') <> ''
			SET @iReturn += CASE @iReturn WHEN '' THEN '' ELSE '，' END + @iInclude
		
		SET @iExclude = STUFF(REPLACE(REPLACE(
			(
				SELECT DISTINCT A.DMA_SAP_Code+A.DMA_ChineseName AS DMA_ChineseName FROM dbo.DealerMaster A,Promotion.PRO_DEALER B 
				WHERE A.DMA_ID = B.DEALERID AND B.WithType = 'ByDealer' AND B.OperType = '不包含' AND B.PolicyId = @PolicyId 
				FOR XML AUTO
			), '<A DMA_ChineseName="', '，'), '"/>', ''), 1, 1, '')
		
		IF ISNULL(@iExclude,'') <> ''
			SET @iReturn += '，(不包含：'+ @iExclude +')'
	END
	
	RETURN @iReturn
END



GO


