DROP PROCEDURE [interface].[P_I_EW_UpdateDealerSAPCode]
GO

/*
���ľ�����SAP��ʽ�˺�
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
		--		SELECT NEWID(),'email','',A.DMA_Email,'��ʿ�ٿ�ѧ������DMSϵͳ�˺ű��֪ͨ','�𾴵ľ����̺�����飬���ã� <br/> ��˾��DMSϵͳ�˺��Ѿ���ʽ��ͨ������һ�����ݣ��¶������ϴ���漰�������˻����������ȣ������ʹ��DMSϵͳ����˾��������ֹ�������<br/>��˾��DMSϵͳ��ʽ�˺�Ϊ'+@DMASapCode+'_01 ��ϵͳ��ַ��http://bscdealer.cn ����ϵͳ�������뽫������Ϣά���������޸ġ�<br/> �����ڲ������������κ����ʣ�����DMSϵͳ����Ա��ϵ��ѯ4006309930���ʼ��� 2976286693@qq.com<mailto:2976286693@qq.com> ��<br/>���⸽��DMS������Ƶ���ص�ַ���£�<br/>����: http://pan.baidu.com/s/1c0exa60 <br/>��ȡ����: dfyb <br/> <br/>����ע�⣺����˫��������Э��ǩ����뾡���½DMSϵͳ���ڡ���Ϣά����ģ����С�CFDA֤��ά��������������Ӱ���˾�¶�����<br/> <br/> ף������죡','Waiting',GETDATE(),NULL
		--		FROM DealerMaster A WHERE DMA_ID=@DMA_ID
		
		INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
		SELECT NEWID(),'email','','YingSarah.Huang@bsci.com','��ʿ�ٿ�ѧ������DMSϵͳ�˺ű��֪ͨ','�𾴵ľ����̺�����飬���ã� <br/> ��˾��DMSϵͳ�˺��Ѿ���ʽ��ͨ������һ�����ݣ��¶������ϴ���漰�������˻����������ȣ������ʹ��DMSϵͳ����˾��������ֹ�������<br/>��˾��DMSϵͳ��ʽ�˺�Ϊ'+@DMASapCode+'_01 ��ϵͳ��ַ��http://bscdealer.cn ����ϵͳ�������뽫������Ϣά���������޸ġ�<br/> �����ڲ������������κ����ʣ�����DMSϵͳ����Ա��ϵ��ѯ4006309930���ʼ��� 2976286693@qq.com<mailto:2976286693@qq.com> ��<br/>���⸽��DMS������Ƶ���ص�ַ���£�<br/>����: http://pan.baidu.com/s/1c0exa60 <br/>��ȡ����: dfyb <br/> <br/>����ע�⣺����˫��������Э��ǩ����뾡���½DMSϵͳ���ڡ���Ϣά����ģ����С�CFDA֤��ά��������������Ӱ���˾�¶�����<br/><br/> ף������죡','Waiting',GETDATE(),NULL
			
	END
	
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	VALUES(NEWID(),@ContractId,'00000000-0000-0000-0000-000000000000',GETDATE (),'Waiting',@ContractType+' ��ͬ, SAP�˺� ״̬ͬ���ɹ�')
GO


