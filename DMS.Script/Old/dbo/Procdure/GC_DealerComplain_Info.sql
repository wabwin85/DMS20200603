DROP PROCEDURE [dbo].[GC_DealerComplain_Info]
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GC_DealerComplain_Info]
	@DC_ID UNIQUEIDENTIFIER,
	@ComplainType NVARCHAR(20)
AS
	IF @ComplainType = 'BSC'
	BEGIN
	    SELECT *
	    FROM   DealerComplain DC,
	           Lafite_IDENTITY LI
	    WHERE  DC.EID = LI.Id
	           AND DC.DC_ID = @DC_ID
	END
	ELSE IF @ComplainType = 'CRM'
	BEGIN
	    SELECT *
	    FROM   DealerComplainCRM DC,
             Lafite_IDENTITY LI
      WHERE  DC.EID = LI.Id
	           AND DC.DC_ID = @DC_ID
	END
GO


