Drop VIEW [interface].[V_I_QV_DealerAuthorizationTemp]
GO

--Drop VIEW [interface].[V_I_QV_DealerAuthorizationTemp];

Create VIEW   [interface].[V_I_QV_DealerAuthorizationTemp]
AS
		SELECT TAB1.*
		,ProductName=(SELECT TOP 1 CA_NameCN FROM INTERFACE.ClassificationAuthorization WHERE CA_ID=TAB2.DAT_PMA_ID)
		,TAB4.HOS_ID AS HospitalId
		,TAB4.HOS_Key_Account AS HospitalCode
		,TAB4.HOS_HospitalName AS HospitalName
		,TAB4.HOS_HospitalShortName AS HospitalShortName
		,TAB3.HOS_Depart AS Depart
		,DP.VALUE1 AS HosDepartTypeName
		,TAB3.HOS_DepartRemark AS DepartRemark
		FROM (
		select a.ContractId,EId,EName,ContractNo,DepId AS DivisionCode,E.DivisionName,SUBDEPID AS SubBUCode,f.CC_NameCN SubBUName,C.DMA_SAP_Code AS SAPCode,C.DMA_ChineseName AS DealerName,G.AgreementBegin,AgreementEnd
		from Contract.AppointmentMain A
		INNER JOIN Contract.AppointmentCandidate B ON A.ContractId=B.ContractId
		INNER JOIN Contract.AppointmentProposals G ON G.ContractId=A.ContractId
		INNER JOIN DealerMaster C ON C.DMA_ID=B.CompanyID
		INNER JOIN INTERFACE.T_I_EW_ContractState D ON D.ContractId=A.ContractId
		INNER JOIN V_DivisionProductLineRelation E ON E.IsEmerging='0' AND E.DivisionCode=CONVERT(NVARCHAR(10),A.DepId)
		INNER JOIN INTERFACE.ClassificationContract F ON A.SUBDEPID=F.CC_Code
		WHERE D.ContractType='Appointment'
		AND D.SynState='0'
		UNION 
		select a.ContractId,EId,EName,ContractNo,DepId AS DivisionCode,E.DivisionName,SUBDEPID AS SubBUCode,f.CC_NameCN SubBUName,C.DMA_SAP_Code,C.DMA_ChineseName,A.AmendEffectiveDate,A.DealerEndDate   	
		from Contract.AmendmentMain A
		INNER JOIN DealerMaster C ON C.DMA_ID=A.CompanyID
		INNER JOIN INTERFACE.T_I_EW_ContractState D ON D.ContractId=A.ContractId
		INNER JOIN V_DivisionProductLineRelation E ON E.IsEmerging='0' AND E.DivisionCode=CONVERT(NVARCHAR(10),A.DepId)
		INNER JOIN INTERFACE.ClassificationContract F ON A.SUBDEPID=F.CC_Code
		WHERE D.ContractType='Amendment'
		AND D.SynState='0'
		UNION
		select a.ContractId,EId,EName,ContractNo,DepId AS DivisionCode,E.DivisionName,SUBDEPID AS SubBUCode,f.CC_NameCN SubBUName,C.DMA_SAP_Code,C.DMA_ChineseName,B.AgreementBegin,B.AgreementEnd  	
		from Contract.RenewalMain A
		INNER JOIN Contract.RenewalProposals B ON A.ContractId=B.ContractId
		INNER JOIN DealerMaster C ON C.DMA_ID=A.CompanyID
		INNER JOIN INTERFACE.T_I_EW_ContractState D ON D.ContractId=A.ContractId
		INNER JOIN V_DivisionProductLineRelation E ON E.IsEmerging='0' AND E.DivisionCode=CONVERT(NVARCHAR(10),A.DepId)
		INNER JOIN INTERFACE.ClassificationContract F ON A.SUBDEPID=F.CC_Code
		WHERE D.ContractType='Renewal'
		AND D.SynState='0') TAB1
		INNER JOIN DealerAuthorizationTableTemp  TAB2 ON TAB1.ContractId=TAB2.DAT_DCL_ID
		INNER JOIN ContractTerritory TAB3 ON TAB3.Contract_ID=TAB2.DAT_ID
		INNER JOIN Hospital TAB4 ON TAB4.HOS_ID=TAB3.HOS_ID
		LEFT JOIN Lafite_DICT DP ON DP.DICT_TYPE = 'HospitalDepart' AND CONVERT (NVARCHAR (50),TAB2.DAT_ProductLine_BUM_ID) = DP.PID AND TAB3.HOS_DepartType = DP.DICT_KEY
		UNION
		
		SELECT TAB1.*
		,ProductName=(SELECT TOP 1 CA_NameCN FROM INTERFACE.ClassificationAuthorization WHERE CA_ID=TAB2.DA_PMA_ID)
		,TAB4.TER_ID AS HospitalId
		,TAB4.TER_Code AS HospitalCode
		,TAB4.TER_Description AS HospitalName
		,NULL 
		,NULL
		,NULL
		,TAB3.TA_Remark
		FROM (
		select a.ContractId,EId,EName,ContractNo,DepId AS DivisionCode,E.DivisionName,SUBDEPID AS SubBUCode,f.CC_NameCN SubBUName,C.DMA_SAP_Code,C.DMA_ChineseName,G.AgreementBegin,AgreementEnd
		from Contract.AppointmentMain A
		INNER JOIN Contract.AppointmentCandidate B ON A.ContractId=B.ContractId
		INNER JOIN Contract.AppointmentProposals G ON G.ContractId=A.ContractId
		INNER JOIN DealerMaster C ON C.DMA_ID=B.CompanyID
		INNER JOIN INTERFACE.T_I_EW_ContractState D ON D.ContractId=A.ContractId
		INNER JOIN V_DivisionProductLineRelation E ON E.IsEmerging='0' AND E.DivisionCode=CONVERT(NVARCHAR(10),A.DepId)
		INNER JOIN INTERFACE.ClassificationContract F ON A.SUBDEPID=F.CC_Code
		WHERE D.ContractType='Appointment'
		AND D.SynState='0'
		UNION 
		select a.ContractId,EId,EName,ContractNo,DepId AS DivisionCode,E.DivisionName,SUBDEPID AS SubBUCode,f.CC_NameCN SubBUName,C.DMA_SAP_Code,C.DMA_ChineseName,A.AmendEffectiveDate,A.DealerEndDate   	
		from Contract.AmendmentMain A
		INNER JOIN DealerMaster C ON C.DMA_ID=A.CompanyID
		INNER JOIN INTERFACE.T_I_EW_ContractState D ON D.ContractId=A.ContractId
		INNER JOIN V_DivisionProductLineRelation E ON E.IsEmerging='0' AND E.DivisionCode=CONVERT(NVARCHAR(10),A.DepId)
		INNER JOIN INTERFACE.ClassificationContract F ON A.SUBDEPID=F.CC_Code
		WHERE D.ContractType='Amendment'
		AND D.SynState='0'
		UNION
		select a.ContractId,EId,EName,ContractNo,DepId AS DivisionCode,E.DivisionName,SUBDEPID AS SubBUCode,f.CC_NameCN SubBUName,C.DMA_SAP_Code,C.DMA_ChineseName,B.AgreementBegin,B.AgreementEnd  	
		from Contract.RenewalMain A
		INNER JOIN Contract.RenewalProposals B ON A.ContractId=B.ContractId
		INNER JOIN DealerMaster C ON C.DMA_ID=A.CompanyID
		INNER JOIN INTERFACE.T_I_EW_ContractState D ON D.ContractId=A.ContractId
		INNER JOIN V_DivisionProductLineRelation E ON E.IsEmerging='0' AND E.DivisionCode=CONVERT(NVARCHAR(10),A.DepId)
		INNER JOIN INTERFACE.ClassificationContract F ON A.SUBDEPID=F.CC_Code
		WHERE D.ContractType='Renewal'
		AND D.SynState='0') TAB1
		INNER JOIN DealerAuthorizationAreaTemp  TAB2 ON TAB1.ContractId=TAB2.DA_DCL_ID
		INNER JOIN dbo.TerritoryAreaTemp TAB3 ON TAB3.TA_DA_ID=TAB2.DA_ID
		INNER JOIN Territory TAB4 ON TAB4.TER_ID=TAB3.TA_Area
GO


