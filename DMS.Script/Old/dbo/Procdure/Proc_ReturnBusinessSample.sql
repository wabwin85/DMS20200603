DROP PROCEDURE [dbo].[Proc_ReturnBusinessSample]
GO

CREATE PROCEDURE [dbo].[Proc_ReturnBusinessSample](
    @UserId         NVARCHAR(500),
    @DeptCode       NVARCHAR(500),
    @ApplyNo        NVARCHAR(500),
    @ReturnDate     NVARCHAR(500),
    @ReturnUser     NVARCHAR(500),
    @ReturnUserId   NVARCHAR(500),
    @ReturnHosp     NVARCHAR(500),
    @ReturnMemo     NVARCHAR(500),
    @CourierNumber NVARCHAR(500),
    @UpnList        XML
)
AS
BEGIN
	--TODO CHECK
	--是否还可退货
	
	BEGIN TRY
		BEGIN TRAN
		DECLARE @ReturnHeadId UNIQUEIDENTIFIER;
		DECLARE @ReturnNo NVARCHAR(500);
		DECLARE @DealerId UNIQUEIDENTIFIER;
		DECLARE @DealerName NVARCHAR(500);
		
		SELECT @DealerId = DMA_ID,
		       @DealerName = DMA_ChineseName
		FROM   DealerMaster
		WHERE  DMA_SAP_Code = '471287';
		
		SET @ReturnHeadId = NEWID();
		
		SET @ReturnNo = ''
		--获取退货申请单号的逻辑改变
    --EXEC dbo.GC_GetNextAutoNumber @DealerId, 'Next_AdjustNbr', '', @ReturnNo OUTPUT
	  
    --先获取申请单号
    --drop table #RtnSeq
    --declare @ReturnNo nvarchar(50)
    --declare @ApplyNo nvarchar(50)
    --SET @ApplyNo='EN-S-2016-0267'
    select substring(ReturnNo,19,21) AS ReturnSeq into #RtnSeq FROM SampleReturnHead where ReturnNo like '%' + @ApplyNo + '-RTN'+'%'
    
    IF ((select count(*) from #RtnSeq) = 0)
      BEGIN
        SET @ReturnNo = @ApplyNo + '-RTN' + '001'
      END
    ELSE
      BEGIN
        SELECT @ReturnNo = @ApplyNo + '-RTN' +REPLICATE('0',3-len(tab.RtnSeq))+cast(tab.RtnSeq as nvarchar) 
          FROM (SELECT max(Convert(int,ReturnSeq))+1 AS RtnSeq from #RtnSeq) tab
      END
   
    
		--INSERT INTO SampleReturnHead
		--  (SampleReturnHeadId, SampleType, ReturnNo, ApplyNo, DealerId, ReturnDate, ReturnUserId, ReturnUser, ProcessUserId, ProcessUser, ReturnHosp, DealerName, ReturnMemo, ReturnStatus, CreateUser, CreateDate)
		--VALUES
		--  (@ReturnHeadId, '商业样品', @ReturnNo, @ApplyNo, @DealerId, @ReturnDate, @ReturnUserId, @ReturnUser, @ReturnUserId, @ReturnUser, @ReturnHosp, @DealerName, @ReturnMemo, 'New', @UserId, GETDATE())
		
		INSERT INTO SampleReturnHead
		  (SampleReturnHeadId, SampleType, ReturnNo, ApplyNo, DealerId, ReturnDate, ReturnUserId, ReturnUser, ProcessUserId, ProcessUser, ReturnHosp, DealerName, ReturnMemo, ReturnStatus, CreateUser, CreateDate,CourierNumber)
		VALUES
		  (@ReturnHeadId, '商业样品', @ReturnNo, @ApplyNo, @DealerId, @ReturnDate, @ReturnUserId, @ReturnUser, @ReturnUserId, @ReturnUser, @ReturnHosp, @DealerName, @ReturnMemo, 'New', @UserId, GETDATE(),@CourierNumber)
		
		
		DECLARE @UpnNo NVARCHAR(500);
		DECLARE @Lot NVARCHAR(500);
		DECLARE @ProductName NVARCHAR(500);
		DECLARE @ProductDesc NVARCHAR(500);
		DECLARE @ApplyQuantity INT;
		DECLARE @SortNo INT;
		
		DECLARE CUR_UPN CURSOR  
		FOR
		    SELECT doc.col.value('UpnNo[1]', 'NVARCHAR(500)'),
		           doc.col.value('Lot[1]', 'NVARCHAR(500)'),
		           doc.col.value('ProductName[1]', 'NVARCHAR(500)'),
		           doc.col.value('ProductDesc[1]', 'NVARCHAR(500)'),
		           doc.col.value('ApplyQuantity[1]', 'INT'),
		           doc.col.value('SortNo[1]', 'INT')
		    FROM   @UpnList.nodes('/UpnList/Upn') doc(col)
		
		OPEN CUR_UPN
		FETCH NEXT FROM CUR_UPN INTO @UpnNo,@Lot,@ProductName,@ProductDesc,@ApplyQuantity,@SortNo
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
		    INSERT INTO SampleUpn
		      (SampleUpnId, SampleHeadId, UpnNo, Lot, ProductName, ProductDesc, ApplyQuantity, SortNo, CreateUser, CreateDate)
		    VALUES
		      (NEWID(), @ReturnHeadId, @UpnNo, @Lot, @ProductName, @ProductDesc, @ApplyQuantity, @SortNo, @UserId, GETDATE())
		    
		    FETCH NEXT FROM CUR_UPN INTO @UpnNo,@Lot,@ProductName,@ProductDesc,@ApplyQuantity,@SortNo
		END
		CLOSE CUR_UPN
		DEALLOCATE CUR_UPN
		
		INSERT INTO ScoreCardLog
		  (SCL_ID, SCL_ESC_ID, SCL_OperUser, SCL_OperDate, SCL_OperType, SCL_OperNote)
		VALUES
		  (NEWID(), @ReturnHeadId, @ReturnUser, GETDATE(), '创建退货单', '')
		
		DECLARE @SyncContent NVARCHAR(MAX)
		
		SET @SyncContent = '<Data>';
		SET @SyncContent += '<FlowId>1835</FlowId>';
		SET @SyncContent += '<IgnoreAlarm>1</IgnoreAlarm>';
		SET @SyncContent += '<Initiator>' + ISNULL(@ReturnUserId, '') + '</Initiator>';
		SET @SyncContent += '<ApproveSelect/>';
		SET @SyncContent += '<Principal/>';
		SET @SyncContent += '<Tables>';
		SET @SyncContent += '<Table Name="BIZ_RETURNSAMPLE_MAIN">';
		SET @SyncContent += '<R Index="1">';
		SET @SyncContent += '<EID><![CDATA[' + ISNULL(@ReturnUserId, '') + ']]></EID>';
		SET @SyncContent += '<DEPID><![CDATA[]]></DEPID>';
    SET @SyncContent += '<SAMPLETYPE><![CDATA[1]]></SAMPLETYPE>';
		SET @SyncContent += '<DMSNO><![CDATA[' + ISNULL(@ReturnNo, '') + ']]></DMSNO>';
		SET @SyncContent += '<XML><![CDATA[' + ISNULL(dbo.Func_GetSampleReturnHtml(@ReturnHeadId), '') + ']]></XML>';
		SET @SyncContent += '</R>';
		SET @SyncContent += '</Table>';
		SET @SyncContent += '</Tables>';
		SET @SyncContent += '</Data>';
		
		INSERT INTO SampleSyncStack
		  (SampleHeadId, ApplyType, SampleType, SyncType, SampleNo, SyncContent, SyncStatus, SyncErrCount, SyncMsg, CreateDate)
		VALUES
		  (@ReturnHeadId, '退货单', '商业样品', '单据创建', @ReturnNo, @SyncContent, 'Wait', 0, '', GETDATE())
		
		COMMIT TRAN
	END TRY
	
	BEGIN CATCH
		ROLLBACK TRAN
		DECLARE @error_number INT
		DECLARE @error_serverity INT
		DECLARE @error_state INT
		DECLARE @error_message NVARCHAR(256)
		DECLARE @error_line INT
		DECLARE @error_procedure NVARCHAR(256)
		DECLARE @vError NVARCHAR(1000)
		DECLARE @vSyncTime DATETIME	
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = ISNULL(@error_procedure, '') + '第' + CONVERT(NVARCHAR(10), ISNULL(@error_line, ''))
		    + '行出错[错误号：' + CONVERT(NVARCHAR(10), ISNULL(@error_number, ''))
		    + ']，' + ISNULL(@error_message, '')
		
		RAISERROR(@vError, @error_serverity, @error_state)
	END CATCH
END
GO


