DROP Function [dbo].[fn_GetPeriod]
GO

CREATE Function [dbo].[fn_GetPeriod] (@RDate datetime)
returns  nvarchar(6)
as
Begin
    Declare @InvPeriod nvarchar(6)
    
	If (select DATEPART(day,@RDate))<=(select CDD_Date1 from CalendarDate
	where CDD_Calendar=CONVERT(nvarchar(6),@RDate,112))
	Set @InvPeriod=CONVERT(nvarchar(6), DATEADD(MONTH,-1,@RDate),112)
	else
	Set @InvPeriod=CONVERT(nvarchar(6),@RDate,112)
	
	return @InvPeriod

End
GO


