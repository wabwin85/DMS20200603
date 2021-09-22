DROP PROCEDURE [interface].[P_I_EW_QACRMDealerComplain_Lock]
GO

CREATE PROCEDURE [interface].[P_I_EW_QACRMDealerComplain_Lock]
@DMSBSCCode nvarchar(20), @Status nvarchar(20), @CarrierNumber nvarchar(50), @UserId uniqueidentifier, @InstanceId uniqueidentifier, @DNNumber nvarchar(50), @PI nvarchar(200), @IAN nvarchar(200)
WITH EXEC AS CALLER
AS
DECLARE @SysUserId uniqueidentifier	
  DECLARE @OrderId uniqueidentifier	
  DECLARE @BatchNbr NVARCHAR(30)
  DECLARE @EmptyGuid UNIQUEIDENTIFIER
  DECLARE @SystemHoldWarehouseID UNIQUEIDENTIFIER
  DECLARE @WHMID NVARCHAR(200)
  DECLARE @RETURNNUM NVARCHAR(200)
  DECLARE @CorpId UNIQUEIDENTIFIER
  DECLARE @UPN NVARCHAR(200)
  DECLARE @LOT NVARCHAR(200)
  DECLARE @WHMTYPE NVARCHAR(200)  --仓库类型-物权
  DECLARE @DMATYPE NVARCHAR(200)  --经销商类型
  DECLARE @ReturnType NVARCHAR(30) --投诉类型
  DECLARE @ParentDMAID UNIQUEIDENTIFIER
  DECLARE @m_DmaId uniqueidentifier
	DECLARE @m_ProductLine uniqueidentifier
	DECLARE @m_Id uniqueidentifier
	DECLARE @m_OrderNo nvarchar(50)
	DECLARE @m_BU nvarchar(20)
	declare @PONumber nvarchar(20);
SET NOCOUNT ON

BEGIN TRY
	SET @BatchNbr = ''
  EXEC dbo.GC_GetNextAutoNumberForInt 'SYS','P_I_EW_QABSCDealerComplain_Lock',@BatchNbr OUTPUT
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
  SET @EmptyGuid = '00000000-0000-0000-0000-000000000000'
  if @InstanceId is null
     SET @InstanceId = '00000000-0000-0000-0000-000000000000'
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
     LOT_OnHandQty  FLOAT,
     LOT_LotNumber  NVARCHAR (50) COLLATE Chinese_PRC_CI_AS,
     PRIMARY KEY (LOT_ID)
  )
  
  CREATE TABLE #tmp_invtrans (
    [ITR_Quantity] float NOT NULL,
    [ITR_ID] uniqueidentifier NOT NULL,
    [ITR_ReferenceID] uniqueidentifier NOT NULL,
    [ITR_Type] nvarchar(50) NOT NULL,
    [ITR_WHM_ID] uniqueidentifier NOT NULL,
    [ITR_PMA_ID] uniqueidentifier NOT NULL,
    [ITR_UnitPrice] float NOT NULL,
    [ITR_TransDescription] nvarchar(200) NULL)

  CREATE TABLE #tmp_invtranslot (
    [ITL_Quantity] float NOT NULL,
    [ITL_ID] uniqueidentifier NOT NULL,
    [ITL_ITR_ID] uniqueidentifier NOT NULL,
    [ITL_LTM_ID] uniqueidentifier NOT NULL,
    [ITL_LotNumber] nvarchar(50) NOT NULL)
  
create table #tmp_PurchaseOrderHeader (
   POH_ID               uniqueidentifier     not null,
   POH_OrderNo          nvarchar(30)         collate Chinese_PRC_CI_AS null,
   POH_ProductLine_BUM_ID uniqueidentifier     null,
   POH_DMA_ID           uniqueidentifier     null,
   POH_VendorID         nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_TerritoryCode    nvarchar(200)        null,
   POH_RDD              datetime             null,
   POH_ContactPerson    nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_Contact          nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_ContactMobile    nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_Consignee        nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_ShipToAddress    nvarchar(200)        collate Chinese_PRC_CI_AS null,
   POH_ConsigneePhone   nvarchar(200)        collate Chinese_PRC_CI_AS null,
   POH_Remark           nvarchar(400)        collate Chinese_PRC_CI_AS null,
   POH_InvoiceComment   nvarchar(200)        null,
   POH_CreateType       nvarchar(20)         not null,
   POH_CreateUser       uniqueidentifier     not null,
   POH_CreateDate       datetime             not null,
   POH_UpdateUser       uniqueidentifier     null,
   POH_UpdateDate       datetime             null,
   POH_SubmitUser       uniqueidentifier     null,
   POH_SubmitDate       datetime             null,
   POH_LastBrowseUser   uniqueidentifier     null,
   POH_LastBrowseDate   datetime             null,
   POH_OrderStatus      nvarchar(20)         collate Chinese_PRC_CI_AS not null,
   POH_LatestAuditDate  datetime             null,
   POH_IsLocked         bit                  not null,
   POH_SAP_OrderNo      nvarchar(50)         null,
   POH_SAP_ConfirmDate  datetime             null,
   POH_LastVersion      int                  not null,
   POH_OrderType nvarchar(50) null,
   POH_VirtualDC nvarchar(50) null,
   POH_SpecialPriceID uniqueidentifier null,
   POH_WHM_ID uniqueidentifier null,
   POH_POH_ID uniqueidentifier null,
   primary key nonclustered (POH_ID)
)

  create table #tmp_PurchaseOrderDetail (
   POD_ID               uniqueidentifier     not null,
   POD_POH_ID           uniqueidentifier     not null,
   POD_CFN_ID           uniqueidentifier     not null,
   POD_CFN_Price        decimal(18,6)        null,
   POD_UOM              nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POD_RequiredQty      decimal(18,6)        null,
   POD_Amount           decimal(18,6)        null,
   POD_Tax              decimal(18,6)        null,
   POD_ReceiptQty       decimal(18,6)        null,
   POD_Status           nvarchar(50)         collate Chinese_PRC_CI_AS null,
   POD_LotNumber		nvarchar(50)		 null,
   primary key nonclustered (POD_ID)
)

	create table #ShipmentToHos(
	UPN nvarchar(100) null,           --预先写入
	LOT nvarchar(100) null,           --预先写入
	Qty decimal(18,2) null,           --预先写入
	HospitalCode nvarchar(100) null,  --预先写入
	DMA_SAP_Code nvarchar(100) null,  --预先写入
	WHM_Code nvarchar(100) null,      --预先写入
	ADJ_Type nvarchar(100) null,    --预先写入
	ADJ_Reason nvarchar(100) null,    --预先写入
	InputTime Datetime null,           --预先写入
	NewShipmentNbr nvarchar(100) null, --预先写入（人工分配）
	SPH_Status nvarchar(100) null,    --固定为Complete
	SPH_ShipmentDate datetime null,   --预先写入 
	SPH_ID uniqueidentifier null,
	HOS_ID uniqueidentifier null,
	DMA_ID uniqueidentifier null,
	SPL_ID uniqueidentifier null,
	PMA_ID uniqueidentifier null,
	LineNbr int null,
	SLT_ID uniqueidentifier null,
	LOT_ID uniqueidentifier null,
	WHM_ID uniqueidentifier null,
	Unit_Price decimal(18,2) null
	)
	
BEGIN TRAN

