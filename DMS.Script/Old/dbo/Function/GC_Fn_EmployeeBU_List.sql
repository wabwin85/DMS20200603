DROP FUNCTION [dbo].[GC_Fn_EmployeeBU_List]
GO


--产品线：
--申请人部门DRM/EM：IC，CRM，EP，SH，PI，URO，Endo，PUL
--1100123汝建伟/1086375 雷剑/1106000 余锋/1109137 黄耀民/1104498 罗璇：IC，CRM
--1530985刘辉：CRM，EP
--1062070 赵世新/1108613 姜焕荣/1092451 侯丽丽/1102308 李晓玲/1115020 潘永哲：IC，EP
--其他BU：本部门BU。

--合同分类：
--申请人部门DRM：IC，CRM，EP，SH，PI，URO，Endo，PUL里只是LP的SubBu申请权限。
--申请人部门EM：IC，CRM，EP，SH，PI，URO，Endo，PUL里蓝海属性的SubBu。
--IC Rovus团队只能申请编号为C1703,C1706的SubBu。
--北一区，北二区团队只能申请编号为C1701，C1705的SubBu。
--IC 南区团队只能申请编号为C1704，C1701，C1705，C1706，C1703的SubBu。
--1028963 刘爽能申请编号为C1704，C1701，C1705的SubBu。

--上面区域的区分是根据主数据判断的，参考附件。
--select * from interface.T_I_QV_SalesRep

