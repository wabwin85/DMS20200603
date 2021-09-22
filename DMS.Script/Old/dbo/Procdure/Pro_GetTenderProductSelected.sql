DROP PROCEDURE [dbo].[Pro_GetTenderProductSelected]
GO


/**********************************************
	功能：获取设备招标授权书授权产品
	作者：Huakaichun
	最后更新时间：	2016-06-14
	更新记录说明：
	1.创建 2016-06-14
**********************************************/
CREATE PROCEDURE [dbo].[Pro_GetTenderProductSelected]
	@DtmId NVARCHAR(36),
	@DthId NVARCHAR(36),
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@OperType NVARCHAR(10),
	@PageNum INT,
	@PageSize INT
AS
BEGIN

	DECLARE @HospitalId uniqueidentifier 
	
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
		TCount	int,
		RepeatDealer NVARCHAR(2000),
		SubProductName NVARCHAR(200),
		ROWNUMBER   INT,
		PRIMARY KEY(ROWNUMBER)
	)
	IF @DthId='00000000-0000-0000-0000-000000000000'
	BEGIN
		SET @HospitalId='00000000-0000-0000-0000-000000000000'
	END
	ELSE
	BEGIN
		SELECT @HospitalId=A.DTH_HospitalId FROM AuthorizationTenderHospital A WHERE A.DTH_ID=@DthId
	END
	INSERT INTO #TerritoryTemp(PMA_ID,HOS_ID,DealerName)
	SELECT c.DTP_PMA_ID,b.DTH_HospitalId,a.DTM_DealerName 
	FROM dbo.AuthorizationTenderMain A
	INNER JOIN AuthorizationTenderHospital B ON A.DTM_ID=B.DTH_DTM_ID
	INNER JOIN AuthorizationTenderProduct C ON C.DTP_DTH_ID=B.DTH_ID
	WHERE A.DTM_ID<>@DtmId
	AND (B.DTH_HospitalId=@HospitalId OR @HospitalId='00000000-0000-0000-0000-000000000000')
	AND ((CONVERT(NVARCHAR(10),A.DTM_BeginDate,112)>=CONVERT(NVARCHAR(10),@BeginDate,112) 
			AND  CONVERT(NVARCHAR(10),A.DTM_BeginDate,112)<=CONVERT(NVARCHAR(10),@EndDate,112)) 
		OR (CONVERT(NVARCHAR(10),A.DTM_BeginDate,112)<CONVERT(NVARCHAR(10),@BeginDate,112) 
			AND  CONVERT(NVARCHAR(10),a.DTM_EndDate,112)>=CONVERT(NVARCHAR(10),@BeginDate,112)))
	AND A.DTM_States IN ('InApproval','Approved')
		
	INSERT #TerritoryTempString(PMA_ID,HOS_ID,DealerName)	
	SELECT 	t1.PMA_ID,t1.HOS_ID,[DealerName] =STUFF (
			(SELECT ',' + tt1.DealerName FROM #TerritoryTemp tt1 WHERE t1.PMA_ID =tt1.PMA_ID	AND t1.HOS_ID = tt1.HOS_ID
			FOR XML PATH ( '' )),1,1,'')
	FROM	#TerritoryTemp t1
	GROUP BY t1.HOS_ID,t1.PMA_ID
	
	INSERT INTO #ReturnTerritory(Id,HosId,HosHospitalShortName,HosHospitalName,HosGrade,HosKeyAccount,HosProvince,HosCity,HosDistrict,
	HosDepart,TCount,RepeatDealer,SubProductName ,ROWNUMBER)
	SELECT 
			C.DTP_ID AS Id,
			F.HOS_ID AS HosId,
			F.HOS_HospitalShortName AS HosHospitalShortName,  
			F.HOS_HospitalName AS HosHospitalName,
			F.HOS_Grade AS HosGrade,
			F.HOS_Key_Account AS HosKeyAccount,
			F.HOS_Province AS HosProvince,
			F.HOS_City AS HosCity,
			F.HOS_District AS HosDistrict,
			C.DTP_Remark1 AS HosDepart,
			CASE WHEN ISNULL(ST.DealerName,'')='' THEN '0' ELSE '1' END AS TCount,
			ST.DealerName AS RepeatDealer,
			G.CA_NameCN,
			row_number () OVER (ORDER BY C.DTP_PMA_ID ASC)
		FROM dbo.AuthorizationTenderMain A
		INNER JOIN AuthorizationTenderHospital B ON A.DTM_ID=B.DTH_DTM_ID
		INNER JOIN AuthorizationTenderProduct C ON C.DTP_DTH_ID=B.DTH_ID
		INNER JOIN Hospital F ON B.DTH_HospitalId= F.HOS_ID
		INNER JOIN  (SELECT DISTINCT CA_ID,CA_Code,CA_NameCN FROM INTERFACE.ClassificationAuthorization) G ON G.CA_ID=C.DTP_PMA_ID
		LEFT JOIN #TerritoryTempString ST ON ST.PMA_ID=C.DTP_PMA_ID AND ST.HOS_ID=B.DTH_HospitalId
		WHERE A.DTM_ID= @DtmId
		AND (B.DTH_ID=@DthId OR (@DthId='00000000-0000-0000-0000-000000000000' and a.DTM_ID=@DtmId ))


	IF(@OperType = 'Query')
		BEGIN
			SELECT COUNT(*) CNT FROM #ReturnTerritory;
	
			SELECT A.Id,A.HosId,A.HosHospitalShortName,A.HosHospitalName,A.HosGrade,A.HosKeyAccount,A.HosProvince,A.HosCity,A.HosDistrict,A.HosDepart,A.TCount,A.RepeatDealer,a.SubProductName,A.ROWNUMBER
			FROM   #ReturnTerritory  A
			WHERE  ROWNUMBER  BETWEEN @PageSize * @PageNum + 1 AND @PageSize * (@PageNum+1);
		END
	ELSE
		BEGIN
			SELECT A.Id,A.HosId,A.HosHospitalShortName,A.HosHospitalName,A.HosGrade,A.HosKeyAccount,A.HosProvince,A.HosCity,A.HosDistrict,A.HosDepart,A.TCount,A.RepeatDealer,a.SubProductName,A.ROWNUMBER
			FROM   #ReturnTerritory  A
		END
	
END  



GO


