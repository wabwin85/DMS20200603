DROP PROCEDURE [dbo].[GC_Interface_QRDealerTransaction]
GO


/*
二维码平台APP上传经销商的交易信息
1、二维码平台通过接口上传数据，此时@BatchNbr和@ClientID不能为空
2、系统保存数据并校验数据准确性，并写入正确的数据至正式表： [interface].[T_I_WC_DealerBarcodeQRcodeScan]
   --经销商不能为空 <ErrorCode>E001</ErrorCode><ErrorDesc>经销商不能为空</ErrorDesc>
   --经销商不存在   <ErrorCode>E002</ErrorCode><ErrorDesc>经销商不存在</ErrorDesc>
   --提交人不能为空 <ErrorCode>E003</ErrorCode><ErrorDesc>提交人不能为空</ErrorDesc>
   --单据日期不能为空 <ErrorCode>E004</ErrorCode><ErrorDesc>单据日期不能为空</ErrorDesc>   
   --数据类型不能为空   <ErrorCode>E005</ErrorCode><ErrorDesc>操作类型不能为空</ErrorDesc>
   --备注说明不能为空   <ErrorCode>E006</ErrorCode><ErrorDesc>备注说明不能为空</ErrorDesc>
   --行号不能为空   <ErrorCode>E007</ErrorCode><ErrorDesc>行号不能为空</ErrorDesc>
   --行号不是数字类型   <ErrorCode>E008</ErrorCode><ErrorDesc>行号不是数字类型</ErrorDesc>
   --二维码编号不存在（QRCodeMaster） <ErrorCode>E009</ErrorCode><ErrorDesc>二维码编号不存在</ErrorDesc>
   --二维码没有关联   <ErrorCode>E010</ErrorCode><ErrorDesc>二维码未关联，需要填写UPN和批号</ErrorDesc>
   --填写的UPN不存在  <ErrorCode>E011</ErrorCode><ErrorDesc>填写的UPN不存在</ErrorDesc>
   --填写的UPN、批号没有关联关系  <ErrorCode>E012</ErrorCode><ErrorDesc>填写的UPN、批号不匹配</ErrorDesc>
*/

CREATE PROCEDURE [dbo].[GC_Interface_QRDealerTransaction]
   @BatchNbr       NVARCHAR (30),
   @ClientID       NVARCHAR (50),
   @IsValid        NVARCHAR (20) OUTPUT,
   @RtnMsg         NVARCHAR (500) OUTPUT
