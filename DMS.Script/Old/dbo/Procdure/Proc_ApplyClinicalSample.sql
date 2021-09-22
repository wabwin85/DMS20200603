DROP PROCEDURE [dbo].[Proc_ApplyClinicalSample]
GO

CREATE PROCEDURE [dbo].[Proc_ApplyClinicalSample](
    @UserId          NVARCHAR(500),
    @ApplyDate       NVARCHAR(500),
    @ApplyUser       NVARCHAR(500),
    @ApplyUserId     NVARCHAR(500),
    @CostCenter      NVARCHAR(500),
    @DeptCode        NVARCHAR(500),
    @ApplyPurpose    NVARCHAR(500),
    @HospId          NVARCHAR(500),
    @HospName        NVARCHAR(500),
    @HpspAddress     NVARCHAR(500),
    @HcpId           NVARCHAR(500),
    @TrialDoctor     NVARCHAR(500),
    @ReceiptUser     NVARCHAR(500),
    @ReceiptPhone    NVARCHAR(500),
    @ReceiptAddress  NVARCHAR(500),
    @ApplyMemo       NVARCHAR(500),
    @ConfirmItem1    NVARCHAR(500),
    @ConfirmItem2    NVARCHAR(500),
    @UpnList         XML
)
AS
BEGIN
	--TODO CHECK
	SELECT doc.col.value('UpnNo[1]', 'NVARCHAR(500)') UpnNo,
	       doc.col.value('ProductName[1]', 'NVARCHAR(500)') ProductName,
	       doc.col.value('ProductDesc[1]', 'NVARCHAR(500)') ProductDesc,
	       doc.col.value('ApplyQuantity[1]', 'INT') ApplyQuantity,
	       doc.col.value('ProductMemo[1]', 'NVARCHAR(500)') ProductMemo,
	       doc.col.value('Cost[1]', 'NVARCHAR(500)') Cost,
	       doc.col.value('Level4Code[1]', 'NVARCHAR(500)') Level4Code,
	       doc.col.value('Level5Code[1]', 'NVARCHAR(500)') Level5Code,
	       doc.col.value('SortNo[1]', 'INT') SortNo INTO #TmpUpn
	FROM   @UpnList.nodes('/UpnList/Upn') doc(col)
	
	
	
	IF EXISTS (
	       SELECT 1
	       FROM   #TmpUpn
	       WHERE  CONVERT(MONEY, Cost) = 0
	   )
	BEGIN
	    RAISERROR ('UPN没有Cost不允许做申请，请联系Finance BP！', 16, 1) ;
	    RETURN;
	END
	
	SELECT HcpId,
	       Level4Code,
	       Level5Code,
	       SUM(ApplyQuantity -ReturnQuantity) CurrentQuantity INTO #TmpQuantity
	FROM   (
	           SELECT A.HcpId,
	                  B.Level4Code,
	                  B.Level5Code,
	                  CONVERT(INT, B.ApplyQuantity) ApplyQuantity,
	                  (
	                      SELECT ISNULL(SUM(TA.ApplyQuantity), 0)
	                      FROM   SampleUpn TA,
	                             SampleReturnHead TB
	                      WHERE  TA.SampleHeadId = TB.SampleReturnHeadId
	                             AND TB.ReturnStatus <> 'Deny'
	                             AND TB.ApplyNo = A.ApplyNo
	                             AND TA.UpnNo = B.UpnNo
	                  ) ReturnQuantity
	           FROM   SampleApplyHead A,
	                  SampleUpn B
	           WHERE  A.SampleApplyHeadId = b.SampleHeadId
	                  AND A.ApplyStatus <> 'Deny'
	                  AND A.HcpId = @HcpId
	                  AND EXISTS (
	                          SELECT 1
	                          FROM   #TmpUpn C
	                          WHERE  B.Level4Code = C.Level4Code
	                      )
	           UNION ALL
	           SELECT @HcpId,
	                  Level4Code,
	                  Level5Code,
	                  ApplyQuantity,
	                  0
	           FROM   #TmpUpn
	       ) T
	GROUP BY HcpId, Level4Code, Level5Code
	
	
	
	BEGIN TRY
		BEGIN TRAN
		DECLARE @ApplyHeadId UNIQUEIDENTIFIER;
		DECLARE @ApplyNo NVARCHAR(500);
		DECLARE @DealerId UNIQUEIDENTIFIER;
		DECLARE @DealerName NVARCHAR(500);
		DECLARE @ApplyPurposeValue NVARCHAR(20);
		DECLARE @UpnIndex INT;
    DECLARE @DivisionCode NVARCHAR(10);
		
		SELECT @DealerId = DMA_ID,
		       @DealerName = DMA_ChineseName
		FROM   DealerMaster
		WHERE  DMA_SAP_Code = '471288';
		
		SET @ApplyHeadId = NEWID();
		
		SET @ApplyNo = ''
		EXEC dbo.[GC_GetNextAutoNumberForSampleClin] @DeptCode, 'S', 'Next_ClinicalSampleApplyNbr', @ApplyNo OUTPUT
    
    
		
		INSERT INTO SampleApplyHead
		  (SampleApplyHeadId, SampleType, ApplyNo, DealerId, ApplyDate, ApplyUserId, ApplyUser, ProcessUserId, ProcessUser, ApplyPurpose,  HospName, HpspAddress, HcpId, TrialDoctor, ReceiptUser, ReceiptPhone, ReceiptAddress, DealerName, ApplyMemo, ConfirmItem1, ConfirmItem2, CostCenter, ApplyStatus, CreateUser, CreateDate)
		VALUES
		  (@ApplyHeadId, '临床样品', @ApplyNo, @DealerId, @ApplyDate, @ApplyUserId, @ApplyUser, @ApplyUserId, @ApplyUser, @ApplyPurpose,  @HospName, @HpspAddress, @HcpId, @TrialDoctor, @ReceiptUser, @ReceiptPhone, @ReceiptAddress, @DealerName, @ApplyMemo, @ConfirmItem1, @ConfirmItem2, @CostCenter, 'Approved', @UserId, GETDATE())
		
		
		DECLARE @UpnNo NVARCHAR(500);
		DECLARE @ProductName NVARCHAR(500);
		DECLARE @ProductDesc NVARCHAR(500);
		DECLARE @ApplyQuantity INT;
		DECLARE @ProductMemo NVARCHAR(500);
		DECLARE @Cost NVARCHAR(500);
		DECLARE @Level4Code NVARCHAR(500);
		DECLARE @Level5Code NVARCHAR(500);
		DECLARE @SortNo INT;
		DECLARE @UpnStr NVARCHAR(2000);
		DECLARE @UpnAmount MONEY;
		SET @UpnStr = '';
		SET @UpnAmount = 0;
		SET @UpnIndex = 1;
		
		DECLARE CUR_UPN CURSOR  
		FOR
		    SELECT doc.col.value('UpnNo[1]', 'NVARCHAR(500)'),
		           doc.col.value('ProductName[1]', 'NVARCHAR(500)'),
		           doc.col.value('ProductDesc[1]', 'NVARCHAR(500)'),
		           doc.col.value('ApplyQuantity[1]', 'INT'),
		           doc.col.value('ProductMemo[1]', 'NVARCHAR(500)'),
		           doc.col.value('Cost[1]', 'NVARCHAR(500)'),
		           doc.col.value('Level4Code[1]', 'NVARCHAR(500)'),
		           doc.col.value('Level5Code[1]', 'NVARCHAR(500)'),
		           doc.col.value('SortNo[1]', 'INT')
		    FROM   @UpnList.nodes('/UpnList/Upn') doc(col)
		
		OPEN CUR_UPN
		FETCH NEXT FROM CUR_UPN INTO @UpnNo,@ProductName,@ProductDesc,@ApplyQuantity,@ProductMemo,@Cost,@Level4Code,@Level5Code,@SortNo
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
		    SET @UpnStr += '<R Index="' + CONVERT(NVARCHAR(10), @UpnIndex) + '"><UPN><![CDATA[' + @UpnNo + ']]></UPN></R>';
		    SET @UpnIndex = @UpnIndex + 1;
		    SET @UpnAmount += @ApplyQuantity * CONVERT(MONEY, @Cost);
		    
		    INSERT INTO SampleUpn
		      (SampleUpnId, SampleHeadId, UpnNo, ProductName, ProductDesc, ApplyQuantity, ProductMemo, Cost, Level4Code, Level5Code, SortNo, CreateUser, CreateDate)
		    VALUES
		      (NEWID(), @ApplyHeadId, @UpnNo, @ProductName, @ProductDesc, @ApplyQuantity, @ProductMemo, @Cost, @Level4Code, @Level5Code, @SortNo, @UserId, GETDATE())
		    
		    FETCH NEXT FROM CUR_UPN INTO @UpnNo,@ProductName,@ProductDesc,@ApplyQuantity,@ProductMemo,@Cost,@Level4Code,@Level5Code,@SortNo
		END
		CLOSE CUR_UPN
		DEALLOCATE CUR_UPN
		
		INSERT INTO ScoreCardLog
		  (SCL_ID, SCL_ESC_ID, SCL_OperUser, SCL_OperDate, SCL_OperType, SCL_OperNote)
		VALUES
		  (NEWID(), @ApplyHeadId, @ApplyUser, GETDATE(), '创建申请单', '')
		
		
    

		
     
    --后续操作：
    --1、更新申请单对应的Division      
    --2、生成订单  
    --3、生成接口
    SELECT @DivisionCode = DivisionCode 
      FROM V_DivisionProductLineRelation t1, cfn t2 
     WHERE t1.ProductLineID=t2.CFN_ProductLine_BUM_ID and t2.CFN_CustomerFaceNbr=@UpnNo
    
    UPDATE SampleApplyHead set ApplyDivision = @DivisionCode where SampleApplyHeadId = @ApplyHeadId
    
      insert into PurchaseOrderHeader (POH_ID,POH_OrderNo,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_VendorID,POH_ContactPerson,POH_ContactMobile,POH_ShipToAddress,POH_CreateType,
      POH_CreateUser,POH_CreateDate,POH_SubmitUser,POH_SubmitDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_OrderType,POH_WHM_ID,POH_Consignee,POH_ConsigneePhone, POH_Remark )
      select SampleApplyHeadId,ApplyNo,ProductLineID,DMA_ID,DMA_Parent_DMA_ID,isnull(ApplyUser,'')  + '(' + isnull(CostCenter,'') + ')','',ReceiptAddress,'Manual',
      Id,GETDATE(),Id,GETDATE(),'Submitted',0,1,'SampleApply',WHM_ID,isnull(ReceiptUser,''),isnull(ReceiptPhone,'') + ';' + isnull(ConfirmItem1,''),isnull(ApplyMemo,'') + ';医院SAP ID：'+ isnull(ConfirmItem2,'')
      from SampleApplyHead,V_DivisionProductLineRelation,DealerMaster,Lafite_IDENTITY,Warehouse
      where ApplyDivision = DivisionCode
      and DMA_SAP_Code='471288'
      and DMA_ID = WHM_DMA_ID
      and DMA_ID = Lafite_IDENTITY.Corp_ID
      and whm_type = 'DefaultWH'
      and SampleApplyHeadId= @ApplyHeadId
      
      
      insert into PurchaseOrderDetail (
       POD_ID
      ,POD_POH_ID
      ,POD_CFN_ID
      ,POD_CFN_Price
      ,POD_UOM
      ,POD_RequiredQty
      ,POD_Amount
      ,POD_Tax
      ,POD_ReceiptQty
      ,POD_Status
      ,POD_LotNumber
      ,POD_ShipmentNbr
      ,POD_HOS_ID
      ,POD_WH_ID
      ,POD_Field1
      ,POD_Field2
      ,POD_Field3
      ,POD_CurRegNo
      ,POD_CurValidDateFrom
      ,POD_CurValidDataTo
      ,POD_CurManuName
      ,POD_LastRegNo
      ,POD_LastValidDateFrom
      ,POD_LastValidDataTo
      ,POD_LastManuName
      ,POD_CurGMKind
      ,POD_CurGMCatalog
      ,POD_QRCode
      )
      select NEWID(),SampleHeadId,CFN_ID,0,PMA_UnitOfMeasure, ApplyQuantity,0,0,0,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null
      from SampleUpn,Product,CFN
      where UpnNo = PMA_UPN
      and PMA_CFN_ID = CFN_ID     
      and SampleHeadId= @ApplyHeadId
      
      INSERT INTO PurchaseOrderInterface (POI_ID,POI_BatchNbr,POI_RecordNbr,POI_POH_ID,POI_POH_OrderNo,POI_Status,POI_ProcessType
        ,POI_FileName,POI_CreateUser,POI_CreateDate,POI_UpdateUser,POI_UpdateDate,POI_ClientID) 
      SELECT newid(),'','',@ApplyHeadId,@ApplyNo,'Pending','Manual',null,
            '12B2B080-E1E3-432C-BDF5-2CA03BCBA662',getdate(),'12B2B080-E1E3-432C-BDF5-2CA03BCBA662',getdate(),'EAI'
		
		COMMIT TRAN
	END TRY
	
	BEGIN CATCH
		ROLLBACK TRAN
		DECLARE @error_number INT
		DECLARE @error_serverity INT
		DECLARE @error_state INT
		DECLARE @error_message NVARCHAR(256)
		DECLARE @error_line INT
		DECLARE @error_procedure NVARCHAR(256)
		DECLARE @vError NVARCHAR(1000)
		DECLARE @vSyncTime DATETIME	
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = ISNULL(@error_procedure, '') + '第' + CONVERT(NVARCHAR(10), ISNULL(@error_line, ''))
		    + '行出错[错误号：' + CONVERT(NVARCHAR(10), ISNULL(@error_number, ''))
		    + ']，' + ISNULL(@error_message, '')
		
		RAISERROR(@vError, @error_serverity, @error_state)
	END CATCH
END