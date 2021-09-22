DROP Procedure [dbo].[GC_ModifyPartsAuthorizationAreaTemp]
GO


/*
	因为调整授权分类而调整授权
*/
Create Procedure [dbo].[GC_ModifyPartsAuthorizationAreaTemp]
	@ContractId uniqueidentifier,
	@DealerId uniqueidentifier,
	@ProductLineId uniqueidentifier,
	@PartsAuthorizationId NVARCHAR(max),--授权分类
 
    @RtnVal NVARCHAR(50) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	CREATE TABLE #TBHospital
	(
		HosId uniqueidentifier
	)
	
	CREATE TABLE #TBArea
	(
		AreaId uniqueidentifier
	)
	
	CREATE TABLE #TBNewPMAId
	(
		PMA_ID uniqueidentifier,	
		ID uniqueidentifier
	)
	
SET NOCOUNT ON

BEGIN TRY	

BEGIN TRAN

	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	INSERT INTO #TBHospital(HosId)
	SELECT DISTINCT B.TAE_HOS_ID FROM DealerAuthorizationAreaTemp A
	INNER JOIN TerritoryAreaExcTemp B ON A.DA_ID=B.TAE_DA_ID
	WHERE a.DA_DCL_ID=@ContractId;
	
	INSERT INTO #TBArea(AreaId)
	SELECT DISTINCT B.TA_Area FROM DealerAuthorizationAreaTemp A
	INNER JOIN TerritoryAreaTemp B ON A.DA_ID=B.TA_DA_ID
	WHERE a.DA_DCL_ID=@ContractId;
	
	DELETE TerritoryAreaExcTemp WHERE TAE_DA_ID IN (
	SELECT DA_ID FROM DealerAuthorizationAreaTemp WHERE DA_DCL_ID=@ContractId AND DA_PMA_ID NOT IN (SELECT VAL FROM GC_Fn_SplitStringToTable(@PartsAuthorizationId,','))
	);
	
	DELETE TerritoryAreaTemp WHERE TA_DA_ID IN (
	SELECT DA_ID FROM DealerAuthorizationAreaTemp WHERE DA_DCL_ID=@ContractId AND DA_PMA_ID NOT IN (SELECT VAL FROM GC_Fn_SplitStringToTable(@PartsAuthorizationId,','))
	);
	
	DELETE DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@ContractId AND DAT_PMA_ID NOT IN (SELECT VAL FROM GC_Fn_SplitStringToTable(@PartsAuthorizationId,',') );
	
	INSERT #TBNewPMAId( PMA_ID,ID)
	SELECT A.VAL,NEWID() FROM GC_Fn_SplitStringToTable(@PartsAuthorizationId,',') A 
	WHERE A.VAL NOT IN (SELECT DA_PMA_ID FROM DealerAuthorizationAreaTemp WHERE DA_DCL_ID=@ContractId)
	
	INSERT INTO DealerAuthorizationAreaTemp (DA_PMA_ID,	DA_ID,	DA_DCL_ID,	DA_DMA_ID,	DA_DMA_ID_Actual,	DA_ProductLine_BUM_ID,	DA_AuthorizationType)
	SELECT PMA_ID,ID,@ContractId,@DealerId,NULL,@ProductLineId, case when PMA_ID=@ProductLineId then 0 else  1 end FROM  #TBNewPMAId
	
	INSERT INTO TerritoryAreaExcTemp (TAE_ID,	TAE_DA_ID	,TAE_HOS_ID)
	SELECT NEWID(),B.ID,A.HosId FROM #TBHospital A,#TBNewPMAId B
	
	INSERT INTO TerritoryAreaTemp (TA_ID,	TA_DA_ID	,TA_Area)
	SELECT NEWID(),B.ID,A.AreaId FROM #TBArea A,#TBNewPMAId B
	
	

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


