DROP FUNCTION [Promotion].[func_Pro_ProlicyClosingGetWFCode]
GO


/**********************************************
 ����:��ȡ��ǰ����E-workflow��������
 ���ߣ�Grapecity
 ������ʱ�䣺 2016-10-23
 ���¼�¼˵����
 1.���� 2016-10-23
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_ProlicyClosingGetWFCode](
	@PolicyId INT,@DealerId UNIQUEIDENTIFIER,@runPeriod NVARCHAR(50)
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX);
	IF EXISTS (SELECT * FROM DealerMaster A WHERE A.DMA_ID=@DealerId AND A.DMA_DealerType IN('T2','T1'))
	BEGIN
		SELECT @iReturn=A.WFCode
		FROM Promotion.T_Pro_Flow A 
		INNER JOIN Promotion.T_Pro_Flow_Detail B ON A.FlowId=B.FlowId
		WHERE B.PolicyId=@PolicyId AND B.DealerId=@DealerId AND A.AccountMonth=@runPeriod 
		AND A.Status='����ͨ��';
	END
	ELSE
	BEGIN
		--SELECT @iReturn=A.WFCode
		--FROM Promotion.T_Pro_Flow A 
		--INNER JOIN Promotion.T_Pro_Flow_Detail B ON A.FlowId=B.FlowId
		--INNER JOIN DealerMaster C ON C.DMA_ID=B.DealerId
		--WHERE B.PolicyId=@PolicyId AND C.DMA_Parent_DMA_ID=@DealerId AND A.AccountMonth=@runPeriod 
		--AND A.Status='����ͨ��';
		
		SELECT @iReturn=STUFF(REPLACE(REPLACE((
						SELECT DISTINCT A.WFCode RESULT
						FROM Promotion.T_Pro_Flow A 
						INNER JOIN Promotion.T_Pro_Flow_Detail B ON A.FlowId=B.FlowId
						INNER JOIN DealerMaster C ON C.DMA_ID=B.DealerId
						WHERE B.PolicyId=@PolicyId AND C.DMA_Parent_DMA_ID=@DealerId AND A.AccountMonth=@runPeriod 
						AND A.Status='����ͨ��'
						FOR XML AUTO
					), '<A RESULT="', ','), '"/>', ''), 1, 1, '')
	END

	
	RETURN @iReturn
END


GO


