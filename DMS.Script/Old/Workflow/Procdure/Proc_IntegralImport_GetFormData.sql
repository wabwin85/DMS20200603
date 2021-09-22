
DROP PROCEDURE [Workflow].[Proc_IntegralImport_GetFormData]
GO

CREATE PROCEDURE [Workflow].[Proc_IntegralImport_GetFormData]
	@InstanceId uniqueidentifier
AS


DECLARE @VendorType INT
DECLARE @Rate DECIMAL(10,4)

SELECT @VendorType = COUNT(1) FROM Promotion.Pro_InitPoint_Flow WHERE InstanceID = @InstanceId

IF @VendorType = 1
	BEGIN
	SELECT @Rate=Rate FROM interface.V_MDM_ExchangeRate
	
	IF ISNULL(@Rate,0)=0
	BEGIN
		SET @Rate=1;
	END
	
	SELECT CASE  WHEN ISNULL(a.MarketType,0)=1 THEN '36' ELSE DR.DivisionCode END AS BU,
	a.FlowId AS RequestNo,SUM(Point/1.17/isnull(b.Ratio,1)) AS TotalRMB ,SUM(Point/1.17/isnull(b.Ratio,1))/@Rate AS TotalUSD
	FROM Promotion.Pro_InitPoint_Flow a 
	INNER JOIN Promotion.Pro_InitPoint_Flow_Detail b ON A.FlowId=B.FlowId
	INNER JOIN V_DivisionProductLineRelation DR ON DR.ProductLineName=A.BU AND DR.IsEmerging='0'
	WHERE A.InstanceID=@InstanceId
	GROUP BY  DR.DivisionCode ,a.FlowId,a.MarketType
		
	END

GO


