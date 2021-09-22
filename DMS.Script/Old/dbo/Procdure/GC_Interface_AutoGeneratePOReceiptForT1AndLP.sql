DROP PROCEDURE [dbo].[GC_Interface_AutoGeneratePOReceiptForT1AndLP]
GO

/*
自动生成波科发货数据接口（畅联WMS发货数据与波科SAP发货数据匹配后进行更新）
1、定时执行，判断状态为UploadSuccess的数据是需要处理的数据
2、关联二维码以后，将包含二维码的数据写入正式的PoreceiptHeader表
   A、发货单号进行匹配（SAP的41单号与畅联的发货单号）
   B、畅联手工单，将SAP订单编号中“补”后面的单号与畅联的发货单号进行匹配
   B、SAP的投诉发货单号，需要将生成给二级的发货单号的“-ForT2”部分去掉，然后进行匹配
3、使用游标一条条遍历SAP的发货单，逐条进行处理
   A、判断收货单每一个批号的产品数量与WMS按批号汇总的产品数量是否一致
   B、判断收货单总数量与WMS收货单总数量是否一致
   C、更新接口表的数据，将状态更新为GenerateSuccess（POReceiptHeader_SAPNoQR表和DeliveryNoteBSCSLC表）
   D、更新对应订单的状态和每一条明细产品的实际收货数量
   E、错误信息发送邮件通知
*/

CREATE PROCEDURE [dbo].[GC_Interface_AutoGeneratePOReceiptForT1AndLP]  
   @IsValid        NVARCHAR (20) OUTPUT,
   @RtnMsg         NVARCHAR (500) OUTPUT
