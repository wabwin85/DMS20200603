DROP FUNCTION [dbo].[Lafite_GetUserNameById]
GO

CREATE FUNCTION [dbo].[Lafite_GetUserNameById]
(	@UserId varchar(36) )
RETURNS nvarchar(50)
AS
BEGIN

	declare @user_name nvarchar(50)

	select @user_name = a.IDENTITY_NAME from dbo.Lafite_IDENTITY a
	where a.Id = @UserId
	
	if( @user_name is null )
	begin
		select @user_name = ''	
	end
	-- Return the result of the function
	RETURN @user_name

END

GO


