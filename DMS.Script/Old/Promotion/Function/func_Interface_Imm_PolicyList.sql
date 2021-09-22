DROP FUNCTION [Promotion].[func_Interface_Imm_PolicyList]
GO



/**********************************************
 功能:取得经销商当前在即时订单中可以选到的政策
 作者：Grapecity
 最后更新时间： 2015-08-28
 更新记录说明：
 1.创建 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Interface_Imm_PolicyList](
	@DealerId UNIQUEIDENTIFIER,
	@ProductLineId UNIQUEIDENTIFIER
	)
RETURNS @temp TABLE 
(
	PolicyId INT,
	PolicyNo NVARCHAR(50),
	PolicyName NVARCHAR(100),
	PolicySubStyle NVARCHAR(100)	--满额送赠品、满额打折
)
	WITH
	EXECUTE AS CALLER
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @BU NVARCHAR(20)
	DECLARE @SubBU NVARCHAR(20)
	
	DECLARE @TMP_POLICY TABLE
	(
		POLICYID INT
	)
	
	DECLARE @TMP_DEALER TABLE
	(
		POLICYID INT,
		DealerId UNIQUEIDENTIFIER,
		DealerName NVARCHAR(100)
	)
	
	--取得当前有效的即时买赠政策
	INSERT INTO @TMP_POLICY(POLICYID)
	SELECT POLICYID FROM Promotion.PRO_POLICY,V_DivisionProductLineRelation WHERE PolicyStyle = '即时买赠' 
	AND Status = '有效' AND CONVERT(NVARCHAR(6),GETDATE(),112) BETWEEN StartDate AND EndDate
	AND BU = DivisionName
	AND ProductLineID = @ProductLineId
	AND PolicyId=1139
	
	--取得政策涉及的经销商清单
	--单个指定的包含经销商
	INSERT INTO @TMP_DEALER(PolicyId,DealerId,DealerName)
	SELECT C.PolicyId,A.DMA_ID,A.DMA_ChineseName FROM dbo.DealerMaster A,Promotion.PRO_DEALER B,@TMP_POLICY C
		WHERE A.DMA_ID = B.DEALERID AND B.OperType = '包含' AND B.PolicyId = C.PolicyId
			AND A.DMA_ID = @DealerId
	
	--包含的授权经销商
	INSERT INTO @TMP_DEALER(PolicyId,DealerId,DealerName)
	SELECT DISTINCT G.PolicyId,A.DMA_ID,A.DMA_ChineseName 
	FROM dbo.DealerMaster A,Promotion.PRO_DEALER B ,V_DealerContractMaster C,
	INTERFACE.ClassificationContract D,V_DivisionProductLineRelation E,
	Promotion.PRO_POLICY F,@TMP_POLICY G
		WHERE B.WithType = 'ByAuth' AND B.OperType = '包含' 
		AND B.PolicyId = F.PolicyId AND F.PolicyId = G.PolicyId
		AND C.DMA_ID=A.DMA_ID AND C.ActiveFlag='1'  AND D.CC_Division=E.DivisionCode 
		AND E.IsEmerging='0' AND E.DivisionName=F.BU  AND C.Division=D.CC_Division
		AND ((ISNULL(F.SubBU,'')<>'' AND D.CC_ID=C.CC_ID AND D.CC_Code=F.SubBU ) OR ( ISNULL(F.SubBU,'')=''))
		AND C.DMA_ID = @DealerId
	
	--删除不包含的单个经销商
	DELETE C FROM dbo.DealerMaster A,Promotion.PRO_DEALER B,@TMP_DEALER C,Promotion.PRO_POLICY F,@TMP_POLICY G
	WHERE A.DMA_ID = B.DEALERID AND B.OperType = '不包含' AND B.PolicyId = F.PolicyId AND F.PolicyId = G.PolicyId
	AND A.DMA_ID = C.DealerId AND A.DMA_ID = @DealerId
	
	--返回适用的政策
	INSERT INTO @temp(PolicyId,PolicyNo,PolicyName,PolicySubStyle)
	--SELECT DISTINCT A.PolicyId,A.PolicyNo,A.PolicyName+'('+PolicyNo+')',A.PolicySubStyle+'('+PolicyNo+':'+PolicyName+')'
	SELECT DISTINCT A.PolicyId,A.PolicyNo,A.PolicyName,A.PolicySubStyle
	FROM Promotion.PRO_POLICY A,@TMP_DEALER B
	WHERE A.PolicyId = B.PolicyId AND B.DealerId = @DealerId
	union
	select '0' AS PolicyId,'SP0000001' AS PolicyNo,'一次性特殊价格' AS PolicyName,
            '一次性特殊价格' AS PolicySubStyle

	return
END


GO