AS  
   DECLARE @SysUserId   UNIQUEIDENTIFIER   
   DECLARE @EmptyGuid   UNIQUEIDENTIFIER
   DECLARE @ErrCnt      INT
   DECLARE @RowCnt      INT
   DECLARE @MatchCnt    INT
   
   --遍历待匹配记录时使用
   DECLARE @PRH_ID                UNIQUEIDENTIFIER
   DECLARE @PRH_SAPShipmentID     NVARCHAR(50)
   DECLARE @PRH_Type              NVARCHAR(50)
   DECLARE @PRH_PurchaseOrderNbr  NVARCHAR(50)
   
   --更新订单时使用
    DECLARE @TmpPohId uniqueidentifier ;        --#TMP_ORDER表POHID
  	--DECLARE @TmpPodId uniqueidentifier ;      --#TMP_ORDER表PODID
    DECLARE @TmpOrderNo   NVARCHAR(50);         --#TMP_ORDER表OrderNo
    --DECLARE @TmpCfnID uniqueidentifier;       --#TMP_ORDER表CFNID
    DECLARE @TmpShortCode NVARCHAR(50);         --#TMP_ORDER表ShortCode
  	DECLARE @TmpReceiptQty DECIMAL (18, 6);	    --#TMP_ORDER表ReceiptQty
    DECLARE @TmpOrderRequiredQty DECIMAL (18, 6);	--#TMP_ORDER表OrderRequiredQty
    DECLARE @TmpOrderReceiptQty DECIMAL (18, 6);	--#TMP_ORDER表OrderReceiptQty
  	
    DECLARE @CurPodID uniqueidentifier		 --PurchaseOrderDetail表PODID(curDetail使用)
  	DECLARE @CurCfnID uniqueidentifier
  	DECLARE @CurRequireQty DECIMAL (18, 6); 
  	DECLARE @CurReceiptQty DECIMAL (18, 6); 
    DECLARE @CurCfnPrice DECIMAL (18, 6); 
    DECLARE @CurShortCode NVARCHAR(50);
  	--declare @updateqty DECIMAL (18, 6);  --
  	--declare @updateqty2 DECIMAL (18, 6); --
  	declare @UpdateCfn uniqueidentifier;
  	
  	declare @cfn nvarchar(200); --产品型号
  	declare @bum nvarchar(100); --产品线
    
    --DECLARE @pn nvarchar(100);
		--DECLARE @upn nvarchar(100);
		--DECLARE @lotnumber nvarchar(20);
		--DECLARE @prlqty decimal(18,6);
    
    
   
   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN

      SET @IsValid = 'Success'
      SET @RtnMsg = ''
      SET @SysUserId = '00000000-0000-0000-0000-000000000000'
      SET @EmptyGuid = '00000000-0000-0000-0000-000000000000'
	 
   
      CREATE TABLE #tmpPOReceiptHeader (
        [PRH_ID] uniqueidentifier NOT NULL,
        [PRH_PONumber] nvarchar(30) NULL,
        [PRH_SAPShipmentID] nvarchar(50) NULL,
        [PRH_Dealer_DMA_ID] uniqueidentifier NOT NULL,
        [PRH_ReceiptDate] datetime NULL,
        [PRH_SAPShipmentDate] datetime NULL,
        [PRH_Status] nvarchar(50) NOT NULL,
        [PRH_Vendor_DMA_ID] uniqueidentifier NOT NULL,
        [PRH_Type] nvarchar(50) NOT NULL,
        [PRH_ProductLine_BUM_ID] uniqueidentifier NULL,
        [PRH_PurchaseOrderNbr] nvarchar(50) NULL,
        [PRH_Receipt_USR_UserID] uniqueidentifier NULL,
        [PRH_Carrier] nvarchar(20) NULL,
        [PRH_TrackingNo] nvarchar(100) NULL,
        [PRH_ShipType] nvarchar(20) NULL,
        [PRH_Note] nvarchar(20) NULL,
        [PRH_ArrivalDate] datetime NULL,
        [PRH_DeliveryDate] datetime NULL,
        [PRH_SapDeliveryDate] datetime NULL,
        [PRH_WHM_ID] uniqueidentifier NULL,
        [PRH_FromWHM_ID] uniqueidentifier NULL)
        
      CREATE TABLE #tmpPOReceipt (
        [POR_ID] uniqueidentifier NOT NULL,
        [POR_SAPSOLine] nvarchar(30) NULL,
        [POR_SAPSOID] nvarchar(30) NULL,
        [POR_SAP_PMA_ID] uniqueidentifier NOT NULL,
        [POR_ReceiptQty] float NOT NULL,
        [POR_UnitPrice] float NULL,
        [POR_ConvertFactor] float NULL,
        [POR_PRH_ID] uniqueidentifier NOT NULL,
        [POR_ChangedUnitProduct_PMA_ID] uniqueidentifier NULL,
        [POR_LineNbr] int NULL)
        
      CREATE TABLE #tmpPOReceiptLot (
        [PRL_POR_ID] uniqueidentifier NOT NULL,
        [PRL_ID] uniqueidentifier NOT NULL,
        [PRL_LotNumber] nvarchar(50) NOT NULL,
        [PRL_ReceiptQty] float NOT NULL,
        [PRL_ExpiredDate] datetime NULL,
        [PRL_WHM_ID] uniqueidentifier NULL,
        [PRL_UnitPrice] decimal(18, 2) NULL,
        [PRL_IsCalRebate] bit NULL)
      
      CREATE TABLE #tmpSAPShipmentHeader(
        [PRH_ID]               UNIQUEIDENTIFIER NOT NULL,
        [PRH_SAPShipmentID]    NVARCHAR(50) NULL,
        [PRH_Type]             NVARCHAR(50) NULL,
        [PRH_PurchaseOrderNbr] NVARCHAR(50) NULL
      )
      
      CREATE TABLE #cmpWMSShipment(
        [DNB_ID] uniqueidentifier NOT NULL,
        [DNB_DeliveryNoteNbr] nvarchar(50) NULL, 
        [DNB_LotNumber] nvarchar(50) NULL,
        [DNB_QRCode] nvarchar(50) NULL,
        [DNB_ShipQty] decimal(18, 6) NULL, 
        [DNB_OrderNo] nvarchar(50) NULL,
        [DNB_BoxNo] nvarchar(50) NULL,       
        [DNB_SapDeliveryLineNbr] nvarchar(50) NULL,
        [DNB_ProblemDescription] nvarchar(200) NULL,       
        [DNB_POReceiptLot_PRL_ID] uniqueidentifier NULL,
        [DNB_HandleDate] datetime NULL,
        [DNB_DMA_ID] uniqueidentifier NULL,     
        [DNB_CFN_ID] uniqueidentifier NULL,
        [DNB_PMA_ID] uniqueidentifier NULL,
        [DNB_LTM_ID] uniqueidentifier NULL,
        [DNB_Note] nvarchar(100) NULL      
      )
      
      CREATE TABLE #cmpSAPShipment(
        [PRH_ID] uniqueidentifier NOT NULL,
        [PRH_SAPShipmentID] nvarchar(50) NOT NULL, 
        [PRH_PurchaseOrderNbr] nvarchar(50) NOT NULL, 
        [POR_SAP_PMA_ID] uniqueidentifier NOT NULL, 
        [PRL_LotNumber] nvarchar(50) NULL,       
        [Qty] decimal(18, 6) NULL,
        [ErrorMsg] nvarchar(200) NULL
      )
      
      CREATE TABLE #ErrorShipment(
        [PRH_ID] uniqueidentifier NOT NULL,
        [PRH_SAPShipmentID] nvarchar(50) NOT NULL, 
        [PRH_PurchaseOrderNbr] nvarchar(50) NOT NULL, 
        [ErrorMsg] nvarchar(200) NULL
      )
      
       CREATE TABLE #TMP_ORDER(
         PohId        UNIQUEIDENTIFIER,
		     OrderNo      NVARCHAR(50),
         --PodId        UNIQUEIDENTIFIER,
		     --CfnID        UNIQUEIDENTIFIER,
		     ShortCode    NVARCHAR(50),         
         ReceiptQty   DECIMAL (18, 6),
         OrderRequiredQty DECIMAL (18, 6),
         OrderReceiptQty DECIMAL (18, 6),
         PRIMARY KEY (PohId, ShortCode)
      )
      
      CREATE TABLE #TmpOrderDetail(
        POD_ID UNIQUEIDENTIFIER not null,
        POD_ReceiptQty decimal(18, 6) not null
      )
      
      CREATE TABLE #SuccessWMSShipment(
        DNB_ID UNIQUEIDENTIFIER NOT NULL
      )
      
      --Add By SongWeiming on 2017-02-07 (投诉相关功能)
      Create table #ComplainID(DC_ID uniqueidentifier not null)
                              
      select DC_ID,COMPLAINTID,UPN,DC_CorpId,WHM_ID,RETURNTYPE,CONFIRMRETURNTYPE INTO #DealerComplainBSC 
        from DealerComplain(nolock)
       where COMPLAINTID IS NOT NULL and COMPLAINTID <> '' and DC_ID IS NOT NULL
     
      select DC_ID,IAN,PI,Serial,DC_CorpId,WHMID,RETURNTYPE INTO #DealerComplainCRM 
        from DealerComplainCRM(nolock) 
       where ((IAN IS NOT NULL and IAN <> '') OR (PI IS NOT NULL and PI <> '')) and DC_ID IS NOT NULL
      --End Add By SongWeiming on 2017-02-07
      
      --写入待匹配的SAP发货单
      INSERT INTO #tmpSAPShipmentHeader(PRH_ID,PRH_SAPShipmentID,PRH_Type,PRH_PurchaseOrderNbr)
      SELECT PRH_ID,PRH_SAPShipmentID,PRH_Type,PRH_PurchaseOrderNbr
        FROM POReceiptHeader_SAPNoQR(nolock)
       WHERE PRH_InterfaceStatus = 'UploadSuccess'
      
      --判断是否有记录，如果有记录则逐条进行处理
      SELECT @RowCnt = count(*) FROM #tmpSAPShipmentHeader
      IF @RowCnt > 0 
        BEGIN
          --游标遍历SAP发货单
          DECLARE curSAPShipment CURSOR FOR SELECT PRH_ID,PRH_SAPShipmentID,PRH_Type,PRH_PurchaseOrderNbr FROM #tmpSAPShipmentHeader 
          
          OPEN curSAPShipment
    				FETCH NEXT FROM curSAPShipment INTO @PRH_ID,@PRH_SAPShipmentID,@PRH_Type,@PRH_PurchaseOrderNbr

    				WHILE (@@fetch_status <> -1)
    				BEGIN
    				  IF (@@fetch_status <> -2)
    					  BEGIN
    						  DELETE FROM #cmpWMSShipment
							  DELETE FROM #cmpSAPShipment
							  DELETE FROM #ErrorShipment
							  DELETE FROM #TMP_ORDER
                  
                  --优先进行发货单匹配，匹配不上的，再核查是否是手工单的情况
                  IF @PRH_Type = 'Complain'
                         SET @PRH_SAPShipmentID = REPLACE(@PRH_SAPShipmentID,'-ForT2','')
                      
                  --Update product master infomation in DeliverynoteBSCSLC
        				  update t1 set t1.DNB_BUM_ID=t2.CFN_ProductLine_BUM_ID,t1.DNB_PCT_ID=ccf.ClassificationId,t1.DNB_CFN_ID=t2.CFN_ID,t1.DNB_PMA_ID=t3.PMA_ID
        					from DeliveryNoteBSCSLC t1, cfn t2(nolock), product t3(nolock),CfnClassification ccf 
        					where t1.DNB_CFN=t2.CFN_CustomerFaceNbr and t2.CFN_ID=t3.PMA_CFN_ID 
        					and ccf.CfnCustomerFaceNbr=t2.CFN_CustomerFaceNbr 
        					and ccf.ClassificationId in (select ProducPctId from GC_FN_GetDealerAuthProductSub(t1.DNB_DMA_ID) where ActiveFlag=1)
        					and DNB_DeliveryNoteNbr = @PRH_SAPShipmentID
        					and DNB_Status='UploadSuccess' 
        				  
        				  --将匹配的信息写入临时表
                  INSERT INTO #cmpWMSShipment(DNB_ID,DNB_DeliveryNoteNbr,DNB_LotNumber,DNB_QRCode,DNB_ShipQty,DNB_OrderNo,DNB_BoxNo,DNB_SapDeliveryLineNbr,DNB_ProblemDescription,DNB_POReceiptLot_PRL_ID,DNB_HandleDate,DNB_DMA_ID,DNB_CFN_ID,DNB_PMA_ID,DNB_LTM_ID,DNB_Note)
                  SELECT DNB_ID,DNB_DeliveryNoteNbr,DNB_LotNumber,DNB_QRCode,DNB_ShipQty,DNB_OrderNo,DNB_BoxNo,DNB_SapDeliveryLineNbr,DNB_ProblemDescription,DNB_POReceiptLot_PRL_ID,DNB_HandleDate,DNB_DMA_ID,DNB_CFN_ID,DNB_PMA_ID,DNB_LTM_ID,DNB_Note
                    FROM DeliveryNoteBSCSLC(NOLOCK)
                   WHERE DNB_Status='UploadSuccess' 
                     AND DNB_DeliveryNoteNbr = @PRH_SAPShipmentID
                         
                  
                  --判断是否匹配上，如果匹配不上，则核查是否手工单
                  select @MatchCnt = COUNT(*) from #cmpWMSShipment
                  IF @MatchCnt = 0
                    BEGIN                  
        					  --判断是否是手工单（订单编号中是否存在“补”字样）
        					  IF @PRH_Type = 'PurchaseOrder' AND CHARINDEX('补',@PRH_PurchaseOrderNbr)>0
        						BEGIN                      
        						  --手工单根据“补”之后的编号进行匹配
        						  INSERT INTO #cmpWMSShipment(DNB_ID,DNB_DeliveryNoteNbr,DNB_LotNumber,DNB_QRCode,DNB_ShipQty,DNB_OrderNo,DNB_BoxNo,DNB_SapDeliveryLineNbr,DNB_ProblemDescription,DNB_POReceiptLot_PRL_ID,DNB_HandleDate,DNB_DMA_ID,DNB_CFN_ID,DNB_PMA_ID,DNB_LTM_ID,DNB_Note)
        						  SELECT DNB_ID,DNB_DeliveryNoteNbr,DNB_LotNumber,DNB_QRCode,DNB_ShipQty,DNB_OrderNo,DNB_BoxNo,DNB_SapDeliveryLineNbr,DNB_ProblemDescription,DNB_POReceiptLot_PRL_ID,DNB_HandleDate,DNB_DMA_ID,DNB_CFN_ID,DNB_PMA_ID,DNB_LTM_ID,DNB_Note
        							FROM DeliveryNoteBSCSLC(NOLOCK) 
        						   WHERE DNB_Status='UploadSuccess' 
        							AND DNB_DeliveryNoteNbr = Substring(@PRH_PurchaseOrderNbr,CHARINDEX('补',@PRH_PurchaseOrderNbr)+1,len(@PRH_PurchaseOrderNbr))  
        							                     
        						END
        					END
                  /*
                  ELSE
                    BEGIN
                      --对于二级的投诉换货，会在正常的41单号后面增加"-ForT2"的字样
                      IF @PRH_Type = 'Complain'
                         SET @PRH_SAPShipmentID = REPLACE(@PRH_SAPShipmentID,'-ForT2','')
                      
                      --将匹配的信息写入临时表
                      INSERT INTO #cmpWMSShipment(DNB_ID,DNB_DeliveryNoteNbr,DNB_LotNumber,DNB_QRCode,DNB_ShipQty,DNB_OrderNo,DNB_BoxNo,DNB_SapDeliveryLineNbr,DNB_ProblemDescription,DNB_POReceiptLot_PRL_ID,DNB_HandleDate,DNB_DMA_ID,DNB_CFN_ID,DNB_PMA_ID,DNB_LTM_ID,DNB_Note)
                      SELECT DNB_ID,DNB_DeliveryNoteNbr,DNB_LotNumber,DNB_QRCode,DNB_ShipQty,DNB_OrderNo,DNB_BoxNo,DNB_SapDeliveryLineNbr,DNB_ProblemDescription,DNB_POReceiptLot_PRL_ID,DNB_HandleDate,DNB_DMA_ID,DNB_CFN_ID,DNB_PMA_ID,DNB_LTM_ID,DNB_Note
                        FROM DeliveryNoteBSCSLC 
                       WHERE DNB_Status='UploadSuccess' 
                         AND DNB_DeliveryNoteNbr = @PRH_SAPShipmentID
                    END
                  */                 
                  
                  --进行数量匹配，先将需要匹配的数据写入临时表
                  INSERT INTO #cmpSAPShipment(PRH_ID,PRH_SAPShipmentID,PRH_PurchaseOrderNbr,POR_SAP_PMA_ID,PRL_LotNumber,Qty)
                  SELECT H.PRH_ID,H.PRH_SAPShipmentID,H.PRH_PurchaseOrderNbr, Line.POR_SAP_PMA_ID,LOT.PRL_LotNumber,sum(LOT.PRL_ReceiptQty) AS Qty
                    FROM POReceiptHeader_SAPNoQR AS H(nolock), POReceipt_SAPNoQR AS Line(nolock), POReceiptLot_SAPNoQR AS LOT(nolock)
                   WHERE H.PRH_ID = Line.POR_PRH_ID AND Line.POR_ID = LOT.PRL_POR_ID
                     AND H.PRH_ID=@PRH_ID
                     group by  H.PRH_ID,H.PRH_SAPShipmentID,H.PRH_PurchaseOrderNbr, Line.POR_SAP_PMA_ID,LOT.PRL_LotNumber
                  
                  --判断收货单总数量与WMS收货单总数量是否一致,不一致则更新错误信息(如果WMS没有上传数据则不认为是错误)
                  IF (select count(*) from #cmpWMSShipment) > 0  
                    BEGIN
                      IF (select count(*) 
                                  from (SELECT sum(Qty) AS SAPQty FROM #cmpSAPShipment) AS cmpSAP,
                                       (select sum(DNB_ShipQty) AS WMSQty FROM #cmpWMSShipment) AS cmpWMS
                               WHERE cmpSAP.SAPQty <> cmpWMS.WMSQty) > 0
                         UPDATE #cmpSAPShipment SET ErrorMsg = 'SAP发货单总数量与WMS发货单不一致;'                   
                      
                      --判断收货单每一个批号的产品数量与WMS按批号汇总的产品数量是否一致
                      --SELECT * 
                      UPDATE cmpSAP SET cmpSAP.ErrorMsg = isnull(cmpSAP.ErrorMsg,'') + '此批号产品SAP发货数量与WMS发货数量不一致'
                        FROM #cmpSAPShipment AS cmpSAP 
                        LEFT JOIN
                             (select DNB_PMA_ID,DNB_LotNumber,sum(DNB_ShipQty) AS WMSQty FROM #cmpWMSShipment group by DNB_PMA_ID,DNB_LotNumber ) AS cmpWMS
                          ON (cmpSAP.POR_SAP_PMA_ID = cmpWMS.DNB_PMA_ID and cmpSAP.PRL_LotNumber = cmpWMS.DNB_LotNumber)
                          WHERE cmpSAP.Qty <> isnull(cmpWMS.WMSQty,0)
                    END
                 
                    
                  --判断是否包含错误
                  SELECT @ErrCnt = COUNT(*) FROM #cmpSAPShipment WHERE ErrorMsg IS NOT NULL AND ErrorMsg <>''
                  IF (@ErrCnt = 0 AND (select count(*) from #cmpWMSShipment) > 0)
                    BEGIN
                      --将数据写入正式收货表(Header)                     
                      INSERT INTO #tmpPOReceiptHeader
                            (PRH_ID, PRH_PONumber, PRH_SAPShipmentID, PRH_Dealer_DMA_ID, PRH_ReceiptDate, PRH_SAPShipmentDate, PRH_Status, PRH_Vendor_DMA_ID, PRH_Type, PRH_ProductLine_BUM_ID, PRH_PurchaseOrderNbr, PRH_Receipt_USR_UserID, PRH_Carrier, PRH_TrackingNo, PRH_ShipType, PRH_Note, PRH_ArrivalDate, PRH_DeliveryDate, PRH_SapDeliveryDate, PRH_WHM_ID, PRH_FromWHM_ID )
                      SELECT PRH_ID, PRH_PONumber, PRH_SAPShipmentID, PRH_Dealer_DMA_ID, PRH_ReceiptDate, PRH_SAPShipmentDate, PRH_Status, PRH_Vendor_DMA_ID, PRH_Type, PRH_ProductLine_BUM_ID, PRH_PurchaseOrderNbr, PRH_Receipt_USR_UserID, PRH_Carrier, PRH_TrackingNo, PRH_ShipType, PRH_Note, PRH_ArrivalDate, PRH_DeliveryDate, PRH_SapDeliveryDate, PRH_WHM_ID, PRH_FromWHM_ID 
                        FROM POReceiptHeader_SAPNoQR(nolock) 
                       WHERE PRH_ID= @PRH_ID
                      
                      --更新装箱号 /暂时不使用 2016-12-07
                      --UPDATE #tmpPOReceiptHeader SET PRH_TrackingNo = (SELECT top 1 DNB_BoxNo FROM #cmpWMSShipment)
                      -- WHERE PRH_ID= @PRH_ID
                      
                      --将数据写入正式收货表(Line)   
                      INSERT INTO #tmpPOReceipt
                            (POR_ID, POR_SAPSOLine, POR_SAPSOID, POR_SAP_PMA_ID, POR_ReceiptQty, POR_UnitPrice, POR_ConvertFactor, POR_PRH_ID, POR_ChangedUnitProduct_PMA_ID, POR_LineNbr)
                      SELECT POR_ID, POR_SAPSOLine, POR_SAPSOID, POR_SAP_PMA_ID, POR_ReceiptQty, POR_UnitPrice, POR_ConvertFactor, POR_PRH_ID, POR_ChangedUnitProduct_PMA_ID, POR_LineNbr
                        FROM POReceipt_SAPNoQR(nolock) 
                       WHERE POR_PRH_ID = @PRH_ID
                      
                      --将数据写入正式收货表(Lot)   
                      --更新订单明细表的实际收货数量及订单主表的状态
                      INSERT INTO #tmpPOReceiptLot(PRL_POR_ID, PRL_ID, PRL_LotNumber, PRL_ReceiptQty, PRL_ExpiredDate, PRL_WHM_ID, PRL_UnitPrice, PRL_IsCalRebate)
                      SELECT Line.POR_ID,newid(),Lot.PRL_LotNumber + '@@' + ISNULL(#cmpWMSShipment.DNB_QRCode,'NoQR'),#cmpWMSShipment.DNB_ShipQty,
                             LOT.PRL_ExpiredDate,LOT.PRL_WHM_ID,LOT.PRL_UnitPrice,LOT.PRL_IsCalRebate
                        FROM POReceiptLot_SAPNoQR AS LOT(nolock)
                          INNER JOIN
                             POReceipt_SAPNoQR AS Line(nolock) ON (LOT.PRL_POR_ID = Line.POR_ID )
                          INNER JOIN
                             #cmpWMSShipment ON (Line.POR_SAP_PMA_ID = #cmpWMSShipment.DNB_PMA_ID and Lot.PRL_LotNumber = #cmpWMSShipment.DNB_LotNumber)
                        WHERE Line.POR_PRH_ID = @PRH_ID
                      
                      
                      --更新订单(对于投诉不用更新订单,如果无法找到对应的订单，也不需要更新)
                      IF @PRH_Type = 'PurchaseOrder'
                        BEGIN
                          --按短编号进行匹配（因为非CRM产品UPN就等于短编号）                           
                  			  INSERT INTO #TMP_ORDER (PohId, OrderNo, ShortCode, ReceiptQty,OrderRequiredQty,OrderReceiptQty)
                  			  SELECT cmpOrder.POH_ID,
                                 cmpOrder.POH_OrderNo,
                                 cmpOrder.ShortCode,
                                 cmpSAP.ReceiptQty,
                                 cmpOrder.OrderRequiredQty,
                                 cmpOrder.OrderReceiptQty
                  					 FROM (select t1.PRH_PurchaseOrderNbr,t3.CFN_Property1 AS ShortCode,SUM(Qty) AS ReceiptQty
                                     from #cmpSAPShipment t1,Product t2(NOLOCK), cfn t3(NOLOCK)
                                    where t1.POR_SAP_PMA_ID = t2.PMA_ID
                                      and t2.PMA_CFN_ID = t3.CFN_ID
                                     group by t1.PRH_PurchaseOrderNbr,t3.CFN_Property1
                                   )  AS cmpSAP,                    						  
                                  (select POH.POH_ID,POH.POH_OrderNo,C.CFN_Property1 AS ShortCode,
                                          SUM(isnull(POD.POD_RequiredQty,0)) AS OrderRequiredQty,
                                          SUM(isnull(POD_ReceiptQty,0)) AS OrderReceiptQty
                                     from PurchaseOrderHeader AS POH(nolock)                     						  
                                          INNER JOIN PurchaseOrderDetail AS POD(nolock) ON (POD.POD_POH_ID = POH.POH_ID)
                                          INNER JOIN CFN AS C(nolock) ON (C.CFN_ID = POD.POD_CFN_ID)
                  					        WHERE POH.POH_CreateType <> 'Temporary'
                  					          AND POH.POH_OrderNo IN (SELECT CASE WHEN CHARINDEX('补',PRH_PurchaseOrderNbr)>0 
                                                                          THEN Substring(PRH_PurchaseOrderNbr,1,CHARINDEX('补',PRH_PurchaseOrderNbr)-1)
                                                                          ELSE PRH_PurchaseOrderNbr
                                                                          END 
                                                                FROM #cmpSAPShipment)              
                  				          GROUP BY POH.POH_ID,POH.POH_OrderNo,C.CFN_Property1 
                                  ) AS cmpOrder
                            WHERE cmpOrder.POH_OrderNo = CASE WHEN CHARINDEX('补',cmpSAP.PRH_PurchaseOrderNbr)>0 
                                                              THEN Substring(cmpSAP.PRH_PurchaseOrderNbr,1,CHARINDEX('补',cmpSAP.PRH_PurchaseOrderNbr)-1)
                                                              ELSE cmpSAP.PRH_PurchaseOrderNbr
                                                              END
                              AND cmpOrder.ShortCode = cmpSAP.ShortCode
                          
                          
                          --如果没有获取订单，则不执行下面的更新操作
                          SELECT @RowCnt = count(*) FROM #TMP_ORDER
                          IF @RowCnt > 0 
                            BEGIN
                              
                              DECLARE	curTMPOrder CURSOR FOR SELECT PohId,OrderNo,ShortCode,ReceiptQty,OrderRequiredQty,OrderReceiptQty FROM #TMP_ORDER
                      				OPEN curTMPOrder FETCH NEXT FROM curTMPOrder INTO @TmpPohId,@TmpOrderNo,@TmpShortCode,@TmpReceiptQty,@TmpOrderRequiredQty,@TmpOrderReceiptQty
                      				
                      				WHILE @@FETCH_STATUS = 0
                      					BEGIN
                      						DECLARE	curDetail CURSOR 
                      						FOR SELECT POD_ID,POD_CFN_ID,POD_RequiredQty,POD_ReceiptQty,POD_CFN_Price,CFN_Property1 AS ShortCode
                      							    FROM PurchaseOrderDetail(nolock),cfn(nolock)
                      							   WHERE POD_POH_ID=@TmpPohId
                            						 AND POD_CFN_ID = CFN_ID                            						 
                            						 AND CFN_Property1 = @TmpShortCode
                            						 AND POD_RequiredQty > POD_ReceiptQty
                            					 ORDER BY POD_CFN_Price desc

                      						OPEN curDetail
                      						FETCH NEXT FROM curDetail INTO @CurPodID,@CurCfnID,@CurRequireQty,@CurReceiptQty,@CurCfnPrice,@CurShortCode

                      						WHILE @@FETCH_STATUS = 0
                      						BEGIN
                      						  --遍历发货明细，比较未收货数量和发货明细数量
                      						  --如果未收货数量>发货明细数量，则更新收货数量和未收货数量
                      							IF(@TmpReceiptQty > 0 and  @CurShortCode = @TmpShortCode)
                        							BEGIN
                        								IF((@CurRequireQty -@CurReceiptQty ) <  @TmpReceiptQty)
                          								BEGIN
                          									--如果发货数量大于未收货数量，则直接加上未收货数量
                                            INSERT INTO #TmpOrderDetail(POD_ID,POD_ReceiptQty)
                                            SELECT @CurPodID,(@CurRequireQty-@CurReceiptQty)                                          
                                            
--                                            UPDATE PurchaseOrderDetail
--                          									SET POD_ReceiptQty = POD_RequiredQty
--                          									WHERE POD_ID = @CurPodID
                          									
                          									SELECT @TmpReceiptQty = @TmpReceiptQty - @CurRequireQty + @CurReceiptQty

                          								END
                        								ELSE
                          								BEGIN
                          									--如果发货数量小于未收货数量，则直接加上发货数量
                                            INSERT INTO #TmpOrderDetail(POD_ID,POD_ReceiptQty)
                                            SELECT @CurPodID,@TmpReceiptQty
                                            
--                                            UPDATE PurchaseOrderDetail
--                          									SET POD_ReceiptQty = POD_ReceiptQty + @TmpReceiptQty
--                          									WHERE POD_ID = @CurPodID
                          								
                          									SET @TmpReceiptQty = 0
                          								END
                        							END					 
                      						  
                                    FETCH NEXT FROM curDetail INTO @CurPodID,@CurCfnID,@CurRequireQty,@CurReceiptQty,@CurCfnPrice,@CurShortCode
                      						END
                      						CLOSE curDetail
                      						DEALLOCATE curDetail
                      					
                      					  
                                  
                                  FETCH NEXT FROM curTMPOrder INTO @TmpPohId,@TmpOrderNo,@TmpShortCode,@TmpReceiptQty,@TmpOrderRequiredQty,@TmpOrderReceiptQty
                      					END

                      					CLOSE curTMPOrder
                      					DEALLOCATE curTMPOrder
                            END
                            
                            --将正确的WMS接口数据ID写入临时表，用于后续更新状态
                            INSERT INTO #SuccessWMSShipment(DNB_ID)
                            SELECT DNB_ID FROM #cmpWMSShipment
                            
                      END
                      ELSE
                        BEGIN
                                  print '100'
                                  
                                  --Add By SongWeiming on 2017-01-22 更新投诉单状态
                                  Delete from #ComplainID                                   
                                  INSERT INTO #ComplainID 
                                      select DC_ID FROM (
                                      SELECT DISTINCT dc.DC_ID  
                      							     FROM (SELECT PRH_PurchaseOrderNbr FROM #tmpPOReceiptHeader WHERE PRH_ID = @PRH_ID ) AS PRH
                      				          INNER JOIN #DealerComplainBSC AS dc(nolock) on ((case when len(PRH.PRH_PurchaseOrderNbr) < 3 
                      					                                                          then PRH.PRH_PurchaseOrderNbr 
                      					                                                          else case when substring(PRH.PRH_PurchaseOrderNbr,1,3)='CRA' 
                      							                                                                then substring(PRH.PRH_PurchaseOrderNbr,3,LEN(PRH.PRH_PurchaseOrderNbr)-2)
                      							                                                                ELSE PRH.PRH_PurchaseOrderNbr end 
                      					                                                          END) = 
                                                                                   (case when len(COMPLAINTID) <= 10 
                      								                                                   then COMPLAINTID 
                      								                                                   else CASE WHEN substring(PRH.PRH_PurchaseOrderNbr,1,3)='CRA' 
                      											                                                       THEN SUBSTRING(COMPLAINTID,1,PATINDEX ('%-%', COMPLAINTID)-1) 
                      										                                                         ELSE COMPLAINTID end
                      								                                                   END ) 
                                                                                   )
                      		             
                                      UNION
                                      --CRM
                                      SELECT DISTINCT dc.DC_ID
                      			            FROM (SELECT PRH_PurchaseOrderNbr FROM #tmpPOReceiptHeader WHERE PRH_ID = @PRH_ID ) AS PRH
                      			           INNER JOIN #DealerComplainCRM AS dc on ((case when len(PRH.PRH_PurchaseOrderNbr) < 3  
                      					                                                     then PRH.PRH_PurchaseOrderNbr 
                                                                                     else case when substring(PRH.PRH_PurchaseOrderNbr,1,3)='IAN' 
                                                                                               then substring(PRH.PRH_PurchaseOrderNbr,4,LEN(PRH.PRH_PurchaseOrderNbr)-3) 
                      												                                                 When substring(PRH.PRH_PurchaseOrderNbr,1,2)='PI' 
                                                                                               then substring(PRH.PRH_PurchaseOrderNbr,3,LEN(PRH.PRH_PurchaseOrderNbr)-2)
                      												                                                 else PRH.PRH_PurchaseOrderNbr end 
                      					                                                      end ) = 
                                                                              (Case when substring(PRH.PRH_PurchaseOrderNbr,1,3)='IAN' 
                                                                                    then dc.IAN 
                                                                                    else dc.PI end ) 
                                                                            	)
                                      ) tab
                                       
                                    print '101'
                                      update t1  set t1.DC_Status='Delivered'
                                      from DealerComplain t1,#ComplainID t2
                                      where t1.DC_ID = t2.DC_ID
                                    
                                    print '102'
                                      update t1  set t1.DC_Status='Delivered'
                                      from DealerComplainCRM t1,#ComplainID t2
                                      where t1.DC_ID = t2.DC_ID
                                    
                                    print '103'  
                                      INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
                                      SELECT NEWID(),DC_ID,@SysUserId,GETDATE(),'Submit','修改状态为：波科已换货给平台/T1' from #ComplainID
                                  --End Add By SongWeiming on 2017-01-22 更新投诉单状态
                        
                        END
                      
                    
                    END
                  ELSE
                    BEGIN
                      IF (select count(*) from #cmpWMSShipment) > 0
                        BEGIN
                          --错误处理，将错误的SAP发货单写入错误数据表
                          INSERT INTO #ErrorShipment(PRH_ID,PRH_SAPShipmentID,PRH_PurchaseOrderNbr,ErrorMsg)                      
                          SELECT H.PRH_ID,H.PRH_SAPShipmentID,H.PRH_PurchaseOrderNbr,ErrorMsg = 'SAP发货单数量与WMS发货单不一致'
                            FROM POReceiptHeader_SAPNoQR AS H(Nolock) 
                           WHERE PRH_ID = @PRH_ID
                        END
                    END
    					  END

    				   FETCH NEXT FROM curSAPShipment	INTO @PRH_ID,@PRH_SAPShipmentID,@PRH_Type,@PRH_PurchaseOrderNbr
               
               
    				END

    				CLOSE curSAPShipment
    				DEALLOCATE curSAPShipment
            
            
            --发货数据写入正式表
            INSERT INTO POReceiptHeader(PRH_ID, PRH_PONumber, PRH_SAPShipmentID, PRH_Dealer_DMA_ID, PRH_ReceiptDate, PRH_SAPShipmentDate, PRH_Status, PRH_Vendor_DMA_ID, PRH_Type, PRH_ProductLine_BUM_ID, PRH_PurchaseOrderNbr, PRH_Receipt_USR_UserID, PRH_Carrier, PRH_TrackingNo, PRH_ShipType, PRH_Note, PRH_ArrivalDate, PRH_DeliveryDate, PRH_SapDeliveryDate, PRH_WHM_ID, PRH_FromWHM_ID )
            SELECT PRH_ID, PRH_PONumber, PRH_SAPShipmentID, PRH_Dealer_DMA_ID, PRH_ReceiptDate, PRH_SAPShipmentDate, PRH_Status, PRH_Vendor_DMA_ID, PRH_Type, PRH_ProductLine_BUM_ID, PRH_PurchaseOrderNbr, PRH_Receipt_USR_UserID, PRH_Carrier, PRH_TrackingNo, PRH_ShipType, PRH_Note, PRH_ArrivalDate, PRH_DeliveryDate, PRH_SapDeliveryDate, PRH_WHM_ID, PRH_FromWHM_ID
              FROM #tmpPOReceiptHeader
            
            INSERT INTO POReceipt (POR_ID, POR_SAPSOLine, POR_SAPSOID, POR_SAP_PMA_ID, POR_ReceiptQty, POR_UnitPrice, POR_ConvertFactor, POR_PRH_ID, POR_ChangedUnitProduct_PMA_ID, POR_LineNbr)
            SELECT POR_ID, POR_SAPSOLine, POR_SAPSOID, POR_SAP_PMA_ID, POR_ReceiptQty, POR_UnitPrice, POR_ConvertFactor, POR_PRH_ID, POR_ChangedUnitProduct_PMA_ID, POR_LineNbr
              FROM #tmpPOReceipt
              
            INSERT INTO POReceiptLot(PRL_POR_ID, PRL_ID, PRL_LotNumber, PRL_ReceiptQty, PRL_ExpiredDate, PRL_WHM_ID, PRL_UnitPrice, PRL_IsCalRebate)
            SELECT PRL_POR_ID, PRL_ID, PRL_LotNumber, PRL_ReceiptQty, PRL_ExpiredDate, PRL_WHM_ID, PRL_UnitPrice, PRL_IsCalRebate
              FROM #tmpPOReceiptLot
            
            PRINT 'AAA'
            --发货单信息写入接口表（供平台下载）
            INSERT INTO DeliveryInterface (DI_ID,DI_BatchNbr,DI_RecordNbr,DI_SapDeliveryNo,DI_Status,DI_ProcessType,DI_FileName,
                                           DI_CreateUser,DI_CreateDate,DI_UpdateUser,DI_UpdateDate,DI_ClientID)
				   SELECT newid(),'','',PRH_SAPShipmentID,'Pending','System',
    						  '',@SysUserId,getdate (),NULL,NULL,CLT_ID
					 FROM (SELECT DISTINCT PRH_SAPShipmentID, CLT_ID
							     FROM #tmpPOReceiptHeader
								        INNER JOIN Client ON (CLT_Corp_Id = PRH_Dealer_DMA_ID)
							    WHERE PRH_Dealer_DMA_ID IN (SELECT DMA_ID
																                  FROM dealerMaster(NOLOCK)
															                   WHERE DMA_DealerType ='LP')
                ) AS TAB
            
            --更新订单明细的实际发货数量            
            UPDATE CurPod 
               SET CurPod.POD_ReceiptQty = ISNULL(CurPod.POD_ReceiptQty,0)+UpdPod.ReceiptQty
              FROM PurchaseOrderDetail CurPod,
                   (SELECT POD_ID,sum(POD_ReceiptQty) AS ReceiptQty 
                      from #TmpOrderDetail group by POD_ID
                    ) UpdPod 
             WHERE CurPod.POD_ID = UpdPod.POD_ID
          
            --更新订单表头状态
    				UPDATE PurchaseOrderHeader
    				   SET POH_OrderStatus = 'Delivering'
    				 WHERE POH_ID IN (SELECT DISTINCT D.POD_POH_ID FROM #TmpOrderDetail POD, PurchaseOrderDetail AS D(nolock) WHERE POD.POD_ID = D.POD_ID )

    				UPDATE PurchaseOrderHeader
    				   SET POH_OrderStatus = 'Completed'
    				 WHERE     POH_ID IN (SELECT DISTINCT D.POD_POH_ID FROM #TmpOrderDetail POD, PurchaseOrderDetail AS D(nolock) WHERE POD.POD_ID = D.POD_ID)
    					   AND POH_OrderStatus = 'Delivering'
    					   AND NOT EXISTS
    							  (SELECT 1
    								 FROM PurchaseOrderDetail(nolock)
    								WHERE PurchaseOrderDetail.POD_POH_ID = PurchaseOrderHeader.POH_ID
    									AND POD_RequiredQty > POD_ReceiptQty)
            PRINT 'BBB'
            --写入订单接口信息
            
                        
            INSERT INTO PurchaseOrderLog (POL_ID,
											  POL_POH_ID,
											  POL_OperUser,
											  POL_OperDate,
											  POL_OperType,
											  POL_OperNote)
				    SELECT newid () AS POL_ID,
						       TAB.POD_POH_ID AS POL_POH_ID,
						       @SysUserId AS POL_OperUser,
						       getdate () AS POL_OperDate,
						       N'Delivery' AS POL_OperType,
						       N'波科SAP数据接口发货,发货总数量：' + Convert(nvarchar(100),isnull(Qty,0)) AS POL_OperNote						    
					    FROM (SELECT POD.POD_POH_ID,sum(UpdPod.ReceiptQty) AS Qty
                      FROM (SELECT POD_ID,sum(POD_ReceiptQty) AS ReceiptQty 
                              FROM #TmpOrderDetail
                             GROUP BY POD_ID
                            ) UpdPod, PurchaseOrderDetail AS POD(nolock) 
                     WHERE UpdPod.POD_ID = POD.POD_ID
                     GROUP BY POD.POD_POH_ID  ) TAB
                     
            
            PRINT 'CCC'
            --写入新的LotMaster信息
            INSERT INTO LotMaster
			      SELECT NULL,
                   TAB.PRL_ExpiredDate,
					         TAB.PRL_LotNumber,
          				 newid (),
          				 getdate (),
          				 NULL,
          				 TAB.PMA_ID,
          				 (SELECT max(DOM.DOM) FROM dbo.LotMasterDOM AS DOM(NOLOCK) 
          				   where DOM.PMA_ID = TAB.PMA_ID 
          				   and DOM.LOT = CASE WHEN charindex('@@',TAB.PRL_LotNumber) > 0 
											                  THEN substring(TAB.PRL_LotNumber,1,charindex('@@',TAB.PRL_LotNumber)-1) 
											                  ELSE TAB.PRL_LotNumber
											                  END),
          				 NULL
			        FROM (SELECT DISTINCT Line.POR_SAP_PMA_ID AS PMA_ID, Lot.PRL_LotNumber,Lot.PRL_ExpiredDate 
                      FROM #tmpPOReceipt Line, #tmpPOReceiptLot Lot
                     WHERE Line.POR_ID = Lot.PRL_POR_ID ) TAB
			       WHERE NOT EXISTS (SELECT 1
                							   FROM LotMaster AS LM(NOLOCK)
                						    WHERE LM.LTM_LotNumber = TAB.PRL_LotNumber
                								  AND LM.LTM_Product_PMA_ID = TAB.PMA_ID)
            PRINT 'DDD'
            --错误数据更新POReceiptHeader_SAPNoQR表的状态
            UPDATE POReceiptHeader_SAPNoQR
               SET PRH_InterfaceStatus = 'GenerateSuccess'
             WHERE PRH_ID IN (SELECT PRH_ID FROM #tmpPOReceiptHeader)
            PRINT 'EEE'
            UPDATE T
               SET T.PRH_InterfaceStatus = 'GenerateFailure', T.PRH_Note=E.ErrorMsg
              FROM POReceiptHeader_SAPNoQR AS T,#ErrorShipment AS E
             WHERE T.PRH_ID = E.PRH_ID
            PRINT 'FFF'
            UPDATE T
               SET T.DNB_Status = 'GenerateSuccess'
              FROM DeliveryNoteBSCSLC T,#SuccessWMSShipment Tmp
             WHERE T.DNB_ID = Tmp.DNB_ID
            PRINT 'GGG'
            --增加收货数据日志
            INSERT INTO PurchaseOrderLog (POL_ID,
    											  POL_POH_ID,
    											  POL_OperUser,
    											  POL_OperDate,
    											  POL_OperType,
    											  POL_OperNote)
    				   SELECT newid () AS POL_ID,
    						  PRH_ID,
    						  @SysUserId AS POL_OperUser,
    						  getdate () AS POL_OperDate,
    						  N'Delivery' AS POL_OperType,
    						  N'DMS合并校验WMS系统数据后,定时自动生成最终的发货数据' AS POL_OperNote
    					 FROM #tmpPOReceiptHeader
               
          
      			
            
            --错误发货单发邮件通知(暂时不处理)
            --#ErrorShipment表中数据写入
            --INSERT INTO TmpOrderDetail SELECT * FROM #TmpOrderDetail
            --INSERT INTO _Tmp_cmpSAPShipment SELECT * FROM #cmpSAPShipment
        END
        
      COMMIT TRAN
      SET @IsValid = 'Success'

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
      SET @vError = '行' + CONVERT (NVARCHAR (10), @error_line) + '出错[错误号' + CONVERT (NVARCHAR (10), @error_number) + '],' + @error_message
      SET @RtnMsg = @vError      
      RETURN -1
   END CATCH
GO


