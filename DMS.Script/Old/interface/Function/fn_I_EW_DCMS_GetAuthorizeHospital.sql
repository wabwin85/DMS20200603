DROP FUNCTION [interface].[fn_I_EW_DCMS_GetAuthorizeHospital]
GO


/*
平台收货确认数据处理
*/
Create FUNCTION [interface].[fn_I_EW_DCMS_GetAuthorizeHospital]
	(@InstanceID NVARCHAR(36))	
RETURNS  NVARCHAR(20) 
AS 
BEGIN
DECLARE @RtnVal NVARCHAR(36)
DECLARE @CountHs INT;
	SELECT @CountHs=COUNT( distinct tr.HOS_ID) FROM ContractTerritory tr 
					INNER JOIN DealerAuthorizationTableTemp tp ON tp.DAT_ID=tr.Contract_ID
				WHERE tp.DAT_DCL_ID=@InstanceID;

	IF(@CountHs=0)
	BEGIN
		SET @RtnVal = '0 Hospital'
	END
	BEGIN
		SET @RtnVal = CONVERT(NVARCHAR(20),@CountHs) +' Hospital(s)'
	END
	RETURN @RtnVal
END
	
	




GO


