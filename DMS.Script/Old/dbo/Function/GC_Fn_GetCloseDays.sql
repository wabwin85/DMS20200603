DROP function [dbo].[GC_Fn_GetCloseDays]
GO

CREATE function [dbo].[GC_Fn_GetCloseDays]
(
@year nvarchar(10),
@DMA_ID uniqueidentifier
)
RETURNS nvarchar(10)
AS
BEGIN
  DECLARE @result nvarchar(5);
  DECLARE @minMonth nvarchar(10);
  DECLARE @start datetime;
  DECLARE @end datetime;



/*本年截止天数*/
if(@year <> convert(varchar(4),getdate(),112))
  begin
    select @minMonth = min(substring(RIH_Period,5,3)) from ReportInventoryHistory
    where substring(RIH_Period,1,4) = @year
    and RIH_DMA_ID = @DMA_ID

    select @start = COP_StartDate from COP
    where COP.COP_Year = @year and COP_Period = @minMonth
    
    select @end = COP_EndDate from COP
    where COP.COP_Year = @year and COP_Period = '12'

    select @result = datediff(day,@start, @end)+1 

  end
 else
  begin
    select @result =
    case when substring(convert(varchar(10),dm.DMA_FirstContractDate,112),1,4) 
              < substring(convert(varchar(6),getdate(),112),1,4)
        then datediff(day,convert(datetime,substring(convert(varchar(6),getdate(),112),1,4)), getdate())
        else datediff(day,dm.DMA_FirstContractDate, getdate())
    end 
    from DealerMaster dm
    where DMA_ID = @DMA_ID

  end
  
  
  RETURN @result;
END

GO


