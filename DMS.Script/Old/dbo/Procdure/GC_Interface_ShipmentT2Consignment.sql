DROP PROCEDURE [dbo].[GC_Interface_ShipmentT2Consignment]
GO

CREATE PROCEDURE [dbo].[GC_Interface_ShipmentT2Consignment]
   @BatchNbr NVARCHAR (30),
   @ClientID NVARCHAR (50),
   @IsValid NVARCHAR (20) OUTPUT,
   @RtnMsg NVARCHAR (500) OUTPUT
AS
   DECLARE @ErrorCount    INTEGER
   DECLARE @SysUserId     UNIQUEIDENTIFIER
   --DECLARE @Vender_DMA_ID UNIQUEIDENTIFIER
   DECLARE @Client_DMA_ID UNIQUEIDENTIFIER
   DECLARE @LPSystemHoldWarehouse UNIQUEIDENTIFIER
   DECLARE @LPDefaultWHWarehouse UNIQUEIDENTIFIER
   DECLARE @EmptyGuid     UNIQUEIDENTIFIER
   DECLARE @ErrCnt     INT
   DECLARE @ShipmentType nvarchar(20)
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
         [ShipType]     NVARCHAR (20) COLLATE Chinese_PRC_CI_AS NULL,
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
         [LTM_ID]       UNIQUEIDENTIFIER NULL,
         [UnitPrice]    FLOAT NULL
      )

      /*产品临时表*/
      CREATE TABLE #tmp_product
      (
         PMA_ID         UNIQUEIDENTIFIER,
         PMA_UPN        NVARCHAR (50) COLLATE Chinese_PRC_CI_AS,
         PMA_CFN_ID     UNIQUEIDENTIFIER PRIMARY KEY (PMA_ID)
      )

      --得到波科（作为经销商）的ID
      --      SELECT TOP 1
      --             @Vender_DMA_ID = DMA_ID
      --      FROM DealerMaster
      --      WHERE (DMA_HostCompanyFlag = 1)

      --获取对应的物流平台
      SELECT TOP 1
             @Client_DMA_ID = CLT_Corp_Id
      FROM Client(nolock)
      WHERE CLT_ID = @ClientID

      IF (@Client_DMA_ID IS NULL)
         RAISERROR ('Can not get LP according to clientID', 16, 1)

      --获取对应物流平台的中间库
      SELECT TOP 1
             @LPSystemHoldWarehouse = WHM_ID
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
      SELECT TOP 1
             @ShipmentType = ISH_ShipmentType
      FROM InterfaceShipment AS A(nolock)
      WHERE ISH_BatchNbr = @BatchNbr
      
      IF (@ShipmentType = 'Normal')
        BEGIN
          SELECT TOP 1
             @LPDefaultWHWarehouse = WHM_ID
          FROM Warehouse(nolock)
          WHERE     WHM_DMA_ID = @Client_DMA_ID
                AND WHM_Type = 'DefaultWH' AND WHM_ActiveFlag = 1
        
        END
      IF (@ShipmentType = 'Consignment')
        BEGIN
          SELECT TOP 1
             @LPDefaultWHWarehouse = WHM_ID
          FROM Warehouse(nolock)
          WHERE     WHM_DMA_ID = @Client_DMA_ID
                AND WHM_Type = 'Borrow' AND WHM_ActiveFlag = 1
        
        END
      
      IF (@ShipmentType = 'Lend')
        BEGIN
          SELECT TOP 1
             @LPDefaultWHWarehouse = WHM_ID
          FROM Warehouse(nolock)
          WHERE     WHM_DMA_ID = @Client_DMA_ID
                AND WHM_Type = 'Borrow' AND WHM_ActiveFlag = 1
        
        END
        
      IF (@LPDefaultWHWarehouse IS NULL)
         RAISERROR ('Can not get default warehouse', 16, 1)

      --校验一张发货单是否包含重复的二维码
      select @DupQRCnt = COUNT(*) from (
		  select ISH_QRCode,SUM(ISH_DeliveryQty) AS QTy
		   from InterfaceShipment(nolock) where ISH_BatchNbr = @BatchNbr
		  and ISH_QRCode <>'' and ISH_QRCode<>'NoQR' 
		  group by ISH_QRCode having SUM(ISH_DeliveryQty)>1
      ) tab
      
      IF (@DupQRCnt > 0)
         RAISERROR ('此发货数据存在二维码重复或二维码数量大于1的情况', 16, 1)

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
      INSERT INTO DeliveryNote (DNL_ID,
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
                                DNL_ShipmentType,
                                DNL_FromWhmId,
                                DNL_UnitPrice,
                                DNL_UPN
                                )
         SELECT A.ISH_ID, --主键
                A.ISH_LineNbr, --发货单批号
                A.ISH_Dealer_SapCode, --（DMS系统中的经销商编号）
                A.ISH_Dealer_SapCode, --经销商编号（DMS系统中的经销商编号）
                A.ISH_OrderNo, --订单号
                A.ISH_SapDeliveryNo, --SAP发货单号
                A.ISH_ArticleNumber, --产品UPN
                ISNULL (A.ISH_LotNumber, '') + '@@' +ISNULL (A.ISH_QRCode,'NoQR'), --产品批号+产品二维码 Add By Weiming ON 2016-1-4
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
                A.ISH_LotNumber + '@@NoQR' --产品批号+产品二维码 Add By Weiming ON 2016-1-4
         FROM   InterfaceShipment AS A(nolock)
         WHERE      ISH_BatchNbr = @BatchNbr
