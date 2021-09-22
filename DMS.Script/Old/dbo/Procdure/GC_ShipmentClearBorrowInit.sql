DROP proc [dbo].[GC_ShipmentClearBorrowInit]
GO



Create proc [dbo].[GC_ShipmentClearBorrowInit]
 @RtnVal					NVARCHAR(20) OUTPUT,
 @RtnMsg NVARCHAR(4000) OUTPUT
 AS
 DECLARE @DealerType NVARCHAR(10)
 DECLARE @DMAID UNIQUEIDENTIFIER
 DECLARE @User UNIQUEIDENTIFIER
 DECLARE @IsValid NVARCHAR(50)
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
 SET @RtnVal = 'Success'
 SET @RtnMsg = ''
--��guid����ͨ���ô洢�������ɵ����۵�
SET @User='25681D2A-B567-45C1-9EFA-92C9CD7E26C2'
--ֱ��ҽԺ��������ʱ��
CREATE TABLE #DealerClearBorrow
(
 Dma_Id UNIQUEIDENTIFIER
)
--��Ų�Ʒ��Ϣ��ҽԺ�������̵���ʱ��
CREATE TABLE #ShipmentInit
(
    [SPI_ID] [uniqueidentifier] NOT NULL,
	[SPI_USER] [uniqueidentifier] NOT NULL,
	[SPI_UploadDate] [datetime] NOT NULL,
	[SPI_LineNbr] [int] NOT NULL,
	[SPI_FileName] [nvarchar](200),
	[SPI_ErrorFlag] [bit] NOT NULL,
	[SPI_ErrorDescription] [nvarchar](100) NULL,
	[SPI_SaleType] [nvarchar](20) NOT NULL,
	[SPI_HospitalCode] [nvarchar](50) NULL,
	[SPI_HospitalName] [nvarchar](200) NULL,
	[SPI_HospitalOffice] [nvarchar](200) NULL,
	[SPI_InvoiceNumber] [nvarchar](400) NULL,
	[SPI_InvoiceDate] [nvarchar](20) NULL,
	[SPI_InvoiceTitle] [nvarchar](200) NULL,
	[SPI_ShipmentDate] [nvarchar](20) NULL,
	[SPI_ArticleNumber] [nvarchar](200) NULL,
	[SPI_ChineseName] [nvarchar](200) NULL,
	[SPI_LotNumber] [nvarchar](20) NULL,
	[SPI_Price] [nvarchar](20) NULL,
	[SPI_ExpiredDate] [nvarchar](20) NULL,
	[SPI_UOM] [nvarchar](20) NULL,
	[SPI_Qty] [nvarchar](20) NULL,
	[SPI_Warehouse] [nvarchar](50) NULL,
	[SPI_DMA_ID] [uniqueidentifier] NULL,
	[SPI_HOS_ID] [uniqueidentifier] NULL,
	[SPI_CFN_ID] [uniqueidentifier] NULL,
	[SPI_PMA_ID] [uniqueidentifier] NULL,
	[SPI_BUM_ID] [uniqueidentifier] NULL,
	[SPI_WHM_ID] [uniqueidentifier] NULL,
	[SPI_LTM_ID] [uniqueidentifier] NULL,
	[SPI_HospitalCode_ErrMsg] [nvarchar](100) NULL,
	[SPI_ShipmentDate_ErrMsg] [nvarchar](100) NULL,
	[SPI_ArticleNumber_ErrMsg] [nvarchar](100) NULL,
	[SPI_LotNumber_ErrMsg] [nvarchar](100) NULL,
	[SPI_Qty_ErrMsg] [nvarchar](100) NULL,
	[SPI_Price_ErrMsg] [nvarchar](100) NULL,
	[SPI_Warehouse_ErrMsg] [nvarchar](100) NULL,
	[SPI_InvoiceDate_ErrMsg] [nvarchar](100) NULL,
	[SPI_HospitalName_ErrMsg] [nvarchar](100) NULL,
	[SPI_LotShipmentDate] [nvarchar](20) NULL,
	[SPI_Remark] [nvarchar](100) NULL,
	[SPI_LotShipmentDate_ErrMsg] [nvarchar](100) NULL,
	[SPI_Remark_ErrMsg] [nvarchar](100) NULL,
	[SPI_ConsignmentNbr] [nvarchar](200) NULL,
	[SPI_ConsignmentNbr_ErrMsg] [nvarchar](200) NULL,
	[SPI_CAH_ID] [uniqueidentifier] NULL,
	[SPI_QrCode_ErrMsg] [nvarchar](100) NULL,
	[SPI_QrCode] [nvarchar](20) NULL,
 )
 --��ֱ��ҽԺ�ľ�����д����ʱ��

 INSERT INTO #DealerClearBorrow(Dma_Id)
 SELECT DMA_ID FROM DealerMaster WHERE DMA_Taxpayer='ֱ��ҽԺ'

 --ֱ��ҽԺ���ֿ�Ĳ�Ʒд����ϸ��
  INSERT INTO #ShipmentInit(SPI_ID,SPI_USER,SPI_UploadDate,SPI_LineNbr,SPI_ErrorFlag,SPI_SaleType,SPI_HospitalCode,SPI_HospitalName,SPI_HospitalOffice,
 SPI_ShipmentDate,SPI_ArticleNumber,SPI_LotNumber,SPI_Price,SPI_ExpiredDate,SPI_UOM,SPI_Qty,SPI_Warehouse,SPI_DMA_ID,
 SPI_HOS_ID,SPI_CFN_ID,SPI_PMA_ID,SPI_BUM_ID,SPI_WHM_ID,SPI_LTM_ID,SPI_QrCode)
