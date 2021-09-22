DROP PROCEDURE [interface].[P_I_EW_Contract_Status_250327]
GO


/*
平台收货确认数据处理
*/
CREATE PROCEDURE [interface].[P_I_EW_Contract_Status_250327]
@Contract_ID nvarchar(36), @Contract_Type nvarchar(50), @Contract_Status nvarchar(20), @RtnVal nvarchar(20) OUTPUT, @RtnMsg nvarchar(4000) OUTPUT
WITH EXEC AS CALLER
AS
DECLARE @Division NVARCHAR(100)
DECLARE @DivCode NVARCHAR(100)
DECLARE @SubDepID NVARCHAR(50)
DECLARE @CC_ID uniqueidentifier
DECLARE @CC_NameCN NVARCHAR(500)
	DECLARE @ProductLine uniqueidentifier
	DECLARE @DMA_ID uniqueidentifier
	DECLARE @CON_BEGIN DATETIME
	DECLARE @CON_END DATETIME
	DECLARE @CON_NUMB NVARCHAR(20)
	-----市场分类参数
	--DECLARE @Mark  NVARCHAR(20) --是否新兴市场
	DECLARE @MarktType  NVARCHAR(10) --是否新兴市场
	DECLARE @HasDCL_ID  uniqueidentifier-- 判断是否已有老合同
	DECLARE @MarkDAT_ID uniqueidentifier
	CREATE TABLE #TBProductLine
	(
		Id uniqueidentifier
	)
	---修改正式数据库合同主表
	DECLARE @ConStartDate NVARCHAR(10)
	DECLARE @ConStopDate NVARCHAR(10)
	DECLARE @ConDclID uniqueidentifier
	DECLARE @ConDatID uniqueidentifier
  DECLARE @ConPMA_ID uniqueidentifier
	--维护DealerContractMast
	DECLARE @FinalBegin datetime
	DECLARE @FinalEnd datetime
	DECLARE @Exclusiveness NVARCHAR(100)
	DECLARE @ProductLin NVARCHAR(100)
	DECLARE @ProductLinRemarks NVARCHAR(100)
	DECLARE @Prices NVARCHAR(100)
	DECLARE @PricesRemarks NVARCHAR(2000)
	DECLARE @SpecialSales NVARCHAR(100)
	DECLARE @SpecialSalesRemarks NVARCHAR(2000)
	DECLARE @CreditLimits NVARCHAR(100)
	DECLARE @Payment NVARCHAR(100)
	DECLARE @SecurityDeposit NVARCHAR(100)
	DECLARE @Account NVARCHAR(100)
	DECLARE @GuaranteeWay NVARCHAR(200)
	DECLARE @GuaranteeWayRemark NVARCHAR(1000)
	DECLARE @Attachment NVARCHAR(100)
	--Amendment参数
	DECLARE @AmendmentSQLUpdate NVARCHAR(2000)
	DECLARE @AmdProductIsChange bit
	DECLARE @AmdPriceIsChange bit
	DECLARE @AmdSpecialIsChange bit
	DECLARE @AmdHospitalIsChange bit
	DECLARE @AmdQuotaIsChange bit
	DECLARE @AmdPaymentIsChange bit
	DECLARE @AmdCreditLimitIsChange bit
	--SUB BU
	DECLARE @SUBBU_ProductLineId uniqueidentifier
	DECLARE @SUBBU_PMA_ID uniqueidentifier
	DECLARE @SUBBU_DMA_ID uniqueidentifier
	DECLARE @SUBBU_DAT_ID_Temp uniqueidentifier
	DECLARE @SUBBU_DAT_ID uniqueidentifier
	--ApplicantUser
	DECLARE @ApplicantUser NVARCHAR(100)

	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SELECT top 1 @ApplicantUser=Name FROM [interface].[Biz_Dealer_Approval] WHERE ApplicationID=@Contract_ID ORDER BY DoneTime ;
	SELECT  @MarktType= CONVERT(NVARCHAR(10),ISNULL(MarketType,0)),@SubDepID= SubDepID,@Division=Division FROM Interface.T_I_EW_Contract A WHERE A.InstanceID=@Contract_ID;
	SELECT @CC_ID= CC_ID,@CC_NameCN=CC_NameCN FROM interface.ClassificationContract a WHERE A.CC_Code=@SubDepID;
	INSERT INTO #TBProductLine (Id)
		SELECT DV.ProductLineID FROM V_DivisionProductLineRelation  DV
		WHERE DV.DivisionName=@Division AND DV.IsEmerging='0';
	SELECT @DivCode=A.DivisionCode FROM V_DivisionProductLineRelation A WHERE  A.DivisionName=@Division AND A.IsEmerging='0';
	--维护历史记录
	
	
	
	IF @Contract_Type='Appointment'
	BEGIN
		
		
		DECLARE @DM_TY NVARCHAR(50)
		--发邮件通知填写IAF
		DECLARE @email NVARCHAR(200)
		DECLARE @dealerTypeEM NVARCHAR(5)
		DECLARE @ISEquipment NVARCHAR(5)
		DECLARE @dealerName NVARCHAR(500)
		DECLARE @dealerAccount NVARCHAR(100)
		DECLARE @mailBody NVARCHAR(4000)
		DECLARE @mailName NVARCHAR(100)
		DECLARE @mailBodyCo NVARCHAR(4000)
		DECLARE @mailNameCo NVARCHAR(100)
		DECLARE @mailBodyLP NVARCHAR(4000)
		DECLARE @mailNameLP NVARCHAR(100)
		DECLARE @ProductName_App NVARCHAR(100)
		
			SELECT @dealerName= CAP_Company_Name,@email=CAP_Email_Address,@ISEquipment=CAP_Type,@Division=CAP_Division  ,@DM_TY=B.DealerLevel
		FROM ContractAppointment A
		INNER JOIN INTERFACE.T_I_EW_Contract  B ON A.CAP_ID=B.InstanceID
		WHERE A.CAP_ID=@Contract_ID
		
		SELECT @dealerAccount=DealerMaster.DMA_SAP_Code,@dealerTypeEM=DealerMaster.DMA_DealerType 
			FROM Lafite_IDENTITY INNER JOIN  DealerMaster 
			ON Lafite_IDENTITY.Corp_ID=DealerMaster.DMA_ID   
			WHERE  DealerMaster.DMA_ChineseName=@dealerName
			and DealerMaster.DMA_DealerType=@DM_TY;
			
		SELECT @ProductName_App= ProductLineName FROM V_DivisionProductLineRelation WHERE DivisionName=@Division AND IsEmerging='0'
		SET @dealerAccount=ISNULL(@dealerAccount,'')+'_01';
		--账号建立后邮件通知Dealer LP CO
		select @mailNameCo=MMT_Subject,@mailBodyCo=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_DEALERACCOUNTTOCO';
		IF (@dealerTypeEM='T1' OR @dealerTypeEM='LP')
		BEGIN
			IF(@Contract_Status='COApproved')
			BEGIN
				select @mailName=MMT_Subject,@mailBody=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_DEALERIAF';
				SET @mailBody=REPLACE(REPLACE(REPLACE(@mailBody,'{#DealerName}',@dealerName),'{#Account}',@dealerAccount),'{#ApplicantUser}',ISNULL(@ApplicantUser,''));
				SET @mailName=@Division+'-'+@CC_NameCN+'-'+@dealerName+'-'+'Appointment'+'('+@dealerTypeEM+')-'+@mailName
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				VALUES(NEWID(),'email','',@email,@mailName,@mailBody,'Waiting',GETDATE(),NULL);
				
				--select  @mailBody,@mailName
			
				
		
			END
		END
	END
	
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
END CATCH

GO


