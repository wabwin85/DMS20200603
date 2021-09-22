DROP FUNCTION [dbo].[GC_Fn_Report_OrderSalesMonthSumTable]
GO


--�¶������ۻ��ܱ���
CREATE FUNCTION [dbo].[GC_Fn_Report_OrderSalesMonthSumTable](
	@ProductLineId uniqueidentifier,
	@dt Nvarchar(50),
  @LpId uniqueidentifier,
	@DealerId uniqueidentifier
)
RETURNS @temp TABLE 
(
	 ProductLineBUMId uniqueidentifier NULL,	--��Ʒ��ID
	 ProductLineName Nvarchar(100) NULL,		--��Ʒ������
	 ChineseName Nvarchar(100) NULL,            --��������������
	 SAPCode Nvarchar(100) NULL,				  --SAPCode
   SAPShipmentDate Nvarchar(10) NULL,
   ParentDealerName Nvarchar(100) NULL, --�ϼ�����������
   Type Nvarchar(20) NULL,              --��������
	 Years  Nvarchar(100) NULL,					  --���
	 OneAmount decimal(18,6) NULL,				--1�½��
	 TwoAmount decimal(18,6) NULL,				--2�½��
	 ThreeAmount decimal(18,6) NULL,			--3�½��
	 FourAmount decimal(18,6) NULL,				--4�½��
	 FiveAmount decimal(18,6) NULL,				--5�½��
	 SixAmount decimal(18,6) NULL,				--6�½��
	 SevenAmount decimal(18,6) NULL,			--7�½��
	 EightAmount decimal(18,6) NULL,			--8�½��
	 NineAmount decimal(18,6) NULL,				--9�½��
	 TenAmount decimal(18,6) NULL,				--10�½��
	 ElevenAmount decimal(18,6) NULL,			--11�½��
	 TwelveAmount decimal(18,6) NULL,			--12�½��
	 Amount decimal(18,6) NULL					--�ܽ��
	 	  
)
	WITH
	EXECUTE AS CALLER
AS
    BEGIN
     --�½���ʱ��
    declare @t table(
		 BUMId uniqueidentifier,
		 TerritoryCode Nvarchar(100) NULL,
		 ChineseName Nvarchar(100) NULL,
		 SAPCode Nvarchar(100) NULL,
     ParentDealerName Nvarchar(100) NULL, 
		 Amount decimal(18,6),	
		 SAPShipmentDate datetime, --��������
     Type Nvarchar(20) NULL
		)
  --����ʱ���������
  insert into @t 
   select POH_ProductLine_BUM_ID,
     POH.POH_TerritoryCode as TerritoryCode,
     dm.DMA_ChineseName as ChineseName, dm.DMA_SAP_Code as SAPCode ,
     (select DMA_ChineseName from dealermaster where dma_id = dm.DMA_Parent_DMA_ID ) AS ParentDealerName,
     sum(POD.POD_CFN_Price*PR.POR_ReceiptQty) as Amount,
     convert(varchar(10),PRH_SAPShipmentDate,120) as SAPShipmentDate,
     '��������' 
     from PurchaseOrderHeader POH
     --���ݾ�����ID����DealerMaster��,�õ��������������ƺ�SAPCode
     left join DealerMaster dm on POH.POH_DMA_ID=dm.DMA_ID  
     --���ݶ�������ID���Ӷ�����ϸ��,�õ�POD_CFN_Price
     inner join PurchaseOrderDetail POD on POD.POD_POH_ID=POH.POH_ID 
     --���ݶ�������Ķ��������ӳ��ⵥ��,�õ���������
     inner join POReceiptHeader PRH on PRH.PRH_PurchaseOrderNbr=POH.POH_OrderNo
     --���ݳ��ⵥID���ӳ��ⵥ��ϸ��,�õ�POR_ReceiptQty
     inner join POReceipt PR on PR.POR_PRH_ID=PRH.PRH_ID
     --����Product��,����Product��PMAID��CFNID,ʹ��������ͳ��ⵥ��ϸ�����
     inner join Product pd on PR.POR_SAP_PMA_ID=pd.PMA_ID and pd.PMA_CFN_ID=POD.POD_CFN_ID
     where PRH_Type='PurchaseOrder' 
     and POH.POH_OrderType not in ('ConsignmentSales')
     and PRH.PRH_Status not in ('Cancelled')
     and CONVERT(char(4),PRH_SAPShipmentDate,120)=@dt
     and (POH.POH_ProductLine_BUM_ID=@ProductLineId or @ProductLineId is null)     
     and (POH.POH_DMA_ID = @DealerId or @DealerId is null)
     and (dm.DMA_Parent_DMA_ID = @LpId or @LpId is null)
     --AND (dbo.GC_FilterByDealer(@UserId,POH.POH_DMA_ID,POH_ProductLine_BUM_ID) = 1)
	 group by POH_ProductLine_BUM_ID,POH_TerritoryCode,DMA_ChineseName,DMA_SAP_Code,PRH_SAPShipmentDate,DMA_Parent_DMA_ID
   
    
  insert into @t
  select POH_ProductLine_BUM_ID,
     POH.POH_TerritoryCode as TerritoryCode,
     dm.DMA_ChineseName as ChineseName, dm.DMA_SAP_Code as SAPCode ,
     (select DMA_ChineseName from dealermaster where dma_id = dm.DMA_Parent_DMA_ID ) AS ParentDealerName,
     sum(POD.POD_Amount) as Amount,
     convert(varchar(10),POH.POH_SubmitDate ,120) as SAPShipmentDate,
     '�������۶���'
     from PurchaseOrderHeader POH
     --���ݾ�����ID����DealerMaster��,�õ��������������ƺ�SAPCode
     left join DealerMaster dm on POH.POH_DMA_ID=dm.DMA_ID  
     --���ݶ�������ID���Ӷ�����ϸ��,�õ�POD_CFN_Price
     inner join PurchaseOrderDetail POD on POD.POD_POH_ID=POH.POH_ID 
     --���ݶ�������Ķ��������ӳ��ⵥ��,�õ���������
     where POH.POH_OrderType in ('ConsignmentSales')
     and CONVERT(char(4),POH_SubmitDate,120)=@dt
     and (POH.POH_ProductLine_BUM_ID=@ProductLineId or @ProductLineId is null)     
     and (POH.POH_DMA_ID = @DealerId or @DealerId is null)
     and (dm.DMA_Parent_DMA_ID = @LpId or @LpId is null)
     --AND (dbo.GC_FilterByDealer(@UserId,POH.POH_DMA_ID,POH_ProductLine_BUM_ID) = 1)
	 group by POH_ProductLine_BUM_ID,POH_TerritoryCode,DMA_ChineseName,DMA_SAP_Code,POH_SubmitDate,DMA_Parent_DMA_ID
	