SELECT NEWID(),@User,GETDATE(),0,0,'T1',G.HOS_Key_Account,G.HOS_HospitalName,NULL,
 CONVERT(varchar(10), getdate(), 120 ),D.CFN_CustomerFaceNbr,
 CASE WHEN CHARINDEX('@@', F.LTM_LotNumber) > 0 THEN substring(F.LTM_LotNumber, 1, CHARINDEX('@@', F.LTM_LotNumber) - 1) 
                      ELSE F.LTM_LotNumber END AS LTM_LotNumber,
 ISNULL((SELECT top 1 ISNULL(DPH_UnitPrice,0)AS UnitPrice from DealerProductPriceHistory where DPH_DMA_ID=H.DMA_ID AND DPH_PMA_ID=B.PMA_ID),0),F.LTM_ExpiredDate,D.CFN_Property3,E.LOT_OnHandQty,C.WHM_Name,H.DMA_ID,G.HOS_ID,D.CFN_ID,B.PMA_ID,
 D.CFN_ProductLine_BUM_ID,C.WHM_ID,F.LTM_ID,
 CASE WHEN CHARINDEX('@@', F.LTM_LotNumber) > 0 THEN substring(F.LTM_LotNumber, CHARINDEX('@@', F.LTM_LotNumber) + 2, LEN(F.LTM_LotNumber) 
                      - CHARINDEX('@@', F.LTM_LotNumber)) ELSE 'NoQR' END AS LTM_QrCode
 FROM Inventory A INNER JOIN Product B ON A.INV_PMA_ID=B.PMA_ID
INNER JOIN Warehouse  C ON A.INV_WHM_ID=C.WHM_ID
INNER JOIN CFN D ON D.CFN_ID=B.PMA_CFN_ID INNER JOIN Lot E ON E.LOT_INV_ID=A.INV_ID
INNER JOIN LotMaster F ON F.LTM_ID=E.LOT_LTM_ID
INNER JOIN Hospital G ON C.WHM_Hospital_HOS_ID=G.HOS_ID 
INNER JOIN DealerMaster H ON H.DMA_ID=C.WHM_DMA_ID
where H.DMA_Taxpayer='ֱ��ҽԺ'
AND C.WHM_Type='DefaultWH' AND LOT_OnHandQty>0
AND  CASE WHEN CHARINDEX('@@', F.LTM_LotNumber) > 0 THEN substring(F.LTM_LotNumber, CHARINDEX('@@', F.LTM_LotNumber) + 2, LEN(F.LTM_LotNumber) 
                      - CHARINDEX('@@', F.LTM_LotNumber)) ELSE 'NoQR' END<>'NoQR'
                     
