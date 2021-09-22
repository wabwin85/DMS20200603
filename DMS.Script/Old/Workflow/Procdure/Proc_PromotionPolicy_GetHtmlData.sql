
DROP PROCEDURE [Workflow].[Proc_PromotionPolicy_GetHtmlData]
GO

Create PROCEDURE [Workflow].[Proc_PromotionPolicy_GetHtmlData]
	@InstanceId uniqueidentifier
AS
DECLARE @ApplyType NVARCHAR(100)
DECLARE @PolicyId INT

SELECT @ApplyType = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

--模版信息，必须放在第一个查询结果，且只有固定的两个字段，名称不能变
SELECT @ApplyType AS TemplateName, 'Header,PromotionPolicy,Attachment' AS TableNames

--数据准备
SELECT @PolicyId=a.PolicyId FROM Promotion.PRO_POLICY A WHERE A.InstanceID=@InstanceId

--数据信息
--表头

SELECT Promotion.func_Pro_PolicyToHtml(@PolicyId)  AS PolicyXML

--明细信息
SELECT A.PolicyNo,A.PolicyName,A.Period,A.StartDate,A.EndDate,A.BU,A.[Status] FROM Promotion.PRO_POLICY A WHERE A.PolicyId=@PolicyId

--附件信息
EXEC Workflow.Proc_Attachment_GetHtmlData @InstanceId,NULL

GO


