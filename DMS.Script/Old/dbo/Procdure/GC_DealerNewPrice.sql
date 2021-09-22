DROP Procedure [dbo].[GC_DealerNewPrice]
GO

--
CREATE Procedure [dbo].[GC_DealerNewPrice]
	
AS
	--DECLARE @PriceType INT
	DECLARE @SysUserId uniqueidentifier
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

	--SET @PriceType = 2  
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'	
	
	--删除已失效的价格，并放入历史价格表中
	INSERT INTO CFNPriceHistory
	SELECT *, GETDATE() FROM CFNPrice
	WHERE CONVERT(NVARCHAR(50),GETDATE(),112) > CONVERT(NVARCHAR(50),ISNULL(CFNP_ValidDateTo,CONVERT(DATETIME,'20990101')),112)

	DELETE FROM CFNPrice
	WHERE CONVERT(NVARCHAR(50),GETDATE(),112) > CONVERT(NVARCHAR(50),ISNULL(CFNP_ValidDateTo,CONVERT(DATETIME,'20990101')),112)

	--将生效的价格放入临时表
	SELECT * INTO #TMP_DATA FROM DealerNewPrice
	WHERE CONVERT(NVARCHAR(50),GETDATE(),112) BETWEEN
	CONVERT(NVARCHAR(50),ISNULL(ValidFrom,CONVERT(DATETIME,'19000101')),112)
	AND CONVERT(NVARCHAR(50),ISNULL(ValidTo,CONVERT(DATETIME,'20990101')),112)
	AND ([Type] = 2 or SubtType in (112,122,113,123))
	--从经销商待生效价格表中删除
	DELETE FROM DealerNewPrice
	WHERE CONVERT(NVARCHAR(50),GETDATE(),112) BETWEEN
	CONVERT(NVARCHAR(50),ISNULL(ValidFrom,CONVERT(DATETIME,'19000101')),112)
	AND CONVERT(NVARCHAR(50),ISNULL(ValidTo,CONVERT(DATETIME,'20990101')),112)
	AND ([Type] = 2 or SubtType in (112,122,113,123))
	
	--处理可能的价格重复情况
	SELECT UPN,CustomerSapCode,MAX(InstancdId) AS InstancdId INTO #TMP_DATA_1 FROM #TMP_DATA GROUP BY UPN,CustomerSapCode

	DELETE FROM #TMP_DATA
	WHERE EXISTS (SELECT 1 FROM #TMP_DATA_1 WHERE #TMP_DATA_1.UPN = #TMP_DATA.UPN
	AND #TMP_DATA_1.CustomerSapCode = #TMP_DATA.CustomerSapCode AND #TMP_DATA_1.InstancdId > #TMP_DATA.InstancdId)
	
	SELECT InstancdId,DealerMaster.DMA_ID,CFN.CFN_CustomerFaceNbr AS UPN,T.NewPrice AS UNITPRICE,'盒' AS UOM,CFN.CFN_ID,T.ValidFrom,T.ValidTo,IsForRebate
	INTO #TMP_PRICE 
	FROM #TMP_DATA T
	INNER JOIN CFN ON CFN.CFN_Property1 = T.UPN
	INNER JOIN DealerMaster on DealerMaster.DMA_SAP_Code = T.CustomerSapCode

	--更新产品价格表
	--存在的更新，不存在的新增
  --从2017-05-22开始，组套设备价格不再使用比例
	--UPDATE CFNPrice SET CFNP_Price = CASE WHEN IsForRebate= 1 THEN 1 + T.UNITPRICE ELSE Convert(Decimal(18,2),T.UNITPRICE) END, CFNP_UpdateUser = @SysUserId, CFNP_UpdateDate = GETDATE(),
  UPDATE CFNPrice SET CFNP_Price = Convert(Decimal(18,2),T.UNITPRICE) , CFNP_UpdateUser = @SysUserId, CFNP_UpdateDate = GETDATE(),
	CFNP_ValidDateFrom = T.ValidFrom,CFNP_ValidDateTo = T.ValidTo, CFNP_Market_Price = T.UNITPRICE,
	CFNP_UOM_Inventory = ISNULL(Convert(nvarchar(20),InstancdId),'')
	FROM #TMP_PRICE T WHERE T.CFN_ID = CFNPrice.CFNP_CFN_ID
	AND CFNPrice.CFNP_Group_ID = T.DMA_ID
	AND CFNPrice.CFNP_PriceType = 'Dealer'

	--UPDATE CFNPrice SET CFNP_Price = CASE WHEN IsForRebate= 1 THEN 1 + T.UNITPRICE ELSE Convert(Decimal(18,2),T.UNITPRICE) END, CFNP_UpdateUser = @SysUserId, CFNP_UpdateDate = GETDATE(),
  UPDATE CFNPrice SET CFNP_Price = Convert(Decimal(18,2),T.UNITPRICE), CFNP_UpdateUser = @SysUserId, CFNP_UpdateDate = GETDATE(),
	CFNP_ValidDateFrom = T.ValidFrom,CFNP_ValidDateTo = T.ValidTo, CFNP_Market_Price = T.UNITPRICE,
	CFNP_UOM_Inventory = ISNULL(Convert(nvarchar(20),InstancdId),'')
	FROM #TMP_PRICE T WHERE T.CFN_ID = CFNPrice.CFNP_CFN_ID
	AND CFNPrice.CFNP_Group_ID = T.DMA_ID
	AND CFNPrice.CFNP_PriceType = 'DealerConsignment'			
	
	INSERT INTO CFNPrice
	(
		CFNP_ID,
		CFNP_CFN_ID,
		CFNP_PriceType,
		CFNP_Group_ID,
		CFNP_CanOrder,
		CFNP_Price,
		CFNP_Currency,
		CFNP_UOM,
		CFNP_UOM_Inventory,
		CFNP_CreateUser,
		CFNP_CreateDate,
		CFNP_DeletedFlag,
		CFNP_ValidDateFrom,
		CFNP_ValidDateTo,
		CFNP_Market_Price
	)
	
  select newid(),CFNP_CFN_ID,
		CFNP_PriceType,
		CFNP_Group_ID,
		CFNP_CanOrder,
		CFNP_Price,
		CFNP_Currency,
		CFNP_UOM,
		CFNP_UOM_Inventory,
		CFNP_CreateUser,
		CFNP_CreateDate,
		CFNP_DeletedFlag,
		CFNP_ValidDateFrom,
		CFNP_ValidDateTo,
		CFNP_Market_Price
  from (
  SELECT distinct T.CFN_ID AS CFNP_CFN_ID,'Dealer' AS CFNP_PriceType,
         T.DMA_ID AS CFNP_Group_ID,1 AS CFNP_CanOrder,T.UNITPRICE AS CFNP_Price,'CNY' AS CFNP_Currency,T.UOM AS CFNP_UOM,
	ISNULL(Convert(nvarchar(20),InstancdId),'') AS CFNP_UOM_Inventory,@SysUserId AS CFNP_CreateUser,
  GETDATE() AS CFNP_CreateDate,0 AS CFNP_DeletedFlag,T.ValidFrom AS CFNP_ValidDateFrom,T.ValidTo AS CFNP_ValidDateTo,T.UNITPRICE AS CFNP_Market_Price
	FROM #TMP_PRICE T
	WHERE NOT EXISTS (SELECT 1 FROM CFNPrice WHERE CFNP_CFN_ID = T.CFN_ID
	AND CFNP_Group_ID = T.DMA_ID AND CFNP_PriceType = 'Dealer')
  ) tab

	INSERT INTO CFNPrice
	(
		CFNP_ID,
		CFNP_CFN_ID,
		CFNP_PriceType,
		CFNP_Group_ID,
		CFNP_CanOrder,
		CFNP_Price,
		CFNP_Currency,
		CFNP_UOM,
		CFNP_UOM_Inventory,
		CFNP_CreateUser,
		CFNP_CreateDate,
		CFNP_DeletedFlag,
		CFNP_ValidDateFrom,
		CFNP_ValidDateTo,
		CFNP_Market_Price
	)
	select newid(),CFNP_CFN_ID,
		CFNP_PriceType,
		CFNP_Group_ID,
		CFNP_CanOrder,
		CFNP_Price,
		CFNP_Currency,
		CFNP_UOM,
		CFNP_UOM_Inventory,
		CFNP_CreateUser,
		CFNP_CreateDate,
		CFNP_DeletedFlag,
		CFNP_ValidDateFrom,
		CFNP_ValidDateTo,
		CFNP_Market_Price
  from (
  SELECT distinct T.CFN_ID AS CFNP_CFN_ID,'DealerConsignment' AS CFNP_PriceType,
         T.DMA_ID AS CFNP_Group_ID,1 AS CFNP_CanOrder,T.UNITPRICE AS CFNP_Price,'CNY' AS CFNP_Currency,T.UOM AS CFNP_UOM,
	ISNULL(Convert(nvarchar(20),InstancdId),'') AS CFNP_UOM_Inventory,@SysUserId AS CFNP_CreateUser,
  GETDATE() AS CFNP_CreateDate,0 AS CFNP_DeletedFlag,T.ValidFrom AS CFNP_ValidDateFrom,T.ValidTo AS CFNP_ValidDateTo,T.UNITPRICE AS CFNP_Market_Price
	FROM #TMP_PRICE T
	WHERE NOT EXISTS (SELECT 1 FROM CFNPrice WHERE CFNP_CFN_ID = T.CFN_ID
	AND CFNP_Group_ID = T.DMA_ID AND CFNP_PriceType = 'DealerConsignment')
  ) tab

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN

    return -1
    
END CATCH
GO


