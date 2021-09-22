DROP FUNCTION [DP].[Func_IsCanApproveFeedback]
GO


CREATE FUNCTION [DP].[Func_IsCanApproveFeedback]
(
	@UserId          UNIQUEIDENTIFIER,
	@FeedbackStauts  NVARCHAR(100)
)
RETURNS INT
AS
BEGIN
	DECLARE @Rtn INT;
	
	SET @Rtn = 0;
	
	IF EXISTS (
	       SELECT 1
	       FROM   Lafite_IDENTITY_MAP T1,
	              Lafite_ATTRIBUTE T2
	       WHERE  T1.MAP_ID = T2.Id
	              AND T1.MAP_TYPE = 'Role'
	              AND T2.ATTRIBUTE_TYPE = 'Role'
	              AND T1.IDENTITY_ID = @UserId
	              AND T2.ATTRIBUTE_NAME = 'DP NCM»À‘±'
	   )
	   AND @FeedbackStauts IN ('30')
	BEGIN
	    SET @Rtn = 1;
	END
	
	RETURN @Rtn
END
GO


