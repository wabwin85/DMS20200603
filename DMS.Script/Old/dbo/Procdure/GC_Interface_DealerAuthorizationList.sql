DROP [dbo].[GC_Interface_DealerAuthorizationList] 
GO


CREATE PROCEDURE [dbo].[GC_Interface_DealerAuthorizationList] @AuthDate DATETIME
WITH EXEC AS CALLER
AS
	Create TABLE #Temp 
	(
		Id uniqueidentifier NULL,
		DealerName NVARCHAR(500) NULL,
		DealerId uniqueidentifier NULL,
		SAPId NVARCHAR(50)  NULL,
		DealerType NVARCHAR(50)  NULL,
		Division NVARCHAR(50) null,
		SubBU NVARCHAR(100) null,
		MarketType INT null,
		ContractType NVARCHAR(50)  NULL,
		DmaParent NVARCHAR(100)  NULL,
		EffectiveDate DATETIME null,
		ExpirationDate DATETIME null,
		UpdateDate DATETIME,
		PMAID uniqueidentifier,
		PMAName NVARCHAR(100)  NULL,
		ProductLineID uniqueidentifier null,	
		Province NVARCHAR(100) null,
		ProvindeID uniqueidentifier null,	
		City NVARCHAR(100) null,	
		CityID uniqueidentifier null,
		HospitalId uniqueidentifier null,	
		HospitalCode NVARCHAR(100) null,	
		HospitalName NVARCHAR(200) null,
		HospitalDepart	 NVARCHAR(100) null,
		HospitalDepartRemark NVARCHAR(500) null,
		TerminationDate DATETIME null
	)
	Create TABLE #tempMap
	(
		Id uniqueidentifier NULL,
		DealerId uniqueidentifier NULL,
		Division NVARCHAR(50) null,
		SubBU NVARCHAR(100) null,
		MarketType INT null,
		ContractType NVARCHAR(50)  NULL,
		EffectiveDate DATETIME null
	)

	Create TABLE #tempMapRel
	(
		Id uniqueidentifier NULL,
		DealerId uniqueidentifier NULL,
		Division NVARCHAR(50) null,
		SubBU NVARCHAR(100) null,
		MarketType INT null,
		ContractType NVARCHAR(50)  NULL,
		EffectiveDate DATETIME null
	)

	Create TABLE #tempTem
	(
		Id uniqueidentifier NULL,
		DealerId uniqueidentifier NULL,
		Division NVARCHAR(50) null,
		SubBU NVARCHAR(100) null,
		MarketType INT null,
		ContractType NVARCHAR(50)  NULL,
		EffectiveDate DATETIME null
	)
	Create TABLE #tempTemRel
	(
		Id uniqueidentifier NULL,
		DealerId uniqueidentifier NULL,
		Division NVARCHAR(50) null,
		SubBU NVARCHAR(100) null,
		MarketType INT null,
		ContractType NVARCHAR(50)  NULL,
		EffectiveDate DATETIME null
	)
	
	Create TABLE #ContractMaster
	(
		DealerId uniqueidentifier NULL,
		Division NVARCHAR(50) null,
		SubBU NVARCHAR(100) null,
		MarketType INT null,
		TerminationDate DATETIME null
	)
	
	Create TABLE #ContractMaster_ExtensionDate
	(
		DealerId uniqueidentifier NULL,
		Division NVARCHAR(50) null,
		SubBU NVARCHAR(100) null,
		MarketType INT null,
		ExtensionDate DATETIME null
	)

	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @AuthDate=ISNULL(@AuthDate,GETDATE());
