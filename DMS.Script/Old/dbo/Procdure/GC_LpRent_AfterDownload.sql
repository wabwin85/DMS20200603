DROP Procedure [dbo].[GC_LpRent_AfterDownload]
GO


/*
�������������������LpRentInterface��״̬���ɹ���ʧ�ܣ�
PurchaseOrderLog�м�¼��־
*/
CREATE Procedure [dbo].[GC_LpRent_AfterDownload]
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
	
  --����ClientID�õ�DealerType
	SELECT @DealerId = DealerMaster.DMA_ID ,@DealerType = DealerMaster.DMA_DealerType 
  FROM DealerMaster 
	INNER JOIN Client ON Client.CLT_Corp_Id = DealerMaster.DMA_ID
	WHERE Client.CLT_ID = @ClientID

	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	
	IF @Success = 'Success'
		BEGIN
			UPDATE LpRentInterface SET LRI_Status = 'Success', LRI_UpdateDate = GETDATE()
		    WHERE LRI_BatchNbr = @BatchNbr			



			IF @DealerType = 'LP'
				BEGIN
					
					--��¼����������־
					INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
					SELECT NEWID(),LRI_TranferID,@SysUserId,GETDATE(),'Download',NULL
					FROM LpRentInterface WHERE LRI_BatchNbr = @BatchNbr					
				END
		   
		END
	ELSE
		BEGIN
			UPDATE LpRentInterface SET LRI_Status = 'Failure', LRI_UpdateDate = GETDATE()
		    WHERE LRI_BatchNbr = @BatchNbr
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


