DROP Procedure [dbo].[GC_Interface_Sales]
GO




/*
销售医院数据上传
1、LP通过接口上传数据，此时@BatchNbr和@ClientID不能为空
2、T1和T2通过界面上传数据，此时@UserId不能为空
*/
CREATE Procedure [dbo].[GC_Interface_Sales]
	@BatchNbr NVARCHAR(30),
	@ClientID NVARCHAR(50),
	@UserId uniqueidentifier,
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	DECLARE @SysUserId uniqueidentifier
	DECLARE @SystemHoldWarehouse uniqueidentifier
	DECLARE @DealerId uniqueidentifier
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	--经销商主键
	if @ClientID is not null
		SELECT @DealerId = CLT_Corp_Id FROM Client WHERE CLT_ID = @ClientID
	else
		SELECT @DealerId = Corp_ID FROM Lafite_IDENTITY WHERE Id = @UserId
		
	--在途库主键
	SELECT @SystemHoldWarehouse = WHM_ID FROM Warehouse WHERE WHM_DMA_ID = @DealerId AND WHM_Type = 'SystemHold'

	--如果@ClientID不为空，表示从InterfaceSales中读取数据
	--产品授权暂不做检查,SNL_Authorized始终1
	if @ClientID is not null
	begin
		INSERT INTO SalesNote (SNL_ID,SNL_ArticleNumber,SNL_UnitPrice,SNL_LotNumber,SNL_LotQty,SNL_SaleDate,
		    SNL_SaleType,SNL_HospitalCode,SNL_Remark,SNL_LineNbr,SNL_FileName,SNL_ImportDate,SNL_ClientID,
		    SNL_BatchNbr,SNL_DMA_ID,SNL_Authorized,SNL_WriteOff)
		SELECT NEWID(),ITS_ArticleNumber,ITS_UnitPrice,ITS_LotNumber + '@@' + isnull(ITS_QRCode,'NoQR'),ITS_LotQty,ITS_SaleDate,ITS_SaleType,
		       ITS_HospitalCode,ITS_Remark,ITS_LineNbr,ITS_FileName,ITS_ImportDate,@DealerId,
		       ITS_BatchNbr,@DealerId,1,(case when ITS_LotQty > 0 then 0 else 1 end) as IsWriteOff
		FROM   InterfaceSales
		WHERE  ITS_BatchNbr = @BatchNbr 
		AND ABS(ITS_LotQty) > 0

		--根据销售类型得到对应的默认仓库
		UPDATE SalesNote SET SalesNote.SNL_WHM_ID = WH.WHM_ID, SalesNote.SNL_Warehouse = WH.WHM_Name, SalesNote.SNL_HandleDate = GETDATE()
		FROM Warehouse WH
		WHERE WH.WHM_DMA_ID = SalesNote.SNL_DMA_ID
		AND WH.WHM_Type = (CASE SalesNote.SNL_SaleType WHEN '1' THEN 'DefaultWH' WHEN '2' THEN 'Consignment' WHEN '3' THEN 'Borrow' ELSE SalesNote.SNL_SaleType END)
		AND SalesNote.SNL_BatchNbr = @BatchNbr

		--更新产品信息
		UPDATE A 
		SET A.SNL_CFN_ID = CFN.CFN_ID, 
		A.SNL_PMA_ID = Product.PMA_ID,
		A.SNL_BUM_ID = CFN.CFN_ProductLine_BUM_ID,
		A.SNL_PCT_ID = ccf.ClassificationId,
		A.SNL_HandleDate = GETDATE()
		FROM SalesNote A
		INNER JOIN 	CFN ON CFN.CFN_CustomerFaceNbr = A.SNL_ArticleNumber
		INNER JOIN Product ON Product.PMA_CFN_ID = CFN.CFN_ID
		inner join CfnClassification ccf on ccf.CfnCustomerFaceNbr=cfn.CFN_CustomerFaceNbr 
		and ccf.ClassificationId in (select ProducPctId from GC_FN_GetDealerAuthProductSub(a.SNL_DMA_ID))
		WHERE  A.SNL_BatchNbr = @BatchNbr

		--根据物料主键和批次号更新批次号主键
		UPDATE SalesNote
		SET SalesNote.SNL_LTM_ID = LM.LTM_ID
		FROM LotMaster LM
		WHERE LM.LTM_LotNumber = SalesNote.SNL_LotNumber
		AND LM.LTM_Product_PMA_ID = SalesNote.SNL_PMA_ID
		AND SalesNote.SNL_BatchNbr = @BatchNbr
		AND SalesNote.SNL_PMA_ID IS NOT NULL

		--更新医院
		UPDATE SalesNote SET SalesNote.SNL_HOS_ID = HOS.HOS_ID, SalesNote.SNL_HospitalName = HOS.HOS_HospitalName, SalesNote.SNL_HandleDate = GETDATE()
		FROM Hospital HOS
		WHERE HOS.HOS_Key_Account = SalesNote.SNL_HospitalCode
		AND SalesNote.SNL_BatchNbr = @BatchNbr

		--TODO：检查医院授权
		
		--更新错误信息
		UPDATE SalesNote SET SNL_ProblemDescription = N'销售仓库未找到'
		WHERE SNL_WHM_ID IS NULL AND SalesNote.SNL_BatchNbr = @BatchNbr

		UPDATE SalesNote SET SNL_ProblemDescription = (CASE WHEN SNL_ProblemDescription IS NULL THEN '' ELSE SNL_ProblemDescription + ',' END) + N'产品型号不存在'
		WHERE SNL_CFN_ID IS NULL AND SalesNote.SNL_BatchNbr = @BatchNbr

		UPDATE SalesNote SET SNL_ProblemDescription = (CASE WHEN SNL_ProblemDescription IS NULL THEN '' ELSE SNL_ProblemDescription + ',' END) + N'产品未关联产品线'
		WHERE SNL_CFN_ID IS NOT NULL AND SNL_BUM_ID IS NULL AND SalesNote.SNL_BatchNbr = @BatchNbr
		
		UPDATE SalesNote SET SNL_ProblemDescription = (CASE WHEN SNL_ProblemDescription IS NULL THEN '' ELSE SNL_ProblemDescription + ',' END) + N'医院代码不正确'
		WHERE SNL_HOS_ID IS NULL AND SalesNote.SNL_BatchNbr = @BatchNbr

		UPDATE SalesNote SET SNL_ProblemDescription = (CASE WHEN SNL_ProblemDescription IS NULL THEN '' ELSE SNL_ProblemDescription + ',' END) + N'医院未授权'
		WHERE SNL_Authorized = 0 AND SalesNote.SNL_BatchNbr = @BatchNbr

		--寄售产品不允许冲红
		UPDATE SalesNote SET SNL_ProblemDescription = (CASE WHEN SNL_ProblemDescription IS NULL THEN '' ELSE SNL_ProblemDescription + ',' END) + N'寄售产品不允许冲红'
		WHERE SNL_SaleType <> '1' AND SNL_LotQty < 0 AND SalesNote.SNL_BatchNbr = @BatchNbr	

		--产品批次号不存在
		UPDATE SalesNote SET SNL_ProblemDescription = (CASE WHEN SNL_ProblemDescription IS NULL THEN '' ELSE SNL_ProblemDescription + ',' END) + N'产品批次号不存在'
		WHERE SNL_PMA_ID IS NOT NULL AND SNL_LTM_ID IS NULL AND SalesNote.SNL_BatchNbr = @BatchNbr
	end

	--如果@UserId不为空，则表示从ShipmentInit中读取数据
	if @UserId is not null
		begin
			IF @BatchNbr IS NULL
				BEGIN
					--取得批处理号
					SET @BatchNbr = ''
					EXEC dbo.GC_GetNextAutoNumberForInt 'SYS','SysSalesUploader',@BatchNbr OUTPUT
				END
			
			INSERT INTO SalesNote
			(
				SNL_ID,
				SNL_HospitalCode,
				SNL_HospitalName,
				SNL_HospitalOffice,
				SNL_InvoiceNumber,
				SNL_InvoiceTitle,
				SNL_InvoiceDate,
				SNL_SaleType,
				SNL_SaleDate,
				SNL_ArticleNumber,
				SNL_LotNumber,
				SNL_UnitPrice,
				SNL_Remark,
				SNL_ExpiredDate,
				SNL_UOM,
				SNL_LotQty,
				SNL_Warehouse,
				SNL_WriteOff,
				SNL_LineNbr,
				SNL_FileName,
				SNL_ImportDate,
				SNL_ClientID,
				SNL_BatchNbr,
				SNL_DMA_ID,
				SNL_WHM_ID,
				SNL_CFN_ID,
				SNL_PMA_ID,
				SNL_BUM_ID,
				SNL_PCT_ID,
				SNL_HOS_ID,
				SNL_LTM_ID,
				SNL_Authorized,
				SNL_ProblemDescription,
				SNL_HandleDate,
				SNL_ShipmentDate,
				SNL_LotRemark
				
			)
			SELECT NEWID(),I.SPI_HospitalCode,I.SPI_HospitalName, isnull(I.SPI_HospitalOffice,''),
			       isnull(I.SPI_InvoiceNumber,''), isnull(I.SPI_InvoiceTitle,''),I.SPI_InvoiceDate,I.SPI_SaleType,I.SPI_ShipmentDate,I.SPI_ArticleNumber,
			       I.SPI_LotNumber, I.SPI_Price,NULL,I.SPI_ExpiredDate,I.SPI_UOM,CONVERT(DECIMAL(18,6),I.SPI_Qty),I.SPI_Warehouse,
			       (case when CONVERT(DECIMAL(18,6),I.SPI_Qty) > 0 then 0 else 1 end) as IsWriteOff,I.SPI_LineNbr,
			       I.SPI_FileName,I.SPI_UploadDate,I.SPI_USER,@BatchNbr,I.SPI_DMA_ID,I.SPI_WHM_ID,I.SPI_CFN_ID,
			       I.SPI_PMA_ID, I.SPI_BUM_ID,NULL,I.SPI_HOS_ID,SPI_LTM_ID,1,NULL,GETDATE(),SPI_LotShipmentDate,SPI_Remark
		  	FROM ShipmentInit I
		  	WHERE I.SPI_USER = @UserId
		end

	--检查批次库存量是否足够
	--1、检查物料批次在仓库中是否存在
	UPDATE SalesNote SET SNL_ProblemDescription = N'该批次产品不存在仓库中'	
	WHERE SNL_ProblemDescription IS NULL AND SalesNote.SNL_BatchNbr = @BatchNbr
	AND NOT EXISTS (SELECT 1 FROM Lot INNER JOIN Inventory INV ON INV.INV_ID = Lot.LOT_INV_ID
	WHERE Lot.LOT_LTM_ID = SNL_LTM_ID AND INV.INV_WHM_ID = SNL_WHM_ID
	AND INV.INV_PMA_ID = SNL_PMA_ID)

	--2、检查物料批次在仓库中数量是否足够
	UPDATE SalesNote SET SNL_ProblemDescription = N'该批次产品在仓库中数量不足'
	FROM (SELECT SNL_WHM_ID,SNL_PMA_ID,SNL_LTM_ID,SUM(SNL_LotQty) AS SNL_LotQty, MAX(Lot.LOT_OnHandQty) AS LOT_OnHandQty 
	FROM SalesNote
	INNER JOIN Lot ON Lot.LOT_LTM_ID = SNL_LTM_ID 
	INNER JOIN Inventory INV ON INV.INV_ID = Lot.LOT_INV_ID AND INV.INV_WHM_ID = SNL_WHM_ID
	AND INV.INV_PMA_ID = SNL_PMA_ID
	WHERE SNL_ProblemDescription IS NULL AND SalesNote.SNL_BatchNbr = @BatchNbr	
	GROUP BY SNL_WHM_ID,SNL_PMA_ID,SNL_LTM_ID) AS T
	WHERE SalesNote.SNL_ProblemDescription IS NULL AND SalesNote.SNL_BatchNbr = @BatchNbr
	AND T.SNL_WHM_ID = SalesNote.SNL_WHM_ID 
	AND T.SNL_PMA_ID = SalesNote.SNL_PMA_ID 
	AND T.SNL_LTM_ID = SalesNote.SNL_LTM_ID
	AND T.LOT_OnHandQty - T.SNL_LotQty < 0

	--库存操作
	/*库存临时表*/
	create table #tmp_inventory(
	INV_ID uniqueidentifier,
	INV_WHM_ID uniqueidentifier,
	INV_PMA_ID uniqueidentifier,
	INV_OnHandQuantity float
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
	LOT_LotNumber nvarchar(20),
	primary key (LOT_ID)
	)

	--Inventory表
	INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
	SELECT -A.QTY,NEWID(),A.SNL_WHM_ID,A.SNL_PMA_ID
	FROM 
	(SELECT SNL_WHM_ID,SNL_PMA_ID,SUM(SNL_LotQty) AS QTY 
	FROM SalesNote
	WHERE SNL_ProblemDescription IS NULL AND SNL_BatchNbr = @BatchNbr	
	GROUP BY SNL_WHM_ID,SNL_PMA_ID) AS A

	--更新库存表，存在的更新，不存在的新增
	UPDATE Inventory SET Inventory.INV_OnHandQuantity = Convert(decimal(18,6),Inventory.INV_OnHandQuantity)+Convert(decimal(18,6),TMP.INV_OnHandQuantity)
	FROM #tmp_inventory AS TMP
	WHERE Inventory.INV_WHM_ID = TMP.INV_WHM_ID
	AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID

	INSERT INTO Inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)	
	SELECT INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID
	FROM #tmp_inventory AS TMP	
	WHERE NOT EXISTS (SELECT 1 FROM Inventory INV WHERE INV.INV_WHM_ID = TMP.INV_WHM_ID
	AND INV.INV_PMA_ID = TMP.INV_PMA_ID)	

	--Lot表
	INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
	SELECT NEWID(),A.SNL_LTM_ID,A.SNL_WHM_ID,A.SNL_PMA_ID,A.SNL_LotNumber,-A.QTY
	FROM 
	(SELECT SNL_WHM_ID,SNL_PMA_ID,SNL_LTM_ID,SNL_LotNumber,SUM(SNL_LotQty) AS QTY 
	FROM SalesNote
	WHERE SNL_ProblemDescription IS NULL AND SNL_BatchNbr = @BatchNbr	
	GROUP BY SNL_WHM_ID,SNL_PMA_ID,SNL_LTM_ID,SNL_LotNumber) AS A

	--更新关联库存主键
	UPDATE #tmp_lot SET LOT_INV_ID = INV.INV_ID
	FROM Inventory INV ,Lot
	WHERE INV.INV_ID = Lot.LOT_INV_ID
	and Lot.LOT_OnHandQty > 0
	and INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
	AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

	--更新批次表，存在的更新，不存在的新增
	UPDATE Lot SET Lot.LOT_OnHandQty = Convert(decimal(18,6),Lot.LOT_OnHandQty)+Convert(decimal(18,6),TMP.LOT_OnHandQty)
	FROM #tmp_lot AS TMP
	WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID 
	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID

	INSERT INTO Lot (LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID)
	SELECT LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID 
	FROM #tmp_lot AS TMP
	WHERE NOT EXISTS (SELECT 1 FROM Lot WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)

	--生成销售单
	--取得表头数据
	select newid() as HeaderId,CONVERT(NVARCHAR(100),'') as OrderNo,SNL_DMA_ID as DmaId,SNL_HOS_ID as HosId,
	SNL_BUM_ID as BumId,SNL_Remark as Remark,SNL_SaleType as SaleType,SNL_SaleDate as SaleDate,SNL_WriteOff as WriteOff,
	SNL_HospitalOffice as HospitalOffice, SNL_InvoiceNumber as InvoiceNumber, SNL_InvoiceTitle as InvoiceTitle,SNL_InvoiceDate as InvoiceDate,
	CONVERT(NVARCHAR(100),'') as BuName,SNL_ClientID
	into #tmp_header
	from (select SNL_DMA_ID,SNL_HOS_ID,SNL_BUM_ID,isnull(SNL_Remark,'') as SNL_Remark,SNL_SaleType,SNL_SaleDate,SNL_WriteOff,
	isnull(SNL_HospitalOffice,'') as SNL_HospitalOffice, isnull(SNL_InvoiceNumber,'') as SNL_InvoiceNumber, isnull(SNL_InvoiceTitle,'') as SNL_InvoiceTitle, 
	case when SNL_InvoiceDate='' then null else SNL_InvoiceDate end as SNL_InvoiceDate,SNL_ClientID
	FROM SalesNote 
	WHERE SNL_ProblemDescription IS NULL AND SalesNote.SNL_BatchNbr = @BatchNbr
	group by SNL_DMA_ID,SNL_HOS_ID,SNL_BUM_ID,SNL_Remark,SNL_SaleType,SNL_SaleDate,SNL_WriteOff,
	isnull(SNL_HospitalOffice,''), isnull(SNL_InvoiceNumber,''), isnull(SNL_InvoiceTitle,''), SNL_InvoiceDate,SNL_ClientID) as t
	

	--更新BUNAME
	UPDATE #tmp_header SET BuName = attribute_name
	from Lafite_ATTRIBUTE where Id in (
	select rootID from Cache_OrganizationUnits 
	where attributeID = Convert(varchar(36),#tmp_header.BumId))
	and ATTRIBUTE_TYPE = 'BU'

	--取得行数据
	select newid() AS LineId, h.HeaderId ,t.PmaId,t.ShipmentQty,t.LineNbr,
	--冗余字段
	t.DmaId,t.HosId,t.BumId,t.Remark,t.SaleType,t.SaleDate,t.WriteOff,
	t.HospitalOffice,t.InvoiceNumber,t.InvoiceTitle,t.InvoiceDate
	INTO #tmp_line
	from (select SNL_DMA_ID as DmaId,SNL_HOS_ID as HosId,SNL_PMA_ID as PmaId,SNL_BUM_ID as BumId,
	SNL_Remark as Remark,SNL_SaleType as SaleType,SNL_SaleDate as SaleDate,SNL_WriteOff as WriteOff,
	SNL_HospitalOffice as HospitalOffice, SNL_InvoiceNumber as InvoiceNumber, SNL_InvoiceTitle as InvoiceTitle,SNL_InvoiceDate as InvoiceDate,
	SUM(SNL_LotQty) AS ShipmentQty,
	row_number() OVER (PARTITION BY SNL_DMA_ID,SNL_HOS_ID,SNL_BUM_ID,SNL_Remark,SNL_SaleType,SNL_SaleDate,SNL_WriteOff,
	SNL_HospitalOffice, SNL_InvoiceNumber, SNL_InvoiceTitle, SNL_InvoiceDate
	ORDER BY SNL_DMA_ID,SNL_HOS_ID,SNL_BUM_ID,SNL_Remark,SNL_SaleType,SNL_SaleDate,SNL_WriteOff,
	SNL_HospitalOffice, SNL_InvoiceNumber, SNL_InvoiceTitle, SNL_InvoiceDate,
	SNL_PMA_ID) LineNbr 
	FROM SalesNote 
	WHERE SNL_ProblemDescription IS NULL AND SalesNote.SNL_BatchNbr = @BatchNbr
	group by SNL_DMA_ID,SNL_HOS_ID,SNL_PMA_ID,SNL_BUM_ID,SNL_Remark,SNL_SaleType,SNL_SaleDate,SNL_WriteOff,
	SNL_HospitalOffice, SNL_InvoiceNumber, SNL_InvoiceTitle, SNL_InvoiceDate) as t
	inner join #tmp_header h on h.DmaId = t.DmaId
	and h.HosId = t.HosId and h.BumId = t.BumId
	and ISNULL(h.Remark,'') = ISNULL(t.Remark,'') and h.SaleType = t.SaleType
	and h.SaleDate = t.SaleDate and h.WriteOff = t.WriteOff
	and ISNULL(h.HospitalOffice,'') = ISNULL(t.HospitalOffice,'') and ISNULL(h.InvoiceNumber,'') = ISNULL(t.InvoiceNumber,'') 
	and ISNULL(h.InvoiceTitle,'') = ISNULL(t.InvoiceTitle,'')
	and ISNULL(h.InvoiceDate,CONVERT(DATETIME,'19000101')) = ISNULL(t.InvoiceDate,CONVERT(DATETIME,'19000101'))

	--取得批次数据
	select newid() as DetailId, l.LineId, Lot.LOT_ID as LotId, a.SNL_WHM_ID as WhmId, a.SNL_LotQty as ShipmentQty,
	a.SNL_LotNumber as LotNumber, a.SNL_LTM_ID as LtmId, a.SNL_UnitPrice as UnitPrice
	,SNL_ShipmentDate as ShipmentDate
	,SNL_LotRemark as LotRemark
	into #tmp_detail
	from (select SNL_DMA_ID,SNL_HOS_ID,SNL_PMA_ID,SNL_BUM_ID,SNL_Remark,SNL_SaleType,SNL_SaleDate,SNL_WriteOff,
	SNL_HospitalOffice, SNL_InvoiceNumber, SNL_InvoiceTitle, SNL_InvoiceDate,SNL_LTM_ID,SNL_LotNumber,SNL_WHM_ID,SNL_UnitPrice ,SUM(SNL_LotQty) AS SNL_LotQty
	,SNL_ShipmentDate,SNL_LotRemark
	FROM SalesNote 
	WHERE SNL_ProblemDescription IS NULL AND SalesNote.SNL_BatchNbr = @BatchNbr
	group by SNL_DMA_ID,SNL_HOS_ID,SNL_PMA_ID,SNL_BUM_ID,SNL_Remark,SNL_SaleType,SNL_SaleDate,SNL_WriteOff,
	SNL_HospitalOffice, SNL_InvoiceNumber, SNL_InvoiceTitle, SNL_InvoiceDate,SNL_LTM_ID,SNL_LotNumber,SNL_WHM_ID,SNL_UnitPrice,SNL_ShipmentDate,SNL_LotRemark) as a
	INNER JOIN Lot ON Lot.LOT_LTM_ID = a.SNL_LTM_ID
	INNER JOIN Inventory INV ON INV.INV_ID = Lot.LOT_INV_ID AND INV.INV_WHM_ID = a.SNL_WHM_ID
	AND INV.INV_PMA_ID = a.SNL_PMA_ID
	inner join #tmp_line l on l.DmaId = a.SNL_DMA_ID
	and l.HosId = a.SNL_HOS_ID and l.BumId = a.SNL_BUM_ID
	and ISNULL(l.Remark,'') = ISNULL(a.SNL_Remark,'') and l.SaleType = a.SNL_SaleType
	and l.SaleDate = a.SNL_SaleDate and l.WriteOff = a.SNL_WriteOff
	and ISNULL(l.HospitalOffice,'') = ISNULL(a.SNL_HospitalOffice,'') and ISNULL(l.InvoiceNumber,'') = ISNULL(a.SNL_InvoiceNumber,'') 
	and ISNULL(l.InvoiceTitle,'') = ISNULL(a.SNL_InvoiceTitle,'')
	and ISNULL(l.InvoiceDate,CONVERT(DATETIME,'19000101')) = ISNULL(a.SNL_InvoiceDate,CONVERT(DATETIME,'19000101'))
	and l.PmaId = a.SNL_PMA_ID

	--生成单据号
	DECLARE @m_DmaId uniqueidentifier
	DECLARE @m_BuName nvarchar(20)
	DECLARE @m_Id uniqueidentifier
	DECLARE @m_OrderNo nvarchar(50)

	DECLARE	curHandleOrderNo CURSOR 
	FOR SELECT HeaderId,DmaId,BuName FROM #tmp_header

	OPEN curHandleOrderNo
	FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_BuName

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC [GC_GetNextAutoNumber] @m_DmaId,'Next_ShipmentNbr',@m_BuName, @m_OrderNo output
		UPDATE #tmp_header SET OrderNo = @m_OrderNo WHERE HeaderId = @m_Id
		FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_BuName
	END

	CLOSE curHandleOrderNo
	DEALLOCATE curHandleOrderNo

	--插入销售单数据
	INSERT INTO ShipmentHeader
	(
		SPH_ID,
		SPH_Hospital_HOS_ID,
		SPH_ShipmentNbr,
		SPH_Dealer_DMA_ID,
		SPH_ShipmentDate,
		SPH_Status,
		SPH_Reverse_SPH_ID,
		SPH_NoteForPumpSerialNbr,
		SPH_Type,
		SPH_ProductLine_BUM_ID,
		SPH_Shipment_User,
		SPH_InvoiceNo,
		SPH_UpdateDate,
		SPH_SubmitDate,
		SPH_Office,
		SPH_InvoiceTitle,
		SPH_InvoiceDate,
		SPH_IsAuth,
		SPH_InvoiceFirstDate
	)
	select HeaderId,HosId,OrderNo,DmaId,SaleDate,case WriteOff when 0 then 'Complete' else 'Reversed' end,null,Remark,
	case SaleType when '1' then 'Hospital' when '2' then 'Consignment' else 'Borrow' end,BumId,SNL_ClientID,InvoiceNumber,GETDATE(),getdate(),
	HospitalOffice,InvoiceTitle,InvoiceDate,1,
	CASE WHEN InvoiceNumber is null or LTRIM(RTRIM(InvoiceNumber)) = '' 
		THEN NULL 
		ELSE GETDATE() 
	END
	from #tmp_header

	INSERT INTO ShipmentLine
	(
		SPL_ID,
		SPL_SPH_ID,
		SPL_Shipment_PMA_ID,
		SPL_ShipmentQty,
		SPL_LineNbr
	)
	select LineId,HeaderId,PmaId,ShipmentQty,LineNbr
	from #tmp_line

	INSERT INTO ShipmentLot
	(
		SLT_SPL_ID,
		SLT_LotShippedQty,
		SLT_LOT_ID,
		SLT_ID,
		SLT_WHM_ID,
		SLT_UnitPrice,
		ShipmentDate,
		Remark
	)
	select LineId,ShipmentQty,LotId,DetailId,WhmId,UnitPrice,ShipmentDate,LotRemark
	from #tmp_detail
	--left join (select SPI_WHM_ID,LOT_ID,SPI_LotShipmentDate,SPI_Remark from ShipmentInit si,Inventory inv,Lot l 
	--	where si.SPI_WHM_ID = inv.INV_WHM_ID 
	--	and si.SPI_PMA_ID =inv.INV_PMA_ID 
	--	and inv.INV_ID = l.LOT_INV_ID 
	--	and si.SPI_LTM_ID = l.LOT_LTM_ID
	--	and si.SPI_USER= @UserId) SI
	--	on LotId = SI.LOT_ID AND WhmId = SI.SPI_WHM_ID
		
	--记录单据日志
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),HeaderId,@SysUserId,GETDATE(),'Generate',NULL
	FROM #tmp_header
	
	--记录库存日志
	SELECT -d.ShipmentQty as ITR_Quantity,
	NEWID() as ITR_ID,d.DetailId as ITR_ReferenceID,'销售出库' as ITR_Type,
	d.WhmId as ITR_WHM_ID,l.PmaId as ITR_PMA_ID,d.UnitPrice as ITR_UnitPrice,
	'销售出库单：' + h.OrderNo + ' 行：' + Convert(nvarchar(20),l.LineNbr) as ITR_TransDescription
	into #tmp_invtrans
	from #tmp_detail d
	inner join #tmp_line l on l.LineId = d.LineId
	inner join #tmp_header h on h.HeaderId = l.HeaderId

	select -d.ShipmentQty as ITL_Quantity,
	newid() as ITL_ID,t.ITR_ID as ITL_ITR_ID,
	d.LtmId as ITL_LTM_ID,d.LotNumber as ITL_LotNumber
	into #tmp_invtranslot
	from #tmp_detail d
	inner join #tmp_invtrans t on t.ITR_ReferenceID = d.DetailId

	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot
  
  --写入接口表
	insert into SalesInterface
	select newid(),'','', SPH_ID, SPH_ShipmentNbr,  'Pending','Manual',null,'00000000-0000-0000-0000-000000000000',getdate(),null,null,
	(select t2.CLT_ID from DealerMaster t1, client t2 where t1.DMA_Parent_DMA_ID=t2.CLT_Corp_Id and t1.DMA_ID=SPH_Dealer_DMA_ID  )
	from ShipmentHeader sph,#tmp_header th where SPH_ID = th.HeaderId and SPH_Type='Consignment' and SPH_Status in ('Complete','Reversed') and SPH_ID not in (select SI_SPH_ID from SalesInterface  )
	and SPH_SubmitDate>'2014-01-01 0:00:00'	
	
  --如果是寄售销售单或借货销售单，则根据经销商类型自动生成寄售销售订单和清指定批号订单
  --具体逻辑：如果是一级、二级经销商，且销售单类型是寄售销售，则
  DECLARE @P_HeaderId uniqueidentifier
  DECLARE @P_OrderNo nvarchar(MAX)
  DECLARE @P_DmaId uniqueidentifier
	DECLARE @P_SaleType nvarchar(20)
	DECLARE @P_BUName nvarchar(20)
	DECLARE @P_DealerType nvarchar(5)
  DECLARE @P_RtnVal nvarchar(20) 
	DECLARE @P_RtnMsg  nvarchar(MAX)
  
  DECLARE	curGenPurchaseOrder CURSOR 
	FOR SELECT distinct OrderNo=Replace(STUFF((   SELECT ';' + t3.OrderNo
          FROM #tmp_header t3 where SaleType = 2 and t3.BuName = t1.BuName
            FOR XML PATH('')), 1, 1, ''),';','##'),
            DmaId,BuName,SaleType,DMA_DealerType FROM #tmp_header t1,dealermaster t2 where t1.DmaId = t2.DMA_ID 

	OPEN curGenPurchaseOrder
	FETCH NEXT FROM curGenPurchaseOrder INTO @P_OrderNo,@P_DmaId,@P_BUName,@P_SaleType,@P_DealerType

	WHILE @@FETCH_STATUS = 0
	BEGIN
    IF ( @P_DealerType = 'T2' AND @P_SaleType='2')
      BEGIN    
			EXEC [GC_PurchaseOrder_AfterShipmentImport] @P_OrderNo,'ConsignmentSales',@P_RtnVal output, @P_RtnMsg output
		  END
      
		
    FETCH NEXT FROM curGenPurchaseOrder INTO @P_OrderNo,@P_DmaId,@P_BUName,@P_SaleType,@P_DealerType
	END

	CLOSE curGenPurchaseOrder
	DEALLOCATE curGenPurchaseOrder
	
	DECLARE	curGenPurchaseOrder2 CURSOR 
	FOR SELECT HeaderId,OrderNo,DmaId,SaleType,DMA_DealerType FROM #tmp_header t1,dealermaster t2 where t1.DmaId = t2.DMA_ID

	OPEN curGenPurchaseOrder2
	FETCH NEXT FROM curGenPurchaseOrder2 INTO @P_HeaderId,@P_OrderNo,@P_DmaId,@P_SaleType,@P_DealerType

	WHILE @@FETCH_STATUS = 0
	BEGIN
      IF (@P_DealerType = 'T1' AND @P_SaleType='2')
      BEGIN    
		    EXEC [GC_PurchaseOrder_AfterShipment] @P_OrderNo,'ConsignmentSales',@P_RtnVal output, @P_RtnMsg output
		  END
    IF (@P_DealerType in ('T1','LP') AND @P_SaleType='3')
      BEGIN    
		    EXEC [GC_PurchaseOrder_AfterShipment] @P_OrderNo,'ClearBorrow',@P_RtnVal output, @P_RtnMsg output
		  END
		
    FETCH NEXT FROM curGenPurchaseOrder2 INTO @P_HeaderId,@P_OrderNo,@P_DmaId,@P_SaleType,@P_DealerType
	END

	CLOSE curGenPurchaseOrder2
	DEALLOCATE curGenPurchaseOrder2
  
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
	set @vError = '2行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
    
END CATCH



GO


