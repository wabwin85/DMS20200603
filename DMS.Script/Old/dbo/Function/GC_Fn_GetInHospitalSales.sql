DROP FUNCTION [dbo].[GC_Fn_GetInHospitalSales]
GO


--产品使用量信息
CREATE FUNCTION [dbo].[GC_Fn_GetInHospitalSales](
	@Year int,
	@Month int,
	@DivisionID int
)
RETURNS @temp TABLE 
(
	DmaId uniqueidentifier,
	HospitalId uniqueidentifier,
	ProductLineId uniqueidentifier,
	DivisionId INT,
	DealerCode INT,
	DealerShortName nvarchar(20),
	SalesName nvarchar(50),
	HospitalNameE nvarchar(500),
	HospitalNameC nvarchar(550),
	HospitalCode nvarchar(20),
	UPN nvarchar(20),
	[Description] nvarchar(250),
	Level1 nvarchar(200),
	Level2 nvarchar(200),
	Level3 nvarchar(200),
	Level4 nvarchar(200),
	Level5 nvarchar(200),
	LotNumber nvarchar(50),
	SellPrice money,
	PurchasePrice money,
	Qty numeric(18,1),
	amountrmb money,
	amountusd money,
	asprmb money,
	aspusd money,
	[Month] int,
	[Year] int,
	ProvinceNameE nvarchar(50),
	ProvinceCode INT,
	Region nvarchar(20),
	Ktype INT,
	ShipmentType nvarchar(50),
	CfnId uniqueidentifier
)
	WITH
	EXECUTE AS CALLER
AS
    BEGIN

	insert into @temp (DmaId,HospitalId,ProductLineId,DivisionId,[Year],[Month],UPN,LotNumber,SellPrice,Qty,Ktype,ShipmentType,CfnId)	
	SELECT header.SPH_Dealer_DMA_ID,header.SPH_Hospital_HOS_ID,header.SPH_ProductLine_BUM_ID,Division.DivisionId,
	DATEPART(year,header.SPH_ShipmentDate) AS [Year],DATEPART(month,header.SPH_ShipmentDate) AS [MONTH],
	Product.PMA_UPN,LotMaster.LTM_LotNumber,detail.SLT_UnitPrice,SUM(detail.SLT_LotShippedQty),1,header.SPH_Type,Product.PMA_CFN_ID
	  FROM ShipmentHeader AS header
	INNER JOIN ShipmentLine AS line ON line.SPL_SPH_ID = header.SPH_ID
	INNER JOIN ShipmentLot AS detail ON detail.SLT_SPL_ID = line.SPL_ID
	INNER JOIN Product ON Product.PMA_ID = line.SPL_Shipment_PMA_ID
	INNER JOIN Lot ON Lot.LOT_ID = detail.SLT_LOT_ID
	INNER JOIN LotMaster ON LotMaster.LTM_ID = Lot.LOT_LTM_ID
	INNER JOIN (SELECT bu.DivisionId,ou.AttributeID FROM Cache_OrganizationUnits ou
	INNER JOIN View_BU bu ON bu.Id = ou.RootID
	WHERE ou.AttributeType = 'Product_Line') AS Division ON Division.AttributeID = header.SPH_ProductLine_BUM_ID
	WHERE header.SPH_Status in ('Complete','Reversed') AND header.SPH_Type IN ('Consignment','Hospital')
	AND (@Year is null or DATEPART(year,header.SPH_ShipmentDate) = @Year)
	AND (@Month is null or DATEPART(month,header.SPH_ShipmentDate) = @Month)
	AND (@DivisionID is null or Division.DivisionId = @DivisionID)
	GROUP BY header.SPH_Dealer_DMA_ID,header.SPH_Hospital_HOS_ID,header.SPH_ProductLine_BUM_ID,Division.DivisionId,
	DATEPART(year,header.SPH_ShipmentDate),DATEPART(month,header.SPH_ShipmentDate),
	Product.PMA_UPN,LotMaster.LTM_LotNumber,detail.SLT_UnitPrice,header.SPH_Type,Product.PMA_CFN_ID
	HAVING SUM(detail.SLT_LotShippedQty) <> 0

	--更新总金额
	update @temp set amountrmb = SellPrice*Qty,amountusd = SellPrice*Qty/6.83

	--更新经销商信息
	update @temp set DealerCode = dm.DMA_SAP_Code,DealerShortName = dm.DMA_EnglishShortName,Region = dm.DMA_Province
	from DealerMaster dm where dm.DMA_ID = DmaId

	--更新销售员
	update @temp set SalesName = Lafite_IDENTITY.IDENTITY_NAME
	from View_SalesOfDealer 
	inner join Lafite_IDENTITY on Lafite_IDENTITY.Id = View_SalesOfDealer.SalesID
	where View_SalesOfDealer.BUM_ID = ProductLineId
	and View_SalesOfDealer.DealerID = DmaId

	--更新医院信息
	update @temp set HospitalNameE = '',HospitalNameC = h.HOS_HospitalName,HospitalCode = h.HOS_Key_Account,ProvinceNameE = p.TER_EName,ProvinceCode = p.TER_Code
	from Hospital h
	left outer join (SELECT TER_Description, TER_EName, TER_Code
      from Territory WHERE TER_Type = 'Province') AS p ON p.TER_Description = h.HOS_Province
	where h.HOS_ID = HospitalId

	--更新产品信息
	update @temp set [Description]= CFN_Description ,Level1 = CFN_Level1Desc,
	Level2 = CFN_Level2Desc,Level3 = CFN_Level3Desc,Level4 = CFN_Level4Desc,Level5 = CFN_Level5Desc
	from cfn where CFN_ID = CfnId

	--更新采购价格
	update @temp set PurchasePrice = CFNP_Price
	from CFNPrice where CFNP_CFN_ID = CfnId
	and CFNP_Group_ID = DmaId and CFNP_PriceType = 'Dealer'
	and ShipmentType = 'Hospital'

	update @temp set PurchasePrice = CFNP_Price
	from CFNPrice where CFNP_CFN_ID = CfnId
	and CFNP_Group_ID = DmaId and CFNP_PriceType = 'DealerConsignment'
	and ShipmentType = 'Consignment'
	
        RETURN
    END


GO


