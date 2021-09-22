
/****** Object:  StoredProcedure [dbo].[GC_Interface_ShipmentT2Normal]    Script Date: 2019/12/5 9:32:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GC_Interface_ShipmentT2Normal]
	@BatchNbr nvarchar(30), 
	@ClientID nvarchar(50),
	--@SubCompanyId nvarchar(50),
	--@BrandId nvarchar(50),
	@IsValid nvarchar(20) OUTPUT,
	@RtnMsg nvarchar(500) OUTPUT
WITH EXEC AS CALLER
AS
   DECLARE @SubCompanyId nvarchar(50)
   DECLARE @BrandId nvarchar(50)
   DECLARE @ErrorCount    INTEGER
   DECLARE @SysUserId     UNIQUEIDENTIFIER
   --DECLARE @Vender_DMA_ID UNIQUEIDENTIFIER
   DECLARE @Client_DMA_ID UNIQUEIDENTIFIER
   DECLARE @LPSystemHoldWarehouse UNIQUEIDENTIFIER
   DECLARE @LPDefaultWHWarehouse UNIQUEIDENTIFIER
   DECLARE @EmptyGuid     UNIQUEIDENTIFIER
   DECLARE @ErrCnt     INT
   DECLARE @ShipmentType nvarchar(30) 
   DECLARE @PONbr nvarchar(30) 
   DECLARE @DupQRCnt INT
   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN
      SET @IsValid = 'Success'
      SET @RtnMsg = ''
      SET @SysUserId = '00000000-0000-0000-0000-000000000000'
      SET @EmptyGuid = '00000000-0000-0000-0000-000000000000'

      --创建临时表
      CREATE TABLE #tmpPORImportHeader
      (
         [ID]           UNIQUEIDENTIFIER NOT NULL,
         [PONumber]     NVARCHAR (30) COLLATE Chinese_PRC_CI_AS NULL,
         [SAPCusPONbr]  NVARCHAR (50) COLLATE Chinese_PRC_CI_AS NULL,
         [SAPShipmentID] NVARCHAR (50) COLLATE Chinese_PRC_CI_AS NULL,
         [DealerDMAID]  UNIQUEIDENTIFIER NULL,
         [SAPShipmentDate] DATETIME NULL,
         [Status]       NVARCHAR (50) COLLATE Chinese_PRC_CI_AS NULL,
         [VendorDMAID]  UNIQUEIDENTIFIER NULL,
         [Type]         NVARCHAR (50) COLLATE Chinese_PRC_CI_AS NULL,
         [ProductLineBUMID] UNIQUEIDENTIFIER NULL,
         [BUName]       NVARCHAR (20) COLLATE Chinese_PRC_CI_AS NULL,
         [Carrier]      NVARCHAR (20) COLLATE Chinese_PRC_CI_AS NULL,
         [TrackingNo]   NVARCHAR (100) COLLATE Chinese_PRC_CI_AS NULL,
         [ShipType]     NVARCHAR (30) COLLATE Chinese_PRC_CI_AS NULL,
         [Note]         NVARCHAR (100) COLLATE Chinese_PRC_CI_AS NULL,
         [SapDeliveryDate] DATETIME NULL,
         [WHMID]      UNIQUEIDENTIFIER NULL,
         [PRH_FromWHM_ID] UNIQUEIDENTIFIER NULL
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
         [LotRecID]     UNIQUEIDENTIFIER NOT NULL,
         [LineRecID]    UNIQUEIDENTIFIER NULL,
         [LotNumber]    NVARCHAR (50) COLLATE Chinese_PRC_CI_AS NULL,
         [ReceiptQty]   FLOAT NULL,
         [ExpiredDate]  DATETIME NULL,
         [WarehouseRecID] UNIQUEIDENTIFIER NULL,
         [DNL_ID]       UNIQUEIDENTIFIER NULL,
         [UnitPrice]    FLOAT NULL,
         [TaxRate]      DECIMAL(6,2),
		 [Lot]    NVARCHAR (50) COLLATE Chinese_PRC_CI_AS NULL,
		 [QrCode]    NVARCHAR (50) COLLATE Chinese_PRC_CI_AS NULL,
		 [DOM]    NVARCHAR (50) COLLATE Chinese_PRC_CI_AS NULL
      )

      /*产品临时表*/
      CREATE TABLE #tmp_product
      (
         PMA_ID         UNIQUEIDENTIFIER,
         PMA_UPN        NVARCHAR (50) COLLATE Chinese_PRC_CI_AS,
         PMA_CFN_ID     UNIQUEIDENTIFIER PRIMARY KEY (PMA_ID)
      )
      
      CREATE TABLE #InterfaceShipment 
      (
        [ISH_ID] uniqueidentifier NOT NULL,
        [ISH_Dealer_SapCode] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
        [ISH_OrderNo] nvarchar(30) COLLATE Chinese_PRC_CI_AS NULL,
        [ISH_SapDeliveryNo] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
        [ISH_SapDeliveryDate] datetime NULL,
        [ISH_ShippingDate] datetime NULL,
        [ISH_ToWhmCode] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
        [ISH_ArticleNumber] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
        [ISH_SapDeliveryLineNbr] nvarchar(20) COLLATE Chinese_PRC_CI_AS NULL,
        [ISH_LotNumber] nvarchar(20) COLLATE Chinese_PRC_CI_AS NULL,
        [ISH_ExpiredDate] datetime NULL,
        [ISH_DeliveryQty] decimal(18, 6) NULL,
        [ISH_LineNbr] int NOT NULL,
        [ISH_FileName] nvarchar(200) COLLATE Chinese_PRC_CI_AS NULL,
        [ISH_ImportDate] datetime NOT NULL,
        [ISH_ClientID] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
        [ISH_BatchNbr] nvarchar(30) COLLATE Chinese_PRC_CI_AS NULL,
        [ISH_ShipmentType] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
        [ISH_UnitPrice] decimal(18, 6) NULL,        
        [ISH_QRCode] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
        [ISH_TaxRate] decimal(18, 2) NULL 
      )

	  PRINT 'Step1 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
      
      --将数据写入临时表，提高效率
      INSERT INTO #InterfaceShipment(ISH_ID, ISH_Dealer_SapCode, ISH_OrderNo, ISH_SapDeliveryNo, ISH_SapDeliveryDate, ISH_ShippingDate, ISH_ToWhmCode, ISH_ArticleNumber, ISH_SapDeliveryLineNbr, ISH_LotNumber, ISH_ExpiredDate, ISH_DeliveryQty, ISH_LineNbr, ISH_FileName, ISH_ImportDate, ISH_ClientID, ISH_BatchNbr, ISH_ShipmentType, ISH_UnitPrice, ISH_QRCode, ISH_TaxRate)
      SELECT ISH_ID, ISH_Dealer_SapCode, ISH_OrderNo, ISH_SapDeliveryNo, ISH_SapDeliveryDate, ISH_ShippingDate, ISH_ToWhmCode, ISH_ArticleNumber, ISH_SapDeliveryLineNbr, ISH_LotNumber, ISH_ExpiredDate, ISH_DeliveryQty, ISH_LineNbr, ISH_FileName, ISH_ImportDate, ISH_ClientID, ISH_BatchNbr, ISH_ShipmentType, ISH_UnitPrice, ISH_QRCode, ISH_TaxRate
       FROM dbo.InterfaceShipment(nolock) WHERE ISH_BatchNbr = @BatchNbr
      
     
      --获取对应的物流平台
      SELECT TOP 1 @Client_DMA_ID = CLT_Corp_Id
        FROM Client(nolock)
       WHERE CLT_ID = @ClientID

      IF (@Client_DMA_ID IS NULL)
         RAISERROR ('Can not get LP according to clientID', 16, 1)

      --获取对应物流平台的中间库
      SELECT TOP 1 @LPSystemHoldWarehouse = WHM_ID
      FROM Warehouse(nolock)
      WHERE     WHM_DMA_ID = @Client_DMA_ID
            AND WHM_Type = 'SystemHold'

      IF (@LPSystemHoldWarehouse IS NULL)
         RAISERROR ('Can not get system hold warehouse', 16, 1)

      --获取对应物流平台的默认仓库
