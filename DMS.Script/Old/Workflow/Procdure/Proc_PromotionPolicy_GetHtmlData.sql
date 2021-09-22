
DROP PROCEDURE [Workflow].[Proc_PromotionPolicy_GetHtmlData]
GO

Create PROCEDURE [Workflow].[Proc_PromotionPolicy_GetHtmlData]
	@InstanceId uniqueidentifier
AS
DECLARE @ApplyType NVARCHAR(100)
DECLARE @PolicyId INT

SELECT @ApplyType = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

--ģ����Ϣ��������ڵ�һ����ѯ�������ֻ�й̶��������ֶΣ����Ʋ��ܱ�
SELECT @ApplyType AS TemplateName, 'Header,PromotionPolicy,Attachment' AS TableNames

--����׼��
SELECT @PolicyId=a.PolicyId FROM Promotion.PRO_POLICY A WHERE A.InstanceID=@InstanceId

--������Ϣ
--��ͷ

SELECT Promotion.func_Pro_PolicyToHtml(@PolicyId)  AS PolicyXML

--��ϸ��Ϣ
SELECT A.PolicyNo,A.PolicyName,A.Period,A.StartDate,A.EndDate,A.BU,A.[Status] FROM Promotion.PRO_POLICY A WHERE A.PolicyId=@PolicyId

--������Ϣ
EXEC Workflow.Proc_Attachment_GetHtmlData @InstanceId,NULL

GO


