DROP PROCEDURE [Contract].[Proc_GetBjfInfo]
GO


CREATE PROCEDURE [Contract].[Proc_GetBjfInfo](@ContractId UNIQUEIDENTIFIER, @ContractType NVARCHAR(20))
AS
BEGIN
	IF @ContractType = 'Appointment'
	BEGIN
	    SELECT '新签约' BJF_0,
	           A.EName BJF_1_1,
	           B.Jus1_QDJL BJF_1_2,
	           B.Jus1_BKQY BJF_1_3,
	           B.Jus1_GJ BJF_1_4,
	           B.Jus1_QYF BJF_1_5,
	           C.CompanyName BJF_2_1,
	           B.Jus2_GSDZ BJF_2_2,
	           B.Jus3_JXSLX BJF_3_1,
	           CASE A.DealerType
	                WHEN 'T1' THEN 'Exclusive'
	                ELSE 'Non-Exclusive'
	           END BJF_3_2_Value,
	           CASE A.DealerType
	                WHEN 'T1' THEN '排他'
	                ELSE '非排他（标准）'
	           END BJF_3_2,
	           B.Jus3_DZYY BFJ_3_3,
	           B.Jus4_FWFW BJF_4_1_Value,
	           dbo.Func_GetCode2('CONST_CONTRACT_Jus4_FWFW', B.Jus4_FWFW) BJF_4_1,
	           B.Jus4_EWFWFW BJF_4_1_1_Value,
	           dbo.Func_GetCode2('CONST_CONTRACT_Jus4_EWFWFW', B.Jus4_EWFWFW) BJF_4_1_1,
	           B.Jus4_YWFW BJF_4_2,
	           D.DepFullName BJF_4_3,
	           B.Jus4_SQQY BJF_4_4,
	           B.Jus4_SQFW BJF_4_5,
	           B.Jus5_SFCD BJF_5_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus5_SFCD) BJF_5_1,
	           B.Jus5_YYSM BJF_5_2,
	           B.Jus5_JTMS BJF_5_3,
	           B.Jus6_ZMFS BJF_6_1_Value,
	           dbo.Func_GetCode2('CONST_CONTRACT_Jus6_ZMFS', B.Jus6_ZMFS) BJF_6_1,
	           B.Jus6_TJR BJF_6_2,
	           B.Jus6_QTFS BJF_6_3,
	           B.Jus6_JXSPG BJF_6_4_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus6_JXSPG) BJF_6_4,
	           B.Jus6_YY BJF_6_5_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_Jus6_YY', B.Jus6_YY) BJF_6_5,
	           B.Jus6_QTXX BJF_6_6,
	           B.Jus6_XWYQ BJF_6_7_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus6_XWYQ) BJF_6_7,
	           B.Jus7_ZZBJ BJF_7_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus7_ZZBJ) BJF_7_1,
	           B.Jus7_SX BJF_7_2,
	           B.Jus7_SYLW BJF_7_3_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus7_SYLW) BJF_7_3,
	           B.Jus7_HDMS BJF_7_4,
	           B.Jus8_YWZB BJF_8_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_Jus8_YWZB', B.Jus8_YWZB) BJF_8_1,
	           B.Jus8_QTQK BJF_8_2_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus8_QTQK) BJF_8_2,
	           B.Jus8_TSYY BJF_8_3,
	           B.Jus8_SFFGD BJF_8_4_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus8_SFFGD) BJF_8_4,
	           B.Jus8_FGDFS BJF_8_5,
	           B.Jus8_JL BJF_8_6_Value,
	           dbo.Func_GetCode2('CONST_CONTRACT_Jus8_JL', B.Jus8_JL) BJF_8_6,
	           B.Jus8_JLFS BJF_8_7
	    FROM   [Contract].AppointmentMain A,
	           dbo.DealerContractJustification B,
	           [Contract].AppointmentCandidate C,
	           interface.MDM_Department D
	    WHERE  A.DepId = B.DeptId
	           AND B.DealerId = C.CompanyID
	           AND A.ContractId = C.ContractId
	           AND A.DepId = D.DepID
	           AND A.ContractId = @ContractId
	END
	ELSE 
	IF @ContractType = 'Amendment'
	BEGIN
	    SELECT '商业条款修改' BJF_0,
	           A.EName BJF_1_1,
	           B.Jus1_QDJL BJF_1_2,
	           B.Jus1_BKQY BJF_1_3,
	           B.Jus1_GJ BJF_1_4,
	           B.Jus1_QYF BJF_1_5,
	           C.DMA_ChineseName BJF_2_1,
	           B.Jus2_GSDZ BJF_2_2,
	           B.Jus3_JXSLX BJF_3_1,
	           CASE A.DealerType
	                WHEN 'T1' THEN 'Exclusive'
	                ELSE 'Non-Exclusive'
	           END BJF_3_2_Value,
	           CASE A.DealerType
	                WHEN 'T1' THEN '排他'
	                ELSE '非排他（标准）'
	           END BJF_3_2,
	           B.Jus3_DZYY BFJ_3_3,
	           B.Jus4_FWFW BJF_4_1_Value,
	           dbo.Func_GetCode2('CONST_CONTRACT_Jus4_FWFW', B.Jus4_FWFW) BJF_4_1,
	           B.Jus4_EWFWFW BJF_4_1_1_Value,
	           dbo.Func_GetCode2('CONST_CONTRACT_Jus4_EWFWFW', B.Jus4_EWFWFW) BJF_4_1_1,
	           B.Jus4_YWFW BJF_4_2,
	           D.DepFullName BJF_4_3,
	           B.Jus4_SQQY BJF_4_4,
	           B.Jus4_SQFW BJF_4_5,
	           B.Jus5_SFCD BJF_5_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus5_SFCD) BJF_5_1,
	           B.Jus5_YYSM BJF_5_2,
	           B.Jus5_JTMS BJF_5_3,
	           B.Jus6_ZMFS BJF_6_1_Value,
	           dbo.Func_GetCode2('CONST_CONTRACT_Jus6_ZMFS', B.Jus6_ZMFS) BJF_6_1,
	           B.Jus6_TJR BJF_6_2,
	           B.Jus6_QTFS BJF_6_3,
	           B.Jus6_JXSPG BJF_6_4_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus6_JXSPG) BJF_6_4,
	           B.Jus6_YY BJF_6_5_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_Jus6_YY', B.Jus6_YY) BJF_6_5,
	           B.Jus6_QTXX BJF_6_6,
	           B.Jus6_XWYQ BJF_6_7_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus6_XWYQ) BJF_6_7,
	           B.Jus7_ZZBJ BJF_7_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus7_ZZBJ) BJF_7_1,
	           B.Jus7_SX BJF_7_2,
	           B.Jus7_SYLW BJF_7_3_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus7_SYLW) BJF_7_3,
	           B.Jus7_HDMS BJF_7_4,
	           B.Jus8_YWZB BJF_8_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_Jus8_YWZB', B.Jus8_YWZB) BJF_8_1,
	           B.Jus8_QTQK BJF_8_2_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus8_QTQK) BJF_8_2,
	           B.Jus8_TSYY BJF_8_3,
	           B.Jus8_SFFGD BJF_8_4_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus8_SFFGD) BJF_8_4,
	           B.Jus8_FGDFS BJF_8_5,
	           B.Jus8_JL BJF_8_6_Value,
	           dbo.Func_GetCode2('CONST_CONTRACT_Jus8_JL', B.Jus8_JL) BJF_8_6,
	           B.Jus8_JLFS BJF_8_7
	    FROM   [Contract].AmendmentMain A,
	           DealerContractJustification B,
	           DealerMaster C,
	           interface.MDM_Department D
	    WHERE  A.DepId = B.DeptId
	           AND A.CompanyID = B.DealerId
	           AND B.DealerId = C.DMA_ID
	           AND A.DepId = D.DepID
	           AND A.ContractId = @ContractId
	END
	ELSE 
	IF @ContractType = 'Renewal'
	BEGIN
	    SELECT '现有合同续约' BJF_0,
	           A.EName BJF_1_1,
	           B.Jus1_QDJL BJF_1_2,
	           B.Jus1_BKQY BJF_1_3,
	           B.Jus1_GJ BJF_1_4,
	           B.Jus1_QYF BJF_1_5,
	           C.DMA_ChineseName BJF_2_1,
	           B.Jus2_GSDZ BJF_2_2,
	           B.Jus3_JXSLX BJF_3_1,
	           CASE A.DealerType
	                WHEN 'T1' THEN 'Exclusive'
	                ELSE 'Non-Exclusive'
	           END BJF_3_2_Value,
	           CASE A.DealerType
	                WHEN 'T1' THEN '排他'
	                ELSE '非排他（标准）'
	           END BJF_3_2,
	           B.Jus3_DZYY BFJ_3_3,
	           B.Jus4_FWFW BJF_4_1_Value,
	           dbo.Func_GetCode2('CONST_CONTRACT_Jus4_FWFW', B.Jus4_FWFW) BJF_4_1,
	           B.Jus4_EWFWFW BJF_4_1_1_Value,
	           dbo.Func_GetCode2('CONST_CONTRACT_Jus4_EWFWFW', B.Jus4_EWFWFW) BJF_4_1_1,
	           B.Jus4_YWFW BJF_4_2,
	           D.DepFullName BJF_4_3,
	           B.Jus4_SQQY BJF_4_4,
	           B.Jus4_SQFW BJF_4_5,
	           B.Jus5_SFCD BJF_5_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus5_SFCD) BJF_5_1,
	           B.Jus5_YYSM BJF_5_2,
	           B.Jus5_JTMS BJF_5_3,
	           B.Jus6_ZMFS BJF_6_1_Value,
	           dbo.Func_GetCode2('CONST_CONTRACT_Jus6_ZMFS', B.Jus6_ZMFS) BJF_6_1,
	           B.Jus6_TJR BJF_6_2,
	           B.Jus6_QTFS BJF_6_3,
	           B.Jus6_JXSPG BJF_6_4_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus6_JXSPG) BJF_6_4,
	           B.Jus6_YY BJF_6_5_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_Jus6_YY', B.Jus6_YY) BJF_6_5,
	           B.Jus6_QTXX BJF_6_6,
	           B.Jus6_XWYQ BJF_6_7_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus6_XWYQ) BJF_6_7,
	           B.Jus7_ZZBJ BJF_7_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus7_ZZBJ) BJF_7_1,
	           B.Jus7_SX BJF_7_2,
	           B.Jus7_SYLW BJF_7_3_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus7_SYLW) BJF_7_3,
	           B.Jus7_HDMS BJF_7_4,
	           B.Jus8_YWZB BJF_8_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_Jus8_YWZB', B.Jus8_YWZB) BJF_8_1,
	           B.Jus8_QTQK BJF_8_2_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus8_QTQK) BJF_8_2,
	           B.Jus8_TSYY BJF_8_3,
	           B.Jus8_SFFGD BJF_8_4_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.Jus8_SFFGD) BJF_8_4,
	           B.Jus8_FGDFS BJF_8_5,
	           B.Jus8_JL BJF_8_6_Value,
	           dbo.Func_GetCode2('CONST_CONTRACT_Jus8_JL', B.Jus8_JL) BJF_8_6,
	           B.Jus8_JLFS BJF_8_7
	    FROM   [Contract].RenewalMain A,
	           DealerContractJustification B,
	           DealerMaster C,
	           interface.MDM_Department D
	    WHERE  A.DepId = B.DeptId
	           AND A.CompanyID = B.DealerId
	           AND B.DealerId = C.DMA_ID
	           AND A.DepId = D.DepID
	           AND A.ContractId = @ContractId
	END
END
GO


