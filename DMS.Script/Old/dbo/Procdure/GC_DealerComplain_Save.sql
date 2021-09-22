DROP PROCEDURE [dbo].[GC_DealerComplain_Save]
GO

CREATE PROCEDURE [dbo].[GC_DealerComplain_Save]
@UserId uniqueidentifier, @CorpId uniqueidentifier, @ComplainType nvarchar(20), @ComplainInfo xml, @Result nvarchar(2000) = 'a' OUTPUT
WITH EXEC AS CALLER
AS
BEGIN TRY
	BEGIN TRAN
	SELECT @Result = 'Init'
  DECLARE @SystemHoldWarehouseID UNIQUEIDENTIFIER
  DECLARE @EmptyGuid     UNIQUEIDENTIFIER
  DECLARE @InstanceID UNIQUEIDENTIFIER
  
  DECLARE @WHMTYPE NVARCHAR(50)
  DECLARE @UPNDESC nvarchar(2000)
    
  SET @EmptyGuid = '00000000-0000-0000-0000-000000000000'
  
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
	
	IF @ComplainType = 'BSC'
	BEGIN
	    DECLARE @EID NVARCHAR(200);
	    DECLARE @REQUESTDATE NVARCHAR(200);
	    DECLARE @INITIALNAME NVARCHAR(200);
	    DECLARE @INITIALPHONE NVARCHAR(200);
	    DECLARE @INITIALJOB NVARCHAR(200);
	    DECLARE @INITIALEMAIL NVARCHAR(200);
	    DECLARE @PHYSICIAN NVARCHAR(200);
	    DECLARE @PHYSICIANPHONE NVARCHAR(200);
	    DECLARE @FIRSTBSCNAME NVARCHAR(200);
	    DECLARE @BSCAWAREDATE NVARCHAR(200);
	    DECLARE @NOTIFYDATE NVARCHAR(200);
	    DECLARE @CONTACTMETHOD NVARCHAR(200);
	    DECLARE @COMPLAINTSOURCE NVARCHAR(200);
	    DECLARE @FEEDBACKREQUESTED NVARCHAR(200);
	    DECLARE @FEEDBACKSENDTO NVARCHAR(200);
	    DECLARE @COMPLAINTID NVARCHAR(200);
	    DECLARE @REFERBOX NVARCHAR(200);
	    DECLARE @PRODUCTTYPE NVARCHAR(200);
	    DECLARE @RETURNTYPE NVARCHAR(200);
	    DECLARE @ISPLATFORM NVARCHAR(200);
	    DECLARE @BSCSOLDTOACCOUNT NVARCHAR(200);
	    DECLARE @BSCSOLDTONAME NVARCHAR(200);
	    DECLARE @BSCSOLDTOCITY NVARCHAR(200);
	    DECLARE @SUBSOLDTONAME NVARCHAR(200);
	    DECLARE @SUBSOLDTOCITY NVARCHAR(200);
	    DECLARE @DISTRIBUTORCUSTOMER NVARCHAR(200);
	    DECLARE @DISTRIBUTORCITY NVARCHAR(200);
	    DECLARE @UPN NVARCHAR(200);
	    DECLARE @DESCRIPTION NVARCHAR(200);
	    DECLARE @LOT NVARCHAR(200);
	    DECLARE @BU NVARCHAR(200);
	    DECLARE @SINGLEUSE NVARCHAR(200);
	    DECLARE @RESTERILIZED NVARCHAR(200);
	    DECLARE @PREPROCESSOR NVARCHAR(200);
	    DECLARE @USEDEXPIRY NVARCHAR(200);
	    DECLARE @UPNEXPECTED NVARCHAR(200);
	    DECLARE @UPNQUANTITY NVARCHAR(200);
	    DECLARE @NORETURN NVARCHAR(200);
	    DECLARE @NORETURNREASON NVARCHAR(200);
	    DECLARE @INITIALPDATE NVARCHAR(200);
	    DECLARE @PNAME NVARCHAR(200);
	    DECLARE @INDICATION NVARCHAR(200);
	    DECLARE @IMPLANTEDDATE NVARCHAR(200);
	    DECLARE @EXPLANTEDDATE NVARCHAR(200);
	    DECLARE @POUTCOME NVARCHAR(200);
	    DECLARE @IVUS NVARCHAR(200);
	    DECLARE @GENERATOR NVARCHAR(200);
	    DECLARE @GENERATORTYPE NVARCHAR(200);
	    DECLARE @GENERATORSET NVARCHAR(200);
	    DECLARE @PCONDITION NVARCHAR(200);
	    DECLARE @PCONDITIONOTHER NVARCHAR(200);
	    DECLARE @EDATE NVARCHAR(200);
	    DECLARE @WHEREOCCUR NVARCHAR(200);
	    DECLARE @WHENNOTICED NVARCHAR(200);
	    DECLARE @EDESCRIPTION NVARCHAR(400);
	    DECLARE @WITHLABELEDUSE NVARCHAR(200);
	    DECLARE @NOLABELEDUSE NVARCHAR(200);
	    DECLARE @EVENTRESOLVED NVARCHAR(200);
      DECLARE @BSCSALESNAME NVARCHAR(200);
      DECLARE @BSCSALESPHONE NVARCHAR(200);
      DECLARE @COMPLAINNBR NVARCHAR(200);
      DECLARE @WHMID NVARCHAR(200);
      DECLARE @RETURNNUM NVARCHAR(50);
      DECLARE @CONVERTFACTOR NVARCHAR(50);
      DECLARE @UPNExpDate NVARCHAR(50);
      DECLARE @EFINSTANCECODE NVARCHAR(50);
      DECLARE @HOSPITAL NVARCHAR(50);
      DECLARE @REGISTRATION NVARCHAR(200);
      DECLARE @SALESDATE NVARCHAR(50);
	    
	    SELECT @EID = doc.col.value('EID[1]', 'NVARCHAR(200)'),
	           @REQUESTDATE = doc.col.value('REQUESTDATE[1]', 'NVARCHAR(200)'),
	           @INITIALNAME = doc.col.value('INITIALNAME[1]', 'NVARCHAR(200)'),
	           @INITIALPHONE = doc.col.value('INITIALPHONE[1]', 'NVARCHAR(200)'),
	           @INITIALJOB = doc.col.value('INITIALJOB[1]', 'NVARCHAR(200)'),
	           @INITIALEMAIL = doc.col.value('INITIALEMAIL[1]', 'NVARCHAR(200)'),
	           @PHYSICIAN = doc.col.value('PHYSICIAN[1]', 'NVARCHAR(200)'),
	           @PHYSICIANPHONE = doc.col.value('PHYSICIANPHONE[1]', 'NVARCHAR(200)'),
	           @FIRSTBSCNAME = doc.col.value('FIRSTBSCNAME[1]', 'NVARCHAR(200)'),
	           @BSCAWAREDATE = doc.col.value('BSCAWAREDATE[1]', 'NVARCHAR(200)'),
	           @NOTIFYDATE = doc.col.value('NOTIFYDATE[1]', 'NVARCHAR(200)'),
	           @CONTACTMETHOD = doc.col.value('CONTACTMETHOD[1]', 'NVARCHAR(200)'),
	           @COMPLAINTSOURCE = doc.col.value('COMPLAINTSOURCE[1]', 'NVARCHAR(200)'),
	           @FEEDBACKREQUESTED = doc.col.value('FEEDBACKREQUESTED[1]', 'NVARCHAR(200)'),
	           @FEEDBACKSENDTO = doc.col.value('FEEDBACKSENDTO[1]', 'NVARCHAR(200)'),
	           @COMPLAINTID = doc.col.value('COMPLAINTID[1]', 'NVARCHAR(200)'),
	           @REFERBOX = doc.col.value('REFERBOX[1]', 'NVARCHAR(200)'),
	           @PRODUCTTYPE = doc.col.value('PRODUCTTYPE[1]', 'NVARCHAR(200)'),
	           @RETURNTYPE = doc.col.value('RETURNTYPE[1]', 'NVARCHAR(200)'),
	           @ISPLATFORM = doc.col.value('ISPLATFORM[1]', 'NVARCHAR(200)'),
	           @BSCSOLDTOACCOUNT = doc.col.value('BSCSOLDTOACCOUNT[1]', 'NVARCHAR(200)'),
	           @BSCSOLDTONAME = doc.col.value('BSCSOLDTONAME[1]', 'NVARCHAR(200)'),
	           @BSCSOLDTOCITY = doc.col.value('BSCSOLDTOCITY[1]', 'NVARCHAR(200)'),
	           @SUBSOLDTONAME = doc.col.value('SUBSOLDTONAME[1]', 'NVARCHAR(200)'),
	           @SUBSOLDTOCITY = doc.col.value('SUBSOLDTOCITY[1]', 'NVARCHAR(200)'),
	           @DISTRIBUTORCUSTOMER = doc.col.value('DISTRIBUTORCUSTOMER[1]', 'NVARCHAR(200)'),
	           @DISTRIBUTORCITY = doc.col.value('DISTRIBUTORCITY[1]', 'NVARCHAR(200)'),
	           @UPN = doc.col.value('UPN[1]', 'NVARCHAR(200)'),
	           @DESCRIPTION = doc.col.value('DESCRIPTION[1]', 'NVARCHAR(200)'),
	           @LOT = doc.col.value('LOT[1]', 'NVARCHAR(200)'),
	           @BU = doc.col.value('BU[1]', 'NVARCHAR(200)'),
	           @SINGLEUSE = doc.col.value('SINGLEUSE[1]', 'NVARCHAR(200)'),
	           @RESTERILIZED = doc.col.value('RESTERILIZED[1]', 'NVARCHAR(200)'),
	           @PREPROCESSOR = doc.col.value('PREPROCESSOR[1]', 'NVARCHAR(200)'),
	           @USEDEXPIRY = doc.col.value('USEDEXPIRY[1]', 'NVARCHAR(200)'),
	           @UPNEXPECTED = doc.col.value('UPNEXPECTED[1]', 'NVARCHAR(200)'),
	           @UPNQUANTITY = doc.col.value('UPNQUANTITY[1]', 'NVARCHAR(200)'),
	           @NORETURN = doc.col.value('NORETURN[1]', 'NVARCHAR(200)'),
	           @NORETURNREASON = doc.col.value('NORETURNREASON[1]', 'NVARCHAR(200)'),
	           @INITIALPDATE = doc.col.value('INITIALPDATE[1]', 'NVARCHAR(200)'),
	           @PNAME = doc.col.value('PNAME[1]', 'NVARCHAR(200)'),
	           @INDICATION = doc.col.value('INDICATION[1]', 'NVARCHAR(200)'),
	           @IMPLANTEDDATE = doc.col.value('IMPLANTEDDATE[1]', 'NVARCHAR(200)'),
	           @EXPLANTEDDATE = doc.col.value('EXPLANTEDDATE[1]', 'NVARCHAR(200)'),
	           @POUTCOME = doc.col.value('POUTCOME[1]', 'NVARCHAR(200)'),
	           @IVUS = doc.col.value('IVUS[1]', 'NVARCHAR(200)'),
	           @GENERATOR = doc.col.value('GENERATOR[1]', 'NVARCHAR(200)'),
	           @GENERATORTYPE = doc.col.value('GENERATORTYPE[1]', 'NVARCHAR(200)'),
	           @GENERATORSET = doc.col.value('GENERATORSET[1]', 'NVARCHAR(200)'),
	           @PCONDITION = doc.col.value('PCONDITION[1]', 'NVARCHAR(200)'),
	           @PCONDITIONOTHER = doc.col.value('PCONDITIONOTHER[1]', 'NVARCHAR(200)'),
	           @EDATE = doc.col.value('EDATE[1]', 'NVARCHAR(200)'),
	           @WHEREOCCUR = doc.col.value('WHEREOCCUR[1]', 'NVARCHAR(200)'),
	           @WHENNOTICED = doc.col.value('WHENNOTICED[1]', 'NVARCHAR(200)'),
	           @EDESCRIPTION = doc.col.value('EDESCRIPTION[1]', 'NVARCHAR(400)'),
	           @WITHLABELEDUSE = doc.col.value('WITHLABELEDUSE[1]', 'NVARCHAR(200)'),
	           @NOLABELEDUSE = doc.col.value('NOLABELEDUSE[1]', 'NVARCHAR(200)'),
	           @EVENTRESOLVED = doc.col.value('EVENTRESOLVED[1]', 'NVARCHAR(200)'),
             @BSCSALESNAME = doc.col.value('BSCSALESNAME[1]', 'NVARCHAR(200)'),
             @BSCSALESPHONE = doc.col.value('BSCSALESPHONE[1]', 'NVARCHAR(200)'),
             @COMPLAINNBR = doc.col.value('COMPLAINNBR[1]', 'NVARCHAR(200)'),
             @WHMID = doc.col.value('WHMID[1]', 'NVARCHAR(200)'),
             @RETURNNUM = doc.col.value('RETURNNUM[1]', 'NVARCHAR(200)'),
             @CONVERTFACTOR = doc.col.value('CONVERTFACTOR[1]', 'NVARCHAR(200)'),
             @UPNExpDate = doc.col.value('UPNEXPDATE[1]', 'NVARCHAR(200)'),
             @EFINSTANCECODE = doc.col.value('EFINSTANCECODE[1]', 'NVARCHAR(200)'),
             @HOSPITAL =  doc.col.value('HOSPITAL[1]', 'NVARCHAR(50)'),
             @REGISTRATION = doc.col.value('REGISTRATION[1]', 'NVARCHAR(200)'),
             @SALESDATE = doc.col.value('SALESDATE[1]', 'NVARCHAR(50)')
             
	    FROM   @ComplainInfo.nodes('/DealerComplain') doc(col);
	    
	    
	    
	    IF @LOT = '' OR @UPN = '' OR NOT EXISTS (	SELECT 1
	        	          	FROM   LotMaster LM
	        	          	WHERE  LM.LTM_LotNumber = @LOT
	        	          	       AND EXISTS (	SELECT 1
	        	          	            	      	FROM   Product P
	        	          	            	      	WHERE  P.PMA_ID = LM.LTM_Product_PMA_ID
	        	          	            	      	       AND P.PMA_UPN = @UPN ) )
	    BEGIN
	        SELECT @Result = '无效的UPN和批次'
	    END
	    
	    IF @Result = 'Init'
	    BEGIN
	        select @InstanceID=newid()
	        
	        insert into dbo.tmp_dealercomplainsave
          select @InstanceID,@UserId,@CorpId,@ComplainInfo,GETDATE()
	    
	    --获取产品有效期    
        select @UPNExpDate = LTM_ExpiredDate from cfn t1, product t2, LotMaster t3
		where t1.CFN_ID=t2.PMA_CFN_ID and t2.PMA_ID=t3.LTM_Product_PMA_ID and t3.LTM_LotNumber=@LOT and t1.CFN_CustomerFaceNbr=@UPN
          
        if ISNULL(@COMPLAINNBR,'') = ''
	    begin
	    DECLARE @m_OrderNo nvarchar(50)
	    EXEC [GC_GetNextAutoNumber] @CorpId,'Next_ComplainNbr','', @m_OrderNo output
		select  @COMPLAINNBR = @m_OrderNo 
		end
		
		IF ISNULL(@DISTRIBUTORCUSTOMER,'') = ''
		BEGIN
			SELECT @DISTRIBUTORCUSTOMER =  @HOSPITAL
		END
		
		if(@REGISTRATION = '')
	        begin
				select @REGISTRATION =REG_NO from MD.V_INF_UPN_REG_LIST t1,
				  (
				  select REG_NO.CFN_CustomerFaceNbr , max(REG_NO.VALID_DATE_FROM) As ValidDateFrom from MD.V_INF_UPN_REG_LIST REG_NO where REG_NO.VALID_DATE_TO is not null and Reg_No.CFN_CustomerFaceNbr = @UPN group by REG_NO.CFN_CustomerFaceNbr
				  ) t2
				  where t1.CFN_CustomerFaceNbr=t2.CFN_CustomerFaceNbr and t1.VALID_DATE_FROM =t2.ValidDateFrom and t1.CFN_CustomerFaceNbr =@UPN
	        end
	     if(@SALESDATE = '')
	        begin
				select @SALESDATE = max(convert(nvarchar(30),PRH_SapDeliveryDate,121))  from POReceiptHeader,POReceipt,POReceiptLot
				where PRH_ID = POR_PRH_ID
				and POR_ID = PRL_POR_ID
				and POR_SAP_PMA_ID = @UPN
				and PRL_LotNumber = @LOT
				and PRH_Dealer_DMA_ID = @CorpId
				and PRH_Type in ('PurchaseOrder','Retail')
	        end
          
          INSERT INTO DealerComplain
	          (
	            DC_ID,
	            DC_ComplainNbr,
	            DC_CorpId,
	            DC_Status,
	            DC_CreatedBy,
	            DC_CreatedDate,
	            DC_LastModifiedBy,
	            DC_LastModifiedDate,
	            EID,
	            REQUESTDATE,
	            INITIALNAME,
	            INITIALPHONE,
	            INITIALJOB,
	            INITIALEMAIL,
	            PHYSICIAN,
	            PHYSICIANPHONE,
	            FIRSTBSCNAME,
	            BSCAWAREDATE,
	            NOTIFYDATE,
	            CONTACTMETHOD,
	            COMPLAINTSOURCE,
	            FEEDBACKREQUESTED,
	            FEEDBACKSENDTO,
	            COMPLAINTID,
	            REFERBOX,
	            PRODUCTTYPE,
	            RETURNTYPE,
	            ISPLATFORM,
	            BSCSOLDTOACCOUNT,
	            BSCSOLDTONAME,
	            BSCSOLDTOCITY,
	            SUBSOLDTONAME,
	            SUBSOLDTOCITY,
	            DISTRIBUTORCUSTOMER,
	            DISTRIBUTORCITY,
	            UPN,
	            [DESCRIPTION],
	            LOT,
	            BU,
	            SINGLEUSE,
	            RESTERILIZED,
	            PREPROCESSOR,
	            USEDEXPIRY,
	            UPNEXPECTED,
	            UPNQUANTITY,
	            NORETURN,
	            NORETURNREASON,
	            INITIALPDATE,
	            PNAME,
	            INDICATION,
	            IMPLANTEDDATE,
	            EXPLANTEDDATE,
	            POUTCOME,
	            IVUS,
	            GENERATOR,
	            GENERATORTYPE,
	            GENERATORSET,
	            PCONDITION,
	            PCONDITIONOTHER,
	            EDATE,
	            WHEREOCCUR,
	            WHENNOTICED,
	            EDESCRIPTION,
	            WITHLABELEDUSE,
	            NOLABELEDUSE,
	            EVENTRESOLVED,
              BSCSALESNAME,
              BSCSALESPHONE,
              WHM_ID,
              ReturnNum,
              ConvertFactor,
              UPNExpDate,
              CONFIRMRETURNTYPE,
              EFINSTANCECODE,
              Registration,
              SalesDate
	          )
	        VALUES
	          (
	            @InstanceID,
	            @COMPLAINNBR,
	            @CorpId,
	            'Submit',
	            @UserId,
	            GETDATE(),
	            @UserId,
	            GETDATE(),
	            @UserId,
	            CASE WHEN ISNULL(@REQUESTDATE,'') = '' THEN NULL ELSE CONVERT(DATETIME,@REQUESTDATE,121) END,
	            @INITIALNAME,
	            @INITIALPHONE,
	            @INITIALJOB,
	            @INITIALEMAIL,
	            @PHYSICIAN,
	            @PHYSICIANPHONE,
	            @FIRSTBSCNAME,
	            CASE WHEN ISNULL(@BSCAWAREDATE,'') = '' THEN NULL ELSE CONVERT(DATETIME,@BSCAWAREDATE,121) END,
	            CASE WHEN ISNULL(@NOTIFYDATE,'') = '' THEN NULL ELSE CONVERT(DATETIME,@NOTIFYDATE,121) END,
	            @CONTACTMETHOD,
	            @COMPLAINTSOURCE,
	            @FEEDBACKREQUESTED,
	            @FEEDBACKSENDTO,
	            @COMPLAINTID,
	            @REFERBOX,
	            @PRODUCTTYPE,
	            @RETURNTYPE,
	            CASE WHEN ISNULL(@ISPLATFORM,'') = '' THEN NULL ELSE CONVERT(INT,@ISPLATFORM) END,
	            @BSCSOLDTOACCOUNT,
	            @BSCSOLDTONAME,
	            @BSCSOLDTOCITY,
	            @SUBSOLDTONAME,
	            @SUBSOLDTOCITY,
	            @DISTRIBUTORCUSTOMER,
	            @DISTRIBUTORCITY,
	            @UPN,
	            @DESCRIPTION,
	            @LOT,
	            @BU,
	            CASE WHEN ISNULL(@SINGLEUSE,'') = '' THEN NULL ELSE CONVERT(INT,@SINGLEUSE) END,
	            CASE WHEN ISNULL(@RESTERILIZED,'') = '' THEN NULL ELSE CONVERT(INT,@RESTERILIZED) END,
	            @PREPROCESSOR,
	            CASE WHEN ISNULL(@USEDEXPIRY,'') = '' THEN NULL ELSE CONVERT(INT,@USEDEXPIRY) END,
	            CASE WHEN ISNULL(@UPNEXPECTED,'') = '' THEN NULL ELSE CONVERT(INT,@UPNEXPECTED) END,
	            CASE WHEN ISNULL(@UPNQUANTITY,'') = '' THEN NULL ELSE CONVERT(INT,CONVERT(decimal(18,2),@UPNQUANTITY)) END,
	            @NORETURN,
	            @NORETURNREASON,
	            CASE WHEN ISNULL(@INITIALPDATE,'') = '' THEN NULL ELSE CONVERT(DATETIME,@INITIALPDATE,121) END,
	            @PNAME,
	            @INDICATION,
	            CASE WHEN ISNULL(@IMPLANTEDDATE,'') = '' THEN NULL ELSE CONVERT(DATETIME,@IMPLANTEDDATE,121) END,
	            CASE WHEN ISNULL(@EXPLANTEDDATE,'') = '' THEN NULL ELSE CONVERT(DATETIME,@EXPLANTEDDATE,121) END,
	            @POUTCOME,
	            @IVUS,
	            @GENERATOR,
	            @GENERATORTYPE,
	            @GENERATORSET,
	            @PCONDITION,
	            @PCONDITIONOTHER,
	            CASE WHEN ISNULL(@EDATE,'') = '' THEN NULL ELSE CONVERT(DATETIME,@EDATE,121) END,
	            @WHEREOCCUR,
	            @WHENNOTICED,
	            @EDESCRIPTION,
	            @WITHLABELEDUSE,
	            @NOLABELEDUSE,
	            @EVENTRESOLVED,
              @BSCSALESNAME,
              @BSCSALESPHONE,
              @WHMID,
              @RETURNNUM,
              @CONVERTFACTOR,
              @UPNExpDate,
              @RETURNTYPE,
              @EFINSTANCECODE,
              @REGISTRATION,
              CASE WHEN ISNULL(@SALESDATE,'') = '' THEN NULL ELSE CONVERT(DATETIME,@SALESDATE,121) END
	          )
	          
	     
        --记录单据日志
      	 INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
      	 VALUES (NEWID(),@InstanceID,@UserId,GETDATE(),'Submit','经销商提交申请')
        
        
       
        IF(@WHMID <> '00000000-0000-0000-0000-000000000000')
        Begin
        
        select @WHMTYPE = WHM_Type  from Warehouse where WHM_ID = @WHMID
        
        IF(@RETURNTYPE <> 13 or (@RETURNTYPE = 13 and (@WHMTYPE = 'Nomal' or @WHMTYPE = 'DefaultWH' or @WHMTYPE='Frozen')))
        BEGIN
        --库存操作
        select @SystemHoldWarehouseID = WHM_ID  from Warehouse where WHM_DMA_ID=@CorpId and WHM_Type='SystemHold' and WHM_ActiveFlag=1
        
        IF (@SystemHoldWarehouseID IS NULL)
		  BEGIN
			RAISERROR ('无法获取经销商的在途仓库', 16, 1)
          END
          
        
        
      
        
        --Inventory表(从选择的仓库中扣减库存)
        INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                    INV_ID,
                                    INV_WHM_ID,
                                    INV_PMA_ID)
           SELECT -Convert(decimal(18,2),Convert(nvarchar(10),@RETURNNUM)), NEWID() AS INV_ID, 
                  Convert(UNIQUEIDENTIFIER, @WHMID) AS WHM_ID, PMA_ID
             FROM Product
            WHERE PMA_UPN = @UPN
        
       
        
            
  


        
        --Inventory表(在经销商的中间仓库中增加库存)
        INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                    INV_ID,
                                    INV_WHM_ID,
                                    INV_PMA_ID)
           SELECT Convert(decimal(18,2),Convert(nvarchar(10),@RETURNNUM)),
                  NEWID() AS INV_ID,
                  Convert(uniqueidentifier,Convert(nvarchar(100),@SystemHoldWarehouseID)) AS WHM_ID,
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
        SELECT inv.INV_OnHandQuantity AS ITR_Quantity,
               NEWID() AS ITR_ID,
               @EmptyGuid AS ITR_ReferenceID,
               '经销商投诉换货' AS ITR_Type,
               inv.INV_WHM_ID AS ITR_WHM_ID,
               inv.INV_PMA_ID AS ITR_PMA_ID,
               0 AS ITR_UnitPrice,
               NULL AS ITR_TransDescription
        INTO   #tmp_invtrans
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
            SELECT NEWID(),LM.LTM_ID,
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
           SELECT  NEWID(),LM.LTM_ID,
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
        SELECT lot.LOT_OnHandQty AS ITL_Quantity,
               NEWID() AS ITL_ID,
               itr.ITR_ID AS ITL_ITR_ID,
               lot.LOT_LTM_ID AS ITL_LTM_ID,
               lot.LOT_LotNumber AS ITL_LotNumber
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
        
           END 
        END
        
        --发邮件通知
        --产品描述   
        --select @DESCRIPTION= isnull(t1.CFN_ChineseName,@DESCRIPTION),@BU = isnull(t2.DivisionName,@BU) from CFN t1,V_DivisionProductLineRelation t2
        --where CFN_CustomerFaceNbr='H7493892820200' and t1.CFN_ProductLine_BUM_ID = t2.ProductLineID
        
        SET @UPNDESC = '<table border frame ="box" cellspacing="0" style="font-family: 微软雅黑"><tr><td bgcolor="#FFC0FF">Division</td><td bgcolor="#FFC0FF">UPN</td><td bgcolor="#FFC0FF">UPN描述</td></tr><tr><td>' + isnull(@BU,'') + '</td><td >' + isnull(@UPN,'')+'</td><td>' + isnull(@DESCRIPTION,'') +'</td></tr></table>' 
        
        INSERT INTO MailMessageQueue
           SELECT newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#UploadNo}',DC_ComplainNbr),
                   replace(replace(replace(replace(MMT_Body,'{#UploadNo}',DC_ComplainNbr),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),getdate(),20)),'{#productInfo}',@UPNDESC) AS MMT_Body,
                   'Waiting',getdate(),null
             from DealerComplain t1, dealermaster t2, MailMessageTemplate t3,
                  (
                    select  MDA_MailAddress from MailDeliveryAddress where MDA_MailType='QAComplainBSC' and MDA_MailTo='EAI'
                    union
                    select t1.MDA_MailAddress from MailDeliveryAddress t1,dealermaster t2, client t3 , DealerComplain t4
                    where t1.MDA_MailType='QAComplainBSC' and t1.MDA_MailTo=t3.CLT_ID and t2.DMA_Parent_DMA_ID=t3.CLT_Corp_Id and t2.DMA_ID =t4.DC_CorpId
                    and t4.DC_ComplainNbr=@COMPLAINNBR
                  ) t4
            where DC_ComplainNbr=@COMPLAINNBR and t1.DC_CorpId=t2.DMA_ID
              and t3.MMT_Code='EMAIL_QACOMPLAIN_SUBMITAPPLY'
        
	    END
	END
	ELSE --	IF @ComplainType = 'CRM'
	BEGIN
	    DECLARE @Model NVARCHAR(200);
	    DECLARE @Serial NVARCHAR(200);
	    DECLARE @CRMLot NVARCHAR(200);
	    DECLARE @CompletedName NVARCHAR(200);
	    DECLARE @CompletedTitle NVARCHAR(200);
	    DECLARE @NonBostonName NVARCHAR(200);
	    DECLARE @NonBostonCompany NVARCHAR(200);
	    DECLARE @NonBostonAddress NVARCHAR(200);
	    DECLARE @NonBostonCity NVARCHAR(200);
	    DECLARE @NonBostonCountry NVARCHAR(200);
	    DECLARE @DateEvent NVARCHAR(200);
	    --DECLARE @DateBSC NVARCHAR(200);
	    DECLARE @EventCountry NVARCHAR(200);
	    DECLARE @OtherCountry NVARCHAR(200);
	    DECLARE @NeedSupport NVARCHAR(200);
	    DECLARE @PatientName NVARCHAR(200);
	    DECLARE @PatientNum NVARCHAR(200);
	    DECLARE @PatientSex NVARCHAR(200);
	    DECLARE @PatientSexInvalid NVARCHAR(200);
	    DECLARE @PatientBirth NVARCHAR(200);
	    DECLARE @PatientBirthInvalid NVARCHAR(200);
	    DECLARE @PatientWeight NVARCHAR(200);
	    DECLARE @PatientWeightInvalid NVARCHAR(200);
	    DECLARE @PhysicianName NVARCHAR(200);
	    DECLARE @PhysicianHospital NVARCHAR(200);
	    DECLARE @PhysicianTitle NVARCHAR(200);
	    DECLARE @PhysicianAddress NVARCHAR(200);
	    DECLARE @PhysicianCity NVARCHAR(200);
	    DECLARE @PhysicianZipcode NVARCHAR(200);
	    DECLARE @PhysicianCountry NVARCHAR(200);
	    DECLARE @PatientStatus NVARCHAR(200);
	    DECLARE @DeathDate NVARCHAR(200);
	    DECLARE @DeathTime NVARCHAR(200);
	    DECLARE @DeathCause NVARCHAR(200);
	    DECLARE @Witnessed NVARCHAR(200);
	    DECLARE @RelatedBSC NVARCHAR(200);
	    DECLARE @ReasonsForProduct NVARCHAR(200);
	    DECLARE @Returned NVARCHAR(200);
	    DECLARE @ReturnedDay NVARCHAR(200);
	    DECLARE @AnalysisReport NVARCHAR(200);
	    DECLARE @RequestPhysicianName NVARCHAR(200);
	    DECLARE @Warranty NVARCHAR(200);
	    DECLARE @Pulse NVARCHAR(200);
	    DECLARE @Pulsebeats NVARCHAR(200);
	    DECLARE @Leads NVARCHAR(200);
	    DECLARE @LeadsFracture NVARCHAR(200);
	    DECLARE @LeadsIssue NVARCHAR(200);
	    DECLARE @LeadsDislodgement NVARCHAR(200);
	    DECLARE @LeadsMeasurements NVARCHAR(200);
	    DECLARE @LeadsThresholds NVARCHAR(200);
	    DECLARE @LeadsBeats NVARCHAR(200);
	    DECLARE @LeadsNoise NVARCHAR(200);
	    DECLARE @LeadsLoss NVARCHAR(200);
	    DECLARE @Clinical NVARCHAR(200);
	    DECLARE @ClinicalPerforation NVARCHAR(200);
	    DECLARE @ClinicalBeats NVARCHAR(200);
	    DECLARE @PulseModel NVARCHAR(200);
	    DECLARE @PulseSerial NVARCHAR(200);
	    DECLARE @PulseImplant NVARCHAR(200);
	    DECLARE @Leads1Model NVARCHAR(200);
	    DECLARE @Leads1Serial NVARCHAR(200);
	    DECLARE @Leads1Implant NVARCHAR(200);
	    DECLARE @Leads1Position NVARCHAR(200);
	    DECLARE @Leads2Model NVARCHAR(200);
	    DECLARE @Leads2Serial NVARCHAR(200);
	    DECLARE @Leads2Implant NVARCHAR(200);
	    DECLARE @Leads2Position NVARCHAR(200);
	    DECLARE @Leads3Model NVARCHAR(200);
	    DECLARE @Leads3Serial NVARCHAR(200);
	    DECLARE @Leads3Implant NVARCHAR(200);
	    DECLARE @Leads3Position NVARCHAR(200);
	    DECLARE @AccessoryModel NVARCHAR(200);
	    DECLARE @AccessorySerial NVARCHAR(200);
	    DECLARE @AccessoryImplant NVARCHAR(200);
	    DECLARE @AccessoryLot NVARCHAR(200);
	    DECLARE @ExplantDate NVARCHAR(200);
	    DECLARE @RemainsService NVARCHAR(200);
	    DECLARE @RemovedService NVARCHAR(200);
	    DECLARE @Replace1Model NVARCHAR(200);
	    DECLARE @Replace1Serial NVARCHAR(200);
	    DECLARE @Replace1Implant NVARCHAR(200);
	    DECLARE @Replace2Model NVARCHAR(200);
	    DECLARE @Replace2Serial NVARCHAR(200);
	    DECLARE @Replace2Implant NVARCHAR(200);
	    DECLARE @Replace3Model NVARCHAR(200);
	    DECLARE @Replace3Serial NVARCHAR(200);
	    DECLARE @Replace3Implant NVARCHAR(200);
	    DECLARE @Replace4Model NVARCHAR(200);
	    DECLARE @Replace4Serial NVARCHAR(200);
	    DECLARE @Replace4Implant NVARCHAR(200);
	    DECLARE @Replace5Model NVARCHAR(200);
	    DECLARE @Replace5Serial NVARCHAR(200);
	    DECLARE @Replace5Implant NVARCHAR(200);
	    DECLARE @ProductExpDetail NVARCHAR(2000);
	    DECLARE @CustomerComment NVARCHAR(2000);
      DECLARE @PI              NVARCHAR(200);
      DECLARE @IAN             NVARCHAR(200);
      DECLARE @DateDealer NVARCHAR(200);
      DECLARE @COMPLAINNBRCRM NVARCHAR(200);
      
      DECLARE @PRODUCTTYPECRM NVARCHAR(200);
	    DECLARE @RETURNTYPECRM NVARCHAR(200);
	    DECLARE @ISPLATFORMCRM NVARCHAR(200);
	    DECLARE @BSCSOLDTOACCOUNTCRM NVARCHAR(200);
	    DECLARE @BSCSOLDTONAMECRM NVARCHAR(200);
	    DECLARE @BSCSOLDTOCITYCRM NVARCHAR(200);
	    DECLARE @SUBSOLDTONAMECRM NVARCHAR(200);
	    DECLARE @SUBSOLDTOCITYCRM NVARCHAR(200);
	    DECLARE @DISTRIBUTORCUSTOMERCRM NVARCHAR(200);
	    DECLARE @DISTRIBUTORCITYCRM NVARCHAR(200);
      DECLARE @ISFORBSCPRODUCT NVARCHAR(200);
      
      DECLARE @DESCRIPTIONCRM NVARCHAR(200);
      DECLARE @UPNExpDateCRM NVARCHAR(200);
      DECLARE @WHMIDCRM NVARCHAR(200);
      DECLARE @EFINSTANCECODECRM NVARCHAR(200);
      DECLARE @HOSPITALCRM NVARCHAR(50);
      DECLARE @REGISTRATIONCRM NVARCHAR(200);
      DECLARE @SALESDATECRM NVARCHAR(50);
	    
	    SELECT @Model = doc.col.value('Model[1]', 'NVARCHAR(200)'),
	           @Serial = doc.col.value('Serial[1]', 'NVARCHAR(200)'),
	           @CRMLot = doc.col.value('Lot[1]', 'NVARCHAR(200)'),
	           @CompletedName = doc.col.value('CompletedName[1]', 'NVARCHAR(200)'),
	           @CompletedTitle = doc.col.value('CompletedTitle[1]', 'NVARCHAR(200)'),
	           @NonBostonName = doc.col.value('NonBostonName[1]', 'NVARCHAR(200)'),
	           @NonBostonCompany = doc.col.value('NonBostonCompany[1]', 'NVARCHAR(200)'),
	           @NonBostonAddress = doc.col.value('NonBostonAddress[1]', 'NVARCHAR(200)'),
	           @NonBostonCity = doc.col.value('NonBostonCity[1]', 'NVARCHAR(200)'),
	           @NonBostonCountry = doc.col.value('NonBostonCountry[1]', 'NVARCHAR(200)'),
	           @DateEvent = doc.col.value('DateEvent[1]', 'NVARCHAR(200)'),
	           --@DateBSC = doc.col.value('DateBSC[1]', 'NVARCHAR(200)'),
	           @EventCountry = doc.col.value('EventCountry[1]', 'NVARCHAR(200)'),
	           @OtherCountry = doc.col.value('OtherCountry[1]', 'NVARCHAR(200)'),
	           @NeedSupport = doc.col.value('NeedSupport[1]', 'NVARCHAR(200)'),
	           @PatientName = doc.col.value('PatientName[1]', 'NVARCHAR(200)'),
	           @PatientNum = doc.col.value('PatientNum[1]', 'NVARCHAR(200)'),
	           @PatientSex = doc.col.value('PatientSex[1]', 'NVARCHAR(200)'),
	           @PatientSexInvalid = doc.col.value('PatientSexInvalid[1]', 'NVARCHAR(200)'),
	           @PatientBirth = doc.col.value('PatientBirth[1]', 'NVARCHAR(200)'),
	           @PatientBirthInvalid = doc.col.value('PatientBirthInvalid[1]', 'NVARCHAR(200)'),
	           @PatientWeight = doc.col.value('PatientWeight[1]', 'NVARCHAR(200)'),
	           @PatientWeightInvalid = doc.col.value('PatientWeightInvalid[1]', 'NVARCHAR(200)'),
	           @PhysicianName = doc.col.value('PhysicianName[1]', 'NVARCHAR(200)'),
	           @PhysicianHospital = doc.col.value('PhysicianHospital[1]', 'NVARCHAR(200)'),
	           @PhysicianTitle = doc.col.value('PhysicianTitle[1]', 'NVARCHAR(200)'),
	           @PhysicianAddress = doc.col.value('PhysicianAddress[1]', 'NVARCHAR(200)'),
	           @PhysicianCity = doc.col.value('PhysicianCity[1]', 'NVARCHAR(200)'),
	           @PhysicianZipcode = doc.col.value('PhysicianZipcode[1]', 'NVARCHAR(200)'),
	           @PhysicianCountry = doc.col.value('PhysicianCountry[1]', 'NVARCHAR(200)'),
	           @PatientStatus = doc.col.value('PatientStatus[1]', 'NVARCHAR(200)'),
	           @DeathDate = doc.col.value('DeathDate[1]', 'NVARCHAR(200)'),
	           @DeathTime = doc.col.value('DeathTime[1]', 'NVARCHAR(200)'),
	           @DeathCause = doc.col.value('DeathCause[1]', 'NVARCHAR(200)'),
	           @Witnessed = doc.col.value('Witnessed[1]', 'NVARCHAR(200)'),
	           @RelatedBSC = doc.col.value('RelatedBSC[1]', 'NVARCHAR(200)'),
	           @ReasonsForProduct = doc.col.value('ReasonsForProduct[1]', 'NVARCHAR(200)'),
	           @Returned = doc.col.value('Returned[1]', 'NVARCHAR(200)'),
	           @ReturnedDay = doc.col.value('ReturnedDay[1]', 'NVARCHAR(200)'),
	           @AnalysisReport = doc.col.value('AnalysisReport[1]', 'NVARCHAR(200)'),
	           @RequestPhysicianName = doc.col.value('RequestPhysicianName[1]', 'NVARCHAR(200)'),
	           @Warranty = doc.col.value('Warranty[1]', 'NVARCHAR(200)'),
	           @Pulse = doc.col.value('Pulse[1]', 'NVARCHAR(200)'),
	           @Pulsebeats = doc.col.value('Pulsebeats[1]', 'NVARCHAR(200)'),
	           @Leads = doc.col.value('Leads[1]', 'NVARCHAR(200)'),
	           @LeadsFracture = doc.col.value('LeadsFracture[1]', 'NVARCHAR(200)'),
	           @LeadsIssue = doc.col.value('LeadsIssue[1]', 'NVARCHAR(200)'),
	           @LeadsDislodgement = doc.col.value('LeadsDislodgement[1]', 'NVARCHAR(200)'),
	           @LeadsMeasurements = doc.col.value('LeadsMeasurements[1]', 'NVARCHAR(200)'),
	           @LeadsThresholds = doc.col.value('LeadsThresholds[1]', 'NVARCHAR(200)'),
	           @LeadsBeats = doc.col.value('LeadsBeats[1]', 'NVARCHAR(200)'),
	           @LeadsNoise = doc.col.value('LeadsNoise[1]', 'NVARCHAR(200)'),
	           @LeadsLoss = doc.col.value('LeadsLoss[1]', 'NVARCHAR(200)'),
	           @Clinical = doc.col.value('Clinical[1]', 'NVARCHAR(200)'),
	           @ClinicalPerforation = doc.col.value('ClinicalPerforation[1]', 'NVARCHAR(200)'),
	           @ClinicalBeats = doc.col.value('ClinicalBeats[1]', 'NVARCHAR(200)'),
	           @PulseModel = doc.col.value('PulseModel[1]', 'NVARCHAR(200)'),
	           @PulseSerial = doc.col.value('PulseSerial[1]', 'NVARCHAR(200)'),
	           @PulseImplant = doc.col.value('PulseImplant[1]', 'NVARCHAR(200)'),
	           @Leads1Model = doc.col.value('Leads1Model[1]', 'NVARCHAR(200)'),
	           @Leads1Serial = doc.col.value('Leads1Serial[1]', 'NVARCHAR(200)'),
	           @Leads1Implant = doc.col.value('Leads1Implant[1]', 'NVARCHAR(200)'),
	           @Leads1Position = doc.col.value('Leads1Position[1]', 'NVARCHAR(200)'),
	           @Leads2Model = doc.col.value('Leads2Model[1]', 'NVARCHAR(200)'),
	           @Leads2Serial = doc.col.value('Leads2Serial[1]', 'NVARCHAR(200)'),
	           @Leads2Implant = doc.col.value('Leads2Implant[1]', 'NVARCHAR(200)'),
	           @Leads2Position = doc.col.value('Leads2Position[1]', 'NVARCHAR(200)'),
	           @Leads3Model = doc.col.value('Leads3Model[1]', 'NVARCHAR(200)'),
	           @Leads3Serial = doc.col.value('Leads3Serial[1]', 'NVARCHAR(200)'),
	           @Leads3Implant = doc.col.value('Leads3Implant[1]', 'NVARCHAR(200)'),
	           @Leads3Position = doc.col.value('Leads3Position[1]', 'NVARCHAR(200)'),
	           @AccessoryModel = doc.col.value('AccessoryModel[1]', 'NVARCHAR(200)'),
	           @AccessorySerial = doc.col.value('AccessorySerial[1]', 'NVARCHAR(200)'),
	           @AccessoryImplant = doc.col.value('AccessoryImplant[1]', 'NVARCHAR(200)'),
	           @AccessoryLot = doc.col.value('AccessoryLot[1]', 'NVARCHAR(200)'),
	           @ExplantDate = doc.col.value('ExplantDate[1]', 'NVARCHAR(200)'),
	           @RemainsService = doc.col.value('RemainsService[1]', 'NVARCHAR(200)'),
	           @RemovedService = doc.col.value('RemovedService[1]', 'NVARCHAR(200)'),
	           @Replace1Model = doc.col.value('Replace1Model[1]', 'NVARCHAR(200)'),
	           @Replace1Serial = doc.col.value('Replace1Serial[1]', 'NVARCHAR(200)'),
	           @Replace1Implant = doc.col.value('Replace1Implant[1]', 'NVARCHAR(200)'),
	           @Replace2Model = doc.col.value('Replace2Model[1]', 'NVARCHAR(200)'),
	           @Replace2Serial = doc.col.value('Replace2Serial[1]', 'NVARCHAR(200)'),
	           @Replace2Implant = doc.col.value('Replace2Implant[1]', 'NVARCHAR(200)'),
	           @Replace3Model = doc.col.value('Replace3Model[1]', 'NVARCHAR(200)'),
	           @Replace3Serial = doc.col.value('Replace3Serial[1]', 'NVARCHAR(200)'),
	           @Replace3Implant = doc.col.value('Replace3Implant[1]', 'NVARCHAR(200)'),
	           @Replace4Model = doc.col.value('Replace4Model[1]', 'NVARCHAR(200)'),
	           @Replace4Serial = doc.col.value('Replace4Serial[1]', 'NVARCHAR(200)'),
	           @Replace4Implant = doc.col.value('Replace4Implant[1]', 'NVARCHAR(200)'),
	           @Replace5Model = doc.col.value('Replace5Model[1]', 'NVARCHAR(200)'),
	           @Replace5Serial = doc.col.value('Replace5Serial[1]', 'NVARCHAR(200)'),
	           @Replace5Implant = doc.col.value('Replace5Implant[1]', 'NVARCHAR(200)'),
	           @ProductExpDetail = doc.col.value('ProductExpDetail[1]', 'NVARCHAR(2000)'),
	           @CustomerComment = doc.col.value('CustomerComment[1]', 'NVARCHAR(2000)'),
             @PI = doc.col.value('PI[1]', 'NVARCHAR(200)'),
             @IAN = doc.col.value('IAN[1]', 'NVARCHAR(200)'),
             @DateDealer = doc.col.value('DateDealer[1]', 'NVARCHAR(200)'),
             @COMPLAINNBRCRM = doc.col.value('COMPLAINNBR[1]', 'NVARCHAR(200)'),
             
             @PRODUCTTYPECRM = doc.col.value('PRODUCTTYPE[1]', 'NVARCHAR(200)'),
	           @RETURNTYPECRM = doc.col.value('RETURNTYPE[1]', 'NVARCHAR(200)'),
	           @ISPLATFORMCRM = doc.col.value('ISPLATFORM[1]', 'NVARCHAR(200)'),
	           @BSCSOLDTOACCOUNTCRM = doc.col.value('BSCSOLDTOACCOUNT[1]', 'NVARCHAR(200)'),
	           @BSCSOLDTONAMECRM = doc.col.value('BSCSOLDTONAME[1]', 'NVARCHAR(200)'),
	           @BSCSOLDTOCITYCRM = doc.col.value('BSCSOLDTOCITY[1]', 'NVARCHAR(200)'),
	           @SUBSOLDTONAMECRM = doc.col.value('SUBSOLDTONAME[1]', 'NVARCHAR(200)'),
	           @SUBSOLDTOCITYCRM = doc.col.value('SUBSOLDTOCITY[1]', 'NVARCHAR(200)'),
	           @DISTRIBUTORCUSTOMERCRM = doc.col.value('DISTRIBUTORCUSTOMER[1]', 'NVARCHAR(200)'),
	           @DISTRIBUTORCITYCRM = doc.col.value('DISTRIBUTORCITY[1]', 'NVARCHAR(200)'),
             @ISFORBSCPRODUCT = doc.col.value('ISFORBSCPRODUCT[1]', 'NVARCHAR(200)'),
             @DESCRIPTIONCRM = doc.col.value('DESCRIPTION[1]', 'NVARCHAR(200)'),
             @UPNExpDateCRM = doc.col.value('UPNExpDate[1]', 'NVARCHAR(200)'),
             @WHMIDCRM = doc.col.value('WHMID[1]', 'NVARCHAR(200)'),
             @EFINSTANCECODECRM = doc.col.value('WFINSTANCEID[1]', 'NVARCHAR(200)'),
             @HOSPITALCRM = doc.col.value('HOSPITAL[1]', 'NVARCHAR(50)'),
             @REGISTRATIONCRM = doc.col.value('REGISTRATION[1]', 'NVARCHAR(200)'),
             @SALESDATECRM = doc.col.value('SALESDATE[1]', 'NVARCHAR(50)')
	    FROM   @ComplainInfo.nodes('/DealerComplain') doc(col);
	    
	    if ISNULL(@COMPLAINNBRCRM,'') = ''
	    begin
	    DECLARE @m_OrderNoCRM nvarchar(50)
	    EXEC [GC_GetNextAutoNumber] @CorpId,'Next_ComplainNbr','', @m_OrderNoCRM output
		select  @COMPLAINNBRCRM = @m_OrderNoCRM 
		end
		
	    select @InstanceID=newid()
	    
	    insert into dbo.tmp_dealercomplainsave
          select @InstanceID,@UserId,@CorpId,@ComplainInfo,GETDATE()
	    
	     --获取产品有效期    
        select @UPNExpDateCRM = LTM_ExpiredDate from cfn t1, product t2, LotMaster t3
		where t1.CFN_ID=t2.PMA_CFN_ID and t2.PMA_ID=t3.LTM_Product_PMA_ID and t3.LTM_LotNumber=@CRMLot and t1.CFN_CustomerFaceNbr=@Serial
	    
	    IF ISNULL(@DISTRIBUTORCUSTOMERCRM,'') = ''
		BEGIN
			SELECT @DISTRIBUTORCUSTOMERCRM = @HOSPITALCRM
		END
		
	    IF @Result = 'Init'
	    BEGIN
	    
			if(@REGISTRATIONCRM = '')
	        begin
				select @REGISTRATIONCRM =REG_NO from MD.V_INF_UPN_REG_LIST t1,
				  (
				  select REG_NO.CFN_CustomerFaceNbr , max(REG_NO.VALID_DATE_FROM) As ValidDateFrom from MD.V_INF_UPN_REG_LIST REG_NO where REG_NO.VALID_DATE_TO is not null and Reg_No.CFN_CustomerFaceNbr = @UPN group by REG_NO.CFN_CustomerFaceNbr
				  ) t2
				  where t1.CFN_CustomerFaceNbr=t2.CFN_CustomerFaceNbr and t1.VALID_DATE_FROM =t2.ValidDateFrom and t1.CFN_CustomerFaceNbr =@UPN
	        end
	        if(@SALESDATECRM = '')
	        begin
				select @SALESDATECRM = max(convert(nvarchar(30),PRH_SapDeliveryDate,121))  from POReceiptHeader,POReceipt,POReceiptLot
				where PRH_ID = POR_PRH_ID
				and POR_ID = PRL_POR_ID
				and POR_SAP_PMA_ID = @Serial
				and PRL_LotNumber = @CRMLot
				and PRH_Dealer_DMA_ID = @CorpId
				and PRH_Type in ('PurchaseOrder','Retail')
	        end
	        
	        INSERT INTO DealerComplainCRM
	          (
	            DC_ID,
	            DC_ComplainNbr,
	            DC_CorpId,
	            DC_Status,
	            DC_CreatedBy,
	            DC_CreatedDate,
	            DC_LastModifiedBy,
	            DC_LastModifiedDate,
              EID,
	            Model,
	            Serial,
	            Lot,
	            CompletedName,
	            CompletedTitle,
	            NonBostonName,
	            NonBostonCompany,
	            NonBostonAddress,
	            NonBostonCity,
	            NonBostonCountry,
	            DateEvent,
	            DateBSC,
	            EventCountry,
	            OtherCountry,
	            NeedSupport,
	            PatientName,
	            PatientNum,
	            PatientSex,
	            PatientSexInvalid,
	            PatientBirth,
	            PatientBirthInvalid,
	            PatientWeight,
	            PatientWeightInvalid,
	            PhysicianName,
	            PhysicianHospital,
	            PhysicianTitle,
	            PhysicianAddress,
	            PhysicianCity,
	            PhysicianZipcode,
	            PhysicianCountry,
	            PatientStatus,
	            DeathDate,
	            DeathTime,
	            DeathCause,
	            Witnessed,
	            RelatedBSC,
	            ReasonsForProduct,
	            Returned,
	            ReturnedDay,
	            AnalysisReport,
	            RequestPhysicianName,
	            Warranty,
	            Pulse,
	            Pulsebeats,
	            Leads,
	            LeadsFracture,
	            LeadsIssue,
	            LeadsDislodgement,
	            LeadsMeasurements,
	            LeadsThresholds,
	            LeadsBeats,
	            LeadsNoise,
	            LeadsLoss,
	            Clinical,
	            ClinicalPerforation,
	            ClinicalBeats,
	            PulseModel,
	            PulseSerial,
	            PulseImplant,
	            Leads1Model,
	            Leads1Serial,
	            Leads1Implant,
	            Leads1Position,
	            Leads2Model,
	            Leads2Serial,
	            Leads2Implant,
	            Leads2Position,
	            Leads3Model,
	            Leads3Serial,
	            Leads3Implant,
	            Leads3Position,
	            AccessoryModel,
	            AccessorySerial,
	            AccessoryImplant,
	            AccessoryLot,
	            ExplantDate,
	            RemainsService,
	            RemovedService,
	            Replace1Model,
	            Replace1Serial,
	            Replace1Implant,
	            Replace2Model,
	            Replace2Serial,
	            Replace2Implant,
	            Replace3Model,
	            Replace3Serial,
	            Replace3Implant,
	            Replace4Model,
	            Replace4Serial,
	            Replace4Implant,
	            Replace5Model,
	            Replace5Serial,
	            Replace5Implant,
	            ProductExpDetail,
	            CustomerComment,
              PI,
              IAN,
              DateDealer,
              ProductType,
              ReturnType,
              IsPlatform,
              BSCSoldToAccount,
              BSCSoldToName,
              BSCSoldToCity,
              SubSoldToName,
              SubSoldToCity,
              DistributorCustomer,
              DistributorCity,
              IsForBSCProduct,
              ProductDescription,
              UPNExpDate,
              WHMID,
              CONFIRMRETURNTYPE,
              EFINSTANCECODE,
              Registration,
              SalesDate
	          )
	        VALUES
	          (
	            NEWID(),
	            @COMPLAINNBRCRM,
	            @CorpId,
	            'Submit',
	            @UserId,
	            GETDATE(),
	            @UserId,
	            GETDATE(),
              @UserId,
	            @Model,
	            @Serial,
	            @CRMLot,
	            @CompletedName,
	            @CompletedTitle,
	            @NonBostonName,
	            @NonBostonCompany,
	            @NonBostonAddress,
	            @NonBostonCity,
	            @NonBostonCountry,
	            @DateEvent,
	            getdate(),
	            @EventCountry,
	            @OtherCountry,
	            @NeedSupport,
	            @PatientName,
	            @PatientNum,
	            @PatientSex,
	            @PatientSexInvalid,
	            @PatientBirth,
	            @PatientBirthInvalid,
	            @PatientWeight,
	            @PatientWeightInvalid,
	            @PhysicianName,
	            @PhysicianHospital,
	            @PhysicianTitle,
	            @PhysicianAddress,
	            @PhysicianCity,
	            @PhysicianZipcode,
	            @PhysicianCountry,
	            @PatientStatus,
	            @DeathDate,
	            @DeathTime,
	            @DeathCause,
	            @Witnessed,
	            @RelatedBSC,
	            @ReasonsForProduct,
	            @Returned,
	            @ReturnedDay,
	            @AnalysisReport,
	            @RequestPhysicianName,
	            @Warranty,
	            @Pulse,
	            @Pulsebeats,
	            @Leads,
	            @LeadsFracture,
	            @LeadsIssue,
	            @LeadsDislodgement,
	            @LeadsMeasurements,
	            @LeadsThresholds,
	            @LeadsBeats,
	            @LeadsNoise,
	            @LeadsLoss,
	            @Clinical,
	            @ClinicalPerforation,
	            @ClinicalBeats,
	            @PulseModel,
	            @PulseSerial,
	            @PulseImplant,
	            @Leads1Model,
	            @Leads1Serial,
	            @Leads1Implant,
	            @Leads1Position,
	            @Leads2Model,
	            @Leads2Serial,
	            @Leads2Implant,
	            @Leads2Position,
	            @Leads3Model,
	            @Leads3Serial,
	            @Leads3Implant,
	            @Leads3Position,
	            @AccessoryModel,
	            @AccessorySerial,
	            @AccessoryImplant,
	            @AccessoryLot,
	            @ExplantDate,
	            @RemainsService,
	            @RemovedService,
	            @Replace1Model,
	            @Replace1Serial,
	            @Replace1Implant,
	            @Replace2Model,
	            @Replace2Serial,
	            @Replace2Implant,
	            @Replace3Model,
	            @Replace3Serial,
	            @Replace3Implant,
	            @Replace4Model,
	            @Replace4Serial,
	            @Replace4Implant,
	            @Replace5Model,
	            @Replace5Serial,
	            @Replace5Implant,
	            @ProductExpDetail,
	            @CustomerComment,
              @PI,
              @IAN,
              @DateDealer,
              @PRODUCTTYPECRM,
        	    @RETURNTYPECRM,
        	    @ISPLATFORMCRM,
        	    @BSCSOLDTOACCOUNTCRM,
        	    @BSCSOLDTONAMECRM,
        	    @BSCSOLDTOCITYCRM,
        	    @SUBSOLDTONAMECRM,
        	    @SUBSOLDTOCITYCRM,
        	    @DISTRIBUTORCUSTOMERCRM,
        	    @DISTRIBUTORCITYCRM,
              @ISFORBSCPRODUCT,
              @DESCRIPTIONCRM,
              @UPNExpDateCRM,
              @WHMIDCRM,
              @RETURNTYPECRM,
              @EFINSTANCECODECRM,
              @REGISTRATIONCRM,
              CASE WHEN ISNULL(@SALESDATECRM,'') = '' THEN NULL ELSE CONVERT(DATETIME,@SALESDATECRM,121) END
	          )
        
        
        
        SET @RETURNNUM ='1'
        
        IF(@WHMIDCRM <> '00000000-0000-0000-0000-000000000000')
        -- 库存操作
        BEGIN
        
			select @WHMTYPE = WHM_Type  from Warehouse where WHM_ID = @WHMIDCRM
	        
			IF(@RETURNTYPECRM <> 3 or (@RETURNTYPECRM = 3 and (@WHMTYPE = 'Nomal' or @WHMTYPE = 'DefaultWH'or @WHMTYPE='Frozen')))
			BEGIN
	        
			select @SystemHoldWarehouseID = WHM_ID  from Warehouse where WHM_DMA_ID=@CorpId and WHM_Type='SystemHold' and WHM_ActiveFlag=1
			IF (@SystemHoldWarehouseID IS NULL)
			  RAISERROR ('无法获取经销商的在途仓库', 16, 1)
	         
			--Inventory表(从选择的仓库中扣减库存)
			INSERT INTO #tmp_inventory (INV_OnHandQuantity,
										INV_ID,
										INV_WHM_ID,
										INV_PMA_ID)
			   SELECT -Convert(decimal(18,2),@RETURNNUM), NEWID() AS INV_ID, 
					  Convert(UNIQUEIDENTIFIER, @WHMIDCRM) AS WHM_ID, PMA_ID
				 FROM Product
				WHERE PMA_UPN = @Serial
	  



			--Inventory表(在经销商的中间仓库中增加库存)
			INSERT INTO #tmp_inventory (INV_OnHandQuantity,
										INV_ID,
										INV_WHM_ID,
										INV_PMA_ID)
			   SELECT Convert(decimal(18,2),@RETURNNUM),
					  NEWID() AS INV_ID,
					  @SystemHoldWarehouseID AS WHM_ID,
					  PMA_ID
				 FROM Product
				WHERE PMA_UPN = @Serial
	            
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
			SELECT inv.INV_OnHandQuantity AS ITR_Quantity,
				   NEWID() AS ITR_ID,
				   @EmptyGuid AS ITR_ReferenceID,
				   '经销商投诉换货' AS ITR_Type,
				   inv.INV_WHM_ID AS ITR_WHM_ID,
				   inv.INV_PMA_ID AS ITR_PMA_ID,
				   0 AS ITR_UnitPrice,
				   NULL AS ITR_TransDescription
			INTO   #tmp_invtransCRM
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
			   FROM   #tmp_invtransCRM


			--Lot表(从仓库中扣减库存)
			INSERT INTO #tmp_lot (LOT_ID,
								  LOT_LTM_ID,
								  LOT_WHM_ID,
								  LOT_PMA_ID,
								  LOT_LotNumber,
								  LOT_OnHandQty)         
				SELECT NEWID(),LM.LTM_ID,
					   Convert(UNIQUEIDENTIFIER, @WHMIDCRM) AS WHM_ID,
					   P.PMA_ID,
					   LM.LTM_LotNumber,
					   -Convert(decimal(18,2),@RETURNNUM)
	        		  FROM LotMaster LM, Product P
	        		 WHERE P.PMA_ID = LM.LTM_Product_PMA_ID 
				   AND LM.LTM_LotNumber = @CRMLot
				   AND P.PMA_UPN = @Serial
		        	          	      

			--Lot表(在在途仓库中增加库存)
			INSERT INTO #tmp_lot (LOT_ID,
								  LOT_LTM_ID,
								  LOT_WHM_ID,
								  LOT_PMA_ID,
								  LOT_LotNumber,
								  LOT_OnHandQty)
			   SELECT  NEWID(),LM.LTM_ID,
					   @SystemHoldWarehouseID AS WHM_ID,
					   P.PMA_ID,
					   LM.LTM_LotNumber,
					   Convert(decimal(18,2),@RETURNNUM)
	        		  FROM LotMaster LM, Product P
	        		 WHERE P.PMA_ID = LM.LTM_Product_PMA_ID 
				   AND LM.LTM_LotNumber = @CRMLot
				   AND P.PMA_UPN = @Serial

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
			SELECT lot.LOT_OnHandQty AS ITL_Quantity,
				   NEWID() AS ITL_ID,
				   itr.ITR_ID AS ITL_ITR_ID,
				   lot.LOT_LTM_ID AS ITL_LTM_ID,
				   lot.LOT_LotNumber AS ITL_LotNumber
			INTO   #tmp_invtranslotCRM
			FROM   #tmp_lot AS lot
				   INNER JOIN #tmp_invtransCRM AS itr
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
			   FROM   #tmp_invtranslotCRM
			   END
        END
        
        --发邮件通知        
        select @DESCRIPTION= isnull(CFN_ChineseName,@DESCRIPTION) from CFN where CFN_CustomerFaceNbr=@Serial
        SET @UPNDESC = '<table border frame ="box" cellspacing="0" style="font-family: 微软雅黑"><tr><td bgcolor="#FFC0FF">Division</td><td bgcolor="#FFC0FF">UPN</td><td bgcolor="#FFC0FF">UPN描述</td></tr><tr><td>CRM</td><td >' + isnull(@Serial,'')+'</td><td>' + isnull(@DESCRIPTION,'') +'</td></tr></table>' 
                       
        INSERT INTO MailMessageQueue
           SELECT newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#UploadNo}',DC_ComplainNbr),
                   replace(replace(replace(replace(MMT_Body,'{#UploadNo}',DC_ComplainNbr),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),getdate(),20)),'{#productInfo}',@UPNDESC) AS MMT_Body,
                   'Waiting',getdate(),null
             from DealerComplainCRM t1, dealermaster t2, MailMessageTemplate t3,
                  (
                    select t1.MDA_MailAddress from MailDeliveryAddress t1,dealermaster t2, client t3 , DealerComplainCRM t4
                    where t1.MDA_MailType='QAComplainBSC' and t1.MDA_MailTo=t3.CLT_ID and t2.DMA_Parent_DMA_ID=t3.CLT_Corp_Id and t2.DMA_ID =t4.DC_CorpId
                    and t4.DC_ComplainNbr=@COMPLAINNBRCRM
                  ) t4,Warehouse t5
            where DC_ComplainNbr=@COMPLAINNBRCRM and t1.DC_CorpId=t2.DMA_ID
              and t3.MMT_Code='EMAIL_QACOMPLAIN_SUBMITAPPLY'
              and t1.WHMID =t5.WHM_ID
              and t5.WHM_Type not in ('Normal','SystemHold','DefaultWH')
            union
              SELECT newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#UploadNo}',DC_ComplainNbr),
                   replace(replace(replace(replace(MMT_Body,'{#UploadNo}',DC_ComplainNbr),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),getdate(),20)),'{#productInfo}',@UPNDESC) AS MMT_Body,
                   'Waiting',getdate(),null
             from DealerComplainCRM t1, dealermaster t2, MailMessageTemplate t3,
                  (
                    select  MDA_MailAddress from MailDeliveryAddress where MDA_MailType='QAComplainBSC' and MDA_MailTo='EAI'
                  ) t4
            where DC_ComplainNbr=@COMPLAINNBRCRM and t1.DC_CorpId=t2.DMA_ID
              and t3.MMT_Code='EMAIL_QACOMPLAIN_SUBMITAPPLY'
              
	    END
	END
  
	IF @Result = 'Init'
	BEGIN
	    SELECT @Result = 'Success'
	END
	
	COMMIT TRAN
END TRY
BEGIN CATCH
	SET  NOCOUNT OFF
  ROLLBACK TRAN

  --记录错误日志开始
  DECLARE @error_line   INT
  DECLARE @error_number   INT
  DECLARE @error_message   NVARCHAR (1500)
  DECLARE @vError   NVARCHAR (1000)
  SET @error_line = ERROR_LINE ()
  SET @error_number = ERROR_NUMBER ()
  SET @error_message = ERROR_MESSAGE ()
  SET @vError = '行' + CONVERT (NVARCHAR (10), @error_line) + '出错[错误号' + CONVERT (NVARCHAR (10), @error_number) + '],' + @error_message
  SET @Result = @vError   
END CATCH
GO


