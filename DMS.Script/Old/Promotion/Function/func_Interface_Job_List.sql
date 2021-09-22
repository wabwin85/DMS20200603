DROP FUNCTION [Promotion].[func_Interface_Job_List]
GO


/**********************************************
 功能:界面查询列出符合条件的任务列表(草稿，待处理，执行中，已完成)
 作者：Grapecity
 最后更新时间： 2015-11-05
 更新记录说明：
 1.创建 2015-11-05
**********************************************/
CREATE FUNCTION [Promotion].[func_Interface_Job_List](
	@JobType NVARCHAR(20),	--任务类型
	@BU NVARCHAR(20),				--BU产品线
	@Status NVARCHAR(20),		--状态
	@StartTime NVARCHAR(10),	--任务开始时间
	@EndTime NVARCHAR(10)			--任务结束时间
	)
RETURNS @temp TABLE
(     
	JobId INT,
	JobNo NVARCHAR(20),
	JobType NVARCHAR(20),
	BU NVARCHAR(20),
	JobTime NVARCHAR(19),
	Period NVARCHAR(20),
	CalPeriod NVARCHAR(20),
	Status NVARCHAR(20),
	RunSummary NVARCHAR(200),
	iCanView INT,	--1可查看,0不可查看
	iLog INT,			--1可看日志,0不可看日志
	iExport INT,	--1可下载,0不可下载
	iDelete INT		--1可删除,0不可删除
)
AS
BEGIN
	INSERT INTO @temp(JobId,JobNo,JobType,BU,JobTime,Period,CalPeriod,Status,RunSummary,iCanView,iLog,iExport,iDelete)
	SELECT JobId,JobNo,JobType,BU,CONVERT(NVARCHAR(16),JobTime,121),Period,CalPeriod,Status,RunSummary,1,0,0,0 
	FROM PROMOTION.Pro_Job
	WHERE (@JobType IS NULL OR JobType = @JobType)
		AND (@BU IS NULL OR BU = @BU)
		AND (@Status IS NULL OR Status = @Status)
		AND CONVERT(NVARCHAR(10),JobTime,121) BETWEEN ISNULL(@StartTime,'1900-01-01') AND ISNULL(@EndTime,'2100-01-01')
	
	UPDATE @temp SET iCanView = 0 WHERE Status = '草稿'
	
	UPDATE @temp SET iLog = 1,iExport=1 WHERE Status = '已完成'
	
	UPDATE @temp SET iDelete = 1 WHERE Status in ('草稿','待处理')
	 
	RETURN
	
END


GO


