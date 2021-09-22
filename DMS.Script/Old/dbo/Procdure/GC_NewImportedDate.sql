DROP PROCEDURE [dbo].[GC_NewImportedDate]
GO


CREATE PROCEDURE [dbo].[GC_NewImportedDate]
AS

DECLARE @ImportFileName NVARCHAR(200)
DECLARE NewImportFileList CURSOR FOR 
SELECT DISTINCT DNL_ImportFileName 
FROM ProDeliveryNote
Where DNL_ProblemDescription IS NULL
ORDER BY DNL_ImportFileName

OPEN NewImportFileList
FETCH NEXT FROM NewImportFileList INTO @ImportFileName

WHILE @@FETCH_STATUS = 0
BEGIN

	UPDATE ProDeliveryNote SET DNL_ProblemDescription = 'New'
	FROM         DeliveryNote RIGHT OUTER JOIN
						  ProDeliveryNote ON DeliveryNote.DNL_SAPCode = ProDeliveryNote.DNL_SAPCode AND DeliveryNote.DNL_PONbr = ProDeliveryNote.DNL_PONbr AND 
						  DeliveryNote.DNL_DeliveryNoteNbr = ProDeliveryNote.DNL_DeliveryNoteNbr AND DeliveryNote.DNL_CFN = ProDeliveryNote.DNL_CFN AND 
						  DeliveryNote.DNL_UPN = ProDeliveryNote.DNL_UPN AND DeliveryNote.DNL_LotNumber = ProDeliveryNote.DNL_LotNumber AND 
						  DeliveryNote.DNL_ShipmentDate = ProDeliveryNote.DNL_ShipmentDate AND DeliveryNote.DNL_OrderType = ProDeliveryNote.DNL_OrderType AND 
						  DeliveryNote.DNL_ShipmentType = ProDeliveryNote.DNL_ShipmentType
	WHERE  (DeliveryNote.DNL_ID IS NULL)   
	 AND (ProDeliveryNote.DNL_ImportFileName = @ImportFileName)

INSERT INTO DeliveryNote (DNL_ID, DNL_LineNbrInFile, DNL_ShipToDealerCode, DNL_SAPCode, DNL_PONbr, DNL_DeliveryNoteNbr, DNL_CFN, DNL_UPN, DNL_LotNumber, DNL_ExpiredDate, 
                      DNL_DN_UnitOfMeasure, DNL_ReceiveUnitOfMeasure, DNL_ShipQty, DNL_ReceiveQty, DNL_ShipmentDate, DNL_ImportFileName, DNL_OrderType, DNL_UnitPrice, 
                      DNL_SubTotal, DNL_ShipmentType, DNL_CreatedDate)
SELECT     DNL_ID, DNL_LineNbrInFile, DNL_ShipToDealerCode, DNL_SAPCode, DNL_PONbr, DNL_DeliveryNoteNbr, DNL_CFN, DNL_UPN, DNL_LotNumber, DNL_ExpiredDate, 
                      DNL_DN_UnitOfMeasure, DNL_ReceiveUnitOfMeasure, DNL_ShipQty, DNL_ReceiveQty, DNL_ShipmentDate, DNL_ImportFileName, DNL_OrderType, DNL_UnitPrice, 
                      DNL_SubTotal, DNL_ShipmentType, DNL_CreatedDate
FROM         ProDeliveryNote
WHERE DNL_ProblemDescription = 'New'

UPDATE ProDeliveryNote SET DNL_ProblemDescription = 'Done' WHERE  DNL_ImportFileName = @ImportFileName

	FETCH NEXT FROM NewImportFileList INTO @ImportFileName

END

CLOSE NewImportFileList
DEALLOCATE NewImportFileList

GO


