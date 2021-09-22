 
USE [BSC_Prd]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create FUNCTION [Contract].[GC_Fn_AuthorizationProduct_HtmlTable]
(


 @InstanceId UNIQUEIDENTIFIER
 )

RETURNS @temp TABLE 
(
    ProductName NVARCHAR(max)	NOT NULL,	--��Ʒ����
	ProductEnglishName  NVARCHAR(max) NULL--��Ʒ����Ӣ������
)
  WITH
  EXECUTE AS CALLER
  BEGIN
  DECLARE @Rtn1 NVARCHAR(max);
  DECLARE @Rtn2 NVARCHAR(max);
  DECLARE   @ProductName	NVARCHAR(200);		--��Ʒ����
  DECLARE	@ProductEnglishName	NVARCHAR(200);	--��Ʒ����Ӣ������
  set @Rtn1='<!DOCTYPE html><html><head><meta charset=''UTF-8''></head><body><table style=''border: 0; width: 100%;''>'
  set @Rtn2='<!DOCTYPE html><html><head><meta charset=''UTF-8''></head><body><table style=''border: 0; width: 100%;''>';
  DECLARE @PRODUCT_CUR cursor;
  SET @PRODUCT_CUR=cursor for 
  select distinct ProductName, isnull(ProductEnglishName,'') from [Contract].[GC_Fn_AuthorizationData_List](@InstanceId)  
  OPEN @PRODUCT_CUR
  FETCH NEXT FROM @PRODUCT_CUR INTO @ProductName,@ProductEnglishName
    WHILE @@FETCH_STATUS = 0        
        BEGIN			
			begin			
            set @Rtn1+='<tr><td style=''font-family:������; font-size:15px;''>'+@ProductName+'</td></tr>'
			set @Rtn2+='<tr><td style=''font-family:Times New Roman; font-size:15px;''>'+@ProductEnglishName+'</td></tr>'		
			end
				
    	FETCH NEXT FROM @PRODUCT_CUR INTO @ProductName,@ProductEnglishName
		END        
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR; 
	set @Rtn1+='</table></body></html>';
	set @Rtn2+='</table></body></html>';
		
	
	 INSERT INTO @temp(ProductName,ProductEnglishName) 
     select @Rtn1,@Rtn2
 
RETURN

 END
	

	



