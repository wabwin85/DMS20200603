
DROP  function [dbo].[GC_Fn_ConvertNumToChinese]
GO

create  function [dbo].[GC_Fn_ConvertNumToChinese]
(@instr varchar(2))
returns varchar(2)
as
begin
declare  @temStr varchar(2)
if @instr = '1' set @temStr =  '一'
if @instr ='2'  set @temStr =  '二'
if @instr ='3'  set @temStr =  '三'
if @instr ='4'  set @temStr =  '四'
if @instr ='5'  set @temStr =  '五'
if @instr ='6'  set @temStr =  '六'
if @instr ='7'  set @temStr =  '七'
if @instr ='8'  set @temStr =  '八'
if @instr ='9'  set @temStr =  '九'
if @instr ='0'  set @temStr =  '零'
return @temstr
end

GO


