DROP PROCEDURE [Contract].[Pro_DCMS_QueryContractAuthorization]
GO

/**********************************************
	���ܣ���ͬ����-��Ȩ
	���ߣ�Huakaichun
	������ʱ�䣺	2017-08-15
	���¼�¼˵����
	1.���� 2017-08-15
**********************************************/
CREATE PROCEDURE [Contract].[Pro_DCMS_QueryContractAuthorization]
	@ContractId NVARCHAR(36),
	@DealerId NVARCHAR(36),
	@ProductLineId NVARCHAR(36),
	@SubBU NVARCHAR(50),
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@PropertyType NVARCHAR(50) --0,1: 0 ҽԺ��Ȩ��1 ʡ����Ȩ
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
	--��ȡ��Ȩ��Ϣ
	Create Table #DealerAuthorization(
		ProductName NVARCHAR(200),
		SubBUName NVARCHAR(200),
		PCTId uniqueidentifier,
		PCTName NVARCHAR(200),
		HospitalId uniqueidentifier,
		HospitalName NVARCHAR(200),
		Depart NVARCHAR(200),
		DepartType NVARCHAR(200),
		DepartRemark NVARCHAR(200),
		HosDepartTypeName NVARCHAR(200),
		IsNew NVARCHAR(200)
	)
	
		
	CREATE TABLE #TerritoryTempString(
		PMA_ID NVARCHAR(36),
		HOS_ID NVARCHAR(36),
		DealerName NVARCHAR(max)
	)
	
	INSERT INTO #DealerAuthorization (ProductName,SubBUName,PCTId,PCTName,HospitalId,HospitalName,Depart,DepartType,HosDepartTypeName,DepartRemark,IsNew)
	SELECT C.ProductLineName,
	SubBUName=(SELECT TOP 1 CC_NameCN FROM INTERFACE.ClassificationContract WHERE CC_Code=@SubBU),
	PCTId=DAT_PMA_ID,
	PCTName=(SELECT TOP 1 CA_NameCN FROM INTERFACE.ClassificationAuthorization WHERE CA_ID=a.DAT_PMA_ID),
	D.HOS_ID,
	D.HOS_HospitalName,
	B.HOS_Depart,
	B.HOS_DepartType,
	DP.VALUE1 AS HosDepartTypeName,
	B.HOS_DepartRemark,
	B.Territory_Type
	FROM DealerAuthorizationTableTemp A 
	INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID
	INNER JOIN V_DivisionProductLineRelation C ON C.ProductLineID=A.DAT_ProductLine_BUM_ID AND C.IsEmerging='0'
	INNER JOIN Hospital D ON D.HOS_ID=B.HOS_ID
	LEFT JOIN Lafite_DICT DP ON DP.DICT_TYPE = 'HospitalDepart' AND CONVERT (NVARCHAR (50),A.DAT_ProductLine_BUM_ID) = DP.PID AND B.HOS_DepartType = DP.DICT_KEY
	WHERE a.DAT_DCL_ID=@ContractId;
	
	--ʱ����ܽϳ�
	SELECT DISTINCT A.DAT_PMA_ID as PMA_ID,B.HLA_HOS_ID AS HOS_ID,C.DMA_ChineseName AS DealerName
	INTO #ReTableDealer
	FROM DealerAuthorizationTable A 
	INNER JOIN HospitalList B ON A.DAT_ID=B.HLA_DAT_ID 
	INNER JOIN DealerMaster C ON C.DMA_ID=A.DAT_DMA_ID 
	WHERE A.DAT_Type='Normal'
	AND C.DMA_DealerType<>'LP'
	AND C.DMA_ID <>@DealerId
	AND exists(select 1 from DealerAuthorizationTableTemp e where e.DAT_DCL_ID=@ContractId and a.DAT_PMA_ID=e.DAT_PMA_ID)
	AND ((CONVERT(NVARCHAR(10),B.HLA_StartDate,112)>=CONVERT(NVARCHAR(10),@BeginDate,112) 
			AND  CONVERT(NVARCHAR(10),B.HLA_StartDate,112)<=CONVERT(NVARCHAR(10),@EndDate,112)) 
		OR (CONVERT(NVARCHAR(10),B.HLA_StartDate,112)<CONVERT(NVARCHAR(10),@BeginDate,112) 
			AND  CONVERT(NVARCHAR(10),B.HLA_EndDate,112)>=CONVERT(NVARCHAR(10),@BeginDate,112)))
	
	
	INSERT #TerritoryTempString(PMA_ID,HOS_ID,DealerName)	
	SELECT 	t1.PMA_ID,t1.HOS_ID,[DealerName] =STUFF (
			(SELECT ',' + tt1.DealerName FROM #ReTableDealer tt1 WHERE t1.PMA_ID =tt1.PMA_ID	AND t1.HOS_ID = tt1.HOS_ID
			FOR XML PATH ( '' )),1,1,'')
	FROM	#ReTableDealer t1
	GROUP BY t1.HOS_ID,t1.PMA_ID
	
	--1.0��ȨҽԺ��ѯ�б�
	SELECT ProductName, --��Ʒ��
			SubBUName,	--SuBU
			PCTId,		--��Ȩ����ID
			PCTName,	--��Ȩ��������
			HospitalId AS HosId, --ҽԺID
			d.HOS_HospitalShortName AS HosHospitalShortName, --ҽԺ����  
			d.HOS_HospitalName AS HosHospitalName, --ҽԺ����
			d.HOS_Grade AS HosGrade,--ҽԺ�ȼ�
			d.HOS_Key_Account AS HosKeyAccount,--ҽԺ���
			d.HOS_Province AS HosProvince,--ʡ��
			d.HOS_City AS HosCity,--����
			d.HOS_District AS HosDistrict,--����
			Depart AS HosDepart,--����
			DepartType AS HosDepartType,--��������
			HosDepartTypeName AS HosDepartTypeName,--������������
			DepartRemark AS HosDepartRemark,--���ұ�ע
			
			IsNew AS OperType,--��Ȩ��ʶ��1 ����ҽԺ��Ȩ
			CASE WHEN ISNULL(B.DealerName,'')='' THEN '0' ELSE '1' END AS TCount,--�Ƿ�����ظ���Ȩ
			B.DealerName AS DealerString    --�ظ���Ȩ������
			,row_number ()  OVER (ORDER BY  a.PCTName,a.HospitalName  ASC) AS [row_number]
	FROM #DealerAuthorization A
	inner join Hospital d on d.HOS_ID=a.HospitalId
	LEFT JOIN #TerritoryTempString B ON A.PCTId=B.PMA_ID AND A.HospitalId=B.HOS_ID 
	
	--2.0��ֹ��Ȩ��ҽԺ����Ʒ
	SELECT 
	PCTName=(SELECT TOP 1 CA_NameCN FROM INTERFACE.ClassificationAuthorization WHERE CA_ID=a.DAT_PMA_ID) --��Ȩ��Ʒ����
	,c.HOS_HospitalName AS HospitalName --��ȨҽԺ����
	FROM DealerAuthorizationTableTemp A 
	INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID
	INNER JOIN Hospital C ON C.HOS_ID=B.HOS_ID
	WHERE A.DAT_DCL_ID=@LastContractId
	AND NOT EXISTS (SELECT 1 FROM DealerAuthorizationTableTemp E 
		INNER JOIN ContractTerritory F  ON E.DAT_ID=F.Contract_ID AND E.DAT_DCL_ID=@ContractId 
		AND B.HOS_ID=F.HOS_ID and a.DAT_PMA_ID=e.DAT_PMA_ID)