--                AND NOT EXISTS
--                       (SELECT 1
--                        FROM   DeliveryNote AS B
--                        WHERE      B.DNL_SAPCode = A.ISH_Dealer_SapCode
--                               AND ISNULL (B.DNL_PONbr, '') = ISNULL (A.ISH_OrderNo, '')
--                               AND ISNULL (B.DNL_SapDeliveryDate, CONVERT (DATETIME, '2999-01-01')) = ISNULL (A.ISH_SapDeliveryDate, CONVERT (DATETIME, '2999-01-01'))
--                               --AND ISNULL (B.DNL_ShipmentDate, CONVERT (DATETIME, '2999-01-01')) = ISNULL (A.ISH_ShippingDate, CONVERT (DATETIME, '2999-01-01'))
--                               AND ISNULL (B.DNL_DeliveryNoteNbr, '') = ISNULL (A.ISH_SapDeliveryNo, '')
--                               AND ISNULL (B.DNL_SapDeliveryLineNbr, '') = ISNULL (A.ISH_SapDeliveryLineNbr, '')
--                               AND ISNULL (B.DNL_CFN, '') = ISNULL (A.ISH_ArticleNumber, '')
--                               AND ISNULL (B.DNL_LotNumber, '') = ISNULL (A.ISH_LotNumber, '')
--                               AND ISNULL (B.DNL_ExpiredDate, CONVERT (DATETIME, '2999-01-01')) = ISNULL (A.ISH_ExpiredDate, CONVERT (DATETIME, '2999-01-01'))
--                               AND ISNULL (B.DNL_ReceiveQty, 0) = ISNULL (A.ISH_DeliveryQty, 0))



      --将未生成收货数据的记录行中的错误信息、产品线、产品分类和授权做初始化
      UPDATE DeliveryNote
      SET    DNL_ProblemDescription = NULL,
             DNL_ProductLine_BUM_ID = NULL,
             DNL_ProductCatagory_PCT_ID = NULL,
             DNL_Authorized = 0,
             DNL_BUName = NULL
      WHERE      DNL_POReceiptLot_PRL_ID IS NULL
             AND DNL_BatchNbr = @BatchNbr


      --更新经销商ID
      UPDATE DeliveryNote
      SET    DNL_DealerID_DMA_ID = DealerMaster.DMA_ID, DNL_HandleDate = getdate ()
      FROM   DealerMaster(nolock)
      WHERE      DealerMaster.DMA_SAP_Code = DeliveryNote.DNL_SAPCode
             AND DeliveryNote.DNL_DealerID_DMA_ID IS NULL
             AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
             AND DNL_BatchNbr = @BatchNbr
           
      --更新产品信息
      UPDATE A
      SET    A.DNL_CFN_ID = CFN.CFN_ID, --产品型号
             A.DNL_Product_PMA_ID = Product.PMA_ID,
             A.DNL_ProductLine_BUM_ID = CFN.CFN_ProductLine_BUM_ID, --产品线
             A.DNL_ProductCatagory_PCT_ID = CCF.ClassificationId, --产品分类
             A.DNL_HandleDate = GETDATE ()
      FROM   DeliveryNote A
			 INNER JOIN CFN(nolock)  ON CFN.CFN_CustomerFaceNbr = A.DNL_CFN
			 INNER JOIN Product(nolock) ON Product.PMA_CFN_ID = CFN.CFN_ID
			 INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
			 AND ccf.ClassificationId in (select ProducPctId from GC_FN_GetDealerAuthProductSub(A.DNL_DealerID_DMA_ID))
      WHERE A.DNL_BatchNbr = @BatchNbr

      --更新BU
      UPDATE DeliveryNote
      SET    DNL_BUName = attribute_name
      FROM   Lafite_ATTRIBUTE(nolock)
      WHERE      Id IN (SELECT rootID
                        FROM   Cache_OrganizationUnits(nolock)
                        WHERE  attributeID = CONVERT (VARCHAR (36), DeliveryNote.DNL_ProductLine_BUM_ID))
             AND ATTRIBUTE_TYPE = 'BU'
             AND DeliveryNote.DNL_ProductLine_BUM_ID IS NOT NULL
             AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
             AND DeliveryNote.DNL_BatchNbr = @BatchNbr

      --更新授权信息：二级经销商收货需要检查经销商授权
      --暂时先不使用
      
      UPDATE DeliveryNote
      SET    DNL_Authorized = dbo.GC_Fn_CFN_CheckDealerAuth(DeliveryNote.DNL_DealerID_DMA_ID,DeliveryNote.DNL_CFN_ID), DNL_HandleDate = getdate ()
      WHERE  DeliveryNote.DNL_BatchNbr = @BatchNbr
      
      
      --将系统中不存在的Lot+QR写入LotMaster(前提条件是PMA_ID是存在的，QR是存在的)  Add By SongWeiming on 2016-1-4
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
      SELECT A.ISH_DeliveryQty,A.ISH_ExpiredDate,A.ISH_LotNumber + '@@' +ISNULL (A.ISH_QRCode,'NoQR'),newid(),getdate(),null,P.PMA_ID,null,null     
        FROM InterfaceShipment AS A(nolock), Product P(nolock), CFN C(nolock)
       WHERE ISH_BatchNbr = @BatchNbr 
         AND A.ISH_LotNumber IS NOT NULL
         AND A.ISH_LotNumber <> ''   
         AND A.ISH_ArticleNumber = C.CFN_CustomerFaceNbr
         AND C.CFN_ID = P.PMA_CFN_ID
         AND EXISTS 
                    (
                      SELECT 1 FROM QRCodeMaster QRM(nolock)
                       WHERE QRM.QRM_QRCode = A.ISH_QRCode
                         --AND QRM.QRM_Status = 1 
                         )                 
         AND NOT EXISTS
    								 (SELECT 1
    									  FROM LotMaster AS LM(nolock)
    								   WHERE LM.LTM_LotNumber = A.ISH_LotNumber + '@@' +ISNULL (A.ISH_QRCode,'NoQR')
    										 AND LM.LTM_Product_PMA_ID = P.PMA_ID )
                         
                         
      --写入NoQR的记录 Add By SongWeiming on 2016-1-4
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
      SELECT QTY,DNL_ExpiredDate,DNL_UPN,newid(),getdate(),null,DNL_Product_PMA_ID ,null,null FROM (
      SELECT SUM(DN.DNL_ReceiveQty) AS QTY ,min(DN.DNL_ExpiredDate) AS DNL_ExpiredDate,DN.DNL_UPN ,DN.DNL_Product_PMA_ID     
        FROM DeliveryNote AS DN(nolock)
       WHERE DN.DNL_BatchNbr = @BatchNbr 
         AND DN.DNL_UPN <> DN.DNL_LotNumber
         AND NOT EXISTS
    								 (SELECT 1
    									  FROM LotMaster AS LM(nolock)
    								   WHERE LM.LTM_LotNumber = DN.DNL_UPN)      
         group by DN.DNL_UPN ,DN.DNL_Product_PMA_ID
      ) RS   
         
      
      
      
      --根据物料主键和批次号更新批次号主键
      UPDATE DeliveryNote
      SET    DeliveryNote.DNL_LTM_ID = LM.LTM_ID
      FROM   LotMaster LM(nolock)
      WHERE      LM.LTM_LotNumber = DeliveryNote.DNL_LotNumber
             AND LM.LTM_Product_PMA_ID = DeliveryNote.DNL_Product_PMA_ID
             AND DeliveryNote.DNL_Product_PMA_ID IS NOT NULL
             AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
             AND DeliveryNote.DNL_BatchNbr = @BatchNbr
      
      


      --更新二级经销商仓库，使用接口中定义的仓库，
      --如果接口中不包含仓库，则使用订单对应的仓库，(取消此逻辑 weiming 2015.03.25)
      --如果无法通过订单获取仓库，则使用二级经销商的默认寄售仓库 (取消此逻辑 weiming 2015.03.25)
      UPDATE DeliveryNote
      SET    DNL_ToWhmId = WH.WHM_ID
      FROM   Warehouse  AS WH(nolock)
      WHERE     WH.WHM_Code = DeliveryNote.DNL_ToWhmCode
             AND DeliveryNote.DNL_ToWhmId IS NULL
             AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
             AND DeliveryNote.DNL_DealerID_DMA_ID = WH.WHM_DMA_ID
             AND DNL_BatchNbr = @BatchNbr
         
     --UPDATE DeliveryNote
     -- SET    DNL_ToWhmId = POH_WHM_ID
     -- FROM   PurchaseOrderHeader AS POH
     -- WHERE      POH.POH_OrderNo = DeliveryNote.DNL_PONbr
     --        AND DeliveryNote.DNL_ToWhmId IS NULL
     --        AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
     --        AND DNL_BatchNbr = @BatchNbr
             
     -- UPDATE DeliveryNote
     -- SET    DNL_ToWhmId = WH.WHM_ID
     -- FROM   (SELECT WHM_DMA_ID,Convert(uniqueidentifier, max (Convert(nvarchar(100),WHM_ID))) AS WHM_ID
     --         FROM   Warehouse
     --         WHERE      WHM_ActiveFlag = 1
     --                AND WHM_Type IN ('LP_Consignment','Consignment')
     --         GROUP BY WHM_DMA_ID) AS WH
     -- WHERE      WH.WHM_DMA_ID = DeliveryNote.DNL_DealerID_DMA_ID
     --        AND DeliveryNote.DNL_ToWhmId IS NULL
     --        AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
     --        AND DNL_BatchNbr = @BatchNbr

      
      
      /* 更新错误信息：
         经销商不存在、产品型号不存在、产品线未关联、产品型号对应的批号不存在、二级经销商仓库不存在、未做授权
      */
      UPDATE DeliveryNote
      SET    DNL_ProblemDescription = N'经销商不存在(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
      WHERE      DNL_DealerID_DMA_ID IS NULL
             AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
             AND DeliveryNote.DNL_BatchNbr = @BatchNbr
      
      --校验经销商是不是属于当前平台的      
      UPDATE DeliveryNote
      SET    DNL_ProblemDescription =
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'二级经销商不属于此物流平台(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',二级经销商不属于此物流平台(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)                
      WHERE      DNL_DealerID_DMA_ID IS NOT NULL
             AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
             AND DeliveryNote.DNL_BatchNbr = @BatchNbr 
             AND NOT Exists (select 1 from client AS CT(nolock), DealerMaster AS DM(nolock) where CT.CLT_ID = DeliveryNote.DNL_ClientID AND CT.CLT_Corp_Id = DM.DMA_Parent_DMA_ID and DM.DMA_ID = DeliveryNote.DNL_DealerID_DMA_ID)
      
      --校验仓库是否属于此二级经销商
      UPDATE DeliveryNote
      SET    DNL_ProblemDescription =
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'仓库不属于此二级经销商(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',仓库不属于此二级经销商(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)                
      WHERE      DeliveryNote.DNL_ToWhmId IS NOT NULL
             AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
             AND DeliveryNote.DNL_BatchNbr = @BatchNbr 
             AND NOT Exists (select 1 from Warehouse AS WH(nolock) WHERE WH.WHM_ID = DeliveryNote.DNL_ToWhmId AND WH.WHM_DMA_ID = DeliveryNote.DNL_DealerID_DMA_ID)
      
      --
      
      UPDATE DeliveryNote
      SET    DNL_ProblemDescription =
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'产品型号不存在(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',产品型号不存在(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)
      WHERE      DNL_CFN_ID IS NULL
             AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
             AND DeliveryNote.DNL_BatchNbr = @BatchNbr

      UPDATE DeliveryNote
      SET    DNL_ProblemDescription =
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'产品线未关联(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',产品线未关联(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)
      WHERE      DNL_CFN_ID IS NOT NULL
             AND DNL_ProductLine_BUM_ID IS NULL
             AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
             AND DeliveryNote.DNL_BatchNbr = @BatchNbr 

      UPDATE DeliveryNote
      SET    DNL_ProblemDescription =
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'产品型号对应的批号不存在(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',产品型号对应的批号不存在(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)
      WHERE      DNL_Product_PMA_ID IS NOT NULL
             AND DNL_LTM_ID IS NULL
             AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
             AND DeliveryNote.DNL_BatchNbr = @BatchNbr
      
      --校验发货单是否有重复
      UPDATE DeliveryNote
      SET    DNL_ProblemDescription = 
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'发货单存在重复(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',发货单存在重复(发货单号：'+ ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)    
      WHERE      DeliveryNote.DNL_DeliveryNoteNbr IS NOT NULL
             AND DeliveryNote.DNL_BatchNbr = @BatchNbr      
             AND EXISTS (SELECT 1 FROM POReceiptHeader(nolock) WHERE PRH_Status IN ('Complete','Waiting') and PRH_SAPShipmentID= DNL_DeliveryNoteNbr)     
      
      --暂时先不校验
      
      UPDATE DeliveryNote
      SET    DNL_ProblemDescription =
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'未做授权(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',未做授权(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)
      WHERE      DNL_DealerID_DMA_ID IS NOT NULL
             AND DNL_CFN_ID IS NOT NULL
             AND DNL_ProductLine_BUM_ID IS NOT NULL
             AND DNL_Authorized = 0
             AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
             AND DeliveryNote.DNL_BatchNbr = @BatchNbr
     

      
      
      UPDATE DeliveryNote
      SET    DNL_ProblemDescription =
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'二级经销商仓库不存在(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',二级经销商仓库不存在(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)
      WHERE      DNL_POReceiptLot_PRL_ID IS NULL
             AND DNL_ProblemDescription IS NULL
             AND DNL_ToWhmId IS NULL
             AND DNL_BatchNbr = @BatchNbr

      UPDATE DeliveryNote
      SET    DNL_ProblemDescription =
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'二级经销商仓库类型不是寄售仓库(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',二级经销商仓库类型不是寄售仓库(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)
      WHERE      DNL_POReceiptLot_PRL_ID IS NULL
             AND DNL_ProblemDescription IS NULL
             AND DNL_ToWhmId IS NOT NULL
             AND DNL_BatchNbr = @BatchNbr
             AND NOT EXISTS (SELECT 1
                          FROM   Warehouse AS WH(nolock)
                          WHERE      WH.WHM_ID = DeliveryNote.DNL_ToWhmId
                                 AND WHM_Type IN ('LP_Consignment','Consignment'))
      
      UPDATE DeliveryNote
      SET    DNL_ProblemDescription =
                (CASE
                    WHEN DNL_ProblemDescription IS NULL THEN N'订单对应的经销商与收货经销商不相同(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                    ELSE DNL_ProblemDescription + N',订单对应的经销商与收货经销商不相同(发货单号：' + ISNULL(DNL_DeliveryNoteNbr,'') + ';UPN：' + ISNULL(DNL_CFN,'') + ';LOT:' + ISNULL(DNL_LotNumber,'')+')'
                 END)
      WHERE      DNL_POReceiptLot_PRL_ID IS NULL
             AND DNL_ProblemDescription IS NULL            
             AND DNL_BatchNbr = @BatchNbr
             AND Exists
             (
                SELECT 1
				  FROM   PurchaseOrderHeader AS POH(nolock)
				  WHERE      POH.POH_OrderNo = DeliveryNote.DNL_PONbr
						 AND POH.POH_DMA_ID <> DeliveryNote.DNL_DealerID_DMA_ID						
             )
      
      --LP寄售发货给二级经销商，如果发货单包含错误，则整单不生成收货单，待问题处理完了以后再重新传      
      select @ErrCnt = count(*) from DeliveryNote(nolock) WHERE DNL_BatchNbr = @BatchNbr AND DNL_ProblemDescription IS NOT NULL
      IF (@ErrCnt = 0)
      BEGIN       
             
      --检查平台的库存是否足够

      --1、检查物料批次在仓库中是否存在
      --      UPDATE DeliveryNote
      --      SET    DNL_ProblemDescription =
      --                (CASE
      --                    WHEN DNL_ProblemDescription IS NULL THEN N'LP仓库中不存在该批次产品'
      --                    ELSE DNL_ProblemDescription + N',LP仓库中不存在该批次产品'
      --                 END)
      --      WHERE      DNL_ProblemDescription IS NULL
      --             AND DNL_POReceiptLot_PRL_ID IS NULL
      --             AND DNL_BatchNbr = @BatchNbr
      --             AND NOT EXISTS
      --                    (SELECT 1
      --                     FROM   Lot INNER JOIN Inventory INV ON INV.INV_ID = Lot.LOT_INV_ID
      --                     WHERE      Lot.LOT_LTM_ID = DeliveryNote.DNL_LTM_ID
      --                            AND INV.INV_WHM_ID = @LPDefaultWHWarehouse
      --                            AND INV.INV_PMA_ID = DeliveryNote.DNL_Product_PMA_ID)
      --
      --
      --      --2、检查物料批次在仓库中数量是否足够
      --      UPDATE DeliveryNote
      --      SET    DNL_ProblemDescription =
      --                (CASE
      --                    WHEN DNL_ProblemDescription IS NULL THEN N'该批次产品在LP仓库中数量不足'
      --                    ELSE DNL_ProblemDescription + N',该批次产品在LP仓库中数量不足'
      --                 END)
      --      FROM   (SELECT INV.INV_WHM_ID,
      --                     DNL_Product_PMA_ID,
      --                     DNL_LTM_ID,
      --                     SUM (DNL_ReceiveQty) AS DNL_ReceiveQty,
      --                     MAX (Lot.LOT_OnHandQty) AS LOT_OnHandQty
      --              FROM   DeliveryNote
      --                     INNER JOIN Lot ON Lot.LOT_LTM_ID = DNL_LTM_ID
      --                     INNER JOIN Inventory INV
      --                        ON     INV.INV_ID = Lot.LOT_INV_ID
      --                           AND INV.INV_WHM_ID = @LPDefaultWHWarehouse
      --                           AND INV.INV_PMA_ID = DNL_Product_PMA_ID
      --              WHERE      DNL_ProblemDescription IS NULL
      --                     AND DNL_POReceiptLot_PRL_ID IS NULL
      --                     AND DeliveryNote.DNL_BatchNbr = @BatchNbr
      --              GROUP BY INV.INV_WHM_ID, DNL_Product_PMA_ID, DNL_LTM_ID) AS T
      --      WHERE      DeliveryNote.DNL_ProblemDescription IS NULL
      --             AND DeliveryNote.DNL_BatchNbr = @BatchNbr
      --             AND T.INV_WHM_ID = @LPDefaultWHWarehouse
      --             AND T.DNL_Product_PMA_ID = DeliveryNote.DNL_Product_PMA_ID
      --             AND T.DNL_LTM_ID = DeliveryNote.DNL_LTM_ID
      --             AND T.LOT_OnHandQty - T.DNL_ReceiveQty < 0



      --库存操作
      /*库存临时表*/
      CREATE TABLE #tmp_inventory
      (
         INV_ID         UNIQUEIDENTIFIER,
         INV_WHM_ID     UNIQUEIDENTIFIER,
         INV_PMA_ID     UNIQUEIDENTIFIER,
         INV_OnHandQuantity FLOAT,
         IS_LP          BIT,
         PRIMARY KEY (INV_ID)
      )

      /*库存明细Lot临时表*/
      CREATE TABLE #tmp_lot
      (
         LOT_ID         UNIQUEIDENTIFIER,
         LOT_LTM_ID     UNIQUEIDENTIFIER,
         LOT_WHM_ID     UNIQUEIDENTIFIER,
         LOT_PMA_ID     UNIQUEIDENTIFIER,
         LOT_INV_ID     UNIQUEIDENTIFIER,
         LOT_OnHandQty  FLOAT,
         LOT_LotNumber  NVARCHAR (50) COLLATE Chinese_PRC_CI_AS,
         IS_LP          BIT,
         PRIMARY KEY (LOT_ID)
      )

      --Inventory表(从LP的默认仓库中扣减库存)
      INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                  INV_ID,
                                  INV_WHM_ID,
                                  INV_PMA_ID,
                                  IS_LP)
         SELECT -A.QTY,
                NEWID (),
                @LPDefaultWHWarehouse AS WHM_ID,
                A.DNL_Product_PMA_ID,
                1 AS IS_LP
         FROM   (SELECT DN.DNL_Product_PMA_ID, SUM (DN.DNL_ReceiveQty) AS QTY
                 FROM   DeliveryNote AS DN(nolock)
                 WHERE      DN.DNL_ProblemDescription IS NULL
                        AND DN.DNL_BatchNbr = @BatchNbr
                 GROUP BY DN.DNL_Product_PMA_ID) AS A



      --Inventory表(直接增加二级经销商的库存)
      INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                  INV_ID,
                                  INV_WHM_ID,
                                  INV_PMA_ID,
                                  IS_LP)
         SELECT A.QTY,
                NEWID (),
                A.DNL_ToWhmId ,
                A.DNL_Product_PMA_ID,
                0 AS IS_LP
         FROM   (SELECT DN.DNL_ToWhmId,DN.DNL_Product_PMA_ID, SUM (DN.DNL_ReceiveQty) AS QTY
                 FROM   DeliveryNote AS DN(nolock)
                 WHERE      DN.DNL_ProblemDescription IS NULL
                        AND DN.DNL_BatchNbr = @BatchNbr
                 GROUP BY DN.DNL_ToWhmId,DN.DNL_Product_PMA_ID) AS A

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

      --记录库存操作日志(LP和二级经销商的库存操作要分开进行记录，二级经销商需要记录单据编号)
      --Inventory表(仅记录LP的记录)
      SELECT inv.INV_OnHandQuantity AS ITR_Quantity,
             NEWID () AS ITR_ID,
             @EmptyGuid AS ITR_ReferenceID,
             'LP分销出库' AS ITR_Type,
             inv.INV_WHM_ID AS ITR_WHM_ID,
             inv.INV_PMA_ID AS ITR_PMA_ID,
             0 AS ITR_UnitPrice,
              (SELECT [DNL_DeliveryNoteNbr]=STUFF(( SELECT distinct ','+[DNL_DeliveryNoteNbr] 
                                       FROM DeliveryNote DN2(nolock)
                                      WHERE DN1.DNL_BatchNbr = DN2.DNL_BatchNbr
                                        FOR XML PATH('')), 1, 1, '')
                FROM DeliveryNote AS DN1(nolock)
               WHERE DNL_BatchNbr = @BatchNbr
               group by DNL_BatchNbr) AS ITR_TransDescription
      INTO   #tmp_invtrans
      FROM   #tmp_inventory AS inv
       WHERE inv.IS_LP = 1


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

        --如果默认库中有对应二维码的库存，则扣减二维码的库存
        INSERT INTO #tmp_lot (LOT_ID,
                              LOT_LTM_ID,
                              LOT_WHM_ID,
                              LOT_PMA_ID,
                              LOT_LotNumber,
                              LOT_OnHandQty,
                              IS_LP)
           SELECT NEWID (),
                  A.DNL_LTM_ID,
                  @LPDefaultWHWarehouse AS WHM_ID,
                  A.DNL_Product_PMA_ID,
                  A.DNL_LotNumber,
                  -A.QTY,
                  1
           FROM   (SELECT DN.DNL_Product_PMA_ID,
                          DN.DNL_LTM_ID,
                          DN.DNL_LotNumber,
                          SUM (DN.DNL_ReceiveQty) AS QTY
                   FROM   DeliveryNote AS DN(nolock)
                   WHERE      DN.DNL_ProblemDescription IS NULL
                          AND DN.DNL_BatchNbr = @BatchNbr
                          --今后不再扣减平台NoQR库存，而是将二维码的库存扣成负数 Eidt By SongWeiming on 2016-03-21
--                          AND EXISTS (SELECT 1 FROM Inventory INV, Lot LT
--                                       WHERE INV.INV_ID = LT.LOT_INV_ID
--                                         AND INV.INV_WHM_ID = @LPDefaultWHWarehouse
--                                         AND LT.LOT_LTM_ID = DN.DNL_LTM_ID
--                                      )
                   GROUP BY DN.DNL_Product_PMA_ID, DN.DNL_LTM_ID, DN.DNL_LotNumber) AS A
                   
        --如果默认库中没有对应库存，则扣减NoQR的库存
        --今后不再扣减平台NoQR库存，而是将二维码的库存扣成负数 Eidt By SongWeiming on 2016-03-21
