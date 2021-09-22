DROP Procedure [dbo].[GC_LpComplain_AfterDownload]
GO


/*
根据批处理号批量更新ComplainInterface的状态（成功或失败）
PurchaseOrderLog中记录日志
*/
CREATE Procedure [dbo].[GC_LpComplain_AfterDownload]
    @RtnVal NVARCHAR(20) OUTPUT,
	@BatchNbr NVARCHAR(30),
	@ClientID NVARCHAR(50),
	@Success NVARCHAR(50)
AS
	DECLARE @DealerType NVARCHAR(30)
	DECLARE @DealerId uniqueidentifier
	DECLARE @SysUserId uniqueidentifier

SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	--根据ClientID得到DealerType
	SELECT @DealerId = DealerMaster.DMA_ID ,@DealerType = DealerMaster.DMA_DealerType FROM DealerMaster 
	INNER JOIN Client ON Client.CLT_Corp_Id = DealerMaster.DMA_ID
	WHERE Client.CLT_ID = @ClientID

	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	
	IF @Success = 'Success'
		BEGIN
			UPDATE ComplainInterface SET CI_Status = 'Success', CI_UpdateDate = GETDATE()
		    WHERE CI_BatchNbr = @BatchNbr			

			IF @DealerType = 'LP'
				BEGIN
					--AND IAH_DMA_ID = @DealerId
					--记录订单操作日志
					INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
					SELECT NEWID(),CI_POH_ID,@SysUserId,GETDATE(),'Download',NULL
					FROM ComplainInterface WHERE CI_BatchNbr = @BatchNbr
					
				END
		    ELSE IF @DealerType = 'T2'
		    	BEGIN
					--更新PurchaseOrderHeader的状态为已进入SAP(已生成接口)
					--UPDATE InventoryAdjustHeader SET IAH_Status = 'Uploaded'
					--WHERE IAH_ID IN (SELECT AI_IAH_ID FROM AdjustInterface WHERE AI_BatchNbr = @BatchNbr)
					
					--记录订单操作日志
					INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
					SELECT NEWID(),POH_ID,@SysUserId,GETDATE(),'Download',NULL
					FROM ComplainInterface 
					INNER JOIN PurchaseOrderHeader ON POH_ID = CI_POH_ID
					INNER JOIN DealerMaster ON POH_DMA_ID = DMA_ID
					WHERE CI_BatchNbr = @BatchNbr AND DMA_Parent_DMA_ID = @DealerId
		    	END	    		
		END
	ELSE
		BEGIN
			UPDATE ComplainInterface SET CI_Status = 'Failure', CI_UpdateDate = GETDATE()
		    WHERE CI_BatchNbr = @BatchNbr
		END		

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


