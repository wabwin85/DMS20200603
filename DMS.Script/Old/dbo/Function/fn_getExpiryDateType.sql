DROP function [dbo].[fn_getExpiryDateType]
GO

CREATE function [dbo].[fn_getExpiryDateType]
(@ExpiryDate datetime,@CFN_Property6 int)
returns nvarchar(50)
as
begin
    DECLARE @rtnstatus nvarchar(50)
    DECLARE @diffdays int
declare @currentdate datetime
if @CFN_Property6=1
    SET @diffdays = DATEDIFF(DAY,GETDATE(),@ExpiryDate)
    else 
    set @diffdays= DATEDIFF(DAY,GETDATE(),
    dateadd(dd,-1,dateadd(mm,datediff(m,0,@ExpiryDate)+1,0)))
    
    --SET @currentdate=GETDATE()
    
IF @diffdays < 0
SET @rtnstatus = 'Expired'
ELSE IF @diffdays >= 0 AND @ExpiryDate<=DATEADD(MONTH,1,GETDATE()) 
SET @rtnstatus = 'Valid1'
ELSE if @ExpiryDate >DATEADD(MONTH,1,GETDATE()) and @ExpiryDate<=DATEADD(MONTH,3,GETDATE()) 
SET @rtnstatus = 'Valid2'
ELSE if @ExpiryDate >DATEADD(MONTH,3,GETDATE()) and @ExpiryDate<=DATEADD(MONTH,6,GETDATE()) 
   SET @rtnstatus = 'Valid3'
ELSE if @ExpiryDate >DATEADD(MONTH,6,GETDATE()) or @ExpiryDate is null
   set @rtnstatus = 'Valid4'
--else 
--    set @rtnstatus = 'Valid5'
 
   
  return @rtnstatus
   
end
GO


