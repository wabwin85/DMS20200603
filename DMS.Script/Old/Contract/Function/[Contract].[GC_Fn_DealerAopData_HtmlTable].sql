USE [BSC_Prd]
GO
/****** Object:  UserDefinedFunction [Contract].[GC_Fn_DealerAopData_HtmlTable]    Script Date: 2017/12/28 9:48:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create FUNCTION [Contract].[GC_Fn_DealerAopData_HtmlTable]
(
	@InstanceId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
DECLARE @ContractYear NVARCHAR(50)
DECLARE @Rtn NVARCHAR(MAX)
DECLARE @DealerName NVARCHAR(200)
DECLARE	@SubDeptName    NVARCHAR(200)		--SubBU
DECLARE	@Year			NVARCHAR(50)
DECLARE	@Month1			float		--1月
DECLARE	@Month2			float	--2月
DECLARE	@Month3			float	--3
DECLARE	@Month4			float	--4
DECLARE	@Month5			float	--5
DECLARE	@Month6			float	--6
DECLARE	@Month7			float		--7
DECLARE	@Month8			float		--8
DECLARE	@Month9			float		--9
DECLARE	@Month10		float		--10
DECLARE	@Month11		float		--11
DECLARE	@Month12		float		--12
DECLARE	@Q1				float		--Q1
DECLARE	@Q2				float		--Q2
DECLARE	@Q3				float		--Q3
DECLARE	@Q4				float		--Q4
DECLARE	@TotalYaer		float		--全年指标
	
	select @ContractYear=DATENAME(YEAR,AgreementBegin) from Contract.AppointmentProposals where ContractId=@InstanceId
	if ISNULL(@ContractYear,'')=''
	begin
	  select @ContractYear=DATENAME(YEAR,AmendEffectiveDate)  from Contract.AmendmentMain a where a.ContractId=@InstanceId
	end
	if ISNULL(@ContractYear,'')=''
	begin
     select @ContractYear=DATENAME(YEAR,AgreementBegin)from Contract.RenewalProposals r where r.ContractId=@InstanceId  
	end

	 select  @Year=[Year],
	@DealerName=DealerName,		
	@Month1=Month1 ,			
	@Month2=Month2,			
	@Month3=Month3,			
	@Month4=Month4,			
	@Month5=Month5,			
	@Month6=Month6,			
	@Month7=Month7,			
	@Month8=Month8,			
	@Month9=Month9,			
	@Month10=Month10,			
	@Month11=Month11,		
	@Month12=Month12,			
	@Q1=Q1,	
	@Q2=Q2,				
	@Q3=Q3,				
	@Q4=Q4,			
	@TotalYaer=TotalYaer from [Contract].[GC_Fn_DealerAopData_List](@InstanceId) where [Year]=@ContractYear
	
	
	SET @Rtn = '<style type="text/css">table.gridtable {width:100%; font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable tr {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;}td.title{font-weight:bold;text-align:center;}</style>'
    SET @Rtn+='<table class="gridtable"><tr><td colspan=''3'' style=''text-align:center; font-size:20px''>'+ isnull(@DealerName,'')+ @Year+'年指标清单'+'</td> </tr>'
    SET @Rtn+='<tr><td>月份</td><td>不含税</td> <td>含税</td></tr>'
	SET @Rtn+='<tr><td>1月</td><td>'+dbo.GetFormatString(@Month1,2)+'</td><td>'+dbo.GetFormatString( @Month1*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>2月</td><td>'+dbo.GetFormatString(@Month2,2)+'</td><td>'+dbo.GetFormatString( @Month2*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>3月</td><td>'+dbo.GetFormatString(@Month3,2)+'</td><td>'+dbo.GetFormatString( @Month3*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>第一季度</td><td>'+dbo.GetFormatString(@Q1,2)+'</td><td>'+dbo.GetFormatString( @Q1*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>4月</td> <td>'+dbo.GetFormatString(@Month4,2)+'</td><td>'+dbo.GetFormatString( @Month4*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>5月</td> <td>'+dbo.GetFormatString(@Month5,2)+'</td><td>'+dbo.GetFormatString( @Month5*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>6月</td> <td>'+dbo.GetFormatString(@Month6,2)+'</td><td>'+dbo.GetFormatString( @Month6*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>第二季度</td><td>'+dbo.GetFormatString(@Q2,2)+'</td><td>'+dbo.GetFormatString( @Q2*1.17,2)+' </td></tr>'
	SET @Rtn+='<tr><td>7月</td> <td>'+dbo.GetFormatString(@Month7,2)+'</td><td>'+dbo.GetFormatString( @Month7*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>8月</td> <td>'+dbo.GetFormatString(@Month8,2)+'</td><td>'+dbo.GetFormatString( @Month8*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>9月</td> <td>'+dbo.GetFormatString(@Month9,2)+'</td><td>'+dbo.GetFormatString( @Month9*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>第三季度</td><td>'+dbo.GetFormatString(@Q3,2)+'</td><td>'+dbo.GetFormatString(@Q3*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>10月</td> <td>'+dbo.GetFormatString(@Month10,2)+'</td><td>'+dbo.GetFormatString( @Month10*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>11月</td> <td>'+dbo.GetFormatString(@Month11,2)+'</td><td>'+dbo.GetFormatString( @Month11*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>12月</td> <td>'+dbo.GetFormatString(@Month12,2)+'</td><td>'+dbo.GetFormatString( @Month12*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>第四季度</td><td>'+dbo.GetFormatString(@Q4,2)+'</td><td>'+dbo.GetFormatString(@Q4*1.17,2)+'</td></tr>'
	SET @Rtn+='<tr><td>合计</td><td>'+dbo.GetFormatString(@TotalYaer,2)+'</td><td>'+dbo.GetFormatString( @TotalYaer*1.17,2)+' </td></tr>'
	SET @Rtn += '</table>'

	RETURN ISNULL(@Rtn, '')
END