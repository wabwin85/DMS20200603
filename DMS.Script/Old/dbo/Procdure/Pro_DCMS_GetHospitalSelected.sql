DROP PROCEDURE [dbo].[Pro_DCMS_GetHospitalSelected]
GO


/**********************************************
	���ܣ���ȡ��Ʒ����Ӧ��ȨҽԺ
	���ߣ�Huakaichun
	������ʱ�䣺	2016-06-14
	���¼�¼˵����
	1.���� 2016-06-14
**********************************************/
CREATE PROCEDURE [dbo].[Pro_DCMS_GetHospitalSelected]
	@ContractId NVARCHAR(36),
	@DealerId NVARCHAR(36),
	@DctId NVARCHAR(36),
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@PageNum INT,
	@PageSize INT
AS
BEGIN

	DECLARE @PmaId uniqueidentifier 
	
	CREATE TABLE #TerritoryTemp(
		PMA_ID NVARCHAR(36),
		HOS_ID NVARCHAR(36),
		DealerName NVARCHAR(36)
	)
	
	CREATE TABLE #TerritoryTempString(
		PMA_ID NVARCHAR(36),
		HOS_ID NVARCHAR(36),
		DealerName NVARCHAR(max)
	)
	
	CREATE TABLE #ReturnTerritory(
		Id uniqueidentifier,
		HosId NVARCHAR(36),
		HosHospitalShortName NVARCHAR(200),
		HosHospitalName NVARCHAR(200),
		HosGrade NVARCHAR(200),
		HosKeyAccount NVARCHAR(200),
		HosProvince NVARCHAR(200),
		HosCity NVARCHAR(200),
		HosDistrict NVARCHAR(200),
		HosDepart NVARCHAR(200),
		HosDepartType  NVARCHAR(200),
		HosDepartTypeName NVARCHAR(200),
		HosDepartRemark NVARCHAR(200),
		OperType NVARCHAR(200),
		TCount	int,
		RepeatDealer NVARCHAR(2000),
		HospitalCount NVARCHAR(200),
		ROWNUMBER   INT,
		PRIMARY KEY(ROWNUMBER)
	)
	
	SELECT @PmaId=A.DAT_PMA_ID FROM DealerAuthorizationTableTemp A WHERE A.DAT_ID= @DctId AND A.DAT_DCL_ID=@ContractId
	
	INSERT INTO #TerritoryTemp(PMA_ID,HOS_ID,DealerName)
	SELECT DISTINCT A.DAT_PMA_ID,B.HLA_HOS_ID,C.DMA_ChineseName AS DealerName
	FROM DealerAuthorizationTable A 
	INNER JOIN HospitalList B ON A.DAT_ID=B.HLA_DAT_ID 
	INNER JOIN DealerMaster C ON C.DMA_ID=A.DAT_DMA_ID 
	WHERE A.DAT_Type='Normal'
	AND C.DMA_DealerType<>'LP'
	AND C.DMA_ID <>@DealerId
	AND A.DAT_PMA_ID=@PmaId
	AND ((CONVERT(NVARCHAR(10),B.HLA_StartDate,112)>=CONVERT(NVARCHAR(10),@BeginDate,112) 
			AND  CONVERT(NVARCHAR(10),B.HLA_StartDate,112)<=CONVERT(NVARCHAR(10),@EndDate,112)) 
		OR (CONVERT(NVARCHAR(10),B.HLA_StartDate,112)<CONVERT(NVARCHAR(10),@BeginDate,112) 
			AND  CONVERT(NVARCHAR(10),B.HLA_EndDate,112)>=CONVERT(NVARCHAR(10),@BeginDate,112)))
		
	INSERT #TerritoryTempString(PMA_ID,HOS_ID,DealerName)	
	SELECT 	t1.PMA_ID,t1.HOS_ID,[DealerName] =STUFF (
			(SELECT ',' + tt1.DealerName FROM #TerritoryTemp tt1 WHERE t1.PMA_ID =tt1.PMA_ID	AND t1.HOS_ID = tt1.HOS_ID
			FOR XML PATH ( '' )),1,1,'')
	FROM	#TerritoryTemp t1
	GROUP BY t1.HOS_ID,t1.PMA_ID
	
	INSERT INTO #ReturnTerritory(Id,HosId,HosHospitalShortName,HosHospitalName,HosGrade,HosKeyAccount,HosProvince,HosCity,HosDistrict,
	HosDepart,HosDepartType,HosDepartTypeName,HosDepartRemark,
	OperType,TCount,RepeatDealer,HospitalCount,ROWNUMBER)
	SELECT 
			E.ID AS Id,
			F.HOS_ID AS HosId,
			F.HOS_HospitalShortName AS HosHospitalShortName,  
			F.HOS_HospitalName AS HosHospitalName,
			F.HOS_Grade AS HosGrade,
			F.HOS_Key_Account AS HosKeyAccount,
			F.HOS_Province AS HosProvince,
			F.HOS_City AS HosCity,
			F.HOS_District AS HosDistrict,
			E.HOS_Depart AS HosDepart,
			E.HOS_DepartType AS HosDepartType,
			DP.VALUE1 AS HosDepartTypeName,
			E.HOS_DepartRemark AS HosDepartRemark,
			
			E.Territory_Type AS OperType,
			CASE WHEN ISNULL(ST.DealerName,'')='' THEN '0' ELSE '1' END AS TCount,
			ST.DealerName AS RepeatDealer,
			NULL,
			row_number () OVER (ORDER BY F.HOS_ID ASC)
		FROM DealerAuthorizationTableTemp D
		INNER JOIN ContractTerritory E ON D.DAT_ID=E.Contract_ID
		INNER JOIN Hospital F ON E.HOS_ID= F.HOS_ID
		LEFT JOIN Lafite_DICT DP ON DP.DICT_TYPE = 'HospitalDepart' AND CONVERT (NVARCHAR (50),D.DAT_ProductLine_BUM_ID) = DP.PID AND E.HOS_DepartType = DP.DICT_KEY
		LEFT JOIN #TerritoryTempString ST ON ST.PMA_ID=D.DAT_PMA_ID AND ST.HOS_ID= E.HOS_ID
		WHERE D.DAT_DCL_ID= @ContractId
		AND D.DAT_ID=@DctId


	SELECT COUNT(*) CNT FROM #ReturnTerritory;
	
	SELECT A.Id,A.HosId,A.HosHospitalShortName,A.HosHospitalName,A.HosGrade,A.HosKeyAccount,A.HosProvince,A.HosCity,A.HosDistrict,A.HosDepart,A.HosDepartType,A.HosDepartTypeName,A.HosDepartRemark,A.OperType,A.HospitalCount,A.TCount,A.RepeatDealer,A.ROWNUMBER
	FROM   #ReturnTerritory  A
	WHERE  ROWNUMBER  BETWEEN @PageSize * @PageNum + 1 AND @PageSize * (@PageNum+1);
	
	SELECT TOP 1 CA_NameCN AS ProductName FROM INTERFACE.ClassificationAuthorization A WHERE A.CA_ID=@PmaId AND @BeginDate between CA_StartDate and CA_EndDate;
END  



GO


