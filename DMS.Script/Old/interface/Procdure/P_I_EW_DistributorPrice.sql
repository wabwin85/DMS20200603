
DROP Procedure [interface].[P_I_EW_DistributorPrice]
GO

CREATE Procedure [interface].[P_I_EW_DistributorPrice]
	@InstancdId INT,
	@Price Int,
	@DealerID nvarchar(200)
AS
	DECLARE @PriceType INT
  DECLARE @SubType INT
	DECLARE @SysUserId uniqueidentifier
	DECLARE @BatchNbr NVARCHAR(30)
SET NOCOUNT ON

BEGIN TRY
	SET @BatchNbr = ''
	EXEC dbo.GC_GetNextAutoNumberForInt 'SYS','P_I_EW_DistributorPrice',@BatchNbr OUTPUT

	SET @SysUserId = '00000000-0000-0000-0000-000000000000'	
BEGIN TRAN
	
	SELECT TOP 1 @PriceType = [Type],@SubType = SubtType FROM interface.T_I_EW_DistributorPrice
	WHERE InstancdId = @InstancdId
	--�������̼۸�
	--ֻ����ǰ��Ч�Ĳ�Ʒ�۸�
	IF (@PriceType = 2 OR @SubType in (112,122,113,123))
		BEGIN
			SELECT DP.InstancdId, [Type], SubtType, DP.UPN, Qty, max(NewPrice) AS NewPrice, CustomerSapCode, ValidFrom, ValidTo, Reason, IsForRebate, Lot
        INTO #TMP_DATA 
        FROM interface.T_I_EW_DistributorPrice AS DP 
       inner join (select InstancdId,UPN,MAX(CreateDate) AS createDate
                     from interface.T_I_EW_DistributorPrice where InstancdId=@InstancdId
                    group by InstancdId,UPN) AS MaxDate 
                   ON (MaxDate.InstancdId = DP.InstancdId and MaxDate.UPN=DP.UPN and MaxDate.createDate=DP.CreateDate)
	     WHERE DP.InstancdId = @InstancdId
       GROUP BY DP.InstancdId, [Type], SubtType, DP.UPN, Qty, CustomerSapCode, ValidFrom, ValidTo, Reason, IsForRebate, Lot
            
			--����δ����Ч�ļ۸����������DealerNewPrice
			INSERT INTO DealerNewPrice
			SELECT InstancdId, [Type], SubtType, UPN, Qty, NewPrice, CustomerSapCode, ValidFrom, ValidTo, Reason, IsForRebate, Lot 
      FROM #TMP_DATA
			WHERE CONVERT(NVARCHAR(50),GETDATE(),112) < CONVERT(NVARCHAR(50),ISNULL(ValidFrom,CONVERT(DATETIME,'19000101')),112)
			
			--ɾ����ǰ����Ҫ����ļ۸�
			DELETE FROM #TMP_DATA 
			WHERE CONVERT(NVARCHAR(50),GETDATE(),112) < CONVERT(NVARCHAR(50),ISNULL(ValidFrom,CONVERT(DATETIME,'19000101')),112) 
			OR CONVERT(NVARCHAR(50),GETDATE(),112) > CONVERT(NVARCHAR(50),ISNULL(ValidTo,CONVERT(DATETIME,'20990101')),112)

			SELECT InstancdId,DealerMaster.DMA_ID,CFN.CFN_CustomerFaceNbr AS UPN,T.NewPrice AS UNITPRICE,'��' AS UOM,CFN.CFN_ID,T.ValidFrom,T.ValidTo,IsForRebate
			INTO #TMP_PRICE 
			FROM #TMP_DATA T
			INNER JOIN CFN ON CFN.CFN_Property1 = T.UPN
			INNER JOIN DealerMaster on DealerMaster.DMA_SAP_Code = T.CustomerSapCode

			--���²�Ʒ�۸��
			--���ڵĸ��£������ڵ�����
      --�����豸��Ʒ (2017-05-22�����ײ�Ʒ����ʹ�ñ���)      
			--UPDATE CFNPrice SET CFNP_Price = CASE WHEN IsForRebate= 1 THEN 1 + T.UNITPRICE ELSE Convert(Decimal(18,2),T.UNITPRICE) END, CFNP_UpdateUser = @SysUserId, CFNP_UpdateDate = GETDATE(),
      UPDATE CFNPrice 
			SET CFNP_Price =  
					CASE WHEN EXISTS(SELECT 1 FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),CFNP_ValidDateFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
						THEN Convert(Decimal(18,2),T.UNITPRICE) /(SELECT TOP 1 DC.DC_ExchangeRate FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),CFNP_ValidDateFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
					ELSE Convert(Decimal(18,2),T.UNITPRICE) END, 
			CFNP_Currency=
			CASE WHEN EXISTS(SELECT 1 FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),CFNP_ValidDateFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
						THEN (SELECT TOP 1 DC.DC_Currency FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),CFNP_ValidDateFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
					ELSE 'CNY' END, 
			
			
			CFNP_UpdateUser = @SysUserId, CFNP_UpdateDate = GETDATE(),
			CFNP_ValidDateFrom = T.ValidFrom,CFNP_ValidDateTo = T.ValidTo, 
			
			CFNP_Market_Price=CASE WHEN EXISTS(SELECT 1 FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),CFNP_ValidDateFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
						THEN Convert(Decimal(18,2),T.UNITPRICE) /(SELECT TOP 1 DC.DC_ExchangeRate FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),CFNP_ValidDateFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
					ELSE Convert(Decimal(18,2),T.UNITPRICE) END, 
			--CFNP_Market_Price = T.UNITPRICE, 
			
			CFNP_UOM_Inventory = ISNULL(Convert(nvarchar(20),InstancdId),'')
			FROM #TMP_PRICE T WHERE T.CFN_ID = CFNPrice.CFNP_CFN_ID
			AND CFNPrice.CFNP_Group_ID = T.DMA_ID
			AND CFNPrice.CFNP_PriceType = 'Dealer'

			--UPDATE CFNPrice SET CFNP_Price = CASE WHEN IsForRebate= 1 THEN 1 + T.UNITPRICE ELSE Convert(Decimal(18,2),T.UNITPRICE) END, CFNP_UpdateUser = @SysUserId, CFNP_UpdateDate = GETDATE(),
      UPDATE CFNPrice 
			--SET CFNP_Price = Convert(Decimal(18,2),T.UNITPRICE) , 
			SET CFNP_Price =  
					CASE WHEN EXISTS(SELECT 1 FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),CFNP_ValidDateFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
						THEN Convert(Decimal(18,2),T.UNITPRICE) /(SELECT TOP 1 DC.DC_ExchangeRate FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),CFNP_ValidDateFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
					ELSE Convert(Decimal(18,2),T.UNITPRICE) END, 
			CFNP_Currency=
			CASE WHEN EXISTS(SELECT 1 FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),CFNP_ValidDateFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
						THEN (SELECT TOP 1 DC.DC_Currency FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),CFNP_ValidDateFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
					ELSE 'CNY' END, 
			
			CFNP_UpdateUser = @SysUserId, CFNP_UpdateDate = GETDATE(),
			CFNP_ValidDateFrom = T.ValidFrom,CFNP_ValidDateTo = T.ValidTo, 
			
			CFNP_Market_Price=CASE WHEN EXISTS(SELECT 1 FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),CFNP_ValidDateFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
						THEN Convert(Decimal(18,2),T.UNITPRICE) /(SELECT TOP 1 DC.DC_ExchangeRate FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),CFNP_ValidDateFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
					ELSE Convert(Decimal(18,2),T.UNITPRICE) END, 
			--CFNP_Market_Price = T.UNITPRICE, 
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
			--SELECT NEWID(),T.CFN_ID,'Dealer',T.DMA_ID,1,CASE WHEN IsForRebate= 1 THEN 1 + T.UNITPRICE ELSE Convert(Decimal(18,2),T.UNITPRICE) END,'CNY',T.UOM,
      SELECT NEWID(),T.CFN_ID,'Dealer',T.DMA_ID,1,
			
			CASE WHEN EXISTS(SELECT 1 FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),T.ValidFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
						THEN Convert(Decimal(18,2),T.UNITPRICE) /(SELECT TOP 1 DC.DC_ExchangeRate FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),T.ValidFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
					ELSE Convert(Decimal(18,2),T.UNITPRICE) END,
			--Convert(Decimal(18,2),T.UNITPRICE),
			CASE WHEN EXISTS(SELECT 1 FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),T.ValidFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
						THEN (SELECT TOP 1 DC.DC_Currency FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),T.ValidFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
					ELSE 'CNY' END, 
			--'CNY',
			
			T.UOM,
			--ISNULL(Convert(nvarchar(20),InstancdId),''),@SysUserId,GETDATE(),0,T.ValidFrom,T.ValidTo,CASE WHEN IsForRebate= 1 THEN 1 + T.UNITPRICE ELSE Convert(Decimal(18,2),T.UNITPRICE) END
			ISNULL(Convert(nvarchar(20),InstancdId),''),@SysUserId,GETDATE(),0,T.ValidFrom,T.ValidTo, 
			
			CASE WHEN EXISTS(SELECT 1 FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),T.ValidFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
				THEN Convert(Decimal(18,2),T.UNITPRICE) /(SELECT TOP 1 DC.DC_ExchangeRate FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),T.ValidFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
			ELSE Convert(Decimal(18,2),T.UNITPRICE) END
			--Convert(Decimal(18,2),T.UNITPRICE)
			FROM #TMP_PRICE T
			WHERE NOT EXISTS (SELECT 1 FROM CFNPrice WHERE CFNP_CFN_ID = T.CFN_ID
			AND CFNP_Group_ID = T.DMA_ID AND CFNP_PriceType = 'Dealer')

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
			--SELECT NEWID(),T.CFN_ID,'DealerConsignment',T.DMA_ID,1,CASE WHEN IsForRebate= 1 THEN 1 + T.UNITPRICE ELSE Convert(Decimal(18,2),T.UNITPRICE) END,'CNY',T.UOM,
      SELECT NEWID(),T.CFN_ID,'DealerConsignment',T.DMA_ID,1,
      
				CASE WHEN EXISTS(SELECT 1 FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),T.ValidFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
						THEN Convert(Decimal(18,2),T.UNITPRICE) /(SELECT TOP 1 DC.DC_ExchangeRate FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),T.ValidFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
					ELSE Convert(Decimal(18,2),T.UNITPRICE) END,
			  --Convert(Decimal(18,2),T.UNITPRICE) ,
			  
			  	CASE WHEN EXISTS(SELECT 1 FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),T.ValidFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
						THEN (SELECT TOP 1 DC.DC_Currency FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),T.ValidFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
					ELSE 'CNY' END, 
			  --'CNY',
			  T.UOM,
			--ISNULL(Convert(nvarchar(20),InstancdId),''),@SysUserId,GETDATE(),0,T.ValidFrom,T.ValidTo,CASE WHEN IsForRebate= 1 THEN 1 + T.UNITPRICE ELSE Convert(Decimal(18,2),T.UNITPRICE) END
			ISNULL(Convert(nvarchar(20),InstancdId),''),@SysUserId,GETDATE(),0,T.ValidFrom,T.ValidTo,
			
			CASE WHEN EXISTS(SELECT 1 FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),T.ValidFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
				THEN Convert(Decimal(18,2),T.UNITPRICE) /(SELECT TOP 1 DC.DC_ExchangeRate FROM dbo.DealerCurrency DC  WHERE DC.DC_DMA_ID=T.DMA_ID AND CONVERT(NVARCHAR(10),T.ValidFrom,120) BETWEEN DC_BeginDate AND DC_EndDate) 
			ELSE Convert(Decimal(18,2),T.UNITPRICE) END
			--Convert(Decimal(18,2),T.UNITPRICE)
			FROM #TMP_PRICE T
			WHERE NOT EXISTS (SELECT 1 FROM CFNPrice WHERE CFNP_CFN_ID = T.CFN_ID
			AND CFNP_Group_ID = T.DMA_ID AND CFNP_PriceType = 'DealerConsignment')			
		END
  
 

	--��¼��־
	INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_Message,IL_ClientID,IL_BatchNbr) 
	VALUES (NEWID(),'P_I_EW_DistributorPrice',GETDATE(),GETDATE(),'Success','�ӿڵ��óɹ���InstancdId = '+CONVERT(NVARCHAR(50),@InstancdId),'SYS',@BatchNbr)
	
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN

	--��¼��־
	INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_Message,IL_ClientID,IL_BatchNbr) 
	VALUES (NEWID(),'P_I_EW_DistributorPrice',GETDATE(),GETDATE(),'Failure','�ӿڵ���ʧ�ܣ�InstancdId = '+CONVERT(NVARCHAR(50),@InstancdId) + ' ������Ϣ��' + ERROR_MESSAGE(),'SYS',@BatchNbr)

    return -1
    
END CATCH
GO


