DROP FUNCTION [Contract].[Func_GetAmendmentLpHtml]
GO


CREATE FUNCTION [Contract].[Func_GetAmendmentLpHtml]
(
	@ContractId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Rtn NVARCHAR(MAX);
	
	SET @Rtn = '<style type="text/css">table.gridtable {width:100%; font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;}td.title{background-color: #E8E8E8;font-weight:bold;}</style>'
	
	--�Ƿ�DRM�û�����������RSMѡ�� 2016-11-09
	DECLARE @IsDrm BIT;
	SELECT @IsDrm = CASE 
	                     WHEN A.DepID = '5' THEN 1
	                     ELSE 0
	                END
	FROM   interface.MDM_EmployeeMaster A,
	       Lafite_IDENTITY B,
	       [Contract].TerminationMain C
	WHERE  A.account = B.IDENTITY_CODE
	       AND B.Id = C.CreateUser
	       AND C.ContractId = @ContractId
	
	--PreContract
	DECLARE @Pre1_HTLX NVARCHAR(2000) ;
	DECLARE @Pre4_FBZTK NVARCHAR(2000) ;
	DECLARE @Pre4_FBZTKShow NVARCHAR(2000) ;
	DECLARE @Pre4_ZDLY NVARCHAR(2000) ;
	DECLARE @Pre6_HTJZShow NVARCHAR(2000) ;
	DECLARE @Pre7_SFTZShow NVARCHAR(2000) ;
	DECLARE @Pre9_SHPZShow NVARCHAR(2000) ;
	DECLARE @Pre9_QYSQShow NVARCHAR(2000) ;
	DECLARE @Pre9_JKZSShow NVARCHAR(2000) ;
	
	SELECT @Pre1_HTLX = ISNULL(A.Pre1_HTLX, ''),
	       @Pre4_FBZTK = ISNULL(A.Pre4_FBZTK, ''),
	       @Pre4_FBZTKShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Pre4_FBZTK),
	       @Pre4_ZDLY = ISNULL(A.Pre4_ZDLY, ''),
	       @Pre6_HTJZShow = dbo.Func_GetCode('CONST_CONTRACT_Pre6_HTJZ', A.Pre6_HTJZ),
	       @Pre7_SFTZShow = dbo.Func_GetCode('CONST_CONTRACT_Pre7_SFTZ', A.Pre7_SFTZ),
	       @Pre9_SHPZShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Pre9_SHPZ),
	       @Pre9_QYSQShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Pre9_QYSQ),
	       @Pre9_JKZSShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Pre9_JKZS)
	FROM   [Contract].PreContractApproval A
	WHERE  A.ContractId = @ContractId; 
	
	--Main
	DECLARE @ContractNo NVARCHAR(200) ;
	DECLARE @DealerType NVARCHAR(200) ;
	DECLARE @DealerTypeShow NVARCHAR(200) ;
	DECLARE @DepId NVARCHAR(200) ;
	DECLARE @DepIdShow NVARCHAR(200) ;
	DECLARE @SUBDEPID NVARCHAR(200) ;
	DECLARE @SUBDEPIDShow NVARCHAR(200) ;
	DECLARE @EName NVARCHAR(200) ;
	DECLARE @ApplicantDepShow NVARCHAR(200) ;
	DECLARE @RequestDate NVARCHAR(200) ;
	DECLARE @CompanyID NVARCHAR(200) ;
	DECLARE @DealerName NVARCHAR(200) ;
	DECLARE @DealerNameShow NVARCHAR(500) ;
	DECLARE @MarketType NVARCHAR(200) ;
	DECLARE @MarketTypeShow NVARCHAR(200) ;
	DECLARE @DealerBeginDate NVARCHAR(200) ;
	DECLARE @DealerEndDate NVARCHAR(200) ;
	DECLARE @AmendEffectiveDate NVARCHAR(200) ;
	DECLARE @Purpose NVARCHAR(500) ;
	DECLARE @IsEquipmentShow NVARCHAR(200) ;	
	DECLARE @ReagionRSMShow NVARCHAR(200) ;
	DECLARE @AOPTYPE NVARCHAR(200) ;
	DECLARE @PRICEAUTO NVARCHAR(200) ;
	DECLARE @REBATEAUTO NVARCHAR(200) ;
	DECLARE @HospitalType NVARCHAR(200) ;
	DECLARE @IsLP NVARCHAR(200) ;
	DECLARE @IsFirstContract NVARCHAR(20);
	
	SELECT @ContractNo = ISNULL(ContractNo, ''),
	       @DealerType = A.DealerType,
	       @DealerTypeShow = dbo.Func_GetCode('CONST_CONTRACT_DealerType', A.DealerType),
	       @DepId = A.DepId,
	       @DepIdShow = ISNULL(B.DepFullName, ''),
	       @SUBDEPID = A.SUBDEPID,
	       @SUBDEPIDShow = ISNULL(C.CC_NameCN, ''),
	       @EName = ISNULL(EName, ''),
	       @ApplicantDepShow = ISNULL(F.DepFullName, ''),
	       @RequestDate = ISNULL(CONVERT(NVARCHAR(10), RequestDate, 121), ''),
	       @CompanyID = ISNULL(A.CompanyID, ''),
	       @DealerName = ISNULL(A.DealerName, ''),
	       @DealerNameShow = ISNULL(D.DMA_SAP_Code + ' - ' + D.DMA_ChineseName, ''),
	       @MarketType = MarketType,
	       @MarketTypeShow = dbo.Func_GetCode('CONST_CONTRACT_MarketType', A.MarketType),
	       @DealerBeginDate = ISNULL(CONVERT(NVARCHAR(10), DealerBeginDate, 121), ''),
	       @DealerEndDate = ISNULL(CONVERT(NVARCHAR(10), DealerEndDate, 121), ''),
	       @AmendEffectiveDate = ISNULL(CONVERT(NVARCHAR(10), AmendEffectiveDate, 121), ''),
	       @Purpose = A.Purpose,
	       @IsEquipmentShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsEquipment),
	       @ReagionRSMShow = (
	           SELECT TOP 1 T.ManagerName
	           FROM   MDM_Manager T
	           WHERE  A.ReagionRSM = T.EmpNo
	                  AND T.ManagerTitle = 'RSM'
	       ),
	       @AOPTYPE = A.AOPTYPE,
	       @PRICEAUTO = A.PRICEAUTO,
	       @REBATEAUTO = A.REBATEAUTO,
	       @HospitalType = A.HospitalType,
	       @IsLP = A.IsLP,
	       @IsFirstContract = A.IsFirstContract
	FROM   [Contract].AmendmentMain A
	       LEFT JOIN interface.mdm_department B
	            ON  CONVERT(NVARCHAR(10), A.DepId) = B.DepID
	       LEFT JOIN interface.ClassificationContract C
	            ON  A.SUBDEPID = C.CC_Code
	       LEFT JOIN DealerMaster D
	            ON  A.DealerName = D.DMA_SAP_Code
	       LEFT JOIN interface.mdm_department F
	            ON  CONVERT(NVARCHAR(10), A.ApplicantDep) = F.DepID
	WHERE  A.ContractId = @ContractId;
	
	--Justification
	DECLARE @Jus1_QDJLShow NVARCHAR(500) ;
	DECLARE @Jus3_JXSLX NVARCHAR(500) ;
	DECLARE @Jus3_DZYY NVARCHAR(500) ;
	DECLARE @Jus4_FWFW NVARCHAR(500) ;
	DECLARE @Jus4_FWFWShow NVARCHAR(500) ;
	DECLARE @Jus4_EWFWFW NVARCHAR(500) ;
	DECLARE @Jus4_EWFWFWShow NVARCHAR(500) ;
	DECLARE @Jus4_YWFW NVARCHAR(500) ;
	DECLARE @Jus4_SQFW NVARCHAR(500) ;
	DECLARE @Jus5_SFCD NVARCHAR(500) ;
	DECLARE @Jus5_SFCDShow NVARCHAR(500) ;
	DECLARE @Jus5_YYSM NVARCHAR(500) ;
	DECLARE @Jus5_JTMS NVARCHAR(500) ;
	DECLARE @Jus6_ZMFS NVARCHAR(500) ;
	DECLARE @Jus6_ZMFSShow NVARCHAR(500) ;
	DECLARE @Jus6_TJR NVARCHAR(500) ;
	DECLARE @Jus6_QTFS NVARCHAR(500) ;
	DECLARE @Jus6_JXSPG NVARCHAR(500) ;
	DECLARE @Jus6_JXSPGShow NVARCHAR(500) ;
	DECLARE @Jus6_YY NVARCHAR(500) ;
	DECLARE @Jus6_YYShow NVARCHAR(500) ;
	DECLARE @Jus6_QTXX NVARCHAR(500) ;
	DECLARE @Jus6_XWYQ NVARCHAR(500) ;
	DECLARE @Jus6_XWYQShow NVARCHAR(500) ;
	DECLARE @Jus7_ZZBJ NVARCHAR(500) ;
	DECLARE @Jus7_ZZBJShow NVARCHAR(500) ;
	DECLARE @Jus7_SX NVARCHAR(500) ;
	DECLARE @Jus7_SYLW NVARCHAR(500) ;
	DECLARE @Jus7_SYLWShow NVARCHAR(500) ;
	DECLARE @Jus7_HDMS NVARCHAR(500) ;
	DECLARE @Jus8_YWZBShow NVARCHAR(500) ;
	DECLARE @Jus8_SFFGD NVARCHAR(500) ;
	DECLARE @Jus8_SFFGDShow NVARCHAR(500) ;
	DECLARE @Jus8_FGDFS NVARCHAR(500) ;
	
	SELECT @Jus1_QDJLShow = ISNULL(Jus1_QDJL, ''),
	       @Jus3_JXSLX = ISNULL(Jus3_JXSLX, ''),
	       @Jus3_DZYY = ISNULL(Jus3_DZYY, ''),
	       @Jus4_FWFW = ISNULL(Jus4_FWFW, ''),
	       @Jus4_FWFWShow = dbo.Func_GetCode2('CONST_CONTRACT_Jus4_FWFW', A.Jus4_FWFW),
	       @Jus4_EWFWFW = ISNULL(Jus4_EWFWFW, ''),
	       @Jus4_EWFWFWShow = dbo.Func_GetCode2('CONST_CONTRACT_Jus4_EWFWFW', A.Jus4_EWFWFW),
	       @Jus4_YWFW = ISNULL(Jus4_YWFW, ''),
	       @Jus4_SQFW = ISNULL(Jus4_SQFW, ''),
	       @Jus5_SFCD = ISNULL(Jus5_SFCD, ''),
	       @Jus5_SFCDShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus5_SFCD),
	       @Jus5_YYSM = ISNULL(Jus5_YYSM, ''),
	       @Jus5_JTMS = ISNULL(Jus5_JTMS, ''),
	       @Jus6_ZMFS = ISNULL(Jus6_ZMFS, ''),
	       @Jus6_ZMFSShow = dbo.Func_GetCode2('CONST_CONTRACT_Jus6_ZMFS', A.Jus6_ZMFS),
	       @Jus6_TJR = ISNULL(Jus6_TJR, ''),
	       @Jus6_QTFS = ISNULL(Jus6_QTFS, ''),
	       @Jus6_JXSPG = ISNULL(Jus6_JXSPG, ''),
	       @Jus6_JXSPGShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus6_JXSPG),
	       @Jus6_YY = ISNULL(Jus6_YY, ''),
	       @Jus6_YYShow = dbo.Func_GetCode('CONST_CONTRACT_Jus6_YY', A.Jus6_YY),
	       @Jus6_QTXX = ISNULL(Jus6_QTXX, ''),
	       @Jus6_XWYQ = ISNULL(Jus6_XWYQ, ''),
	       @Jus6_XWYQShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus6_XWYQ),
	       @Jus7_ZZBJ = ISNULL(Jus7_ZZBJ, ''),
	       @Jus7_ZZBJShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus7_ZZBJ),
	       @Jus7_SX = ISNULL(Jus7_SX, ''),
	       @Jus7_SYLW = ISNULL(Jus7_SYLW, ''),
	       @Jus7_SYLWShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus7_SYLW),
	       @Jus7_HDMS = ISNULL(Jus7_HDMS, ''),
	       @Jus8_YWZBShow = dbo.Func_GetCode('CONST_CONTRACT_Jus8_YWZB', A.Jus8_YWZB),
	       @Jus8_SFFGD = ISNULL(Jus8_SFFGD, ''),
	       @Jus8_SFFGDShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus8_SFFGD),
	       @Jus8_FGDFS = ISNULL(Jus8_FGDFS, '')
	FROM   [Contract].AppointmentJustification A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>������Ϣ(Application Information)</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td colspan="6" style="color: red;">ƽ̨��һ�������̣�����Ӣ�����룡Please fill in English.</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td width="13%" class="title">���뵥��(Application No.)</td><td colspan="5">' + @ContractNo + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td width="13%" class="title">����������(Dealer Type)</td><td width="20%">' + @DealerTypeShow + '</td><td width="13%" class="title">��Ʒ��(Product Line)</td><td width="20%">' + @DepIdShow + '</td><td width="13%" class="title">��ͬ����(Sub-BU)</td><td width="21%">' + @SUBDEPIDShow + '</td></tr>'
	--Line 4
	SET @Rtn += '<tr><td class="title">������(Applicant)</td><td>' + @EName + '</td><td class="title">���벿��(Department)</td><td>' + @ApplicantDepShow + '</td><td class="title">��������(Request Date)</td><td>' + @RequestDate + '</td></tr>'
	--Line 4
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title">ָ���������� (Channel BP)</td><td>' + @Jus1_QDJLShow + '</td><td colspan="4">&nbsp;</td></tr>'
	END
	--Line 5
	SET @Rtn += '<tr><td class="title">������(Dealer Name)</td><td colspan="3">' + @DealerNameShow + '</td><td class="title">�г�����(Marketing Type)</td><td>' + @MarketTypeShow + '</td></tr>'
	--Line 6
	SET @Rtn += '<tr><td class="title">ԭЭ����Ч��(Agreement Effective Date)</td><td>' + @DealerBeginDate + '</td><td class="title">ԭЭ�鵽����(Agreement Expiry Date)</td><td>' + @DealerEndDate + '</td><td class="title">�޸���Ч��(Amendment Effective Date)</td><td>' + @AmendEffectiveDate + '</td></tr>'
	--Line 7
	SET @Rtn += '<tr><td class="title">�޸�ԭ��(Change Reason)</td><td colspan="3">' + @Purpose + '</td><td class="title">�Ƿ�Ϊ�豸�����̣�Equipment Dealer��</td><td>' + @IsEquipmentShow + '</td></tr>'
	--Line 8
	IF NOT (@DealerType = 'LP' AND @IsDrm = 1)
	   AND @DepId IN ('17', '19', '32', '35')
	BEGIN
	    SET @Rtn += '<tr><td class="title">RSM</td><td>' + @ReagionRSMShow + '</td><td colspan="4">&nbsp;</td></tr>'
	END
	
	SET @Rtn += '</table>'
	
	IF @IsFirstContract = '1'
	BEGIN
	    --Head
	    SET @Rtn += '<h4>�����̻�����Ϣ Dealer Basic Information</h4><table class="gridtable">'
	    --Line 1
	    SET @Rtn += '<tr><td class="title">ѡ��������������Ϊ Boston Scientific �ṩ�ķ������ͺͷ�Χ(Select the service type and scope that the channel partner will provide to Boston Scientific)</td><td colspan="5">' + @Jus4_FWFWShow + '</td></tr>'
	    --Line 2
	    IF EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Jus4_FWFW, ',') T
	           WHERE  T.VAL = '70'
	       )
	    BEGIN
	        SET @Rtn += '<tr><td class="title">��ѡ��������������Ϊ Boston Scientific �ṩ��������������(Please select the type(s) of other services the channel partner will provide to Boston Scientific )</td><td colspan="5">' + @Jus4_EWFWFWShow + '</td></tr>'
	    END
	    --Line 3
	    IF EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Jus4_FWFW, ',') T
	           WHERE  T.VAL = '70'
	       )
	       AND EXISTS (
	               SELECT 1
	               FROM   dbo.GC_Fn_SplitStringToTable(@Jus4_EWFWFW, ',') T
	               WHERE  T.VAL = '60'
	           )
	    BEGIN
	        SET @Rtn += '<tr><td class="title">�������������ṩ�ķ���δ�����������������г��������ṩ�÷�������������(If the channel partner is providing a service(s) not listed in the previous two questions, please provide a description of the service(s) being provided.)</td><td colspan="5">' + @Jus4_YWFW + '</td></tr>'
	    END
	    
	    SET @Rtn += '</table>'
	    
	    --Head
	    SET @Rtn += '<h4>����&�г��ľ������� Sales & Market competitiveness</h4><table class="gridtable">'
	    --Line 1
	    SET @Rtn += '<tr><td colspan="2" class="title">���֪����������������(How was the channel partner identified?)</td><td colspan="4">' + @Jus6_ZMFSShow + '</td></tr>'
	    --Line 3
	    IF EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_ZMFS, ',') T
	           WHERE  T.VAL = '70'
	       )
	    BEGIN
	        SET @Rtn += '<tr><td colspan="2" class="title">ע���Ƽ�����/�����ʵ�������/������(Identify the name of the referring party and/or related entity.)</td><td colspan="4">' + @Jus6_TJR + '</td></tr>'
	    END
	    --Line 3
	    IF EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_ZMFS, ',') T
	           WHERE  T.VAL = '80'
	       )
	    BEGIN
	        SET @Rtn += '<tr><td colspan="2" class="title">�ṩ���ڡ���������������(Provide a description for "Other".)</td><td colspan="4">' + @Jus6_QTFS + '</td></tr>'
	    END
	    --Line 3
	    SET @Rtn += '<tr><td colspan="2" class="title">�Ƿ����Կ��ṩ�÷����������������������������(Were other channel partners evaluated for the services to be performed?)</td><td colspan="4">' + @Jus6_JXSPGShow + '</td></tr>'
	    --Line 3
	    SET @Rtn += '<tr><td colspan="2" class="title">Ϊ��ѡ���������������(Why was this channel partner chosen?)</td><td colspan="4">' + @Jus6_YYShow + '</td></tr>'
	    --Line 3
	    IF EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_YY, ',') T
	           WHERE  T.VAL = '50'
	       )
	    BEGIN
	        SET @Rtn += '<tr><td colspan="2" class="title">�ṩ���ڡ���������������(Provide a description for "Other".)</td><td colspan="4">' + @Jus6_QTXX + '</td></tr>'
	    END
	    --Line 3
	    SET @Rtn += '<tr><td colspan="2" class="title">�������������� Boston Scientific �Ƿ�����κ������ͻ������� Boston Scientific Code of Conduct ����(If there is any conflict between this channel partner and Boston Scientific? (Please ref.  Boston Scientific Code of Conduct))</td><td colspan="4">' + @Jus6_XWYQShow + '</td></tr>'
	    SET @Rtn += '</table>'
	END
	
	--Current
	DECLARE @ProductAmend NVARCHAR(200) ;
	DECLARE @ProductAmendShow NVARCHAR(200) ;
	DECLARE @CurrentProduct NVARCHAR(4000) ;
	DECLARE @PriceAmend NVARCHAR(200) ;
	DECLARE @PriceAmendShow NVARCHAR(200) ;
	DECLARE @CurrentPrice NVARCHAR(4000) ;
	DECLARE @SalesAmend NVARCHAR(200) ;
	DECLARE @SalesAmendShow NVARCHAR(200) ;
	DECLARE @CurrentSpecialSales NVARCHAR(4000) ;
	DECLARE @HospitalAmend NVARCHAR(200) ;
	DECLARE @HospitalAmendShow NVARCHAR(200) ;
	DECLARE @CurrentHospital NVARCHAR(4000) ;
	DECLARE @QuotaAmend NVARCHAR(200) ;
	DECLARE @QuotaAmendShow NVARCHAR(200) ;
	DECLARE @CurrentQuota NVARCHAR(4000) ;
	DECLARE @PaymentAmend NVARCHAR(200) ;
	DECLARE @PaymentAmendShow NVARCHAR(200) ;
	DECLARE @CurrentPayment NVARCHAR(2000) ;
	DECLARE @CurrentAttachment NVARCHAR(200) ;	    
	
	SELECT @ProductAmend = ISNULL(ProductAmend, ''),
	       @ProductAmendShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.ProductAmend),
	       @CurrentProduct = ISNULL(Product, ''),
	       @PriceAmend = ISNULL(PriceAmend, ''),
	       @PriceAmendShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.PriceAmend),
	       @CurrentPrice = ISNULL(Price, ''),
	       @SalesAmend = ISNULL(SalesAmend, ''),
	       @SalesAmendShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.SalesAmend),
	       @CurrentSpecialSales = ISNULL(SpecialSales, ''),
	       @HospitalAmend = ISNULL(HospitalAmend, ''),
	       @HospitalAmendShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.HospitalAmend),
	       @CurrentHospital = SUBSTRING(Hospital, 0, CHARINDEX('<', Hospital)),
	       @QuotaAmend = ISNULL(QuotaAmend, ''),
	       @QuotaAmendShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.QuotaAmend),
	       @CurrentQuota = SUBSTRING(Quota, 0, CHARINDEX('<', Quota)),
	       @PaymentAmend = ISNULL(PaymentAmend, ''),
	       @PaymentAmendShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.PaymentAmend),
	       @CurrentPayment = ISNULL(Payment, ''),
	       @CurrentAttachment = ISNULL(Attachment, '')
	FROM   [Contract].AmendmentCurrent A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>��ǰЭ�����Original Agreement Term ��</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td width="25%" class="title">�Ƿ���(Change)</td><td width="25%">' + @ProductAmendShow + '</td><td width="25%" class="title">��Ʒ��(Product Line)</td><td width="25%">' + @CurrentProduct + '</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title">�Ƿ���(Change)</td><td>' + @PriceAmendShow + '</td><td class="title">�۸�(Price)</td><td>' + @CurrentPrice + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title">�Ƿ���(Change)</td><td>' + @SalesAmendShow + '</td><td class="title">���۷�������(Sales Rebate)</td><td>' + @CurrentSpecialSales + '</td></tr>'
	--Line 4
	DECLARE @CurrentHospitalUrl NVARCHAR(1000)
	SET @CurrentHospitalUrl = '';
	SET @CurrentHospitalUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'API.aspx?';
	SET @CurrentHospitalUrl += '&InstanceID=' + CONVERT(NVARCHAR(100), @ContractId);
	SET @CurrentHospitalUrl += '&DivisionID=' + @DepId;
	SET @CurrentHospitalUrl += '&PartsContractCode=' + @SUBDEPID;
	SET @CurrentHospitalUrl += '&DealerID=' + @CompanyID;
	SET @CurrentHospitalUrl += '&IsEmerging=' + @MarketType;
	SET @CurrentHospitalUrl += '&AOPType=' + @AOPTYPE;
	SET @CurrentHospitalUrl += '&NeedAuth=True';
	IF (@HospitalType = '0')
	BEGIN
	    SET @CurrentHospitalUrl += '&PageId=9';
	END
	ELSE
	BEGIN
	    SET @CurrentHospitalUrl += '&PageId=10';
	END
	
	SET @Rtn += '<tr><td class="title">�Ƿ���(Change)</td><td>' + @HospitalAmendShow + '</td><td class="title">����(ҽԺ)/Territory(Hospital)</td><td>' + @CurrentHospital + '&nbsp;<a href="' + @CurrentHospitalUrl + '" target="_blank">�鿴</a></td></tr>'
	--Line 5	
	DECLARE @CurrentQuotaUrl NVARCHAR(1000)
	SET @CurrentQuotaUrl = '';
	SET @CurrentQuotaUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'API.aspx?';
	SET @CurrentQuotaUrl += '&InstanceID=' + CONVERT(NVARCHAR(100), @ContractId);
	SET @CurrentQuotaUrl += '&DivisionID=' + @DepId;
	SET @CurrentQuotaUrl += '&PartsContractCode=' + @SUBDEPID;
	SET @CurrentQuotaUrl += '&DealerID=' + @CompanyID;
	SET @CurrentQuotaUrl += '&DealerType=' + @DealerType;
	SET @CurrentQuotaUrl += '&EffectiveDate=' + @AmendEffectiveDate;
	SET @CurrentQuotaUrl += '&ExpirationDate=' + @DealerEndDate;
	SET @CurrentQuotaUrl += '&IsEmerging=' + @MarketType;
	SET @CurrentQuotaUrl += '&AOPType=' + @AOPTYPE;
	SET @CurrentQuotaUrl += '&NeedAuth=True';
	SET @CurrentQuotaUrl += '&PageId=11';
	
	SET @Rtn += '<tr><td class="title">�Ƿ���(Change)</td><td>' + @QuotaAmendShow + '</td><td class="title">�ɹ�ָ��(CNY)/Purchase Quota(CNY)<br />(BSC SFX Rate:USD 1 = CNY 6.69)</td><td>' + @CurrentQuota + '&nbsp;<a href="' + @CurrentQuotaUrl + '" target="_blank">�鿴</a></td></td></tr>'
	--Line 6
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<td class="title">�Ƿ���(Change)</td><td>' + @PaymentAmendShow + '</td><td class="title">���ʽ(Payment)</td><td>' + @CurrentPayment + '</td></tr>'
	END
	--Line 7
	SET @Rtn += '<tr><td class="title">����(Attachment)</td><td colspan="3">' + dbo.Func_GetAttachmentHtml(@CurrentAttachment) + '</td></tr>'
	
	SET @Rtn += '</table>'
	
	--Proposals
	DECLARE @Product NVARCHAR(100) ;
	DECLARE @ProductRemark NVARCHAR(2000) ;
	DECLARE @Price NVARCHAR(50) ;
	DECLARE @PriceRemark NVARCHAR(4000) ;
	DECLARE @SpecialSales NVARCHAR(50) ;
	DECLARE @SpecialSalesRemark NVARCHAR(4000) ;
	DECLARE @Hospital NVARCHAR(2000) ;
	DECLARE @Quota NVARCHAR(2000) ;
	DECLARE @QuotaTotal NVARCHAR(20) ;
	DECLARE @QUOTAUSD NVARCHAR(20) ;
	DECLARE @Payment NVARCHAR(200) ;
	DECLARE @PaymentShow NVARCHAR(200) ;
	DECLARE @PayTerm NVARCHAR(200) ;
	DECLARE @CreditTermShow NVARCHAR(200) ;
	DECLARE @CreditLimit NVARCHAR(200) ;
	DECLARE @IsDeposit NVARCHAR(200) ;
	DECLARE @IsDepositShow NVARCHAR(200) ;
	DECLARE @Deposit NVARCHAR(200) ;
	DECLARE @Inform NVARCHAR(200) ;
	DECLARE @InformShow NVARCHAR(200) ;
	DECLARE @InformOther NVARCHAR(200) ;
	DECLARE @Comment NVARCHAR(200) ;
	DECLARE @DealerLessHosQ NVARCHAR(20) ;
	DECLARE @DealerLessHosReason NVARCHAR(200) ;
	DECLARE @DealerLessHosReasonQ NVARCHAR(200) ;
	DECLARE @DealerLessHosQRemark NVARCHAR(1000) ;
	DECLARE @HosLessStandardQ NVARCHAR(1000) ;
	DECLARE @HosLessStandardReason NVARCHAR(200) ;
	DECLARE @HosLessStandardReasonQ NVARCHAR(200) ;
	DECLARE @HosLessStandardQRemark NVARCHAR(1000) ;
	DECLARE @ChangeQuarter NVARCHAR(200) ;
	DECLARE @ChangeQuarterShow NVARCHAR(200) ;
	DECLARE @ChangeReason NVARCHAR(200) ;
	DECLARE @Attachment NVARCHAR(1000) ;
	DECLARE @ISVAT NVARCHAR(200) ;
	DECLARE @QUATOUP INT ;
	DECLARE @ProductGroupCheck NVARCHAR(200) ;
	DECLARE @ProductGroupRemark NVARCHAR(2000) ;
	DECLARE @ProductGroupMemo NVARCHAR(2000) ;
	
	SELECT @Product = dbo.Func_GetCode('CONST_CONTRACT_ProposalsProduct', A.Product),
	       @ProductRemark = ISNULL(ProductRemark, ''),
	       @Price = ISNULL(Price, ''),
	       @PriceRemark = ISNULL(PriceRemark, ''),
	       @SpecialSales = ISNULL(SpecialSales, ''),
	       @SpecialSalesRemark = ISNULL(SpecialSalesRemark, ''),
	       @Hospital = ISNULL(SUBSTRING(Hospital, 0, CHARINDEX('<', Hospital)), ''),
	       @Quota = ISNULL(SUBSTRING(Quota, 0, CHARINDEX('<', Quota)), ''),
	       @QuotaTotal = ISNULL(CONVERT(NVARCHAR(20), QuotaTotal), ''),
	       @QUOTAUSD = ISNULL(CONVERT(NVARCHAR(20), QUOTAUSD), ''),
	       @Payment = ISNULL(Payment, ''),
	       @PaymentShow = dbo.Func_GetCode('CONST_CONTRACT_Payment', A.Payment),
	       @PayTerm = ISNULL(PayTerm, ''),
	       @CreditTermShow = dbo.Func_GetCode('CONST_CONTRACT_CreditTerm', A.CreditTerm),
	       @CreditLimit = ISNULL(CreditLimit, ''),
	       @IsDeposit = ISNULL(IsDeposit, ''),
	       @IsDepositShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsDeposit),
	       @Deposit = ISNULL(Deposit, ''),
	       @Inform = ISNULL(Inform, ''),
	       @InformShow = dbo.Func_GetCode2('CONST_CONTRACT_Inform', A.Inform),
	       @InformOther = ISNULL(InformOther, ''),
	       @Comment = ISNULL(Comment, ''),
	       @DealerLessHosQ = ISNULL(DealerLessHosQ, ''),
	       @DealerLessHosReason = ISNULL(DealerLessHosReason, ''),
	       @DealerLessHosReasonQ = ISNULL(DealerLessHosReasonQ, ''),
	       @DealerLessHosQRemark = ISNULL(DealerLessHosQRemark, ''),
	       @HosLessStandardQ = ISNULL(HosLessStandardQ, ''),
	       @HosLessStandardReason = ISNULL(HosLessStandardReason, ''),
	       @HosLessStandardReasonQ = ISNULL(HosLessStandardReasonQ, ''),
	       @HosLessStandardQRemark = ISNULL(HosLessStandardQRemark, ''),
	       @ChangeQuarter = ISNULL(ChangeQuarter, ''),
	       @ChangeQuarterShow = dbo.Func_GetCode('CONST_CONTRACT_ChangeQuarter', A.ChangeQuarter),
	       @ChangeReason = ISNULL(ChangeReason, ''),
	       @Attachment = ISNULL(Attachment, ''),
	       @ISVAT = ISNULL(ISVAT, ''),
	       @QUATOUP = ISNULL(QUATOUP, ''),
	       @ProductGroupCheck = ISNULL(ProductGroupCheck, ''),
	       @ProductGroupRemark = ISNULL(ProductGroupRemark, ''),
	       @ProductGroupMemo = ISNULL(ProductGroupMemo, '')
	FROM   [Contract].AmendmentProposals A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>�޸ĺ�Э������ (Revised Agreement Term )</h4><table class="gridtable">'
	--Line 1
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title">��������Ŀǰ�Ƿ�ֱ�Ӿ��� BSC ���۲�������һ����������ִ�У�(Are the above services being excuted internally or another channel partner?)</td><td>' + @Jus5_SFCDShow + '</td>'
	    IF @Jus5_SFCD = '1'
	    BEGIN
	        SET @Rtn += '<td class="title">����Ϊ����Ҫ���ӻ������а��š�(Explain the reason for change)</td><td>' + @Jus5_YYSM + '</td></tr>'
	    END
	    ELSE
	    BEGIN
	        SET @Rtn += '<td>&nbsp;</td><td>&nbsp;</td></tr>'
	    END
	END
	--Line 2
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title">����ͨ����Ӷ���Ƽ����������������������ҵ������(Describe the business requestments that will be fulfilled by this channel partner)</td><td colspan="3">' + @Jus5_JTMS + '</td></tr>'
	END 
	--PreContract
	SET @Rtn += '<tr><td class="title" width="25%">��Э���Ƿ�����Ǳ�׼��ͬ�����������ֹ����ֹ֪ͨ���ޣ�ͨ��Ϊ 60 �죩���ع���棩��(Does the agreement contain non-standard contract provisions (end without reason,non-standard termination notification,inventory buyback))</td><td width="25%">' + @Pre4_FBZTKShow + '</td>'
	IF @Pre4_FBZTK = '1'
	BEGIN
	    SET @Rtn += '<td class="title" width="25%">���ṩ�Ǳ�׼������������ɡ�(Provide justification for the non-standard terms.��</td><td width="25%">' + @Pre4_ZDLY + '</td></tr>'
	END
	ELSE
	BEGIN
	    SET @Rtn += '<td width="25%">&nbsp;</td><td width="30%">&nbsp;</td></tr>'
	END
	--Line 1
	SET @Rtn += '<tr><td class="title">��Ʒ��(Product Line)</td><td>' + @Product + '</td><td class="title">(����ǲ��ֲ�Ʒ�ߣ����г�)(if partial, please list)</td><td>' + @ProductRemark + '</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title">�۸�<br/>��׼�۸��_%���ۿ�(Pricing Discount  _% off standard price list)</td><td>' + @Price + '</td><td class="title">��ע��Remark��</td><td>' + @PriceRemark + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title">���۷�������<br/>���Ȳɹ��ܶ��_% (Sales Rebate _% of the quarter purchase AMT)</td><td>' + @SpecialSales + '</td><td class="title">��ע��Remark��</td><td>' + @SpecialSalesRemark + '</td></tr>'
	--Line 4
	DECLARE @HospitalUrl NVARCHAR(1000)
	SET @HospitalUrl = '';
	SET @HospitalUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'API.aspx?ContractType=Amendment';
	SET @HospitalUrl += '&InstanceID=' + CONVERT(NVARCHAR(100), @ContractId);
	SET @HospitalUrl += '&DivisionID=' + @DepId;
	SET @HospitalUrl += '&PartsContractCode=' + @SUBDEPID;
	SET @HospitalUrl += '&TempDealerID=' + @CompanyID;
	SET @HospitalUrl += '&DealerType=' + @DealerType;
	SET @HospitalUrl += '&EffectiveDate=' + @AmendEffectiveDate;
	SET @HospitalUrl += '&ExpirationDate=' + @DealerEndDate;
	SET @HospitalUrl += '&IsEmerging=' + @MarketType;
	SET @HospitalUrl += '&IsArea=' + @IsLP;
	SET @HospitalUrl += '&ProductAmend=1' + @ProductAmend;
	SET @HospitalUrl += '&NeedAuth=True';
	SET @HospitalUrl += '&PageId=2';
	
	DECLARE @QuotaUrl NVARCHAR(1000)
	SET @QuotaUrl = '';
	SET @QuotaUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'API.aspx?ContractType=Amendment';
	SET @QuotaUrl += '&InstanceID=' + CONVERT(NVARCHAR(100), @ContractId);
	SET @QuotaUrl += '&DivisionID=' + @DepId;
	SET @QuotaUrl += '&PartsContractCode=' + @SUBDEPID;
	SET @QuotaUrl += '&TempDealerID=' + @CompanyID;
	SET @QuotaUrl += '&DealerType=' + @DealerType;
	SET @QuotaUrl += '&EffectiveDate=' + @AmendEffectiveDate;
	SET @QuotaUrl += '&ExpirationDate=' + @DealerEndDate;
	SET @QuotaUrl += '&IsEmerging=' + @MarketType;
	SET @QuotaUrl += '&AOPType=' + @AOPTYPE;
	SET @QuotaUrl += '&NeedAuth=True';
	SET @QuotaUrl += '&PageId=4';
	
	SET @Rtn += '<tr>'
	
	DECLARE @AuthUrl NVARCHAR(1000);
	SET @AuthUrl = '';
	SET @AuthUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'Contract/PagesEwf/Contract/AuthList.aspx?ContractId=' + CONVERT(NVARCHAR(100), @ContractId);
	SET @AuthUrl += '&SUBDEPID=' + @SUBDEPID;
	SET @AuthUrl += '&IsLP=' + @IsLP;
	SET @AuthUrl += '&AgreementBegin=' + @AmendEffectiveDate;
	
	IF @HospitalAmend = '1'
	BEGIN
	    SET @Rtn += '<td class="title">����(ҽԺ) Territory (Hospital)</td><td>' + @Hospital + '&nbsp;<a href="' + @HospitalUrl + '" target="_blank">�鿴</a>
	    <br/><a href="' + @AuthUrl + '" target="_blank"><h4>��Ȩ��ϸ�б�</h4></a>
	    </td>'
	END
	ELSE
	BEGIN
	    SET @Rtn += '<td class="title">����(ҽԺ) Territory (Hospital)</td><td>&nbsp;</td>'
	END
	IF @QuotaAmend = '1'
	BEGIN
	    SET @Rtn += '<td class="title">�ɹ�ָ��(CNY)/Purchase Quota(CNY)<br/>(BSC SFX Rate:USD 1 = CNY 6.69)</td><td>' + @Quota + '&nbsp;<a href="' + @QuotaUrl + '" target="_blank">�鿴</a></td>'
	END
	ELSE
	BEGIN
	    SET @Rtn += '<td class="title">�ɹ�ָ��(CNY)/Purchase Quota(CNY)<br/>(BSC SFX Rate:USD 1 = CNY 6.69)</td><td>&nbsp;</td>'
	END
	SET @Rtn += '</tr>'
	--Line 2
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title">������������Щ����/����ִ�У�(list the territory (hospital) which will be excuted.)</td><td colspan="3">' + @Jus4_SQFW + '</td></tr>'
	END
	--Line 5
	SET @Rtn += '<tr><td class="title">ָ���ܶ�(CNY)����˰ Quota Total (CNY Without VAT)</td><td>' + @QuotaTotal + '</td><td class="title">ָ���ܶ�(USD)����˰  Quota Total(USD Without VAT)</td><td>' + @QUOTAUSD + '</td></tr>'
	--Line 6
	SET @Rtn += '<tr><td class="title">���ʽ(Payment)</td><td>' + @PaymentShow + '</td><td colspan="3"></td></tr>'
	--PreContract
	IF @Payment = 'LC'
	BEGIN
	    SET @Rtn += '<tr><td class="title">Ӧ�ڶ���������ɸ��(Payable within how many days?)</td><td colspan="3">' + @PayTerm + '</td></tr>'
	END
	--Line 7
	IF @Payment = 'Credit'
	BEGIN
	    SET @Rtn += '<tr><td class="title">��������(����)(credit terms��Day)</td><td>' + @CreditTermShow + '</td><td class="title">���ö��(CNY, ����ֵ˰)(Credit Limit)</td><td>' + @CreditLimit + '</td></tr>'
	END
	--PreContract
	SET @Rtn += '<tr><td class="title" width="25%" >�Ƿ��е����� (Is there a security amount?)</td><td colspan="3">' + @IsDepositShow + '</td></tr>'
	
	--Line 8
	IF @IsDeposit = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title">��֤��(CNY) Deposit</td><td>' + @Deposit + '</td><td class="title">��֤����ʽ Deposit Type</td><td>' + @InformShow + '</td></tr>'
	END
	--Line 9
	IF @IsDeposit = '1'
	   AND EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Inform, ',')
	           WHERE  VAL = 'Others'
	       )
	BEGIN
	    SET @Rtn += '<tr><td class="title">��֤����ʽ��ע Deposit Type Remark</td><td colspan="3">' + @InformOther + '</td></tr></tr>'
	END
	--Line 10
	SET @Rtn += '<tr><td class="title">���ע Payment Remark</td><td colspan="3">' + @Comment + '</td></tr>'
	--Line 13
	SET @Rtn += '<tr><td class="title">�������ܼƲɹ�ָ��С���ܼ�ҽԺָ���ԭ�� Reason for total dealer commercial purchase target less than total hospital target</td><td >' + @DealerLessHosReason 
	
	if @DealerLessHosQ = '0'
	begin
	SET @Rtn += +@DealerLessHosQRemark+'</td>'
	end
	else 
	begin
		SET @Rtn +='</td>'
	end
	
	
	
	SET @Rtn+='<td class="title">�����̼���ָ��С��ҽԺ����ָ���ԭ�� (Reason for Dealer quarterly commercial purchase target less than hospital quarterly target)</td><td>' + @DealerLessHosReasonQ + '</td></tr>'
	--Line 14
	
	
	SET @Rtn += '<tr><td class="title">�ܼ�ҽԺʵ��ָ��С���ܼ�ҽԺ��׼ָ���ԭ�� (Reason for total actual hospital target less than total standard hospital target)</td><td >' + @HosLessStandardReason 
	IF @HosLessStandardQ = '0'
	BEGIN
	    SET @Rtn += + @HosLessStandardQRemark +'</td>'
	END
	else 
	begin
	   SET @Rtn +='</td>'
	   end
	
	SET @Rtn +='<td class="title" >ҽԺʵ�ʼ���ָ��С��ҽԺ��׼����ָ���ԭ�� ��Reason for quarterly actual hospital target less than quarterly standard hospital target��</td><td>' + @HosLessStandardReasonQ 
	--Line 17
	
	
	IF @ProductGroupCheck = '0'
	BEGIN
	   SET @Rtn += + @ProductGroupRemark +'</td></tr>'
	END
	else 
	begin
	   SET @Rtn +='</td></tr>'
	   end
	   
	   SET @Rtn += '<tr><td class="title">����ָ�����ԭ�� quarter target change reason</td><td>' + @ChangeQuarterShow + '</td><td class="title">����ָ����ĵ���ϸԭ�� quarter target change detail reason</td><td>' + @ChangeReason + '</td></tr>'

	SET @Rtn += '<tr><td class="title">��Ʒ����Сָ�걸ע Product group minimal target remark</td><td colspan="3" >' + @ProductGroupMemo + '</td></tr>'
	--Line 2
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title" width="25%">����������������Ĺ��ң�����Ϊ Boston Scientific �ĵ�Լ�����������г���(What portion of the Boston Scientific Contracting Party''' + 's business will be driven by the channel partner in the country where the channel partner is performing services?)</td><td colspan="3">' + @Jus8_YWZBShow + '</td></tr>'
	END
	--Line 1
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title" width="25%">�����������Ƿ���Ҫ��ǳ���ĸ�����������Ԥ�������������˻�����������ͬʵ�塢���������������������ڹ��ң���(Is the channel partner requesting non-routine payment terms (e.g.,advance payments, payments to multiple accounts, payments to a different entity, payments to a country other than where the channel partner is located)?)</td><td>' + @Jus8_SFFGDShow + '</td>'
	    IF @Jus8_SFFGD = '1'
	    BEGIN
	        SET @Rtn += '<td class="title" width="25%">�г��ǳ���ĸ�������(List the non-routine payment terms.)</td><td>' + @Jus8_FGDFS + '</td></tr>'
	    END
	    ELSE
	    BEGIN
	        SET @Rtn += '<td>&nbsp;</td><td>&nbsp;</td></tr>'
	    END
	END
	--Line 18
	
	SET @Rtn += '<tr><td colspan="4" style="margin: 10px !important; padding: 10px !important;"><table class="gridtable">';
	SET @Rtn += '<tr><td class="title" width="12%">��� (Year)</td><td class="title" width="12%">��һ����(Q1)</td><td class="title" width="12%">�ڶ�����(Q2)</td><td class="title" width="12%">��������(Q3)</td><td class="title" width="12%">���ļ���(Q4)</td><td class="title" width="12%">�ϼ�(Total)</td><td class="title" width="16%">% ����һ������۶� (% vs Actual purchase of LY )</td></tr>';
	
	DECLARE @Pre5_NF NVARCHAR(2000) ;
	DECLARE @Pre5_Q1 NVARCHAR(2000) ;
	DECLARE @Pre5_Q2 NVARCHAR(2000) ;
	DECLARE @Pre5_Q3 NVARCHAR(2000) ;
	DECLARE @Pre5_Q4 NVARCHAR(2000) ;
	DECLARE @Pre5_HJ NVARCHAR(2000) ;
	DECLARE @Pre5_DB NVARCHAR(2000) ;
	
	DECLARE CUR_QUOTA CURSOR  
	FOR
	    SELECT Pre5_NF,
	           Pre5_Q1,
	           Pre5_Q2,
	           Pre5_Q3,
	           Pre5_Q4,
	           Pre5_HJ,
	           Pre5_DB
	    FROM   [Contract].PreContractQuota
	    WHERE  ContractId = @ContractId
	    ORDER BY SortNo
	
	OPEN CUR_QUOTA
	FETCH NEXT FROM CUR_QUOTA INTO @Pre5_NF, @Pre5_Q1, @Pre5_Q2, @Pre5_Q3, @Pre5_Q4, @Pre5_HJ, @Pre5_DB
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @Rtn += '<tr><td>' + @Pre5_NF + '</td><td>' + @Pre5_Q1 + '</td><td>' + @Pre5_Q2 + '</td><td>' + @Pre5_Q3 + '</td><td>' + @Pre5_Q4 + '</td><td>' + @Pre5_HJ + '</td><td>' + @Pre5_DB + '</td></tr>';
	    FETCH NEXT FROM CUR_QUOTA INTO @Pre5_NF, @Pre5_Q1, @Pre5_Q2, @Pre5_Q3, @Pre5_Q4, @Pre5_HJ, @Pre5_DB
	END
	CLOSE CUR_QUOTA
	DEALLOCATE CUR_QUOTA
	
	SET @Rtn += '</table></td></tr>'
	
	--PreContract
	--SET @Rtn += '<tr><td>���ⶨ����Ⱥ�ͬ��ֵ�Ƕ��٣�</td><td colspan="3">' + @Pre6_HTJZShow + '</td></tr>'
	--PreContract
	SET @Rtn += '<tr><td class="title">������������Ϊ Boston Scientific �ṩ��ֻһ����񣬻����Ƿ����ݷ����������Ե�����(If the channel partner''' + 's reward will be changed with service type changing?)</td><td colspan="3">' + @Pre7_SFTZShow + '</td></tr>'
	
	--PreContract
	SET @Rtn += '<tr><td colspan="4" style="margin: 10px !important; padding: 10px !important;"><table class="gridtable">';
	SET @Rtn += '<tr><td class="title" width="33%">��������(Service Type)</td><td class="title" width="33%">������/��(Profit(Yes/no))</td><td class="title" width="34%">���ṩ������Χ(<10%, 10-20%, >20%)(Range (<10%,10-20%, >20%))</td></tr>';
	
	DECLARE @Pre7_FWLX NVARCHAR(2000) ;
	DECLARE @Pre7_LR NVARCHAR(2000) ;
	DECLARE @Pre7_LRFW NVARCHAR(2000) ;
	
	DECLARE CUR_SERVICE CURSOR  
	FOR
	    SELECT Pre7_FWLX,
	           Pre7_LR,
	           Pre7_LRFW
	    FROM   [Contract].PreContractService
	    WHERE  ContractId = @ContractId
	    ORDER BY SortNo
	
	OPEN CUR_SERVICE
	FETCH NEXT FROM CUR_SERVICE INTO @Pre7_FWLX, @Pre7_LR, @Pre7_LRFW
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @Rtn += '<tr><td>' + @Pre7_FWLX + '</td><td>' + @Pre7_LR + '</td><td>' + @Pre7_LRFW + '</td></tr>';
	    FETCH NEXT FROM CUR_SERVICE INTO @Pre7_FWLX, @Pre7_LR, @Pre7_LRFW
	END
	CLOSE CUR_SERVICE
	DEALLOCATE CUR_SERVICE
	
	SET @Rtn += '</table></td></tr>'
	
	--Line 17
	SET @Rtn += '<tr><td class="title">����(Attachment)</td><td colspan="3">' + dbo.Func_GetAttachmentHtml(@Attachment) + '</td></tr>'
	
	SET @Rtn += '</table>'
	
	--������
	DECLARE @Conflict NVARCHAR(100) ;
	DECLARE @ConflictShow NVARCHAR(100) ;
	DECLARE @ConflictRemark NVARCHAR(2000) ;
	DECLARE @Handover NVARCHAR(100) ;
	DECLARE @HandoverShow NVARCHAR(100) ;
	DECLARE @HandoverRemark NVARCHAR(2000) ;
	
	SELECT @Conflict = ISNULL(A.Conflict, ''),
	       @ConflictShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Conflict),
	       @ConflictRemark = ISNULL(A.ConflictRemark, ''),
	       @Handover = ISNULL(A.Handover, ''),
	       @HandoverShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Handover),
	       @HandoverRemark = ISNULL(A.HandoverRemark, '')
	FROM   [Contract].AmendmentNCM A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>����(Other)</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">1.) �������ҵ��ƻ������ӵ�ǰ������Э��Ĳ�Ʒ�߻�������ô�����κ��������о����̵Ķ���Э�������ͻ�𣿻��ǻ����κ�������������Ǳ�ڳ�ͻ��
	' + '��1.) If the business proposals above increase the current product line or territory of a dealer agreement, will it have conflicts with any other current dealers''' + ' (exclusive) contract terms, or will it have potential conflicts with any newly appointed dealers?��</td><td>' + @ConflictShow 

	IF @Conflict = '1'
	BEGIN
	    SET @Rtn += '</br>����ǣ���˵�� If yes, please explain</br>' + @ConflictRemark + '</td>'
	    
	    END	 
	    else 
	  begin
	   SET @Rtn +='</td>'
	   end   
	    --Line 3
	SET @Rtn += '<td class="title">2.) �������ҵ��ƻ���������ǰ������Э��Ĳ�Ʒ�߻�����˭���ӹ����������������ҵ��(
	' + '2.) If the business proposals above cut down the current product line or territory of a dealer agreement, who will take over the abandoned business from this dealer?)</td><td >' + @HandoverShow 
	--Line 4

	if @Handover = '1'
	BEGIN
	   set  @Rtn += '</br>����ǣ���˵�� If yes, please explain </br>'+ @HandoverRemark + '</td>'	    
	END
    else 
	  begin
	   SET @Rtn +='</td></tr>'
	   end   
	--Line 1
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title" width="25%">����������������������Ƿ���������Ա������(Dose the channel partner contact with foreign officials?)</td><td>' + @Jus7_ZZBJShow 
	    --Line 2
	    IF @Jus7_ZZBJ = '1'
	    BEGIN
	        SET @Rtn += '</br>�����˵Ƚ������ʡ�(Describe the nature of these interactions.)</br>' + @Jus7_SX + '</td>'
	    END
	    else 
	   begin
	   SET @Rtn +='</td>'
	   end   
	    
    --Line 3
	    SET @Rtn += '<td class="title">�����������Ƿ����� Boston Scientific ����������������������Ӧ�̡�������̡������磩������(Dose the channel partner behalf BSC to contact with other 3rd. Part? (e.g.logistics supplier, events service provider, travel agency.))</td><td>' + @Jus7_SYLWShow 
	    --Line 4
	    IF @Jus7_SYLW = '1'
	    BEGIN
	        SET @Rtn += '</br>�����˵Ƚ������ʡ�(Describe the nature of these interactions.)</br>' + @Jus7_HDMS + '</td></tr>'
	    END
	      else 
	   begin
	   SET @Rtn +='</td></tr>'
	   end  
	END
	--PreContract
	SET @Rtn += '<tr><td class="title" width="25%">�������������ǩ����Э���Ƿ���Ҫ������˺���׼���羭���һ��ع�֤����(Whether the agreement need to be approved by related organization? (such as government offices))</td><td>' + @Pre9_SHPZShow + '</td><td class="title" width="25%">�������������ǩ����Э���Ƿ���Ҫ����ǩԼ��Ȩ�� (Does an agreement with this channel partner require certification of appointment?)</td><td>' + @Pre9_QYSQShow + '</td></tr>'
	
	SET @Rtn += '<tr><td class="title">�������������ǩ����Э���Ƿ���Ҫ����֤�飿 (Whether the agreement needs import license?)</td><td colspan="3">' + @Pre9_JKZSShow + '</td></tr>'
	
	
	
	
	
	
	--PreContract
	--SET @Rtn += '<tr><td class="title" >�������������ǩ����Э���Ƿ���Ҫ������˺���׼���羭���һ��ع�֤����(Whether the agreement need to be approved by related organization? (such as government offices))</td><td colspan="3">' + @Pre9_SHPZShow + '</td></tr>'
	--PreContract
	--SET @Rtn += '<tr><td class="title"width="25%">�������������ǩ����Э���Ƿ���Ҫ����ǩԼ��Ȩ�� (Whether the agreement need to authorized in written.)</td><td>' + @Pre9_QYSQShow + '</td>
	--<td class="title"width="25%">�������������ǩ����Э���Ƿ���Ҫ����֤�飿 (Whether the agreement needs import license?)</td><td>' + @Pre9_JKZSShow + '</td></tr>'
	
	SET @Rtn += '</table>' 
	
	--��ʷKPI
	DECLARE @KpiYear NVARCHAR(500) ;
	DECLARE @KpiQuarter NVARCHAR(500) ;
	DECLARE @KpiMonth NVARCHAR(500) ;
	DECLARE @KpiDivision NVARCHAR(500) ;
	DECLARE @KpiSubBUName NVARCHAR(500) ;
	DECLARE @KpiTotalScore NVARCHAR(500) ;
	
	DECLARE CUR_KPI CURSOR  
	FOR
	    SELECT A.Column1 [Year],
	           A.Column2 [Quarter],
	           A.Column3 [Month],
	           A.Column5 Division,
	           A.Column7 SubBUName,
	           A.Column11 TotalScore
	    FROM   DP.DealerMaster A
	    WHERE  ModleID = '00000002-0002-0001-0000-000000000000'
	           AND DealerId = @CompanyID
	           AND (
	                   (
	                       DATEPART(MONTH, CONVERT(DATETIME, @RequestDate, 121)) IN (1, 2, 3)
	                       AND Column1 = DATEPART(
	                               YEAR,
	                               DATEADD(YEAR, -1, CONVERT(DATETIME, @RequestDate, 121))
	                           )
	                   )
	                   OR (
	                          DATEPART(MONTH, CONVERT(DATETIME, @RequestDate, 121)) NOT IN (1, 2, 3)
	                          AND Column1 = DATEPART(YEAR, CONVERT(DATETIME, @RequestDate, 121))
	                      )
	               )  ORDER BY A.Column5,A.Column7, A.Column1,A.Column2
	
	--Head
	SET @Rtn += '<h4>��ʷKPI History KPI</h4><table class="gridtable">'
	SET @Rtn += '<tr><td class="title" width="19%">��� Year</td><td class="title" width="19%">���� Quarter</td><td class="title" width="20%">Division</td><td class="title" width="21%">Sub BU</td><td class="title" width="21%">�ܷ� Score</td></tr>'
	
	OPEN CUR_KPI
	FETCH NEXT FROM CUR_KPI INTO @KpiYear,@KpiQuarter,@KpiMonth,@KpiDivision,@KpiSubBUName,@KpiTotalScore
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @Rtn += '<tr><td>' + @KpiYear + '</td><td>' + @KpiQuarter + '</td><td>' + @KpiDivision + '</td><td>' + @KpiSubBUName + '</td><td>' + @KpiTotalScore + '</td></tr>'
	    
	    FETCH NEXT FROM CUR_KPI INTO @KpiYear,@KpiQuarter,@KpiMonth,@KpiDivision,@KpiSubBUName,@KpiTotalScore
	END
	CLOSE CUR_KPI
	DEALLOCATE CUR_KPI
	
	SET @Rtn += '</table>'
	
	--CFDA��Ʒ����
	DECLARE @GM_KIND NVARCHAR(500) ;
	DECLARE @GM_CATALOG NVARCHAR(500) ;
	DECLARE @CatagoryName NVARCHAR(500) ;
	
	DECLARE CUR_CFDA CURSOR  
	FOR
	    SELECT DISTINCT A.GM_KIND,
	           A.GM_CATALOG,
	           A.CatagoryName
	    FROM   V_SubBU_CFDACatalog A,
	           interface.ClassificationAuthorization B
	    WHERE  A.CA_ID = B.CA_ID
	           AND B.CA_ParentCode = @SUBDEPID
	
	--Head
	SET @Rtn += '<h4>CFDA��Ʒ���� CFDA Product Category</h4><table class="gridtable">'
	SET @Rtn += '<tr><td class="title" width="33%">���(level 1)</td><td class="title" width="33%">�������(level 2)</td><td class="title" width="34%">��������(Product Name)</td></tr>'
	
	OPEN CUR_CFDA
	FETCH NEXT FROM CUR_CFDA INTO @GM_KIND,@GM_CATALOG,@CatagoryName
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @Rtn += '<tr><td>' + @GM_KIND + '</td><td>' + @GM_CATALOG + '</td><td>' + @CatagoryName + '</td></tr>'
	    
	    FETCH NEXT FROM CUR_CFDA INTO @GM_KIND,@GM_CATALOG,@CatagoryName
	END
	CLOSE CUR_CFDA
	DEALLOCATE CUR_CFDA
	
	SET @Rtn += '</table>'
	
	--�����ļ�
	SET @Rtn += [Contract].Func_GetQualificationFileHtml(@CompanyID);
	/*
	DECLARE @AuthUrl NVARCHAR(1000);
	SET @AuthUrl = '';
	SET @AuthUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'Contract/PagesEwf/Contract/AuthList.aspx?ContractId=' + CONVERT(NVARCHAR(100), @ContractId);
	SET @AuthUrl += '&SUBDEPID=' + @SUBDEPID;
	SET @AuthUrl += '&IsLP=' + @IsLP;
	SET @AuthUrl += '&AgreementBegin=' + @AmendEffectiveDate;
	
	SET @Rtn += '<a href="' + @AuthUrl + '" target="_blank"><h4>��Ȩ��ϸ�б�</h4></a>'
	*/
	RETURN ISNULL(@Rtn, '')
END
GO


