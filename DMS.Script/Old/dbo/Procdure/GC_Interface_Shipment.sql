DROP PROCEDURE [dbo].[GC_Interface_Shipment]
GO

CREATE PROCEDURE [dbo].[GC_Interface_Shipment]
   @BatchNbr       NVARCHAR (30),
   @ClientID       NVARCHAR (50),
   @IsValid        NVARCHAR (20) OUTPUT,
   @RtnMsg         NVARCHAR (500) OUTPUT
AS
   DECLARE @ErrorCount   INTEGER
   DECLARE @Vender_DMA_ID   UNIQUEIDENTIFIER
   DECLARE @SysUserId   UNIQUEIDENTIFIER
   DECLARE @Client_DMA_ID   UNIQUEIDENTIFIER
   DECLARE @LPSystemHoldWarehouse   UNIQUEIDENTIFIER
   DECLARE @LPDefaultWHWarehouse   UNIQUEIDENTIFIER
   DECLARE @EmptyGuid   UNIQUEIDENTIFIER
   DECLARE @ErrCnt   INT
   DECLARE @CNT INT
   DECLARE @WhmType NVARCHAR(50)
   DECLARE @ReturnType NVARCHAR(50) --投诉退货类型
   DECLARE @Status NVARCHAR(50)
   
	DECLARE @DealerDMAID   UNIQUEIDENTIFIER
	DECLARE @BusinessUnitName   NVARCHAR (20)
	DECLARE @ID   UNIQUEIDENTIFIER
	DECLARE @PONumber   NVARCHAR (50)
	
	Declare @ProcLineNum nvarchar(20)
	
   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN

      SET @IsValid = 'Success'
      SET @RtnMsg = ''
      SET @SysUserId = '00000000-0000-0000-0000-000000000000'
      SET @EmptyGuid = '00000000-0000-0000-0000-000000000000'
	  
	  SET @ProcLineNum = 'Line43'
      
      --创建临时表
      CREATE TABLE #tmpPORImportHeader
      (
         [ID]                 UNIQUEIDENTIFIER NOT NULL,
         [PONumber]           NVARCHAR (30) COLLATE Chinese_PRC_CI_AS NULL,
         [SAPCusPONbr]        NVARCHAR (50) COLLATE Chinese_PRC_CI_AS NULL,
         [SAPShipmentID]      NVARCHAR (50) COLLATE Chinese_PRC_CI_AS NULL,
         [DealerDMAID]        UNIQUEIDENTIFIER NULL,
         [SAPShipmentDate]    DATETIME NULL,
         [Status]             NVARCHAR (50) COLLATE Chinese_PRC_CI_AS NULL,
         [VendorDMAID]        UNIQUEIDENTIFIER NULL,
         [Type]               NVARCHAR (50) COLLATE Chinese_PRC_CI_AS NULL,
         [ProductLineBUMID]   UNIQUEIDENTIFIER NULL,
         [BUName]             NVARCHAR (20) COLLATE Chinese_PRC_CI_AS NULL,
         [Carrier]            NVARCHAR (20) COLLATE Chinese_PRC_CI_AS NULL,
         [TrackingNo]         NVARCHAR (100) COLLATE Chinese_PRC_CI_AS NULL,
         [ShipType]           NVARCHAR (20) COLLATE Chinese_PRC_CI_AS NULL,
         [Note]               NVARCHAR (100) COLLATE Chinese_PRC_CI_AS NULL,
         [SapDeliveryDate]    DATETIME NULL,
         [WHMID]              UNIQUEIDENTIFIER NULL,
         [FromWHMID]		UNIQUEIDENTIFIER NULL
      )

      CREATE TABLE #tmpPORImportLine
      (
         [LineRecID]    UNIQUEIDENTIFIER NOT NULL,
         [PMAID]        UNIQUEIDENTIFIER NOT NULL,
         [ReceiptQty]   FLOAT NOT NULL,
         [HeaderID]     UNIQUEIDENTIFIER NOT NULL,
         [LineNbr]      INT NULL,
         [UnitPrice]    FLOAT NULL
      )

      CREATE TABLE #tmpPORImportLot
      (
         [LotRecID]         UNIQUEIDENTIFIER NOT NULL,
         [LineRecID]        UNIQUEIDENTIFIER NULL,
         [LotNumber]        NVARCHAR (20) COLLATE Chinese_PRC_CI_AS NULL,
         [ReceiptQty]       FLOAT NULL,
         [ExpiredDate]      DATETIME NULL,
         [WarehouseRecID]   UNIQUEIDENTIFIER NULL,
         [DNL_ID]           UNIQUEIDENTIFIER NULL
      )
      
      SET @ProcLineNum = 'Line90'
      
      --得到波科（作为经销商）的ID
      --为了提高效率，不需要查询了，为固定值,Edit By SongWeiming on 2015-12-16
      --      SELECT TOP 1
      --             @Vender_DMA_ID = DMA_ID
      --      FROM DealerMaster
      --      WHERE (DMA_HostCompanyFlag = 1)
      
      SET @Vender_DMA_ID = 'FB62D945-C9D7-4B0F-8D26-4672D2C728B7'

      
      --创建临时表
      --产品临时表
      CREATE TABLE #tmp_product
      (
         PMA_ID       UNIQUEIDENTIFIER,
         PMA_UPN      NVARCHAR (50) COLLATE Chinese_PRC_CI_AS,
         PMA_CFN_ID   UNIQUEIDENTIFIER PRIMARY KEY (PMA_ID)
      )
      
      --发货信息临时表(DeliveryNote临时表)
      CREATE TABLE #tmp_DN 
      (
        [DNL_ID] uniqueidentifier NOT NULL,
        [DNL_LineNbrInFile] int NULL,
        [DNL_ShipToDealerCode] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [DNL_SAPCode] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [DNL_PONbr] nvarchar(30) collate Chinese_PRC_CI_AS NULL,
        [DNL_DeliveryNoteNbr] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [DNL_CFN] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [DNL_UPN] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [DNL_LotNumber] nvarchar(20) collate Chinese_PRC_CI_AS NULL,
        [DNL_ExpiredDate] datetime NULL,
        [DNL_DN_UnitOfMeasure] nvarchar(20) collate Chinese_PRC_CI_AS NULL,
        [DNL_ReceiveUnitOfMeasure] nvarchar(20) collate Chinese_PRC_CI_AS NULL,
        [DNL_ShipQty] float NULL,
        [DNL_ReceiveQty] float NULL,
        [DNL_ShipmentDate] datetime NULL,
        [DNL_ImportFileName] nvarchar(200) collate Chinese_PRC_CI_AS NULL,
        [DNL_OrderType] nvarchar(20) collate Chinese_PRC_CI_AS NULL,
        [DNL_UnitPrice] float NULL,
        [DNL_SubTotal] float NULL,
        [DNL_ShipmentType] nvarchar(20) collate Chinese_PRC_CI_AS NULL,
        [DNL_CreatedDate] datetime NOT NULL,
        [DNL_ProblemDescription] nvarchar(200) collate Chinese_PRC_CI_AS NULL,
        [DNL_ProductDescription] nvarchar(200) collate Chinese_PRC_CI_AS NULL,
        [DNL_SAPSOLine] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [DNL_SAPSalesOrderID] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [DNL_POReceiptLot_PRL_ID] uniqueidentifier NULL,
        [DNL_HandleDate] datetime NULL,
        [DNL_DealerID_DMA_ID] uniqueidentifier NULL,
        [DNL_CFN_ID] uniqueidentifier NULL,
        [DNL_BUName] nvarchar(20) collate Chinese_PRC_CI_AS NULL,
        [DNL_Product_PMA_ID] uniqueidentifier NULL,
        [DNL_ProductLine_BUM_ID] uniqueidentifier NULL,
        [DNL_Authorized] bit NULL,
        [DNL_CreateUser] uniqueidentifier NULL,
        [DNL_Carrier] nvarchar(20) collate Chinese_PRC_CI_AS NULL,
        [DNL_TrackingNo] nvarchar(100) collate Chinese_PRC_CI_AS NULL,   --用户记录产品的生成日期
        [DNL_ShipType] nvarchar(20) collate Chinese_PRC_CI_AS NULL,
        [DNL_Note] nvarchar(100) collate Chinese_PRC_CI_AS NULL,
        [DNL_ProductCatagory_PCT_ID] uniqueidentifier NULL,
        [DNL_SapDeliveryDate] datetime NULL,
        [DNL_LTM_ID] uniqueidentifier NULL,
        [DNL_ToWhmCode] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [DNL_ToWhmId] uniqueidentifier NULL,
        [DNL_ClientID] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [DNL_SapDeliveryLineNbr] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [DNL_BatchNbr] nvarchar(30) collate Chinese_PRC_CI_AS NULL,
        [DNL_FromWhmId] uniqueidentifier NULL
      )
      
      SET @ProcLineNum = 'Line163'
      
      CREATE TABLE #IShipment 
      (
        [ISH_ID] uniqueidentifier NOT NULL,
        [ISH_Dealer_SapCode] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [ISH_OrderNo] nvarchar(30) collate Chinese_PRC_CI_AS NULL,
        [ISH_SapDeliveryNo] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [ISH_SapDeliveryDate] datetime NULL,
        [ISH_ShippingDate] datetime NULL,
        [ISH_ToWhmCode] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [ISH_ArticleNumber] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [ISH_SapDeliveryLineNbr] nvarchar(20) collate Chinese_PRC_CI_AS NULL,
        [ISH_LotNumber] nvarchar(20) collate Chinese_PRC_CI_AS NULL,
        [ISH_ExpiredDate] datetime NULL,
        [ISH_DeliveryQty] decimal(18, 6) NULL,
        [ISH_LineNbr] int NOT NULL,
        [ISH_FileName] nvarchar(200) collate Chinese_PRC_CI_AS NULL,
        [ISH_ImportDate] datetime NOT NULL,
        [ISH_ClientID] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [ISH_BatchNbr] nvarchar(30) collate Chinese_PRC_CI_AS NULL,
        [ISH_ShipmentType] nvarchar(50) collate Chinese_PRC_CI_AS NULL,
        [ISH_UnitPrice] decimal(18, 6) NULL,
        [ISH_WHMCode] nvarchar(50) collate Chinese_PRC_CI_AS NULL		   
      )
      
      
      CREATE TABLE #ClearBorrowOrderNeedtoUpdate 
      (
        [POH_ID] uniqueidentifier NOT NULL
      )
      /*
  	  1、区分是不是投诉类型发货
  	  2、区分物权，BSC的不生成单据，其他生成LP收货单，状态：T2物权为完成，LP物权为待接收
  	  3、退款不生成T2收货单
  	  4、生成LP订单，根据/分割发货中的单号，生成多张订单，价格为0
  	  */
	
		--为了提高效率，且避免死锁，将Interfaceshipment数据写入临时表,然后再进行处理   
    SET @ProcLineNum = 'Line202'
    
    INSERT INTO #IShipment (
           ISH_ID,ISH_Dealer_SapCode,ISH_OrderNo,ISH_SapDeliveryNo,ISH_SapDeliveryDate,ISH_ShippingDate,ISH_ToWhmCode,ISH_ArticleNumber,ISH_SapDeliveryLineNbr,ISH_LotNumber,ISH_ExpiredDate,ISH_DeliveryQty,ISH_LineNbr,ISH_FileName,ISH_ImportDate,ISH_ClientID,ISH_BatchNbr,ISH_ShipmentType,ISH_UnitPrice)
    SELECT ISH_ID,ISH_Dealer_SapCode,ISH_OrderNo,ISH_SapDeliveryNo,ISH_SapDeliveryDate,ISH_ShippingDate,ISH_ToWhmCode,ISH_ArticleNumber,ISH_SapDeliveryLineNbr,ISH_LotNumber,ISH_ExpiredDate,ISH_DeliveryQty,ISH_LineNbr,ISH_FileName,ISH_ImportDate,ISH_ClientID,ISH_BatchNbr,ISH_ShipmentType,ISH_UnitPrice
      FROM InterfaceShipment(nolock) 
     WHERE ISH_BatchNbr = @BatchNbr
    
    SET @ProcLineNum = 'Line210'
    select DC_ID,COMPLAINTID,UPN,DC_CorpId,WHM_ID,RETURNTYPE,CONFIRMRETURNTYPE INTO #DealerComplainBSC 
      from DealerComplain(nolock)
     where COMPLAINTID IS NOT NULL and COMPLAINTID <> '' and DC_ID IS NOT NULL
    
    SET @ProcLineNum = 'Line215'
    select DC_ID,IAN,PI,Serial,DC_CorpId,WHMID,RETURNTYPE INTO #DealerComplainCRM 
      from DealerComplainCRM(nolock) 
     where ((IAN IS NOT NULL and IAN <> '') OR (PI IS NOT NULL and PI <> '')) and DC_ID IS NOT NULL
    
    
    SET @ProcLineNum = 'Line221'
    --查询确认是否是投诉对应的发货单
    select @CNT = COUNT(*) 
      from (
		        SELECT IShip.ISH_ID 
              FROM #IShipment AS IShip
		     LEFT JOIN #DealerComplainBSC AS DCBSC on (CASE WHEN LEN(IShip.ISH_OrderNo) < 3 
                                                        THEN IShip.ISH_OrderNo 
                                                        ELSE CASE WHEN substring(IShip.ISH_OrderNo,1,3)='CRA' 
                                                                  THEN substring(IShip.ISH_OrderNo,3,LEN(IShip.ISH_OrderNo)-2)
                                                                  ELSE IShip.ISH_OrderNo 
                                                                  END 
                                                        END) = 
                                                  (CASE WHEN LEN(DCBSC.COMPLAINTID) <= 10 
                                                        THEN DCBSC.COMPLAINTID 
                                                        ELSE CASE WHEN substring(IShip.ISH_OrderNo,1,3)='CRA' 
                                                                  THEN SUBSTRING(DCBSC.COMPLAINTID,1,PATINDEX ('%-%', DCBSC.COMPLAINTID)-1) 
                                                                  ELSE DCBSC.COMPLAINTID 
                                                                  END
                                                        END)
  						          and IShip.ISH_ArticleNumber = DCBSC.UPN
		     LEFT JOIN DealerMaster AS DM(nolock) ON DCBSC.DC_CorpId = DM.DMA_ID
	           WHERE DM.DMA_DealerType <> 'T1'
		        
            UNION
            
		        SELECT IShip.ISH_ID 
              FROM #IShipment AS IShip
		     LEFT JOIN #DealerComplainCRM AS DCCRM on (CASE WHEN LEN(IShip.ISH_OrderNo) < 3  
                                                        THEN IShip.ISH_OrderNo 
                                                        ELSE CASE WHEN SUBSTRING(IShip.ISH_OrderNo,1,3)='IAN' 
                                                                    THEN SUBSTRING(IShip.ISH_OrderNo,4,LEN(IShip.ISH_OrderNo)-3) 
                                                                  WHEN SUBSTRING(IShip.ISH_OrderNo,1,2)='PI' 
                                                                    THEN SUBSTRING(IShip.ISH_OrderNo,3,LEN(IShip.ISH_OrderNo)-2)
                                                                  ELSE IShip.ISH_OrderNo 
                                                                  END 
                                                        END ) = 
                                                  (CASE WHEN SUBSTRING(ISH_OrderNo,1,3)='IAN' 
                                                        THEN DCCRM.IAN 
                                                        ELSE DCCRM.PI 
                                                        END ) and IShip.ISH_ArticleNumber = DCCRM.Serial
    		 LEFT JOIN DealerMaster AS DM(nolock) ON DCCRM.DC_CorpId = DM.DMA_ID	
    		     WHERE DM.DMA_DealerType <> 'T1') tab
	  
	  
		  --将接口中的发货数据导入到发货记录中
		  --系统根据接口中的“经销商在SAP中的唯一帐号”、“经销商订单编号”、”发货创建日期”,“发货日期”、“发货单号”、“发货单行号”、
		  --“产品编号”、“产品序列号”、“产品有效期”、“发货数量”全部字段进行检查，若接口文件中包含了已经获取的接口数据，
		  --则认为是重复数据，不予处理；若非此情况，则认为是新增的发货数据
		  SET @ProcLineNum = 'Line270'
		  
		  INSERT INTO #tmp_DN (DNL_ID,
									DNL_SapDeliveryLineNbr,
									DNL_ShipToDealerCode,
									DNL_SAPCode,
									DNL_PONbr,
									DNL_DeliveryNoteNbr,
									DNL_CFN,
									DNL_LotNumber,
									DNL_ExpiredDate,
									DNL_ReceiveQty,
									DNL_ShipmentDate,
									DNL_ImportFileName,
									DNL_CreatedDate,
									DNL_SapDeliveryDate,
									DNL_BatchNbr,
									DNL_ToWhmCode,
									DNL_ClientID,
                  DNL_TrackingNo)                      --TrackingNo用于存放产品生产日期
			 SELECT A.ISH_ID,                                --主键
    					A.ISH_LineNbr,                           --发货单批号
    					A.ISH_Dealer_SapCode,                    --（DMS系统中的经销商编号）
    					A.ISH_Dealer_SapCode,                    --经销商编号（DMS系统中的经销商编号）
    					A.ISH_OrderNo,                           --订单号
    					A.ISH_SapDeliveryNo,                     --SAP发货单号
    					A.ISH_ArticleNumber,                     --产品UPN
    					ISNULL (SUBSTRING (A.ISH_LotNumber,PATINDEX ('%[^0]%', A.ISH_LotNumber),LEN (A.ISH_LotNumber) - PATINDEX ('%[^0]%', A.ISH_LotNumber) + 1),''),  --产品批号(去除前面的0)
    					A.ISH_ExpiredDate,                       --产品有效期
    					A.ISH_DeliveryQty,                       --发货数量
    					A.ISH_SapDeliveryDate,                   --发货日期
    					A.ISH_FileName,                          --文件名
    					getdate (),                              --创建日期
    					A.ISH_SapDeliveryDate,                   --发货单创建日期
    					A.ISH_BatchNbr,
    					ISH_ToWhmCode,
    					@ClientID,
              convert(nvarchar(10),A.ISH_ShippingDate,120) --ISH_ShippingDate用于存放产品生产日期
			   FROM #IShipment AS A
			  WHERE 
          NOT EXISTS
						   (SELECT 1
							    FROM PurchaseOrderHeader(nolock)
							   WHERE POH_OrderType IN ('ClearBorrow','ClearBorrowManual') AND POH_OrderNo = ISH_OrderNo)
					AND ISH_SapDeliveryNo NOT LIKE '084%'          --084开头的单据先不做收货
					AND NOT EXISTS 
               (SELECT 1 FROM POReceiptHeader_SAPNoQR(nolock) 
                 WHERE PRH_Status IN ('Complete','Waiting') and PRH_SAPShipmentID= ISH_SapDeliveryNo)

	
          SET @ProcLineNum = 'Line320'
		  --更新数量，对于084开头的发货单，且结尾是LC的发货单，全部做负数处理
		  UPDATE TDN 
         SET TDN.DNL_ReceiveQty = 0 - TDN.DNL_ReceiveQty
			  FROM #tmp_DN AS TDN
		   WHERE TDN.DNL_BatchNbr = @BatchNbr
				 AND substring (TDN.DNL_DeliveryNoteNbr, 1, 3) = '084'
				 AND substring (TDN.DNL_DeliveryNoteNbr,len (TDN.DNL_DeliveryNoteNbr) - 1, len (TDN.DNL_DeliveryNoteNbr)) = 'LC'

		  --如果对应的订单是清指定批号订单，则不做后续任何处理，直接更新的订单的状态、同时更新收货数（收货数=订单数）
		  --更新清指定批号订单的状态(后续有必要先将需要更新的数据写入临时表，等整个过程完成时一起进行更新)
		  --UPDATE PurchaseOrderHeader
			--   SET POH_OrderStatus = 'Completed'
	  
	  SET @ProcLineNum = 'Line334'  
      INSERT INTO #ClearBorrowOrderNeedtoUpdate(POH_ID)
      SELECT POH_ID FROM PurchaseOrderHeader(nolock)
       WHERE POH_OrderNo IN (SELECT DISTINCT ISH_OrderNo
									             FROM #IShipment
									            WHERE EXISTS (SELECT 1
              													      FROM PurchaseOrderHeader(nolock)
              													     WHERE POH_OrderType IN ('ClearBorrow','ClearBorrowManual','ZTKA','ZTKB')
              														     AND POH_OrderNo = ISH_OrderNo
                                           )
                            )
				 AND POH_OrderType IN ('ClearBorrow', 'ClearBorrowManual','ZTKA','ZTKB')
         AND POH_CreateType <>'Temporary'    
      
      Declare @IsClearBorrow int
      SELECT @IsClearBorrow = count(*) FROM #ClearBorrowOrderNeedtoUpdate
      --如果是清指定批号订单的发货，则进行清指定批号订单的状态更新，不做其他操作
      
      SET @ProcLineNum = 'Line352'
      
      --如果是短期寄售转移订单对应的发货单，则使用其他程序生成发货单
      --Start Add By SongWeiming on 2016-04-11
      Declare @CahID uniqueidentifier
	  SET  @CahID = null
      SELECT @CahID = CAH.CAH_ID
			  FROM #tmp_DN AS DN , PurchaseOrderHeader POH(nolock),ConsignmentApplyHeader CAH(nolock)
			 WHERE DN.DNL_PONbr = POH.POH_OrderNo and POH.POH_OrderNo = CAH.CAH_POH_OrderNo
			   AND CAH.CAH_ConsignmentFrom=N'Otherdealers' AND CAH.CAH_OrderStatus = N'Approved'
				 AND NOT EXISTS (SELECT 1 FROM POReceiptHeader(nolock) A WHERE A.PRH_PurchaseOrderNbr = DN.DNL_PONbr)
			 GROUP BY CAH.CAH_ID	
      --End Add By SongWeiming on 2016-04-11
      
      
      SET @ProcLineNum = 'Line367'  
      IF (@IsClearBorrow > 0)
        --更新清指定批号订单的逻辑
        BEGIN  
    		  Update PurchaseOrderHeader SET POH_OrderStatus = 'Completed' WHERE POH_ID IN (SELECT POH_ID FROM #ClearBorrowOrderNeedtoUpdate)
          
          --记录单据日志
    		  INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
    			SELECT NEWID (), POH.POH_ID ,@SysUserId,GETDATE (),'Confirm','SAP确认订单,SAP发货单：'+isnull(ISH_SapDeliveryNo,'')
    			  FROM #IShipment ISH, PurchaseOrderHeader POH(nolock)
    			 WHERE ISH.ISH_OrderNo=POH.POH_OrderNo
    			   AND POH.POH_OrderStatus='Completed' 
                   AND POH.POH_CreateType<>'Temporary'
    			   AND POH.POH_OrderNo IN (SELECT DISTINCT ISH_OrderNo
        										           FROM #IShipment
        										          WHERE EXISTS (SELECT 1
        														                  FROM PurchaseOrderHeader(nolock)
        													                   WHERE POH_OrderType IN ('ClearBorrow','ClearBorrowManual','ZTKA','ZTKB')
        															                 AND POH_OrderNo = ISH_OrderNo))
    				 AND POH_OrderType IN ('ClearBorrow', 'ClearBorrowManual','ZTKA','ZTKB')
           

    		  --更新清指定批号订单的数量（收货数量=订单数量）
    		  UPDATE Detail
    			   SET Detail.POD_ReceiptQty = Detail.POD_RequiredQty
    			  FROM PurchaseOrderHeader AS Header(nolock), PurchaseOrderDetail AS Detail
    		   WHERE Header.POH_ID = Detail.POD_POH_ID
    				 AND Header.POH_OrderNo IN (SELECT DISTINCT ISH_OrderNo
    											                FROM #IShipment
    											               WHERE EXISTS (SELECT 1
                          															 FROM PurchaseOrderHeader(nolock)
                          															WHERE POH_OrderType IN ('ClearBorrow','ClearBorrowManual','ZTKA','ZTKB')
                          																AND POH_OrderNo = ISH_OrderNo))
    				 AND Header.POH_OrderType IN ('ClearBorrow', 'ClearBorrowManual','ZTKA','ZTKB')
             AND Header.POH_CreateType <>'Temporary'
        END      
      ELSE IF (@CahID is not null)  --Start Add By SongWeiming on 2016-04-11
        BEGIN  
          Declare @PrcRtnVal NVARCHAR(20)
          Declare @PrcRtnMsg NVARCHAR(1000)
          EXEC [GC_ConsignmentApplyOrder_DealerConfirm] @CahID,@SysUserId,@PrcRtnVal OUTPUT,@PrcRtnMsg OUTPUT 
        END   --End Add By SongWeiming on 2016-04-11
      ELSE
        BEGIN
    		  SET @ProcLineNum = 'Line411' 
    		  --更新经销商ID
    		  UPDATE #tmp_DN
    			   SET DNL_DealerID_DMA_ID = DealerMaster.DMA_ID,
    				     DNL_HandleDate = getdate ()
    			  FROM DealerMaster(nolock)
    		   WHERE (DealerMaster.DMA_SAP_Code = #tmp_DN.DNL_SAPCode
    					    OR RIGHT (REPLICATE ('0', 10) + DealerMaster.DMA_SAP_Code,10) = #tmp_DN.DNL_SAPCode)
    				 AND #tmp_DN.DNL_DealerID_DMA_ID IS NULL
    				 AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    				 AND #tmp_DN.DNL_BatchNbr = @BatchNbr

    		  SET @ProcLineNum = 'Line423' 
    		  
          --更新产品信息
          --先不判断产品分类 Edit By SongWeiming on 2017-07-03
    		  UPDATE A
    			   SET A.DNL_CFN_ID = CFN.CFN_ID,                      --产品型号
    				     A.DNL_Product_PMA_ID = Product.PMA_ID,
    				     A.DNL_ProductLine_BUM_ID = CFN.CFN_ProductLine_BUM_ID, --产品线
    				     --A.DNL_ProductCatagory_PCT_ID =  ccf.ClassificationId,                         --产品分类
    				     A.DNL_HandleDate = GETDATE ()
    			  FROM #tmp_DN A 
    			  INNER JOIN CFN(nolock) on CFN.CFN_CustomerFaceNbr = A.DNL_CFN 
    			  INNER JOIN Product(nolock) ON Product.PMA_CFN_ID = CFN.CFN_ID
    			  --INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr and ccf.ClassificationId in (select ProducPctId from GC_FN_GetDealerAuthProductSub(a.DNL_DealerID_DMA_ID))
    		   WHERE  A.DNL_POReceiptLot_PRL_ID IS NULL
    				 AND A.DNL_BatchNbr = @BatchNbr

              
			  SET @ProcLineNum = 'Line437' 
			  --Update Product Line according to Order
			  update t1 set t1.dnl_ProductLine_BUM_ID = t2.POH_ProductLine_BUM_ID
				from #tmp_DN t1, purchaseorderheader t2(NOLOCK)
				where t1.dnl_PoNbr = t2.Poh_orderno
				and t1.DNL_BatchNbr = @BatchNbr
				and t2.POH_CreateType = 'Manual' 


    		  SET @ProcLineNum = 'Line446' 
    		  --更新BU
    		  UPDATE #tmp_DN
    			   SET DNL_BUName = attribute_name
    			  FROM Lafite_ATTRIBUTE(nolock)
    		   WHERE Id IN (SELECT rootID
    							        FROM Cache_OrganizationUnits(nolock)
    							       WHERE attributeID = CONVERT (VARCHAR (36),#tmp_DN.DNL_ProductLine_BUM_ID))
    				 AND ATTRIBUTE_TYPE = 'BU'
    				 AND #tmp_DN.DNL_ProductLine_BUM_ID IS NOT NULL
    				 AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    				 AND #tmp_DN.DNL_BatchNbr = @BatchNbr

    		  SET @ProcLineNum = 'Line459' 
    		  --更新授权信息：（每次都要重新更新）
          --先不更新授权 Edit By Songweiming on 2017-07-03
    		  UPDATE #tmp_DN
    			   SET DNL_Authorized = 1, DNL_HandleDate = getdate ()
    		   WHERE #tmp_DN.DNL_DealerID_DMA_ID IS NOT NULL
    				 --AND #tmp_DN.DNL_ProductCatagory_PCT_ID IS NOT NULL
    				 AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    				 AND #tmp_DN.DNL_Authorized = 0
    				 AND #tmp_DN.DNL_BatchNbr = @BatchNbr
--    				 AND EXISTS
--    						(SELECT 1
--    						   FROM DealerAuthorizationTable AS DA(nolock)
--    						  INNER JOIN Cache_PartsClassificationRec AS CP(nolock)
--    								   ON CP.PCT_ProductLine_BUM_ID = DA.DAT_ProductLine_BUM_ID
--    							INNER JOIN DealerContract AS DC(nolock)
--                       ON DA.DAT_DCL_ID = DC.DCL_ID
--    						  WHERE DA.DAT_DMA_ID = #tmp_DN.DNL_DealerID_DMA_ID
--    								AND ((DA.DAT_PMA_ID =DA.DAT_ProductLine_BUM_ID 
--                          AND DA.DAT_ProductLine_BUM_ID =	#tmp_DN.DNL_ProductLine_BUM_ID)
--    									 OR (DA.DAT_PMA_ID !=	DA.DAT_ProductLine_BUM_ID
--    										  AND CP.PCT_ParentClassification_PCT_ID = DA.DAT_PMA_ID
--    										  AND CP.PCT_ID =	#tmp_DN.DNL_ProductCatagory_PCT_ID)))

    		  --根据物料主键和批次号更新批次号主键(当前就不用再更新了，Edit By SongWeiming on 2015-12-18)
    --		  UPDATE #tmp_DN
    --			   SET #tmp_DN.DNL_LTM_ID = LM.LTM_ID
    --			  FROM LotMaster AS LM(nolock)
    --		   WHERE LM.LTM_LotNumber = #tmp_DN.DNL_LotNumber
    --				 AND LM.LTM_Product_PMA_ID = #tmp_DN.DNL_Product_PMA_ID
    --				 AND #tmp_DN.DNL_Product_PMA_ID IS NOT NULL
    --				 AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    --				 AND #tmp_DN.DNL_BatchNbr = @BatchNbr



    		  SET @ProcLineNum = 'Line494' 
    		  --更新经销商仓库，如果可以关联订单,则更新为订单上的仓库，如果无法关联订单的，则更新为经销商的默认仓库
    		  --更新订单上的仓库
    		  UPDATE #tmp_DN
    			   SET DNL_ToWhmId = POH_WHM_ID
    			  FROM PurchaseOrderHeader AS POH(nolock)
    		   WHERE POH.POH_OrderNo = #tmp_DN.DNL_PONbr
    				 AND #tmp_DN.DNL_ToWhmId IS NULL
    				 AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    				 AND #tmp_DN.DNL_BatchNbr = @BatchNbr

    		  
          --无订单的借货发货接口中，订单编号（PO Number）的最后一位为“L”，DMS系统在获取SAP的发货数据后，自动根据最后一位进行判断，如果是“L”，则生成收货仓库为借货库的经销商收货单
    		  --Edit By 宋卫铭 on 2013-11-08：如果是物流平台，则暂时将借货产品录入到缺省仓库
    		  --如果是一级经销商，则录入到借货库
    		  SET @ProcLineNum = 'Line509' 
    		  UPDATE #tmp_DN
    			   SET DNL_ToWhmId = WH.WHM_ID
    			  FROM (SELECT WHM_DMA_ID,CONVERT (UNIQUEIDENTIFIER,max (CONVERT (NVARCHAR (100), WHM_ID))) AS WHM_ID
    			          FROM Warehouse(nolock)
    				       WHERE WHM_Type = 'Borrow' AND WHM_ActiveFlag = 1
    				       GROUP BY WHM_DMA_ID) AS WH
    		   WHERE WH.WHM_DMA_ID = #tmp_DN.DNL_DealerID_DMA_ID
    				 AND #tmp_DN.DNL_ToWhmId IS NULL
    				 AND (substring (CASE WHEN charindex('补',#tmp_DN.DNL_PONbr) > 0 
										            	THEN substring(#tmp_DN.DNL_PONbr,1,charindex('补',#tmp_DN.DNL_PONbr)-1) 
											            ELSE #tmp_DN.DNL_PONbr
											            END ,len (CASE WHEN charindex('补',#tmp_DN.DNL_PONbr) > 0 
															                   THEN substring(#tmp_DN.DNL_PONbr,1,charindex('补',#tmp_DN.DNL_PONbr)-1) 
															                   ELSE #tmp_DN.DNL_PONbr
															                   END ),1) in ('L','B')
    					    OR 
                    (substring (#tmp_DN.DNL_DeliveryNoteNbr, 1, 3) = '084'
    						     AND 
                     substring (DNL_DeliveryNoteNbr,len (DNL_DeliveryNoteNbr) - 1,len (DNL_DeliveryNoteNbr)) = 'LC'
                     )
                 )
    				 AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    				 AND DNL_BatchNbr = @BatchNbr
    	

    		  -- 无订单的投诉换货发货接口中，订单编号（PO Number）的开始3位为“CRA”，DMS系统在获取SAP的发货数据后，自动根据前3位进行判断，如果是“CRA”，则生成收货仓库为默认普通库的经销商收货单
    		  SET @ProcLineNum = 'Line536' 
    		  UPDATE #tmp_DN
    			   SET DNL_ToWhmId = WH.WHM_ID
    			  FROM (SELECT WHM_DMA_ID,CONVERT (UNIQUEIDENTIFIER,max (CONVERT (NVARCHAR (100), WHM_ID)))	AS WHM_ID
    					      FROM Warehouse (nolock)
    				       WHERE WHM_Type = 'DefaultWH' AND WHM_ActiveFlag = 1
    				       GROUP BY WHM_DMA_ID) AS WH
    		   WHERE WH.WHM_DMA_ID = #tmp_DN.DNL_DealerID_DMA_ID
    				 AND #tmp_DN.DNL_ToWhmId IS NULL
    				 AND substring (#tmp_DN.DNL_PONbr, 1, 3) = 'CRA'
    				 AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    				 AND DNL_BatchNbr = @BatchNbr

    		  SET @ProcLineNum = 'Line549' 
    		  --将不确定仓库的收货单更新默认仓库
    		  UPDATE #tmp_DN
    			   SET DNL_ToWhmId = WH.WHM_ID
    			  FROM Warehouse AS WH(nolock)
    		   WHERE WH.WHM_DMA_ID = #tmp_DN.DNL_DealerID_DMA_ID
    				 AND WH.WHM_Type = 'DefaultWH'
    				 AND WH.WHM_ActiveFlag = 1
    				 AND #tmp_DN.DNL_ToWhmId IS NULL
    				 AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    				 AND DNL_BatchNbr = @BatchNbr


    		  /* 更新错误信息：
    			  经销商不存在、产品型号不存在、产品线未关联、产品型号对应的批号不存在、经销商仓库不存在、未做授权
    		   */
    		  SET @ProcLineNum = 'Line565' 
    		  UPDATE #tmp_DN
    			   SET DNL_ProblemDescription = N'经销商不存在'
    		   WHERE DNL_DealerID_DMA_ID IS NULL
    				 AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    				 AND #tmp_DN.DNL_BatchNbr = @BatchNbr

    		  UPDATE #tmp_DN
    			   SET DNL_ProblemDescription =	(CASE WHEN DNL_ProblemDescription IS NULL
    						                                THEN N'产品型号不存在'
    						                                ELSE DNL_ProblemDescription + N',产品型号不存在'
    					                                  END)
    		   WHERE DNL_CFN_ID IS NULL
    				 AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    				 AND #tmp_DN.DNL_BatchNbr = @BatchNbr

    		  UPDATE #tmp_DN
    			   SET DNL_ProblemDescription =( CASE WHEN DNL_ProblemDescription IS NULL
                                    						THEN
                                    						   N'产品线未关联'
                                    						ELSE
                                    						   DNL_ProblemDescription + N',产品线未关联'
                                    					 END)
    		   WHERE DNL_CFN_ID IS NOT NULL
    				 AND DNL_ProductLine_BUM_ID IS NULL
    				 AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    				 AND #tmp_DN.DNL_BatchNbr = @BatchNbr
    		  
          UPDATE #tmp_DN
    			   SET DNL_ProblemDescription = (CASE	WHEN DNL_ProblemDescription IS NULL 
                                                THEN N'未做授权'
                                    		  			ELSE DNL_ProblemDescription + N',未做授权'
                                    		  		  END)
    		   WHERE DNL_DealerID_DMA_ID IS NOT NULL
    				 AND DNL_CFN_ID IS NOT NULL
    				 AND DNL_ProductLine_BUM_ID IS NOT NULL
    				 AND DNL_Authorized = 0
    				 AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    				 AND #tmp_DN.DNL_BatchNbr = @BatchNbr

    		  UPDATE #tmp_DN
    			   SET DNL_ProblemDescription = (CASE
                                					 WHEN DNL_ProblemDescription IS NULL
                                					 THEN N'经销商仓库不存在'
                                					 ELSE DNL_ProblemDescription + N',经销商仓库不存在'
                                					 END)
    		   WHERE DNL_POReceiptLot_PRL_ID IS NULL
    				 AND DNL_ProblemDescription IS NULL
    				 AND DNL_ToWhmId IS NULL
    				 AND DNL_BatchNbr = @BatchNbr

    		  UPDATE #tmp_DN
    			   SET DNL_ProblemDescription = (CASE WHEN DNL_ProblemDescription IS NULL
                                          			THEN N'订单对应的经销商与收货经销商不相同'
                                          			ELSE DNL_ProblemDescription + N',订单对应的经销商与收货经销商不相同'
                                          		  END)
    		   WHERE DNL_POReceiptLot_PRL_ID IS NULL
    				 AND DNL_ProblemDescription IS NULL
    				 AND DNL_BatchNbr = @BatchNbr
    				 AND EXISTS
    						(SELECT 1
    						   FROM PurchaseOrderHeader AS POH(nolock)
    						  WHERE POH.POH_OrderNo = #tmp_DN.DNL_PONbr
    								AND POH.POH_DMA_ID <> #tmp_DN.DNL_DealerID_DMA_ID)


              
              
    		  --SAP发货给LP、一级经销商，如果发货单包含错误，则整单不生成收货单，待问题处理完了以后再重新传
    		  SELECT @ErrCnt = count (*)
    		    FROM #tmp_DN
    		   WHERE DNL_BatchNbr = @BatchNbr AND DNL_ProblemDescription IS NOT NULL

          
    		  IF (@ErrCnt = 0)
    			  --数据经过校验，没有错误信息的情况下进行数据处理
            BEGIN
    			    --非投诉换货的发货单处理流程
              IF(@CNT = 0)
              
    			
    			 BEGIN
    			    SET @ProcLineNum = 'Line643' 	    
    				--将Lotmaster表中不存在的批号、有效期数据写入LotMaster表(不用事先写入，在和畅联二维码数据匹配后再写入LotMaster)
    --				INSERT INTO LotMaster
    --				   SELECT NULL,
    --						  t3.DNL_ExpiredDate,
    --						  t3.DNL_LotNumber,
    --						  newid (),
    --						  getdate (),
    --						  NULL,
    --						  t2.PMA_ID,
    --						  NULL,
    --						  NULL
    --					 FROM cfn t1,
    --						  product t2,
    --						  (SELECT DISTINCT
    --								  DNL_CFN, DNL_LotNumber, DNL_ExpiredDate
    --							 FROM #tmp_DN
    --							WHERE     DNL_BatchNbr = @BatchNbr
    --								  AND DNL_ProblemDescription IS NULL) t3
    --					WHERE     t1.CFN_CustomerFaceNbr = t3.DNL_CFN
    --						  AND t2.PMA_CFN_ID = t1.CFN_ID
    --						  AND NOT EXISTS
    --								 (SELECT 1
    --									FROM LotMaster AS LM
    --								   WHERE     LM.LTM_LotNumber = t3.DNL_LotNumber
    --										 AND LM.LTM_Product_PMA_ID = t2.PMA_ID)

    				--生成收货数据(生成的单据为待发货状态)
    				--Header
    				INSERT INTO #tmpPORImportHeader (ID,
    												 SAPCusPONbr,
    												 SAPShipmentID,
    												 DealerDMAID,
    												 SAPShipmentDate,
    												 [Status],
    												 [Type],
    												 ProductLineBUMID,
    												 VendorDMAID,
    												 Carrier,
    												 TrackingNo,
    												 ShipType,
    												 Note,
    												 BUName,
    												 SapDeliveryDate,
    												 WHMID)
    				   SELECT NEWID (),
    						  DNL_PONbr,
    						  DNL_DeliveryNoteNbr,
    						  DNL_DealerID_DMA_ID,
    						  DNL_ShipmentDate,
    						  'Waiting',
    						  'PurchaseOrder',                 --原来是WaitingForDelivery
    						  DNL_ProductLine_BUM_ID,
    						  ISNULL (@Vender_DMA_ID,
    							'00000000-0000-0000-0000-000000000000'),
    						  Carrier,
    						  TrackingNo,
    						  ShipType,
    						  Note,
    						  BUName,
    						  SapDeliveryDate,
    						  DNL_ToWhmId
    					 FROM (SELECT DNL_PONbr,
    								  DNL_DeliveryNoteNbr,
    								  DNL_DealerID_DMA_ID,
    								  DNL_ShipmentDate,
    								  DNL_ProductLine_BUM_ID,
    								  max (DNL_TrackingNo) AS TrackingNo,
    								  DNL_SapDeliveryDate AS SapDeliveryDate,
    								  max (DNL_BUName) AS BUName,
    								  max (DNL_Carrier) AS Carrier,
    								  max (DNL_ShipType) AS ShipType,
    								  max (DNL_Note) AS Note,
    								  DNL_ToWhmId
    							 FROM #tmp_DN
    							WHERE   DNL_POReceiptLot_PRL_ID IS NULL
    								  AND DNL_ProblemDescription IS NULL
    								  AND DNL_BatchNbr = @BatchNbr						   
    						   GROUP BY DNL_PONbr,
    									DNL_DeliveryNoteNbr,
    									DNL_DealerID_DMA_ID,
    									DNL_ShipmentDate,
    									DNL_ProductLine_BUM_ID,
    									DNL_SapDeliveryDate,
    									DNL_ToWhmId) AS Header

    				SET @ProcLineNum = 'Line730' 
    				--Line
    				INSERT INTO #tmpPORImportLine (LineRecID,
    											   PMAID,
    											   ReceiptQty,
    											   HeaderID,
    											   LineNbr)
    				   SELECT NEWID (),
    						  Line.DNL_Product_PMA_ID,
    						  Line.QTY,
    						  #tmpPORImportHeader.ID,
    						  row_number ()
    							 OVER (PARTITION BY DNL_PONbr,
    												DNL_DeliveryNoteNbr,
    												DNL_DealerID_DMA_ID,
    												DNL_ShipmentDate,
    												DNL_ProductLine_BUM_ID
    								   ORDER BY
    									  DNL_PONbr,
    									  DNL_DeliveryNoteNbr,
    									  DNL_DealerID_DMA_ID,
    									  DNL_ShipmentDate,
    									  DNL_ProductLine_BUM_ID,
    									  DNL_SapDeliveryDate,
    									  DNL_Product_PMA_ID)
    							 LineNbr
    					 FROM (SELECT DNL_PONbr,
    								  DNL_DeliveryNoteNbr,
    								  DNL_DealerID_DMA_ID,
    								  DNL_ShipmentDate,
    								  DNL_ProductLine_BUM_ID,
    								  DNL_SapDeliveryDate,
    								  DNL_Product_PMA_ID,
    								  SUM (DNL_ReceiveQty) AS QTY
    							 FROM #tmp_DN
    							WHERE   DNL_POReceiptLot_PRL_ID IS NULL
    								  AND DNL_ProblemDescription IS NULL
    								  AND DNL_BatchNbr = @BatchNbr						  
    						   GROUP BY DNL_PONbr,
    									DNL_DeliveryNoteNbr,
    									DNL_DealerID_DMA_ID,
    									DNL_ShipmentDate,
    									DNL_ProductLine_BUM_ID,
    									DNL_SapDeliveryDate,
    									DNL_Product_PMA_ID) AS Line
    						  INNER JOIN #tmpPORImportHeader ON 
                        Line.DNL_PONbr = #tmpPORImportHeader.SAPCusPONbr
    								AND Line.DNL_DeliveryNoteNbr =
    									   #tmpPORImportHeader.SAPShipmentID
    								AND Line.DNL_DealerID_DMA_ID =
    									   #tmpPORImportHeader.DealerDMAID
    								AND Line.DNL_ShipmentDate =
    									   #tmpPORImportHeader.SAPShipmentDate
    								AND Line.DNL_ProductLine_BUM_ID =
    									   #tmpPORImportHeader.ProductLineBUMID								
    								AND Line.DNL_SapDeliveryDate =
    									   #tmpPORImportHeader.SapDeliveryDate

    				SET @ProcLineNum = 'Line788' 
    				--Lot
    				INSERT INTO #tmpPORImportLot (LotRecID,
    											  LineRecID,
    											  LotNumber,
    											  ReceiptQty,
    											  ExpiredDate,
    											  WarehouseRecID,
    											  DNL_ID)
    				   SELECT NEWID (),
    						  #tmpPORImportLine.LineRecID,
    						  #tmp_DN.DNL_LotNumber,
    						  #tmp_DN.DNL_ReceiveQty,
    						  #tmp_DN.DNL_ExpiredDate,
    						  --Warehouse.WHM_ID,
    						  #tmp_DN.DNL_ToWhmId,
    						  #tmp_DN.DNL_ID
    					 FROM #tmp_DN, #tmpPORImportHeader, #tmpPORImportLine
    					WHERE   #tmpPORImportHeader.ID = #tmpPORImportLine.HeaderID
    						  AND #tmp_DN.DNL_PONbr = #tmpPORImportHeader.SAPCusPONbr
    						  AND #tmp_DN.DNL_DeliveryNoteNbr = #tmpPORImportHeader.SAPShipmentID
    						  AND #tmp_DN.DNL_DealerID_DMA_ID = #tmpPORImportHeader.DealerDMAID
    						  AND #tmp_DN.DNL_ShipmentDate = #tmpPORImportHeader.SAPShipmentDate
    						  AND #tmp_DN.DNL_ProductLine_BUM_ID = #tmpPORImportHeader.ProductLineBUMID
    						  AND #tmp_DN.DNL_SapDeliveryDate = #tmpPORImportHeader.SapDeliveryDate
    						  AND #tmp_DN.DNL_Product_PMA_ID = #tmpPORImportLine.PMAID
    						  AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    						  AND #tmp_DN.DNL_ProblemDescription IS NULL
    						  AND #tmp_DN.DNL_BatchNbr = @BatchNbr


                    SET @ProcLineNum = 'Line819' 
    				--更新发货数据
    				UPDATE #tmp_DN
    				   SET DNL_POReceiptLot_PRL_ID = #tmpPORImportLot.LotRecID,
    					   DNL_HandleDate = GETDATE ()
    				  FROM #tmp_DN
    					   INNER JOIN #tmpPORImportLot
    						  ON #tmp_DN.DNL_ID = #tmpPORImportLot.DNL_ID

    				SET @ProcLineNum = 'Line828' 
    				--生成单据号
    				DECLARE
    				   curHandlePONumber CURSOR FOR
    					  SELECT ID,
    							 DealerDMAID,
    							 BUName,
    							 PONumber
    						FROM #tmpPORImportHeader
    					  FOR UPDATE OF PONumber

    				OPEN curHandlePONumber
    				FETCH NEXT FROM curHandlePONumber
    					 INTO @ID,
    						  @DealerDMAID,
    						  @BusinessUnitName,
    						  @PONumber

    				WHILE (@@fetch_status <> -1)
    				BEGIN
    				   IF (@@fetch_status <> -2)
    					  BEGIN
    						 SET @ProcLineNum = 'Line850' 
    						 EXEC [GC_GetNextAutoNumber] @DealerDMAID,
    													 'Next_POReceiptNbr',
    													 @BusinessUnitName,
    													 @PONumber OUTPUT

    						 UPDATE #tmpPORImportHeader
    							SET PONumber = @PONumber
    						  WHERE ID = @ID
    					  END

    				   FETCH NEXT FROM curHandlePONumber
    						INTO @ID,
    							 @DealerDMAID,
    							 @BusinessUnitName,
    							 @PONumber
    				END

    				CLOSE curHandlePONumber
    				DEALLOCATE curHandlePONumber

    				--复制数据
    				SET @ProcLineNum = 'Line872' 
    				INSERT INTO POReceiptHeader_SAPNoQR (PRH_ID,
    											 PRH_PONumber,
    											 PRH_SAPShipmentID,
    											 PRH_Dealer_DMA_ID,
    											 PRH_SAPShipmentDate,
    											 PRH_Status,
    											 PRH_Vendor_DMA_ID,
    											 PRH_Type,
    											 PRH_ProductLine_BUM_ID,
    											 PRH_PurchaseOrderNbr,
    											 PRH_Carrier,
    											 PRH_TrackingNo,
    											 PRH_ShipType,
    											 PRH_Note,
    											 PRH_SapDeliveryDate,
    											 PRH_WHM_ID,
                           PRH_InterfaceStatus)
    				   SELECT ID,
    						  PONumber,
    						  SAPShipmentID,
    						  DealerDMAID,
    						  SAPShipmentDate,
    						  [Status],
    						  VendorDMAID,
    						  [Type],
    						  ProductLineBUMID,
    						  SAPCusPONbr,
    						  Carrier,
    						  '',--TrackingNo,
    						  ShipType,
    						  Note,
    						  SapDeliveryDate,
    						  WHMID,
                  'UploadSuccess'
    					 FROM #tmpPORImportHeader

    				--记录日志表
    				SET @ProcLineNum = 'Line910' 
    				INSERT INTO PurchaseOrderLog (POL_ID,
    											  POL_POH_ID,
    											  POL_OperUser,
    											  POL_OperDate,
    											  POL_OperType,
    											  POL_OperNote)
    				   SELECT newid () AS POL_ID,
    						  ID AS POL_POH_ID,
    						  @SysUserId AS POL_OperUser,
    						  getdate () AS POL_OperDate,
    						  N'Delivery' AS POL_OperType,
    						  N'波科SAP数据接口自动上传发货数据'
    							 AS POL_OperNote
    					 FROM #tmpPORImportHeader

                    SET @ProcLineNum = 'Line926' 
    				INSERT INTO POReceipt_SAPNoQR (POR_ID,
    									   POR_SAP_PMA_ID,
    									   POR_PRH_ID,
    									   POR_ReceiptQty,
    									   POR_LineNbr,
    									   POR_UnitPrice)
    				   SELECT LineRecID,
    						  PMAID,
    						  HeaderID,
    						  ReceiptQty,
    						  LineNbr,
    						  UnitPrice
    					 FROM #tmpPORImportLine

    				SET @ProcLineNum = 'Line941' 
    				INSERT INTO POReceiptLot_SAPNoQR (PRL_ID,
    										  PRL_POR_ID,
    										  PRL_LotNumber,
    										  PRL_ReceiptQty,
    										  PRL_ExpiredDate,
    										  PRL_WHM_ID)
    				   SELECT newid (),
    						  LineRecID,
    						  LotNumber,
    						  SUM (ReceiptQty),
    						  ExpiredDate,
    						  WarehouseRecID
    					 FROM #tmpPORImportLot
    				   GROUP BY LineRecID,
    							LotNumber,
    							ExpiredDate,
    							WarehouseRecID

    				SET @IsValid = 'Success'
    			END
    			    
              --投诉换货发货单的处理流程
              ELSE 
    			      
                BEGIN
        					--获取投诉单对应的仓库类型、退货类型
                  SELECT @WhmType = WHM_Type,@ReturnType = RETURNTYPE 
                    FROM (
                          --CNF
                          SELECT ISH_ID, 
                                 CASE WHEN DC.WHM_ID = '00000000-0000-0000-0000-000000000000' 
                                      THEN 'Normal' 
                                      ELSE w.WHM_Type 
                                      END AS WHM_Type,
                                 ISNULL(dc.CONFIRMRETURNTYPE,dc.RETURNTYPE) as RETURNTYPE 
          					        FROM #IShipment LEFT JOIN #DealerComplainBSC dc ON (CASE WHEN LEN(ISH_OrderNo) < 3 
                                                                                     THEN ISH_OrderNo 
                                                                                     ELSE CASE WHEN substring(ISH_OrderNo,1,3)='CRA' 
                                                                                               THEN substring(ISH_OrderNo,3,LEN(ISH_OrderNo)-2)
                                                                                               ELSE ISH_OrderNo 
                                                                                               END 
                                                                                     END) = 
                                                                               (CASE WHEN len(COMPLAINTID) <= 10 
                                                                                     THEN COMPLAINTID 
                                                                                     ELSE CASE WHEN substring(ISH_OrderNo,1,3)='CRA' 
                                                                                               THEN SUBSTRING(COMPLAINTID,1,PATINDEX ('%-%', COMPLAINTID)-1) 
                                                                                               ELSE COMPLAINTID 
                                                                                               END
                                                                                     END )
          						                                                         AND ISH_ArticleNumber = DC.UPN
                                 --and SUBSTRING (ISH_LotNumber,PATINDEX ('%[^0]%', ISH_LotNumber),LEN (ISH_LotNumber) - PATINDEX ('%[^0]%', ISH_LotNumber)+ 1) = dc.LOT 
          						           LEFT JOIN Warehouse AS w(nolock) on DC.WHM_ID= w.WHM_ID
          						    --where ISH_BatchNbr=@BatchNbr
        						
                          union 
              						--CRM
                          SELECT ISH_ID,  
                                 CASE WHEN DC.WHMID = '00000000-0000-0000-0000-000000000000' 
                                      THEN 'Normal' 
                                      ELSE w.WHM_Type 
                                      END AS WHM_Type,
              					         RETURNTYPE
              					    FROM #IShipment LEFT JOIN #DealerComplainCRM dc ON (CASE WHEN LEN(ISH_OrderNo) < 3  
                                                                                     THEN ISH_OrderNo 
                                                                                     ELSE CASE WHEN SUBSTRING(ISH_OrderNo,1,3)='IAN' 
                                                                                               THEN substring(ISH_OrderNo,4,LEN(ISH_OrderNo)-3) 
                                                                                               WHEN substring(ISH_OrderNo,1,2)='PI' 
                                                                                               THEN substring(ISH_OrderNo,3,LEN(ISH_OrderNo)-2)
                                                                                               ELSE ISH_OrderNo END 
                                                                                END ) = 
                                                                               (CASE WHEN SUBSTRING(ISH_OrderNo,1,3)='IAN' 
                                                                                     THEN dc.IAN 
                                                                                     ELSE dc.PI END ) 
                                                                                AND ISH_ArticleNumber = dc.Serial
              						--and SUBSTRING (ISH_LotNumber,PATINDEX ('%[^0]%', ISH_LotNumber),LEN (ISH_LotNumber) - PATINDEX ('%[^0]%', ISH_LotNumber)+ 1) = dc.LOT 
              						                  LEFT JOIN Warehouse AS w(nolock) on dc.WHMID= w.WHM_ID
              						--where ISH_BatchNbr=@BatchNbr
                          ) tab
              			WHERE WHM_Type is not null and RETURNTYPE is not null
    						
    					    IF(@WhmType <> 'Consignment' and @WhmType <> 'Borrow' )--非BSC物权
    					      BEGIN
    						      IF(@WhmType = 'LP_Consignment' or @WhmType = 'LP_Borrow')--平台物权，收货单状态为待接收
    						        BEGIN
    							        set @Status = 'Waiting'
    						        END
    						    ELSE 
            						BEGIN
            							set @Status = 'Complete'
            						END
    						
    						

    						--生成收货数据(生成的单据为待发货状态)
    						--Header
    						INSERT INTO #tmpPORImportHeader (ID,
    														 SAPCusPONbr,
    														 SAPShipmentID,
    														 DealerDMAID,
    														 SAPShipmentDate,
    														 [Status],
    														 [Type],
    														 ProductLineBUMID,
    														 VendorDMAID,
    														 Carrier,
    														 TrackingNo,
    														 ShipType,
    														 Note,
    														 BUName,
    														 SapDeliveryDate,
    														 WHMID)
    						   SELECT NEWID (),
    								  DNL_PONbr,
    								  DNL_DeliveryNoteNbr,
    								  DNL_DealerID_DMA_ID,
    								  DNL_ShipmentDate,
    								  @Status,
    								  'Complain',                 
    								  DNL_ProductLine_BUM_ID,
    								  ISNULL (@Vender_DMA_ID,
    										  '00000000-0000-0000-0000-000000000000'),
    								  Carrier,
    								  TrackingNo,
    								  ShipType,
    								  Note,
    								  BUName,
    								  SapDeliveryDate,
    								  DNL_ToWhmId
    							 FROM (SELECT DNL_PONbr,
    										  DNL_DeliveryNoteNbr,
    										  DNL_DealerID_DMA_ID,
    										  DNL_ShipmentDate,
    										  DNL_ProductLine_BUM_ID,
    										  max (DNL_TrackingNo) AS TrackingNo,
    										  DNL_SapDeliveryDate AS SapDeliveryDate,
    										  max (DNL_BUName) AS BUName,
    										  max (DNL_Carrier) AS Carrier,
    										  max (DNL_ShipType) AS ShipType,
    										  max (DNL_Note) AS Note,
    										  DNL_ToWhmId
    									 FROM #tmp_DN
    									WHERE     DNL_POReceiptLot_PRL_ID IS NULL
    										  AND DNL_ProblemDescription IS NULL
    										  AND DNL_BatchNbr = @BatchNbr
    								   GROUP BY DNL_PONbr,
    											DNL_DeliveryNoteNbr,
    											DNL_DealerID_DMA_ID,
    											DNL_ShipmentDate,
    											DNL_ProductLine_BUM_ID,
    											DNL_SapDeliveryDate,
    											DNL_ToWhmId) AS Header

    						--Line
    						INSERT INTO #tmpPORImportLine (LineRecID,
    													   PMAID,
    													   ReceiptQty,
    													   HeaderID,
    													   LineNbr)
    						   SELECT NEWID (),
    								  Line.DNL_Product_PMA_ID,
    								  Line.QTY,
    								  #tmpPORImportHeader.ID,
    								  row_number ()
    									 OVER (PARTITION BY DNL_PONbr,
    														DNL_DeliveryNoteNbr,
    														DNL_DealerID_DMA_ID,
    														DNL_ShipmentDate,
    														DNL_ProductLine_BUM_ID
    										   ORDER BY
    											  DNL_PONbr,
    											  DNL_DeliveryNoteNbr,
    											  DNL_DealerID_DMA_ID,
    											  DNL_ShipmentDate,
    											  DNL_ProductLine_BUM_ID,
    											  DNL_SapDeliveryDate,
    											  DNL_Product_PMA_ID)
    									 LineNbr
    							 FROM (SELECT DNL_PONbr,
    										  DNL_DeliveryNoteNbr,
    										  DNL_DealerID_DMA_ID,
    										  DNL_ShipmentDate,
    										  DNL_ProductLine_BUM_ID,
    										  DNL_SapDeliveryDate,
    										  DNL_Product_PMA_ID,
    										  SUM (DNL_ReceiveQty) AS QTY
    									 FROM #tmp_DN
    									WHERE     DNL_POReceiptLot_PRL_ID IS NULL
    										  AND DNL_ProblemDescription IS NULL
    										  AND DNL_BatchNbr = @BatchNbr
    								   --and exists (select 1 from DealerMaster where DealerMaster.dma_id = #tmp_DN.DNL_DealerID_DMA_ID
    								   --and DealerMaster.DMA_SystemStartDate is not null and DealerMaster.DMA_SystemStartDate <= #tmp_DN.DNL_ShipmentDate)
    								   GROUP BY DNL_PONbr,
    											DNL_DeliveryNoteNbr,
    											DNL_DealerID_DMA_ID,
    											DNL_ShipmentDate,
    											DNL_ProductLine_BUM_ID,
    											DNL_SapDeliveryDate,
    											DNL_Product_PMA_ID) AS Line
    								  INNER JOIN #tmpPORImportHeader
    									 ON     Line.DNL_PONbr =
    											   #tmpPORImportHeader.SAPCusPONbr
    										AND Line.DNL_DeliveryNoteNbr =
    											   #tmpPORImportHeader.SAPShipmentID
    										AND Line.DNL_DealerID_DMA_ID =
    											   #tmpPORImportHeader.DealerDMAID
    										AND Line.DNL_ShipmentDate =
    											   #tmpPORImportHeader.SAPShipmentDate
    										AND Line.DNL_ProductLine_BUM_ID =
    											   #tmpPORImportHeader.ProductLineBUMID
    										--AND Line.DNL_TrackingNo = tmpPORImportHeader.TrackingNo
    										AND Line.DNL_SapDeliveryDate =
    											   #tmpPORImportHeader.SapDeliveryDate

    						--Lot
    						INSERT INTO #tmpPORImportLot (LotRecID,
    													  LineRecID,
    													  LotNumber,
    													  ReceiptQty,
    													  ExpiredDate,
    													  WarehouseRecID,
    													  DNL_ID)
    						   SELECT NEWID (),
    								  #tmpPORImportLine.LineRecID,
    								  #tmp_DN.DNL_LotNumber,
    								  #tmp_DN.DNL_ReceiveQty,
    								  #tmp_DN.DNL_ExpiredDate,
    								  --Warehouse.WHM_ID,
    								  #tmp_DN.DNL_ToWhmId,
    								  #tmp_DN.DNL_ID
    							 FROM #tmp_DN, #tmpPORImportHeader, #tmpPORImportLine
    							WHERE   #tmpPORImportHeader.ID = #tmpPORImportLine.HeaderID
    								  AND #tmp_DN.DNL_PONbr = #tmpPORImportHeader.SAPCusPONbr
    								  AND #tmp_DN.DNL_DeliveryNoteNbr = #tmpPORImportHeader.SAPShipmentID
    								  AND #tmp_DN.DNL_DealerID_DMA_ID = #tmpPORImportHeader.DealerDMAID
    								  AND #tmp_DN.DNL_ShipmentDate = #tmpPORImportHeader.SAPShipmentDate
    								  AND #tmp_DN.DNL_ProductLine_BUM_ID = #tmpPORImportHeader.ProductLineBUMID
    								  AND #tmp_DN.DNL_SapDeliveryDate = #tmpPORImportHeader.SapDeliveryDate
    								  AND #tmp_DN.DNL_Product_PMA_ID = #tmpPORImportLine.PMAID
    								  AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    								  AND #tmp_DN.DNL_ProblemDescription IS NULL
    								  AND #tmp_DN.DNL_BatchNbr = @BatchNbr

    						--更新发货数据
    						UPDATE #tmp_DN
    						   SET DNL_POReceiptLot_PRL_ID = #tmpPORImportLot.LotRecID,
    							     DNL_HandleDate = GETDATE ()
    						  FROM #tmp_DN INNER JOIN #tmpPORImportLot ON #tmp_DN.DNL_ID = #tmpPORImportLot.DNL_ID

    						DECLARE
    						   curHandlePONumber CURSOR FOR
    							  SELECT ID,
    									 DealerDMAID,
    									 BUName,
    									 PONumber
    								FROM #tmpPORImportHeader
    							  FOR UPDATE OF PONumber

    						OPEN curHandlePONumber
    						FETCH NEXT FROM curHandlePONumber
    							 INTO @ID,
    								    @DealerDMAID,
    								    @BusinessUnitName,
    								    @PONumber

    						WHILE (@@fetch_status <> -1)
    						BEGIN
    						   IF (@@fetch_status <> -2)
    							  BEGIN
    								 EXEC [GC_GetNextAutoNumber] @DealerDMAID,
    															 'Next_POReceiptNbr',
    															 @BusinessUnitName,
    															 @PONumber OUTPUT

    								 UPDATE #tmpPORImportHeader
    									SET PONumber = @PONumber
    								  WHERE ID = @ID
    							  END

    						   FETCH NEXT FROM curHandlePONumber
    								INTO @ID,
    									   @DealerDMAID,
    									   @BusinessUnitName,
    									   @PONumber
    						END

    						CLOSE curHandlePONumber
    						DEALLOCATE curHandlePONumber

    						--复制数据
    						INSERT INTO POReceiptHeader_SAPNoQR (PRH_ID,
    													 PRH_PONumber,
    													 PRH_SAPShipmentID,
    													 PRH_Dealer_DMA_ID,
    													 PRH_SAPShipmentDate,
    													 PRH_Status,
    													 PRH_Vendor_DMA_ID,
    													 PRH_Type,
    													 PRH_ProductLine_BUM_ID,
    													 PRH_PurchaseOrderNbr,
    													 PRH_Carrier,
    													 PRH_TrackingNo,
    													 PRH_ShipType,
    													 PRH_Note,
    													 PRH_SapDeliveryDate,
    													 PRH_WHM_ID,
                               PRH_InterfaceStatus)
    						   SELECT ID,
        								  PONumber,
        								  SAPShipmentID,
        								  DealerDMAID,
        								  SAPShipmentDate,
        								  [Status],
        								  VendorDMAID,
        								  [Type],
        								  ProductLineBUMID,
        								  SAPCusPONbr,
        								  Carrier,
        								  '',--TrackingNo,
        								  ShipType,
        								  Note,
        								  SapDeliveryDate,
        								  WHMID,
                          'UploadSuccess'
    							   FROM #tmpPORImportHeader

    						--记录日志表
    						SET @ProcLineNum = 'Line1268' 
    						INSERT INTO PurchaseOrderLog (POL_ID,
    													  POL_POH_ID,
    													  POL_OperUser,
    													  POL_OperDate,
    													  POL_OperType,
    													  POL_OperNote)
    						   SELECT newid () AS POL_ID,
        								  ID AS POL_POH_ID,
        								  @SysUserId AS POL_OperUser,
        								  getdate () AS POL_OperDate,
        								  N'Delivery' AS POL_OperType,
        								  N'波科SAP数据接口自动上传发货数据'
        									 AS POL_OperNote
    							 FROM #tmpPORImportHeader

    						INSERT INTO POReceipt_SAPNoQR (POR_ID,
                      											   POR_SAP_PMA_ID,
                      											   POR_PRH_ID,
                      											   POR_ReceiptQty,
                      											   POR_LineNbr,
                      											   POR_UnitPrice)
      						   SELECT LineRecID,
          								  PMAID,
          								  HeaderID,
          								  ReceiptQty,
          								  LineNbr,
          								  UnitPrice
      							 FROM #tmpPORImportLine

    						INSERT INTO POReceiptLot_SAPNoQR (PRL_ID,
                        												  PRL_POR_ID,
                        												  PRL_LotNumber,
                        												  PRL_ReceiptQty,
                        												  PRL_ExpiredDate,
                        												  PRL_WHM_ID)
    						   SELECT newid (),
        								  LineRecID,
        								  LotNumber,
        								  SUM (ReceiptQty),
        								  ExpiredDate,
        								  WarehouseRecID
    							   FROM #tmpPORImportLot
    						    GROUP BY  LineRecID,
            									LotNumber,
            									ExpiredDate,
            									WarehouseRecID
    						
    						--等二维码发货数据合并时，再发送接口 Edit By SongWeiming on 2015-12-18
    --            insert into DeliveryInterface
    --						select NEWID(),'',ROW_NUMBER() OVER (ORDER BY ID desc),SAPShipmentID, 'Pending','Manual',null,@SysUserId,GETDATE(),null,null,CLT_ID
    --						from #tmpPORImportHeader ,Client
    --						where DealerDMAID = CLT_Corp_Id
    --						and [Status] IN ('Waiting','Complete')
    							
    						----T2物权生成T2收货单,仅退货
    						----清空临时表
    						delete from #tmpPORImportHeader		
    						delete from #tmpPORImportLine
    						delete from #tmpPORImportLot
    						
    						if(@WhmType = 'Normal' or @WhmType = 'DefaultWH' or @WhmType = 'Frozen' )
    						BEGIN
    							if(@ReturnType = '1' or @ReturnType = '10')
    							BEGIN								
    								--生成收货数据(生成的单据为待发货状态)
    								--Header
    								INSERT INTO #tmpPORImportHeader (ID,
                    																 SAPCusPONbr,
                    																 SAPShipmentID,
                    																 DealerDMAID,
                    																 SAPShipmentDate,
                    																 [Status],
                    																 [Type],
                    																 ProductLineBUMID,
                    																 VendorDMAID,
                    																 Carrier,
                    																 TrackingNo,
                    																 ShipType,
                    																 Note,
                    																 BUName,
                    																 SapDeliveryDate,
                    																 WHMID,
                    																 FromWHMID)
    								   SELECT NEWID (),
        										  DNL_PONbr,
        										  DNL_DeliveryNoteNbr + '-ForT2',
        										  DMA_ID,
        										  DNL_ShipmentDate,
        										  'Waiting',
        										  'Complain',                 
        										  DNL_ProductLine_BUM_ID,
        										  DNL_DealerID_DMA_ID,
        										  Carrier,
        										  TrackingNo,
        										  ShipType,
        										  Note,
        										  BUName,
        										  SapDeliveryDate,
        										  WHM_ID,
        										  DNL_ToWhmId
    									 FROM (SELECT DNL_PONbr,
          												  DNL_DeliveryNoteNbr,
          												  DNL_DealerID_DMA_ID,
          												  DNL_ShipmentDate,
          												  DNL_ProductLine_BUM_ID,
          												  max (DNL_TrackingNo) AS TrackingNo,
          												  DNL_SapDeliveryDate AS SapDeliveryDate,
          												  max (DNL_BUName) AS BUName,
          												  max (DNL_Carrier) AS Carrier,
          												  max (DNL_ShipType) AS ShipType,
          												  max (DNL_Note) AS Note,
          												  DNL_ToWhmId,
          												  DW.WHM_ID,
          												  DW.DMA_ID
    											 FROM #tmp_DN,
    											 (
    											   select top 1 DMA_ID,WHM_ID 
                               from (
            											   --CNF
                                     SELECT DISTINCT DM.DMA_ID,W.WHM_ID
            											     FROM #tmp_DN
    												          INNER JOIN #DealerComplainBSC AS dc(nolock) on ((case when len(DNL_PONbr) < 3 
    													                                                          then DNL_PONbr 
    													                                                          else case when substring(DNL_PONbr,1,3)='CRA' 
    															                                                                then substring(DNL_PONbr,3,LEN(DNL_PONbr)-2)
    															                                                                ELSE DNL_PONbr end 
    													                                                          END) = 
                                                                                 (case when len(COMPLAINTID) <= 10 
    																                                                   then COMPLAINTID 
    																                                                   else CASE WHEN substring(DNL_PONbr,1,3)='CRA' 
    																			                                                       THEN SUBSTRING(COMPLAINTID,1,PATINDEX ('%-%', COMPLAINTID)-1) 
    																		                                                         ELSE COMPLAINTID end
    																                                                   END ) 
                                                                                 and DNL_CFN = dc.UPN)
    										              INNER JOIN DealerMaster AS DM(nolock) ON (dc.DC_CorpId = DM.DMA_ID and DM.DMA_DealerType='T2')              
    												          INNER JOIN Warehouse AS W(nolock) ON (DM.DMA_ID = W.WHM_DMA_ID and W.WHM_Type = 'DefaultWH') 
    												          WHERE DNL_BatchNbr=@BatchNbr AND DNL_ProblemDescription IS NULL
    									            
                                      UNION 
    												          
                                      --CRM
    									                SELECT DISTINCT DM.DMA_ID,W.WHM_ID
    												            FROM #tmp_DN
    												           INNER JOIN #DealerComplainCRM AS dc on ((case when len(DNL_PONbr) < 3  
    														                                                     then DNL_PONbr 
                                                                                     else case when substring(DNL_PONbr,1,3)='IAN' 
                                                                                               then substring(DNL_PONbr,4,LEN(DNL_PONbr)-3) 
    																					                                                 When substring(DNL_PONbr,1,2)='PI' 
                                                                                               then substring(DNL_PONbr,3,LEN(DNL_PONbr)-2)
    																					                                                 else DNL_PONbr end 
    														                                                      end ) = 
                                                                              (Case when substring(DNL_PONbr,1,3)='IAN' 
                                                                                    then dc.IAN 
                                                                                    else dc.PI end ) 
                                                                              AND DNL_CFN = dc.Serial	)					
    												           INNER JOIN DealerMaster DM ON (dc.DC_CorpId = DM.DMA_ID and DM.DMA_DealerType='T2')              
    												           INNER JOIN Warehouse W ON (DM.DMA_ID = W.WHM_DMA_ID and W.WHM_Type = 'DefaultWH') 
    												           WHERE DNL_BatchNbr=@BatchNbr and DNL_ProblemDescription IS NULL
    											   ) tab
    											 ) AS DW
    										   GROUP BY DNL_PONbr,
    													DNL_DeliveryNoteNbr,
    													DNL_DealerID_DMA_ID,
    													DNL_ShipmentDate,
    													DNL_ProductLine_BUM_ID,
    													DNL_SapDeliveryDate,
    													DNL_ToWhmId,
    													DW.WHM_ID,
    													DW.DMA_ID) AS Header
    													
    								--Line
    								INSERT INTO #tmpPORImportLine (LineRecID,
    															   PMAID,
    															   ReceiptQty,
    															   HeaderID,
    															   LineNbr)
    								   SELECT NEWID (),
        										  Line.DNL_Product_PMA_ID,
        										  Line.QTY,
        										  #tmpPORImportHeader.ID,
        										  row_number ()
    											    OVER (PARTITION BY DNL_PONbr,
    																DNL_DeliveryNoteNbr,
    																DNL_DealerID_DMA_ID,
    																DNL_ShipmentDate,
    																DNL_ProductLine_BUM_ID
    												   ORDER BY
    													  DNL_PONbr,
    													  DNL_DeliveryNoteNbr,
    													  DNL_DealerID_DMA_ID,
    													  DNL_ShipmentDate,
    													  DNL_ProductLine_BUM_ID,
    													  DNL_SapDeliveryDate,
    													  DNL_Product_PMA_ID)
    											      LineNbr
    									 FROM (SELECT DNL_PONbr,
    												  DNL_DeliveryNoteNbr,
    												  DNL_DealerID_DMA_ID,
    												  DNL_ShipmentDate,
    												  DNL_ProductLine_BUM_ID,
    												  DNL_SapDeliveryDate,
    												  DNL_Product_PMA_ID,
    												  SUM (DNL_ReceiveQty) AS QTY
    											 FROM #tmp_DN
    											WHERE   DNL_ProblemDescription IS NULL
    												  AND DNL_BatchNbr = @BatchNbr
    										   --and exists (select 1 from DealerMaster where DealerMaster.dma_id = #tmp_DN.DNL_DealerID_DMA_ID
    										   --and DealerMaster.DMA_SystemStartDate is not null and DealerMaster.DMA_SystemStartDate <= #tmp_DN.DNL_ShipmentDate)
    										   GROUP BY DNL_PONbr,
    													DNL_DeliveryNoteNbr,
    													DNL_DealerID_DMA_ID,
    													DNL_ShipmentDate,
    													DNL_ProductLine_BUM_ID,
    													DNL_SapDeliveryDate,
    													DNL_Product_PMA_ID) AS Line
    										  INNER JOIN #tmpPORImportHeader
    											 ON Line.DNL_PONbr = #tmpPORImportHeader.SAPCusPONbr
    												  AND Line.DNL_DeliveryNoteNbr = substring(#tmpPORImportHeader.SAPShipmentID,1,10)
    												  AND Line.DNL_DealerID_DMA_ID = #tmpPORImportHeader.VendorDMAID
    												  AND Line.DNL_ShipmentDate = #tmpPORImportHeader.SAPShipmentDate
    												  AND Line.DNL_ProductLine_BUM_ID = #tmpPORImportHeader.ProductLineBUMID												
    												  AND Line.DNL_SapDeliveryDate = #tmpPORImportHeader.SapDeliveryDate

    								--Lot
    								INSERT INTO #tmpPORImportLot (LotRecID,
    															  LineRecID,
    															  LotNumber,
    															  ReceiptQty,
    															  ExpiredDate,
    															  WarehouseRecID,
    															  DNL_ID)
    								   SELECT NEWID (),
        										  #tmpPORImportLine.LineRecID,
        										  #tmp_DN.DNL_LotNumber,
        										  #tmp_DN.DNL_ReceiveQty,
        										  #tmp_DN.DNL_ExpiredDate,
        										  --Warehouse.WHM_ID,
        										  #tmp_DN.DNL_ToWhmId,
        										  #tmp_DN.DNL_ID
    									   FROM #tmp_DN, #tmpPORImportHeader, #tmpPORImportLine
    									  WHERE #tmpPORImportHeader.ID = #tmpPORImportLine.HeaderID
    										  AND #tmp_DN.DNL_PONbr = #tmpPORImportHeader.SAPCusPONbr
    										  AND #tmp_DN.DNL_DeliveryNoteNbr = substring(#tmpPORImportHeader.SAPShipmentID,1,10)
    										  AND #tmp_DN.DNL_DealerID_DMA_ID = #tmpPORImportHeader.VendorDMAID
    										  AND #tmp_DN.DNL_ShipmentDate = #tmpPORImportHeader.SAPShipmentDate
    										  AND #tmp_DN.DNL_ProductLine_BUM_ID = #tmpPORImportHeader.ProductLineBUMID
    										  AND #tmp_DN.DNL_SapDeliveryDate = #tmpPORImportHeader.SapDeliveryDate
    										  AND #tmp_DN.DNL_Product_PMA_ID = #tmpPORImportLine.PMAID
    										  --AND #tmp_DN.DNL_POReceiptLot_PRL_ID IS NULL
    										  AND #tmp_DN.DNL_ProblemDescription IS NULL
    										  AND #tmp_DN.DNL_BatchNbr = @BatchNbr
    									  
    								--更新发货数据
    								UPDATE #tmp_DN
    								   SET DNL_POReceiptLot_PRL_ID = #tmpPORImportLot.LotRecID,
    									     DNL_HandleDate = GETDATE ()
    								  FROM #tmp_DN
    								   INNER JOIN #tmpPORImportLot ON #tmp_DN.DNL_ID = #tmpPORImportLot.DNL_ID

    								DECLARE
    								   curHandlePONumber CURSOR FOR
    									  SELECT ID,
    											 DealerDMAID,
    											 BUName,
    											 PONumber
    										FROM #tmpPORImportHeader
    									  FOR UPDATE OF PONumber

    								OPEN curHandlePONumber
    								FETCH NEXT FROM curHandlePONumber
    									 INTO @ID,
      										  @DealerDMAID,
      										  @BusinessUnitName,
      										  @PONumber

    								WHILE (@@fetch_status <> -1)
    								BEGIN
    								   IF (@@fetch_status <> -2)
    									  BEGIN
    										 EXEC [GC_GetNextAutoNumber] @DealerDMAID,
                  																	 'Next_POReceiptNbr',
                  																	 @BusinessUnitName,
                  																	 @PONumber OUTPUT

    										 UPDATE #tmpPORImportHeader
    											SET PONumber = @PONumber
    										  WHERE ID = @ID
    									  END

    								   FETCH NEXT FROM curHandlePONumber
    										INTO @ID,
    											 @DealerDMAID,
    											 @BusinessUnitName,
    											 @PONumber
    								END

    								CLOSE curHandlePONumber
    								DEALLOCATE curHandlePONumber

    								--复制数据
    								INSERT INTO POReceiptHeader_SAPNoQR (PRH_ID,
    															 PRH_PONumber,
    															 PRH_SAPShipmentID,
    															 PRH_Dealer_DMA_ID,
    															 PRH_SAPShipmentDate,
    															 PRH_Status,
    															 PRH_Vendor_DMA_ID,
    															 PRH_Type,
    															 PRH_ProductLine_BUM_ID,
    															 PRH_PurchaseOrderNbr,
    															 PRH_Carrier,
    															 PRH_TrackingNo,
    															 PRH_ShipType,
    															 PRH_Note,
    															 PRH_SapDeliveryDate,
    															 PRH_WHM_ID,
    															 PRH_FromWHM_ID,
                                   PRH_InterfaceStatus
                                   )
    								   SELECT ID,
    										  PONumber,
    										  SAPShipmentID,
    										  DealerDMAID,
    										  SAPShipmentDate,
    										  [Status],
    										  VendorDMAID,
    										  [Type],
    										  ProductLineBUMID,
    										  SAPCusPONbr,
    										  Carrier,
    										  '',--TrackingNo,
    										  ShipType,
    										  Note,
    										  SapDeliveryDate,
    										  WHMID,
    										  FromWHMID,
                          'UploadSuccess'
    									 FROM #tmpPORImportHeader

    								--记录日志表
    								INSERT INTO PurchaseOrderLog (POL_ID,
    															  POL_POH_ID,
    															  POL_OperUser,
    															  POL_OperDate,
    															  POL_OperType,
    															  POL_OperNote)
    								   SELECT newid () AS POL_ID,
    										  ID AS POL_POH_ID,
    										  @SysUserId AS POL_OperUser,
    										  getdate () AS POL_OperDate,
    										  N'Delivery' AS POL_OperType,
    										  N'波科SAP数据接口自动上传发货数据'
    											 AS POL_OperNote
    									 FROM #tmpPORImportHeader

    								INSERT INTO POReceipt_SAPNoQR (POR_ID,
                      													   POR_SAP_PMA_ID,
                      													   POR_PRH_ID,
                      													   POR_ReceiptQty,
                      													   POR_LineNbr,
                      													   POR_UnitPrice)
    								   SELECT LineRecID,
        										  PMAID,
        										  HeaderID,
        										  ReceiptQty,
        										  LineNbr,
        										  UnitPrice
    									 FROM #tmpPORImportLine

    								INSERT INTO POReceiptLot_SAPNoQR (PRL_ID,
                        														  PRL_POR_ID,
                        														  PRL_LotNumber,
                        														  PRL_ReceiptQty,
                        														  PRL_ExpiredDate,
                        														  PRL_WHM_ID)
    								   SELECT newid (),
        										  LineRecID,
        										  LotNumber,
        										  SUM (ReceiptQty),
        										  ExpiredDate,
        										  WarehouseRecID
    									 FROM #tmpPORImportLot
    								   GROUP BY LineRecID,
          											LotNumber,
          											ExpiredDate,
          											WarehouseRecID
    							END		
    						END						
    					END
    					
    			  END
            
        		  --将正式数据写入DeliveryNote
        		  SET @ProcLineNum = 'Line1662' 
        		  INSERT INTO DeliveryNote(DNL_ID, DNL_LineNbrInFile, DNL_ShipToDealerCode, DNL_SAPCode, DNL_PONbr, DNL_DeliveryNoteNbr, DNL_CFN, DNL_UPN, DNL_LotNumber, DNL_ExpiredDate, DNL_DN_UnitOfMeasure, DNL_ReceiveUnitOfMeasure, DNL_ShipQty, DNL_ReceiveQty, DNL_ShipmentDate, DNL_ImportFileName, DNL_OrderType, DNL_UnitPrice, DNL_SubTotal, DNL_ShipmentType, DNL_CreatedDate, DNL_ProblemDescription, DNL_ProductDescription, DNL_SAPSOLine, DNL_SAPSalesOrderID, DNL_POReceiptLot_PRL_ID, DNL_HandleDate, DNL_DealerID_DMA_ID, DNL_CFN_ID, DNL_BUName, DNL_Product_PMA_ID, DNL_ProductLine_BUM_ID, DNL_Authorized, DNL_CreateUser, DNL_Carrier, DNL_TrackingNo, DNL_ShipType, DNL_Note, DNL_ProductCatagory_PCT_ID, DNL_SapDeliveryDate, DNL_LTM_ID, DNL_ToWhmCode, DNL_ToWhmId, DNL_ClientID, DNL_SapDeliveryLineNbr, DNL_BatchNbr, DNL_FromWhmId)
              SELECT DNL_ID, DNL_LineNbrInFile, DNL_ShipToDealerCode, DNL_SAPCode, DNL_PONbr, DNL_DeliveryNoteNbr, DNL_CFN, DNL_UPN, DNL_LotNumber, DNL_ExpiredDate, DNL_DN_UnitOfMeasure, DNL_ReceiveUnitOfMeasure, DNL_ShipQty, DNL_ReceiveQty, DNL_ShipmentDate, DNL_ImportFileName, DNL_OrderType, DNL_UnitPrice, DNL_SubTotal, DNL_ShipmentType, DNL_CreatedDate, DNL_ProblemDescription, DNL_ProductDescription, DNL_SAPSOLine, DNL_SAPSalesOrderID, DNL_POReceiptLot_PRL_ID, DNL_HandleDate, DNL_DealerID_DMA_ID, DNL_CFN_ID, DNL_BUName, DNL_Product_PMA_ID, DNL_ProductLine_BUM_ID, DNL_Authorized, DNL_CreateUser, DNL_Carrier, DNL_TrackingNo, DNL_ShipType, DNL_Note, DNL_ProductCatagory_PCT_ID, DNL_SapDeliveryDate, DNL_LTM_ID, DNL_ToWhmCode, DNL_ToWhmId, DNL_ClientID, DNL_SapDeliveryLineNbr, DNL_BatchNbr, DNL_FromWhmId FROM #tmp_DN
              
           
              
             
              --将DOM信息写入LotMaster表（相应的将有效期等信息都进行更新）
              SET @ProcLineNum = 'Line1666' 
              INSERT INTO dbo.LotMasterDOM(PMA_ID,UPN,LOT,DOM)
              SELECT DNL_Product_PMA_ID,DNL_CFN,DNL_LotNumber,max(DNL_TrackingNo) 
                FROM #tmp_DN AS DN
               WHERE DNL_CFN IS NOT NULL 
                 AND DNL_Product_PMA_ID IS NOT NULL 
                 AND DNL_LotNumber IS NOT NULL
                 AND NOT EXISTS
    								  (SELECT 1
    									   FROM dbo.LotMasterDOM AS DOM(NOLOCK)
    								    WHERE DOM.LOT = DN.DNL_LotNumber                         
    										  AND DOM.PMA_ID = DN.DNL_Product_PMA_ID)
               GROUP BY DNL_CFN,DNL_LotNumber,DNL_Product_PMA_ID
              
              
              --写入NoQR的数据
              INSERT INTO LotMaster (
						 LTM_InitialQty
						,LTM_ExpiredDate
						,LTM_LotNumber
						,LTM_ID
						,LTM_CreatedDate
						,LTM_PRL_ID
						,LTM_Product_PMA_ID
						,LTM_Type
						,LTM_RelationID
					  )      
					  select Qty,DNL_ExpiredDate,DNL_LotNumber + '@@NoQR',newid(),getdate(),null,DNL_Product_PMA_ID,null,null from (
					  SELECT SUM(DN.DNL_ReceiveQty) AS QTY ,DN.DNL_ExpiredDate,DN.DNL_LotNumber ,DN.DNL_Product_PMA_ID     
						FROM #tmp_DN AS DN
					   WHERE NOT EXISTS				 (SELECT 1
    													  FROM LotMaster AS LM(nolock)
    												   WHERE LM.LTM_LotNumber = DN.DNL_LotNumber + '@@NoQR' 
    												     and LM.LTM_Product_PMA_ID = DN.DNL_Product_PMA_ID)      
					   GROUP BY DN.DNL_LotNumber ,DN.DNL_ExpiredDate,DN.DNL_Product_PMA_ID
					  ) tab
             
            --对于样品的发货，需要更新
              UPDATE SampleApplyHead
        		    SET    ApplyStatus  = 'Delivery',
        		           UpdateDate   = GETDATE()
        		    WHERE  exists (select 1 from #tmp_DN where DNL_PONbr = ApplyNo )     
        		    
        		  INSERT INTO ScoreCardLog (SCL_ID, SCL_ESC_ID, SCL_OperUser, SCL_OperDate, SCL_OperType, SCL_OperNote)
        			SELECT NEWID(), SampleApplyHeadId, '系统', getdate(), '发货', ''
        			  FROM SampleApplyHead t1,(SELECT distinct DNL_PONbr FROM #tmp_DN ) t2
        				WHERE  t1.ApplyNo = t2.DNL_PONbr
        				
        				
        		   Update PurchaseOrderHeader 
                  SET POH_OrderStatus = 'Completed' 
                WHERE exists (select 1 from #tmp_DN where DNL_PONbr = POH_OrderNo )  
                  AND exists (select 1 from SampleApplyHead where ApplyNo = POH_OrderNo )
--    				  INSERT INTO LotMaster(LTM_InitialQty,LTM_ExpiredDate,LTM_LotNumber,LTM_ID,LTM_CreatedDate,LTM_PRL_ID,LTM_Product_PMA_ID,LTM_Type,LTM_RelationID)
--    				  SELECT NULL,
--      						   t3.DNL_ExpiredDate,
--      						   t3.DNL_LotNumber,
--      						   newid (),
--      						   getdate (),
--      						   NULL,
--      						   t2.PMA_ID,
--      						   t3.DNL_TrackingNo,
--      						   NULL
--    					  FROM cfn t1,
--    						     product t2,
--    						    (SELECT DISTINCT DNL_CFN, DNL_LotNumber, DNL_ExpiredDate, DNL_TrackingNo
--    							     FROM #tmp_DN
--    							    WHERE DNL_BatchNbr = @BatchNbr AND DNL_ProblemDescription IS NULL) t3
--    					WHERE   t1.CFN_CustomerFaceNbr = t3.DNL_CFN
--    						  AND t2.PMA_CFN_ID = t1.CFN_ID
--    						  AND NOT EXISTS
--    								  (SELECT 1
--    									   FROM LotMaster AS LM
--    								    WHERE LM.LTM_LotNumber = t3.DNL_LotNumber
--    										  AND LM.LTM_Product_PMA_ID = t2.PMA_ID)
              
            END
        
        END
      COMMIT TRAN
      Print @ProcLineNum 
      
      SET  NOCOUNT OFF
      RETURN 1
   END TRY
   BEGIN CATCH
      SET  NOCOUNT OFF
      ROLLBACK TRAN
      SET @IsValid = 'Failure'

      --记录错误日志开始
      DECLARE @error_line   INT
      DECLARE @error_number   INT
      DECLARE @error_message   NVARCHAR (256)
      DECLARE @vError   NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError = 'GC_Interface_Shipment_行(' + @ProcLineNum +'):' + CONVERT (NVARCHAR (10), @error_line) + '出错[错误号' + CONVERT (NVARCHAR (10), @error_number) + '],' + @error_message
      SET @RtnMsg = @vError
      --EXEC dbo.GC_Interface_Log 'Shipment', 'Failure', @vError

      RETURN -1
   END CATCH
GO


