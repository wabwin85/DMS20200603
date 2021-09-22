DROP proc [dbo].[GC_Interface_Promotion_InHospitalSales]
GO



CREATE proc [dbo].[GC_Interface_Promotion_InHospitalSales](@PRCode nvarchar(200),
@StartDatec nvarchar(100),@FinishDatec nvarchar(100))
as

declare @StartDate DATETIME 
declare @FinishDate DATETIME
SET @StartDate =CONVERT(DATETIME,@StartDatec);
SET @FinishDate =CONVERT(DATETIME,@FinishDatec);
--------------------- 计算经销商销量明细--------------------------- 

	 select DealerID,Division,Hospital,MIN(Transaction_Date) as ShipmentDate 
		    into #first
		    from interface.V_I_QV_InHospitalSales (nolock)
		    group by DealerID, Division, Hospital
	   
	 Declare @BeginDate datetime,@CustomerType nvarchar(200)
			 ,@IsAddUp bit, @IsAddLastCount bit,@IsAchIndicator bit
			 ,@ComputeCycle nvarchar(100)
			 ,@Division nvarchar(100)
			 ,@MarketType nvarchar(100)
			 ,@IsIntegral bit
			 ,@IsBundle bit
			 ,@IsAchSpecificInd bit
			 ,@IsAchHosIndicator bit
			 ,@IsAchDealerHosIndicator bit
			 ,@IsReduction bit
			 ,@SuDept nvarchar(200)
	 set @BeginDate=(select BeginDate from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
	 set @CustomerType=(select CustomerType from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
	 set @IsAddUp=(select IsAddUp from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
	 set @IsAddLastCount=(select IsAddLastCount from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
	 set @IsAchIndicator=(select IsAchIndicator from interface.T_I_EW_PromotionRules where PRCode=@PRCode) 
	 set @ComputeCycle=(select ComputeCycle  from interface.T_I_EW_PromotionRules where PRCode=@PRCode) 
	 set @MarketType=(select MarketType from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
	 set @Division=(select Division from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
	 set @IsIntegral=(select IsIntegral from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
	 set @IsBundle=(select IsBundle from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
	 set @IsAchSpecificInd=(Select IsAchSpecificInd  from interface.T_I_EW_PromotionRules where PRCode=@PRCode)  
	 set @IsAchHosIndicator=(Select isnull(IsHosAchIndicator,0)  from interface.T_I_EW_PromotionRules where PRCode=@PRCode)  
	 set @IsAchDealerHosIndicator=(Select isnull(IsDealerHosAchIndicator,0)  from interface.T_I_EW_PromotionRules where PRCode=@PRCode)  
	 set @IsReduction=(Select isnull(IsReduction,0)  from interface.T_I_EW_PromotionRules where PRCode=@PRCode)  
	 set @SuDept=(Select isnull(SubDept,'')  from interface.T_I_EW_PromotionRules where PRCode=@PRCode)  
	 
	 EXEC dbo.GC_Interface_Promotion_Dealers @PRCode
	 EXEC dbo.GC_Interface_Promotion_Product @PRCode,@IsBundle
	 
	 select DealerID,UPN,Transaction_Date,Qty,DMScode,Province,Division,
			SalesType=case SalesType when 'Hospital' then N'批发' else N'寄售' end
			,MarketName=case when MarketProperty=0 then N'红海' when MarketProperty=1 then N'蓝海' else '' end
			,SAPID,ParentSAPID,ParentDealerID,SPH_ShipmentNbr,HOS_City as City
			,FirstShipmentDate=case when
			  @CustomerType=N'首次上报用量时间的医院' then case when
			  ((select ShipmentDate from #first f where f.DealerID=i.DealerID and
			                   f.Division=i.Division and f.Hospital=i.Hospital) between @StartDate and @FinishDate )
			                   then 1 else 0 end
			                   else 1 end
			  --,IsAchIndicator= dbo.GC_Fn_GetIndicator(@IsAchIndicator,SAPID,@ComputeCycle,Division,@FinishDate,@MarketType)      
			  --,IsHosAchIndicator=dbo.GC_Fn_GetHospitalIndicator(@IsAchHosIndicator,SAPID,@ComputeCycle,Division,@FinishDate,isnull(i.DMScode,''))
			  --,IsDelaerHosAchIndicator= dbo.GC_Fn_GetDealerHospitalIndicator(@IsAchDealerHosIndicator,SAPID,@ComputeCycle,Division,@FinishDate)    
			  ,DMA_DealerType
			  ,Invoice
			  into #ips_01
			from interface.V_I_QV_InHospitalSales i(nolock)
			left join V_AllHospitalMarketProperty on DMScode=Hos_Code and DivisionID=DivisionCode
			left join Hospital on Hospital.HOS_Key_Account=DMScode
			left join DealerMaster on DMA_ID=DealerID
			where Transaction_Date>=@StartDate and Transaction_Date<@FinishDate
			
		
--------------------Limiting Conditions----------------------------------------	
	Declare  @SpecificDealers nvarchar(max),@SpecificDealers2 nvarchar(max)
			,@HospitalProvince nvarchar(max),@HospitalProvince2 nvarchar(max)
		    ,@HospitalCity nvarchar(max),@HospitalCity2 nvarchar(max)
			,@HospitalCode nvarchar(max),@HospitalCode2 nvarchar(max)
			,@Sql nvarchar(max)
	
	set @SpecificDealers='('''+(select replace(SpecificDealers,',',''',''') from interface.T_I_EW_PromotionRules where PRCode=@PRCode ) +''')'	
	set @HospitalProvince='('''+(select replace(HospitalProvince,',',''',''') from interface.T_I_EW_PromotionRules where PRCode=@PRCode)+''')'	
	set @HospitalCity='('''+(select replace(HospitalCity,',',''',''') from interface.T_I_EW_PromotionRules where PRCode=@PRCode)+''')'	
	set @HospitalCode='('''+(select replace(HospitalCode,',',''',''') from interface.T_I_EW_PromotionRules where PRCode=@PRCode)+''')'	
    set @SpecificDealers2=(select replace(SpecificDealers,',',''',''') from interface.T_I_EW_PromotionRules where PRCode=@PRCode )	
	set @HospitalProvince2=(select replace(HospitalProvince,',',''',''') from interface.T_I_EW_PromotionRules where PRCode=@PRCode)	
	set @HospitalCity2=(select replace(HospitalCity,',',''',''') from interface.T_I_EW_PromotionRules where PRCode=@PRCode)	
	set @HospitalCode2=(select replace(HospitalCode,',',''',''') from interface.T_I_EW_PromotionRules where PRCode=@PRCode)	
---------------------Specific Dealers------------------------ 
	IF ISNULL(@SpecificDealers2,'')!=''
	Begin
		set @Sql= 'delete #ips_01 where SAPID not in '+@SpecificDealers+'';
		Exec (@Sql)
	ENd
-------------------------适用客户（城市，省，全国，医院)--------------
	IF ISNULL(@HospitalProvince2,'')!=''
	Begin
		set @Sql= 'delete #ips_01 where Province not in '+@HospitalProvince+'';
		Exec (@Sql)
	ENd
    
    IF ISNULL(@HospitalCity2,'')!=''
	Begin
		set @Sql= 'delete #ips_01 where City not in '+@HospitalCity+'';
		Exec (@Sql)
	ENd
	
    IF ISNULL(@HospitalCode2,'')!=''
	Begin
		set @Sql= 'delete #ips_01 where DMScode not in '+@HospitalCode+'';
		Exec (@Sql)
	ENd	
			
	select DealerID,UPN,Transaction_Date,Qty,DMScode,Province,Division,
		SalesType
		,MarketName
		,SAPID,ParentSAPID,ParentDealerID,SPH_ShipmentNbr,City 
		,FirstShipmentDate
		,IsAchIndicator= dbo.GC_Fn_GetIndicator(@IsAchIndicator,SAPID,@ComputeCycle,Division,@FinishDate,@MarketType,@SuDept)      
		,IsHosAchIndicator=dbo.GC_Fn_GetHospitalIndicator(@IsAchHosIndicator,SAPID,@ComputeCycle,Division,@FinishDate,isnull(DMScode,''),@SuDept)
		,IsDelaerHosAchIndicator= dbo.GC_Fn_GetDealerHospitalIndicator(@IsAchDealerHosIndicator,SAPID,@ComputeCycle,Division,@FinishDate,@SuDept)    
		,DMA_DealerType
		,Invoice
		into #ips
	from  #ips_01  	  
	 

	 select
		  PRCode=t.PRCode
		 ,PurchaseQty=
		       case when IsTiersRule=1 then (select PurchaseQty from interface.V_I_EW_PromotionRules a where a.PRCode=t.PRCode
			and ips.IsAchIndicator>=IndicatorRateFrom and ips.IsAchIndicator<IndicatorRateTo)
			else PurchaseQty end
		 ,FreeQty=	
		          case when IsTiersRule=1  then (select FreeQty from interface.V_I_EW_PromotionRules a where a.PRCode=t.PRCode
			and ips.IsAchIndicator>=IndicatorRateFrom and ips.IsAchIndicator<IndicatorRateTo)
			else FreeQty end
		 ,DealerID
		 ,UPN=ips.UPN
		 ,Transaction_Date
		 ,Qty=ips.Qty
		 ,DMScode --Hospital Code
		 ,Province
		 ,Division=ips.Division
		 ,SalesType=ips.SalesType
		 ,MarketName
		 ,SAPID
		 ,ParentSAPID
		 ,ParentDealerID
		 ,SPH_ShipmentNbr
		 ,City
		 ,CreateTime=GETDATE()
		 ,IsAchIndicator=ips.IsAchIndicator
		 ,ProductLineID=t.ProductLineID
		 ,DMA_DealerType
		 ,Tiers=	
		          case when IsTiersRule=1  then (select Tiers from interface.V_I_EW_PromotionRules a where a.PRCode=t.PRCode
			and ips.IsAchIndicator>=IndicatorRateFrom and ips.IsAchIndicator<IndicatorRateTo)
			else NULL end
		  ,Rownumber=0
		  ,Invoice
		 into #tmpips  
	 from #ips ips
		join interface.T_I_EW_PromotionRules t on  t.PRCode=@PRCode 
			 and t.Division=ips.Division
			 and (ips.SalesType=t.ProductSales or t.ProductSales=N'批发,寄售')
			 and MarketName=t.MarketType
		join interface.T_I_EW_PromtionDealers d on d.PRCode=@PRCode and d.DMA_SAP_Code=SAPID
		join interface.T_I_EW_PromotionProduct p on p.PRCode=@PRCode and p.UPN=ips.UPN
		where FirstShipmentDate=1  and ips.IsAchIndicator>=1 and @IsBundle=0 and ips.IsHosAchIndicator >=1 and ips.IsDelaerHosAchIndicator >=1
        
   

                 
	--Bundle	      
	Insert into #tmpips  	      
	 select
		  PRCode=t.PRCode
		 ,PurchaseQty=
		       case when IsTiersRule=1 then (select PurchaseQty from interface.V_I_EW_PromotionRules a where a.PRCode=t.PRCode
			and ips.IsAchIndicator>=IndicatorRateFrom and ips.IsAchIndicator<=IndicatorRateTo)
			else PurchaseQty end
		 ,FreeQty=	
		          case when IsTiersRule=1  then (select FreeQty from interface.V_I_EW_PromotionRules a where a.PRCode=t.PRCode
			and ips.IsAchIndicator>=IndicatorRateFrom and ips.IsAchIndicator<=IndicatorRateTo)
			else FreeQty end
		 ,DealerID
		 ,UPN=ips.UPN
		 ,Transaction_Date
		 ,Qty
		 ,DMScode --Hospital Code
		 ,Province
		 ,Division=ips.Division
		 ,SalesType=ips.SalesType
		 ,MarketName
		 ,SAPID
		 ,ParentSAPID
		 ,ParentDealerID
		 ,SPH_ShipmentNbr
		 ,City
		 ,CreateTime=GETDATE()
		 ,IsAchIndicator=ips.IsAchIndicator
		 ,ProductLineID=t.ProductLineID
		 ,DMA_DealerType
		 ,Tiers=	
		          case when IsTiersRule=1  then (select Tiers from interface.V_I_EW_PromotionRules a where a.PRCode=t.PRCode
			and ips.IsAchIndicator>=IndicatorRateFrom and ips.IsAchIndicator<=IndicatorRateTo)
			else NULL end
		  ,Rownumber=0
		  ,Invoice
	 from #ips ips
		join interface.T_I_EW_PromotionRules t on  t.PRCode=@PRCode 
			 and t.Division=ips.Division
			 and (ips.SalesType=t.ProductSales or t.ProductSales=N'批发,寄售')
			 and MarketName=t.MarketType
		join interface.T_I_EW_PromtionDealers d on d.PRCode=@PRCode and d.DMA_SAP_Code=SAPID
		where FirstShipmentDate=1 and Transaction_Date>=@StartDate and Transaction_Date<@FinishDate
		      and ips.IsAchIndicator>=1 and @IsBundle=1 and ips.IsHosAchIndicator>=1 and ips.IsDelaerHosAchIndicator>=1
		        
	
		      
		select p.*
		--,ROW_NUMBER() over (order by p.Qty) as rownumber 
		      into #Product from interface.T_I_EW_PromotionProduct p
		      join #tmpips i on isnull(i.Tiers,0)=isnull(p.Tiers,0) and i.UPN=p.UPN
		      where p.PRCode=@PRCode and @IsBundle=1
		Declare @Count int,@PCount int
		set @Count=1
		set @PCount=(select count(distinct Rownumber) from #Product)
		while @Count<=@PCount
		      begin
		          Insert into #tmpips
		          select   [PRCode]=ips.PRCode
						  ,[PurchaseQty]=p.Qty
						  ,[FreeQty]
						  ,[DealerID]
						  ,ips.[UPN]
						  ,[Transaction_Date]
						  ,[Qty]=ips.Qty
						  ,[DMScode]
						  ,[Province]
						  ,[Division]
						  ,[SalesType]
						  ,[MarketName]
						  ,[SAPID]
						  ,[ParentSAPID]
						  ,[ParentDealerID]
						  ,[SPH_ShipmentNbr]
						  ,[City]
						  ,ips.[CreateTime]
						  ,[IsAchIndicator]
						  ,[ProductLineID]
						  ,[DMA_DealerType] 
						  ,Tiers=ips.Tiers
						  ,RowNumber=@Count
						  ,Invoice
				  from #tmpips ips
		          join #Product p on  p.UPN=ips.UPN
		           --and @Count=rownumber
		           --and ips.Tiers=p.Tiers
		        
		       set @Count=@Count+1
		      end
		      
Delete from #tmpips where RowNumber=0 and @IsBundle=1 

--Filter not match bundle
select * into #p from (
select DealerId,count(RowNumber) as RowNumber from #tmpips
group by DealerId) as a where RowNumber<>@PCount and @IsBundle=1

Delete from #tmpips where DealerId in (select DealerId from #p) 

	

 ----------------Minus Free Goods Quantity-------------
  --   select 
  --        PRCode  
  --       ,PurchaseQty
		-- ,FreeQty
		-- ,DealerID=a.DealerID
		-- ,UPN=a.UPN
		-- ,Qty=case when a.qty>=ISNULL(FreeGoods.qty,0)
		--       then  a.qty-ISNULL(FreeGoods.qty,0) else 0 end
		-- ,Division
		-- ,SAPID
		-- ,ParentSAPID
		-- ,ParentDealerID
		-- ,DMA_DealerType  
		-- into #bscsale  
	 -- from 
		--( select  
		--	  PRCode
		--	 ,PurchaseQty
		--	 ,FreeQty
		--	 ,DealerID
		--	 ,UPN
		--	 ,Qty=sum(Qty)
		--	 ,Division
		--	 ,SAPID
		--	 ,ParentSAPID
		--	 ,ParentDealerID
		--	 ,DMA_DealerType  
		--	from  #tmpips
		--		  group by PRCode
		--				 ,PurchaseQty
		--				 ,FreeQty
		--				 ,DealerID
		--				 ,UPN ,Division
		--				 ,SAPID
		--				 ,ParentSAPID 
		--				 ,ParentDealerID
		--				 ,DMA_DealerType) as a 
		--left join 
		--  (select UPN, DealerID,SUM(QTY) as QTY 
		--	 from interface.V_I_EW_BSCSales_FreeGoods
		--	 where Transaction_Date>=@StartDate and Transaction_Date<@FinishDate
		--	      and Division=@Division
		--	 group by UPN, DealerID
  --          ) as FreeGoods
  --      on a.DealerID=FreeGoods.DealerID and a.UPN=FreeGoods.UPN


 select * into #bscsales from #tmpips 
-- where  [dbo].[GC_Fn_GetICPurchaseIndicator](@IsAchSpecificInd,DealerID ,@ComputeCycle ,@Division,@FinishDate ,@MarketType ,@StartDate)=1
 
---Log
Insert into Promotion_InHospitalSalesLog select * from #bscsales 




-----------------Calculate Free Qty, Note:IsTiers----------------------- 
		 select 
			PRCode,DealerID,PurchaseQty,FreeQty,
			ShipmentQty,
			AvaliableQty=case when @IsIntegral=0 then ShipmentQty/PurchaseQty*FreeQty
			             else convert(decimal(18,1),ShipmentQty)/PurchaseQty*FreeQty end
			,NotUsedQty=case when @IsIntegral=0 then
				                     case when ShipmentQty>=PurchaseQty then ShipmentQty%PurchaseQty	
				                     else ShipmentQty end
				                     else 0 end
            ,CreateTime=GETDATE()
            ,DType='T1'
            ,ParentDealerID
            ,RNo=0
            ,Tiers
			into #ts 
		from
			(
			select PRCode,DealerID,convert(int,SUM(Qty)) as ShipmentQty,PurchaseQty,FreeQty,ParentDealerID,Tiers from #bscsales
			where DMA_DealerType='T1' 
			group by PRCode,DealerID,PurchaseQty,FreeQty,ParentDealerID,Tiers
			
			) as s 
	
		Insert into #ts		
	     select 
				PRCode,DealerID,PurchaseQty,FreeQty
			   ,ShipmentQty
			   ,AvaliableQty=case when @IsIntegral=0 then ShipmentQty/PurchaseQty*FreeQty
							 else convert(decimal(18,1),ShipmentQty)/PurchaseQty*FreeQty end
				,NotUsedQty=case when @IsIntegral=0 then
				                     case when ShipmentQty>=PurchaseQty then ShipmentQty%PurchaseQty	
				                     else ShipmentQty end
				                     else 0 end
                 ,CreateTime=GETDATE() 
                 ,DType='T2'
                 ,ParentDealerID
                 ,RNo=0
                 ,Tiers
		 from
				(
				select PRCode,DealerID,
					ParentDealerID=case when ParentSAPID='BSC' then DealerID else ParentDealerID end,
					convert(int,SUM(Qty)) as ShipmentQty,PurchaseQty,FreeQty,Tiers  from #bscsales
					where DMA_DealerType in ('LP','T2') 
					group by PRCode,DealerID,ParentDealerID,PurchaseQty,FreeQty,ParentSAPID,Tiers
				) as s 	
			--group by PRCode,DealerID,PurchaseQty,FreeQty
			
 ---Bundle	
		Insert into #ts	
	    select 	 
	             PRCode
				,DealerID
				,PurchaseQty
				,FreeQty
				,ShipmentQty
				,AvaliableQty
				,NotUsedQty
				,CreateTime
				,DType
				,ParentDealerID
				,RNo= row_number() OVER (partition  by DealerID ORDER BY AvaliableQty)
				,Tiers
				 from #ts where @IsBundle=1
		Delete #ts where RNO<>1 and @IsBundle=1	 
	
	---Log	
	select * into #P2 from (
	 select DealerID,AvaliableQty,NotUsedQty
	        ,RowNumber=row_number() over(partition by DealerID order by CreateTime desc)
	        from PromotionPolicyForT2
	 where PRCode=@PRCode) b where RowNumber=1
	
	---累计余量时候不能选择积分制度，所以可用数量为整数
		Insert into PromotionPolicyForT2
		select 
			 PRCode=a.PRCode
			 ,DealerID=a.DealerID
			 ,PurchaseQty=a.PurchaseQty
			 ,FreeQty=a.FreeQty
			 ,ShipmentQty=a.ShipmentQty
			 ,AvaliableQty=convert(int,(a.ShipmentQty+ISNULL(b.NotUsedQty,0)-isnull(b.AvaliableQty,0))/a.PurchaseQty)*a.FreeQty
			 ,NotUsedQty=case when  (a.ShipmentQty+ISNULL(b.NotUsedQty,0)-isnull(b.AvaliableQty,0))>=a.PurchaseQty
			                       then convert(int,(a.ShipmentQty+ISNULL(b.NotUsedQty,0)-isnull(b.AvaliableQty,0))%a.PurchaseQty)
			                       else  (a.ShipmentQty+ISNULL(b.NotUsedQty,0)-isnull(b.AvaliableQty,0)) end
			             
			 ,CreateTime=GETDATE()
			 ,DType=a.DType  
			 ,ParentDealerID=a.ParentDealerID 		  
			 ,AdjustQty=0.0
			 ,AdjustRemark=NULL
			 ,AdjustUserId=null
			 ,UpdateTime=getdate()
			 ,PM_Id=NewID()
			 ,Tiers=a.Tiers
			 ,LastAvaliableQty=b.AvaliableQty
			 ,LimitQty=null
			 ,TotalLimitQty=null   
		  from #ts a 
		  left join #P2 b on a.DealerID=b.DealerID
		  where @IsAddLastCount=1  and @IsReduction=1
		  
	Insert into PromotionPolicyForT2
		select 
			 PRCode=a.PRCode
			 ,DealerID=a.DealerID
			 ,PurchaseQty=a.PurchaseQty
			 ,FreeQty=a.FreeQty
			 ,ShipmentQty=a.ShipmentQty
			 ,AvaliableQty=convert(int,(a.ShipmentQty+ISNULL(b.NotUsedQty,0))/a.PurchaseQty)*a.FreeQty
			 ,NotUsedQty=case when  (a.ShipmentQty+ISNULL(b.NotUsedQty,0))>=a.PurchaseQty
			                       then convert(int,(a.ShipmentQty+ISNULL(b.NotUsedQty,0))%a.PurchaseQty)
			                       else  (a.ShipmentQty+ISNULL(b.NotUsedQty,0)) end
			             
			 ,CreateTime=GETDATE()
			 ,DType=a.DType  
			 ,ParentDealerID=a.ParentDealerID 		  
			 ,AdjustQty=0.0
			 ,AdjustRemark=NULL
			 ,AdjustUserId=null
			 ,UpdateTime=getdate()
			 ,PM_Id=NewID()
			 ,Tiers=a.Tiers
			 ,LastAvaliableQty=b.AvaliableQty
			 ,LimitQty=null
			 ,TotalLimitQty=null   
		  from #ts a 
		  left join #P2 b on a.DealerID=b.DealerID
		  where @IsAddLastCount=1  and @IsReduction=0
		
		Insert into PromotionPolicyForT2
		select 
			 PRCode=a.PRCode
			 ,DealerID=a.DealerID
			 ,PurchaseQty=a.PurchaseQty
			 ,FreeQty=a.FreeQty
			 ,ShipmentQty=a.ShipmentQty
			 ,AvaliableQty=convert(int,(a.ShipmentQty-isnull(b.AvaliableQty,0))/a.PurchaseQty)*a.FreeQty
			 ,NotUsedQty=case when  (a.ShipmentQty-isnull(b.AvaliableQty,0))>=a.PurchaseQty
			                       then convert(int,(a.ShipmentQty-isnull(b.AvaliableQty,0))%a.PurchaseQty)
			                       else  (a.ShipmentQty -isnull(b.AvaliableQty,0)) end
			             
			 ,CreateTime=GETDATE()
			 ,DType=a.DType  
			 ,ParentDealerID=a.ParentDealerID 		  
			 ,AdjustQty=0.0
			 ,AdjustRemark=NULL
			 ,AdjustUserId=null
			 ,UpdateTime=getdate()
			 ,PM_Id=NewID()
			 ,Tiers=a.Tiers
			 ,LastAvaliableQty=b.AvaliableQty
			 ,LimitQty=null
			 ,TotalLimitQty=null   
		  from #ts a 
		  left join #P2 b on a.DealerID=b.DealerID
		  where @IsAddLastCount=0  and @IsReduction=1
			
		 Insert into PromotionPolicyForT2
		 select 
				 PRCode
				,DealerID=a.DealerID
				,PurchaseQty=a.PurchaseQty
				,FreeQty=a.FreeQty
				,ShipmentQty=a.ShipmentQty
				,AvaliableQty=convert(int,a.ShipmentQty)/a.PurchaseQty*a.FreeQty
				,NotUsedQty=a.NotUsedQty
				,CreateTime=GETDATE() 
				,DType=a.DType  
				,ParentDealerID=a.ParentDealerID 
				,AdjustQty=0.0
				,AdjustRemark=NULL
				,AdjustUserId=null
				,UpdateTime=getdate()
				,PM_Id=NewID() 
				,Tiers=a.Tiers
			    ,LastAvaliableQty=b.AvaliableQty
			    ,LimitQty=null
			    ,TotalLimitQty=null      
			from #ts a 
			left join #P2 b on a.DealerID=b.DealerID
			where @IsAddLastCount=0 and @IsReduction=0

			
	---Write in the [PromotionPlocliy] table----
	select * into #final from 
	(
		 select 
			  PRCode
			 ,DealerId=ParentDealerID
			 ,AvaliableQty=SUM(AvaliableQty)
		  from PromotionPolicyForT2
		  where PRCode=@PRCode and DType='T2' and CreateTime>=CONVERT(date,getdate()) 
			    group by PRCode,ParentDealerID
	     union all
		 select 
			  PRCode
			 ,DealerId
			 ,AvaliableQty
		  from PromotionPolicyForT2
		  where PRCode=@PRCode and DType<>'T2' and CreateTime>=CONVERT(date,getdate())
	 ) as final  where AvaliableQty>0

	 Insert into [PromotionPolicy]
	 select 
		   [PMP_ID]=NEWID()
		  ,[PMP_Code]=i.PRCode
		  ,[Content]
		  ,[DMAID]=DealerID
		  ,[Division]
		  ,[ProductLine]
		  ,[ComputeCycle]
		  ,[PurchaseQty]=i.PurchaseQty
		  ,[FreeQty]=i.FreeQty
		  ,[ClearQty]=0
		  ,[AdjustQty]=0
		  ,[AdjustRemark]=NULL
		  ,[AvaliableQty]=AvaliableQty
		  ,[BeginDate]
		  ,[EndDate]
		  ,[CreateTime]=GETDATE()
		  ,[UpdateTime]=GETDATE()
		  ,[PromotionType]
		  ,[UPN]=LevelCode
		  ,[IsDeleted]=0
		  ,ProductLineId
		  ,IsApproved='Submitted'
		  ,PRName
		  ,AdjustUserId=NULL
		  ,AdjustQtyForT2=NULL
	  from interface.T_I_EW_PromotionRules i
	      join #final f on f.PRCode=i.PRCode
    
    
	
----------Clear temporary table----------------
    drop table #tmpips
    drop table #ts
	drop table #first
	drop table #final
	--drop table #Policy

-------End-------------------
 

GO


