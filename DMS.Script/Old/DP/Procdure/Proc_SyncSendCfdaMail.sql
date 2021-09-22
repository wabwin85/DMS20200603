DROP PROCEDURE [DP].[Proc_SyncSendCfdaMail]
GO


CREATE PROCEDURE [DP].[Proc_SyncSendCfdaMail]
AS
BEGIN
	DECLARE @error_number INT
	DECLARE @error_serverity INT
	DECLARE @error_state INT
	DECLARE @error_message NVARCHAR(256)
	DECLARE @error_line INT
	DECLARE @error_procedure NVARCHAR(256)
	DECLARE @vError NVARCHAR(1000)
	
	BEGIN TRY
		SET LANGUAGE N'English'
		
		IF DATENAME(WEEKDAY, GETDATE()) <> 'Monday'
		BEGIN
		    RETURN
		END
		
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DPParam
		       WHERE  ParamType = 'CfdaMail'
		              AND ParamKey = 'LastSendDate'
		              AND ParamValue = CONVERT(NVARCHAR(10), GETDATE(), 121)
		   )
		BEGIN
		    RETURN
		END
		
		DECLARE @MailHead NVARCHAR(MAX)
		DECLARE @MailBody NVARCHAR(MAX)
		DECLARE @MailBodyDealer NVARCHAR(MAX)
		DECLARE @DealerId UNIQUEIDENTIFIER
		DECLARE @SapCode NVARCHAR(200);
		DECLARE @DealerName NVARCHAR(200);
		DECLARE @Bu NVARCHAR(200);
		DECLARE @LicenseValidTo DATETIME;
		DECLARE @Status NVARCHAR(200);
		
		DECLARE @MailAddress NVARCHAR(100);
		
		BEGIN TRAN
		
		IF EXISTS (
		       SELECT 1
		       FROM   DealerMasterLicense A,
		              dbo.DealerMaster B
		       WHERE  A.DML_DMA_ID = B.DMA_ID
		              AND B.DMA_DeletedFlag = 0
		              AND B.DMA_ActiveFlag = 1
		              AND (
		                      (
		                          DML_CurLicenseValidTo IS NOT NULL
		                          AND CONVERT(NVARCHAR(10), DATEADD(MONTH, 3, GETDATE()), 121) >= CONVERT(NVARCHAR(10), DML_CurLicenseValidTo, 121)
		                      )
		                      OR (
		                             DML_CurFilingValidTo IS NOT NULL
		                             AND CONVERT(NVARCHAR(10), DATEADD(MONTH, 3, GETDATE()), 121) >= CONVERT(NVARCHAR(10), DML_CurFilingValidTo, 121)
		                         )
		                  )
		              AND EXISTS (
		                       SELECT 1
		                         FROM   V_DealerContractMaster C
		                        WHERE  C.ActiveFlag = 1
		                             AND C.DMA_ID = B.DMA_ID
		                  )
		   )
		BEGIN
		    SET @MailHead = '<font face="΢���ź�"><b style=''font-weight:bold;font-size:14.0pt;''>�𾴵Ĵ����̻��,</b><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��˾�ľ�Ӫ���֤Ч����Ϣ���±�<b style=''font-size:12.0pt;color:red;''>�������������֤�����������֤���ڲ���DMSϵͳ�и���CFDA֤����Ϣ������Ӱ������¶���</b>��лл��</font><br/><br/><br/><table border="1" cellspadding="0" cellspacing="0"><tr><td>SAPID</td><td>������</td><td>����BU</td><td>֤������</td><td>��Ч��</td><td>״̬</td></tr>';
		    SET @MailBody = '';
		    
		    DECLARE CUR_LICENCE CURSOR  
		    FOR
		        SELECT B.DMA_ID,
		               B.DMA_SAP_Code,
		               B.DMA_ChineseName,
		               (
		                   SELECT ISNULL(
		                              STUFF(
		                                  REPLACE(
		                                      REPLACE(
		                                          (
		                                              SELECT DISTINCT T2.DivisionName T
		                                              FROM   V_DealerContractMaster T1,
		                                                     V_DivisionProductLineRelation T2
		                                              WHERE  T1.Division = T2.DivisionCode
		                                                     AND T1.ActiveFlag = 1
		                                                     AND T2.IsEmerging = 0
		                                                     AND T1.DMA_ID = A.DML_DMA_ID
		                                              ORDER BY T2.DivisionName
		                                                    FOR XML AUTO
		                                          ),
		                                          '<T2 T="',
		                                          '/'
		                                      ),
		                                      '"/>',
		                                      ''
		                                  ),
		                                  1,
		                                  1,
		                                  ''
		                              ),
		                              '&nbsp;'
		                          )
		               ) Bu,
		               DML_CurLicenseValidTo DML_CurLicenseValidTo
		        FROM   DealerMasterLicense A,
		               dbo.DealerMaster B
		        WHERE  A.DML_DMA_ID = B.DMA_ID
		               AND B.DMA_DeletedFlag = 0
		               AND B.DMA_ActiveFlag = 1
		               AND (
		                       DML_CurLicenseValidTo IS NOT NULL
		                       AND CONVERT(NVARCHAR(10), DATEADD(MONTH, 3, GETDATE()), 121) >= CONVERT(NVARCHAR(10), DML_CurLicenseValidTo, 121)
		                   )
		              AND EXISTS (
		                       SELECT 1
		                         FROM   V_DealerContractMaster C
		                        WHERE  C.ActiveFlag = 1
		                             AND C.DMA_ID = B.DMA_ID
		                  )
		        ORDER BY DML_CurLicenseValidTo
		    
		    OPEN CUR_LICENCE
		    FETCH NEXT FROM CUR_LICENCE INTO @DealerId,@SapCode,@DealerName,@Bu,@LicenseValidTo
		    WHILE @@FETCH_STATUS = 0
		    BEGIN
		        SET @MailBodyDealer = '';
		        IF (
		               @LicenseValidTo IS NOT NULL
		               AND CONVERT(NVARCHAR(10), DATEADD(MONTH, 3, GETDATE()), 121) >= CONVERT(NVARCHAR(10), @LicenseValidTo, 121)
		           )
		        BEGIN
		            IF @LicenseValidTo < = GETDATE()
		            BEGIN
		                SET @Status = '�ѹ���'
		            END
		            ELSE
		            BEGIN
		                SET @Status = CONVERT(NVARCHAR(10), DATEDIFF(DAY, GETDATE(), @LicenseValidTo)) + '������'
		            END
		            SET @MailBody += '<tr><td>' + @SapCode + '</td><td>' + @DealerName + '</td><td>' + @Bu + '</td><td>ҽ����е��Ӫ���֤��Ϣ</td><td>' + CONVERT(NVARCHAR(10), @LicenseValidTo, 121) + '</td><td>' + @Status + '</td></tr>';
		            SET @MailBodyDealer += '<tr><td>' + @SapCode + '</td><td>' + @DealerName + '</td><td>' + @Bu + '</td><td>ҽ����е��Ӫ���֤��Ϣ</td><td>' + CONVERT(NVARCHAR(10), @LicenseValidTo, 121) + '</td><td>' + @Status + '</td></tr>';
		        END
		        
		        SET @MailBodyDealer = @MailHead + @MailBodyDealer + '</table>';
		        
		        DECLARE CUR_DEALER CURSOR  
		        FOR
		            SELECT DISTINCT Email
		            FROM   (
		                       SELECT ISNULL(EMAIL1, '') Email
		                       FROM   Lafite_IDENTITY
		                       WHERE  Corp_ID = @DealerId
		                              AND ISNULL(EMAIL1, '') <> ''
		                       UNION 
		                       SELECT ISNULL(EMAIL2, '') Email
		                       FROM   Lafite_IDENTITY
		                       WHERE  Corp_ID = @DealerId
		                              AND ISNULL(EMAIL2, '') <> ''
		                   ) T
		        
		        OPEN CUR_DEALER
		        FETCH NEXT FROM CUR_DEALER INTO @MailAddress
		        WHILE @@FETCH_STATUS = 0
		        BEGIN
		            INSERT INTO MailMessageQueue
		              (MMQ_ID, MMQ_QueueNo, MMQ_From, MMQ_To, MMQ_Subject, MMQ_Body, MMQ_Status, MMQ_CreateDate)
		            VALUES
		              (NEWID(), 'email', '', @MailAddress, '������֤�չ�������', @MailBodyDealer, 'Waiting', GETDATE())
		            
		            FETCH NEXT FROM CUR_DEALER INTO @MailAddress
		        END
		        CLOSE CUR_DEALER
		        DEALLOCATE CUR_DEALER
		        
		        FETCH NEXT FROM CUR_LICENCE INTO @DealerId,@SapCode,@DealerName,@Bu,@LicenseValidTo
		    END
		    CLOSE CUR_LICENCE
		    DEALLOCATE CUR_LICENCE
		    
		    SET @MailBody = @MailHead + @MailBody + '</table>';
		    
		    DECLARE CUR_MAIL_LICENCE CURSOR  
		    FOR
		        SELECT DISTINCT Email
		        FROM   (
		                   SELECT ParamValue Email
		                   FROM   DP.DPParam
		                   WHERE  ParamType = 'CFDALicenseAlert'
		                   UNION
		                   SELECT MDA_MailAddress Email
		                   FROM   MailDeliveryAddress
		                   WHERE  MDA_MailType = 'CFDALicenseAlert'
		               ) T
		    
		    OPEN CUR_MAIL_LICENCE
		    FETCH NEXT FROM CUR_MAIL_LICENCE INTO @MailAddress
		    WHILE @@FETCH_STATUS = 0
		    BEGIN
		        INSERT INTO MailMessageQueue
		          (MMQ_ID, MMQ_QueueNo, MMQ_From, MMQ_To, MMQ_Subject, MMQ_Body, MMQ_Status, MMQ_CreateDate)
		        VALUES
		          (NEWID(), 'email', '', @MailAddress, '������֤�չ�������', @MailBody, 'Waiting', GETDATE())
		        
		        FETCH NEXT FROM CUR_MAIL_LICENCE INTO @MailAddress
		    END
		    CLOSE CUR_MAIL_LICENCE
		    DEALLOCATE CUR_MAIL_LICENCE
		END
		
		UPDATE DP.DPParam
		SET    ParamValue = CONVERT(NVARCHAR(10), GETDATE(), 121)
		WHERE  ParamType = 'CfdaMail'
		       AND ParamKey = 'LastSendDate'
		
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncSendCfdaMail' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + '�г���[����ţ�' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']��' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO


