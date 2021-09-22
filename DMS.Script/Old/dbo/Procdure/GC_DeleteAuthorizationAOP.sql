DROP Procedure [dbo].[GC_DeleteAuthorizationAOP]
GO


/*
	因为调整医院进而“医院指标”、“经销商指标”
*/
CREATE Procedure [dbo].[GC_DeleteAuthorizationAOP]
	@ContractId uniqueidentifier,
	@PartsContractCode NVARCHAR(200),
    @Hospital NVARCHAR(2000),
    @BeginDate Datetime,
    @RtnVal NVARCHAR(50) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	DECLARE @CheckProduct int
	
SET NOCOUNT ON

BEGIN TRY	

BEGIN TRAN

	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	--维护产品分类与授权医院关系
	DELETE AOPHospitalProductMapping  
	WHERE AOPHPM_ContractId=@ContractId 
	AND AOPHPM_Hos_Id IN (SELECT VAL FROM GC_Fn_SplitStringToTable(@Hospital,','));
	
	--删除医院指标
	--DELETE AOPDealerHospitalTemp WHERE AOPDH_Contract_ID=@ContractId AND AOPDH_Hospital_ID IN  (SELECT VAL FROM GC_Fn_SplitStringToTable(@Hospital,','));
	DELETE A  FROM AOPDealerHospitalTemp A WHERE AOPDH_Contract_ID=@ContractId 
	AND NOT EXISTS(SELECT 1 FROM DealerAuthorizationTableTemp B  
				INNER JOIN (SELECT DISTINCT CA_ID,CQ_ID FROM V_ProductClassificationStructure  WHERE @BeginDate between StartDate and	EndDate ) C  ON C.CA_ID=B.DAT_PMA_ID
			WHERE B.DAT_DCL_ID=A.AOPDH_Contract_ID AND C.CQ_ID=A.AOPDH_PCT_ID )
	
	--删除医院产品线指标
	--DELETE AOPICDealerHospitalTemp WHERE AOPICH_Contract_ID=@ContractId AND AOPICH_Hospital_ID IN  (SELECT VAL FROM GC_Fn_SplitStringToTable(@Hospital,','));
	DELETE A  FROM AOPICDealerHospitalTemp A WHERE A.AOPICH_Contract_ID=@ContractId 
	AND NOT EXISTS(SELECT 1 FROM DealerAuthorizationTableTemp B  
				INNER JOIN (SELECT DISTINCT CA_ID,CQ_ID FROM V_ProductClassificationStructure WHERE @BeginDate between StartDate and	EndDate ) C  ON C.CA_ID=B.DAT_PMA_ID
			WHERE B.DAT_DCL_ID=A.AOPICH_Contract_ID AND C.CQ_ID=A.AOPICH_PCT_ID )
	
	
	DELETE AOPDealerTemp WHERE   AOPD_Contract_ID=@ContractId 
	--更新经销商指标临时表数据（同步经销商医院临时表）
	--SELECT @CheckProduct=COUNT(*) FROM AOPICDealerHospitalTemp WHERE AOPICH_Contract_ID=@ContractId 
	--IF(@CheckProduct>0)
	--BEGIN
	--	INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_ProductLine_BUM_ID,AOPD_CC_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date)
	--	SELECT NEWID(),AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,@CCId ,AOPICH_Year,AOPICH_Month,sum(AOPICH_Unit * Pcp.PCP_Price) AS ProductAumt,GETDATE()
	--	FROM AOPICDealerHospitalTemp  temp
	--	INNER JOIN AOPHospitalProductMapping mp on mp.AOPHPM_Hos_Id=temp.AOPICH_Hospital_ID and  mp.AOPHPM_ContractId=temp.AOPICH_Contract_ID 
	--	and mp.AOPHPM_PCT_ID=temp.AOPICH_PCT_ID
	--	INNER JOIN ProductClassificationPrice Pcp on Pcp.PCP_ID=mp.AOPHPM_PCP_ID
	--	WHERE AOPICH_Contract_ID=@ContractId
	--	GROUP BY AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_Year,AOPICH_Month;
	--END
	--SET @CheckProduct=0
	--SELECT @CheckProduct=COUNT(*) FROM AOPDealerHospitalTemp WHERE AOPDH_Contract_ID=@ContractId 
	--IF(@CheckProduct>0)
	--BEGIN
	--	INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_ProductLine_BUM_ID,AOPD_CC_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date)
	--	SELECT NEWID(),AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID, AOPDH_ProductLine_BUM_ID,@CCId,AOPDH_Year,AOPDH_Month,SUM(AOPDH_Amount),GETDATE() 
	--	FROM AOPDealerHospitalTemp temp
	--	WHERE AOPDH_Contract_ID=@ContractId
	--	GROUP BY AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Month
	--END
		
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


