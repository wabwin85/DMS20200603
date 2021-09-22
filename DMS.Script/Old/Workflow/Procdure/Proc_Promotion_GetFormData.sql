DROP PROCEDURE [Workflow].[Proc_Promotion_GetFormData]
GO

CREATE PROCEDURE [Workflow].[Proc_Promotion_GetFormData]
	@InstanceId uniqueidentifier
AS

--select * from Promotion.T_Pro_Flow
DECLARE @VendorType INT
DECLARE @Rate DECIMAL(10,4)
DECLARE @Ratio DECIMAL(10,4)

SELECT @VendorType = COUNT(1) FROM Promotion.T_Pro_Flow WHERE InstanceID = @InstanceId
SELECT @Rate=Rate FROM [interface].[MDM_ExchangeRate] WHERE [FROM]='CNY' AND [TO]='USD'	
--获取赠品加价率
SELECT top 1 @Ratio=T4.Ratio FROM PROMOTION.T_Pro_Flow t1
INNER JOIN Promotion.T_Pro_Flow_Detail t2 ON t1.FlowId = t2.FlowId
INNER JOIN DealerMaster T3 ON T2.DealerId=T3.DMA_ID
INNER JOIN Promotion.Pro_BU_PointRatio T4 ON T4.PlatFormId=T3.DMA_Parent_DMA_ID AND t4.BU=t1.BU
WHERE t1.InstanceID=@InstanceId

SET @Ratio=ISNULL(@Ratio,1);

IF ISNULL(@Rate,0)=0
BEGIN
	SET @Rate=1;
END

IF @VendorType = 1
	BEGIN
		
	SELECT t1.WFCode RequestNo,
			CASE WHEN ISNULL(t1.MarketType,0)=1 THEN '36' ELSE t3.DivisionCode END AS BU,
			CASE WHEN FlowType='赠品' THEN  ISNULL(sum(AdjustNum*ISNULL(GiftPrice,1)/1.17/@Ratio),0) ELSE ISNULL(sum(AdjustNum/1.17/isnull( (case when t2.Ratio=0 then 1 else t2.Ratio end),1)),0) END as TotalRMB,
			CASE WHEN FlowType='赠品' THEN  ISNULL(SUM(AdjustNum*ISNULL(GiftPrice,1)/1.17/@Ratio),0)/@Rate ELSE ISNULL(SUM(AdjustNum/1.17/isnull((case when t2.Ratio=0 then 1 else t2.Ratio end),1)),0)/@Rate END as TotalUSD,
			CASE WHEN Reason='已获取亚太审批的促销政策' THEN '1'
			WHEN Reason='不需获取亚太审批的促销政策(非红票冲抵)' THEN '2'
			ELSE '3' END SubType
      FROM PROMOTION.T_Pro_Flow t1,Promotion.T_Pro_Flow_Detail t2 ,V_DivisionProductLineRelation t3
      WHERE t1.FlowId = t2.FlowId
      and t3.DivisionName=t1.BU
      and t3.IsEmerging='0'
      and t1.InstanceID=@InstanceId
      group by WFCode,DivisionCode,FlowType,Reason,t1.MarketType
		
	END

GO


