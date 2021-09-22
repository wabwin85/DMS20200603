DROP PROCEDURE [Contract].[Pro_DCMS_QueryContractHistory]
GO


/**********************************************
	���ܣ���ͬ����-��ѯ��ʷָ������
	���ߣ�Huakaichun
	������ʱ�䣺	2017-08-17
	���¼�¼˵����
	1.���� 2017-08-17
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
	
		SELECT C.ProductLineName,--��Ʒ��
		SubBUName=(SELECT TOP 1 CC_NameCN FROM INTERFACE.ClassificationContract WHERE CC_Code=@SubBU),--SubBU
		PCTName=(SELECT TOP 1 CA_NameCN FROM INTERFACE.ClassificationAuthorization WHERE CA_ID=a.DAT_PMA_ID),--��Ȩ��Ʒ����
		D.HOS_HospitalName,--ҽԺ����
		B.HOS_Depart,--����
		B.HOS_DepartType,--��������
		DP.VALUE1 AS HosDepartTypeName,--������������
		B.HOS_DepartRemark --���ұ�ע
		FROM DealerAuthorizationTableTemp A 
		INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID
		INNER JOIN V_DivisionProductLineRelation C ON C.ProductLineID=A.DAT_ProductLine_BUM_ID AND C.IsEmerging='0'
		INNER JOIN Hospital D ON D.HOS_ID=B.HOS_ID
		LEFT JOIN Lafite_DICT DP ON DP.DICT_TYPE = 'HospitalDepart' AND CONVERT (NVARCHAR (50),A.DAT_ProductLine_BUM_ID) = DP.PID AND B.HOS_DepartType = DP.DICT_KEY
		WHERE a.DAT_DCL_ID=@LastContractId;
		
	END
	IF @PropertyType=2
	BEGIN
		--������Ȩ
		SELECT C.ProductLineName,--��Ʒ��
		SubBUName=(SELECT TOP 1 CC_NameCN FROM INTERFACE.ClassificationContract WHERE CC_Code=@SubBU),--SubBU
		PCTName=(SELECT TOP 1 CA_NameCN FROM INTERFACE.ClassificationAuthorization WHERE CA_ID=a.DA_PMA_ID), --��Ȩ��Ʒ����
		D.TER_Description AS Area --��Ȩ����
		FROM DealerAuthorizationAreaTemp A 
		INNER JOIN TerritoryAreaTemp B ON A.DA_ID=B.TA_DA_ID
		INNER JOIN Territory D ON D.TER_ID=B.TA_Area
		INNER JOIN V_DivisionProductLineRelation C ON C.ProductLineID=A.DA_ProductLine_BUM_ID AND C.IsEmerging='0'
		WHERE A.DA_DCL_ID=@LastContractId
		ORDER BY DA_PMA_ID,TER_Description
		
		SELECT D.ProductLineName, --��Ʒ��
		SubBUName=(SELECT TOP 1 CC_NameCN FROM INTERFACE.ClassificationContract WHERE CC_Code=@SubBU),--SubBU
		PCTName=(SELECT TOP 1 CA_NameCN FROM INTERFACE.ClassificationAuthorization WHERE CA_ID=a.DA_PMA_ID),--��Ȩ��Ʒ����
		HospitalCode=c.HOS_Key_Account, --�ų�ҽԺ���
		HospitalName=C.HOS_HospitalName --�ų�ҽԺ����
		FROM DealerAuthorizationAreaTemp A 
		INNER JOIN TerritoryAreaExcTemp B ON A.DA_ID=B.TAE_DA_ID
		INNER JOIN V_DivisionProductLineRelation D ON D.ProductLineID=A.DA_ProductLine_BUM_ID AND D.IsEmerging='0'
		INNER JOIN Hospital C ON C.HOS_ID=B.TAE_HOS_ID
		WHERE A.DA_DCL_ID=@LastContractId
		
	END
	IF @PropertyType=1
	BEGIN
		--ҽԺָ��
		SELECT 
		c.CQ_Code ProductCode,--��Ʒ������
		c.CQ_NameCN as ProductName,--��Ʒ��������
		b.HOS_Key_Account as HospitalCode ,--ҽԺ���
		b.HOS_HospitalName AS HospitalName,--ҽԺ����
		a.AOPDH_Year [Year],--ָ�����
		a.AOPDH_Amount_1,--1��ָ��
		a.AOPDH_Amount_2,a.AOPDH_Amount_3,a.AOPDH_Amount_4,a.AOPDH_Amount_5,a.AOPDH_Amount_6,a.AOPDH_Amount_7,a.AOPDH_Amount_8,a.AOPDH_Amount_9,a.AOPDH_Amount_10,a.AOPDH_Amount_11,a.AOPDH_Amount_12,
		a.AOPDH_Amount_Y --ȫ��ָ��
		FROM V_AOPDealerHospital_Temp a 
		INNER JOIN Hospital B ON B.HOS_ID=A.AOPDH_Hospital_ID
		INNER JOIN (SELECT distinct CQ_ID,CQ_NameCN,CQ_Code FROM interface.ClassificationQuota) c on c.CQ_ID=a.AOPDH_PCT_ID
		WHERE A.AOPDH_Contract_ID=@LastContractId
		
		--������ָ��
		SELECT 
		C.ProductLineName,--��Ʒ��
		B.CC_Code AS SubBUCode,--SubBU���
		B.CC_NameCN AS SubBUName,--SubBU����
		a.AOPD_Year AS [Year],--ָ�����
		A.AOPD_Amount_1,--1��ָ��
		A.AOPD_Amount_2 ,A.AOPD_Amount_3,A.AOPD_Amount_4,A.AOPD_Amount_5,A.AOPD_Amount_6,A.AOPD_Amount_7,A.AOPD_Amount_8,A.AOPD_Amount_9,A.AOPD_Amount_10,A.AOPD_Amount_11,A.AOPD_Amount_12,
		A.AOPD_Amount_Y --ȫ��ָ��
		FROM V_AOPDealer_Temp A 
		INNER JOIN interface.ClassificationContract B ON A.AOPD_CC_ID=B.CC_ID
		INNER JOIN V_DivisionProductLineRelation C ON C.ProductLineID=A.AOPD_ProductLine_BUM_ID AND C.IsEmerging='0'
		WHERE A.AOPD_Contract_ID=@LastContractId
		
	END
	
END  

GO


