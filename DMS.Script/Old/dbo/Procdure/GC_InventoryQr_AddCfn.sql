DROP PROCEDURE [dbo].[GC_InventoryQr_AddCfn]
GO

/*
库存上报——生成销售单
*/
CREATE PROCEDURE [dbo].[GC_InventoryQr_AddCfn]
   @UserId               UNIQUEIDENTIFIER,
   @DealerId             UNIQUEIDENTIFIER,
   @LotString            NVARCHAR (MAX),
   @InventoryType        NVARCHAR (20),
   @RtnVal               NVARCHAR (20) OUTPUT,
   @RtnMsg               NVARCHAR (1000) OUTPUT
AS
   DECLARE @ErrorCount   INTEGER
   DECLARE @CfnId		UNIQUEIDENTIFIER
   DECLARE @PmaId		UNIQUEIDENTIFIER
   DECLARE @LotId		UNIQUEIDENTIFIER
   DECLARE @QrId		UNIQUEIDENTIFIER
   DECLARE @Qty			DECIMAL(18,6)
   DECLARE @UPN			NVARCHAR(200)
   DECLARE @QrCode		NVARCHAR(200)
   DECLARE @LotNumber	NVARCHAR(200)
   
   /*将传递进来的CFNID字符串转换成纵表*/
   DECLARE LotCursor CURSOR FOR SELECT E.CFN_ID AS CfnId,
								  D.PMA_ID AS PmaId,
								  A.Col1 AS LotId,
								  A.Col2 AS QrId,
                                  A.Col3 AS Qty,
								  E.CFN_CustomerFaceNbr AS UPN,
								  C.LTM_QrCode AS QrCode,
								  C.LTM_LotNumber AS LotNumber
                             FROM dbo.GC_Fn_SplitStringToMultiColsTable (
                                     @LotString,
                                     ',',
                                     '@') A
								INNER JOIN Lot B ON B.LOT_ID = A.Col1
								INNER JOIN V_LotMaster C ON C.LTM_ID = B.LOT_LTM_ID
								INNER JOIN Product D ON D.PMA_ID = C.LTM_Product_PMA_ID
								INNER JOIN CFN E ON E.CFN_ID = D.PMA_CFN_ID
								
   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''

      OPEN LotCursor
      FETCH NEXT FROM LotCursor INTO @CfnId, @PmaId, @LotId, @QrId, @Qty, @UPN, @QrCode, @LotNumber

      WHILE @@FETCH_STATUS = 0
		BEGIN

            IF EXISTS (SELECT 1 FROM InventoryQROperation WHERE IO_CreateUser = @UserId AND IO_Lot_ID = @LotId AND IO_OperationType = @InventoryType)
			BEGIN
				UPDATE InventoryQROperation SET IO_Qty = IO_Qty + CONVERT(DECIMAL(18,6),ISNULL(@Qty,'0')) WHERE IO_CreateUser = @UserId AND IO_Lot_ID = @LotId AND IO_OperationType = @InventoryType

				--二维码库存数量最多是1
				UPDATE InventoryQROperation SET IO_Qty = 1 WHERE IO_CreateUser = @UserId AND IO_Lot_ID = @LotId AND IO_OperationType = @InventoryType AND IO_Qty > 1
			END
            ELSE
			BEGIN
				--新增产品，默认数量1
				INSERT INTO InventoryQROperation(IO_Id,
													IO_QRC_ID, 
													IO_DMA_Id,
													IO_CFN_ID,
													IO_PMA_ID,
													IO_UPN,
													IO_Lot_Id,
													IO_LotNumber,
													IO_BarCode,
													IO_Qty,
													IO_CreateUser,
													IO_CreateDate,
													IO_OperationType
													)
				VALUES (NEWID(),
						@QrId,
						@DealerId,
						@CfnId,
						@PmaId,
						@UPN,
						@LotId,
						@LotNumber,
						@QrCode,
						@Qty,
						@UserId,
						GETDATE(),
						@InventoryType
						)
				END
			 FETCH NEXT FROM LotCursor INTO @CfnId, @PmaId, @LotId, @QrId, @Qty, @UPN, @QrCode, @LotNumber
		  END

      CLOSE LotCursor
      DEALLOCATE LotCursor

      COMMIT TRAN

      SET  NOCOUNT OFF
      RETURN 1
   END TRY
   BEGIN CATCH
      SET  NOCOUNT OFF
      ROLLBACK TRAN
      SET @RtnVal = 'Failure'
	  --记录错误日志开始
      DECLARE @error_line   INT
      DECLARE @error_number   INT
      DECLARE @error_message   NVARCHAR (256)
      DECLARE @vError   NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError =
				 '行'
			   + CONVERT (NVARCHAR (10), @error_line)
			   + '出错[错误号'
			   + CONVERT (NVARCHAR (10), @error_number)
			   + '],'
			   + @error_message
		SET @RtnMsg = @vError
      RETURN -1
   END CATCH

GO


