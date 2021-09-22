DROP  PROCEDURE [Contract].[Proc_GetPcafInfo]
GO


CREATE PROCEDURE [Contract].[Proc_GetPcafInfo](@ContractId UNIQUEIDENTIFIER, @ContractType NVARCHAR(20))
AS
BEGIN
	IF @ContractType = 'Appointment'
	BEGIN
	    SELECT '新签约' PCAF_0,
	           CONVERT(NVARCHAR(10), B.AgreementBegin, 121) PCAF_4_1,
	           CONVERT(NVARCHAR(10), B.AgreementEnd, 121) PCAF_4_2,
	           C.Pre4_QXLY PCAF_4_3,
	           C.Pre4_FBZTK PCAF_4_4_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre4_FBZTK) PCAF_4_4,
	           C.Pre4_ZDLY PCAF_4_5,
	           C.Pre5_HB PCAF_5_1,
	           C.Pre5_HBLX PCAF_5_2,
	           C.Pre5_HBHL PCAF_5_3,
	           C.Pre6_HTJZ PCAF_6_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_Pre6_HTJZ', C.Pre6_HTJZ) PCAF_6_1,
	           C.Pre7_SFTZ PCAF_7_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_Pre7_SFTZ', C.Pre7_SFTZ) PCAF_7_1,
	           C.Pre7_TK PCAF_7_10,
	           C.Pre7_YJFW PCAF_7_11,
	           C.Pre7_GPSJ PCAF_7_12,
	           B.Payment PCAF_8_1_Value,
	           CASE B.Payment
	                WHEN 'Credit' THEN '往来账户'
	                WHEN 'COD' THEN '仅预付现金'
	                WHEN 'LC' THEN '信用证预付现金(LOC)'
	                ELSE ''
	           END PCAF_8_1,
	           B.CreditTerm PCAF_8_2_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_CreditTerm', B.CreditTerm) PCAF_8_2,
	           B.CreditLimit PCAF_8_3,
	           B.PayTerm PCAF_8_4,
	           B.IsDeposit PCAF_8_5_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.IsDeposit) PCAF_8_5,
	           B.Deposit PCAF_8_6,
	           REPLACE(
	                   REPLACE(
	                       REPLACE(B.Inform, 'Cash deposit', ''),
	                       'Company guarantee',
	                       ''
	                   ),
	                   'Real estate mortgage',
	                   ''
	               )
	            PCAF_8_7_Value,
	           dbo.Func_GetCode2(
	               'CONST_CONTRACT_Inform',
	               REPLACE(
	                   REPLACE(
	                       REPLACE(B.Inform, 'Cash deposit', ''),
	                       'Company guarantee',
	                       ''
	                   ),
	                   'Real estate mortgage',
	                   ''
	               )
	           ) PCAF_8_7,
	           CASE ISNULL(B.InformOther, '')
	                WHEN '' THEN ''
	                ELSE B.InformOther + ','
	           END + dbo.Func_GetCode2(
	               'CONST_CONTRACT_Inform',
	               REPLACE(
	                   REPLACE(
	                       REPLACE(B.Inform, 'Bank guarantee', ''),
	                       'Credit Letter',
	                       ''
	                   ),
	                   'Others',
	                   ''
	               )
	           ) PCAF_8_8,
	           C.Pre9_SHPZ PCAF_9_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_SHPZ) PCAF_9_1,
	           C.Pre9_QYSQ PCAF_9_2_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_QYSQ) PCAF_9_2,
	           C.Pre9_JKZS PCAF_9_3_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_JKZS) PCAF_9_3,
	           C.Pre9_4 PCAF_9_4_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_4) PCAF_9_4,
	           C.Pre9_5 PCAF_9_5_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_5) PCAF_9_5
	    FROM   [Contract].AppointmentMain A,
	           [Contract].AppointmentProposals B,
	           [Contract].PreContractApproval C
	    WHERE  A.ContractId = B.ContractId
	           AND A.ContractId = C.ContractId
	           AND A.ContractId = @ContractId
	    
	    SELECT A.Pre5_FWXZ PCAF_5_4,
	           C.DepFullName PCAF_5_5,
	           A.Pre5_NF PCAF_5_6,
	           CONVERT(DECIMAL(18, 2), A.Pre5_Q1) PCAF_5_7,
	           CONVERT(DECIMAL(18, 2), A.Pre5_Q2) PCAF_5_8,
	           CONVERT(DECIMAL(18, 2), A.Pre5_Q3) PCAF_5_9,
	           CONVERT(DECIMAL(18, 2), A.Pre5_Q4) PCAF_5_10,
	           CONVERT(DECIMAL(18, 2), A.Pre5_HJ) PCAF_5_11,
	           A.Pre5_DB PCAF_5_12
	    FROM   [Contract].PreContractQuota A,
	           [Contract].AppointmentMain B,
	           interface.MDM_Department C
	    WHERE  A.ContractId = B.ContractId
	           AND B.DepId = C.DepID
	           AND A.ContractId = @ContractId
	    ORDER BY
	           A.SortNo
	END
	ELSE 
	IF @ContractType = 'Amendment'
	BEGIN
	    SELECT '商业条款修改' PCAF_0,
	           CONVERT(NVARCHAR(10), A.AmendEffectiveDate, 121) PCAF_4_1,
	           CONVERT(NVARCHAR(10), A.DealerEndDate, 121) PCAF_4_2,
	           C.Pre4_QXLY PCAF_4_3,
	           C.Pre4_FBZTK PCAF_4_4_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre4_FBZTK) PCAF_4_4,
	           C.Pre4_ZDLY PCAF_4_5,
	           C.Pre5_HB PCAF_5_1,
	           C.Pre5_HBLX PCAF_5_2,
	           C.Pre5_HBHL PCAF_5_3,
	           C.Pre6_HTJZ PCAF_6_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_Pre6_HTJZ', C.Pre6_HTJZ) PCAF_6_1,
	           C.Pre7_SFTZ PCAF_7_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_Pre7_SFTZ', C.Pre7_SFTZ) PCAF_7_1,
	           C.Pre7_TK PCAF_7_10,
	           C.Pre7_YJFW PCAF_7_11,
	           C.Pre7_GPSJ PCAF_7_12,
	           B.Payment PCAF_8_1_Value,
	           CASE B.Payment
	                WHEN 'Credit' THEN '往来账户'
	                WHEN 'COD' THEN '仅预付现金'
	                WHEN 'LC' THEN '信用证预付现金(LOC)'
	                ELSE ''
	           END PCAF_8_1,
	           B.CreditTerm PCAF_8_2_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_CreditTerm', B.CreditTerm) PCAF_8_2,
	           B.CreditLimit PCAF_8_3,
	           B.PayTerm PCAF_8_4,
	           B.IsDeposit PCAF_8_5_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.IsDeposit) PCAF_8_5,
	           B.Deposit PCAF_8_6,
	           REPLACE(
	                   REPLACE(
	                       REPLACE(B.Inform, 'Cash deposit', ''),
	                       'Company guarantee',
	                       ''
	                   ),
	                   'Real estate mortgage',
	                   ''
	               )
	            PCAF_8_7_Value,
	           dbo.Func_GetCode2(
	               'CONST_CONTRACT_Inform',
	               REPLACE(
	                   REPLACE(
	                       REPLACE(B.Inform, 'Cash deposit', ''),
	                       'Company guarantee',
	                       ''
	                   ),
	                   'Real estate mortgage',
	                   ''
	               )
	           ) PCAF_8_7,
	           CASE ISNULL(B.InformOther, '')
	                WHEN '' THEN ''
	                ELSE B.InformOther + ','
	           END + dbo.Func_GetCode2(
	               'CONST_CONTRACT_Inform',
	               REPLACE(
	                   REPLACE(
	                       REPLACE(B.Inform, 'Bank guarantee', ''),
	                       'Credit Letter',
	                       ''
	                   ),
	                   'Others',
	                   ''
	               )
	           ) PCAF_8_8,
	           C.Pre9_SHPZ PCAF_9_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_SHPZ) PCAF_9_1,
	           C.Pre9_QYSQ PCAF_9_2_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_QYSQ) PCAF_9_2,
	           C.Pre9_JKZS PCAF_9_3_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_JKZS) PCAF_9_3,
	           C.Pre9_4 PCAF_9_4_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_4) PCAF_9_4,
	           C.Pre9_5 PCAF_9_5_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_5) PCAF_9_5
	    FROM   [Contract].AmendmentMain A,
	           [Contract].AmendmentProposals B,
	           [Contract].PreContractApproval C
	    WHERE  A.ContractId = B.ContractId
	           AND A.ContractId = C.ContractId
	           AND A.ContractId = @ContractId
	    
	    SELECT A.Pre5_FWXZ PCAF_5_4,
	           C.DepFullName PCAF_5_5,
	           A.Pre5_NF PCAF_5_6,
	           CONVERT(DECIMAL(18, 2), A.Pre5_Q1) PCAF_5_7,
	           CONVERT(DECIMAL(18, 2), A.Pre5_Q2) PCAF_5_8,
	           CONVERT(DECIMAL(18, 2), A.Pre5_Q3) PCAF_5_9,
	           CONVERT(DECIMAL(18, 2), A.Pre5_Q4) PCAF_5_10,
	           CONVERT(DECIMAL(18, 2), A.Pre5_HJ) PCAF_5_11,
	           A.Pre5_DB PCAF_5_12
	    FROM   [Contract].PreContractQuota A,
	           [Contract].AmendmentMain B,
	           interface.MDM_Department C
	    WHERE  A.ContractId = B.ContractId
	           AND B.DepId = C.DepID
	           AND A.ContractId = @ContractId
	    ORDER BY
	           A.SortNo
	END
	ELSE 
	IF @ContractType = 'Renewal'
	BEGIN
	    SELECT '现有合同续约' PCAF_0,
	           CONVERT(NVARCHAR(10), B.AgreementBegin, 121) PCAF_4_1,
	           CONVERT(NVARCHAR(10), B.AgreementEnd, 121) PCAF_4_2,
	           C.Pre4_QXLY PCAF_4_3,
	           C.Pre4_FBZTK PCAF_4_4_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre4_FBZTK) PCAF_4_4,
	           C.Pre4_ZDLY PCAF_4_5,
	           C.Pre5_HB PCAF_5_1,
	           C.Pre5_HBLX PCAF_5_2,
	           C.Pre5_HBHL PCAF_5_3,
	           C.Pre6_HTJZ PCAF_6_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_Pre6_HTJZ', C.Pre6_HTJZ) PCAF_6_1,
	           C.Pre7_SFTZ PCAF_7_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_Pre7_SFTZ', C.Pre7_SFTZ) PCAF_7_1,
	           C.Pre7_TK PCAF_7_10,
	           C.Pre7_YJFW PCAF_7_11,
	           C.Pre7_GPSJ PCAF_7_12,
	           B.Payment PCAF_8_1_Value,
	           CASE B.Payment
	                WHEN 'Credit' THEN '往来账户'
	                WHEN 'COD' THEN '仅预付现金'
	                WHEN 'LC' THEN '信用证预付现金(LOC)'
	                ELSE ''
	           END PCAF_8_1,
	           B.CreditTerm PCAF_8_2_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_CreditTerm', B.CreditTerm) PCAF_8_2,
	           B.CreditLimit PCAF_8_3,
	           B.PayTerm PCAF_8_4,
	           B.IsDeposit PCAF_8_5_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', B.IsDeposit) PCAF_8_5,
	           B.Deposit PCAF_8_6,
	           REPLACE(
	                   REPLACE(
	                       REPLACE(B.Inform, 'Cash deposit', ''),
	                       'Company guarantee',
	                       ''
	                   ),
	                   'Real estate mortgage',
	                   ''
	               )
	            PCAF_8_7_Value,
	           dbo.Func_GetCode2(
	               'CONST_CONTRACT_Inform',
	               REPLACE(
	                   REPLACE(
	                       REPLACE(B.Inform, 'Cash deposit', ''),
	                       'Company guarantee',
	                       ''
	                   ),
	                   'Real estate mortgage',
	                   ''
	               )
	           ) PCAF_8_7,
	           CASE ISNULL(B.InformOther, '')
	                WHEN '' THEN ''
	                ELSE B.InformOther + ','
	           END + dbo.Func_GetCode2(
	               'CONST_CONTRACT_Inform',
	               REPLACE(
	                   REPLACE(
	                       REPLACE(B.Inform, 'Bank guarantee', ''),
	                       'Credit Letter',
	                       ''
	                   ),
	                   'Others',
	                   ''
	               )
	           ) PCAF_8_8,
	           C.Pre9_SHPZ PCAF_9_1_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_SHPZ) PCAF_9_1,
	           C.Pre9_QYSQ PCAF_9_2_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_QYSQ) PCAF_9_2,
	           C.Pre9_JKZS PCAF_9_3_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_JKZS) PCAF_9_3,
	           C.Pre9_4 PCAF_9_4_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_4) PCAF_9_4,
	           C.Pre9_5 PCAF_9_5_Value,
	           dbo.Func_GetCode('CONST_CONTRACT_YesNo', C.Pre9_5) PCAF_9_5
	    FROM   [Contract].RenewalMain A,
	           [Contract].RenewalProposals B,
	           [Contract].PreContractApproval C
	    WHERE  A.ContractId = B.ContractId
	           AND A.ContractId = C.ContractId
	           AND A.ContractId = @ContractId
	    
	    SELECT A.Pre5_FWXZ PCAF_5_4,
	           C.DepFullName PCAF_5_5,
	           A.Pre5_NF PCAF_5_6,
	           CONVERT(DECIMAL(18, 2), A.Pre5_Q1) PCAF_5_7,
	           CONVERT(DECIMAL(18, 2), A.Pre5_Q2) PCAF_5_8,
	           CONVERT(DECIMAL(18, 2), A.Pre5_Q3) PCAF_5_9,
	           CONVERT(DECIMAL(18, 2), A.Pre5_Q4) PCAF_5_10,
	           CONVERT(DECIMAL(18, 2), A.Pre5_HJ) PCAF_5_11,
	           A.Pre5_DB PCAF_5_12
	    FROM   [Contract].PreContractQuota A,
	           [Contract].RenewalMain B,
	           interface.MDM_Department C
	    WHERE  A.ContractId = B.ContractId
	           AND B.DepId = C.DepID
	           AND A.ContractId = @ContractId
	    ORDER BY
	           A.SortNo
	END
	
	SELECT A.Pre7_FWLX PCAF_7_2,
	       A.Pre7_YJ PCAF_7_3,
	       A.Pre7_YJBL PCAF_7_4,
	       A.Pre7_LR PCAF_7_5,
	       A.Pre7_LRFW PCAF_7_6,
	       A.Pre7_JDXFK PCAF_7_7,
	       A.Pre7_QKDJ PCAF_7_8,
	       A.Pre7_QT PCAF_7_9
	FROM   [Contract].PreContractService A
	WHERE  A.ContractId = @ContractId
	ORDER BY
	       A.SortNo
END
GO


