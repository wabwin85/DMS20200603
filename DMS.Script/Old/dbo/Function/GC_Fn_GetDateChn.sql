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

-- ��ʼ�������
set @temstr = dbo.GC_Fn_ConvertNumToChinese(substring(@vYear,1,1))
set @temstr = @temstr + dbo.GC_Fn_ConvertNumToChinese(substring(@vYear,2,1))
set @temstr = @temstr + dbo.GC_Fn_ConvertNumToChinese(substring(@vYear,3,1))
set @temstr = @temstr + dbo.GC_Fn_ConvertNumToChinese(substring(@vYear,4,1))
set @temstr = @temstr + '��'

-- ��ʼ�����·�
if substring(@vMonth,1,1) = '0'
set @temstr = @temstr + dbo.GC_Fn_ConvertNumToChinese(substring(@vMonth,2,1))
else
begin
 if substring(@vMonth,2,1) = '0'
   set @temstr = @temstr + 'ʮ'
 else
   set @temstr = @temstr +'ʮ'+ dbo.GC_Fn_ConvertNumToChinese(substring(@vMonth,2,1))
end
set @temstr = @temstr + '��'

-- ��ʼ��������

if convert(int,@vDay) < 10 
  set @temstr = @temstr +  dbo.GC_Fn_ConvertNumToChinese(substring(@vDay,1,1))
else
begin
  if substring(@vDay,2,1) = '0'
    begin 
     if  substring(@vDay,1,1)<> '1'
       set  @temstr = @temstr +  dbo.GC_Fn_ConvertNumToChinese(substring(@vDay,1,1)) + 'ʮ'
      else
        set @temstr = @temstr +  'ʮ'
     end
  else
    begin
     if substring(@vDay,1,1) <> '1'
       set @temstr = @temstr  +  dbo.GC_Fn_ConvertNumToChinese(substring(@vDay,1,1)) + 'ʮ' + dbo.GC_Fn_ConvertNumToChinese(substring(@vDay,2,1))
     else
        set @temstr = @temstr + 'ʮ' + dbo.GC_Fn_ConvertNumToChinese(substring(@vDay,2,1))
    end
end
set @temstr = @temstr +  '��'  

set @ChineseDateStr = @temstr

RETURN @ChineseDateStr
END

GO