AS
   DECLARE @ErrorCount   INTEGER 
   DECLARE @SysUserId   UNIQUEIDENTIFIER  
   DECLARE @EmptyGuid   UNIQUEIDENTIFIER

   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN

      SET @IsValid = 'Success'
      SET @RtnMsg = ''
      SET @SysUserId = '00000000-0000-0000-0000-000000000000'
      SET @EmptyGuid = '00000000-0000-0000-0000-000000000000'

	  CREATE TABLE #TmpInterfaceQRDealerTransaction(
			[IDT_ID] [uniqueidentifier] NOT NULL,
			[IDT_DealerCode] [nvarchar](50) NULL,
			[IDT_UserName] [nvarchar](50) NULL,
			[IDT_UploadDate] [datetime] NULL,
			[IDT_DataType] [nvarchar](50) NULL,
			[IDT_Remark] [nvarchar](100) NULL,
			[IDT_RowNo] [int] NULL,
			[IDT_QRCode] [nvarchar](50) NULL,
			[IDT_UPN] [nvarchar](50) NULL,
			[IDT_Lot] [nvarchar](50) NULL,
			[IDT_PMA_ID] [uniqueidentifier] NULL,
			[IDT_DMA_ID] [uniqueidentifier] NULL,
			[IDT_FileName] [nvarchar](200) NULL,
			[IDT_ImportDate] [datetime] NOT NULL,
			[IDT_ClientID] [nvarchar](50) NOT NULL,
			[IDT_BatchNbr] [nvarchar](30) NOT NULL,
			[IDT_ErrorMsg] [nvarchar](max) NULL
      )
	  
	  INSERT INTO #TmpInterfaceQRDealerTransaction
	  SELECT * FROM InterfaceQRDealerTransaction WHERE IDT_BatchNbr = @BatchNbr


      /* 更新错误信息 */    
	  UPDATE #TmpInterfaceQRDealerTransaction
		 SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E001</ErrorCode><ErrorDesc>经销商不能为空</ErrorDesc>'
	   WHERE (#TmpInterfaceQRDealerTransaction.IDT_DealerCode IS NULL OR #TmpInterfaceQRDealerTransaction.IDT_DealerCode	= '')
	 		 AND #TmpInterfaceQRDealerTransaction.IDT_BatchNbr = @BatchNbr

      --更新经销商ID
      UPDATE t1
         SET t1.IDT_DMA_ID = t2.DMA_ID
        FROM #TmpInterfaceQRDealerTransaction t1, DealerMaster t2
       WHERE t1.IDT_DealerCode = t2.DMA_SAP_Code
        AND  t1.IDT_DealerCode IS NOT NULL 
        AND  t1.IDT_DealerCode	<> ''
			  AND  t1.IDT_BatchNbr = @BatchNbr
      
	  UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E002</ErrorCode><ErrorDesc>经销商不存在</ErrorDesc>'				
		   WHERE IDT_DealerCode IS NOT NULL 
        AND  IDT_DealerCode	<> ''
        AND  IDT_DMA_ID IS NULL
			  AND  IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
      
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E003</ErrorCode><ErrorDesc>提交人不能为空</ErrorDesc>'				
		   WHERE (IDT_UserName IS NULL OR IDT_UserName = '')
			  AND  IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
      
	  UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E004</ErrorCode><ErrorDesc>单据日期不能为空</ErrorDesc>'				
		   WHERE IDT_UploadDate IS NULL 
			  AND  IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
      
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E005</ErrorCode><ErrorDesc>操作类型不能为空</ErrorDesc>'				
		   WHERE (IDT_DataType IS NULL OR IDT_DataType = '')
			  AND  IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
        
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E006</ErrorCode><ErrorDesc>备注说明不能为空</ErrorDesc>'				
		   WHERE (IDT_Remark IS NULL OR IDT_Remark = '')
			  AND  IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
        
      UPDATE #TmpInterfaceQRDealerTransaction
			 SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E007</ErrorCode><ErrorDesc>行号不能为空</ErrorDesc>'				
		   WHERE IDT_RowNo IS NULL
			  AND  IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL  
      
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E008</ErrorCode><ErrorDesc>二维码编号不能为空</ErrorDesc>'				
		   WHERE (IDT_QRCode IS NULL OR IDT_QRCode = '')
			  AND  IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
        
      /*
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E009</ErrorCode><ErrorDesc>二维码编号不存在</ErrorDesc>'				
		   WHERE IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
        AND  NOT EXISTS (SELECT 1 FROM QRCodeMaster QRM where QRM.QRM_QRCode = IDT_QRCode)
      */
      /*
      UPDATE t1
         SET t1.IDT_UPN = P.PMA_UPN, t1.IDT_Lot = VLM.LTM_LotNumber
        FROM #TmpInterfaceQRDealerTransaction t1, V_LotMaster VLM ,Product P
       WHERE t1.IDT_QRCode = VLM.LTM_QrCode and VLM.LTM_Product_PMA_ID = P.PMA_ID
         AND t1.IDT_BatchNbr = @BatchNbr
         AND IDT_ErrorMsg IS NULL
      
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E010</ErrorCode><ErrorDesc>二维码未关联，需要填写UPN和批号</ErrorDesc>'				
		   WHERE IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
		AND  (IDT_UPN IS NULL OR IDT_UPN='' OR IDT_Lot IS NULL OR IDT_LOT ='')
        AND  NOT EXISTS (SELECT 1 FROM V_LotMaster VLM where VLM.LTM_QrCode = IDT_QRCode)         
        
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E011</ErrorCode><ErrorDesc>填写的UPN不存在</ErrorDesc>'				
		   WHERE IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
		AND IDT_UPN IS NOT NULL AND IDT_UPN<>''
        AND NOT EXISTS (SELECT 1 FROM V_LotMaster VLM where VLM.LTM_QrCode = IDT_QRCode)
        AND NOT EXISTS (SELECT 1 FROM CFN where CFN.CFN_CustomerFaceNbr = IDT_UPN)      
      
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E012</ErrorCode><ErrorDesc>填写的UPN、批号不匹配</ErrorDesc>'				
		   WHERE IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
        AND NOT EXISTS (SELECT 1 FROM V_LotMaster VLM where VLM.LTM_QrCode = IDT_QRCode) 
        AND IDT_UPN IS NOT NULL AND IDT_UPN<>'' AND IDT_Lot IS NOT NULL AND IDT_LOT<>''
        AND NOT EXISTS (SELECT 1 FROM V_LotMaster VLM, Product P where VLM.LTM_Product_PMA_ID = P.PMA_ID and VLM.LTM_LotNumber = IDT_Lot and IDT_UPN = P.PMA_UPN )  
      */
      
      /* 不要更新了，如果已存在，则系统自动删除
 	  UPDATE #TmpInterfaceQRDealerTransaction
	  		   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E013</ErrorCode><ErrorDesc>已提交过此二维码</ErrorDesc>'				
	  	   WHERE IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL       
        AND  EXISTS (SELECT 1 FROM interface.T_I_WC_DealerBarcodeQRcodeScan AS WC WHERE WC.QRC_DMA_ID = IDT_DMA_ID and WC.QRC_QRCode = IDT_QRCode and WC.QRC_Status='New' )  
      */
	     
      DECLARE @cnt int;
	    select @cnt = COUNT(*) from #TmpInterfaceQRDealerTransaction where IDT_ErrorMsg IS NOT NULL AND IDT_BatchNbr = @BatchNbr

	    IF(@cnt = 0)
			BEGIN
			/* 如果已经存在的,则更新为删除*/
			UPDATE interface.T_I_WC_DealerBarcodeQRcodeScan SET QRC_Status='Delete'
			where EXISTS (SELECT 1 FROM #TmpInterfaceQRDealerTransaction WHERE QRC_DMA_ID = IDT_DMA_ID and QRC_QRCode = IDT_QRCode) 
			  and QRC_Status='New'
			
			/* 将正确的数据写入正式表 */
			--新增
			INSERT INTO interface.T_I_WC_DealerBarcodeQRcodeScan 
			(QRC_ID, QRC_DMA_ID, QRC_BarCode1, QRC_BarCode2, QRC_QRCode, QRC_UPN, QRC_LOT, 
			 QRC_Remark, QRC_RemarkDate, QRC_CreateDate, QRC_CreateUserName, QRC_Status, QRC_DataHandleRemark
			) SELECT newid(),t1.IDT_DMA_ID, t1.IDT_DataType,IDT_ClientID,t1.IDT_QRCode,isnull(P.PMA_UPN,IDT_UPN),ISNULL(VLM.LTM_LotNumber,IDT_Lot),
			  t1.IDT_Remark,t1.IDT_UploadDate,getdate(),t1.IDT_UserName,'New',null
				FROM #TmpInterfaceQRDealerTransaction t1 
				LEFT JOIN V_LotMaster VLM ON (t1.IDT_QRCode = VLM.LTM_QRCode)
				LEFT JOIN Product P ON (P.PMA_ID = VLM.LTM_Product_PMA_ID )
			   WHERE IDT_BatchNbr = @BatchNbr
			     
			 END
		ELSE 
		    BEGIN
			  --SELECT * 
			  UPDATE t2 SET t2.IDT_ErrorMsg = t1.IDT_ErrorMsg
			  FROM #TmpInterfaceQRDealerTransaction t1, dbo.InterfaceQRDealerTransaction t2
			  where t1.IDT_ID = t2.IDT_ID

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


