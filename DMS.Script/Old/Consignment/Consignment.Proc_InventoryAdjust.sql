IF OBJECT_ID ('Consignment.Proc_InventoryAdjust') IS NOT NULL
	DROP PROCEDURE Consignment.Proc_InventoryAdjust
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
1. 功能名称：库存转移或库存调整
2. 更能描述：
	根据单据类型创建符合要求的订单，具体如下：
	寄售退货：寄售申请提交后"冻结库存"，畅联确认数据后"库存调整"（被确认数据扣减冻结库库存，未被确认数据返回原仓库）
	投诉退换货：申请提交后"冻结库存"，审批后"库存调整"（被确认数据扣减冻结库库存，未被确认数据返回原仓库）
	寄售买断：提交申请后冻结库存，审批完成后转移冻结库到主仓库，审批拒绝后返回原仓库
	强制寄售买断：提交申请后冻结库存，审批完成后转移冻结库到主仓库，审批拒绝后返回原仓库
	寄售销售：提交申请后扣减库存
	寄售发货：获取平台接口后扣减库存（暂时不需要）
	寄售转移：提交申请后冻结移出经销商库存，审批完成后扣减移出经销商冻结库库存，增加移入经销商寄售库库存
	
3. 参数描述：
	@BillType 功能类型：寄售退货(ConsignReturn)，投诉退换货(ComplainReturn)，寄售买断(CTS)，强制寄售买断(MCTS)，寄售销售(ConsignSales)，寄售发货(ConsignShipment)，寄售转移(ConsignTransfer)
	@BillNo 功能单据类型
	@OperationType 操作类型：冻结库存(Frozen)、库存调整(Adjust)、撤销(Cancel)
	@RtnVal 执行状态：Success、Failure
	@RtnMsg 错误描述
