DROP Procedure [dbo].[GC_UpdateDealerName]
GO


create Procedure [dbo].[GC_UpdateDealerName](   
 @DealerType NVARCHAR(100),
 @NewDealerName NVARCHAR(100),
 @SapCode NVARCHAR(100),
 @NewDealerEnglishName NVARCHAR(100),
 @DealerID uniqueidentifier,
 @UserId uniqueidentifier,
 @IsValid NVARCHAR(20) = 'Success' OUTPUT
)
as 
begin
BEGIN TRY
begin tran
declare @DealerName nvarchar(50);
declare @EnglishDealerName nvarchar(50);
declare @row1 nvarchar(50);
declare @row2 nvarchar(50);

select @DealerName= d.DMA_ChineseName from DealerMaster d where d.DMA_ID=@DealerID
select @EnglishDealerName=d.DMA_EnglishName from DealerMaster d where d.DMA_ID=@DealerID
 
  
update Warehouse set WHM_Name=replace(WHM_Name,@DealerName,@NewDealerName)
 where WHM_DMA_ID=@DealerID 

 
if(@DealerType='T1')
 begin 
 update DealerMaster set DMA_ChineseName=@NewDealerName ,DMA_ChineseShortName=@NewDealerName+' - '+@SapCode,
 DMA_EnglishName=@NewDealerEnglishName where DMA_ID=@DealerID
 end
 else
 begin
 update DealerMaster set DMA_ChineseName=@NewDealerName ,DMA_ChineseShortName=@NewDealerName+' - '+@SapCode
 where DMA_ID=@DealerID
 end                                                                                                                  



select @row1= COUNT(*) from  DealerMaster d where d.DMA_ChineseName like'%'+@NewDealerName+'%'and d.DMA_ID=@DealerID

select @row2= COUNT(*) from  Warehouse w where w.WHM_Name like'%'+@NewDealerName+'%' and w.WHM_DMA_ID=@DealerID
   
   if(@row1>0 and @row2>0)
   begin 
		SET @IsValid = 'Success'
		
	END
ELSE
	BEGIN
		 
		SET @IsValid = 'Error'
		
   end
 
 if(@IsValid = 'Success' and @DealerType='T1')
    begin
     insert  INTO UserLog(UserId,Category,EventId,EventTime,EventMessage)
     select l.IDENTITY_CODE,'Users','经销商更名',GETDATE() ,'经销商'+@DealerName+'已更名为'+@NewDealerName+'，英文名'+@EnglishDealerName+'变更为'+@NewDealerEnglishName 
     from Lafite_IDENTITY  l where l.Id=@UserId
	end
  if(@IsValid = 'Success' and @DealerType='T2')
  begin
    insert  INTO UserLog(UserId,Category,EventId,EventTime,EventMessage)
     select l.IDENTITY_CODE,'Users','经销商更名',GETDATE() ,'经销商'+@DealerName+'已更名为'+@NewDealerName
     from Lafite_IDENTITY  l where l.Id=@UserId
  end 
    
  COMMIT TRAN

SET NOCOUNT OFF


END TRY

BEGIN CATCH 

 SET NOCOUNT OFF
    ROLLBACK TRAN
   
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @IsValid = @vError
	
	
 
  
  
END CATCH



end







GO
