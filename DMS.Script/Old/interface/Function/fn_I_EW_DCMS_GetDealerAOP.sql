DROP FUNCTION [interface].[fn_I_EW_DCMS_GetDealerAOP]
GO


/*
获取经销商指标信息
*/
CREATE FUNCTION [interface].[fn_I_EW_DCMS_GetDealerAOP]
	(@InstanceID NVARCHAR(36))
	RETURNS  NVARCHAR(4000) 
AS
	begin
	DECLARE @RtnVal NVARCHAR(4000);
	DECLARE @Year NVARCHAR(20);
	DECLARE @Q1 decimal  ;
	DECLARE @Q2 decimal  ;
	DECLARE @Q3 decimal  ;
	DECLARE @Q4 decimal  ;
	
	DECLARE @PRODUCT_CUR cursor;
	SET @RtnVal='';
	
	SET @PRODUCT_CUR=cursor for 
		SELECT allAop.Year,SUM(allAop.Q1) Q1,SUM(allAop.Q2) Q2,SUM(allAop.Q3) Q3,SUM(allAop.Q4)Q4 FROM (
			  SELECT 
			  AOPD_Year as Year,
			  (AOPD_Amount_1 +AOPD_Amount_2 +AOPD_Amount_3 ) AS Q1 ,
			  (AOPD_Amount_4 +AOPD_Amount_5 +AOPD_Amount_6 ) AS Q2 ,
			  (AOPD_Amount_7 +AOPD_Amount_8 +AOPD_Amount_9 ) AS Q3 ,
			  (AOPD_Amount_10 +AOPD_Amount_11 +AOPD_Amount_12 ) AS Q4 
			  FROM V_AOPDealer_Temp
			  left join View_ProductLine pl on pl.Id=V_AOPDealer_Temp.AOPD_ProductLine_BUM_ID
			  WHERE AOPD_Contract_ID=@InstanceID) allAop
			  GROUP BY allAop.Year
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @Year,@Q1,@Q2,@Q3,@Q4
    WHILE @@FETCH_STATUS = 0        
        BEGIN
		SET @RtnVal = @RtnVal +@Year +'  [Q1:'+dbo.GetFormatString(CONVERT(NVARCHAR(1000),@Q1),0)+';  Q2:'+dbo.GetFormatString(CONVERT(NVARCHAR(1000),@Q2),0)+';  Q3:'+dbo.GetFormatString(CONVERT(NVARCHAR(1000),@Q3),0)++';  Q4:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q4),0)+'];   '
		FETCH NEXT FROM @PRODUCT_CUR INTO @Year,@Q1,@Q2,@Q3,@Q4
        END
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR ;
    
    RETURN @RtnVal;
End




GO


