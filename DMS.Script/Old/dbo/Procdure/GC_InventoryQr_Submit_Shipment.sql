DROP PROCEDURE [dbo].[GC_InventoryQr_Submit_Shipment]
GO



CREATE PROCEDURE [dbo].[GC_InventoryQr_Submit_Shipment]
	@UserId uniqueidentifier,
	@DealerId uniqueidentifier,
	@ProductLineId uniqueidentifier,	
	@HospitalId uniqueidentifier,
	@ShipmentDate nvarchar(30),
	@HeadXmlString XML,
	@RtnVal nvarchar(20) OUTPUT,
	@RtnMsg  nvarchar(2000) OUTPUT
AS 
	DECLARE @SHIPMENTINVOICENO NVARCHAR(1000);
    DECLARE @SHIPMENTINVOICETITLE NVARCHAR(1000);
    DECLARE @SHIPMENTINVOICEDATE NVARCHAR(1000);
    DECLARE @SHIPMENTDEPAERMENT NVARCHAR(1000);
    DECLARE @SHIPMENTREMARK NVARCHAR(1000);
	DECLARE @SysUserId uniqueidentifier;
	DECLARE @VENDORID uniqueidentifier;
SET NOCOUNT ON


	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	
	SELECT	 @SHIPMENTINVOICENO = doc.col.value('SHIPMENTINVOICENO[1]', 'NVARCHAR(1000)'),
             @SHIPMENTINVOICETITLE = doc.col.value('SHIPMENTINVOICETITLE[1]', 'NVARCHAR(1000)'),
             @SHIPMENTINVOICEDATE = doc.col.value('SHIPMENTINVOICEDATE[1]', 'NVARCHAR(1000)'),
             @SHIPMENTDEPAERMENT = doc.col.value('SHIPMENTDEPAERMENT[1]', 'NVARCHAR(1000)'),
             @SHIPMENTREMARK = doc.col.value('SHIPMENTREMARK[1]', 'NVARCHAR(1000)')
      FROM   @HeadXmlString.nodes('/HEADER') doc(col);

	CREATE TABLE #ShipmentHeader(
		[SPH_ID] [uniqueidentifier] NOT NULL,
		[SPH_Hospital_HOS_ID] [uniqueidentifier] NULL,
		[SPH_ShipmentNbr] [nvarchar](30) NULL,
		[SPH_Dealer_DMA_ID] [uniqueidentifier] NOT NULL,
		[SPH_ShipmentDate] [datetime] NULL,
		[SPH_Status] [nvarchar](50) NOT NULL,
		[SPH_Reverse_SPH_ID] [uniqueidentifier] NULL,
		[SPH_NoteForPumpSerialNbr] [nvarchar](2000) NULL,
		[SPH_Type] [nvarchar](50) NULL,
		[SPH_ProductLine_BUM_ID] [uniqueidentifier] NULL,
		[SPH_Shipment_User] [uniqueidentifier] NULL,
		[SPH_InvoiceNo] [nvarchar](400) NULL,
		[SPH_UpdateDate] [datetime] NULL,
		[SPH_SubmitDate] [datetime] NULL,
		[SPH_Office] [nvarchar](200) NULL,
		[SPH_InvoiceTitle] [nvarchar](200) NULL,
		[SPH_InvoiceDate] [datetime] NULL,
		[SPH_IsAuth] [bit] NULL,
		[SPH_InvoiceFirstDate] [datetime] NULL,
		[InputTime] [datetime] NULL,
		[DataType] [nvarchar](50) NULL,
		[AdjReason] [nvarchar](50) NULL,
		[AdjAction] [nvarchar](50) NULL
	)

	CREATE TABLE #ShipmentLine(
		[SPL_ID] [uniqueidentifier] NOT NULL,
		[SPL_SPH_ID] [uniqueidentifier] NOT NULL,
		[SPL_Shipment_PMA_ID] [uniqueidentifier] NOT NULL,
		[SPL_ShipmentQty] [float] NOT NULL,
		[SPL_UnitPrice] [float] NULL,
		[SPL_LineNbr] [int] NULL
	)

	CREATE TABLE #ShipmentLot(
		[SLT_SPL_ID] [uniqueidentifier] NOT NULL,
		[SLT_LotShippedQty] [float] NOT NULL,
		[SLT_LOT_ID] [uniqueidentifier] NOT NULL,
		[SLT_ID] [uniqueidentifier] NOT NULL,
		[SLT_WHM_ID] [uniqueidentifier] NOT NULL,
		[SLT_UnitPrice] [decimal](18, 6) NULL,
		[AdjType] [nvarchar](1000) NULL,
		[AdjReason] [nvarchar](1000) NULL,
		[AdjAction] [nvarchar](1000) NULL,
		[InputTime] [datetime] NULL,
		[ShipmentDate] [datetime] NULL,
		[Remark] [nvarchar](100) NULL,
		[SLT_CAH_ID] [uniqueidentifier] NULL,
		[SLT_QRLOT_ID] [uniqueidentifier] NULL,
		[SLT_QRLotNumber] [nvarchar](50) NULL
	)
	/*附件临时表*/
	create table #tmp_Attachment(
	AT_ID                uniqueidentifier,
	AT_Main_ID           uniqueidentifier,
	AT_Name              nvarchar(200),
	AT_URL               nvarchar(200),
	AT_TYPE              nvarchar(50),
	AT_UPloadUser        uniqueidentifier,
	AT_UPloadDate        date
	primary key (AT_ID)
	)

	SELECT distinct IO_Id AS ID,
		IO_DMA_ID AS DealerId,
		IO_CFN_ID AS CfnId,
		IO_PMA_ID AS PmaId,
		IO_Lot_Id AS LotId,
		IO_QRC_ID AS QrcId,
		INV_ID AS InvId,
		WHM_ID AS WhmId,
		WHM_Type AS WarehouseType,
		null AS WarehouseTypeCode,
		IO_LotNumber AS LotNumber,
		IO_BarCode AS BarCode,
		IO_Qty AS Qty,
		IO_ShipmentPrice AS Price,
		Lot.LOT_LTM_ID AS LTM_ID,
		CFN.CFN_CustomerFaceNbr AS UPN,
		CFN_ProductLine_BUM_ID AS ProductLineId,
		CAST(null AS uniqueidentifier) AS SphId,
		CAST(null AS uniqueidentifier) AS SplId,
		CAST(null AS uniqueidentifier) AS SltId,
		NEWID() AS SLT_ID,
		CFN.CFN_Property6 AS CFN_Property6,
		CAST(null AS nvarchar(max)) AS Error_Messinge INTO #TEMP
	 FROM InventoryQROperation 
	INNER JOIN CFN ON CFN_ID = IO_CFN_ID
	INNER JOIN Lot ON LOT_ID = IO_Lot_Id
	INNER JOIN Inventory ON INV_ID = LOT_INV_ID
	INNER JOIN Warehouse ON WHM_ID = INV_WHM_ID
	WHERE WHM_Type IN ('Normal','DefaultWH','Consignment','LP_Consignment','Borrow','Frozen')
	AND IO_CreateUser = @UserId
	AND IO_OperationType = 'Shipment'
	AND CFN_ProductLine_BUM_ID = @ProductLineId
	AND EXISTS (SELECT  1
			  FROM    DealerAuthorizationTable AS DA
			  INNER JOIN DealerContract AS DC ON DA.DAT_DCL_ID = DC.DCL_ID
			  INNER JOIN HospitalList AS HL ON DA.DAT_ID = HL.HLA_DAT_ID
			  INNER JOIN Cache_PartsClassificationRec AS CP ON CP.PCT_ProductLine_BUM_ID = DA.DAT_ProductLine_BUM_ID
			  WHERE DC.DCL_DMA_ID = Warehouse.WHM_DMA_ID
			  AND HL.HLA_HOS_ID = @HospitalId
			  AND 
			  (
				  (
					  DA.DAT_PMA_ID = DA.DAT_ProductLine_BUM_ID
					  AND DA.DAT_ProductLine_BUM_ID = CFN.CFN_ProductLine_BUM_ID)
				  OR
				  (
					  DA.DAT_PMA_ID != DA.DAT_ProductLine_BUM_ID
					  AND CP.PCT_ParentClassification_PCT_ID = DA.DAT_PMA_ID
					  AND CP.PCT_ID in (select CCF.ClassificationId from CfnClassification CCF where CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr)
				  )
			  )
		  )
	AND EXISTS (SELECT 1 FROM interface.T_I_WC_DealerBarcodeQRcodeScan 
						WHERE QRC_ID = IO_QRC_ID
							AND QRC_Status = 'New'
				)
			 	
	--UPDATE #TEMP SET WarehouseType = 'Consignment' WHERE LotId = '9038CA53-9236-464E-A00F-5AC62EB771A1'
	--UPDATE #TEMP SET WarehouseType = 'Normal' WHERE LotId = 'D7DA97F8-7A8B-4FC0-AA51-8943807AED31'

	UPDATE #TEMP SET WarehouseTypeCode = 0 WHERE WarehouseType IN ('Normal','DefaultWH','Frozen')
	UPDATE #TEMP SET WarehouseTypeCode = 1 WHERE WarehouseType IN ('Consignment','LP_Consignment')
	UPDATE #TEMP SET WarehouseTypeCode = 2 WHERE WarehouseType IN ('Borrow')

	SELECT NEWID() AS Id,
		WarehouseTypeCode INTO #ShipmentHeadId_TEMP
	FROM #TEMP GROUP BY WarehouseTypeCode

	UPDATE #TEMP SET SphId = #ShipmentHeadId_TEMP.Id FROM #ShipmentHeadId_TEMP
	WHERE #ShipmentHeadId_TEMP.WarehouseTypeCode = #TEMP.WarehouseTypeCode
	
	--根据所在仓库的不同生成不同的销售出库单主表信息
	INSERT INTO #ShipmentHeader
			([SPH_ID]
           ,[SPH_Hospital_HOS_ID]
           ,[SPH_ShipmentNbr]
           ,[SPH_Dealer_DMA_ID]
           ,[SPH_ShipmentDate]
           ,[SPH_Status]
           ,[SPH_Reverse_SPH_ID]
           ,[SPH_NoteForPumpSerialNbr]
           ,[SPH_Type]
           ,[SPH_ProductLine_BUM_ID]
           ,[SPH_Shipment_User]
           ,[SPH_InvoiceNo]
           ,[SPH_UpdateDate]
           ,[SPH_SubmitDate]
           ,[SPH_Office]
           ,[SPH_InvoiceTitle]
           ,[SPH_InvoiceDate]
           ,[SPH_IsAuth]
           ,[SPH_InvoiceFirstDate]
           ,[InputTime]
           ,[DataType]
           ,[AdjReason]
           ,[AdjAction])
	SELECT SphId,@HospitalId,NULL,DealerId,@ShipmentDate,'Draft',NULL,@SHIPMENTREMARK,'Hospital',ProductLineId,@UserId,@SHIPMENTINVOICENO
	,GETDATE(),GETDATE(),@SHIPMENTDEPAERMENT,@SHIPMENTINVOICETITLE,CASE WHEN @SHIPMENTINVOICEDATE = '' THEN NULL ELSE CONVERT(DATETIME,@SHIPMENTINVOICEDATE) END 
	,0,NULL,NULL,NULL,NULL,NULL FROM #TEMP
	WHERE WarehouseType IN ('Normal','DefaultWH','Frozen')
	GROUP BY SphId,DealerId,ProductLineId
	UNION 
	SELECT SphId,@HospitalId,NULL,DealerId,@ShipmentDate,'Draft',NULL,NULL,'Consignment',ProductLineId,@UserId,NULL
	,GETDATE(),GETDATE(),NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL FROM #TEMP
	WHERE WarehouseType IN ('Consignment','LP_Consignment')
	GROUP BY SphId,DealerId,ProductLineId
	UNION 
	SELECT SphId,@HospitalId,NULL,DealerId,@ShipmentDate,'Draft',NULL,NULL,'Borrow',ProductLineId,@UserId,NULL
	,GETDATE(),GETDATE(),NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL FROM #TEMP
	WHERE WarehouseType IN ('Borrow')
	GROUP BY SphId,DealerId,ProductLineId

	SELECT NEWID() AS Id,
		SphId,PmaId INTO #ShipmentLineId_TEMP
	FROM #TEMP GROUP BY SphId,PmaId

	UPDATE #TEMP SET SplId = #ShipmentLineId_TEMP.Id FROM #ShipmentLineId_TEMP
	WHERE #ShipmentLineId_TEMP.SphId = #TEMP.SphId
	AND #ShipmentLineId_TEMP.PmaId = #TEMP.PmaId

    
     
     
	INSERT INTO #ShipmentLine
	(
		[SPL_ID],
		[SPL_SPH_ID],
		[SPL_Shipment_PMA_ID],
		[SPL_ShipmentQty],
		[SPL_UnitPrice],
		[SPL_LineNbr]
	)
	SELECT SplId,SphId,PmaId,SUM(Qty) AS Qty,null,ROW_NUMBER() OVER(PARTITION BY SphId ORDER BY PmaId) AS LineNbr FROM #TEMP 
	GROUP BY SplId,SphId,PmaId

	INSERT INTO #ShipmentLot
           ([SLT_SPL_ID],
			[SLT_LotShippedQty],
			[SLT_LOT_ID],
			[SLT_ID],
			[SLT_WHM_ID],
			[SLT_UnitPrice],
			[AdjType],
			[AdjReason],
			[AdjAction],
			[InputTime],
			[ShipmentDate],
			[Remark],
			[SLT_CAH_ID],
			[SLT_QRLOT_ID],
			[SLT_QRLotNumber])
	SELECT SplId,Qty,LotId,SLT_ID,WhmId,Price,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL FROM #TEMP
 
