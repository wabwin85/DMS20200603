DROP PROCEDURE [Workflow].[Proc_DealerReturn_CheckFormData]

GO


CREATE PROCEDURE [Workflow].[Proc_DealerReturn_CheckFormData]
	@InstanceId UNIQUEIDENTIFIER,
	@NodeIds NVARCHAR(2000),
	@RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(4000) OUTPUT
AS
BEGIN
	IF (NOT EXISTS (
	       SELECT 1
	       FROM   InventoryReturnBsc
	       WHERE  IR_Adj_Id = @InstanceId
	   )
	   OR EXISTS (
	       SELECT 1
	       FROM   InventoryReturnBsc
	       WHERE  IR_Adj_Id = @InstanceId
	              AND ISNULL(RTRIM(LTRIM(IR_RGANo)),'') = ''
	   ))
	   AND EXISTS (
	           SELECT 1
	           FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	           WHERE  VAL IN ('N14','N15')
	       )
	BEGIN
	    SET @RtnVal = 'Fail';
	    SET @RtnMsg = 'RGA∫≈±ÿ–ÎÃÓ–¥£°';
	END
	ELSE
	BEGIN
	    SET @RtnVal = 'Success';
	    SET @RtnMsg = '';
	END
END
GO


