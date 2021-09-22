DROP  proc [dbo].[GC_Interface_Promotion_BSCSales]
GO



CREATE proc [dbo].[GC_Interface_Promotion_BSCSales](@PRCode nvarchar(200),
@StartDate nvarchar(100),@FinishDate nvarchar(100))
as

-------Calculate Comercial Sales-------------

	   
	 Declare  @BeginDate datetime,@SalesType nvarchar(200)
	         --,@IsAddUp bit
	         ,@IsAddLastCount bit
	         ,@IsAchIndicator bit,@ComputeCycle nvarchar(100)
	         ,@Division nvarchar(100),@MarketType nvarchar(100)
	         ,@IsIntegral bit
			 ,@IsBundle bit
			 ,@IsAchSpecificInd bit
			 ,@ProductSales nvarchar(30)
			 ,@IsAchHosIndicator bit
			 ,@IsAchDealerHosIndicator bit
			 ,@IsReduction bit
			 ,@SuDept nvarchar(200)
	 set @BeginDate=(select BeginDate from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
	 set @SalesType=(select SalesType from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
	 --set @IsAddUp=(select IsAddUp from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
	 set @IsAddLastCount=(select IsAddLastCount from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
	 set @IsAchIndicator=(select IsAchIndicator from interface.T_I_EW_PromotionRules where PRCode=@PRCode) 
	 set @ComputeCycle=(select ComputeCycle  from interface.T_I_EW_PromotionRules where PRCode=@PRCode) 
	 set @Division=(select Division from interface.T_I_EW_PromotionRules where PRCode=@PRCode) 
	 set @MarketType=(select MarketType from interface.T_I_EW_PromotionRules where PRCode=@PRCode) 
	 set @IsIntegral=(select IsIntegral from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
	 set @IsBundle=(select IsBundle from interface.T_I_EW_PromotionRules where PRCode=@PRCode) 
	 set @IsAchSpecificInd=(Select IsAchSpecificInd  from interface.T_I_EW_PromotionRules where PRCode=@PRCode) 
	 set @ProductSales=(Select ProductSales  from interface.T_I_EW_PromotionRules where PRCode=@PRCode) 
	 
	 set @IsAchDealerHosIndicator=(Select isnull(IsDealerHosAchIndicator,0)  from interface.T_I_EW_PromotionRules where PRCode=@PRCode)  
	 set @IsReduction=(Select isnull(IsReduction,0)  from interface.T_I_EW_PromotionRules where PRCode=@PRCode)  
	 set @SuDept=(Select isnull(SubDept,'')  from interface.T_I_EW_PromotionRules where PRCode=@PRCode)   
	 
	 EXEC dbo.GC_Interface_Promotion_Dealers @PRCode
	 EXEC dbo.GC_Interface_Promotion_Product @PRCode,@IsBundle
	 select PRCode=t.PRCode
			 ,PurchaseQty
			 ,FreeQty 
			 ,DealerID
			 ,UPN=bs.UPN
			 ,Transaction_Date
			 ,Qty=bs.QTY
			 ,Division=bs.Division
			 ,SAPID
			 ,ParentSAPID
			 ,ParentDealerID
			 ,NBR
			 ,CreateTime=GETDATE()
			 --,AchIndicator= dbo.GC_Fn_GetIndicator(IsAchIndicator,SAPID,ComputeCycle,t.Division,@FinishDate,MarketType) 
			 ,IsTiersRule into #Temp1
			from [interface].[V_I_EW_BSCSales] bs	  
			join interface.T_I_EW_PromotionRules t on  t.Division=bs.Division  and t.PRCode=@PRCode
			join interface.T_I_EW_PromtionDealers d on d.DMA_SAP_Code=SAPID and d.PRCode=@PRCode
			join interface.T_I_EW_PromotionProduct p on p.PRCode=@PRCode and p.UPN=bs.UPN
			where ParentSAPID='BSC' and @SalesType=N'波科发货'  and Transaction_Date between @StartDate and @FinishDate
	 
	  select
			  PRCode=t.PRCode
			 ,PurchaseQty
			 ,FreeQty 
			 ,DealerID=dm.DMA_ID
			 ,UPN=bs.UPN
			 ,Transaction_Date=TransactionDate
			 ,Qty=bs.Qty
			 ,Division=bs.Division
			 ,SAPID
			 ,ParentSAPID
			 ,ParentDealerID=dp.DMA_ID
			 ,NBR
			 ,CreateTime=GETDATE()
			 --,AchIndicator= dbo.GC_Fn_GetIndicator(IsAchIndicator,SAPID,ComputeCycle,t.Division,@FinishDate,t.MarketType) 
			 ,IsTiersRule
			 ,SalesType2=Case bs.SalesType when 'Normal' then '批发' when 'Consignment' then '寄售'
			  else '' end 
			  into #Temp2
			from interface.T_I_QV_LPSales(nolock) bs	 
				join interface.T_I_EW_PromotionRules t on  t.Division=bs.Division  and t.PRCode=@PRCode
				join interface.T_I_EW_PromtionDealers d on d.DMA_SAP_Code=SAPID and d.PRCode=@PRCode
				join interface.T_I_EW_PromotionProduct p on p.PRCode=@PRCode and p.UPN=bs.UPN
				join DealerMaster dm on dm.DMA_SAP_Code=SAPID
				join DealerMaster dp on ParentSAPID=dp.DMA_SAP_Code
			where 
			       bs.SalesType in ('Normal','Consignment') and @SalesType=N'平台销售到二级'
				  and TransactionDate between @StartDate and @FinishDate
				  and bs.MarketType=t.MarketType
				  
	 --------------------Filter data by Specific Distributor----------------------------------------	
	Declare @SpecificDealers nvarchar(max),@Sql nvarchar(max)
	
	,@SpecificDealers2 nvarchar(max)
	
	set @SpecificDealers='('''+(select replace(SpecificDealers,',',''',''') from interface.T_I_EW_PromotionRules where PRCode=@PRCode ) +''')'	

	set @SpecificDealers2=(select replace(SpecificDealers,',',''',''') from interface.T_I_EW_PromotionRules where PRCode=@PRCode )	
	
	IF ISNULL(@SpecificDealers2,'')!='' and @SalesType=N'平台销售到二级'
	Begin
	set @Sql= 'delete #Temp2 where SAPID not in '+@SpecificDealers+'';
	Exec (@Sql)
	End
	
	
	 select PRCode
			 ,PurchaseQty
			 ,FreeQty 
			 ,DealerID
			 ,UPN
			 ,Transaction_Date
			 ,Qty
			 ,Division
			 ,SAPID
			 ,ParentSAPID
			 ,ParentDealerID
			 ,NBR
			 ,CreateTime
			 ,AchIndicator= dbo.GC_Fn_GetIndicator(@IsAchIndicator,SAPID,@ComputeCycle,Division,@FinishDate,@MarketType,@SuDept)    
			 ,DelaerHosAchIndicator= dbo.GC_Fn_GetDealerHospitalIndicator(@IsAchDealerHosIndicator,SAPID,@ComputeCycle,Division,@FinishDate,@SuDept)    
			 ,IsTiersRule 
			 into #Temp1_use
			 from  #Temp1
	
	  select
			  PRCode
			 ,PurchaseQty
			 ,FreeQty 
			 ,DealerID
			 ,UPN
			 ,Transaction_Date
			 ,Qty
			 ,Division
			 ,SAPID
			 ,ParentSAPID
			 ,ParentDealerID
			 ,NBR
			 ,CreateTime
			 ,AchIndicator= dbo.GC_Fn_GetIndicator(@IsAchIndicator,SAPID,@ComputeCycle,Division,@FinishDate,@MarketType,@SuDept)   
			 ,DelaerHosAchIndicator= dbo.GC_Fn_GetDealerHospitalIndicator(@IsAchDealerHosIndicator,SAPID,@ComputeCycle,Division,@FinishDate,@SuDept) 
			 ,IsTiersRule
			 ,SalesType2
			  into #Temp2_use
			 from  #Temp2
	
	 select  
	         PRCode
			,PurchaseQty=
				   case when IsTiersRule=1 then (select PurchaseQty 
				        from interface.V_I_EW_PromotionRules a where a.PRCode=Sales.PRCode
				             and AchIndicator>=IndicatorRateFrom and AchIndicator<=IndicatorRateTo)
				        else PurchaseQty end
			 ,FreeQty=	
					  case when IsTiersRule=1 then (select FreeQty 
					       from interface.V_I_EW_PromotionRules a where a.PRCode=Sales.PRCode
				                 and AchIndicator>=IndicatorRateFrom and AchIndicator<=IndicatorRateTo)
				           else FreeQty end
			 ,DealerID
			 ,UPN
			 ,Transaction_Date
			 ,Qty
			 ,Division
			 ,SAPID
			 ,ParentSAPID
			 ,ParentDealerID
			 ,NBR
			 ,CreateTime
		     ,Tiers=	
		          case when IsTiersRule=1  then (select Tiers 
					       from interface.V_I_EW_PromotionRules a where a.PRCode=Sales.PRCode
				                 and AchIndicator>=IndicatorRateFrom and AchIndicator<=IndicatorRateTo)
			else NULL end
		    ,Rownumber=0
		    ,AchIndicator
			 into #sales from #Temp1_use as Sales
	   where AchIndicator>=1 and DelaerHosAchIndicator>=1 and @IsBundle=0
     
        
       INSert into #sales 
	   select  
	         PRCode=PRCode
			,PurchaseQty=
				   case when IsTiersRule=1 then (select PurchaseQty 
				        from interface.V_I_EW_PromotionRules a where a.PRCode=Sales.PRCode
				             and AchIndicator>=IndicatorRateFrom and AchIndicator<=IndicatorRateTo)
				        else PurchaseQty end
			 ,FreeQty=	
					  case when IsTiersRule=1 then (select FreeQty 
					       from interface.V_I_EW_PromotionRules a where a.PRCode=Sales.PRCode
				                and AchIndicator>=IndicatorRateFrom and AchIndicator<=IndicatorRateTo)
				           else FreeQty end
			 ,DealerID
			 ,UPN
			 ,Transaction_Date
			 ,Qty
			 ,Division
			 ,SAPID
			 ,ParentSAPID
			 ,ParentDealerID
			 ,NBR
			 ,CreateTime
		     ,Tiers=	
		          case when IsTiersRule=1  then (select Tiers 
					       from interface.V_I_EW_PromotionRules a where a.PRCode=Sales.PRCode
				                 and AchIndicator>=IndicatorRateFrom and AchIndicator<=IndicatorRateTo)
			else NULL end
		    ,Rownumber=0
		    ,AchIndicator
	  from #Temp2_use as Sales
     where AchIndicator>=1  and DelaerHosAchIndicator>=1 and @IsBundle=0  and (SalesType2=@ProductSales or @ProductSales='批发,寄售')	    

----Bundle---------
   INSert into #sales 
	 select  
	         PRCode
			,PurchaseQty=
				   case when IsTiersRule=1 then (select PurchaseQty 
				        from interface.V_I_EW_PromotionRules a where a.PRCode=Sales.PRCode
				             and AchIndicator>=IndicatorRateFrom and AchIndicator<=IndicatorRateTo)
				        else PurchaseQty end
			 ,FreeQty=	
					  case when IsTiersRule=1 then (select FreeQty 
					       from interface.V_I_EW_PromotionRules a where a.PRCode=Sales.PRCode
				                 and AchIndicator>=IndicatorRateFrom and AchIndicator<=IndicatorRateTo)
				           else FreeQty end
			 ,DealerID
			 ,UPN
			 ,Transaction_Date
			 ,Qty
			 ,Division
			 ,SAPID
			 ,ParentSAPID
			 ,ParentDealerID
			 ,NBR
			 ,CreateTime
		     ,Tiers=	
		          case when IsTiersRule=1  then (select Tiers 
					       from interface.V_I_EW_PromotionRules a where a.PRCode=Sales.PRCode
				                 and AchIndicator>=IndicatorRateFrom and AchIndicator<=IndicatorRateTo)
			else NULL end
		    ,Rownumber=0
		    ,AchIndicator
	 from #Temp1_use as Sales
	   where AchIndicator>=1  and DelaerHosAchIndicator>=1 and @IsBundle=1
     
        
       INSert into #sales 
	   select  
	         PRCode=PRCode
			,PurchaseQty=
				   case when IsTiersRule=1 then (select PurchaseQty 
				        from interface.V_I_EW_PromotionRules a where a.PRCode=Sales.PRCode
				             and AchIndicator>=IndicatorRateFrom and AchIndicator<=IndicatorRateTo)
				        else PurchaseQty end
			 ,FreeQty=	
					  case when IsTiersRule=1 then (select FreeQty 
					       from interface.V_I_EW_PromotionRules a where a.PRCode=Sales.PRCode
				                and AchIndicator>=IndicatorRateFrom and AchIndicator<=IndicatorRateTo)
				           else FreeQty end
			 ,DealerID
			 ,UPN
			 ,Transaction_Date
			 ,Qty
			 ,Division
			 ,SAPID
			 ,ParentSAPID
			 ,ParentDealerID
			 ,NBR
			 ,CreateTime
		     ,Tiers=	
		          case when IsTiersRule=1  then (select Tiers 
					       from interface.V_I_EW_PromotionRules a where a.PRCode=Sales.PRCode
				                 and AchIndicator>=IndicatorRateFrom and AchIndicator<=IndicatorRateTo)
			else NULL end
		    ,Rownumber=0
		    ,AchIndicator
	  from #Temp2_use  as Sales
     where AchIndicator>=1 and DelaerHosAchIndicator>=1  and @IsBundle=1 and (SalesType2=@ProductSales or @ProductSales='批发,寄售')	    
     
     		      
		select p.*
		      into #Product from interface.T_I_EW_PromotionProduct p
		      join #sales i on isnull(i.Tiers,0)=isnull(p.Tiers,0)
		      where p.PRCode=@PRCode and @IsBundle=1
		Declare @Count int,@PCount int
		set @Count=1
		set @PCount=(select count(distinct Rownumber) from #Product)
		while @Count<=@PCount
		      begin
		          Insert into #sales
		          select   [PRCode]=ips.PRCode
						  ,[PurchaseQty]=Qty
						  ,[FreeQty]
						  ,[DealerID]
						  ,[UPN]
						  ,[Transaction_Date]
						  ,[Qty]
						  ,[DMScode]
						  ,[Division]
						  ,[SAPID]
						  ,[ParentSAPID]
						  ,[ParentDealerID]
						  ,NBR
						  ,[CreateTime]
						  ,[ProductLineID]
						  ,Tiers=ips.Tiers
						  ,RowNumber=@Count
						  ,AchIndicator
				  from #sales ips
		           join #Product p on  p.UPN=ips.UPN 
		           --and @Count=rownumber
		           --and ips.Tiers=p.Tiers
		        
		       set @Count=@Count+1
		      end
      
Delete from #sales where RowNumber=0 and @IsBundle=1 

--Filter not match bundle
select * into #p from (
select DealerId,count(RowNumber) as RowNumber from #sales
group by DealerId) as a where RowNumber<>@PCount and @IsBundle=1

Delete from #sales where DealerId in (select DealerId from #p) 

 ----------------Minus Free Goods Quantity-------------
 
 

	
	--select * into #bscsaleold from #sales
	--where [dbo].[GC_Fn_GetICPurchaseIndicator](@IsAchSpecificInd,
 --                DealerID ,@ComputeCycle ,@Division,@FinishDate
 --                ,@MarketType ,@StartDate)=1
                 
     select * into #bscsale from #sales
     --where [dbo].[GC_Fn_GetInterfaceIndicator](@PRCode,DealerID,@ComputeCycle,
     --             @Division,@FinishDate,@MarketType)=1   
     
	
	---Log Deatial Sales (include free goods)
	Insert into Promotion_BSCSalesLog select * from #bscsale
	--select * into Promotion_BSCSalesLog from #bscsale 

	
    ------Calculate Free Qty------ 
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
            ,ParentDealerID 
            ,DType='T1&LP'
            ,RNo=0
            ,Tiers
			into #ts 
		from
			(
				select PRCode,DealerID,ParentDealerID,SUM(convert(int,Qty)) as ShipmentQty,PurchaseQty,FreeQty,Tiers  from #bscsale
				group by PRCode,DealerID,PurchaseQty,FreeQty,ParentDealerID,Tiers
			) as s 
	   where @SalesType=N'波科发货'


	
	
    Insert into #ts
	select 
			PRCode,DealerID,PurchaseQty,FreeQty,ShipmentQty,
			AvaliableQty=case when @IsIntegral=0 then ShipmentQty/PurchaseQty*FreeQty
			             else convert(decimal(18,1),ShipmentQty)/PurchaseQty*FreeQty end
		   ,NotUsedQty=case when @IsIntegral=0 then
				                     case when ShipmentQty>=PurchaseQty then ShipmentQty%PurchaseQty	
				                     else ShipmentQty end
				                     else 0 end
            ,CreateTime=GETDATE() 
            ,ParentDealerID
            ,DType='T2'
            ,RNo=0
            ,Tiers
	   from
			(
			  select PRCode,DealerID,ParentDealerID,SUM(convert(int,Qty)) as ShipmentQty,PurchaseQty,FreeQty,Tiers 
			  from #bscsale
			       group by PRCode,DealerID,ParentDealerID,PurchaseQty,FreeQty,Tiers
			) as s 
	    where 
			@SalesType=N'平台销售到二级'         	
	
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
	
	---Log T2 Info 
		select * into #P2 from (
	 select DealerID,AvaliableQty,NotUsedQty
	        ,RowNumber=row_number() over(partition by DealerID order by CreateTime desc)
	        from PromotionPolicyForT2
	 where PRCode=@PRCode) b where RowNumber=1
	 
	 ---用余量不能用积分制
		Insert into PromotionPolicyForT2
		select 
			 PRCode=a.PRCode
			 ,DealerID=a.DealerID
			 ,PurchaseQty=a.PurchaseQty
			 ,FreeQty=a.FreeQty
			 ,ShipmentQty=a.ShipmentQty
			 ,AvaliableQty=convert(int,(a.ShipmentQty+ISNULL(b.NotUsedQty,0)-ISNULL(b.AvaliableQty,0))/a.PurchaseQty)*a.FreeQty
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
		  where @IsAddLastCount=1 and @IsReduction=1
		  
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
		  where @IsAddLastCount=1 and @IsReduction=0
		  

		 Insert into PromotionPolicyForT2
		 select 
				 PRCode
			    ,DealerID=a.DealerID
			    ,PurchaseQty=a.PurchaseQty
			    ,FreeQty=a.FreeQty
			    ,ShipmentQty=a.ShipmentQty
				,AvaliableQty=convert(int,(a.ShipmentQty-ISNULL(b.AvaliableQty,0))/a.PurchaseQty)*a.FreeQty
				,NotUsedQty=case when  (a.ShipmentQty-isnull(b.AvaliableQty,0))>=a.PurchaseQty
			                       then convert(int,(a.ShipmentQty-isnull(b.AvaliableQty,0))%a.PurchaseQty)
			                       else  (a.ShipmentQty-isnull(b.AvaliableQty,0)) end
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
			where @IsAddLastCount=0 and @IsReduction=1
			
			 Insert into PromotionPolicyForT2
		 select 
				 PRCode
			    ,DealerID=a.DealerID
			    ,PurchaseQty=a.PurchaseQty
			    ,FreeQty=a.FreeQty
			    ,ShipmentQty=a.ShipmentQty
				,AvaliableQty=convert(int,(a.ShipmentQty))/a.PurchaseQty*a.FreeQty
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
	 ) as final
	 where  AvaliableQty>0
	 
	 
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
		  ,[FreeQty]=AvaliableQty
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

  --  select * into #Policy from (
  --    select DMAID,IsDeleted,AvaliableQty,
  --    row_number() over(Partition by DMAID,IsDeleted order by CreateTime desc ) 
  --   as Rownumber  from PromotionPolicy where PMP_Code=@PRCode 
  --) a where Rownumber=1
		   
 
---------Clear temporary table--------------------
	drop table #sales
	drop table #bscsale
 	drop table #ts
 	drop table #final
	--drop table #Policy
----------End-------------------------------------
 


GO


