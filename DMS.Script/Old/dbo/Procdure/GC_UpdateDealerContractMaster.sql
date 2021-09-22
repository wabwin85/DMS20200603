DROP  Procedure [dbo].[GC_UpdateDealerContractMaster]
GO



/*
维护合同主数据
*/
CREATE Procedure [dbo].[GC_UpdateDealerContractMaster]
	@ContractId NVARCHAR(36),
	@ContractType NVARCHAR(100),
	@ContractState NVARCHAR(20),
	@RtnVal NVARCHAR(20) output,
	@RtnMsg nvarchar(4000)  output

AS
	DECLARE @Check_DCM INT; 	
	DECLARE @DMA_ID uniqueidentifier
	DECLARE @Division NVARCHAR(100)
	DECLARE @MarktType  NVARCHAR(10) --是否新兴市场
	DECLARE @SubDepID NVARCHAR(50)
	DECLARE @CC_ID uniqueidentifier
	
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
	DECLARE @PayTerm NVARCHAR(50)
	DECLARE @IsDeposit INT
	
	DECLARE @AmendmentSQLUpdate NVARCHAR(2000)
	DECLARE @AmdProductIsChange bit
	DECLARE @AmdPriceIsChange bit
	DECLARE @AmdSpecialIsChange bit
	DECLARE @AmdHospitalIsChange bit
	DECLARE @AmdQuotaIsChange bit
	DECLARE @AmdPaymentIsChange bit
	DECLARE @AmdCreditLimitIsChange bit
	DECLARE @CON_BEGIN DATETIME
	DECLARE @CON_END DATETIME
	
	DECLARE @TerminationType NVARCHAR(200)
	
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
	SELECT  @MarktType= CONVERT(NVARCHAR(10),ISNULL(MarketType,0)),@SubDepID= SubDepID,@Division=Division FROM Interface.T_I_EW_Contract A WHERE A.InstanceID=@ContractId;
	SELECT @CC_ID= CC_ID FROM interface.ClassificationContract a WHERE A.CC_Code=@SubDepID;
	
	--------------------------------
	
	IF @ContractState='Completed' AND @ContractType='Appointment'
	BEGIN
			SELECT @DMA_ID=CAP_DMA_ID FROM ContractAppointment A WHERE A.CAP_ID=@ContractId
			SELECT @Check_DCM=COUNT(*) FROM DealerContractMaster A
			INNER JOIN V_DivisionProductLineRelation DV ON DV.DivisionCode=CONVERT(NVARCHAR(10),A.DCM_Division) AND DV.IsEmerging='0'
			WHERE DCM_DMA_ID=@DMA_ID AND DV.DivisionName=@Division AND  CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))=@MarktType AND DCM_CC_ID=@CC_ID;
			
			IF(@Check_DCM>0)
			BEGIN
				UPDATE DealerContractMaster 
				SET [DCM_ContractType]=A.CAP_Contract_Type,[DCM_BSCEntity]=A.CAP_BSC_Entity,
					[DCM_Exclusiveness]=A.CAP_Exclusiveness,[DCM_EffectiveDate]=A.CAP_EffectiveDate,
					[DCM_ExpirationDate]=A.CAP_ExpirationDate,
					[DCM_ProductLine]=(CASE WHEN A.CAP_ProductLine='All' THEN 'All' ELSE 'Partial' END),
					[DCM_ProductLineRemark]=(CASE WHEN A.CAP_ProductLine='All' THEN NULL ELSE CAP_ProductLine END),
					[DCM_Credit_Limit]=A.CAP_Credit_Limit,[DCM_Credit_Term]=A.CAP_Account,
					[DCM_Pricing]=A.CAP_Pricing,[DCM_Pricing_Discount]=A.CAP_Pricing_Discount,
					[DCM_Pricing_Discount_Remark]=A.CAP_Pricing_Discount_Remark, [DCM_Pricing_Rebate]=A.CAP_Pricing_Rebate,
					[DCM_Pricing_Rebate_Remark]=A.CAP_Pricing_Rebate_Remark,[DCM_Payment_Term]=A.CAP_Payment_Term,
					[DCM_Security_Deposit]=A.CAP_Security_Deposit,[DCM_Guarantee]=A.CAP_Guarantee_Remark,
					[DCM_Attachment]=A.CAP_Attachment,[DCM_Update_Date]=GETDATE(),
					[DCM_TerminationDate]=null,
					[DCM_PayTerm]=A.CAP_PayTerm,
					[DCM_IsDeposit]=A.CAP_IsDeposit
				FROM ContractAppointment A  
				INNER JOIN DealerMaster B ON A.CAP_DMA_ID=B.DMA_ID
				INNER JOIN V_DivisionProductLineRelation DV ON DV.DivisionName=A.CAP_Division AND DV.IsEmerging='0'
				WHERE A.CAP_ID=@ContractId
				AND DealerContractMaster.DCM_DMA_ID=B.DMA_ID 
				AND CONVERT(NVARCHAR(10),DealerContractMaster.DCM_Division)=DV.DivisionCode
				AND CONVERT(NVARCHAR(10),ISNULL(DealerContractMaster.DCM_MarketType,0))= @MarktType
				AND DCM_CC_ID=@CC_ID;
			END
			ELSE
			BEGIN
				INSERT INTO DealerContractMaster
				(DCM_CC_ID,[DCM_ID],[DCM_DMA_ID],[DCM_Division],[DCM_MarketType],[DCM_ContractType],[DCM_DealerType],[DCM_BSCEntity]
				,[DCM_Exclusiveness],[DCM_EffectiveDate],[DCM_ExpirationDate],[DCM_ProductLine],[DCM_ProductLineRemark]
				,[DCM_Credit_Limit],[DCM_Credit_Term],[DCM_Pricing],[DCM_Pricing_Discount],[DCM_Pricing_Discount_Remark],[DCM_Pricing_Rebate]
				,[DCM_Pricing_Rebate_Remark],[DCM_Payment_Term],[DCM_Security_Deposit],[DCM_Guarantee],[DCM_GuaranteeRemark],[DCM_Attachment],[DCM_Delete_flag],[DCM_Update_Date],[DCM_FirstContractDate],DCM_FristCooperationDate,DCM_PayTerm,DCM_IsDeposit)
				SELECT @CC_ID,NEWID(),CAP_DMA_ID,(SELECT REV1 FROM Lafite_ATTRIBUTE WHERE ATTRIBUTE_TYPE='BU' AND DELETE_FLAG='0' AND ATTRIBUTE_NAME=ContractAppointment.CAP_Division ),
				ISNULL(CAP_MarketType,0),CAP_Contract_Type,DealerMaster.DMA_DealerType,CAP_BSC_Entity,
				CAP_Exclusiveness,CAP_EffectiveDate,CAP_ExpirationDate, (CASE WHEN CAP_ProductLine='All' THEN 'All' ELSE 'Partial' END),(CASE WHEN CAP_ProductLine='All' THEN NULL ELSE CAP_ProductLine END),
				CAP_Credit_Limit,CAP_Account,CAP_Pricing,CAP_Pricing_Discount,CAP_Pricing_Discount_Remark,CAP_Pricing_Rebate,
				CAP_Pricing_Rebate_Remark,CAP_Payment_Term,CAP_Security_Deposit,CAP_Guarantee,CAP_Guarantee_Remark,CAP_Attachment,'0',getdate(),CAP_EffectiveDate,CAP_EffectiveDate,CAP_PayTerm,CAP_IsDeposit
				FROM ContractAppointment
				INNER JOIN DealerMaster ON ContractAppointment.CAP_DMA_ID=DealerMaster.DMA_ID
				WHERE ContractAppointment.CAP_ID=@ContractId;
			 END
	END
	IF @ContractState='Completed' AND @ContractType='Amendment'
	BEGIN
		SELECT @DMA_ID=CAM_DMA_ID FROM ContractAmendment A WHERE A.CAM_ID=@ContractId
		SET @AmendmentSQLUpdate='';
		SELECT	--@Exclusiveness=CRE_Exclusiveness_Renewal,
					@AmdProductIsChange=CAM_ProductLine_IsChange,
					@ProductLin=CAM_ProductLine_New,@ProductLinRemarks=CAM_ProductLine_Remarks,
					
					@AmdPriceIsChange=CAM_Price_IsChange,
					@Prices=CAM_Price_New,@PricesRemarks=CAM_Price_Remarks,
					
					@AmdSpecialIsChange=CAM_Special_IsChange,
					@SpecialSales=CAM_Special_Amendment,@SpecialSalesRemarks=CAM_Special_Amendment_Remraks,
					
					@AmdHospitalIsChange=CAM_Territory_IsChange,
					@AmdQuotaIsChange=CAM_Quota_IsChange,
					@CON_END=CAM_Agreement_ExpirationDate,
					@AmdPaymentIsChange=CAM_Payment_IsChange,
					@Payment=CAM_Payment_New,
					@CreditLimits=CAM_Credit_Limit_New,
					@Account=CAM_Account_New,
					@SecurityDeposit=CAM_Security_Deposit_New ,
					@GuaranteeWay=CAM_Guarantee_Way_New,
					@GuaranteeWayRemark=CAM_Guarantee_Way_Remark,
					@Attachment=CAM_Attachment_New,
					@PayTerm=CAM_PayTerm,
					@IsDeposit=CAM_IsDeposit
			FROM ContractAmendment WHERE CAM_ID= @ContractId
	
		
		SELECT @Check_DCM=COUNT(*) FROM DealerContractMaster A
		INNER JOIN V_DivisionProductLineRelation DV ON DV.DivisionCode=CONVERT(NVARCHAR(10),A.DCM_Division) AND DV.IsEmerging='0'
		WHERE DCM_DMA_ID=@DMA_ID AND DV.DivisionName=@Division AND  CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))= @MarktType
		AND DCM_CC_ID=@CC_ID;
		
		
		IF @Check_DCM >0
			BEGIN
				SET @AmendmentSQLUpdate=' UPDATE DealerContractMaster SET DCM_Update_Date=''' + Convert(NVARCHAR(12),GETDATE(),111)+'''  '
				IF @AmdProductIsChange=1
				BEGIN
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ' ,DCM_ProductLine= ''' + @ProductLin+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ' ,DCM_ProductLineRemark= ''' + ISNULL( @PricesRemarks,'')+''' '
				END
				IF @AmdPriceIsChange =1
				BEGIN
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Pricing_Discount= ''' + ISNULL( @Prices,'')+''', DCM_Pricing_Discount_Remark=''' + ISNULL( @PricesRemarks,'')+''' '
				END
				IF @AmdSpecialIsChange=1
				BEGIN
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Pricing_Rebate= ''' + ISNULL( @SpecialSales,'')+''', DCM_Pricing_Rebate_Remark=''' + ISNULL( @SpecialSalesRemarks,'')+''' '
				END
				IF @AmdPaymentIsChange=1
				BEGIN
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Payment_Term= ''' + ISNULL( @Payment,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Credit_Limit= ''' + ISNULL( @CreditLimits,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Attachment= ''' + ISNULL( @Attachment,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Guarantee= ''' + ISNULL( @GuaranteeWay,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_GuaranteeRemark= ''' + ISNULL( @GuaranteeWayRemark,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Credit_Term= ''' + ISNULL( @Account,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Security_Deposit= ''' + ISNULL( @SecurityDeposit,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_PayTerm= ''' + ISNULL( @PayTerm,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_IsDeposit= ''' + CONVERT(nvarchar(10),ISNULL(@IsDeposit,0))+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_TerminationDate= null '
					
				END
				SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ' WHERE DCM_DMA_ID= ''' + Convert(NVARCHAR(36),@DMA_ID)+''' '
				SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ' AND  DCM_Division IN (SELECT REV1 FROM Lafite_ATTRIBUTE WHERE ATTRIBUTE_TYPE= '+'''BU'' ' + ' AND DELETE_FLAG=0 AND ATTRIBUTE_NAME= '''+@Division+''' )'
				SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ' AND CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))='+@MarktType ;
				SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ' AND DCM_CC_ID=''' +CONVERT(NVARCHAR(100), @CC_ID)+''' '
				
				EXEC(@AmendmentSQLUpdate) ;
			END
			ELSE
			BEGIN
				INSERT INTO DealerContractMaster (DCM_CC_ID,DCM_ID,DCM_DMA_ID,DCM_DealerType,DCM_Division,DCM_MarketType,DCM_ContractType,DCM_BSCEntity,
				DCM_Update_Date,DCM_EffectiveDate,DCM_ExpirationDate,DCM_ProductLine,DCM_ProductLineRemark,
				DCM_Pricing_Discount,DCM_Pricing_Discount_Remark,DCM_Pricing_Rebate,DCM_Pricing_Rebate_Remark,
				DCM_Payment_Term,DCM_Credit_Limit,DCM_Attachment,DCM_Guarantee,DCM_GuaranteeRemark,DCM_Credit_Term,DCM_Security_Deposit,DCM_FirstContractDate,DCM_FristCooperationDate,DCM_PayTerm,DCM_IsDeposit)
				SELECT @CC_ID,NEWID(),B.DMA_ID,B.DMA_DealerType,(SELECT TOP 1 DV.DivisionCode FROM V_DivisionProductLineRelation DV WHERE DV.DivisionName=A.CAM_Division),@MarktType,'Dealer','China',
				Convert(NVARCHAR(12),GETDATE(),111),Convert(NVARCHAR(12),CAM_Amendment_EffectiveDate,111),CONVERT(varchar(12) , @CON_END, 111 ),@ProductLin,ISNULL( @PricesRemarks,''),
				ISNULL( @Prices,''),ISNULL( @PricesRemarks,''),ISNULL( @SpecialSales,''),ISNULL( @SpecialSalesRemarks,''),
				ISNULL( @Payment,''),ISNULL( @CreditLimits,''),ISNULL( @Attachment,''),ISNULL( @GuaranteeWay,''),ISNULL( @GuaranteeWayRemark,''),ISNULL( @Account,''),ISNULL( @SecurityDeposit,''),Convert(NVARCHAR(12),CAM_Amendment_EffectiveDate,111),Convert(NVARCHAR(12),CAM_Amendment_EffectiveDate,111),CAM_PayTerm,CAM_IsDeposit
				FROM ContractAmendment A  INNER JOIN DealerMaster B ON A.CAM_DMA_ID=B.DMA_ID
				WHERE A.CAM_ID=@ContractId
			END
	END
	IF @ContractState='Completed' AND @ContractType='Renewal'
	BEGIN
		SELECT @DMA_ID=CRE_DMA_ID FROM ContractRenewal A WHERE A.CRE_ID=@ContractId
		SELECT	@Exclusiveness=CRE_Exclusiveness_Renewal,@ProductLin=CRE_ProductLine_New,@ProductLinRemarks=CRE_ProductLine_Remarks,
					@Prices=CRE_Prices_Renewal,@PricesRemarks=CRE_Prices_Remarks,
					@SpecialSales=CRE_SpecialSales_Renewal,@SpecialSalesRemarks=CRE_SpecialSales_Remarks,
					@CreditLimits=CRE_CreditLimits_Renewal,@Payment=CRE_Payment_Renewal,@SecurityDeposit=CRE_SecurityDeposit_Renewal,
					@Account=CRE_Account_Renewal,
					@GuaranteeWay=CRE_Guarantee_Way_Renewal,
					@GuaranteeWayRemark=CRE_Guarantee_Way_Remark,
					@Attachment=CRE_Attachment_Renewal,
					@CON_BEGIN= CRE_Agrmt_EffectiveDate_Renewal,
					@CON_END=CRE_Agrmt_ExpirationDate_Renewal,
					@PayTerm=CRE_PayTerm,
					@IsDeposit=CRE_IsDeposit
			FROM ContractRenewal WHERE CRE_ID= @ContractId
		
			SELECT @Check_DCM=COUNT(*) FROM DealerContractMaster A
			INNER JOIN V_DivisionProductLineRelation DV ON DV.DivisionCode=CONVERT(NVARCHAR(10),A.DCM_Division) AND DV.IsEmerging='0'
			WHERE DCM_DMA_ID=@DMA_ID AND DV.DivisionName=@Division AND  CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))= @MarktType
			AND DCM_CC_ID=@CC_ID;
			
			IF(@Check_DCM>0)
			BEGIN
				UPDATE DealerContractMaster 
				SET DCM_Exclusiveness=@Exclusiveness,
					DCM_EffectiveDate=@CON_BEGIN,
					DCM_ExpirationDate=@CON_END,
					DCM_ProductLine=@ProductLin, 
					DCM_ProductLineRemark=@ProductLinRemarks,
					DCM_Pricing_Discount=@Prices,
					DCM_Pricing_Discount_Remark=@PricesRemarks,
					DCM_Pricing_Rebate=@SpecialSales, 
					DCM_Pricing_Rebate_Remark=@SpecialSalesRemarks,
					DCM_Credit_Limit=@CreditLimits,
					DCM_Payment_Term=@Payment,
					DCM_Security_Deposit=@SecurityDeposit,
					DCM_Credit_Term=@Account,
					DCM_Guarantee=@GuaranteeWay,
					DCM_GuaranteeRemark=@GuaranteeWayRemark,
					DCM_Attachment =@Attachment,
					DCM_TerminationDate=null,
					DCM_PayTerm=@PayTerm,
					DCM_IsDeposit=@IsDeposit
				WHERE DCM_DMA_ID=@DMA_ID  
				AND  CONVERT(NVARCHAR(10), DCM_Division) IN (SELECT a.DivisionCode FROM V_DivisionProductLineRelation a where a.DivisionName=@Division and a.IsEmerging='0')
				AND  CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))= @MarktType
				AND DCM_CC_ID=@CC_ID
			END
			ELSE
			BEGIN
				INSERT INTO DealerContractMaster(DCM_CC_ID,DCM_ID,DCM_DMA_ID,DCM_DealerType,DCM_Division,DCM_MarketType,
				DCM_Update_Date,DCM_EffectiveDate,DCM_ExpirationDate,DCM_ProductLine,DCM_ProductLineRemark,
				DCM_Pricing_Discount,DCM_Pricing_Discount_Remark,DCM_Pricing_Rebate,DCM_Pricing_Rebate_Remark,
				DCM_Credit_Limit,DCM_Payment_Term,DCM_Security_Deposit,DCM_Credit_Term,
				DCM_Guarantee,DCM_GuaranteeRemark,DCM_Attachment,DCM_ContractType,	DCM_BSCEntity,	DCM_Exclusiveness,DCM_PayTerm,DCM_IsDeposit)
				SELECT @CC_ID,NEWID(),B.DMA_ID,B.DMA_DealerType,(SELECT TOP 1 DV.DivisionCode FROM V_DivisionProductLineRelation DV WHERE DV.DivisionName=A.CRE_Division),@MarktType,
				GETDATE(),A.CRE_Agrmt_EffectiveDate_Renewal,A.CRE_Agrmt_ExpirationDate_Renewal,@ProductLin,@ProductLinRemarks,
				@Prices,@PricesRemarks,@SpecialSales,@SpecialSalesRemarks,
				@CreditLimits,@Payment,@SecurityDeposit,@Account,@GuaranteeWay,@GuaranteeWayRemark,@Attachment,'Dealer','China','Exclusive',@PayTerm,@IsDeposit
				FROM ContractRenewal A INNER JOIN DealerMaster B ON A.CRE_DMA_ID=B.DMA_ID
				WHERE A.CRE_ID=@ContractId
			END
	END
	IF @ContractState='Completed' AND @ContractType='Termination'
	BEGIN
		SELECT @DMA_ID=CTE_DMA_ID,
				@CON_BEGIN=CTE_Termination_EffectiveDate,
				@Division=CTE_Division ,
				@TerminationType=CTE_TerminationStatus 
				FROM  ContractTermination 
				WHERE CTE_ID= @ContractId
			
				IF(@TerminationType='Non-Renewal')
				BEGIN
					UPDATE DealerContractMaster SET DCM_TerminationDate=@CON_BEGIN  
					WHERE DCM_DMA_ID=@DMA_ID 
					AND CONVERT(nvarchar(10), DCM_Division) IN (SELECT  B.DivisionCode FROM V_DivisionProductLineRelation B WHERE DivisionName=@Division AND B.IsEmerging='0' )
					AND CONVERT( nvarchar(10),ISNULL(DCM_MarketType,0))=ISNULL(@MarktType,'0')
					AND DCM_CC_ID=@CC_ID;
				END
				else
				BEGIN
					UPDATE DealerContractMaster SET DCM_TerminationDate=@CON_BEGIN  
					WHERE DCM_DMA_ID=@DMA_ID 
					AND CONVERT(nvarchar(10), DCM_Division) IN (SELECT B.DivisionCode FROM V_DivisionProductLineRelation B WHERE DivisionName=@Division AND B.IsEmerging='0' )
					AND CONVERT( nvarchar(10),ISNULL(DCM_MarketType,0))=ISNULL(@MarktType,'0')
					AND DCM_CC_ID=@CC_ID;
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


