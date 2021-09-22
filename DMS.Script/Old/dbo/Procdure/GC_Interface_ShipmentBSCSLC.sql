DROP PROCEDURE [dbo].[GC_Interface_ShipmentBSCSLC]
GO

/*
波科发货数据上传（畅联WMS系统上传）
1、畅联WMS系统通过接口上传数据，此时@BatchNbr和@ClientID不能为空
2、系统保存数据并校验数据准确性，只有准确的数据才会写入DeliveryNoteBSCSLC表
   --数据格式是否正确，必须填写的项目是否都已填写
   --DeliveryNoteBSCSLC表是否有历史发货单数据（如果有，则不允许再写入）
   --是否有重复的二维码
*/

CREATE PROCEDURE [dbo].[GC_Interface_ShipmentBSCSLC]
   @BatchNbr       NVARCHAR (30),
   @ClientID       NVARCHAR (50),
   @IsValid        NVARCHAR (20) OUTPUT,
   @RtnMsg         NVARCHAR (500) OUTPUT
AS  
   DECLARE @SysUserId   UNIQUEIDENTIFIER   
   DECLARE @EmptyGuid   UNIQUEIDENTIFIER
   DECLARE @ErrCnt   INT
   
   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN

      SET @IsValid = 'Success'
      SET @RtnMsg = ''
      SET @SysUserId = '00000000-0000-0000-0000-000000000000'
      SET @EmptyGuid = '00000000-0000-0000-0000-000000000000'
	 
      --发货信息临时表(DeliveryNoteBSCSLC临时表)
      CREATE TABLE #tmp_DNBSCSLC (
         DNB_ID               uniqueidentifier     not null,
         DNB_ISB_ID           uniqueidentifier     not null,
         DNB_DeliveryNoteNbr  nvarchar(50)         collate Chinese_PRC_CI_AS null,
         DNB_DeliveryDate     datetime             null,
         DNB_SoldToSAPCode    nvarchar(50)         collate Chinese_PRC_CI_AS null,
         DNB_SoldToName       nvarchar(500)        null,
         DNB_ShipToSAPCode    nvarchar(50)         null,
         DNB_ShipToName       nvarchar(500)        null,
         DNB_CFN              nvarchar(50)         collate Chinese_PRC_CI_AS null,
         DNB_UPN              nvarchar(50)         collate Chinese_PRC_CI_AS null,
         DNB_LotNumber        nvarchar(20)         collate Chinese_PRC_CI_AS null,
         DNB_QRCode           nvarchar(50)         null,
         DNB_ShipQty          decimal(18,6)        null,
         DNB_ReceiveQty       decimal(18,6)        null,
         DNB_ExpiredDate      datetime             null,
         DNB_DeliveryUnitOfMeasure nvarchar(20)    collate Chinese_PRC_CI_AS null,
         DNB_ReceiveUnitOfMeasure nvarchar(20)     collate Chinese_PRC_CI_AS null,
         DNB_UnitPrice        decimal(18,6)        null,
         DNB_OrderNo          nvarchar(50)         collate Chinese_PRC_CI_AS null,
         DNB_BoxNo            nvarchar(50)         null,
         DNB_OrderType        nvarchar(50)         collate Chinese_PRC_CI_AS null,
         DNB_LineNbrInFile    int                  null,
         DNB_SapDeliveryLineNbr nvarchar(50)       null,
         DNB_ImportFileName   nvarchar(200)        collate Chinese_PRC_CI_AS null,
         DNB_ShipmentType     nvarchar(20)         collate Chinese_PRC_CI_AS null,
         DNB_CreatedDate      datetime             not null,
         DNB_ProblemDescription nvarchar(200)      collate Chinese_PRC_CI_AS null,
         DNB_SAPSalesOrderID  nvarchar(50)         collate Chinese_PRC_CI_AS null,
         DNB_POReceiptLot_PRL_ID uniqueidentifier  null,
         DNB_HandleDate       datetime             null,
         DNB_DMA_ID           uniqueidentifier     null,
         DNB_BU_Name          nvarchar(200)        collate Chinese_PRC_CI_AS null,
         DNB_BUM_ID           uniqueidentifier     null,
         DNB_PCT_ID           uniqueidentifier     null,
         DNB_CFN_ID           uniqueidentifier     null,
         DNB_PMA_ID           uniqueidentifier     null,
         DNB_LTM_ID           uniqueidentifier     null,
         DNB_Carrier          nvarchar(20)         null,
         DNB_TrackingNo       nvarchar(100)        null,
         DNB_ShipType         nvarchar(20)         null,
         DNB_Note             nvarchar(100)        null,
         DNB_ToWhmCode        nvarchar(50)         null,
         DNB_ToWhmId          uniqueidentifier     null,
         DNB_ClientID         nvarchar(50)         null,
         DNB_BatchNbr         nvarchar(30)         null
      )
      
   
	  
		  --所有数据先写入临时表，然后再做校验		 
		  INSERT INTO #tmp_DNBSCSLC (
                  DNB_ID,
                  DNB_ISB_ID,
									DNB_SapDeliveryLineNbr,
									DNB_DeliveryNoteNbr,
                  DNB_DeliveryDate,
                  DNB_SoldToSAPCode,
                  DNB_SoldToName,
                  DNB_ShipToSAPCode,
                  DNB_ShipToName,
                  DNB_CFN,
                  DNB_UPN,
                  DNB_LotNumber,
                  DNB_QRCode,
                  DNB_ShipQty,
                  DNB_ExpiredDate,
                  DNB_OrderNo,
                  DNB_BoxNo,
                  DNB_ImportFileName,                  
									DNB_CreatedDate,
									DNB_ClientID,
                  DNB_BatchNbr)
    			 SELECT newid(),              
                  A.ISB_ID,                               --主键
    					    A.ISB_LineNbr,                         --发货单批号
        					A.ISB_DeliveryNo,                        --（DMS系统中的经销商编号）
                  A.ISB_DeliveryDate,
                  A.ISB_SoldToSAPCode,
                  A.ISB_SoldToName,
                  A.ISB_ShipToSAPCode,
                  A.ISB_ShipToName,
                  A.ISB_UPN,
                  A.ISB_UPN,            
        					ISNULL (SUBSTRING (A.ISB_LotNumber,PATINDEX ('%[^0]%', A.ISB_LotNumber),LEN (A.ISB_LotNumber) - PATINDEX ('%[^0]%', A.ISB_LotNumber) + 1),''),   --产品批号(去除前面的0)
        					A.ISB_QRCode,
                  A.ISB_DeliveryQty,
                  A.ISB_ExpiredDate,
                  A.ISB_OrderNo,
                  A.ISB_BoxNo,
        					A.ISB_FileName,                                          --文件名
        					getdate (),                                             --创建日期
        			    A.ISB_ClientID,
        					A.ISB_BatchNbr
        			   FROM InterfaceShipmentBSCSLC AS A
        			  WHERE     ISB_BatchNbr = @BatchNbr



		  /* 更新错误信息：
			   1、数据格式是否正确，必须填写的项目是否都已填写
         2、经销商不存在、产品型号不存在,批号不存在
         3、如果二维码不为空，则不允许数量大于0
         4、一次发货数据中，不能有相同二维码的多条数据
         5、二维码库中必须存在此二维码信息
         6、DeliveryNoteBSCSLC表是否有历史发货单数据（如果有，则不允许再写入）   
		   */
		  
      
      
      --因为接口过来的数据，除了经销商还有直销医院、销售人员等，所以不用校验经销商是否存在。
      --发货单号不能为空
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'发货单不能为空'
						ELSE
						   DNB_ProblemDescription + N',发货单不能为空'
					  END)
		   WHERE (#tmp_DNBSCSLC.DNB_DeliveryNoteNbr IS NULL OR #tmp_DNBSCSLC.DNB_DeliveryNoteNbr = '')       
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
      
      --发货日期不能为空
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'发货日期不能为空'
						ELSE
						   DNB_ProblemDescription + N',发货日期不能为空'
					  END)
		   WHERE #tmp_DNBSCSLC.DNB_DeliveryDate IS NULL       
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
      
      --订购对象SAP编号不能为空
      /*  增加退货单数据以后，此项不校验
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'订购对象SAP编号不能为空'
						ELSE
						   DNB_ProblemDescription + N',订购对象SAP编号不能为空'
					  END)
		   WHERE (#tmp_DNBSCSLC.DNB_SoldToSAPCode IS NULL OR #tmp_DNBSCSLC.DNB_SoldToSAPCode = '')       
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
      */
		  
      --产品型号不能为空
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'产品型号不能为空'
						ELSE
						   DNB_ProblemDescription + N',产品型号不能为空'
					  END)
		   WHERE (#tmp_DNBSCSLC.DNB_CFN IS NULL OR #tmp_DNBSCSLC.DNB_CFN = '') 			
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr

      --批号不能为空
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'批号不能为空'
						ELSE
						   DNB_ProblemDescription + N',批号不能为空'
					  END)
		   WHERE (#tmp_DNBSCSLC.DNB_LotNumber IS NULL OR #tmp_DNBSCSLC.DNB_LotNumber = '') 			
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
         
      --产品数量不能为0
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'产品数量不能为0'
						ELSE
						   DNB_ProblemDescription + N',产品数量不能为0'
					  END)
		   WHERE #tmp_DNBSCSLC.DNB_ShipQty = 0
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr      
      
      --如果二维码不为空，则不允许数量大于1
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'二维码产品数量不能大于1'
						ELSE
						   DNB_ProblemDescription + N',二维码产品数量不能大于1'
					  END)
		   WHERE #tmp_DNBSCSLC.DNB_QRCode IS NOT NULL 
         AND #tmp_DNBSCSLC.DNB_QRCode <> ''
         AND #tmp_DNBSCSLC.DNB_ShipQty > 1
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
      
      --一次发货数据中，不能有相同二维码的多条数据
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'一次发货数据中，不能有相同二维码的多条数据'
						ELSE
						   DNB_ProblemDescription + N',一次发货数据中，不能有相同二维码的多条数据'
					  END)
		   WHERE #tmp_DNBSCSLC.DNB_QRCode IS NOT NULL 
         AND #tmp_DNBSCSLC.DNB_QRCode <> ''        
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
         AND #tmp_DNBSCSLC.DNB_QRCode IN 
              (SELECT DNB_QRCode
                 FROM #tmp_DNBSCSLC
                WHERE DNB_BatchNbr = @BatchNbr
               GROUP BY DNB_QRCode
               HAVING count (*) > 1) 
         AND EXISTS 
              ( select 1 from QRCodeMaster AS QRM(nolock)
                 where QRM.QRM_Status = 1
                   AND QRM.QRM_QRCode = #tmp_DNBSCSLC.DNB_QRCode
              )
      
      --不能存在重复的发货单
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'上传的发货单有重复,已成功上传过'
						ELSE
						   DNB_ProblemDescription + N',上传的发货单有重复,已成功上传过'
					  END)
		   WHERE #tmp_DNBSCSLC.DNB_DeliveryNoteNbr IS NOT NULL 
         AND #tmp_DNBSCSLC.DNB_DeliveryNoteNbr <> ''        
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
         AND EXISTS 
              (SELECT 1
                 FROM DeliveryNoteBSCSLC AS DN(nolock)
                WHERE DN.DNB_STATUS IN ('UploadSuccess','GenerateSuccess')
                  AND DN.DNB_DeliveryNoteNbr = #tmp_DNBSCSLC.DNB_DeliveryNoteNbr
              )
      
      --校验二维码平台中是否存在此二维码(处理方式修改为：如果不存在此二维码，则直接分配一个ERRQR开头的DMS二维码，DMS就不再报错了)
