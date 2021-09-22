
DROP FUNCTION [dbo].[Func_IsSampleComplete]
GO


CREATE FUNCTION [dbo].[Func_IsSampleComplete]
(
	@SampleId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
	DECLARE @SampleNo NVARCHAR(100);
	DECLARE @Rtn INT;
	
	SELECT @SampleNo = ApplyNo
	FROM   SampleApplyHead
	WHERE  SampleApplyHeadId = @SampleId;
	
	DECLARE @Tmp TABLE
	        (
	            UpnNo NVARCHAR(100),
	            Lot NVARCHAR(100),
	            ProductName NVARCHAR(500),
	            ProductDesc NVARCHAR(500),
	            DeliveryQuantity INT,
	            EvalQuantity INT,
	            ReturnQuantity INT,
	            RemainQuantity INT
	        )
	
	INSERT INTO @Tmp
	  (UpnNo, Lot, ProductName, ProductDesc, DeliveryQuantity)
	SELECT D.PMA_UPN UpnNo,
	       C.PRL_LotNumber Lot,
	       F.ProductName,
	       F.ProductDesc,
	       SUM(C.PRL_ReceiptQty) DeliveryQuantity
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
	GROUP BY D.PMA_UPN, C.PRL_LotNumber, F.ProductName, F.ProductDesc
	
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
	                  AND C.ReturnStatus = 'Approved'
	       )
	FROM   @Tmp A
	
	UPDATE @Tmp
	SET    EvalQuantity = ISNULL(EvalQuantity, 0),
	       ReturnQuantity = ISNULL(ReturnQuantity, 0)
	
	UPDATE @Tmp
	SET    RemainQuantity = DeliveryQuantity - EvalQuantity - ReturnQuantity
	
	IF NOT EXISTS (SELECT 1 FROM @Tmp)
	BEGIN
		SET @Rtn = 0;
	END
	ELSE IF EXISTS (
	       SELECT 1
	       FROM   @Tmp
	       WHERE  RemainQuantity > 0
	   )
	BEGIN
	    SET @Rtn = 0;
	END
	ELSE
	BEGIN
	    SET @Rtn = 1;
	END
	
	RETURN @Rtn;
END

GO


