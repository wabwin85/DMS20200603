DROP procedure [dbo].[GC_CheckAuthorizationParts]
GO

CREATE procedure [dbo].[GC_CheckAuthorizationParts]
(
 @CatagoryID uniqueidentifier,
 @DealerID uniqueidentifier, 
 @Flag bit OUTPUT
)
as BEGIN

declare @partID uniqueidentifier
DECLARE @ReturnValue   int
SET @FLAG = 0 
SET @ReturnValue = 0


--IF (@CatagoryID IS NULL ) OR (@DealerID IS NULL )
--BEGIN
--	SET @FLAG = -1 
--	SET @ReturnValue = -1
--	GOTO Cleanup
--END

-------- ��ǰѡ����ǲ�Ʒ�߻���ࣺ����Ƿ��Ѵ��ڵ�ǰѡ���; 
--IF EXISTS(select * from dbo.DealerAuthorizationTable 
-- where DAT_PMA_ID =@CatagoryID AND DAT_DMA_ID = @DealerID) 
--BEGIN
--	SET @FLAG = 1 
--	SET @ReturnValue  =1
--	GOTO Cleanup
--End

-------- ��ǰѡ����ǲ�Ʒ�ߣ���鵱ǰѡ��Ĳ�Ʒ���Ƿ�����Ѵ��ڵķ���
--IF EXISTS(select * from dbo.DealerAuthorizationTable A, dbo.PartsClassification B
--where A.DAT_ProductLine_BUM_ID<>A.DAT_PMA_ID and A.DAT_PMA_ID = B.PCT_ID AND A.DAT_DMA_ID = @DealerID AND  b.PCT_ProductLine_BUM_ID =@CatagoryID ) 
--BEGIN
--	SET @FLAG = 1 
--	SET @ReturnValue  =2
--	GOTO Cleanup
--End;

---------��ǰѡ����Ƿ��ࣺ ��鵱ǰѡ��ķ����Ƿ��Ѿ����ڵĲ�Ʒ�߰���
--IF EXISTS(select * from dbo.DealerAuthorizationTable A, dbo.PartsClassification B
--where A.DAT_PMA_ID =A.DAT_ProductLine_BUM_ID and DAT_DMA_ID= @DealerID  AND B.PCT_ID = @CatagoryID AND  b.PCT_ProductLine_BUM_ID =DAT_PMA_ID ) 
--BEGIN
--	SET @FLAG = 1 
--	SET @ReturnValue  =3
--	GOTO Cleanup
--End;

--------��ǰѡ����Ƿ��ࣺ  ��鵱ǰѡ��ķ����Ƿ�����Ѵ��ڵķ���
--WITH Parts1(ID, [NAME], ParentID,BUM_ID, [Level]) AS 
--(
--select PCT_ID ID, 
--PCT_NAME [NAME],
--PCT_ParentClassification_PCT_ID ParentID,
--PCT_ProductLine_BUM_ID BUM_ID , 0 [LEVEL]
--from dbo.PartsClassification 
--where EXISTS(select 1 from dbo.DealerAuthorizationTable b where  B.DAT_PMA_ID = PCT_ID AND b.DAT_DMA_ID = @DealerID and B.DAT_ProductLine_BUM_ID <>B.DAT_PMA_ID)
--UNION ALL
--select PCT_ID ID, 
--PCT_NAME [NAME],
--PCT_ParentClassification_PCT_ID ParentID,
--PCT_ProductLine_BUM_ID BUM_ID , Parts1.[LEVEL]-1 [LEVEL]
--from dbo.PartsClassification, Parts1 where PCT_ID= Parts1.ParentID
--)

--select @partID = ID from Parts1  where ID = @CatagoryID 
--if( @partID is not null)
--begin
--	SET @FLAG = 1 
--	SET @ReturnValue  =4
--	GOTO Cleanup
--end;

--------��ǰѡ����Ƿ��ࣺ  ��鵱ǰѡ��ķ����Ƿ��Ѵ��ڵķ������
--WITH Parts(ID, [NAME], ParentID,BUM_ID, [Level]) AS 
--(
--select PCT_ID ID, 
--PCT_NAME [NAME],
--PCT_ParentClassification_PCT_ID ParentID,
--PCT_ProductLine_BUM_ID BUM_ID , 0 [LEVEL]
--from dbo.PartsClassification 
--where EXISTS(select 1 from dbo.DealerAuthorizationTable b where  B.DAT_PMA_ID = PCT_ID AND b.DAT_DMA_ID = @DealerID and B.DAT_ProductLine_BUM_ID <>B.DAT_PMA_ID)
--UNION ALL
--select PCT_ID ID, 
--PCT_NAME [NAME],
--PCT_ParentClassification_PCT_ID ParentID,
--PCT_ProductLine_BUM_ID BUM_ID , Parts.[LEVEL]+1 [LEVEL]
--from dbo.PartsClassification, Parts where PCT_ParentClassification_PCT_ID= Parts.ID
--)

--select @partID = ID from Parts  where ID = @CatagoryID 

--if (@partID is not null )
--begin
--	SET @FLAG = 1 
--	SET @ReturnValue  =5
--	GOTO Cleanup
--end;

return 0

Cleanup:

    RETURN @ReturnValue

end;



GO


