DROP VIEW  [interface].[V_I_QV_Policy]
GO




CREATE VIEW  [interface].[V_I_QV_Policy]
AS
SELECT [PolicyId]
      ,[PolicyNo]
      ,[PolicyName]
      ,[Description]
      ,[Period]
      ,[StartDate]
      ,[EndDate]
      ,[BU]
      ,[SubBu]
      ,[PolicyClass]--政策类型
      ,[PolicyGroupName]
      ,[TopType]
      ,[TopValue]
      ,case [CalType] when 'ByDealer' then N'经销商' when 'ByHospital' then N'医院' else '' end CalType  --计算粒度
      ,[Status]
      ,[PolicyType]--促销方式
      ,case when isnull(ifConvert,'N')='Y' then N'转积分' when isnull(ifConvert,'N')='N' then N'不转换' else N'转金额' end as  ifConvert --是否转积分
      ,case when isnull(ifMinusLastGift,'N')='Y' then N'扣除上期赠品'  else N'不扣除上期赠品' end as  ifMinusLastGift --是否扣除上期赠品
	  ,case when isnull(ifAddLastLeft,'N')='Y' then N'添加上期余量'  else N'不添加上期余量' end as  ifAddLastLeft --添加上期余量
      ,case when isnull(ifCalPurchaseAR,'N')='Y' then N'赠品算入商业采购达成'  else N'赠品不算入商业采购达成' end as  ifCalPurchaseAR --本政策赠品是否算入商业采购达成
	  ,case when isnull(ifCalSalesAR,'N')='Y' then N'赠品算入植入达成'  else N'赠品不算入植入达成' end as  ifCalSalesAR --本政策赠品是否算入植入达成
	  ,case [CarryType] when 'Round' then N'四舍五入' when 'KeepValue' then N'保留原则' when 'Ceiling' then N'向上取整' when 'Floor' then N'往下取整'  else '' end CarryType  --进位方式
      ,case when isnull(ifIncrement,'N')='Y' then N'增量计算'  else '' end as  ifIncrement --是否增量计算
      ,case when isnull(ifCalRebateAR,'N')='Y' then N'赠品作为返利计算'  else N'赠品不作为返利计算' end as  ifCalRebateAR --是否作为返利计算
      ,PolicyStyle
      ,PolicySubStyle
	  ,[CreateBy]
      ,[CreateTime]
      ,[ModifyBy]
      ,[ModifyDate]
      ,[Remark1]
      ,[Remark2]
      ,[Remark3]
  FROM [Bsc_Prd].[Promotion].[PRO_POLICY]



GO


