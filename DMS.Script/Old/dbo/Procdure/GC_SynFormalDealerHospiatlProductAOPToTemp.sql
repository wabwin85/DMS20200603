DROP Procedure [dbo].[GC_SynFormalDealerHospiatlProductAOPToTemp]
GO


/*
同步上一年产品分类与授权医院的关系
*/
CREATE Procedure [dbo].[GC_SynFormalDealerHospiatlProductAOPToTemp]
	@Con_Id NVARCHAR(36), 
	@Dma_Id NVARCHAR(36),	  
	@Plb_Id NVARCHAR(36), 
	@YearString NVARCHAR(4000),
	@minYear  NVARCHAR(4),
	@IsEmerging NVARCHAR(2),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	DECLARE @CheckYearHasDate INT
	DECLARE @GetConId NVARCHAR(36)
	DECLARE @GetHosId NVARCHAR(36)
	DECLARE @GetStringProduct NVARCHAR(4000)

	
	SELECT @CheckYearHasDate=COUNT(*)
	FROM AOPICDealerHospital T1
	INNER JOIN (SELECT hosTp.HOS_ID FROM ContractTerritory hosTp,DealerAuthorizationTableTemp AuthTp WHERE hosTp.Contract_ID = AuthTp.DAT_ID AND AuthTp.DAT_DCL_ID=@Con_Id) Territory
	ON Territory.HOS_ID=T1.AOPICH_Hospital_ID
	INNER JOIN AOPHospitalProductMapping T2 ON T1.AOPICH_PCT_ID=T2.AOPHPM_PCT_ID AND T2.AOPHPM_Dma_id=T1.AOPICH_DMA_ID AND T2.AOPHPM_ActiveFlag='1' 
	INNER JOIN Hospital ON Hospital.HOS_ID=T1.AOPICH_Hospital_ID
	INNER JOIN V_AllHospitalMarketProperty AMP ON AMP.ProductLineID=T1.AOPICH_ProductLine_ID AND AMP.HOS_ID=Territory.HOS_ID
	WHERE T1.AOPICH_DMA_ID=@Dma_Id
	AND T1.AOPICH_ProductLine_ID=@Plb_Id
	AND T1.AOPICH_Year IN (SELECT  VAL FROM GC_Fn_SplitStringToTable(@YearString,',')) 
	AND AMP.MarketProperty =@IsEmerging
				
	IF @CheckYearHasDate=0
	BEGIN
		--维护上一年MP关系
		INSERT INTO AOPHospitalProductMapping(AOPHPM_Id,AOPHPM_ContractId,AOPHPM_Dma_id,AOPHPM_Hos_Id,AOPHPM_PCT_ID,AOPHPM_PCP_ID)
		SELECT NEWID(),@Con_Id,tb.AOPICH_DMA_ID,tb.AOPICH_Hospital_ID,tb.AOPICH_PCT_ID,tb.AOPHPM_PCP_ID
		FROM (
		SELECT DISTINCT T1.AOPICH_DMA_ID,T1.AOPICH_Hospital_ID,T1.AOPICH_PCT_ID,T2.AOPHPM_PCP_ID
		FROM AOPICDealerHospital T1
		INNER JOIN (SELECT hosTp.HOS_ID FROM ContractTerritory hosTp,DealerAuthorizationTableTemp AuthTp WHERE hosTp.Contract_ID = AuthTp.DAT_ID AND AuthTp.DAT_DCL_ID=@Con_Id) Territory
		ON Territory.HOS_ID=T1.AOPICH_Hospital_ID
		INNER JOIN AOPHospitalProductMapping T2 ON T1.AOPICH_PCT_ID=T2.AOPHPM_PCT_ID AND T2.AOPHPM_Dma_id=T1.AOPICH_DMA_ID AND T2.AOPHPM_ActiveFlag='1' 
		INNER JOIN Hospital ON Hospital.HOS_ID=T1.AOPICH_Hospital_ID
		INNER JOIN V_AllHospitalMarketProperty AMP ON AMP.ProductLineID=T1.AOPICH_ProductLine_ID AND AMP.HOS_ID=Territory.HOS_ID
		WHERE T1.AOPICH_DMA_ID=@Dma_Id
		AND T1.AOPICH_ProductLine_ID=@Plb_Id
		AND T1.AOPICH_Year =@minYear
		AND AMP.MarketProperty=@IsEmerging) tb;
		--页面同步AOP指标
	END
	ELSE
	BEGIN
		INSERT INTO AOPHospitalProductMapping(AOPHPM_Id,AOPHPM_ContractId,AOPHPM_Dma_id,AOPHPM_Hos_Id,AOPHPM_PCT_ID,AOPHPM_PCP_ID)
		SELECT NEWID(),@Con_Id,tb.AOPICH_DMA_ID,tb.AOPICH_Hospital_ID,tb.AOPICH_PCT_ID,tb.AOPHPM_PCP_ID
		FROM (
		SELECT DISTINCT T1.AOPICH_DMA_ID,T1.AOPICH_Hospital_ID,T1.AOPICH_PCT_ID,T2.AOPHPM_PCP_ID
		FROM AOPICDealerHospital T1
		INNER JOIN (SELECT hosTp.HOS_ID FROM ContractTerritory hosTp,DealerAuthorizationTableTemp AuthTp WHERE hosTp.Contract_ID = AuthTp.DAT_ID AND AuthTp.DAT_DCL_ID=@Con_Id) Territory
		ON Territory.HOS_ID=T1.AOPICH_Hospital_ID
		INNER JOIN AOPHospitalProductMapping T2 ON T1.AOPICH_PCT_ID=T2.AOPHPM_PCT_ID AND T2.AOPHPM_Dma_id=T1.AOPICH_DMA_ID AND T2.AOPHPM_ActiveFlag='1' 
		INNER JOIN Hospital ON Hospital.HOS_ID=T1.AOPICH_Hospital_ID
		INNER JOIN V_AllHospitalMarketProperty AMP ON AMP.ProductLineID=T1.AOPICH_ProductLine_ID AND AMP.HOS_ID=Territory.HOS_ID
		WHERE T1.AOPICH_DMA_ID=@Dma_Id
		AND T1.AOPICH_ProductLine_ID=@Plb_Id
		AND T1.AOPICH_Year IN (SELECT  VAL FROM GC_Fn_SplitStringToTable(@YearString,','))
		AND AMP.MarketProperty=@IsEmerging) tb;
		
		--INSERT INTO AOPICDealerHospitalTemp
		--(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_DMA_ID_Actual,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit,AOPICH_Update_Date)
		--SELECT NEWID(),@Con_Id,@Dma_Id,@Dma_Id,@Plb_Id,
		--AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit,GETDATE()
		--FROM AOPICDealerHospital Aop
		--INNER JOIN (SELECT hosTp.HOS_ID FROM ContractTerritory hosTp,DealerAuthorizationTableTemp AuthTp WHERE hosTp.Contract_ID = AuthTp.DAT_ID AND AuthTp.DAT_DCL_ID=@Con_Id) Territory
		--ON Territory.HOS_ID=Aop.AOPICH_Hospital_ID
		--INNER JOIN Hospital ON Hospital.HOS_ID=Aop.AOPICH_Hospital_ID
		--INNER JOIN AOPHospitalProductMapping Pro ON Pro.AOPHPM_PCT_ID= Aop.AOPICH_PCT_ID AND Pro.AOPHPM_Dma_id=Aop.AOPICH_DMA_ID AND Pro.AOPHPM_ActiveFlag='1'
		--WHERE Aop.AOPICH_DMA_ID=@Dma_Id
		--AND Aop.AOPICH_ProductLine_ID=@Plb_Id
		--AND Aop.AOPICH_Year IN (SELECT  VAL FROM GC_Fn_SplitStringToTable(@YearString,','))
		--AND Hospital.HOS_Grade='新兴市场'
		
	END



	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''

	
	
		
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


