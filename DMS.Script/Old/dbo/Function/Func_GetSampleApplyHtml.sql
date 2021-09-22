DROP FUNCTION [dbo].[Func_GetSampleApplyHtml]
GO

CREATE FUNCTION [dbo].[Func_GetSampleApplyHtml]
(
	@SampleApplyHeadId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Rtn NVARCHAR(MAX);
	
	SET @Rtn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
	
	DECLARE @SampleType NVARCHAR(500);
	DECLARE @ApplyNo NVARCHAR(500);
	DECLARE @DealerId UNIQUEIDENTIFIER;
	DECLARE @ApplyQuantity NVARCHAR(500);
	DECLARE @RemainQuantity NVARCHAR(500);
	DECLARE @ProcessUser NVARCHAR(500);
	DECLARE @ApplyDate NVARCHAR(500);
	DECLARE @ApplyUserId NVARCHAR(500);
	DECLARE @ApplyUser NVARCHAR(500);
	DECLARE @ApplyDept NVARCHAR(500);
	DECLARE @ApplyDivision NVARCHAR(500);
	DECLARE @CustType NVARCHAR(500);
	DECLARE @CustName NVARCHAR(500);
	DECLARE @ArrivalDate NVARCHAR(500);
	DECLARE @ApplyPurpose NVARCHAR(500);
	DECLARE @ApplyCost NVARCHAR(500);
	DECLARE @IrfNo NVARCHAR(500);
	DECLARE @HospName NVARCHAR(500);
	DECLARE @HpspAddress NVARCHAR(500);
	DECLARE @TrialDoctor NVARCHAR(500);
	DECLARE @ReceiptUser NVARCHAR(500);
	DECLARE @ReceiptPhone NVARCHAR(500);
	DECLARE @ReceiptAddress NVARCHAR(500);
	DECLARE @DealerName NVARCHAR(500);
	DECLARE @ApplyMemo NVARCHAR(500);
	DECLARE @ConfirmItem1 NVARCHAR(500);
	DECLARE @ConfirmItem2 NVARCHAR(500);
	DECLARE @ConfirmItem3 NVARCHAR(500);
	DECLARE @CostCenter NVARCHAR(500);
	DECLARE @ApplyStatus NVARCHAR(500);
	DECLARE @CreateUser NVARCHAR(500);
	DECLARE @CreateDate NVARCHAR(500);
	DECLARE @UpdateUser NVARCHAR(500);
	DECLARE @UpdateDate NVARCHAR(500);
	
	SELECT @SampleType = ISNULL(SampleType, ''),
	       @ApplyNo = ISNULL(ApplyNo, ''),
	       @DealerId = DealerId,
	       @ApplyQuantity = ISNULL(ApplyQuantity, ''),
	       @RemainQuantity = ISNULL(RemainQuantity,''),
	       @ProcessUser = ISNULL(ProcessUser, ''),
	       @ApplyDate = ISNULL(ApplyDate, ''),
	       @ApplyUserId = ISNULL(ApplyUserId, ''),
	       @ApplyUser = ISNULL(ApplyUser, ''),
	       @ApplyDept = ISNULL(ApplyDept, ''),
	       @ApplyDivision = ISNULL(ApplyDivision, ''),
	       @CustType = ISNULL(CustType, ''),
	       @CustName = ISNULL(CustName, ''),
	       @ArrivalDate = ISNULL(ArrivalDate, ''),
	       @ApplyPurpose = ISNULL(ApplyPurpose, ''),
	       @ApplyCost = ISNULL(ApplyCost, ''),
	       @IrfNo = ISNULL(IrfNo, ''),
	       @HospName = ISNULL(HospName, ''),
	       @HpspAddress = ISNULL(HpspAddress, ''),
	       @TrialDoctor = ISNULL(TrialDoctor, ''),
	       @ReceiptUser = ISNULL(ReceiptUser, ''),
	       @ReceiptPhone = ISNULL(ReceiptPhone, ''),
	       @ReceiptAddress = ISNULL(ReceiptAddress, ''),
	       @DealerName = ISNULL(DealerName, ''),
	       @ApplyMemo = ISNULL(ApplyMemo, ''),
	       @ConfirmItem1 = ISNULL(ConfirmItem1, '') ,
	       @ConfirmItem2 = ISNULL(ConfirmItem2, '') ,
		   @ConfirmItem3 = ISNULL(ConfirmItem3, '') ,
	       @CostCenter = ISNULL(CostCenter, ''),
	       @ApplyStatus = ISNULL(VALUE1, ''),
	       @CreateUser = ISNULL(CreateUser, ''),
	       @CreateDate = ISNULL(CreateDate, ''),
	       @UpdateUser = ISNULL(UpdateUser, ''),
	       @UpdateDate = ISNULL(UpdateDate, '')
	FROM   SampleApplyHead A,Lafite_DICT B
	WHERE  A.SampleApplyHeadId = @SampleApplyHeadId
	and A.ApplyStatus = B.DICT_KEY
	and B.DICT_TYPE='CONST_Sample_State';
	

	
	IF @SampleType = '商业样品'
	BEGIN
	    SET @Rtn += '<h4>样品申请单</h4><table class="gridtable">'
	    SET @Rtn += '<tr><th width="60">样品类型</th><td>' + @SampleType + '</td><th>申请单编号</th><td>' + @ApplyNo + '</td><th>申请目的</th><td>' + @ApplyPurpose + '</td></tr>'
	    --SET @Rtn += '<tr><th>费用分摊</th><td>' + @ApplyCost + '</td></tr>'
	    SET @Rtn += '<tr><th>医院名称</th><td>' + @HospName + '</td><th>医院地址</th><td>' + @HpspAddress + '</td><th>试用医生姓名</th><td>' + @TrialDoctor + '</td></tr>'
	    SET @Rtn += '<tr><th>收货人</th><td>' + @ReceiptUser + '</td><th>收货人联系方式</th><td>' + @ReceiptPhone + '</td><th>收货地址</th><td>' + @ReceiptAddress + '</td></tr>'
	    SET @Rtn += '<tr><th>是否接受<6个月<br/>效期的产品</th><td colspan="5">' + @ConfirmItem3 + '</td></tr>'	
	    if(@ApplyPurpose = '捐赠' or @ApplyPurpose = 'CRM手术辅助')
			begin
				SET @Rtn += '<tr><th>IRF编号</th><td colspan="5">' + @IrfNo + '</td></tr>'
			end
	    else
			begin				
				SET @Rtn += '<tr><th>备注</th><td colspan="5">' + @ApplyMemo + '</td></tr>'	    
			
				SET @Rtn += '<tr><th>确认事项1</th><td colspan="5"><input type="checkbox" id="check1" disabled="true" '
				if (@ConfirmItem1 = 'true')
					begin
					SET @Rtn += 'checked="' + @ConfirmItem1 
					end 
				SET @Rtn += '"/>样品需在收到后尽快试用，三十天内上传样品评估表</td></tr>'
				SET @Rtn += '<tr><th>确认事项2</th><td colspan="5"><input type="checkbox" id="check2" disabled="true" ' 
				if (@ConfirmItem2 = 'true')
					begin
					SET @Rtn += 'checked="' + @ConfirmItem2 
					end
				SET @Rtn += '"/>样品不得转售</td></tr>'
			end
	    SET @Rtn += '</table>'
	END
	ELSE
	BEGIN
		IF EXISTS(
	           SELECT 1
	           FROM   SampleTesting
	           WHERE  SampleHeadId = @SampleApplyHeadId
	       )
	    BEGIN        
	        DECLARE @TestingDivision NVARCHAR(500);
	        DECLARE @TestingPriority NVARCHAR(500);
	        DECLARE @TestingCertificate NVARCHAR(500);
	        DECLARE @TestingCostCenter NVARCHAR(500);
	        DECLARE @TestingArrivalDate NVARCHAR(500);
	        DECLARE @TestingIrf NVARCHAR(500);
	        DECLARE @TestingRa NVARCHAR(500);    

	        SELECT TOP 1 @TestingDivision = ISNULL(Division, ''),
	                   @TestingPriority = ISNULL(Priority, ''),
	                   @TestingCertificate = ISNULL([Certificate], ''),
	                   @TestingCostCenter = ISNULL(CostCenter, ''),
	                   @TestingArrivalDate = ISNULL(ArrivalDate, ''),
	                   @TestingIrf = ISNULL(Irf, ''),
	                   @TestingRa = ISNULL(Ra, '')
	            FROM   SampleTesting
	            WHERE  SampleHeadId = @SampleApplyHeadId
	            ORDER BY SortNo    
	    END

	    SET @Rtn += '<h4>样品申请单</h4><table class="gridtable">'
	    SET @Rtn += '<tr><th width="60">样品类型</th><td width="160">' + @SampleType + '</td><th width="60">申请数量</th><td width="160">' + @ApplyQuantity + '</td><th width="60">使用人</th><td width="160">' + @ProcessUser + '</td></tr>'
	    SET @Rtn += '<tr><th>申请日期</th><td>' + @ApplyDate + '</td><th>申请单编号</th><td>' + @ApplyNo + '</td><th>申请者</th><td>' + @ApplyUser + '</td></tr>'
	    SET @Rtn += '<tr><th>部门</th><td>' + @ApplyDept + '</td><th>事业部</th><td>' + @ApplyDivision + '</td><th>费用分摊</th><td>' + @ApplyCost + '</td></tr>'
	    SET @Rtn += '<tr><th>客户类型</th><td>' + @CustType + '</td><th>客户名称</th><td>' + @CustName + '</td><th>申请目的</th><td>' + @ApplyPurpose + '</td></tr>'
	    SET @Rtn += '<tr><th>业务部</th><td>' + ISNULL(@TestingDivision,'') + '</td><th>优先级</th><td>' + ISNULL(@TestingPriority,'') + '</td><th>注册证</th><td>' + ISNULL(@TestingCertificate,'') + '</td></tr>'
	    SET @Rtn += '<tr><th>成本中心</th><td>' + ISNULL(@TestingCostCenter,'') + '</td><th>期望到货日期</th><td>' + ISNULL(@TestingArrivalDate,'') + '</td><th>IRF#</th><td>' + ISNULL(@TestingIrf,'') + '</td></tr>'
	    SET @Rtn += '<tr><th>RA项目</th><td>' + ISNULL(@TestingRa,'') + '</td><th>收货人</th><td>' + @ReceiptUser + '</td><th>收货人联系方式</th><td>' + @ReceiptPhone + '</td></tr>'
	    SET @Rtn += '<tr><th>经销商</th><td colspan="3">' + @DealerName + '</td><th rowspan="2">收货地址</th><td rowspan="2">' + @ReceiptAddress + '</td></tr>'
	    SET @Rtn += '<tr><th>备注</th><td colspan="3">' + @ApplyMemo + '</td></tr>'
	    SET @Rtn += '</table>'
	    
	    
	END
	
	IF EXISTS(
	       SELECT 1
	       FROM   SampleUpn
	       WHERE  SampleHeadId = @SampleApplyHeadId
	   )
	BEGIN
		IF @SampleType = '商业样品'
			begin
				SET @Rtn += '<h4>UPN列表</h4><table class="gridtable">'
				SET @Rtn += '<tr><th>UPN编号</th><th>产品名称</th><th>描述</th><th width="30">申请数量</th><th>备注</th></tr>'
			end
	    else 
			begin
				SET @Rtn += '<h4>UPN列表</h4><table class="gridtable">'
				SET @Rtn += '<tr><th>UPN编号</th><th>产品名称</th><th>描述</th><th>申请数量</th><th>批号</th><th>批次要求</th><th>备注</th></tr>'
			end
	    DECLARE @UpnNo NVARCHAR(500);
	    DECLARE @UpnLot NVARCHAR(500);
	    DECLARE @UpnProductName NVARCHAR(500);
	    DECLARE @UpnProductDesc NVARCHAR(500);
	    DECLARE @UpnApplyQuantity NVARCHAR(500);
	    DECLARE @UpnLotReuqest NVARCHAR(500);
	    DECLARE @UpnProductMemo NVARCHAR(500);
	    --DECLARE @UpnCost NVARCHAR(500);
	    
	    
	    DECLARE CUR_UPN CURSOR  
	    FOR
	        SELECT ISNULL(UpnNo, ''),
	               ISNULL(Lot, ''),
	               ISNULL(ProductName, ''),
	               ISNULL(ProductDesc, ''),
	               ISNULL(CONVERT(NVARCHAR,CONVERT(FLOAT,ApplyQuantity)), ''),
	               ISNULL(LotReuqest, ''),
	               ISNULL(ProductMemo, '')--,
	               --ISNULL(Cost,'')
	        FROM   SampleUpn
	        WHERE  SampleHeadId = @SampleApplyHeadId
	        ORDER BY SortNo
	    
	    OPEN CUR_UPN
	    FETCH NEXT FROM CUR_UPN INTO @UpnNo, @UpnLot, @UpnProductName, @UpnProductDesc, @UpnApplyQuantity, @UpnLotReuqest, @UpnProductMemo--,@UpnCost
	    WHILE @@FETCH_STATUS = 0
	    BEGIN
			IF @SampleType = '商业样品'
			begin
				SET @Rtn += '<tr><td>' + @UpnNo + '</td><td>' + @UpnProductName + '</td><td>' + @UpnProductDesc + '</td><td>' + @UpnApplyQuantity + '</td><td>' + @UpnProductMemo + '</td></tr>'
	        end
	        else
	        begin
				SET @Rtn += '<tr><td>' + @UpnNo + '</td><td>' + @UpnProductName + '</td><td>' + @UpnProductDesc + '</td><td>' + @UpnApplyQuantity + '</td><td>' + @UpnLot + '</td><td>' + @UpnLotReuqest + '</td><td>' + @UpnProductMemo + '</td></tr>'
	        end
	        FETCH NEXT FROM CUR_UPN INTO @UpnNo, @UpnLot, @UpnProductName, @UpnProductDesc, @UpnApplyQuantity, @UpnLotReuqest, @UpnProductMemo--,@UpnCost
	    END
	    CLOSE CUR_UPN
	    DEALLOCATE CUR_UPN
	    
	    SET @Rtn += '</table>'
	END
	
	RETURN @Rtn
END
GO


