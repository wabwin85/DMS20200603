DROP FUNCTION [Promotion].[func_Interface_Job_PolicySelect]
GO


/**********************************************
 ����:ά������ʱ��ѡ������
 ���ߣ�Grapecity
 ������ʱ�䣺 2015-11-05
 ���¼�¼˵����
 1.���� 2015-11-05
**********************************************/
CREATE FUNCTION [Promotion].[func_Interface_Job_PolicySelect](
	@JobId INT,
	@ShowType NVARCHAR(10)	--'ȫ��','��ִ��','����ִ��'
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
	
	--ȡ���������
	SELECT 
		@JobType = JobType,
		@BU = BU,
		@Period = Period,
		@CalPeriod = CalPeriod
	FROM PROMOTION.Pro_Job WHERE JobId = @JobId
		
	--ȡ�ò�Ʒ�ߡ����ڷ��ϵģ�����û�н����������
	INSERT INTO @temp(PolicyId,PolicyNo,PolicyName,CurrentPeriod,Status,Remark,iCanSelect)
	SELECT A.PolicyId,A.PolicyNo,
	A.PolicyName + CASE ISNULL(A.PolicyGroupName,'') WHEN '' THEN '' ELSE '['+A.PolicyGroupName+']' END,
	A.CurrentPeriod,'��ִ��','',1
	FROM Promotion.PRO_POLICY A
	WHERE A.BU = @BU AND A.Period = @Period 
		AND NOT (PROMOTION.func_Pro_Utility_getPeriod(A.Period,'CURRENT',A.EndDate) <= PROMOTION.func_Pro_Utility_getPeriod(A.Period,'CURRENT',A.CurrentPeriod)
		AND A.CalStatus = '����') --��ǰ�ѹ����������Ǳ��������һ���ɼ�������
		
	--���²���ִ�е����START**************************************************************************************************
	UPDATE A SET Status ='����ִ��',
		Remark = '���߷���Ч״̬',
		iCanSelect = 0
	FROM @temp A,Promotion.Pro_Policy B
	WHERE A.PolicyId = B.PolicyId AND A.iCanSelect = 1 AND B.Status <> '��Ч'
	
	UPDATE A SET Status ='����ִ��',
		Remark = '����������'+B.JobNo+'������',
		iCanSelect = 0
	FROM @temp A,PROMOTION.Pro_Job B,PROMOTION.Pro_Job_detail C
	WHERE A.PolicyId = C.PolicyId AND B.JobId = c.JobId AND B.status = '������'
	AND A.iCanSelect = 1
	
	IF @JobType = N'��ʽ' or @JobType = N'Ԥ��'
	BEGIN
		UPDATE A SET Status ='����ִ��',
			Remark = '��������������ѹ���',
			iCanSelect = 0
		FROM @temp A,Promotion.Pro_Policy B
		WHERE A.PolicyId = B.PolicyId AND A.iCanSelect = 1 AND B.CalStatus = '����'
		AND PROMOTION.func_Pro_Utility_getPeriod(B.Period,'CURRENT',B.CurrentPeriod) = @CalPeriod
			
		UPDATE A SET Status ='����ִ��',
			Remark = '���ڲ�����Ҫ��',
			iCanSelect = 0
		FROM @temp A,Promotion.Pro_Policy B
		WHERE A.PolicyId = B.PolicyId AND A.iCanSelect = 1 
		AND PROMOTION.func_Pro_Utility_getPeriod(B.Period,
				CASE ISNULL(B.CurrentPeriod,'') WHEN '' THEN 'CURRENT' ELSE 'NEXT' END,
				CASE ISNULL(B.CurrentPeriod,'') WHEN '' THEN B.StartDate ELSE B.CurrentPeriod END) <> @CalPeriod
	END
	
	IF @JobType = '����'
	BEGIN
		
		UPDATE A SET Status ='����ִ��',
			Remark = '�����ظ�����',
			iCanSelect = 0
		FROM @temp A,Promotion.Pro_Policy B
		WHERE A.PolicyId = B.PolicyId AND A.iCanSelect = 1 
		AND ISNULL(B.CalStatus,'') = '����' AND PROMOTION.func_Pro_Utility_getPeriod(B.Period,'CURRENT',B.CurrentPeriod) = @CalPeriod
	
		UPDATE A SET Status ='����ִ��',
			Remark = 'Ԥ�㲻�ɹ���',
			iCanSelect = 0
		FROM @temp A,Promotion.Pro_Policy B
		WHERE A.PolicyId = B.PolicyId AND A.iCanSelect = 1 
		AND ISNULL(B.CalModule,'') = 'Ԥ��'
	
		UPDATE A SET Status ='����ִ��',
			Remark = '���ڲ�����Ҫ��',
			iCanSelect = 0
		FROM @temp A,Promotion.Pro_Policy B
		WHERE A.PolicyId = B.PolicyId AND A.iCanSelect = 1 
		AND ISNULL(B.CalStatus,'') = '��ʽ' AND PROMOTION.func_Pro_Utility_getPeriod(B.Period,
				CASE ISNULL(B.CurrentPeriod,'') WHEN '' THEN 'CURRENT' ELSE 'NEXT' END,
				CASE ISNULL(B.CurrentPeriod,'') WHEN '' THEN B.StartDate ELSE B.CurrentPeriod END) <> @CalPeriod
		
		--���������ԣ����ɹ���
		UPDATE A SET Status ='����ִ��',
			Remark = '���ɹ���',
			iCanSelect = 0
		FROM @temp A,Promotion.Pro_Policy B
		WHERE A.PolicyId = B.PolicyId AND A.iCanSelect = 1 
		AND NOT (ISNULL(B.CalModule,'') = '��ʽ' AND ISNULL(B.CalStatus,'')='�������' AND PROMOTION.func_Pro_Utility_getPeriod(B.Period,
				CASE ISNULL(B.CurrentPeriod,'') WHEN '' THEN 'CURRENT' ELSE 'NEXT' END,
				CASE ISNULL(B.CurrentPeriod,'') WHEN '' THEN B.StartDate ELSE B.CurrentPeriod END) = @CalPeriod)
	END
	
	--���²���ִ�е����END****************************************************************************************************
	
	IF @ShowType <> 'ȫ��'
	BEGIN
		DELETE FROM @temp WHERE Status <> @ShowType
	END

	RETURN
	
END


GO


