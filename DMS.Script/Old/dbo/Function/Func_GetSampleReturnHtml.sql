DROP FUNCTION [dbo].[Func_GetSampleReturnHtml]
GO

CREATE FUNCTION [dbo].[Func_GetSampleReturnHtml]
(
	@SampleReturnHeadId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Rtn NVARCHAR(MAX);
	
	SET @Rtn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
	
	DECLARE @SampleType NVARCHAR(500);
	DECLARE @ReturnNo NVARCHAR(500);
	DECLARE @ApplyNo NVARCHAR(500);
	DECLARE @DealerId UNIQUEIDENTIFIER;
	DECLARE @ReturnRequire NVARCHAR(500);
	DECLARE @ReturnDate NVARCHAR(500);
	DECLARE @ReturnUserId NVARCHAR(500);
	DECLARE @ReturnUser NVARCHAR(500);
	DECLARE @ReturnHosp NVARCHAR(500);
	DECLARE @ReturnDept NVARCHAR(500);
	DECLARE @ReturnDivision NVARCHAR(500);
	DECLARE @DealerName NVARCHAR(500);
	DECLARE @ReturnReason NVARCHAR(500);
	DECLARE @ReturnQuantity NVARCHAR(500);
	DECLARE @ProcessUser NVARCHAR(500);
	DECLARE @ReturnMemo NVARCHAR(500);
	DECLARE @StatusName NVARCHAR(500);
	
	SELECT @SampleType = ISNULL(SampleType, ''),
	       @ReturnNo = ISNULL(ReturnNo, ''),
	       @ApplyNo = ISNULL(ApplyNo, ''),
	       @DealerId = DealerId,
	       @ReturnRequire = ISNULL(ReturnRequire, ''),
	       @ReturnDate = ISNULL(ReturnDate, ''),
	       @ReturnUserId = ISNULL(ReturnUserId, ''),
	       @ReturnUser = ISNULL(ReturnUser, ''),
	       @ReturnHosp = ISNULL(ReturnHosp, ''),
	       @ReturnDept = ISNULL(ReturnDept, ''),
	       @ReturnDivision = ISNULL(ReturnDivision, ''),
	       @DealerName = ISNULL(DealerName, ''),
	       @ReturnReason = ISNULL(ReturnReason, ''),
	       @ReturnQuantity = ISNULL(ReturnQuantity, ''),
	       @ProcessUser = ISNULL(ProcessUser, ''),
	       @ReturnMemo = ISNULL(ReturnMemo, ''),
	       @StatusName = ISNULL(VALUE1, '')
	FROM   SampleReturnHead A,Lafite_DICT B
	WHERE  A.SampleReturnHeadId = @SampleReturnHeadId
	and A.ReturnStatus = B.DICT_KEY
	and B.DICT_TYPE='CONST_Sample_State';
	
	SET @Rtn += '<h4>��Ʒ�˻���</h4><table class="gridtable">'
	SET @Rtn += '<tr><th width="60">��Ʒ����</th><td colspan="5">' + @SampleType + '</td></tr>'
	SET @Rtn += '<tr><th width="60">�˻������</th><td width="160">' + @ReturnNo + '</td><th>��������</th><td>' + @ReturnDate + '</td><th>��������</th><td>' + @ReturnUser + '</td></tr>'
	SET @Rtn += '<tr><th>����״̬</th><td>' + @StatusName + '</td><th>���뵥���</th><td>' + @ApplyNo + '</td><th>ҽԺ</th><td>' + @ReturnHosp + '</td></tr>'
	--SET @Rtn += '<tr><th>�˻�Ҫ��</th><td colspan="5">' + @ReturnRequire + '</td></tr>'
	--SET @Rtn += '<tr><th>�˻�ԭ��</th><td colspan="5">' + @ReturnReason + '</td></tr>'
	SET @Rtn += '<tr><th>��ע</th><td colspan="5">' + @ReturnMemo + '</td></tr>'
	SET @Rtn += '</table>'
	
	IF EXISTS(
	       SELECT 1
	       FROM   SampleUpn
	       WHERE  SampleHeadId = @SampleReturnHeadId
	   )
	BEGIN
	    SET @Rtn += '<h4>UPN�б�</h4><table class="gridtable" width="660">'
	    if (@SampleType = '��ҵ��Ʒ')
	    begin
			SET @Rtn += '<tr><th>UPN���</th><th>����</th><th>��Ʒ����</th><th>����</th><th>�����˻�����</th></tr>'
	    end
	    else
	    begin
			SET @Rtn += '<tr><th>UPN���</th><th>����</th><th>��Ʒ����</th><th>����</th><th>�����˻�����</th><th>��ע</th></tr>'
	    end
	    --DECLARE @ApplyNo NVARCHAR(500);
	    DECLARE @UpnNo NVARCHAR(500);
	    DECLARE @UpnLot NVARCHAR(500);
	    DECLARE @UpnProductName NVARCHAR(500);
	    DECLARE @UpnProductDesc NVARCHAR(500);
	    DECLARE @UpnApplyQuantity NVARCHAR(500);
	    DECLARE @UpnLotReuqest NVARCHAR(500);
	    DECLARE @UpnProductMemo NVARCHAR(500);
	    
	    DECLARE CUR_UPN CURSOR  
	    FOR
	        SELECT ISNULL(UpnNo, ''),
	               ISNULL(Lot, ''),
	               ISNULL(ProductName, ''),
	               ISNULL(ProductDesc, ''),
	               ISNULL(CONVERT(NVARCHAR,CONVERT(FLOAT,ApplyQuantity)), ''),
	               ISNULL(LotReuqest, ''),
	               ISNULL(ProductMemo, '')
	        FROM   SampleUpn
	        WHERE  SampleHeadId = @SampleReturnHeadId
	        ORDER BY SortNo
	    
	    OPEN CUR_UPN
	    FETCH NEXT FROM CUR_UPN INTO @UpnNo, @UpnLot, @UpnProductName, @UpnProductDesc, @UpnApplyQuantity, @UpnLotReuqest, @UpnProductMemo
	    WHILE @@FETCH_STATUS = 0
	    BEGIN
			if (@SampleType = '��ҵ��Ʒ')
				begin
					SET @Rtn += '<tr><td>' + @UpnNo + '</td><td>' + @UpnLot + '</td><td>' + @UpnProductName + '</td><td>' + @UpnProductDesc + '</td><td>' + @UpnApplyQuantity + '</td></tr>'
				end
			else
				begin
					SET @Rtn += '<tr><td>' + @UpnNo + '</td><td>' + @UpnLot + '</td><td>' + @UpnProductName + '</td><td>' + @UpnProductDesc + '</td><td>' + @UpnApplyQuantity + '</td><td>' + @UpnProductMemo + '</td></tr>'
				end
	        FETCH NEXT FROM CUR_UPN INTO @UpnNo, @UpnLot, @UpnProductName, @UpnProductDesc, @UpnApplyQuantity, @UpnLotReuqest, @UpnProductMemo
	    END
	    CLOSE CUR_UPN
	    DEALLOCATE CUR_UPN
	    
	    SET @Rtn += '</table>'
	END
	
	RETURN @Rtn
END
GO


