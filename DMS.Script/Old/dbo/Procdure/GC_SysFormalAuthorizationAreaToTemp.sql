DROP Procedure [dbo].[GC_SysFormalAuthorizationAreaToTemp]
GO


/*
	同步正式表授权区域到临时表
*/
CREATE Procedure [dbo].[GC_SysFormalAuthorizationAreaToTemp]
	@ContractId uniqueidentifier,
	@DealerId uniqueidentifier,
	@ProductLineId uniqueidentifier,
	@PartsContractCode NVARCHAR(200),
    @MarketType int,
 
    @RtnVal NVARCHAR(50) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	CREATE TABLE #TBHospital
	(
		Hosid uniqueidentifier
	)
	
	CREATE TABLE #TBPMBR
	(
		PMA_ID uniqueidentifier
	)
	
SET NOCOUNT ON

BEGIN TRY	

BEGIN TRAN

	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	--不分红蓝海
	IF @MarketType=2
	BEGIN
		DECLARE @DAT_ID_Temp uniqueidentifier
		set @DAT_ID_Temp= NEWID();
		
		INSERT INTO DealerAuthorizationAreaTemp(DA_PMA_ID,DA_ID,	DA_DCL_ID,	DA_DMA_ID,	DA_ProductLine_BUM_ID,	DA_AuthorizationType)
		SELECT DA_PMA_ID,@DAT_ID_Temp,	@ContractId,	DA_DMA_ID,	DA_ProductLine_BUM_ID,	'1'
		FROM DealerAuthorizationArea A 
		WHERE A.DA_DMA_ID=@DealerId AND A.DA_ProductLine_BUM_ID=@ProductLineId
		AND A.DA_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization b  where b.CA_ParentCode=@PartsContractCode)
		
		--授权区域
		INSERT INTO TerritoryAreaTemp (TA_DA_ID,TA_ID,TA_Area,TA_Remark)
		SELECT @DAT_ID_Temp,NEWID(),TABAREA.TA_Area,NULL FROM (
		SELECT DISTINCT  B.TA_Area
		FROM DealerAuthorizationArea A 
		INNER JOIN TerritoryArea B ON A.DA_ID=B.TA_DA_ID
		WHERE A.DA_DMA_ID=@DealerId AND A.DA_ProductLine_BUM_ID=@ProductLineId
		AND A.DA_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization b  where b.CA_ParentCode=@PartsContractCode)) TABAREA
			
		
		
		--排除医院
		INSERT INTO #TBHospital (Hosid)
		SELECT DISTINCT  D.TAE_HOS_ID
		FROM DealerAuthorizationArea A 
		INNER JOIN TerritoryAreaExc D ON A.DA_ID=D.TAE_DA_ID
		WHERE A.DA_DMA_ID=@DealerId AND A.DA_ProductLine_BUM_ID=@ProductLineId
		AND A.DA_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization b  where b.CA_ParentCode=@PartsContractCode)
		
		INSERT INTO TerritoryAreaExcTemp (TAE_ID,TAE_DA_ID,TAE_HOS_ID)
		SELECT NEWID(),@DAT_ID_Temp,a.Hosid FROM #TBHospital A
		
	END
	--分红蓝海
	ELSE 
	BEGIN
		--获取授权分类
		INSERT INTO #TBPMBR (PMA_ID)
		SELECT DISTINCT B.DA_PMA_ID
		FROM DealerAuthorizationArea B
		WHERE B.DA_DMA_ID=@DealerId AND b.DA_ProductLine_BUM_ID=@ProductLineId 
		AND B.DA_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization b  where b.CA_ParentCode=@PartsContractCode)
		
		--获取授权医院
		INSERT INTO #TBHospital (Hosid)
		SELECT DISTINCT  A.TAE_HOS_ID
		FROM TerritoryAreaExc A 
		INNER JOIN DealerAuthorizationArea B ON A.TAE_DA_ID=B.DA_ID
		INNER JOIN V_AllHospitalMarketProperty C ON C.Hos_Id=A.TAE_HOS_ID AND C.ProductLineID=@ProductLineId AND C.MarketProperty=@MarketType
		WHERE B.DA_DMA_ID=@DealerId AND b.DA_ProductLine_BUM_ID=@ProductLineId 
		AND B.DA_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization b  where b.CA_ParentCode=@PartsContractCode)
		
		--维护主表
		INSERT INTO DealerAuthorizationAreaTemp(DA_PMA_ID,DA_ID,	DA_DCL_ID,	DA_DMA_ID,	DA_ProductLine_BUM_ID,	DA_AuthorizationType)
		SELECT PMA_ID,NEWID(),@ContractId,@DealerId,@ProductLineId,'1' FROM #TBPMBR
		
		--维护授权区域
		INSERT INTO TerritoryAreaTemp (TA_Area,TA_DA_ID,TA_ID)
		SELECT TABAREA.TA_Area,B.DA_ID,NEWID() FROM(
		SELECT DISTINCT  B.TA_Area
		FROM DealerAuthorizationArea A 
		INNER JOIN TerritoryArea B ON A.DA_ID=B.TA_DA_ID
		WHERE A.DA_DMA_ID=@DealerId AND A.DA_ProductLine_BUM_ID=@ProductLineId
		AND A.DA_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization b  where b.CA_ParentCode=@PartsContractCode)) TABAREA ,DealerAuthorizationAreaTemp  B
		WHERE B.DA_DCL_ID=@ContractId
		
		--维护排除医院
		
		INSERT INTO TerritoryAreaExcTemp (TAE_ID,TAE_DA_ID,TAE_HOS_ID)
		SELECT NEWID(),B.DA_ID,a.Hosid FROM #TBHospital A,DealerAuthorizationAreaTemp B
		
	END

	
		
COMMIT TRAN
SET NOCOUNT OFF
return 1
END TRY
BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
     --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
END CATCH




GO


