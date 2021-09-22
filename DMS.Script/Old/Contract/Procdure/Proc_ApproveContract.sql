DROP PROCEDURE [Contract].[Proc_ApproveContract]
GO


CREATE PROCEDURE [Contract].[Proc_ApproveContract](
    @ContractId      UNIQUEIDENTIFIER,
    @ContractType    NVARCHAR(100),
    @ContractStatus  NVARCHAR(100),
    @ApproveUser     NVARCHAR(100),
    @ApproveUserEN   NVARCHAR(200),
    @ApproveType     NVARCHAR(100),
    @ApproveDate     DATETIME,
    @ApproveNote     NVARCHAR(500),
    @ApproveRole	 NVARCHAR(100),
    @NextApprove     NVARCHAR(100)
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
		DECLARE @DealerType NVARCHAR(10);
		DECLARE @DealerId UNIQUEIDENTIFIER;
		DECLARE @DepId INT;
		
		IF @ContractType = 'Appointment'
		BEGIN
		    UPDATE [Contract].AppointmentMain
		    SET    ContractStatus  = @ContractStatus,
		           CurrentApprove  = CASE WHEN ISNULL(@ApproveUser, '') = '' THEN CurrentApprove ELSE @ApproveUser END,
		           NextApprove     = @NextApprove,
		           UpdateDate      = @ApproveDate
		    WHERE  ContractId      = @ContractId
		    
		    SELECT @DealerType = DealerType,
		           @DealerId = B.CompanyID,
		           @DepId = A.DepId
		    FROM   [Contract].AppointmentMain A,
		           [Contract].AppointmentCandidate B
		    WHERE  A.ContractId = B.ContractId
		           AND A.ContractId = @ContractId
		END
		ELSE IF @ContractType = 'Amendment'
		BEGIN
		    UPDATE [Contract].AmendmentMain
		    SET    ContractStatus  = @ContractStatus,
		           CurrentApprove  = CASE WHEN ISNULL(@ApproveUser, '') = '' THEN CurrentApprove ELSE @ApproveUser END,
		           NextApprove     = @NextApprove,
		           UpdateDate      = @ApproveDate
		    WHERE  ContractId      = @ContractId
		    
		    SELECT @DealerType = DealerType,
		           @DealerId = A.CompanyID,
		           @DepId = A.DepId
		    FROM   [Contract].AmendmentMain A
		    WHERE  ContractId = @ContractId
		END
		ELSE IF @ContractType = 'Renewal'
		BEGIN
		    UPDATE [Contract].RenewalMain
		    SET    ContractStatus  = @ContractStatus,
		           CurrentApprove  = CASE WHEN ISNULL(@ApproveUser, '') = '' THEN CurrentApprove ELSE @ApproveUser END,
		           NextApprove     = @NextApprove,
		           UpdateDate      = @ApproveDate
		    WHERE  ContractId      = @ContractId
		    
		    SELECT @DealerType = DealerType,
		           @DealerId = A.CompanyID,
		           @DepId = A.DepId
		    FROM   [Contract].RenewalMain A
		    WHERE  ContractId = @ContractId
		END
		ELSE IF @ContractType = 'Termination'
		BEGIN
		    UPDATE [Contract].TerminationMain
		    SET    ContractStatus  = @ContractStatus,
		           CurrentApprove  = CASE WHEN ISNULL(@ApproveUser, '') = '' THEN CurrentApprove ELSE @ApproveUser END,
		           NextApprove     = @NextApprove,
		           UpdateDate      = @ApproveDate
		    WHERE  ContractId      = @ContractId
		    
		    SELECT @DealerType=DealerType FROM Contract.TerminationMain WHERE ContractId = @ContractId
		END
		
		INSERT INTO [Contract].ContractOperLog
		  (LogId, ContractId, OperUser, OperDate, OperType, OperNote,OperRole,OperUserEN)
		VALUES
		  (NEWID(), @ContractId, @ApproveUser, @ApproveDate, @ApproveType, @ApproveNote,@ApproveRole,@ApproveUserEN)
		
		/*同步合同主数据到原DCMS表*/
		--1.判断经销商类型
		IF @ApproveRole='CO Confirm' AND @ApproveType='审批通过' 
		BEGIN
			EXEC interface.P_I_EW_MaintContract_New @ContractId,@ContractType,NULL,NULL;
		END
		--ELSE IF @ContractStatus='Approved' --or @ContractStatus='Deny'
		--BEGIN
		--	EXEC interface.P_I_EW_MaintContract_New @ContractId,@ContractType,NULL,NULL;
		--END
		
		--/*调用原同步状态程序 */
		--EXEC [interface].[P_I_EW_Contract_Approval_New] @ContractId,@ContractType,null,null
		
		IF @ApproveRole='CO Confirm' AND @ApproveType='审批通过'
		BEGIN
			EXEC interface.P_I_EW_Contract_Status_New @ContractId,@ContractType,'COApproved'
			EXEC [dbo].[GC_ELearning_SendEmail] @ContractId,@ContractType 
		END
		
		IF @ContractStatus='Approved'
		BEGIN
			DELETE contract.BeginDateLog  WHERE ContractId =@ContractId
			IF @ContractType='Appointment'
			BEGIN
				insert into contract.BeginDateLog (ContractId,ContractType,BeginDateOld,BeginDateNew)
				SELECT  ContractId,'Appointment',AgreementBegin,@ApproveDate FROM contract.AppointmentProposals where ContractId=@ContractId
			
				UPDATE ContractAppointment SET CAP_EffectiveDate=@ApproveDate WHERE CAP_ID=@ContractId AND CONVERT(NVARCHAR(10),CAP_EffectiveDate,120)<CONVERT(NVARCHAR(10),@ApproveDate,120);
				UPDATE contract.AppointmentProposals SET AgreementBegin=@ApproveDate WHERE ContractId=@ContractId AND  CONVERT(NVARCHAR(10),AgreementBegin,120)<CONVERT(NVARCHAR(10),@ApproveDate,120);
			END
			IF @ContractType='Amendment'
			BEGIN
				insert into contract.BeginDateLog (ContractId,ContractType,BeginDateOld,BeginDateNew)
				SELECT  ContractId,'Amendment',AmendEffectiveDate,@ApproveDate FROM contract.AmendmentMain where ContractId=@ContractId
			
				UPDATE ContractAmendment SET CAM_Amendment_EffectiveDate=@ApproveDate WHERE CAM_ID=@ContractId AND CONVERT(NVARCHAR(10),CAM_Amendment_EffectiveDate,120)<CONVERT(NVARCHAR(10),@ApproveDate,120);
				UPDATE contract.AmendmentMain SET AmendEffectiveDate=@ApproveDate WHERE ContractId=@ContractId AND CONVERT(NVARCHAR(10),AmendEffectiveDate,120)<CONVERT(NVARCHAR(10),@ApproveDate,120);
			END
			IF @ContractType='Renewal'
			BEGIN
				insert into contract.BeginDateLog (ContractId,ContractType,BeginDateOld,BeginDateNew)
				SELECT  ContractId,'Renewal',AgreementBegin,@ApproveDate FROM contract.RenewalProposals where ContractId=@ContractId
				
				UPDATE ContractRenewal SET CRE_Agrmt_EffectiveDate_Renewal=@ApproveDate WHERE CRE_ID=@ContractId AND CONVERT(NVARCHAR(10),CRE_Agrmt_EffectiveDate_Renewal,120)<CONVERT(NVARCHAR(10),@ApproveDate,120);
				UPDATE contract.RenewalProposals  SET AgreementBegin=@ApproveDate WHERE ContractId=@ContractId  AND CONVERT(NVARCHAR(10),AgreementBegin,120)<CONVERT(NVARCHAR(10),@ApproveDate,120);
			END
			--IF @ContractType='Termination'
			--BEGIN
			--	UPDATE ContractTermination SET CTE_Termination_EffectiveDate=GETDATE() WHERE CTE_ID=@ContractId AND CONVERT(NVARCHAR(10),CTE_Termination_EffectiveDate,120)<CONVERT(NVARCHAR(10),GETDATE(),120);
			--	UPDATE contract.TerminationMain   SET PlanExpiration=GETDATE() WHERE ContractId=@ContractId  AND CONVERT(NVARCHAR(10),PlanExpiration,120)<CONVERT(NVARCHAR(10),GETDATE(),120);
			--END
		    
		    EXEC [dbo].[GC_ELearning_SendEmail] @ContractId,@ContractType
		    
		    /*Begin 将需要DPS推送给BU Admin 的邮件维护如中间表*/
		    INSERT INTO interface.T_I_DPS_SendMessageQueue (SMQ_ID,SMQ_Type,SMQ_Dept,SMQ_SubDept,SMQ_Subject,SMQ_Body,SMQ_CreateDate,SMQ_SendFlag,SMQ_SendDate,SMQ_Remark1,SMQ_Remark2,SMQ_Remark3)
		    SELECT NEWID(),'CONTRACT_BUAdmin',CONVERT(NVARCHAR(10),ISNULL(TempTB.DepId,0)),TempTB.SUBDEPID,TempTB.ContractSubject,
			'您好，<br/>'+TempTB.EName+' 申请的经销商'+ContractType+'合同审批完成。<br/><br/>&nbsp;&nbsp;&nbsp;经销商名称：'+DealerName+'('+ISNULL(DealerCode,'')+')<br/>&nbsp;&nbsp;&nbsp;合同编号：'+ContractNo+'<br/>&nbsp;&nbsp;&nbsp;产品线：'+D.DivisionName+'<br>&nbsp;&nbsp;&nbsp;合同分类:'+E.CC_NameCN+'<br/><br/>详情请访问<b>“经销商管理系统（DMS）- 合同管理”</b>模块查看。<be/>谢谢！'
			,GETDATE(),0,null,null,null,null
			FROM (
			SELECT  A.EName,C.DMA_SAP_Code AS DealerCode,A.ContractNo,A.DepId,A.SUBDEPID,'Appointment' AS ContractType,'新经销商合同审批完成通知' AS ContractSubject, CompanyName AS DealerName  FROM Contract.AppointmentMain A 
					INNER JOIN Contract.AppointmentCandidate B ON A.ContractId=b.ContractId	
					LEFT JOIN DealerMaster C ON C.DMA_ID=B.CompanyID
				WHERE A.ContractId=@ContractId
			UNION SELECT  A.EName,A.DealerName,A.ContractNo,A.DepId,A.SUBDEPID,'Termination'  AS ContractType,'经销商合同终止审批完成通知',B.DMA_ChineseName AS DealerName  FROM Contract.TerminationMain A INNER JOIN DealerMaster B ON A.DealerName=b.DMA_SAP_Code	WHERE A.ContractId=@ContractId
			) AS TempTB
			INNER JOIN V_DivisionProductLineRelation D ON D.IsEmerging='0' AND D.DivisionCode=CONVERT(NVARCHAR(10),TempTB.DepId)
			INNER JOIN INTERFACE.ClassificationContract E ON E.CC_Code=TempTB.SUBDEPID
		    /*End*/
		    
		    IF @ContractType IN ('Appointment','Amendment','Renewal')
		    BEGIN
		        IF NOT EXISTS (
		               SELECT 1
		               FROM   DealerContractJustification
		               WHERE  DealerId = @DealerId
		                      AND DeptId = @DepId
		           )
		        BEGIN
		            INSERT INTO DealerContractJustification
		              (DealerId, DeptId, Jus1_QDJL, Jus1_BKQY, Jus1_GJ, Jus1_QYF, Jus2_GSDZ, Jus3_JXSLX, Jus3_DZYY, Jus4_FWFW, Jus4_EWFWFW, Jus4_YWFW, Jus4_SQQY, Jus4_SQFW, Jus5_SFCD, Jus5_YYSM, Jus5_JTMS, Jus6_ZMFS, Jus6_TJR, Jus6_QTFS, Jus6_JXSPG, Jus6_YY, Jus6_QTXX, Jus6_XWYQ, Jus7_ZZBJ, Jus7_SX, Jus7_SYLW, Jus7_HDMS, Jus8_YWZB, Jus8_QTQK, Jus8_TSYY, Jus8_SFFGD, Jus8_FGDFS, Jus8_JL, Jus8_JLFS)
		            SELECT @DealerId,
		                   @DepId,
		                   Jus1_QDJL,
		                   Jus1_BKQY,
		                   Jus1_GJ,
		                   Jus1_QYF,
		                   Jus2_GSDZ,
		                   Jus3_JXSLX,
		                   Jus3_DZYY,
		                   Jus4_FWFW,
		                   Jus4_EWFWFW,
		                   Jus4_YWFW,
		                   Jus4_SQQY,
		                   Jus4_SQFW,
		                   Jus5_SFCD,
		                   Jus5_YYSM,
		                   Jus5_JTMS,
		                   Jus6_ZMFS,
		                   Jus6_TJR,
		                   Jus6_QTFS,
		                   Jus6_JXSPG,
		                   Jus6_YY,
		                   Jus6_QTXX,
		                   Jus6_XWYQ,
		                   Jus7_ZZBJ,
		                   Jus7_SX,
		                   Jus7_SYLW,
		                   Jus7_HDMS,
		                   Jus8_YWZB,
		                   Jus8_QTQK,
		                   Jus8_TSYY,
		                   Jus8_SFFGD,
		                   Jus8_FGDFS,
		                   Jus8_JL,
		                   Jus8_JLFS
		            FROM   [Contract].AppointmentJustification
		            WHERE  ContractId = @ContractId;
		        END
		    END
			
			/* update By Hua Kaichun 20180103
			EXEC interface.P_I_EW_Contract_Status_New @ContractId,@ContractType,'Completed'
			*/
			IF  Not EXISTS (SELECT 1 FROM Contract.StatusSynchronization WHERE ContractId=@ContractId)
			BEGIN
				INSERT INTO Contract.StatusSynchronization(ContractId,ContractType,ContractStatus,ApprovalDate,SynStatus)
				SELECT @ContractId,@ContractType,'Completed',GETDATE(),0 ;
			END
			
			/* 邮件提醒销售人员：合同申请的授权变更申请中涉及到使用红会系统的医院，请和经销商确认实际医院供货情况 */
			SELECT CM.Email AS Email,
					 '<tr><td>'
				   + DM.DMA_ChineseName
				   + '</td><td>'
				   + LA.ATTRIBUTE_NAME
				   + '</td><td>'
				   + D.CA_NAMECN
				   + '</td><td>'
				   + c.HOS_HospitalName
				   + '</td><td>'
				   + c.HOS_Key_Account
				   + '</td></tr>'
					  AS MailBody
			  INTO #RedCrsHosMailBody
			  FROM DealerAuthorizationTableTemp a
				   INNER JOIN ContractTerritory b ON a.DAT_ID = b.Contract_ID
				   INNER JOIN Hospital c ON c.HOS_ID = b.HOS_ID
				   INNER JOIN
				   (SELECT DISTINCT CA_ID, CA_NAMECN
					  FROM interface.ClassificationAuthorization) D
					  ON D.CA_ID = a.DAT_PMA_ID
				   INNER JOIN Lafite_ATTRIBUTE LA ON (LA.Id = A.DAT_ProductLine_BUM_ID)
				   INNER JOIN DealerMaster DM ON (a.DAT_DMA_ID = DM.DMA_ID)
				   INNER JOIN
				   (SELECT CM.ContractId, CM.Eid, EM.Email
					  FROM (SELECT ContractId, Eid FROM [Contract].AppointmentMain
							UNION
							SELECT ContractId, Eid FROM [Contract].AmendmentMain
							UNION
							SELECT ContractId, Eid FROM [Contract].RenewalMain) CM
						   INNER JOIN interface.MDM_EmployeeMaster EM
							  ON (CM.Eid = EM.EID) AND EM.Email IS NOT NULL) AS CM
					  ON (CM.ContractId = a.DAT_DCL_ID)
			WHERE     a.DAT_DCL_ID = @ContractId
				   AND NOT EXISTS
						  (SELECT 1
							 FROM DealerAuthorizationTable DT
								  INNER JOIN HospitalList HL ON DT.DAT_ID = HL.HLA_DAT_ID
							WHERE     A.DAT_ProductLine_BUM_ID =
										 DT.DAT_ProductLine_BUM_ID
								  AND DT.DAT_PMA_ID = A.DAT_PMA_ID
								  AND DT.DAT_DMA_ID = A.DAT_DMA_ID
								  AND HL.HLA_HOS_ID = B.HOS_ID)
				   AND EXISTS
						  (SELECT 1
							 FROM interface.MDM_Hospital MH
							WHERE     MH.[IsRedSystem] = 1
								  AND MH.HOS_Key_Account = c.HOS_Key_Account)

			INSERT INTO MailMessageQueue (MMQ_ID,
										  MMQ_QueueNo,
										  MMQ_From,
										  MMQ_To,
										  MMQ_Subject,
										  MMQ_Body,
										  MMQ_Status,
										  MMQ_CreateDate,
										  MMQ_SendDate)
			   SELECT newid (),
					  'email',
					  '',
					  Email,
					  '合同申请的授权变更申请中涉及到使用红会系统的医院，请和经销商确认实际医院供货情况',
						'BSC销售同事,您好!<br/>&nbsp;&nbsp;&nbsp;&nbsp;你所提交的授权变更申请中涉及到使用红会系统的医院，为避免发生不能扫码入院的情况，请和此家经销商确认实际医院供货情况，如有红会系统方面的问题可以联系DRM的同事，蔡晓晨，xiaochen.cai@bsci.com。<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style><table class="gridtable"><tr><th>经销商名称</th><th>产品线</th><th>产品分类</th><th>红会医院名称</th><th>红会医院编号</th></tr>'
					  + +replace (replace (Body, '&lt;', '<'), '&gt;', '>')
					  + +'</table><br/>波士顿科学<br/>――――――――――――――――――――――――<br/>此邮件为系统自动发送，请勿回复！<br/>谢谢！',
					  'Waiting',
					  getdate (),
					  NULL
				 FROM (SELECT email,
							  (SELECT [MailBody] + ' '
								 FROM #RedCrsHosMailBody AS b
								WHERE b.Email = a.Email
							   FOR XML PATH ( '' ))
								 AS Body
						 FROM #RedCrsHosMailBody AS a
					   GROUP BY Email) tab
			/*结束发邮件*/

		END
		
		IF @ContractStatus='Deny'
		BEGIN
			EXEC interface.P_I_EW_Contract_Status_New @ContractId,@ContractType,'Reject'
			
			IF @ContractType='Appointment'
			BEGIN
				EXEC [Contract].[Proc_DeleteTempAccount] @ContractId;
			END
		END
		
		
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
		INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
		VALUES(NEWID(),@ContractId,'00000000-0000-0000-0000-000000000000',GETDATE (),'Failure',@ContractType+' 合同 '+@ContractStatus+' 同步失败:'+@vError)
	
		RAISERROR(@vError, @error_serverity, @error_state)
	END CATCH
END


