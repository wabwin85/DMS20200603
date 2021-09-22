DROP proc [dbo].[GC_DealerInventoryInit]
GO






CREATE proc [dbo].[GC_DealerInventoryInit]
   (@UserId uniqueidentifier,
    @IsImport int,
    @IsValid NVARCHAR(20) = 'Success' OUTPUT)
 AS
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

/*�Ƚ������־��Ϊ0*/
Update DealerInventoryInit set DII_WHM_ID=null,DII_ErrorFlag=0,
DII_PMA_ID=null,DII_LTM_ID=null
where DII_USER=@UserId

--����Ʒ�Ƿ����
Update DealerInventoryInit 
set DII_PMA_ID=Product.PMA_ID
from CFN
join Product on Product.PMA_CFN_ID=CFN.CFN_ID
where CFN.CFN_CustomerFaceNbr=DII_ArticleNumber  and DII_USER=@UserId
and DII_ArticleNumber_ErrMsg is null

Update DealerInventoryInit set  DII_ArticleNumber_ErrMsg='��Ʒ������'
where DII_ArticleNumber_ErrMsg is null and DII_USER=@UserId and 
DII_PMA_ID is null

--���ֿ��Ƿ����
Update DealerInventoryInit set DII_WHM_ID=WHM_ID
from Warehouse
where Warehouse.WHM_Name=DealerInventoryInit.DII_Warehouse and DII_Warehouse_ErrMsg is null and DII_USER=@UserId
and WHM_DMA_ID=DII_DMA_ID

Update DealerInventoryInit set DII_Warehouse_ErrMsg='�ֿⲻ����'
where DII_WHM_ID is null and DII_Warehouse_ErrMsg is null and DII_USER=@UserId

--��������Ƿ����
Update DealerInventoryInit set DII_LTM_ID=LTM_ID
from LotMaster
where DII_USER=@UserId and CASE WHEN charindex('@@',LTM_LotNumber) > 0 
                                THEN substring(LTM_LotNumber,1,charindex('@@',LTM_LotNumber)-1) 
                                ELSE LTM_LotNumber
                                END = CASE WHEN charindex('@@',DII_LotNumber) > 0 
                                THEN substring(DII_LotNumber,1,charindex('@@',DII_LotNumber)-1) 
                                ELSE DII_LotNumber
                                END  and DII_LotNumber_ErrMsg is null
and DII_PMA_ID=LotMaster.LTM_Product_PMA_ID


Update DealerInventoryInit set DII_LotNumber_ErrMsg='���Ų�����'
 where DII_LotNumber_ErrMsg is null and DII_USER=@UserId and  DII_LTM_ID is null
 
update DealerInventoryInit set DII_Qty_ErrMsg='��������С��0'
where DII_Qty_ErrMsg is null and DII_USER=@UserId and ISNULL(Convert(decimal(18,6),DII_Qty),0)<=0


--Added By Song Yuqi On 2015-06-11
--�ж�С��λ
UPDATE DealerInventoryInit SET DII_Qty_ErrMsg='��С��λ��'+CONVERT(NVARCHAR(10),1/(PMA_ConvertFactor)) FROM Product 
WHERE PMA_ID = DII_PMA_ID AND DII_Qty_ErrMsg IS NULL AND DII_USER=@UserId AND 
(CONVERT(decimal(18,6),DII_Qty)*1000000)%((CONVERT(decimal(18,6),1)/CONVERT(decimal(18,6),PMA_ConvertFactor))*1000000) != 0


--������ڼ��Ƿ���ȷ
Update DealerInventoryInit set DII_Period_ErrMsg='����ڼ��д�'
where DII_Period_ErrMsg is null and DII_USER=@UserId
and (
ISNUMERIC(DII_Period)=0 or LEN (DII_Period)<>6
or (DII_Period not between CONVERT(nvarchar(6), DATEADD(MONTH,-1,GETDATE()),112)
and CONVERT(nvarchar(6),getdate(),112)) 
or DII_Period<dbo.fn_GetPeriod(getdate())
)


