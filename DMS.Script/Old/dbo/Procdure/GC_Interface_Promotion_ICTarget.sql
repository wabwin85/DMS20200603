DROP proc [dbo].[GC_Interface_Promotion_ICTarget]
GO






--exec [dbo].[GC_Interface_Promotion_ICTarget] 'IC-PRO-2015-0002','2014-01-01','2015-05-01'
--Update [interface].[T_I_QV_ICTarget]-- PRCode
CREATE proc [dbo].[GC_Interface_Promotion_ICTarget] (@PRCode nvarchar(200),
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
	 	 
	 EXEC dbo.GC_Interface_Promotion_Dealers @PRCode
	 EXEC dbo.GC_Interface_Promotion_Product @PRCode,@IsBundle
	 

	   select  
	         PRCode=PRCode
			,PurchaseQty=
				   case when IsTiersRule=1 then (select PurchaseQty 
				        from interface.V_I_EW_PromotionRules a where a.PRCode=Sales.PRCode
				             and AchIndicator>=IndicatorRateFrom and AchIndicator<IndicatorRateTo)
				        else PurchaseQty end
			 ,FreeQty=	
					  case when IsTiersRule=1 then (select FreeQty 
					       from interface.V_I_EW_PromotionRules a where a.PRCode=Sales.PRCode
				                and AchIndicator>=IndicatorRateFrom and AchIndicator<IndicatorRateTo)
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
				                 and AchIndicator>=IndicatorRateFrom and AchIndicator<IndicatorRateTo)
			      else NULL end
		    ,Rownumber=0
		    ,AchIndicator
		    into #sales 
		    
	  from (
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
			,AchIndicator= dbo.GC_Fn_GetIndicator(IsAchIndicator,SAPID,ComputeCycle,t.Division,@FinishDate,t.MarketType) 
			 ,IsTiersRule
			 ,SalesType2=Case bs.SalesType when 'Normal' then '批发' when 'Consignment' then '寄售'
			  else '' end			 
			from interface.T_I_QV_LPSales(nolock) bs	 
				join interface.T_I_EW_PromotionRules t on  t.Division=bs.Division  and t.PRCode=@PRCode
				join interface.T_I_EW_PromtionDealers d on d.DMA_SAP_Code=SAPID and d.PRCode=@PRCode
				join interface.T_I_EW_PromotionProduct p on p.PRCode=@PRCode and p.UPN=bs.UPN
				join DealerMaster dm on dm.DMA_SAP_Code=SAPID
				join DealerMaster dp on ParentSAPID=dp.DMA_SAP_Code
			where bs.SalesType in ('Normal','Consignment') and t.SalesType=N'平台销售到二级'
				  and TransactionDate between @StartDate and @FinishDate
				  and bs.MarketType=t.MarketType
        ) as Sales
     where AchIndicator>=1 --Need
     and (SalesType2=@ProductSales or @ProductSales='批发,寄售')
     
     select a.* into #tms from #sales a
     --join interface.T_I_QV_ICTarget i 
     --on a.PRCode=i.PRCode and a.SAPID=i.SAPID	
         
	Insert into Promotion_BSCSalesLog select * from #tms

		select PRCode,DealerID,SAPID, ParentDealerID,SUM(convert(int,Qty)) as ShipmentQty,PurchaseQty,FreeQty,Tiers
		into #bs 
		from #tms
		--where PRCode in ('IC-PRO-2015-0061','IC_PRO_2015_0062')
		group by PRCode,DealerID,ParentDealerID,PurchaseQty,FreeQty,Tiers,SAPID


		select PRCode,DealerID,SAPID, ParentDealerID, ShipmentQty
		   ,PurchaseQty=(select MAX(TargetQty) from interface.T_I_QV_ICTarget i where a.PRCode=i.PRCode
						 and a.SAPID=i.SAPID and a.ShipmentQty>=TargetQty )
		   ,FreeQty=(select MAX(i.FreeQty) from interface.T_I_QV_ICTarget i where a.PRCode=i.PRCode
						 and a.SAPID=i.SAPID and a.ShipmentQty>=TargetQty )
		   ,Tiers
		   into #tm
		from #bs a
		 
		     --Insert into #ts
	select 
			PRCode,DealerID,PurchaseQty,FreeQty,ShipmentQty,
			AvaliableQty=ShipmentQty/PurchaseQty*FreeQty
			            
		   ,NotUsedQty=case when ShipmentQty>=PurchaseQty then ShipmentQty%PurchaseQty	
				                     else ShipmentQty end

            ,CreateTime=GETDATE() 
            ,ParentDealerID
            ,DType='T2'
            ,RNo=0
            ,Tiers
            into #ts
	   from #tm
	   
  ---Log T2 Info 
		select * into #P2 from (
	 select DealerID,AvaliableQty,NotUsedQty
	        ,RowNumber=row_number() over(partition by DealerID order by CreateTime desc)
	        from PromotionPolicyForT2
	 where PRCode=@PRCode) b where RowNumber=1  

	 --累计余量则无积分制 
		Insert into PromotionPolicyForT2
		select 
			 PRCode=a.PRCode
			 ,DealerID=a.DealerID
			 ,PurchaseQty=a.PurchaseQty
			 ,FreeQty=a.FreeQty
			 ,ShipmentQty=a.ShipmentQty
			 ,AvaliableQty=convert(int,(a.ShipmentQty+ISNULL(b.NotUsedQty,0)-ISNULL(b.AvaliableQty,0))/a.PurchaseQty)*a.FreeQty
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
		  where @IsAddLastCount=1 

		 Insert into PromotionPolicyForT2
		 select 
				 PRCode
			    ,DealerID=a.DealerID
			    ,PurchaseQty=a.PurchaseQty
			    ,FreeQty=a.FreeQty
			    ,ShipmentQty=a.ShipmentQty
				,AvaliableQty=convert(int,(a.ShipmentQty-isnull(b.AvaliableQty,0)))/a.PurchaseQty*a.FreeQty
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
			where @IsAddLastCount=0
	
			
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
---------Clear temporary table--------------------
	drop table #sales
	--drop table #bscsale
 	drop table #ts
 	drop table #final
	--drop table #Policy
	drop table #P2
----------End-------------------------------------




GO


