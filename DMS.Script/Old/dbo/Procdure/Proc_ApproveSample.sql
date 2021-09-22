DROP PROCEDURE [dbo].[Proc_ApproveSample]
GO

CREATE PROCEDURE [dbo].[Proc_ApproveSample](
    @ApplyType     NVARCHAR(100),
    @SampleNo      NVARCHAR(100),
    @SampleStatus  NVARCHAR(100),
    @ApproveUser   NVARCHAR(100),
    @ApproveType   NVARCHAR(100),
    @ApproveDate   DATETIME,
    @ApproveNote   NVARCHAR(500)
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
		DECLARE @SampleHeadId UNIQUEIDENTIFIER;
		DECLARE @SampleType NVARCHAR(100);
		DECLARE @SyncContent NVARCHAR(MAX);

		SET @SyncContent = '';
		
		IF @ApplyType = '申请单'
		BEGIN
		    SELECT @SampleHeadId = SampleApplyHeadId,
		           @SampleType = SampleType
		    FROM   SampleApplyHead
		    WHERE  ApplyNo = @SampleNo
		    
		    UPDATE SampleApplyHead
		    SET    ApplyStatus  = @SampleStatus,
		           UpdateDate   = GETDATE()
		    WHERE  ApplyNo      = @SampleNo
		END
		ELSE
		BEGIN
		    SELECT @SampleHeadId = SampleReturnHeadId,
		           @SampleType = SampleType
		    FROM   SampleReturnHead
		    WHERE  ReturnNo = @SampleNo
		    
		    UPDATE SampleReturnHead
		    SET    ReturnStatus  = @SampleStatus,
		           UpdateDate    = GETDATE()
		    WHERE  ReturnNo      = @SampleNo
		END
		
		INSERT INTO ScoreCardLog
		  (SCL_ID, SCL_ESC_ID, SCL_OperUser, SCL_OperDate, SCL_OperType, SCL_OperNote)
		VALUES
		  (NEWID(), @SampleHeadId, @ApproveUser, @ApproveDate, @ApproveType, @ApproveNote)

        IF @SampleType = '测试样品'
        BEGIN
			IF @ApplyType = '申请单'
			BEGIN
				SET @SyncContent += '<InterfaceDataSet><Record><ApplyType>SampleApply</ApplyType>';
			END
			ELSE
			BEGIN
				SET @SyncContent += '<InterfaceDataSet><Record><ApplyType>SampleReturn</ApplyType>';
			END
			SET @SyncContent += '<ApplyNo>' + isnull(@SampleNo,'') + '</ApplyNo>';
			SET @SyncContent += '<UserName>' + isnull(@ApproveUser,'') + '</UserName>';
			SET @SyncContent += '<ApproveDate>' + CONVERT(NVARCHAR(19), @ApproveDate, 121) + '</ApproveDate>';
			SET @SyncContent += '<Remark><![CDATA[' + isnull(@ApproveNote,'') + ']]></Remark>';
			SET @SyncContent += '<Status>' + isnull(@SampleStatus,'') + '</Status>';
			SET @SyncContent += '</Record></InterfaceDataSet>';
		
			INSERT INTO SampleSyncStack
			  (SampleHeadId, ApplyType, SampleType, SyncType, SampleNo, SyncContent, SyncStatus, SyncErrCount, SyncMsg, CreateDate)
			VALUES
			  (@SampleHeadId, @ApplyType, @SampleType, '单据状态', @SampleNo, @SyncContent, 'Wait', 0, '', GETDATE())
		END

		--样品申请单，如果是商业样品并且状态是完成，则生成订单
		IF (
		       @ApplyType = '申请单'
		       AND @SampleType = '商业样品'
		       AND @SampleStatus = 'Approved'
		   ) OR (
		       @ApplyType = '申请单'
		       AND @SampleType = '测试样品'
		       AND @SampleStatus = 'Approved'
		       AND EXISTS (SELECT 1 FROM SampleTesting WHERE SampleHeadId = @SampleHeadId AND Certificate in ('续证','变更'))
		   )
		BEGIN
		    DECLARE @ProductLineID UNIQUEIDENTIFIER 
		    DECLARE @DmaID UNIQUEIDENTIFIER
		    DECLARE @WhmID UNIQUEIDENTIFIER
		    DECLARE @DmaCode NVARCHAR(100)
		    
		    CREATE TABLE #tmp_PurchaseOrderHeader
		    (
		    	POH_ID                  UNIQUEIDENTIFIER NOT NULL,
		    	POH_OrderNo             NVARCHAR(30) COLLATE Chinese_PRC_CI_AS NULL,
		    	POH_ProductLine_BUM_ID  UNIQUEIDENTIFIER NULL,
		    	POH_DMA_ID              UNIQUEIDENTIFIER NULL,
		    	POH_VendorID            NVARCHAR(100) COLLATE Chinese_PRC_CI_AS NULL,
		    	POH_TerritoryCode       NVARCHAR(200) NULL,
		    	POH_RDD                 DATETIME NULL,
		    	POH_ContactPerson       NVARCHAR(100) COLLATE Chinese_PRC_CI_AS NULL,
		    	POH_Contact             NVARCHAR(100) COLLATE Chinese_PRC_CI_AS NULL,
		    	POH_ContactMobile       NVARCHAR(100) COLLATE Chinese_PRC_CI_AS NULL,
		    	POH_Consignee           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS NULL,
		    	POH_ShipToAddress       NVARCHAR(200) COLLATE Chinese_PRC_CI_AS NULL,
		    	POH_ConsigneePhone      NVARCHAR(200) COLLATE Chinese_PRC_CI_AS NULL,
		    	POH_Remark              NVARCHAR(400) COLLATE Chinese_PRC_CI_AS NULL,
		    	POH_InvoiceComment      NVARCHAR(200) COLLATE Chinese_PRC_CI_AS NULL,
		    	POH_CreateType          NVARCHAR(20) NOT NULL,
		    	POH_CreateUser          UNIQUEIDENTIFIER NOT NULL,
		    	POH_CreateDate          DATETIME NOT NULL,
		    	POH_UpdateUser          UNIQUEIDENTIFIER NULL,
		    	POH_UpdateDate          DATETIME NULL,
		    	POH_SubmitUser          UNIQUEIDENTIFIER NULL,
		    	POH_SubmitDate          DATETIME NULL,
		    	POH_LastBrowseUser      UNIQUEIDENTIFIER NULL,
		    	POH_LastBrowseDate      DATETIME NULL,
		    	POH_OrderStatus         NVARCHAR(20) COLLATE Chinese_PRC_CI_AS NOT NULL,
		    	POH_LatestAuditDate     DATETIME NULL,
		    	POH_IsLocked            BIT NOT NULL,
		    	POH_SAP_OrderNo         NVARCHAR(50) NULL,
		    	POH_SAP_ConfirmDate     DATETIME NULL,
		    	POH_LastVersion         INT NOT NULL,
		    	POH_OrderType           NVARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
		    	POH_VirtualDC           NVARCHAR(50) NULL,
		    	POH_SpecialPriceID      UNIQUEIDENTIFIER NULL,
		    	POH_WHM_ID              UNIQUEIDENTIFIER NULL,
		    	POH_POH_ID              UNIQUEIDENTIFIER NULL,
		    	POH_BU_NAME             NVARCHAR(50) NULL,
		    	PRIMARY KEY(POH_ID)
		    )
		    
		    CREATE TABLE #tmp_PurchaseOrderDetail
		    (
		    	POD_ID                 UNIQUEIDENTIFIER NOT NULL,
		    	POD_POH_ID             UNIQUEIDENTIFIER NOT NULL,
		    	POD_CFN_ID             UNIQUEIDENTIFIER NOT NULL,
		    	POD_CFN_Price          DECIMAL(18, 6) NULL,
		    	POD_UOM                NVARCHAR(100) COLLATE Chinese_PRC_CI_AS NULL,
		    	POD_RequiredQty        DECIMAL(18, 6) NULL,
		    	POD_Amount             DECIMAL(18, 6) NULL,
		    	POD_Tax                DECIMAL(18, 6) NULL,
		    	POD_ReceiptQty         DECIMAL(18, 6) NULL,
		    	POD_Status             NVARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
		    	POD_LotNumber          NVARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
		    	POD_ShipmentNbr        NVARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
		    	POD_HOS_ID             UNIQUEIDENTIFIER NULL,
		    	POD_WH_ID              UNIQUEIDENTIFIER NULL,
		    	POD_Field1             NVARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
		    	POD_Field2             NVARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
		    	POD_Field3             NVARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
		    	POD_CurRegNo           NVARCHAR(500) COLLATE Chinese_PRC_CI_AS NULL,
		    	POD_CurValidDateFrom   DATETIME NULL,
		    	POD_CurValidDataTo     DATETIME NULL,
		    	POD_CurManuName        NVARCHAR(500) COLLATE Chinese_PRC_CI_AS NULL,
		    	POD_LastRegNo          NVARCHAR(500) COLLATE Chinese_PRC_CI_AS NULL,
		    	POD_LastValidDateFrom  DATETIME NULL,
		    	POD_LastValidDataTo    DATETIME NULL,
		    	POD_LastManuName       NVARCHAR(500) COLLATE Chinese_PRC_CI_AS NULL,
		    	POD_CurGMKind          NVARCHAR(200) COLLATE Chinese_PRC_CI_AS NULL,
		    	POD_CurGMCatalog       NVARCHAR(200) COLLATE Chinese_PRC_CI_AS NULL,
		    	PRIMARY KEY(POD_ID)
		    )

		    --获取商业样品和测试样品经销商
		    SELECT @DmaCode = (CASE WHEN @SampleType = '商业样品' THEN '471287' ELSE '133897' END)
		    
		    SELECT @DmaID = DMA_ID
			FROM   DealerMaster
			WHERE  DMA_SAP_Code = @DmaCode;
		    
		    SELECT @ProductLineID = CFN_ProductLine_BUM_ID
		    FROM   SampleUpn,
		           Product,
		           CFN
		    WHERE  UpnNo = PMA_UPN
		           AND PMA_CFN_ID = CFN_ID
		           AND SortNo = 1
		           AND SampleHeadId = @SampleHeadId
		    
		    SELECT @WhmID = WHM_ID
		    FROM   Warehouse
		    WHERE  WHM_DMA_ID = @DmaID
		    AND    WHM_Type = 'DefaultWH'
		    
		    INSERT INTO #tmp_PurchaseOrderHeader
		      (POH_ID, POH_OrderNo, POH_ProductLine_BUM_ID, POH_DMA_ID, POH_VendorID, POH_OrderType, POH_CreateType, POH_CreateUser, 
		       POH_CreateDate, POH_OrderStatus, POH_IsLocked, POH_LastVersion, POH_WHM_ID, POH_SubmitDate, POH_SubmitUser, POH_Remark,
		       POH_Consignee,POH_ConsigneePhone,POH_ShipToAddress, POH_ContactPerson, POH_ContactMobile,POH_Contact,POH_InvoiceComment)
		    SELECT @SampleHeadId,
		           @SampleNo,
		           @ProductLineID,
		           @DmaID,
		           DMA_Parent_DMA_ID,
		         'SampleApply',
		           'Manual',
		           '00000000-0000-0000-0000-000000000000',
		           GETDATE(),
		           'Submitted',
		           0,
		           0,
		           Warehouse.WHM_ID,
		           GETDATE(),
		           '00000000-0000-0000-0000-000000000000',
		           isnull(applymemo,''),
		           ReceiptUser,
		           ReceiptPhone,
		           ReceiptAddress,
		           isnull(SampleApplyHead.ApplyUser,'')+'(CostCenter:' + isnull((select t3.CostCenter_Marketing
																				   from interface.T_I_QV_SalesRep t2, interface.T_I_QV_BUCostCenter t3
																				  where ApplyUserId=t2.UserAccount and t2.DivisionID = t3.DivisionID ),'Null') + ')' ,
		           (select Mobile from interface.T_I_QV_SalesRep where UserAccount=SampleApplyHead.ApplyUserID) AS ApplyUserMobile,
                   (select Email from interface.T_I_QV_SalesRep where UserAccount=SampleApplyHead.ApplyUserID) AS ApplyUserMobileEmail,
				   ConfirmItem3
		           --select *
		    FROM   SampleApplyHead,
		           Warehouse,
		           DealerMaster
		    WHERE  SampleapplyHeadId = @SampleHeadId
		           AND DMA_ID = WHM_DMA_ID
		           AND WHM_DMA_ID = @DmaID
		           AND WHM_Type = 'DefaultWH'
		    
		    --根据仓库，更新收货地址
		    --UPDATE #tmp_PurchaseOrderHeader
		    --SET    POH_ShipToAddress = WHM_Address
		    --FROM   Warehouse
		    --WHERE  WHM_ID = POH_WHM_ID
		    
		    --更新承运商
		    --UPDATE #tmp_PurchaseOrderHeader
		    --SET    POH_TerritoryCode = DMA_Certification
		    --FROM   DealerMaster
		    --WHERE  DMA_ID = POH_DMA_ID
		    
		    
		    --根据创建人，更新联系人信息
		    --UPDATE #tmp_PurchaseOrderHeader
		    --SET    POH_ContactPerson = DST_ContactPerson,
		    --       POH_Contact = DST_Contact,
		    --       POH_ContactMobile = DST_ContactMobile,
		    --       POH_Consignee = DST_Consignee,
		    --       POH_ConsigneePhone = DST_ConsigneePhone
		    --FROM   DealerShipTo
		    --WHERE  POH_CreateUser = DST_Dealer_User_ID
		    
		    --插入临时订单明细表(如果是警戒库存，则仍然按照安全库存标准进行更新)
		    INSERT INTO #tmp_PurchaseOrderDetail
		      (POD_ID, POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_RequiredQty, POD_Amount, POD_Tax, POD_ReceiptQty, POD_UOM, POD_LotNumber, POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3, POD_CurRegNo, POD_CurValidDateFrom, POD_CurValidDataTo, POD_CurManuName, POD_LastRegNo, POD_LastValidDateFrom, POD_LastValidDataTo, POD_LastManuName, POD_CurGMKind, POD_CurGMCatalog)
		    SELECT NEWID(),
		           POH_ID,
		           CFN_ID,
		           0,
		           CAST(ROUND(SampleUpn.ApplyQuantity, 2) AS NUMERIC(10)),
		           0,
		           0,
		           0,
		           CFN_Property3,
		           NULL,
		           SampleApplyHead.ApplyNo,
		           HOS_ID,
		           @WhmID,
		           '',
		           '',
		           '',
		           REG.CurRegNo,
		           REG.CurValidDateFrom,
		           REG.CurValidDataTo,
		           REG.CurManuName,
		           REG.LastRegNo,
		           REG.LastValidDateFrom,
		           REG.LastValidDataTo,
		           REG.LastManuName,
		           REG.CurGMKind,
		           REG.CurGMCatalog
		    FROM   #tmp_PurchaseOrderHeader
		           INNER JOIN SampleApplyHead
		                ON  (POH_OrderNo = ApplyNo)
		           INNER JOIN SampleUpn
		                ON  (SampleApplyHeadId = SampleHeadId)
		           INNER JOIN Product
		                ON  (UpnNo = PMA_UPN)
		           INNER JOIN CFN
		                ON  (PMA_CFN_ID = CFN_ID)
		           LEFT JOIN MD.V_INF_UPN_REG AS REG
		                ON  (CFN.CFN_CustomerFaceNbr = REG.CurUPN)
		           LEFT JOIN Hospital
		                ON  HOS_HospitalName = HospName collate Chinese_PRC_CI_AS
		    WHERE  SampleApplyHead.ApplyNo = @SampleNo
		    
		    --删除数量是0的记录
		    DELETE 
		    FROM   #tmp_PurchaseOrderDetail
		    WHERE  POD_RequiredQty = 0
		  
		    DELETE 
		    FROM   #tmp_PurchaseOrderHeader
		    WHERE  POH_ID NOT IN (SELECT POD_POH_ID
		                          FROM   #tmp_PurchaseOrderDetail)
		    
		    --更新金额
		    UPDATE t2
		    SET    POD_CFN_Price = CFNP_Price,
		           POD_Amount = POD_RequiredQty * CFNP_Price
		    FROM   #tmp_PurchaseOrderHeader t1,
		           #tmp_PurchaseOrderDetail t2,
		           CFNPrice t3
		    WHERE  t1.POH_ID = t2.POD_POH_ID
		           AND t1.POH_DMA_ID = t3.CFNP_Group_ID
		           AND t2.POD_CFN_ID = t3.CFNP_CFN_ID
		           AND t3.CFNP_PriceType = 'Dealer'
		    
		    --插入订单主表和明细表
		    INSERT INTO PurchaseOrderHeader
		      (POH_ID, POH_OrderNo, POH_ProductLine_BUM_ID, POH_DMA_ID, POH_VendorID, POH_TerritoryCode, POH_RDD, POH_ContactPerson, POH_Contact, POH_ContactMobile, POH_Consignee, POH_ShipToAddress, POH_ConsigneePhone, POH_Remark, POH_InvoiceComment, POH_CreateType, POH_CreateUser, POH_CreateDate, POH_UpdateUser, POH_UpdateDate, POH_SubmitUser, POH_SubmitDate, POH_LastBrowseUser, POH_LastBrowseDate, POH_OrderStatus, POH_LatestAuditDate, POH_IsLocked, POH_SAP_OrderNo, POH_SAP_ConfirmDate, POH_LastVersion, POH_OrderType, POH_VirtualDC, POH_SpecialPriceID, POH_WHM_ID, POH_POH_ID)
		    SELECT POH_ID,
		           POH_OrderNo,
		           POH_ProductLine_BUM_ID,
		           POH_DMA_ID,
		           POH_VendorID,
		           POH_TerritoryCode,
		           POH_RDD,
		           POH_ContactPerson,
		           POH_Contact,
		           POH_ContactMobile,
		           POH_Consignee,
		           POH_ShipToAddress,
		           POH_ConsigneePhone,
		           POH_Remark,
		           POH_InvoiceComment,
		           POH_CreateType,
		           POH_CreateUser,
		           POH_CreateDate,
		           POH_UpdateUser,
		           POH_UpdateDate,
		           POH_SubmitUser,
		           POH_SubmitDate,
		           POH_LastBrowseUser,
		           POH_LastBrowseDate,
		           POH_OrderStatus,
		           POH_LatestAuditDate,
		           POH_IsLocked,
		           POH_SAP_OrderNo,
		           POH_SAP_ConfirmDate,
		           POH_LastVersion,
		           POH_OrderType,
		           POH_VirtualDC,
		           POH_SpecialPriceID,
		           POH_WHM_ID,
		           POH_POH_ID
		    FROM   #tmp_PurchaseOrderHeader
		    
		    INSERT INTO PurchaseOrderDetail
		      (POD_ID, POD_POH_ID, POD_CFN_ID, POD_CFN_Price, POD_UOM, POD_RequiredQty, POD_Amount, POD_Tax, POD_ReceiptQty, POD_Status, POD_LotNumber, POD_ShipmentNbr, POD_HOS_ID, POD_WH_ID, POD_Field1, POD_Field2, POD_Field3, POD_CurRegNo, POD_CurValidDateFrom, POD_CurValidDataTo, POD_CurManuName, POD_LastRegNo, POD_LastValidDateFrom, POD_LastValidDataTo, POD_LastManuName, POD_CurGMKind, POD_CurGMCatalog, POD_QRCode)
		    SELECT POD_ID,
		           POD_POH_ID,
		           POD_CFN_ID,
		           POD_CFN_Price,
		           POD_UOM,
		           POD_RequiredQty,
		           POD_Amount,
		           POD_Tax,
		           POD_ReceiptQty,
		           POD_Status,
		           CASE 
		                WHEN CHARINDEX('@@', POD_LotNumber) > 0 THEN SUBSTRING(POD_LotNumber, 1, CHARINDEX('@@', POD_LotNumber) -1)
		                ELSE POD_LotNumber
		           END AS Lot,
		           POD_ShipmentNbr,
		           POD_HOS_ID,
		           POD_WH_ID,
		           POD_Field1,
		           POD_Field2,
		           POD_Field3,
		           POD_CurRegNo,
		           POD_CurValidDateFrom,
		           POD_CurValidDataTo,
		           POD_CurManuName,
		           POD_LastRegNo,
		           POD_LastValidDateFrom,
		           POD_LastValidDataTo,
		           POD_LastManuName,
		           POD_CurGMKind,
		           POD_CurGMCatalog,
		           CASE 
		                WHEN CHARINDEX('@@', POD_LotNumber) > 0 THEN SUBSTRING(
		                         POD_LotNumber,
		                         CHARINDEX('@@', POD_LotNumber) + 2,
		                         LEN(POD_LotNumber)
		                     )
		                ELSE ''
		           END AS QRCode
		    FROM   #tmp_PurchaseOrderDetail
		    
		    
		    --插入订单操作日志
		    INSERT INTO PurchaseOrderLog
		      (POL_ID, POL_POH_ID, POL_OperUser, POL_OperDate, POL_OperType, POL_OperNote)
		    SELECT NEWID(),
		           POH_ID,
		           POH_CreateUser,
		           GETDATE(),
		           'Generate',
		           NULL
		    FROM   #tmp_PurchaseOrderHeader
		    
		    --插入接口表
		    INSERT INTO PurchaseOrderInterface
		    SELECT NEWID(),
		           '',
		           '',
		           POH_ID,
		           POH_OrderNo,
		           'Pending',
		           'Manual',
		           NULL,
		           POH_CreateUser,
		           GETDATE(),
		           POH_CreateUser,
		           GETDATE(),
		           CLT_ID
		    FROM   #tmp_PurchaseOrderHeader
		           LEFT JOIN Client
		                ON  POH_VendorID = CLT_Corp_Id
		    WHERE  POH_OrderStatus = 'Submitted'
		END
		
		--发送邮件
		IF @ApplyType = '申请单' AND @SampleType = '测试样品' AND @SampleStatus = 'Approved'
		BEGIN

			DECLARE @MAIL_SUBJECT NVARCHAR(200)
			DECLARE @MAIL_BODY NVARCHAR(MAX)
			DECLARE @MAIL_CODE NVARCHAR(50)

			IF EXISTS (SELECT 1 FROM SampleTesting WHERE SampleHeadId = @SampleHeadId AND Certificate in ('续证','变更'))
				SELECT @MAIL_CODE = 'EMAIL_SAMPLE_NOTIFY_SS_PO'
			ELSE
				SELECT @MAIL_CODE = 'EMAIL_SAMPLE_NOTIFY_DP'

			IF EXISTS (SELECT 1 FROM MailMessageTemplate WHERE MMT_CODE = @MAIL_CODE)
			AND EXISTS (SELECT 1 FROM MailDeliveryAddress WHERE MDA_MAILTYPE = @MAIL_CODE)
			BEGIN
				SELECT @MAIL_SUBJECT=MMT_SUBJECT, @MAIL_BODY=MMT_BODY FROM MailMessageTemplate WHERE MMT_CODE = @MAIL_CODE
				SELECT @MAIL_SUBJECT = REPLACE(@MAIL_SUBJECT,'{#ApplyNo}',ApplyNo),
					   @MAIL_BODY = REPLACE(REPLACE(REPLACE(REPLACE(@MAIL_BODY,'{#ApplyNo}',ApplyNo),'{#ReceiptUser}',ReceiptUser),'{#ReceiptPhone}',ReceiptPhone),'{#ReceiptAddress}',ReceiptAddress)
				FROM SampleApplyHead WHERE SampleApplyHeadId = @SampleHeadId

				IF @MAIL_CODE = 'EMAIL_SAMPLE_NOTIFY_DP'
				BEGIN
					DECLARE @TABLE_UPN NVARCHAR(MAX)
					SET @TABLE_UPN = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
					SET @TABLE_UPN += '<table class="gridtable">'
					SET @TABLE_UPN += '<tr><th>UPN编号</th><th>申请数量</th></tr>'

				    DECLARE @UpnNo NVARCHAR(500);
				    DECLARE @UpnApplyQuantity NVARCHAR(500);			    
				    
				    DECLARE CUR_UPN CURSOR  
				    FOR
				        SELECT ISNULL(UpnNo, ''),
				               ISNULL(CONVERT(NVARCHAR,CONVERT(FLOAT,ApplyQuantity)), '')
				        FROM   SampleUpn
				        WHERE  SampleHeadId = @SampleHeadId
				        ORDER BY SortNo
				    
				    OPEN CUR_UPN
				    FETCH NEXT FROM CUR_UPN INTO @UpnNo, @UpnApplyQuantity
				    WHILE @@FETCH_STATUS = 0
				    BEGIN
						SET @TABLE_UPN += '<tr><td>' + @UpnNo + '</td><td>' + @UpnApplyQuantity + '</td></tr>'
				        
				        FETCH NEXT FROM CUR_UPN INTO @UpnNo, @UpnApplyQuantity
				    END
				    CLOSE CUR_UPN
				    DEALLOCATE CUR_UPN
				    
				    SET @TABLE_UPN += '</table>'

				    SET @MAIL_BODY = REPLACE(@MAIL_BODY,'{#UPN_LIST}',@TABLE_UPN)
				END

				INSERT INTO dbo.MailMessageQueue
					(
					MMQ_ID,
					MMQ_QueueNo,
					MMQ_From,
					MMQ_To,
					MMQ_Subject,
					MMQ_Body,
					MMQ_Status,
					MMQ_CreateDate
					)
				SELECT NEWID(),'email','',MDA_MAILADDRESS,@MAIL_SUBJECT,@MAIL_BODY,'Waiting',GETDATE()
				FROM MailDeliveryAddress
				WHERE MDA_MAILTYPE = @MAIL_CODE

			END
		END

		
		COMMIT TRAN
		RETURN 1
	END TRY
	
	BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000);
	SELECT @ErrorMessage = ERROR_MESSAGE()
	RAISERROR(@ErrorMessage,16,1)
		ROLLBACK TRAN
		RETURN -1
	END CATCH
END
GO


