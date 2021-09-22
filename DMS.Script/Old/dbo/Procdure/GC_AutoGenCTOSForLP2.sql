DROP procedure [dbo].[GC_AutoGenCTOSForLP2]
GO

CREATE procedure [dbo].[GC_AutoGenCTOSForLP2]
as
begin
create table #tmp_CTOS
(
	DmaId uniqueidentifier null,
	WhmId uniqueidentifier null,
	ProductLineId uniqueidentifier null,
	PmaId uniqueidentifier null,
	LotId uniqueidentifier null,
	LotNumber nvarchar(50) null,
	ExpiredDate datetime null,
	Qty decimal(18,2) null,
	IadId uniqueidentifier null,
	IalId  uniqueidentifier null
)


--查询国科下属二级经销商的国科寄售库，有效期在15天以内
insert into #tmp_CTOS
select DMA_ID,WHM_ID,CFN_ProductLine_BUM_ID,PMA_ID,LOT_ID,LTM_LotNumber,LTM_ExpiredDate,LOT_OnHandQty ,NEWID(),NEWID()
from DealerMaster,Warehouse,Inventory,Product,CFN,Lot,LotMaster
where DMA_ID = WHM_DMA_ID
and WHM_ID = INV_WHM_ID
and INV_ID = LOT_INV_ID
and INV_PMA_ID = PMA_ID
and PMA_CFN_ID = CFN_ID
and LOT_LTM_ID = LTM_ID
and WHM_Type in ('LP_Consignment')
and LTM_LotNumber not like '%NoQR%'
and LOT_OnHandQty > 0
and DMA_Parent_DMA_ID in ('84C83F71-93B4-4EFD-AB51-12354AFABAC3','a54add15-cb13-4850-9848-6da4576207cb')
and Not exists(select 1 from InventoryAdjustHeader,InventoryAdjustDetail,InventoryAdjustLot 
	where IAH_ID = IAD_IAH_ID and IAD_ID = IAL_IAD_ID and IAL_LOT_ID = LOT_ID 
	and IAH_Reason = 'CTOS' and IAH_Status='Submit')
and DATEDIFF(day,getdate(),LTM_ExpiredDate) <= 15


--更新IAD_ID
	update t1
	set t1.IadId = t2.IadId
	from #tmp_CTOS t1,(select MAX(convert(nvarchar(100),IadId)) as IadId,DmaId,PmaId from #tmp_CTOS group by DmaId,PmaId) t2
	where t1.DmaId= t2.DmaId
	and t1.PmaId = t2.PmaId

--遍历每个二级经销商的产品线，生成寄售转销售申请单，并写入接口表
declare @m_DmaId uniqueidentifier 
declare @m_Bumid uniqueidentifier
declare @m_BuName nvarchar(20)
declare @HeaderID uniqueidentifier
DECLARE @PONumber   NVARCHAR (50)

DECLARE	curHandleInventory CURSOR 
	FOR SELECT distinct DmaId,t.ProductLineId,divisionname FROM #tmp_CTOS t,V_DivisionProductLineRelation v
	where t.ProductLineId = v.ProductLineId

	OPEN curHandleInventory
	FETCH NEXT FROM curHandleInventory INTO @m_DmaId,@m_Bumid,@m_BuName

	WHILE @@FETCH_STATUS = 0
	BEGIN
		select @HeaderID = NEWID();
		
		--获取单据编号
		EXEC [GC_GetNextAutoNumber] @m_DmaId,'Next_ConsignToSellNbr',@m_BuName,@PONumber OUTPUT
		
		--写入主表
		insert into InventoryAdjustHeader 
			([IAH_ID]
           ,[IAH_Reason]
           ,[IAH_Inv_Adj_Nbr]
           ,[IAH_DMA_ID]
           ,[IAH_ApprovalDate]
           ,[IAH_CreatedDate]
           ,[IAH_UserDescription]           
           ,[IAH_Status]
           ,[IAH_CreatedBy_USR_UserID]
           ,[IAH_ProductLine_BUM_ID])
			SELECT distinct @HeaderID					  
			,'CTOS'				  
			,@PONumber			
			,DmaId				  
			,GETDATE()          
			,GETDATE()                 
			,'因为产品效期小于或等于15个自然日，系统自动强制提交寄售转销售申请单'	
			,'Submit'			  
			,Id  	  
			,ProductLineId  
			FROM #tmp_CTOS t,DealerMaster,Lafite_IDENTITY
			where DmaId= @m_DmaId
			and ProductLineId = @m_Bumid
			and t.DmaId = DMA_ID
			and DMA_SAP_Code + '_99' = IDENTITY_CODE
			--写入明细表
			insert into InventoryAdjustDetail
			select qty,IadId,PmaId,@HeaderID,row_number() OVER (ORDER BY PmaId DESC) AS row_number
			from (
			select sum(Qty) as Qty,IadId,PmaId from #tmp_CTOS
			where DmaId=@m_DmaId
			and ProductLineId=@m_Bumid
			group by IadId,PmaId
			) tab
			--写入批次表
			insert into InventoryAdjustLot(IAL_IAD_ID,IAL_ID,IAL_LotQty,IAL_LOT_ID,IAL_WHM_ID,IAL_LotNumber,IAL_ExpiredDate,IAL_PRH_ID,IAL_UnitPrice, IAL_QRLotNumber ) 
			select iadid,ialid,Qty,LotId,WhmId,LotNumber,ExpiredDate,(select top 1 PRH_ID from POReceiptHeader where PRH_Dealer_DMA_ID = @m_DmaId and PRH_ProductLine_BUM_ID = @m_Bumid),null,null
			from #tmp_CTOS
			where DmaId=@m_DmaId
			and ProductLineId=@m_Bumid
			
			--写入接口表
			INSERT INTO AdjustInterface
			SELECT NEWID(),'','',@HeaderID,@PONumber,'Pending','Manual',NULL,Id,GETDATE(),Id,GETDATE(),'LP2'
			FROM DealerMaster,Lafite_IDENTITY
			where DMA_SAP_Code + '_99' = IDENTITY_CODE
			AND DMA_ID = @m_DmaId
		

	 FETCH NEXT FROM curHandleInventory INTO @m_DmaId,@m_Bumid,@m_BuName
		END	
	CLOSE curHandleInventory
	DEALLOCATE curHandleInventory

end
GO


