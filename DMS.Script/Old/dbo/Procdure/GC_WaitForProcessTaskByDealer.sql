
DROP PROCEDURE [dbo].[GC_WaitForProcessTaskByDealer]
GO


CREATE PROCEDURE [dbo].[GC_WaitForProcessTaskByDealer]
	@DealerId UNIQUEIDENTIFIER,
	@OwnerId UNIQUEIDENTIFIER
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		CREATE TABLE #Temp
		(
			ModelID NVARCHAR(200),
			RecordCount NVARCHAR(200),
			ItemQty NVARCHAR(200),
			TotalAmount NVARCHAR(200)	
		)
		
		DECLARE @recordCount NVARCHAR(200);
		DECLARE @itemNumber NVARCHAR(200);
		DECLARE @totalAmount NVARCHAR(200);
		
		--经销商待收货数量
		SELECT @recordCount = COUNT(1)
		  FROM
		  POReceiptHeader nolock
		  WHERE PRH_Dealer_DMA_ID= @DealerId
		  AND PRH_Status= 'Waiting'; 
		  --AND EXISTS (SELECT 1 FROM DealerMaster WHERE DealerMaster.DMA_ID = POReceiptHeader.PRH_Dealer_DMA_ID 
		--					AND ISNULL(DealerMaster.DMA_SystemStartDate,CONVERT(DATETIME,'2999-12-31')) <= POReceiptHeader.PRH_SAPShipmentDate);
		
		INSERT INTO #Temp VALUES ('POReceiptHeader', @recordCount , NULL, NULL);
		
		--经销商投诉单未回复数
		SELECT @recordCount = COUNT(1) 
			FROM 
			DealerQA with(nolock)
			WHERE DQA_Status = 'Submitted'
			AND DQA_Dealer_ID = @DealerId
			AND DQA_Category = '1' 
		
		INSERT INTO #Temp VALUES ('DealerQA', @recordCount , NULL, NULL);
		
		--上传库存数据数量
		--如果当前日期大于当月25日，且小于次月的第6个工作日，则开始统计上传库存数据数量，
    --不需要提醒了，取消提醒 Edit By SongWeiming on 2016-10-17 
		/*
    declare @curDate datetime
		declare @cur20thDay nvarchar(10)
		select  @curDate = getdate()
		select @cur20thDay = max(CDD_Calendar)+'20' from CalendarDate where cDD_Calendar + right('00'+Convert(nvarchar(2),cdd_Date1),2)<CONVERT(VARCHAR(8),@curDate,112) 
		--select @cur20thDay
		IF ( Convert(int,Convert(nvarchar(8),@curDate,112)) <= Convert(int,@cur20thDay) )
		  BEGIN
		    SET @recordCount = 1
		  END
		ELSE
		  BEGIN
		    SELECT @recordCount = COUNT(1)
			  FROM DealerInventoryData
			 WHERE DID_DMA_ID = @DealerId
			   AND DID_Period= (select max(CDD_Calendar) from CalendarDate where cDD_Calendar + right('00'+Convert(nvarchar(2),cdd_Date1),2)<CONVERT(VARCHAR(8),getdate(),112) )
		  END
		*/
		--INSERT INTO #Temp VALUES ('UploadInventory', @recordCount , NULL, NULL);
    INSERT INTO #Temp VALUES ('UploadInventory', 1 , NULL, NULL);
		
    
		--填写销售数据数量
		SELECT @recordCount = COUNT(1) 
			FROM ShipmentHeader with(nolock)
			WHERE SPH_Dealer_DMA_ID = @DealerId			
			AND CONVERT(VARCHAR(6),SPH_ShipmentDate,112) = (select max(CDD_Calendar) from CalendarDate where cDD_Calendar + right('00'+Convert(nvarchar(2),cdd_Date1),2)<CONVERT(VARCHAR(8),getdate(),112) )
		
		INSERT INTO #Temp VALUES ('UploadLog', @recordCount , NULL, NULL);
		
		SELECT @recordCount = COUNT(1)
			FROM ShipmentHeader with(nolock)
			WHERE SPH_Dealer_DMA_ID = @DealerId
			AND SPH_Status <> 'Draft'
			AND CONVERT(VARCHAR(6),SPH_SubmitDate,112) = CONVERT(VARCHAR(6),getdate(),112)
		
		INSERT INTO #Temp VALUES ('ShipmentHeader', @recordCount , NULL, NULL);
		
		
		--本月已采购数量（订单：数量、金额）
		SELECT 
			@itemNumber = SUM(ISNULL(Detail.POD_RequiredQty,0)),	--总数量
			@totalAmount = Convert(money,isnull(sum(CASE when Head.POH_OrderType in ('PEGoodsReturn','EEGoodsReturn') then 0 else 
                            ISNULL (Detail.POD_Amount,0) + ISNULL(Detail.POD_Tax, 0) END),0)) --总金额
			FROM PurchaseOrderHeader Head with(nolock),PurchaseOrderDetail Detail with(nolock)
			WHERE Head.POH_ID = Detail.POD_POH_ID
			AND POH_DMA_ID = @DealerId
			AND POH_CreateType not in ('Temporary')
			AND POH_OrderStatus <> 'Draft' AND POH_OrderStatus <> 'Revoked'
			AND CONVERT(VARCHAR(6),Head.POH_SubmitDate,112) = CONVERT(VARCHAR(6),getdate(),112)
		
		INSERT INTO #Temp VALUES ('OrderQT', NULL , @itemNumber, @totalAmount);
		
		
		--本月累计销售（销售单：数量、金额）
		SELECT 
			@itemNumber = SUM(ISNULL(Lot.SLT_LotShippedQty,0)),
			@totalAmount = SUM(CONVERT(DECIMAL(18,6),ISNULL(Lot.SLT_LotShippedQty,0))*ISNULL(Lot.SLT_UnitPrice,0))
			FROM ShipmentHeader Head with(nolock),ShipmentLine Line with(nolock),ShipmentLot Lot with(nolock)
			WHERE Head.SPH_ID = Line.SPL_SPH_ID AND SPL_ID = Lot.SLT_SPL_ID
			AND Head.SPH_Dealer_DMA_ID = @DealerId
			AND Head.SPH_Status <> 'Draft'
			AND CONVERT(VARCHAR(6),Head.SPH_ShipmentDate,112) = CONVERT(VARCHAR(6),getdate(),112)
		
		INSERT INTO #Temp VALUES ('ShipmentQT', NULL , @itemNumber, @totalAmount);
		
		
		--本月累计冲红（冲红销售单：数量、金额）
		SELECT 
			@itemNumber = SUM(ISNULL(Lot.SLT_LotShippedQty,0)),
			@totalAmount = SUM(CONVERT(DECIMAL(18,6),ISNULL(Lot.SLT_LotShippedQty,0))*ISNULL(Lot.SLT_UnitPrice,0))
			FROM ShipmentHeader Head with(nolock),ShipmentLine Line with(nolock),ShipmentLot Lot with(nolock)
			WHERE Head.SPH_ID = Line.SPL_SPH_ID AND SPL_ID = Lot.SLT_SPL_ID 
			AND Head.SPH_Dealer_DMA_ID = @DealerId
			AND Head.SPH_Status = 'Reversed'
			AND Head.SPH_Reverse_SPH_ID IS NOT NULL
			AND CONVERT(VARCHAR(6),Head.SPH_ShipmentDate,112) = CONVERT(VARCHAR(6),getdate(),112)
			
		INSERT INTO #Temp VALUES ('ShipmentReversedQT', NULL , @itemNumber, @totalAmount);
		
		
		--本月累计IC产品线发票金额（有发票销售单：金额）
		SELECT 
			@itemNumber = SUM(ISNULL(Lot.SLT_LotShippedQty,0)),
			@totalAmount = SUM(CONVERT(DECIMAL(18,6),ISNULL(Lot.SLT_LotShippedQty,0))*ISNULL(Lot.SLT_UnitPrice,0))
			FROM ShipmentHeader Head with(nolock),ShipmentLine Line with(nolock),ShipmentLot Lot with(nolock)
			WHERE Head.SPH_ID = Line.SPL_SPH_ID AND SPL_ID = Lot.SLT_SPL_ID
			AND Head.SPH_Dealer_DMA_ID = @DealerId
			AND Head.SPH_Status <> 'Draft'
			AND Head.SPH_InvoiceNo IS NOT NULL
			AND Head.SPH_InvoiceNo <> ''
			AND Head.SPH_Reverse_SPH_ID IS NULL
			AND Head.SPH_ProductLine_BUM_ID = '0f71530b-66d5-44af-9cab-ad65d5449c51'
			AND CONVERT(VARCHAR(6),Head.SPH_SubmitDate,112) = CONVERT(VARCHAR(6),getdate(),112)
			
		INSERT INTO #Temp VALUES ('ShipmentICQT', NULL , @itemNumber, @totalAmount);
		
		
		--本月累计借货出库（借货出库单：数量）
		SELECT
			@itemNumber = SUM(ISNULL(Line.TRL_TransferQty,0))
			FROM Transfer Trans with(nolock),TransferLine Line with(nolock)
			WHERE Trans.TRN_ID = Line.TRL_TRN_ID
			AND Trans.TRN_FromDealer_DMA_ID = @DealerId
			AND Trans.TRN_Type IN ('Rent','RentConsignment')
			AND Trans.TRN_Status <> 'Draft' AND Trans.TRN_Status <> 'Cancelled'
			AND CONVERT(VARCHAR(6),Trans.TRN_TransferDate,112) = CONVERT(VARCHAR(6),getdate(),112)
			
		INSERT INTO #Temp VALUES ('TransferQT', NULL , @itemNumber, NULL);
		
		
		--本月累计退货（审批通过的退货单：数量）
		SELECT  
			@itemNumber = SUM(ISNULL(Detail.IAD_Quantity,0))
		FROM InventoryAdjustHeader Head with(nolock),InventoryAdjustDetail Detail with(nolock)
		WHERE Head.IAH_ID = Detail.IAD_IAH_ID
		AND Head.IAH_DMA_ID = @DealerId
		AND Head.IAH_Reason = 'Return'
		AND Head.IAH_Status <> 'Draft' AND Head.IAH_Status <> 'Cancelled'
		AND CONVERT(VARCHAR(6),Head.IAH_CreatedDate,112) = CONVERT(VARCHAR(6),getdate(),112)
		
		INSERT INTO #Temp VALUES ('InventoryAdjustQT', NULL , @itemNumber, NULL);
		
		
		--经销商普通库库存（包括缺省仓库）
		SELECT @itemNumber = ISNULL(sum (CONVERT (DECIMAL (18, 2), isnull (Inv_onhandQuantity, 0))),0)
		  FROM Inventory with(nolock)
		 WHERE  EXISTS
				  (SELECT 1
					 FROM Warehouse
					WHERE     WHM_DMA_ID = @DealerId
						  AND WHM_Type IN ('Normal', 'DefaultWH','Frozen') AND INV_WHM_ID=WHM_ID )
						  
		INSERT INTO #Temp VALUES ('NormalInventory', NULL , @itemNumber, NULL);
		--经销商寄售库库存数
		SELECT @itemNumber = ISNULL(sum (CONVERT (DECIMAL (18, 2), isnull (Inv_onhandQuantity, 0))),0)
		  FROM Inventory with(nolock)
		 WHERE EXISTS 
				  (SELECT 1
					 FROM Warehouse
					WHERE     WHM_DMA_ID = @DealerId
						  AND WHM_Type IN ('Consignment', 'LP_Consignment') AND INV_WHM_ID=WHM_ID)
		INSERT INTO #Temp VALUES ('ConsignmentInventory', NULL , @itemNumber, NULL);
		--经销商借货库库存数
		SELECT @itemNumber = ISNULL(sum (CONVERT (DECIMAL (18, 2), isnull (Inv_onhandQuantity, 0))),0)
		  FROM Inventory with(nolock)
		 WHERE EXISTS 
				  (SELECT 1
					 FROM Warehouse
					WHERE     WHM_DMA_ID = @DealerId
						  AND WHM_Type IN ('Borrow') AND INV_WHM_ID=WHM_ID)
		INSERT INTO #Temp VALUES ('BorrowInventory', NULL , @itemNumber, NULL);
		
		--经销商在途库库存数
		SELECT @itemNumber = ISNULL(sum (CONVERT (DECIMAL (18, 2), isnull (Inv_onhandQuantity, 0))),0)
		  FROM Inventory with(nolock)
		 WHERE EXISTS
				  (SELECT WHM_ID
					 FROM Warehouse
					WHERE     WHM_DMA_ID = @DealerId
						  AND WHM_Type IN ('SystemHold') AND INV_WHM_ID=WHM_ID)
		INSERT INTO #Temp VALUES ('SystemHoldInventory', NULL , @itemNumber, NULL);
		
		
		--是否具备订单管理的权限
		SELECT @itemNumber = COUNT(*)
		  FROM Lafite_IDENTITY t1 with(nolock),Lafite_IDENTITY_MAP t2 with(nolock),Lafite_ATTRIBUTE_MAP t3 with(nolock),Lafite_STRATEGY t4 with(nolock)
		 WHERE     t1.Id = t2.IDENTITY_ID
			   AND t2.MAP_ID = t3.ATTRIBUTE_ID
			   AND t3.MAP_ID = t4.Id
			   AND t4.STRATEGY_NAME = '订单管理'
			   AND t1.Id = @OwnerId	
		INSERT INTO #Temp VALUES ('HasOrderStrategy', NULL , @itemNumber, NULL);
    
    --填写T2销售预测数量
	  select @recordCount = COUNT(1) 
      from  DealerPurchaseForecastAdjust with(nolock)   
		 WHERE PFA_DMA_ID = @DealerId	
      AND PFA_ForecastVersion = Convert(nvarchar(6),getdate(),112) 
      and Convert(nvarchar(8),getdate(),112)  >= (select CDD_Calendar + right('00'+Convert(nvarchar(2),cdd_Date8),2) from CalendarDate where CDD_Calendar = Convert(nvarchar(6),getdate(),112) )
      and Convert(nvarchar(8),getdate(),112)  <= (select CDD_Calendar + right('00'+Convert(nvarchar(2),cdd_Date9),2) from CalendarDate where CDD_Calendar = Convert(nvarchar(6),getdate(),112) )
      and (PFA_Forecast_M1 is null or PFA_ForecastAdj_M2 is null or PFA_ForecastAdj_M3 is null)
    
		INSERT INTO #Temp VALUES ('UploadSalesForecast', @recordCount , NULL, NULL);
		
	--提示超过九十天未上传发票
	 	 
	  
		set @recordCount=(select * from GC_Fn_ShipmentFileUpload(@DealerId))
		INSERT INTO #Temp VALUES ('UploadInvoice', @recordCount , NULL, NULL);
		
		
		SELECT * FROM #Temp;
		SET NOCOUNT OFF;
		RETURN 1;
	END TRY

	BEGIN CATCH 
		SET NOCOUNT OFF
		RETURN -1;
	    
	END CATCH
END