--        INSERT INTO #tmp_lot (LOT_ID,
--                              LOT_LTM_ID,
--                              LOT_WHM_ID,
--                              LOT_PMA_ID,
--                              LOT_LotNumber,
--                              LOT_OnHandQty,
--                              IS_LP)
--           SELECT NEWID (),
--                  A.DNL_LTM_ID,
--                  @LPDefaultWHWarehouse AS WHM_ID,
--                  A.DNL_Product_PMA_ID,
--                  A.DNL_LotNumber,
--                  -A.QTY,
--                  1 AS IS_LP
--           FROM   (SELECT DN.DNL_Product_PMA_ID,
--                          (SELECT top 1 LM.LTM_ID
--                             FROM LotMaster LM 
--                            WHERE LM.LTM_LotNumber = DN.DNL_UPN ) AS DNL_LTM_ID,
--                          DN.DNL_UPN AS DNL_LotNumber,
--                          SUM (DN.DNL_ReceiveQty) AS QTY
--                   FROM   DeliveryNote AS DN
--                   WHERE      DN.DNL_ProblemDescription IS NULL
--                          AND DN.DNL_BatchNbr = @BatchNbr
--                          AND NOT EXISTS (SELECT 1 FROM Inventory INV, Lot LT
--                                           WHERE INV.INV_ID = LT.LOT_INV_ID
--                                             AND INV.INV_WHM_ID = @LPDefaultWHWarehouse
--                                             AND LT.LOT_LTM_ID = DN.DNL_LTM_ID
--                                      )
--                   GROUP BY DN.DNL_Product_PMA_ID, DN.DNL_UPN) AS A
      
      
      --Lot表(从LP的默认仓库中扣减库存)
