DROP Function [dbo].[fn_GetEnabledFlag] 
GO


CREATE Function [dbo].[fn_GetEnabledFlag] 
(@CFN_Property6 int,@ExpiredDate datetime,@ShipmentDate nvarchar(50))
returns  nvarchar(6)
as
Begin
   declare @EnabledFlag nvarchar(6)
   if @CFN_Property6=1 and @ExpiredDate>=@ShipmentDate
   set  @EnabledFlag=N'ÊÇ'
   else if @CFN_Property6=1 and @ExpiredDate<@ShipmentDate
   set  @EnabledFlag=N'·ñ'
   else if @CFN_Property6=0 and dateadd(dd,-1,dateadd(mm,datediff(m,0,@ExpiredDate)+1,0))>=@ShipmentDate
   set @EnabledFlag=N'ÊÇ'
   else 
   set @EnabledFlag=N'·ñ'
   
  return @EnabledFlag
End



GO


