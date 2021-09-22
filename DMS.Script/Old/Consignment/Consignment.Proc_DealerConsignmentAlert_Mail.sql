DROP PROCEDURE [Consignment].[Proc_DealerConsignmentAlert_Mail]
GO

CREATE Procedure [Consignment].[Proc_DealerConsignmentAlert_Mail](@RtnVal NVARCHAR(20) OUTPUT ,@RtnMsg NVARCHAR(1000) OUTPUT)
AS
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
  SET @RtnVal = 'Success'
	SET @RtnMsg = ''
  
	CREATE TABLE #TMPROW
	(
		ROWVALUE NVARCHAR(MAX)
	)
	
  DECLARE @iReturn NVARCHAR(MAX) 
	DECLARE @SQL NVARCHAR(MAX) 
	DECLARE @iColumnName NVARCHAR(100);
	DECLARE @iColumnString NVARCHAR(MAX);
	DECLARE @iColumnRow NVARCHAR(MAX);

	--按照经销商、产品线遍历 
	declare @DealerCode nvarchar(200) 
  declare @DealerName nvarchar(200) 
  declare @DealerType nvarchar(200)
  declare @PDealerName nvarchar(200)
  declare @WhmName nvarchar(200)
	declare @UPN nvarchar(200) 
	declare @LotNumber nvarchar(200) 
	declare @QrCode nvarchar(200) 
  declare @ExpDate nvarchar(10) 
	declare @Remark nvarchar(200) 
	declare @Days nvarchar(200)
  declare @Qty decimal(18,2)
	
  Create table #tmp_QRConsignmentDay
  (
    QRC_DMA_ID uniqueidentifier not null,
    QRC_SAPShipmentID nvarchar(50) collate Chinese_PRC_CI_AS not null,
    QRC_PMA_ID uniqueidentifier not null,
    QRC_Lot nvarchar(50) collate Chinese_PRC_CI_AS null,
    QRC_QRCode nvarchar(50) collate Chinese_PRC_CI_AS null,
    QRC_ConsignmentEndDate datetime null,
    QRC_ApplyAccount nvarchar(20) null,  
    QRC_ContractEndDate datetime null,
    QRC_ConsignApplyEndDate datetime null
  )
	
  create table #tmp_CTOS
  (
  	DmaId uniqueidentifier not null,
    DmaName nvarchar(200) collate Chinese_PRC_CI_AS null,
    DmaCode nvarchar(20) collate Chinese_PRC_CI_AS null,
    DmaType nvarchar(20) collate Chinese_PRC_CI_AS null,
    ParentDmaId uniqueidentifier null,    
    PDMAName nvarchar(200) collate Chinese_PRC_CI_AS null,
    PDMACode nvarchar(200) collate Chinese_PRC_CI_AS null,
  	WhmId uniqueidentifier null,
    WhmName nvarchar(50) collate Chinese_PRC_CI_AS null,
  	ProductLineId uniqueidentifier null,
  	PmaId uniqueidentifier null,
    CfnId uniqueidentifier null,
    UPN nvarchar(50) collate Chinese_PRC_CI_AS null,
  	LotId uniqueidentifier null,
  	LotNumber nvarchar(50) collate Chinese_PRC_CI_AS null,
    QrCode nvarchar(50) collate Chinese_PRC_CI_AS null,
  	ExpiredDate datetime null,
  	Qty decimal(18,2) null,
  	IadId uniqueidentifier null,
  	IalId  uniqueidentifier null,
    UnitPrice decimal(18,2) null,
    ApplyAccount nvarchar(20) collate Chinese_PRC_CI_AS null,
    Remark nvarchar(50) null,
    AlertDays int null
  )
  
  BEGIN
  
  Insert into #tmp_QRConsignmentDay(QRC_DMA_ID,QRC_SAPShipmentID,QRC_PMA_ID,QRC_Lot,QRC_QRCode,QRC_ConsignmentEndDate,QRC_ApplyAccount,QRC_ContractEndDate,QRC_ConsignApplyEndDate)
  SELECT PRH.PRH_Dealer_DMA_ID,PRH.PRH_SAPShipmentID, PR.POR_SAP_PMA_ID, 
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
  END  
  
  
  
  --查询波科物权的产品到期的(查询仓库类型为Consignment、Borrow)  
  --寄售产品过有效期的
  insert into #tmp_CTOS(DmaId,DmaName,DmaCode,DmaType,ParentDmaId,PDMAName,PDMACode,WhmId,WhmName,ProductLineId,PmaId,UPN,LotId,LotNumber,QrCode,ExpiredDate,Qty,CfnId,ApplyAccount,Remark,AlertDays)
  select DM.DMA_ID,DM.DMA_ChineseName,DM.DMA_SAP_Code,DM.DMA_DealerType,DM.DMA_Parent_DMA_ID ,DMP.DMA_ChineseName AS PDMAName,DMP.DMA_SAP_Code,
         WHM_ID,WHM_Name,CFN_ProductLine_BUM_ID,PMA_ID,CFN.CFN_CustomerFaceNbr,LOT_ID,LTM_LotNumber , LTM_QRCode,LTM_ExpiredDate,LOT_OnHandQty ,CFN_ID, QRCD.QRC_ApplyAccount,'产品过有效期',DATEDIFF(day,getdate(),LTM_ExpiredDate)
  from DealerMaster AS DM(nolock),Warehouse(nolock),Inventory(nolock),Product(nolock),CFN(nolock),Lot(nolock),v_LotMaster(nolock),#tmp_QRConsignmentDay AS QRCD,DealerMaster AS DMP(nolock)
  where DM.DMA_ID = WHM_DMA_ID
    and WHM_ID = INV_WHM_ID
    and INV_ID = LOT_INV_ID
    and INV_PMA_ID = PMA_ID
    and PMA_CFN_ID = CFN_ID
    and LOT_LTM_ID = LTM_ID
    AND LTM_QRCode = QRCD.QRC_QRCode
    And DMP.DMA_ID = DM.DMA_Parent_DMA_ID
    AND LTM_LotNumber = QRCD.QRC_Lot
    and WHM_Type in ('Consignment','Borrow')
    and LTM_LotNumber <> 'NoQR'
    and LOT_OnHandQty > 0
    and DATEDIFF(day,getdate(),LTM_ExpiredDate) <= 15     
  
  --根据二维码查找最近一次KB订单，查找对应的寄售日期和寄售合同
  insert into #tmp_CTOS(DmaId,DmaName,DmaCode,DmaType,ParentDmaId,PDMAName,PDMACode,WhmId,WhmName,ProductLineId,PmaId,UPN,LotId,LotNumber,QrCode,ExpiredDate,Qty,CfnId,ApplyAccount,Remark,AlertDays)
  select DM.DMA_ID,DM.DMA_ChineseName,DM.DMA_SAP_Code,DM.DMA_DealerType,DM.DMA_Parent_DMA_ID ,DMP.DMA_ChineseName AS PDMAName,DMP.DMA_SAP_Code,
         WHM_ID,WHM_Name,CFN_ProductLine_BUM_ID,PMA_ID,CFN.CFN_CustomerFaceNbr,LOT_ID,LTM_LotNumber , LTM_QRCode,LTM_ExpiredDate,LOT_OnHandQty ,CFN_ID, QRCD.QRC_ApplyAccount, 
         CASE WHEN QRC_ConsignmentEndDate= QRC_ContractEndDate THEN '寄售合同到期' WHEN QRC_ConsignmentEndDate = QRC_ConsignApplyEndDate THEN '寄售天数到期' ELSE '' END ,DATEDIFF(day,getdate(),QRCD.QRC_ConsignmentEndDate)
  from DealerMaster AS DM(nolock),Warehouse(nolock),Inventory(nolock),Product(nolock),CFN(nolock),Lot(nolock),v_LotMaster(nolock),#tmp_QRConsignmentDay AS QRCD,DealerMaster AS DMP(nolock)
  where DM.DMA_ID = WHM_DMA_ID
    and WHM_ID = INV_WHM_ID
    and INV_ID = LOT_INV_ID
    and INV_PMA_ID = PMA_ID
    and PMA_CFN_ID = CFN_ID
    and LOT_LTM_ID = LTM_ID
    AND LTM_QRCode = QRCD.QRC_QRCode
    AND PMA_ID = QRCD.QRC_PMA_ID
    AND DM.DMA_ID = QRCD.QRC_DMA_ID
    AND LTM_LotNumber = QRCD.QRC_Lot
    And DMP.DMA_ID = DM.DMA_Parent_DMA_ID
    and WHM_Type in ('Consignment','Borrow')
    and LTM_LotNumber <> 'NoQR'
    and LOT_OnHandQty > 0
    and DATEDIFF(day,getdate(),QRCD.QRC_ConsignmentEndDate) <= 15
    AND not exists (select 1 from #tmp_CTOS CTOS where CTOS.DmaId = DM.Dma_Id and CTOS.LotId = Lot.LOT_ID  )
  
 

	DECLARE cur cursor FOR select distinct DmaCode from #tmp_CTOS --select DmaName,DmaCode,DmaType,PDMAName,WhmName,UPN,LotNumber,QrCode,Convert(nvarchar(10),ExpiredDate,120),Qty,Remark,AlertDays from #tmp_CTOS
	OPEN cur
    FETCH NEXT FROM cur INTO @DealerCode
      
    WHILE @@FETCH_STATUS = 0
    BEGIN
		
  		SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
  		
  		SET @iReturn += '<table class="gridtable">'
  		
  		SET @iReturn += '<tr>'
  		SET @iColumnString = '''<tr>'''

  		SET @iReturn += '<th>经销商名称</th><th>经销商编号</th><th>经销商类型</th><th>上级经销商名称</th><th>仓库名称</th><th>UPN</th><th>批号</th><th>二维码</th><th>产品有效期</th><th>数量</th><th>备注</th><th>到期天数</th>'
  		SET @iColumnString += '+''<td>''+ISNULL(CONVERT(NVARCHAR(MAX),[DmaName]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[DmaCode]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[DmaType]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[PDMAName]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[WhmName]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[UPN]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[LotNumber]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[QrCode]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(10),[ExpiredDate],120),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[Qty]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[Remark]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[AlertDays]),'''')+''</td>'''
  		
  		SET @iReturn += '</tr>'
  		SET @iColumnString += '+''</tr>'''
  		
  		SET @SQL = 'INSERT INTO #TMPROW(ROWVALUE) SELECT '+@iColumnString+' FROM #tmp_CTOS WHERE DmaCode =''' + @DealerCode  + ''' OR PDMACode =''' + @DealerCode  + ''''
  		print @SQL;
  		EXEC(@SQL) 
  	
  		DECLARE @iCURSOR_ROW CURSOR;
  		SET @iCURSOR_ROW = CURSOR FOR SELECT ROWVALUE FROM #TMPROW
  		OPEN @iCURSOR_ROW 	
  		FETCH NEXT FROM @iCURSOR_ROW INTO @iColumnRow
  		WHILE @@FETCH_STATUS = 0
  		BEGIN
  			SET @iReturn += @iColumnRow
  			
  			FETCH NEXT FROM @iCURSOR_ROW INTO @iColumnRow
  		END	
  		CLOSE @iCURSOR_ROW
  		DEALLOCATE @iCURSOR_ROW
  		SET @iReturn += '</table>'
		
		
		
		
		  INSERT INTO MailMessageQueue
           SELECT newid(),'email','',t4.EMAIL1,MMT_Subject,
                   replace(MMT_Body,'{#CfnList}',@iReturn) AS MMT_Body,
                   'Waiting',getdate(),null
             from dealermaster t2, MailMessageTemplate t3,Lafite_IDENTITY t4
            where  t2.DMA_SAP_Code = @DealerCode
				and t2.DMA_SAP_Code +'_01' = t4.IDENTITY_CODE
              and t3.MMT_Code='EMAIL_CONSIGNMENTTOSELLING_ALERT'
              and ISNULL(t4.EMAIL1,'') <> ''
		
    	DELETE FROM #TMPROW
    	
    	FETCH NEXT FROM cur INTO @DealerCode
    	END

  CLOSE cur
  DEALLOCATE cur

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

    	

GO