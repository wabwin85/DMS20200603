DROP Procedure [dbo].[GC_DealerComplain_CheckUPNAndDate]
GO


/*
�������ύͶ���˻�ǰ��UPN��LOT���������ڽ���У�飬����У����
*/
CREATE Procedure [dbo].[GC_DealerComplain_CheckUPNAndDate]
    @WHMID       uniqueidentifier,
    @DMAID       uniqueidentifier,
    @UPN         NVARCHAR(50),
    @LOT         NVARCHAR(50),
    @RETURNNUM   Decimal(18,2),
    @ImplantDate Datetime,
    @EventDate   Datetime,
    @ComplainType NVARCHAR(50), --����CRM��BSC
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(2000) OUTPUT
AS
	DECLARE @SysUserId uniqueidentifier
  DECLARE @RowCnt int
  DECLARE @Validdate Datetime
  DECLARE @PMAID uniqueidentifier
  DECLARE @NUM Decimal(18,2)
  DECLARE @WHMTYPE nvarchar(20)
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
  
  --�жϲ�Ʒ�ͺ��Ƿ����
  select @RowCnt = count(*) from cfn where CFN_CustomerFaceNbr = @UPN
    if (@RowCnt = 0)
       SET @RtnMsg = '��Ʒ�ͺŲ�����'
  
  
  IF len(@RtnMsg) = 0
    BEGIN
      --�жϲ�Ʒ�����Ƿ����
      select @RowCnt = count(*) from cfn t1, product t2, LotMaster t3
      where t1.CFN_ID=t2.PMA_CFN_ID and t2.PMA_ID=t3.LTM_Product_PMA_ID and t3.LTM_LotNumber=@LOT and t1.CFN_CustomerFaceNbr=@UPN
      if (@RowCnt = 0)
        SET @RtnMsg = '��Ʒ���Ų�����'
    END
    
  IF (len(@RtnMsg) = 0  and @WHMID <> '00000000-0000-0000-0000-000000000000')
    BEGIN
      --�жϿ���Ƿ񹻿ۼ�
      select @NUM = sum(Lot.LOT_OnHandQty) - @RETURNNUM 
      from Inventory AS INV, Lot , LotMaster AS LM , Product AS PRD
      where INV.INV_ID=Lot.LOT_INV_ID and LM.LTM_ID = Lot.LOT_LTM_ID
        and PRD.PMA_ID = INV.INV_PMA_ID and INV.INV_WHM_ID = @WHMID
        and LM.LTM_LotNumber = @LOT and PRD.PMA_UPN = @UPN
        
      if (@NUM < 0)
        SET @RtnMsg = '�����������'
        
       
    END
  
--  IF len(@RtnMsg) = 0
--    BEGIN  
--      --�жϾ������Ƿ��ж�Ӧ�����ۼ�¼
--      select @RowCnt = count(*) 
--        from ShipmentHeader SH, ShipmentLine SLN, ShipmentLot SLT, cfn , product AS PRD, LotMaster LM ,LOT
--       where SH.SPH_ID=SLN.SPL_SPH_ID and SLN.SPL_ID = SLT.SLT_SPL_ID and cfn.CFN_ID = PRD.PMA_CFN_ID and PRD.PMA_ID = SLN.SPL_Shipment_PMA_ID 
--         and SLT.SLT_LOT_ID = lot.lot_id and Lot.LOT_LTM_ID=LM.LTM_ID and SH.SPH_Dealer_DMA_ID=@DMAID and CFN.CFN_CustomerFaceNbr=@UPN and LM.LTM_LotNumber = @LOT
--         and SH.SPH_Status = 'Complete'
--      if (@RowCnt = 0)
--        SET @RtnMsg = '���ۼ�¼�в����ڴ˲�Ʒ,��֪ͨ������Աͨ��E-Workflowϵͳ�ύ'        
--    END
    
