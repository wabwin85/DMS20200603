DROP FUNCTION [dbo].[GC_Fn_EmployeeGetReagion]
GO


CREATE FUNCTION [dbo].[GC_Fn_EmployeeGetReagion]
(
  @employeeId INT
)
RETURNS Int
AS
BEGIN
  DECLARE @ReagionID int;
  DECLARE @CostCenter int;

  set @CostCenter=0;

   --select @CostCenter= CostCenter from dbo.MD_Sales_IC
   --where EID=@employeeId
   
   select @CostCenter=CostCenter from interface.mdm_employeemaster where EID=@employeeId

   if(@CostCenter=0)
   BEGIN
    set @ReagionID=0
   END
   else if(@CostCenter=5150059)
   BEGIN
     --Rovus团队
     set @ReagionID=1
   END
   else if(@CostCenter=5150055)
   BEGIN
     --北一区
     set @ReagionID=2
   END
   else if(@CostCenter=5150056)
   BEGIN
     --北二区
     set @ReagionID=3
   END
   else if(@CostCenter=5150058)
   BEGIN
     --汝建伟 南区  IC
     set @ReagionID=4
   END
    else if(@CostCenter=5150071)
   BEGIN
     --南区  EP
     set @ReagionID=5
   END

   else 
    BEGIN
    set @ReagionID=0
   END


  RETURN @ReagionID;

END

GO


