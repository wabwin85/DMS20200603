DROP  Procedure [dbo].[GC_SysFormalAuthorizationToTemp]
GO



		
/*
	同步正式表授权到临时表
*/
CREATE Procedure [dbo].[GC_SysFormalAuthorizationToTemp]
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
		Hosid uniqueidentifier,
		HOS_Depart NVARCHAR(500),
		HOS_DepartType NVARCHAR(500),
		HOS_DepartRemark NVARCHAR(2000)
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
		
		
		INSERT INTO DealerAuthorizationTableTemp(DAT_PMA_ID,DAT_ID,	DAT_DCL_ID,	DAT_DMA_ID,	DAT_ProductLine_BUM_ID,	DAT_AuthorizationType)
		SELECT DAT_PMA_ID,NEWID(),	@ContractId,	DAT_DMA_ID,	DAT_ProductLine_BUM_ID,	'1'
		FROM DealerAuthorizationTable A 
		WHERE A.DAT_DMA_ID=@DealerId AND A.DAT_ProductLine_BUM_ID=@ProductLineId
		AND A.DAT_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization b  where b.CA_ParentCode=@PartsContractCode)
		
		
		
		INSERT INTO #TBHospital (Hosid,HOS_Depart,HOS_DepartType,HOS_DepartRemark)
		SELECT DISTINCT  D.HLA_HOS_ID,d.HLA_HOS_Depart,d.HLA_HOS_DepartType,d.HLA_HOS_DepartRemark
		FROM DealerAuthorizationTable A 
		INNER JOIN HospitalList D ON A.DAT_ID=D.HLA_DAT_ID
		WHERE A.DAT_DMA_ID=@DealerId AND A.DAT_ProductLine_BUM_ID=@ProductLineId
		AND A.DAT_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization b  where b.CA_ParentCode=@PartsContractCode)
		
		INSERT INTO ContractTerritory (ID,Contract_ID,HOS_ID,Territory_Type,HOS_Depart,HOS_DepartType,HOS_DepartRemark)
		SELECT NEWID(),B.DAT_ID,a.Hosid,'Old',a.HOS_Depart,a.HOS_DepartType,a.HOS_DepartRemark 
		FROM #TBHospital A,DealerAuthorizationTableTemp b
		WHERE B.DAT_DCL_ID=@ContractId
		
	END
	--分红蓝海
	ELSE 
	BEGIN
		INSERT INTO #TBPMBR (PMA_ID)
		SELECT DISTINCT B.DAT_PMA_ID
		FROM HospitalList A 
		INNER JOIN DealerAuthorizationTable B ON A.HLA_DAT_ID=B.DAT_ID
		INNER JOIN V_AllHospitalMarketProperty C ON C.Hos_Id=A.HLA_HOS_ID AND C.ProductLineID=@ProductLineId AND C.MarketProperty=@MarketType
		WHERE B.DAT_DMA_ID=@DealerId AND b.DAT_ProductLine_BUM_ID=@ProductLineId 
		AND B.DAT_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization b  where b.CA_ParentCode=@PartsContractCode)
		
		INSERT INTO #TBHospital (Hosid,HOS_Depart,HOS_DepartType,HOS_DepartRemark)
		SELECT DISTINCT  A.HLA_HOS_ID,A.HLA_HOS_Depart,A.HLA_HOS_DepartType,A.HLA_HOS_DepartRemark
		FROM HospitalList A 
		INNER JOIN DealerAuthorizationTable B ON A.HLA_DAT_ID=B.DAT_ID
		INNER JOIN V_AllHospitalMarketProperty C ON C.Hos_Id=A.HLA_HOS_ID AND C.ProductLineID=@ProductLineId AND C.MarketProperty=@MarketType
		WHERE B.DAT_DMA_ID=@DealerId AND b.DAT_ProductLine_BUM_ID=@ProductLineId 
		AND B.DAT_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization b  where b.CA_ParentCode=@PartsContractCode)
		
		INSERT INTO DealerAuthorizationTableTemp(DAT_PMA_ID,DAT_ID,	DAT_DCL_ID,	DAT_DMA_ID,	DAT_ProductLine_BUM_ID,	DAT_AuthorizationType)
		SELECT PMA_ID,NEWID(),@ContractId,@DealerId,@ProductLineId,'1' FROM #TBPMBR
		
		INSERT INTO ContractTerritory (ID,Contract_ID,HOS_ID,Territory_Type,HOS_Depart,HOS_DepartType,HOS_DepartRemark)
		SELECT NEWID(),B.DAT_ID,a.Hosid,'Old',a.HOS_Depart,a.HOS_DepartType,a.HOS_DepartRemark FROM #TBHospital A ,DealerAuthorizationTableTemp  B
		WHERE B.DAT_DCL_ID=@ContractId
		
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


