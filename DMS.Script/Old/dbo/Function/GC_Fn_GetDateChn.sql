DROP function [dbo].[GC_Fn_GetDateChn]
GO

CREATE function [dbo].[GC_Fn_GetDateChn](
@vdate datetime)
returns nvarchar(50)
as
BEGIN
declare @vYear nvarchar(20)
declare @vMonth nvarchar(20)
declare @vDay nvarchar(20)
declare @temstr nvarchar(100)
declare @ChineseDateStr nvarchar(50)

set @temstr = ''
set @vYear = convert(nvarchar(4),@vdate,112)

set @vMonth = substring(convert(nvarchar(10),@vdate,112),5,2)

set @vDay  = substring(convert(nvarchar(10),@vdate,112),7,2)

-- 开始计算年份
set @temstr = dbo.GC_Fn_ConvertNumToChinese(substring(@vYear,1,1))
set @temstr = @temstr + dbo.GC_Fn_ConvertNumToChinese(substring(@vYear,2,1))
set @temstr = @temstr + dbo.GC_Fn_ConvertNumToChinese(substring(@vYear,3,1))
set @temstr = @temstr + dbo.GC_Fn_ConvertNumToChinese(substring(@vYear,4,1))
set @temstr = @temstr + '年'

-- 开始计算月份
if substring(@vMonth,1,1) = '0'
set @temstr = @temstr + dbo.GC_Fn_ConvertNumToChinese(substring(@vMonth,2,1))
else
begin
 if substring(@vMonth,2,1) = '0'
   set @temstr = @temstr + '十'
 else
   set @temstr = @temstr +'十'+ dbo.GC_Fn_ConvertNumToChinese(substring(@vMonth,2,1))
end
set @temstr = @temstr + '月'

-- 开始计算日期

if convert(int,@vDay) < 10 
  set @temstr = @temstr +  dbo.GC_Fn_ConvertNumToChinese(substring(@vDay,1,1))
else
begin
  if substring(@vDay,2,1) = '0'
    begin 
     if  substring(@vDay,1,1)<> '1'
       set  @temstr = @temstr +  dbo.GC_Fn_ConvertNumToChinese(substring(@vDay,1,1)) + '十'
      else
        set @temstr = @temstr +  '十'
     end
  else
    begin
     if substring(@vDay,1,1) <> '1'
       set @temstr = @temstr  +  dbo.GC_Fn_ConvertNumToChinese(substring(@vDay,1,1)) + '十' + dbo.GC_Fn_ConvertNumToChinese(substring(@vDay,2,1))
     else
        set @temstr = @temstr + '十' + dbo.GC_Fn_ConvertNumToChinese(substring(@vDay,2,1))
    end
end
set @temstr = @temstr +  '日'  

set @ChineseDateStr = @temstr

RETURN @ChineseDateStr
END

GO


