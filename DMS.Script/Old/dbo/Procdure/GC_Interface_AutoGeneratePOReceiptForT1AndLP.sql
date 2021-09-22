DROP PROCEDURE [dbo].[GC_Interface_AutoGeneratePOReceiptForT1AndLP]
GO

/*
�Զ����ɲ��Ʒ������ݽӿڣ�����WMS���������벨��SAP��������ƥ�����и��£�
1����ʱִ�У��ж�״̬ΪUploadSuccess����������Ҫ���������
2��������ά���Ժ󣬽�������ά�������д����ʽ��PoreceiptHeader��
   A���������Ž���ƥ�䣨SAP��41�����볩���ķ������ţ�
   B�������ֹ�������SAP��������С���������ĵ����볩���ķ������Ž���ƥ��
   B��SAP��Ͷ�߷������ţ���Ҫ�����ɸ������ķ������ŵġ�-ForT2������ȥ����Ȼ�����ƥ��
3��ʹ���α�һ��������SAP�ķ��������������д���
   A���ж��ջ���ÿһ�����ŵĲ�Ʒ������WMS�����Ż��ܵĲ�Ʒ�����Ƿ�һ��
   B���ж��ջ�����������WMS�ջ����������Ƿ�һ��
   C�����½ӿڱ�����ݣ���״̬����ΪGenerateSuccess��POReceiptHeader_SAPNoQR���DeliveryNoteBSCSLC��
   D�����¶�Ӧ������״̬��ÿһ����ϸ��Ʒ��ʵ���ջ�����
   E��������Ϣ�����ʼ�֪ͨ
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
   
   --������ƥ���¼ʱʹ��
   DECLARE @PRH_ID                UNIQUEIDENTIFIER
   DECLARE @PRH_SAPShipmentID     NVARCHAR(50)
   DECLARE @PRH_Type              NVARCHAR(50)
   DECLARE @PRH_PurchaseOrderNbr  NVARCHAR(50)
   
   --���¶���ʱʹ��
    DECLARE @TmpPohId uniqueidentifier ;        --#TMP_ORDER��POHID
  	--DECLARE @TmpPodId uniqueidentifier ;      --#TMP_ORDER��PODID
    DECLARE @TmpOrderNo   NVARCHAR(50);         --#TMP_ORDER��OrderNo
    --DECLARE @TmpCfnID uniqueidentifier;       --#TMP_ORDER��CFNID
    DECLARE @TmpShortCode NVARCHAR(50);         --#TMP_ORDER��ShortCode
  	DECLARE @TmpReceiptQty DECIMAL (18, 6);	    --#TMP_ORDER��ReceiptQty
    DECLARE @TmpOrderRequiredQty DECIMAL (18, 6);	--#TMP_ORDER��OrderRequiredQty
    DECLARE @TmpOrderReceiptQty DECIMAL (18, 6);	--#TMP_ORDER��OrderReceiptQty
  	
    DECLARE @CurPodID uniqueidentifier		 --PurchaseOrderDetail��PODID(curDetailʹ��)
  	DECLARE @CurCfnID uniqueidentifier
  	DECLARE @CurRequireQty DECIMAL (18, 6); 
  	DECLARE @CurReceiptQty DECIMAL (18, 6); 
    DECLARE @CurCfnPrice DECIMAL (18, 6); 
    DECLARE @CurShortCode NVARCHAR(50);
  	--declare @updateqty DECIMAL (18, 6);  --
  	--declare @updateqty2 DECIMAL (18, 6); --
  	declare @UpdateCfn uniqueidentifier;
  	
  	declare @cfn nvarchar(200); --��Ʒ�ͺ�
  	declare @bum nvarchar(100); --��Ʒ��
    
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
      
      --Add By SongWeiming on 2017-02-07 (Ͷ����ع���)
      Create table #ComplainID(DC_ID uniqueidentifier not null)
                              
      select DC_ID,COMPLAINTID,UPN,DC_CorpId,WHM_ID,RETURNTYPE,CONFIRMRETURNTYPE INTO #DealerComplainBSC 
        from DealerComplain(nolock)
       where COMPLAINTID IS NOT NULL and COMPLAINTID <> '' and DC_ID IS NOT NULL
     
      select DC_ID,IAN,PI,Serial,DC_CorpId,WHMID,RETURNTYPE INTO #DealerComplainCRM 
        from DealerComplainCRM(nolock) 
       where ((IAN IS NOT NULL and IAN <> '') OR (PI IS NOT NULL and PI <> '')) and DC_ID IS NOT NULL
      --End Add By SongWeiming on 2017-02-07
      
      --д���ƥ���SAP������
      INSERT INTO #tmpSAPShipmentHeader(PRH_ID,PRH_SAPShipmentID,PRH_Type,PRH_PurchaseOrderNbr)
      SELECT PRH_ID,PRH_SAPShipmentID,PRH_Type,PRH_PurchaseOrderNbr
        FROM POReceiptHeader_SAPNoQR(nolock)
       WHERE PRH_InterfaceStatus = 'UploadSuccess'
      
      --�ж��Ƿ��м�¼������м�¼���������д���
      SELECT @RowCnt = count(*) FROM #tmpSAPShipmentHeader
      IF @RowCnt > 0 
        BEGIN
          --�α����SAP������
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
                  
                  --���Ƚ��з�����ƥ�䣬ƥ�䲻�ϵģ��ٺ˲��Ƿ����ֹ��������
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
        				  
        				  --��ƥ�����Ϣд����ʱ��
                  INSERT INTO #cmpWMSShipment(DNB_ID,DNB_DeliveryNoteNbr,DNB_LotNumber,DNB_QRCode,DNB_ShipQty,DNB_OrderNo,DNB_BoxNo,DNB_SapDeliveryLineNbr,DNB_ProblemDescription,DNB_POReceiptLot_PRL_ID,DNB_HandleDate,DNB_DMA_ID,DNB_CFN_ID,DNB_PMA_ID,DNB_LTM_ID,DNB_Note)
                  SELECT DNB_ID,DNB_DeliveryNoteNbr,DNB_LotNumber,DNB_QRCode,DNB_ShipQty,DNB_OrderNo,DNB_BoxNo,DNB_SapDeliveryLineNbr,DNB_ProblemDescription,DNB_POReceiptLot_PRL_ID,DNB_HandleDate,DNB_DMA_ID,DNB_CFN_ID,DNB_PMA_ID,DNB_LTM_ID,DNB_Note
                    FROM DeliveryNoteBSCSLC(NOLOCK)
                   WHERE DNB_Status='UploadSuccess' 
                     AND DNB_DeliveryNoteNbr = @PRH_SAPShipmentID
                         
                  
                  --�ж��Ƿ�ƥ���ϣ����ƥ�䲻�ϣ���˲��Ƿ��ֹ���
                  select @MatchCnt = COUNT(*) from #cmpWMSShipment
                  IF @MatchCnt = 0
                    BEGIN                  
        					  --�ж��Ƿ����ֹ���������������Ƿ���ڡ�����������
        					  IF @PRH_Type = 'PurchaseOrder' AND CHARINDEX('��',@PRH_PurchaseOrderNbr)>0
        						BEGIN                      
        						  --�ֹ������ݡ�����֮��ı�Ž���ƥ��
        						  INSERT INTO #cmpWMSShipment(DNB_ID,DNB_DeliveryNoteNbr,DNB_LotNumber,DNB_QRCode,DNB_ShipQty,DNB_OrderNo,DNB_BoxNo,DNB_SapDeliveryLineNbr,DNB_ProblemDescription,DNB_POReceiptLot_PRL_ID,DNB_HandleDate,DNB_DMA_ID,DNB_CFN_ID,DNB_PMA_ID,DNB_LTM_ID,DNB_Note)
        						  SELECT DNB_ID,DNB_DeliveryNoteNbr,DNB_LotNumber,DNB_QRCode,DNB_ShipQty,DNB_OrderNo,DNB_BoxNo,DNB_SapDeliveryLineNbr,DNB_ProblemDescription,DNB_POReceiptLot_PRL_ID,DNB_HandleDate,DNB_DMA_ID,DNB_CFN_ID,DNB_PMA_ID,DNB_LTM_ID,DNB_Note
        							FROM DeliveryNoteBSCSLC(NOLOCK) 
        						   WHERE DNB_Status='UploadSuccess' 
        							AND DNB_DeliveryNoteNbr = Substring(@PRH_PurchaseOrderNbr,CHARINDEX('��',@PRH_PurchaseOrderNbr)+1,len(@PRH_PurchaseOrderNbr))  
        							                     
        						END
        					END
                  /*
                  ELSE
                    BEGIN
                      --���ڶ�����Ͷ�߻���������������41���ź�������"-ForT2"������
                      IF @PRH_Type = 'Complain'
                         SET @PRH_SAPShipmentID = REPLACE(@PRH_SAPShipmentID,'-ForT2','')
                      
                      --��ƥ�����Ϣд����ʱ��
                      INSERT INTO #cmpWMSShipment(DNB_ID,DNB_DeliveryNoteNbr,DNB_LotNumber,DNB_QRCode,DNB_ShipQty,DNB_OrderNo,DNB_BoxNo,DNB_SapDeliveryLineNbr,DNB_ProblemDescription,DNB_POReceiptLot_PRL_ID,DNB_HandleDate,DNB_DMA_ID,DNB_CFN_ID,DNB_PMA_ID,DNB_LTM_ID,DNB_Note)
                      SELECT DNB_ID,DNB_DeliveryNoteNbr,DNB_LotNumber,DNB_QRCode,DNB_ShipQty,DNB_OrderNo,DNB_BoxNo,DNB_SapDeliveryLineNbr,DNB_ProblemDescription,DNB_POReceiptLot_PRL_ID,DNB_HandleDate,DNB_DMA_ID,DNB_CFN_ID,DNB_PMA_ID,DNB_LTM_ID,DNB_Note
                        FROM DeliveryNoteBSCSLC 
                       WHERE DNB_Status='UploadSuccess' 
                         AND DNB_DeliveryNoteNbr = @PRH_SAPShipmentID
                    END
                  */                 
                  
                  --��������ƥ�䣬�Ƚ���Ҫƥ�������д����ʱ��
                  INSERT INTO #cmpSAPShipment(PRH_ID,PRH_SAPShipmentID,PRH_PurchaseOrderNbr,POR_SAP_PMA_ID,PRL_LotNumber,Qty)
                  SELECT H.PRH_ID,H.PRH_SAPShipmentID,H.PRH_PurchaseOrderNbr, Line.POR_SAP_PMA_ID,LOT.PRL_LotNumber,sum(LOT.PRL_ReceiptQty) AS Qty
                    FROM POReceiptHeader_SAPNoQR AS H(nolock), POReceipt_SAPNoQR AS Line(nolock), POReceiptLot_SAPNoQR AS LOT(nolock)
                   WHERE H.PRH_ID = Line.POR_PRH_ID AND Line.POR_ID = LOT.PRL_POR_ID
                     AND H.PRH_ID=@PRH_ID
                     group by  H.PRH_ID,H.PRH_SAPShipmentID,H.PRH_PurchaseOrderNbr, Line.POR_SAP_PMA_ID,LOT.PRL_LotNumber
                  
                  --�ж��ջ�����������WMS�ջ����������Ƿ�һ��,��һ������´�����Ϣ(���WMSû���ϴ���������Ϊ�Ǵ���)
                  IF (select count(*) from #cmpWMSShipment) > 0  
                    BEGIN
                      IF (select count(*) 
                                  from (SELECT sum(Qty) AS SAPQty FROM #cmpSAPShipment) AS cmpSAP,
                                       (select sum(DNB_ShipQty) AS WMSQty FROM #cmpWMSShipment) AS cmpWMS
                               WHERE cmpSAP.SAPQty <> cmpWMS.WMSQty) > 0
                         UPDATE #cmpSAPShipment SET ErrorMsg = 'SAP��������������WMS��������һ��;'                   
                      
                      --�ж��ջ���ÿһ�����ŵĲ�Ʒ������WMS�����Ż��ܵĲ�Ʒ�����Ƿ�һ��
                      --SELECT * 
                      UPDATE cmpSAP SET cmpSAP.ErrorMsg = isnull(cmpSAP.ErrorMsg,'') + '�����Ų�ƷSAP����������WMS����������һ��'
                        FROM #cmpSAPShipment AS cmpSAP 
                        LEFT JOIN
                             (select DNB_PMA_ID,DNB_LotNumber,sum(DNB_ShipQty) AS WMSQty FROM #cmpWMSShipment group by DNB_PMA_ID,DNB_LotNumber ) AS cmpWMS
                          ON (cmpSAP.POR_SAP_PMA_ID = cmpWMS.DNB_PMA_ID and cmpSAP.PRL_LotNumber = cmpWMS.DNB_LotNumber)
                          WHERE cmpSAP.Qty <> isnull(cmpWMS.WMSQty,0)
                    END
                 
                    
                  --�ж��Ƿ��������
                  SELECT @ErrCnt = COUNT(*) FROM #cmpSAPShipment WHERE ErrorMsg IS NOT NULL AND ErrorMsg <>''
                  IF (@ErrCnt = 0 AND (select count(*) from #cmpWMSShipment) > 0)
                    BEGIN
                      --������д����ʽ�ջ���(Header)                     
                      INSERT INTO #tmpPOReceiptHeader
                            (PRH_ID, PRH_PONumber, PRH_SAPShipmentID, PRH_Dealer_DMA_ID, PRH_ReceiptDate, PRH_SAPShipmentDate, PRH_Status, PRH_Vendor_DMA_ID, PRH_Type, PRH_ProductLine_BUM_ID, PRH_PurchaseOrderNbr, PRH_Receipt_USR_UserID, PRH_Carrier, PRH_TrackingNo, PRH_ShipType, PRH_Note, PRH_ArrivalDate, PRH_DeliveryDate, PRH_SapDeliveryDate, PRH_WHM_ID, PRH_FromWHM_ID )
                      SELECT PRH_ID, PRH_PONumber, PRH_SAPShipmentID, PRH_Dealer_DMA_ID, PRH_ReceiptDate, PRH_SAPShipmentDate, PRH_Status, PRH_Vendor_DMA_ID, PRH_Type, PRH_ProductLine_BUM_ID, PRH_PurchaseOrderNbr, PRH_Receipt_USR_UserID, PRH_Carrier, PRH_TrackingNo, PRH_ShipType, PRH_Note, PRH_ArrivalDate, PRH_DeliveryDate, PRH_SapDeliveryDate, PRH_WHM_ID, PRH_FromWHM_ID 
                        FROM POReceiptHeader_SAPNoQR(nolock) 
                       WHERE PRH_ID= @PRH_ID
                      
                      --����װ��� /��ʱ��ʹ�� 2016-12-07
                      --UPDATE #tmpPOReceiptHeader SET PRH_TrackingNo = (SELECT top 1 DNB_BoxNo FROM #cmpWMSShipment)
                      -- WHERE PRH_ID= @PRH_ID
                      
                      --������д����ʽ�ջ���(Line)   
                      INSERT INTO #tmpPOReceipt
                            (POR_ID, POR_SAPSOLine, POR_SAPSOID, POR_SAP_PMA_ID, POR_ReceiptQty, POR_UnitPrice, POR_ConvertFactor, POR_PRH_ID, POR_ChangedUnitProduct_PMA_ID, POR_LineNbr)
                      SELECT POR_ID, POR_SAPSOLine, POR_SAPSOID, POR_SAP_PMA_ID, POR_ReceiptQty, POR_UnitPrice, POR_ConvertFactor, POR_PRH_ID, POR_ChangedUnitProduct_PMA_ID, POR_LineNbr
                        FROM POReceipt_SAPNoQR(nolock) 
                       WHERE POR_PRH_ID = @PRH_ID
                      
                      --������д����ʽ�ջ���(Lot)   
                      --���¶�����ϸ���ʵ���ջ����������������״̬
                      INSERT INTO #tmpPOReceiptLot(PRL_POR_ID, PRL_ID, PRL_LotNumber, PRL_ReceiptQty, PRL_ExpiredDate, PRL_WHM_ID, PRL_UnitPrice, PRL_IsCalRebate)
                      SELECT Line.POR_ID,newid(),Lot.PRL_LotNumber + '@@' + ISNULL(#cmpWMSShipment.DNB_QRCode,'NoQR'),#cmpWMSShipment.DNB_ShipQty,
                             LOT.PRL_ExpiredDate,LOT.PRL_WHM_ID,LOT.PRL_UnitPrice,LOT.PRL_IsCalRebate
                        FROM POReceiptLot_SAPNoQR AS LOT(nolock)
                          INNER JOIN
                             POReceipt_SAPNoQR AS Line(nolock) ON (LOT.PRL_POR_ID = Line.POR_ID )
                          INNER JOIN
                             #cmpWMSShipment ON (Line.POR_SAP_PMA_ID = #cmpWMSShipment.DNB_PMA_ID and Lot.PRL_LotNumber = #cmpWMSShipment.DNB_LotNumber)
                        WHERE Line.POR_PRH_ID = @PRH_ID
                      
                      
                      --���¶���(����Ͷ�߲��ø��¶���,����޷��ҵ���Ӧ�Ķ�����Ҳ����Ҫ����)
                      IF @PRH_Type = 'PurchaseOrder'
                        BEGIN
                          --���̱�Ž���ƥ�䣨��Ϊ��CRM��ƷUPN�͵��ڶ̱�ţ�                           
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
                  					          AND POH.POH_OrderNo IN (SELECT CASE WHEN CHARINDEX('��',PRH_PurchaseOrderNbr)>0 
                                                                          THEN Substring(PRH_PurchaseOrderNbr,1,CHARINDEX('��',PRH_PurchaseOrderNbr)-1)
                                                                          ELSE PRH_PurchaseOrderNbr
                                                                          END 
                                                                FROM #cmpSAPShipment)              
                  				          GROUP BY POH.POH_ID,POH.POH_OrderNo,C.CFN_Property1 
                                  ) AS cmpOrder
                            WHERE cmpOrder.POH_OrderNo = CASE WHEN CHARINDEX('��',cmpSAP.PRH_PurchaseOrderNbr)>0 
                                                              THEN Substring(cmpSAP.PRH_PurchaseOrderNbr,1,CHARINDEX('��',cmpSAP.PRH_PurchaseOrderNbr)-1)
                                                              ELSE cmpSAP.PRH_PurchaseOrderNbr
                                                              END
                              AND cmpOrder.ShortCode = cmpSAP.ShortCode
                          
                          
                          --���û�л�ȡ��������ִ������ĸ��²���
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
                      						  --����������ϸ���Ƚ�δ�ջ������ͷ�����ϸ����
                      						  --���δ�ջ�����>������ϸ������������ջ�������δ�ջ�����
                      							IF(@TmpReceiptQty > 0 and  @CurShortCode = @TmpShortCode)
                        							BEGIN
                        								IF((@CurRequireQty -@CurReceiptQty ) <  @TmpReceiptQty)
                          								BEGIN
                          									--���������������δ�ջ���������ֱ�Ӽ���δ�ջ�����
                                            INSERT INTO #TmpOrderDetail(POD_ID,POD_ReceiptQty)
                                            SELECT @CurPodID,(@CurRequireQty-@CurReceiptQty)                                          
                                            
--                                            UPDATE PurchaseOrderDetail
--                          									SET POD_ReceiptQty = POD_RequiredQty
--                          									WHERE POD_ID = @CurPodID
                          									
                          									SELECT @TmpReceiptQty = @TmpReceiptQty - @CurRequireQty + @CurReceiptQty

                          								END
                        								ELSE
                          								BEGIN
                          									--�����������С��δ�ջ���������ֱ�Ӽ��Ϸ�������
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
                            
                            --����ȷ��WMS�ӿ�����IDд����ʱ�����ں�������״̬
                            INSERT INTO #SuccessWMSShipment(DNB_ID)
                            SELECT DNB_ID FROM #cmpWMSShipment
                            
                      END
                      ELSE
                        BEGIN
                                  print '100'
                                  
                                  --Add By SongWeiming on 2017-01-22 ����Ͷ�ߵ�״̬
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
                                      SELECT NEWID(),DC_ID,@SysUserId,GETDATE(),'Submit','�޸�״̬Ϊ�������ѻ�����ƽ̨/T1' from #ComplainID
                                  --End Add By SongWeiming on 2017-01-22 ����Ͷ�ߵ�״̬
                        
                        END
                      
                    
                    END
                  ELSE
                    BEGIN
                      IF (select count(*) from #cmpWMSShipment) > 0
                        BEGIN
                          --�������������SAP������д��������ݱ�
                          INSERT INTO #ErrorShipment(PRH_ID,PRH_SAPShipmentID,PRH_PurchaseOrderNbr,ErrorMsg)                      
                          SELECT H.PRH_ID,H.PRH_SAPShipmentID,H.PRH_PurchaseOrderNbr,ErrorMsg = 'SAP������������WMS��������һ��'
                            FROM POReceiptHeader_SAPNoQR AS H(Nolock) 
                           WHERE PRH_ID = @PRH_ID
                        END
                    END
    					  END

    				   FETCH NEXT FROM curSAPShipment	INTO @PRH_ID,@PRH_SAPShipmentID,@PRH_Type,@PRH_PurchaseOrderNbr
               
               
    				END

    				CLOSE curSAPShipment
    				DEALLOCATE curSAPShipment
            
            
            --��������д����ʽ��
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
            --��������Ϣд��ӿڱ���ƽ̨���أ�
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
            
            --���¶�����ϸ��ʵ�ʷ�������            
            UPDATE CurPod 
               SET CurPod.POD_ReceiptQty = ISNULL(CurPod.POD_ReceiptQty,0)+UpdPod.ReceiptQty
              FROM PurchaseOrderDetail CurPod,
                   (SELECT POD_ID,sum(POD_ReceiptQty) AS ReceiptQty 
                      from #TmpOrderDetail group by POD_ID
                    ) UpdPod 
             WHERE CurPod.POD_ID = UpdPod.POD_ID
          
            --���¶�����ͷ״̬
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
            --д�붩���ӿ���Ϣ
            
                        
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
						       N'����SAP���ݽӿڷ���,������������' + Convert(nvarchar(100),isnull(Qty,0)) AS POL_OperNote						    
					    FROM (SELECT POD.POD_POH_ID,sum(UpdPod.ReceiptQty) AS Qty
                      FROM (SELECT POD_ID,sum(POD_ReceiptQty) AS ReceiptQty 
                              FROM #TmpOrderDetail
                             GROUP BY POD_ID
                            ) UpdPod, PurchaseOrderDetail AS POD(nolock) 
                     WHERE UpdPod.POD_ID = POD.POD_ID
                     GROUP BY POD.POD_POH_ID  ) TAB
                     
            
            PRINT 'CCC'
            --д���µ�LotMaster��Ϣ
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
            --�������ݸ���POReceiptHeader_SAPNoQR���״̬
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
            --�����ջ�������־
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
    						  N'DMS�ϲ�У��WMSϵͳ���ݺ�,��ʱ�Զ��������յķ�������' AS POL_OperNote
    					 FROM #tmpPOReceiptHeader
               
          
      			
            
            --���󷢻������ʼ�֪ͨ(��ʱ������)
            --#ErrorShipment��������д��
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
      
      --��¼������־��ʼ
      DECLARE @error_line   INT
      DECLARE @error_number   INT
      DECLARE @error_message   NVARCHAR (256)
      DECLARE @vError   NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError = '��' + CONVERT (NVARCHAR (10), @error_line) + '����[�����' + CONVERT (NVARCHAR (10), @error_number) + '],' + @error_message
      SET @RtnMsg = @vError      
      RETURN -1
   END CATCH
GO


