DROP Proc [dbo].[GC_Interface_Promotion_BackupInterfaceTable]
GO


/****** Script for SelectTopNRows command from SSMS  ******/


CREATE Proc [dbo].[GC_Interface_Promotion_BackupInterfaceTable]
as
begin
Insert into [interface].[T_I_EW_PromotionRules_Backup]
    select
       [PRID]
      ,[PromotionType]
      ,[PRCode]
      ,[Content]
      ,[Division]
      ,[ProductLine]
      ,[ProductLevel]
      ,[LevelCode]
      ,[PurchaseQty]
      ,[FreeQty]
      ,[CustomerType]
      ,[HospitalProvince]
      ,[HospitalCity]
      ,[HospitalCode]
      ,[ToDealer]
      ,[BeginDate]
      ,[EndDate]
      ,[SalesType]
      ,[SpecificDealers]
      ,[IsAchIndicator]
      ,[ProductSales]
      ,[MarketType]
      ,[ComputeCycle]
      ,[UseQty]
      ,[UseRange]
      ,[UseProductLevel]
      ,[UseLevelCode]
      ,[IsAddUp]
      ,[CreateTime]
      ,[UpdateTime]
      ,[ProductLineId]
      ,[ToDealerList]
      ,[IsAddLastCount]
      ,[IsTiersRule]
      ,[IndicatorRateFrom]
      ,[IndicatorRateTo]
      ,[PurchaseQty2]
      ,[FreeQty2]
      ,[IndicatorRateFrom2]
      ,[IndicatorRateTo2]
      ,[PurchaseQty3]
      ,[FreeQty3]
      ,[IndicatorRateFrom3]
      ,[IndicatorRateTo3]
      ,[PurchaseQty4]
      ,[FreeQty4]
      ,[IndicatorRateFrom4]
      ,[IndicatorRateTo4]
      ,[PurchaseQty5]
      ,[FreeQty5]
      ,[IndicatorRateFrom5]
      ,[IndicatorRateTo5]
      ,[PRName]
      ,[IsBundle]
      ,[IsAchSpecificInd]
      ,[IsIntegral]
      ,[IsSuit]
  FROM [interface].[T_I_EW_PromotionRules] a
  where not exists (select 1 from [interface].[T_I_EW_PromotionRules_Backup] b where b.PRID=a.PRID)
  
  
  Insert into dbo.PromotionPolicy_Backup
  select * from PromotionPolicy a
  where not exists (select 1 from PromotionPolicy_Backup b where a.PMP_ID=b.PMP_ID and a.DMAID=b.DMAID and a.IsDeleted=b.IsDeleted)
  
  Insert into dbo.PromotionPolicyForT2_Backup
  select * from PromotionPolicyForT2 a
  where  not exists (select 1 from PromotionPolicyForT2_Backup b where a.PM_Id=b.PM_Id)
  --Insert into [interface].[T_I_EW_PromotionRules_Bundle_Backup]
  --SELECT [PRCode]
  --    ,[ProductLevel]
  --    ,[LevelCode]
  --    ,[Qty]
  --    ,[Tiers]
  --    ,[ProductLineId]
  --FROM [interface].[T_I_EW_PromotionRules_Bundle] a
  --where not exists (select 1 from [interface].[T_I_EW_PromotionRules_Bundle_Backup] b where a.PRCode=b.PRCode
  -- and a.ProductLevel
   

  
  end
  


GO