*/
CREATE PROCEDURE Consignment.Proc_InventoryAdjust(
     @BillType NVARCHAR(100)
    ,@BillNo  NVARCHAR(100)
    ,@OperationType  NVARCHAR(100)
    ,@RtnVal NVARCHAR(20) OUTPUT
	  ,@RtnMsg NVARCHAR(1000) OUTPUT
)
AS
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
BEGIN
	--根据类型写入不同的库存更新临时表
  CREATE TABLE #InventoryDetail(
    BillNo NVARCHAR(100) collate Chinese_PRC_CI_AS Not Null,--单据号
    BillType NVARCHAR(100) collate Chinese_PRC_CI_AS Not Null,--单据类型
    OperationType NVARCHAR(100) collate Chinese_PRC_CI_AS Not Null,--操作类型
    FromDealerID uniqueidentifier Null, --出经销商ID
    ToDealerID uniqueidentifier Null, --入经销商ID
    FromWHMID uniqueidentifier Null,--From仓库ID
    ToWHMID uniqueidentifier Null,--To仓库ID    
    LotID uniqueidentifier Null,--lotID，从单据的明细获取
    PMAID uniqueidentifier Null,--CFNID
    LtmID uniqueidentifier Null,--LTMID
    Qty decimal(10,2) Null,
    FormId uniqueidentifier Null
  )
  
  /*库存临时表*/
	CREATE TABLE #tmp_inventory(
  	INV_ID uniqueidentifier,
  	INV_WHM_ID uniqueidentifier,
  	INV_PMA_ID uniqueidentifier,
  	INV_OnHandQuantity float
  	primary key (INV_ID)
	)

	/*库存明细Lot临时表*/
	CREATE TABLE #tmp_lot(
  	LOT_ID uniqueidentifier,
  	LOT_LTM_ID uniqueidentifier,
  	LOT_WHM_ID uniqueidentifier,
  	LOT_PMA_ID uniqueidentifier,
  	LOT_INV_ID uniqueidentifier,
  	LOT_OnHandQty float,
  	LOT_LotNumber nvarchar(50) collate Chinese_PRC_CI_AS NULL,
    BillNo NVARCHAR(100) collate Chinese_PRC_CI_AS Null,--单据号
    BillType NVARCHAR(100) collate Chinese_PRC_CI_AS Null,--单据类型
    OperationType NVARCHAR(100) collate Chinese_PRC_CI_AS Null,--操作类型
    FormId uniqueidentifier Null,
  	primary key (LOT_ID)
	)

	/*库存日志临时表*/
	CREATE TABLE #tmp_invtrans(
  	ITR_Quantity         float,
  	ITR_ID               uniqueidentifier,
  	ITR_ReferenceID      uniqueidentifier,
  	ITR_Type             nvarchar(50)         collate Chinese_PRC_CI_AS,
  	ITR_WHM_ID           uniqueidentifier,
  	ITR_PMA_ID           uniqueidentifier,
  	ITR_UnitPrice        float,
  	ITR_TransDescription nvarchar(200)        collate Chinese_PRC_CI_AS,
  	primary key (ITR_ID)
	)
	
	/*库存明细Lot日志临时表*/
	CREATE TABLE #tmp_invtranslot(
  	ITL_Quantity         float,
  	ITL_ID               uniqueidentifier,
  	ITL_ITR_ID           uniqueidentifier,
  	ITL_LTM_ID           uniqueidentifier,
  	ITL_LotNumber        nvarchar(50)         collate Chinese_PRC_CI_AS
  	primary key (ITL_ID)
	)	
  
  --根据单据号，获取不同的数据，然后写入中间表（寄售退货）
  IF (@BillType = 'ConsignReturn') 
    BEGIN
      --寄售退货，直接从退货表获取数据（ToWHMID 为null,如果是从在途库扣减的话，需要更新FromWHMID和ToWHMID）
      INSERT INTO #InventoryDetail(BillNo,BillType,OperationType,FromDealerID,ToDealerID,FromWHMID,ToWHMID,LotID,PMAID,LtmID,Qty,FormId)
      SELECT @BillNo,@BillType,@OperationType,
             H.IAH_DMA_ID,null as ToDealerID,IAL_WHM_ID,null,T.IAL_LOT_ID,P.PMA_ID,LT.LOT_LTM_ID,T.IAL_LotQty,D.IAD_ID
        FROM InventoryAdjustHeader H(nolock), InventoryAdjustDetail D(nolock), InventoryAdjustLot T(nolock), Product P(nolock),LOT LT(nolock)
       WHERE H.IAH_ID = D.IAD_IAH_ID AND D.IAD_ID = T.IAL_IAD_ID AND D.IAD_PMA_ID = P.PMA_ID AND T.IAL_LOT_ID = LT.LOT_ID
         AND H.IAH_Inv_Adj_Nbr =@BillNo AND IAH_Reason='Return' 
      
      
    END
  IF (@BillType = 'ComplainReturn')
    BEGIN
      --投诉退换货,从投诉表中获取（ToWHMID 为null,如果是从在途库扣减的话，需要更新FromWHMID和ToWHMID）
      INSERT INTO #InventoryDetail(BillNo,BillType,OperationType,FromDealerID,ToDealerID,FromWHMID,ToWHMID,LotID,PMAID,LtmID,Qty,FormId)
      SELECT @BillNo,@BillType,@OperationType,
             DC_CorpId AS DMA_ID,null as ToDealerID,WHM_ID,null,LT.LOT_ID, P.PMA_ID,LM.LTM_ID,ReturnNum,DC_ID
        FROM DealerComplain DC(nolock) , Product P(nolock),  Inventory Inv(nolock), Lot LT(nolock), LotMaster LM(nolock)
       WHERE DC.UPN = P.PMA_UPN AND P.PMA_ID = Inv.INV_PMA_ID and Inv.INV_WHM_ID=DC.WHM_ID and Inv.INV_ID = LT.LOT_INV_ID
         AND LT.LOT_LTM_ID = LM.LTM_ID and LM.LTM_LotNumber = DC.LOT
         AND DC.DC_ComplainNbr=@BillNo
      UNION
      SELECT @BillNo,@BillType,@OperationType,
             DC_CorpId AS DMA_ID,null as ToDealerID,WHMID,null,LT.LOT_ID, P.PMA_ID,LM.LTM_ID,1 as ReturnNum,DC_ID
        FROM DealerComplainCRM DC(nolock) , Product P(nolock),  Inventory Inv(nolock), Lot LT(nolock), LotMaster LM(nolock)
       WHERE DC.Serial = P.PMA_UPN AND P.PMA_ID = Inv.INV_PMA_ID and Inv.INV_WHM_ID=DC.WHMID and Inv.INV_ID = LT.LOT_INV_ID
         AND LT.LOT_LTM_ID = LM.LTM_ID and LM.LTM_LotNumber = DC.LOT
         AND DC.DC_ComplainNbr=@BillNo
         
       
        
    END
  IF (@BillType = 'CTS')
    BEGIN
      --寄售买断，直接从退货表获取数据（ToWHMID 为null,如果是从在途库扣减的话，需要更新FromWHMID和ToWHMID）
      INSERT INTO #InventoryDetail(BillNo,BillType,OperationType,FromDealerID,ToDealerID,FromWHMID,ToWHMID,LotID,PMAID,LtmID,Qty,FormId)
      SELECT @BillNo,@BillType,@OperationType,
             H.IAH_DMA_ID,null as ToDealerID,IAL_WHM_ID,null,T.IAL_LOT_ID,P.PMA_ID,LT.LOT_LTM_ID,T.IAL_LotQty,D.IAD_ID
        FROM InventoryAdjustHeader H(nolock), InventoryAdjustDetail D(nolock), InventoryAdjustLot T(nolock), Product P(nolock),LOT LT(nolock)
       WHERE H.IAH_ID = D.IAD_IAH_ID AND D.IAD_ID = T.IAL_IAD_ID AND D.IAD_PMA_ID = P.PMA_ID AND T.IAL_LOT_ID = LT.LOT_ID
         AND H.IAH_Inv_Adj_Nbr =@BillNo AND IAH_Reason='CTOS' 
      
    END
  IF (@BillType = 'MCTS')
    BEGIN
      --强制寄售买断，直接从退货表获取数据（ToWHMID 为null,如果是从在途库扣减的话，需要更新FromWHMID和ToWHMID）
      INSERT INTO #InventoryDetail(BillNo,BillType,OperationType,FromDealerID,ToDealerID,FromWHMID,ToWHMID,LotID,PMAID,LtmID,Qty,FormId)
      SELECT @BillNo,@BillType,@OperationType,
             H.IAH_DMA_ID,null as ToDealerID,IAL_WHM_ID,null,T.IAL_LOT_ID,P.PMA_ID,LT.LOT_LTM_ID,T.IAL_LotQty,D.IAD_ID
        FROM InventoryAdjustHeader H(nolock), InventoryAdjustDetail D(nolock), InventoryAdjustLot T(nolock), Product P(nolock),LOT LT(nolock)
       WHERE H.IAH_ID = D.IAD_IAH_ID AND D.IAD_ID = T.IAL_IAD_ID AND D.IAD_PMA_ID = P.PMA_ID AND T.IAL_LOT_ID = LT.LOT_ID
         AND H.IAH_Inv_Adj_Nbr =@BillNo AND IAH_Reason='ForceCTOS' 
    END
  IF (@BillType = 'ConsignSales')
    BEGIN
      --寄售销售，从销售表中获取(销售数据不存在在途的情况)
      INSERT INTO #InventoryDetail(BillNo,BillType,OperationType,FromDealerID,ToDealerID,FromWHMID,ToWHMID,LotID,PMAID,LtmID,Qty,FormId)
      SELECT @BillNo,@BillType,@OperationType,
             H.SPH_Dealer_DMA_ID,null as ToDealerID,L.SLT_WHM_ID,null,L.SLT_LOT_ID,P.PMA_ID,LT.LOT_LTM_ID,L.SLT_LotShippedQty,D.SPL_ID
        FROM ShipmentHeader H(nolock), ShipmentLine D(nolock), ShipmentLot L(nolock), Product P(nolock),LOT LT(nolock)
       WHERE H.SPH_ID = D.SPL_SPH_ID AND D.SPL_ID = L.SLT_SPL_ID AND P.PMA_ID = D.SPL_Shipment_PMA_ID and  L.SLT_LOT_ID = LT.LOT_ID
         AND H.SPH_ShipmentNbr=@BillNo AND H.SPH_Type IN ('Borrow','Consignment')
    
    END
