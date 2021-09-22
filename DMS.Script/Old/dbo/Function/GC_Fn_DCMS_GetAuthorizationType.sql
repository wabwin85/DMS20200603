DROP FUNCTION [dbo].[GC_Fn_DCMS_GetAuthorizationType]
GO

CREATE FUNCTION [dbo].[GC_Fn_DCMS_GetAuthorizationType]
(
	@ContractId UNIQUEIDENTIFIER
)
RETURNS TINYINT
AS

BEGIN
	DECLARE @RtnVal TINYINT
	SET @RtnVal=0;
	--返回授权医院与授权产品关系
	--0、授权医院全覆盖授权产品
	--1、授权医院根据授权产品部分覆盖
	
	IF EXISTS(SELECT 1 FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@ContractId)
	BEGIN
		
		IF EXISTS (SELECT 1 FROM (SELECT COUNT(HosCount) HosCount FROM (SELECT DISTINCT COUNT(A.DAT_PMA_ID) HosCount FROM DealerAuthorizationTableTemp A
		INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID
		WHERE DAT_DCL_ID=@ContractId
		GROUP BY B.HOS_ID) tab ) tab2 WHERE tab2.HosCount>1)
		BEGIN
			SET @RtnVal=1
		END
		ELSE
		BEGIN
			SET @RtnVal=0
		END
	END
	ELSE IF EXISTS(SELECT 1 FROM DealerAuthorizationAreaTemp WHERE DA_DCL_ID=@ContractId)
	BEGIN
			
		IF EXISTS (SELECT 1 FROM (SELECT COUNT(HosCount) HosCount FROM (SELECT DISTINCT COUNT(A.DA_PMA_ID) HosCount FROM DealerAuthorizationAreaTemp A
		INNER JOIN TerritoryAreaTemp B ON A.DA_ID=B.TA_DA_ID
		WHERE DA_DCL_ID=@ContractId
		GROUP BY B.TA_Area) tab ) tab2 WHERE tab2.HosCount>1)
		BEGIN
			SET @RtnVal=1
		END
		ELSE
		BEGIN
			SET @RtnVal=0
		END
	END
	
	RETURN @RtnVal
END
GO


