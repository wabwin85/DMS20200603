DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_Before] 
GO


/**********************************************
	功能：单个促销政策计算过程之前的特殊处理
	在此存储过程中，可以针对政策再嵌套各个SP.
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_Before] 
	@PolicyId INT
AS
BEGIN  

--***********START:主政策中扣除副政策的上期赠品****************************************************************
	--EXEC PROMOTION.Proc_Pro_Cal_Policy_Before_1 主政策ID,副政策ID
	
	IF @PolicyId = 115
	BEGIN
		EXEC PROMOTION.Proc_Pro_Cal_Policy_Before_1 115,123
		EXEC PROMOTION.Proc_Pro_Cal_Policy_Before_1 115,103
		
	END
	IF @PolicyId = 116
	BEGIN
		EXEC PROMOTION.Proc_Pro_Cal_Policy_Before_1 116,124
		EXEC PROMOTION.Proc_Pro_Cal_Policy_Before_1 116,104
	END
	IF @PolicyId = 147
	BEGIN
		EXEC PROMOTION.Proc_Pro_Cal_Policy_Before_1 147,123
		EXEC PROMOTION.Proc_Pro_Cal_Policy_Before_1 147,103
	END
	IF @PolicyId = 148
	BEGIN
		EXEC PROMOTION.Proc_Pro_Cal_Policy_Before_1 148,100
		EXEC PROMOTION.Proc_Pro_Cal_Policy_Before_1 148,124
		EXEC PROMOTION.Proc_Pro_Cal_Policy_Before_1 148,104
	END
	IF @PolicyId = 105
	BEGIN
		EXEC PROMOTION.Proc_Pro_Cal_Policy_Before_1 105,113
	END
	IF @PolicyId = 106
	BEGIN
		EXEC PROMOTION.Proc_Pro_Cal_Policy_Before_1 106,114
	END
	
	
--***********END:主政策中扣除副政策的上期赠品****************************************************************

 	RETURN
END  

GO


