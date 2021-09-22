DROP proc [dbo].[GC_Interface_Promotion]
GO










CREATE proc [dbo].[GC_Interface_Promotion]
as



	declare @MonthDay nvarchar(100),@LastMonth nvarchar(100) 
			,@QuarterDay nvarchar(100) ,@LastQuarter nvarchar(100)
			,@YearDay nvarchar(100),@LastYear nvarchar(10)
			,@Today nvarchar(100)
			
	DECLARE @FMJobDate DATETIME; 
	DECLARE @EMJobDate DATETIME;
	DECLARE @FQJobDate DATETIME; 
	DECLARE @EQJobDate DATETIME;
	DECLARE @FYJobDate DATETIME; 
	DECLARE @EYJobDate DATETIME;

	SELECT @FYJobDate=DATEADD(YY,-1,DATEADD(yy, DATEDIFF(yy,0,getdate()), 0))
	SELECT @FQJobDate=DATEADD(QQ,-1,DATEADD(qq, DATEDIFF(qq,0,getdate()), 0))
	SELECT @FMJobDate=DATEADD(MM,-1,DATEADD(mm, DATEDIFF(mm,0,getdate()), 0))

	SELECT @EYJobDate=dateadd(dd,1,dateadd(ms,-3,DATEADD(yy, DATEDIFF(yy,0,@FYJobDate)+1, 0)))
	SELECT @EQJobDate=dateadd(dd,1,dateadd(ms,-3,DATEADD(qq, DATEDIFF(qq,0,@FQJobDate)+1, 0)))
	SELECT @EMJobDate=dateadd(dd,1,dateadd(ms,-3,DATEADD(mm, DATEDIFF(mm,0,@FMJobDate)+1, 0)))
			 
	--当月,上月的第一天

	Set @MonthDay=(select convert(varchar,CDD_Calendar)+
	 case when CDD_Date7<10 and len(convert(varchar,CDD_Date7))<2 then '0'+convert(varchar,CDD_Date7) else  convert(varchar,CDD_Date7) end
	  from CalendarDate where CDD_Calendar=CONVERT(nvarchar(6),getdate(),112))
	set @MonthDay=convert(nvarchar(10),convert(datetime,@MonthDay),121)
	SET @LastMonth=CONVERT(nvarchar(10),dateadd(month,-1,@Monthday),121)
	
	--当季度,上季度第一天
	set @QuarterDay=CONVERT(nvarchar(10), DATEADD(qq, DATEDIFF(qq,0,getdate()), 0),121)
	
	Set @QuarterDay=(select convert(varchar,CDD_Calendar)+
	 case when CDD_Date7<10 and len(convert(varchar,CDD_Date7))<2 then '0'+convert(varchar,CDD_Date7) else  convert(varchar,CDD_Date7) end
	  from CalendarDate where CDD_Calendar=CONVERT(nvarchar(6),CONVERT(datetime, @QuarterDay),112))
	set @QuarterDay=convert(nvarchar(10),convert(datetime,@QuarterDay),121)
	SET @LastQuarter=CONVERT(nvarchar(10),dateadd(month,-3,CONVERT(datetime, @QuarterDay)),121)
	
	--今年第一天
	set @YearDay=CONVERT(nvarchar(10), DATEADD(yy, DATEDIFF(yy,0,getdate()), 0),121)
	--去年第一天
	
	
	Set @YearDay=(select convert(varchar,CDD_Calendar)+
	 case when CDD_Date7<10 and len(convert(varchar,CDD_Date7))<2 then '0'+convert(varchar,CDD_Date7) else  convert(varchar,CDD_Date7) end
	  from CalendarDate where CDD_Calendar=CONVERT(nvarchar(6),CONVERT(datetime, @YearDay),112))
	set @YearDay=convert(nvarchar(10),convert(datetime,@YearDay),121)
	set @LastYear=CONVERT(nvarchar(10),DatEADD(yy,-1,CONVERT(datetime, @YearDay)),121)
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

    declare @count int,@PRcode nvarchar(200),@ComputeCycle nvarchar(200),@SalesType nvarchar(200)
    set @count=1
    while @count<=(select COUNT(*) from #tmp)
    begin
    
       set @PRcode=(select PRCode from #tmp where @count=rownumber)
       set @ComputeCycle=(select ComputeCycle from #tmp where @count=rownumber)
       set @SalesType=(select SalesType from #tmp where @count=rownumber)
       
       IF @ComputeCycle=N'月'  and @MonthDay=@Today  and @SalesType=N'销售到医院'
		   exec  dbo.GC_Interface_Promotion_InHospitalSales @PRCode,@FMJobDate,@EMJobDate
		   
       else IF @ComputeCycle='季度' and @SalesType=N'销售到医院' and @QuarterDay=@Today 
		   exec  dbo.GC_Interface_Promotion_InHospitalSales @PRCode,@FQJobDate,@EQJobDate
		   
       ElSE IF @ComputeCycle='年' and @YearDay=@Today   and @SalesType=N'销售到医院'
		   exec dbo.GC_Interface_Promotion_InHospitalSales @PRCode,@FYJobDate,@EYJobDate
		   
       ElSE IF @ComputeCycle=N'月' and @MonthDay=@Today and @SalesType!=N'销售到医院'
           exec dbo.GC_Interface_Promotion_BSCSales @PRCode,@FMJobDate,@EMJobDate
           
       Else IF @ComputeCycle='季度' and @SalesType!=N'销售到医院' and @QuarterDay=@Today 
		   exec dbo.GC_Interface_Promotion_BSCSales @PRCode,@FQJobDate,@EQJobDate
		   
	   ElSE IF @ComputeCycle='年' and @YearDay=@Today and @SalesType!=N'销售到医院'
		  exec dbo.GC_Interface_Promotion_BSCSales @PRCode,@FYJobDate,@EYJobDate
		  
		  
		  
		  
	   ELSE print 1  
       
       
       set @count=@count+1
    
    end
    
 drop table #tmp   










GO


