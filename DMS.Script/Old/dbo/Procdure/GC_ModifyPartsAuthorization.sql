DROP Procedure [dbo].[GC_ModifyPartsAuthorization]
GO


/*
	因为调整授权分类而调整授权
*/
Create Procedure [dbo].[GC_ModifyPartsAuthorization]
	@ContractId uniqueidentifier,
	@DealerId uniqueidentifier,
	@ProductLineId uniqueidentifier,
	@PartsAuthorizationId NVARCHAR(max),--授权分类
 
    @RtnVal NVARCHAR(50) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	CREATE TABLE #TBHospital
	(
		HosId uniqueidentifier,
		HosType NVARCHAR(500),
		HOS_Depart NVARCHAR(500),
		HOS_DepartType NVARCHAR(500),
		HOS_DepartRemark NVARCHAR(2000)
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
	INSERT INTO #TBHospital(HosId,HosType,HOS_Depart,HOS_DepartType,HOS_DepartRemark)
	SELECT DISTINCT B.HOS_ID,B.Territory_Type,b.HOS_Depart,b.HOS_DepartType,b.HOS_DepartRemark FROM DealerAuthorizationTableTemp A
	INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID
	WHERE DAT_DCL_ID=@ContractId;
	
	DELETE ContractTerritory WHERE Contract_ID IN (
	SELECT DAT_ID FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@ContractId AND DAT_PMA_ID NOT IN (SELECT VAL FROM GC_Fn_SplitStringToTable(@PartsAuthorizationId,','))
	);
	
	DELETE DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@ContractId AND DAT_PMA_ID NOT IN (SELECT VAL FROM GC_Fn_SplitStringToTable(@PartsAuthorizationId,',') );
	
	INSERT #TBNewPMAId( PMA_ID,ID)
	SELECT A.VAL,NEWID() FROM GC_Fn_SplitStringToTable(@PartsAuthorizationId,',') A 
	WHERE A.VAL NOT IN (SELECT DAT_PMA_ID FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@ContractId)
	
	INSERT INTO DealerAuthorizationTableTemp (DAT_PMA_ID,	DAT_ID,	DAT_DCL_ID,	DAT_DMA_ID,	DAT_DMA_ID_Actual,	DAT_ProductLine_BUM_ID,	DAT_AuthorizationType)
	SELECT PMA_ID,ID,@ContractId,@DealerId,NULL,@ProductLineId, case when PMA_ID=@ProductLineId then 0 else  1 end FROM  #TBNewPMAId
	
	INSERT INTO ContractTerritory (ID,	Contract_ID	,HOS_ID,	Territory_Type,	HOS_Depart,	HOS_DepartType,	HOS_DepartRemark)
	SELECT NEWID(),B.ID,A.HosId,A.HosType,A.HOS_Depart,A.HOS_DepartType,A.HOS_DepartRemark FROM #TBHospital A,#TBNewPMAId B
	
	

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


