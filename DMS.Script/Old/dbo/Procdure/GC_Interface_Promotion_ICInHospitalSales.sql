DROP proc [dbo].[GC_Interface_Promotion_ICInHospitalSales]
GO


--exec [GC_Interface_Promotion_ICInHospitalSales] 'IC-PRO-2015-0004'
Create proc [dbo].[GC_Interface_Promotion_ICInHospitalSales](@PRCode nvarchar(200))
as

--------------------- 计算经销商销量明细--------------------------- 
	 select DealerID,Hospital,MIN(Transaction_Date) as ShipmentDate 
		    into #first
		    from interface.V_I_QV_InHospitalSales (nolock)
		    where Division='Cardio'
		    group by DealerID, Hospital
	   
	 Declare @BeginDate datetime,@CustomerType nvarchar(200)
			 ,@IsAddUp bit, @IsAddLastCount bit,@IsAchIndicator bit
			 ,@ComputeCycle nvarchar(100)
			 ,@Division nvarchar(100)
			 ,@MarketType nvarchar(100)
			 ,@IsIntegral bit
			 ,@IsBundle bit
			 ,@IsAchSpecificInd bit
			 ,@EndDate datetime
			 ,@StartDate datetime
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
	 set @EndDate=(Select EndDate  from interface.T_I_EW_PromotionRules where PRCode=@PRCode) 
	 --set @StartDate=(select ShipmentDate from #first)
	 
	 EXEC dbo.GC_Interface_Promotion_Dealers @PRCode
	 EXEC dbo.GC_Interface_Promotion_Product @PRCode,@IsBundle
	 
	 select DealerID=i.DealerID,UPN,Transaction_Date,Qty,DMScode,Province,Division,
			SalesType=case SalesType when 'Hospital' then N'批发' else N'寄售' end
			,MarketName=case when MarketProperty=0 then N'红海' when MarketProperty=1 then N'蓝海' else '' end
			,SAPID,ParentSAPID,ParentDealerID,SPH_ShipmentNbr,HOS_City as City
			,FirstShipmentDate=1
			,IsAchIndicator= dbo.GC_Fn_GetIndicator(@IsAchIndicator,SAPID,@ComputeCycle,Division,@EndDate,@MarketType)              
			,DMA_DealerType into #ips
			from interface.V_I_QV_InHospitalSales i(nolock)
			left join V_AllHospitalMarketProperty on DMScode=Hos_Code and DivisionID=DivisionCode
			join Hospital on Hospital.HOS_Key_Account=DMScode
			join DealerMaster on DMA_ID=i.DealerID
			join #first f on f.DealerID=i.DealerID and f.Hospital=i.Hospital
			where Transaction_Date>=@BeginDate and Transaction_Date<@EndDate
			 and DATEDIFF(month,ShipmentDate,GETDATE())=3
			 and DATEPART(DAY,ShipmentDate)=DATEPART(DAY,GETDATE())
	 

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
		 into #tmpips  
	 from #ips ips
		join interface.T_I_EW_PromotionRules t on  t.PRCode=@PRCode 
			 and t.Division=ips.Division and MarketName=t.MarketType
		join interface.T_I_EW_PromtionDealers d on d.PRCode=@PRCode and d.DMA_SAP_Code=SAPID
		join interface.T_I_EW_PromotionProduct p on p.PRCode=@PRCode and p.UPN=ips.UPN
		where t.ProductSales=N'批发' and t.Division='Cardio'
		     --and PRCode in ('IC-PRO-2015-0004','IC-PRO-2015-0005')
                  
select * from #tmpips

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
		set @Sql= 'delete #tmpips where SAPID not in '+@SpecificDealers+'';
		Exec (@Sql)
	ENd
-------------------------适用客户（城市，省，全国，医院)--------------
	IF ISNULL(@HospitalProvince2,'')!=''
	Begin
		set @Sql= 'delete #tmpips where Province not in '+@HospitalProvince+'';
		Exec (@Sql)
	ENd
    
    IF ISNULL(@HospitalCity2,'')!=''
	Begin
		set @Sql= 'delete #tmpips where City not in '+@HospitalCity+'';
		Exec (@Sql)
	ENd
	
    IF ISNULL(@HospitalCode2,'')!=''
	Begin
		set @Sql= 'delete #tmpips where DMScode not in '+@HospitalCode+'';
		Exec (@Sql)
	ENd	
 ----------------Minus Free Goods Quantity-------------
     select 
          PRCode  
         ,PurchaseQty
		 ,FreeQty
		 ,DealerID=a.DealerID
		 ,UPN=a.UPN
		 ,Qty=a.qty-ISNULL(FreeGoods.qty,0)
		 ,Division
		 ,SAPID
		 ,ParentSAPID
		 ,ParentDealerID
		 ,DMA_DealerType  
		 into #bscsale  
	  from 
		( select  
			  PRCode
			 ,PurchaseQty
			 ,FreeQty
			 ,DealerID
			 ,UPN
			 ,Qty=sum(Qty)
			 ,Division
			 ,SAPID
			 ,ParentSAPID
			 ,ParentDealerID
			 ,DMA_DealerType  
			from  #tmpips
				  group by PRCode
						 ,PurchaseQty
						 ,FreeQty
						 ,DealerID
						 ,UPN ,Division
						 ,SAPID
						 ,ParentSAPID 
						 ,ParentDealerID
						 ,DMA_DealerType) as a 
		left join 
		  (select UPN, DealerID,SUM(QTY) as QTY 
			 from interface.V_I_EW_BSCSales_FreeGoods
			 where Transaction_Date>=@BeginDate and Transaction_Date<@EndDate
			 --and DATEDIFF(month,ShipmentDate,GETDATE())=3
			 --and DATEPART(DAY,ShipmentDate)=DATEPART(DAY,GETDATE())
			      and Division=@Division
			 group by UPN, DealerID
            ) as FreeGoods
        on a.DealerID=FreeGoods.DealerID and a.UPN=FreeGoods.UPN


 select * into #bscsales from #bscsale 
 where  [dbo].[GC_Fn_GetICPurchaseIndicator](@IsAchIndicator,DealerID ,@ComputeCycle ,@Division,@EndDate
 ,@MarketType ,@StartDate)=1
	---Log
	Insert into Promotion_InHospitalSalesLog select * from #bscsales 
	--select * into Promotion_InHospitalSalesLog from #bscsales 


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
			into #ts 
		from
			(
			select PRCode,DealerID,convert(int,SUM(Qty)) as ShipmentQty,PurchaseQty,FreeQty,ParentDealerID  from #bscsales
			where DMA_DealerType='T1' 
			group by PRCode,DealerID,PurchaseQty,FreeQty,ParentDealerID
			
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
		 from
				(
				select PRCode,DealerID,
					ParentDealerID=case when ParentSAPID='BSC' then DealerID else ParentDealerID end,
					convert(int,SUM(Qty)) as ShipmentQty,PurchaseQty,FreeQty  from #bscsales
					where DMA_DealerType in ('LP','T2') 
					group by PRCode,DealerID,ParentDealerID,PurchaseQty,FreeQty,ParentSAPID
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
				 from #ts where @IsBundle=1
		Delete #ts where RNO<>1 and @IsBundle=1	 
	
	---Log	
	select * into #P2 from (
	 select DealerID,AvaliableQty,NotUsedQty
	        ,RowNumber=row_number() over(partition by DealerID order by CreateTime desc)
	        from PromotionPolicyForT2
	 where PRCode=@PRCode) b where RowNumber=1
	
		Insert into PromotionPolicyForT2
		select 
			 PRCode=a.PRCode
			 ,DealerID=a.DealerID
			 ,PurchaseQty=a.PurchaseQty
			 ,FreeQty=a.FreeQty
			 ,ShipmentQty=a.ShipmentQty
			 ,AvaliableQty=case when @IsIntegral=0 then
			                         convert(int,(a.ShipmentQty+ISNULL(b.NotUsedQty,0))/a.PurchaseQty)*a.FreeQty+ISNULL(b.AvaliableQty,0)
			                    else convert(decimal(18,3),(a.ShipmentQty+ISNULL(b.NotUsedQty,0))/a.PurchaseQty)*a.FreeQty+ISNULL(b.AvaliableQty,0)
			                    end  
			 ,NotUsedQty=case when @IsIntegral=0 then
			                      case when  (a.ShipmentQty+ISNULL(b.NotUsedQty,0))>=a.PurchaseQty
			                       then convert(int,(a.ShipmentQty+ISNULL(b.NotUsedQty,0))%a.PurchaseQty)
			                       else  (a.ShipmentQty+ISNULL(b.NotUsedQty,0)) end
			                  else 0
			                  end
			 ,CreateTime=GETDATE()
			 ,DType=a.DType  
			 ,ParentDealerID=a.ParentDealerID 		  
			 ,AdjustQty=0.0
			 ,AdjustRemark=NULL
			 ,AdjustUserId=null
			 ,UpdateTime=getdate()
			 ,PM_Id=NewID()   
		  from #ts a 
		  left join #P2 b on a.DealerID=b.DealerID
		  where @IsAddLastCount=1 

			
		 Insert into PromotionPolicyForT2
		 select 
				 PRCode
				,DealerID
				,PurchaseQty
				,FreeQty
				,ShipmentQty
				,AvaliableQty=a.AvaliableQty 
				,NotUsedQty=a.NotUsedQty
				,CreateTime=GETDATE() 
				,DType=a.DType  
				,ParentDealerID=a.ParentDealerID 
				,AdjustQty=0.0
				,AdjustRemark=NULL
				,AdjustUserId=null
				,UpdateTime=getdate()
				,PM_Id=NewID()      
			from #ts a 
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
      where @IsAddUp=0
    
    
    select * into #Policy from (
      select DMAID,IsDeleted,AvaliableQty,
      row_number() over(Partition by DMAID,IsDeleted order by CreateTime desc ) 
     as Rownumber  from PromotionPolicy where PMP_Code=@PRCode 
  ) a where Rownumber=1
    
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
		  ,[FreeQty]=f.AvaliableQty+ISNULL(p.AvaliableQty,0)
		  ,[ClearQty]=0
		  ,[AdjustQty]=0
		  ,[AdjustRemark]=NULL
		  ,[AvaliableQty]=f.AvaliableQty+ISNULL(p.AvaliableQty,0)
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
	      left join #Policy p on P.DMAID=DealerID
      where @IsAddUp=1	
		
	
----------Clear temporary table----------------
    drop table #tmpips
    drop table #ts
	drop table #first
	drop table #final
	drop table #Policy

-------End-------------------
 






















GO


