DROP PROCEDURE [dbo].[Lafite_InsertCategoryLog]
GO

CREATE PROCEDURE [dbo].[Lafite_InsertCategoryLog]
	@CategoryID INT,
	@LogID INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CatLogID INT
	SELECT @CatLogID FROM Lafite_CategoryLog WHERE CategoryID=@CategoryID and LogID = @LogID
	IF @CatLogID IS NULL
	BEGIN
		INSERT INTO Lafite_CategoryLog (CategoryID, LogID) VALUES(@CategoryID, @LogID)
		RETURN @@IDENTITY
	END
	ELSE RETURN @CatLogID
END

GO


