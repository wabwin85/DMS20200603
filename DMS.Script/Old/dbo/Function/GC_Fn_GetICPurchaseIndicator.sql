DROP FUNCTION [dbo].[GC_Fn_GetICPurchaseIndicator]
GO

CREATE FUNCTION [dbo].[GC_Fn_GetICPurchaseIndicator]
(
	@IsAchIndicator  BIT,
	@DealerId        NVARCHAR(200),
	@ComputeCycle    NVARCHAR(100),
	@Divison         NVARCHAR(100),
	@FinishDatec     NVARCHAR(100),
	@MarketType      NVARCHAR(100),
	@StartDatec      NVARCHAR(100)
)
RETURNS INT
AS

BEGIN
	DECLARE @IsMatch         DECIMAL(18, 6),
	        @CycleDate       DATETIME,
	        @Indicator       DECIMAL(18, 6),
	        @ShipmentQty     DECIMAL(18, 6),
	        @PurchaseAmount  DECIMAL(18, 6),
	        @ShipmentAmount  DECIMAL(18, 6),
	        @FinishDate      DATETIME,
	        @StartDate       DATETIME
	
	SET @StartDate = CONVERT(DATETIME, @StartDatec) ;
	SET @FinishDate = CONVERT(DATETIME, @FinishDatec);
	SET @CycleDate = DATEADD(MONTH, -1, @FinishDate)
	
	SELECT @ShipmentQty = SUM(Qty)
	FROM   (
	           SELECT MarketName = CASE 
	                                    WHEN MarketProperty = 0 THEN N'红海'
	                                    WHEN MarketProperty = 1 THEN N'蓝海'
	                                    ELSE ''
	                               END,
	                  Qty
	           FROM   interface.V_I_QV_InHospitalSales i(NOLOCK)
	                  LEFT JOIN V_AllHospitalMarketProperty
	                       ON  DMScode = Hos_Code
	                           AND DivisionID = DivisionCode
	           WHERE  Transaction_Date >= @StartDate
	                  AND Transaction_Date < @FinishDate
	                  AND DealerID = @DealerId
	                  AND i.Division = @Divison
	       ) s
	WHERE  MarketName = @MarketType
	
	SELECT @ShipmentAmount = SUM(Amount)
	FROM   (
	           SELECT MarketName = CASE 
	                                    WHEN MarketProperty = 0 THEN N'红海'
	                                    WHEN MarketProperty = 1 THEN N'蓝海'
	                                    ELSE ''
	                               END,
	                  Amount = [interface].[Promotion_GetPurchasePrice](DealerID, UPN, SalesType)
	                  * Qty
	           FROM   interface.V_I_QV_InHospitalSales i(NOLOCK)
	                  LEFT JOIN V_AllHospitalMarketProperty
	                       ON  DMScode = Hos_Code
	                           AND DivisionID = DivisionCode
	           WHERE  Transaction_Date >= @StartDate
	                  AND Transaction_Date < @FinishDate
	                  AND DealerID = @DealerId
	                  AND i.Division = @Divison
	       ) s
	WHERE  MarketName = @MarketType
	
	IF @MarketType = '红海'
	    SELECT @PurchaseAmount = SUM(SellingAmount)
	    FROM   [interface].[V_I_EW_BSCSales]
	    WHERE  DealerID = @DealerId
	           AND Division = @Divison
	           AND Transaction_Date >= @StartDate
	           AND Transaction_Date < @FinishDate
	ELSE
	    SELECT @PurchaseAmount = SUM(T2PurAmt_VAT_RMB)
	    FROM   [interface].[T_I_QV_LPSales]
	           JOIN DealerMaster
	                ON  DMA_SAP_Code = SAPID
	    WHERE  DMA_ID = @DealerId
	           AND Division = @Divison
	           AND TransactionDate >= @StartDate
	           AND TransactionDate < @FinishDate
	           AND MarketType = '蓝海'
	
	IF @IsAchIndicator = 1
	   AND @ComputeCycle = '月'
	BEGIN
	    SELECT @Indicator = ISNULL(AOPICH_Unit, 0)
	    FROM   [interface].[V_I_EW_Promotion_Indicator]
	    WHERE  MarketProperty = @MarketType
	           AND AOPICH_Year = CONVERT(NVARCHAR, YEAR(@CycleDate))
	           AND AOPICH_Month = CONVERT(NVARCHAR, MONTH(@CycleDate))
	           AND AOPICH_DMA_ID = @DealerId
	           AND DivisionName = @Divison
	    
	    IF @PurchaseAmount >= @ShipmentAmount
	       AND @ShipmentQty >= @Indicator
	        SET @IsMatch = 1
	    ELSE
	        SET @IsMatch = 0
	END
	ELSE 
	IF @IsAchIndicator = 1
	   AND @ComputeCycle = '季度'
	BEGIN
	    SELECT @Indicator = SUM(ISNULL(AOPICH_Unit, 0))
	    FROM   [interface].[V_I_EW_Promotion_Indicator]
	    WHERE  MarketProperty = @MarketType
	           AND AOPICH_Year = CONVERT(NVARCHAR, YEAR(@CycleDate))
	           AND [Quarter] = CONVERT(NVARCHAR, MONTH(@CycleDate))
	           AND AOPICH_DMA_ID = @DealerId
	           AND DivisionName = @Divison
	    
	    IF @PurchaseAmount >= @ShipmentAmount
	       AND @ShipmentQty >= @Indicator
	        SET @IsMatch = 1
	    ELSE
	        SET @IsMatch = 0
	END
	ELSE 
	IF @IsAchIndicator = 1
	   AND @ComputeCycle = '年'
	BEGIN
	    SELECT @Indicator = SUM(ISNULL(AOPICH_Unit, 0))
	    FROM   [interface].[V_I_EW_Promotion_Indicator]
	    WHERE  MarketProperty = @MarketType
	           AND AOPICH_Year = CONVERT(NVARCHAR, YEAR(@CycleDate))
	           AND AOPICH_DMA_ID = @DealerId
	           AND DivisionName = @Divison
	    
	    IF @PurchaseAmount >= @ShipmentAmount
	       AND @ShipmentQty >= @Indicator
	        SET @IsMatch = 1
	    ELSE
	        SET @IsMatch = 0
	END
	ELSE
	BEGIN
	    SET @IsMatch = 1
	END
	
	RETURN @IsMatch
	
END
GO


