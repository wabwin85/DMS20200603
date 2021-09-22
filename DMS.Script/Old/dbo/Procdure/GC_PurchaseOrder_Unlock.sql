DROP Procedure [dbo].[GC_PurchaseOrder_Unlock]
GO


/*
订单批量解锁
*/
CREATE Procedure [dbo].[GC_PurchaseOrder_Unlock]
	@UserId uniqueidentifier,
	@ListString NVARCHAR(1000),
    @RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(1000) OUTPUT
AS
    DECLARE @ErrorCount INTEGER
	DECLARE @PohId uniqueidentifier
	DECLARE @OrderNo NVARCHAR(30)
	DECLARE @OrderStatus NVARCHAR(20)
	DECLARE @IsLocked BIT
	/*将传递进来的@ListString字符串转换成纵表*/
	DECLARE ListCursor CURSOR FOR 
		SELECT P.POH_ID, P.POH_OrderNo, P.POH_OrderStatus, P.POH_IsLocked
		FROM dbo.GC_Fn_SplitStringToTable(@ListString,',') A
		INNER JOIN PurchaseOrderHeader P ON P.POH_ID = A.VAL

SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	OPEN ListCursor
	FETCH NEXT FROM ListCursor INTO @PohId,@OrderNo,@OrderStatus,@IsLocked
	WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @OrderStatus IN ('Submitted','Approved')
				BEGIN
					IF @IsLocked = 1
						BEGIN						
							UPDATE PurchaseOrderHeader SET POH_IsLocked = 0 WHERE POH_ID = @PohId
							--记录订单操作日志
							INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
							VALUES (NEWID(),@PohId,@UserId,GETDATE(),'Unlock',NULL)
						END
				END
			ELSE
				SET @RtnMsg = @RtnMsg + '订单[' + @OrderNo + ']无法解锁<BR/>'
			FETCH NEXT FROM ListCursor INTO @PohId,@OrderNo,@OrderStatus,@IsLocked
		END
	CLOSE ListCursor
	DEALLOCATE ListCursor
	
	IF LEN(@RtnMsg) > 0
		SET @RtnVal = 'Error'

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    return -1
    
END CATCH




GO


