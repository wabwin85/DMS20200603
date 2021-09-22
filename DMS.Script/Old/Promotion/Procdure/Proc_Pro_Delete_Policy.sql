DROP PROCEDURE [Promotion].[Proc_Pro_Delete_Policy]
GO



/**********************************************
	功能：删除1个政策的所有内容（包括计算表）
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Delete_Policy] 
	@PolicyId INT
AS
BEGIN 
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @TableName NVARCHAR(50)
	
	SET @TableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'REP')
	IF OBJECT_ID (@TableName) IS NOT NULL
	BEGIN
		SET @SQL = 'DROP TABLE '+@TableName
		EXEC (@SQL)
	END
	
	SET @TableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'REP') +'_HIS'
	IF OBJECT_ID (@TableName) IS NOT NULL
	BEGIN
		SET @SQL = 'DROP TABLE '+@TableName
		EXEC (@SQL)
	END
	
	SET @TableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'TMP')
	IF OBJECT_ID (@TableName) IS NOT NULL
	BEGIN
		SET @SQL = 'DROP TABLE '+@TableName
		EXEC (@SQL)
	END
	
	SET @TableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'CAL')
	IF OBJECT_ID (@TableName) IS NOT NULL
	BEGIN
		SET @SQL = 'DROP TABLE '+@TableName
		EXEC (@SQL)
	END
	
	PRINT 'Msg:4张计算表已删除！'
	

	DELETE a FROM Promotion.PRO_DEALER a WHERE a.PolicyId = @PolicyId
	PRINT 'Msg:Promotion.PRO_DEALER '+CONVERT(NVARCHAR,@@ROWCOUNT)+' rows Deleted!'
	
	DELETE b
	FROM Promotion.PRO_POLICY_FACTOR a,Promotion.Pro_Hospital_PrdSalesTaget b
	WHERE a.PolicyFactorId = b.PolicyFactorId AND a.PolicyId = @PolicyId
	PRINT 'Msg:Promotion.PRO_HOSPITAL_PRDSALESTAGET '+CONVERT(NVARCHAR,@@ROWCOUNT)+' rows Deleted!'
	
	DELETE b
	FROM Promotion.PRO_POLICY_FACTOR a,Promotion.Pro_Dealer_PrdPurchase_Taget b
	WHERE a.PolicyFactorId = b.PolicyFactorId AND a.PolicyId = @PolicyId
	PRINT 'Msg:Promotion.PRO_DEALER_PRDPURCHASE_TAGET '+CONVERT(NVARCHAR,@@ROWCOUNT)+' rows Deleted!'
	
	DELETE b
	FROM Promotion.PRO_POLICY_FACTOR a,Promotion.PRO_POLICY_FACTOR_CONDITION b
	WHERE a.PolicyFactorId = b.PolicyFactorId AND a.PolicyId = @PolicyId
	PRINT 'Msg:Promotion.PRO_POLICY_FACTOR_CONDITION '+CONVERT(NVARCHAR,@@ROWCOUNT)+' rows Deleted!'
	
	DELETE b
	FROM Promotion.PRO_POLICY_FACTOR a,Promotion.PRO_POLICY_FACTOR_RELATION b
	WHERE a.PolicyFactorId = b.PolicyFactorId AND a.PolicyId = @PolicyId
	PRINT 'Msg:Promotion.PRO_POLICY_FACTOR_RELATION '+CONVERT(NVARCHAR,@@ROWCOUNT)+' rows Deleted!'
	
	DELETE A 
	FROM Promotion.PRO_POLICY_RULE_FACTOR A,Promotion.PRO_POLICY_RULE B
	WHERE A.RuleId = B.RuleId AND B.PolicyId = @PolicyId
	PRINT 'Msg:Promotion.PRO_POLICY_RULE_FACTOR '+CONVERT(NVARCHAR,@@ROWCOUNT)+' rows Deleted!'
	
	DELETE A FROM Promotion.PRO_POLICY_RULE A WHERE a.PolicyId = @PolicyId
	PRINT 'Msg:Promotion.PRO_POLICY_RULE '+CONVERT(NVARCHAR,@@ROWCOUNT)+' rows Deleted!'
	
	DELETE A FROM Promotion.PRO_PREPRICE A WHERE a.PolicyId = @PolicyId
	PRINT 'Msg:Promotion.PRO_PREPRICE '+CONVERT(NVARCHAR,@@ROWCOUNT)+' rows Deleted!'
	
	DELETE A FROM Promotion.PRO_POLICY_TOPVALUE A WHERE a.PolicyId = @PolicyId
	PRINT 'Msg:Promotion.PRO_POLICY_TOPVALUE '+CONVERT(NVARCHAR,@@ROWCOUNT)+' rows Deleted!'
	
	DELETE A FROM Promotion.PRO_POLICY_FACTOR A WHERE a.PolicyId = @PolicyId
	PRINT 'Msg:Promotion.PRO_POLICY_FACTOR '+CONVERT(NVARCHAR,@@ROWCOUNT)+' rows Deleted!'
	
	DELETE A FROM Promotion.PRO_POLICY_LARGESS A WHERE a.PolicyId = @PolicyId
	PRINT 'Msg:Promotion.PRO_POLICY_LARGESS '+CONVERT(NVARCHAR,@@ROWCOUNT)+' rows Deleted!'
	
	DELETE A FROM Promotion.PRO_POLICY A WHERE a.PolicyId = @PolicyId
	PRINT 'Msg:Promotion.PRO_POLICY '+CONVERT(NVARCHAR,@@ROWCOUNT)+' rows Deleted!'
	
	PRINT 'Msg:PolicyId='+CONVERT(NVARCHAR,@PolicyId)+'的数据已删除！'
	
END


GO


