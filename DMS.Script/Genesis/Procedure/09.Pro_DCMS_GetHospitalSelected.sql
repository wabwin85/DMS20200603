USE [GenesisDMS_Test]
GO
/****** Object:  StoredProcedure [dbo].[Pro_DCMS_GetHospitalSelected]    Script Date: 2019/10/11 10:19:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************
	功能：获取产品所对应授权医院
	作者：Huakaichun
	最后更新时间：	2016-06-14
	更新记录说明：
	1.创建 2016-06-14
**********************************************/
ALTER PROCEDURE [dbo].[Pro_DCMS_GetHospitalSelected]
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
			--判断医院是否重复授权
			CASE (select Count(_E.HOS_ID)  FROM ContractTerritory _E
			INNER JOIN DealerAuthorizationTableTemp _D ON _D.DAT_ID=_E.Contract_ID
			INNER JOIN [Contract].AppointmentMain am ON am.ContractId =_D.DAT_DCL_ID
			INNER JOIN [Contract].AppointmentProposals ap ON ap.ContractId = _D.DAT_DCL_ID
			where am.ContractStatus<>'Draft' and am.ContractStatus<>'Delete' --状态不是草稿或删除
			AND _E.Contract_ID<>E.Contract_ID                                --不是当前合同
			AND _E.HOS_ID=E.Hos_ID                                           --同一家医院其它合同还有授权
			AND not (ap.AgreementBegin>@EndDate
			OR ap.AgreementEnd<@BeginDate)) WHEN 0 then '否' else '是' end as IsMustFill,
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