Update DealerInventoryInit Set DII_ErrorFlag=1
where DII_USER=@UserId
and (DII_Warehouse_ErrMsg is not null or DII_ArticleNumber_ErrMsg is not null or
DII_LotNumber_ErrMsg is not null or DII_Qty_ErrMsg is not null
 or DII_Period_ErrMsg is not null )





IF (SELECT COUNT(*) FROM DealerInventoryInit WHERE DII_ErrorFlag = 1 AND DII_USER = @UserId) > 0
	BEGIN
		/*������ڴ����򷵻�Error*/
		SET @IsValid = 'Error'
	END
ElSE IF (SELECT COUNT(*) FROM DealerInventoryInit WHERE DII_ErrorFlag = 1 AND DII_USER = @UserId)=0 and 
        @IsImport=0
BEGIN
	/*������ϴ����򷵻�Init*/
	SET @IsValid = 'Init'
END
ELSE
  BEGIN
  SET @IsValid = 'Success'
  
 -- Declare @InvPeriod nvarchar(6)
	--If (select DATEPART(day,getDate()))<=(select CDD_Date1 from CalendarDate
	--where CDD_Calendar=CONVERT(nvarchar(6),GetDate(),112))
	--Set @InvPeriod=CONVERT(nvarchar(6), DATEADD(MONTH,-1,GETDATE()),112)
	--else
	--Set @InvPeriod=CONVERT(nvarchar(6),GetDate(),112)
select MIN(Convert(nvarchar(200),DII_ID)) as DII_ID, DII_USER,getdate() DII_UploadDate,min(DII_LineNbr) as DII_LineNbr,DII_FileName, DII_ErrorFlag,
DII_ErrorDescription,DII_DealerSapCode,DII_Warehouse,DII_DMA_ID,DII_LotNumber,
DII_PMA_ID,DII_WHM_ID,DII_LTM_ID,SUM(Convert(decimal(16,5),DII_Qty)) as DII_Qty,DII_ArticleNumber,DII_DealerSapCode_ErrMsg,
DII_Warehouse_ErrMsg,DII_ArticleNumber_ErrMsg,DII_LotNumber_ErrMsg,DII_Qty_ErrMsg,DII_Period,DII_Period_ErrMsg
into #tmpDII
from DealerInventoryInit
where DII_USER=@UserId 
group by DII_USER,DII_FileName, DII_ErrorFlag,
DII_ErrorDescription,DII_DealerSapCode,DII_Warehouse,DII_DMA_ID,DII_LotNumber,
DII_PMA_ID,DII_WHM_ID,DII_LTM_ID,DII_ArticleNumber,DII_DealerSapCode_ErrMsg,
DII_Warehouse_ErrMsg,DII_ArticleNumber_ErrMsg,DII_LotNumber_ErrMsg,DII_Qty_ErrMsg,DII_Period,DII_Period_ErrMsg

Delete from DealerInventoryInit
where DII_USER=@UserId
Insert into DealerInventoryInit
select * from #tmpDII
	
	
  Delete did from DealerInventoryData did,DealerInventoryInit dii
  where DII_USER=did.DID_UploadUser and did.DID_DMA_ID=dii.DII_DMA_ID
  and did.DID_Period=dii.DII_Period
  
  Insert into DealerInventoryData 
      ([DID_ID]
      ,[DID_Period]
      ,[DID_DMA_ID]
      ,[DID_PMA_ID]
      ,[DID_WHM_ID]
      ,[DID_LTM_ID]
      ,[DID_Qty]
      ,[DID_UploadUser]
      ,[DID_UploadDate])
     select NEWID(),DII_Period,DII_DMA_ID,
            DII_PMA_ID,DII_WHM_ID,DII_LTM_ID,DII_Qty,DII_USER,GETDATE()
     from DealerInventoryInit
     where DII_USER=@UserId
  Delete from   DealerInventoryInit where   DII_USER=@UserId 
  
end

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


