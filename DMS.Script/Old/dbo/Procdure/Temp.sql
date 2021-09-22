
DROP Procedure [dbo].[Temp]
GO


CREATE Procedure [dbo].[Temp]
	@ContractId	NVARCHAR(36) ,
	@DealerId	NVARCHAR(36) ,
	@PartsContractCode	NVARCHAR(100),
	@BRType NVARCHAR(20),
	
	@PageNum INT,
	@PageSize INT
	
	
AS
	CREATE TABLE #TerritoryTemp(
		DMA_ID NVARCHAR(36),
		DAT_ProductLine_BUM_ID NVARCHAR(36),
		CA_ID NVARCHAR(36),
		CA_Code NVARCHAR(36),
		HLA_HOS_ID NVARCHAR(36)
	)
	
	CREATE TABLE #ReturnTerritory(
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
		RepeatDealer NVARCHAR(max),
		HospitalCount NVARCHAR(200),
	)
	
	CREATE TABLE #ReturnTerritory2(
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
	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

	DECLARE @HospitalCount INT;
	
	SELECT @HospitalCount=COUNT(*) FROM (
	SELECT  DISTINCT B.HOS_ID FROM DealerAuthorizationTableTemp A INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID
	WHERE A.DAT_DCL_ID=@ContractId
	) TAB 
	
	IF @BRType='BR'
	BEGIN
		INSERT INTO #TerritoryTemp (DMA_ID,DAT_ProductLine_BUM_ID,CA_ID,CA_Code,HLA_HOS_ID)
		SELECT DISTINCT DMA_ID,DAT_ProductLine_BUM_ID,CA_ID,CA_Code,HLA_HOS_ID
		FROM V_DealerAuthorizationBR WHERE CA_ID IN ( SELECT distinct CA_ID FROM interface.ClassificationAuthorization) and CC_Code =@PartsContractCode;
		
		
		INSERT INTO #ReturnTerritory (HosId,HosHospitalShortName ,HosHospitalName,HosGrade ,
		HosKeyAccount ,HosProvince ,HosCity ,HosDistrict ,HosDepart ,HosDepartType  ,HosDepartTypeName ,HosDepartRemark ,OperType ,TCount	,RepeatDealer,HospitalCount )
		SELECT
		   HosId,
		   HosHospitalShortName,
		   HosHospitalName,
		   HosGrade,
		   HosKeyAccount,
		   HosProvince,
		   HosCity,
		   HosDistrict,
		   ISNULL (HosDepart, '') AS HosDepart,
		   ISNULL (HosDepartType, '') AS HosDepartType,
		   ISNULL (HosDepartTypeName, '') AS HosDepartTypeName,
		   ISNULL (HosDepartRemark, '') AS HosDepartRemark,
		   OperType,
		   CASE WHEN ISNULL (bTable.DealerName, '') = '' THEN 0 ELSE 1 END TCount,
		   bTable.DealerName AS RepeatDealer,
		   @HospitalCount AS HospitalCount
	  FROM    (SELECT DISTINCT dat.DAT_DMA_ID,
					  hos.HOS_ID AS HosId,
					  hos.HOS_HospitalShortName AS HosHospitalShortName,
					  hos.HOS_HospitalName AS HosHospitalName,
					  hos.HOS_Grade AS HosGrade,
					  hos.HOS_Key_Account AS HosKeyAccount,
					  hos.HOS_Province AS HosProvince,
					  hos.HOS_City AS HosCity,
					  hos.HOS_District AS HosDistrict,
					  --@PartsContractCode CC_Code,
					  ca.CA_Code AS CA_Code,
					  dat.DAT_ProductLine_BUM_ID,
					  cont.Territory_Type AS OperType,
					  cont.HOS_Depart AS HosDepart,
					  cont.HOS_DepartType AS HosDepartType,
					  dst.VALUE1 AS HosDepartTypeName,
					  cont.HOS_DepartRemark AS HosDepartRemark
				 FROM Hospital hos
					  INNER JOIN dbo.ContractTerritory cont
						 ON hos.HOS_ID = cont.HOS_ID
					  INNER JOIN dbo.DealerAuthorizationTableTemp dat
						 ON dat.DAT_ID = cont.Contract_ID
					  INNER JOIN (select distinct CA_ID,CA_Code from interface.ClassificationAuthorization) ca on ca.CA_ID=dat.DAT_PMA_ID
					  LEFT JOIN Lafite_DICT dst
						 ON     dst.DICT_TYPE = 'HospitalDepart'
							AND CONVERT (NVARCHAR (50),
										 dat.DAT_ProductLine_BUM_ID) = dst.PID
							AND cont.HOS_DepartType = dst.DICT_KEY
				WHERE dat.DAT_DCL_ID = @ContractId) aTable
		   LEFT JOIN
			  (SELECT t1.DAT_ProductLine_BUM_ID,
					  t1.CA_Code,
					  t1.CA_ID,
					  t1.HLA_HOS_ID,
					  [DealerName] =
						 STUFF (
							(SELECT ',' + tt2.[DMA_ChineseName]
							   FROM #TerritoryTemp tt1, DealerMaster tt2
							  WHERE     tt1.DMA_ID = tt2.DMA_ID
									AND tt2.DMA_DealerType <> 'LP'
									AND tt2.DMA_ID <> @DealerId
									AND t1.DAT_ProductLine_BUM_ID =tt1.DAT_ProductLine_BUM_ID
									AND t1.CA_ID = tt1.CA_ID
									AND t1.HLA_HOS_ID=tt1.HLA_HOS_ID
							 FOR XML PATH ( '' )),
							1,
							1,
							'')
				 FROM	#TerritoryTemp t1
			   GROUP BY t1.DAT_ProductLine_BUM_ID,t1.CA_Code,t1.CA_ID, t1.HLA_HOS_ID ) bTable
		   ON     aTable.DAT_ProductLine_BUM_ID = bTable.DAT_ProductLine_BUM_ID
			  AND aTable.CA_Code = bTable.CA_Code
			  AND aTable.HosId = bTable.HLA_HOS_ID
	END
	ELSE
	BEGIN
		INSERT INTO #TerritoryTemp (DMA_ID,DAT_ProductLine_BUM_ID,CA_ID,HLA_HOS_ID)
		SELECT DISTINCT DMA_ID,DAT_ProductLine_BUM_ID,CC_ID,HLA_HOS_ID
		FROM V_DealerAuthorizationNoBR WHERE CA_ID IN (SELECT distinct CA_ID FROM interface.ClassificationAuthorization) and CC_Code =@PartsContractCode;
		
		INSERT INTO #ReturnTerritory (HosId,HosHospitalShortName ,HosHospitalName,HosGrade ,
		HosKeyAccount ,HosProvince ,HosCity ,HosDistrict ,HosDepart ,HosDepartType  ,HosDepartTypeName ,HosDepartRemark ,OperType ,TCount	,RepeatDealer,HospitalCount )
		 SELECT HosId,
			 HosHospitalShortName,
			 HosHospitalName,
			 HosGrade,
			 HosKeyAccount,
			 HosProvince,
			 HosCity,
			 HosDistrict,
			 ISNULL (HosDepart, '') AS HosDepart,
			 ISNULL (HosDepartType, '') AS HosDepartType,
			 ISNULL (HosDepartTypeName, '') AS HosDepartTypeName,
			 ISNULL (HosDepartRemark, '') AS HosDepartRemark,
			 OperType,
			 CASE WHEN ISNULL (bTable.DealerName, '') = '' THEN 0 ELSE 1 END TCount,
			 bTable.DealerName AS RepeatDealer,
			 @HospitalCount AS HospitalCount
		FROM    (SELECT DISTINCT dat.DAT_DMA_ID,
						hos.HOS_ID AS HosId,
						hos.HOS_HospitalShortName AS HosHospitalShortName,
						hos.HOS_HospitalName AS HosHospitalName,
						hos.HOS_Grade AS HosGrade,
						hos.HOS_Key_Account AS HosKeyAccount,
						hos.HOS_Province AS HosProvince,
						hos.HOS_City AS HosCity,
						hos.HOS_District AS HosDistrict,
						--@PartsContractCode CC_Code,
						ca.CA_Code AS CA_Code,
						dat.DAT_ProductLine_BUM_ID,
						cont.Territory_Type AS OperType,
						cont.HOS_Depart AS HosDepart,
						cont.HOS_DepartType AS HosDepartType,
						dst.VALUE1 AS HosDepartTypeName,
						cont.HOS_DepartRemark AS HosDepartRemark
				   FROM Hospital hos
						INNER JOIN dbo.ContractTerritory cont
						   ON hos.HOS_ID = cont.HOS_ID
						INNER JOIN dbo.DealerAuthorizationTableTemp dat
						   ON dat.DAT_ID = cont.Contract_ID
						INNER JOIN (select distinct CA_ID,CA_Code from interface.ClassificationAuthorization) ca on ca.CA_ID=dat.DAT_PMA_ID
						LEFT JOIN Lafite_DICT dst
						   ON     dst.DICT_TYPE = 'HospitalDepart'
							  AND CONVERT (NVARCHAR (50),
										   dat.DAT_ProductLine_BUM_ID) = dst.PID
							  AND cont.HOS_DepartType = dst.DICT_KEY
				  WHERE dat.DAT_DCL_ID = @ContractId) aTable
			 LEFT JOIN
				(SELECT distinct t1.DAT_ProductLine_BUM_ID,
						t1.CA_ID,
						t1.CA_Code,
						t1.HLA_HOS_ID,
						[DealerName] =
						   STUFF (
							  (SELECT ',' + tt2.[DMA_ChineseName]
								 FROM #TerritoryTemp tt1, DealerMaster tt2
								WHERE     tt1.DMA_ID = tt2.DMA_ID
									  AND tt2.DMA_DealerType <> 'LP'
									  AND tt2.DMA_ID <>@DealerId
									  AND t1.DAT_ProductLine_BUM_ID =tt1.DAT_ProductLine_BUM_ID
									  AND t1.CA_ID = tt1.CA_ID
									  AND t1.HLA_HOS_ID=tt1.HLA_HOS_ID
							   FOR XML PATH ( '' )),
							  1,
							  1,
							  '')
				   FROM #TerritoryTemp t1
				 GROUP BY t1.DAT_ProductLine_BUM_ID,t1.CA_Code,t1.CA_ID, t1.HLA_HOS_ID, t1.HLA_HOS_ID) bTable
			 ON     aTable.DAT_ProductLine_BUM_ID = bTable.DAT_ProductLine_BUM_ID
				AND aTable.CA_Code = bTable.CA_Code
				AND aTable.HosId = bTable.HLA_HOS_ID
		
	END
	

	insert into #ReturnTerritory2
	(Id,HosId,HosHospitalShortName,HosHospitalName,HosGrade,HosKeyAccount,HosProvince,HosCity,HosDistrict,HosDepart,HosDepartType,HosDepartTypeName,HosDepartRemark,OperType,HospitalCount,TCount,RepeatDealer,ROWNUMBER)
	SELECT  NEWID() Id,A.HosId,HosHospitalShortName ,HosHospitalName,HosGrade ,
		HosKeyAccount ,HosProvince ,HosCity ,HosDistrict ,HosDepart ,HosDepartType  ,HosDepartTypeName ,HosDepartRemark ,OperType,HospitalCount,b.TCount,b.RepeatDealer 
		,row_number () OVER (ORDER BY A.HosId ASC)
		FROM (	
			SELECT DISTINCT HosId,HosHospitalShortName ,HosHospitalName,HosGrade ,
			HosKeyAccount ,HosProvince ,HosCity ,HosDistrict ,HosDepart ,HosDepartType  ,HosDepartTypeName ,HosDepartRemark ,OperType,HospitalCount 
		FROM #ReturnTerritory) A
	LEFT JOIN 
	(SELECT DISTINCT HosId ,TCount	,RepeatDealer FROM #ReturnTerritory WHERE TCount=1) B
	ON A.HosId=B.HosId
	
	
	
	
	SELECT COUNT(*) CNT FROM #ReturnTerritory2;
	
	SELECT *
	FROM   #ReturnTerritory2
	WHERE  ROWNUMBER  BETWEEN @PageSize * @PageNum + 1 AND @PageSize * (@PageNum+1);
	--WHERE ROWNUMBER BETWEEN @PageSize * (@PageNum - 1) + 1 AND @PageSize * @PageNum;
	
	

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
	
	--记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
    return -1
    
END CATCH




GO


