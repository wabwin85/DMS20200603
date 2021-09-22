DROP FUNCTION [dbo].[Func_GetSampleTrace]
GO

CREATE FUNCTION [dbo].[Func_GetSampleTrace]
(
	@SampleId UNIQUEIDENTIFIER
)
RETURNS @Rtn TABLE
        (
            UpnNo NVARCHAR(100),
            Lot NVARCHAR(100),
            ProductName NVARCHAR(500),
            ProductDesc NVARCHAR(500),
            DeliveryQuantity INT,
            ReciveQuantity INT,
            EvalQuantity INT,
            ReturnQuantity INT,
            RemainQuantity INT
        )
AS
BEGIN
	DECLARE @SampleNo NVARCHAR(100);
	
	SELECT @SampleNo = ApplyNo
	FROM   SampleApplyHead
	WHERE  SampleApplyHeadId = @SampleId;
	
	INSERT INTO @Rtn
	  (UpnNo, Lot, ProductName, ProductDesc, DeliveryQuantity,ReciveQuantity)
	SELECT D.PMA_UPN UpnNo,
	       C.PRL_LotNumber Lot,
	       F.ProductName,
	       F.ProductDesc,
	       SUM(C.PRL_ReceiptQty) DeliveryQuantity,
	       CASE WHEN E.SampleType='商业样品' or A.PRH_Status='Complete' then SUM(C.PRL_ReceiptQty) else 0 end AS ReciveQuantity
	FROM   POReceiptHeader_SAPNoQR A,
	       POReceipt_SAPNoQR B,
	       POReceiptLot_SAPNoQR C,
	       Product D,
	       SampleApplyHead E,
	       SampleUpn F
	WHERE  A.PRH_ID = B.POR_PRH_ID
	       AND B.POR_ID = C.PRL_POR_ID
	       AND B.POR_SAP_PMA_ID = D.PMA_ID
	       AND A.PRH_PurchaseOrderNbr = E.ApplyNo
	       AND E.SampleApplyHeadId = F.SampleHeadId
	       AND D.PMA_UPN = F.UpnNo
	       AND A.PRH_PurchaseOrderNbr = @SampleNo
	GROUP BY D.PMA_UPN, C.PRL_LotNumber, F.ProductName, F.ProductDesc,E.SampleType,A.PRH_Status
	
	UPDATE A
	SET    A.EvalQuantity = (
	           SELECT COUNT(*)
	           FROM   SampleEval B
	           WHERE  A.UpnNo = B.UpnNo
	                  AND A.Lot = B.Lot
	                  AND B.SampleHeadId = @SampleId
	       ),
	       A.ReturnQuantity = (
	           SELECT ISNULL(SUM(B.ApplyQuantity), 0)
	           FROM   SampleUpn B,
	                  SampleReturnHead C
	           WHERE  A.UpnNo = B.UpnNo
	                  AND A.Lot = B.Lot
	                  AND C.ApplyNo = @SampleNo
	                  AND B.SampleHeadId = C.SampleReturnHeadId
	                  AND C.ReturnStatus <> 'Deny'
	       )
	FROM   @Rtn A
	
	UPDATE @Rtn
	SET    EvalQuantity = ISNULL(EvalQuantity, 0),
	       ReturnQuantity = ISNULL(ReturnQuantity, 0)
	
	UPDATE @Rtn
	SET    RemainQuantity = DeliveryQuantity - EvalQuantity - ReturnQuantity
	
	
	
	RETURN
END
GO