END
ELSE IF @PropertyType=1
BEGIN
	--3.0��Ʒ��Ȩ����
	SELECT PCTName=(SELECT TOP 1 CA_NameCN FROM INTERFACE.ClassificationAuthorization WHERE CA_ID=a.DA_PMA_ID)--��Ȩ��Ʒ����
	,DA_ID --ID
	,C.ProductLineName --��Ȩ��Ʒ�� 
	,d.TER_Description AS Area  --��Ȩ����
	FROM DealerAuthorizationAreaTemp A
	INNER JOIN TerritoryAreaTemp B ON A.DA_ID=B.TA_DA_ID
	INNER JOIN V_DivisionProductLineRelation C ON C.ProductLineID=A.DA_ProductLine_BUM_ID AND C.IsEmerging='0'
	INNER JOIN Territory d on d.TER_ID=b.TA_Area
	WHERE A.DA_DCL_ID=@ContractId
	
	--4.0�ų�ҽԺ
	SELECT 
	C.HOS_ID AS HosId, --ҽԺID
	C.HOS_HospitalShortName AS HosHospitalShortName,--ҽԺ����  
	C.HOS_HospitalName AS HosHospitalName,--ҽԺ����
	C.HOS_Grade AS HosGrade,--ҽԺ�ȼ�
	C.HOS_Key_Account AS HosKeyAccount,--ҽԺ���
	C.HOS_Province AS HosProvince,--ʡ��
	C.HOS_City AS HosCity,--����
	C.HOS_District AS HosDistrict --����
	FROM DealerAuthorizationAreaTemp A
	INNER JOIN TerritoryAreaExcTemp B ON A.DA_ID=B.TAE_DA_ID
	INNER JOIN Hospital C ON C.HOS_ID=B.TAE_HOS_ID
	WHERE A.DA_DCL_ID=@ContractId
END


END  

GO


