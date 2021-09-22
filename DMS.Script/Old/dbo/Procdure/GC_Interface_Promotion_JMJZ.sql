DROP  proc [dbo].[GC_Interface_Promotion_JMJZ]
GO







CREATE proc [dbo].[GC_Interface_Promotion_JMJZ]
as

	select 
		PRCode
	   ,ROW_NUMBER() over (order by PRCode) as rownumber
	   ,IsBundle
	   ,IsSuit
		into #tmp
		from interface.T_I_EW_PromotionRules(nolock)
		where PromotionType=N'¼´Âò¼´Ôù' and BeginDate<=GETDATE() and EndDate>=convert(date,GETDATE())

    declare @count int,@PRcode nvarchar(200),@IsBundle bit, @IsSuit bit
    set @count=1
    while @count<=(select COUNT(*) from #tmp)
    begin
    
       set @PRcode=(select PRCode from #tmp where @count=rownumber)
	   set @IsBundle=(select IsBundle from #tmp where @count=rownumber)
	   set @IsSuit=(select IsSuit from #tmp where @count=rownumber)
	   
		 EXEC dbo.GC_Interface_Promotion_Dealers @PRCode
		 EXEC dbo.GC_Interface_Promotion_Product @PRCode,@IsBundle
		 EXEC GC_Interface_Promotion_FreeGoods @PRCode,@IsSuit
	
	 Insert into [PromotionPolicy]
	 select 
		   [PMP_ID]=NEWID()
		  ,[PMP_Code]=i.PRCode
		  ,[Content]
		  --,[DMAID]=(select DMA_ID from DealerMaster dm where dm.DMA_SAP_Code=d.DMA_SAP_Code)
		  ,DMAID=DMA_ID
		  ,[Division]
		  ,[ProductLine]
		  ,[ComputeCycle]
		  ,[PurchaseQty]=i.PurchaseQty
		  ,[FreeQty]=FreeQty
		  ,[ClearQty]=0
		  ,[AdjustQty]=0
		  ,[AdjustRemark]=NULL
		  ,[AvaliableQty]=FreeQty
		  ,[BeginDate]
		  ,[EndDate]
		  ,[CreateTime]=GETDATE()
		  ,[UpdateTime]=GETDATE()
		  ,[PromotionType]
		  ,[UPN]=LevelCode
		  ,[IsDeleted]=0
		  ,ProductLineId
		  ,IsApproved=NULL
		  ,PRName
		  ,AdjustUserId=NULL
		  ,AdjustQtyForT2=NULL
	  from interface.T_I_EW_PromotionRules i
	  join interface.T_I_EW_PromtionDealers d on i.PRCode=d.PRCode
	  join DealerMaster dm on d.DMA_SAP_Code=dm.DMA_SAP_Code
	  where i.PRCode=@PRcode and Not exists 
	       (select 1 from PromotionPolicy p where p.PMP_Code=i.PRCode and dm.DMA_ID=p.DMAID and p.IsDeleted=0) 
       set @count=@count+1
    
    end
    
 drop table #tmp   







GO


