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
	

	
	IF @SampleType = '��ҵ��Ʒ'
	BEGIN
	    SET @Rtn += '<h4>��Ʒ���뵥</h4><table class="gridtable">'
	    SET @Rtn += '<tr><th width="60">��Ʒ����</th><td>' + @SampleType + '</td><th>���뵥���</th><td>' + @ApplyNo + '</td><th>����Ŀ��</th><td>' + @ApplyPurpose + '</td></tr>'
	    --SET @Rtn += '<tr><th>���÷�̯</th><td>' + @ApplyCost + '</td></tr>'
	    SET @Rtn += '<tr><th>ҽԺ����</th><td>' + @HospName + '</td><th>ҽԺ��ַ</th><td>' + @HpspAddress + '</td><th>����ҽ������</th><td>' + @TrialDoctor + '</td></tr>'
	    SET @Rtn += '<tr><th>�ջ���</th><td>' + @ReceiptUser + '</td><th>�ջ�����ϵ��ʽ</th><td>' + @ReceiptPhone + '</td><th>�ջ���ַ</th><td>' + @ReceiptAddress + '</td></tr>'
	    SET @Rtn += '<tr><th>�Ƿ����<6����<br/>Ч�ڵĲ�Ʒ</th><td colspan="5">' + @ConfirmItem3 + '</td></tr>'	
	    if(@ApplyPurpose = '����' or @ApplyPurpose = 'CRM��������')
			begin
				SET @Rtn += '<tr><th>IRF���</th><td colspan="5">' + @IrfNo + '</td></tr>'
			end
	    else
			begin				
				SET @Rtn += '<tr><th>��ע</th><td colspan="5">' + @ApplyMemo + '</td></tr>'	    
			
				SET @Rtn += '<tr><th>ȷ������1</th><td colspan="5"><input type="checkbox" id="check1" disabled="true" '
				if (@ConfirmItem1 = 'true')
					begin
					SET @Rtn += 'checked="' + @ConfirmItem1 
					end 
				SET @Rtn += '"/>��Ʒ�����յ��󾡿����ã���ʮ�����ϴ���Ʒ������</td></tr>'
				SET @Rtn += '<tr><th>ȷ������2</th><td colspan="5"><input type="checkbox" id="check2" disabled="true" ' 
				if (@ConfirmItem2 = 'true')
					begin
					SET @Rtn += 'checked="' + @ConfirmItem2 
					end
				SET @Rtn += '"/>��Ʒ����ת��</td></tr>'
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

	    SET @Rtn += '<h4>��Ʒ���뵥</h4><table class="gridtable">'
	    SET @Rtn += '<tr><th width="60">��Ʒ����</th><td width="160">' + @SampleType + '</td><th width="60">��������</th><td width="160">' + @ApplyQuantity + '</td><th width="60">ʹ����</th><td width="160">' + @ProcessUser + '</td></tr>'
	    SET @Rtn += '<tr><th>��������</th><td>' + @ApplyDate + '</td><th>���뵥���</th><td>' + @ApplyNo + '</td><th>������</th><td>' + @ApplyUser + '</td></tr>'
	    SET @Rtn += '<tr><th>����</th><td>' + @ApplyDept + '</td><th>��ҵ��</th><td>' + @ApplyDivision + '</td><th>���÷�̯</th><td>' + @ApplyCost + '</td></tr>'
	    SET @Rtn += '<tr><th>�ͻ�����</th><td>' + @CustType + '</td><th>�ͻ�����</th><td>' + @CustName + '</td><th>����Ŀ��</th><td>' + @ApplyPurpose + '</td></tr>'
	    SET @Rtn += '<tr><th>ҵ��</th><td>' + ISNULL(@TestingDivision,'') + '</td><th>���ȼ�</th><td>' + ISNULL(@TestingPriority,'') + '</td><th>ע��֤</th><td>' + ISNULL(@TestingCertificate,'') + '</td></tr>'
	    SET @Rtn += '<tr><th>�ɱ�����</th><td>' + ISNULL(@TestingCostCenter,'') + '</td><th>������������</th><td>' + ISNULL(@TestingArrivalDate,'') + '</td><th>IRF#</th><td>' + ISNULL(@TestingIrf,'') + '</td></tr>'
	    SET @Rtn += '<tr><th>RA��Ŀ</th><td>' + ISNULL(@TestingRa,'') + '</td><th>�ջ���</th><td>' + @ReceiptUser + '</td><th>�ջ�����ϵ��ʽ</th><td>' + @ReceiptPhone + '</td></tr>'
	    SET @Rtn += '<tr><th>������</th><td colspan="3">' + @DealerName + '</td><th rowspan="2">�ջ���ַ</th><td rowspan="2">' + @ReceiptAddress + '</td></tr>'
	    SET @Rtn += '<tr><th>��ע</th><td colspan="3">' + @ApplyMemo + '</td></tr>'
	    SET @Rtn += '</table>'
	    
	    
	END
	
	IF EXISTS(
	       SELECT 1
	       FROM   SampleUpn
	       WHERE  SampleHeadId = @SampleApplyHeadId
	   )
	BEGIN
		IF @SampleType = '��ҵ��Ʒ'
			begin
				SET @Rtn += '<h4>UPN�б�</h4><table class="gridtable">'
				SET @Rtn += '<tr><th>UPN���</th><th>��Ʒ����</th><th>����</th><th width="30">��������</th><th>��ע</th></tr>'
			end
	    else 
			begin
				SET @Rtn += '<h4>UPN�б�</h4><table class="gridtable">'
				SET @Rtn += '<tr><th>UPN���</th><th>��Ʒ����</th><th>����</th><th>��������</th><th>����</th><th>����Ҫ��</th><th>��ע</th></tr>'
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
			IF @SampleType = '��ҵ��Ʒ'
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


