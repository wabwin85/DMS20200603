DROP PROCEDURE [dbo].[GC_Interface_ShipmentBSCSLC]
GO

/*
���Ʒ��������ϴ�������WMSϵͳ�ϴ���
1������WMSϵͳͨ���ӿ��ϴ����ݣ���ʱ@BatchNbr��@ClientID����Ϊ��
2��ϵͳ�������ݲ�У������׼ȷ�ԣ�ֻ��׼ȷ�����ݲŻ�д��DeliveryNoteBSCSLC��
   --���ݸ�ʽ�Ƿ���ȷ��������д����Ŀ�Ƿ�����д
   --DeliveryNoteBSCSLC���Ƿ�����ʷ���������ݣ�����У���������д�룩
   --�Ƿ����ظ��Ķ�ά��
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
	 
      --������Ϣ��ʱ��(DeliveryNoteBSCSLC��ʱ��)
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
      
   
	  
		  --����������д����ʱ��Ȼ������У��		 
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
                  A.ISB_ID,                               --����
    					    A.ISB_LineNbr,                         --����������
        					A.ISB_DeliveryNo,                        --��DMSϵͳ�еľ����̱�ţ�
                  A.ISB_DeliveryDate,
                  A.ISB_SoldToSAPCode,
                  A.ISB_SoldToName,
                  A.ISB_ShipToSAPCode,
                  A.ISB_ShipToName,
                  A.ISB_UPN,
                  A.ISB_UPN,            
        					ISNULL (SUBSTRING (A.ISB_LotNumber,PATINDEX ('%[^0]%', A.ISB_LotNumber),LEN (A.ISB_LotNumber) - PATINDEX ('%[^0]%', A.ISB_LotNumber) + 1),''),   --��Ʒ����(ȥ��ǰ���0)
        					A.ISB_QRCode,
                  A.ISB_DeliveryQty,
                  A.ISB_ExpiredDate,
                  A.ISB_OrderNo,
                  A.ISB_BoxNo,
        					A.ISB_FileName,                                          --�ļ���
        					getdate (),                                             --��������
        			    A.ISB_ClientID,
        					A.ISB_BatchNbr
        			   FROM InterfaceShipmentBSCSLC AS A
        			  WHERE     ISB_BatchNbr = @BatchNbr



		  /* ���´�����Ϣ��
			   1�����ݸ�ʽ�Ƿ���ȷ��������д����Ŀ�Ƿ�����д
         2�������̲����ڡ���Ʒ�ͺŲ�����,���Ų�����
         3�������ά�벻Ϊ�գ���������������0
         4��һ�η��������У���������ͬ��ά��Ķ�������
         5����ά����б�����ڴ˶�ά����Ϣ
         6��DeliveryNoteBSCSLC���Ƿ�����ʷ���������ݣ�����У���������д�룩   
		   */
		  
      
      
      --��Ϊ�ӿڹ��������ݣ����˾����̻���ֱ��ҽԺ��������Ա�ȣ����Բ���У�龭�����Ƿ���ڡ�
      --�������Ų���Ϊ��
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'����������Ϊ��'
						ELSE
						   DNB_ProblemDescription + N',����������Ϊ��'
					  END)
		   WHERE (#tmp_DNBSCSLC.DNB_DeliveryNoteNbr IS NULL OR #tmp_DNBSCSLC.DNB_DeliveryNoteNbr = '')       
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
      
      --�������ڲ���Ϊ��
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'�������ڲ���Ϊ��'
						ELSE
						   DNB_ProblemDescription + N',�������ڲ���Ϊ��'
					  END)
		   WHERE #tmp_DNBSCSLC.DNB_DeliveryDate IS NULL       
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
      
      --��������SAP��Ų���Ϊ��
      /*  �����˻��������Ժ󣬴��У��
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'��������SAP��Ų���Ϊ��'
						ELSE
						   DNB_ProblemDescription + N',��������SAP��Ų���Ϊ��'
					  END)
		   WHERE (#tmp_DNBSCSLC.DNB_SoldToSAPCode IS NULL OR #tmp_DNBSCSLC.DNB_SoldToSAPCode = '')       
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
      */
		  
      --��Ʒ�ͺŲ���Ϊ��
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'��Ʒ�ͺŲ���Ϊ��'
						ELSE
						   DNB_ProblemDescription + N',��Ʒ�ͺŲ���Ϊ��'
					  END)
		   WHERE (#tmp_DNBSCSLC.DNB_CFN IS NULL OR #tmp_DNBSCSLC.DNB_CFN = '') 			
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr

      --���Ų���Ϊ��
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'���Ų���Ϊ��'
						ELSE
						   DNB_ProblemDescription + N',���Ų���Ϊ��'
					  END)
		   WHERE (#tmp_DNBSCSLC.DNB_LotNumber IS NULL OR #tmp_DNBSCSLC.DNB_LotNumber = '') 			
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
         
      --��Ʒ��������Ϊ0
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'��Ʒ��������Ϊ0'
						ELSE
						   DNB_ProblemDescription + N',��Ʒ��������Ϊ0'
					  END)
		   WHERE #tmp_DNBSCSLC.DNB_ShipQty = 0
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr      
      
      --�����ά�벻Ϊ�գ���������������1
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'��ά���Ʒ�������ܴ���1'
						ELSE
						   DNB_ProblemDescription + N',��ά���Ʒ�������ܴ���1'
					  END)
		   WHERE #tmp_DNBSCSLC.DNB_QRCode IS NOT NULL 
         AND #tmp_DNBSCSLC.DNB_QRCode <> ''
         AND #tmp_DNBSCSLC.DNB_ShipQty > 1
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
      
      --һ�η��������У���������ͬ��ά��Ķ�������
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'һ�η��������У���������ͬ��ά��Ķ�������'
						ELSE
						   DNB_ProblemDescription + N',һ�η��������У���������ͬ��ά��Ķ�������'
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
      
      --���ܴ����ظ��ķ�����
      UPDATE #tmp_DNBSCSLC
			 SET DNB_ProblemDescription =
					 (CASE
						WHEN DNB_ProblemDescription IS NULL
						THEN
						   N'�ϴ��ķ��������ظ�,�ѳɹ��ϴ���'
						ELSE
						   DNB_ProblemDescription + N',�ϴ��ķ��������ظ�,�ѳɹ��ϴ���'
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
      
      --У���ά��ƽ̨���Ƿ���ڴ˶�ά��(����ʽ�޸�Ϊ����������ڴ˶�ά�룬��ֱ�ӷ���һ��ERRQR��ͷ��DMS��ά�룬DMS�Ͳ��ٱ�����)
--      UPDATE #tmp_DNBSCSLC
--			 SET DNB_ProblemDescription =
--					 (CASE
--						WHEN DNB_ProblemDescription IS NULL
--						THEN
--						   N'��ά��ƽ̨�в����ڴ˶�ά��'
--						ELSE
--						   DNB_ProblemDescription + N',��ά��ƽ̨�в����ڴ˶�ά��'
--					  END)
--		   WHERE #tmp_DNBSCSLC.DNB_QRCode IS NOT NULL 
--         AND #tmp_DNBSCSLC.DNB_QRCode <> ''        
--				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
--         AND NOT EXISTS 
--              ( select 1 from QRCodeMaster AS QRM(nolock)
--                 where QRM.QRM_Status = 1
--                   AND QRM.QRM_QRCode = #tmp_DNBSCSLC.DNB_QRCode
--              )
     
      
      
      --���¾�����ID(�еĸ��£�û�еĿ�����ֱ��ҽԺ��������Ա)
  		UPDATE #tmp_DNBSCSLC
  			 SET DNB_DMA_ID = DealerMaster.DMA_ID,
  				   DNB_HandleDate = getdate ()
  			FROM DealerMaster(nolock)
		   WHERE (DealerMaster.DMA_SAP_Code = #tmp_DNBSCSLC.DNB_SoldToSAPCode OR RIGHT (REPLICATE ('0', 10) + DealerMaster.DMA_SAP_Code,10) = #tmp_DNBSCSLC.DNB_SoldToSAPCode)								 
				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr

		  
      --���²�Ʒ��Ϣ���еĸ��£�û�еĿ�����SAPû��ͬ����DMS�Ĳ�Ʒ��
		  UPDATE A
  			 SET A.DNB_CFN_ID = CFN.CFN_ID,                     --��Ʒ�ͺ�
  				   A.DNB_PMA_ID = Product.PMA_ID,
  				   A.DNB_BUM_ID = CFN.CFN_ProductLine_BUM_ID,     --��Ʒ��
  				   A.DNB_PCT_ID = ccf.ClassificationId, --��Ʒ����
  				   A.DNB_HandleDate = GETDATE ()
  			FROM #tmp_DNBSCSLC A  
  			inner join CFN(nolock) ON CFN.CFN_CustomerFaceNbr = A.DNB_CFN	
  			INNER JOIN Product(nolock) ON Product.PMA_CFN_ID = CFN.CFN_ID
  			inner join CfnClassification ccf on ccf.CfnCustomerFaceNbr=cfn.CFN_CustomerFaceNbr
  			and ccf.ClassificationId in (select ProducPctId from GC_FN_GetDealerAuthProductSub(a.DNB_DMA_ID))
		   WHERE  A.DNB_BatchNbr = @BatchNbr


      
		  --SAP������LP��һ�������̣�������������������������������ջ����������⴦�������Ժ������´�
		  SELECT @ErrCnt = count (*)
		  FROM #tmp_DNBSCSLC
		  WHERE DNB_BatchNbr = @BatchNbr AND DNB_ProblemDescription IS NOT NULL

      IF @ErrCnt = 0 
        BEGIN
          --�ҳ����в����ڵĶ�ά�����ݣ�������һ�����
          UPDATE #tmp_DNBSCSLC
      			 SET DNB_Note = 'ԭQRCode��' + DNB_QRCode
      		   WHERE #tmp_DNBSCSLC.DNB_QRCode IS NOT NULL 
               AND #tmp_DNBSCSLC.DNB_QRCode <> ''        
      				 AND #tmp_DNBSCSLC.DNB_BatchNbr = @BatchNbr
               AND NOT EXISTS 
                    ( select 1 from QRCodeMaster AS QRM(nolock)
                       where QRM.QRM_Status = 1
                         AND QRM.QRM_QRCode = #tmp_DNBSCSLC.DNB_QRCode
                    )
          
          --���¶�ά��
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
          
          --��ERRQR��ͷ��DMS��ά��д��QRCodeMaster��
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

      --��¼�ɹ���־
      --EXEC dbo.GC_Interface_Log 'Shipment', 'Success', ''

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
      --EXEC dbo.GC_Interface_Log 'Shipment', 'Failure', @vError

      RETURN -1
   END CATCH
GO


