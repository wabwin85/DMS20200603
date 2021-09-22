DROP Proc [dbo].[GC_Interface_Promotion_Product]
GO












	 --EXEC dbo.GC_Interface_Promotion_Product 'IC-PRO-2015-0006',0

CREATE Proc [dbo].[GC_Interface_Promotion_Product](@PRCode nvarchar(200),@IsBundle bit)
as
 
 IF @IsBundle=0
	 begin
	 Insert into interface.T_I_EW_PromotionProducts
	 select 
		   PRCode,ProductLineId, ProductLevel=
		   case ProductLevel when 'Level1' then 'CFN_Level1Code'
							 when 'Level2' then 'CFN_Level2Code'
							 when 'Level3' then 'CFN_Level3Code'
							 when 'Level4' then 'CFN_Level4Code'
							 when 'Level5' then 'CFN_Level5Code'
							 when 'Level6' then 'CFN_CustomerFaceNbr'
							 else '' end
		   ,LevelCode,row_number() over (order by PRCode) as rownumber, getdate() CreateTime,0 As Qty
		   ,0 as Tiers
	 from Interface.T_I_EW_PromotionRules i
	 where  PRCode=@PRCode and
	 not exists (select 1 FROM interface.T_I_EW_PromotionProducts where PRCode=@PRCode)
	 end
 else
	 begin
	 Insert into interface.T_I_EW_PromotionProducts
	 select 
		   PRCode,ProductLineId, ProductLevel=
		   case ProductLevel when 'Level1' then 'CFN_Level1Code'
							 when 'Level2' then 'CFN_Level2Code'
							 when 'Level3' then 'CFN_Level3Code'
							 when 'Level4' then 'CFN_Level4Code'
							 when 'Level5' then 'CFN_Level5Code'
							 when 'Level6' then 'CFN_CustomerFaceNbr'
							 else '' end
		   ,LevelCode,row_number() over (order by PRCode) as rownumber, getdate() CreateTime,Qty,Tiers
	 from interface.T_I_EW_PromotionRules_Bundle i
	 where PRCode=@PRCode and not exists (select 1 FROM interface.T_I_EW_PromotionProducts f where PRCode=@PRCode
	  and i.LevelCode=f.LevelCode and isnull(i.Tiers,0)= isnull(f.Tiers,0))
	 end

 declare @ProductLevel nvarchar(200),@sql nvarchar(max),@LevelCode nvarchar(max),
		 @ProdctLineId nvarchar(500),@Qty nvarchar(10),@Tiers nvarchar(10)
		 ,@Rownumber nvarchar(10)
         ,@Count int
	--IF  Exists(select 1 from interface.T_I_EW_PromotionProducts 
	--		  where CreateTime>=convert(date,getdate())
 --             and PRCode=@PRCode)

 
  set @Count=1
   while @Count<=(select COUNT(1) from [interface].[T_I_EW_PromotionProducts] where PRCode=@PRCode) 

	begin

		 set @ProductLevel=(select ProductLevel from interface.T_I_EW_PromotionProducts where PRCode=@PRCode and @Count=rownumber) 
		 set @LevelCode='('''+(select replace(LevelCode,',',''',''') from interface.T_I_EW_PromotionProducts where PRCode=@PRCode and @Count=rownumber ) +''')'
		 set @ProdctLineId=(select ProductLineId from interface.T_I_EW_PromotionProducts where PRCode=@PRCode and @Count=rownumber)
		 set @Qty=(select Qty from interface.T_I_EW_PromotionProducts where PRCode=@PRCode and @Count=rownumber)
		 set @Tiers=(select isnull(Tiers,0) from interface.T_I_EW_PromotionProducts where PRCode=@PRCode and @Count=rownumber)
         set @Rownumber=(select Rownumber from interface.T_I_EW_PromotionProducts where PRCode=@PRCode and @Count=rownumber)
		 
	 Set @sql='Insert into interface.T_I_EW_PromotionProduct  select distinct PRCode= '+''''+@PRCode+''' ,
		 CFN_CustomerFaceNbr as UPN,GetDate() as CreateTime,Qty='+@Qty+', Tiers='+@Tiers+', Rownumber='+@Rownumber+' from CFN c where '+ QUOTENAME(@ProductLevel) +' in '+@LevelCode+
		 ' and CFN_ProductLine_BUM_ID='''+@ProdctLineId+''' and not exists (select 1 from interface.T_I_EW_PromotionProduct
		  where UPN=c.CFN_CustomerFaceNbr and PRCode='+''''+@PRCode+''') '

		 --print @Sql
		 Exec (@sql)
		 
		 set @Count=@Count+1

	 end
	 













GO


