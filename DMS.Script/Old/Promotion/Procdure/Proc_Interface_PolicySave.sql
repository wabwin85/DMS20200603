DROP PROCEDURE [Promotion].[Proc_Interface_PolicySave] 
GO

/**********************************************
	功能：将政策保存到正式表
	作者：GrapeCity
	最后更新时间：	2015-11-07
	更新记录说明：
	1.创建 2015-11-07
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_PolicySave] 
	@UserId NVARCHAR(50),
	@Command NVARCHAR(20),
	@Result  nvarchar(20) = 'Failed' output 
AS
BEGIN TRY
	
	DECLARE @STATUS NVARCHAR(20)
	DECLARE @POLICYID INT
	
	SELECT @POLICYID = A.POLICYID,@STATUS = A.STATUS 
	FROM Promotion.PRO_POLICY A,Promotion.PRO_POLICY_UI B WHERE A.POLICYID = B.POLICYID AND B.CurrUser = @UserId
	
	IF @POLICYID IS NULL
	BEGIN
		SET @Result ='Failed No PolicyId'
		RETURN 
	END
	
	--BEGIN TRAN
	
	--如果是提交审批，先进行备份
	IF @Command = 'Submit'
	BEGIN
		EXEC PROMOTION.Proc_Interface_PolicyBackup @POLICYID,@UserId
	END
	
	
	--删除正式数据
	DELETE FROM Promotion.PRO_DEALER WHERE POLICYID = @POLICYID

	DELETE FROM Promotion.PRO_POLICY_FACTOR_CONDITION 
		WHERE PolicyFactorId IN (SELECT PolicyFactorId FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId)
		
	DELETE FROM Promotion.Pro_Hospital_PrdSalesTaget 
		WHERE PolicyFactorId IN (SELECT PolicyFactorId FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId)	
	
	DELETE FROM Promotion.Pro_Dealer_PrdPurchase_Taget 
		WHERE PolicyFactorId IN (SELECT PolicyFactorId FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId)
	
	DELETE FROM Promotion.Pro_Dealer_Std_Point WHERE PolicyId = @PolicyId
	
	DELETE FROM Promotion.PRO_POLICY_POINTRATIO WHERE PolicyId = @PolicyId
	
	IF @STATUS = '草稿'
	BEGIN
		DELETE FROM Promotion.PRO_POLICY_TOPVALUE WHERE POLICYID = @PolicyId
		
		DELETE FROM Promotion.PRO_POLICY_LARGESS WHERE POLICYID = @PolicyId
		
		DELETE FROM Promotion.PRO_POLICY_FACTOR_RELATION 
		WHERE PolicyFactorId IN (SELECT PolicyFactorId FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId)
		
		DELETE FROM Promotion.PRO_POLICY_RULE_FACTOR WHERE RULEID IN (SELECT RULEID FROM Promotion.PRO_POLICY_RULE WHERE POLICYID = @PolicyId)
		
		DELETE FROM Promotion.PRO_POLICY_RULE WHERE POLICYID = @POLICYID
		
		DELETE FROM Promotion.PRO_POLICY_FACTOR WHERE POLICYID = @POLICYID	
	END
	
	--表1：PRO_POLICY*************************************************************************************************
	--只有草稿才会更新，正式数据只能更新有限字段。
	IF @STATUS = '草稿'
	BEGIN
		UPDATE A SET PolicyNo = 'P_'+B.BU+'_'+RIGHT('0000'+CONVERT(NVARCHAR,A.PolicyId),4),
			PolicyName = b.PolicyName,
			Description = b.Description,
			Period = b.Period,
			--StartDate = CONVERT(NVARCHAR(6),CONVERT(DATETIME,B.StartDate),112),
			--EndDate = CONVERT(NVARCHAR(6),CONVERT(DATETIME,B.EndDate),112),
			StartDate = B.StartDate,
			EndDate = B.EndDate,
			BU = b.BU,
			TopType = B.TopType,
			TopValue = b.TopValue,
			CalType = b.CalType,
			IsPrePrice = b.IsPrePrice,
			PrePriceValue = b.PrePriceValue,
			Status = b.Status,
			ReportTableName = b.ReportTableName,
			TempTableName = b.TempTableName,
			PreTableName = b.PreTableName,
			CurrentPeriod = b.CurrentPeriod,
			ApproveStatus = b.ApproveStatus,
			PolicyType = b.PolicyType,
			ifConvert = b.ifConvert,
			ifMinusLastGift = b.ifMinusLastGift,
			ifAddLastLeft = b.ifAddLastLeft,
			ifCalPurchaseAR = b.ifCalPurchaseAR,
			ifCalSalesAR = b.ifCalSalesAR,
			CalModule = b.CalModule,
			CalStatus = b.CalStatus,
			CalPeriod = b.CalPeriod,
			StartTime = b.StartTime,
			EndTime = b.EndTime,
			CreateBy = b.CreateBy,
			CreateTime = b.CreateTime,
			ModifyBy = b.ModifyBy,
			ModifyDate = b.ModifyDate,
			Remark1 = b.Remark1,
			Remark2 = b.Remark2,
			Remark3 = b.Remark3,
			SubBu = b.SubBu,
			CarryType = b.CarryType,
			ifIncrement = b.ifIncrement,
			PolicyGroupName = b.PolicyGroupName,
			PolicyClass = b.PolicyClass,
			ifCalRebateAR=b.ifCalRebateAR,
			PointValidDateType = B.PointValidDateType,
			PointValidDateDuration = B.PointValidDateDuration,
			PointValidDateAbsolute = B.PointValidDateAbsolute,
			PointValidDateType2 = B.PointValidDateType2,
			PointValidDateDuration2 = B.PointValidDateDuration2,
			PointValidDateAbsolute2 = B.PointValidDateAbsolute2,
			PolicyStyle = B.PolicyStyle,
			PolicySubStyle = B.PolicySubStyle,
			PointUseRange = B.PointUseRange,
			YTDOption=B.YTDOption,
			MJRatio = b.MJRatio
		FROM Promotion.PRO_POLICY A,Promotion.PRO_POLICY_UI B
		WHERE A.PolicyId = B.PolicyId AND B.CurrUser = @UserId
	END
	ELSE
	BEGIN
		--正式政策只能更新政策名称等
		UPDATE A SET 
			PolicyName = b.PolicyName,
			Description = b.Description,
			PolicyGroupName = b.PolicyGroupName
		FROM Promotion.PRO_POLICY A,Promotion.PRO_POLICY_UI B
		WHERE A.PolicyId = B.PolicyId AND B.CurrUser = @UserId
	END
	
	--表2：PRO_DEALER*************************************************************************************************
	INSERT INTO Promotion.PRO_DEALER(PolicyId,WithType,OperType,DEALERID,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1)
	SELECT PolicyId,WithType,OperType,DEALERID,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1
	FROM Promotion.PRO_DEALER_UI WHERE PolicyId = @PolicyId AND CurrUser = @UserId
	
	--表3：PRO_POLICY_FACTOR*************************************************************************************************
	IF @STATUS = '草稿'
	BEGIN
		INSERT INTO Promotion.PRO_POLICY_FACTOR(PolicyId,FactId,FactDesc,DataType,FactValue,
			CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,FactType)
		SELECT PolicyId,FactId,FactDesc,DataType,FactValue,
			CreateBy,CreateTime,ModifyBy,ModifyDate,
			PolicyFactorId AS Remark1, --后续利用此字段做关联
			FactType
		FROM Promotion.PRO_POLICY_FACTOR_UI WHERE PolicyId = @PolicyId AND CurrUser = @UserId
	END
	ELSE
	BEGIN
		PRINT '正式政策不会更新PRO_POLICY_FACTOR表'
	END
	
	--表4：PRO_POLICY_FACTOR_RELATION*****************************************************************************************
	IF @STATUS = '草稿'
	BEGIN
		INSERT INTO Promotion.PRO_POLICY_FACTOR_RELATION(PolicyFactorId,ConditionPolicyFactorId)
		SELECT A.PolicyFactorId,C.PolicyFactorId AS ConditionPolicyFactorId
		FROM Promotion.PRO_POLICY_FACTOR A,Promotion.PRO_POLICY_FACTOR_RELATION_UI B,Promotion.PRO_POLICY_FACTOR C 
		WHERE A.Remark1 = B.PolicyFactorId AND C.Remark1 = B.ConditionPolicyFactorId
		AND A.PolicyId = C.PolicyId 
		AND A.PolicyId = @PolicyId AND B.CurrUser = @UserId
	END
	ELSE
	BEGIN
		PRINT '正式政策不会更新PRO_POLICY_FACTOR_RELATION表'
	END
	
	--表5：PRO_POLICY_FACTOR_CONDITION*******************************************************************************
	IF @STATUS = '草稿'
	BEGIN
		INSERT INTO Promotion.PRO_POLICY_FACTOR_CONDITION(PolicyFactorId,ConditionId,OperTag,ConditionValue)
		SELECT A.PolicyFactorId,B.ConditionId,B.OperTag,B.ConditionValue
		FROM Promotion.PRO_POLICY_FACTOR A,Promotion.PRO_POLICY_FACTOR_CONDITION_UI B
		WHERE A.Remark1 = B.PolicyFactorId AND A.PolicyId = @PolicyId AND B.CurrUser = @UserId
	END
	ELSE
	BEGIN
		INSERT INTO Promotion.PRO_POLICY_FACTOR_CONDITION(PolicyFactorId,ConditionId,OperTag,ConditionValue)
		SELECT B.PolicyFactorId,B.ConditionId,B.OperTag,B.ConditionValue
		FROM Promotion.PRO_POLICY_FACTOR A,Promotion.PRO_POLICY_FACTOR_CONDITION_UI B
		WHERE A.PolicyFactorId = B.PolicyFactorId AND A.PolicyId = @PolicyId AND B.CurrUser = @UserId
	END
	
	--表6：Pro_Hospital_PrdSalesTaget**********************************************************************************
	IF @STATUS = '草稿'
	BEGIN
		INSERT INTO Promotion.Pro_Hospital_PrdSalesTaget(PolicyFactorId,DealerId,HospitalId,Period,TargetLevel,TargetValue,CreateBy,CreateTime)
		SELECT A.PolicyFactorId,B.DealerId,B.HospitalId,B.Period,B.TargetLevel,B.TargetValue,B.CreateBy,B.CreateTime
		FROM Promotion.PRO_POLICY_FACTOR A,Promotion.Pro_Hospital_PrdSalesTaget_UI B
		WHERE A.Remark1 = B.PolicyFactorId AND A.PolicyId = @PolicyId AND B.CurrUser = @UserId
	END
	ELSE
	BEGIN
		INSERT INTO Promotion.Pro_Hospital_PrdSalesTaget(
			PolicyFactorId,DealerId,HospitalId,Period,TargetLevel,TargetValue,CreateBy,CreateTime)
		SELECT b.PolicyFactorId,b.DealerId,b.HospitalId,b.Period,b.TargetLevel,b.TargetValue,b.CreateBy,b.CreateTime
		FROM Promotion.PRO_POLICY_FACTOR a,Promotion.Pro_Hospital_PrdSalesTaget_UI b
		WHERE a.PolicyFactorId = b.PolicyFactorId AND a.PolicyId = @PolicyId AND B.CurrUser = @UserId
	END
	
	--表7：Pro_Dealer_PrdPurchase_Taget_UI******************************************************************************
	IF @STATUS = '草稿'
	BEGIN
		INSERT INTO Promotion.Pro_Dealer_PrdPurchase_Taget(
			PolicyFactorId,DealerId,Period,TargetLevel,TargetValue,CreateBy,CreateTime)
		SELECT A.PolicyFactorId,B.DealerId,B.Period,B.TargetLevel,B.TargetValue,B.CreateBy,B.CreateTime
		FROM Promotion.PRO_POLICY_FACTOR a,Promotion.Pro_Dealer_PrdPurchase_Taget_UI b
		WHERE A.Remark1 = b.PolicyFactorId AND a.PolicyId = @PolicyId AND B.CurrUser = @UserId
	END
	ELSE
	BEGIN
		INSERT INTO Promotion.Pro_Dealer_PrdPurchase_Taget(
			PolicyFactorId,DealerId,Period,TargetLevel,TargetValue,CreateBy,CreateTime)
		SELECT B.PolicyFactorId,B.DealerId,B.Period,B.TargetLevel,B.TargetValue,B.CreateBy,B.CreateTime
		FROM Promotion.PRO_POLICY_FACTOR a,Promotion.Pro_Dealer_PrdPurchase_Taget_UI b
		WHERE a.PolicyFactorId = b.PolicyFactorId AND a.PolicyId = @PolicyId AND B.CurrUser = @UserId
	END
	
	--表8：PRO_POLICY_RULE*******************************************************************************************
	IF @STATUS = '草稿'
	BEGIN
		INSERT INTO Promotion.PRO_POLICY_RULE(
			PolicyId,RuleDesc,JudgePolicyFactorId,JudgeValue,GiftValue,PointsValue,PointsType,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1)
		SELECT A.PolicyId,A.RuleDesc,B.PolicyFactorId,A.JudgeValue,A.GiftValue,A.PointsValue,A.PointsType,A.CreateBy,A.CreateTime,A.ModifyBy,A.ModifyDate,
		A.RuleId AS Remark1  --后续利用此字段做关联
		FROM Promotion.PRO_POLICY_RULE_UI A 
			LEFT JOIN Promotion.PRO_POLICY_FACTOR B ON A.PolicyId = B.PolicyId AND A.JudgePolicyFactorId = B.REMARK1
		WHERE A.PolicyId = @PolicyId AND CurrUser = @UserId
	END
	ELSE
	BEGIN
		PRINT '正式政策不会更新PRO_POLICY_RULE表'
	END
	
	--表9：PRO_POLICY_RULE_FACTOR*************************************************************************************
	IF @STATUS = '草稿'
	BEGIN
		INSERT INTO Promotion.PRO_POLICY_RULE_FACTOR(
			RuleId,PolicyFactorId,LogicType,LogicSymbol,AbsoluteValue1,AbsoluteValue2,RelativeValue1,RelativeValue2,
			OtherPolicyFactorIdRatio,OtherPolicyFactorId,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1)
		SELECT A.RuleId,
					C.PolicyFactorId,
					B.LogicType,B.LogicSymbol,B.AbsoluteValue1,B.AbsoluteValue2,B.RelativeValue1,B.RelativeValue2,
					B.OtherPolicyFactorIdRatio,
					D.PolicyFactorId,
					B.CreateBy,B.CreateTime,B.ModifyBy,B.ModifyDate,B.Remark1
		FROM Promotion.PRO_POLICY_RULE A
		INNER JOIN Promotion.PRO_POLICY_RULE_FACTOR_UI B ON A.Remark1 = B.RuleId
		INNER JOIN Promotion.PRO_POLICY_FACTOR C ON A.PolicyId = C.PolicyId AND B.PolicyFactorId = C.Remark1
		LEFT JOIN Promotion.PRO_POLICY_FACTOR D ON A.PolicyId = D.PolicyId AND B.OTHERPOLICYFACTORID = D.REMARK1
		WHERE A.PolicyId = @PolicyId AND B.CurrUser = @UserId 
	END
	ELSE
	BEGIN
		PRINT '正式政策不会更新PRO_POLICY_RULE_FACTOR表'
	END
	
	
	--表10：PRO_POLICY_LARGESS*************************************************************************************************
	IF @STATUS = '草稿'
	BEGIN
		INSERT INTO Promotion.PRO_POLICY_LARGESS(
		PolicyId,GiftType,GiftPolicyFactorId,PointsValue,UseRangePolicyFactorId,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1)
		SELECT A.PolicyId,A.GiftType,
			B.PolicyFactorId,
			A.PointsValue,
			C.PolicyFactorId,
			A.CreateBy,A.CreateTime,A.ModifyBy,A.ModifyDate,A.Remark1
		FROM Promotion.PRO_POLICY_LARGESS_UI A 
		LEFT JOIN Promotion.PRO_POLICY_FACTOR B ON A.PolicyId = B.PolicyId AND A.GiftPolicyFactorId = B.REMARK1
		LEFT JOIN Promotion.PRO_POLICY_FACTOR C ON A.PolicyId = C.PolicyId AND A.UseRangePolicyFactorId = C.REMARK1
		WHERE A.PolicyId = @PolicyId AND A.CurrUser = @UserId
	END
	ELSE
	BEGIN
		PRINT '正式政策不会更新PRO_POLICY_LARGESS表'
	END
	
	--表11：PRO_POLICY_TOPVALUE*************************************************************************************************
	IF @STATUS = '草稿'
	BEGIN
		INSERT INTO Promotion.PRO_POLICY_TOPVALUE(
		PolicyId,DealerId,HospitalId,Period,TopValue,CreateBy,CreateTime)
		SELECT A.PolicyId,A.DealerId,A.HospitalId,A.Period,A.TopValue,A.CreateBy,A.CreateTime
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A,Promotion.PRO_POLICY_UI B WHERE A.POLICYID = B.POLICYID AND B.CurrUser = @UserId 
		AND A.PolicyId = @PolicyId AND A.CurrUser = @UserId
		AND B.TopType IN ('Dealer','Hospital','DealerPeriod','HospitalPeriod') --只有政策上设置了封顶类型时才放入子表
	END
	ELSE
	BEGIN
		PRINT '正式政策不会更新PRO_POLICY_TOPVALUE表'
	END
	
	--表12：Pro_Dealer_Std_Point_UI******************************************************************************
	IF @STATUS = '草稿'
	BEGIN
		INSERT INTO Promotion.Pro_Dealer_Std_Point(
			PolicyId,DealerId,Points,CreateBy,CreateTime)
		SELECT PolicyId,DealerId,Points,CreateBy,CreateTime
		FROM Promotion.Pro_Dealer_Std_Point_UI a
		WHERE a.PolicyId = @PolicyId AND a.CurrUser = @UserId
	END
	ELSE
	BEGIN
		INSERT INTO Promotion.Pro_Dealer_Std_Point(
			PolicyId,DealerId,Points,CreateBy,CreateTime)
		SELECT PolicyId,DealerId,Points,CreateBy,CreateTime
		FROM Promotion.Pro_Dealer_Std_Point_UI a
		WHERE a.PolicyId = @PolicyId AND a.CurrUser = @UserId
	END
	
	--表13：PRO_POLICY_POINTRATIO_UI******************************************************************************
	IF @STATUS = '草稿'
	BEGIN
		INSERT INTO Promotion.PRO_POLICY_POINTRATIO(
			PolicyId,AccountMonth,DealerId,Ratio,Remark1,CreateBy,CreateTime,ModifyBy,ModifyDate)
		SELECT PolicyId,AccountMonth,DealerId,Ratio,Remark1,CreateBy,CreateTime,ModifyBy,ModifyDate
		FROM Promotion.PRO_POLICY_POINTRATIO_UI a
		WHERE a.PolicyId = @PolicyId AND a.CurrUser = @UserId
	END
	ELSE
	BEGIN
		INSERT INTO Promotion.PRO_POLICY_POINTRATIO(
			PolicyId,AccountMonth,DealerId,Ratio,Remark1,CreateBy,CreateTime,ModifyBy,ModifyDate)
		SELECT PolicyId,AccountMonth,DealerId,Ratio,Remark1,CreateBy,CreateTime,ModifyBy,ModifyDate
		FROM Promotion.PRO_POLICY_POINTRATIO_UI a
		WHERE a.PolicyId = @PolicyId AND a.CurrUser = @UserId
	END
	
	IF @Command = 'SaveDraft'
	BEGIN
		UPDATE Promotion.PRO_POLICY SET STATUS = '草稿',MODIFYBY=@UserId,MODIFYDATE=GETDATE() WHERE PolicyId = @PolicyId
	END
	
	IF @Command = 'Submit'
	BEGIN
		UPDATE Promotion.PRO_POLICY SET STATUS = '审批中',MODIFYBY=@UserId,MODIFYDATE=GETDATE() WHERE PolicyId = @PolicyId
	END
	
	SET @Result = 'Success'  
	--COMMIT TRAN
	
END TRY
BEGIN CATCH
    --ROLLBACK TRAN
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


