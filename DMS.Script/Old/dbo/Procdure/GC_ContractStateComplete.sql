DROP Procedure [dbo].[GC_ContractStateComplete]
GO



/*
ά����ͬ������
*/
CREATE Procedure [dbo].[GC_ContractStateComplete]
AS
	--����
	DECLARE @ContractId uniqueidentifier
	DECLARE @ContractState NVARCHAR(20)
	DECLARE @ContractType NVARCHAR(100)
	DECLARE @RtnVal nvarchar(20)
	DECLARE @RtnMsg nvarchar(4000) 
	
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
	
		DECLARE @Sysflg INT
		DECLARE @DealerType nvarchar(20)
		DECLARE @DealerId	uniqueidentifier
		DECLARE @BeginDate DateTime
		
		UPDATE interface.T_I_EW_ContractState SET SynState=1 
		WHERE SynState=0 
		AND CONVERT(NVARCHAR(10),BeginDate,120) <= CONVERT(NVARCHAR(10),GETDATE(),120) 
		--AND ContractType='Renewal' ;
		
		DECLARE @PRODUCT_CUR cursor;
		SET @PRODUCT_CUR=cursor for 
			SELECT ContractId,ContractState,ContractType 
			FROM interface.T_I_EW_ContractState WHERE SynState=1  order by ContractState asc
		OPEN @PRODUCT_CUR
		FETCH NEXT FROM @PRODUCT_CUR INTO @ContractId,@ContractState,@ContractType
		WHILE @@FETCH_STATUS = 0        
			BEGIN
			SET @Sysflg=1;
			
			--�жϾ�������ѵ�Ƿ����
			IF @ContractState='Completed' and @ContractType IN ('Appointment','Renewal')
			BEGIN
				SET @DealerType=null;
				SET @DealerId=null;
				SET @BeginDate=null;
				
				IF @ContractType ='Appointment' 
					SELECT @DealerId=a.CAP_DMA_ID,@BeginDate=CAP_EffectiveDate,@DealerType=b.DMA_DealerType	FROM ContractAppointment a,DealerMaster b WHERE a.CAP_DMA_ID=b.DMA_ID and CAP_ID=@ContractId
				
				IF @ContractType ='Renewal' 
				    SELECT @DealerId=CRE_DMA_ID,@BeginDate=CRE_Agrmt_EffectiveDate_Renewal,@DealerType=b.DMA_DealerType FROM ContractRenewal a,DealerMaster b WHERE a.CRE_DMA_ID=b.DMA_ID and  CRE_ID=@ContractId
			
				IF EXISTS (SELECT 1 FROM  interface.T_I_MDM_DeaelrTraining a 
								WHERE a.DealerId=@DealerId 
								AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,-90,GETDATE())
								--AND (YEAR(TestDate)=YEAR(@BeginDate) OR (YEAR(TestDate)+1=YEAR(@BeginDate) and MONTH(TestDate)=12))
								AND A.TestStatus='��ͨ��' AND TestName='�������Ϲ�֪ʶ��ѵ-��������')
				AND (EXISTS (SELECT 1 FROM  interface.T_I_MDM_DeaelrTraining a WHERE  a.DealerId=@DealerId 
							AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,-90,GETDATE()) 
							--AND (YEAR(TestDate)=YEAR(@BeginDate) OR (YEAR(TestDate)+1=YEAR(@BeginDate) and MONTH(TestDate)=12))
							AND A.TestStatus='��ͨ��' AND TestName='������������ѵ����') OR @DealerType='T2')
				--AND (EXISTS(SELECT 1 FROM Attachment a where AT_Main_ID=@ContractId and a.AT_Type in ('LP_Agreement','T1_Agreement')) OR @DealerType='T2' OR @ContractType <>'Appointment' )
				BEGIN
					SET @Sysflg=1;
				END
				ELSE
				BEGIN
					SET @Sysflg=0;
					UPDATE interface.T_I_EW_ContractState SET SynState=0
					WHERE ContractId=@ContractId;
				END
			END
			
			IF @Sysflg=1
			BEGIN
				IF @ContractState='Completed'
				BEGIN
					--ͬ����ʷ��
					EXEC [interface].[P_I_EW_ContractHistoryComplete] @ContractId,@ContractType,'',''
					
					EXEC [interface].[P_I_EW_ContractExtensionComplete] @ContractId,@ContractType,'',''
					--ͬ����Ȩ
					EXEC [interface].[P_I_EW_ContractAuthorComplete] @ContractId,@ContractType,'',''
					
					--ͬ��������Ȩ
					/* ��Ȩ���������Ϣ��*/
					EXEC [dbo].[GC_MaintainAreaAutStatus] @ContractId, @ContractType
					
					--ͬ��ָ��
					EXEC [interface].[P_I_EW_ContractAOPComplete] @ContractId,@ContractType,'',''
				
				END
				
				--���º�ͬ������
				EXEC [dbo].[GC_UpdateDealerContractMaster] @ContractId,@ContractType,@ContractState,'',''
			END
			
			FETCH NEXT FROM @PRODUCT_CUR INTO @ContractId,@ContractState,@ContractType
			END
		CLOSE @PRODUCT_CUR
		DEALLOCATE @PRODUCT_CUR ;

		UPDATE interface.T_I_EW_ContractState  SET SynState=2 WHERE SynState=1 
		
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 

 SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    --��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	
	INSERT INTO MailMessageQueue 
	VALUES(NEWID(),'email','','kaichun.hua@cnc.grapecity.com','������'+@ContractType+'��ͬͬ�����󣬺�ͬ��ţ�'+CONVERT(nvarchar(50),@ContractId),@RtnMsg,'Waiting',GETDATE(),null)
	
    return -1
		
END CATCH




GO


