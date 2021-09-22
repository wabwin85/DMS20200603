DROP PROCEDURE [Promotion].[Proc_Interface_PolicyBackup] 
GO

CREATE PROCEDURE [Promotion].[Proc_Interface_PolicyBackup] 
	@PolicyId INT,
	@UserId NVARCHAR(50)
AS
BEGIN 
	  DECLARE @BKID INT
	  
		INSERT INTO Promotion.PRO_POLICY_HIS(PolicyId,PolicyNo,PolicyName,Description,Period,StartDate,EndDate,BU,TopType,TopValue,CalType,IsPrePrice,PrePriceValue,Status,ReportTableName,TempTableName,PreTableName,CurrentPeriod,ApproveStatus,PolicyType,ifConvert,ifMinusLastGift,ifAddLastLeft,ifCalPurchaseAR,ifCalSalesAR,CalModule,CalStatus,CalPeriod,StartTime,EndTime,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,Remark2,Remark3,SubBu,CarryType,ifIncrement,PolicyGroupName,PolicyClass,BKUser,BKDate,ifCalRebateAR,PointValidDateType,PointValidDateDuration,PointValidDateAbsolute,PolicyStyle,PolicySubStyle,PointUseRange)
		SELECT PolicyId,PolicyNo,PolicyName,Description,Period,StartDate,EndDate,BU,TopType,TopValue,CalType,IsPrePrice,PrePriceValue,Status,ReportTableName,TempTableName,PreTableName,CurrentPeriod,ApproveStatus,PolicyType,ifConvert,ifMinusLastGift,ifAddLastLeft,ifCalPurchaseAR,ifCalSalesAR,CalModule,CalStatus,CalPeriod,StartTime,EndTime,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,Remark2,Remark3,SubBu,CarryType,ifIncrement,PolicyGroupName,PolicyClass,@UserId,GETDATE(),ifCalRebateAR,PointValidDateType,PointValidDateDuration,PointValidDateAbsolute,PolicyStyle,PolicySubStyle,PointUseRange
		FROM Promotion.PRO_POLICY WHERE PolicyId = @PolicyId 
		
		SET @BKID = SCOPE_IDENTITY()
		
		INSERT INTO Promotion.PRO_DEALER_HIS(BKID,PolicyId,WithType,OperType,DEALERID,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,BKUser,BKDate)
		SELECT @BKID,PolicyId,WithType,OperType,DEALERID,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,@UserId,GETDATE()
		FROM Promotion.PRO_DEALER WHERE PolicyId = @PolicyId
		
		INSERT INTO Promotion.PRO_POLICY_FACTOR_HIS(BKID,PolicyFactorId,PolicyId,FactId,FactDesc,DataType,FactValue,
			CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,FactType,BKUser,BKDate)
		SELECT @BKID,PolicyFactorId,PolicyId,FactId,FactDesc,DataType,FactValue,
			CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,FactType,@UserId,GETDATE()
		FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId
		
		INSERT INTO Promotion.PRO_POLICY_FACTOR_RELATION_HIS(BKID,PolicyFactorId,ConditionPolicyFactorId,BKUser,BKDate)
		SELECT @BKID,B.PolicyFactorId,B.ConditionPolicyFactorId,@UserId,GETDATE()
		FROM Promotion.PRO_POLICY_FACTOR A,Promotion.PRO_POLICY_FACTOR_RELATION B
		WHERE A.PolicyFactorId = B.PolicyFactorId AND A.PolicyId = @PolicyId
		
		INSERT INTO Promotion.PRO_POLICY_FACTOR_CONDITION_HIS(BKID,PolicyFactorConditionId,PolicyFactorId,ConditionId,OperTag,ConditionValue,BKUser,BKDate)
		SELECT @BKID,B.PolicyFactorConditionId,B.PolicyFactorId,B.ConditionId,B.OperTag,B.ConditionValue,@UserId,GETDATE()
		FROM Promotion.PRO_POLICY_FACTOR A,Promotion.PRO_POLICY_FACTOR_CONDITION B
		WHERE A.PolicyFactorId = B.PolicyFactorId AND A.PolicyId = @PolicyId
		
		INSERT INTO Promotion.Pro_Hospital_PrdSalesTaget_HIS(
			BKID,PolicyFactorId,DealerId,HospitalId,Period,TargetLevel,TargetValue,CreateBy,CreateTime,BKUser,BKDate)
		SELECT @BKID,b.PolicyFactorId,b.DealerId,b.HospitalId,b.Period,b.TargetLevel,b.TargetValue,b.CreateBy,b.CreateTime,@UserId,GETDATE()
		FROM Promotion.PRO_POLICY_FACTOR a,Promotion.Pro_Hospital_PrdSalesTaget b
		WHERE a.PolicyFactorId = b.PolicyFactorId AND a.PolicyId = @PolicyId
		
		INSERT INTO Promotion.Pro_Dealer_PrdPurchase_Taget_HIS(
			BKID,PolicyFactorId,DealerId,Period,TargetLevel,TargetValue,CreateBy,CreateTime,BKUser,BKDate)
		SELECT @BKID,B.PolicyFactorId,B.DealerId,B.Period,B.TargetLevel,B.TargetValue,B.CreateBy,B.CreateTime,@UserId,GETDATE()
		FROM Promotion.PRO_POLICY_FACTOR a,Promotion.Pro_Dealer_PrdPurchase_Taget b
		WHERE a.PolicyFactorId = b.PolicyFactorId AND a.PolicyId = @PolicyId
		
		INSERT INTO Promotion.PRO_POLICY_RULE_HIS(
		BKID,RuleId,PolicyId,RuleDesc,JudgePolicyFactorId,JudgeValue,GiftValue,PointsValue,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,BKUser,BKDate)
		SELECT @BKID,RuleId,PolicyId,RuleDesc,JudgePolicyFactorId,JudgeValue,GiftValue,PointsValue,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,@UserId,GETDATE()
		FROM Promotion.PRO_POLICY_RULE WHERE PolicyId = @PolicyId
		
		INSERT INTO Promotion.PRO_POLICY_RULE_FACTOR_HIS(
			BKID,RuleFactorId,RuleId,PolicyFactorId,LogicType,LogicSymbol,AbsoluteValue1,AbsoluteValue2,RelativeValue1,RelativeValue2,
			OtherPolicyFactorIdRatio,OtherPolicyFactorId,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,BKUser,BKDate)
		SELECT @BKID,B.RuleFactorId,B.RuleId,B.PolicyFactorId,B.LogicType,B.LogicSymbol,B.AbsoluteValue1,B.AbsoluteValue2,B.RelativeValue1,B.RelativeValue2,
			B.OtherPolicyFactorIdRatio,B.OtherPolicyFactorId,B.CreateBy,B.CreateTime,B.ModifyBy,B.ModifyDate,B.Remark1,@UserId,GETDATE()
		FROM Promotion.PRO_POLICY_RULE A,Promotion.PRO_POLICY_RULE_FACTOR B 
		WHERE A.PolicyId = @PolicyId AND A.RuleId = B.RuleId
		
		INSERT INTO Promotion.PRO_POLICY_LARGESS_HIS(
		BKID,PolicyId,GiftType,GiftPolicyFactorId,PointsValue,UseRangePolicyFactorId,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,BKUser,BKDate)
		SELECT @BKID,PolicyId,GiftType,GiftPolicyFactorId,PointsValue,UseRangePolicyFactorId,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,@UserId,GETDATE()
		FROM Promotion.PRO_POLICY_LARGESS WHERE PolicyId = @PolicyId
		
		INSERT INTO Promotion.PRO_POLICY_TOPVALUE_HIS(
		BKID,PolicyId,DealerId,HospitalId,Period,TopValue,CreateBy,CreateTime,BKUser,BKDate)
		SELECT @BKID,PolicyId,DealerId,HospitalId,Period,TopValue,CreateBy,CreateTime,@UserId,GETDATE()
		FROM Promotion.PRO_POLICY_TOPVALUE WHERE PolicyId = @PolicyId
	
END 

GO