--ɾ����ǰ�ύ��
 DELETE ShipmentInit WHERE SPI_USER = @User
--�����α�,��ÿһ�������̵����ֿ�Ĳ�Ʒ�������۵�
DECLARE DealerCursor CURSOR FOR 
        SELECT Dma_Id FROM #DealerClearBorrow
OPEN DealerCursor
  FETCH NEXT FROM DealerCursor INTO @DMAID
	WHILE @@FETCH_STATUS = 0
	 BEGIN
	 --������ύ��
	   DELETE ShipmentInit WHERE SPI_USER = @User
	   
	   INSERT INTO ShipmentInit(SPI_ID,SPI_USER,SPI_UploadDate,SPI_LineNbr,SPI_ErrorFlag,SPI_SaleType,SPI_HospitalCode,SPI_HospitalName,SPI_HospitalOffice,
       SPI_ShipmentDate,SPI_ArticleNumber,SPI_LotNumber,SPI_Price,SPI_ExpiredDate,SPI_UOM,SPI_Qty,SPI_Warehouse,SPI_DMA_ID,
       SPI_HOS_ID,SPI_CFN_ID,SPI_PMA_ID,SPI_BUM_ID,SPI_WHM_ID,SPI_LTM_ID,SPI_QrCode,SPI_FileName)
       SELECT NEWID(),SPI_USER,SPI_UploadDate,SPI_LineNbr,SPI_ErrorFlag,SPI_SaleType,SPI_HospitalCode,SPI_HospitalName,SPI_HospitalOffice,
       SPI_ShipmentDate,SPI_ArticleNumber,SPI_LotNumber,SPI_Price,SPI_ExpiredDate,SPI_UOM,SPI_Qty,SPI_Warehouse,SPI_DMA_ID,
       SPI_HOS_ID,SPI_CFN_ID,SPI_PMA_ID,SPI_BUM_ID,SPI_WHM_ID,SPI_LTM_ID,SPI_QrCode,''
       FROM #ShipmentInit WHERE SPI_DMA_ID=@DMAID
       --����SPI_SaleType
       Update ShipmentInit set SPI_SaleType=
             (case when WHM_Type='DefaultWH' or WHM_Type='Normal' then '1'
              when WHM_Type='Consignment' or WHM_Type='LP_Consignment' then '2'
              when WHM_Type='Borrow' or  WHM_Type='LP_Borrow' then '3' else ''  end)
              from Warehouse
             where  Warehouse.WHM_Name=ShipmentInit.SPI_Warehouse and SPI_Warehouse_ErrMsg is null
            and SPI_USER=@User
            and Warehouse.WHM_DMA_ID=SPI_DMA_ID
       --�������۵�����洢����У��,���ڸ�Ϊ����У�顣
       --EXEC [GC_ShipmentInit] @User,3, @IsValid OUTPUT
   
       --IF(@IsValid='Success' OR @IsValid='Error')
       --BEGIN
         --���У����ɣ����ݵ��п����в�����Ҫ��Ĳ�Ʒ��ɾ��������Ҫ��Ĳ�Ʒ
          --DELETE ShipmentInit WHERE SPI_ErrorFlag=1 AND SPI_USER = @User

         --�����������۵��Ĵ洢���̣����м��������������۵����ô洢���̻���ݲ�ͬ��Ʒ�����ɲ�ͬ���۵���
        
         IF((SELECT COUNT(*) FROM ShipmentInit WHERE SPI_USER = @User)>0)
         BEGIN
         --�����ֱ��ҽԺ�����ֿ��Ʒ���������۵�
          EXEC [GC_Interface_Sales] NULL,NULL,@User, @IsValid OUTPUT,@RtnMsg OUTPUT
         END
      
        
       --END
       
        FETCH NEXT FROM DealerCursor INTO @DMAID
	 END
    CLOSE DealerCursor
    DEALLOCATE DealerCursor
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
   SET @RtnVal = 'Failure'
    
    --��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '2��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	
	return -1
END CATCH



GO


