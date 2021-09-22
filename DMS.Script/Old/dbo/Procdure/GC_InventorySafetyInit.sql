DROP proc [dbo].[GC_InventorySafetyInit]
GO











CREATE proc [dbo].[GC_InventorySafetyInit]
   (@UserId uniqueidentifier,
    @DealerId uniqueidentifier,
    @IsValid NVARCHAR(20) = 'Success' OUTPUT)
AS
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

--检查经销商是否存在
Update InventorySafetyInit set ISI_DMA_ID=DMA_ID,ISI_DealerName=DMA_ChineseName
from DealerMaster
where DMA_SAP_Code=ISI_DealerSapCode and ISI_USER=@UserId

update InventorySafetyInit set ISI_ErrorFlag=1, ISI_ErrorDescription=ISI_ErrorDescription+'经销商编号不存在,'
where ISI_DMA_ID is null and ISI_USER=@UserId
      
select DMA_ID into #DMAID from DealerMaster
where (DMA_ID = @DealerId or DMA_Parent_DMA_ID = @DealerId)
      
  update InventorySafetyInit set ISI_ErrorFlag=1, 
         ISI_ErrorDescription=ISI_ErrorDescription+'经销商未授权,'
   where  ISI_USER=@UserId
   and ISI_DMA_ID not in (select DMA_ID from #DMAID)
   
  
 --檢查倉庫是否存在
Update InventorySafetyInit set ISI_WHM_ID=WHM_ID
from Warehouse
where WHM_Name=ISI_Warehouse and ISI_ErrorFlag=0 and ISI_USER=@UserId and WHM_DMA_ID=ISI_DMA_ID

Update InventorySafetyInit set ISI_ErrorFlag=1, ISI_ErrorDescription=ISI_ErrorDescription+'仓库名称不存在,'
where  ISI_WHM_ID is null and ISI_USER=@UserId 

--检查产品是否存在
UPDATE InventorySafetyInit SET ISI_CFN_ID = CFN_ID
FROM CFN WHERE CFN_CustomerFaceNbr = ISI_ArticleNumber
AND ISI_ErrorFlag = 0 AND ISI_USER = @UserId
UPDATE InventorySafetyInit SET ISI_ErrorFlag = 1, ISI_ErrorDescription = ISI_ErrorDescription + '产品不存在,'
WHERE ISI_CFN_ID IS NULL AND ISI_USER = @UserId




select ISI_DMA_ID as DMA_ID,ISI_WHM_ID as WHM_ID,ISI_CFN_ID as CFN_ID
 into #ReData from InventorySafetyInit 
 where ISI_USER=@UserId
group by ISI_DMA_ID,ISI_WHM_ID,ISI_CFN_ID having COUNT(ISI_DMA_ID)>1

update InventorySafetyInit set ISI_ErrorFlag=1, ISI_ErrorDescription=ISI_ErrorDescription+'经销商，产品，仓库重复.'
from #ReData
where ISI_USER=@UserId and #ReData.DMA_ID=ISI_DMA_ID
and ISI_CFN_ID=#ReData.CFN_ID and ISI_WHM_ID=#ReData.WHM_ID

  drop table #DMAID
  drop table #ReData

--检查是否存在错误
IF (SELECT COUNT(*) FROM InventorySafetyInit WHERE ISI_ErrorFlag = 1 AND ISI_USER = @UserId) > 0
	BEGIN
		/*如果存在错误，则返回Error*/
		SET @IsValid = 'Error'
	END
ELSE
  BEGIN
  SET @IsValid = 'Success'
   
   delete a from InventorySafety a, InventorySafetyInit b
   where a.IS_CFN_ID=b.ISI_CFN_ID and a.IS_Dealer_DMA_ID=b.ISI_DMA_ID
   and a.IS_WHM_ID=b.ISI_WHM_ID and b.ISI_USER=@UserId
  
  Insert into InventorySafety ([IS_ID],[IS_Dealer_DMA_ID],[IS_CFN_ID],[IS_Qty],[IS_WHM_ID])
  select NEWID(),ISI_DMA_ID,ISI_CFN_ID,ISI_Qty,ISI_WHM_ID 
  from InventorySafetyInit where ISI_USER=@UserId 
  
  delete from InventorySafetyInit where ISI_USER=@UserId

  END
	
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @IsValid = 'Failure'
    return -1
    
END CATCH











GO


