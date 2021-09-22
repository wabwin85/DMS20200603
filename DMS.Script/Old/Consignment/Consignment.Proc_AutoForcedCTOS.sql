IF OBJECT_ID ('Consignment.Proc_AutoForcedCTOS') IS NOT NULL
	DROP PROCEDURE Consignment.Proc_AutoForcedCTOS
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
1. 功能名称：强制寄售买断
2. 更能描述：
	根据2个条件，生成强制寄售买断单据
  1、产品有效期到期
  2、寄售天数到期（对于无法关联到寄售天数的单据不处理）
	3、寄售有效期到期
  
  此处只是申请，然后后续走审批流程（申请的时候库存操作方式是Frozen）
  
3. 参数描述：	
	@RtnVal 执行状态：Success、Failure
	@RtnMsg 错误描述
*/
CREATE PROCEDURE Consignment.Proc_AutoForcedCTOS(     
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(1000) OUTPUT
)
AS
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	DECLARE @strSynContent Nvarchar(max)
 
  SET @RtnVal = 'Success'
	SET @RtnMsg = ''
  SET @strSynContent =''
	

  
BEGIN


  create table #tmp_CTOS
  (
  	DmaId uniqueidentifier not null,
    ParentDmaId uniqueidentifier null,
  	WhmId uniqueidentifier null,
  	ProductLineId uniqueidentifier null,
  	PmaId uniqueidentifier null,
    CfnId uniqueidentifier null,
  	LotId uniqueidentifier null,
  	LotNumber nvarchar(50) collate Chinese_PRC_CI_AS null,
  	ExpiredDate datetime null,
  	Qty decimal(18,2) null,
  	IadId uniqueidentifier null,
  	IalId  uniqueidentifier null,
    UnitPrice decimal(18,2) null,
    ApplyAccount nvarchar(20) collate Chinese_PRC_CI_AS null,
    Remark nvarchar(50) collate Chinese_PRC_CI_AS null 
  )
  
  Create table #tmp_QRConsignmentDay
  (
    QRC_DMA_ID uniqueidentifier not null,
    QRC_SAPShipmentID nvarchar(50) collate Chinese_PRC_CI_AS not null,
    QRC_PMA_ID uniqueidentifier not null,
    QRC_Lot nvarchar(50) collate Chinese_PRC_CI_AS null,
    QRC_QRCode nvarchar(50) collate Chinese_PRC_CI_AS null,
    QRC_ConsignmentEndDate datetime null,
    QRC_ApplyAccount nvarchar(20) collate Chinese_PRC_CI_AS null ,  
    QRC_ContractEndDate datetime null,
    QRC_ConsignApplyEndDate datetime null
  )
  
  create table #tmp_Employee
  (
  	EID int not null,   
    UserAccount nvarchar(20) collate Chinese_PRC_CI_AS null
  )
  
  Insert into #tmp_Employee
  SELECT EID,[Account] FROM interface.MDM_EmployeeMaster
  
  Insert into #tmp_QRConsignmentDay(QRC_DMA_ID,QRC_SAPShipmentID,QRC_PMA_ID,QRC_Lot,QRC_QRCode,QRC_ConsignmentEndDate,QRC_ApplyAccount,QRC_ContractEndDate,QRC_ConsignApplyEndDate)
  SELECT PRH.PRH_Dealer_DMA_ID, PRH.PRH_SAPShipmentID, PR.POR_SAP_PMA_ID, 
         CASE WHEN CHARINDEX('@@',PRL.PRL_LotNumber) > 0 THEN substring(PRL.PRL_LotNumber,1,CHARINDEX('@@',PRL.PRL_LotNumber)-1) ELSE PRL.PRL_LotNumber END AS LotNumber,     
         CASE WHEN CHARINDEX('@@',PRL.PRL_LotNumber) > 0 THEN substring(PRL.PRL_LotNumber,CHARINDEX('@@',PRL.PRL_LotNumber)+2,LEN(PRL.PRL_LotNumber)-CHARINDEX('@@',PRL.PRL_LotNumber)) ELSE 'NoQR' END AS QrCode,
         case when dateadd(d,OInfo.ConsignmentDay,PRH.PRH_SAPShipmentDate)  < OInfo.ContractEndDate then  dateadd(d,OInfo.ConsignmentDay,PRH.PRH_SAPShipmentDate) else OInfo.ContractEndDate end as ConsignmentEndDate,         
         OInfo.UserAccount,ContractEndDate,dateadd(d,OInfo.ConsignmentDay,PRH.PRH_SAPShipmentDate) AS ConsignApplyEndDate
  FROM POReceiptHeader PRH, POReceipt PR, POReceiptLot PRL,
  (
  select H.POH_OrderNo AS OrderNo, H.POH_DMA_ID AS DMAID, D.POD_CFN_ID AS CFN_ID,P.PMA_ID AS PMA_ID, min(D.POD_ConsignmentDay) As ConsignmentDay ,max(isnull(CCH.CCH_EndDate,Convert(datetime,'2099-01-01'))) AS ContractEndDate,UPPER(LI.IDENTITY_CODE) AS UserAccount
    from PurchaseOrderHeader H 
    inner join PurchaseOrderDetail_WithQR D ON (H.POH_ID = D.POD_POH_ID)
    inner join product P on (P.PMA_CFN_ID = D.POD_CFN_ID)
    left join Consignment.ContractHeader CCH on (CCH.CCH_ID = D.POD_ConsignmentContractID )
    left join Lafite_IDENTITY LI on (LI.Id = CCH.CCH_CreateUser )
   where H.POH_OrderType='Consignment'
     AND H.POH_CreateType='Manual'
     AND H.POH_SubmitDate>'2018-10-01'
    group by H.POH_OrderNo, H.POH_DMA_ID, D.POD_CFN_ID,P.PMA_ID, LI.IDENTITY_CODE 
  ) AS OInfo  
    where PRH.PRH_ID= PR.POR_PRH_ID and PR.POR_ID = PRL.PRL_POR_ID 
      and PRH.PRH_PurchaseOrderNbr = OInfo.OrderNo and PR.POR_SAP_PMA_ID = OInfo.PMA_ID
      and PRH.PRH_Dealer_DMA_ID = OInfo.DMAID
      AND PRH.PRH_SAPShipmentDate>'2018-10-01'
  
  
  
  
  --查询波科物权的产品到期的(查询仓库类型为Consignment、Borrow)
  
  --寄售产品过有效期的
  insert into #tmp_CTOS(DmaId,ParentDmaId,WhmId,ProductLineId,PmaId,LotId,LotNumber,ExpiredDate,Qty,IadId,IalId,CfnId,ApplyAccount,Remark)
  select DMA_ID,CASE WHEN DealerMaster.DMA_DealerType='T2' THEN Dealermaster.DMA_Parent_DMA_ID ELSE DMA_ID END AS  ParentDmaId,
       WHM_ID,CFN_ProductLine_BUM_ID,PMA_ID,LOT_ID,LTM_LotNumber + '@@' + LTM_QRCode,LTM_ExpiredDate,LOT_OnHandQty ,NEWID(),NEWID(),CFN_ID, QRCD.QRC_ApplyAccount,'产品过有效期'
  from DealerMaster(nolock),Warehouse(nolock),Inventory(nolock),Product(nolock),CFN(nolock),Lot(nolock),v_LotMaster(nolock),#tmp_QRConsignmentDay AS QRCD
  where DMA_ID = WHM_DMA_ID
    and WHM_ID = INV_WHM_ID
    and INV_ID = LOT_INV_ID
    and INV_PMA_ID = PMA_ID
    and PMA_CFN_ID = CFN_ID
    and LOT_LTM_ID = LTM_ID
    AND LTM_QRCode = QRCD.QRC_QRCode
    --AND PMA_ID = QRCD.QRC_PMA_ID
    --AND DMA_ID = QRCD.QRC_DMA_ID
    AND LTM_LotNumber = QRCD.QRC_Lot
    and WHM_Type in ('Consignment','Borrow')
    and LTM_LotNumber <> 'NoQR'
    and LOT_OnHandQty > 0
    and DATEDIFF(day,getdate(),LTM_ExpiredDate) <= 1   

  
  --根据二维码查找最近一次KB订单，查找对应的寄售日期和寄售合同
  insert into #tmp_CTOS(DmaId,ParentDmaId,WhmId,ProductLineId,PmaId,LotId,LotNumber,ExpiredDate,Qty,IadId,IalId,CfnId,ApplyAccount,Remark)
  select DMA_ID,CASE WHEN DealerMaster.DMA_DealerType='T2' THEN Dealermaster.DMA_Parent_DMA_ID ELSE DMA_ID END AS  ParentDmaId,
         WHM_ID,CFN_ProductLine_BUM_ID,PMA_ID,LOT_ID,LTM_LotNumber + '@@' + LTM_QRCode,LTM_ExpiredDate,LOT_OnHandQty ,NEWID(),NEWID(),CFN_ID, QRCD.QRC_ApplyAccount, 
         CASE WHEN QRC_ConsignmentEndDate= QRC_ContractEndDate THEN '寄售合同到期' WHEN QRC_ConsignmentEndDate = QRC_ConsignApplyEndDate THEN '寄售天数到期' ELSE '' END 
  from DealerMaster(nolock),Warehouse(nolock),Inventory(nolock),Product(nolock),CFN(nolock),Lot(nolock),v_LotMaster(nolock),#tmp_QRConsignmentDay AS QRCD
  where DMA_ID = WHM_DMA_ID
    and WHM_ID = INV_WHM_ID
    and INV_ID = LOT_INV_ID
    and INV_PMA_ID = PMA_ID
    and PMA_CFN_ID = CFN_ID
    and LOT_LTM_ID = LTM_ID
    AND LTM_QRCode = QRCD.QRC_QRCode
    AND PMA_ID = QRCD.QRC_PMA_ID
    AND DMA_ID = QRCD.QRC_DMA_ID
    AND LTM_LotNumber = QRCD.QRC_Lot
    and WHM_Type in ('Consignment','Borrow')
    and LTM_LotNumber <> 'NoQR'
    and LOT_OnHandQty > 0
    and DATEDIFF(day,getdate(),QRCD.QRC_ConsignmentEndDate) <= 1
    AND not exists (select 1 from #tmp_CTOS CTOS where CTOS.DmaId = DealerMaster.Dma_Id and CTOS.LotId = Lot.LOT_ID  )
  
  

  
  --更新IAD_ID
  	update t1
  	set t1.IadId = t2.IadId
  	from #tmp_CTOS t1,(select MAX(convert(nvarchar(100),IadId)) as IadId,DmaId,PmaId from #tmp_CTOS group by DmaId,PmaId) t2
  	where t1.DmaId= t2.DmaId
  	and t1.PmaId = t2.PmaId
  
  --更新金额
  update t1
     set t1.UnitPrice = CFNP_Price			
    from #tmp_CTOS t1,CFNPrice t3(nolock)
    where t1.DmaId = t3.CFNP_Group_ID
      and t1.CfnId = t3.CFNP_CFN_ID
      and t3.CFNP_PriceType = 'Dealer'
  

  
  --遍历产品线，生成寄售转销售申请单，并写入接口表
  declare @m_DmaId uniqueidentifier 
  declare @m_Bumid uniqueidentifier
  declare @m_BuName nvarchar(20)
  declare @m_account nvarchar(20)
  declare @HeaderID uniqueidentifier
  DECLARE @PONumber   NVARCHAR (50)
  DECLARE @m_RtnVal nvarchar(20);
  DECLARE @m_RtnMsg nvarchar(1000);
  
  DECLARE	curHandleCTOS CURSOR LOCAL
  	FOR SELECT distinct DmaId,t.ProductLineId,divisionname,ApplyAccount FROM #tmp_CTOS t,V_DivisionProductLineRelation v
  	where t.ProductLineId = v.ProductLineId

  	OPEN curHandleCTOS
  	FETCH NEXT FROM curHandleCTOS INTO @m_DmaId,@m_Bumid,@m_BuName,@m_account

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
             ,[IAH_ProductLine_BUM_ID]           
             ,[SaleRep] 
             )
  			SELECT distinct @HeaderID					  
  			,'ForceCTOS'				  
  			,@PONumber			
  			,DmaId				  
  			,GETDATE()          
  			,GETDATE()                 
  			,'因为产品效期小于当前日期或寄售天数到期，系统自动强制提交寄售转销售申请单'	
  			,'Submit'			  
  			,Id  	  
  			,ProductLineId      
        ,EM.EID
  			FROM #tmp_CTOS t inner join DealerMaster(nolock) on (t.DmaId = DMA_ID)
                         inner join Lafite_IDENTITY(nolock) on (DMA_SAP_Code + '_99' = IDENTITY_CODE)
                         left join #tmp_Employee EM(nolock) on (EM.UserAccount=t.ApplyAccount)
  			where DmaId= @m_DmaId
  			and ProductLineId = @m_Bumid
  		
        
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
  			insert into InventoryAdjustLot(IAL_IAD_ID,IAL_ID,IAL_LotQty,IAL_LOT_ID,IAL_WHM_ID,IAL_LotNumber,IAL_ExpiredDate,IAL_PRH_ID,IAL_UnitPrice, IAL_QRLotNumber,IAL_Remark ) 
  			select iadid,ialid,Qty,LotId,WhmId,LotNumber,ExpiredDate,(select top 1 PRH_ID from POReceiptHeader where PRH_Dealer_DMA_ID = @m_DmaId and PRH_ProductLine_BUM_ID = @m_Bumid),UnitPrice,null, Remark
  			from #tmp_CTOS
  			where DmaId=@m_DmaId
  			and ProductLineId=@m_Bumid
  			
        --调用Procedure 进行库存扣减     
        EXEC [Consignment].[Proc_InventoryAdjust] 'MCTS', @PONumber, 'Frozen',@m_RtnVal OUTPUT,@m_RtnMsg OUTPUT
       
        IF @m_RtnVal <> 'Success'
          RAISERROR (@m_RtnMsg, -- Message text,
             10,                        -- Severity,
             1,                         -- State,
             N'RownNum',                 -- First argument.
             0                          -- Second argument.
            ); 
      
        --写入pushstack表
       
        
        SET @strSynContent = '{"ApplyUser": "' + @m_account +  '","ConsignPurchaseId":"' + Convert(nvarchar(100),@HeaderID) + '","ConsignPurchaseNo":"' + @PONumber + '","DealerId": "' + Convert(nvarchar(100),@m_DmaId) + '"}'
        
        insert into PushStack (PrimaryKey,StampId,PushType,PushMethod,PushContent,PushStatus,PushErrCount,PushMsg,CreateDate,PushDate,ForeignKey) 
        select newid(),null,'PushMethodMFlowConsignPurchase','PushMethodMFlowConsignPurchase',@strSynContent,'Wait',0,'',getdate(),null,null 
      
        
      
        
  			--写入接口表
--  			INSERT INTO AdjustInterface
--  			SELECT NEWID(),'','',@HeaderID,@PONumber,'Pending','Manual',NULL,Id,GETDATE(),Id,GETDATE(),'LP2'
--  			FROM DealerMaster,Lafite_IDENTITY
--  			where DMA_SAP_Code + '_99' = IDENTITY_CODE
--  			AND DMA_ID = @m_DmaId
  		

  	  FETCH NEXT FROM curHandleCTOS INTO @m_DmaId,@m_Bumid,@m_BuName,@m_account
  		END	
  	CLOSE curHandleCTOS
  	DEALLOCATE curHandleCTOS
     
  
  
END
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	
    return -1
    
END CATCH
GO