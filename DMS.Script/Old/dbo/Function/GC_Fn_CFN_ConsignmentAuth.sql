DROP FUNCTION [dbo].[GC_Fn_CFN_ConsignmentAuth]
GO


CREATE FUNCTION [dbo].[GC_Fn_CFN_ConsignmentAuth]
(
    @DealerId UNIQUEIDENTIFIER,
    @ProductLine UNIQUEIDENTIFIER ,
	@CfnId UNIQUEIDENTIFIER,
	@CMID UNIQUEIDENTIFIER
	
)
RETURNS TINYINT
AS

BEGIN
	DECLARE @RtnVal TINYINT
	--判断该经销商下的产品线是否在规则内
	IF EXISTS(SELECT 1 FROM ConsignmentAuthorization WHERE   CA_DMA_ID=@DealerId AND CA_ProductLine_Id=@ProductLine AND CA_StartDate<GETDATE()AND CA_EndDate>GETDATE()AND CA_IsActive=1 AND CA_CM_ID=@CMID)
	BEGIN
	 IF EXISTS(SELECT 1 FROM
				(
				SELECT CFN.CFN_ID FROM CFN
				WHERE EXISTS(SELECT 1 FROM ConsignmentMaster 
											INNER JOIN ConsignmentAuthorization ON ConsignmentMaster.CM_ID=ConsignmentAuthorization.CA_CM_ID 
											INNER JOIN ConsignmentCfn ON ConsignmentCfn.CC_CM_ID=ConsignmentMaster.CM_ID
										WHERE ConsignmentAuthorization.CA_DMA_ID=@DealerId 
										AND ConsignmentAuthorization.CA_ProductLine_Id=@ProductLine
										AND ConsignmentMaster.CM_ID=@CMID
										AND CFN.CFN_ID = CC_CFN_ID
				  )) AS C  WHERE C.CFN_ID=@CfnId
				)
				
	   SET @RtnVal = 1
	   ELSE
	   SET @RtnVal = 0
	    END
	ELSE
	BEGIN
	   SET @RtnVal = 0
	   END
	   RETURN @RtnVal
	   END


GO


