DROP PROCEDURE [Promotion].[Proc_Interface_JobSave] 
GO


/**********************************************
	功能：保存任务
	作者：GrapeCity
	最后更新时间：	2015-11-01
	更新记录说明：
	1.创建 2015-11-01
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_JobSave] 
	@JobId INT
AS
BEGIN 
	  DECLARE @JobType NVARCHAR(20)
	  
	  SELECT @JobType = JobType FROM Promotion.Pro_Job WHERE JobId = @JobId
	  
	  IF @JobType IN ('预算','正式')
	  BEGIN
	  	UPDATE C SET
	  		 	CalModule = @JobType,
	  			CalStatus = '待计算',
	  			CalPeriod = NULL,
	  			StartTime = NULL,
	  			EndTime = NULL
	  	FROM Promotion.Pro_Job A,Promotion.Pro_Job_Detail B,Promotion.Pro_Policy C
	  	WHERE A.JobId = B.JobId AND B.PolicyId = C.PolicyId AND A.JobId = @JobId
	  END
	  
END 

GO


