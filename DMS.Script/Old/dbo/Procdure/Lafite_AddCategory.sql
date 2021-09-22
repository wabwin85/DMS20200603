DROP PROCEDURE [dbo].[Lafite_AddCategory]
GO



CREATE PROCEDURE [dbo].[Lafite_AddCategory]
	-- Add the parameters for the function here
	@CategoryName nvarchar(64),
	@LogID int
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @CatID INT
	SELECT @CatID = CategoryID FROM Lafite_Category WHERE CategoryName = @CategoryName
	IF @CatID IS NULL
	BEGIN
		INSERT INTO Lafite_Category (CategoryName) VALUES(@CategoryName)
		SELECT @CatID = @@IDENTITY
	END

	EXEC Lafite_InsertCategoryLog @CatID, @LogID 

	RETURN @CatID
END


GO


