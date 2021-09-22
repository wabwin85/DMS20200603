DROP FUNCTION [dbo].[GC_FN_GetDealerAuthProductSub]
GO


/**********************************************
 ����:��ȡ��������Ȩ��Ʒ����
 ���ߣ�Grapecity
 ������ʱ�䣺 2016-12-23
 ���¼�¼˵����
 1.���� 2016-12-23
**********************************************/
CREATE FUNCTION [dbo].[GC_FN_GetDealerAuthProductSub]( @DealerId UNIQUEIDENTIFIER
	)
RETURNS @temp TABLE
	(
		DealerId UNIQUEIDENTIFIER,
		ProductLineId UNIQUEIDENTIFIER,
		ProducPctId UNIQUEIDENTIFIER,
		ProductBeginDate DATETIME,
		ProductEndDate DATETIME,
		ActiveFlag int
	)
AS
BEGIN
	INSERT INTO @temp (DealerId,ProductLineId,ProducPctId,ProductBeginDate,ProductEndDate,ActiveFlag)
	SELECT a.DAT_DMA_ID,a.DAT_ProductLine_BUM_ID,a.DAT_PMA_ID,a.DAT_StartDate,a.DAT_EndDate,
	CASE WHEN GETDATE() BETWEEN a.DAT_StartDate and a.DAT_EndDate THEN 1 ELSE 0 END
	FROM DealerAuthorizationTable A
	WHERE a.DAT_DMA_ID=@DealerId
	AND  A.DAT_ProductLine_BUM_ID<>A.DAT_PMA_ID
	UNION
	SELECT a.DAT_DMA_ID,a.DAT_ProductLine_BUM_ID,B.PCT_ID,a.DAT_StartDate,a.DAT_EndDate,
	CASE WHEN GETDATE() BETWEEN a.DAT_StartDate and a.DAT_EndDate THEN 1 ELSE 0 END
	FROM DealerAuthorizationTable A
	INNER JOIN PartsClassification B ON B.PCT_ParentClassification_PCT_ID=A.DAT_PMA_ID AND B.PCT_ProductLine_BUM_ID=A.DAT_ProductLine_BUM_ID
	WHERE a.DAT_DMA_ID=@DealerId
	AND  A.DAT_ProductLine_BUM_ID<>A.DAT_PMA_ID
	UNION
	SELECT a.DAT_DMA_ID,A.DAT_ProductLine_BUM_ID,B.CA_ID,a.DAT_StartDate,a.DAT_EndDate,
	CASE WHEN GETDATE() BETWEEN a.DAT_StartDate and a.DAT_EndDate THEN 1 ELSE 0 END
	FROM DealerAuthorizationTable A,(SELECT DISTINCT CA_ID,CC_ProductLineID FROM V_ProductClassificationStructure WHERE ActiveFlag=1) B
	WHERE a.DAT_DMA_ID=@DealerId
	AND  A.DAT_ProductLine_BUM_ID=A.DAT_PMA_ID
	AND B.CC_ProductLineID=A.DAT_ProductLine_BUM_ID
	
	UNION
	SELECT a.DAT_DMA_ID,A.DAT_ProductLine_BUM_ID,c.PCT_ID,a.DAT_StartDate,a.DAT_EndDate,
	CASE WHEN GETDATE() BETWEEN a.DAT_StartDate and a.DAT_EndDate THEN 1 ELSE 0 END
	FROM DealerAuthorizationTable A,
	(SELECT DISTINCT CA_ID,CC_ProductLineID FROM V_ProductClassificationStructure WHERE ActiveFlag=1) B,PartsClassification C
	WHERE a.DAT_DMA_ID=@DealerId
	AND  A.DAT_ProductLine_BUM_ID=A.DAT_PMA_ID
	AND B.CC_ProductLineID=A.DAT_ProductLine_BUM_ID
	AND C.PCT_ParentClassification_PCT_ID IS NOT NULL 
	AND C.PCT_ProductLine_BUM_ID=B.CC_ProductLineID 
	and c.PCT_ParentClassification_PCT_ID=b.CA_ID
	
	
	RETURN
END


GO


