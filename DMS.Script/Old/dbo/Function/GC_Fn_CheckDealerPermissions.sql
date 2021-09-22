DROP FUNCTION [dbo].[GC_Fn_CheckDealerPermissions]
GO

Create FUNCTION [dbo].[GC_Fn_CheckDealerPermissions] (
   @DealerId    UNIQUEIDENTIFIER,
   @OrderPermissionsType   NVARCHAR (100)
   )
   RETURNS TINYINT
AS
   BEGIN
      DECLARE @RtnVal   TINYINT
      IF EXISTS (SELECT 1 FROM DealerPermissions WHERE DMA_ID=@DealerId AND PermissionsType=@OrderPermissionsType )
		  BEGIN
			IF   EXISTS (SELECT 1 FROM DealerPermissions 
							WHERE DMA_ID=@DealerId 
							AND PermissionsType=@OrderPermissionsType 
							AND (CONVERT(NVARCHAR(10),BeginDate,120) <= CONVERT(NVARCHAR(10),GETDATE(),120))
							AND  (EndDate IS NULL OR CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),EndDate,120)))
				BEGIN
					SET @RtnVal=1;
				END
				ELSE
				BEGIN
					SET @RtnVal=0;
				END
		  END
      ELSE
		BEGIN
			SET @RtnVal=1;
		END
                   
      IF @RtnVal IS NULL
         SET @RtnVal = 0

      RETURN @RtnVal
   END
GO


