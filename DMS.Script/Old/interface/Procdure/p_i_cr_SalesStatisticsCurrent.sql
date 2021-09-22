DROP proc [interface].[p_i_cr_SalesStatisticsCurrent]
GO

Create proc [interface].[p_i_cr_SalesStatisticsCurrent]
as

declare @StartTime datetime, @EndTime datetime
set @StartTime=DATEADD(mi, 00, DATEADD(hh, 12, DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE()), 0)))
set @EndTime=DATEADD(mi, 00, DATEADD(hh, 12, DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE())+1, 0)))

delete from [interface].[T_I_CR_SalesStatisticsCurrent]
--where StartTime between @StartTime and @EndTime
insert into [interface].[T_I_CR_SalesStatisticsCurrent]
	select 
		DMA_SAP_Code,
		@StartTime as StartTime,
		@EndTime as EndTime,
		case when  (select count(1) from ShipmentHeader (Nolock)
		left join DealerMaster d (nolock) on SPH_Dealer_DMA_ID=d.DMA_ID
		where d.DMA_SAP_Code=dma.DMA_SAP_Code and 
		SPH_Status!='Draft' and SPH_SubmitDate>=@StartTime and SPH_SubmitDate<@EndTime)>0
		then N'是' 
		when  (select count(1) from ShipmentHeader (Nolock)
		left join DealerMaster a (nolock) on SPH_Dealer_DMA_ID=a.DMA_ID
		where a.DMA_ID=dma.DMA_ID and
		SPH_Status!='Draft' and SPH_SubmitDate>=@StartTime and SPH_SubmitDate<@EndTime)<=0
		and (select count(1) from UploadLog 
		left join DealerMaster ab  on ULL_DMA_Id=ab.DMA_ID
		where dma.DMA_ID=ab.DMA_ID and
		ULL_Type=N'销售' and ULL_UploadDate>=@StartTime and ULL_UploadDate<@EndTime)>0
		then N'无销量' 
		else N'否' end InDueTime
	from DealerMaster dma (nolock)
		where DMA_DealerType in ('T1','T2')
		and DMA_ActiveFlag=1 and DMA_DeletedFlag=0
		order by InDueTime
GO


