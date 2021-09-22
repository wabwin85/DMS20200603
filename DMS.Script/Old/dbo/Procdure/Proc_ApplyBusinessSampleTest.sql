DROP PROCEDURE [dbo].[Proc_ApplyBusinessSampleTest]
GO

CREATE PROCEDURE [dbo].[Proc_ApplyBusinessSampleTest](
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
	    RAISERROR (
	        'CRM手术辅助UPN超出选择范围',
	        16,
	        1
	    ) ;
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
	                             AND TB.ReturnStatus <> 'Deny'
	                             AND TB.ApplyNo = A.ApplyNo
	                             AND TA.UpnNo = B.UpnNo
	                  ) ReturnQuantity
	           FROM   SampleApplyHead A,
	                  SampleUpn B
	           WHERE  A.SampleApplyHeadId = b.SampleHeadId
	                  AND A.ApplyStatus <> 'Deny'
	                  AND A.HcpId = @HcpId
	           UNION
	           SELECT @HcpId,
	                  Level4Code,
	                  Level5Code,
	                  ApplyQuantity,
	                  0
	           FROM   #TmpUpn
	       ) T
	GROUP BY HcpId, Level4Code, Level5Code
	
	SELECT A.HcpId,
	                  B.Level4Code,
	                  B.Level5Code,
	                  CONVERT(INT, B.ApplyQuantity) ApplyQuantity,
	                  (
	                      SELECT ISNULL(SUM(TA.ApplyQuantity), 0)
	                      FROM   SampleUpn TA,
	                             SampleReturnHead TB
	                      WHERE  TA.SampleHeadId = TB.SampleReturnHeadId
	                             AND TB.ReturnStatus <> 'Deny'
	                             AND TB.ApplyNo = A.ApplyNo
	                             AND TA.UpnNo = B.UpnNo
	                  ) ReturnQuantity
	           FROM   SampleApplyHead A,
	                  SampleUpn B
	           WHERE  A.SampleApplyHeadId = b.SampleHeadId
	                  AND A.ApplyStatus <> 'Deny'
	                  AND A.HcpId = @HcpId
	                  
	SELECT 'D0001865',
	                  Level4Code,
	                  Level5Code,
	                  ApplyQuantity,
	                  0
	           FROM   #TmpUpn
	select * from #TmpQuantity
	
	SELECT A.HcpId,
	                  B.Level4Code,
	                  B.Level5Code,
	                  CONVERT(INT, B.ApplyQuantity) ApplyQuantity,
	                  (
	                      SELECT ISNULL(SUM(TA.ApplyQuantity), 0)
	                      FROM   SampleUpn TA,
	                             SampleReturnHead TB
	                      WHERE  TA.SampleHeadId = TB.SampleReturnHeadId
	                             AND TB.ReturnStatus <> 'Deny'
	                             AND TB.ApplyNo = A.ApplyNo
	                             AND TA.UpnNo = B.UpnNo
	                  ) ReturnQuantity
	           FROM   SampleApplyHead A,
	                  SampleUpn B
	           WHERE  A.SampleApplyHeadId = b.SampleHeadId
	                  AND A.ApplyStatus <> 'Deny'
	                  AND A.HcpId = @HcpId
	           UNION ALL
	           SELECT @HcpId,
	                  Level4Code,
	                  Level5Code,
	                  ApplyQuantity,
	                  0
	           FROM   #TmpUpn
	
	IF @ApplyPurpose NOT IN ('捐赠', 'CRM手术辅助')
	   AND EXISTS (
	           SELECT 1
	           FROM   #TmpQuantity A
	                  LEFT JOIN SampleApplyLimit B
	                       ON  (
	                               (B.Level4Code IS NOT NULL AND B.Level4Code = A.Level4Code)
	                               OR (B.Level5Code IS NOT NULL AND B.Level5Code = A.Level5Code)
	                           )
	           WHERE  ISNULL(B.Limit, 0) < A.CurrentQuantity
	       )
	BEGIN
	    RAISERROR ('该医生的申请数量超过限制！', 16, 1) ;
	    RETURN;
	END
	
	BEGIN TRY
		BEGIN TRAN
		
		print 'OK'
		
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


