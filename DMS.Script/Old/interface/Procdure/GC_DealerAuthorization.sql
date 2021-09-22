DROP PROCEDURE [interface].[GC_DealerAuthorization]
GO


/**********************************************
	功能：经销商合同授权与实际授权
	作者：GrapeCity
	最后更新时间：	2016-04-19
	更新记录说明：
	1.创建 2016-04-19
**********************************************/
CREATE PROCEDURE [interface].[GC_DealerAuthorization]
	@ContractId NVARCHAR(36),
	@HospitalId NVARCHAR(36)
AS
BEGIN

	DECLARE @Division NVARCHAR(10)
	DECLARE @SubBU UNIQUEIDENTIFIER
	DECLARE @DealerId UNIQUEIDENTIFIER
	DECLARE @ContractType NVARCHAR(50)
	DECLARE @HasChannge INT;
	SET @HasChannge=1;
	IF @HospitalId=''  SET @HospitalId=NULL;
	
	SELECT * INTO #TABTO  FROM (
	SELECT appoin.CAP_ID AS ContractID,appoin.CAP_DMA_ID AS DealerID, appoin.CAP_Division AS Division,Convert(NVARCHAR(10),appoin.CAP_EffectiveDate ,120) as EffectiveDate,Convert(NVARCHAR(10),appoin.CAP_ExpirationDate,120) as ExpirationDate,'Appointment' AS ContractType, appoin.CAP_SubDepID AS SubDepID FROM ContractAppointment appoin
		UNION
		SELECT amend.CAM_ID AS ContractID,amend.CAM_DMA_ID AS DealerID,amend.CAM_Division AS Division,Convert(NVARCHAR(10),amend.CAM_Amendment_EffectiveDate ,120) ,Convert(NVARCHAR(10),amend.CAM_Agreement_ExpirationDate,120),'Amendment' AS ContractType,amend.CAM_SubDepID FROM ContractAmendment amend
		UNION
		SELECT rene.CRE_ID AS ContractID,rene.CRE_DMA_ID AS DealerID, rene.CRE_Division AS Division, Convert(NVARCHAR(10),rene.CRE_Agrmt_EffectiveDate_Renewal ,120),Convert(NVARCHAR(10),rene.CRE_Agrmt_ExpirationDate_Renewal,120),'Renewal' AS ContractType,rene.CRE_SubDepID FROM ContractRenewal rene
	) TAB
	
	--0.准备参数
	SELECT @DealerId=a.DealerID,@Division=C.DivisionCode,@SubBU=D.CC_ID ,@ContractType=a.ContractType
	FROM #TABTO A
	INNER JOIN V_DivisionProductLineRelation C ON C.IsEmerging='0' AND C.DivisionName= A.Division
	INNER JOIN interface.ClassificationContract D ON D.CC_Code=A.SubDepID
	WHERE A.ContractID=@ContractId
	
	--如果是Amendment合同，不变更授权
	IF @ContractType='Amendment' AND  EXISTS(SELECT 1 FROM ContractAmendment A WHERE A.CAM_Territory_IsChange=0 AND A.CAM_ID=@ContractId)
	BEGIN
		SET @HasChannge=0;
	END
	
	--1.流程合同主信息
	SELECT B.DMA_SAP_Code AS SAPCode,B.DMA_ChineseName AS DealerName,C.ProductLineName,D.CC_NameCN AS SubDepName,EffectiveDate,ExpirationDate,ContractType ,E.DMA_SAP_Code AS ParentSAPCode,E.DMA_ChineseName AS ParentDealerName
	FROM #TABTO A
	INNER JOIN DealerMaster B ON A.DealerID=B.DMA_ID
	INNER JOIN V_DivisionProductLineRelation C ON C.IsEmerging='0' AND C.DivisionName= A.Division
	INNER JOIN interface.ClassificationContract D ON D.CC_Code=A.SubDepID
	INNER JOIN DealerMaster E ON E.DMA_ID=B.DMA_Parent_DMA_ID
	WHERE A.ContractID=@ContractId
	
	
	--2.流程合同授权产品
	IF NOT EXISTS (SELECT 1 FROM DealerAuthorizationAreaTemp A WHERE A.DA_DCL_ID=@ContractId)
	BEGIN
		SELECT D.ProductLineName +'-'+C.CA_NameCN AS ProductName FROM DealerAuthorizationTableTemp A 
		INNER JOIN V_DivisionProductLineRelation D ON D.ProductLineID=A.DAT_ProductLine_BUM_ID
		INNER JOIN (SELECT b.CA_ID,b.CA_NameCN FROM interface.ClassificationAuthorization B) C ON C.CA_ID=A.DAT_PMA_ID
		WHERE A.DAT_DCL_ID=@ContractId
		AND @HasChannge=1
		--AND ((ISNULL(@HospitalId,'')<>'' AND EXISTS(SELECT 1 FROM ContractTerritory CT WHERE CT.Contract_ID=A.DAT_ID AND CT.HOS_ID=@HospitalId))
		--	OR ISNULL(@HospitalId,'')='')
	END
	ELSE
	BEGIN
		SELECT D.ProductLineName +'-'+C.CA_NameCN AS ProductName FROM DealerAuthorizationAreaTemp A 
		INNER JOIN V_DivisionProductLineRelation D ON D.ProductLineID=A.DA_ProductLine_BUM_ID
		INNER JOIN (SELECT b.CA_ID,b.CA_NameCN FROM interface.ClassificationAuthorization B) C ON C.CA_ID=A.DA_PMA_ID
		WHERE A.DA_DCL_ID=@ContractId
		AND @HasChannge=1
		--AND ((ISNULL(@HospitalId,'')<>'' 
		--	AND EXISTS(
		--	SELECT 1 FROM TerritoryArea CT
		--	INNER JOIN Territory TRE ON CT.TA_Area=TRE.TER_ID
		--	INNER JOIN Hospital C ON C.HOS_Province=TRE.TER_Description
		--	WHERE CT.TA_DA_ID=A.DA_ID
		--	AND NOT EXISTS (SELECT 1 FROM TerritoryAreaExc WHERE TAE_DA_ID=CT.TA_DA_ID AND TAE_HOS_ID=C.HOS_ID)
		--	AND C.HOS_ID=@HospitalId
		--	))
		--OR ISNULL(@HospitalId,'')='')
	END
	
	--3.流程合同授权医院
	IF NOT EXISTS (SELECT 1 FROM DealerAuthorizationAreaTemp A WHERE A.DA_DCL_ID=@ContractId)
	BEGIN 
		SELECT DISTINCT C.HOS_HospitalName AS HospitalName FROM ContractTerritory A 
		INNER JOIN DealerAuthorizationTableTemp B ON A.Contract_ID=B.DAT_ID 
		INNER JOIN Hospital C ON C.HOS_ID=A.HOS_ID
		WHERE B.DAT_DCL_ID=@ContractId 
		AND @HasChannge=1
		AND ((ISNULL(@HospitalId,'')<>'' AND A.HOS_ID=@HospitalId)
			OR ISNULL(@HospitalId,'')='') 
	END
	ELSE
	BEGIN
		SELECT DISTINCT C.HOS_HospitalName AS HospitalName FROM TerritoryArea  A 
		INNER JOIN DealerAuthorizationAreaTemp D ON D.DA_ID=A.TA_DA_ID
		INNER JOIN Territory B ON A.TA_Area=B.TER_ID
		INNER JOIN Hospital C ON C.HOS_Province=B.TER_Description
		WHERE D.DA_DCL_ID=@ContractId
		and c.HOS_ActiveFlag='1' and c.HOS_DeletedFlag='0'
		AND NOT EXISTS (SELECT 1 FROM TerritoryAreaExc WHERE TAE_DA_ID=A.TA_DA_ID AND TAE_HOS_ID=C.HOS_ID)
		AND @HasChannge=1
		AND ((ISNULL(@HospitalId,'')<>'' AND C.HOS_ID=@HospitalId)
			OR ISNULL(@HospitalId,'')='') 
	END
	
	--4. 经销商实际合同主信息
	SELECT B.DMA_SAP_Code AS SAPCode,B.DMA_ChineseName AS DealerName,C.ProductLineName,D.CC_NameCN AS SubDepName,A.EffectiveDate,A.MinDate AS N'ExpirationDate',E.DMA_SAP_Code AS ParentSAPCode,E.DMA_ChineseName AS ParentDealerName
	FROM V_DealerContractMaster A 
	INNER JOIN DealerMaster B ON A.DMA_ID=B.DMA_ID
	INNER JOIN V_DivisionProductLineRelation C ON C.IsEmerging='0' AND C.DivisionCode= CONVERT(NVARCHAR(10),A.Division)
	INNER JOIN interface.ClassificationContract D ON D.CC_ID=A.CC_ID
	INNER JOIN DealerMaster E ON E.DMA_ID=B.DMA_Parent_DMA_ID
	WHERE A.ActiveFlag=1
	AND A.DMA_ID=@DealerId AND CONVERT(NVARCHAR(10),A.Division)=@Division AND A.CC_ID=@SubBU
	
	--5. 经销商实际产品线
	SELECT D.CC_ProductLineName+'-'+D.CA_NameCN AS ProductName
	FROM V_DealerContractMaster A 
	INNER JOIN V_DivisionProductLineRelation C ON C.IsEmerging='0' AND C.DivisionCode= CONVERT(NVARCHAR(10),A.Division)
	INNER JOIN (SELECT DISTINCT CC_ProductLineName,CC_ID,CA_ID,CA_NameCN FROM V_ProductClassificationStructure) D ON D.CC_ID=A.CC_ID 
	INNER JOIN DealerAuthorizationTable E ON E.DAT_DMA_ID=A.DMA_ID AND E.DAT_ProductLine_BUM_ID=C.ProductLineID AND D.CA_ID=E.DAT_PMA_ID
	WHERE A.ActiveFlag=1
	AND A.DMA_ID=@DealerId AND CONVERT(NVARCHAR(10),A.Division)=@Division AND A.CC_ID=@SubBU
	--有医院授权的产品线
	--AND EXISTS (SELECT 1 FROM HospitalList F WHERE F.HLA_DAT_ID=E.DAT_ID
	--		AND ((ISNULL(@HospitalId,'')<>'' AND F.HLA_HOS_ID=@HospitalId) OR ISNULL(@HospitalId,'')='')
	--		) 

	
	--6. 经销商实际授权医院
	SELECT DISTINCT G.HOS_HospitalName AS HospitalName
	FROM V_DealerContractMaster A 
	INNER JOIN V_DivisionProductLineRelation C ON C.IsEmerging='0' AND C.DivisionCode= CONVERT(NVARCHAR(10),A.Division)
	INNER JOIN (SELECT DISTINCT CC_ID,CA_ID,CA_NameCN FROM V_ProductClassificationStructure) D ON D.CC_ID=A.CC_ID 
	INNER JOIN DealerAuthorizationTable E ON E.DAT_DMA_ID=A.DMA_ID AND E.DAT_ProductLine_BUM_ID=C.ProductLineID AND D.CA_ID=E.DAT_PMA_ID
	INNER JOIN HospitalList F ON F.HLA_DAT_ID=E.DAT_ID
	INNER JOIN Hospital G ON G.HOS_ID=F.HLA_HOS_ID
	WHERE A.ActiveFlag=1
	AND A.DMA_ID=@DealerId AND CONVERT(NVARCHAR(10),A.Division)=@Division AND A.CC_ID=@SubBU
	AND ((ISNULL(@HospitalId,'')<>'' AND F.HLA_HOS_ID=@HospitalId) OR ISNULL(@HospitalId,'')='')
END

GO


