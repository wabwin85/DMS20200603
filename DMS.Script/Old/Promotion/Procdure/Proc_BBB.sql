DROP PROCEDURE [Promotion].[Proc_BBB]
GO




CREATE PROCEDURE [Promotion].[Proc_BBB]
	
AS
BEGIN
	DECLARE @PolicyId int
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
		SELECT  PolicyId FROM Promotion.PRO_POLICY
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @PolicyId
    WHILE @@FETCH_STATUS = 0        
        BEGIN
			SET @SQL='exec PROMOTION.Proc_Pro_Cal_Policy_Closing ' +CONVERT(nvarchar(10),@PolicyId)
			EXEC(@SQL)
			
            FETCH NEXT FROM @PRODUCT_CUR INTO @PolicyId
        END
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR ;
	
	
END



GO


