DROP Proc [dbo].[GC_Interface_Promotion_Dealers]
GO




 --EXEC dbo.GC_Interface_Promotion_Dealers 'IC-PRO-2015-0006'

 CREATE Proc [dbo].[GC_Interface_Promotion_Dealers](@PRCode nvarchar(200))
 as
		
 declare @ToDealer nvarchar(500),@ToDealerList nvarchar(max),
 @ProdctLineId nvarchar(500),@sql nvarchar(max)
 ,@PromotionType nvarchar(50)

 set @ProdctLineId=(select ProductLineId from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
 set @PRCode=(select PRCode from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
 set @ToDealer=(select ToDealer from interface.T_I_EW_PromotionRules where PRCode=@PRCode)
 set @ToDealerList='('''+(select replace(ToDealerList,',',''',''') from interface.T_I_EW_PromotionRules where PRCode=@PRCode ) +''')'
 set @PromotionType=(select PromotionType from interface.T_I_EW_PromotionRules where PRCode=@PRCode)

if isnull(@ToDealerList,'')!='' and @PromotionType=N'¼´Âò¼´Ôù'
 set @sql= 'Insert into interface.T_I_EW_PromtionDealers select PRCode,DMA_SAP_Code,GetDate() as CreateTime  from dbo.V_DealerAuthorization d where PRCode= '+''''+@PRCode+''' and DMA_SAP_Code in '+@ToDealerList+'
  and not exists (select 1 from interface.T_I_EW_PromtionDealers a where a.PRCode='+''''+ @PRCode+''' and a.DMA_SAP_Code=d.DMA_SAP_Code) ';
else if isnull(@ToDealerList,'')!='' and @PromotionType=N'¶î¶ÈÊ¹ÓÃ'
 set @sql= 'Insert into interface.T_I_EW_PromtionDealers select PRCode,DMA_SAP_Code,GetDate() as CreateTime  from dbo.V_DealerAuthorization d where PRCode= '+''''+@PRCode+''' and (DMA_SAP_Code in '+@ToDealerList+'
  or ParentSAPID in '+@ToDealerList+') and not exists (select 1 from interface.T_I_EW_PromtionDealers a where a.PRCode='+''''+ @PRCode+''' and a.DMA_SAP_Code=d.DMA_SAP_Code) ';
else if @ToDealer='T1'
 set @sql= 'Insert into interface.T_I_EW_PromtionDealers select PRCode,DMA_SAP_Code,GetDate() as CreateTime  from dbo.V_DealerAuthorization d where PRCode= '+''''+@PRCode+''' and DMA_DealerType=''T1''
 and not exists (select 1 from interface.T_I_EW_PromtionDealers a where a.PRCode='+''''+ @PRCode+''' and a.DMA_SAP_Code=d.DMA_SAP_Code) ';
else if @ToDealer='LP' and @PromotionType=N'¶î¶ÈÊ¹ÓÃ'
 set @sql= 'Insert into interface.T_I_EW_PromtionDealers select PRCode,DMA_SAP_Code,GetDate() as CreateTime  from dbo.V_DealerAuthorization d where PRCode= '+''''+@PRCode+''' and  DMA_DealerType in (''LP'',''T2'')
 and not exists (select 1 from interface.T_I_EW_PromtionDealers a where a.PRCode='+''''+ @PRCode+''' and a.DMA_SAP_Code=d.DMA_SAP_Code) ';
else if @ToDealer='LP' and @PromotionType=N'¼´Âò¼´Ôù'
 set @sql= 'Insert into interface.T_I_EW_PromtionDealers select PRCode,DMA_SAP_Code,GetDate() as CreateTime  from dbo.V_DealerAuthorization d where PRCode= '+''''+@PRCode+''' and  DMA_DealerType in (''LP'')
 and not exists (select 1 from interface.T_I_EW_PromtionDealers a where a.PRCode='+''''+ @PRCode+''' and a.DMA_SAP_Code=d.DMA_SAP_Code) ';
else if @ToDealer='T1,LP' and @PromotionType=N'¼´Âò¼´Ôù'
 set @sql= 'Insert into interface.T_I_EW_PromtionDealers select PRCode,DMA_SAP_Code,GetDate() as CreateTime  from dbo.V_DealerAuthorization d  where PRCode= '+''''+@PRCode+''' and  DMA_DealerType in (''LP'',''T1'')
  and not exists 
  (select 1 from interface.T_I_EW_PromtionDealers a where a.PRCode='+''''+ @PRCode+''' and a.DMA_SAP_Code=d.DMA_SAP_Code) ';
else 
 set @sql= 'Insert into interface.T_I_EW_PromtionDealers select PRCode,DMA_SAP_Code,GetDate() as CreateTime  from dbo.V_DealerAuthorization d  where PRCode= '+''''+@PRCode+''' and not exists 
  (select 1 from interface.T_I_EW_PromtionDealers a where a.PRCode='+''''+ @PRCode+''' and a.DMA_SAP_Code=d.DMA_SAP_Code) ';

--print @sql
exec (@sql)





GO


