DROP PROCEDURE [dbo].[Proc_ApplyBusinessSample]
GO

CREATE PROCEDURE [dbo].[Proc_ApplyBusinessSample](
    @UserId          NVARCHAR(500),
    @ApplyDate       NVARCHAR(500),
    @ApplyUser       NVARCHAR(500),
    @ApplyUserId     NVARCHAR(500),
    @CostCenter      NVARCHAR(500),
    @DeptCode        NVARCHAR(500),
    @ApplyPurpose    NVARCHAR(500),
    @HospId          NVARCHAR(500),
    @HospName        NVARCHAR(500),
    @HpspAddress     NVARCHAR(500),
    @HcpId           NVARCHAR(500),
    @TrialDoctor     NVARCHAR(500),
    @ReceiptPhone    NVARCHAR(500),
    @ReceiptAddress  NVARCHAR(500),
    @ApplyMemo       NVARCHAR(500),
    @IrfNo           NVARCHAR(500),
    @ConfirmItem1    NVARCHAR(500),
    @ConfirmItem2    NVARCHAR(500),
    @ConfirmItem3    NVARCHAR(500),
    @UpnList         XML
)
AS
BEGIN
	--TODO CHECK
	SELECT doc.col.value('UpnNo[1]', 'NVARCHAR(500)') UpnNo,
	       doc.col.value('ProductName[1]', 'NVARCHAR(500)') ProductName,
	       doc.col.value('ProductDesc[1]', 'NVARCHAR(500)') ProductDesc,
	       doc.col.value('ApplyQuantity[1]', 'INT') ApplyQuantity,
	       doc.col.value('ProductMemo[1]', 'NVARCHAR(500)') ProductMemo,
	       doc.col.value('Cost[1]', 'NVARCHAR(500)') Cost,
	       doc.col.value('Level4Code[1]', 'NVARCHAR(500)') Level4Code,
	       doc.col.value('Level5Code[1]', 'NVARCHAR(500)') Level5Code,
	       doc.col.value('SortNo[1]', 'INT') SortNo INTO #TmpUpn
	FROM   @UpnList.nodes('/UpnList/Upn') doc(col)
	
	IF @ApplyPurpose = 'CRM手术辅助'
	   AND EXISTS (
	           SELECT 1
	           FROM   #TmpUpn
	           WHERE  UpnNo NOT IN (SELECT DICT_KEY
	                                FROM   Lafite_DICT
	                                WHERE  DICT_TYPE = 'CONST_Sample_CrmUpn')
	       )
	BEGIN
	    RAISERROR ('CRM手术辅助UPN超出选择范围', 16, 1) ;
	    RETURN;
	END
	
	IF EXISTS (
	       SELECT 1
	       FROM   #TmpUpn
	       WHERE  CONVERT(MONEY, Cost) = 0
	   )
	BEGIN
	    RAISERROR ('UPN没有Cost不允许做申请，请联系Finance BP！', 16, 1) ;
	    RETURN;
	END
	
	SELECT HcpId,
	       Level4Code,
	       Level5Code,
	       SUM(ApplyQuantity -ReturnQuantity) CurrentQuantity INTO #TmpQuantity
	FROM   (
	           SELECT A.HcpId,
	                  B.Level4Code,
	                  B.Level5Code,
	                  CONVERT(INT, B.ApplyQuantity) ApplyQuantity,
	                  (
	                      SELECT ISNULL(SUM(TA.ApplyQuantity), 0)
	                      FROM   SampleUpn TA,
	                             SampleReturnHead TB
	                      WHERE  TA.SampleHeadId = TB.SampleReturnHeadId
	                             AND TB.ReturnStatus not in('Deny','Revoked')
	                             AND TB.ApplyNo = A.ApplyNo
	                             AND TA.UpnNo = B.UpnNo
	                  ) ReturnQuantity
	           FROM   SampleApplyHead A,
	                  SampleUpn B
	           WHERE  A.SampleApplyHeadId = b.SampleHeadId
	                  AND A.ApplyStatus not in('Deny','Revoked')
	                  AND A.HcpId = @HcpId
	                  AND EXISTS (
	                          SELECT 1
	                          FROM   #TmpUpn C
	                          WHERE  B.Level4Code = C.Level4Code
	                      )
	           UNION ALL
	           SELECT @HcpId,
	                  Level4Code,
	                  Level5Code,
	                  ApplyQuantity,
	                  0
	           FROM   #TmpUpn
	       ) T
	GROUP BY HcpId, Level4Code, Level5Code
	
	IF @ApplyPurpose NOT IN ('捐赠', 'CRM手术辅助')
	   AND EXISTS (
			   SELECT 1
			   FROM   #TmpQuantity A
					  LEFT JOIN SampleApplyLimit B
						   ON   B.Level4Code = A.Level4Code
               GROUP BY A.Level4Code, B.Limit
			   HAVING  ISNULL(B.Limit, 0) < SUM(A.CurrentQuantity)
	       )
	BEGIN
	    RAISERROR ('该医生的申请数量超过限制，请联系市场部经理。', 16, 1) ;
	    RETURN;
	END
	
	BEGIN TRY
		BEGIN TRAN
		DECLARE @ApplyHeadId UNIQUEIDENTIFIER;
		DECLARE @ApplyNo NVARCHAR(500);
		DECLARE @DealerId UNIQUEIDENTIFIER;
		DECLARE @DealerName NVARCHAR(500);
		DECLARE @ApplyPurposeValue NVARCHAR(20);
		DECLARE @UpnIndex INT;
		
		SELECT @DealerId = DMA_ID,
		       @DealerName = DMA_ChineseName
		FROM   DealerMaster
		WHERE  DMA_SAP_Code = '471287';
		
		SET @ApplyHeadId = NEWID();
		
		SET @ApplyNo = ''
		EXEC dbo.GC_GetNextAutoNumberForSample @DeptCode, 'S', 'Next_BusinessSampleApplyNbr', @ApplyNo OUTPUT
		
		INSERT INTO SampleApplyHead
		  (SampleApplyHeadId, SampleType, ApplyNo, DealerId, ApplyDate, ApplyUserId, ApplyUser, ProcessUserId, ProcessUser, ApplyPurpose, IrfNo, HospName, HpspAddress, HcpId, TrialDoctor, ReceiptUser, ReceiptPhone, ReceiptAddress, DealerName, ApplyMemo, ConfirmItem1, ConfirmItem2, CostCenter, ApplyStatus, CreateUser, CreateDate, ConfirmItem3)
		VALUES
		  (@ApplyHeadId, '商业样品', @ApplyNo, @DealerId, @ApplyDate, @ApplyUserId, @ApplyUser, @ApplyUserId, @ApplyUser, @ApplyPurpose, @IrfNo, @HospName, @HpspAddress, @HcpId, @TrialDoctor, @TrialDoctor, @ReceiptPhone, @ReceiptAddress, @DealerName, @ApplyMemo, @ConfirmItem1, @ConfirmItem2, @CostCenter, 'New', @UserId, GETDATE(), @ConfirmItem3)
		
		DECLARE @UpnNo NVARCHAR(500);
		DECLARE @ProductName NVARCHAR(500);
		DECLARE @ProductDesc NVARCHAR(500);
		DECLARE @ApplyQuantity INT;
		DECLARE @ProductMemo NVARCHAR(500);
		DECLARE @Cost NVARCHAR(500);
		DECLARE @Level4Code NVARCHAR(500);
		DECLARE @Level5Code NVARCHAR(500);
		DECLARE @SortNo INT;
		DECLARE @UpnStr NVARCHAR(2000);
		DECLARE @UpnAmount MONEY;
		SET @UpnStr = '';
		SET @UpnAmount = 0;
		SET @UpnIndex = 1;
		
		DECLARE CUR_UPN CURSOR  
		FOR
		    SELECT doc.col.value('UpnNo[1]', 'NVARCHAR(500)'),
		           doc.col.value('ProductName[1]', 'NVARCHAR(500)'),
		           doc.col.value('ProductDesc[1]', 'NVARCHAR(500)'),
		           doc.col.value('ApplyQuantity[1]', 'INT'),
		           doc.col.value('ProductMemo[1]', 'NVARCHAR(500)'),
		           doc.col.value('Cost[1]', 'NVARCHAR(500)'),
		           doc.col.value('Level4Code[1]', 'NVARCHAR(500)'),
		           doc.col.value('Level5Code[1]', 'NVARCHAR(500)'),
		           doc.col.value('SortNo[1]', 'INT')
		    FROM   @UpnList.nodes('/UpnList/Upn') doc(col)
		
		OPEN CUR_UPN
		FETCH NEXT FROM CUR_UPN INTO @UpnNo,@ProductName,@ProductDesc,@ApplyQuantity,@ProductMemo,@Cost,@Level4Code,@Level5Code,@SortNo
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
		    SET @UpnStr += '<R Index="' + CONVERT(NVARCHAR(10), @UpnIndex) + '"><UPN><![CDATA[' + @UpnNo + ']]></UPN></R>';
		    SET @UpnIndex = @UpnIndex + 1;
		    SET @UpnAmount += @ApplyQuantity * CONVERT(MONEY, @Cost);
		    
		    INSERT INTO SampleUpn
		      (SampleUpnId, SampleHeadId, UpnNo, ProductName, ProductDesc, ApplyQuantity, ProductMemo, Cost, Level4Code, Level5Code, SortNo, CreateUser, CreateDate)
		    VALUES
		      (NEWID(), @ApplyHeadId, @UpnNo, @ProductName, @ProductDesc, @ApplyQuantity, @ProductMemo, @Cost, @Level4Code, @Level5Code, @SortNo, @UserId, GETDATE())
		    
		    FETCH NEXT FROM CUR_UPN INTO @UpnNo,@ProductName,@ProductDesc,@ApplyQuantity,@ProductMemo,@Cost,@Level4Code,@Level5Code,@SortNo
		END
		CLOSE CUR_UPN
		DEALLOCATE CUR_UPN
		
		INSERT INTO ScoreCardLog
		  (SCL_ID, SCL_ESC_ID, SCL_OperUser, SCL_OperDate, SCL_OperType, SCL_OperNote)
		VALUES
		  (NEWID(), @ApplyHeadId, @ApplyUser, GETDATE(), '创建申请单', '')
		
		SET @ApplyPurposeValue = CASE @ApplyPurpose
		                              WHEN '捐赠' THEN '110'
		                              WHEN '新开发医院' THEN '120'
		                              WHEN '已开发医院医生' THEN '130'
		                              WHEN '新上市产品' THEN '140'
		                              WHEN '六个月内未曾使用过产品' THEN '150'
		                              WHEN 'CRM手术辅助' THEN '160'
		                              WHEN '其他' THEN '170'
		                              ELSE ''
		                         END
		
		DECLARE @SyncContent NVARCHAR(MAX)
		
		SET @SyncContent = '<Data>';
		SET @SyncContent += '<FlowId>1834</FlowId>';
		SET @SyncContent += '<IgnoreAlarm>1</IgnoreAlarm>';
		SET @SyncContent += '<Initiator>' + ISNULL(@ApplyUserId, '') + '</Initiator>';
		SET @SyncContent += '<ApproveSelect/>';
		SET @SyncContent += '<Principal/>';
		SET @SyncContent += '<Tables>';
		SET @SyncContent += '<Table Name="BIZ_SAMPLE_NEWMAIN">';
		SET @SyncContent += '<R Index="1">';
		SET @SyncContent += '<EID><![CDATA[' + ISNULL(@ApplyUserId, '') + ']]></EID>';
		SET @SyncContent += '<DEPID><![CDATA[]]></DEPID>';
    SET @SyncContent += '<SAMPLETYPE><![CDATA[1]]></SAMPLETYPE>';
		SET @SyncContent += '<PURPOSETYPE><![CDATA[' + ISNULL(@ApplyPurposeValue, '') + ']]></PURPOSETYPE>';
		SET @SyncContent += '<TOTALAMOUNTUSD><![CDATA[' + CONVERT(NVARCHAR(10), @UpnAmount) + ']]></TOTALAMOUNTUSD>';
		SET @SyncContent += '<XML><![CDATA[' + ISNULL(dbo.Func_GetSampleApplyHtml(@ApplyHeadId), '') + ']]></XML>';
		SET @SyncContent += '<HOSTIPAL><![CDATA[' + ISNULL(@HospId, '') + ']]></HOSTIPAL>';
		SET @SyncContent += '<DMSNO><![CDATA[' + ISNULL(@ApplyNo, '') + ']]></DMSNO>';
		SET @SyncContent += '</R>';
		SET @SyncContent += '</Table>';
		SET @SyncContent += '<Table Name="BIZ_SAMPLE_NEWUPN">';
		SET @SyncContent += @UpnStr;
		SET @SyncContent += '</Table>';
		SET @SyncContent += '</Tables>';
		SET @SyncContent += '</Data>';
		
		INSERT INTO SampleSyncStack
		  (SampleHeadId, ApplyType, SampleType, SyncType, SampleNo, SyncContent, SyncStatus, SyncErrCount, SyncMsg, CreateDate)
		VALUES
		  (@ApplyHeadId, '申请单', '商业样品', '单据创建', @ApplyNo, @SyncContent, 'Wait', 0, '', GETDATE())
		
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