--  ELSE IF (@BillType = 'ConsignShipment')
--    BEGIN
--      --寄售发货,从收货表中获取，LP to T2是直接完成的，不需要在途，BSC to LP当前有相应的程序，也不需要单独的处理程序
--      --暂时不使用
--      
--    
--    END
  IF (@BillType = 'ConsignTransfer')
    BEGIN
      --寄售转移
      INSERT INTO #InventoryDetail(BillNo,BillType,OperationType,FromDealerID,ToDealerID,FromWHMID,ToWHMID,LotID,PMAID,LtmID,Qty,FormId)
      SELECT @BillNo,@BillType,@OperationType,
             H.TH_DMA_ID_From,H.TH_DMA_ID_TO,C.TC_WHM_ID,null,c.TC_LOT_ID, P.PMA_ID, LT.LOT_LTM_ID,C.TC_QTY,D.TD_ID
        FROM Consignment.TransferHeader H(nolock), Consignment.TransferDetail D(nolock), Consignment.TransferConfirm C(nolock), Product P(nolock),LOT LT(nolock)
       WHERE H.TH_ID = D.TD_TH_ID and D.TD_ID = C.TC_TD_ID and C.TC_PMA_ID = P.PMA_ID and C.TC_LOT_ID = LT.LOT_ID
         and H.TH_No=@BillNo
    
    END
  
  
  
  --核对数据（如果数据不存在，需要报错）
  Declare @RowNum int
  SELECT @RowNum=COUNT(*) FROM #InventoryDetail
  
  SELECT * FROM #InventoryDetail
  
  IF @RowNum=0
    BEGIN
      --报错
      RAISERROR (N'单据数据不存在或不符合条件.', -- Message text,
                 10,                        -- Severity,
                 1,                         -- State,
                 N'RownNum',                 -- First argument.
                 0                          -- Second argument.
                ); 
      
    END
  
  ELSE
    BEGIN
        --先不控制From仓库是不是寄售仓库  
        --更新仓库（如果当前是在途的情况）
        IF @OperationType='Adjust'
          BEGIN
            --1、寄售退货、投诉退换货、更新FromWHM为经销商在途仓库，ToWHM不用更新，保持为null
            --2、寄售买断(CTS)，强制寄售买断(MCTS)，更新FromWHM为From经销商在途仓库，ToWHM为From经销商的主仓库
            --3、寄售销售不会存在在途的情况，忽略
            --4、寄售转移(ConsignTransfer)，更新FromWHM为From经销商在途仓库，ToWHM为To经销商的编号最大的波科寄售库
            IF @BillType IN ('ConsignReturn','ComplainReturn')
              BEGIN
                --获取经销商在途库
                UPDATE InvD SET InvD.FromWHMID = WH.WHM_ID 
                  FROM #InventoryDetail InvD, Warehouse WH(nolock)
                 WHERE InvD.FromDealerID = WH.WHM_DMA_ID
                   AND WH.WHM_Type = 'SystemHold'          
              END
            
            IF @BillType IN ('CTS','MCTS')
              BEGIN
                UPDATE InvD SET InvD.FromWHMID = WH.WHM_ID 
                  FROM #InventoryDetail InvD, Warehouse WH(nolock)
                 WHERE InvD.FromDealerID = WH.WHM_DMA_ID
                   AND WH.WHM_Type = 'SystemHold' 
                   
                UPDATE InvD SET InvD.ToWHMID = WH.WHM_ID 
                  FROM #InventoryDetail InvD, Warehouse WH(nolock)
                 WHERE InvD.FromDealerID = WH.WHM_DMA_ID
                   AND WH.WHM_Type = 'DefaultWH' 
              END
            
            IF @BillType IN ('ConsignTransfer')
              BEGIN
                UPDATE InvD SET InvD.FromWHMID = WH.WHM_ID 
                  FROM #InventoryDetail InvD, Warehouse WH(nolock)
                 WHERE InvD.FromDealerID = WH.WHM_DMA_ID
                   AND WH.WHM_Type = 'SystemHold' 
                
                UPDATE InvD SET InvD.ToWHMID = WH.WHM_ID 
                  FROM #InventoryDetail InvD, 
                       (select WHM_DMA_ID,max( WHM_Code) AS WHM_Code from Warehouse where WHM_Type in ('Borrow') group by WHM_DMA_ID) MaxWH,
                       warehouse WH(nolock)
                 WHERE InvD.ToDealerID = WH.WHM_DMA_ID
                   AND MaxWH.WHM_DMA_ID = WH.WHM_DMA_ID and MaxWH.WHM_Code = WH.WHM_Code
              END  
            
          END
        ELSE IF (@OperationType='Cancel')
          BEGIN
            --1、寄售退货、投诉退换货、更新ToWHM为From经销商的原仓库，FromWHM为From经销商的在途仓库
            --2、寄售买断(CTS)，强制寄售买断(MCTS)，更新ToWHM为From经销商的原仓库，FromWHM为From经销商的在途仓库
            --3、寄售销售不会存在在途的情况，也不存在Cancel的情况，忽略
            --4、寄售转移(ConsignTransfer)，更新ToWHM为From经销商的原仓库，FromWHM为From经销商的在途仓库
            IF @BillType IN ('ConsignReturn','ComplainReturn')
              BEGIN
                --获取经销商在途库
                UPDATE InvD SET InvD.FromWHMID = WH.WHM_ID 
                  FROM #InventoryDetail InvD, Warehouse WH(nolock)
                 WHERE InvD.FromDealerID = WH.WHM_DMA_ID
                   AND WH.WHM_Type = 'SystemHold'   
                   
                --获取经销商原仓库
                UPDATE InvD SET InvD.ToWHMID = Inv.Inv_WHM_ID 
                  FROM #InventoryDetail InvD, Lot LT(nolock), Inventory INV(nolock)
                 WHERE InvD.LotID = LT.Lot_ID and LT.LOT_INV_ID = INV.INV_ID
               
              END
            
            IF @BillType IN ('CTS','MCTS')
              BEGIN
                UPDATE InvD SET InvD.FromWHMID = WH.WHM_ID 
                  FROM #InventoryDetail InvD, Warehouse WH(nolock)
                 WHERE InvD.FromDealerID = WH.WHM_DMA_ID
                   AND WH.WHM_Type = 'SystemHold'
             
                --获取经销商原仓库
                UPDATE InvD SET InvD.ToWHMID = Inv.Inv_WHM_ID 
                  FROM #InventoryDetail InvD, Lot LT(nolock), Inventory INV(nolock)
                 WHERE InvD.LotID = LT.Lot_ID and LT.LOT_INV_ID = INV.INV_ID              
               
              END
            
            IF @BillType IN ('ConsignTransfer')
              BEGIN
                UPDATE InvD SET InvD.FromWHMID = WH.WHM_ID 
                  FROM #InventoryDetail InvD, Warehouse WH(nolock)
                 WHERE InvD.FromDealerID = WH.WHM_DMA_ID
                   AND WH.WHM_Type = 'SystemHold' 
                   
              --获取经销商原仓库
                UPDATE InvD SET InvD.ToWHMID = Inv.Inv_WHM_ID 
                  FROM #InventoryDetail InvD, Lot LT(nolock), Inventory INV(nolock)
                 WHERE InvD.LotID = LT.Lot_ID and LT.LOT_INV_ID = INV.INV_ID     
              END
              
          END
        ELSE IF (@OperationType='Frozen')
          BEGIN
            --1、寄售退货、投诉退换货、更新ToWHM为From经销商在途仓库
            --2、寄售买断(CTS)，强制寄售买断(MCTS)，更新ToWHM为From经销商在途仓库
            --3、寄售销售不会存在在途的情况，忽略
            --4、寄售转移(ConsignTransfer)，更新ToWHM为From经销商在途仓库
            IF @BillType IN ('ConsignReturn','ComplainReturn')
              BEGIN
                --获取经销商在途库
                UPDATE InvD SET InvD.ToWHMID = WH.WHM_ID 
                  FROM #InventoryDetail InvD, Warehouse WH(nolock)
                 WHERE InvD.FromDealerID = WH.WHM_DMA_ID
                   AND WH.WHM_Type = 'SystemHold'          
              END
            
            IF @BillType IN ('CTS','MCTS')
              BEGIN
                UPDATE InvD SET InvD.ToWHMID = WH.WHM_ID 
                  FROM #InventoryDetail InvD, Warehouse WH(nolock)
                 WHERE InvD.FromDealerID = WH.WHM_DMA_ID
                   AND WH.WHM_Type = 'SystemHold'
               
              END
            
            IF @BillType IN ('ConsignTransfer')
              BEGIN
                UPDATE InvD SET InvD.ToWHMID = WH.WHM_ID 
                  FROM #InventoryDetail InvD, Warehouse WH(nolock)
                 WHERE InvD.FromDealerID = WH.WHM_DMA_ID
                   AND WH.WHM_Type = 'SystemHold' 
              END
          
          END
          
          --仓库更新后，根据新的From仓库更新LotID                
          UPDATE InvD SET LotID = LT.LOT_ID
            FROM #InventoryDetail InvD,warehouse WH(nolock),Inventory Inv(nolock), Lot LT(nolock)
           WHERE InvD.FromDealerID = WH.WHM_DMA_ID and InvD.FromWHMID = WH.WHM_ID             
             and WH.WHM_ID = Inv.Inv_WHM_ID
             AND InvD.PMAID = Inv.Inv_PMA_ID and Inv.Inv_ID = LT.Lot_Inv_ID and LT.Lot_Ltm_ID = InvD.LtmID
          
          SELECT * from #InventoryDetail
          
          --更新库存
          --如果是冻结，则直接跟新
          --Inventory表，新增仓库中没有的物料，更新仓库中存在的物料数量
        	INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
        	SELECT sum(-QTY),NEWID(),FromWHMID,PMAID 
            FROM #InventoryDetail
           GROUP By FromWHMID,PMAID
        	
          INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
        	SELECT sum(QTY),NEWID(),ToWHMID,PMAID 
            FROM #InventoryDetail
           GROUP By ToWHMID,PMAID
            	
        	UPDATE Inventory 
             SET Inventory.INV_OnHandQuantity = Convert(decimal(18,2),Inventory.INV_OnHandQuantity)+Convert(decimal(18,2),TMP.INV_OnHandQuantity)
        	  FROM #tmp_inventory AS TMP
        	 WHERE Inventory.INV_WHM_ID = TMP.INV_WHM_ID
        	   AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID

        	INSERT INTO Inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)	
        	SELECT INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID
        	  FROM #tmp_inventory AS TMP	
        	 WHERE NOT EXISTS (SELECT 1 FROM Inventory INV WHERE INV.INV_WHM_ID = TMP.INV_WHM_ID AND INV.INV_PMA_ID = TMP.INV_PMA_ID)	

        	--Lot表，新增批次库存
        	INSERT INTO #tmp_lot (LOT_ID,LOT_INV_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty,BillNo,BillType,OperationType,FormID)
        	SELECT LotID,LT.Lot_Inv_ID,LTMID,FromWHMID,PMAID,'',-QTY ,InvD.BillNo,InvD.BillType,InvD.OperationType,InvD.FormID
            FROM #InventoryDetail InvD, Lot LT(nolock) 
            where InvD.LotID = LT.Lot_ID
          
          INSERT INTO #tmp_lot (LOT_ID,LOT_INV_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty,BillNo,BillType,OperationType,FormID)
        	SELECT newid(),null,LTMID,ToWHMID,PMAID,'',QTY  ,BillNo,BillType,OperationType,FormID
            FROM #InventoryDetail
              
        	--更新关联库存主键
        	UPDATE #tmp_lot SET LOT_INV_ID = INV.INV_ID
        	  FROM Inventory INV
        	 WHERE INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
        	   AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID
             AND LOT_INV_ID is null

        	--更新批次表，存在的更新，不存在的新增
        	 UPDATE Lot
              SET Lot.LOT_OnHandQty =
                       CONVERT (DECIMAL (18, 2), Lot.LOT_OnHandQty)
                     + CONVERT (DECIMAL (18, 2), TMP.LOT_OnHandQty)
             FROM #tmp_lot AS TMP
            WHERE     Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
                  AND Lot.LOT_INV_ID = TMP.LOT_INV_ID
                 
                  
                  
           INSERT INTO Lot (LOT_ID,
                            LOT_LTM_ID,
                            LOT_OnHandQty,
                            LOT_INV_ID)
              SELECT LOT_ID,
                     LOT_LTM_ID,
                     CONVERT (DECIMAL (18, 2), LOT_OnHandQty),
                     LOT_INV_ID
                FROM #tmp_lot AS TMP
               WHERE NOT EXISTS
                        (SELECT 1
                           FROM Lot (NOLOCK)
                          WHERE     Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
                                AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)
           
            
            --Inventory操作日志(收货)，加库存
               INSERT INTO #tmp_invtrans (ITR_Quantity,
                                          ITR_ID,
                                          ITR_ReferenceID,
                                          ITR_Type,
                                          ITR_WHM_ID,
                                          ITR_PMA_ID,
                                          ITR_UnitPrice,
                                          ITR_TransDescription)
                  
               SELECT sum(LOT_OnHandQty),NEWID (),FormId,BillType,LOT_WHM_ID,LOT_PMA_ID,0, BillNo + '-' + OperationType
                 FROM #tmp_lot group by LOT_WHM_ID,LOT_PMA_ID,BillType,OperationType,BillNo,FormId
                  
               --写入正式表        
               INSERT INTO InventoryTransaction (ITR_Quantity,
                                                 ITR_ID,
                                                 ITR_ReferenceID,
                                                 ITR_Type,
                                                 ITR_WHM_ID,
                                                 ITR_PMA_ID,
                                                 ITR_UnitPrice,
                                                 ITR_TransDescription,
                                                 ITR_TransactionDate)
                  SELECT ITR_Quantity,
                         ITR_ID,
                         ITR_ReferenceID,
                         ITR_Type,
                         ITR_WHM_ID,
                         ITR_PMA_ID,
                         ITR_UnitPrice,
                         ITR_TransDescription,
                         GETDATE ()
                    FROM #tmp_invtrans

               --Lot操作日志（收货），加库存
               INSERT INTO #tmp_invtranslot (ITL_Quantity,
                                             ITL_ID,
                                             ITL_LTM_ID,
                                             ITL_LotNumber,
                                             ITL_ITR_ID)
                 
                   SELECT LOT_OnHandQty,
                         NEWID(),
                         T.LOT_LTM_ID,
                         LM.LTM_LotNumber,                  
                         itr.ITR_ID
                    FROM #tmp_lot T, LotMaster LM,#tmp_invtrans itr
                    where T.LOT_LTM_ID = LM.LTM_ID AND T.FormId = itr.ITR_ReferenceID
                    
               
               
               --写入正式表
               INSERT INTO InventoryTransactionLot (ITL_Quantity,
                                                    ITL_ID,
                                                    ITL_ITR_ID,
                                                    ITL_LTM_ID,
                                                    ITL_LotNumber)
                  SELECT ITL_Quantity,
                         ITL_ID,
                         ITL_ITR_ID,
                         ITL_LTM_ID,
                         ITL_LotNumber
                    FROM #tmp_invtranslot
    END
  

	
	
	
	

												
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
