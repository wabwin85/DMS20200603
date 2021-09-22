DROP PROCEDURE [dbo].[GC_RegistrationInit]
GO

CREATE PROCEDURE [dbo].[GC_RegistrationInit]
@UserId uniqueidentifier, @IsValid nvarchar(20) = 'Success' OUTPUT
WITH 
EXECUTE AS CALLER
AS
DECLARE @ErrorCount INTEGER
	SET NOCOUNT ON
	
	BEGIN TRY
		BEGIN TRAN
		
		/*检查是否存在不同的到期日期*/
		UPDATE RegistrationInit
		SET    RI_ERROR = 1,
		       RI_ERROR_DESC = RI_ERROR_DESC + '同张注册证日期不同,'
		WHERE  RI_ERROR = 0
		       AND RI_USER = @UserId
		       AND EXISTS
		           (
		               SELECT 1
		               FROM   (
		                          SELECT RI_RegistrationNbrCN,
		                                 RI_RegistrationNbrEN
		                          FROM   (
		                                     SELECT DISTINCT 
		                                            MAIN.RI_RegistrationNbrCN,
		                                            MAIN.RI_RegistrationNbrEN,
		                                            MAIN.RI_OpeningDate,
		                                            MAIN.RI_ExpirationDate
		                                     FROM   RegistrationInit AS MAIN
		                                     WHERE MAIN.RI_ERROR = 0
		                      							 AND MAIN.RI_USER = @UserId
		                                 ) AS t1
		                          GROUP BY
		                                 RI_RegistrationNbrCN,
		                                 RI_RegistrationNbrEN
		                          HAVING COUNT(*) > 1
		                      ) AS t2
		               WHERE  t2.RI_RegistrationNbrCN = RegistrationInit.RI_RegistrationNbrCN
		                      AND t2.RI_RegistrationNbrEN = RegistrationInit.RI_RegistrationNbrEN
		                      
		           )
		
		
		
		/*检查是否存在相同的产品编号*/
		UPDATE RegistrationInit
		SET    RI_ERROR = 1,
		       RI_ERROR_DESC = RI_ERROR_DESC + '同张注册证有相同的产品,'
		WHERE  RI_ERROR = 0
		       AND RI_USER = @UserId
		       AND EXISTS
		           (
		               SELECT 1
		               FROM   RegistrationInit t
		               WHERE  t.RI_RegistrationNbrCN = RegistrationInit.RI_RegistrationNbrCN
		                      AND t.RI_RegistrationNbrEN = RegistrationInit.RI_RegistrationNbrEN
                          AND t.RI_ArticleNumber = RegistrationInit.RI_ArticleNumber
		                      AND t.RI_ERROR = 0
		                      AND t.RI_USER = @UserId
		               GROUP BY
		                      t.RI_RegistrationNbrCN,
		                      t.RI_RegistrationNbrEN,
		                      t.RI_ArticleNumber
		               HAVING COUNT(*) > 1
		           )
               
    /*检查是否存在不同的注册证产品名称*/
		UPDATE RegistrationInit
		SET    RI_ERROR = 1,
		       RI_ERROR_DESC = RI_ERROR_DESC + '同张注册证有不同的注册证产品名称,'
		WHERE  RI_ERROR = 0
		       AND RI_USER = @UserId
		       AND EXISTS
		           (
		               SELECT 1
		               FROM   (
		                          SELECT RI_RegistrationNbrCN,
		                                 RI_RegistrationNbrEN
		                          FROM   (
		                                     SELECT DISTINCT 
		                                            MAIN.RI_RegistrationNbrCN,
		                                            MAIN.RI_RegistrationNbrEN,
		                                            MAIN.RI_RegistrationProductName
		                                     FROM   RegistrationInit AS MAIN
		                                     WHERE MAIN.RI_ERROR = 0
		                      							 AND MAIN.RI_USER = @UserId
		                                 ) AS t1
		                          GROUP BY
		                                 RI_RegistrationNbrCN,
		                                 RI_RegistrationNbrEN
		                          HAVING COUNT(*) > 1
		                      ) AS t2
		               WHERE  t2.RI_RegistrationNbrCN = RegistrationInit.RI_RegistrationNbrCN
		                      AND t2.RI_RegistrationNbrEN = RegistrationInit.RI_RegistrationNbrEN
		                      
		           )
		
		/*检查是否存在错误*/
		SELECT @ErrorCount = COUNT(*)
		FROM   RegistrationInit
		WHERE  RI_ERROR = 1
		       AND RI_USER = @UserId
		
		IF @ErrorCount > 0
		BEGIN
		    /*如果存在错误，则返回Error*/
		    SET @IsValid = 'Error'
		END
		ELSE
		BEGIN
		    /*如果不存在错误，则返回Success，并执行初始化库存的操作*/		
		    SET @IsValid = 'Success'
		    
		    /*删除Detail表*/
		    DELETE 
		    FROM   RegistrationDetail
		    WHERE  RD_RM_ID IN (SELECT DISTINCT main.RM_ID
		                        FROM   RegistrationMain main
		                               INNER JOIN RegistrationInit INIT
		                                    ON  main.RM_RegistrationNbrCN = INIT.RI_RegistrationNbrCN
                                        AND main.RM_RegistrationNbrEN = INIT.RI_RegistrationNbrEN
		                        WHERE  INIT.RI_ERROR = 0
		                               AND INIT.RI_USER = @UserId)
		    
		    /*删除Main表*/
		    DELETE 
		    FROM   RegistrationMain
		    WHERE  RM_ID IN (SELECT DISTINCT main.RM_ID
		                     FROM   RegistrationMain main
		                            INNER JOIN RegistrationInit INIT
		                                 ON  main.RM_RegistrationNbrCN = INIT.RI_RegistrationNbrCN
                                     AND main.RM_RegistrationNbrEN = INIT.RI_RegistrationNbrEN
		                     WHERE  INIT.RI_ERROR = 0
		                            AND INIT.RI_USER = @UserId)
		                            
		    --DELETE FROM RegistrationMain WHERE EXISTS (SELECT 1 FROM RegistrationInit INIT
		    --WHERE INIT.RI_USER = @UserId AND INIT.RM_RegistrationNbrCN = RegistrationMain.RM_RegistrationNbrCN)          
		    
		    /*先插入主表*/
		    INSERT INTO RegistrationMain
		      (
		        RM_ID,
		        RM_RegistrationNbrCN,
		        RM_RegistrationNbrEN,
		        RM_OpeningDate,
		        RM_ExpirationDate,
            RM_RegistrationProductName
		      )
		    SELECT NEWID(),
		           RI_RegistrationNbrCN,
		           RI_RegistrationNbrEN,
		           RI_OpeningDate,
		           RI_ExpirationDate,
               RI_RegistrationProductName
		    FROM   (
		               SELECT DISTINCT RI_RegistrationNbrCN,
		                      RI_RegistrationNbrEN,
		                      RI_OpeningDate,
		                      RI_ExpirationDate,
                          RI_RegistrationProductName
		               FROM   RegistrationInit
		               WHERE  RI_ERROR = 0
		                      AND RI_USER = @UserId
		           ) a
		    
		    /*再插入明细表表*/
		    INSERT INTO RegistrationDetail
		      (
		        RD_ID,
		        RD_RM_ID,
		        RD_ArticleNumber,
		        RD_ChineseName,
		        RD_EnglishName,
		        RD_Specification,
		        RD_Manufacturer_ID,
		        RD_Manufacturer_Name,
		        RD_Manufacturer_Address,
		        RD_Manufactory_Address,
		        RD_Scope,
		        RD_RegisteredAgent,
		        RD_Service,
		        RD_Import,
		        RD_Implant,
		        RD_Lot,
		        RD_SN,
		        RD_Pacemaker,
		        RD_GuaranteePeriod,
		        RD_MinUnit,
		        RD_Barcode1,
		        RD_Barcode2,
		        RD_Barcode3,
		        RD_Barcode4
		      )
		    SELECT NEWID(),
		           main.RM_ID,
		           RI_ArticleNumber,
		           RI_ChineseName,
		           RI_EnglishName,
		           RI_Specification,
		           RI_Manufacturer_ID,
		           RI_Manufacturer_Name,
		           RI_Manufacturer_Address,
		           RI_Manufactory_Address,
		           RI_Scope,
		           RI_RegisteredAgent,
		           RI_Service,
		           RI_Import,
		           RI_Implant,
		           RI_Lot,
		           RI_SN,
		           RI_Pacemaker,
		           RI_GuaranteePeriod,
		           RI_MinUnit,
		           RI_Barcode1,
		           RI_Barcode2,
		           RI_Barcode3,
		           RI_Barcode4
		    FROM   RegistrationInit INIT
		           INNER JOIN RegistrationMain main
		                ON  INIT.RI_RegistrationNbrCN = main.RM_RegistrationNbrCN
		                AND INIT.RI_RegistrationNbrEN = main.RM_RegistrationNbrEN
		    WHERE  INIT.RI_ERROR = 0
		           AND INIT.RI_USER = @UserId
		END 
		COMMIT TRAN
		
		SET NOCOUNT OFF
		RETURN 1
	END TRY
	
	BEGIN CATCH
		SET NOCOUNT OFF
		ROLLBACK TRAN
		SET @IsValid = 'Failure'
		RETURN -1
	END CATCH
GO