--      UPDATE #tmp_DNBSCSLC
--			 SET DNB_ProblemDescription =
--					 (CASE
--						WHEN DNB_ProblemDescription IS NULL
--						THEN
--						   N'二维码平台中不存在此二维码'
--						ELSE
--						   DNB_ProblemDescription + N',二维码平台中不存在此二维码'
--					  END)
--		   WHERE #tmp_DNBSCSLC.DNB_QRCode IS NOT NULL 
--         AND #tmp_DNBSCSLC.DNB_QRCode <> ''        
--				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
--         AND NOT EXISTS 
--              ( select 1 from QRCodeMaster AS QRM(nolock)
--                 where QRM.QRM_Status = 1
--                   AND QRM.QRM_QRCode = #tmp_DNBSCSLC.DNB_QRCode
--              )
     
      
      
      --更新经销商ID(有的更新，没有的可能是直销医院或销售人员)
  		UPDATE #tmp_DNBSCSLC
  			 SET DNB_DMA_ID = DealerMaster.DMA_ID,
  				   DNB_HandleDate = getdate ()
  			FROM DealerMaster(nolock)
		   WHERE (DealerMaster.DMA_SAP_Code = #tmp_DNBSCSLC.DNB_SoldToSAPCode OR RIGHT (REPLICATE ('0', 10) + DealerMaster.DMA_SAP_Code,10) = #tmp_DNBSCSLC.DNB_SoldToSAPCode)								 
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr

		  
      --更新产品信息（有的更新，没有的可能是SAP没有同步到DMS的产品）
		  UPDATE A
  			 SET A.DNB_CFN_ID = CFN.CFN_ID,                     --产品型号
  				   A.DNB_PMA_ID = Product.PMA_ID,
  				   A.DNB_BUM_ID = CFN.CFN_ProductLine_BUM_ID,     --产品线
  				   A.DNB_PCT_ID = ccf.ClassificationId, --产品分类
  				   A.DNB_HandleDate = GETDATE ()
  			FROM #tmp_DNBSCSLC A  
  			inner join CFN(nolock) ON CFN.CFN_CustomerFaceNbr = A.DNB_CFN	
  			INNER JOIN Product(nolock) ON Product.PMA_CFN_ID = CFN.CFN_ID
  			inner join CfnClassification ccf on ccf.CfnCustomerFaceNbr=cfn.CFN_CustomerFaceNbr
  			and ccf.ClassificationId in (select ProducPctId from GC_FN_GetDealerAuthProductSub(a.DNB_DMA_ID))
		   WHERE  A.DNB_BatchNbr = @BatchNbr


      
		  --SAP发货给LP、一级经销商，如果发货单包含错误，则整单不生成收货单，待问题处理完了以后再重新传
		  SELECT @ErrCnt = count (*)
		  FROM #tmp_DNBSCSLC
		  WHERE DNB_BatchNbr = @BatchNbr AND DNB_ProblemDescription IS NOT NULL

      IF @ErrCnt = 0 
        BEGIN
          --找出所有不存在的二维码数据，并分配一个编号
          UPDATE #tmp_DNBSCSLC
      			 SET DNB_Note = '原QRCode：' + DNB_QRCode
      		   WHERE #tmp_DNBSCSLC.DNB_QRCode IS NOT NULL 
               AND #tmp_DNBSCSLC.DNB_QRCode <> ''        
      				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
               AND NOT EXISTS 
                    ( select 1 from QRCodeMaster AS QRM(nolock)
                       where QRM.QRM_Status = 1
                         AND QRM.QRM_QRCode = #tmp_DNBSCSLC.DNB_QRCode
                    )
          
          --更新二维码
          UPDATE #tmp_DNBSCSLC
      			 SET DNB_QRCode = REPLACE(DNB_BatchNbr,'U17SLC','ERRQR') + RIGHT('000'+CONVERT(NVARCHAR,DNB_SapDeliveryLineNbr),4)
      		   WHERE #tmp_DNBSCSLC.DNB_QRCode IS NOT NULL 
               AND #tmp_DNBSCSLC.DNB_QRCode <> ''        
      				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
               AND NOT EXISTS 
                    ( select 1 from QRCodeMaster AS QRM(nolock)
                       where QRM.QRM_Status = 1
                         AND QRM.QRM_QRCode = #tmp_DNBSCSLC.DNB_QRCode
                    )
          
          --将ERRQR开头的DMS二维码写入QRCodeMaster表
          INSERT INTO QRCodeMaster (QRM_ID,QRM_QRCode,QRM_Status,QRM_CreateDate,QRM_UserCode,QRM_Channel,QRM_ImportDate,QRM_UpdateDate)
          SELECT newid(),
                 DNB_QRCode = REPLACE(DNB_BatchNbr,'U17SLC','ERRQR') + RIGHT('000'+CONVERT(NVARCHAR,DNB_SapDeliveryLineNbr),4),
                 1 AS QRM_Status,
                 getdate() AS QRM_CreateDate,
                 DNB_SoldToSAPCode,
                 null,
                 getdate(),
                 null                  
             FROM #tmp_DNBSCSLC
      	    WHERE #tmp_DNBSCSLC.DNB_QRCode IS NOT NULL 
              AND #tmp_DNBSCSLC.DNB_QRCode <> ''        
      			 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
              AND NOT EXISTS 
                    ( select 1 from QRCodeMaster AS QRM(nolock)
                       where QRM.QRM_Status = 1
                         AND QRM.QRM_QRCode = #tmp_DNBSCSLC.DNB_QRCode
                    ) 
          
          
          
          insert into DeliveryNoteBSCSLC (
                       DNB_ID
                      ,DNB_DeliveryNoteNbr
                      ,DNB_DeliveryDate
                      ,DNB_SoldToSAPCode
                      ,DNB_SoldToName
                      ,DNB_ShipToSAPCode
                      ,DNB_ShipToName
                      ,DNB_CFN
                      ,DNB_UPN
                      ,DNB_LotNumber
                      ,DNB_QRCode
                      ,DNB_ShipQty
                      ,DNB_ReceiveQty
                      ,DNB_ExpiredDate
                      ,DNB_DeliveryUnitOfMeasure
                      ,DNB_ReceiveUnitOfMeasure
                      ,DNB_UnitPrice
                      ,DNB_OrderNo
                      ,DNB_BoxNo
                      ,DNB_OrderType
                      ,DNB_LineNbrInFile
                      ,DNB_SapDeliveryLineNbr
                      ,DNB_ImportFileName
                      ,DNB_ShipmentType
                      ,DNB_CreatedDate
                      ,DNB_ProblemDescription
                      ,DNB_SAPSalesOrderID
                      ,DNB_POReceiptLot_PRL_ID
                      ,DNB_HandleDate
                      ,DNB_DMA_ID
                      ,DNB_BU_Name
                      ,DNB_BUM_ID
                      ,DNB_PCT_ID
                      ,DNB_CFN_ID
                      ,DNB_PMA_ID
                      ,DNB_LTM_ID
                      ,DNB_Carrier
                      ,DNB_TrackingNo
                      ,DNB_ShipType
                      ,DNB_Note
                      ,DNB_ToWhmCode
                      ,DNB_ToWhmId
                      ,DNB_ClientID
                      ,DNB_BatchNbr
                      ,DNB_Status
                    ) SELECT 
                        DNB_ID,
                        DNB_DeliveryNoteNbr,
                        DNB_DeliveryDate,
                        DNB_SoldToSAPCode,
                        DNB_SoldToName,
                        DNB_ShipToSAPCode,
                        DNB_ShipToName,
                        DNB_CFN,
                        DNB_UPN,
                        DNB_LotNumber,
                        DNB_QRCode,
                        DNB_ShipQty,
                        DNB_ReceiveQty,
                        DNB_ExpiredDate,
                        DNB_DeliveryUnitOfMeasure,
                        DNB_ReceiveUnitOfMeasure,
                        DNB_UnitPrice,
                        DNB_OrderNo,
                        DNB_BoxNo,
                        DNB_OrderType,
                        DNB_LineNbrInFile,
                        DNB_SapDeliveryLineNbr,
                        DNB_ImportFileName,
                        DNB_ShipmentType,
                        DNB_CreatedDate,
                        DNB_ProblemDescription,
                        DNB_SAPSalesOrderID,
                        DNB_POReceiptLot_PRL_ID,
                        DNB_HandleDate,
                        DNB_DMA_ID,
                        DNB_BU_Name,
                        DNB_BUM_ID,
                        DNB_PCT_ID,
                        DNB_CFN_ID,
                        DNB_PMA_ID,
                        DNB_LTM_ID,
                        DNB_Carrier,
                        DNB_TrackingNo,
                        DNB_ShipType,
                        DNB_Note,
                        DNB_ToWhmCode,
                        DNB_ToWhmId,
                        DNB_ClientID,
                        DNB_BatchNbr,
                        'UploadSuccess'
                      FROM #tmp_DNBSCSLC
		                 WHERE DNB_BatchNbr = @BatchNbr 
                     
          
        END
		  ELSE
        BEGIN
          INSERT INTO DeliveryNoteBSCSLC (
                       DNB_ID
                      ,DNB_DeliveryNoteNbr
                      ,DNB_DeliveryDate
                      ,DNB_SoldToSAPCode
                      ,DNB_SoldToName
                      ,DNB_ShipToSAPCode
                      ,DNB_ShipToName
                      ,DNB_CFN
                      ,DNB_UPN
                      ,DNB_LotNumber
                      ,DNB_QRCode
                      ,DNB_ShipQty
                      ,DNB_ReceiveQty
                      ,DNB_ExpiredDate
                      ,DNB_DeliveryUnitOfMeasure
                      ,DNB_ReceiveUnitOfMeasure
                      ,DNB_UnitPrice
                      ,DNB_OrderNo
                      ,DNB_BoxNo
                      ,DNB_OrderType
                      ,DNB_LineNbrInFile
                      ,DNB_SapDeliveryLineNbr
                      ,DNB_ImportFileName
                      ,DNB_ShipmentType
                      ,DNB_CreatedDate
                      ,DNB_ProblemDescription
                      ,DNB_SAPSalesOrderID
                      ,DNB_POReceiptLot_PRL_ID
                      ,DNB_HandleDate
                      ,DNB_DMA_ID
                      ,DNB_BU_Name
                      ,DNB_BUM_ID
                      ,DNB_PCT_ID
                      ,DNB_CFN_ID
                      ,DNB_PMA_ID
                      ,DNB_LTM_ID
                      ,DNB_Carrier
                      ,DNB_TrackingNo
                      ,DNB_ShipType
                      ,DNB_Note
                      ,DNB_ToWhmCode
                      ,DNB_ToWhmId
                      ,DNB_ClientID
                      ,DNB_BatchNbr
                      ,DNB_Status
                    ) SELECT 
                        DNB_ID,
                        DNB_DeliveryNoteNbr,
                        DNB_DeliveryDate,
                        DNB_SoldToSAPCode,
                        DNB_SoldToName,
                        DNB_ShipToSAPCode,
                        DNB_ShipToName,
                        DNB_CFN,
                        DNB_UPN,
                        DNB_LotNumber,
                        DNB_QRCode,
                        DNB_ShipQty,
                        DNB_ReceiveQty,
                        DNB_ExpiredDate,
                        DNB_DeliveryUnitOfMeasure,
                        DNB_ReceiveUnitOfMeasure,
                        DNB_UnitPrice,
                        DNB_OrderNo,
                        DNB_BoxNo,
                        DNB_OrderType,
                        DNB_LineNbrInFile,
                        DNB_SapDeliveryLineNbr,
                        DNB_ImportFileName,
                        DNB_ShipmentType,
                        DNB_CreatedDate,
                        DNB_ProblemDescription,
                        DNB_SAPSalesOrderID,
                        DNB_POReceiptLot_PRL_ID,
                        DNB_HandleDate,
                        DNB_DMA_ID,
                        DNB_BU_Name,
                        DNB_BUM_ID,
                        DNB_PCT_ID,
                        DNB_CFN_ID,
                        DNB_PMA_ID,
                        DNB_LTM_ID,
                        DNB_Carrier,
                        DNB_TrackingNo,
                        DNB_ShipType,
                        DNB_Note,
                        DNB_ToWhmCode,
                        DNB_ToWhmId,
                        DNB_ClientID,
                        DNB_BatchNbr,
                        'UploadError'
                      FROM #tmp_DNBSCSLC
		                 WHERE DNB_BatchNbr = @BatchNbr  
        
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
      DECLARE @error_line   INT
      DECLARE @error_number   INT
      DECLARE @error_message   NVARCHAR (256)
      DECLARE @vError   NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError = '行' + CONVERT (NVARCHAR (10), @error_line) + '出错[错误号' + CONVERT (NVARCHAR (10), @error_number) + '],' + @error_message
      SET @RtnMsg = @vError
      --EXEC dbo.GC_Interface_Log 'Shipment', 'Failure', @vError

      RETURN -1
   END CATCH
GO


