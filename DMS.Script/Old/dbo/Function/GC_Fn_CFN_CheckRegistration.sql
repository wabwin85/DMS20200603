DROP FUNCTION [dbo].[GC_Fn_CFN_CheckRegistration]
GO


CREATE FUNCTION [dbo].[GC_Fn_CFN_CheckRegistration]
(
	@ArticleNumber NVARCHAR(200)
)
RETURNS TINYINT
AS

BEGIN
	DECLARE @RtnVal TINYINT
	
	--判断产品是否存在有效注册证信息
	IF EXISTS (SELECT 1 FROM RegistrationMain AS M
				WHERE EXISTS (SELECT 1 FROM RegistrationDetail AS D
				WHERE D.RD_RM_ID = M.RM_ID AND D.RD_ArticleNumber = @ArticleNumber)
				AND GETDATE() BETWEEN M.RM_OpeningDate AND M.RM_ExpirationDate)
		SET @RtnVal = 1
	ELSE
		SET @RtnVal = 0
	RETURN @RtnVal
END


GO


