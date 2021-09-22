DROP Procedure [dbo].[GC_Task_ExpirationRemind]
GO


/*
过期产品提醒
*/
CREATE Procedure [dbo].[GC_Task_ExpirationRemind]
	@RemindMonth int,
	@RemindDay int,
    @RtnVal NVARCHAR(20) OUTPUT
AS

SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	
	INSERT INTO MailMessageProcess (MMP_ID,MMP_Code,MMP_ProcessId,MMP_Status,MMP_CreateDate)
	SELECT NEWID(),'EMAIL_EXPIRATION_REMIND',T.HeaderId,'Waiting',GETDATE()
	FROM (select distinct W.WHM_DMA_ID AS HeaderId
	from Inventory I
	inner join Lot L on L.LOT_INV_ID = I.INV_ID
	inner join LotMaster LM on L.LOT_LTM_ID = LM.LTM_ID
	inner join Warehouse W on I.INV_WHM_ID = W.WHM_ID
	where L.LOT_OnHandQty <> 0 and LM.LTM_ExpiredDate is not null
	and convert(varchar(10),dateadd(d,0-@RemindDay,dateadd(m,0-@RemindMonth,LM.LTM_ExpiredDate)),112) <= convert(varchar(10),getdate(),112)) AS T


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


