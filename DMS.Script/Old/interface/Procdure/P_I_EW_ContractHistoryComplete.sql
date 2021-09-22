DROP PROCEDURE [interface].[P_I_EW_ContractHistoryComplete]
GO



CREATE PROCEDURE [interface].[P_I_EW_ContractHistoryComplete]
@Contract_ID nvarchar(36), @Contract_Type nvarchar(50),@RtnVal nvarchar(20) OUTPUT, @RtnMsg nvarchar(4000) OUTPUT
WITH EXEC AS CALLER
AS
DECLARE @ProductLineId uniqueidentifier
DECLARE @Division NVARCHAR(10)
DECLARE @DMA_ID uniqueidentifier
DECLARE @MarktType NVARCHAR(10)
DECLARE @SubDepID NVARCHAR(50)
DECLARE @CC_ID uniqueidentifier
DECLARE @BeginDate DATETIME

SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	IF (@Contract_Type='Appointment')
	BEGIN
		SELECT @DMA_ID=CAP_DMA_ID,@MarktType= CONVERT(NVARCHAR(10),ISNULL(A.CAP_MarketType,0)), @Division=A.CAP_Division,@SubDepID= A.CAP_SubDepID,@BeginDate=CAP_EffectiveDate
		FROM  ContractAppointment A WHERE CAP_ID= @Contract_ID
		
		--向历史表中添加最初数据
		DELETE HospitalListHistory WHERE HLH_CurrentContractID=@Contract_ID
		DELETE AOPDealerHistory WHERE ADH_CurrentContractID=@Contract_ID
		DELETE AOPDealerHospitaHistory WHERE ADHH_CurrentContractID=@Contract_ID
		DELETE AOPICDealerHospitalHistory WHERE ADHPH_CurrentContractID=@Contract_ID
		
		INSERT INTO HospitalListHistory
		(HLH_ID,HLH_CurrentContractID,HLH_HOS_ID)
		SELECT NEWID(),@Contract_ID,tab.HOS_ID  from  (SELECT distinct tr.HOS_ID 
		FROM ContractTerritory tr 
		INNER JOIN DealerAuthorizationTableTemp tp ON tp.DAT_ID=tr.Contract_ID
		WHERE tp.DAT_DCL_ID=@Contract_ID) tab;
		
		INSERT INTO AOPDealerHistory 
		([ADH_ID] ,[ADH_ChangeToContractID] ,[ADH_CurrentContractID],[ADH_DMA_ID],[ADH_Year],
		[ADH_January],[ADH_February],[ADH_March] ,[ADH_April]     ,[ADH_May]    ,
		[ADH_June],[ADH_July]  ,[ADH_August] ,[ADH_September] ,[ADH_October]
		,[ADH_November],[ADH_December])
		SELECT NEWID(),NULL,@Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Year,
		AOPD_Amount_1,AOPD_Amount_2,AOPD_Amount_3,AOPD_Amount_4,AOPD_Amount_5,
		AOPD_Amount_6,AOPD_Amount_7,AOPD_Amount_8,AOPD_Amount_9,AOPD_Amount_10,
		AOPD_Amount_11,AOPD_Amount_12
		FROM [dbo].[V_AOPDealer_Temp]
		WHERE AOPD_Contract_ID=@Contract_ID;
		
		INSERT INTO AOPDealerHospitaHistory 
		([ADHH_ID] ,[ADHH_ChangeToContractID] ,[ADHH_CurrentContractID],[ADHH_DMA_ID],[ADHH_HospitalID],ADHH_PCT_ID,[ADHH_Year],
		[ADHH_January],[ADHH_February],[ADHH_March] ,[ADHH_April]     ,[ADHH_May]    ,
		[ADHH_June],[ADHH_July]  ,[ADHH_August] ,[ADHH_September] ,[ADHH_October]
		,[ADHH_November],[ADHH_December])
		SELECT NEWID(),NULL,@Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Hospital_ID,AOPDH_PCT_ID, AOPDH_Year,
		AOPDH_Amount_1,AOPDH_Amount_2,AOPDH_Amount_3,AOPDH_Amount_4,AOPDH_Amount_5,
		AOPDH_Amount_6,AOPDH_Amount_7,AOPDH_Amount_8,AOPDH_Amount_9,AOPDH_Amount_10,
		AOPDH_Amount_11,AOPDH_Amount_12
		FROM [dbo].[V_AOPDealerHospital_Temp]
		WHERE AOPDH_Contract_ID=@Contract_ID;
		
		--INSERT INTO AOPICDealerHospitalHistory 
		--(ADHPH_ID ,[ADHPH_ChangeToContractID] ,[ADHPH_CurrentContractID],[ADHPH_DMA_ID],[ADHPH_HospitalID],ADHPH_PCT_ID,[ADHPH_Year],
		--[ADHPH_January],[ADHPH_February],[ADHPH_March] ,[ADHPH_April]     ,[ADHPH_May]    ,
		--[ADHPH_June],[ADHPH_July]  ,[ADHPH_August] ,[ADHPH_September] ,[ADHPH_October]
		--,[ADHPH_November],[ADHPH_December])
		--SELECT NEWID(),NULL,@Contract_ID,AOPICH_DMA_ID,AOPICH_Hospital_ID, AOPICH_PCT_ID,AOPICH_Year,
		--AOPICH_Unit_1,AOPICH_Unit_2,AOPICH_Unit_3,AOPICH_Unit_4,AOPICH_Unit_5,
		--AOPICH_Unit_6,AOPICH_Unit_7,AOPICH_Unit_8,AOPICH_Unit_9,AOPICH_Unit_10,
		--AOPICH_Unit_11,AOPICH_Unit_12
		--FROM [dbo].[V_AOPICDealerHospital_Temp]
		--WHERE AOPICH_Contract_ID=@Contract_ID;
		
	END
	IF (@Contract_Type='Amendment')
	BEGIN
		SELECT @DMA_ID=CAM_DMA_ID,@MarktType= CONVERT(NVARCHAR(10),ISNULL(A.CAM_MarketType,0)), @Division=A.CAM_Division,@SubDepID= A.CAM_SubDepID ,@BeginDate=CAM_Amendment_EffectiveDate
		FROM  ContractAmendment A WHERE CAM_ID= @Contract_ID
	END
	IF (@Contract_Type='Renewal')
	BEGIN
		SELECT @DMA_ID=CRE_DMA_ID,@MarktType= CONVERT(NVARCHAR(10),ISNULL(A.CRE_MarketType,0)), @Division=A.CRE_Division,@SubDepID= A.CRE_SubDepID,@BeginDate=CRE_Agrmt_EffectiveDate_Renewal
		FROM  ContractRenewal A WHERE CRE_ID= @Contract_ID
	END
	IF (@Contract_Type='Termination')
	BEGIN
		SELECT @DMA_ID=CTE_DMA_ID,@MarktType= CONVERT(NVARCHAR(10),ISNULL(A.CTE_MarketType,0)),@Division=CTE_Division,@SubDepID= A.CTE_SubDepID ,@BeginDate=CTE_Termination_EffectiveDate
		FROM  ContractTermination A  WHERE CTE_ID= @Contract_ID
	END
	
	SELECT top (1) @CC_ID= CC_ID FROM interface.ClassificationContract a WHERE A.CC_Code=@SubDepID;
	SELECT @ProductLineId= ProductLineID FROM V_DivisionProductLineRelation WHERE DivisionName=@Division AND IsEmerging='0'
		
	--清空当前合同历史数据
	DELETE HospitalListHistory WHERE HLH_ChangeToContractID=@Contract_ID;
	DELETE AOPDealerHistory WHERE [ADH_ChangeToContractID]=@Contract_ID;
	DELETE AOPDealerHospitaHistory WHERE [ADHH_ChangeToContractID]=@Contract_ID;
	DELETE AOPICDealerHospitalHistory WHERE [ADHPH_ChangeToContractID]=@Contract_ID;
	
	SET @BeginDate=ISNULL(@BeginDate,GETDATE());
	--插入历史表
	IF(ISNULL(@MarktType,'0'))='2'
	BEGIN
		INSERT INTO HospitalListHistory(HLH_ID,HLH_ChangeToContractID,HLH_CurrentContractID,HLH_HOS_ID)
		SELECT NEWID(),@Contract_ID,NULL,HLA_HOS_ID FROM (
		SELECT DISTINCT HLA_HOS_ID
		FROM HospitalList hos
		INNER JOIN DealerAuthorizationTable aut on hos.HLA_DAT_ID=aut.DAT_ID
		INNER JOIN (SELECT distinct a.CC_ID,a.CA_ID  FROM V_ProductClassificationStructure a WHERE @BeginDate BETWEEN a.StartDate AND A.EndDate) pcs on pcs.CA_ID=aut.DAT_PMA_ID
		INNER JOIN V_AllHospitalMarketProperty amp ON amp.ProductLineID=aut.DAT_ProductLine_BUM_ID and amp.HOS_ID=hos.HLA_HOS_ID
		WHERE aut.DAT_ProductLine_BUM_ID =@ProductLineId
		AND aut.DAT_DMA_ID=@DMA_ID
		AND pcs.CC_ID=@CC_ID)TAB
		
		INSERT INTO AOPDealerHistory 
		([ADH_ID] ,[ADH_ChangeToContractID] ,[ADH_CurrentContractID],[ADH_DMA_ID],[ADH_Year],
		[ADH_January],[ADH_February],[ADH_March] ,[ADH_April]     ,[ADH_May]    ,
		[ADH_June],[ADH_July]  ,[ADH_August] ,[ADH_September] ,[ADH_October]
		,[ADH_November],[ADH_December])
		SELECT NEWID(),@Contract_ID,NULL,AOPD_Dealer_DMA_ID,AOPD_Year,
		AOPD_Amount_1,AOPD_Amount_2,AOPD_Amount_3,AOPD_Amount_4,AOPD_Amount_5,
		AOPD_Amount_6,AOPD_Amount_7,AOPD_Amount_8,AOPD_Amount_9,AOPD_Amount_10,
		AOPD_Amount_11,AOPD_Amount_12
		FROM [dbo].[V_AOPDealer]
		WHERE AOPD_Dealer_DMA_ID=@DMA_ID
		AND AOPD_ProductLine_BUM_ID =@ProductLineId
		AND AOPD_CC_ID=@CC_ID
		AND AOPD_Year IN (SELECT AOPD_Year FROM AOPDealerTemp WHERE AOPD_Contract_ID=@Contract_ID);

		INSERT INTO AOPDealerHospitaHistory 
		([ADHH_ID] ,[ADHH_ChangeToContractID] ,[ADHH_CurrentContractID],[ADHH_DMA_ID],[ADHH_HospitalID],[ADHH_Year],
		[ADHH_January],[ADHH_February],[ADHH_March] ,[ADHH_April]     ,[ADHH_May]    ,
		[ADHH_June],[ADHH_July]  ,[ADHH_August] ,[ADHH_September] ,[ADHH_October]
		,[ADHH_November],[ADHH_December],ADHH_PCT_ID)
		SELECT NEWID(),@Contract_ID,NULL,AOPDH_Dealer_DMA_ID,AOPDH_Hospital_ID,AOPDH_Year,
		AOPDH_Amount_1,AOPDH_Amount_2,AOPDH_Amount_3,AOPDH_Amount_4,AOPDH_Amount_5,
		AOPDH_Amount_6,AOPDH_Amount_7,AOPDH_Amount_8,AOPDH_Amount_9,AOPDH_Amount_10,
		AOPDH_Amount_11,AOPDH_Amount_12,AOP.AOPDH_PCT_ID
		FROM [dbo].[V_AOPDealerHospital] AOP
		INNER JOIN V_AllHospitalMarketProperty AMP ON AMP.ProductLineID=AOP.AOPDH_ProductLine_BUM_ID AND AMP.HOS_ID=AOP.AOPDH_Hospital_ID
		WHERE AOPDH_Dealer_DMA_ID=@DMA_ID
		AND AOPDH_ProductLine_BUM_ID =@ProductLineId
		AND AOPDH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure A WHERE A.CC_ID =@CC_ID AND (@BeginDate BETWEEN a.StartDate AND A.EndDate))

		INSERT INTO AOPICDealerHospitalHistory 
		(ADHPH_ID ,[ADHPH_ChangeToContractID] ,[ADHPH_CurrentContractID],[ADHPH_DMA_ID],[ADHPH_HospitalID],ADHPH_PCT_ID,[ADHPH_Year],
		[ADHPH_January],[ADHPH_February],[ADHPH_March] ,[ADHPH_April]     ,[ADHPH_May]    ,
		[ADHPH_June],[ADHPH_July]  ,[ADHPH_August] ,[ADHPH_September] ,[ADHPH_October]
		,[ADHPH_November],[ADHPH_December])
		SELECT NEWID(),@Contract_ID,NULL,AOPICH_DMA_ID,AOPICH_Hospital_ID,AOPICH_PCT_ID,AOPICH_Year,
		AOPICH_Unit_1,AOPICH_Unit_2,AOPICH_Unit_3,AOPICH_Unit_4,AOPICH_Unit_5,
		AOPICH_Unit_6,AOPICH_Unit_7,AOPICH_Unit_8,AOPICH_Unit_9,AOPICH_Unit_10,
		AOPICH_Unit_11,AOPICH_Unit_12
		FROM [dbo].[V_AOPICDealerHospital] AOP
		INNER JOIN V_AllHospitalMarketProperty AMP ON AMP.ProductLineID=AOP.AOPICH_ProductLine_ID AND AMP.HOS_ID=AOP.AOPICH_Hospital_ID
		WHERE AOPICH_DMA_ID=@DMA_ID
		AND AOPICH_ProductLine_ID =@ProductLineId
		AND AOPICH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure A WHERE A.CC_ID =@CC_ID AND (@BeginDate BETWEEN a.StartDate AND A.EndDate))
	END
	ELSE
	BEGIN
		INSERT INTO HospitalListHistory(HLH_ID,HLH_ChangeToContractID,HLH_CurrentContractID,HLH_HOS_ID)
		SELECT NEWID(),@Contract_ID,NULL,HLA_HOS_ID
		FROM HospitalList hos
		INNER JOIN DealerAuthorizationTable aut on hos.HLA_DAT_ID=aut.DAT_ID
		INNER JOIN (SELECT distinct a.CC_ID,a.CA_ID  FROM V_ProductClassificationStructure a  WHERE @BeginDate BETWEEN a.StartDate AND A.EndDate) pcs on pcs.CA_ID=aut.DAT_PMA_ID
		INNER JOIN V_AllHospitalMarketProperty amp ON amp.ProductLineID=aut.DAT_ProductLine_BUM_ID and amp.HOS_ID=hos.HLA_HOS_ID
		WHERE aut.DAT_ProductLine_BUM_ID =@ProductLineId
		AND aut.DAT_DMA_ID=@DMA_ID
		AND pcs.CC_ID=@CC_ID
		AND ISNULL(amp.MarketProperty,0) =CONVERT(INT , @MarktType);
		
		
		INSERT INTO AOPDealerHistory 
		([ADH_ID] ,[ADH_ChangeToContractID] ,[ADH_CurrentContractID],[ADH_DMA_ID],[ADH_Year],
		[ADH_January],[ADH_February],[ADH_March] ,[ADH_April]     ,[ADH_May]    ,
		[ADH_June],[ADH_July]  ,[ADH_August] ,[ADH_September] ,[ADH_October]
		,[ADH_November],[ADH_December])
		SELECT NEWID(),@Contract_ID,NULL,AOPD_Dealer_DMA_ID,AOPD_Year,
		AOPD_Amount_1,AOPD_Amount_2,AOPD_Amount_3,AOPD_Amount_4,AOPD_Amount_5,
		AOPD_Amount_6,AOPD_Amount_7,AOPD_Amount_8,AOPD_Amount_9,AOPD_Amount_10,
		AOPD_Amount_11,AOPD_Amount_12
		FROM [dbo].[V_AOPDealer]
		WHERE AOPD_Dealer_DMA_ID=@DMA_ID
		AND AOPD_ProductLine_BUM_ID =@ProductLineId
		AND AOPD_CC_ID=@CC_ID
		AND ISNULL(AOPD_Market_Type,'0')=@MarktType;

		INSERT INTO AOPDealerHospitaHistory 
		([ADHH_ID] ,[ADHH_ChangeToContractID] ,[ADHH_CurrentContractID],[ADHH_DMA_ID],[ADHH_HospitalID],[ADHH_Year],
		[ADHH_January],[ADHH_February],[ADHH_March] ,[ADHH_April]     ,[ADHH_May]    ,
		[ADHH_June],[ADHH_July]  ,[ADHH_August] ,[ADHH_September] ,[ADHH_October]
		,[ADHH_November],[ADHH_December],ADHH_PCT_ID)
		SELECT NEWID(),@Contract_ID,NULL,AOPDH_Dealer_DMA_ID,AOPDH_Hospital_ID,AOPDH_Year,
		AOPDH_Amount_1,AOPDH_Amount_2,AOPDH_Amount_3,AOPDH_Amount_4,AOPDH_Amount_5,
		AOPDH_Amount_6,AOPDH_Amount_7,AOPDH_Amount_8,AOPDH_Amount_9,AOPDH_Amount_10,
		AOPDH_Amount_11,AOPDH_Amount_12,AOP.AOPDH_PCT_ID
		FROM [dbo].[V_AOPDealerHospital] AOP
		INNER JOIN V_AllHospitalMarketProperty AMP ON AMP.ProductLineID=AOP.AOPDH_ProductLine_BUM_ID AND AMP.HOS_ID=AOP.AOPDH_Hospital_ID
		WHERE AOPDH_Dealer_DMA_ID=@DMA_ID
		AND AOPDH_ProductLine_BUM_ID =@ProductLineId
		AND AOPDH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure A WHERE A.CC_ID =@CC_ID and (@BeginDate BETWEEN a.StartDate AND A.EndDate))
		AND ISNULL(AMP.MarketProperty,0)=CONVERT(INT ,@MarktType)

		INSERT INTO AOPICDealerHospitalHistory 
		(ADHPH_ID ,[ADHPH_ChangeToContractID] ,[ADHPH_CurrentContractID],[ADHPH_DMA_ID],[ADHPH_HospitalID],ADHPH_PCT_ID,[ADHPH_Year],
		[ADHPH_January],[ADHPH_February],[ADHPH_March] ,[ADHPH_April]     ,[ADHPH_May]    ,
		[ADHPH_June],[ADHPH_July]  ,[ADHPH_August] ,[ADHPH_September] ,[ADHPH_October]
		,[ADHPH_November],[ADHPH_December])
		SELECT NEWID(),@Contract_ID,NULL,AOPICH_DMA_ID,AOPICH_Hospital_ID,AOPICH_PCT_ID,AOPICH_Year,
		AOPICH_Unit_1,AOPICH_Unit_2,AOPICH_Unit_3,AOPICH_Unit_4,AOPICH_Unit_5,
		AOPICH_Unit_6,AOPICH_Unit_7,AOPICH_Unit_8,AOPICH_Unit_9,AOPICH_Unit_10,
		AOPICH_Unit_11,AOPICH_Unit_12
		FROM [dbo].[V_AOPICDealerHospital] AOP
		INNER JOIN V_AllHospitalMarketProperty AMP ON AMP.ProductLineID=AOP.AOPICH_ProductLine_ID AND AMP.HOS_ID=AOP.AOPICH_Hospital_ID
		WHERE AOPICH_DMA_ID=@DMA_ID
		AND AOPICH_ProductLine_ID =@ProductLineId
		AND AOPICH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure A WHERE A.CC_ID =@CC_ID and (@BeginDate BETWEEN a.StartDate AND A.EndDate))
		AND ISNULL(AMP.MarketProperty,0)=CONVERT(INT ,@MarktType)
	END
	UPDATE ContractChangeMapping SET CCM_ChangeToContractID=@Contract_ID
	WHERE CCM_DMA_ID=isnull(@DMA_ID,newid())
	AND  CCM_ChangeToContractID is null;
	
	INSERT INTO ContractChangeMapping (CCM_ID,CCM_DMA_ID,CCM_CurrentContractID,CCM_ChangeToContractID)
	VALUES(NEWID(),isnull(@DMA_ID,newid()),@Contract_ID,NULL);
		

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
	
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	VALUES(NEWID(),@Contract_ID,'00000000-0000-0000-0000-000000000000',GETDATE (),'Failure',@Contract_Type+' 合同 历史数据 同步失败:'+@vError)
	
    return -1
END CATCH
		
		

GO


