DROP function [dbo].[GC_Fn_GetInterfaceIndicator]
GO







CREATE function [dbo].[GC_Fn_GetInterfaceIndicator](@PRCode nvarchar(50),
@DealerId nvarchar(200),@ComputeCycle nvarchar(100),@Divison nvarchar(100),@FinishDate nvarchar(100)
,@MarketType nvarchar(100))
returns int
as
begin

   declare @IsMatch decimal(18,6), @CycleDate nvarchar(100)
   
  -- set @CycleDate=CONVERT(nvarchar(6), DATEADD(month,-1,@FinishDate),112)
   
  --  IF @PRCode in ('','')
  --  Begin
  --   select top 1 @IsMatch= Quota from 
		--(select
		-- Quota=Case when @ComputeCycle='ÔÂ' then AOP_QuotaM 
		--	when @ComputeCycle='¼¾¶È' then AOP_QuotaQ
		--	When @ComputeCycle='Äê' then AOP_QuotaY
		--	else 0 end
		--from interface.T_I_QV_AOPDealerHospital
		--where Division=@Divison and AOP_DMA_ID=@DealerId and AOP_YearMonth=@CycleDate
		--and MarketType=@MarketType
		--) as A
		--if @IsMatch>=1
		--set @IsMatch=1
		--else 
		--set @IsMatch=0
  --    ENd
      
  --    else 
       set @IsMatch=1
			 
    return @IsMatch 
    		
 
end


			









GO


