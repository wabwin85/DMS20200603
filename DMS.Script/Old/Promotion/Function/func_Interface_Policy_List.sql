DROP FUNCTION [Promotion].[func_Interface_Policy_List]
GO

/**********************************************
 功能:界面查询列出符合条件的政策列表
 作者：Grapecity
 最后更新时间： 2015-11-05
 更新记录说明：
 1.创建 2015-11-05
**********************************************/
CREATE FUNCTION [Promotion].[func_Interface_Policy_List](
	@BU NVARCHAR(20),
	@PolicyNo NVARCHAR(50),
	@PolicyName NVARCHAR(100),
	@Status NVARCHAR(20),	--草稿、有效、审批中、审批退回
	@TimeStatus NVARCHAR(20),	--正常、过期
	@Year INT,
	@PolicyStyle NVARCHAR(50)
	)
RETURNS @temp TABLE
(     
	PolicyId INT,
	PolicyNo NVARCHAR(50),
	PolicyName NVARCHAR(300),
	BU NVARCHAR(20),
	StartDate NVARCHAR(10),
	EndDate NVARCHAR(10),
	Status NVARCHAR(10),
	TimeStatus NVARCHAR(10),
	CalPeriod NVARCHAR(20),
	UserId NVARCHAR(36),
	canModify INT,
	canDelete INT,
	canView INT,
	PolicyStyle NVARCHAR(50)
)
AS
BEGIN
	INSERT @temp(PolicyId,PolicyNo,PolicyName,BU,StartDate,EndDate,Status,TimeStatus,CalPeriod,UserId,canModify,canDelete,canView,PolicyStyle)
	SELECT a.PolicyId,a.PolicyNo,
		a.PolicyName+CASE ISNULL(A.PolicyGroupName,'') WHEN '' THEN '' ELSE '['+A.PolicyGroupName+']' END PolicyName,
		A.BU,
		CONVERT(NVARCHAR(10),CONVERT(DATETIME,A.StartDate+'01'),121) StartDate,
		CONVERT(NVARCHAR(10),DATEADD(M,1,CONVERT(DATETIME,A.EndDate+'01'))-1,121) EndDate,
		A.Status,
		CASE WHEN a.EndDate > CONVERT(NVARCHAR(6),getdate(),112) AND a.CalPeriod = Promotion.func_Pro_Utility_getPeriod(period,'CURRENT',enddate) 
			THEN '过期' ELSE '正常' END TimeStatus,
		a.CalPeriod,
		a.CreateBy,
		0 canModify,
		0 canDelete,
		0 canView,
		a.PolicyStyle
	FROM Promotion.PRO_POLICY a
	WHERE 1=1
	AND (ISNULL(@BU, '') = '' OR A.BU = @BU)
	AND (ISNULL(@PolicyNo, '') = '' OR A.PolicyNo LIKE '%'+@PolicyNo+'%')
	AND (ISNULL(@PolicyName, '') = '' OR a.PolicyName LIKE '%'+@PolicyName+'%' OR a.PolicyGroupName LIKE '%'+@PolicyName+'%')
	AND (ISNULL(@Status, '') = '' OR A.Status = @Status)
	AND (ISNULL(@Year, '') = '' OR LEFT(A.StartDate,4) = @Year OR LEFT(A.EndDate,4) = @Year)
	AND (ISNULL(@PolicyStyle, '') = '' OR A.PolicyStyle = @PolicyStyle)
	AND (ISNULL(@TimeStatus, '') = '' 
		OR (@TimeStatus = '正常' AND a.EndDate >= CONVERT(NVARCHAR(6),getdate(),112))
		OR (@TimeStatus = '过期' AND a.EndDate < CONVERT(NVARCHAR(6),getdate(),112) AND a.CalPeriod = Promotion.func_Pro_Utility_getPeriod(period,'CURRENT',enddate)))
	
	UPDATE @temp SET canModify = 1 WHERE Status IN ('有效','草稿','审批退回') AND TimeStatus = '正常'
	UPDATE @temp SET canDelete = 1 WHERE Status = '草稿' OR (Status = '审批退回' AND ISNULL(CalPeriod,'')='')
	UPDATE @temp SET canView = 1 WHERE Status <> '草稿'
	
	RETURN
	
END


GO


