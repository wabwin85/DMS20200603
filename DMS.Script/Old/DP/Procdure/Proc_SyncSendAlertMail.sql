
DROP PROCEDURE [DP].[Proc_SyncSendAlertMail]
GO

CREATE PROCEDURE [DP].[Proc_SyncSendAlertMail]
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
		       WHERE  ParamType = 'AlertMail'
		              AND ParamKey = 'Licence'
		              AND ParamValue = CONVERT(NVARCHAR(10), GETDATE(), 121)
		   )
		BEGIN
		    RETURN
		END
		
		DECLARE @MailBody NVARCHAR(MAX)
		DECLARE @SapCode NVARCHAR(200);
		DECLARE @DealerName NVARCHAR(200);
		DECLARE @Bu NVARCHAR(200);
		DECLARE @Licence NVARCHAR(200);
		DECLARE @ExpireDate NVARCHAR(200);
		DECLARE @Status NVARCHAR(200);
		DECLARE @CcName NVARCHAR(200);
		DECLARE @CaCode NVARCHAR(200);
		DECLARE @CaName NVARCHAR(200);
		DECLARE @MailName NVARCHAR(100);
		DECLARE @MailAddress NVARCHAR(100);
		
		BEGIN TRAN
		
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster A,
		              dbo.DealerMaster B
		       WHERE  A.ModleID = '00000001-0002-0007-0000-000000000000'
		              AND A.DealerId = B.DMA_ID
		              AND B.DMA_DealerType IN ('LP', 'T1')
		              AND Column1 IN ('医疗器械经营许可证信息', '医疗器械备案凭证信息')
		              AND Column2 LIKE '%已过期%'
		              AND EXISTS (
		                       SELECT 1
		                         FROM   V_DealerContractMaster C
		                        WHERE  C.ActiveFlag = 1
		                             AND C.DMA_ID = A.DealerId
                          --SELECT 1
		                      --FROM   DealerContractMaster C
		                      --WHERE  CONVERT(NVARCHAR(10), GETDATE(), 121) >= CONVERT(NVARCHAR(10), C.DCM_EffectiveDate, 121)
		                      --       AND CONVERT(NVARCHAR(10), GETDATE(), 121) <= CONVERT(NVARCHAR(10), C.DCM_ExpirationDate, 121)
		                      --       AND C.DCM_DMA_ID = A.DealerId
		                  )
		   )
		BEGIN
		    SET @MailBody = '&nbsp;&nbsp;&nbsp;&nbsp;经销商证照过期提醒:<br/><br/><table border="1" cellspadding="0" cellspacing="0"><tr><td>SAPID</td><td>经销商</td><td>合作BU</td><td>证照名称</td><td>有效期</td><td>状态</td></tr>';
		    
		    DECLARE CUR_LICENCE CURSOR  
		    FOR
		        SELECT B.DMA_SAP_Code,
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
		                                                     AND T1.DMA_ID = A.DealerId
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
		               ),
		               Column1,
		               SUBSTRING(Column2, 1, 10),
		               '已过期'
		        FROM   DP.DealerMaster A,
		               dbo.DealerMaster B
		        WHERE  A.ModleID = '00000001-0002-0007-0000-000000000000'
		               AND A.DealerId = B.DMA_ID
		               AND B.DMA_DealerType IN ('LP', 'T1')
		               AND B.DMA_SAP_Code NOT IN ('D999999') --去除测试经销商
		               AND Column1 IN ('医疗器械经营许可证信息', '医疗器械备案凭证信息')
		               AND Column2 LIKE '%已过期%'
		               AND EXISTS (
		                       SELECT 1
		                         FROM   V_DealerContractMaster C
		                        WHERE  C.ActiveFlag = 1
		                             AND C.DMA_ID = A.DealerId
                           
                           --SELECT 1
		                       --FROM   DealerContractMaster C
		                       --WHERE  CONVERT(NVARCHAR(10), GETDATE(), 121) >= CONVERT(NVARCHAR(10), C.DCM_EffectiveDate, 121)
		                       --       AND CONVERT(NVARCHAR(10), GETDATE(), 121) <= CONVERT(NVARCHAR(10), C.DCM_ExpirationDate, 121)
		                       --       AND C.DCM_DMA_ID = A.DealerId
		                   )
		        ORDER BY B.DMA_ChineseName
		    
		    OPEN CUR_LICENCE
		    FETCH NEXT FROM CUR_LICENCE INTO @SapCode,@DealerName,@Bu,@Licence,@ExpireDate,@Status
		    WHILE @@FETCH_STATUS = 0
		    BEGIN
		        SET @MailBody += '<tr><td>' + @SapCode + '</td><td>' + @DealerName + '</td><td>' + @Bu + '</td><td>' + @Licence + '</td><td>' + @ExpireDate + '</td><td>' + @Status + '</td></tr>';
		        
		        FETCH NEXT FROM CUR_LICENCE INTO @SapCode,@DealerName,@Bu,@Licence,@ExpireDate,@Status
		    END
		    CLOSE CUR_LICENCE
		    DEALLOCATE CUR_LICENCE
		    
		    SET @MailBody += '</table>';
		    
		    DECLARE CUR_MAIL_LICENCE CURSOR  
		    FOR
		        SELECT ParamKey,
		               ParamValue
		        FROM   DP.DPParam
		        WHERE  ParamType = 'AlertMailAddress'
		    
		    OPEN CUR_MAIL_LICENCE
		    FETCH NEXT FROM CUR_MAIL_LICENCE INTO @MailName,@MailAddress
		    WHILE @@FETCH_STATUS = 0
		    BEGIN
		        INSERT INTO MailMessageQueue
		          (MMQ_ID, MMQ_QueueNo, MMQ_From, MMQ_To, MMQ_Subject, MMQ_Body, MMQ_Status, MMQ_CreateDate)
		        VALUES
		          (NEWID(), 'email', '', @MailAddress, '经销商证照过期提醒', @MailBody, 'Waiting', GETDATE())
		        
		        FETCH NEXT FROM CUR_MAIL_LICENCE INTO @MailName,@MailAddress
		    END
		    CLOSE CUR_MAIL_LICENCE
		    DEALLOCATE CUR_MAIL_LICENCE
		END
		
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster A,
		              dbo.DealerMaster B
		       WHERE  A.ModleID = '00000001-0002-0007-0000-000000000000'
		              AND A.DealerId = B.DMA_ID
		              AND B.DMA_DealerType IN ('LP', 'T1')
		              AND Column1 IN ('授权产品经营资质')
		              AND EXISTS (
		                      SELECT 1
		                         FROM   V_DealerContractMaster C
		                        WHERE  C.ActiveFlag = 1
		                             AND C.DMA_ID = A.DealerId
                          
--                          SELECT 1
--		                      FROM   DealerContractMaster C
--		                      WHERE  CONVERT(NVARCHAR(10), GETDATE(), 121) >= CONVERT(NVARCHAR(10), C.DCM_EffectiveDate, 121)
--		                             AND CONVERT(NVARCHAR(10), GETDATE(), 121) <= CONVERT(NVARCHAR(10), C.DCM_ExpirationDate, 121)
--		                             AND C.DCM_DMA_ID = A.DealerId
		                  )
		   )
		BEGIN
		    SET @MailBody = '&nbsp;&nbsp;&nbsp;&nbsp;经销商授权资质提醒:<br/><br/><table border="1" cellspadding="0" cellspacing="0"><tr><td>SAPID</td><td>经销商</td><td>合作BU</td><td>授权产品</td><td>产品分类代码</td><td>产品分类名称</td><td>资质有无</td></tr>';
		    
		    SELECT TT2.DAT_DMA_ID,
		           TT2.CC_NameCN,
		           TT2.CA_Code,
		           TT2.CA_NameCN,
		           TT2.DAT_ProductLine_BUM_ID
		           INTO #TMP
		    FROM   (
		               SELECT b.*,
		                      pc.CA_NameCN,
		                      pc.CC_NameCN,
		                      pc.CA_Code
		               FROM   V_DealerContractMaster a
		                      INNER JOIN (
		                               SELECT DISTINCT CC_Code,
		                                      CC_NameCN,
		                                      CC_ID,
		                                      CA_Code,
		                                      CA_ID,
		                                      CC_ProductLineID,
		                                      CC_Division,
		                                      CA_NameCN
		                               FROM   V_ProductClassificationStructure
		                           ) pc
		                           ON  CONVERT(NVARCHAR(10), a.Division) = pc.CC_Division
		                           AND pc.CC_ID = a.CC_ID
		                      INNER JOIN DealerAuthorizationTable b
		                           ON  b.DAT_DMA_ID = a.DMA_ID
		                           AND pc.CC_ProductLineID = b.DAT_ProductLine_BUM_ID
		                           AND b.DAT_PMA_ID = pc.CA_ID
		               WHERE  a.ActiveFlag = '1'
		                      AND A.DealerType = 'T1'
		                      AND EXISTS (
		                              SELECT 1
		                                FROM V_DealerContractMaster C
		                               WHERE C.ActiveFlag = 1
		                                 AND C.DMA_ID = A.DMA_ID
                                  
--                                  SELECT 1
--		                              FROM   DealerContractMaster x
--		                              WHERE  CONVERT(NVARCHAR(10), GETDATE(), 121) >= CONVERT(NVARCHAR(10), x.DCM_EffectiveDate, 121)
--		                                     AND CONVERT(NVARCHAR(10), GETDATE(), 121) <= CONVERT(NVARCHAR(10), x.DCM_ExpirationDate, 121)
--		                                     AND x.DCM_DMA_ID = A.DMA_ID
		                          )
		           ) TT2
		    WHERE  NOT EXISTS (
		               SELECT 1
		               FROM   (
		                          SELECT DISTINCT t1.GM_CATALOG,
		                                 CCF.ClassificationId AS CFN_ProductCatagory_PCT_ID,--t3.CFN_ProductCatagory_PCT_ID,
		                                 t3.CFN_ProductLine_BUM_ID
		                          FROM   MD.INF_REG t1 inner join
		                                 MD.V_INF_UPN_REG_LIST t2 on (t1.REG_NO = t2.REG_NO)
		                                 inner join dbo.CFN t3 on (t2.SAP_Code = t3.CFN_Property1)
                                     inner join CfnClassification CCF 
                                       on (    ccf.CfnCustomerFaceNbr=t3.CFN_CustomerFaceNbr 
                                           and ccf.ClassificationId in (select ProducPctId from GC_FN_GetDealerAuthProductSub( TT2.DAT_DMA_ID)))
		                          WHERE      t3.CFN_Property4 <> -1
		                                 AND t1.GM_KIND = '2'
		                                 AND t1.GM_CATALOG IN (SELECT VAL
		                                                       FROM   GC_Fn_SplitStringToTable(
		                                                                  (
		                                                                      SELECT TOP 1 DML_CurSecondClassCatagory
		                                                                      FROM   DealerMasterLicense
		                                                                      WHERE  DML_DMA_ID = TT2.DAT_DMA_ID
		                                                                  ),
		                                                                  ','
		                                                              ))
		                          UNION
		                          SELECT DISTINCT t1.GM_CATALOG,
		                                 CCF.ClassificationId AS CFN_ProductCatagory_PCT_ID, --t3.CFN_ProductCatagory_PCT_ID,
		                                 t3.CFN_ProductLine_BUM_ID
		                          FROM   MD.INF_REG t1 inner join
		                                 MD.V_INF_UPN_REG_LIST t2 on ( t1.REG_NO = t2.REG_NO)
		                                 inner join dbo.CFN t3 on (t2.SAP_Code = t3.CFN_Property1)
                                     inner join CfnClassification CCF 
                                       on (    ccf.CfnCustomerFaceNbr=t3.CFN_CustomerFaceNbr 
                                           and ccf.ClassificationId in (select ProducPctId from GC_FN_GetDealerAuthProductSub( TT2.DAT_DMA_ID)))
		                          WHERE      t3.CFN_Property4 <> -1
		                                 AND t1.GM_KIND = '3'
		                                 AND t1.GM_CATALOG IN (SELECT VAL
		                                                       FROM   GC_Fn_SplitStringToTable(
		                                                                  (
		                                                                      SELECT TOP 1 DML_CurThirdClassCatagory
		                                                                      FROM   DealerMasterLicense
		                                                                      WHERE  DML_DMA_ID = TT2.DAT_DMA_ID
		                                                                  ),
		                                                                  ','
		                                                              ))
		                      ) T1
		               WHERE  TT2.DAT_PMA_ID = T1.CFN_ProductCatagory_PCT_ID
		                      OR  TT2.DAT_PMA_ID = T1.CFN_ProductLine_BUM_ID
		           )
		    
		    SELECT * INTO #TMP2
		    FROM   (
		               SELECT DISTINCT t1.GM_CATALOG,
		                      t4.CatagoryName,
		                      CCF.ClassificationId AS CFN_ProductCatagory_PCT_ID,--t3.CFN_ProductCatagory_PCT_ID,
		                      t3.CFN_ProductLine_BUM_ID
		               FROM   MD.INF_REG t1 inner join
		                      MD.V_INF_UPN_REG_LIST t2 on (t1.REG_NO = t2.REG_NO)
		                      inner join dbo.CFN t3 on (t2.SAP_Code = t3.CFN_Property1)
		                      inner join [MD].[MedicalDeviceCatagory] t4 on (t1.GM_CATALOG = t4.CatagoryID)
                          inner join CfnClassification CCF on (ccf.CfnCustomerFaceNbr=t3.CFN_CustomerFaceNbr) 
		               WHERE  t3.CFN_Property4 <> -1
		                      AND t1.GM_KIND = '2'
		                      
		               UNION
		               SELECT DISTINCT t1.GM_CATALOG,
		                      t4.CatagoryName,
		                      CCF.ClassificationId AS CFN_ProductCatagory_PCT_ID, --t3.CFN_ProductCatagory_PCT_ID,
		                      t3.CFN_ProductLine_BUM_ID
		               FROM   MD.INF_REG t1 inner join 
		                      MD.V_INF_UPN_REG_LIST t2 on (t1.REG_NO = t2.REG_NO)
		                      inner join dbo.CFN t3 on (t2.SAP_Code = t3.CFN_Property1)
		                      inner join [MD].[MedicalDeviceCatagory] t4 on (t1.GM_CATALOG = t4.CatagoryID)
                          inner join CfnClassification CCF on (ccf.CfnCustomerFaceNbr=t3.CFN_CustomerFaceNbr) 
		               WHERE      t3.CFN_Property4 <> -1
		                      AND t1.GM_KIND = '3'		                       
		           ) A
		    
		    DECLARE CUR_AUTH CURSOR  
		    FOR
		        SELECT DISTINCT C.DMA_SAP_Code,
		               C.DMA_ChineseName,
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
		                                                     AND T1.DMA_ID = C.DMA_ID
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
		               ),
		               A.CA_NameCN,
		               B.GM_CATALOG,
		               B.CatagoryName
		        FROM   #TMP A,
		               #TMP2 B,
		               dbo.DealerMaster C
		        WHERE  A.DAT_DMA_ID = C.DMA_ID
		               AND (
		                       A.DAT_ProductLine_BUM_ID = B.CFN_ProductCatagory_PCT_ID
		                       OR A.DAT_ProductLine_BUM_ID = B.CFN_ProductLine_BUM_ID
		                   )
		               AND B.GM_CATALOG NOT IN (SELECT VAL
		                                        FROM   GC_Fn_SplitStringToTable(
		                                                   (
		                                                       SELECT TOP 1 DML_CurSecondClassCatagory
		                                                       FROM   DealerMasterLicense
		                                                       WHERE  DML_DMA_ID = A.DAT_DMA_ID
		                                                   ),
		                                                   ','
		                                               ))
		               AND C.DMA_SAP_Code NOT IN ('D999999') --去除测试经销商
		        ORDER BY C.DMA_ChineseName, A.CA_NameCN
		    
		    OPEN CUR_AUTH
		    FETCH NEXT FROM CUR_AUTH INTO @SapCode,@DealerName,@Bu,@CcName,@CaCode,@CaName
		    WHILE @@FETCH_STATUS = 0
		    BEGIN
		        SET @MailBody += '<tr><td>' + @SapCode + '</td><td>' + @DealerName + '</td><td>' + @Bu + '</td><td>' + @CcName + '</td><td>' + @CaCode + '</td><td>' + @CaName + '</td><td>无</td></tr>';
		        
		        FETCH NEXT FROM CUR_AUTH INTO @SapCode,@DealerName,@Bu,@CcName,@CaCode,@CaName
		    END
		    CLOSE CUR_AUTH
		    DEALLOCATE CUR_AUTH
		    
		    SET @MailBody += '</table>';
		    
		    DECLARE CUR_MAIL_AUTH CURSOR  
		    FOR
		        SELECT ParamKey,
		               ParamValue
		        FROM   DP.DPParam
		        WHERE  ParamType = 'AlertMailAddress'
		    
		    OPEN CUR_MAIL_AUTH
		    FETCH NEXT FROM CUR_MAIL_AUTH INTO @MailName,@MailAddress
		    WHILE @@FETCH_STATUS = 0
		    BEGIN
		        INSERT INTO MailMessageQueue
		          (MMQ_ID, MMQ_QueueNo, MMQ_From, MMQ_To, MMQ_Subject, MMQ_Body, MMQ_Status, MMQ_CreateDate)
		        VALUES
		          (NEWID(), 'email', '', @MailAddress, '经销商授权资质提醒', @MailBody, 'Waiting', GETDATE())
		        
		        FETCH NEXT FROM CUR_MAIL_AUTH INTO @MailName,@MailAddress
		    END
		    CLOSE CUR_MAIL_AUTH
		    DEALLOCATE CUR_MAIL_AUTH
		END
		
		
		UPDATE DP.DPParam
		SET    ParamValue = CONVERT(NVARCHAR(10), GETDATE(), 121)
		WHERE  ParamType = 'AlertMail'
		       AND ParamKey = 'Licence'
		
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
		SET @vError = 'DP.Proc_SyncSendAlertMail' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + '行出错[错误号：' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']，' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END