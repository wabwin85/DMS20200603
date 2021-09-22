DROP FUNCTION [Promotion].[func_Interface_Job_List]
GO


/**********************************************
 ����:�����ѯ�г����������������б�(�ݸ壬������ִ���У������)
 ���ߣ�Grapecity
 ������ʱ�䣺 2015-11-05
 ���¼�¼˵����
 1.���� 2015-11-05
**********************************************/
CREATE FUNCTION [Promotion].[func_Interface_Job_List](
	@JobType NVARCHAR(20),	--��������
	@BU NVARCHAR(20),				--BU��Ʒ��
	@Status NVARCHAR(20),		--״̬
	@StartTime NVARCHAR(10),	--����ʼʱ��
	@EndTime NVARCHAR(10)			--�������ʱ��
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
	iCanView INT,	--1�ɲ鿴,0���ɲ鿴
	iLog INT,			--1�ɿ���־,0���ɿ���־
	iExport INT,	--1������,0��������
	iDelete INT		--1��ɾ��,0����ɾ��
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
	
	UPDATE @temp SET iCanView = 0 WHERE Status = '�ݸ�'
	
	UPDATE @temp SET iLog = 1,iExport=1 WHERE Status = '�����'
	
	UPDATE @temp SET iDelete = 1 WHERE Status in ('�ݸ�','������')
	 
	RETURN
	
END


GO


