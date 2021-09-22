DROP PROCEDURE [dbo].[GC_ShipmentInvoiceInit]
GO


--Create By Song Yuqi For ���۷�Ʊ����������
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

/*�Ƚ������־��Ϊ0*/
UPDATE ShipmentInvoiceInit SET SII_IsError = 0,SII_Error_Msg = NULL,SII_SPH_ID = NULL
WHERE SII_ImportUser = @UserId 

--�ж����۵��Ƿ����
UPDATE ShipmentInvoiceInit SET SII_SPH_ID = SPH_ID
FROM ShipmentHeader
WHERE SPH_ShipmentNbr = SII_ShipmentNbr
AND SPH_Dealer_DMA_ID = SII_DMA_ID
AND SPH_Status != 'Reversed'
AND SII_ImportUser = @UserId

UPDATE ShipmentInvoiceInit SET SII_IsError = 1, SII_Error_Msg = '���۵��Ų�����'
WHERE SII_SPH_ID IS NULL
AND SII_ImportUser = @UserId

IF (SELECT COUNT(*) FROM ShipmentInvoiceInit WHERE SII_IsError = 1 AND SII_ImportUser = @UserId) > 0
	BEGIN
		/*������ڴ����򷵻�Error*/
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

	--��¼������־��ʼ
	DECLARE @error_line   INT
	DECLARE @error_number   INT
	DECLARE @error_message   NVARCHAR (256)
	DECLARE @vError   NVARCHAR (1000)
	SET @error_line = ERROR_LINE ()
	SET @error_number = ERROR_NUMBER ()
	SET @error_message = ERROR_MESSAGE ()
	SET @vError =
			'��'
			+ CONVERT (NVARCHAR (10), @error_line)
			+ '����[�����'
			+ CONVERT (NVARCHAR (10), @error_number)
			+ '],'
			+ @error_message
	SET @RtnMsg = @vError
	RETURN -1

END CATCH



--����Ʊ����δ��д��������۳������ڻ�ȡ��Ʒ����





GO


