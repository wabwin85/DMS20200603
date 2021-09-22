DROP PROCEDURE [Promotion].[Proc_Interface_JobSave] 
GO


/**********************************************
	���ܣ���������
	���ߣ�GrapeCity
	������ʱ�䣺	2015-11-01
	���¼�¼˵����
	1.���� 2015-11-01
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_JobSave] 
	@JobId INT
AS
BEGIN 
	  DECLARE @JobType NVARCHAR(20)
	  
	  SELECT @JobType = JobType FROM Promotion.Pro_Job WHERE JobId = @JobId
	  
	  IF @JobType IN ('Ԥ��','��ʽ')
	  BEGIN
	  	UPDATE C SET
	  		 	CalModule = @JobType,
	  			CalStatus = '������',
	  			CalPeriod = NULL,
	  			StartTime = NULL,
	  			EndTime = NULL
	  	FROM Promotion.Pro_Job A,Promotion.Pro_Job_Detail B,Promotion.Pro_Policy C
	  	WHERE A.JobId = B.JobId AND B.PolicyId = C.PolicyId AND A.JobId = @JobId
	  END
	  
END 

GO


