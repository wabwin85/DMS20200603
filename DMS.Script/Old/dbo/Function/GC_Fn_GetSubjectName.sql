DROP FUNCTION [dbo].[GC_Fn_GetSubjectName]
GO



CREATE FUNCTION [dbo].[GC_Fn_GetSubjectName]
(
	@SubjectId UNIQUEIDENTIFIER,
	@SubjectType NVARCHAR(50)
)
RETURNS VARCHAR(20)
AS

BEGIN
	DECLARE @Ret VARCHAR(20)
	SET @Ret = 0
	
	/*�жϿ�����������*/
	IF @SubjectType IN ('SaleMGR','Sale')
		BEGIN
			/*��������Ϊ�ˣ���ȡ�øÿ�����������*/
			SELECT @Ret = LI.IDENTITY_NAME FROM dbo.Lafite_IDENTITY_MAP LIM inner join dbo.Lafite_IDENTITY LI on LIM.IDENTITY_ID = LI.ID
				 WHERE MAP_TYPE = 'Role' AND IDENTITY_ID = CONVERT(VARCHAR(36),@SubjectId)

		END
	ELSE
		BEGIN
		/*��������Ϊ��֯�ܹ�����ȡ�øÿ��������Ӧ����֯�ܹ�����*/
		SELECT @Ret = ATTRIBUTE_NAME FROM dbo.Lafite_Attribute WHERE Attribute_Type = @SubjectType AND ID = @SubjectId

		END

	RETURN @Ret
END



GO


