Drop VIEW [interface].[V_I_QV_HospitalAOPTemp]
GO

--Drop VIEW [interface].[V_I_QV_HospitalAOPTemp];

Create VIEW   [interface].[V_I_QV_HospitalAOPTemp]
AS
		SELECT TAB1.*
		,ProductName=(SELECT TOP 1 CQ_NameCN FROM INTERFACE.ClassificationQuota WHERE CQ_ID=TAB2.AOPDH_PCT_ID)
		,TAB3.HOS_Key_Account AS HospitalCode
		,TAB3.HOS_HospitalName AS HospitalName
		,TAB2.AOPDH_Year AS [Year]
		,TAB2.AOPDH_Amount_1 AS Amount1
		,TAB2.AOPDH_Amount_2 AS Amount2
		,TAB2.AOPDH_Amount_3 AS Amount3
		,TAB2.AOPDH_Amount_4 AS Amount4
		,TAB2.AOPDH_Amount_5 AS Amount5
		,TAB2.AOPDH_Amount_6 AS Amount6
		,TAB2.AOPDH_Amount_7 AS Amount7
		,TAB2.AOPDH_Amount_8 AS Amount8
		,TAB2.AOPDH_Amount_9 AS Amount9
		,TAB2.AOPDH_Amount_10 AS Amount10
		,TAB2.AOPDH_Amount_11 AS Amount11
		,TAB2.AOPDH_Amount_12 AS Amount12
		,TAB2.AOPDH_Amount_Y AS AmountY
		FROM (
		select a.ContractId,EId,EName,ContractNo,DepId AS DivisionCode,E.DivisionName,SUBDEPID AS SubBUCode,f.CC_NameCN SubBUName,C.DMA_SAP_Code SAPCode,C.DMA_ChineseName DealerName,G.AgreementBegin,AgreementEnd
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
		INNER JOIN V_AOPDealerHospital_Temp  TAB2 ON TAB1.ContractId=TAB2.AOPDH_Contract_ID
		INNER JOIN Hospital TAB3 ON TAB3.HOS_ID=TAB2.AOPDH_Hospital_ID
	
GO


