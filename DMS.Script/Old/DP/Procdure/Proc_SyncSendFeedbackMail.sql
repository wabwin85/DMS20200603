DROP PROCEDURE [DP].[Proc_SyncSendFeedbackMail]
GO

CREATE PROCEDURE [DP].[Proc_SyncSendFeedbackMail]
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
		RETURN
		
		CREATE TABLE #Tmp
		(
			BuCode            INT,
			SubBuCode         NVARCHAR(20),
			SapCode           NVARCHAR(20),
			WarningLevel      NVARCHAR(10),
			BscFeedStatus     NVARCHAR(10),
			DealerFeedStatus  NVARCHAR(10)
		)
		
		SET LANGUAGE N'English'
		
		IF DATENAME(WEEKDAY, GETDATE()) NOT IN ('Monday', 'Thursday')
		BEGIN
		    RETURN
		END
		
		IF NOT EXISTS (
		       SELECT 1
		       FROM   DP.DPParam
		       WHERE  ParamType = 'FeedbackMail'
		              AND ParamKey = 'LastSendDate'
		   )
		BEGIN
		    INSERT INTO DP.DPParam
		      (ParamType, ParamKey, ParamValue)
		    VALUES
		      ('FeedbackMail', 'LastSendDate', CONVERT(NVARCHAR(10), GETDATE() - 1, 121));
		END
		
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DPParam
		       WHERE  ParamType = 'FeedbackMail'
		              AND ParamKey = 'LastSendDate'
		              AND ParamValue = CONVERT(NVARCHAR(10), GETDATE(), 121)
		   )
		BEGIN
		    RETURN
		END
		
		DECLARE @MailTitle NVARCHAR(200);
		DECLARE @MailBody NVARCHAR(MAX);
		DECLARE @Year NVARCHAR(4);
		DECLARE @Quarter NVARCHAR(1);
		DECLARE @UserAccount NVARCHAR(200);
		DECLARE @UserName NVARCHAR(200);
		DECLARE @BuCode INT;
		DECLARE @BuName NVARCHAR(200);
		DECLARE @SubBuCode NVARCHAR(200);
		DECLARE @SubBuName NVARCHAR(200);
		
		DECLARE @RedBscZsm INT;
		DECLARE @RedBscRsm INT;
		DECLARE @RedBscNcm INT;
		DECLARE @RedBscFinish INT;
		DECLARE @RedDealerUnfinish INT;
		DECLARE @RedDealerFinish INT;
		
		DECLARE @YellowBscZsm INT;
		DECLARE @YellowBscRsm INT;
		DECLARE @YellowBscNcm INT;
		DECLARE @YellowBscFinish INT;
		DECLARE @YellowDealerUnfinish INT;
		DECLARE @YellowDealerFinish INT;
		
		DECLARE @GreenBscZsm INT;
		DECLARE @GreenBscRsm INT;
		DECLARE @GreenBscNcm INT;
		DECLARE @GreenBscFinish INT;
		DECLARE @GreenDealerUnfinish INT;
		DECLARE @GreenDealerFinish INT;
		
		SET @Year = CONVERT(NVARCHAR(4), DATEPART(YEAR, DATEADD(QQ, -1, GETDATE())))
		SET @Quarter = CONVERT(NVARCHAR(1), DATEPART(QQ, DATEADD(QQ, -1, GETDATE())))
		
		SET @MailTitle = '�����̷������Ȼ���';
		
		BEGIN TRAN
		
		DECLARE CUR_USER CURSOR  
		FOR
		    SELECT DISTINCT B.account,
		           B.Name + ' ' + B.eName
		    FROM   Lafite_IDENTITY A
		           INNER JOIN interface.MDM_EmployeeMaster B
		                ON  A.IDENTITY_CODE = B.account
		    WHERE  A.IDENTITY_TYPE = 'User'
		           AND EXISTS (
		                   SELECT 1
		                   FROM   Lafite_IDENTITY_MAP T1,
		                          Lafite_ATTRIBUTE T2
		                   WHERE  T1.MAP_ID = T2.Id
		                          AND T1.MAP_TYPE = 'Role'
		                          AND T2.ATTRIBUTE_TYPE = 'Role'
		                          AND T1.IDENTITY_ID = A.Id
		                          AND T2.ATTRIBUTE_NAME IN ('DP DRM��Ա', 'DP NCM��Ա')
		               )
		
		OPEN CUR_USER
		FETCH NEXT FROM CUR_USER INTO @UserAccount,@UserName
		WHILE @@FETCH_STATUS = 0
		BEGIN
		    IF EXISTS (
		           SELECT 1
		           FROM   DP.BscFeedback A
		           WHERE  A.BscFeedStatus <> '50'
		                  AND A.[Year] = @Year
		                  AND A.[Quarter] = @Quarter
		                  AND EXISTS (
		                          SELECT 1
		                          FROM   DP.UserDealerMapping T
		                          WHERE  A.Bu = T.Division
		                                 AND A.SubBu = T.SubBu
		                                 AND A.SapCode = T.SapCode
		                                 AND T.UserAccount = @UserAccount
		                      )
		       )
		    BEGIN
		        DELETE #Tmp;
		        
		        INSERT INTO #Tmp
		        SELECT DISTINCT A.DivisionID,
		               A.SubBUCode,
		               A.SAPID,
		               A.WarningLevel,
		               B.BscFeedStatus,
		               CASE 
		                    WHEN C.FeedbackId IS NULL THEN '00'
		                    ELSE '10'
		               END
		        FROM   interface.RV_DealerKPI_Score_Summary A
		               INNER JOIN DP.BscFeedback B
		                    ON  A.[Year] = B.[Year]
		                    AND A.[Quarter] = B.[Quarter]
		                    AND A.DivisionID = B.Bu
		                    AND A.SubBUCode = B.SubBu
		                    AND A.SAPID = B.SapCode
		               LEFT JOIN DP.DealerFeedback C
		                    ON  A.[Year] = C.[Year]
		                    AND A.[Quarter] = C.[Quarter]
		                    AND A.DivisionID = C.Bu
		                    AND A.SubBUCode = C.SubBu
		                    AND A.SAPID = C.SapCode
		        WHERE  A.[Year] = @Year
		               AND A.[Quarter] = @Quarter
		               AND EXISTS (
		                       SELECT 1
		                       FROM   DP.UserDealerMapping T
		                       WHERE  B.Bu = T.Division
		                              AND B.SubBu = T.SubBu
		                              AND B.SapCode = T.SapCode
		                              AND T.UserAccount = @UserAccount
		                   )
		        
		        SET @MailBody = '<style>html,body{ font-family: Arial; }</style>&nbsp;&nbsp;&nbsp;&nbsp;��ֹ��ǰ��' + @Year + '-Q' + @Quarter + '���Ⱦ�����Ԥ���ķ������Ȼ������£��뼰ʱ���и��٣�������Ϣ���¼<a href="https://www.bscdealer.cn">DMSϵͳ</a>���в鿴����NCM�����ȫ��Ԥ��������������ʾ��BU�������ȡ�<br /><br />';
		        
		        DECLARE CUR_SUBBU CURSOR  
		        FOR
		            SELECT DISTINCT B.DivisionID,
		                   B.Division,
		                   B.SubBUCode,
		                   B.SubBUName
		            FROM   DP.BscFeedback A
		                   INNER JOIN interface.RV_DealerKPI_Score_Summary B
		                        ON  A.[Year] = B.[Year]
		                        AND A.[Quarter] = B.[Quarter]
		                        AND A.Bu = B.DivisionID
		                        AND A.SubBu = B.SubBUCode
		                        AND A.SapCode = B.SAPID
		            WHERE  A.BscFeedStatus <> '50'
		                   AND A.[Year] = @Year
		                   AND A.[Quarter] = @Quarter
		                   AND EXISTS (
		                           SELECT 1
		                           FROM   DP.UserDealerMapping T
		                           WHERE  A.Bu = T.Division
		                                  AND A.SubBu = T.SubBu
		                                  AND A.SapCode = T.SapCode
		                                  AND T.UserAccount = @UserAccount
		                       )
		        
		        OPEN CUR_SUBBU
		        FETCH NEXT FROM CUR_SUBBU INTO @BuCode,@BuName,@SubBuCode,@SubBuName
		        WHILE @@FETCH_STATUS = 0
		        BEGIN
		            SELECT @RedBscZsm = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '11'
		                   AND BscFeedStatus = '10';
		            SELECT @RedBscRsm = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '11'
		                   AND BscFeedStatus = '20';
		            SELECT @RedBscNcm = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '11'
		                   AND BscFeedStatus = '30';
		            SELECT @RedBscFinish = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '11'
		                   AND BscFeedStatus = '50';		        	
		            SELECT @RedDealerUnfinish = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '11'
		                   AND DealerFeedStatus = '00';
		            SELECT @RedDealerFinish = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '11'
		                   AND DealerFeedStatus = '10';
		            
		            SELECT @YellowBscZsm = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '12'
		                   AND BscFeedStatus = '10';
		            SELECT @YellowBscRsm = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '12'
		                   AND BscFeedStatus = '20';
		            SELECT @YellowBscNcm = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '12'
		                   AND BscFeedStatus = '30';
		            SELECT @YellowBscFinish = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '12'
		                   AND BscFeedStatus = '50';		        	
		            SELECT @YellowDealerUnfinish = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '12'
		                   AND DealerFeedStatus = '00';
		            SELECT @YellowDealerFinish = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '12'
		                   AND DealerFeedStatus = '10';
		            
		            SELECT @GreenBscZsm = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '0'
		                   AND BscFeedStatus = '10';
		            SELECT @GreenBscRsm = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '0'
		                   AND BscFeedStatus = '20';
		            SELECT @GreenBscNcm = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '0'
		                   AND BscFeedStatus = '30';
		            SELECT @GreenBscFinish = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '0'
		                   AND BscFeedStatus = '50';		        	
		            SELECT @GreenDealerUnfinish = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '0'
		                   AND DealerFeedStatus = '00';
		            SELECT @GreenDealerFinish = COUNT(*)
		            FROM   #Tmp
		            WHERE  BuCode = @BuCode
		                   AND SubBuCode = @SubBuCode
		                   AND WarningLevel = '0'
		                   AND DealerFeedStatus = '10';
		            
		            SET @MailBody += '<h2>' + @BuName + ' - ' + @SubBuName + '</h2>';
		            SET @MailBody += '<table border="1" cellspadding="0" cellspacing="0">';
		            SET @MailBody += '<tr><td>&nbsp;</td><td colspan="4">BU��������</td><td colspan="2">�����̷�������</td></tr>';
		            SET @MailBody += '<tr><td>�ۺ�Ԥ���ȼ�</td><td>ZSM������</td><td>RSM������</td><td>NCM������</td><td>BU�������</td><td>�����̷�����</td><td>�����̷������</td></tr>';
		            SET @MailBody += '<tr><td>��</td><td>' + CONVERT(NVARCHAR(10), @RedBscZsm) + '</td><td>' + CONVERT(NVARCHAR(10), @RedBscRsm) + '</td><td>' + CONVERT(NVARCHAR(10), @RedBscNcm) + '</td><td>' + CONVERT(NVARCHAR(10), @RedBscFinish) + '</td><td>' + CONVERT(NVARCHAR(10), @RedDealerUnfinish) + '</td><td>' + CONVERT(NVARCHAR(10), @RedDealerFinish) + '</td></tr>';
		            SET @MailBody += '<tr><td>��</td><td>' + CONVERT(NVARCHAR(10), @YellowBscZsm) + '</td><td>' + CONVERT(NVARCHAR(10), @YellowBscRsm) + '</td><td>' + CONVERT(NVARCHAR(10), @YellowBscNcm) + '</td><td>' + CONVERT(NVARCHAR(10), @YellowBscFinish) + '</td><td>' + CONVERT(NVARCHAR(10), @YellowDealerUnfinish) + '</td><td>' + CONVERT(NVARCHAR(10), @YellowDealerFinish) + '</td></tr>';
		            SET @MailBody += '<tr><td>��</td><td>' + CONVERT(NVARCHAR(10), @GreenBscZsm) + '</td><td>' + CONVERT(NVARCHAR(10), @GreenBscRsm) + '</td><td>' + CONVERT(NVARCHAR(10), @GreenBscNcm) + '</td><td>' + CONVERT(NVARCHAR(10), @GreenBscFinish) + '</td><td>' + CONVERT(NVARCHAR(10), @GreenDealerUnfinish) + '</td><td>' + CONVERT(NVARCHAR(10), @GreenDealerFinish) + '</td></tr>';
		            SET @MailBody += '</table>';
		            SET @MailBody += '<br />';
		            
		            FETCH NEXT FROM CUR_SUBBU INTO @BuCode,@BuName,@SubBuCode,@SubBuName
		        END
		        CLOSE CUR_SUBBU
		        DEALLOCATE CUR_SUBBU
		        
		        SET @MailBody = '<h1 style="color:red;text-align:center;">�������Ȼ���</h1>' + @MailBody;
		        
		        INSERT INTO MailMessageQueue
		          (MMQ_ID, MMQ_QueueNo, MMQ_From, MMQ_To, MMQ_Subject, MMQ_Body, MMQ_Status, MMQ_CreateDate)
		        VALUES
		          (NEWID(), 'email', '', @UserAccount + '@bsci.com', @MailTitle, @MailBody, 'Waiting', GETDATE())
		    END
		    
		    FETCH NEXT FROM CUR_USER INTO @UserAccount,@UserName
		END
		CLOSE CUR_USER
		DEALLOCATE CUR_USER
		
		UPDATE DP.DPParam
		SET    ParamValue = CONVERT(NVARCHAR(10), GETDATE(), 121)
		WHERE  ParamType = 'FeedbackMail'
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
		SET @vError = 'DP.Proc_SyncSendFeedbackMail' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + '�г���[����ţ�' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']��' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO


