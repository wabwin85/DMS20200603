
DROP  function [dbo].[GC_Fn_ConvertNumToChinese]
GO

create  function [dbo].[GC_Fn_ConvertNumToChinese]
(@instr varchar(2))
returns varchar(2)
as
begin
declare  @temStr varchar(2)
if @instr = '1' set @temStr =  'һ'
if @instr ='2'  set @temStr =  '��'
if @instr ='3'  set @temStr =  '��'
if @instr ='4'  set @temStr =  '��'
if @instr ='5'  set @temStr =  '��'
if @instr ='6'  set @temStr =  '��'
if @instr ='7'  set @temStr =  '��'
if @instr ='8'  set @temStr =  '��'
if @instr ='9'  set @temStr =  '��'
if @instr ='0'  set @temStr =  '��'
return @temstr
end

GO


