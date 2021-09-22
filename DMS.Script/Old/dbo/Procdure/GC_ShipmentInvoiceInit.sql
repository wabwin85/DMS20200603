DROP PROCEDURE [dbo].[GC_ShipmentInvoiceInit]
GO


--Create By Song Yuqi For 销售发票号批量导入
CREATE PROCEDURE [dbo].[GC_ShipmentInvoiceInit]
	(
		@UserId uniqueidentifier,
		@IsImport int,
		@RtnVal NVARCHAR(20) OUTPUT,
		@RtnMsg NVARCHAR(2000) OUTPUT
	)
AS

SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

SET @RtnVal = 'Success'
SET @RtnMsg = ''

/*先将错误标志设为0*/
UPDATE ShipmentInvoiceInit SET SII_IsError = 0,SII_Error_Msg = NULL,SII_SPH_ID = NULL
WHERE SII_ImportUser = @UserId 

--判断销售单是否存在
UPDATE ShipmentInvoiceInit SET SII_SPH_ID = SPH_ID
FROM ShipmentHeader
WHERE SPH_ShipmentNbr = SII_ShipmentNbr
AND SPH_Dealer_DMA_ID = SII_DMA_ID
AND SPH_Status != 'Reversed'
AND SII_ImportUser = @UserId

UPDATE ShipmentInvoiceInit SET SII_IsError = 1, SII_Error_Msg = '销售单号不存在'
WHERE SII_SPH_ID IS NULL
AND SII_ImportUser = @UserId

IF (SELECT COUNT(*) FROM ShipmentInvoiceInit WHERE SII_IsError = 1 AND SII_ImportUser = @UserId) > 0
	BEGIN
		/*如果存在错误，则返回Error*/
		SET @RtnVal = 'Error'
	END
ELSE
	BEGIN
		IF @IsImport = 1
			BEGIN
				
				SELECT SII_SPH_ID AS SphId,SII_DMA_ID AS DmaId,CAST('' AS NVARCHAR(1000)) AS InvoiceNos INTO #TEMP
				FROM ShipmentInvoiceInit A
				WHERE SII_ImportUser = @UserId
				GROUP BY SII_SPH_ID,SII_DMA_ID
				
				UPDATE #TEMP SET InvoiceNos = STUFF((SELECT DISTINCT ';'+ISNULL(T.SII_InvoiceNo,'') 
                                                         FROM ShipmentInvoiceInit AS T
                                                      WHERE T.SII_ImportUser = @UserId
														AND T.SII_SPH_ID = #TEMP.SphId
                                                        AND T.SII_DMA_ID = #TEMP.DmaId
                                                          FOR XML PATH('')), 1, 1, '') 
				
				UPDATE ShipmentHeader SET SPH_InvoiceNo = InvoiceNos FROM #TEMP WHERE SphId = SPH_ID

			END

		SET @RtnVal = 'Success'
 
	END

COMMIT TRAN

SET NOCOUNT OFF
RETURN 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
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



--若发票日期未填写则根据销售出库日期获取产品单价





GO


