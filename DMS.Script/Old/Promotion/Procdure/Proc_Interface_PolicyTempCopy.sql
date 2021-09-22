DROP PROCEDURE [Promotion].[Proc_Interface_PolicyTempCopy] 
GO


/**********************************************
	功能：将政策COPY进TEMP表
	作者：GrapeCity
	最后更新时间：	2015-11-01
	更新记录说明：
	1.创建 2015-11-01
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_PolicyTempCopy] 
	@PolicyId INT,
	@UserId NVARCHAR(50),
	@Mode NVARCHAR(50),
	@NewId INT = NULL OUTPUT,
	@Result  nvarchar(20) = 'Failed' output 
AS
BEGIN TRY
	BEGIN TRAN
	
	--清空临时表
	DELETE FROM PROMOTION.PRO_POLICY_UI WHERE CurrUser = @UserId
	DELETE FROM PROMOTION.PRO_DEALER_UI WHERE CurrUser = @UserId
	DELETE FROM PROMOTION.PRO_POLICY_FACTOR_UI WHERE CurrUser = @UserId
	DELETE FROM PROMOTION.PRO_POLICY_FACTOR_RELATION_UI WHERE CurrUser = @UserId
	DELETE FROM PROMOTION.PRO_POLICY_FACTOR_CONDITION_UI WHERE CurrUser = @UserId
	DELETE FROM PROMOTION.Pro_Hospital_PrdSalesTaget_UI WHERE CurrUser = @UserId
	DELETE FROM PROMOTION.Pro_Dealer_PrdPurchase_Taget_UI WHERE CurrUser = @UserId
	DELETE FROM PROMOTION.PRO_POLICY_RULE_UI WHERE CurrUser = @UserId
	DELETE FROM PROMOTION.PRO_POLICY_RULE_FACTOR_UI WHERE CurrUser = @UserId
	DELETE FROM PROMOTION.PRO_POLICY_LARGESS_UI WHERE CurrUser = @UserId
	DELETE FROM PROMOTION.PRO_POLICY_TOPVALUE_UI WHERE CurrUser = @UserId
	DELETE FROM PROMOTION.Pro_Dealer_Std_Point_UI WHERE CurrUser = @UserId
	DELETE FROM PROMOTION.PRO_POLICY_POINTRATIO_UI WHERE CurrUser = @UserId
	
	DECLARE @PolicyName NVARCHAR(100)
	DECLARE @NewPolicyId INT
	
	SET @PolicyName = 'CREATED BY '+@UserId+' AT '+ CONVERT(NVARCHAR(19),GETDATE(),121)
	
	INSERT INTO Promotion.PRO_POLICY(POLICYNAME,STATUS,CreateBy,CreateTime,IsTemplate,PolicyMode,SoucePolicy) SELECT @PolicyName,'草稿',@UserId,GETDATE(),
		case when @Mode = 'Copy' THEN IsTemplate else 0 END,case when @Mode = 'Copy' THEN PolicyMode else 'Template' END,PolicyId
		FROM Promotion.PRO_POLICY WHERE PolicyId = @PolicyId 
	
	SELECT @NewPolicyId = PolicyId FROM Promotion.PRO_POLICY WHERE PolicyName = @PolicyName AND CreateBy = @UserId
	
	SET @NewId = @NewPolicyId
	
	INSERT INTO Promotion.PRO_POLICY_UI(PolicyId,PolicyNo,PolicyName,Description,Period,
		StartDate,
		EndDate,
		BU,TopType,TopValue,CalType,IsPrePrice,PrePriceValue,Status,ReportTableName,TempTableName,PreTableName,CurrentPeriod,ApproveStatus,PolicyType,ifConvert,ifMinusLastGift,ifAddLastLeft,ifCalPurchaseAR,ifCalSalesAR,CalModule,CalStatus,CalPeriod,StartTime,EndTime,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,Remark2,Remark3,SubBu,CarryType,ifIncrement,PolicyGroupName,PolicyClass,ifCalRebateAR,CurrUser,
		PointValidDateType,PointValidDateDuration,PointValidDateAbsolute,PolicyStyle,PolicySubStyle,PointUseRange,YTDOption,PointValidDateType2,PointValidDateDuration2,PointValidDateAbsolute2)
		
	SELECT 
		@NewPolicyId,
		NULL AS PolicyNo,
		PolicyName+'-NEW',Description,Period,
		--CONVERT(NVARCHAR(10),CONVERT(DATETIME,StartDate+'01'),121) StartDate,
		--CONVERT(NVARCHAR(10),DATEADD(M,1,CONVERT(DATETIME,EndDate+'01'))-1,121) EndDate,
		StartDate,
		EndDate,
		BU,TopType,TopValue,CalType,IsPrePrice,PrePriceValue,
		'草稿' Status,
		NULL ReportTableName,NULL TempTableName,NULL PreTableName,NULL CurrentPeriod,NULL ApproveStatus,
		PolicyType,ifConvert,ifMinusLastGift,ifAddLastLeft,ifCalPurchaseAR,ifCalSalesAR,
		CalModule,NULL CalStatus,NULL CalPeriod,NULL StartTime,NULL EndTime,
		@UserId AS CreateBy,GETDATE() AS CreateTime,
		@UserId AS ModifyBy,GETDATE() AS ModifyDate,
		Remark1,Remark2,Remark3,SubBu,CarryType,ifIncrement,PolicyGroupName,PolicyClass,ifCalRebateAR,@UserId,
		PointValidDateType,PointValidDateDuration,PointValidDateAbsolute,PolicyStyle,PolicySubStyle,PointUseRange,YTDOption
		,PointValidDateType2,PointValidDateDuration2,PointValidDateAbsolute2
	FROM Promotion.PRO_POLICY WHERE PolicyId = @PolicyId 
	
	INSERT INTO Promotion.PRO_DEALER_UI(PolicyId,WithType,OperType,DEALERID,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,CurrUser)
	SELECT @NewPolicyId,WithType,OperType,DEALERID,
	@UserId AS CreateBy,GETDATE() AS CreateTime,@UserId AS ModifyBy,GETDATE() AS ModifyDate,Remark1,@UserId
	FROM Promotion.PRO_DEALER WHERE PolicyId = @PolicyId

	INSERT INTO Promotion.PRO_POLICY_FACTOR_UI(PolicyFactorId,PolicyId,FactId,FactDesc,DataType,FactValue,
		CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,FactType,CurrUser)
	SELECT PolicyFactorId,
		@NewPolicyId AS PolicyId,
		FactId,FactDesc,DataType,FactValue,
		@UserId AS CreateBy,GETDATE() AS CreateTime,@UserId AS ModifyBy,GETDATE() AS ModifyDate,Remark1,FactType,@UserId
	FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId
	
	INSERT INTO Promotion.PRO_POLICY_FACTOR_RELATION_UI(PolicyFactorId,ConditionPolicyFactorId,CurrUser)
	SELECT B.PolicyFactorId,B.ConditionPolicyFactorId,@UserId
	FROM Promotion.PRO_POLICY_FACTOR A,Promotion.PRO_POLICY_FACTOR_RELATION B
	WHERE A.PolicyFactorId = B.PolicyFactorId AND A.PolicyId = @PolicyId
	
	INSERT INTO Promotion.PRO_POLICY_FACTOR_CONDITION_UI(PolicyFactorConditionId,PolicyFactorId,ConditionId,OperTag,ConditionValue,CurrUser)
	SELECT B.PolicyFactorConditionId,B.PolicyFactorId,B.ConditionId,B.OperTag,B.ConditionValue,@UserId
	FROM Promotion.PRO_POLICY_FACTOR A,Promotion.PRO_POLICY_FACTOR_CONDITION B
	WHERE A.PolicyFactorId = B.PolicyFactorId AND A.PolicyId = @PolicyId

	INSERT INTO Promotion.Pro_Hospital_PrdSalesTaget_UI(
		PolicyFactorId,DealerId,HospitalId,Period,TargetLevel,TargetValue,CreateBy,CreateTime,CurrUser)
	SELECT b.PolicyFactorId,b.DealerId,b.HospitalId,b.Period,b.TargetLevel,b.TargetValue,@UserId AS CreateBy,GETDATE() AS CreateTime,@UserId
	FROM Promotion.PRO_POLICY_FACTOR a,Promotion.Pro_Hospital_PrdSalesTaget b
	WHERE a.PolicyFactorId = b.PolicyFactorId AND a.PolicyId = @PolicyId
	
	INSERT INTO Promotion.Pro_Dealer_PrdPurchase_Taget_UI(
		PolicyFactorId,DealerId,Period,TargetLevel,TargetValue,CreateBy,CreateTime,CurrUser)
	SELECT B.PolicyFactorId,B.DealerId,B.Period,B.TargetLevel,B.TargetValue,@UserId AS CreateBy,GETDATE() AS CreateTime,@UserId
	FROM Promotion.PRO_POLICY_FACTOR a,Promotion.Pro_Dealer_PrdPurchase_Taget b
	WHERE a.PolicyFactorId = b.PolicyFactorId AND a.PolicyId = @PolicyId
	
	INSERT INTO Promotion.PRO_POLICY_RULE_UI(
	RuleId,PolicyId,RuleDesc,JudgePolicyFactorId,JudgeValue,GiftValue,PointsValue,PointsType,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,CurrUser)
	SELECT RuleId,
	@NewPolicyId AS PolicyId,
	RuleDesc,JudgePolicyFactorId,JudgeValue,GiftValue,PointsValue,PointsType,
	@UserId AS CreateBy,GETDATE() AS CreateTime,@UserId AS ModifyBy,GETDATE() AS ModifyDate,Remark1,@UserId
	FROM Promotion.PRO_POLICY_RULE WHERE PolicyId = @PolicyId

	INSERT INTO Promotion.PRO_POLICY_RULE_FACTOR_UI(
		RuleFactorId,RuleId,PolicyFactorId,LogicType,LogicSymbol,AbsoluteValue1,AbsoluteValue2,RelativeValue1,RelativeValue2,
		OtherPolicyFactorIdRatio,OtherPolicyFactorId,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,CurrUser)
	SELECT B.RuleFactorId,B.RuleId,B.PolicyFactorId,B.LogicType,B.LogicSymbol,B.AbsoluteValue1,B.AbsoluteValue2,B.RelativeValue1,B.RelativeValue2,
		B.OtherPolicyFactorIdRatio,B.OtherPolicyFactorId,@UserId AS CreateBy,GETDATE() AS CreateTime,@UserId AS ModifyBy,GETDATE() AS ModifyDate,B.Remark1,@UserId
	FROM Promotion.PRO_POLICY_RULE A,Promotion.PRO_POLICY_RULE_FACTOR B 
	WHERE A.PolicyId = @PolicyId AND A.RuleId = B.RuleId

	INSERT INTO Promotion.PRO_POLICY_LARGESS_UI(
	PolicyId,GiftType,GiftPolicyFactorId,PointsValue,UseRangePolicyFactorId,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,CurrUser)
	SELECT @NewPolicyId AS PolicyId,
	GiftType,GiftPolicyFactorId,PointsValue,UseRangePolicyFactorId,
	@UserId AS CreateBy,GETDATE() AS CreateTime,@UserId AS ModifyBy,GETDATE() AS ModifyDate,Remark1,@UserId
	FROM Promotion.PRO_POLICY_LARGESS WHERE PolicyId = @PolicyId
	
	INSERT INTO Promotion.PRO_POLICY_TOPVALUE_UI(
	PolicyId,DealerId,HospitalId,Period,TopValue,CreateBy,CreateTime,CurrUser)
	SELECT @NewPolicyId AS PolicyId,
	DealerId,HospitalId,Period,TopValue,
	@UserId AS CreateBy,GETDATE() AS CreateTime,@UserId
	FROM Promotion.PRO_POLICY_TOPVALUE WHERE PolicyId = @PolicyId
	
	INSERT INTO Promotion.Pro_Dealer_Std_Point_UI(PolicyId,DealerId,Points,CreateBy,CreateTime,CurrUser)
	SELECT @NewPolicyId AS PolicyId,
	DealerId,Points,
	@UserId AS CreateBy,GETDATE() AS CreateTime,@UserId
	FROM Promotion.Pro_Dealer_Std_Point WHERE PolicyId = @PolicyId
	
	INSERT INTO Promotion.PRO_POLICY_POINTRATIO_UI(PolicyId,AccountMonth,DealerId,Ratio,Remark1,CreateBy,CreateTime,ModifyBy,ModifyDate,CurrUser)
	SELECT @NewPolicyId AS PolicyId,
	AccountMonth,DealerId,Ratio,Remark1,
	@UserId AS CreateBy,GETDATE() AS CreateTime,@UserId AS ModifyBy,GETDATE() AS ModifyDate,@UserId
	FROM Promotion.PRO_POLICY_POINTRATIO WHERE PolicyId = @PolicyId
	
	EXEC PROMOTION.Proc_Interface_PolicySave @UserId,'SaveDraft',@Result OUTPUT
	
	SET @Result = 'Success'  
	COMMIT TRAN
END TRY
BEGIN CATCH
    ROLLBACK TRAN
    SET @Result = 'Failed'
    
    DECLARE @error_number INT
    DECLARE @error_serverity INT
    DECLARE @error_state INT
    DECLARE @error_message NVARCHAR(256)
    DECLARE @error_line INT
    DECLARE @error_procedure NVARCHAR(256)
    DECLARE @vError NVARCHAR(1000)
    SET @error_number = ERROR_NUMBER()
    SET @error_serverity = ERROR_SEVERITY()
    SET @error_state = ERROR_STATE()
    SET @error_message = ERROR_MESSAGE()
    SET @error_line = ERROR_LINE()
    SET @error_procedure = ERROR_PROCEDURE()
    SET @vError = ISNULL(@error_procedure, '') + '第'
        + CONVERT(NVARCHAR(10), ISNULL(@error_line, '')) + '行出错[错误号：'
        + CONVERT(NVARCHAR(10), ISNULL(@error_number, '')) + ']，'
        + ISNULL(@error_message, '')
    
    PRINT @vError
    
END CATCH

GO