INSERT INTO dbo.tmp_dealercomplainsave
SELECT NEWID(),NEWID(),NEWID(),@DMSBSCCode+';'+@Status+';'+isnull(@DNNumber,''),GETDATE()

	  --根据退货单号查询单据是否存在，且单据状态必须是待审批
    IF (@DMSBSCCode IS NULL AND @InstanceId IS NULL)
      RAISERROR ('单据ID不存在',16,1);
      
    SELECT @OrderId = DC_ID FROM dbo.DealerComplainCRM WHERE ((DC_ComplainNbr = @DMSBSCCode OR @DMSBSCCode IS NULL) OR (DC_ID = @InstanceId OR @InstanceId IS NULL) or (EFInstanceCode = @DMSBSCCode) ) 
    IF @@ROWCOUNT = 0
	    RAISERROR ('QA投诉退货单号不存在或单据已被处理',16,1);
	 
    BEGIN 
    
		if(isnull(@DMSBSCCode,'') = '')
		begin
			select @DMSBSCCode =  DC_ComplainNbr from dbo.DealerComplainCRM where DC_ID = @InstanceId
		end
		
      SELECT @OrderId = DC_ID,@CorpId = DC_CorpId,@RETURNNUM = 1,@UPN = Serial,@LOT = LOT ,@WHMID= dc.WHMID ,@WHMTYPE = WHM_Type,@DMATYPE = DMA_DealerType,@ReturnType=CASE WHEN CONFIRMRETURNTYPE IS NULL THEN RETURNTYPE ELSE CONFIRMRETURNTYPE END
		FROM dbo.DealerComplainCRM dc
		LEFT JOIN Warehouse wh ON dc.WHMID = wh.WHM_ID
		LEFT JOIN DealerMaster dm ON  dc.DC_CorpId = dm.DMA_ID 
		where  (DC_ComplainNbr = @DMSBSCCode  OR EFInstanceCode = @DMSBSCCode)
      SELECT @SystemHoldWarehouseID = WHM_ID FROM Warehouse WHERE WHM_DMA_ID = @CorpId and WHM_Type='SystemHold' and WHM_ActiveFlag=1
  
          
      IF @Status = 'Accept'
         BEGIN
           --修改状态
           UPDATE dbo.DealerComplainCRM set DC_Status='Accept' where DC_ID = @OrderId  --投诉已收到
           
           --记录单据日志
        	 INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
        	 VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Submit','eWorkflow提交投诉退货申请')
           
           --发送邮件(发给二级经销商)
           INSERT INTO MailMessageQueue
           SELECT newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#UploadNo}',DC_ComplainNbr),
                   replace(replace(replace(MMT_Body,'{#UploadNo}',DC_ComplainNbr),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),getdate(),20)) AS MMT_Body,
                   'Waiting',getdate(),null
             from DealerComplainCRM t1, dealermaster t2, MailMessageTemplate t3,
                  (
                    select isnull(t1.EMAIL1,t1.EMAIL2) AS MDA_MailAddress
                     from Lafite_IDENTITY t1,(select DC_ComplainNbr,EID,DC_CorpId from DealerComplainCRM where DC_ComplainNbr=@DMSBSCCode) t2
                    where ((t1.Id = t2.EID)  or (t1.Corp_ID = t2.DC_CorpId and t1.IDENTITY_CODE like '%_01'))
                    and t1.BOOLEAN_FLAG=1 and (t1.EMAIL1 is not null OR t1.EMAIL2 is not null) and (len(t1.EMAIL1) > 1 OR len(t1.EMAIL2)>0)
                  ) t4
            where DC_ComplainNbr=@DMSBSCCode and t1.DC_CorpId=t2.DMA_ID
              and t3.MMT_Code='EMAIL_QACOMPLAIN_APPLYACCEPT'
           
           IF(ISNULL(@DNNumber,'') <> '')
            BEGIN
				IF(@WHMID <> '00000000-0000-0000-0000-000000000000')
				-- 库存操作
				Begin
				--库存操作
				select @SystemHoldWarehouseID = WHM_ID  from Warehouse where WHM_DMA_ID=@CorpId and WHM_Type='SystemHold' and WHM_ActiveFlag=1
				IF (@SystemHoldWarehouseID IS NULL)
				  RAISERROR ('无法获取经销商的在途仓库', 16, 1)
		         
				--Inventory表(从选择的仓库中扣减库存)
				INSERT INTO #tmp_inventory (INV_OnHandQuantity,
											INV_ID,
											INV_WHM_ID,
											INV_PMA_ID)
				   SELECT -Convert(decimal(18,2),@RETURNNUM), NEWID () AS INV_ID, 
						  Convert(UNIQUEIDENTIFIER, @WHMID) AS WHM_ID, PMA_ID
					 FROM Product
					WHERE PMA_UPN = @UPN
		  



				--Inventory表(在经销商的中间仓库中增加库存)
				INSERT INTO #tmp_inventory (INV_OnHandQuantity,
											INV_ID,
											INV_WHM_ID,
											INV_PMA_ID)
				   SELECT Convert(decimal(18,2),@RETURNNUM),
						  NEWID () AS INV_ID,
						  @SystemHoldWarehouseID AS WHM_ID,
						  PMA_ID
					 FROM Product
					WHERE PMA_UPN = @UPN
		            
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
							  FROM   Inventory INV
							  WHERE      INV.INV_WHM_ID = TMP.INV_WHM_ID
									 AND INV.INV_PMA_ID = TMP.INV_PMA_ID)

				--记录库存操作日志
				--Inventory表
				INSERT INTO #tmp_invtrans
				SELECT inv.INV_OnHandQuantity AS ITR_Quantity,
					   NEWID () AS ITR_ID,
					   @EmptyGuid AS ITR_ReferenceID,
					   '经销商投诉换货' AS ITR_Type,
					   inv.INV_WHM_ID AS ITR_WHM_ID,
					   inv.INV_PMA_ID AS ITR_PMA_ID,
					   0 AS ITR_UnitPrice,
					   NULL AS ITR_TransDescription
				FROM   #tmp_inventory AS inv


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


				--Lot表(从仓库中扣减库存)
				INSERT INTO #tmp_lot (LOT_ID,
									  LOT_LTM_ID,
									  LOT_WHM_ID,
									  LOT_PMA_ID,
									  LOT_LotNumber,
									  LOT_OnHandQty)         
					SELECT NEWID (),LM.LTM_ID,
						   Convert(UNIQUEIDENTIFIER, @WHMID) AS WHM_ID,
						   P.PMA_ID,
						   LM.LTM_LotNumber,
						   -Convert(decimal(18,2),@RETURNNUM)
	        			  FROM LotMaster LM, Product P
	        			 WHERE P.PMA_ID = LM.LTM_Product_PMA_ID 
					   AND LM.LTM_LotNumber = @LOT
					   AND P.PMA_UPN = @UPN
			        	          	      

				--Lot表(在在途仓库中增加库存)
				INSERT INTO #tmp_lot (LOT_ID,
									  LOT_LTM_ID,
									  LOT_WHM_ID,
									  LOT_PMA_ID,
									  LOT_LotNumber,
									  LOT_OnHandQty)
				   SELECT  NEWID (),LM.LTM_ID,
						   @SystemHoldWarehouseID AS WHM_ID,
						   P.PMA_ID,
						   LM.LTM_LotNumber,
						   Convert(decimal(18,2),@RETURNNUM)
	        			  FROM LotMaster LM, Product P
	        			 WHERE P.PMA_ID = LM.LTM_Product_PMA_ID 
					   AND LM.LTM_LotNumber = @LOT
					   AND P.PMA_UPN = @UPN

				--更新关联库存主键
				UPDATE #tmp_lot
				SET    LOT_INV_ID = INV.INV_ID
				FROM   Inventory INV
				WHERE      INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
					   AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

				--更新批次表,存在的更新,不存在的新增
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
							  FROM   Lot
							  WHERE      Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
									 AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)


				--记录库存操作日志
				--Lot表
				INSERT INTO #tmp_invtranslot
				SELECT lot.LOT_OnHandQty AS ITL_Quantity,
					   newid () AS ITL_ID,
					   itr.ITR_ID AS ITL_ITR_ID,
					   lot.LOT_LTM_ID AS ITL_LTM_ID,
					   lot.LOT_LotNumber AS ITL_LotNumber
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
		        
		            
				END
            END
           
         END
         
      IF @Status = 'REJECT'
         BEGIN
           --修改状态
           UPDATE dbo.DealerComplainCRM set DC_Status='Reject' where DC_ID = @OrderId  --审批拒绝
           
           --记录单据日志
        	 INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
        	 VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Submit','eWorkflow审批拒绝投诉退货申请')
           
           --发送邮件(发给二级经销商)
           INSERT INTO MailMessageQueue
           SELECT newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#UploadNo}',DC_ComplainNbr),
                   replace(replace(replace(MMT_Body,'{#UploadNo}',DC_ComplainNbr),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),getdate(),20)) AS MMT_Body,
                   'Waiting',getdate(),null
             from DealerComplainCRM t1, dealermaster t2, MailMessageTemplate t3,
                  (
                    select isnull(t1.EMAIL1,t1.EMAIL2) AS MDA_MailAddress
                     from Lafite_IDENTITY t1,(select DC_ComplainNbr,EID,DC_CorpId from DealerComplainCRM where DC_ComplainNbr=@DMSBSCCode) t2
                    where ((t1.Id = t2.EID)  or (t1.Corp_ID = t2.DC_CorpId and t1.IDENTITY_CODE like '%_01'))
                    and t1.BOOLEAN_FLAG=1 and (t1.EMAIL1 is not null OR t1.EMAIL2 is not null) and (len(t1.EMAIL1) > 1 OR len(t1.EMAIL2)>0)
                  ) t4
            where DC_ComplainNbr=@DMSBSCCode and t1.DC_CorpId=t2.DMA_ID
              and t3.MMT_Code='EMAIL_QACOMPLAIN_REJECT'
              
           IF (@WHMID <> '00000000-0000-0000-0000-000000000000')
			BEGIN
            --库存操作
            IF (@SystemHoldWarehouseID IS NULL)
              RAISERROR ('无法获取经销商的在途仓库', 16, 1)
             
            --Inventory表(从选择的仓库中增加库存)
            INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                        INV_ID,
                                        INV_WHM_ID,
                                        INV_PMA_ID)
               SELECT Convert(decimal(18,2),@RETURNNUM), NEWID () AS INV_ID, 
                      Convert(UNIQUEIDENTIFIER, @WHMID) AS WHM_ID, PMA_ID
                 FROM Product
                WHERE PMA_UPN = @UPN
      
            --Inventory表(在经销商的中间仓库中扣减库存)
            INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                        INV_ID,
                                        INV_WHM_ID,
                                        INV_PMA_ID)
               SELECT -Convert(decimal(18,2),@RETURNNUM),
                      NEWID () AS INV_ID,
                      @SystemHoldWarehouseID AS WHM_ID,
                      PMA_ID
                 FROM Product
                WHERE PMA_UPN = @UPN
                
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
                          FROM   Inventory INV
                          WHERE      INV.INV_WHM_ID = TMP.INV_WHM_ID
                                 AND INV.INV_PMA_ID = TMP.INV_PMA_ID)

            --记录库存操作日志
            --Inventory表
            INSERT INTO #tmp_invtrans
            SELECT inv.INV_OnHandQuantity AS ITR_Quantity,
                   NEWID () AS ITR_ID,
                   @EmptyGuid AS ITR_ReferenceID,
                   '经销商投诉换货' AS ITR_Type,
                   inv.INV_WHM_ID AS ITR_WHM_ID,
                   inv.INV_PMA_ID AS ITR_PMA_ID,
                   0 AS ITR_UnitPrice,
                   NULL AS ITR_TransDescription
            --INTO   #tmp_invtrans
            FROM   #tmp_inventory AS inv


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


            --Lot表(从仓库中增加库存)
            INSERT INTO #tmp_lot (LOT_ID,
                                  LOT_LTM_ID,
                                  LOT_WHM_ID,
                                  LOT_PMA_ID,
                                  LOT_LotNumber,
                                  LOT_OnHandQty)         
                SELECT NEWID (),LM.LTM_ID,
                       Convert(UNIQUEIDENTIFIER, @WHMID) AS WHM_ID,
                       P.PMA_ID,
                       LM.LTM_LotNumber,
                       Convert(decimal(18,2),@RETURNNUM)
    	        	  FROM LotMaster LM, Product P
    	        	 WHERE P.PMA_ID = LM.LTM_Product_PMA_ID 
                   AND LM.LTM_LotNumber = @LOT
                   AND P.PMA_UPN = @UPN
    	        	          	      

            --Lot表(在在途仓库中扣减库存)
            INSERT INTO #tmp_lot (LOT_ID,
                                  LOT_LTM_ID,
                                  LOT_WHM_ID,
                                  LOT_PMA_ID,
                                  LOT_LotNumber,
                                  LOT_OnHandQty)
               SELECT  NEWID (),LM.LTM_ID,
                       @SystemHoldWarehouseID AS WHM_ID,
                       P.PMA_ID,
                       LM.LTM_LotNumber,
                       -Convert(decimal(18,2),@RETURNNUM)
    	        	  FROM LotMaster LM, Product P
    	        	 WHERE P.PMA_ID = LM.LTM_Product_PMA_ID 
                   AND LM.LTM_LotNumber = @LOT
                   AND P.PMA_UPN = @UPN

            --更新关联库存主键
            UPDATE #tmp_lot
            SET    LOT_INV_ID = INV.INV_ID
            FROM   Inventory INV
            WHERE      INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
                   AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

            --更新批次表,存在的更新,不存在的新增
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
                          FROM   Lot
                          WHERE      Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
                                 AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)


            --记录库存操作日志
            --Lot表
            INSERT INTO #tmp_invtranslot
            SELECT lot.LOT_OnHandQty AS ITL_Quantity,
                   newid () AS ITL_ID,
                   itr.ITR_ID AS ITL_ITR_ID,
                   lot.LOT_LTM_ID AS ITL_LTM_ID,
                   lot.LOT_LotNumber AS ITL_LotNumber
            --INTO   #tmp_invtranslot
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
            END
           
         END

      IF @Status = 'Revoke'
         BEGIN
           --修改状态
           UPDATE dbo.DealerComplainCRM set DC_Status='Revoked' WHERE DC_ID=@InstanceId  --经销商撤销
           
           --记录单据日志
        	 INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
        	 VALUES (NEWID(),@InstanceId,@SysUserId,GETDATE(),'Submit','经销商撤销申请，状态修改为：已撤销')
           
           
            IF (@WHMID <> '00000000-0000-0000-0000-000000000000' and @InstanceId is not null)
           BEGIN
            --库存操作
            IF (@SystemHoldWarehouseID IS NULL)
              RAISERROR ('无法获取经销商的在途仓库', 16, 1)
             
            --Inventory表(从选择的仓库中增加库存)
            INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                        INV_ID,
                                        INV_WHM_ID,
                                        INV_PMA_ID)
               SELECT Convert(decimal(18,2),@RETURNNUM), NEWID () AS INV_ID, 
                      Convert(UNIQUEIDENTIFIER, @WHMID) AS WHM_ID, PMA_ID
                 FROM Product
                WHERE PMA_UPN = @UPN
      



            --Inventory表(在经销商的中间仓库中扣减库存)
            INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                        INV_ID,
                                        INV_WHM_ID,
                                        INV_PMA_ID)
               SELECT -Convert(decimal(18,2),@RETURNNUM),
                      NEWID () AS INV_ID,
                      @SystemHoldWarehouseID AS WHM_ID,
                      PMA_ID
                 FROM Product
                WHERE PMA_UPN = @UPN
                
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
                          FROM   Inventory INV
                          WHERE      INV.INV_WHM_ID = TMP.INV_WHM_ID
                                 AND INV.INV_PMA_ID = TMP.INV_PMA_ID)

            --记录库存操作日志
            --Inventory表
            INSERT INTO #tmp_invtrans
            SELECT inv.INV_OnHandQuantity AS ITR_Quantity,
                   NEWID () AS ITR_ID,
                   @EmptyGuid AS ITR_ReferenceID,
                   '经销商投诉换货' AS ITR_Type,
                   inv.INV_WHM_ID AS ITR_WHM_ID,
                   inv.INV_PMA_ID AS ITR_PMA_ID,
                   0 AS ITR_UnitPrice,
                   NULL AS ITR_TransDescription
            --INTO   #tmp_invtrans
            FROM   #tmp_inventory AS inv


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


            --Lot表(从仓库中增加库存)
            INSERT INTO #tmp_lot (LOT_ID,
                                  LOT_LTM_ID,
                                  LOT_WHM_ID,
                                  LOT_PMA_ID,
                                  LOT_LotNumber,
                                  LOT_OnHandQty)         
                SELECT NEWID (),LM.LTM_ID,
                       Convert(UNIQUEIDENTIFIER, @WHMID) AS WHM_ID,
                       P.PMA_ID,
                       LM.LTM_LotNumber,
                       Convert(decimal(18,2),@RETURNNUM)
    	        	  FROM LotMaster LM, Product P
    	        	 WHERE P.PMA_ID = LM.LTM_Product_PMA_ID 
                   AND LM.LTM_LotNumber = @LOT
                   AND P.PMA_UPN = @UPN
    	        	          	      

            --Lot表(在在途仓库中扣减库存)
            INSERT INTO #tmp_lot (LOT_ID,
                                  LOT_LTM_ID,
                                  LOT_WHM_ID,
                                  LOT_PMA_ID,
                                  LOT_LotNumber,
                                  LOT_OnHandQty)
               SELECT  NEWID (),LM.LTM_ID,
                       @SystemHoldWarehouseID AS WHM_ID,
                       P.PMA_ID,
                       LM.LTM_LotNumber,
                       -Convert(decimal(18,2),@RETURNNUM)
    	        	  FROM LotMaster LM, Product P
    	        	 WHERE P.PMA_ID = LM.LTM_Product_PMA_ID 
                   AND LM.LTM_LotNumber = @LOT
                   AND P.PMA_UPN = @UPN

            --更新关联库存主键
            UPDATE #tmp_lot
            SET    LOT_INV_ID = INV.INV_ID
            FROM   Inventory INV
            WHERE      INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
                   AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

            --更新批次表,存在的更新,不存在的新增
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
                          FROM   Lot
                          WHERE      Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
                                 AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)


            --记录库存操作日志
            --Lot表
            INSERT INTO #tmp_invtranslot
            SELECT lot.LOT_OnHandQty AS ITL_Quantity,
                   newid () AS ITL_ID,
                   itr.ITR_ID AS ITL_ITR_ID,
                   lot.LOT_LTM_ID AS ITL_LTM_ID,
                   lot.LOT_LotNumber AS ITL_LotNumber
            --INTO   #tmp_invtranslot
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
            END
           
           
         END 
      
      IF @Status = 'Confirmed'
         BEGIN
            --修改状态
            UPDATE dbo.DealerComplainCRM set DC_Status='Confirmed', PI=@PI, IAN=@IAN where DC_ID = @OrderId  --投诉已确认，请经销商返回投诉产品  
           
            --记录单据日志
          	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
          	VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Submit','eWorkflow修改状态为:投诉已确认，请返回投诉产品,PI投诉号：'+isnull(@PI,'') + ';IAN投诉号：' + isnull(@IAN,''))
             
            
            --发送邮件(发给二级经销商)
           INSERT INTO MailMessageQueue
           SELECT newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#UploadNo}',@DMSBSCCode),
                   replace(replace(replace(MMT_Body,'{#UploadNo}','PI投诉号：'+isnull(@PI,'') + ';IAN投诉号：' + isnull(@IAN,'')),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),getdate(),20)) AS MMT_Body,
                   'Waiting',getdate(),null
             from DealerComplainCRM t1, dealermaster t2, MailMessageTemplate t3,
                  (
                    select isnull(t1.EMAIL1,t1.EMAIL2) AS MDA_MailAddress
                     from Lafite_IDENTITY t1,(select DC_ComplainNbr,EID,DC_CorpId from DealerComplainCRM where DC_ComplainNbr=@DMSBSCCode) t2
                    where ((t1.Id = t2.EID)  or (t1.Corp_ID = t2.DC_CorpId and t1.IDENTITY_CODE like '%_01'))
                    and t1.BOOLEAN_FLAG=1 and (t1.EMAIL1 is not null OR t1.EMAIL2 is not null) and (len(t1.EMAIL1) > 1 OR len(t1.EMAIL2)>0)
                  ) t4
            where DC_ComplainNbr=@DMSBSCCode and t1.DC_CorpId=t2.DMA_ID
              and t3.MMT_Code='EMAIL_QACOMPLAIN_CONFIRMED'
           
          END
         
      IF @Status = 'SampleReceived'
         BEGIN
           --修改状态
           UPDATE dbo.DealerComplainCRM set DC_Status='SampleReceived' where DC_ID = @OrderId  --投诉产品已收到
           
           --记录单据日志
        	 INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
        	 VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Submit','eWorkflow修改状态为：投诉产品已收到')
           
           --发送邮件
           INSERT INTO MailMessageQueue
           SELECT newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#UploadNo}',DC_ComplainNbr),
                   replace(replace(replace(MMT_Body,'{#UploadNo}',DC_ComplainNbr),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),getdate(),20)) AS MMT_Body,
                   'Waiting',getdate(),null
             from DealerComplainCRM t1, dealermaster t2, MailMessageTemplate t3,
                  (
                    select isnull(t1.EMAIL1,t1.EMAIL2) AS MDA_MailAddress
                     from Lafite_IDENTITY t1,(select DC_ComplainNbr,EID,DC_CorpId from DealerComplainCRM where DC_ComplainNbr=@DMSBSCCode) t2
                    where ((t1.Id = t2.EID)  or (t1.Corp_ID = t2.DC_CorpId and t1.IDENTITY_CODE like '%_01'))
                    and t1.BOOLEAN_FLAG=1 and (t1.EMAIL1 is not null OR t1.EMAIL2 is not null) and (len(t1.EMAIL1) > 1 OR len(t1.EMAIL2)>0)
                  ) t4
            where DC_ComplainNbr=@DMSBSCCode and t1.DC_CorpId=t2.DMA_ID
              and t3.MMT_Code='EMAIL_QACOMPLAIN_RECEIVEGOODS'
           /*   
           BEGIN
            --库存操作
            select @CorpId= DC_CorpId,@UPN= Serial,@LOT= LOT,@RETURNNUM= 1,@WHMID= WHMID from dbo.DealerComplainCRM where DC_ID = @OrderId            
            
            select @SystemHoldWarehouseID = WHM_ID  from Warehouse where WHM_DMA_ID=@CorpId and WHM_Type='SystemHold' and WHM_ActiveFlag=1
            IF (@SystemHoldWarehouseID IS NULL)
              RAISERROR ('无法获取经销商的在途仓库', 16, 1)
             
            --Inventory表(在经销商的中间仓库中扣减库存)
            INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                        INV_ID,
                                        INV_WHM_ID,
                                        INV_PMA_ID)
               SELECT -Convert(decimal(18,2),@RETURNNUM),
                      NEWID () AS INV_ID,
                      @SystemHoldWarehouseID AS WHM_ID,
                      PMA_ID
                 FROM Product
                WHERE PMA_UPN = @UPN
                
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
                          FROM   Inventory INV
                          WHERE      INV.INV_WHM_ID = TMP.INV_WHM_ID
                                 AND INV.INV_PMA_ID = TMP.INV_PMA_ID)

            --记录库存操作日志
            --Inventory表
            INSERT INTO #tmp_invtrans
            SELECT inv.INV_OnHandQuantity AS ITR_Quantity,
                   NEWID () AS ITR_ID,
                   @EmptyGuid AS ITR_ReferenceID,
                   '经销商投诉换货' AS ITR_Type,
                   inv.INV_WHM_ID AS ITR_WHM_ID,
                   inv.INV_PMA_ID AS ITR_PMA_ID,
                   0 AS ITR_UnitPrice,
                   NULL AS ITR_TransDescription
            --INTO   #tmp_invtrans
            FROM   #tmp_inventory AS inv

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

            --Lot表(在在途仓库中扣减库存)
            INSERT INTO #tmp_lot (LOT_ID,
                                  LOT_LTM_ID,
                                  LOT_WHM_ID,
                                  LOT_PMA_ID,
                                  LOT_LotNumber,
                                  LOT_OnHandQty)
               SELECT  NEWID (),LM.LTM_ID,
                       @SystemHoldWarehouseID AS WHM_ID,
                       P.PMA_ID,
                       LM.LTM_LotNumber,
                       -Convert(decimal(18,2),@RETURNNUM)
    	        	  FROM LotMaster LM, Product P
    	        	 WHERE P.PMA_ID = LM.LTM_Product_PMA_ID 
                   AND LM.LTM_LotNumber = @LOT
                   AND P.PMA_UPN = @UPN

            --更新关联库存主键
            UPDATE #tmp_lot
            SET    LOT_INV_ID = INV.INV_ID
            FROM   Inventory INV
            WHERE      INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
                   AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

            --更新批次表,存在的更新,不存在的新增
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
                          FROM   Lot
                          WHERE      Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
                                 AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)


            --记录库存操作日志
            --Lot表
            INSERT INTO #tmp_invtranslot
            SELECT lot.LOT_OnHandQty AS ITL_Quantity,
                   newid () AS ITL_ID,
                   itr.ITR_ID AS ITL_ITR_ID,
                   lot.LOT_LTM_ID AS ITL_LTM_ID,
                   lot.LOT_LotNumber AS ITL_LotNumber
            --INTO   #tmp_invtranslot
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
            END
           */
         END    
      
      IF @Status = 'CSConfirmed'
         BEGIN
            --修改状态
            UPDATE dbo.DealerComplainCRM set CONFIRMRETURNTYPE=@DNNumber where DC_ID = @OrderId  --投诉已确认，请经销商返回投诉产品  
           
            --记录单据日志
          	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
          	VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Submit','eWorkflow确认投诉换货类型')
           
          END
         
      IF @Status = 'Delivered'
         BEGIN
           --修改状态                              
           UPDATE dbo.DealerComplainCRM set DC_Status='Delivered', DN = @DNNumber where DC_ID = @OrderId  --波科货物已发送
           
           --记录单据日志
        	 INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
        	 VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Submit','eWorkflow修改状态为：波科已换货给平台/T1')
           
           --发送邮件
           INSERT INTO MailMessageQueue
           SELECT newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#UploadNo}',DC_ComplainNbr),
                   replace(replace(replace(MMT_Body,'{#UploadNo}',DC_ComplainNbr),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),getdate(),20)) AS MMT_Body,
                   'Waiting',getdate(),null
             from DealerComplainCRM t1, dealermaster t2, MailMessageTemplate t3,
                  (
                    select isnull(t1.EMAIL1,t1.EMAIL2) AS MDA_MailAddress
                     from Lafite_IDENTITY t1,(select DC_ComplainNbr,EID,DC_CorpId from DealerComplainCRM where DC_ComplainNbr=@DMSBSCCode) t2
                    where ((t1.Id = t2.EID)  or (t1.Corp_ID = t2.DC_CorpId and t1.IDENTITY_CODE like '%_01'))
                    and t1.BOOLEAN_FLAG=1 and (t1.EMAIL1 is not null OR t1.EMAIL2 is not null) and (len(t1.EMAIL1) > 1 OR len(t1.EMAIL2)>0)
                  ) t4
            where DC_ComplainNbr=@DMSBSCCode and t1.DC_CorpId=t2.DMA_ID
              and t3.MMT_Code='EMAIL_QACOMPLAIN_GOODSDELIVERED'
              
   --         IF (@WHMID <> '00000000-0000-0000-0000-000000000000')
   --     	    BEGIN
   --     		 if(@ReturnType <> '3')
   --     		 BEGIN    
   --     				--Inventory表(在经销商的中间仓库中扣减库存)
   --     				INSERT INTO #tmp_inventory (INV_OnHandQuantity,
   --     											INV_ID,
   --     											INV_WHM_ID,
   --     											INV_PMA_ID)
   --     				   SELECT -Convert(decimal(18,2),@RETURNNUM),
   --     						  NEWID () AS INV_ID,
   --     						  @SystemHoldWarehouseID AS WHM_ID,
   --     						  PMA_ID
   --     					 FROM Product
   --     					WHERE PMA_UPN = @UPN
        	                
   --     				--更新库存表，存在的更新，不存在的新增
   --     				UPDATE Inventory
   --     				SET    Inventory.INV_OnHandQuantity = CONVERT (DECIMAL (18, 6), Inventory.INV_OnHandQuantity) + CONVERT (DECIMAL (18, 6), TMP.INV_OnHandQuantity)
   --     				FROM   #tmp_inventory AS TMP
   --     				WHERE      Inventory.INV_WHM_ID = TMP.INV_WHM_ID
   --     					   AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID
        	            
   --     				--记录库存操作日志
   --     				--Inventory表
   --     				INSERT INTO #tmp_invtrans
   --     				SELECT inv.INV_OnHandQuantity AS ITR_Quantity,
   --     					   NEWID () AS ITR_ID,
   --     					   @EmptyGuid AS ITR_ReferenceID,
   --     					   '经销商投诉换货' AS ITR_Type,
   --     					   inv.INV_WHM_ID AS ITR_WHM_ID,
   --     					   inv.INV_PMA_ID AS ITR_PMA_ID,
   --     					   0 AS ITR_UnitPrice,
   --     					   NULL AS ITR_TransDescription
   --     				--INTO   #tmp_invtrans
   --     				FROM   #tmp_inventory AS inv


   --     				INSERT INTO InventoryTransaction (ITR_Quantity,
   --     												  ITR_ID,
   --     												  ITR_ReferenceID,
   --     												  ITR_Type,
   --     												  ITR_WHM_ID,
   --     												  ITR_PMA_ID,
   --     												  ITR_UnitPrice,
   --     												  ITR_TransDescription,
   --     												  ITR_TransactionDate)
   --     				   SELECT ITR_Quantity,
   --     						  ITR_ID,
   --     						  ITR_ReferenceID,
   --     						  ITR_Type,
   --     						  ITR_WHM_ID,
   --     						  ITR_PMA_ID,
   --     						  ITR_UnitPrice,
   --     						  ITR_TransDescription,
   --     						  GETDATE ()
   --     				   FROM   #tmp_invtrans
        	                   
   --     				--Lot表(在在途仓库中扣减库存)
   --     				INSERT INTO #tmp_lot (LOT_ID,
   --     									  LOT_LTM_ID,
   --     									  LOT_WHM_ID,
   --     									  LOT_PMA_ID,
   --     									  LOT_LotNumber,
   --     									  LOT_OnHandQty)
   --     				   SELECT  NEWID (),LM.LTM_ID,
   --     						   @SystemHoldWarehouseID AS WHM_ID,
   --     						   P.PMA_ID,
   --     						   LM.LTM_LotNumber,
   --     						   -Convert(decimal(18,2),@RETURNNUM)
   --         	        		  FROM LotMaster LM, Product P
   --         	        		 WHERE P.PMA_ID = LM.LTM_Product_PMA_ID 
   --     					   AND LM.LTM_LotNumber = @LOT
   --     					   AND P.PMA_UPN = @UPN

   --     				--更新关联库存主键
   --     				UPDATE #tmp_lot
   --     				SET    LOT_INV_ID = INV.INV_ID
   --     				FROM   Inventory INV
   --     				WHERE      INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
   --     					   AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

   --     				--更新批次表,存在的更新,不存在的新增
   --     				UPDATE Lot
   --     				SET    Lot.LOT_OnHandQty = CONVERT (DECIMAL (18, 6), Lot.LOT_OnHandQty) + CONVERT (DECIMAL (18, 6), TMP.LOT_OnHandQty)
   --     				FROM   #tmp_lot AS TMP
   --     				WHERE      Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
   --     					   AND Lot.LOT_INV_ID = TMP.LOT_INV_ID                   
        	             
   --     				--记录库存操作日志
   --     				--Lot表
   --     				INSERT INTO #tmp_invtranslot
   --     				SELECT lot.LOT_OnHandQty AS ITL_Quantity,
   --     					   newid () AS ITL_ID,
   --     					   itr.ITR_ID AS ITL_ITR_ID,
   --     					   lot.LOT_LTM_ID AS ITL_LTM_ID,
   --     					   lot.LOT_LotNumber AS ITL_LotNumber
   --     				--INTO   #tmp_invtranslot
   --     				FROM   #tmp_lot AS lot
   --     					   INNER JOIN #tmp_invtrans AS itr
   --     						  ON     itr.ITR_PMA_ID = lot.LOT_PMA_ID
   --     							 AND itr.ITR_WHM_ID = lot.LOT_WHM_ID

   --     				INSERT INTO InventoryTransactionLot (ITL_Quantity,
   --     													 ITL_ID,
   --     													 ITL_ITR_ID,
   --     													 ITL_LTM_ID,
   --     													 ITL_LotNumber)
   --     				   SELECT ITL_Quantity,
   --     						  ITL_ID,
   --     						  ITL_ITR_ID,
   --     						  ITL_LTM_ID,
   --     						  ITL_LotNumber
   --     				   FROM   #tmp_invtranslot 
   --     			   end        
        	           
   --     				--发送邮件(发给LP,只限T2投诉)
   --     				INSERT INTO MailMessageQueue
   --     			   SELECT newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#UploadNo}',DC_ComplainNbr),
   --     					   replace(replace(replace(MMT_Body,'{#UploadNo}',DC_ComplainNbr),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),getdate(),20)) AS MMT_Body,
   --     					   'Waiting',getdate(),null
   --     				 from DealerComplainCRM t1, dealermaster t2, MailMessageTemplate t3,
   --     					  (
   --     						select t1.MDA_MailAddress from MailDeliveryAddress t1,dealermaster t2, client t3 , DealerComplainCRM t4
   --     						where t1.MDA_MailType='QAComplainBSC' and t1.MDA_MailTo=t3.CLT_ID and t2.DMA_Parent_DMA_ID=t3.CLT_Corp_Id and t2.DMA_ID =t4.DC_CorpId
   --     						and t4.DC_ID = @InstanceId
   --     					  ) t4
   --     				where DC_ID = @InstanceId and t1.DC_CorpId=t2.DMA_ID
   --     					and t2.DMA_DealerType = 'T2'
   --     				  and t3.MMT_Code='EMAIL_QACOMPLAIN_CONFIRMED'    
	       	                
			--	----T2提交LP物权，生成LP订单 (非仅投诉事件)
			--	--if(@DMATYPE = 'T2' and (@WHMTYPE = 'LP_Consignment' or @WHMTYPE='LP_Borrow') and @ReturnType <> '3' )
			--	--begin
			--	--	select @ParentDMAID = DMA_Parent_DMA_ID from DealerMaster where DMA_ID = @CorpId
					
			--	--	insert into #tmp_PurchaseOrderHeader(POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_OrderType,POH_CreateType,
			--	--		POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_WHM_ID,POH_Remark)	
			--	--	   SELECT newid(),CFN_ProductLine_BUM_ID,@ParentDMAID,'Normal','Manual',@SysUserId,getdate(),'Submitted',0,0,WHMID,'投诉'
			--	--	   from DealerComplainCRM,Product,CFN 
			--	--	   where DC_ID = @OrderId
			--	--	   and Serial = PMA_UPN
			--	--	   and PMA_CFN_ID = CFN_ID

					
			--	--	--生成单号
					

			--	--	DECLARE	curHandleOrderNo CURSOR 
			--	--	FOR SELECT POH_ID,@ParentDMAID,POH_ProductLine_BUM_ID FROM #tmp_PurchaseOrderHeader where POH_OrderStatus = 'Submitted'

			--	--	OPEN curHandleOrderNo
			--	--	FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_ProductLine

			--	--	WHILE @@FETCH_STATUS = 0
			--	--	BEGIN
			--	--		EXEC dbo.[GC_GetNextAutoNumberForPO] @m_DmaId,'Next_PurchaseOrder',@m_ProductLine, 'Normal', @m_OrderNo output
			--	--		UPDATE #tmp_PurchaseOrderHeader SET POH_OrderNo = @m_OrderNo WHERE POH_ID = @m_Id
			--	--		FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_ProductLine
			--	--	END

			--	--	CLOSE curHandleOrderNo
			--	--	DEALLOCATE curHandleOrderNo
					
			--	--	--根据仓库，更新收货地址
			--	--	  update #tmp_PurchaseOrderHeader set POH_ShipToAddress = WHM_Address
			--	--		from Warehouse where WHM_ID = POH_WHM_ID
					  
			--	--	  --更新承运商
			--	--	  update #tmp_PurchaseOrderHeader set POH_TerritoryCode = DMA_Certification
			--	--		from DealerMaster where DMA_ID = POH_DMA_ID
					  
			--	--	  --更新创建人
			--	--	  update #tmp_PurchaseOrderHeader SET POH_CreateUser = DST_User_ID
			--	--	  FROM (SELECT DST_Dealer_DMA_ID AS DST_DMA_ID,
			--	--		   CONVERT (UNIQUEIDENTIFIER,max (CONVERT (NVARCHAR (100), DST_Dealer_User_ID))) AS DST_User_ID       
			--	--			FROM DealerShipTo
			--	--			 WHERE DST_IsDefault = 1
			--	--			GROUP BY DST_Dealer_DMA_ID) AS DST
			--	--	 WHERE POH_DMA_ID = DST_DMA_ID
					  
			--	--	  --根据创建人，更新联系人信息
			--	--	  update #tmp_PurchaseOrderHeader set POH_ContactPerson = DST_ContactPerson,POH_Contact=DST_Contact,POH_ContactMobile=DST_ContactMobile,POH_Consignee=DST_Consignee,POH_ConsigneePhone=DST_ConsigneePhone
			--	--		from DealerShipTo where POH_CreateUser = DST_Dealer_User_ID  
						
			--	--	--订单明细	
			--	--	insert into #tmp_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
			--	--				POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM)
			--	--	  select newid(),Header.POH_ID,CFN_ID,CFNP_Price,1,CFNP_Price,0,0,LOT ,cfn.CFN_Property3
			--	--	  from #tmp_PurchaseOrderHeader AS Header,DealerMaster as dm,DealerComplainCRM,Product as p,CFN as cfn,CFNPrice as cfnp
			--	--	  where dm.DMA_ID= DC_CorpId
			--	--	  and Header.POH_DMA_ID = dm.DMA_Parent_DMA_ID
			--	--	  and Header.POH_WHM_ID = WHMID
			--	--	  and Serial = PMA_UPN
			--	--	  and PMA_CFN_ID = cfn.CFN_ID					
			--	--	  and CFN_ID = CFNP_CFN_ID
			--	--	  and CFNP_Group_ID = DC_CorpId
			--	--	  and CFNP_PriceType = 'DealerConsignment'
			--	--	  and DC_ID= @OrderId
					  
			--	--	  insert into PurchaseOrderHeader select * from #tmp_PurchaseOrderHeader
			--	--	  insert into PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
			--	--		POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM) 
			--	--		select POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
			--	--		POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM from #tmp_PurchaseOrderDetail
					  
			--	--	  INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
			--	--	  SELECT NEWID(),POH_ID,POH_CreateUser,GETDATE(),'Generate',NULL FROM #tmp_PurchaseOrderHeader
			--	--end
	            
			--END  
			--      ELSE IF(@WHMID = '00000000-0000-0000-0000-000000000000') --销售到医院的平台物权和波科物权需要新增ADJ单据
			--        BEGIN
			--	insert into #ShipmentToHos
			--	select top 1 PMA_UPN,LTM_LotNumber,-1,HOS_Key_Account,DMA_SAP_Code,WHM_Code,
			--	'ADJ','投诉销售单调整',getdate(),DMA_SAP_Code+'17ADJ'+substring(CONVERT(nvarchar(10),getdate(),112),3,6)+'01','Complete',GETDATE(),
			--	SPH_ID,HOS_ID,DMA_ID,SPL_ID,PMA_ID,1,SLT_ID,LOT_ID,WHM_ID,0
			--	--select *
			--	from ShipmentHeader,ShipmentLine,ShipmentLot,hospital,Product,Lot,LotMaster,DealerMaster,Warehouse
			--	where SPH_ID = SPL_SPH_ID
			--	and SPL_ID = SLT_SPL_ID
			--	and SPH_Hospital_HOS_ID = HOS_ID
			--	and SPL_Shipment_PMA_ID = PMA_ID
			--	and SLT_LOT_ID = LOT_ID
			--	and LOT_LTM_ID = LTM_ID
			--	and SPH_Dealer_DMA_ID = DMA_ID
			--	and SLT_WHM_ID = WHM_ID
			--	and SPH_Dealer_DMA_ID =@CorpId
			--	and PMA_UPN = @UPN
			--	and LTM_LotNumber =@LOT 
				
			--	--更新各主键及LineNbr
			--	select NewShipmentNbr,newid() AS SPH_ID into #TB_SphID from #ShipmentToHos group by NewShipmentNbr

			--	--select T1.*,T2.SPH_ID
			--	update T1 SET T1.SPH_ID = T2.SPH_ID
			--	from #ShipmentToHos T1,#TB_SphID T2
			--	where T1.NewShipmentNbr = T2.NewShipmentNbr

			--	--SPL ID
			--	select NewShipmentNbr, PMA_ID,newid() AS SPL_ID,ROW_NUMBER() OVER( partition By NewShipmentNbr ORDER BY NewShipmentNbr, PMA_ID desc) as LineNbr
			--	into #TB_SPLID
			--	 from #ShipmentToHos group by NewShipmentNbr, PMA_ID

			--	update T1 SET T1.SPL_ID = T2.SPL_ID, T1.LineNbr=T2.LineNbr
			--	from #ShipmentToHos T1,#TB_SPLID T2
			--	where T1.NewShipmentNbr = T2.NewShipmentNbr
			--	and T1.PMA_ID = T2.PMA_ID

			--	--SLT_ID
			--	update #ShipmentToHos set SLT_ID=newid()

			--	--写入销售数据表
			--	insert into ShipmentHeader(SPH_ID,SPH_Hospital_HOS_ID,SPH_ShipmentNbr,SPH_Dealer_DMA_ID,SPH_ShipmentDate,SPH_Status,SPH_Type,SPH_ProductLine_BUM_ID,SPH_Shipment_User,SPH_SubmitDate)
			--	select distinct SPH_ID,HOS_ID,NewShipmentNbr,DMA_ID,SPH_ShipmentDate,SPH_Status,'Hospital',T3.CFN_ProductLine_BUM_ID,@SysUserID,getdate()
			--	from #ShipmentToHos t1, product t2, cfn T3
			--	where t1.PMA_ID = t2.PMA_ID
			--	and t2.PMA_CFN_ID = T3.CFN_ID


			--	insert into ShipmentLine(SPL_ID,SPL_SPH_ID,SPL_Shipment_PMA_ID,SPL_ShipmentQty,SPL_LineNbr)
			--	select SPL_ID,SPH_ID,PMA_ID,sum(Qty),LineNbr
			--	from #ShipmentToHos
			--	group by SPH_ID,SPL_ID,PMA_ID,LineNbr

			--	insert into ShipmentLot(SLT_SPL_ID,SLT_LotShippedQty,SLT_LOT_ID,SLT_ID,SLT_WHM_ID,SLT_UnitPrice,AdjType,AdjReason,InputTime)
			--	select SPL_ID,Qty, LOT_ID,SLT_ID,WHM_ID,Unit_Price,ADJ_Type,ADJ_Reason,InputTime
			--	from #ShipmentToHos
			-- END	
       
   --         --增加逻辑判断，如果是二级经销商寄售库的产品，则需要写入接口表 Edit By Weiming on 2016-1-13
   --         INSERT INTO ComplainInterface (CI_ID,CI_BatchNbr,CI_RecordNbr,CI_POH_ID,CI_POH_OrderNo
   --           ,CI_Status,CI_ProcessType,CI_FileName,CI_CreateUser,CI_CreateDate,CI_UpdateUser,CI_UpdateDate,CI_ClientID) 
   --         SELECT newid(),'',1,DC.DC_ID,DC.DC_ComplainNbr, 'Pending','Manual',null,'00000000-0000-0000-0000-000000000000',getdate(),null,null,CT.CLT_ID 
   --          FROM DealerComplainCRM DC 
   --          INNER JOIN dealermaster AS DM ON (DM.DMA_SAP_Code = DC.BSCSOLDTOACCOUNT)
   --          INNER JOIN client AS CT ON (CT.CLT_Corp_Id = DM.DMA_ID)
   --          WHERE (DC_ID = @InstanceId OR DC.DC_ComplainNbr = @DMSBSCCode)
   --            and ((DC.SUBSOLDTONAME is not null and DC.SUBSOLDTONAME<>'' and exists (select 1 from warehouse WH where WH.WHM_ID = DC.WHMID and WH.WHM_Type IN ('Consignment','LP_Consignment')))
   --            OR DC.SUBSOLDTONAME is null OR DC.SUBSOLDTONAME=''
   --            )   
              
         END
         
      IF @Status = 'OutOfStock'
         BEGIN
                     
           --修改状态
           UPDATE dbo.DealerComplainCRM set DC_Status='OutOfStock' where DC_ID = @OrderId  --缺货
           
           --记录单据日志
        	 INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
        	 VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Submit','eWorkflow缺货')              
         END
         
      IF @Status = 'DealerCompleted'
         BEGIN
           --修改状态 
           UPDATE DealerComplainCRM SET DC_Status='Completed' WHERE DC_ID=@InstanceId  --已完成
           
           --记录单据日志
        	 INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
        	 VALUES (NEWID(),@InstanceId,@SysUserId,GETDATE(),'Submit','经销商确认收货，状态修改为：已完成')
           
           --发送邮件
           --发送邮件
           INSERT INTO MailMessageQueue
           SELECT newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#UploadNo}',DC_ComplainNbr),
                   replace(replace(MMT_Body,'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),getdate(),20)) AS MMT_Body,
                   'Waiting',getdate(),null
             from DealerComplainCRM t1, dealermaster t2, MailMessageTemplate t3,
                  (
                    select  MDA_MailAddress from MailDeliveryAddress where MDA_MailType='QAComplainBSC' and MDA_MailTo='EAI'
                    union
                    select t1.MDA_MailAddress from MailDeliveryAddress t1,dealermaster t2, client t3 , DealerComplainCRM t4
                    where t1.MDA_MailType='QAComplainBSC' and t1.MDA_MailTo=t3.CLT_ID and t2.DMA_Parent_DMA_ID=t3.CLT_Corp_Id and t2.DMA_ID =t4.DC_CorpId
                    and t4.DC_ID = @InstanceId
                  ) t4
            where DC_ID = @InstanceId and t1.DC_CorpId=t2.DMA_ID
              and t3.MMT_Code='EMAIL_QACOMPLAIN_COMPLAINCOMPLETED'
              
         END   
         
       IF @Status = 'Completed'
         BEGIN
                     
           --修改状态
           UPDATE dbo.DealerComplainCRM set DC_Status='Completed' where DC_ID = @OrderId and DC_Status not in ('Delivered') --已完成
           
           --记录单据日志
        	 INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
        	 VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Submit','eWorkflow已完成审批')  
        	 
        	 IF (@WHMID <> '00000000-0000-0000-0000-000000000000' and (@DNNumber ='OnlyComplain' or @DNNumber is null))
        	   BEGIN
        		 if(@ReturnType <> '3')
        		 BEGIN    
        				--Inventory表(在经销商的中间仓库中扣减库存)
        				INSERT INTO #tmp_inventory (INV_OnHandQuantity,
        											INV_ID,
        											INV_WHM_ID,
        											INV_PMA_ID)
        				   SELECT -Convert(decimal(18,2),@RETURNNUM),
        						  NEWID () AS INV_ID,
        						  @SystemHoldWarehouseID AS WHM_ID,
        						  PMA_ID
        					 FROM Product
        					WHERE PMA_UPN = @UPN
        	                
        				--更新库存表，存在的更新，不存在的新增
        				UPDATE Inventory
        				SET    Inventory.INV_OnHandQuantity = CONVERT (DECIMAL (18, 6), Inventory.INV_OnHandQuantity) + CONVERT (DECIMAL (18, 6), TMP.INV_OnHandQuantity)
        				FROM   #tmp_inventory AS TMP
        				WHERE      Inventory.INV_WHM_ID = TMP.INV_WHM_ID
        					   AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID
        	            
        				--记录库存操作日志
        				--Inventory表
        				INSERT INTO #tmp_invtrans
        				SELECT inv.INV_OnHandQuantity AS ITR_Quantity,
        					   NEWID () AS ITR_ID,
        					   @EmptyGuid AS ITR_ReferenceID,
        					   '经销商投诉换货' AS ITR_Type,
        					   inv.INV_WHM_ID AS ITR_WHM_ID,
        					   inv.INV_PMA_ID AS ITR_PMA_ID,
        					   0 AS ITR_UnitPrice,
        					   NULL AS ITR_TransDescription
        				--INTO   #tmp_invtrans
        				FROM   #tmp_inventory AS inv


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
        	                   
        				--Lot表(在在途仓库中扣减库存)
        				INSERT INTO #tmp_lot (LOT_ID,
        									  LOT_LTM_ID,
        									  LOT_WHM_ID,
        									  LOT_PMA_ID,
        									  LOT_LotNumber,
        									  LOT_OnHandQty)
        				   SELECT  NEWID (),LM.LTM_ID,
        						   @SystemHoldWarehouseID AS WHM_ID,
        						   P.PMA_ID,
        						   LM.LTM_LotNumber,
        						   -Convert(decimal(18,2),@RETURNNUM)
            	        		  FROM LotMaster LM, Product P
            	        		 WHERE P.PMA_ID = LM.LTM_Product_PMA_ID 
        					   AND LM.LTM_LotNumber = @LOT
        					   AND P.PMA_UPN = @UPN

        				--更新关联库存主键
        				UPDATE #tmp_lot
        				SET    LOT_INV_ID = INV.INV_ID
        				FROM   Inventory INV
        				WHERE      INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
        					   AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

        				--更新批次表,存在的更新,不存在的新增
        				UPDATE Lot
        				SET    Lot.LOT_OnHandQty = CONVERT (DECIMAL (18, 6), Lot.LOT_OnHandQty) + CONVERT (DECIMAL (18, 6), TMP.LOT_OnHandQty)
        				FROM   #tmp_lot AS TMP
        				WHERE      Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
        					   AND Lot.LOT_INV_ID = TMP.LOT_INV_ID                   
        	             
        				--记录库存操作日志
        				--Lot表
        				INSERT INTO #tmp_invtranslot
        				SELECT lot.LOT_OnHandQty AS ITL_Quantity,
        					   newid () AS ITL_ID,
        					   itr.ITR_ID AS ITL_ITR_ID,
        					   lot.LOT_LTM_ID AS ITL_LTM_ID,
        					   lot.LOT_LotNumber AS ITL_LotNumber
        				--INTO   #tmp_invtranslot
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
        			   end        
        	           
        				--发送邮件(发给LP,只限T2投诉)
        				INSERT INTO MailMessageQueue
        			   SELECT newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#UploadNo}',DC_ComplainNbr),
        					   replace(replace(replace(MMT_Body,'{#UploadNo}',DC_ComplainNbr),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),getdate(),20)) AS MMT_Body,
        					   'Waiting',getdate(),null
        				 from DealerComplainCRM t1, dealermaster t2, MailMessageTemplate t3,
        					  (
        						select t1.MDA_MailAddress from MailDeliveryAddress t1,dealermaster t2, client t3 , DealerComplainCRM t4
        						where t1.MDA_MailType='QAComplainCRM' and t1.MDA_MailTo=t3.CLT_ID and t2.DMA_Parent_DMA_ID=t3.CLT_Corp_Id and t2.DMA_ID =t4.DC_CorpId
        						and t4.DC_ID = @InstanceId
        					  ) t4
        				where DC_ID = @InstanceId and t1.DC_CorpId=t2.DMA_ID
        					and t2.DMA_DealerType = 'T2'
        				  and t3.MMT_Code='EMAIL_QACOMPLAIN_CONFIRMED'    
	   
				----T2提交LP物权，生成LP订单 (非仅投诉事件)
				--if(@DMATYPE = 'T2' and (@WHMTYPE = 'LP_Consignment' or @WHMTYPE='LP_Borrow') and @ReturnType <> '3' )
				--begin
				--	select @ParentDMAID = DMA_Parent_DMA_ID from DealerMaster where DMA_ID = @CorpId
					
				--	insert into #tmp_PurchaseOrderHeader(POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_OrderType,POH_CreateType,
				--		POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_WHM_ID,POH_Remark)	
				--	   SELECT newid(),CFN_ProductLine_BUM_ID,@ParentDMAID,'Normal','Manual',@SysUserId,getdate(),'Submitted',0,0,WHMID,'投诉'
				--	   from DealerComplainCRM,Product,CFN 
				--	   where DC_ID = @OrderId
				--	   and Serial = PMA_UPN
				--	   and PMA_CFN_ID = CFN_ID

					
				--	--生成单号
					

				--	DECLARE	curHandleOrderNo CURSOR 
				--	FOR SELECT POH_ID,@ParentDMAID,POH_ProductLine_BUM_ID FROM #tmp_PurchaseOrderHeader where POH_OrderStatus = 'Submitted'

				--	OPEN curHandleOrderNo
				--	FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_ProductLine

				--	WHILE @@FETCH_STATUS = 0
				--	BEGIN
				--		EXEC dbo.[GC_GetNextAutoNumberForPO] @m_DmaId,'Next_PurchaseOrder',@m_ProductLine, 'Normal', @m_OrderNo output
				--		UPDATE #tmp_PurchaseOrderHeader SET POH_OrderNo = @m_OrderNo WHERE POH_ID = @m_Id
				--		FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_ProductLine
				--	END

				--	CLOSE curHandleOrderNo
				--	DEALLOCATE curHandleOrderNo
					
				--	--根据仓库，更新收货地址
				--	  update #tmp_PurchaseOrderHeader set POH_ShipToAddress = WHM_Address
				--		from Warehouse where WHM_ID = POH_WHM_ID
					  
				--	  --更新承运商
				--	  update #tmp_PurchaseOrderHeader set POH_TerritoryCode = DMA_Certification
				--		from DealerMaster where DMA_ID = POH_DMA_ID
					  
				--	  --更新创建人
				--	  update #tmp_PurchaseOrderHeader SET POH_CreateUser = DST_User_ID
				--	  FROM (SELECT DST_Dealer_DMA_ID AS DST_DMA_ID,
				--		   CONVERT (UNIQUEIDENTIFIER,max (CONVERT (NVARCHAR (100), DST_Dealer_User_ID))) AS DST_User_ID       
				--			FROM DealerShipTo
				--			 WHERE DST_IsDefault = 1
				--			GROUP BY DST_Dealer_DMA_ID) AS DST
				--	 WHERE POH_DMA_ID = DST_DMA_ID
					  
				--	  --根据创建人，更新联系人信息
				--	  update #tmp_PurchaseOrderHeader set POH_ContactPerson = DST_ContactPerson,POH_Contact=DST_Contact,POH_ContactMobile=DST_ContactMobile,POH_Consignee=DST_Consignee,POH_ConsigneePhone=DST_ConsigneePhone
				--		from DealerShipTo where POH_CreateUser = DST_Dealer_User_ID  
						
				--	--订单明细	
				--	insert into #tmp_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
				--				POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM)
				--	  select newid(),Header.POH_ID,CFN_ID,CFNP_Price,@RETURNNUM,CFNP_Price*@RETURNNUM,0,0,LOT ,cfn.CFN_Property3
				--	  from #tmp_PurchaseOrderHeader AS Header,DealerMaster as dm,DealerComplainCRM,Product as p,CFN as cfn,CFNPrice as cfnp
				--	  where dm.DMA_ID= DC_CorpId
				--	  and Header.POH_DMA_ID = dm.DMA_Parent_DMA_ID
				--	  and Header.POH_WHM_ID = WHMID
				--	  and Serial = PMA_UPN
				--	  and PMA_CFN_ID = cfn.CFN_ID					
				--	  and CFN_ID = CFNP_CFN_ID
				--	  and CFNP_Group_ID = DC_CorpId
				--	  and CFNP_PriceType = 'DealerConsignment'
				--	  and DC_ID= @OrderId
					  
				--	  insert into PurchaseOrderHeader select * from #tmp_PurchaseOrderHeader
				--	  insert into PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
				--		POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM) 
				--		select POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
				--		POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM from #tmp_PurchaseOrderDetail
					  
				--	  INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
				--	  SELECT NEWID(),POH_ID,POH_CreateUser,GETDATE(),'Generate',NULL FROM #tmp_PurchaseOrderHeader
				--end
	            
				--仅投诉事件处理
				IF(@DMATYPE = 'T2' and @ReturnType = '3')
				BEGIN
					IF(@WHMTYPE = 'DefaultWH' or @WHMTYPE = 'Normal')--t2物权，扣减库存
						BEGIN
							--Inventory表(在经销商的中间仓库中扣减库存)
							INSERT INTO #tmp_inventory (INV_OnHandQuantity,
														INV_ID,
														INV_WHM_ID,
														INV_PMA_ID)
							   SELECT -Convert(decimal(18,2),@RETURNNUM),
									  NEWID () AS INV_ID,
									  @SystemHoldWarehouseID AS WHM_ID,
									  PMA_ID
								 FROM Product
								WHERE PMA_UPN = @UPN
				                
							--更新库存表，存在的更新，不存在的新增
							UPDATE Inventory
							SET    Inventory.INV_OnHandQuantity = CONVERT (DECIMAL (18, 6), Inventory.INV_OnHandQuantity) + CONVERT (DECIMAL (18, 6), TMP.INV_OnHandQuantity)
							FROM   #tmp_inventory AS TMP
							WHERE      Inventory.INV_WHM_ID = TMP.INV_WHM_ID
								   AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID
				            
							--记录库存操作日志
							--Inventory表
							INSERT INTO #tmp_invtrans
							SELECT inv.INV_OnHandQuantity AS ITR_Quantity,
								   NEWID () AS ITR_ID,
								   @EmptyGuid AS ITR_ReferenceID,
								   '经销商投诉换货' AS ITR_Type,
								   inv.INV_WHM_ID AS ITR_WHM_ID,
								   inv.INV_PMA_ID AS ITR_PMA_ID,
								   0 AS ITR_UnitPrice,
								   NULL AS ITR_TransDescription
							--INTO   #tmp_invtrans
							FROM   #tmp_inventory AS inv


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
				                   
							--Lot表(在在途仓库中扣减库存)
							INSERT INTO #tmp_lot (LOT_ID,
												  LOT_LTM_ID,
												  LOT_WHM_ID,
												  LOT_PMA_ID,
												  LOT_LotNumber,
												  LOT_OnHandQty)
							   SELECT  NEWID (),LM.LTM_ID,
									   @SystemHoldWarehouseID AS WHM_ID,
									   P.PMA_ID,
									   LM.LTM_LotNumber,
									   -Convert(decimal(18,2),@RETURNNUM)
    	        					  FROM LotMaster LM, Product P
    	        					 WHERE P.PMA_ID = LM.LTM_Product_PMA_ID 
								   AND LM.LTM_LotNumber = @LOT
								   AND P.PMA_UPN = @UPN

							--更新关联库存主键
							UPDATE #tmp_lot
							SET    LOT_INV_ID = INV.INV_ID
							FROM   Inventory INV
							WHERE      INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
								   AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

							--更新批次表,存在的更新,不存在的新增
							UPDATE Lot
							SET    Lot.LOT_OnHandQty = CONVERT (DECIMAL (18, 6), Lot.LOT_OnHandQty) + CONVERT (DECIMAL (18, 6), TMP.LOT_OnHandQty)
							FROM   #tmp_lot AS TMP
							WHERE      Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
								   AND Lot.LOT_INV_ID = TMP.LOT_INV_ID                   
				             
							--记录库存操作日志
							--Lot表
							INSERT INTO #tmp_invtranslot
							SELECT lot.LOT_OnHandQty AS ITL_Quantity,
								   newid () AS ITL_ID,
								   itr.ITR_ID AS ITL_ITR_ID,
								   lot.LOT_LTM_ID AS ITL_LTM_ID,
								   lot.LOT_LotNumber AS ITL_LotNumber
							--INTO   #tmp_invtranslot
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
						END
					ELSE --LP/BSC物权，不扣减库存，生成寄售退货单和订单-仅投诉订单
						BEGIN
							--生成T2寄售退货单
							create table #tmp_InventoryAdjustHeader (
							   IAH_ID					uniqueidentifier     not null,
							   IAH_Reason				nvarchar(50)         collate Chinese_PRC_CI_AS null,
							   IAH_Inv_Adj_Nbr			nvarchar(30)		collate Chinese_PRC_CI_AS null,
							   IAH_DMA_ID				uniqueidentifier   NOT  null,
							   IAH_ApprovalDate         datetime             null,
							   IAH_CreatedDate          datetime            NOT null,
							   IAH_Approval_USR_UserID  uniqueidentifier     null,
							   IAH_AuditorNotes			nvarchar(2000)         collate Chinese_PRC_CI_AS      null,
							   IAH_UserDescription      nvarchar(2000)         collate Chinese_PRC_CI_AS     null,
							   IAH_Status				nvarchar(50)         collate Chinese_PRC_CI_AS null,
							   IAH_CreatedBy_USR_UserID uniqueidentifier     null,
							   IAH_Reverse_IAH_ID		uniqueidentifier     null,
							   IAH_ProductLine_BUM_ID   uniqueidentifier             null,
							   IAH_WarehouseType		nvarchar(50)         collate Chinese_PRC_CI_AS not null,
							   primary key (IAH_ID)
							)

							create table #tmp_InventoryAdjustDetail (
							   IAD_Quantity         float     not null,
							   IAD_ID				uniqueidentifier     not null,
							   IAD_PMA_ID			uniqueidentifier     not null,
							   IAD_IAH_ID			uniqueidentifier        null,
							   IAD_LineNbr          int        null,
							   IAD_LOT_ID			uniqueidentifier NULL,
							   IAD_LOT_Number		nvarchar(50) collate Chinese_PRC_CI_AS  null,
							   IAD_WHM_ID			uniqueidentifier NULL,
							   IAD_BUM_ID			uniqueidentifier NULL,
							   IAD_ExpiredDate		datetime null,
							   IAD_PRH_ID			uniqueidentifier NULL,
								primary key (IAD_ID)
							)
							
							insert into #tmp_InventoryAdjustHeader
							select newid(),'Return','',@CorpId,GETDATE(),GETDATE(),null,null,'投诉','Submit',@SysUserId,null,CFN_ProductLine_BUM_ID,'Consignment'
							from DealerComplainCRM,Product,CFN
							where Serial = PMA_UPN
							and PMA_CFN_ID = CFN_ID
							and DC_ID = @OrderId
							
							--生成单号

							DECLARE	curHandleOrderNo CURSOR 
							FOR SELECT IAH_ID,IAH_DMA_ID,Attribute_Name 
							FROM #tmp_InventoryAdjustHeader,Cache_OrganizationUnits ,Lafite_ATTRIBUTE 
							where IAH_Status = 'Submit'
							and IAH_ProductLine_BUM_ID = AttributeID
							and id = RootID
							and attribute_type='BU'

							OPEN curHandleOrderNo
							FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_BU

							WHILE @@FETCH_STATUS = 0
							BEGIN
								EXEC dbo.[GC_GetNextAutoNumber] @m_DmaId,'Next_AdjustNbr',@m_BU, @m_OrderNo output
								UPDATE #tmp_InventoryAdjustHeader SET IAH_Inv_Adj_Nbr = @m_OrderNo WHERE IAH_ID = @m_Id
								FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_BU
							END

							CLOSE curHandleOrderNo
							DEALLOCATE curHandleOrderNo
							
							INSERT INTO #tmp_InventoryAdjustDetail
							SELECT @RETURNNUM,NEWID(),PMA_ID,IAH_ID,1,LOT_ID,LOT,WHMID,IAH_ProductLine_BUM_ID,LTM_ExpiredDate,
							(select top 1 PRH_ID from  POReceiptHeader,POReceipt,POReceiptLot where PRH_ID = POR_PRH_ID and POR_ID = PRL_POR_ID
							and PRL_LotNumber = LOT)
							FROM #tmp_InventoryAdjustHeader ,DealerComplainCRM,LotMaster,Lot,Product,Inventory
							WHERE IAH_DMA_ID = DC_CorpId
							AND Serial = PMA_UPN
							AND LOT = LTM_LotNumber
							AND LTM_ID = LOT_LTM_ID
							and WHMID = INV_WHM_ID
							and INV_ID = LOT_INV_ID
							AND DC_ID = @OrderId
							
							--插入订单主表和明细表
							insert into InventoryAdjustHeader select * from #tmp_InventoryAdjustHeader
							insert into InventoryAdjustDetail select IAD_Quantity,IAD_ID,IAD_PMA_ID,IAD_IAH_ID,IAD_LineNbr from #tmp_InventoryAdjustDetail
							insert into InventoryAdjustLot select IAD_ID,NEWID(),IAD_Quantity,IAD_LOT_ID,IAD_WHM_ID,IAD_LOT_Number,IAD_ExpiredDate,IAD_PRH_ID,0 from #tmp_InventoryAdjustDetail
							
							--插入订单操作日志
							INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
							SELECT NEWID(),IAH_ID,IAH_CreatedBy_USR_UserID,GETDATE(),'Generate',NULL FROM #tmp_InventoryAdjustHeader
							
							--生成T2订单
							insert into #tmp_PurchaseOrderHeader(POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_OrderType,POH_CreateType,
								POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_WHM_ID,POH_Remark)	
							   SELECT newid(),CFN_ProductLine_BUM_ID,DC_CorpId,'Consignment','Manual',@SysUserId,getdate(),'Submitted',0,0,WHMID,'投诉'
							   from DealerComplainCRM,Product,CFN 
							   where DC_ID = @OrderId
							   and Serial = PMA_UPN
							   and PMA_CFN_ID = CFN_ID

							
							--生成单号
							

							DECLARE	curHandleOrderNo CURSOR 
							FOR SELECT POH_ID,POH_DMA_ID,POH_ProductLine_BUM_ID FROM #tmp_PurchaseOrderHeader where POH_OrderStatus = 'Submitted'

							OPEN curHandleOrderNo
							FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_ProductLine

							WHILE @@FETCH_STATUS = 0
							BEGIN
								EXEC dbo.[GC_GetNextAutoNumberForPO] @m_DmaId,'Next_PurchaseOrder',@m_ProductLine, 'Normal', @m_OrderNo output
								UPDATE #tmp_PurchaseOrderHeader SET POH_OrderNo = @m_OrderNo WHERE POH_ID = @m_Id
								FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_ProductLine
							END

							CLOSE curHandleOrderNo
							DEALLOCATE curHandleOrderNo
							
							--根据仓库，更新收货地址
							  update #tmp_PurchaseOrderHeader set POH_ShipToAddress = WHM_Address
								from Warehouse where WHM_ID = POH_WHM_ID
							  
							  --更新承运商
							  update #tmp_PurchaseOrderHeader set POH_TerritoryCode = DMA_Certification
								from DealerMaster where DMA_ID = POH_DMA_ID
							  
							  --更新创建人
							  update #tmp_PurchaseOrderHeader SET POH_CreateUser = DST_User_ID
							  FROM (SELECT DST_Dealer_DMA_ID AS DST_DMA_ID,
								   CONVERT (UNIQUEIDENTIFIER,max (CONVERT (NVARCHAR (100), DST_Dealer_User_ID))) AS DST_User_ID       
									FROM DealerShipTo
									 WHERE DST_IsDefault = 1
									GROUP BY DST_Dealer_DMA_ID) AS DST
							 WHERE POH_DMA_ID = DST_DMA_ID
							  
							  --根据创建人，更新联系人信息
							  update #tmp_PurchaseOrderHeader set POH_ContactPerson = DST_ContactPerson,POH_Contact=DST_Contact,POH_ContactMobile=DST_ContactMobile,POH_Consignee=DST_Consignee,POH_ConsigneePhone=DST_ConsigneePhone
								from DealerShipTo where POH_CreateUser = DST_Dealer_User_ID  
								
							--订单明细	
							insert into #tmp_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
										POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM)
							  select newid(),Header.POH_ID,CFN_ID,CFNP_Price,@RETURNNUM,CFNP_Price*@RETURNNUM,0,0,LOT ,cfn.CFN_Property3
							  from #tmp_PurchaseOrderHeader AS Header,DealerMaster as dm,DealerComplainCRM,Product as p,CFN as cfn,CFNPrice as cfnp
							  where Header.POH_DMA_ID = dm.DMA_ID
							  and dm.DMA_ID= DC_CorpId
							  and Header.POH_WHM_ID = WHMID
							  and Serial = PMA_UPN
							  and PMA_CFN_ID = cfn.CFN_ID					
							  and CFN_ID = CFNP_CFN_ID
							  and CFNP_Group_ID = DC_CorpId
							  and CFNP_PriceType = 'DealerConsignment'
							  and DC_ID= @OrderId
							  
							  --insert into PurchaseOrderHeader select * from #tmp_PurchaseOrderHeader
							   insert into PurchaseOrderHeader(POH_ID, POH_OrderNo, POH_ProductLine_BUM_ID, POH_DMA_ID, POH_VendorID, POH_TerritoryCode, POH_RDD, POH_ContactPerson, POH_Contact, POH_ContactMobile, POH_Consignee, POH_ShipToAddress, POH_ConsigneePhone, POH_Remark, POH_InvoiceComment, POH_CreateType, POH_CreateUser, POH_CreateDate, POH_UpdateUser, POH_UpdateDate, POH_SubmitUser, POH_SubmitDate, POH_LastBrowseUser, POH_LastBrowseDate, POH_OrderStatus, POH_LatestAuditDate, POH_IsLocked, POH_SAP_OrderNo, POH_SAP_ConfirmDate, POH_LastVersion, POH_OrderType, POH_VirtualDC, POH_SpecialPriceID, POH_WHM_ID, POH_POH_ID)
							   select POH_ID, POH_OrderNo, POH_ProductLine_BUM_ID, POH_DMA_ID, POH_VendorID, POH_TerritoryCode, POH_RDD, POH_ContactPerson, POH_Contact, POH_ContactMobile, POH_Consignee, POH_ShipToAddress, POH_ConsigneePhone, POH_Remark, POH_InvoiceComment, POH_CreateType, POH_CreateUser, POH_CreateDate, POH_UpdateUser, POH_UpdateDate, POH_SubmitUser, POH_SubmitDate, POH_LastBrowseUser, POH_LastBrowseDate, POH_OrderStatus, POH_LatestAuditDate, POH_IsLocked, POH_SAP_OrderNo, POH_SAP_ConfirmDate, POH_LastVersion, POH_OrderType, POH_VirtualDC, POH_SpecialPriceID, POH_WHM_ID, POH_POH_ID from #tmp_PurchaseOrderHeader
							 
							  insert into PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
								POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM) 
								select POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
								POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM from #tmp_PurchaseOrderDetail
							  
							  INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
							  SELECT NEWID(),POH_ID,POH_CreateUser,GETDATE(),'Generate',NULL FROM #tmp_PurchaseOrderHeader
							
						END
					
				END
			END
			     ELSE IF(@WHMID = '00000000-0000-0000-0000-000000000000') --销售到医院的平台物权和波科物权需要新增ADJ单据
			        BEGIN
						
						EXEC [GC_GetNextAutoNumber] @CorpId,'Next_ShipmentNbr','CRM',@PONumber OUTPUT
		    													 
						select @PONumber = REPLACE(@PONumber,'SN','ADJ');
						
        				insert into #ShipmentToHos
        				select top 1 PMA_UPN,LTM_LotNumber,-Convert(decimal(18,2),@RETURNNUM),HOS_Key_Account,DMA_SAP_Code,WHM_Code,
        				'ADJ','投诉销售单调整',getdate(),@PONumber,'Complete',GETDATE(),
        				SPH_ID,HOS_ID,DMA_ID,SPL_ID,PMA_ID,1,SLT_ID,LOT_ID,WHM_ID,0
        				--select *
        				from ShipmentHeader,ShipmentLine,ShipmentLot,hospital,Product,Lot,LotMaster,DealerMaster,Warehouse
        				where SPH_ID = SPL_SPH_ID
        				and SPL_ID = SLT_SPL_ID
        				and SPH_Hospital_HOS_ID = HOS_ID
        				and SPL_Shipment_PMA_ID = PMA_ID
        				and SLT_LOT_ID = LOT_ID
        				and LOT_LTM_ID = LTM_ID
        				and SPH_Dealer_DMA_ID = DMA_ID
        				and SLT_WHM_ID = WHM_ID
        				and SPH_Dealer_DMA_ID =@CorpId
        				and PMA_UPN = @UPN
        				and LTM_LotNumber =@LOT 
        				
        				--更新各主键及LineNbr
        				select NewShipmentNbr,newid() AS SPH_ID into #TB_SphID2 from #ShipmentToHos group by NewShipmentNbr

        				--select T1.*,T2.SPH_ID
        				update T1 SET T1.SPH_ID = T2.SPH_ID
        				from #ShipmentToHos T1,#TB_SphID2 T2
        				where T1.NewShipmentNbr = T2.NewShipmentNbr

        				--SPL ID
        				select NewShipmentNbr, PMA_ID,newid() AS SPL_ID,ROW_NUMBER() OVER( partition By NewShipmentNbr ORDER BY NewShipmentNbr, PMA_ID desc) as LineNbr
        				into #TB_SPLID2
        				 from #ShipmentToHos group by NewShipmentNbr, PMA_ID

        				update T1 SET T1.SPL_ID = T2.SPL_ID, T1.LineNbr=T2.LineNbr
        				from #ShipmentToHos T1,#TB_SPLID2 T2
        				where T1.NewShipmentNbr = T2.NewShipmentNbr
        				and T1.PMA_ID = T2.PMA_ID

        				--SLT_ID
        				update #ShipmentToHos set SLT_ID=newid()

        				--写入销售数据表
        				insert into ShipmentHeader(SPH_ID,SPH_Hospital_HOS_ID,SPH_ShipmentNbr,SPH_Dealer_DMA_ID,SPH_ShipmentDate,SPH_Status,SPH_Type,SPH_ProductLine_BUM_ID,SPH_Shipment_User,SPH_SubmitDate)
        				select distinct SPH_ID,HOS_ID,NewShipmentNbr,DMA_ID,SPH_ShipmentDate,SPH_Status,'Hospital',T3.CFN_ProductLine_BUM_ID,@SysUserID,getdate()
        				from #ShipmentToHos t1, product t2, cfn T3
        				where t1.PMA_ID = t2.PMA_ID
        				and t2.PMA_CFN_ID = T3.CFN_ID


        				insert into ShipmentLine(SPL_ID,SPL_SPH_ID,SPL_Shipment_PMA_ID,SPL_ShipmentQty,SPL_LineNbr)
        				select SPL_ID,SPH_ID,PMA_ID,sum(Qty),LineNbr
        				from #ShipmentToHos
        				group by SPH_ID,SPL_ID,PMA_ID,LineNbr

        				insert into ShipmentLot(SLT_SPL_ID,SLT_LotShippedQty,SLT_LOT_ID,SLT_ID,SLT_WHM_ID,SLT_UnitPrice,AdjType,AdjReason,InputTime)
        				select SPL_ID,Qty, LOT_ID,SLT_ID,WHM_ID,Unit_Price,ADJ_Type,ADJ_Reason,InputTime
        				from #ShipmentToHos
			 END 
       
       
           --增加逻辑判断，如果是二级经销商寄售库的产品，则需要写入接口表 Edit By Weiming on 2016-1-13
            INSERT INTO ComplainInterface (CI_ID,CI_BatchNbr,CI_RecordNbr,CI_POH_ID,CI_POH_OrderNo
              ,CI_Status,CI_ProcessType,CI_FileName,CI_CreateUser,CI_CreateDate,CI_UpdateUser,CI_UpdateDate,CI_ClientID) 
            SELECT newid(),'',1,DC.DC_ID,DC.DC_ComplainNbr, 'Pending','Manual',null,'00000000-0000-0000-0000-000000000000',getdate(),null,null,CT.CLT_ID 
             FROM DealerComplainCRM DC 
             INNER JOIN dealermaster AS DM ON (DM.DMA_SAP_Code = DC.BSCSOLDTOACCOUNT)
             INNER JOIN client AS CT ON (CT.CLT_Corp_Id = DM.DMA_ID)
             WHERE (DC_ID = @InstanceId OR DC_ComplainNbr = @DMSBSCCode)
               and ((DC.SUBSOLDTONAME is not null and DC.SUBSOLDTONAME<>'' and exists (select 1 from warehouse WH where WH.WHM_ID = DC.WHMID and WH.WHM_Type IN ('Consignment','LP_Consignment')))
               OR DC.SUBSOLDTONAME is null OR DC.SUBSOLDTONAME=''
               )   
         END
                
      IF @Status = 'UploadCarrier'
         BEGIN              
            UPDATE DealerComplainCRM SET CarrierNumber=@CarrierNumber,DC_LastModifiedBy=@UserId,DC_LastModifiedDate=GETDATE() WHERE DC_ID=@InstanceId
            
            --记录单据日志
        	  INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
        	  VALUES (NEWID(),@InstanceId,@SysUserId,GETDATE(),'Submit','经销商已上传快递单号')
           
           --发送邮件
           INSERT INTO MailMessageQueue
           SELECT newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#UploadNo}',DC_ComplainNbr),
                   replace(replace(replace(MMT_Body,'{#CarrierNo}',@CarrierNumber),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),getdate(),20)) AS MMT_Body,
                   'Waiting',getdate(),null
             from DealerComplainCRM t1, dealermaster t2, MailMessageTemplate t3,
                  (
                    select  MDA_MailAddress from MailDeliveryAddress where MDA_MailType='QAComplainBSC' and MDA_MailTo='EAI'
                    union
                    select t1.MDA_MailAddress from MailDeliveryAddress t1,dealermaster t2, client t3 , DealerComplainCRM t4
                    where t1.MDA_MailType='QAComplainBSC' and t1.MDA_MailTo=t3.CLT_ID and t2.DMA_Parent_DMA_ID=t3.CLT_Corp_Id and t2.DMA_ID =t4.DC_CorpId
                    and t4.DC_ID = @InstanceId
                  ) t4
            where DC_ID = @InstanceId and t1.DC_CorpId=t2.DMA_ID
              and t3.MMT_Code='EMAIL_QACOMPLAIN_SUBMITCARRIER'
          END
    END
    
    EXEC [dbo].[GC_DealerComplain_SendMail] @OrderId,'CRM'
    
	--记录日志
	INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_Message,IL_ClientID,IL_BatchNbr) 
	VALUES (NEWID(),'P_I_EW_QABSCDealerComplain_Lock',GETDATE(),GETDATE(),'Success','接口调用成功：DMSBSCCode = '+@DMSBSCCode,'SYS',@BatchNbr)

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN

	--记录日志
	INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_Message,IL_ClientID,IL_BatchNbr) 
	VALUES (NEWID(),'P_I_EW_QABSCDealerComplain_Lock',GETDATE(),GETDATE(),'Failure','接口调用失败：DMSBSCCode = '+@DMSBSCCode+' 错误信息：' + ERROR_MESSAGE(),'SYS',@BatchNbr)

    return -1
    
END CATCH
GO