--ÿ���µ����۽��
  insert into @temp 
	select BUMId,'',ChineseName,SAPCode,convert(nvarchar(10),SAPShipmentDate,111),ParentDealerName,Type,@dt,
	case when SAPShipmentDate >=@dt+'-01-01' and SAPShipmentDate<@dt+'-02-01' then sum(Amount) end as OneAmount,
	case when SAPShipmentDate >=@dt+'-02-01' and SAPShipmentDate<@dt+'-03-01' then sum(Amount) end as TwoAmount,
	case when SAPShipmentDate >=@dt+'-03-01' and SAPShipmentDate<@dt+'-04-01' then sum(Amount) end as ThreeAmount,
	case when SAPShipmentDate >=@dt+'-04-01' and SAPShipmentDate<@dt+'-05-01' then sum(Amount) end as FourAmount,
	case when SAPShipmentDate >=@dt+'-05-01' and SAPShipmentDate<@dt+'-06-01' then sum(Amount) end as FiveAmount,
	case when SAPShipmentDate >=@dt+'-06-01' and SAPShipmentDate<@dt+'-07-01' then sum(Amount) end as SixAmount,
	case when SAPShipmentDate >=@dt+'-07-01' and SAPShipmentDate<@dt+'-08-01' then sum(Amount) end as SevenAmount,
	case when SAPShipmentDate >=@dt+'-08-01' and SAPShipmentDate<@dt+'-09-01' then sum(Amount) end as EightAmount,
	case when SAPShipmentDate >=@dt+'-09-01' and SAPShipmentDate<@dt+'-10-01' then sum(Amount) end as NineAmount,
	case when SAPShipmentDate >=@dt+'-10-01' and SAPShipmentDate<@dt+'-11-01' then sum(Amount) end as TenAmount,
	case when SAPShipmentDate >=@dt+'-11-01' and SAPShipmentDate<@dt+'-12-01' then sum(Amount) end as ElevenAmount,
	case when SAPShipmentDate >=@dt+'-12-01' and SAPShipmentDate<=@dt+'-12-31' then sum(Amount) end as TwelveAmount,
    sum(Amount) as Amount
	from @t 
	group by BUMId,ChineseName,SAPCode,SAPShipmentDate,ParentDealerName,Type
	
--��Ʒ������
    update @temp set ProductLineName=ATTRIBUTE_NAME from dbo.Lafite_ATTRIBUTE where ATTRIBUTE_TYPE='Product_Line' and id=ProductLineBUMId
       
        RETURN
    END




GO


