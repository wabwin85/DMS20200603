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
	
	--是否DRM用户，是则隐藏RSM选项 2016-11-09
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
	SET @Rtn += '<h4>申请信息(Application Information)</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td colspan="6" style="color: red;">平台和一级经销商，请用英文输入！Please fill in English.</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td width="13%" class="title">申请单号(Application No.)</td><td colspan="5">' + @ContractNo + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td width="13%" class="title">经销商类型(Dealer Type)</td><td width="20%">' + @DealerTypeShow + '</td><td width="13%" class="title">产品线(Product Line)</td><td width="20%">' + @DepIdShow + '</td><td width="13%" class="title">合同分类(Sub-BU)</td><td width="21%">' + @SUBDEPIDShow + '</td></tr>'
	--Line 4
	SET @Rtn += '<tr><td class="title">申请人(Applicant)</td><td>' + @EName + '</td><td class="title">申请部门(Department)</td><td>' + @ApplicantDepShow + '</td><td class="title">申请日期(Request Date)</td><td>' + @RequestDate + '</td></tr>'
	--Line 4
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title">指定渠道经理 (Channel BP)</td><td>' + @Jus1_QDJLShow + '</td><td colspan="4">&nbsp;</td></tr>'
	END
	--Line 5
	SET @Rtn += '<tr><td class="title">经销商(Dealer Name)</td><td colspan="3">' + @DealerNameShow + '</td><td class="title">市场类型(Marketing Type)</td><td>' + @MarketTypeShow + '</td></tr>'
	--Line 6
	SET @Rtn += '<tr><td class="title">原协议生效日(Agreement Effective Date)</td><td>' + @DealerBeginDate + '</td><td class="title">原协议到期日(Agreement Expiry Date)</td><td>' + @DealerEndDate + '</td><td class="title">修改生效日(Amendment Effective Date)</td><td>' + @AmendEffectiveDate + '</td></tr>'
	--Line 7
	SET @Rtn += '<tr><td class="title">修改原因(Change Reason)</td><td colspan="3">' + @Purpose + '</td><td class="title">是否为设备经销商（Equipment Dealer）</td><td>' + @IsEquipmentShow + '</td></tr>'
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
	    SET @Rtn += '<h4>经销商基本信息 Dealer Basic Information</h4><table class="gridtable">'
	    --Line 1
	    SET @Rtn += '<tr><td class="title">选择渠道合作方将为 Boston Scientific 提供的服务类型和范围(Select the service type and scope that the channel partner will provide to Boston Scientific)</td><td colspan="5">' + @Jus4_FWFWShow + '</td></tr>'
	    --Line 2
	    IF EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Jus4_FWFW, ',') T
	           WHERE  T.VAL = '70'
	       )
	    BEGIN
	        SET @Rtn += '<tr><td class="title">请选择渠道合作方将为 Boston Scientific 提供的其他服务类型(Please select the type(s) of other services the channel partner will provide to Boston Scientific )</td><td colspan="5">' + @Jus4_EWFWFWShow + '</td></tr>'
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
	        SET @Rtn += '<tr><td class="title">如渠道合作方提供的服务未在上述两个问题中列出，则请提供该服务的相关描述。(If the channel partner is providing a service(s) not listed in the previous two questions, please provide a description of the service(s) being provided.)</td><td colspan="5">' + @Jus4_YWFW + '</td></tr>'
	    END
	    
	    SET @Rtn += '</table>'
	    
	    --Head
	    SET @Rtn += '<h4>销售&市场的竞争能力 Sales & Market competitiveness</h4><table class="gridtable">'
	    --Line 1
	    SET @Rtn += '<tr><td colspan="2" class="title">如何知晓此渠道合作方？(How was the channel partner identified?)</td><td colspan="4">' + @Jus6_ZMFSShow + '</td></tr>'
	    --Line 3
	    IF EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_ZMFS, ',') T
	           WHERE  T.VAL = '70'
	       )
	    BEGIN
	        SET @Rtn += '<tr><td colspan="2" class="title">注明推荐方和/或相关实体的名称/姓名。(Identify the name of the referring party and/or related entity.)</td><td colspan="4">' + @Jus6_TJR + '</td></tr>'
	    END
	    --Line 3
	    IF EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_ZMFS, ',') T
	           WHERE  T.VAL = '80'
	       )
	    BEGIN
	        SET @Rtn += '<tr><td colspan="2" class="title">提供关于“其他”的描述。(Provide a description for "Other".)</td><td colspan="4">' + @Jus6_QTFS + '</td></tr>'
	    END
	    --Line 3
	    SET @Rtn += '<tr><td colspan="2" class="title">是否曾对可提供该服务的其他渠道合作方进行评估？(Were other channel partners evaluated for the services to be performed?)</td><td colspan="4">' + @Jus6_JXSPGShow + '</td></tr>'
	    --Line 3
	    SET @Rtn += '<tr><td colspan="2" class="title">为何选择此渠道合作方？(Why was this channel partner chosen?)</td><td colspan="4">' + @Jus6_YYShow + '</td></tr>'
	    --Line 3
	    IF EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_YY, ',') T
	           WHERE  T.VAL = '50'
	       )
	    BEGIN
	        SET @Rtn += '<tr><td colspan="2" class="title">提供关于“其他”的描述。(Provide a description for "Other".)</td><td colspan="4">' + @Jus6_QTXX + '</td></tr>'
	    END
	    --Line 3
	    SET @Rtn += '<tr><td colspan="2" class="title">此渠道合作方与 Boston Scientific 是否存在任何利益冲突（定义见 Boston Scientific Code of Conduct ）？(If there is any conflict between this channel partner and Boston Scientific? (Please ref.  Boston Scientific Code of Conduct))</td><td colspan="4">' + @Jus6_XWYQShow + '</td></tr>'
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
	SET @Rtn += '<h4>当前协议条款（Original Agreement Term ）</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td width="25%" class="title">是否变更(Change)</td><td width="25%">' + @ProductAmendShow + '</td><td width="25%" class="title">产品线(Product Line)</td><td width="25%">' + @CurrentProduct + '</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title">是否变更(Change)</td><td>' + @PriceAmendShow + '</td><td class="title">价格(Price)</td><td>' + @CurrentPrice + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title">是否变更(Change)</td><td>' + @SalesAmendShow + '</td><td class="title">销售返利政策(Sales Rebate)</td><td>' + @CurrentSpecialSales + '</td></tr>'
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
	
	SET @Rtn += '<tr><td class="title">是否变更(Change)</td><td>' + @HospitalAmendShow + '</td><td class="title">区域(医院)/Territory(Hospital)</td><td>' + @CurrentHospital + '&nbsp;<a href="' + @CurrentHospitalUrl + '" target="_blank">查看</a></td></tr>'
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
	
	SET @Rtn += '<tr><td class="title">是否变更(Change)</td><td>' + @QuotaAmendShow + '</td><td class="title">采购指标(CNY)/Purchase Quota(CNY)<br />(BSC SFX Rate:USD 1 = CNY 6.69)</td><td>' + @CurrentQuota + '&nbsp;<a href="' + @CurrentQuotaUrl + '" target="_blank">查看</a></td></td></tr>'
	--Line 6
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<td class="title">是否变更(Change)</td><td>' + @PaymentAmendShow + '</td><td class="title">付款方式(Payment)</td><td>' + @CurrentPayment + '</td></tr>'
	END
	--Line 7
	SET @Rtn += '<tr><td class="title">附件(Attachment)</td><td colspan="3">' + dbo.Func_GetAttachmentHtml(@CurrentAttachment) + '</td></tr>'
	
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
	SET @Rtn += '<h4>修改后协议条款 (Revised Agreement Term )</h4><table class="gridtable">'
	--Line 1
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title">上述服务目前是否直接经由 BSC 销售部或经由另一渠道合作方执行？(Are the above services being excuted internally or another channel partner?)</td><td>' + @Jus5_SFCDShow + '</td>'
	    IF @Jus5_SFCD = '1'
	    BEGIN
	        SET @Rtn += '<td class="title">解释为何需要增加或变更现有安排。(Explain the reason for change)</td><td>' + @Jus5_YYSM + '</td></tr>'
	    END
	    ELSE
	    BEGIN
	        SET @Rtn += '<td>&nbsp;</td><td>&nbsp;</td></tr>'
	    END
	END
	--Line 2
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title">描述通过雇佣此推荐的渠道合作方所能满足的业务需求。(Describe the business requestments that will be fulfilled by this channel partner)</td><td colspan="3">' + @Jus5_JTMS + '</td></tr>'
	END 
	--PreContract
	SET @Rtn += '<tr><td class="title" width="25%">该协议是否包含非标准合同条款（如无因终止、终止通知期限（通常为 60 天）、回购库存）？(Does the agreement contain non-standard contract provisions (end without reason,non-standard termination notification,inventory buyback))</td><td width="25%">' + @Pre4_FBZTKShow + '</td>'
	IF @Pre4_FBZTK = '1'
	BEGIN
	    SET @Rtn += '<td class="title" width="25%">请提供非标准条款的正当理由。(Provide justification for the non-standard terms.）</td><td width="25%">' + @Pre4_ZDLY + '</td></tr>'
	END
	ELSE
	BEGIN
	    SET @Rtn += '<td width="25%">&nbsp;</td><td width="30%">&nbsp;</td></tr>'
	END
	--Line 1
	SET @Rtn += '<tr><td class="title">产品线(Product Line)</td><td>' + @Product + '</td><td class="title">(如果是部分产品线，请列出)(if partial, please list)</td><td>' + @ProductRemark + '</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title">价格<br/>标准价格的_%的折扣(Pricing Discount  _% off standard price list)</td><td>' + @Price + '</td><td class="title">备注（Remark）</td><td>' + @PriceRemark + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title">销售返利政策<br/>季度采购总额的_% (Sales Rebate _% of the quarter purchase AMT)</td><td>' + @SpecialSales + '</td><td class="title">备注（Remark）</td><td>' + @SpecialSalesRemark + '</td></tr>'
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
	    SET @Rtn += '<td class="title">区域(医院) Territory (Hospital)</td><td>' + @Hospital + '&nbsp;<a href="' + @HospitalUrl + '" target="_blank">查看</a>
	    <br/><a href="' + @AuthUrl + '" target="_blank"><h4>授权明细列表</h4></a>
	    </td>'
	END
	ELSE
	BEGIN
	    SET @Rtn += '<td class="title">区域(医院) Territory (Hospital)</td><td>&nbsp;</td>'
	END
	IF @QuotaAmend = '1'
	BEGIN
	    SET @Rtn += '<td class="title">采购指标(CNY)/Purchase Quota(CNY)<br/>(BSC SFX Rate:USD 1 = CNY 6.69)</td><td>' + @Quota + '&nbsp;<a href="' + @QuotaUrl + '" target="_blank">查看</a></td>'
	END
	ELSE
	BEGIN
	    SET @Rtn += '<td class="title">采购指标(CNY)/Purchase Quota(CNY)<br/>(BSC SFX Rate:USD 1 = CNY 6.69)</td><td>&nbsp;</td>'
	END
	SET @Rtn += '</tr>'
	--Line 2
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title">上述服务将在哪些区域/地区执行？(list the territory (hospital) which will be excuted.)</td><td colspan="3">' + @Jus4_SQFW + '</td></tr>'
	END
	--Line 5
	SET @Rtn += '<tr><td class="title">指标总额(CNY)不含税 Quota Total (CNY Without VAT)</td><td>' + @QuotaTotal + '</td><td class="title">指标总额(USD)不含税  Quota Total(USD Without VAT)</td><td>' + @QUOTAUSD + '</td></tr>'
	--Line 6
	SET @Rtn += '<tr><td class="title">付款方式(Payment)</td><td>' + @PaymentShow + '</td><td colspan="3"></td></tr>'
	--PreContract
	IF @Payment = 'LC'
	BEGIN
	    SET @Rtn += '<tr><td class="title">应在多少天内完成付款？(Payable within how many days?)</td><td colspan="3">' + @PayTerm + '</td></tr>'
	END
	--Line 7
	IF @Payment = 'Credit'
	BEGIN
	    SET @Rtn += '<tr><td class="title">信用期限(天数)(credit terms（Day)</td><td>' + @CreditTermShow + '</td><td class="title">信用额度(CNY, 含增值税)(Credit Limit)</td><td>' + @CreditLimit + '</td></tr>'
	END
	--PreContract
	SET @Rtn += '<tr><td class="title" width="25%" >是否有担保？ (Is there a security amount?)</td><td colspan="3">' + @IsDepositShow + '</td></tr>'
	
	--Line 8
	IF @IsDeposit = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title">保证金(CNY) Deposit</td><td>' + @Deposit + '</td><td class="title">保证金形式 Deposit Type</td><td>' + @InformShow + '</td></tr>'
	END
	--Line 9
	IF @IsDeposit = '1'
	   AND EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Inform, ',')
	           WHERE  VAL = 'Others'
	       )
	BEGIN
	    SET @Rtn += '<tr><td class="title">保证金形式备注 Deposit Type Remark</td><td colspan="3">' + @InformOther + '</td></tr></tr>'
	END
	--Line 10
	SET @Rtn += '<tr><td class="title">付款备注 Payment Remark</td><td colspan="3">' + @Comment + '</td></tr>'
	--Line 13
	SET @Rtn += '<tr><td class="title">经销商总计采购指标小于总计医院指标的原因 Reason for total dealer commercial purchase target less than total hospital target</td><td >' + @DealerLessHosReason 
	
	if @DealerLessHosQ = '0'
	begin
	SET @Rtn += +@DealerLessHosQRemark+'</td>'
	end
	else 
	begin
		SET @Rtn +='</td>'
	end
	
	
	
	SET @Rtn+='<td class="title">经销商季度指标小于医院季度指标的原因 (Reason for Dealer quarterly commercial purchase target less than hospital quarterly target)</td><td>' + @DealerLessHosReasonQ + '</td></tr>'
	--Line 14
	
	
	SET @Rtn += '<tr><td class="title">总计医院实际指标小于总计医院标准指标的原因 (Reason for total actual hospital target less than total standard hospital target)</td><td >' + @HosLessStandardReason 
	IF @HosLessStandardQ = '0'
	BEGIN
	    SET @Rtn += + @HosLessStandardQRemark +'</td>'
	END
	else 
	begin
	   SET @Rtn +='</td>'
	   end
	
	SET @Rtn +='<td class="title" >医院实际季度指标小于医院标准季度指标的原因 （Reason for quarterly actual hospital target less than quarterly standard hospital target）</td><td>' + @HosLessStandardReasonQ 
	--Line 17
	
	
	IF @ProductGroupCheck = '0'
	BEGIN
	   SET @Rtn += + @ProductGroupRemark +'</td></tr>'
	END
	else 
	begin
	   SET @Rtn +='</td></tr>'
	   end
	   
	   SET @Rtn += '<tr><td class="title">当季指标更改原因 quarter target change reason</td><td>' + @ChangeQuarterShow + '</td><td class="title">当季指标更改的详细原因 quarter target change detail reason</td><td>' + @ChangeReason + '</td></tr>'

	SET @Rtn += '<tr><td class="title">产品组最小指标备注 Product group minimal target remark</td><td colspan="3" >' + @ProductGroupMemo + '</td></tr>'
	--Line 2
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title" width="25%">在渠道合作方服务的国家，其能为 Boston Scientific 的缔约方带来多大的市场？(What portion of the Boston Scientific Contracting Party''' + 's business will be driven by the channel partner in the country where the channel partner is performing services?)</td><td colspan="3">' + @Jus8_YWZBShow + '</td></tr>'
	END
	--Line 1
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title" width="25%">渠道合作方是否有要求非常规的付款条件（如预付款、付款至多个账户、付款至不同实体、付款至非渠道合作方所在国家）？(Is the channel partner requesting non-routine payment terms (e.g.,advance payments, payments to multiple accounts, payments to a different entity, payments to a country other than where the channel partner is located)?)</td><td>' + @Jus8_SFFGDShow + '</td>'
	    IF @Jus8_SFFGD = '1'
	    BEGIN
	        SET @Rtn += '<td class="title" width="25%">列出非常规的付款条件(List the non-routine payment terms.)</td><td>' + @Jus8_FGDFS + '</td></tr>'
	    END
	    ELSE
	    BEGIN
	        SET @Rtn += '<td>&nbsp;</td><td>&nbsp;</td></tr>'
	    END
	END
	--Line 18
	
	SET @Rtn += '<tr><td colspan="4" style="margin: 10px !important; padding: 10px !important;"><table class="gridtable">';
	SET @Rtn += '<tr><td class="title" width="12%">年份 (Year)</td><td class="title" width="12%">第一季度(Q1)</td><td class="title" width="12%">第二季度(Q2)</td><td class="title" width="12%">第三季度(Q3)</td><td class="title" width="12%">第四季度(Q4)</td><td class="title" width="12%">合计(Total)</td><td class="title" width="16%">% 对上一年度销售额 (% vs Actual purchase of LY )</td></tr>';
	
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
	--SET @Rtn += '<tr><td>所拟定的年度合同价值是多少？</td><td colspan="3">' + @Pre6_HTJZShow + '</td></tr>'
	--PreContract
	SET @Rtn += '<tr><td class="title">如渠道合作方为 Boston Scientific 提供不只一项服务，获利是否会根据服务类型予以调整？(If the channel partner''' + 's reward will be changed with service type changing?)</td><td colspan="3">' + @Pre7_SFTZShow + '</td></tr>'
	
	--PreContract
	SET @Rtn += '<tr><td colspan="4" style="margin: 10px !important; padding: 10px !important;"><table class="gridtable">';
	SET @Rtn += '<tr><td class="title" width="33%">服务类型(Service Type)</td><td class="title" width="33%">利润（是/否）(Profit(Yes/no))</td><td class="title" width="34%">所提供的利润范围(<10%, 10-20%, >20%)(Range (<10%,10-20%, >20%))</td></tr>';
	
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
	SET @Rtn += '<tr><td class="title">附件(Attachment)</td><td colspan="3">' + dbo.Func_GetAttachmentHtml(@Attachment) + '</td></tr>'
	
	SET @Rtn += '</table>'
	
	--·其他
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
	SET @Rtn += '<h4>其他(Other)</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">1.) 如果以上业务计划书增加当前经销商协议的产品线或区域，那么会与任何其他现有经销商的独家协议条款冲突吗？还是会与任何新任命经销商潜在冲突？
	' + '（1.) If the business proposals above increase the current product line or territory of a dealer agreement, will it have conflicts with any other current dealers''' + ' (exclusive) contract terms, or will it have potential conflicts with any newly appointed dealers?）</td><td>' + @ConflictShow 

	IF @Conflict = '1'
	BEGIN
	    SET @Rtn += '</br>如果是，请说明 If yes, please explain</br>' + @ConflictRemark + '</td>'
	    
	    END	 
	    else 
	  begin
	   SET @Rtn +='</td>'
	   end   
	    --Line 3
	SET @Rtn += '<td class="title">2.) 如果以上业务计划书削减当前经销商协议的产品线或区域，谁将接管这个经销商削减的业务？(
	' + '2.) If the business proposals above cut down the current product line or territory of a dealer agreement, who will take over the abandoned business from this dealer?)</td><td >' + @HandoverShow 
	--Line 4

	if @Handover = '1'
	BEGIN
	   set  @Rtn += '</br>如果是，请说明 If yes, please explain </br>'+ @HandoverRemark + '</td>'	    
	END
    else 
	  begin
	   SET @Rtn +='</td></tr>'
	   end   
	--Line 1
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title" width="25%">渠道合作方在正常情况下是否会与外国官员交往？(Dose the channel partner contact with foreign officials?)</td><td>' + @Jus7_ZZBJShow 
	    --Line 2
	    IF @Jus7_ZZBJ = '1'
	    BEGIN
	        SET @Rtn += '</br>描述此等交往性质。(Describe the nature of these interactions.)</br>' + @Jus7_SX + '</td>'
	    END
	    else 
	   begin
	   SET @Rtn +='</td>'
	   end   
	    
    --Line 3
	    SET @Rtn += '<td class="title">渠道合作方是否会代表 Boston Scientific 与其他第三方（如物流供应商、活动赞助商、旅行社）交往？(Dose the channel partner behalf BSC to contact with other 3rd. Part? (e.g.logistics supplier, events service provider, travel agency.))</td><td>' + @Jus7_SYLWShow 
	    --Line 4
	    IF @Jus7_SYLW = '1'
	    BEGIN
	        SET @Rtn += '</br>描述此等交往性质。(Describe the nature of these interactions.)</br>' + @Jus7_HDMS + '</td></tr>'
	    END
	      else 
	   begin
	   SET @Rtn +='</td></tr>'
	   end  
	END
	--PreContract
	SET @Rtn += '<tr><td class="title" width="25%">与此渠道合作方签订的协议是否需要经过审核和批准（如经国家机关公证）？(Whether the agreement need to be approved by related organization? (such as government offices))</td><td>' + @Pre9_SHPZShow + '</td><td class="title" width="25%">与此渠道合作方签订的协议是否需要经过签约授权？ (Does an agreement with this channel partner require certification of appointment?)</td><td>' + @Pre9_QYSQShow + '</td></tr>'
	
	SET @Rtn += '<tr><td class="title">与此渠道合作方签订的协议是否需要进口证书？ (Whether the agreement needs import license?)</td><td colspan="3">' + @Pre9_JKZSShow + '</td></tr>'
	
	
	
	
	
	
	--PreContract
	--SET @Rtn += '<tr><td class="title" >与此渠道合作方签订的协议是否需要经过审核和批准（如经国家机关公证）？(Whether the agreement need to be approved by related organization? (such as government offices))</td><td colspan="3">' + @Pre9_SHPZShow + '</td></tr>'
	--PreContract
	--SET @Rtn += '<tr><td class="title"width="25%">与此渠道合作方签订的协议是否需要经过签约授权？ (Whether the agreement need to authorized in written.)</td><td>' + @Pre9_QYSQShow + '</td>
	--<td class="title"width="25%">与此渠道合作方签订的协议是否需要进口证书？ (Whether the agreement needs import license?)</td><td>' + @Pre9_JKZSShow + '</td></tr>'
	
	SET @Rtn += '</table>' 
	
	--历史KPI
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
	SET @Rtn += '<h4>历史KPI History KPI</h4><table class="gridtable">'
	SET @Rtn += '<tr><td class="title" width="19%">年份 Year</td><td class="title" width="19%">季度 Quarter</td><td class="title" width="20%">Division</td><td class="title" width="21%">Sub BU</td><td class="title" width="21%">总分 Score</td></tr>'
	
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
	
	--CFDA产品分类
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
	SET @Rtn += '<h4>CFDA产品分类 CFDA Product Category</h4><table class="gridtable">'
	SET @Rtn += '<tr><td class="title" width="33%">类别(level 1)</td><td class="title" width="33%">分类代码(level 2)</td><td class="title" width="34%">分类名称(Product Name)</td></tr>'
	
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
	
	--资质文件
	SET @Rtn += [Contract].Func_GetQualificationFileHtml(@CompanyID);
	/*
	DECLARE @AuthUrl NVARCHAR(1000);
	SET @AuthUrl = '';
	SET @AuthUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'Contract/PagesEwf/Contract/AuthList.aspx?ContractId=' + CONVERT(NVARCHAR(100), @ContractId);
	SET @AuthUrl += '&SUBDEPID=' + @SUBDEPID;
	SET @AuthUrl += '&IsLP=' + @IsLP;
	SET @AuthUrl += '&AgreementBegin=' + @AmendEffectiveDate;
	
	SET @Rtn += '<a href="' + @AuthUrl + '" target="_blank"><h4>授权明细列表</h4></a>'
	*/
	RETURN ISNULL(@Rtn, '')
END
GO


