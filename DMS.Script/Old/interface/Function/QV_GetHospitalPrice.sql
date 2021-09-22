DROP function [interface].[QV_GetHospitalPrice]
GO



CREATE function [interface].[QV_GetHospitalPrice](
@SAPCode nvarchar(50),
@UPN nvarchar(50),
@ShipmentDate Datetime)
returns decimal(18,6)
as
begin
	declare @Price decimal(18,6)
	select top 1 @Price=NewPrice/1.17 FROM [interface].[T_I_EW_DistributorPrice] 
	where type = 2 and validfrom <=isnull(validto,'9999-12-31')
	and CustomerSapCode=@SAPCode and ValidFrom<=@ShipmentDate
	and UPN=@UPN
	order by ValidFrom desc
   
   return @Price
   end


GO