/**********************************************
 功能:获取申请人可选合同
 作者：Grapecity
 最后更新时间： 2016-07-28
 更新记录说明：
 1.创建 2016-07-28
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
                  WHERE  T1.MAP_ID = T2.Id AND T1.IDENTITY_ID = T3.Id AND T1.MAP_TYPE = 'Role' AND T2.ATTRIBUTE_TYPE = 'Role' AND T2.ATTRIBUTE_NAME = '合同管理员' AND T3.IDENTITY_CODE=@UserCode))
      BEGIN
        INSERT INTO @temp(Name,Code) 
        SELECT B.DepFullName,A.DivisionCode
          FROM V_DivisionProductLineRelation A,interface.mdm_department B WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND NOT EXISTS (SELECT 1 FROM @temp WHERE Code=A.DivisionCode)
      END
      ELSE
      BEGIN
        IF @UserDivision=5  --DRM
        BEGIN
			IF @UserAccount='1551560'--Canna – URO, ENDO, PUL
			BEGIN
				INSERT INTO @temp(Name,Code) 
				SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B 
				WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND NOT EXISTS (SELECT 1 FROM @temp WHERE Code=A.DivisionCode)
				AND A.DivisionCode IN('22','18','34')
			END
			ELSE IF @UserAccount='1545195'--Qiu Birong – PI, EM
			BEGIN
				INSERT INTO @temp(Name,Code) 
				SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B 
				WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND NOT EXISTS (SELECT 1 FROM @temp WHERE Code=A.DivisionCode)
			END
			ELSE IF @UserAccount='1556364'--陈一卿 – IC
			BEGIN
				INSERT INTO @temp(Name,Code) 
				SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B 
				WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND NOT EXISTS (SELECT 1 FROM @temp WHERE Code=A.DivisionCode)
				AND A.DivisionCode IN('17')
			END
			ELSE IF @UserAccount='1540346'--Zhu Binyan – CRM, EP, SH
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
        
        IF @UserAccount IN ('1100123','1086375','1106000','1109137','1104498')--1100123汝建伟/1086375 雷剑/1106000 余锋/1109137 黄耀民/1104498 罗璇：IC，CRM
        BEGIN
          DELETE @temp ;
          
          INSERT INTO @temp(Name,Code) 
          SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B 
          WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND A.DivisionCode IN ('17','19');
          
        END
        IF @UserAccount IN ('1530985')--1530985刘辉：CRM，EP
        BEGIN
          DELETE @temp ;
          
          INSERT INTO @temp(Name,Code) 
          SELECT B.DepFullName,A.DivisionCode FROM V_DivisionProductLineRelation A,interface.mdm_department B 
          WHERE A.DivisionCode=B.DepID AND A.IsEmerging='0' AND A.DivisionCode IN ('19','32');
        END
        IF @UserAccount IN ('1062070','1108613','1092451','1102308','1115020')--1062070 赵世新/1108613 姜焕荣/1092451 侯丽丽/1102308 李晓玲/1115020 潘永哲：IC，EP
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
                  WHERE  T1.MAP_ID = T2.Id AND T1.IDENTITY_ID = T3.Id AND T1.MAP_TYPE = 'Role' AND T2.ATTRIBUTE_TYPE = 'Role' AND T2.ATTRIBUTE_NAME = '合同管理员' AND T3.IDENTITY_CODE=@UserCode))
      BEGIN
        INSERT INTO @temp(Name,Code) 
        SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
      END
      ELSE IF (@UserAccount IN ('1551560','1556364','1540346'))
      BEGIN
        INSERT INTO @temp(Name,Code) 
        SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode AND A.CC_NameCN Not LIKE '%新兴市场%' AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
      END
      ELSE IF (@UserAccount IN ('1545195')) --qiu,birong
      BEGIN
        INSERT INTO @temp(Name,Code) 
        SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode AND A.CC_NameCN LIKE '%新兴市场%' AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
        
        INSERT INTO @temp(Name,Code) 
        SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division IN ('10','18','34') AND A.CC_Division=@BUCode AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
        
      END
      ELSE
        BEGIN
          IF @UserDivision=5  --DRM
          BEGIN
            INSERT INTO @temp(Name,Code) 
            SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode --AND A.CC_NameCN LIKE '%平台%' 
            AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120) AND a.CC_Division<>'38'
            
            IF @UserAccount IN ('1091746')--高辉
            BEGIN
            INSERT INTO @temp(Name,Code) 
            SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode AND a.CC_Division='38' AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
            AND NOT EXISTS (SELECT 1 FROM @temp WHERE Code=A.CC_Code)
            END
          END
          IF @UserDivision=36  --EM
          BEGIN
            INSERT INTO @temp(Name,Code) 
            SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode AND A.CC_NameCN LIKE '%新兴市场%' AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
          END
          
          IF @UserDivision=10  --PI
          BEGIN
            INSERT INTO @temp(Name,Code) 
            SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@BUCode AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
          END
          
          IF @UserDivision<>5 AND @UserDivision<>36 AND @UserDivision<>10 AND ISNULL(@BUCode,'0')<>'17'
          BEGIN
            INSERT INTO @temp(Name,Code) 
            SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A WHERE A.CC_Division=@UserDivision AND A.CC_Division=@BUCode  AND A.CC_NameCN NOT LIKE '%新兴市场%' AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
          END
          
          
          IF ISNULL(@BUCode,'0')='17'
          BEGIN
            --指定团队
            DECLARE @Reagion INT;
            SELECT @Reagion=[dbo].[GC_Fn_EmployeeGetReagion] (CONVERT(INT,@UserAccount));
            IF @Reagion=1   --Rovus团队
            BEGIN
              DELETE @temp ;
              INSERT INTO @temp(Name,Code) 
              SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A 
              WHERE A.CC_Division=@BUCode AND A.CC_Code IN ('C1703','C1706') AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
            END
            
            IF @Reagion IN(2,3)   --北一区，北二区
            BEGIN
              DELETE @temp ;
              INSERT INTO @temp(Name,Code) 
              SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A 
              WHERE A.CC_Division=@BUCode AND A.CC_Code IN ('C1701','C1705') AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
            END
            
            --IF @Reagion IN(2,3)   --北一区，北二区
            --BEGIN
            --  DELETE @temp ;
            --  INSERT INTO @temp(Name,Code) 
            --  SELECT CC_Code,CC_NameCN FROM interface.ClassificationContract A 
            --  WHERE A.CC_Division=@BUCode AND A.CC_Code IN ('C1701','C1705')
            --END
            
            IF @Reagion =4   --南区团队
            BEGIN
              DELETE @temp ;
              INSERT INTO @temp(Name,Code) 
              SELECT CC_NameCN,CC_Code FROM interface.ClassificationContract A 
              WHERE A.CC_Division=@BUCode AND A.CC_Code IN ('C1704','C1701','C1705','C1706','C1703') AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),A.CC_EndDate,120)
            END
            
            IF @UserAccount in('1028963','1551385') --刘爽
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
            
            --2016-11-14，张浩提出（北一区由于IC ROVUS设备经理空缺，现东北的设备申请大区经理艾英宏帮忙提交申请）
            IF @UserAccount='1543008' --艾英宏
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