INSERT INTO #tempMap (Id,DealerId,Division,SubBU,MarketType,ContractType,EffectiveDate)
SELECT CAP_ID,CAP_DMA_ID,CAP_Division,CAP_SubDepID,ISNULL(CAP_MarketType,0),'Appointment',CAP_EffectiveDate FROM ContractAppointment WHERE CAP_Status='Completed'
UNION
SELECT CAM_ID,CAM_DMA_ID,CAM_Division,CAM_SubDepID,ISNULL(CAM_MarketType,0),'Amendment',CAM_Amendment_EffectiveDate FROM ContractAmendment WHERE CAM_Status='Completed' and CAM_Territory_IsChange='1'
UNION
select CRE_ID,CRE_DMA_ID,CRE_Division,CRE_SubDepID,ISNULL(CRE_MarketType,0),'Renewal',CRE_Agrmt_EffectiveDate_Renewal  FROM ContractRenewal a WHERE a.CRE_Status='Completed'

INSERT INTO #tempTem (Id,DealerId,Division,SubBU,MarketType,ContractType,EffectiveDate)
SELECT CAP_ID,CAP_DMA_ID,CAP_Division,CAP_SubDepID,ISNULL(CAP_MarketType,0),'Appointment',CAP_EffectiveDate FROM ContractAppointment WHERE CAP_Status='Completed'
UNION
SELECT CAM_ID,CAM_DMA_ID,CAM_Division,CAM_SubDepID,ISNULL(CAM_MarketType,0),'Amendment',CAM_Amendment_EffectiveDate FROM ContractAmendment WHERE CAM_Status='Completed' and CAM_Territory_IsChange='1'
UNION
select CRE_ID,CRE_DMA_ID,CRE_Division,CRE_SubDepID,ISNULL(CRE_MarketType,0),'Renewal',CRE_Agrmt_EffectiveDate_Renewal  FROM ContractRenewal a WHERE a.CRE_Status='Completed'
UNION
select CTE_ID,CTE_DMA_ID,CTE_Division,CTE_SubDepID,ISNULL(CTE_MarketType,0),'Termination',CTE_Termination_EffectiveDate  FROM ContractTermination a WHERE a.CTE_Status='Completed'

INSERT INTO #tempMapRel
	SELECT * FROM  #tempMap WHERE ID IN 
	(
		SELECT Id FROM (
			SELECT Id ,DealerId,Division,SubBU,MarketType,EffectiveDate
			,row_number() over(partition by DealerId,Division,SubBU,MarketType order by EffectiveDate desc) rn
			FROM #tempMap
			WHERE CONVERT(nvarchar(10),EffectiveDate,120)<=CONVERT(nvarchar(10),@AuthDate,120)
		)T  WHERE T.rn<2
	)
	