--  IF len(@RtnMsg) = 0
--    BEGIN  
--      --�жϴ����Ų�Ʒ����-����-�˻�>0 
--       
--      select @PMAID = t2.PMA_ID  from cfn t1,product t2 where t1.CFN_ID=t2.PMA_CFN_ID and t1.CFN_CustomerFaceNbr = @UPN
--      
--      select @RowCnt = sum([Receipt])-sum([Sales])-sum([Return])-sum([Complain]) from 
--        (      
--        select case when Type='Receipt' then Qty else 0 end AS 'Receipt', 
--               case when Type='Sales' then Qty else 0 end AS 'Sales',
--               case when Type='Return' then Qty else 0 end AS 'Return',
--               case when Type='Complain' then Qty else 0 end AS 'Complain'
--          from (
--            select Convert(int,sum(isnull(PLT.PRL_ReceiptQty,0))) AS Qty,'Receipt' AS Type
--              from POReceiptHeader POH, POReceipt POL, POReceiptLot PLT
--             where POH.PRH_ID=POL.POR_PRH_ID and POL.POR_ID=PLT.PRL_POR_ID
--               and POH.PRH_Dealer_DMA_ID = @DMAID and POL.POR_SAP_PMA_ID = @PMAID
--               and PLT.PRL_LotNumber = @LOT and POH.PRH_Status = 'Complete' and POH.PRH_Type in ('PurchaseOrder','Retail')
--            union all
--            select Convert(int,sum(isnull(SLT.SLT_LotShippedQty,0))) AS Qty,'Sales' AS Type
--              from ShipmentHeader SH, ShipmentLine SLN, ShipmentLot SLT, LotMaster LM ,LOT  
--             where SH.SPH_ID=SLN.SPL_SPH_ID and SLN.SPL_ID = SLT.SLT_SPL_ID and SLN.SPL_Shipment_PMA_ID =@PMAID
--               and SLT.SLT_LOT_ID = lot.lot_id and Lot.LOT_LTM_ID=LM.LTM_ID and SH.SPH_Dealer_DMA_ID=@DMAID 
--               and LM.LTM_LotNumber = @LOT and SH.SPH_Status = 'Complete'
--            UNION ALL      
--            select Convert(int,sum(isnull(IAL.IAL_LotQty ,0))) AS Qty,'Return' AS Type
--            from InventoryAdjustHeader IAH, InventoryAdjustDetail IAD, InventoryAdjustLot IAL
--            where IAH.IAH_ID=IAD.IAD_IAH_ID and IAD.IAD_ID=IAL.IAL_IAD_ID and IAH.IAH_Reason in ('Return','Exchange')
--              and IAH.IAH_Status in ('Accept','Submitted') and IAD.IAD_PMA_ID=@PMAID and IAL.IAL_LotNumber = @LOT
--              and IAH.IAH_DMA_ID=@DMAID       
--            UNION ALL
--            select count(*) AS Qty,'Complain' AS Complain from DealerComplain where DC_CorpId=@DMAID and UPN=@UPN and LOT=@LOT and DC_Status NOT in ('Reject','Revoked')
--          ) tab 
--        ) AS Cal
--   
--      if (@RowCnt < 0 or  @RowCnt = 0)
--        SET @RtnMsg = '����-����-�˻�<=0,������û��ʣ���Ʒ���Խ���Ͷ���˻�'        
--    END
--  
  IF len(@RtnMsg) = 0
    BEGIN
      --�ж��Ƿ�CRM��Ʒ
      IF (@ComplainType = 'CRM')
        BEGIN
           select @RowCnt = count(*) from cfn where CFN_CustomerFaceNbr=@UPN and CFN_ProductLine_BUM_ID ='97a4e135-74c7-4802-af23-9d6d00fcb2cc'
           if (@RowCnt = 0)
            SET @RtnMsg = '�˲�Ʒ����CMR��Ʒ'       
        END
      ELSE
        BEGIN
           select @RowCnt = count(*) from cfn where CFN_CustomerFaceNbr=@UPN and CFN_ProductLine_BUM_ID <>'97a4e135-74c7-4802-af23-9d6d00fcb2cc'
           if (@RowCnt = 0)
            SET @RtnMsg = '�˲�Ʒ��CMR��Ʒ' 
        END
    END
  
  IF len(@RtnMsg) = 0
    BEGIN
      --��ȡ��Ʒ��Ч��
      select @Validdate = t3.LTM_ExpiredDate from cfn t1, product t2, LotMaster t3
      where t1.CFN_ID=t2.PMA_CFN_ID and t2.PMA_ID=t3.LTM_Product_PMA_ID and t3.LTM_LotNumber=@LOT and t1.CFN_CustomerFaceNbr=@UPN
      
      --�ж������Ƿ�Ϊ
      IF (@ComplainType = 'CRM')
        BEGIN
           --CRM��Ʒ�Ƚ�������
           if (@Validdate < @ImplantDate)
              SET @RtnMsg = '��Ʒ��Ч�ڣ�'+ Convert(nvarchar(8),@Validdate,112) + ',�������ڴ��ڲ�Ʒ��Ч�ڣ����ڹ���ʹ�ã�'      
             
        END
      ELSE      
        BEGIN
          if (convert(int,Convert(nvarchar(6),@Validdate,112)) < convert(int,Convert(nvarchar(6),@ImplantDate,112)))
            SET @RtnMsg = '��Ʒ��Ч�ڣ�'+ Convert(nvarchar(6),@Validdate,112) + ',�������ڴ��ڲ�Ʒ��Ч�ڣ����ڹ���ʹ�ã�' 
        END
        
    END
  
  IF len(@RtnMsg) = 0
    BEGIN
      IF (@EventDate<@ImplantDate)
        SET @RtnMsg = '�¼����ڲ���С���������ڣ�' 
    END
    
  IF len(@RtnMsg) = 0
    BEGIN
      IF (@EventDate>getdate())
        SET @RtnMsg = '�¼����ڲ��ܴ��ڵ�ǰ���ڣ�' 
    END
  IF len(@RtnMsg)>0
    SET @RtnVal = 'Failure'

  
COMMIT TRAN
SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
	
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


