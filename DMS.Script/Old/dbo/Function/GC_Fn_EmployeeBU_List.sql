DROP FUNCTION [dbo].[GC_Fn_EmployeeBU_List]
GO


--��Ʒ�ߣ�
--�����˲���DRM/EM��IC��CRM��EP��SH��PI��URO��Endo��PUL
--1100123�꽨ΰ/1086375 �׽�/1106000 ���/1109137 ��ҫ��/1104498 ��诣�IC��CRM
--1530985���ԣ�CRM��EP
--1062070 ������/1108613 ������/1092451 ������/1102308 ������/1115020 �����ܣ�IC��EP
--����BU��������BU��

--��ͬ���ࣺ
--�����˲���DRM��IC��CRM��EP��SH��PI��URO��Endo��PUL��ֻ��LP��SubBu����Ȩ�ޡ�
--�����˲���EM��IC��CRM��EP��SH��PI��URO��Endo��PUL���������Ե�SubBu��
--IC Rovus�Ŷ�ֻ��������ΪC1703,C1706��SubBu��
--��һ�����������Ŷ�ֻ��������ΪC1701��C1705��SubBu��
--IC �����Ŷ�ֻ��������ΪC1704��C1701��C1705��C1706��C1703��SubBu��
--1028963 ��ˬ��������ΪC1704��C1701��C1705��SubBu��

--��������������Ǹ����������жϵģ��ο�������
--select * from interface.T_I_QV_SalesRep

/**********************************************
 ����:��ȡ�����˿�ѡ��ͬ
 ���ߣ�Grapecity
 ������ʱ�䣺 2016-07-28
 ���¼�¼˵����
 1.���� 2016-07-28
**********************************************/

CREATE FUNCTION [dbo].[GC_Fn_EmployeeBU_List]
(
   @UserCode NVARCHAR(50),
   @BUType NVARCHAR(10),
   @BUCode NVARCHAR(10)
)
RETURNS @temp TABLE 
(
  Name NVARCHAR(50) NULL,
  Code  NVARCHAR(50) NULL
)
  WITH
  EXECUTE AS CALLER
