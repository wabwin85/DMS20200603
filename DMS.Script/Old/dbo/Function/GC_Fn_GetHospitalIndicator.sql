DROP function [dbo].[GC_Fn_GetHospitalIndicator]
GO


CREATE function [dbo].[GC_Fn_GetHospitalIndicator](@IsAchHospitalIndicator bit,@SAPCode nvarchar(100),@ComputeCycle nvarchar(100),@Divison nvarchar(100),@FinishDate nvarchar(100),@HospitalCode nvarchar(100),@SubDept nvarchar(200))
returns decimal(18,6)
as
begin

   declare @IsMatch decimal(18,6), @CycleDate nvarchar(100) ,@GetQuota decimal(18,6),@DivisonCode nvarchar(100)
   
   set @CycleDate=CONVERT(nvarchar(6), DATEADD(month,-1,@FinishDate),112)
   
   SELECT TOP 1  @DivisonCode=A.DivisionCode FROM V_DivisionProductLineRelation A WHERE A.DivisionName=@Divison
  
  IF @IsAchHospitalIndicator=1
  BEGIN
	if ISNULL(@SubDept,'')=''
	begin
		select top 1  @GetQuota=Quota from 
			(select
			 Quota=Case when @ComputeCycle='月' then MRate_D
				when @ComputeCycle='季度' then  QTDRate_D
				When @ComputeCycle='年' then YTDRate_D
				else '0' end
			from interface.T_I_QV_Hospital_Quota 
			where Division=@DivisonCode and SAPCode=@SAPCode and YearMonth=@CycleDate and HospitalCode=@HospitalCode
			
			) as A ORDER BY Quota DESC;
		end
		else
		begin
			select top 1  @GetQuota=Quota from 
			(select
			 Quota=Case when @ComputeCycle='月' then MRate_D
				when @ComputeCycle='季度' then  QTDRate_D
				When @ComputeCycle='年' then YTDRate_D
				else '0' end
			from interface.T_I_QV_Hospital_Quota 
			where Division=@DivisonCode and SAPCode=@SAPCode and YearMonth=@CycleDate and HospitalCode=@HospitalCode and SubDept=@SubDept
			
			) as A ORDER BY Quota DESC;
		end	
		
		SET @IsMatch=@GetQuota;
  END	
  ELSE
  BEGIN
	SET @IsMatch=1
  END 
     
    
    return @IsMatch 
    		
 
end

GO


