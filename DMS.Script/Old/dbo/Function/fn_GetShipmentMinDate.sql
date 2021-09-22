
DROP Function [dbo].[fn_GetShipmentMinDate]
GO


CREATE Function [dbo].[fn_GetShipmentMinDate] ()
returns  nvarchar(10)
as
Begin
declare @limitNo int,@minDate nvarchar(10)
select @limitNo=CDD_Date1 from CalendarDate
where  CDD_Calendar= CONVERT(nvarchar(6),getdate(),112)

if @limitNo is null
set  @minDate='1979-01-01'
else if(DATEPART(day,getdate())>@limitNo)
select @minDate=convert(nvarchar(10),dateadd(month,0,dateadd(month,datediff(month,0,getdate()),0)),121)
else
select @minDate=convert(nvarchar(10),dateadd(month,-1,dateadd(month,datediff(month,0,getdate()),0)),121)
	
return @minDate

End


GO


