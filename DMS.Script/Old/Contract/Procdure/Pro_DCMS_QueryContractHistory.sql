DROP PROCEDURE [Contract].[Pro_DCMS_QueryContractHistory]
GO


/**********************************************
	功能：合同管理-查询历史指标数据
	作者：Huakaichun
	最后更新时间：	2017-08-17
	更新记录说明：
	1.创建 2017-08-17
**********************************************/
CREATE PROCEDURE [Contract].[Pro_DCMS_QueryContractHistory]
	@ContractId NVARCHAR(36),
	@DealerId NVARCHAR(36),
	@SubBU NVARCHAR(50),
	@PropertyType INT 
AS
BEGIN

	DECLARE @LastContractId uniqueidentifier

	CREATE TABLE #ConTol
	(
		ContractId uniqueidentifier,
		DealerId uniqueidentifier,
		SubBU NVARCHAR(50),
		MarketType INT,
		BeginDate DATETIME,
		EndDate DATETIME,
		ContractType NVARCHAR(50),
		UpdateDate DATETIME
	)

	INSERT INTO #ConTol (ContractId,DealerId,MarketType,BeginDate,EndDate,SubBU,ContractType,UpdateDate)
	SELECT a.CAP_ID,a.CAP_DMA_ID,a.CAP_MarketType,CAP_EffectiveDate,CAP_ExpirationDate,a.CAP_SubDepID ,'Appointment',a.CAP_Update_Date from ContractAppointment a where a.CAP_Status='Completed' and a.CAP_DMA_ID=@DealerId and a.CAP_SubDepID=@SubBU 
	UNION
	SELECT a.CAM_ID,a.CAM_DMA_ID,a.CAM_MarketType,CAM_Amendment_EffectiveDate,CAM_Agreement_ExpirationDate,a.CAM_SubDepID,'Amendment',a.CAM_Update_Date from ContractAmendment a where a.CAM_Status='Completed' and (((@PropertyType=0 OR @PropertyType=2) AND a.CAM_Territory_IsChange='1') OR (@PropertyType=1 AND a.CAM_Quota_IsChange='1')) and a.CAM_DMA_ID=@DealerId and a.CAM_SubDepID=@SubBU 
	UNION
	SELECT  a.CRE_ID,a.CRE_DMA_ID,a.CRE_MarketType,CRE_Agrmt_EffectiveDate_Renewal,CRE_Agrmt_ExpirationDate_Renewal,a.CRE_SubDepID,'Renewal',a.CRE_Update_Date  from ContractRenewal a where a.CRE_Status='Completed' and a.CRE_DMA_ID=@DealerId and a.CRE_SubDepID=@SubBU 

	IF  EXISTS(SELECT 1 FROM #ConTol WHERE ContractId=@ContractId)
	BEGIN
		DECLARE @UpdateDate DATETIME
		SELECT @UpdateDate =UpdateDate FROM #ConTol WHERE ContractId=@ContractId;
		SELECT TOP 1 @LastContractId=ContractId FROM #ConTol WHERE CONVERT(NVARCHAR(10),UpdateDate,120) <CONVERT(NVARCHAR(10),@UpdateDate,120)  ORDER BY UpdateDate DESC
	END
	ELSE
	BEGIN
		SELECT TOP 1 @LastContractId=ContractId FROM #ConTol  ORDER BY UpdateDate DESC
	END
	
	SET @LastContractId=ISNULL(@LastContractId,'00000000-0000-0000-0000-000000000000');
	
	
	IF @PropertyType=0
	BEGIN
	
		SELECT C.ProductLineName,--产品线
		SubBUName=(SELECT TOP 1 CC_NameCN FROM INTERFACE.ClassificationContract WHERE CC_Code=@SubBU),--SubBU
		PCTName=(SELECT TOP 1 CA_NameCN FROM INTERFACE.ClassificationAuthorization WHERE CA_ID=a.DAT_PMA_ID),--授权产品分类
		D.HOS_HospitalName,--医院名称
		B.HOS_Depart,--科室
		B.HOS_DepartType,--科室类型
		DP.VALUE1 AS HosDepartTypeName,--科室类型名称
		B.HOS_DepartRemark --科室备注
		FROM DealerAuthorizationTableTemp A 
		INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID
		INNER JOIN V_DivisionProductLineRelation C ON C.ProductLineID=A.DAT_ProductLine_BUM_ID AND C.IsEmerging='0'
		INNER JOIN Hospital D ON D.HOS_ID=B.HOS_ID
		LEFT JOIN Lafite_DICT DP ON DP.DICT_TYPE = 'HospitalDepart' AND CONVERT (NVARCHAR (50),A.DAT_ProductLine_BUM_ID) = DP.PID AND B.HOS_DepartType = DP.DICT_KEY
		WHERE a.DAT_DCL_ID=@LastContractId;
		
	END
	IF @PropertyType=2
	BEGIN
		--区域授权
		SELECT C.ProductLineName,--产品线
		SubBUName=(SELECT TOP 1 CC_NameCN FROM INTERFACE.ClassificationContract WHERE CC_Code=@SubBU),--SubBU
		PCTName=(SELECT TOP 1 CA_NameCN FROM INTERFACE.ClassificationAuthorization WHERE CA_ID=a.DA_PMA_ID), --授权产品分类
		D.TER_Description AS Area --授权区域
		FROM DealerAuthorizationAreaTemp A 
		INNER JOIN TerritoryAreaTemp B ON A.DA_ID=B.TA_DA_ID
		INNER JOIN Territory D ON D.TER_ID=B.TA_Area
		INNER JOIN V_DivisionProductLineRelation C ON C.ProductLineID=A.DA_ProductLine_BUM_ID AND C.IsEmerging='0'
		WHERE A.DA_DCL_ID=@LastContractId
		ORDER BY DA_PMA_ID,TER_Description
		
		SELECT D.ProductLineName, --产品线
		SubBUName=(SELECT TOP 1 CC_NameCN FROM INTERFACE.ClassificationContract WHERE CC_Code=@SubBU),--SubBU
		PCTName=(SELECT TOP 1 CA_NameCN FROM INTERFACE.ClassificationAuthorization WHERE CA_ID=a.DA_PMA_ID),--授权产品分类
		HospitalCode=c.HOS_Key_Account, --排除医院编号
		HospitalName=C.HOS_HospitalName --排除医院名称
		FROM DealerAuthorizationAreaTemp A 
		INNER JOIN TerritoryAreaExcTemp B ON A.DA_ID=B.TAE_DA_ID
		INNER JOIN V_DivisionProductLineRelation D ON D.ProductLineID=A.DA_ProductLine_BUM_ID AND D.IsEmerging='0'
		INNER JOIN Hospital C ON C.HOS_ID=B.TAE_HOS_ID
		WHERE A.DA_DCL_ID=@LastContractId
		
	END
	IF @PropertyType=1
	BEGIN
		--医院指标
		SELECT 
		c.CQ_Code ProductCode,--产品分类编号
		c.CQ_NameCN as ProductName,--产品分类名称
		b.HOS_Key_Account as HospitalCode ,--医院编号
		b.HOS_HospitalName AS HospitalName,--医院名称
		a.AOPDH_Year [Year],--指标年份
		a.AOPDH_Amount_1,--1月指标
		a.AOPDH_Amount_2,a.AOPDH_Amount_3,a.AOPDH_Amount_4,a.AOPDH_Amount_5,a.AOPDH_Amount_6,a.AOPDH_Amount_7,a.AOPDH_Amount_8,a.AOPDH_Amount_9,a.AOPDH_Amount_10,a.AOPDH_Amount_11,a.AOPDH_Amount_12,
		a.AOPDH_Amount_Y --全年指标
		FROM V_AOPDealerHospital_Temp a 
		INNER JOIN Hospital B ON B.HOS_ID=A.AOPDH_Hospital_ID
		INNER JOIN (SELECT distinct CQ_ID,CQ_NameCN,CQ_Code FROM interface.ClassificationQuota) c on c.CQ_ID=a.AOPDH_PCT_ID
		WHERE A.AOPDH_Contract_ID=@LastContractId
		
		--经销商指标
		SELECT 
		C.ProductLineName,--产品线
		B.CC_Code AS SubBUCode,--SubBU编号
		B.CC_NameCN AS SubBUName,--SubBU名称
		a.AOPD_Year AS [Year],--指标年份
		A.AOPD_Amount_1,--1月指标
		A.AOPD_Amount_2 ,A.AOPD_Amount_3,A.AOPD_Amount_4,A.AOPD_Amount_5,A.AOPD_Amount_6,A.AOPD_Amount_7,A.AOPD_Amount_8,A.AOPD_Amount_9,A.AOPD_Amount_10,A.AOPD_Amount_11,A.AOPD_Amount_12,
		A.AOPD_Amount_Y --全年指标
		FROM V_AOPDealer_Temp A 
		INNER JOIN interface.ClassificationContract B ON A.AOPD_CC_ID=B.CC_ID
		INNER JOIN V_DivisionProductLineRelation C ON C.ProductLineID=A.AOPD_ProductLine_BUM_ID AND C.IsEmerging='0'
		WHERE A.AOPD_Contract_ID=@LastContractId
		
	END
	
END  

GO


