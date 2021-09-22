USE [BSC_Prd]
GO
/****** Object:  UserDefinedFunction [Contract].[GC_Fn_AuthorizationHospital_HtmlTable]    Script Date: 2017/12/26 16:44:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [Contract].[GC_Fn_AuthorizationHospital_HtmlTable]
(
	@InstanceId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
DECLARE @Rtn NVARCHAR(MAX)
DECLARE @TerritoryName	NVARCHAR(200)		--授权区域名称
DECLARE	@TerritoryEName	NVARCHAR(200)		--授权区域英文名称
	
	

	SET @Rtn = '<style type="text/css">table.gridtable {width:100%; font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable tr {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;}table.gridtable 
	td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;}td.title{font-weight:bold;text-align:center;}</style>'
    SET @Rtn+='<table class="gridtable"><tr><td colspan=''2'' style=''text-align:center; font-size:20px''>授权区域</td> </tr>'
    SET @Rtn+='<tr><td style=''text-align:center;''>授权区域名称</td><td style=''text-align:center;''>授权区域英文名称</td></tr>'

	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
		 select distinct
	TerritoryName,
	TerritoryEName	
	  from [Contract].[GC_Fn_AuthorizationData_List](@InstanceId)
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @TerritoryName,@TerritoryEName
    WHILE @@FETCH_STATUS = 0        
        BEGIN
			
			begin			
            set @Rtn+='<tr><td style=''text-align:center;''>'+@TerritoryName+'</td><td style=''text-align:center;''>'+@TerritoryEName+'</td></tr>'
			end
				
    	FETCH NEXT FROM @PRODUCT_CUR INTO @TerritoryName,@TerritoryEName
		END        
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR; 
	
	SET @Rtn += '</table>'

	RETURN ISNULL(@Rtn, '')
END


