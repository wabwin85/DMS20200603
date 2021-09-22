DROP PROCEDURE [Promotion].[Proc_Interface_PolicyTempLoad] 
GO


/**********************************************
	功能：将政策LOAD进TEMP表
	作者：GrapeCity
	最后更新时间：	2015-11-01
	更新记录说明：
	1.创建 2015-11-01
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_PolicyTempLoad] 
	@PolicyId INT,
	@PolicyType NVARCHAR(50),
	@PolicyTypeSub NVARCHAR(50),
	@UserId NVARCHAR(50),
	@IsTemplate BIT,
	@PolicyMode NVARCHAR(10),
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
	
	--PRO_POLICY主表
	IF @PolicyId IS NULL
	BEGIN		
		INSERT INTO Promotion.PRO_POLICY(STATUS,CreateBy,CreateTime,PolicyStyle,PolicySubStyle,IsTemplate,PolicyMode) SELECT '草稿',@UserId,GETDATE(),@PolicyType,@PolicyTypeSub,@IsTemplate,@PolicyMode
		
		SET @PolicyId = SCOPE_IDENTITY()
		
		INSERT INTO Promotion.PRO_POLICY_UI(PolicyId,STATUS,CreateBy,CreateTime,ModifyBy,ModifyDate,CurrUser,PolicyStyle,PolicySubStyle)
		SELECT @PolicyId,'草稿',@UserId,GETDATE(),@UserId,GETDATE(),@UserId,@PolicyType,@PolicyTypeSub
	END
	ELSE
	BEGIN
		INSERT INTO Promotion.PRO_POLICY_UI(PolicyId,PolicyNo,PolicyName,Description,Period,
			StartDate,
			EndDate,
			BU,TopType,TopValue,CalType,IsPrePrice,PrePriceValue,Status,ReportTableName,TempTableName,PreTableName,CurrentPeriod,ApproveStatus,PolicyType,ifConvert,ifMinusLastGift,ifAddLastLeft,ifCalPurchaseAR,ifCalSalesAR,CalModule,CalStatus,CalPeriod,StartTime,EndTime,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,Remark2,Remark3,SubBu,CarryType,ifIncrement,PolicyGroupName,PolicyClass,ifCalRebateAR,CurrUser,
			PointValidDateType,PointValidDateDuration,PointValidDateAbsolute,PointValidDateType2,PointValidDateDuration2,PointValidDateAbsolute2,PolicyStyle,PolicySubStyle,PointUseRange,MJRatio,YTDOption)
		SELECT 
			PolicyId,PolicyNo,PolicyName,Description,Period,
			--CONVERT(NVARCHAR(10),CONVERT(DATETIME,StartDate+'01'),121) StartDate,
			--CONVERT(NVARCHAR(10),DATEADD(M,1,CONVERT(DATETIME,EndDate+'01'))-1,121) EndDate,
			StartDate,
			EndDate,
			BU,TopType,TopValue,CalType,IsPrePrice,PrePriceValue,Status,ReportTableName,TempTableName,PreTableName,CurrentPeriod,ApproveStatus,PolicyType,ifConvert,ifMinusLastGift,ifAddLastLeft,ifCalPurchaseAR,ifCalSalesAR,CalModule,CalStatus,CalPeriod,StartTime,EndTime,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,Remark2,Remark3,SubBu,CarryType,ifIncrement,PolicyGroupName,PolicyClass,ifCalRebateAR,@UserId,
			PointValidDateType,PointValidDateDuration,PointValidDateAbsolute,
			PointValidDateType2,PointValidDateDuration2,PointValidDateAbsolute2,
			PolicyStyle,PolicySubStyle,PointUseRange,MJRatio,YTDOption
		FROM Promotion.PRO_POLICY WHERE PolicyId = @PolicyId 
	END
	
	INSERT INTO Promotion.PRO_DEALER_UI(PolicyId,WithType,OperType,DEALERID,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,CurrUser)
	SELECT PolicyId,WithType,OperType,DEALERID,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,@UserId
	FROM Promotion.PRO_DEALER WHERE PolicyId = @PolicyId

	INSERT INTO Promotion.PRO_POLICY_FACTOR_UI(PolicyFactorId,PolicyId,FactId,FactDesc,DataType,FactValue,
		CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,FactType,CurrUser)
	SELECT PolicyFactorId,PolicyId,FactId,FactDesc,DataType,FactValue,
		CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,FactType,@UserId
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
	SELECT b.PolicyFactorId,b.DealerId,b.HospitalId,b.Period,b.TargetLevel,b.TargetValue,b.CreateBy,b.CreateTime,@UserId
	FROM Promotion.PRO_POLICY_FACTOR a,Promotion.Pro_Hospital_PrdSalesTaget b
	WHERE a.PolicyFactorId = b.PolicyFactorId AND a.PolicyId = @PolicyId
	
	INSERT INTO Promotion.Pro_Dealer_PrdPurchase_Taget_UI(
		PolicyFactorId,DealerId,Period,TargetLevel,TargetValue,CreateBy,CreateTime,CurrUser)
	SELECT B.PolicyFactorId,B.DealerId,B.Period,B.TargetLevel,B.TargetValue,B.CreateBy,B.CreateTime,@UserId
	FROM Promotion.PRO_POLICY_FACTOR a,Promotion.Pro_Dealer_PrdPurchase_Taget b
	WHERE a.PolicyFactorId = b.PolicyFactorId AND a.PolicyId = @PolicyId
	
	INSERT INTO Promotion.PRO_POLICY_RULE_UI(
	RuleId,PolicyId,RuleDesc,JudgePolicyFactorId,JudgeValue,GiftValue,PointsValue,PointsType,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,CurrUser)
	SELECT RuleId,PolicyId,RuleDesc,JudgePolicyFactorId,JudgeValue,GiftValue,PointsValue,PointsType,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,@UserId
	FROM Promotion.PRO_POLICY_RULE WHERE PolicyId = @PolicyId

	INSERT INTO Promotion.PRO_POLICY_RULE_FACTOR_UI(
		RuleFactorId,RuleId,PolicyFactorId,LogicType,LogicSymbol,AbsoluteValue1,AbsoluteValue2,RelativeValue1,RelativeValue2,
		OtherPolicyFactorIdRatio,OtherPolicyFactorId,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,CurrUser)
	SELECT B.RuleFactorId,B.RuleId,B.PolicyFactorId,B.LogicType,B.LogicSymbol,B.AbsoluteValue1,B.AbsoluteValue2,B.RelativeValue1,B.RelativeValue2,
		B.OtherPolicyFactorIdRatio,B.OtherPolicyFactorId,B.CreateBy,B.CreateTime,B.ModifyBy,B.ModifyDate,B.Remark1,@UserId
	FROM Promotion.PRO_POLICY_RULE A,Promotion.PRO_POLICY_RULE_FACTOR B 
	WHERE A.PolicyId = @PolicyId AND A.RuleId = B.RuleId

	INSERT INTO Promotion.PRO_POLICY_LARGESS_UI(
	PolicyId,GiftType,GiftPolicyFactorId,PointsValue,UseRangePolicyFactorId,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,CurrUser)
	SELECT PolicyId,GiftType,GiftPolicyFactorId,PointsValue,UseRangePolicyFactorId,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,@UserId
	FROM Promotion.PRO_POLICY_LARGESS WHERE PolicyId = @PolicyId
	
	INSERT INTO Promotion.PRO_POLICY_TOPVALUE_UI(
	PolicyId,DealerId,HospitalId,Period,TopValue,CreateBy,CreateTime,CurrUser)
	SELECT PolicyId,DealerId,HospitalId,Period,TopValue,CreateBy,CreateTime,@UserId
	FROM Promotion.PRO_POLICY_TOPVALUE WHERE PolicyId = @PolicyId
	
	INSERT INTO Promotion.Pro_Dealer_Std_Point_UI(
	PolicyId,DealerId,Points,CreateBy,CreateTime,CurrUser)
	SELECT PolicyId,DealerId,Points,CreateBy,CreateTime,@UserId
	FROM Promotion.Pro_Dealer_Std_Point WHERE PolicyId = @PolicyId
	
	INSERT INTO Promotion.PRO_POLICY_POINTRATIO_UI(
	PolicyId,AccountMonth,DealerId,Ratio,Remark1,CreateBy,CreateTime,ModifyBy,ModifyDate,CurrUser)
	SELECT PolicyId,AccountMonth,DealerId,Ratio,Remark1,CreateBy,CreateTime,ModifyBy,ModifyDate,@UserId
	FROM Promotion.PRO_POLICY_POINTRATIO WHERE PolicyId = @PolicyId
	
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


