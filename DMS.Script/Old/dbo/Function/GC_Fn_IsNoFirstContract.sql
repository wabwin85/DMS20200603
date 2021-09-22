
DROP FUNCTION [dbo].[GC_Fn_IsNoFirstContract]
GO



CREATE FUNCTION [dbo].[GC_Fn_IsNoFirstContract]
(
	 @DelaerId NVARCHAR(36),
	 @Division NVARCHAR(10)
)
RETURNS nvarchar(20)
as
Begin
    Declare @IsNO nvarchar(20)
    IF EXISTS(SELECT 1 FROM V_DealerContractMaster A WHERE A.DMA_ID=@DelaerId AND CONVERT(NVARCHAR(10),A.Division)=@Division)
	BEGIN
		SET @IsNO=0
	END
	ELSE
	BEGIN
		SET @IsNO=1
	END
	
	return @IsNO

End



GO


