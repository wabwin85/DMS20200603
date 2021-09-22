DROP PROCEDURE [interface].[P_I_EW_UpdateDealerSAPCode]
GO

/*
更改经销商SAP正式账号
*/
CREATE PROCEDURE [interface].[P_I_EW_UpdateDealerSAPCode]
@ContractId nvarchar(36), @ContractType nvarchar(50),@DMASapCode nvarchar(50), @RtnVal nvarchar(20) OUTPUT, @RtnMsg nvarchar(4000) OUTPUT
WITH EXEC AS CALLER
AS
	DECLARE @DMA_ID uniqueidentifier
	DECLARE @DMASapCodeOld nvarchar(50)
	
SET NOCOUNT ON


	
	SET @DMA_ID=NULL;
	IF @ContractType='Appointment'
	BEGIN
		SELECT @DMA_ID=CAP_DMA_ID,@DMASapCodeOld=B.DMA_SAP_Code FROM ContractAppointment A INNER JOIN DealerMaster B ON A.CAP_DMA_ID=B.DMA_ID WHERE A.CAP_ID=@ContractId
	END
	IF @ContractType='Amendment'
	BEGIN
		SELECT @DMA_ID=CAM_DMA_ID,@DMASapCodeOld=B.DMA_SAP_Code FROM ContractAmendment A INNER JOIN DealerMaster B ON A.CAM_DMA_ID=B.DMA_ID WHERE A.CAM_ID=@ContractId
	END
	IF @ContractType='Renewal'
	BEGIN
		SELECT @DMA_ID=CRE_DMA_ID,@DMASapCodeOld=B.DMA_SAP_Code FROM ContractRenewal A INNER JOIN DealerMaster B ON A.CRE_DMA_ID=B.DMA_ID WHERE A.CRE_ID=@ContractId
	END
	IF @DMA_ID IS NOT NULL AND @DMA_ID <>'00000000-0000-0000-0000-000000000000' AND ISNULL(@DMASapCode,'')<>''
	BEGIN
		UPDATE [Contract].AppointmentCandidate   SET    SAPCode     = @DMASapCode    WHERE  ContractId  = @ContractId
		UPDATE DealerMaster SET DMA_SAP_Code=@DMASapCode WHERE DMA_ID =@DMA_ID;
		UPDATE Lafite_IDENTITY SET IDENTITY_CODE=(@DMASapCode+'_01'),	LOWERED_IDENTITY_CODE=(@DMASapCode+'_01'),LAST_UPDATE_DATE=GETDATE()  WHERE IDENTITY_CODE=(@DMASapCodeOld+'_01')
		UPDATE Lafite_IDENTITY SET IDENTITY_CODE=(@DMASapCode+'_99'),	LOWERED_IDENTITY_CODE=(@DMASapCode+'_99'),LAST_UPDATE_DATE=GETDATE()   WHERE IDENTITY_CODE=(@DMASapCodeOld+'_99')
		
		--INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
		--		SELECT NEWID(),'email','',A.DMA_Email,'波士顿科学经销商DMS系统账号变更通知','尊敬的经销商合作伙伴，您好！ <br/> 贵司的DMS系统账号已经正式开通，现在一切数据（下订单、上传库存及销量、退货、库存调整等）传输均使用DMS系统，我司不会接受手工订单。<br/>贵司的DMS系统正式账号为'+@DMASapCode+'_01 ，系统网址：http://bscdealer.cn 进入系统后首先请将个人信息维护及密码修改。<br/> 如您在操作过程中有任何疑问，请与DMS系统管理员联系咨询4006309930或发邮件到 2976286693@qq.com<mailto:2976286693@qq.com> 。<br/>另外附上DMS操作视频下载地址如下：<br/>链接: http://pan.baidu.com/s/1c0exa60 <br/>提取密码: dfyb <br/> <br/>请您注意：贵我双方经销商协议签署后，请尽快登陆DMS系统，在“信息维护”模块进行“CFDA证照维护”操作，以免影响贵司下订单。<br/> <br/> 祝合作愉快！','Waiting',GETDATE(),NULL
		--		FROM DealerMaster A WHERE DMA_ID=@DMA_ID
		
		INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
		SELECT NEWID(),'email','','YingSarah.Huang@bsci.com','波士顿科学经销商DMS系统账号变更通知','尊敬的经销商合作伙伴，您好！ <br/> 贵司的DMS系统账号已经正式开通，现在一切数据（下订单、上传库存及销量、退货、库存调整等）传输均使用DMS系统，我司不会接受手工订单。<br/>贵司的DMS系统正式账号为'+@DMASapCode+'_01 ，系统网址：http://bscdealer.cn 进入系统后首先请将个人信息维护及密码修改。<br/> 如您在操作过程中有任何疑问，请与DMS系统管理员联系咨询4006309930或发邮件到 2976286693@qq.com<mailto:2976286693@qq.com> 。<br/>另外附上DMS操作视频下载地址如下：<br/>链接: http://pan.baidu.com/s/1c0exa60 <br/>提取密码: dfyb <br/> <br/>请您注意：贵我双方经销商协议签署后，请尽快登陆DMS系统，在“信息维护”模块进行“CFDA证照维护”操作，以免影响贵司下订单。<br/><br/> 祝合作愉快！','Waiting',GETDATE(),NULL
			
	END
	
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	VALUES(NEWID(),@ContractId,'00000000-0000-0000-0000-000000000000',GETDATE (),'Waiting',@ContractType+' 合同, SAP账号 状态同步成功')
GO