--      SELECT TOP 1
--             @LPDefaultWHWarehouse = WHM_ID
--      FROM Warehouse
--      WHERE     WHM_DMA_ID = @Client_DMA_ID
--            AND WHM_Type = 'DefaultWH'
      
      
      --Edit By Songweiming on 2014-3-21 根据shipmentType 获取对应的物流平台仓库
      --ShipmentType=Normal：默认仓库；ShipmentType=Consignment：波科寄售仓库
      declare @cnt int
	     select @cnt = COUNT(*) 
         from (
            		SELECT ISH_ShipmentType
            			FROM #InterfaceShipment AS A
            	   --WHERE ISH_BatchNbr = @BatchNbr
            	   group by ISH_ShipmentType
		          ) tab
              
      IF @cnt>1
        BEGIN
          RAISERROR ('一次发货只能包含一种类型的发货单', 16, 1)
        END
      ELSE
        BEGIN
    		  SELECT TOP 1 @ShipmentType = ISH_ShipmentType
    		    FROM #InterfaceShipment AS A
    		   --WHERE ISH_BatchNbr = @BatchNbr
		    END
      
      --增加了寄售转销售类型的发货单，也是获取默认仓库      
      IF (@ShipmentType ='Normal' OR @ShipmentType ='ConsignToSellingApprove')
        BEGIN
          SELECT TOP 1 @LPDefaultWHWarehouse = WHM_ID
            FROM Warehouse(nolock)
           WHERE    WHM_DMA_ID = @Client_DMA_ID
                AND WHM_Type = 'DefaultWH' AND WHM_ActiveFlag = 1
        
        END
        
      IF (@ShipmentType = 'Consignment')
        BEGIN
          SELECT TOP 1 @LPDefaultWHWarehouse = WHM_ID
            FROM Warehouse(nolock)
           WHERE    WHM_DMA_ID = @Client_DMA_ID
                AND WHM_Type = 'Borrow' AND WHM_ActiveFlag = 1
        
        END
      
      IF (@ShipmentType = 'Lend')
        BEGIN
          SELECT TOP 1 @LPDefaultWHWarehouse = WHM_ID
          FROM Warehouse(nolock)
          WHERE     WHM_DMA_ID = @Client_DMA_ID
                AND WHM_Type = 'Borrow' AND WHM_ActiveFlag = 1
        
        END
      
      --如果是寄售转销售拒绝的发货类型，则不校验平台主仓库 Modify By SongWeiming on 2015-06-03
      IF (@LPDefaultWHWarehouse IS NULL and @ShipmentType NOT IN ('ConsignToSellingDeny'))
         RAISERROR ('Can not get default warehouse', 16, 1)
         
      --校验一张发货单是否包含重复的二维码
      SELECT @DupQRCnt = COUNT (*)
        FROM (SELECT ISH_QRCode, SUM (ISH_DeliveryQty) AS QTy
                FROM #InterfaceShipment
               WHERE --ISH_BatchNbr = @BatchNbr AND 
                     ISH_QRCode <> ''
                 AND ISH_QRCode <> 'NoQR'
               GROUP BY ISH_QRCode
              HAVING SUM (ISH_DeliveryQty) > 1
      ) tab
      
      IF (@DupQRCnt > 0)
         RAISERROR ('此发货数据存在二维码重复或二维码数量大于1的情况', 16, 1)

     PRINT 'Step2 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)

      CREATE TABLE #DeliveryNote (
          [DNL_ID] uniqueidentifier NOT NULL,
          [DNL_LineNbrInFile] int NULL,
          [DNL_ShipToDealerCode] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_SAPCode] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_PONbr] nvarchar(30) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_DeliveryNoteNbr] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_CFN] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_UPN] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_LotNumber] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_QrCode] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_ExpiredDate] datetime NULL,
          [DNL_DOM] nvarchar(20) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_DN_UnitOfMeasure] nvarchar(20) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_ReceiveUnitOfMeasure] nvarchar(20) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_ShipQty] float NULL,
          [DNL_ReceiveQty] float NULL,
          [DNL_ShipmentDate] datetime NULL,
          [DNL_ImportFileName] nvarchar(200) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_OrderType] nvarchar(20) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_UnitPrice] float NULL,
          [DNL_SubTotal] float NULL,
          [DNL_ShipmentType] nvarchar(30) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_CreatedDate] datetime NOT NULL,
          [DNL_ProblemDescription] nvarchar(200) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_ProductDescription] nvarchar(200) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_SAPSOLine] nvarchar(50) NULL,
          [DNL_SAPSalesOrderID] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_POReceiptLot_PRL_ID] uniqueidentifier NULL,
          [DNL_HandleDate] datetime NULL,
          [DNL_DealerID_DMA_ID] uniqueidentifier NULL,
          [DNL_CFN_ID] uniqueidentifier NULL,
          [DNL_BUName] nvarchar(20) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_Product_PMA_ID] uniqueidentifier NULL,
          [DNL_ProductLine_BUM_ID] uniqueidentifier NULL,
          [DNL_Authorized] bit NULL,
          [DNL_CreateUser] uniqueidentifier NULL,
          [DNL_Carrier] nvarchar(20) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_TrackingNo] nvarchar(100) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_ShipType] nvarchar(20) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_Note] nvarchar(100) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_ProductCatagory_PCT_ID] uniqueidentifier NULL,
          [DNL_SapDeliveryDate] datetime NULL,
          [DNL_LTM_ID] uniqueidentifier NULL,
          [DNL_ToWhmCode] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_ToWhmId] uniqueidentifier NULL,
          [DNL_ClientID] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_SapDeliveryLineNbr] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_BatchNbr] nvarchar(30) COLLATE Chinese_PRC_CI_AS NULL,
          [DNL_FromWhmId] uniqueidentifier NULL,
          [DNL_TaxRate] decimal(6,2) NULL
          )
      
      
      /*操作步骤：
        0、将接口中的发货数据导入到发货记录中
        1、对判断记录是否错误的字段进行更新（初始化）
        2、更新信息：经销商、订单号、产品信息（产品型号、产品ID、产品线、产品分类、BU）、产品lot信息（UPN、LotNumber）、授权不需要校验
        3、更新错误信息：经销商不存在、订单号不存在、产品型号不存在、产品线未关联、产品lot信息不存在、二级经销商仓库不存在、
           平台库存是否足够、平是否未做授权不需要校验
        4、生成收货数据：写入3张临时表
        5、更新发货数据、生成单据号并更新#tmpPORImportHeader表
        6、复制数据到POReceiptHeader、POReceipt、POReceiptLot
        7、更新订单：明细数量、状态、记录订单操作日志
        8、扣减物流平台库存：移到中间库
      */

      --系统根据接口中的“经销商在SAP中的唯一帐号”、“经销商订单编号”、”发货创建日期”,“发货日期”、“发货单号”、“发货单行号”、
      --“产品编号”、“产品序列号”、“产品有效期”、“发货数量”全部字段进行检查，若接口文件中包含了已经获取的接口数据，
      --则认为是重复数据，不予处理；若非此情况，则认为是新增的发货数据
      INSERT INTO #DeliveryNote (DNL_ID,
                                DNL_SapDeliveryLineNbr,
                                DNL_ShipToDealerCode,
                                DNL_SAPCode,
                                DNL_PONbr,
                                DNL_DeliveryNoteNbr,
                                DNL_CFN,
                                DNL_LotNumber,            
								DNL_QrCode,                    
                                DNL_ExpiredDate,
                                DNL_ReceiveQty,
                                DNL_ShipmentDate,
                                DNL_ImportFileName,
                                DNL_CreatedDate,
                                DNL_SapDeliveryDate,
                                DNL_BatchNbr,
                                DNL_ToWhmCode,
                                DNL_ClientID,                                
                                DNL_ShipmentType,
                                DNL_FromWhmId,
                                DNL_UnitPrice,
                                DNL_UPN,
                                DNL_TaxRate)
         SELECT A.ISH_ID, --主键
                A.ISH_LineNbr, --发货单批号
                A.ISH_Dealer_SapCode, --（DMS系统中的经销商编号）
                A.ISH_Dealer_SapCode, --经销商编号（DMS系统中的经销商编号）
                A.ISH_OrderNo, --订单号
                A.ISH_SapDeliveryNo, --SAP发货单号
                A.ISH_ArticleNumber, --产品UPN
                ISNULL (A.ISH_LotNumber, '') ,--产品批号
                CASE WHEN A.ISH_QRCode IS NULL OR A.ISH_QRCode='' then 'NoQR' ELSE A.ISH_QRCode END, --产品二维码 Add By Weiming ON 2016-1-4
                A.ISH_ExpiredDate, --产品有效期
                A.ISH_DeliveryQty, --发货数量
                A.ISH_SapDeliveryDate, --发货日期
                A.ISH_FileName, --文件名
                getdate (), --创建日期
                A.ISH_SapDeliveryDate, --发货单创建日期
                A.ISH_BatchNbr,
                ISH_ToWhmCode,
                @ClientID,
                A.ISH_ShipmentType,  --发货类型：Normal、Congsignment、Lend
                @LPDefaultWHWarehouse,
                A.ISH_UnitPrice,
                A.ISH_LotNumber + '@@NoQR',  --产品批号+产品二维码 Add By Weiming ON 2016-1-4
                A.ISH_TaxRate
         FROM   #InterfaceShipment AS A
         --WHERE      ISH_BatchNbr = @BatchNbr
      
	  PRINT 'Step3 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
      --将未生成收货数据的记录行中的错误信息、产品线、产品分类和授权做初始化
      UPDATE #DeliveryNote
      SET    DNL_ProblemDescription = NULL,
             DNL_ProductLine_BUM_ID = NULL,
             DNL_ProductCatagory_PCT_ID = NULL,
             DNL_Authorized = 0,
             DNL_BUName = NULL
      WHERE      DNL_POReceiptLot_PRL_ID IS NULL
             --AND DNL_BatchNbr = @BatchNbr


      --更新经销商ID
      UPDATE #DeliveryNote
      SET    DNL_DealerID_DMA_ID = DealerMaster.DMA_ID, DNL_HandleDate = getdate ()
      FROM   DealerMaster(nolock)
      WHERE      DealerMaster.DMA_SAP_Code = DNL_SAPCode
             AND DNL_DealerID_DMA_ID IS NULL
             AND DNL_POReceiptLot_PRL_ID IS NULL
             --AND DNL_BatchNbr = @BatchNbr

      --更新产品信息
	CREATE TABLE   #temp 
	(
		DealerId UNIQUEIDENTIFIER,
		ProductLineId UNIQUEIDENTIFIER,
		ProducPctId UNIQUEIDENTIFIER,
		ProductBeginDate DATETIME,
		ProductEndDate DATETIME,
		ActiveFlag int
	)

	INSERT INTO #temp (DealerId,ProductLineId,ProducPctId,ProductBeginDate,ProductEndDate,ActiveFlag)
	SELECT a.DAT_DMA_ID,a.DAT_ProductLine_BUM_ID,a.DAT_PMA_ID,a.DAT_StartDate,a.DAT_EndDate,
	CASE WHEN GETDATE() BETWEEN a.DAT_StartDate and a.DAT_EndDate THEN 1 ELSE 0 END
	FROM DealerAuthorizationTable A,#DeliveryNote D
	WHERE a.DAT_DMA_ID=d.DNL_DealerID_DMA_ID
	AND  A.DAT_ProductLine_BUM_ID<>A.DAT_PMA_ID
	UNION
	SELECT a.DAT_DMA_ID,a.DAT_ProductLine_BUM_ID,B.PCT_ID,a.DAT_StartDate,a.DAT_EndDate,
	CASE WHEN GETDATE() BETWEEN a.DAT_StartDate and a.DAT_EndDate THEN 1 ELSE 0 END
	FROM DealerAuthorizationTable A
	INNER JOIN PartsClassification B ON B.PCT_ParentClassification_PCT_ID=A.DAT_PMA_ID AND B.PCT_ProductLine_BUM_ID=A.DAT_ProductLine_BUM_ID
	INNER JOIN #DeliveryNote D ON a.DAT_DMA_ID=d.DNL_DealerID_DMA_ID
	WHERE  A.DAT_ProductLine_BUM_ID<>A.DAT_PMA_ID
	UNION
	SELECT a.DAT_DMA_ID,A.DAT_ProductLine_BUM_ID,B.CA_ID,a.DAT_StartDate,a.DAT_EndDate,
	CASE WHEN GETDATE() BETWEEN a.DAT_StartDate and a.DAT_EndDate THEN 1 ELSE 0 END
	FROM DealerAuthorizationTable A,(SELECT DISTINCT CA_ID,CC_ProductLineID FROM V_ProductClassificationStructure WHERE ActiveFlag=1) B,#DeliveryNote D
	WHERE a.DAT_DMA_ID=d.DNL_DealerID_DMA_ID
	AND  A.DAT_ProductLine_BUM_ID=A.DAT_PMA_ID
	AND B.CC_ProductLineID=A.DAT_ProductLine_BUM_ID
	
	UNION
	SELECT a.DAT_DMA_ID,A.DAT_ProductLine_BUM_ID,c.PCT_ID,a.DAT_StartDate,a.DAT_EndDate,
	CASE WHEN GETDATE() BETWEEN a.DAT_StartDate and a.DAT_EndDate THEN 1 ELSE 0 END
	FROM DealerAuthorizationTable A,
	(SELECT DISTINCT CA_ID,CC_ProductLineID FROM V_ProductClassificationStructure WHERE ActiveFlag=1) B,PartsClassification C,#DeliveryNote D
	WHERE a.DAT_DMA_ID=d.DNL_DealerID_DMA_ID
	AND  A.DAT_ProductLine_BUM_ID=A.DAT_PMA_ID
	AND B.CC_ProductLineID=A.DAT_ProductLine_BUM_ID
	AND C.PCT_ParentClassification_PCT_ID IS NOT NULL 
	AND C.PCT_ProductLine_BUM_ID=B.CC_ProductLineID 
	and c.PCT_ParentClassification_PCT_ID=b.CA_ID

      UPDATE A
      SET    A.DNL_CFN_ID = CFN.CFN_ID, --产品型号
             A.DNL_Product_PMA_ID = Product.PMA_ID,
             A.DNL_ProductLine_BUM_ID = CFN.CFN_ProductLine_BUM_ID, --产品线
             A.DNL_ProductCatagory_PCT_ID = CCF.ClassificationId, --产品分类
             A.DNL_HandleDate = GETDATE ()
      FROM   #DeliveryNote A 
			INNER JOIN CFN(nolock) ON CFN.CFN_CustomerFaceNbr = A.DNL_CFN
			INNER JOIN Product(nolock) ON Product.PMA_CFN_ID = CFN.CFN_ID
			INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=cfn.CFN_CustomerFaceNbr
			AND CCF.ClassificationId IN (select ProducPctId from #temp)
            
             --AND DNL_BatchNbr = @BatchNbr

      --更新BU
      UPDATE #DeliveryNote
      SET    DNL_BUName = attribute_name
      FROM   Lafite_ATTRIBUTE(nolock)
      WHERE      Id IN (SELECT rootID
                        FROM   Cache_OrganizationUnits(nolock)
                        WHERE  AttributeID = CONVERT (VARCHAR (36), DNL_ProductLine_BUM_ID))
             AND ATTRIBUTE_TYPE = 'BU'
             AND DNL_ProductLine_BUM_ID IS NOT NULL
             AND DNL_POReceiptLot_PRL_ID IS NULL
             --AND DNL_BatchNbr = @BatchNbr

      --更新授权信息：二级经销商收货不需要检查经销商授权
      
      UPDATE #DeliveryNote
      SET    DNL_Authorized = dbo.GC_Fn_CFN_CheckDealerAuth(DNL_DealerID_DMA_ID,DNL_CFN_ID), DNL_HandleDate = getdate ()
      --WHERE  DNL_BatchNbr = @BatchNbr
            
      --将系统中不存在的Lot+QR写入LotMaster(前提条件是PMA_ID是存在的，QR是存在的)
      --更新，不允许平台写入库存中不存在的产品组合，Edit By Song Weiming on 2018.08.09
--      INSERT INTO LotMaster (
--         LTM_InitialQty
--        ,LTM_ExpiredDate
--        ,LTM_LotNumber
--        ,LTM_ID
--        ,LTM_CreatedDate
--        ,LTM_PRL_ID
--        ,LTM_Product_PMA_ID
--        ,LTM_Type
--        ,LTM_RelationID
--      )   
--	  SELECT tab.ISH_DeliveryQty,tab.ISH_ExpiredDate,tab.Lot,newid(),getdate(),null,tab.PMA_ID,null,null       
--      FROM (
--        	  SELECT Distinct A.ISH_DeliveryQty,A.ISH_ExpiredDate,A.ISH_LotNumber + '@@' +ISNULL (A.ISH_QRCode,'NoQR') AS Lot,P.PMA_ID     
--                FROM #InterfaceShipment AS A, Product P(nolock), CFN C(nolock)
--               WHERE --ISH_BatchNbr = @BatchNbr AND 
--                     A.ISH_LotNumber IS NOT NULL
--                 AND A.ISH_LotNumber <> ''   
--                 AND A.ISH_ArticleNumber = C.CFN_CustomerFaceNbr
--                 AND C.CFN_ID = P.PMA_CFN_ID
--                 AND EXISTS 
--                            (
--                              SELECT 1 FROM QRCodeMaster QRM(nolock)
--                               WHERE QRM.QRM_QRCode = A.ISH_QRCode
--                                 --AND QRM.QRM_Status = 1 
--                                 )                 
--                 AND NOT EXISTS
--            								 (SELECT 1
--            									  FROM LotMaster AS LM(nolock)
--            								   WHERE LM.LTM_LotNumber = A.ISH_LotNumber + '@@' +ISNULL (A.ISH_QRCode,'NoQR')
--            										 AND LM.LTM_Product_PMA_ID = P.PMA_ID )
--                         
--           ) tab  
--	  
	                   
      --写入NoQR的记录
--      INSERT INTO LotMaster (
--         LTM_InitialQty
--        ,LTM_ExpiredDate
--        ,LTM_LotNumber
--        ,LTM_ID
--        ,LTM_CreatedDate
--        ,LTM_PRL_ID
--        ,LTM_Product_PMA_ID
--        ,LTM_Type
--        ,LTM_RelationID
--      )      
--      select Qty,DNL_ExpiredDate,DNL_UPN,newid(),getdate(),null,DNL_Product_PMA_ID,null,null from (
--      SELECT SUM(DN.DNL_ReceiveQty) AS QTY ,DN.DNL_ExpiredDate,DN.DNL_UPN ,DN.DNL_Product_PMA_ID     
--        FROM #DeliveryNote AS DN
--       WHERE --DN.DNL_BatchNbr = @BatchNbr AND
--             DN.DNL_UPN <> DN.DNL_LotNumber
--         AND NOT EXISTS
--    								 (SELECT 1
--    									  FROM LotMaster AS LM(nolock)
--    								   WHERE LM.LTM_LotNumber = DN.DNL_UPN)      
--       GROUP BY DN.DNL_UPN ,DN.DNL_ExpiredDate,DN.DNL_Product_PMA_ID
--      ) tab

      --根据物料主键和批次号更新批次号主键
      UPDATE #DeliveryNote
      SET    DNL_LTM_ID = LM.LTM_ID,
			DNL_ExpiredDate = LM.LTM_ExpiredDate,
			DNL_DOM= LM.LTM_Type
      FROM   LotMaster LM(nolock)
      WHERE      LM.LTM_Lot = DNL_LotNumber
			 AND LM.LTM_QRCode = DNL_QrCode
             AND LM.LTM_Product_PMA_ID = DNL_Product_PMA_ID
             AND DNL_Product_PMA_ID IS NOT NULL
             AND DNL_POReceiptLot_PRL_ID IS NULL
         
      PRINT 'Step4 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
      --更新二级经销商仓库，如果可以关联订单,则更新为订单上的仓库，如果无法关联订单的，则更新为二级经销商的默认仓库
      --如果发货单类型是寄售转销售类型，则根据DNL_ToWhmCode更新仓库ID
      IF @ShipmentType NOT IN ('ConsignToSellingApprove','ConsignToSellingDeny')
        BEGIN
          UPDATE #DeliveryNote
          SET    DNL_ToWhmId = POH_WHM_ID
          FROM   PurchaseOrderHeader AS POH(nolock)
          WHERE      POH.POH_OrderNo = DNL_PONbr
                 AND DNL_ToWhmId IS NULL
                 AND DNL_POReceiptLot_PRL_ID IS NULL
                 --AND DNL_BatchNbr = @BatchNbr

          UPDATE #DeliveryNote
          SET    DNL_ToWhmId = WH.WHM_ID
          FROM   Warehouse AS WH(nolock)
          WHERE      WH.WHM_DMA_ID = DNL_DealerID_DMA_ID
                 AND WH.WHM_Type = 'DefaultWH'
                 AND WH.WHM_ActiveFlag = 1
                 AND DNL_ToWhmId IS NULL
                 AND DNL_POReceiptLot_PRL_ID IS NULL
                 --AND DNL_BatchNbr = @BatchNbr
        END
      ELSE
        BEGIN          
          UPDATE #DeliveryNote
          SET    DNL_ToWhmId = WH.WHM_ID
          FROM   Warehouse AS WH(nolock)
          WHERE      WH.WHM_Code = DNL_ToWhmCode               
                 AND WH.WHM_ActiveFlag = 1
                 AND DNL_ToWhmId IS NULL
                 AND DNL_POReceiptLot_PRL_ID IS NULL
                 --AND DNL_BatchNbr = @BatchNbr
        END
      

	  PRINT 'Step5 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
      /* 更新错误信息：
         经销商不存在、产品型号不存在、产品线未关联、产品型号对应的批号不存在、二级经销商仓库不存在、未做授权
      */
      UPDATE #DeliveryNote
      SET    DNL_ProblemDescription = N'经销商不存在(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
      WHERE      DNL_DealerID_DMA_ID IS NULL
             AND DNL_POReceiptLot_PRL_ID IS NULL
             --AND DNL_BatchNbr = @BatchNbr

      UPDATE #DeliveryNote
      SET    DNL_ProblemDescription = N'二级经销商主仓库不存在(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
      WHERE      DNL_DealerID_DMA_ID IS NOT NULL
             AND DNL_POReceiptLot_PRL_ID IS NULL
             AND NOT EXISTS (SELECT 1 FROM Warehouse WH where WH.WHM_DMA_ID = DNL_DealerID_DMA_ID and WH.WHM_Type='DefaultWH' )             
             --AND DNL_BatchNbr = @BatchNbr
             
      UPDATE #DeliveryNote
      SET    DNL_ProblemDescription =
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'产品型号不存在(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',产品型号不存在(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)
      WHERE      DNL_CFN_ID IS NULL
             AND DNL_POReceiptLot_PRL_ID IS NULL
             --AND DNL_BatchNbr = @BatchNbr

      UPDATE #DeliveryNote
      SET    DNL_ProblemDescription =
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'产品线未关联(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',产品线未关联(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)
      WHERE      DNL_CFN_ID IS NOT NULL
             AND DNL_ProductLine_BUM_ID IS NULL
             AND DNL_POReceiptLot_PRL_ID IS NULL
             --AND DNL_BatchNbr = @BatchNbr 

      UPDATE #DeliveryNote
      SET    DNL_ProblemDescription =
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'产品型号对应的批号(二维码)不存在(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',产品型号对应的批号(二维码)不存在(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)
      WHERE      DNL_Product_PMA_ID IS NOT NULL
             AND DNL_LTM_ID IS NULL
             AND DNL_POReceiptLot_PRL_ID IS NULL
             --AND DNL_BatchNbr = @BatchNbr
      
      --校验发货单是否有重复
      UPDATE #DeliveryNote
      SET    DNL_ProblemDescription = 
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'发货单存在重复(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',发货单存在重复(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)    
      WHERE      DNL_DeliveryNoteNbr IS NOT NULL
             --AND DNL_BatchNbr = @BatchNbr      
             AND EXISTS (SELECT 1 FROM POReceiptHeader(nolock) WHERE PRH_Status IN ('Complete','Waiting') and PRH_SAPShipmentID= DNL_DeliveryNoteNbr)      

      
      UPDATE #DeliveryNote
      SET    DNL_ProblemDescription =
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'未做授权(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')' 
                    ELSE DNL_ProblemDescription + N',未做授权(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)
      WHERE      DNL_DealerID_DMA_ID IS NOT NULL
             AND DNL_CFN_ID IS NOT NULL
             AND DNL_ProductLine_BUM_ID IS NOT NULL
             AND DNL_Authorized = 0
             AND DNL_POReceiptLot_PRL_ID IS NULL
             --AND DNL_BatchNbr = @BatchNbr
      
      
      UPDATE #DeliveryNote
      SET    DNL_ProblemDescription =
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'二级经销商仓库不存在(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',二级经销商仓库不存在(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)
      WHERE      DNL_POReceiptLot_PRL_ID IS NULL
             AND DNL_ProblemDescription IS NULL
             AND DNL_ToWhmId IS NULL
             --AND DNL_BatchNbr = @BatchNbr
      

	  PRINT 'Step6 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
      --如果发货单类型是寄售转销售类型，则不是校验关联订单是否正确，而是校验关联寄售转销售申请是否正确 Edit By SongWeiming on 2015-06-03
      IF @ShipmentType NOT IN ('ConsignToSellingApprove','ConsignToSellingDeny')
         BEGIN
           
           UPDATE #DeliveryNote
           SET    DNL_ProblemDescription =
                     (CASE
                         WHEN DNL_ProblemDescription IS NULL THEN N'订单对应的经销商与收货经销商不相同(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                         ELSE DNL_ProblemDescription + N',订单对应的经销商与收货经销商不相同(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                      END)
           WHERE      DNL_POReceiptLot_PRL_ID IS NULL
                  AND DNL_ProblemDescription IS NULL            
                  --AND DNL_BatchNbr = @BatchNbr
                  AND Exists
                  (
                     SELECT 1
      		             FROM PurchaseOrderHeader AS POH(nolock)
      				        WHERE POH.POH_OrderNo = DNL_PONbr
      						      AND POH.POH_DMA_ID <> DNL_DealerID_DMA_ID
                        AND POH.POH_DMA_ID in (select DMA_ID from dealermaster(nolock) where DMA_DealerType='T2')
                   )
                   
           --发货数据不能是NoQR的产品
           UPDATE #DeliveryNote
              SET    DNL_ProblemDescription =
                        (CASE
                            WHEN DNL_ProblemDescription IS NULL THEN N'产品二维码不能是NoQR(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                            ELSE DNL_ProblemDescription + N',产品二维码不能是NoQR(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                         END)
              WHERE      DNL_POReceiptLot_PRL_ID IS NULL
                     AND DNL_ProblemDescription IS NULL
                     AND DNL_LotNumber like '%NoQR'
                 
           
           --必须有库存
           --只校验寄售库
           IF EXISTS (SELECT 1 FROM Warehouse A WHERE A.WHM_ID=@LPDefaultWHWarehouse AND A.WHM_Type='Borrow')
           BEGIN
			   --1、检查物料批次在仓库中是否存在
				UPDATE #DeliveryNote
				SET    DNL_ProblemDescription =
						  (CASE
							  WHEN DNL_ProblemDescription IS NULL THEN N'LP仓库中不存在该批次产品(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
							  ELSE DNL_ProblemDescription + N',LP仓库中不存在该批次产品(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
						   END)
				WHERE      DNL_ProblemDescription IS NULL
					   AND DNL_POReceiptLot_PRL_ID IS NULL
					   --AND DNL_BatchNbr = @BatchNbr
					   AND NOT EXISTS
							  (SELECT 1
							   FROM   Lot INNER JOIN Inventory INV ON INV.INV_ID = Lot.LOT_INV_ID
							   WHERE      Lot.LOT_LTM_ID = #DeliveryNote.DNL_LTM_ID
									  AND INV.INV_WHM_ID = @LPDefaultWHWarehouse
									  AND INV.INV_PMA_ID = #DeliveryNote.DNL_Product_PMA_ID)
	      
	      
				--2、检查物料批次在仓库中数量是否足够
				UPDATE #DeliveryNote
				SET    DNL_ProblemDescription =
						  (CASE
							  WHEN DNL_ProblemDescription IS NULL THEN N'该批次产品在LP仓库中数量不足(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
							  ELSE DNL_ProblemDescription + N',该批次产品在LP仓库中数量不足(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
						   END)
				FROM   (SELECT INV.INV_WHM_ID,
							   DN.DNL_Product_PMA_ID,
							   DN.DNL_LTM_ID,
							   SUM (DN.DNL_ReceiveQty) AS DNL_ReceiveQty,
							   MAX (Lot.LOT_OnHandQty) AS LOT_OnHandQty
						FROM   #DeliveryNote AS DN
							   INNER JOIN Lot(nolock) ON Lot.LOT_LTM_ID = DNL_LTM_ID
							   INNER JOIN Inventory INV(nolock)
								  ON     INV.INV_ID = Lot.LOT_INV_ID
									 AND INV.INV_WHM_ID = @LPDefaultWHWarehouse
									 AND INV.INV_PMA_ID = DN.DNL_Product_PMA_ID
						WHERE      DNL_ProblemDescription IS NULL
							   AND DNL_POReceiptLot_PRL_ID IS NULL
							   --AND DeliveryNote.DNL_BatchNbr = @BatchNbr
						GROUP BY INV.INV_WHM_ID, DN.DNL_Product_PMA_ID, DN.DNL_LTM_ID) AS T
				WHERE      DNL_ProblemDescription IS NULL
					   --AND DeliveryNote.DNL_BatchNbr = @BatchNbr
					   AND T.INV_WHM_ID = @LPDefaultWHWarehouse
					   AND T.DNL_Product_PMA_ID = #DeliveryNote.DNL_Product_PMA_ID
					   AND T.DNL_LTM_ID = #DeliveryNote.DNL_LTM_ID
					   AND T.LOT_OnHandQty - T.DNL_ReceiveQty < 0
	           
	           
			 END
         END
      ELSE 
        BEGIN
           --根据写入的寄售转销售单据号，获取申请单信息           
           --select * from DeliveryNote where DNL_ShipmentType='ConsignToSellingApprove'
           
           --校验单据总数量是否一致
           UPDATE #DeliveryNote
           SET    DNL_ProblemDescription =
                     (CASE
                         WHEN DNL_ProblemDescription IS NULL THEN N'单据包含产品总数量不一致(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                         ELSE DNL_ProblemDescription + N',单据包含产品总数量不一致(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                      END)
           WHERE      DNL_POReceiptLot_PRL_ID IS NULL
                  AND DNL_ProblemDescription IS NULL            
                  --AND DNL_BatchNbr = @BatchNbr
                  AND DNL_PONbr IN 
                  (
                     SELECT TAB1.DNL_PONbr 
                       FROM (
                              SELECT DNL_PONbr,Convert(decimal(18,2),SUM(DNL_ReceiveQty)) AS Qty
                                FROM #DeliveryNote 
                               --WHERE DNL_BatchNbr = @BatchNbr
                               GROUP BY DNL_PONbr 
                             ) AS TAB1 LEFT JOIN
                             (                                        
                               SELECT IAH.IAH_Inv_Adj_Nbr,Convert(decimal(18,2),SUM(IAL.IAL_LotQty )) AS Qty
                		             FROM InventoryAdjustHeader AS IAH(nolock)
                                      INNER JOIN 
                                      InventoryAdjustDetail AS IAD(nolock) on (IAH.IAH_ID = IAD.IAD_IAH_ID)
                                      INNER JOIN
                                      InventoryAdjustLot AS IAL(nolock) ON (IAD.IAD_ID = IAL.IAL_IAD_ID)                          
                				        WHERE IAH.IAH_Inv_Adj_Nbr IN (SELECT DISTINCT DNL_PONbr 
                                                                FROM #DeliveryNote 
                                                                --WHERE DNL_BatchNbr = @BatchNbr 
                                                              )
                                  AND IAH.IAH_Reason IN ('CTOS','ForceCTOS','SalesOut')
                             GROUP BY IAH.IAH_Inv_Adj_Nbr
                             ) AS TAB2 ON (TAB1.DNL_PONbr = TAB2.IAH_Inv_Adj_Nbr )
                      WHERE TAB1.Qty <> ISNULL(TAB2.Qty,0)
                   )
           
--           UPDATE DeliveryNote
--           SET    DNL_ProblemDescription =
--                     (CASE
--                         WHEN DNL_ProblemDescription IS NULL THEN N'寄售转销售申请单号不存在或上传的经销商与寄售转销售单上的经销商不相同(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
--                         ELSE DNL_ProblemDescription + N',寄售转销售申请单号不存在或上传的经销商与寄售转销售单上的经销商不相同(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
--                      END)
--           WHERE      DNL_POReceiptLot_PRL_ID IS NULL
--                  AND DNL_ProblemDescription IS NULL            
--                  AND DNL_BatchNbr = @BatchNbr
--                  AND NOT Exists
--                  (
--                     SELECT 1
--      		             FROM InventoryAdjustHeader AS IAH
--                            INNER JOIN 
--                            InventoryAdjustDetail AS IAD on (IAH.IAH_ID = IAD.IAD_IAH_ID)
--                            INNER JOIN
--                            InventoryAdjustLot AS IAL ON (IAD.IAD_ID = IAL.IAL_IAD_ID)                          
--      				        WHERE IAH.IAH_Inv_Adj_Nbr = DeliveryNote.DNL_PONbr
--                        AND IAH.IAH_Reason = 'CTOS'
--                        AND IAD.IAD_PMA_ID = DeliveryNote.DNL_Product_PMA_ID
--                        AND ISNULL(IAL.IAL_QRLotNumber,IAL.IAL_LotNumber) = DeliveryNote.DNL_LotNumber
--      						      AND IAH.IAH_DMA_ID = DeliveryNote.DNL_DealerID_DMA_ID
--                        AND IAH.IAH_DMA_ID in (select DMA_ID from dealermaster where DMA_DealerType='T2')
--                   )
           
           --校验二级经销商是否有主仓库
           UPDATE #DeliveryNote
           SET    DNL_ProblemDescription =
                     (CASE
                         WHEN DNL_ProblemDescription IS NULL THEN N'T2没有设置默认仓库！(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                         ELSE DNL_ProblemDescription + N',T2没有设置默认仓库！(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                      END)
           WHERE      DNL_POReceiptLot_PRL_ID IS NULL
                  AND DNL_ProblemDescription IS NULL            
                  --AND DNL_BatchNbr = @BatchNbr
                  AND NOT Exists
                  (
                     SELECT 1
      		             FROM Warehouse AS WH(nolock)
      				        WHERE WH.WHM_Type = N'DefaultWH'
                        and WH.WHM_DMA_ID = DNL_DealerID_DMA_ID )
           
           
           
           
           
           
           --校验二级经销商寄售库的库存是否足够
           --1、检查物料批次在仓库中是否存在
           IF @ShipmentType NOT IN ('ConsignToSellingDeny')
           BEGIN
               --ConsignToSellingApprove的流程
			   --Edit By SongWeiming on 2018-10-24 新寄售流程上线后，不需要对寄售库进行校验，因为都是从在途库进行库存扣减
			   --UPDATE #DeliveryNote
      --           SET  DNL_ProblemDescription =
      --                     (CASE
      --                         WHEN DNL_ProblemDescription IS NULL THEN N'二级经销商寄售库的库存不够(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
      --                         ELSE DNL_ProblemDescription + N',二级经销商寄售库的库存不够(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
      --                      END)
      --           WHERE      DNL_POReceiptLot_PRL_ID IS NULL
      --                  AND DNL_ProblemDescription IS NULL            
      --                  --AND DNL_BatchNbr = @BatchNbr
      --                  AND Exists
      --                  (
      --                     SELECT 1
      --      		             FROM InventoryAdjustHeader AS IAH(nolock)
      --                            INNER JOIN 
      --                            InventoryAdjustDetail AS IAD(nolock) on (IAH.IAH_ID = IAD.IAD_IAH_ID)
      --                            INNER JOIN
      --                            InventoryAdjustLot AS IAL(nolock) ON (IAD.IAD_ID = IAL.IAL_IAD_ID)  
      --                            INNER JOIN 
      --                            Inventory AS INV(nolock) ON (INV.INV_WHM_ID = IAL.IAL_WHM_ID and INV.INV_PMA_ID = IAD.IAD_PMA_ID )
      --                            INNER JOIN 
      --                            LOT AS LOT(nolock) ON (LOT.LOT_INV_ID = INV.INV_ID and isnull(ial_QRLot_ID,ial_Lot_ID) = LOT.Lot_ID)                                  
      --      				        WHERE IAH.IAH_Inv_Adj_Nbr = DNL_PONbr
      --                        AND IAH.IAH_Reason IN ('CTOS')
      --                        AND IAD.IAD_PMA_ID = DNL_Product_PMA_ID
      --                        AND ISNULL(IAL.IAL_QRLotNumber,IAL.IAL_LotNumber) = DNL_LotNumber
      --      						      AND IAH.IAH_DMA_ID = DNL_DealerID_DMA_ID
      --                        AND IAH.IAH_DMA_ID in (select DMA_ID from dealermaster(nolock) where DMA_DealerType='T2')
      --                        AND DNL_ReceiveQty > IAL.IAL_LotQty
      --                   )              
              --End Edit By SongWeiming on 2018-10-24

			  --寄售转销售的审批通过操作
              --寄售转销售申请的时候会将二维码写入LotMaster表
              
              --如果IAL_QRLotNumber不为空，则代表必须要创建新的LotMaster，且代表扣减NoQR的库存
              --如果IAL_QRLotNumber为空，则代表直接扣减IAL_LOT_ID的库存
              

        
               

              
           --校验申请的产品型号、批号与确认的产品型号批号是否一致（数量也要一致）
           --仅当不包含错误的情况下才
           IF (select Count(*) from #DeliveryNote DN where DN.DNL_POReceiptLot_PRL_ID IS NULL AND DN.DNL_ProblemDescription IS NOT NULL) = 0
              BEGIN
                
                Declare @MatchCnt int
                select @MatchCnt = count(*) from
                (
                  select DN.DNL_PONbr,DN.DNL_Product_PMA_ID,DN.DNL_LotNumber,DN.DNL_QrCode,sum(DN.DNL_ReceiveQty) AS Qty
                    from #DeliveryNote DN
                   --where DN.DNL_BatchNbr = @BatchNbr
                   group by DN.DNL_PONbr,DN.DNL_Product_PMA_ID,DN.DNL_LotNumber,DN.DNL_QrCode
                ) tab1 full outer join
                (
                  select H.IAH_Inv_Adj_Nbr,D.IAD_PMA_ID,L.IAL_Lot AS IAL_LotNumber,IAL_QRCode,sum(L.IAL_LotQty) AS Qty
                    from InventoryAdjustHeader AS H(nolock), InventoryAdjustDetail AS D(nolock), InventoryAdjustLot AS L(nolock)
                   where H.IAH_ID = D.IAD_IAH_ID AND D.IAD_ID = L.IAL_IAD_ID
                     AND H.IAH_Inv_Adj_Nbr in (select DNL_PONbr 
                                                 from #DeliveryNote --where DNL_BatchNbr = @BatchNbr
                                              )
                     AND H.IAH_Reason IN ('CTOS','ForceCTOS','SalesOut')
                   group by H.IAH_Inv_Adj_Nbr,D.IAD_PMA_ID,L.IAL_LotNumber,L.IAL_QRLotNumber,IAL_QRCode,L.IAL_Lot
                   
                ) tab2 ON (tab1.DNL_PONbr = tab2.IAH_Inv_Adj_Nbr 
						   and tab1.DNL_Product_PMA_ID=tab2.IAD_PMA_ID
                           and tab1.DNL_LotNumber = tab2.IAL_LotNumber 
						   AND TAB1.DNL_QrCode= tab2.IAL_QRCode
						   and tab1.Qty = tab2.Qty)
                where tab1.DNL_PONbr IS NULL OR tab2.IAH_Inv_Adj_Nbr IS NULL
                
                IF @MatchCnt > 0
                  UPDATE #DeliveryNote
                     SET    DNL_ProblemDescription =
                               (CASE
                                   WHEN DNL_ProblemDescription IS NULL THEN N'寄售转销售确认数据与申请数据不一致！(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                                   ELSE DNL_ProblemDescription + N',寄售转销售确认数据与申请数据不一致！(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                                END)
                     --WHERE DNL_BatchNbr = @BatchNbr
                
              END
              
                        
          END
          
         END



	  PRINT 'Step7 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
      --LP发货给二级经销商，如果发货单包含错误，则整单不生成收货单，待问题处理完了以后再重新传      
      select @ErrCnt = count(*) 
        from #DeliveryNote 
       WHERE DNL_ProblemDescription IS NOT NULL --DNL_BatchNbr = @BatchNbr AND 
             
      IF (@ErrCnt = 0)
        BEGIN
          IF @ShipmentType NOT IN ('ConsignToSellingDeny')  --Edit By SongWeiming On 2015-06-03
            BEGIN
              --库存操作
              /*库存临时表*/
              CREATE TABLE #tmp_inventory
              (
                 INV_ID         UNIQUEIDENTIFIER,
                 INV_WHM_ID     UNIQUEIDENTIFIER,
                 INV_PMA_ID     UNIQUEIDENTIFIER,
                 INV_OnHandQuantity FLOAT PRIMARY KEY (INV_ID)
              )

              /*库存明细Lot临时表*/
              CREATE TABLE #tmp_lot
              (
                 LOT_ID         UNIQUEIDENTIFIER,
                 LOT_LTM_ID     UNIQUEIDENTIFIER,
                 LOT_WHM_ID     UNIQUEIDENTIFIER,
                 LOT_PMA_ID     UNIQUEIDENTIFIER,
                 LOT_INV_ID     UNIQUEIDENTIFIER,
                 LOT_CFN_ID     UNIQUEIDENTIFIER,
                 LOT_OnHandQty  FLOAT,
                 LOT_LotNumber  NVARCHAR (50) COLLATE Chinese_PRC_CI_AS,
                 LOT_QrCode  NVARCHAR (50) COLLATE Chinese_PRC_CI_AS,
				 LOT_ExpireDate datetime,
				 LOT_DOM NVARCHAR (20) COLLATE Chinese_PRC_CI_AS,
                 PRIMARY KEY (LOT_ID)
              )

              --如果发货单类型是寄售转销售类型，则扣减T2在途库存，增加T2主仓库库存 Edit By SongWeiming on 2018-10-24
              IF @ShipmentType NOT IN ('ConsignToSellingApprove')
                --非寄售转销售的发货处理
				        BEGIN
				PRINT 'Step8 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
                  --如果DeliveryNote表中对应的二维码产品在平台库存中数量不足，则扣减"NoQR"的库存                
                  --Inventory表(从LP的默认仓库中扣减库存)
                  INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                              INV_ID,
                                              INV_WHM_ID,
                                              INV_PMA_ID)
                     SELECT -A.QTY,
                            NEWID (),
                            @LPDefaultWHWarehouse AS WHM_ID,
                            A.DNL_Product_PMA_ID
                     FROM   (SELECT DN.DNL_Product_PMA_ID, SUM (DN.DNL_ReceiveQty) AS QTY
                             FROM   #DeliveryNote AS DN
                             WHERE      DN.DNL_ProblemDescription IS NULL
                                    --AND DN.DNL_BatchNbr = @BatchNbr
                             GROUP BY DN.DNL_Product_PMA_ID) AS A



                  --Inventory表(在LP的中间仓库中增加库存)
                  INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                              INV_ID,
                                              INV_WHM_ID,
                                              INV_PMA_ID)
                     SELECT A.QTY,
                            NEWID (),
                            @LPSystemHoldWarehouse AS WHM_ID,
                            A.DNL_Product_PMA_ID
                     FROM   (SELECT DN.DNL_Product_PMA_ID, SUM (DN.DNL_ReceiveQty) AS QTY
                             FROM   #DeliveryNote AS DN
                             WHERE      DN.DNL_ProblemDescription IS NULL
                                    --AND DN.DNL_BatchNbr = @BatchNbr
                             GROUP BY DN.DNL_Product_PMA_ID) AS A
                END
              ELSE
                --寄售转销售-审批通过的发货处理（ConsignToSellingApprove）
				        BEGIN                
                  --先增加LotMaster
                  --Edit By SongWeiming on 2018-10-24 从T2的在途库扣减库存
				  --Edit By SongWeiming on 190416，LotMaster表增加了LTM_LOT、LTM_QRCode两个字段，用于提高性能
                  INSERT INTO LotMaster (LTM_InitialQty,LTM_ExpiredDate,LTM_LotNumber,LTM_ID,LTM_CreatedDate,LTM_PRL_ID,LTM_Product_PMA_ID,LTM_Type,LTM_RelationID,LTM_LOT,LTM_QRCode) 
                  SELECT 1,tab.LOT_LTM_ExpiredDate,tab.Lot,newid(),getdate(),null,tab.IAD_PMA_ID,null,null,
				         tab.Lot,
			             tab.QRCode
          				 FROM (
                				 SELECT distinct Lot.LOT_LTM_ExpiredDate,IAL.IAL_Lot AS Lot,IAL_QRCode AS QRCode,IAD.IAD_PMA_ID
            		             FROM InventoryAdjustHeader AS IAH(nolock)
                                  INNER JOIN 
                                  InventoryAdjustDetail AS IAD(nolock) on (IAH.IAH_ID = IAD.IAD_IAH_ID)
                                  INNER JOIN
                                  InventoryAdjustLot AS IAL(nolock) ON (IAD.IAD_ID = IAL.IAL_IAD_ID)  
                                  INNER JOIN 
                                  Inventory AS INV(nolock) ON (INV.INV_WHM_ID = (select WHM_ID from warehouse where WHM_DMA_ID = IAH.IAH_DMA_ID and WHM_Type='SystemHold' ) )
                                  INNER JOIN 
                                  LOT(nolock)  ON (LOT.LOT_INV_ID = INV.INV_ID and IAL_Lot = LOT_LTM_Lot and IAL_QRCode = LOT_LTM_QRCode) 
            				        WHERE IAH.IAH_Inv_Adj_Nbr IN (SELECT DISTINCT DNL_PONbr FROM #DeliveryNote)
                              AND IAH.IAH_Reason IN ('CTOS')
                              AND ISNULL(IAL.IAL_QRLotNumber,IAL.IAL_LotNumber) is not null
                              AND NOT EXISTS
                              (
                                SELECT 1 FROM LotMaster LM(nolock) 
                                 WHERE LM.LTM_Lot = IAL.IAL_Lot 
								 AND LM.LTM_Product_PMA_ID = IAD.IAD_PMA_ID
								 and LM.LTM_QRCode = IAL.IAL_QRCode                                
                              )
          					    ) tab

                  
                  --Inventory表寄售转销售处理逻辑(从T2的寄售仓库中扣减库存)
				  --Edit By SongWeiming on 2018-10-24 从T2的在途库扣减库存
                  INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                              INV_ID,
                                              INV_WHM_ID,
                                              INV_PMA_ID)
                     SELECT -A.QTY,
                            NEWID (),
                            A.INV_WHM_ID,
                            A.IAD_PMA_ID
                     FROM   (  SELECT SUM(IAL.IAL_LotQty) AS Qty,INV.INV_WHM_ID,IAD.IAD_PMA_ID
                		             FROM InventoryAdjustHeader AS IAH(nolock)
                                      INNER JOIN 
                                      InventoryAdjustDetail AS IAD(nolock) on (IAH.IAH_ID = IAD.IAD_IAH_ID)
                                      INNER JOIN
                                      InventoryAdjustLot AS IAL(nolock) ON (IAD.IAD_ID = IAL.IAL_IAD_ID)  
                                      INNER JOIN 
                                      Inventory AS INV(nolock) ON (INV.INV_WHM_ID = (select WHM_ID from warehouse where WHM_DMA_ID = IAH.IAH_DMA_ID and WHM_Type='SystemHold' ) )
                                      INNER JOIN 
									  LOT(nolock)  ON (LOT.LOT_INV_ID = INV.INV_ID and IAL_Lot = LOT_LTM_Lot and IAL_QRCode = LOT_LTM_QRCode)   
                				        WHERE IAH.IAH_Inv_Adj_Nbr IN (SELECT DISTINCT DNL_PONbr FROM #DeliveryNote)
                                  AND IAH.IAH_Reason IN ('CTOS')
                             GROUP BY INV.INV_WHM_ID,IAD.IAD_PMA_ID                   
                            ) AS A
                            
               
                  --Inventory表(在T2的默认仓库中增加库存)
				  --Edit By SongWeiming on 2018-11-22 从T2的主仓库增加库存（调整库存）				 
                  INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                              INV_ID,
                                              INV_WHM_ID,
                                              INV_PMA_ID)
                     SELECT A.QTY,
                            NEWID (),
                            A.WHM_ID,
                            A.DNL_Product_PMA_ID
                     FROM   (
                           SELECT WH.WHM_ID, DN.DNL_Product_PMA_ID, SUM (DN.DNL_ReceiveQty) AS QTY
                             FROM #DeliveryNote AS DN ,Warehouse AS WH(nolock)
                             WHERE      DN.DNL_ProblemDescription IS NULL
                                    --AND DN.DNL_BatchNbr = @BatchNbr
                                    AND DN.DNL_DealerID_DMA_ID = WH.WHM_DMA_ID
                                    AND WH.WHM_Type='DefaultWH'
									AND Exists (select 1 from InventoryAdjustHeader IAH(nolock) where IAH.IAH_Reason IN ('CTOS') and IAH.IAH_Inv_Adj_Nbr = DN.DNL_PONbr )
                             GROUP BY WH.WHM_ID,DN.DNL_Product_PMA_ID) AS A
                END
                
                
				PRINT 'Step9 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
              --更新库存表，存在的更新，不存在的新增
              UPDATE Inventory
              SET    Inventory.INV_OnHandQuantity = CONVERT (DECIMAL (18, 6), Inventory.INV_OnHandQuantity) + CONVERT (DECIMAL (18, 6), TMP.INV_OnHandQuantity)
              FROM   #tmp_inventory AS TMP
              WHERE      Inventory.INV_WHM_ID = TMP.INV_WHM_ID
                     AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID

              INSERT INTO Inventory (INV_OnHandQuantity,
                                     INV_ID,
                                     INV_WHM_ID,
                                     INV_PMA_ID)
                 SELECT INV_OnHandQuantity,
                        INV_ID,
                        INV_WHM_ID,
                        INV_PMA_ID
                 FROM   #tmp_inventory AS TMP
                 WHERE  NOT EXISTS
                           (SELECT 1
                            FROM   Inventory INV(nolock)
                            WHERE      INV.INV_WHM_ID = TMP.INV_WHM_ID
                                   AND INV.INV_PMA_ID = TMP.INV_PMA_ID)


			PRINT 'Step10 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
              --记录库存操作日志
              --Inventory表
              SELECT inv.INV_OnHandQuantity AS ITR_Quantity,
                     NEWID () AS ITR_ID,
                     @EmptyGuid AS ITR_ReferenceID,
                     case when @ShipmentType ='ConsignToSellingApprove' then 'T2寄售转销售' else 'LP分销出库' end AS ITR_Type,
                     inv.INV_WHM_ID AS ITR_WHM_ID,
                     inv.INV_PMA_ID AS ITR_PMA_ID,
                     0 AS ITR_UnitPrice,
                     (SELECT [DNL_DeliveryNoteNbr]=STUFF(( SELECT distinct ','+[DNL_DeliveryNoteNbr] 
                                               FROM #DeliveryNote DN2
                                              WHERE DN1.DNL_BatchNbr = DN2.DNL_BatchNbr
                                                FOR XML PATH('')), 1, 1, '')
                        FROM #DeliveryNote AS DN1
                       --WHERE DNL_BatchNbr = @BatchNbr
                       group by DNL_BatchNbr) AS ITR_TransDescription
              INTO   #tmp_invtrans
              FROM   #tmp_inventory AS inv

			  PRINT 'Step11 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
              INSERT INTO InventoryTransaction (ITR_Quantity,
                                                ITR_ID,
                                                ITR_ReferenceID,
                                                ITR_Type,
                                                ITR_WHM_ID,
                                                ITR_PMA_ID,
                                                ITR_UnitPrice,
                                                ITR_TransDescription,
                                                ITR_TransactionDate)
                 SELECT ITR_Quantity,
                        ITR_ID,
                        ITR_ReferenceID,
                        ITR_Type,
                        ITR_WHM_ID,
                        ITR_PMA_ID,
                        ITR_UnitPrice,
                        ITR_TransDescription,
                        GETDATE ()
                 FROM   #tmp_invtrans


              --如果发货单类型是寄售转销售类型，则扣减T2在途库库存，增加T2主仓库库存 Edit By SongWeiming on 2018-10-24（Lot表）
              IF @ShipmentType NOT IN ('ConsignToSellingApprove')
                BEGIN   
				PRINT 'Step12 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
                  --如果默认库中有对应二维码的库存，则扣减二维码的库存
                 INSERT INTO #tmp_lot (LOT_ID,
                                        LOT_LTM_ID,
                                        LOT_WHM_ID,
                                        LOT_PMA_ID,
                                        LOT_LotNumber,
                                        LOT_OnHandQty,
										LOT_QrCode,
										LOT_CFN_ID,
										LOT_ExpireDate,
										LOT_DOM)
                     SELECT NEWID (),
                            A.DNL_LTM_ID,
                            @LPDefaultWHWarehouse AS WHM_ID,
                            A.DNL_Product_PMA_ID,
                            A.DNL_LotNumber,
                            -A.QTY,
							A.DNL_QrCode,
							A.DNL_CFN_ID,
							A.DNL_ExpiredDate,
							A.DNL_DOM
                     FROM   (SELECT DN.DNL_Product_PMA_ID,
                                    DN.DNL_LTM_ID,
                                    DN.DNL_LotNumber,
									DN.DNL_QrCode,
									DN.DNL_CFN_ID,
									DN.DNL_ExpiredDate,
									DN.DNL_DOM,
                                    SUM (DN.DNL_ReceiveQty) AS QTY
                             FROM   #DeliveryNote AS DN
                             WHERE      DN.DNL_ProblemDescription IS NULL
                                    --AND DN.DNL_BatchNbr = @BatchNbr
                                    --今后不再扣减平台NoQR库存，而是将二维码的库存扣成负数 Eidt By SongWeiming on 2016-03-21
--                                    AND EXISTS (SELECT 1 FROM Inventory INV(nolock), Lot LT(nolock)
--                                                 WHERE INV.INV_ID = LT.LOT_INV_ID
--                                                   AND INV.INV_WHM_ID = @LPDefaultWHWarehouse
--                                                   AND LT.LOT_LTM_ID = DN.DNL_LTM_ID
--                                                )
                             GROUP BY DN.DNL_Product_PMA_ID, DN.DNL_LTM_ID, DN.DNL_LotNumber,DN.DNL_QrCode,DN.DNL_CFN_ID,DN.DNL_ExpiredDate,DN.DNL_DOM) AS A
                             
                  --如果默认库中没有对应库存，则扣减NoQR的库存
                  --今后不再扣减平台NoQR库存，而是将二维码的库存扣成负数 Eidt By SongWeiming on 2016-03-21
--                  INSERT INTO #tmp_lot (LOT_ID,
--                                        LOT_LTM_ID,
--                                        LOT_WHM_ID,
--                                        LOT_PMA_ID,
--                                        LOT_LotNumber,
--                                        LOT_OnHandQty)
--                     SELECT NEWID (),
--                            A.DNL_LTM_ID,
--                            @LPDefaultWHWarehouse AS WHM_ID,
--                            A.DNL_Product_PMA_ID,
--                            A.DNL_LotNumber,
--                            -A.QTY
--                     FROM   (SELECT DN.DNL_Product_PMA_ID,
--                                    (SELECT top 1 LM.LTM_ID
--                                       FROM LotMaster LM(nolock) 
--                                      WHERE LM.LTM_LotNumber = DN.DNL_UPN ) AS DNL_LTM_ID,
--                                    DN.DNL_UPN AS DNL_LotNumber,
--                                    SUM (DN.DNL_ReceiveQty) AS QTY
--                             FROM   #DeliveryNote AS DN
--                             WHERE      DN.DNL_ProblemDescription IS NULL
--                                    --AND DN.DNL_BatchNbr = @BatchNbr
--                                    AND NOT EXISTS (SELECT 1 FROM Inventory AS INV(nolock), Lot AS LT(nolock)
--                                                     WHERE INV.INV_ID = LT.LOT_INV_ID
--                                                       AND INV.INV_WHM_ID = @LPDefaultWHWarehouse
--                                                       AND LT.LOT_LTM_ID = DN.DNL_LTM_ID
--                                                )
--                             GROUP BY DN.DNL_Product_PMA_ID, DN.DNL_UPN) AS A
                  
                  
                  --Lot表(从LP的默认仓库中扣减库存)
  --                INSERT INTO #tmp_lot (LOT_ID,
  --                                      LOT_LTM_ID,
  --                                      LOT_WHM_ID,
  --                                      LOT_PMA_ID,
  --                                      LOT_LotNumber,
  --                                      LOT_OnHandQty)
  --                   SELECT NEWID (),
  --                          A.DNL_LTM_ID,
  --                          @LPDefaultWHWarehouse AS WHM_ID,
  --                          A.DNL_Product_PMA_ID,
  --                          A.DNL_LotNumber,
  --                          -A.QTY
  --                   FROM   (SELECT DN.DNL_Product_PMA_ID,
  --                                  DN.DNL_LTM_ID,
  --                                  DN.DNL_LotNumber,
  --                                  SUM (DN.DNL_ReceiveQty) AS QTY
  --                           FROM   DeliveryNote AS DN
  --                           WHERE      DN.DNL_ProblemDescription IS NULL
  --                                  AND DN.DNL_BatchNbr = @BatchNbr
  --                           GROUP BY DN.DNL_Product_PMA_ID, DN.DNL_LTM_ID, DN.DNL_LotNumber) AS A
                  
                  
                  
                  PRINT 'Step13 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
                  --Lot表(在LP的中间仓库中增加库存)
                  INSERT INTO #tmp_lot (LOT_ID,
                                        LOT_LTM_ID,
                                        LOT_WHM_ID,
                                        LOT_PMA_ID,
                                        LOT_LotNumber,
                                        LOT_OnHandQty,
										LOT_QrCode,
										LOT_CFN_ID,
										LOT_ExpireDate,
										LOT_DOM)
                      SELECT NEWID (),
                            A.DNL_LTM_ID,
                            @LPSystemHoldWarehouse AS WHM_ID,
                            A.DNL_Product_PMA_ID,
                            A.DNL_LotNumber,
                            A.QTY,
							A.DNL_QrCode,
							A.DNL_CFN_ID,
							A.DNL_ExpiredDate,
							A.DNL_DOM
                     FROM   (SELECT DN.DNL_Product_PMA_ID,
                                    DN.DNL_LTM_ID,
                                    DN.DNL_LotNumber,
									DN.DNL_QrCode,
									DN.DNL_CFN_ID,
									DN.DNL_ExpiredDate,
									DN.DNL_DOM,
                                    SUM (DN.DNL_ReceiveQty) AS QTY
                             FROM   #DeliveryNote AS DN
                             WHERE      DN.DNL_ProblemDescription IS NULL
                                    --AND DN.DNL_BatchNbr = @BatchNbr
                             GROUP BY DN.DNL_Product_PMA_ID, DN.DNL_LTM_ID, DN.DNL_LotNumber,DN.DNL_QrCode,DN.DNL_CFN_ID,DN.DNL_ExpiredDate,DN.DNL_DOM) AS A
                END
              ELSE 
                --寄售转销售-审批通过的发货处理（ConsignToSellingApprove）
                BEGIN
                  --此段代码处理寄售转销售类型的发货，扣减在途库库存（使用申请单扣减），增加T2主仓库库存
                  --Edit By SongWeiming on 2018-10-24 从T2的在途库扣减库存
                  --Lot表(从T2的在途仓库中扣减库存)
                   INSERT INTO #tmp_lot (LOT_ID,
                                        LOT_LTM_ID,
                                        LOT_WHM_ID,
                                        LOT_PMA_ID,
                                        LOT_LotNumber,
                                        LOT_OnHandQty,
										LOT_QrCode,
										LOT_CFN_ID,
										LOT_ExpireDate,
										LOT_DOM)
                     SELECT NEWID (),
                            A.LOT_LTM_ID,
                            A.INV_WHM_ID,
                            A.IAD_PMA_ID,
                            A.IAL_Lot,
                            -A.QTY,
							LOT_LTM_QRCode,
							LOT_CFN_ID,
							LOT_LTM_ExpiredDate,
							LOT_LTM_DOM
                     FROM   (  SELECT SUM(IAL.IAL_LotQty) AS Qty,INV.INV_WHM_ID ,IAD.IAD_PMA_ID,LOT.LOT_LTM_ID,IAL.IAL_Lot,LOT_LTM_QRCode,LOT_LTM_ExpiredDate,LOT_LTM_DOM,LOT_CFN_ID
                		             FROM InventoryAdjustHeader AS IAH(nolock)
                                      INNER JOIN 
                                      InventoryAdjustDetail AS IAD(nolock) on (IAH.IAH_ID = IAD.IAD_IAH_ID)
                                      INNER JOIN
                                      InventoryAdjustLot AS IAL(nolock) ON (IAD.IAD_ID = IAL.IAL_IAD_ID)  
                                      INNER JOIN 
                                      Inventory AS INV(nolock) ON (INV.INV_WHM_ID = (select WHM_ID from warehouse where WHM_DMA_ID = IAH.IAH_DMA_ID and WHM_Type='SystemHold' ) )
                                      INNER JOIN 
                                      LOT(nolock)  ON (LOT.LOT_INV_ID = INV.INV_ID and ial.IAL_Lot = LOT_LTM_Lot and IAL.IAL_QRCode = LOT_LTM_QRCode ) 
                                      --INNER JOIN 
                                      --LOTMaster AS LMA(nolock) ON (LOT.LOT_LTM_ID = LMA.LTM_ID and LMA.LTM_LotNumber = IAL.IAL_LotNumber)                                  
                				        WHERE IAH.IAH_Inv_Adj_Nbr IN (SELECT DISTINCT DNL_PONbr FROM #DeliveryNote)
                                  AND IAH.IAH_Reason IN ('CTOS')
                             GROUP BY INV.INV_WHM_ID ,IAD.IAD_PMA_ID,LOT.LOT_LTM_ID,IAL.IAL_Lot,LOT_LTM_QRCode,LOT_LTM_ExpiredDate,LOT_LTM_DOM,LOT_CFN_ID
                          ) AS A

                  --Lot表(在T2主仓库中增加库存)
				  --Edit By SongWeiming on 2018-11-22 从T2的主仓库增加库存（调整库存）
				  INSERT INTO #tmp_lot (LOT_ID,
                                        LOT_LTM_ID,
                                        LOT_WHM_ID,
                                        LOT_PMA_ID,
                                        LOT_LotNumber,
                                        LOT_OnHandQty,
										LOT_QrCode,
										LOT_CFN_ID,
										LOT_ExpireDate,
										LOT_DOM)
                     SELECT NEWID (),
                            A.DNL_LTM_ID,
                            A.WHM_ID,
                            A.DNL_Product_PMA_ID,
                            A.DNL_LotNumber,
                            A.QTY,
							A.DNL_QrCode,
							A.DNL_CFN_ID,
							A.DNL_ExpiredDate,
							A.DNL_DOM
                     FROM   (SELECT WH.WHM_ID,
                                    DN.DNL_Product_PMA_ID,
                                    DN.DNL_LTM_ID ,
                                    DN.DNL_LotNumber ,
									DN.DNL_QrCode,
									DN.DNL_ExpiredDate,
									DN.DNL_DOM,
									DN.DNL_CFN_ID,
                                    SUM (DN.DNL_ReceiveQty) AS QTY
                             FROM   #DeliveryNote AS DN,Warehouse AS WH(nolock) 
                             WHERE      DN.DNL_ProblemDescription IS NULL
                                    --AND DN.DNL_BatchNbr = @BatchNbr
                                    AND DN.DNL_DealerID_DMA_ID = WH.WHM_DMA_ID
                                    AND WH.WHM_Type='DefaultWH'
									AND Exists (select 1 from InventoryAdjustHeader IAH(nolock) where IAH.IAH_Reason IN ('CTOS') and IAH.IAH_Inv_Adj_Nbr = DN.DNL_PONbr )
                             GROUP BY WH.WHM_ID,DN.DNL_Product_PMA_ID,DN.DNL_LTM_ID ,  DN.DNL_LotNumber ,DN.DNL_QrCode,DN.DNL_ExpiredDate,DN.DNL_DOM,DN.DNL_CFN_ID) AS A
                END
              --更新关联库存主键

			  PRINT 'Step14 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
              UPDATE #tmp_lot
              SET    LOT_INV_ID = INV.INV_ID
              FROM   Inventory INV
              WHERE      INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
                     AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

              --更新批次表，存在的更新，不存在的新增
              UPDATE Lot
              SET    Lot.LOT_OnHandQty = CONVERT (DECIMAL (18, 2), Lot.LOT_OnHandQty) + CONVERT (DECIMAL (18, 2), TMP.LOT_OnHandQty)
              FROM   #tmp_lot AS TMP
              WHERE      Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
                     AND Lot.LOT_INV_ID = TMP.LOT_INV_ID
					 AND LOT.LOT_LTM_Lot = TMP.LOT_LotNumber
					 AND Lot.LOT_LTM_QRCode = TMP.LOT_QrCode

              INSERT INTO Lot (LOT_ID,
                               LOT_LTM_ID,
                               LOT_OnHandQty,
                               LOT_INV_ID,
							   LOT_WHM_ID,
							   LOT_CFN_ID,
							   LOT_LTM_ExpiredDate,
							   LOT_LTM_Lot,
							   LOT_LTM_QRCode,
							   LOT_LTM_DOM,
							   LOT_CreateDate)
                 SELECT LOT_ID,
                        LOT_LTM_ID,
                        Convert(decimal(18,2),LOT_OnHandQty),
                        LOT_INV_ID,
						LOT_WHM_ID,
						LOT_CFN_ID,
						LOT_ExpireDate,
						LOT_LotNumber,
						LOT_QrCode,
						LOT_DOM,
						GETDATE()
                 FROM   #tmp_lot AS TMP
                 WHERE NOT EXISTS
                           (SELECT 1
                            FROM   Lot(nolock)
                            WHERE      Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
                                   AND Lot.LOT_INV_ID = TMP.LOT_INV_ID
                                   AND Lot.LOT_WHM_ID = TMP.LOT_WHM_ID)


				PRINT 'Step15 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
              --记录库存操作日志
              --Lot表
              SELECT lot.LOT_OnHandQty AS ITL_Quantity,
                     newid () AS ITL_ID,
                     itr.ITR_ID AS ITL_ITR_ID,
                     lot.LOT_LTM_ID AS ITL_LTM_ID,
                     lot.LOT_LotNumber + '@@'+ lot.LOT_QrCode AS ITL_LotNumber
              INTO   #tmp_invtranslot
              FROM   #tmp_lot AS lot
                     INNER JOIN #tmp_invtrans AS itr
                        ON     itr.ITR_PMA_ID = lot.LOT_PMA_ID
                           AND itr.ITR_WHM_ID = lot.LOT_WHM_ID

              INSERT INTO InventoryTransactionLot (ITL_Quantity,
                                                   ITL_ID,
                                                   ITL_ITR_ID,
                                                   ITL_LTM_ID,
                                                   ITL_LotNumber)
                 SELECT ITL_Quantity,
                        ITL_ID,
                        ITL_ITR_ID,
                        ITL_LTM_ID,
                        ITL_LotNumber
                 FROM   #tmp_invtranslot

              --生成收货数据(生成的单据为待发货状态)
              --Header
              Declare @ReceiptToWHID uniqueidentifier
              --IF @ShipmentType NOT IN ('ConsignToSellingApprove')
              --  BEGIN
              --    SELECT top 1 @ReceiptToWHID = DNL_ToWhmId FROM DeliveryNote WHERE DNL_BatchNbr = @BatchNbr
              --  END
              --ELSE
              --  BEGIN
              --    SELECT top 1 @ReceiptToWHID = WH.WHM_ID 
              --      FROM DeliveryNote DN, Warehouse WH 
              --     WHERE WH.WHM_DMA_ID = DN.DNL_DealerID_DMA_ID 
              --       AND DN.DNL_BatchNbr = @BatchNbr
              --       AND WH.WHM_Type = 'DefaultWH'
              --  END
			  PRINT 'Step16 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
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
                                                   PRH_FromWHM_ID)
                     SELECT NEWID (),
                            DNL_PONbr,
                            DNL_DeliveryNoteNbr,
                            DNL_DealerID_DMA_ID,
                            DNL_ShipmentDate,
                            case when @ShipmentType ='ConsignToSellingApprove' then 'Complete' else 'Waiting' end ,  --如果是寄售转销售则直接是完成状态
                            --'Retail', --原来是WaitingForDelivery
                            'PurchaseOrder',
                            DNL_ProductLine_BUM_ID,
                            ISNULL (@Client_DMA_ID, '00000000-0000-0000-0000-000000000000'),
                            Carrier,
                            TrackingNo,
                            ShipType,
                            Note,
                            BUName,
                            SapDeliveryDate,
                            ToWhmId,
                            DNL_FromWhmId
                     FROM   (SELECT distinct
                                    DNL_PONbr,
                                    DNL_DeliveryNoteNbr,
                                    DNL_DealerID_DMA_ID,
                                    DNL_ShipmentDate,
                                    DNL_ProductLine_BUM_ID,
                                    max (DNL_TrackingNo) AS TrackingNo,
                                    DNL_SapDeliveryDate AS SapDeliveryDate,
                                    max (DNL_BUName) AS BUName,
                                    max (DNL_Carrier) AS Carrier,
                                    max (DNL_ShipmentType) AS ShipType,
                                    max (DNL_Note) AS Note,
                                    CASE when DNL_ShipmentType ='ConsignToSellingApprove' 
                                         then WHM_ID 
  									   else DNL_ToWhmId end AS ToWhmId,  --Edit By SongWeiming on 2015-06-03
                                    DNL_FromWhmId
                             FROM   #DeliveryNote, warehouse(nolock)
                             WHERE      DNL_POReceiptLot_PRL_ID IS NULL
                                    AND DNL_ProblemDescription IS NULL
                                    AND WHM_DMA_ID = DNL_DealerID_DMA_ID
                                    AND WHM_Type = 'DefaultWH'
                                    --AND DNL_BatchNbr = @BatchNbr
                             --and exists (select 1 from DealerMaster where DealerMaster.dma_id = DeliveryNote.DNL_DealerID_DMA_ID
                             --and DealerMaster.DMA_SystemStartDate is not null and DealerMaster.DMA_SystemStartDate <= DeliveryNote.DNL_ShipmentDate)
                             GROUP BY DNL_PONbr,
                                      DNL_DeliveryNoteNbr,
                                      DNL_DealerID_DMA_ID,
                                      DNL_ShipmentDate,
                                      DNL_ProductLine_BUM_ID,
                                      DNL_SapDeliveryDate,
                                      DNL_ToWhmId,
                                      DNL_FromWhmId,
                                      DNL_ShipmentType,
                                      WHM_ID) AS Header
               
              --Line
              INSERT INTO #tmpPORImportLine (LineRecID,
                                             PMAID,
                                             ReceiptQty,
                                             HeaderID,
                                             LineNbr,
                                             UnitPrice)
                 SELECT NEWID (),
                        Line.DNL_Product_PMA_ID,
                        Line.QTY,
                        #tmpPORImportHeader.ID,
                        row_number ()
                           OVER (PARTITION BY DNL_PONbr, DNL_DeliveryNoteNbr, DNL_DealerID_DMA_ID, DNL_ShipmentDate, DNL_ProductLine_BUM_ID
                                 ORDER BY
                                    DNL_PONbr,
                                    DNL_DeliveryNoteNbr,
                                    DNL_DealerID_DMA_ID,
                                    DNL_ShipmentDate,
                                    DNL_ProductLine_BUM_ID,
                                    DNL_SapDeliveryDate,
                                    DNL_Product_PMA_ID) AS LineNbr,
                        UnitPrice                          
                 FROM   (SELECT DNL_PONbr,
                                DNL_DeliveryNoteNbr,
                                DNL_DealerID_DMA_ID,
                                DNL_ShipmentDate,
                                DNL_ProductLine_BUM_ID,
                                DNL_SapDeliveryDate,
                                DNL_Product_PMA_ID,
                                SUM (DNL_ReceiveQty) AS QTY,
                                max(DNL_UnitPrice) AS UnitPrice
                         FROM   #DeliveryNote
                         WHERE      DNL_POReceiptLot_PRL_ID IS NULL
                                AND DNL_ProblemDescription IS NULL
                                --AND DNL_BatchNbr = @BatchNbr
                         --and exists (select 1 from DealerMaster where DealerMaster.dma_id = DeliveryNote.DNL_DealerID_DMA_ID
                         --and DealerMaster.DMA_SystemStartDate is not null and DealerMaster.DMA_SystemStartDate <= DeliveryNote.DNL_ShipmentDate)
                         GROUP BY DNL_PONbr,
                                  DNL_DeliveryNoteNbr,
                                  DNL_DealerID_DMA_ID,
                                  DNL_ShipmentDate,
                                  DNL_ProductLine_BUM_ID,
                                  DNL_SapDeliveryDate,
                                  DNL_Product_PMA_ID) AS Line
                        INNER JOIN #tmpPORImportHeader
                           ON     Line.DNL_PONbr = #tmpPORImportHeader.SAPCusPONbr
                              AND Line.DNL_DeliveryNoteNbr = #tmpPORImportHeader.SAPShipmentID
                              AND Line.DNL_DealerID_DMA_ID = #tmpPORImportHeader.DealerDMAID
                              AND Line.DNL_ShipmentDate = #tmpPORImportHeader.SAPShipmentDate
                              AND Line.DNL_ProductLine_BUM_ID = #tmpPORImportHeader.ProductLineBUMID
                              --AND Line.DNL_TrackingNo = tmpPORImportHeader.TrackingNo
                              AND Line.DNL_SapDeliveryDate = #tmpPORImportHeader.SapDeliveryDate

              --Lot
              INSERT INTO #tmpPORImportLot (LotRecID,
                                            LineRecID,
                                            LotNumber,
                                            ReceiptQty,
                                            ExpiredDate,
                                            WarehouseRecID,
                                            DNL_ID,
                                            UnitPrice,
                                            TaxRate,
											Lot,
											QrCode,
											DOM)
                 SELECT NEWID (),
                        #tmpPORImportLine.LineRecID,
                        DNL_LotNumber + '@@' + DNL_QrCode,
                        DNL_ReceiveQty,
                        DNL_ExpiredDate,
                        --Warehouse.WHM_ID,
                        DNL_ToWhmId,
                        DNL_ID,
                        DNL_UnitPrice,
                        DNL_TaxRate,
						DNL_LotNumber,
						DNL_QrCode,
						DNL_DOM
                 FROM   #DeliveryNote, #tmpPORImportHeader, #tmpPORImportLine
                 WHERE      #tmpPORImportHeader.ID = #tmpPORImportLine.HeaderID
                        AND DNL_PONbr = #tmpPORImportHeader.SAPCusPONbr
                        AND DNL_DeliveryNoteNbr = #tmpPORImportHeader.SAPShipmentID
                        AND DNL_DealerID_DMA_ID = #tmpPORImportHeader.DealerDMAID
                        AND DNL_ShipmentDate = #tmpPORImportHeader.SAPShipmentDate
                        AND DNL_ProductLine_BUM_ID = #tmpPORImportHeader.ProductLineBUMID
                        AND DNL_SapDeliveryDate = #tmpPORImportHeader.SapDeliveryDate
                        AND DNL_Product_PMA_ID = #tmpPORImportLine.PMAID
                        AND DNL_POReceiptLot_PRL_ID IS NULL
                        AND DNL_ProblemDescription IS NULL
                        --AND DNL_BatchNbr = @BatchNbr

				PRINT 'Step17 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
              --更新发货数据
              UPDATE #DeliveryNote
              SET    DNL_POReceiptLot_PRL_ID = #tmpPORImportLot.LotRecID, DNL_HandleDate = GETDATE ()
              FROM   #DeliveryNote INNER JOIN #tmpPORImportLot ON #DeliveryNote.DNL_ID = #tmpPORImportLot.DNL_ID

              --生成单据号
              DECLARE @DealerDMAID   UNIQUEIDENTIFIER
              DECLARE @BusinessUnitName NVARCHAR (20)
              DECLARE @ID            UNIQUEIDENTIFIER
              DECLARE @PONumber      NVARCHAR (50)

              DECLARE
                 curHandlePONumber CURSOR FOR
                    SELECT tph.ID,
                           DealerDMAID,
                           BUName,
						   SubCompanyId,
						   BrandId,
                           PONumber
                    FROM   #tmpPORImportHeader tph
					LEFT JOIN View_ProductLine vp ON tph.ProductLineBUMID=vp.Id
                    FOR UPDATE OF PONumber

              OPEN curHandlePONumber
              FETCH NEXT FROM curHandlePONumber
              INTO   @ID, @DealerDMAID, @BusinessUnitName, @SubCompanyId,@BrandId, @PONumber

              WHILE (@@fetch_status <> -1)
              BEGIN
                 IF (@@fetch_status <> -2)
                    BEGIN
                       EXEC [GC_GetNextAutoNumber] @DealerDMAID,
                                                   'Next_POReceiptNbr',
                                                   @BusinessUnitName,
												   @SubCompanyId,
												   @BrandId,
                                                   @PONumber OUTPUT

                       UPDATE #tmpPORImportHeader
                       SET    PONumber = @PONumber
                       WHERE  ID = @ID
                    END

                 FETCH NEXT FROM curHandlePONumber
                 INTO   @ID, @DealerDMAID, @BusinessUnitName, @SubCompanyId,@BrandId, @PONumber
              END

              CLOSE curHandlePONumber
              DEALLOCATE curHandlePONumber

			  PRINT 'Step18 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
              --复制数据
              INSERT INTO POReceiptHeader (PRH_ID,
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
                                           PRH_Receipt_USR_UserID,
                                           PRH_ReceiptDate,
                                           PRH_FromWHM_ID                                    
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
                        TrackingNo,
                        Case When ShipType = 'ConsignToSellingApprove' then 'ConsignToSelling' else ShipType end,
                        Note,
                        SapDeliveryDate,
                        WHMID,
                        @SysUserId,
                        getdate(),
                        PRH_FromWHM_ID
                 FROM   #tmpPORImportHeader

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
                        N'通过物流平台数据接口系统自动生成' AS POL_OperNote
                 FROM   #tmpPORImportHeader


              INSERT INTO POReceipt (POR_ID,
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
                 FROM   #tmpPORImportLine

              INSERT INTO POReceiptLot (PRL_ID,
                                        PRL_POR_ID,
                                        PRL_LotNumber,
                                        PRL_ReceiptQty,
                                        PRL_ExpiredDate,
                                        PRL_WHM_ID,
                                        PRL_UnitPrice,
                                        PRL_TaxRate,
										PRL_Lot,
										PRL_QrCode,
										PRL_DOM)
                 SELECT LotRecID,
                        LineRecID,
                        LotNumber,
                        ReceiptQty,
                        ExpiredDate,
                        WarehouseRecID,
                        UnitPrice,
                        TaxRate,
						Lot,
						QrCode,
						DOM
                 FROM   #tmpPORImportLot

              
              IF @ShipmentType NOT IN ('ConsignToSellingApprove') 
                BEGIN
              PRINT 'Step19 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
                  --计算关联订单的产品明细发货数量
                  CREATE TABLE #TMP_ORDER
                  (
                     PohId          UNIQUEIDENTIFIER,
                     PodId          UNIQUEIDENTIFIER,
                     ReceiptQty     DECIMAL (18, 6),
                     PRIMARY KEY (PohId, PodId)
                  )

                  INSERT INTO #TMP_ORDER (PohId, PodId, ReceiptQty)
                     SELECT POH.POH_ID, POD.POD_ID, SUM (ReceiptQty)
                     FROM   #tmpPORImportHeader AS H
                            INNER JOIN #tmpPORImportLine AS L ON H.ID = L.HeaderID
                            INNER JOIN PurchaseOrderHeader AS POH(NOLOCK) ON POH.POH_OrderNo = H.SAPCusPONbr
                            INNER JOIN PurchaseOrderDetail AS POD(NOLOCK) ON POD.POD_POH_ID = POH.POH_ID
                            INNER JOIN Product AS P(NOLOCK) ON P.PMA_ID = L.PMAID AND P.PMA_CFN_ID = POD.POD_CFN_ID
                     WHERE POH.POH_DMA_ID in (select DMA_ID from dealermaster(NOLOCK) where DMA_DealerType='T2')
                     GROUP BY POH.POH_ID, POD.POD_ID


            			--更新订单明细行数量
                        --根据#TMP_ORDER表的podid找到对应的UPN，遍历PurchaseOrderDetail表，更新收货数量。
                        --如果同UPN的PurchaseOrderDetail<#TMP_ORDER的数量，更新下一条。如果RequireQty= ReceiptQty，遍历下一个podid
                        declare @tmppohid uniqueidentifier ; --#TMP_ORDER表POHID
                        declare @tmppodid uniqueidentifier ; --#TMP_ORDER表PODID
                        declare @tmpqty DECIMAL (18, 6);	 --#TMP_ORDER表ReceiptQty
                        declare @podid uniqueidentifier		 --PurchaseOrderDetail表PODID
                        declare @cfnid uniqueidentifier
                        declare @requireqty DECIMAL (18, 6); 
                        declare @receiptqty DECIMAL (18, 6); 
                        declare @updateqty DECIMAL (18, 6);  --
                        declare @updateqty2 DECIMAL (18, 6); --
                        declare @updatecfn uniqueidentifier;
                        declare @cfnprice DECIMAL (18, 6); 
                        declare @cfn nvarchar(200); --产品型号
                        declare @bum nvarchar(100); --产品线
                        
                        set @updateqty2 = 0;
            			DECLARE @pn nvarchar(100);
            			declare @upn nvarchar(100);
            			declare @lotnumber nvarchar(50);
            			declare @prlqty decimal(18,6);
            			--查询发货单中的明细记录
            			DECLARE curReceipt CURSOR	
            			FOR select PONumber,pma_upn,LotNumber,SUM (Lot.ReceiptQty) 
            			from #tmpPORImportHeader H,#tmpPORImportLine L,#tmpPORImportLot Lot,Product(NOLOCK)--,PurchaseOrderHeader
            			where H.ID = L.HeaderID
            			and Lot.LineRecID = L.LineRecID
            			and L.PMAID = PMA_ID
            			group by PONumber,pma_upn,LotNumber
            			
            			OPEN curReceipt
            			FETCH NEXT FROM curReceipt INTO @pn,@upn,@lotnumber,@prlqty
            			WHILE @@FETCH_STATUS = 0
            			BEGIN
                        
            				DECLARE	curTMPOrder CURSOR 
            				FOR SELECT PohId,Podid 
            				FROM #TMP_ORDER

            				OPEN curTMPOrder
            				FETCH NEXT FROM curTMPOrder INTO @tmppohid,@tmppodid
            			
            				WHILE @@FETCH_STATUS = 0
            				BEGIN
            					select @updateqty = sum(POD_ReceiptQty),@updatecfn = POD_CFN_ID 
            					 from PurchaseOrderDetail(NOLOCK)
            					where POD_POH_ID=@tmppohid
            								and POD_CFN_ID = (select CFN_ID from CFN(NOLOCK) where CFN_CustomerFaceNbr= @upn)
            					  group by POD_CFN_ID
            	          
            					if(@updateqty2 < @updateqty)
            					begin
            					  set @updateqty2 = @updateqty
            					end
            				
            					DECLARE	curDetail CURSOR 
            					FOR select POD_ID,POD_CFN_ID,POD_RequiredQty,POD_ReceiptQty,POD_CFN_Price,CFN_CustomerFaceNbr,vp.[DESCRIPTION] 
            						from PurchaseOrderDetail(nolock),cfn(NOLOCK),View_ProductLine vp
            						where POD_POH_ID=@tmppohid
            						and POD_CFN_ID = CFN_ID
            						and CFN_ProductLine_BUM_ID = vp.Id
            						and POD_CFN_ID = @updatecfn
            						and POD_RequiredQty > POD_ReceiptQty
            						order by POD_CFN_Price desc

            					OPEN curDetail
            					FETCH NEXT FROM curDetail INTO @podid,@cfnid,@requireqty,@receiptqty,@cfnprice,@cfn,@bum

            					WHILE @@FETCH_STATUS = 0
            					BEGIN
            					--遍历发货明细，比较未收货数量和发货明细数量
            					--如果未收货数量>发货明细数量，则更新收货数量和未收货数量
            						IF(@prlqty > 0 and  @updatecfn = @cfnid)
            						BEGIN
            							IF((@requireqty -@receiptqty ) <  @prlqty)
            							BEGIN
            								UPDATE PurchaseOrderDetail
            								SET POD_ReceiptQty = POD_RequiredQty
            								WHERE POD_ID = @podid
            								
            								SELECT @prlqty = @prlqty - @requireqty + @receiptqty
            								--insert into tmp_PorecieptLog select  @tmppohid, @podid,@cfnid,@upn,@lotnumber,POD_RequiredQty,1
            								--from PurchaseOrderDetail WHERE POD_ID = @podid
            							END
            							ELSE
            							BEGIN
            								UPDATE PurchaseOrderDetail
            								SET POD_ReceiptQty = POD_ReceiptQty + @prlqty
            								WHERE POD_ID = @podid
            								
            								--insert into tmp_PorecieptLog select  @tmppohid, @podid,@cfnid,@upn,@lotnumber,@prlqty,2
            								SELECT @prlqty = 0
            							END
            							
            						
            						END					 
            					

            					FETCH NEXT FROM curDetail INTO @podid,@cfnid,@requireqty,@receiptqty,@cfnprice,@cfn,@bum
            					END
            					CLOSE curDetail
            					DEALLOCATE curDetail 
            			
            				
            				
            				FETCH NEXT FROM curTMPOrder INTO @tmppohid,@tmppodid
            				END

            				CLOSE curTMPOrder
            				DEALLOCATE curTMPOrder 
            			
            			FETCH NEXT FROM curReceipt INTO @pn,@upn,@lotnumber,@prlqty
            				
            			END

            			CLOSE curReceipt
            			DEALLOCATE curReceipt 

                  ----更新订单明细行数量
                  --UPDATE PurchaseOrderDetail
                  --SET    POD_ReceiptQty = POD_ReceiptQty + TMP.ReceiptQty
                  --FROM   #TMP_ORDER AS TMP
                  --WHERE      TMP.PohId = PurchaseOrderDetail.POD_POH_ID
                  --       AND TMP.PodId = PurchaseOrderDetail.POD_ID
                  --       AND EXISTS
                  --              (SELECT 1
                  --               FROM   PurchaseOrderDetail AS D
                  --               WHERE  D.POD_ID = TMP.PodId)
				  PRINT 'Step20 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
                  --更新订单表头状态
                  UPDATE PurchaseOrderHeader
                  SET    POH_OrderStatus = 'Delivering'
                  WHERE  POH_ID IN (SELECT DISTINCT PohId FROM #TMP_ORDER)
                  --AND POH_OrderStatus = 'Confirmed'

                  UPDATE PurchaseOrderHeader
                  SET    POH_OrderStatus = 'Completed'
                  WHERE      POH_ID IN (SELECT DISTINCT PohId FROM #TMP_ORDER)
                         AND POH_OrderStatus = 'Delivering'
                         AND NOT EXISTS
                                (SELECT 1
                                 FROM   PurchaseOrderDetail(nolock)
                                 WHERE      PurchaseOrderDetail.POD_POH_ID = PurchaseOrderHeader.POH_ID
                                        AND POD_RequiredQty > POD_ReceiptQty)
                END
              ELSE
                BEGIN
                  --更新寄售转销售申请单状态
                  --SELECT TOP 1 @PONbr = A.DNL_PONbr
                  --  FROM #DeliveryNote AS A
                  --  --WHERE A.DNL_BatchNbr = @BatchNbr
                    
                   UPDATE InventoryAdjustHeader 
                      SET IAH_Status = 'Accept'
              			WHERE IAH_Inv_Adj_Nbr IN (SELECT A.DNL_PONbr
                                                    FROM #DeliveryNote AS A
                                                where A.DNL_ShipmentType='ConsignToSellingApprove')
                      AND IAH_Reason IN ('CTOS','ForceCTOS','SalesOut')
                      
                      
                    --记录日志表
                   INSERT INTO PurchaseOrderLog (POL_ID,
                                              POL_POH_ID,
                                              POL_OperUser,
                                              POL_OperDate,
                                              POL_OperType,
                                              POL_OperNote)
                   SELECT newid () AS POL_ID,
                          IAH_ID AS POL_POH_ID,
                          @SysUserId AS POL_OperUser,
                          getdate () AS POL_OperDate,
                          N'Approve' AS POL_OperType,
                          N'寄售转销售审批通过' AS POL_OperNote
                   FROM  InventoryAdjustHeader(NOLOCK)
                   WHERE IAH_Inv_Adj_Nbr IN (SELECT A.DNL_PONbr
                                                    FROM #DeliveryNote AS A
                                                where A.DNL_ShipmentType='ConsignToSellingApprove')
                     AND IAH_Reason IN ('CTOS','ForceCTOS','SalesOut')
                    
                 
                END
                
              IF @ShipmentType IN ( 'Consignment','Lend')
              BEGIN	
        				--针对平台寄售发货，需要生成平台发货寄售买断单据
        				DECLARE @PONum nvarchar(30) 
        				SELECT  @PONum=PONumber FROM #tmpPORImportHeader
        				EXEC [Consignment].[Proc_ConsignmentInv_BuyOff] 'POReceipt_Consignment',@PONum,@IsValid,@RtnMsg
              END
            END
          ELSE
            BEGIN
              --更新对应的寄售转销售申请单，将申请单置为审批拒绝
              --SELECT TOP 1 @PONbr = A.DNL_PONbr
              -- FROM #DeliveryNote AS A
              --  --WHERE A.DNL_BatchNbr = @BatchNbr
                
               UPDATE InventoryAdjustHeader 
                  SET IAH_Status = 'Reject'
          			WHERE IAH_Inv_Adj_Nbr IN (SELECT A.DNL_PONbr
                                                    FROM #DeliveryNote AS A
                                                where A.DNL_ShipmentType='ConsignToSellingDeny')
                  AND IAH_Reason IN ('CTOS')
                  
               INSERT INTO PurchaseOrderLog (POL_ID,
                                              POL_POH_ID,
                                              POL_OperUser,
                                              POL_OperDate,
                                              POL_OperType,
                                              POL_OperNote)
                   SELECT newid () AS POL_ID,
                          IAH_ID AS POL_POH_ID,
                          @SysUserId AS POL_OperUser,
                          getdate () AS POL_OperDate,
                          N'Reject' AS POL_OperType,
                          N'寄售转销售审批拒绝' AS POL_OperNote
                   FROM  InventoryAdjustHeader(nolock)
                   WHERE IAH_Inv_Adj_Nbr IN (SELECT A.DNL_PONbr
                                                    FROM #DeliveryNote AS A
                                                where A.DNL_ShipmentType='ConsignToSellingDeny')
                     AND IAH_Reason IN ('CTOS')
  			       
               DECLARE @invNo NVARCHAR(50)
               DECLARE @RtnValCTOS NVARCHAR(20)
        		   DECLARE @RtnMsgCTOS NVARCHAR(1000)
               
                DECLARE curDetailNo CURSOR 
      					FOR SELECT IAH_Inv_Adj_Nbr
                      FROM InventoryAdjustHeader(nolock)
                     WHERE IAH_Inv_Adj_Nbr IN ( SELECT A.DNL_PONbr FROM #DeliveryNote AS A WHERE A.DNL_ShipmentType='ConsignToSellingDeny')
                       AND IAH_Reason IN ('CTOS')

      					OPEN curDetailNo
      					FETCH NEXT FROM curDetailNo INTO @invNo

      					WHILE @@FETCH_STATUS = 0
      					BEGIN
      					  --库存操作（库存返回）
                  exec Consignment.Proc_InventoryAdjust 'CTS',@invNo,'Cancel',@RtnValCTOS,@RtnMsgCTOS
              	  IF (@RtnValCTOS<>'Success')
            			  BEGIN
            			    RAISERROR ( N'更新库存出错.',10,1,N'RownNum',0); 
            			  END  			 
      					

      					FETCH NEXT FROM curDetailNo INTO @invNo
      					END
      					CLOSE curDetailNo
      					DEALLOCATE curDetailNo
			 					  
            END
            
            
            
        SET @IsValid = 'Success'
        END
        PRINT 'Step21 ' + CONVERT(NVARCHAR(19), GETDATE(), 121)
      --将信息写入正式表  
      INSERT INTO DeliveryNote SELECT  [DNL_ID] ,
          [DNL_LineNbrInFile] ,
          [DNL_ShipToDealerCode],
          [DNL_SAPCode] ,
          [DNL_PONbr] ,
          [DNL_DeliveryNoteNbr] ,
          [DNL_CFN] ,
          [DNL_UPN],
          [DNL_LotNumber] ,
          [DNL_ExpiredDate] ,
          [DNL_DN_UnitOfMeasure] ,
          [DNL_ReceiveUnitOfMeasure] ,
          [DNL_ShipQty] ,
          [DNL_ReceiveQty] ,
          [DNL_ShipmentDate] ,
          [DNL_ImportFileName] ,
          [DNL_OrderType] ,
          [DNL_UnitPrice] ,
          [DNL_SubTotal] ,
          [DNL_ShipmentType] ,
          [DNL_CreatedDate] ,
          [DNL_ProblemDescription] ,
          [DNL_ProductDescription] ,
          [DNL_SAPSOLine] ,
          [DNL_SAPSalesOrderID] ,
          [DNL_POReceiptLot_PRL_ID] ,
          [DNL_HandleDate] ,
          [DNL_DealerID_DMA_ID] ,
          [DNL_CFN_ID] ,
          [DNL_BUName] ,
          [DNL_Product_PMA_ID] ,
          [DNL_ProductLine_BUM_ID],
          [DNL_Authorized] ,
          [DNL_CreateUser] ,
          [DNL_Carrier] ,
          [DNL_TrackingNo],
          [DNL_ShipType],
          [DNL_Note] ,
          [DNL_ProductCatagory_PCT_ID] ,
          [DNL_SapDeliveryDate] ,
          [DNL_LTM_ID] ,
          [DNL_ToWhmCode],
          [DNL_ToWhmId] ,
          [DNL_ClientID] ,
          [DNL_SapDeliveryLineNbr] ,
          [DNL_BatchNbr] ,
          [DNL_FromWhmId] ,
          [DNL_TaxRate] 
		  FROM #DeliveryNote
      
      COMMIT TRAN
      
      --记录成功日志
      --EXEC dbo.GC_Interface_Log 'Shipment', 'Success', ''

      SET  NOCOUNT OFF
      RETURN 1
   END TRY
   BEGIN CATCH
      SET  NOCOUNT OFF
      ROLLBACK TRAN
      SET @IsValid = 'Failure'

      --记录错误日志开始
      DECLARE @error_line    INT
      DECLARE @error_number  INT
      DECLARE @error_message NVARCHAR (256)
      DECLARE @vError        NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError = '行' + CONVERT (NVARCHAR (10), @error_line) + '出错[错误号' + CONVERT (NVARCHAR (10), @error_number) + '],' + @error_message
      SET @RtnMsg = @vError
      --EXEC dbo.GC_Interface_Log 'Shipment', 'Failure', @vError

      RETURN -1
   END CATCH