--      INSERT INTO #tmp_lot (LOT_ID,
--                            LOT_LTM_ID,
--                            LOT_WHM_ID,
--                            LOT_PMA_ID,
--                            LOT_LotNumber,
--                            LOT_OnHandQty,
--                            IS_LP)
--         SELECT NEWID (),
--                A.DNL_LTM_ID,
--                @LPDefaultWHWarehouse AS WHM_ID,
--                A.DNL_Product_PMA_ID,
--                A.DNL_LotNumber,
--                -A.QTY,
--                1 AS IS_LP
--         FROM   (SELECT DN.DNL_Product_PMA_ID,
--                        DN.DNL_LTM_ID,
--                        DN.DNL_LotNumber,
--                        SUM (DN.DNL_ReceiveQty) AS QTY
--                 FROM   DeliveryNote AS DN
--                 WHERE      DN.DNL_ProblemDescription IS NULL
--                        AND DN.DNL_BatchNbr = @BatchNbr
--                 GROUP BY DN.DNL_Product_PMA_ID, DN.DNL_LTM_ID, DN.DNL_LotNumber) AS A

      --Lot表(在二级经销商的仓库中增加库存)
      INSERT INTO #tmp_lot (LOT_ID,
                            LOT_LTM_ID,
                            LOT_WHM_ID,
                            LOT_PMA_ID,
                            LOT_LotNumber,
                            LOT_OnHandQty,
                            IS_LP)
         SELECT NEWID (),
                A.DNL_LTM_ID,
                A.DNL_ToWhmId,
                A.DNL_Product_PMA_ID,
                A.DNL_LotNumber,
                A.QTY,
                0 AS IS_LP
         FROM   (SELECT DN.DNL_ToWhmId,
                        DN.DNL_Product_PMA_ID,
                        DN.DNL_LTM_ID,
                        DN.DNL_LotNumber,
                        SUM (DN.DNL_ReceiveQty) AS QTY
                 FROM   DeliveryNote AS DN(nolock)
                 WHERE      DN.DNL_ProblemDescription IS NULL
                        AND DN.DNL_BatchNbr = @BatchNbr
                 GROUP BY DN.DNL_ToWhmId,DN.DNL_Product_PMA_ID, DN.DNL_LTM_ID, DN.DNL_LotNumber) AS A

      --更新关联库存主键
      UPDATE #tmp_lot
      SET    LOT_INV_ID = INV.INV_ID
      FROM   Inventory INV(nolock)
      WHERE      INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
             AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

      --更新批次表，存在的更新，不存在的新增
      UPDATE Lot
      SET    Lot.LOT_OnHandQty = CONVERT (DECIMAL (18, 6), Lot.LOT_OnHandQty) + CONVERT (DECIMAL (18, 6), TMP.LOT_OnHandQty)
      FROM   #tmp_lot AS TMP
      WHERE      Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
             AND Lot.LOT_INV_ID = TMP.LOT_INV_ID

      INSERT INTO Lot (LOT_ID,
                       LOT_LTM_ID,
                       LOT_OnHandQty,
                       LOT_INV_ID)
         SELECT LOT_ID,
                LOT_LTM_ID,
                LOT_OnHandQty,
                LOT_INV_ID
         FROM   #tmp_lot AS TMP
         WHERE  NOT EXISTS
                   (SELECT 1
                    FROM   Lot(nolock)
                    WHERE      Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
                           AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)


      --记录库存操作日志
      --Lot表
      SELECT lot.LOT_OnHandQty AS ITL_Quantity,
             newid () AS ITL_ID,
             itr.ITR_ID AS ITL_ITR_ID,
             lot.LOT_LTM_ID AS ITL_LTM_ID,
             lot.LOT_LotNumber AS ITL_LotNumber
      INTO   #tmp_invtranslot
      FROM   #tmp_lot AS lot
             INNER JOIN #tmp_invtrans AS itr
                ON     itr.ITR_PMA_ID = lot.LOT_PMA_ID
                   AND itr.ITR_WHM_ID = lot.LOT_WHM_ID
      WHERE lot.IS_LP = 1

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
                'Complete',  --平台发给二级的寄售产品直接入库，不需要接收
                'Retail', 
                DNL_ProductLine_BUM_ID,
                ISNULL (@Client_DMA_ID, '00000000-0000-0000-0000-000000000000'),
                Carrier,
                TrackingNo,
                ShipType,
                Note,
                BUName,
                SapDeliveryDate,
                DNL_ToWhmId,
                DNL_FromWhmId
         FROM   (SELECT DNL_PONbr,
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
                        DNL_ToWhmId,
                        DNL_FromWhmId
                 FROM   DeliveryNote(nolock)
                 WHERE      DNL_POReceiptLot_PRL_ID IS NULL
                        AND DNL_ProblemDescription IS NULL
                        AND DNL_BatchNbr = @BatchNbr
                 --and exists (select 1 from DealerMaster where DealerMaster.dma_id = DeliveryNote.DNL_DealerID_DMA_ID
                 --and DealerMaster.DMA_SystemStartDate is not null and DealerMaster.DMA_SystemStartDate <= DeliveryNote.DNL_ShipmentDate)
                 GROUP BY DNL_PONbr,
                          DNL_DeliveryNoteNbr,
                          DNL_DealerID_DMA_ID,
                          DNL_ShipmentDate,
                          DNL_ProductLine_BUM_ID,
                          DNL_SapDeliveryDate,
                          DNL_ToWhmId,
                          DNL_FromWhmId) AS Header

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
                   OVER (PARTITION BY DNL_PONbr, DNL_DeliveryNoteNbr, DNL_DealerID_DMA_ID, DNL_ShipmentDate, DNL_ProductLine_BUM_ID
                         ORDER BY
                            DNL_PONbr,
                            DNL_DeliveryNoteNbr,
                            DNL_DealerID_DMA_ID,
                            DNL_ShipmentDate,
                            DNL_ProductLine_BUM_ID,
                            DNL_SapDeliveryDate,
                            DNL_Product_PMA_ID)
                   LineNbr
         FROM   (SELECT DNL_PONbr,
                        DNL_DeliveryNoteNbr,
                        DNL_DealerID_DMA_ID,
                        DNL_ShipmentDate,
                        DNL_ProductLine_BUM_ID,
                        DNL_SapDeliveryDate,
                        DNL_Product_PMA_ID,
                        DNL_ToWhmId,
                        SUM (DNL_ReceiveQty) AS QTY
                 FROM   DeliveryNote(nolock)
                 WHERE      DNL_POReceiptLot_PRL_ID IS NULL
                        AND DNL_ProblemDescription IS NULL
                        AND DNL_BatchNbr = @BatchNbr
                 --and exists (select 1 from DealerMaster where DealerMaster.dma_id = DeliveryNote.DNL_DealerID_DMA_ID
                 --and DealerMaster.DMA_SystemStartDate is not null and DealerMaster.DMA_SystemStartDate <= DeliveryNote.DNL_ShipmentDate)
                 GROUP BY DNL_PONbr,
                          DNL_DeliveryNoteNbr,
                          DNL_DealerID_DMA_ID,
                          DNL_ShipmentDate,
                          DNL_ProductLine_BUM_ID,
                          DNL_SapDeliveryDate,
                          DNL_Product_PMA_ID,
                          DNL_ToWhmId) AS Line
                INNER JOIN #tmpPORImportHeader
                   ON     Line.DNL_PONbr = #tmpPORImportHeader.SAPCusPONbr
                      AND Line.DNL_DeliveryNoteNbr = #tmpPORImportHeader.SAPShipmentID
                      AND Line.DNL_DealerID_DMA_ID = #tmpPORImportHeader.DealerDMAID
                      AND Line.DNL_ShipmentDate = #tmpPORImportHeader.SAPShipmentDate
                      AND Line.DNL_ProductLine_BUM_ID = #tmpPORImportHeader.ProductLineBUMID
                      --AND Line.DNL_TrackingNo = tmpPORImportHeader.TrackingNo
                      AND Line.DNL_SapDeliveryDate = #tmpPORImportHeader.SapDeliveryDate
                      AND Line.DNL_ToWhmId = #tmpPORImportHeader.WHMID

      --Lot
      INSERT INTO #tmpPORImportLot (LotRecID,
                                    LineRecID,
                                    LotNumber,
                                    ReceiptQty,
                                    ExpiredDate,
                                    WarehouseRecID,
                                    DNL_ID,
                                    LTM_ID,
                                    UnitPrice)
         SELECT NEWID (),
                #tmpPORImportLine.LineRecID,
                DeliveryNote.DNL_LotNumber,
                DeliveryNote.DNL_ReceiveQty,
                DeliveryNote.DNL_ExpiredDate,
                --Warehouse.WHM_ID,
                DeliveryNote.DNL_ToWhmId,
                DeliveryNote.DNL_ID,
                DeliveryNote.DNL_LTM_ID,
                DeliveryNote.DNL_UnitPrice
         FROM   DeliveryNote(nolock), #tmpPORImportHeader, #tmpPORImportLine
         WHERE      #tmpPORImportHeader.ID = #tmpPORImportLine.HeaderID
                AND DeliveryNote.DNL_PONbr = #tmpPORImportHeader.SAPCusPONbr
                AND DeliveryNote.DNL_DeliveryNoteNbr = #tmpPORImportHeader.SAPShipmentID
                AND DeliveryNote.DNL_DealerID_DMA_ID = #tmpPORImportHeader.DealerDMAID
                AND DeliveryNote.DNL_ShipmentDate = #tmpPORImportHeader.SAPShipmentDate
                AND DeliveryNote.DNL_ProductLine_BUM_ID = #tmpPORImportHeader.ProductLineBUMID
                AND DeliveryNote.DNL_SapDeliveryDate = #tmpPORImportHeader.SapDeliveryDate
                AND DeliveryNote.DNL_Product_PMA_ID = #tmpPORImportLine.PMAID
                AND DeliveryNote.DNL_ToWhmId = #tmpPORImportHeader.WHMID
                AND DeliveryNote.DNL_POReceiptLot_PRL_ID IS NULL
                AND DeliveryNote.DNL_ProblemDescription IS NULL
                AND DeliveryNote.DNL_BatchNbr = @BatchNbr

      --更新发货数据
      UPDATE DeliveryNote
      SET    DNL_POReceiptLot_PRL_ID = #tmpPORImportLot.LotRecID, DNL_HandleDate = GETDATE ()
      FROM   DeliveryNote(nolock) INNER JOIN #tmpPORImportLot ON DeliveryNote.DNL_ID = #tmpPORImportLot.DNL_ID

      --生成单据号
      DECLARE @DealerDMAID   UNIQUEIDENTIFIER
      DECLARE @BusinessUnitName NVARCHAR (20)
      DECLARE @ID            UNIQUEIDENTIFIER
      DECLARE @PONumber      NVARCHAR (50)

      DECLARE
         curHandlePONumber CURSOR FOR
            SELECT ID,
                   DealerDMAID,
                   BUName,
                   PONumber
            FROM   #tmpPORImportHeader
            FOR UPDATE OF PONumber

      OPEN curHandlePONumber
      FETCH NEXT FROM curHandlePONumber
      INTO   @ID, @DealerDMAID, @BusinessUnitName, @PONumber

      WHILE (@@fetch_status <> -1)
      BEGIN
         IF (@@fetch_status <> -2)
            BEGIN
               EXEC [GC_GetNextAutoNumber] @DealerDMAID,
                                           'Next_POReceiptNbr',
                                           @BusinessUnitName,
                                           @PONumber OUTPUT

               UPDATE #tmpPORImportHeader
               SET    PONumber = @PONumber
               WHERE  ID = @ID
            END

         FETCH NEXT FROM curHandlePONumber
         INTO   @ID, @DealerDMAID, @BusinessUnitName, @PONumber
      END

      CLOSE curHandlePONumber
      DEALLOCATE curHandlePONumber

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
                                   PRH_FromWHM_ID)
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
                ShipType,
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
                                PRL_UnitPrice)
         SELECT LotRecID,
                LineRecID,
                LotNumber,
                ReceiptQty,
                ExpiredDate,
                WarehouseRecID,
                UnitPrice
         FROM   #tmpPORImportLot

      
      --记录库存日志(根据生成的二级经销商收货单，来记录日志)      
    	SELECT l.ReceiptQty AS ITR_Quantity,
             NEWID () AS ITR_ID,
             l.LineRecID AS ITR_ReferenceID,
             '寄售产品自动收货入库' AS ITR_Type,
             h.WHMID AS ITR_WHM_ID,
             l.PMAID AS ITR_PMA_ID,
             0 AS ITR_UnitPrice,
             '接收借货入库单：' + h.PONumber + ' 行：' + CONVERT (NVARCHAR (20), l.LineNbr) AS ITR_TransDescription
        INTO #tmp_invtransT2
        FROM #tmpPORImportLine l INNER JOIN #tmpPORImportHeader h ON h.ID = l.HeaderID

      SELECT d.ReceiptQty AS ITL_Quantity,
             newid () AS ITL_ID,
             t.ITR_ID AS ITL_ITR_ID,
             d.LTM_ID AS ITL_LTM_ID,
             d.LotNumber AS ITL_LotNumber
        INTO #tmp_invtranslotT2
        FROM #tmpPORImportLot d INNER JOIN #tmp_invtransT2 t ON t.ITR_ReferenceID = d.LineRecID

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
           FROM #tmp_invtransT2

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
           FROM #tmp_invtranslotT2

      
      
      
      
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
                INNER JOIN PurchaseOrderHeader AS POH(nolock) ON POH.POH_OrderNo = H.SAPCusPONbr
                INNER JOIN PurchaseOrderDetail AS POD(nolock) ON POD.POD_POH_ID = POH.POH_ID
                INNER JOIN Product AS P
                   ON     P.PMA_ID = L.PMAID
                      AND P.PMA_CFN_ID = POD.POD_CFN_ID
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
			from #tmpPORImportHeader H,#tmpPORImportLine L,#tmpPORImportLot Lot(nolock),Product(nolock)--,PurchaseOrderHeader
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
					select @updateqty = sum(POD_ReceiptQty),@updatecfn = POD_CFN_ID from PurchaseOrderDetail(nolock)
								where POD_POH_ID=@tmppohid
								and POD_CFN_ID = (select CFN_ID from CFN(nolock) where CFN_CustomerFaceNbr= @upn)
					  group by POD_CFN_ID
	          
					if(@updateqty2 < @updateqty)
					begin
					  set @updateqty2 = @updateqty
					end
				
					DECLARE	curDetail CURSOR 
					FOR select POD_ID,POD_CFN_ID,POD_RequiredQty,POD_ReceiptQty,POD_CFN_Price,CFN_CustomerFaceNbr,vp.[DESCRIPTION] 
						from PurchaseOrderDetail(nolock),cfn(nolock),View_ProductLine vp
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


      SET @IsValid = 'Success'
      END
      
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
GO


