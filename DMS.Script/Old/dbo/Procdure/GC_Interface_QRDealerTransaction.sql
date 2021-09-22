DROP PROCEDURE [dbo].[GC_Interface_QRDealerTransaction]
GO


/*
��ά��ƽ̨APP�ϴ������̵Ľ�����Ϣ
1����ά��ƽ̨ͨ���ӿ��ϴ����ݣ���ʱ@BatchNbr��@ClientID����Ϊ��
2��ϵͳ�������ݲ�У������׼ȷ�ԣ���д����ȷ����������ʽ�� [interface].[T_I_WC_DealerBarcodeQRcodeScan]
   --�����̲���Ϊ�� <ErrorCode>E001</ErrorCode><ErrorDesc>�����̲���Ϊ��</ErrorDesc>
   --�����̲�����   <ErrorCode>E002</ErrorCode><ErrorDesc>�����̲�����</ErrorDesc>
   --�ύ�˲���Ϊ�� <ErrorCode>E003</ErrorCode><ErrorDesc>�ύ�˲���Ϊ��</ErrorDesc>
   --�������ڲ���Ϊ�� <ErrorCode>E004</ErrorCode><ErrorDesc>�������ڲ���Ϊ��</ErrorDesc>   
   --�������Ͳ���Ϊ��   <ErrorCode>E005</ErrorCode><ErrorDesc>�������Ͳ���Ϊ��</ErrorDesc>
   --��ע˵������Ϊ��   <ErrorCode>E006</ErrorCode><ErrorDesc>��ע˵������Ϊ��</ErrorDesc>
   --�кŲ���Ϊ��   <ErrorCode>E007</ErrorCode><ErrorDesc>�кŲ���Ϊ��</ErrorDesc>
   --�кŲ�����������   <ErrorCode>E008</ErrorCode><ErrorDesc>�кŲ�����������</ErrorDesc>
   --��ά���Ų����ڣ�QRCodeMaster�� <ErrorCode>E009</ErrorCode><ErrorDesc>��ά���Ų�����</ErrorDesc>
   --��ά��û�й���   <ErrorCode>E010</ErrorCode><ErrorDesc>��ά��δ��������Ҫ��дUPN������</ErrorDesc>
   --��д��UPN������  <ErrorCode>E011</ErrorCode><ErrorDesc>��д��UPN������</ErrorDesc>
   --��д��UPN������û�й�����ϵ  <ErrorCode>E012</ErrorCode><ErrorDesc>��д��UPN�����Ų�ƥ��</ErrorDesc>
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


      /* ���´�����Ϣ */    
	  UPDATE #TmpInterfaceQRDealerTransaction
		 SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E001</ErrorCode><ErrorDesc>�����̲���Ϊ��</ErrorDesc>'
	   WHERE (#TmpInterfaceQRDealerTransaction.IDT_DealerCode IS NULL OR #TmpInterfaceQRDealerTransaction.IDT_DealerCode	= '')
	 		 AND #TmpInterfaceQRDealerTransaction.IDT_BatchNbr = @BatchNbr

      --���¾�����ID
      UPDATE t1
         SET t1.IDT_DMA_ID = t2.DMA_ID
        FROM #TmpInterfaceQRDealerTransaction t1, DealerMaster t2
       WHERE t1.IDT_DealerCode = t2.DMA_SAP_Code
        AND  t1.IDT_DealerCode IS NOT NULL 
        AND  t1.IDT_DealerCode	<> ''
			  AND  t1.IDT_BatchNbr = @BatchNbr
      
	  UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E002</ErrorCode><ErrorDesc>�����̲�����</ErrorDesc>'				
		   WHERE IDT_DealerCode IS NOT NULL 
        AND  IDT_DealerCode	<> ''
        AND  IDT_DMA_ID IS NULL
			  AND  IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
      
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E003</ErrorCode><ErrorDesc>�ύ�˲���Ϊ��</ErrorDesc>'				
		   WHERE (IDT_UserName IS NULL OR IDT_UserName = '')
			  AND  IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
      
	  UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E004</ErrorCode><ErrorDesc>�������ڲ���Ϊ��</ErrorDesc>'				
		   WHERE IDT_UploadDate IS NULL 
			  AND  IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
      
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E005</ErrorCode><ErrorDesc>�������Ͳ���Ϊ��</ErrorDesc>'				
		   WHERE (IDT_DataType IS NULL OR IDT_DataType = '')
			  AND  IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
        
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E006</ErrorCode><ErrorDesc>��ע˵������Ϊ��</ErrorDesc>'				
		   WHERE (IDT_Remark IS NULL OR IDT_Remark = '')
			  AND  IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
        
      UPDATE #TmpInterfaceQRDealerTransaction
			 SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E007</ErrorCode><ErrorDesc>�кŲ���Ϊ��</ErrorDesc>'				
		   WHERE IDT_RowNo IS NULL
			  AND  IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL  
      
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E008</ErrorCode><ErrorDesc>��ά���Ų���Ϊ��</ErrorDesc>'				
		   WHERE (IDT_QRCode IS NULL OR IDT_QRCode = '')
			  AND  IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
        
      /*
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E009</ErrorCode><ErrorDesc>��ά���Ų�����</ErrorDesc>'				
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
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E010</ErrorCode><ErrorDesc>��ά��δ��������Ҫ��дUPN������</ErrorDesc>'				
		   WHERE IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
		AND  (IDT_UPN IS NULL OR IDT_UPN='' OR IDT_Lot IS NULL OR IDT_LOT ='')
        AND  NOT EXISTS (SELECT 1 FROM V_LotMaster VLM where VLM.LTM_QrCode = IDT_QRCode)         
        
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E011</ErrorCode><ErrorDesc>��д��UPN������</ErrorDesc>'				
		   WHERE IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
		AND IDT_UPN IS NOT NULL AND IDT_UPN<>''
        AND NOT EXISTS (SELECT 1 FROM V_LotMaster VLM where VLM.LTM_QrCode = IDT_QRCode)
        AND NOT EXISTS (SELECT 1 FROM CFN where CFN.CFN_CustomerFaceNbr = IDT_UPN)      
      
      UPDATE #TmpInterfaceQRDealerTransaction
			   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E012</ErrorCode><ErrorDesc>��д��UPN�����Ų�ƥ��</ErrorDesc>'				
		   WHERE IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL
        AND NOT EXISTS (SELECT 1 FROM V_LotMaster VLM where VLM.LTM_QrCode = IDT_QRCode) 
        AND IDT_UPN IS NOT NULL AND IDT_UPN<>'' AND IDT_Lot IS NOT NULL AND IDT_LOT<>''
        AND NOT EXISTS (SELECT 1 FROM V_LotMaster VLM, Product P where VLM.LTM_Product_PMA_ID = P.PMA_ID and VLM.LTM_LotNumber = IDT_Lot and IDT_UPN = P.PMA_UPN )  
      */
      
      /* ��Ҫ�����ˣ�����Ѵ��ڣ���ϵͳ�Զ�ɾ��
 	  UPDATE #TmpInterfaceQRDealerTransaction
	  		   SET IDT_ErrorMsg = N'<RowNo>'+ Convert(nvarchar(10),IDT_RowNo) +'</RowNo><ErrorCode>E013</ErrorCode><ErrorDesc>���ύ���˶�ά��</ErrorDesc>'				
	  	   WHERE IDT_BatchNbr = @BatchNbr
        AND  IDT_ErrorMsg IS NULL       
        AND  EXISTS (SELECT 1 FROM interface.T_I_WC_DealerBarcodeQRcodeScan AS WC WHERE WC.QRC_DMA_ID = IDT_DMA_ID and WC.QRC_QRCode = IDT_QRCode and WC.QRC_Status='New' )  
      */
	     
      DECLARE @cnt int;
	    select @cnt = COUNT(*) from #TmpInterfaceQRDealerTransaction where IDT_ErrorMsg IS NOT NULL AND IDT_BatchNbr = @BatchNbr

	    IF(@cnt = 0)
			BEGIN
			/* ����Ѿ����ڵ�,�����Ϊɾ��*/
			UPDATE interface.T_I_WC_DealerBarcodeQRcodeScan SET QRC_Status='Delete'
			where EXISTS (SELECT 1 FROM #TmpInterfaceQRDealerTransaction WHERE QRC_DMA_ID = IDT_DMA_ID and QRC_QRCode = IDT_QRCode) 
			  and QRC_Status='New'
			
			/* ����ȷ������д����ʽ�� */
			--����
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