AS
    BEGIN
    DECLARE @UserAccount NVARCHAR(50);
    DECLARE @UserDivision INT;
        
	SELECT @UserDivision=DepID,@UserAccount=EID FROM interface.MDM_EmployeeMaster WHERE account=@UserCode
    
    IF @BUType='BU'
      BEGIN
      
		IF (@UserCode IN ('342859_01','369307_01','442091_01','442090_01','467438_01','480579_01','514724_01'))
		BEGIN
			INSERT INTO @temp(Name,Code) 
			SELECT B.DepFullName,A.DivisionCode
			  FROM V_DivisionProductLineRelation A,interface.mdm_department B WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND NOT EXISTS (SELECT 1 FROM @temp WHERE Code=A.DivisionCode)
		END
      
      IF (EXISTS (SELECT 1 FROM   Lafite_IDENTITY_MAP T1,Lafite_ATTRIBUTE T2,Lafite_IDENTITY T3
                  WHERE  T1.MAP_ID = T2.Id AND T1.IDENTITY_ID = T3.Id AND T1.MAP_TYPE = 'Role' AND T2.ATTRIBUTE_TYPE = 'Role' AND T2.ATTRIBUTE_NAME = '��ͬ����Ա' AND T3.IDENTITY_CODE=@UserCode))
      BEGIN
        INSERT INTO @temp(Name,Code) 
        SELECT B.DepFullName,A.DivisionCode
          FROM V_DivisionProductLineRelation A,interface.mdm_department B WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND NOT EXISTS (SELECT 1 FROM @temp WHERE Code=A.DivisionCode)
      END
      ELSE
      BEGIN
        IF @UserDivision=5  --DRM
        BEGIN
			IF @UserAccount='1551560'--Canna �C URO, ENDO, PUL
			BEGIN
				INSERT INTO @temp(Name,Code) 
				SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B 
				WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND NOT EXISTS (SELECT 1 FROM @temp WHERE Code=A.DivisionCode)
				AND A.DivisionCode IN('22','18','34')
			END
			ELSE IF @UserAccount='1545195'--Qiu Birong �C PI, EM
			BEGIN
				INSERT INTO @temp(Name,Code) 
				SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B 
				WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND NOT EXISTS (SELECT 1 FROM @temp WHERE Code=A.DivisionCode)
			END
			ELSE IF @UserAccount='1556364'--��һ�� �C IC
			BEGIN
				INSERT INTO @temp(Name,Code) 
				SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B 
				WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND NOT EXISTS (SELECT 1 FROM @temp WHERE Code=A.DivisionCode)
				AND A.DivisionCode IN('17')
			END
			ELSE IF @UserAccount='1540346'--Zhu Binyan �C CRM, EP, SH
			BEGIN
				INSERT INTO @temp(Name,Code) 
				SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B 
				WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND NOT EXISTS (SELECT 1 FROM @temp WHERE Code=A.DivisionCode)
				AND A.DivisionCode IN('35','19','32')
			END
			ELSE
			BEGIN
				INSERT INTO @temp(Name,Code) 
				SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND NOT EXISTS (SELECT 1 FROM @temp WHERE Code=A.DivisionCode)
			END
        END
        IF @UserDivision=36  --EM
        BEGIN
        INSERT INTO @temp(Name,Code) 
        SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND NOT EXISTS (SELECT 1 FROM @temp WHERE Code=A.DivisionCode)
        END
        
        IF @UserAccount IN ('1100123','1086375','1106000','1109137','1104498')--1100123�꽨ΰ/1086375 �׽�/1106000 ���/1109137 ��ҫ��/1104498 ��诣�IC��CRM
        BEGIN
          DELETE @temp ;
          
          INSERT INTO @temp(Name,Code) 
          SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B 
          WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND A.DivisionCode IN ('17','19');
          
        END
        IF @UserAccount IN ('1530985')--1530985���ԣ�CRM��EP
        BEGIN
          DELETE @temp ;
          
          INSERT INTO @temp(Name,Code) 
          SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B 
          WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND A.DivisionCode IN ('19','32');
        END
        IF @UserAccount IN ('1062070','1108613','1092451','1102308','1115020')--1062070 ������/1108613 ������/1092451 ������/1102308 ������/1115020 �����ܣ�IC��EP
        BEGIN
          DELETE @temp ;
          
          INSERT INTO @temp(Name,Code) 
          SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B 
          WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND A.DivisionCode IN ('17','32');
        END
        
        IF(@UserDivision NOT IN (5,36) AND @UserAccount NOT IN ('1100123','1086375','1106000','1109137','1104498','1530985','1062070','1108613','1092451','1102308','1115020')
			AND  @UserAccount NOT IN ('1551560','1545195','1556364','1540346'))
        BEGIN
          DELETE @temp ;
          
          INSERT INTO @temp(Name,Code) 
          SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B 
          WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND A.DivisionCode =@UserDivision
        END
      END
        END
        
      IF @BUType='SubBU'
      BEGIN
      IF (@UserCode IN ('342859_01','369307_01','442091_01','442090_01','467438_01','480579_01','514724_01'))
		BEGIN
			INSERT INTO @temp(Name,Code) 
			SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
		END
      
      IF (EXISTS (SELECT 1 FROM   Lafite_IDENTITY_MAP T1,Lafite_ATTRIBUTE T2,Lafite_IDENTITY T3
                  WHERE  T1.MAP_ID = T2.Id AND T1.IDENTITY_ID = T3.Id AND T1.MAP_TYPE = 'Role' AND T2.ATTRIBUTE_TYPE = 'Role' AND T2.ATTRIBUTE_NAME = '��ͬ����Ա' AND T3.IDENTITY_CODE=@UserCode))
      BEGIN
        INSERT INTO @temp(Name,Code) 
        SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
      END
      ELSE IF (@UserAccount IN ('1551560','1556364','1540346'))
      BEGIN
        INSERT INTO @temp(Name,Code) 
        SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode AND A.CC_NameCN Not LIKE '%�����г�%' AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
      END
      ELSE IF (@UserAccount IN ('1545195')) --qiu,birong
      BEGIN
        INSERT INTO @temp(Name,Code) 
        SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode AND A.CC_NameCN LIKE '%�����г�%' AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
        
        INSERT INTO @temp(Name,Code) 
        SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division IN ('10','18','34') AND A.CC_Division=@BUCode AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
        
      END
      ELSE
        BEGIN
          IF @UserDivision=5  --DRM
          BEGIN
            INSERT INTO @temp(Name,Code) 
            SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode --AND A.CC_NameCN LIKE '%ƽ̨%' 
            AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120) AND a.CC_Division<>'38'
            
            IF @UserAccount IN ('1091746')--�߻�
            BEGIN
            INSERT INTO @temp(Name,Code) 
            SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode AND a.CC_Division='38' AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
            AND NOT EXISTS (SELECT 1 FROM @temp WHERE Code=A.CC_Code)
            END
          END
          IF @UserDivision=36  --EM
          BEGIN
            INSERT INTO @temp(Name,Code) 
            SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode AND A.CC_NameCN LIKE '%�����г�%' AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
          END
          
          IF @UserDivision=10  --PI
          BEGIN
            INSERT INTO @temp(Name,Code) 
            SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
          END
          
          IF @UserDivision<>5 AND @UserDivision<>36 AND @UserDivision<>10 AND ISNULL(@BUCode,'0')<>'17'
          BEGIN
            INSERT INTO @temp(Name,Code) 
            SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@UserDivision AND A.CC_Division=@BUCode  AND A.CC_NameCN NOT LIKE '%�����г�%' AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
          END
          
          
          IF ISNULL(@BUCode,'0')='17'
          BEGIN
            --ָ���Ŷ�
            DECLARE @Reagion INT;
            SELECT @Reagion=[dbo].[GC_Fn_EmployeeGetReagion] (CONVERT(INT,@UserAccount));
            IF @Reagion=1   --Rovus�Ŷ�
            BEGIN
              DELETE @temp ;
              INSERT INTO @temp(Name,Code) 
              SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A 
              WHERE A.CC_Division=@BUCode AND A.CC_Code IN ('C1703','C1706') AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
            END
            
            IF @Reagion IN(2,3)   --��һ����������
            BEGIN
              DELETE @temp ;
              INSERT INTO @temp(Name,Code) 
              SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A 
              WHERE A.CC_Division=@BUCode AND A.CC_Code IN ('C1701','C1705') AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
            END
            
            --IF @Reagion IN(2,3)   --��һ����������
            --BEGIN
            --  DELETE @temp ;
            --  INSERT INTO @temp(Name,Code) 
            --  SELECT CC_Code,CC_NameCN FROM interface.ClassificationContract A 
            --  WHERE A.CC_Division=@BUCode AND A.CC_Code IN ('C1701','C1705')
            --END
            
            IF @Reagion =4   --�����Ŷ�
            BEGIN
              DELETE @temp ;
              INSERT INTO @temp(Name,Code) 
              SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A 
              WHERE A.CC_Division=@BUCode AND A.CC_Code IN ('C1704','C1701','C1705','C1706','C1703') AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
            END
            
            IF @UserAccount in('1028963','1551385') --��ˬ
            BEGIN
              DELETE @temp ;
              INSERT INTO @temp(Name,Code) 
              SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A 
              WHERE A.CC_Division=@BUCode AND A.CC_Code IN ('C1704','C1701','C1705') AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
            END
            
            IF @Reagion NOT IN (1,2,3,4) AND @UserAccount<>'1028963' 
            BEGIN
              DELETE @temp ;
              INSERT INTO @temp(Name,Code) 
              SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A 
              WHERE A.CC_Division=@BUCode AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
            END
            
            --2016-11-14���ź��������һ������IC ROVUS�豸�����ȱ���ֶ������豸�����������Ӣ���æ�ύ���룩
            IF @UserAccount='1543008' --��Ӣ��
            BEGIN
              INSERT INTO @temp(Name,Code) 
              SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A 
              WHERE A.CC_Division=@BUCode AND A.CC_Code IN ('C1703') AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
            END 
          END
        END
      END
      RETURN
    END

GO