BEGIN TRY
BEGIN TRAN
	--校验价格
	UPDATE #TEMP SET Error_Messinge='批次号:' + #TEMP.LotNumber + '@@' + #TEMP.BarCode + '价格不能为0'
	WHERE #TEMP.Price IS NULL 
	AND Error_Messinge IS NULL
      
	--校验二维码是否已使用
	UPDATE #TEMP SET #TEMP.Error_Messinge='序列号:' + #TEMP.UPN + '的产品只能销售一个'
	FROM (SELECT A.PmaId,A.LTM_ID,SUM(convert(decimal(18,6),A.Qty)) AS SNL_LotQty FROM #TEMP A WHERE A.ProductLineId='97a4e135-74c7-4802-af23-9d6d00fcb2cc'
	AND A.UPN NOT LIKE '66%' GROUP BY A.PmaId,A.LTM_ID) T
	WHERE #TEMP.LTM_ID=T.LTM_ID 
	AND #TEMP.PmaId=T.PmaId
	AND T.SNL_LotQty>1
	AND #TEMP.Error_Messinge IS NULL
     
	--校验产品是否已销售过
	UPDATE #TEMP SET #TEMP.Error_Messinge='序列号:'+#TEMP.UPN+'的产品已经销售过'
	WHERE dbo.fn_GetCanShipFlag(#TEMP.CFN_Property6,#TEMP.LotNumber + '@@' + #TEMP.BarCode,#TEMP.UPN,@DealerId) = N'否'
	AND Error_Messinge IS NULL

	SELECT @RtnMsg = Error_Messinge FROM #TEMP WHERE Error_Messinge IS NOT NULL
    
	--拼接错误信息
	IF((SELECT COUNT(*) FROM #TEMP WHERE Error_Messinge IS NOT NULL)>0)
		BEGIN
     
			--抛出错误信息
			SELECT @RtnMsg = STUFF((SELECT CAST(','+Error_Messinge AS NVARCHAR(2000)) FROM #TEMP WHERE Error_Messinge IS NOT NULL 
			FOR XML PATH('')),1,1,'')
			RAISERROR (@RtnMsg, 16, 1)
		END
      
     --附件信息
     IF ((SELECT COUNT(*) FROM Attachment WHERE AT_Main_ID = @DealerId AND AT_Type = 'Dealer_Shipment_Qr') > 0)
		BEGIN

			INSERT INTO #tmp_Attachment(AT_ID,AT_Main_ID,AT_Name,AT_TYPE,AT_UPloadDate,AT_UPloadUser,AT_URL)
			SELECT NEWID(),#ShipmentHeader.SPH_ID,AT_Name,'ShipmentToHospital',AT_UPloadDate,AT_UPloadUser,AT_URL 
			FROM #ShipmentHeader INNER JOIN Attachment ON #ShipmentHeader.SPH_Dealer_DMA_ID = Attachment.AT_Main_ID
			WHERE Attachment.AT_Type = 'Dealer_Shipment_Qr'
		
		END

	--将附件信息写入附件表
	INSERT INTO Attachment(AT_ID,AT_Main_ID,AT_Name,AT_TYPE,AT_UPloadDate,AT_UPloadUser,AT_URL)
	SELECT AT_ID,AT_Main_ID,AT_Name,AT_TYPE,AT_UPloadDate,AT_UPloadUser,AT_URL FROM #tmp_Attachment

	INSERT INTO ShipmentHeader
			([SPH_ID]
           ,[SPH_Hospital_HOS_ID]
           ,[SPH_ShipmentNbr]
           ,[SPH_Dealer_DMA_ID]
           ,[SPH_ShipmentDate]
           ,[SPH_Status]
           ,[SPH_Reverse_SPH_ID]
           ,[SPH_NoteForPumpSerialNbr]
           ,[SPH_Type]
           ,[SPH_ProductLine_BUM_ID]
           ,[SPH_Shipment_User]
           ,[SPH_InvoiceNo]
           ,[SPH_UpdateDate]
           ,[SPH_SubmitDate]
           ,[SPH_Office]
           ,[SPH_InvoiceTitle]
           ,[SPH_InvoiceDate]
           ,[SPH_IsAuth]
           ,[SPH_InvoiceFirstDate]
           ,[InputTime]
           ,[DataType]
           ,[AdjReason]
           ,[AdjAction])
	SELECT [SPH_ID]
           ,[SPH_Hospital_HOS_ID]
           ,[SPH_ShipmentNbr]
           ,[SPH_Dealer_DMA_ID]
           ,[SPH_ShipmentDate]
           ,[SPH_Status]
           ,[SPH_Reverse_SPH_ID]
           ,[SPH_NoteForPumpSerialNbr]
           ,[SPH_Type]
           ,[SPH_ProductLine_BUM_ID]
           ,[SPH_Shipment_User]
           ,[SPH_InvoiceNo]
           ,[SPH_UpdateDate]
           ,[SPH_SubmitDate]
           ,[SPH_Office]
           ,[SPH_InvoiceTitle]
           ,[SPH_InvoiceDate]
           ,[SPH_IsAuth]
           ,[SPH_InvoiceFirstDate]
           ,[InputTime]
           ,[DataType]
           ,[AdjReason]
           ,[AdjAction] FROM #ShipmentHeader
	
	INSERT INTO ShipmentLine
	(
		[SPL_ID],
		[SPL_SPH_ID],
		[SPL_Shipment_PMA_ID],
		[SPL_ShipmentQty],
		[SPL_UnitPrice],
		[SPL_LineNbr]
	)
	SELECT [SPL_ID],
		[SPL_SPH_ID],
		[SPL_Shipment_PMA_ID],
		[SPL_ShipmentQty],
		[SPL_UnitPrice],
		[SPL_LineNbr]
	FROM #ShipmentLine

	INSERT INTO ShipmentLot
			([SLT_SPL_ID],
			[SLT_LotShippedQty],
			[SLT_LOT_ID],
			[SLT_ID],
			[SLT_WHM_ID],
			[SLT_UnitPrice],
			[AdjType],
			[AdjReason],
			[AdjAction],
			[InputTime],
			[ShipmentDate],
			[Remark],
			[SLT_CAH_ID],
			[SLT_QRLOT_ID],
			[SLT_QRLotNumber])
	SELECT [SLT_SPL_ID],
			[SLT_LotShippedQty],
			[SLT_LOT_ID],
			[SLT_ID],
			[SLT_WHM_ID],
			[SLT_UnitPrice],
			[AdjType],
			[AdjReason],
			[AdjAction],
			[InputTime],
			[ShipmentDate],
			[Remark],
			[SLT_CAH_ID],
			[SLT_QRLOT_ID],
			[SLT_QRLotNumber]
	FROM #ShipmentLot

	--lijie add 20160630
	/*库存临时表*/
	create table #tmp_inventory(
	INV_ID uniqueidentifier,
	INV_WHM_ID uniqueidentifier,
	INV_PMA_ID uniqueidentifier,
	INV_OnHandQuantity float,
	INV_TOWHM_ID uniqueidentifier,
	primary key (INV_ID)
	)

	/*库存明细Lot临时表*/
	create table #tmp_lot(
	LOT_ID uniqueidentifier,
	LOT_LTM_ID uniqueidentifier,
	LOT_WHM_ID uniqueidentifier,
	LOT_PMA_ID uniqueidentifier,
	LOT_INV_ID uniqueidentifier,
	LOT_OnHandQty float,
	LOT_LotNumber nvarchar(50),
	LOT_TO_WHM_ID uniqueidentifier,
	primary key (LOT_ID)
	)
	
	/*库存日志临时表*/
	create table #tmp_invtrans(
	ITR_Quantity         float,
	ITR_ID               uniqueidentifier,
	ITR_ReferenceID      uniqueidentifier,
	ITR_Type             nvarchar(50)         collate Chinese_PRC_CI_AS,
	ITR_WHM_ID           uniqueidentifier,
	ITR_PMA_ID           uniqueidentifier,
	ITR_UnitPrice        float,
	ITR_TransDescription nvarchar(200)        collate Chinese_PRC_CI_AS,  
	primary key (ITR_ID)
	)
	
	/*库存明细Lot日志临时表*/
	create table #tmp_invtranslot(
	ITL_Quantity         float,
	ITL_ID               uniqueidentifier,
	ITL_ITR_ID           uniqueidentifier,
	ITL_LTM_ID           uniqueidentifier,
	ITL_LotNumber        nvarchar(50)         collate Chinese_PRC_CI_AS,
	primary key (ITL_ID)
	)

    --建立游标
    DECLARE @ShipmenId uniqueidentifier;
    DECLARE @Messinge NVARCHAR(MAX);
    DECLARE @m_DmaId uniqueidentifier
	DECLARE @m_BuName nvarchar(50);
	DECLARE @m_Id uniqueidentifier;
	DECLARE @m_OrderNo nvarchar(50);
	DECLARE @m_LineId uniqueidentifier;
	DECLARE @m_Sphtype nvarchar(50);
	DECLARE @DMA_TYPE nvarchar(50);
	DECLARE @Parent_DMAID uniqueidentifier;
    DECLARE ShipmentCursor CURSOR FOR SELECT #ShipmentHeader.SPH_ID,#ShipmentHeader.SPH_Type
    FROM #ShipmentHeader
    SELECT @ShipmenId=SPH_ID from #ShipmentHeader
    
	--打开游标 

    OPEN ShipmentCursor
    FETCH NEXT FROM ShipmentCursor  INTO @ShipmenId,@m_Sphtype
    WHILE @@FETCH_STATUS = 0
 
    BEGIN 
		SET @RtnMsg='';

		--生成订单号
		SELECT @m_BuName=ATTRIBUTE_NAME 
		FROM Lafite_ATTRIBUTE 
		WHERE Id IN (
						SELECT RootID FROM Cache_OrganizationUnits 
						WHERE AttributeID = Convert(varchar(36),@ProductLineId)
					) 
		AND ATTRIBUTE_TYPE = 'BU'		
		
		EXEC [GC_GetNextAutoNumber] @DealerId,'Next_ShipmentNbr',@m_BuName, @m_OrderNo OUTPUT
  
		--调用存储过程校验信息
		EXEC GC_HospitalShipmentBSC_BeforeSubmit @ShipmenId, @ShipmentDate,@DealerId,@ProductLineId,@HospitalId, @UserId,@RtnVal OUTPUT,@RtnMsg OUTPUT

		IF(@RtnVal<>'Success')
			BEGIN
				RAISERROR (@RtnMsg, 16, 1)
			END
      
		--修改临时表据状态
		UPDATE #ShipmentHeader SET SPH_Status = 'Complete',SPH_ShipmentNbr = @m_OrderNo
		WHERE SPH_ID=@ShipmenId
       --修改单据状态,由于要某些情况下要生成清指定批号订单所已把修改单据状态放到这
	    UPDATE ShipmentHeader SET SPH_Status=#ShipmentHeader.SPH_Status,SPH_ShipmentNbr=#ShipmentHeader.SPH_ShipmentNbr
	    FROM #ShipmentHeader WHERE ShipmentHeader.SPH_ID=#ShipmentHeader.SPH_ID AND ShipmentHeader.SPH_ID=@ShipmenId
		SELECT @DMA_TYPE = DMA_DealerType FROM DealerMaster WHERE DMA_ID=@DealerId
		
		--若经销商为T2且单据类型为‘寄售’那么需要新增销售接口数据
		IF(@DMA_TYPE = 'T2' AND @m_Sphtype = 'Consignment')
		BEGIN
			--如果经销商为T2且寄售类型的销售单,写入接口表供平台下载
			SELECT @Parent_DMAID = DMA_Parent_DMA_ID FROM DealerMaster WHERE DMA_ID = @DealerId
			INSERT INTO SalesInterface(SI_ID,SI_BatchNbr,SI_RecordNbr,SI_SPH_ID,SI_SPH_ShipmentNbr,SI_Status,SI_ProcessType,SI_FileName,SI_CreateUser,SI_CreateDate,SI_UpdateUser,SI_UpdateDate,SI_ClientID)
			SELECT NEWID(),'','',@ShipmenId,@m_OrderNo,'Pending','Manual',NULL,@UserId,GETDATE(),@UserId,GETDATE(),CLT_ID 
			FROM Client 
			WHERE CLT_Corp_Id = @Parent_DMAID 
			AND CLT_ActiveFlag = '1' 
			AND CLT_DeletedFlag = '0'
			EXEC GC_PurchaseOrder_AfterShipmentImport @m_OrderNo,'ConsignmentSales',@RtnVal OUTPUT,@RtnMsg OUTPUT
		END
		--若经销商为T1且单据类型为寄售
		 IF(@DMA_TYPE='T1' AND @m_Sphtype = 'Consignment')
		 BEGIN
		   EXEC GC_PurchaseOrder_AfterShipment @m_OrderNo, 'ConsignmentSales',@RtnVal OUTPUT,@RtnMsg OUTPUT
		 END
		 --若经销商为平台或T1
		
		 IF((@DMA_TYPE='T1' OR @DMA_TYPE='LP') AND @m_Sphtype = 'Borrow')
		 BEGIN
		    EXEC GC_PurchaseOrder_AfterShipment @m_OrderNo, 'ClearBorrowManual',@RtnVal OUTPUT,@RtnMsg OUTPUT
		 END
	    
	    FETCH NEXT FROM ShipmentCursor  INTO @ShipmenId,@m_Sphtype
    END

	CLOSE ShipmentCursor
	DEALLOCATE ShipmentCursor
   
	--写入库存临时表
	INSERT INTO #tmp_inventory(INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
	SELECT A.QTY,A.InvId,A.WhmId,A.PmaId FROM (SELECT #TEMP.PmaId,#TEMP.WhmId,SUM(#TEMP.Qty) AS QTY,#TEMP.InvId FROM #TEMP GROUP BY #TEMP.PmaId,#TEMP.WhmId,#TEMP.InvId)A
	
	--更新仓库库存
	UPDATE Inventory SET INV_OnHandQuantity=Inventory.INV_OnHandQuantity+(-#tmp_inventory.INV_OnHandQuantity)
	FROM #tmp_inventory WHERE Inventory.INV_ID=#tmp_inventory.INV_ID
	AND Inventory.INV_PMA_ID=Inventory.INV_PMA_ID
	AND Inventory.INV_WHM_ID=#tmp_inventory.INV_WHM_ID
	
	--写入批次库存表
	INSERT INTO #tmp_lot(LOT_ID,LOT_LTM_ID,LOT_WHM_ID,LOT_PMA_ID,LOT_INV_ID,LOT_OnHandQty,LOT_LotNumber)
	SELECT A.LotId,A.LTM_ID,A.WhmId,A.PmaId,A.InvId,A.QTY,A.LotNumber FROM (SELECT #TEMP.LotId,#TEMP.LTM_ID,#TEMP.WhmId,#TEMP.PmaId,InvId,#TEMP.LotNumber+'@@'+#TEMP.BarCode AS LotNumber,SUM(#TEMP.Qty) AS QTY FROM #TEMP GROUP BY #TEMP.LotId,#TEMP.LTM_ID,#TEMP.WhmId,#TEMP.PmaId,InvId,#TEMP.LotNumber,#TEMP.BarCode)A
	
	--更新批次库存
	UPDATE Lot SET LOT.LOT_OnHandQty=LOT.LOT_OnHandQty+(-#tmp_lot.LOT_OnHandQty)
	FROM #tmp_lot WHERE Lot.LOT_ID=#tmp_lot.LOT_ID
	AND Lot.LOT_LTM_ID=#tmp_lot.LOT_LTM_ID
	AND LOT.LOT_INV_ID=#tmp_lot.LOT_INV_ID
   
	--记录日志
	INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
	SELECT -#TEMP.Qty,NEWID(),#TEMP.SLT_ID,'扫码上报销量',#TEMP.WhmId,#TEMP.PmaId,0,
	'销售出库单:'+#ShipmentHeader.SPH_ShipmentNbr+'从仓库中移除。'
	FROM #TEMP INNER JOIN #ShipmentHeader on #TEMP.SphId=#ShipmentHeader.SPH_ID
	    
	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
    SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans
		
    --Lot操作日志
    INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber,ITL_ITR_ID)
	SELECT -A.Qty,NEWID(),A.LTM_ID,A.LotNumber+'@@'+A.BarCode,B.ITR_ID
	FROM #TEMP A INNER JOIN #tmp_invtrans B ON A.SLT_ID=B.ITR_ReferenceID
	   
	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot
	
	
     
    --删除上传的附件类型为Dealer_Shipment_Qr
    DELETE Attachment WHERE AT_Main_ID=@DealerId AND AT_Type='Dealer_Shipment_Qr'
    
    --记录日志
	INSERT INTO PurchaseOrderLog
	SELECT NEWID(),SPH_ID,@UserId,GETDATE(),'CreateShipment','销售出库单库存上报' FROM #ShipmentHeader
	
	--在库存上传表中记录操作内容
	UPDATE interface.T_I_WC_DealerBarcodeQRcodeScan 
	SET QRC_DataHandleRemark = ISNULL(QRC_DataHandleRemark,'') + ('在'+CONVERT(NVARCHAR(50),GETDATE(),120)+'执行上报销售,销售数量:'+CAST(Qty AS NVARCHAR(100)))
	FROM (SELECT QrcId,SUM(Qty) AS Qty FROM #TEMP GROUP BY QrcId) T
	WHERE QRC_ID = T.QrcId
	
	--清楚库存上报表中的数据
	DELETE FROM InventoryQROperation 
	WHERE IO_CreateUser = @UserId 
	AND EXISTS (SELECT 1 FROM CFN WHERE CFN_ID = IO_CFN_ID AND CFN_ProductLine_BUM_ID = @ProductLineId)
	AND IO_OperationType = 'Shipment'

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	
    return -1
    
END CATCH



GO