INSERT INTO #tempTemRel
	SELECT * FROM  #tempTem WHERE ID IN 
	(
		SELECT Id FROM (
			SELECT Id ,DealerId,Division,SubBU,MarketType,EffectiveDate
			,row_number() over(partition by DealerId,Division,SubBU,MarketType order by EffectiveDate desc) rn
			FROM #tempTem
			WHERE CONVERT(nvarchar(10),EffectiveDate,120)<=CONVERT(nvarchar(10),@AuthDate,120)
		)T  WHERE T.rn<2
	)
	
	insert into #temp (Id,DealerName,DealerId,SAPId,DealerType,DmaParent,ContractType,Division,SubBU,MarketType,EffectiveDate,ExpirationDate,UpdateDate,PMAID,PMAName,ProductLineID,Province,ProvindeID,City,CityID,HospitalId,HospitalCode,HospitalName,HospitalDepart,HospitalDepartRemark)
	SELECT TAB.ID,a.DMA_ChineseName,TAB.DMA_ID,A.DMA_SAP_Code,A.DMA_DealerType,
	DMA_Parent=Case when DMA_Parent_DMA_ID='A00FCD75-951D-4D91-8F24-A29900DA5E85' then '方承'
				when DMA_Parent_DMA_ID='84C83F71-93B4-4EFD-AB51-12354AFABAC3' then '国科恒泰'
				when DMA_Parent_DMA_ID='A54ADD15-CB13-4850-9848-6DA4576207CB' then '国科恒泰(新兴)'
				when DMA_Parent_DMA_ID='33029AF0-CFCF-495E-B057-550D16C41E4A' then '方承(新兴)'
				when DMA_Parent_DMA_ID='2F2D2BD9-6FAE-4A40-BC44-8E5FECC1C6DD' then '国药控股河南'
				else 'Boston' end 
	,TAB.ContractType,TAB.Division,TAB.SubBU,TAB.MarketType,TAB.EffectiveDate,TAB.ExpirationDate,TAB.UpdateDate ,
	DAT.DAT_PMA_ID,
	
	 isnull( (CASE WHEN DAT.DAT_PMA_ID = DAT.DAT_ProductLine_BUM_ID THEN NULL          
			 ELSE (SELECT PCT_Name FROM PartsClassification WHERE DAT.DAT_PMA_ID = PCT_ID
			 )  END ),
			 (SELECT P. ATTRIBUTE_NAME FROM View_ProductLine AS P WHERE P .ID =
			 DAT.DAT_ProductLine_BUM_ID)
			 ) as ProductLine,
		     isnull( (CASE WHEN DAT.DAT_PMA_ID = DAT.DAT_ProductLine_BUM_ID THEN NULL          
			 ELSE (SELECT PCT_ID FROM PartsClassification WHERE DAT.DAT_PMA_ID = PCT_ID
			 )  END ),
			 (SELECT P.Id FROM View_ProductLine AS P WHERE P .ID =
			 DAT.DAT_ProductLine_BUM_ID)
			 ) as ProductLineId,
	
		Province=HOS_Province,ProvindeID=b.TER_ID,City=HOS_City,CityID=t.TER_ID,
	
	HLA.HOS_ID,HOS.HOS_Key_Account,HOS.HOS_HospitalName,HLA.HOS_Depart,HLA.HOS_DepartRemark
	FROM (
		SELECT a.CAP_ID AS ID,a.CAP_DMA_ID AS DMA_ID, ISNULL(a.CAP_MarketType,0) AS MarketType,a.CAP_Division AS Division,a.CAP_Update_Date AS UpdateDate,a.CAP_SubDepID AS SubBU ,'Appointment' ContractType,CAP_EffectiveDate AS EffectiveDate,CAP_ExpirationDate AS ExpirationDate FROM ContractAppointment a WHERE a.CAP_Status='Completed'
		union
		select a.CAM_ID,a.CAM_DMA_ID,ISNULL(a.CAM_MarketType,0),a.CAM_Division,a.CAM_Update_Date,a.CAM_SubDepID,'Amendment',CASE WHEN CAM_Agreement_EffectiveDate IS NULL THEN CAM_Amendment_EffectiveDate ELSE CAM_Agreement_EffectiveDate  END,CAM_Agreement_ExpirationDate FROM ContractAmendment a WHERE a.CAM_Status='Completed' and a.CAM_Territory_IsChange='1'
		union
		select  a.CRE_ID,a.CRE_DMA_ID,ISNULL(a.CRE_MarketType,0),a.CRE_Division,a.CRE_Update_Date,a.CRE_SubDepID,'Renewal',CRE_Agrmt_EffectiveDate_Renewal,CRE_Agrmt_ExpirationDate_Renewal  FROM ContractRenewal a WHERE a.CRE_Status='Completed'
	) TAB
	INNER JOIN DealerAuthorizationTableTemp DAT ON DAT.DAT_DCL_ID=TAB.ID 
	INNER JOIN ContractTerritory HLA ON HLA.Contract_ID=DAT.DAT_ID
	INNER JOIN DealerMaster a on a.DMA_ID=tab.DMA_ID 
	INNER JOIN #tempMapRel REL ON REL.Id=TAB.ID
	LEFT JOIN Hospital HOS ON HOS.HOS_ID=HLA.HOS_ID
	
	left join Territory b on HOS_Province=b.TER_Description and b.TER_Type='Province'
	left join Territory t on HOS_City=t.TER_Description and t.TER_Type='City'
	and t.TER_ParentID=b.TER_ID
	ORDER BY TAB.UpdateDate
  
	
	
	insert into #temp (Id,DealerName,DealerId,SAPId,DealerType,DmaParent,ContractType,Division,SubBU,MarketType,EffectiveDate,ExpirationDate,UpdateDate,PMAID,PMAName,ProductLineID,Province,ProvindeID,City,CityID,HospitalId,HospitalCode,HospitalName,HospitalDepart,HospitalDepartRemark)
	SELECT TAB.ID,a.DMA_ChineseName,TAB.DMA_ID,A.DMA_SAP_Code,A.DMA_DealerType,
	DMA_Parent='Boston'
	,TAB.ContractType,TAB.Division,TAB.SubBU,TAB.MarketType,TAB.EffectiveDate,TAB.ExpirationDate,TAB.UpdateDate ,
	DAT.DA_PMA_ID,
	
	 isnull( (CASE WHEN DAT.DA_PMA_ID = DAT.DA_ProductLine_BUM_ID THEN NULL          
			 ELSE (SELECT PCT_Name FROM PartsClassification WHERE DAT.DA_PMA_ID = PCT_ID
			 )  END ),
			 (SELECT P. ATTRIBUTE_NAME FROM View_ProductLine AS P WHERE P .ID =
			 DAT.DA_ProductLine_BUM_ID)
			 ) as ProductLine,
		     isnull( (CASE WHEN DAT.DA_PMA_ID = DAT.DA_ProductLine_BUM_ID THEN NULL          
			 ELSE (SELECT PCT_ID FROM PartsClassification WHERE DAT.DA_PMA_ID = PCT_ID
			 )  END ),
			 (SELECT P.Id FROM View_ProductLine AS P WHERE P .ID =
			 DAT.DA_ProductLine_BUM_ID)
			 ) as ProductLineId,
	
		Province=HOS_Province,ProvindeID=b.TER_ID,City=HOS_City,CityID=t.TER_ID,
	
	HOS.HOS_ID,HOS.HOS_Key_Account,HOS.HOS_HospitalName,'',''
	FROM (
		SELECT a.CAP_ID AS ID,a.CAP_DMA_ID AS DMA_ID, ISNULL(a.CAP_MarketType,0) AS MarketType,a.CAP_Division AS Division,a.CAP_Update_Date AS UpdateDate,a.CAP_SubDepID AS SubBU ,'Appointment' ContractType,CAP_EffectiveDate AS EffectiveDate,CAP_ExpirationDate AS ExpirationDate FROM ContractAppointment a WHERE a.CAP_Status='Completed'
		union
		select a.CAM_ID,a.CAM_DMA_ID,ISNULL(a.CAM_MarketType,0),a.CAM_Division,a.CAM_Update_Date,a.CAM_SubDepID,'Amendment',CAM_Agreement_EffectiveDate,CAM_Agreement_ExpirationDate FROM ContractAmendment a WHERE a.CAM_Status='Completed' and a.CAM_Territory_IsChange='1'
		union
		select  a.CRE_ID,a.CRE_DMA_ID,ISNULL(a.CRE_MarketType,0),a.CRE_Division,a.CRE_Update_Date,a.CRE_SubDepID,'Renewal',CRE_Agrmt_EffectiveDate_Renewal,CRE_Agrmt_ExpirationDate_Renewal  FROM ContractRenewal a WHERE a.CRE_Status='Completed'
	) TAB
	INNER JOIN DealerAuthorizationAreaTemp DAT ON DAT.DA_DCL_ID=TAB.ID 
	INNER JOIN TerritoryAreaTemp TA ON TA.TA_DA_ID=DAT.DA_ID
	INNER JOIN DealerMaster a on a.DMA_ID=tab.DMA_ID 
	INNER JOIN #tempMapRel REL ON REL.Id=TAB.ID
	INNER JOIN Territory B ON B.TER_ID=TA.TA_Area and b.TER_Type='Province'
	INNER JOIN Hospital HOS ON HOS.HOS_Province=B.TER_Description
	INNER join Territory t on HOS_City=t.TER_Description and t.TER_Type='City' and t.TER_ParentID=b.TER_ID
	where a.DMA_SAP_Code in ('369307','442091','342859','442090')
	AND NOT EXISTS(SELECT 1 FROM TerritoryAreaExcTemp EX where EX.TAE_DA_ID=TA.TA_DA_ID and EX.TAE_HOS_ID=HOS.HOS_ID )
	ORDER BY TAB.UpdateDate

	delete Interface.T_I_QV_DealerAuthorizationList where [Year]=YEAR(@AuthDate) and [Month]=month(@AuthDate)
	
	INSERT INTO Interface.T_I_QV_DealerAuthorizationList(Id,DealerName,DealerId,SAPId,DealerType,DmaParent,ContractType,Division,SubBU,MarketType,EffectiveDate,ExpirationDate,UpdateDate,PMAID,PMAName,ProductLineID,Province,ProvindeID,City,CityID,HospitalId,HospitalCode,HospitalName,HospitalDepart,HospitalDepartRemark,TerminationDate,[Year],[Month])
	SELECT A.Id,DealerName,A.DealerId,SAPId,DealerType,DmaParent,A.ContractType,A.Division,A.SubBU,A.MarketType,A.EffectiveDate,ExpirationDate,UpdateDate,PMAID,PMAName,ProductLineID,Province,ProvindeID,City,CityID,HospitalId,HospitalCode,HospitalName,HospitalDepart,HospitalDepartRemark 
	,B.EffectiveDate,YEAR(@AuthDate),month(@AuthDate)
	FROM #temp A 
	LEFT JOIN (SELECT * FROM #tempTemRel WHERE ContractType='Termination') B 
	ON A.DealerId=B.DealerId AND A.Division=B.Division AND A.SubBU=B.SubBU AND ISNULL(A.MarketType,0)=ISNULL(B.MarketType,0)
	
	INSERT INTO #ContractMaster(DealerId,Division,SubBU,MarketType,TerminationDate)
	SELECT A.DCM_DMA_ID,B.DivisionName,C.CC_Code,ISNULL(A.DCM_MarketType,0),A.DCM_TerminationDate FROM DealerContractMaster A 
	INNER JOIN V_DivisionProductLineRelation B ON CONVERT(NVARCHAR(10), A.DCM_Division)=B.DivisionCode AND B.IsEmerging='0'
	INNER JOIN interface.ClassificationContract C ON C.CC_ID=A.DCM_CC_ID
	WHERE A.DCM_TerminationDate IS NOT NULL
	
	UPDATE A SET A.TerminationDate=B.TerminationDate FROM Interface.T_I_QV_DealerAuthorizationList A, #ContractMaster B 
	WHERE A.DealerId=B.DealerId AND A.Division=B.Division AND A.MarketType=B.MarketType AND A.SubBU=B.SubBU
	AND A.TerminationDate IS NULL AND [Year]=YEAR(@AuthDate) and [Month]=month(@AuthDate)
	
	INSERT INTO  #ContractMaster_ExtensionDate (DealerId,Division,SubBU,MarketType,ExtensionDate)
	SELECT A.DCM_DMA_ID,B.DivisionName,C.CC_Code,ISNULL(A.DCM_MarketType,0),A.DCM_ExtensionDate FROM DealerContractMaster A 
	INNER JOIN V_DivisionProductLineRelation B ON CONVERT(NVARCHAR(10), A.DCM_Division)=B.DivisionCode AND B.IsEmerging='0'
	INNER JOIN interface.ClassificationContract C ON C.CC_ID=A.DCM_CC_ID
	WHERE A.DCM_ExtensionDate IS NOT NULL
	
	UPDATE A SET A.ExtensionDate=B.ExtensionDate FROM Interface.T_I_QV_DealerAuthorizationList A, #ContractMaster_ExtensionDate B 
	WHERE A.DealerId=B.DealerId AND A.Division=B.Division AND A.MarketType=B.MarketType AND A.SubBU=B.SubBU
	AND  [Year]=YEAR(@AuthDate) and [Month]=month(@AuthDate)
	
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

END CATCH

GO


