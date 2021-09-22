DROP FUNCTION [Promotion].[func_Interface_Job_PolicySelect]
GO


/**********************************************
 功能:维护任务时，选择政策
 作者：Grapecity
 最后更新时间： 2015-11-05
 更新记录说明：
 1.创建 2015-11-05
**********************************************/
CREATE FUNCTION [Promotion].[func_Interface_Job_PolicySelect](
	@JobId INT,
	@ShowType NVARCHAR(10)	--'全部','可执行','不可执行'
	)
RETURNS @temp TABLE
(  
	PolicyId INT,
	PolicyNo NVARCHAR(50),
	PolicyName NVARCHAR(100),
	CurrentPeriod NVARCHAR(10),
	Status NVARCHAR(10),
	Remark NVARCHAR(100),
	iCanSelect INT
)
AS
BEGIN
	DECLARE @JobType NVARCHAR(20)
	DECLARE @BU NVARCHAR(20)
	DECLARE @Period NVARCHAR(20)
	DECLARE @CalPeriod NVARCHAR(20)
	
	--取得任务参数
	SELECT 
		@JobType = JobType,
		@BU = BU,
		@Period = Period,
		@CalPeriod = CalPeriod
	FROM PROMOTION.Pro_Job WHERE JobId = @JobId
		
	--取得产品线、周期符合的，并且没有结算完的政策
	INSERT INTO @temp(PolicyId,PolicyNo,PolicyName,CurrentPeriod,Status,Remark,iCanSelect)
	SELECT A.PolicyId,A.PolicyNo,
	A.PolicyName + CASE ISNULL(A.PolicyGroupName,'') WHEN '' THEN '' ELSE '['+A.PolicyGroupName+']' END,
	A.CurrentPeriod,'可执行','',1
	FROM Promotion.PRO_POLICY A
	WHERE A.BU = @BU AND A.Period = @Period 
		AND NOT (PROMOTION.func_Pro_Utility_getPeriod(A.Period,'CURRENT',A.EndDate) <= PROMOTION.func_Pro_Utility_getPeriod(A.Period,'CURRENT',A.CurrentPeriod)
		AND A.CalStatus = '关账') --当前已关账账期已是本政策最后一个可计算账期
		
	--更新不可执行的情况START**************************************************************************************************
	UPDATE A SET Status ='不可执行',
		Remark = '政策非有效状态',
		iCanSelect = 0
	FROM @temp A,Promotion.Pro_Policy B
	WHERE A.PolicyId = B.PolicyId AND A.iCanSelect = 1 AND B.Status <> '有效'
	
	UPDATE A SET Status ='不可执行',
		Remark = '此政策已在'+B.JobNo+'任务中',
		iCanSelect = 0
	FROM @temp A,PROMOTION.Pro_Job B,PROMOTION.Pro_Job_detail C
	WHERE A.PolicyId = C.PolicyId AND B.JobId = c.JobId AND B.status = '待处理'
	AND A.iCanSelect = 1
	
	IF @JobType = N'正式' or @JobType = N'预算'
	BEGIN
		UPDATE A SET Status ='不可执行',
			Remark = '期望结算的账期已关账',
			iCanSelect = 0
		FROM @temp A,Promotion.Pro_Policy B
		WHERE A.PolicyId = B.PolicyId AND A.iCanSelect = 1 AND B.CalStatus = '关账'
		AND PROMOTION.func_Pro_Utility_getPeriod(B.Period,'CURRENT',B.CurrentPeriod) = @CalPeriod
			
		UPDATE A SET Status ='不可执行',
			Remark = '账期不符合要求',
			iCanSelect = 0
		FROM @temp A,Promotion.Pro_Policy B
		WHERE A.PolicyId = B.PolicyId AND A.iCanSelect = 1 
		AND PROMOTION.func_Pro_Utility_getPeriod(B.Period,
				CASE ISNULL(B.CurrentPeriod,'') WHEN '' THEN 'CURRENT' ELSE 'NEXT' END,
				CASE ISNULL(B.CurrentPeriod,'') WHEN '' THEN B.StartDate ELSE B.CurrentPeriod END) <> @CalPeriod
	END
	
	IF @JobType = '关账'
	BEGIN
		
		UPDATE A SET Status ='不可执行',
			Remark = '不可重复关账',
			iCanSelect = 0
		FROM @temp A,Promotion.Pro_Policy B
		WHERE A.PolicyId = B.PolicyId AND A.iCanSelect = 1 
		AND ISNULL(B.CalStatus,'') = '关账' AND PROMOTION.func_Pro_Utility_getPeriod(B.Period,'CURRENT',B.CurrentPeriod) = @CalPeriod
	
		UPDATE A SET Status ='不可执行',
			Remark = '预算不可关账',
			iCanSelect = 0
		FROM @temp A,Promotion.Pro_Policy B
		WHERE A.PolicyId = B.PolicyId AND A.iCanSelect = 1 
		AND ISNULL(B.CalModule,'') = '预算'
	
		UPDATE A SET Status ='不可执行',
			Remark = '账期不符合要求',
			iCanSelect = 0
		FROM @temp A,Promotion.Pro_Policy B
		WHERE A.PolicyId = B.PolicyId AND A.iCanSelect = 1 
		AND ISNULL(B.CalStatus,'') = '正式' AND PROMOTION.func_Pro_Utility_getPeriod(B.Period,
				CASE ISNULL(B.CurrentPeriod,'') WHEN '' THEN 'CURRENT' ELSE 'NEXT' END,
				CASE ISNULL(B.CurrentPeriod,'') WHEN '' THEN B.StartDate ELSE B.CurrentPeriod END) <> @CalPeriod
		
		--其他可能性，不可关账
		UPDATE A SET Status ='不可执行',
			Remark = '不可关账',
			iCanSelect = 0
		FROM @temp A,Promotion.Pro_Policy B
		WHERE A.PolicyId = B.PolicyId AND A.iCanSelect = 1 
		AND NOT (ISNULL(B.CalModule,'') = '正式' AND ISNULL(B.CalStatus,'')='计算完成' AND PROMOTION.func_Pro_Utility_getPeriod(B.Period,
				CASE ISNULL(B.CurrentPeriod,'') WHEN '' THEN 'CURRENT' ELSE 'NEXT' END,
				CASE ISNULL(B.CurrentPeriod,'') WHEN '' THEN B.StartDate ELSE B.CurrentPeriod END) = @CalPeriod)
	END
	
	--更新不可执行的情况END****************************************************************************************************
	
	IF @ShowType <> '全部'
	BEGIN
		DELETE FROM @temp WHERE Status <> @ShowType
	END

	RETURN
	
END


GO


