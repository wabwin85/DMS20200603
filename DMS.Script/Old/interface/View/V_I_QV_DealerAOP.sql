DROP VIEW [interface].[V_I_QV_DealerAOP] 
GO















CREATE VIEW [interface].[V_I_QV_DealerAOP] 
AS
SELECT DealerId,SAPID,Dealer,StartDate,StopDate,ProductLineId,ProductLine,DivisionID,Division,MarketType,Year,
Amount_1,
Amount_2,
Amount_3,
Amount_4,
Amount_5,
AOPD_Amount_6,
Amount_7,
Amount_8,
Amount_9,
Amount_10,
Amount_11,
Amount_12,
(Amount_1+Amount_2+Amount_3+Amount_4+Amount_5+AOPD_Amount_6+Amount_7+Amount_8+Amount_9+Amount_10+Amount_11+Amount_12) Amount_Total,
IsActive,
SubBUCode,
SubBUName
FROM (
select AOPD_Dealer_DMA_ID as DealerId,b.DMA_SAP_Code as SAPID,b.DMA_ChineseName as Dealer,
d.EffectiveDate as StartDate ,d.MinDate as StopDate,AOPD_ProductLine_BUM_ID as ProductLineId ,f.ProductLineName as ProductLine,f.DivisionCode as DivisionID,f.DivisionName as Division,AOPD_Market_Type as MarketType,AOPD_Year as [Year],
		case when YEAR(d.MinDate)>YEAR(GETDATE()) Then AOPD_Amount_1 else case when MONTH(d.MinDate)>=1 then AOPD_Amount_1 else 0.0 end end  as Amount_1,
		case when YEAR(d.MinDate)>YEAR(GETDATE()) Then AOPD_Amount_2 else case when MONTH(d.MinDate)>=2 then AOPD_Amount_2 else 0.0 end end  as Amount_2,
		case when YEAR(d.MinDate)>YEAR(GETDATE()) Then AOPD_Amount_3 else case when MONTH(d.MinDate)>=3 then AOPD_Amount_3 else 0.0 end end  as Amount_3,
		case when YEAR(d.MinDate)>YEAR(GETDATE()) Then AOPD_Amount_4 else case when MONTH(d.MinDate)>=4 then AOPD_Amount_4 else 0.0 end end  as Amount_4,
		case when YEAR(d.MinDate)>YEAR(GETDATE()) Then AOPD_Amount_5 else case when MONTH(d.MinDate)>=5 then AOPD_Amount_5 else 0.0 end end  as Amount_5,
		case when YEAR(d.MinDate)>YEAR(GETDATE()) Then AOPD_Amount_6 else case when MONTH(d.MinDate)>=6 then AOPD_Amount_6 else 0.0 end end  as AOPD_Amount_6,
		case when YEAR(d.MinDate)>YEAR(GETDATE()) Then AOPD_Amount_7 else case when MONTH(d.MinDate)>=7 then AOPD_Amount_7 else 0.0 end end  as Amount_7,
		case when YEAR(d.MinDate)>YEAR(GETDATE()) Then AOPD_Amount_8 else case when MONTH(d.MinDate)>=8 then AOPD_Amount_8 else 0.0 end end  as Amount_8,
		case when YEAR(d.MinDate)>YEAR(GETDATE()) Then AOPD_Amount_9 else case when MONTH(d.MinDate)>=9 then AOPD_Amount_9 else 0.0 end end  as Amount_9,
		case when YEAR(d.MinDate)>YEAR(GETDATE()) Then AOPD_Amount_10 else case when MONTH(d.MinDate)>=10 then AOPD_Amount_10 else 0.0 end end  as Amount_10,
		case when YEAR(d.MinDate)>YEAR(GETDATE()) Then AOPD_Amount_11 else case when MONTH(d.MinDate)>=11 then AOPD_Amount_11 else 0.0 end end  as Amount_11,
		case when YEAR(d.MinDate)>YEAR(GETDATE()) Then AOPD_Amount_12 else case when MONTH(d.MinDate)>=12 then AOPD_Amount_12 else 0.0 end end  as Amount_12,
		CASE b.DMA_ActiveFlag WHEN 0 THEN 'жуж╧' ELSE '' END  AS IsActive,cc.CC_Code as  SubBUCode,cc.CC_NameCN as SubBUName 
       from V_AOPDealer  a with(nolock)
       inner join DealerMaster b with(nolock) on a.AOPD_Dealer_DMA_ID=b.DMA_ID 
       inner join V_DivisionProductLineRelation f on a.AOPD_ProductLine_BUM_ID= f.ProductLineID and f.IsEmerging='0' 
       left join interface.ClassificationContract cc with(nolock) on cc.CC_ID=a.AOPD_CC_ID
       left join interface.V_I_QV_DealerContractMaster_AOP d on 
       a.AOPD_Dealer_DMA_ID=d.DMA_ID 
       and  isnull(a.AOPD_Market_Type,'0')=CONVERT(nvarchar(10),isnull(d.MarketType,0)) 
       and f.DivisionCode=CONVERT(nvarchar(10),d.Division) 
       and a.AOPD_CC_ID=d.CC_ID     
      where   a.AOPD_Year=CONVERT(NVARCHAR(10),YEAR(GETDATE()))
) TAB












GO


