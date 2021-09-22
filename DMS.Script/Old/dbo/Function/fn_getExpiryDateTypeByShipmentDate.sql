DROP function [dbo].[fn_getExpiryDateTypeByShipmentDate]
GO


CREATE function [dbo].[fn_getExpiryDateTypeByShipmentDate]
(@ExpiryDate datetime,@CFN_Property6 int,@ShipmentDate datetime)
returns nvarchar(50)
as
begin
    DECLARE @rtnstatus nvarchar(50)
    DECLARE @diffdays int
	declare @currentdate datetime
	
	if @CFN_Property6=1
    SET @diffdays = DATEDIFF(DAY,@ShipmentDate,@ExpiryDate)
    else 
    set @diffdays= DATEDIFF(DAY,@ShipmentDate,
    dateadd(dd,-1,dateadd(mm,datediff(m,0,@ExpiryDate)+1,0)))   
   
    
	IF @diffdays < 0
		SET @rtnstatus = 'Expired'
	ELSE IF @diffdays >= 0 AND @ExpiryDate<=DATEADD(MONTH,1,@ShipmentDate) 
		SET @rtnstatus = 'Valid1'
	ELSE if @ExpiryDate >DATEADD(MONTH,1,@ShipmentDate) and @ExpiryDate<=DATEADD(MONTH,3,@ShipmentDate) 
		SET @rtnstatus = 'Valid2'
	ELSE if @ExpiryDate >DATEADD(MONTH,3,@ShipmentDate) and @ExpiryDate<=DATEADD(MONTH,6,@ShipmentDate) 
	    SET @rtnstatus = 'Valid3'
	ELSE if @ExpiryDate >DATEADD(MONTH,6,@ShipmentDate) or @ExpiryDate is null
	    set @rtnstatus = 'Valid4'
   
  return @rtnstatus
   
end









GO


