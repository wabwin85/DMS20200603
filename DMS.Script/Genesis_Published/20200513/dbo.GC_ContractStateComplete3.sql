SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


/*
ά����ͬ������
*/
ALTER Procedure [dbo].[GC_ContractStateComplete]
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
		DECLARE @BeginDate DATETIME
        DECLARE @Status NVARCHAR(20)
	
		Create table #ContractState(
			[ContractId] [uniqueidentifier] NOT NULL,
			[BeginDate] [datetime] NOT NULL,
			[ContractState] [nvarchar](100) NOT NULL,
			[ContractType] [nvarchar](50) NOT NULL,
			[SynState] [int] NOT NULL
		)
	
	
		
		UPDATE  A SET SynState=1  from interface.T_I_EW_ContractState a 
		WHERE a.SynState=0 
		AND CONVERT(NVARCHAR(10),A.BeginDate,120) <= CONVERT(NVARCHAR(10),GETDATE(),120) 
		--AND ContractType='Renewal' ;
		
		INSERT INTO #ContractState(ContractId,BeginDate,ContractState,ContractType,SynState)
		select ContractId,BeginDate,ContractState,ContractType,SynState from interface.T_I_EW_ContractState  where SynState=1
		

		DECLARE @PRODUCT_CUR cursor;
		SET @PRODUCT_CUR=cursor for 
			SELECT ContractId,ContractState,ContractType 
			FROM #ContractState WHERE SynState=1  order by BeginDate asc
		OPEN @PRODUCT_CUR
		FETCH NEXT FROM @PRODUCT_CUR INTO @ContractId,@ContractState,@ContractType
		WHILE @@FETCH_STATUS = 0        
			BEGIN
			SET @Sysflg=1;
			SET @Status='';
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
                
				IF dbo.FN_Contract_IsPassTraining(@ContractId,@DealerId,@DealerType)=1
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
			--�жϺ�ͬ״̬�Ƿ�������
            IF ( EXISTS ( SELECT    1
                          FROM      Contract.ExportT2Main Em
                                    INNER JOIN Contract.ExportVersion Ex ON Em.ExportId = Ex.ExportId
                          WHERE     Ex.VersionStatus IN ( 'WaitDealerSign',
                                                          'WaitBscSign',
                                                          'Complete',
                                                          'BscAbandonment',
                                                          'Cancelled',
                                                          'WaitDealerAbandonment',
                                                          'Abandonment',
                                                          'WaitLPSign' )
                                    AND Em.ContractId = @ContractId )
                 OR EXISTS ( SELECT 1
                             FROM   Contract.ExportMain Em
                                    INNER JOIN Contract.ExportVersion Ex ON Em.ExportId = Ex.ExportId
                             WHERE  Ex.VersionStatus IN ( 'WaitDealerSign',
                                                          'WaitBscSign',
                                                          'Complete',
                                                          'BscAbandonment',
                                                          'Cancelled',
                                                          'WaitDealerAbandonment',
                                                          'Abandonment' )
                                    AND Em.ContractId = @ContractId )
               )
                BEGIN
                    SET @Status = 'NewContract';
                END;
			IF(@Status = '')
			BEGIN
				SET @Sysflg=0;
					UPDATE interface.T_I_EW_ContractState SET SynState=0
					WHERE ContractId=@ContractId;
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
	VALUES(NEWID(),'email','','cooper.xu@grapecity.com','������'+@ContractType+'��ͬͬ������GC_ContractStateComplete����ͬ��ţ�'+CONVERT(nvarchar(50),@ContractId),@RtnMsg,'Waiting',GETDATE(),null)
	
    return -1
		
END CATCH










GO

