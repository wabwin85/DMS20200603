DROP proc [dbo].[GC_Interface_Promotion_ICTargetJob]
GO











create proc [dbo].[GC_Interface_Promotion_ICTargetJob]
as



	declare @MonthDay nvarchar(100), @QuarterDay nvarchar(100),
			@YearDay nvarchar(100),@Today nvarchar(100)
			,@LastMonth nvarchar(100) ,@LastQuarter nvarchar(100)
			,@LastYear nvarchar(10)
			 
	--当月,上月的第一天
	--set @MonthDay=convert(nvarchar(10), DATEADD(mm, DATEDIFF(mm,0,getdate()), 0),121)
	--Set @LastMonth= convert(nvarchar(10),DATEADD(mm, DATEDIFF(mm,0,dateadd(month,-1,getdate())),  0))
	Set @MonthDay=(select convert(varchar,CDD_Calendar)+
	 case when CDD_Date7<10 and len(convert(varchar,CDD_Date7))<2 then '0'+convert(varchar,CDD_Date7) else  convert(varchar,CDD_Date7) end
	  from CalendarDate where CDD_Calendar=CONVERT(nvarchar(6),getdate(),112))
	set @MonthDay=convert(nvarchar(10),convert(datetime,@MonthDay),121)
	SET @LastMonth=CONVERT(nvarchar(10),dateadd(month,-1,@Monthday),121)
	
	--当季度,上季度第一天
	set @QuarterDay=CONVERT(nvarchar(10), DATEADD(qq, DATEDIFF(qq,0,getdate()), 0),121)
	--set @LastQuarter=CONVERT(nvarchar(10), DATEADD(month,-3,@QuarterDay),121)
	
	Set @QuarterDay=(select convert(varchar,CDD_Calendar)+
	 case when CDD_Date7<10 and len(convert(varchar,CDD_Date7))<2 then '0'+convert(varchar,CDD_Date7) else  convert(varchar,CDD_Date7) end
	  from CalendarDate where CDD_Calendar=CONVERT(nvarchar(6),@QuarterDay,112))
	set @QuarterDay=convert(nvarchar(10),convert(datetime,@QuarterDay),121)
	SET @LastQuarter=CONVERT(nvarchar(10),dateadd(month,-3,@QuarterDay),121)
	
	--今年第一天
	set @YearDay=CONVERT(nvarchar(10), DATEADD(yy, DATEDIFF(yy,0,getdate()), 0),121)
	--去年第一天
	
	
	Set @YearDay=(select convert(varchar,CDD_Calendar)+
	 case when CDD_Date7<10 and len(convert(varchar,CDD_Date7))<2 then '0'+convert(varchar,CDD_Date7) else  convert(varchar,CDD_Date7) end
	  from CalendarDate where CDD_Calendar=CONVERT(nvarchar(6),@YearDay,112))
	set @YearDay=convert(nvarchar(10),convert(datetime,@YearDay),121)
	set @LastYear=CONVERT(nvarchar(10),DatEADD(yy,-1,@YearDay),121)
	--今天
	set @Today=CONVERT(nvarchar(10),getdate(),121)


	select 
		PRCode
	   ,ROW_NUMBER() over (order by Createtime) as rownumber
	   ,ComputeCycle
	   ,SalesType
		into #tmp
		from interface.T_I_EW_PromotionRules(nolock)
		where CONVERT(nvarchar(6),EndDate,112)>=convert(nvarchar(6),GETDATE(),112)
		 and BeginDate<=GETDATE() and PromotionType=N'额度使用'
		 and PRCode in ('IC-PRO-2015-0061','IC_PRO_2015_0062')

    declare @count int,@PRcode nvarchar(200),@ComputeCycle nvarchar(200),@SalesType nvarchar(200)
    set @count=1
    while @count<=(select COUNT(*) from #tmp)
    begin
    
       set @PRcode=(select PRCode from #tmp where @count=rownumber)
       set @ComputeCycle=(select ComputeCycle from #tmp where @count=rownumber)
       set @SalesType=(select SalesType from #tmp where @count=rownumber)
       
     IF @ComputeCycle='季度' and @SalesType!=N'销售到医院'
       and @QuarterDay=@Today 
		   exec dbo.GC_Interface_Promotion_ICTarget @PRCode,@LastQuarter,@QuarterDay
		  
	   ELSE print 1  
       
       
       set @count=@count+1
    
    end
    
 drop table #tmp   











GO


