DROP function [dbo].[GC_Fn_GetIndicator]
GO


CREATE function [dbo].[GC_Fn_GetIndicator](@IsAchIndicator bit,@SAPCode nvarchar(100),@ComputeCycle nvarchar(100),@Divison nvarchar(100),@FinishDate nvarchar(100),@MarketType nvarchar(100),@SubDept nvarchar(200))
returns decimal(18,6)
as
begin

   declare @IsMatch decimal(18,6), @CycleDate nvarchar(100) ,@GetQuota money
   
   set @CycleDate=CONVERT(nvarchar(6), DATEADD(month,-1,@FinishDate),112)
   
   IF ISNULL(@MarketType,'')=''
   SET @MarketType='';
  
  IF @IsAchIndicator=1
  BEGIN
		IF (ISNULL(@SubDept,'')='')
		BEGIN
		select top 1  @GetQuota=Quota from 
			(select
			 Quota=Case when @ComputeCycle='月' then DQuotaM_D 
				when @ComputeCycle='季度' then DQuotaQ_D
				When @ComputeCycle='年' then DQuotaY_D
				else '0' end
			from [interface].[T_I_QV_Dealer_Quota_B]
			where 部门名称=@Divison and SAPCode=@SAPCode and [年月]=@CycleDate
			and 市场类型=@MarketType
			) as A ORDER BY Quota desc;
			
		END
		ELSE
		BEGIN
			select top 1  @GetQuota=Quota from 
			(select
			 Quota=Case when @ComputeCycle='月' then DQuotaM_D 
				when @ComputeCycle='季度' then DQuotaQ_D
				When @ComputeCycle='年' then DQuotaY_D
				else '0' end
			from [interface].[T_I_QV_Dealer_Quota_B]
			where 部门名称=@Divison and SAPCode=@SAPCode and [年月]=@CycleDate
			and 市场类型=@MarketType AND SubDept=@SubDept
			) as A ORDER BY Quota desc;
		END
		SET @IsMatch=@GetQuota;
  END	
  ELSE
  BEGIN
	SET @IsMatch=1
  END 
     
    
    return @IsMatch 
    		
 
end

GO


