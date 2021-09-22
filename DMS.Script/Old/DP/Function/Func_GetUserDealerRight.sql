DROP FUNCTION [DP].[Func_GetUserDealerRight]
GO


CREATE FUNCTION [DP].[Func_GetUserDealerRight]
(
	@UserId    UNIQUEIDENTIFIER,
	@SapCode   NVARCHAR(100),
	@Division  INT,
	@SubBu     NVARCHAR(100)
)
RETURNS INT
AS
BEGIN
	DECLARE @Rtn INT;
	
	DECLARE @RightId INT;
	DECLARE @UserAccount NVARCHAR(20);
	
	SET @RightId = DP.Func_GetUserRoleRight(@UserId);
	SELECT @UserAccount = IDENTITY_CODE
	FROM   Lafite_IDENTITY
	WHERE  Id = @UserId;
	
	IF @RightId = 0
	BEGIN
	    SET @Rtn = 0;
	END
	ELSE
	IF @RightId = 1
	BEGIN
	    SET @Rtn = 1;
	END
	ELSE
	IF @RightId = 2
	BEGIN
	    DECLARE @UserDivision INT;
	    
	    SELECT @UserDivision = B.DepID
	    FROM   Lafite_IDENTITY A,
	           interface.MDM_EmployeeMaster B
	    WHERE  A.IDENTITY_CODE = B.account
	           AND A.Id = @UserId;
	    
	    IF @UserDivision = @Division
	    BEGIN
	        SET @Rtn = 1;
	    END
	    ELSE
	    BEGIN
	        SET @Rtn = 0;
	    END
	END
	ELSE
	IF @RightId IN (3, 4, 5)
	BEGIN
	    IF EXISTS (
	           SELECT 1
	           FROM   DP.UserDealerMapping
	           WHERE  UserAccount = @UserAccount
	                  AND SapCode = @SapCode
	                  AND Division = @Division
	                  AND SubBu = @SubBu
	       )
	    BEGIN
	        SET @Rtn = 1;
	    END
	    ELSE
	    BEGIN
	        SET @Rtn = 0;
	    END
	END
	
	RETURN @Rtn
END
GO


