DROP PROCEDURE [dbo].[GC_Interface_ConsignmentWarehouse]
GO

CREATE PROCEDURE [dbo].[GC_Interface_ConsignmentWarehouse]
   @BatchNbr NVARCHAR (30),
   @ClientID NVARCHAR (50),
   @IsValid NVARCHAR (20) OUTPUT,
   @RtnMsg NVARCHAR (4000) OUTPUT
AS
   DECLARE @ErrorCount    INTEGER
   DECLARE @SysUserId     UNIQUEIDENTIFIER
   DECLARE @DealerId uniqueidentifier
   SET  NOCOUNT ON

BEGIN TRY
      BEGIN TRAN
      SET @IsValid = 'Success'
      SET @RtnMsg = ''
      SET @SysUserId = '00000000-0000-0000-0000-000000000000'
      
      --����������
	 SELECT @DealerId = CLT_Corp_Id FROM Client(nolock) WHERE CLT_ID = @ClientID
	 
	 
	 --���¾�����ID��У�龭���̱���Ƿ���ȷ
	 Update InterfaceWarehouse
	 set IWH_DealerID = DMA_ID
	 from DealerMaster(nolock)
	 where IWH_DealerCode = DMA_SAP_Code 
	 and IWH_BatchNbr = @BatchNbr
	 
	 Update InterfaceWarehouse
	 Set IWH_ErrorMsg = 
	 (case when IWH_ErrorMsg is null then N'�����̱�Ų�����'
		else IWH_ErrorMsg + N',�����̱�Ų�����' end)
	 where IWH_DealerID is null
	 and IWH_BatchNbr = @BatchNbr
	 
	 --У��ֿ���
	 Update InterfaceWarehouse
	 set IWH_WhmID = WHM_ID
	 from Warehouse(nolock)
	 where IWH_WhmCode = WHM_Code 
	 and IWH_BatchNbr = @BatchNbr
	 
	 Update InterfaceWarehouse
	 set IWH_WhmID = NEWID()
	 from Warehouse(nolock)
	 where IWH_BatchNbr = @BatchNbr
	 AND IWH_WhmID is null
	  
	 --У��ҽԺ����Ƿ���ȷ
	 Update InterfaceWarehouse
	 set IWH_HospitalID = HOS_ID
	 from Hospital(nolock)
	 where IWH_HospitalCode = HOS_Key_Account 
	 and IWH_BatchNbr = @BatchNbr
	 and isnull(IWH_HospitalCode,'') <> ''
	 
	 update InterfaceWarehouse SET IWH_HospitalCode='' 
	 where len(rtrim(LTRIM(IWH_HospitalCode)))=0
	 and IWH_BatchNbr = @BatchNbr
	 
	 Update InterfaceWarehouse
	 Set IWH_ErrorMsg = 
	 (CASE
            WHEN IWH_ErrorMsg IS NULL THEN N'ҽԺ��Ų�����'
            ELSE IWH_ErrorMsg + N',ҽԺ��Ų�����'
         END)
	 where IWH_HospitalID is null 
	 and IWH_HospitalCode <> '' 
	 and IWH_BatchNbr = @BatchNbr
	 
	 --У����۲ֿ������Ƿ���ȷ
	 Update InterfaceWarehouse
	 Set IWH_ErrorMsg = 
	 (CASE
            WHEN IWH_ErrorMsg IS NULL THEN N'���۲ֿ����Ͳ���ȷ'
            ELSE IWH_ErrorMsg + N',���۲ֿ����Ͳ���ȷ'
         END)
	 where ((IWH_Type is null) or (IWH_Type not in ('BSC','LP')))
	 and IWH_BatchNbr = @BatchNbr
	 
	 
	 Update InterfaceWarehouse
	 Set IWH_ErrorMsg = 
	 (CASE
            WHEN IWH_ErrorMsg IS NULL THEN N'�ϴ��Ĳֿ�������������ƽ̨���������ֿ̲����ظ�'
            ELSE IWH_ErrorMsg + N',�ϴ��Ĳֿ�������������ƽ̨���������ֿ̲����ظ�'
         END)
	 where IWH_BatchNbr = @BatchNbr
	   and EXISTS (
     select 1 from warehouse wh(nolock) , Client ct(nolock), DealerMaster DM(nolock)
                  where InterfaceWarehouse.IWH_ClientID = ct.CLT_ID and ct.CLT_Corp_Id<> DM.DMA_Parent_DMA_ID
                  and DM.DMA_SAP_Code = InterfaceWarehouse.IWH_DealerCode
	               and wh.WHM_Code = InterfaceWarehouse.IWH_WhmCode
                 and wh.WHM_DMA_ID = DM.DMA_ID )


  Update iw
  	 Set iw.IWH_ErrorMsg =      
  	 (CASE
              WHEN IWH_ErrorMsg IS NULL THEN N'��ͬ��ŵļ��۲ֿ�������ͬ'
              ELSE IWH_ErrorMsg + N',��ͬ��ŵļ��۲ֿ�������ͬ'
           END)
    FROM InterfaceWarehouse AS iw(nolock)
  	 where iw.IWH_BatchNbr = @BatchNbr
     and exists (
     select 1 from (select IWH_DealerID,IWH_WhmName from InterfaceWarehouse(nolock) where IWH_BatchNbr = @BatchNbr group by IWH_DealerID,IWH_WhmName having count(*)>1) AS tab
     where tab.IWH_DealerID = iw.IWH_DealerID and tab.IWH_WhmName = iw.IWH_WhmName
 )
     
      --������ʱ��
      
	  SELECT IWH_WhmID as WarehouseID,IWH_DealerCode AS DealerCode,IWH_DealerId,IWH_HospitalCode as HospitalCode,IWH_HospitalID,
	  IWH_WhmCode as WhmCode ,IWH_WhmName as WhmName ,IWH_Address as [Address],IWH_PostalCode as PostalCode,IWH_IsActive as IsActive,IWH_Type AS IWHType
	  into #tmp_warehouse
      FROM InterfaceWarehouse(nolock) 
      WHERE IWH_BatchNbr = @BatchNbr
      AND isnull(IWH_ErrorMsg,'') = '' 

      --����warehouse�������еĲֿ�
      Update w
      set WHM_DMA_ID = iw.IWH_DealerId,
		  WHM_Name = iw.WhmName,
		  WHM_Hospital_HOS_ID = iw.IWH_HospitalID,
		  WHM_Address = iw.[Address],
		  WHM_PostalCode = iw.PostalCode,
		  WHM_ActiveFlag = iw.IsActive
      from Warehouse w(nolock) inner join DealerMaster dm(nolock) on WHM_DMA_ID = DMA_ID
      inner join #tmp_warehouse iw on WHM_Code = iw.WhmCode
      where DMA_Parent_DMA_ID = @DealerId
      and WHM_Type = (CASE WHEN iw.IWHType = 'LP' then 'LP_Consignment' ELSE 'Consignment' END)
      
      --�����ֿ�
      INSERT INTO Warehouse
      select IWH_DealerId,WhmName,'',WarehouseID,'',CASE WHEN iw.IWHType = 'LP' then 'LP_Consignment' ELSE 'Consignment' END,null,PostalCode,[Address],0,'','','','',IsActive,IWH_HospitalID,WhmCode 
      from #tmp_warehouse iw 
      where not exists (select 1 from Warehouse(nolock) where iw.WhmCode = WHM_Code)
      
 COMMIT TRAN	
	
SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @IsValid = 'Failure'
	
	--��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
    
END CATCH
GO


