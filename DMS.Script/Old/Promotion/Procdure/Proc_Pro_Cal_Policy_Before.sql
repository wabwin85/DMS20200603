DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_Before] 
GO


/**********************************************
	���ܣ������������߼������֮ǰ�����⴦��
	�ڴ˴洢�����У��������������Ƕ�׸���SP.
	���ߣ�GrapeCity
	������ʱ�䣺	2015-08-31
	���¼�¼˵����
	1.���� 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_Before] 
	@PolicyId INT
AS
BEGIN  

--***********START:�������п۳������ߵ�������Ʒ****************************************************************
	--EXEC PROMOTION.Proc_Pro_Cal_Policy_Before_1 ������ID,������ID
	
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
	
	
--***********END:�������п۳������ߵ�������Ʒ****************************************************************

 	RETURN
END  

GO


