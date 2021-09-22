DROP FUNCTION [Promotion].[func_Interface_FactorConditionSeleted_String]
GO


/**********************************************
 ����:��ȡ������ѡԼ������
 ���ߣ�Grapecity
 ������ʱ�䣺 2015-11-23
 ���¼�¼˵����
 1.���� 2015-11-23
**********************************************/
CREATE FUNCTION [Promotion].[func_Interface_FactorConditionSeleted_String](
	@PolicyFactorConditionId NVARCHAR(10),@CurrUser NVARCHAR(36)
	)
RETURNS @temp TABLE
	(
		Code nvarchar(50)
	)
AS
BEGIN
	DECLARE @ConditionValue NVARCHAR(MAX)
	DECLARE @PolicyFactorId INT
	DECLARE @FactConditionId INT
	SELECT @PolicyFactorId=PolicyFactorId,@FactConditionId=ConditionId,@ConditionValue=ISNULL(ConditionValue,'') FROM Promotion.PRO_POLICY_FACTOR_CONDITION_UI A WHERE A.PolicyFactorConditionId=@PolicyFactorConditionId AND A.CurrUser=@CurrUser
	--UPN
	IF @FactConditionId=1
	BEGIN
		INSERT INTO @temp
		SELECT A.CFN_CustomerFaceNbr RESULT 
							  FROM CFN A WHERE A.CFN_Property4 IN ('0','1') 
									AND  EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColA=A.CFN_CustomerFaceNbr)
	END
	--��װ
	IF @FactConditionId=2
	BEGIN
		INSERT INTO @temp
		SELECT CONVERT(NVARCHAR(10),A.BundleId) RESULT 
							 FROM Promotion.Pro_Bundle_Setting A 
							WHERE  EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColA=CONVERT(NVARCHAR(10),A.BundleId))
	END
	--��Ʒ��
	IF @FactConditionId=3
	BEGIN
		INSERT INTO @temp
		SELECT  Code RESULT   FROM(
			SELECT DISTINCT ('LEVEL1,'+ A.CFN_Level1Code) AS Code,A.CFN_Level1Desc+'(LEVEL1,'+ A.CFN_Level1Code+')' AS NAME FROM CFN A 
			WHERE  EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level1Code AND b.ColA='Level1')
			UNION
			SELECT DISTINCT ('LEVEL2,'+ A.CFN_Level2Code),A.CFN_Level2Desc+'(LEVEL2,'+ A.CFN_Level2Code+')' FROM CFN A 
			WHERE  EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level2Code AND b.ColA='Level2')
			UNION
			SELECT DISTINCT ('LEVEL3,'+ A.CFN_Level3Code),A.CFN_Level3Desc+'(LEVEL3,'+ A.CFN_Level3Code+')' FROM CFN A 
			WHERE EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level3Code AND b.ColA='Level3')
			UNION
			SELECT DISTINCT ('LEVEL4,'+ A.CFN_Level4Code),A.CFN_Level4Desc+'(LEVEL4,'+ A.CFN_Level4Code+')' FROM CFN A 
			WHERE  EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level4Code AND b.ColA='Level4')
			UNION
			SELECT DISTINCT ('LEVEL5,'+ A.CFN_Level5Code),A.CFN_Level5Desc+'(LEVEL5,'+ A.CFN_Level5Code+')' FROM CFN A 
			WHERE  EXISTS(SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColB=A.CFN_Level5Code AND b.ColA='Level5')
		) A
	END
	--ҽԺ
	IF @FactConditionId=4
	BEGIN
		INSERT INTO @temp
		SELECT A.HOS_Key_Account RESULT 
			FROM Hospital A WHERE  EXISTS (SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColA=A.HOS_Key_Account)
	END
	--ʡ��
	IF @FactConditionId=5
	BEGIN
		INSERT INTO @temp
		SELECT A.TER_Description RESULT 
			FROM Territory A WHERE A.TER_Type='Province'
			AND EXISTS (SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColA=A.TER_Description)
	END
	--����
	IF @FactConditionId=6
	BEGIN
		INSERT INTO @temp
		SELECT A.TER_Description RESULT 
			FROM Territory A WHERE A.TER_Type='City'
			AND EXISTS (SELECT 1 FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B WHERE B.ColA=A.TER_Description)
	END
	--������
	IF @FactConditionId=7
	BEGIN
		INSERT INTO @temp
		SELECT ''
	END
	--�ɹ���ʽ
	--IF @FactConditionId=8
	--BEGIN
	--	INSERT INTO @temp(Id,Name) SELECT '����|','����' WHERE '����' IN (SELECT B.ColA FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B) ;
	--	INSERT INTO @temp(Id,Name) SELECT '����|','����' WHERE '����' IN (SELECT B.ColA FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B) ;
	--END
	----����
	--IF @FactConditionId=9
	--BEGIN
	--	INSERT INTO @temp(Id,Name) SELECT '�캣|','�캣' WHERE '�캣' IN (SELECT B.ColA FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B) ;
	--	INSERT INTO @temp(Id,Name) SELECT '����|','����' WHERE '����' IN (SELECT B.ColA FROM Promotion.func_Pro_Utility_getStringSplit(@ConditionValue) B) ;
	--END
	RETURN
END


GO


