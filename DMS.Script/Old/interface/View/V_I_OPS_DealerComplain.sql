DROP view [interface].[V_I_OPS_DealerComplain]
GO



CREATE view [interface].[V_I_OPS_DealerComplain]
as
SELECT DC_ComplainNbr as '投诉单号',DC_CreatedDate as '投诉时间',DMA_SAP_Code as '经销商编号',SUBSOLDTONAME as '经销商',ParentName as '对应平台名称',isnull(DISTRIBUTORCUSTOMER,'') as '医院',ProductLineName as 'BU',UPN as '型号',LOT as '批次',qrcode as '二维码',max(ExpiredDate) as '效期' ,ReturnNum as '数量',isnull(PMA_UPN,'') as '换新UPN',lot2 as '换新批次',qrcode2 as '换新二维码',isnull(NewExpiredDate,'') as '换新产品效期',case when isnull(WHMName,'') = '' then '销售到医院' else WHMName end as '仓库',isnull(WHMType,'') as '产品物权',isnull(DN2,'') AS 'DN号',DN as '波士顿科学全球投诉号',ReturnType AS '投诉类型',VALUE1 as '状态'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote = 'eWorkflow提交投诉退货申请') as '波科发起投诉日期'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote like 'eWorkflow修改状态为:投诉已确认，请返回投诉产品,投诉号%') as '波科QA投诉上报日期'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote = 'eWorkflow修改状态为：投诉产品已收到') as '投诉产品已收到日期'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote = 'eWorkflow确认投诉换货类型') as 'BU/QA最终确认时间'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote = 'eWorkflow缺货') as '波科确认库存无法满足的日期'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote in ('eWorkflow修改状态为：波科货物已发送','eWorkflow修改状态为：波科已换货给平台/T1')) as '波科已换货给平台/T1'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote = 'eWorkflow已完成审批') as '波科已退款给平台/T1'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote = '平台确认已换货给T2或寄送退款协议给T2') as '平台确认已换货给T2或寄送退款协议给T2'
	  ,EFINSTANCECODE
      FROM (
      SELECT DC.DC_ID,CONVERT(NVARCHAR(19),DC.DC_CreatedDate,121) DC_CreatedDate,'BSC' AS ComplainType,DC.DC_Status,DC.DC_CorpId,LI.IDENTITY_NAME,DC.DC_ComplainNbr,UPN,substring(LOT,1,charindex('@',lot,1)-1) as lot,substring(LOT,charindex('@',lot,1)+2,len(lot) -charindex('@',lot,1)-1) as qrcode,COMPLAINTID AS DN,CarrierNumber,DM2.DMA_ChineseName as ParentName,SUBSOLDTONAME AS CorpName,case when CONFIRMRETURNTYPE = 10 then '换货' else case when CONFIRMRETURNTYPE = 11 then '退款' else '只退不换' end end AS ReturnType,DM.DMA_SAP_Code,SUBSOLDTONAME,HOS_HospitalName as DISTRIBUTORCUSTOMER,ld.VALUE1,ReturnNum,DN as DN2,whm_name as WHMName,ld2.VALUE1 as WHMType,ProductLineName,
      PMA_UPN,case when ISNULL(PRL_LotNumber,'') <> '' then substring(PRL_LotNumber,1,charindex('@',PRL_LotNumber,1)-1) else '' end as lot2,case when ISNULL(PRL_LotNumber,'') <> '' then substring(PRL_LotNumber,charindex('@',PRL_LotNumber,1)+2,len(PRL_LotNumber) -charindex('@',PRL_LotNumber,1)-1) else '' end as qrcode2,LTM_ExpiredDate as ExpiredDate,DM2.DMA_ID as ParentID,PRL_ExpiredDate as NewExpiredDate
      ,DC.EFINSTANCECODE
	  FROM   DealerComplain DC
      inner join DealerMaster DM on DC.DC_CorpId = DM.DMA_ID
      inner join DealerMaster DM2 on DM.DMA_Parent_DMA_ID = DM2.DMA_ID
      inner join Lafite_DICT LD on DC_Status = LD.DICT_KEY
      inner join Lafite_IDENTITY LI on DC.DC_CreatedBy = LI.Id
      inner join CFN on UPN = CFN_CustomerFaceNbr
      inner join V_DivisionProductLineRelation vd on CFN_ProductLine_BUM_ID = ProductLineID
      left join Hospital on DC.DISTRIBUTORCUSTOMER = HOS_Key_Account
      inner join LotMaster on LOT = LTM_LotNumber
      left join Warehouse w on w.WHM_ID = dc.WHM_ID
      left join Lafite_DICT ld2 on w.WHM_Type = ld2.DICT_KEY and  ld2.DICT_TYPE='MS_WarehouseType'
      left join POReceiptHeader PRH on CASE WHEN dc.DN is null or dc.DN='' then 'NoDN' ELSE dc.DN END = PRH_SAPShipmentID
      left join POReceipt por on PRH_ID = por.POR_PRH_ID
      left join POReceiptLot on POR_ID = PRL_POR_ID
      left join Product on POR_SAP_PMA_ID = PMA_ID
      WHERE ld.DICT_TYPE = 'CONST_QAComplainReturn_Status'
      union
      SELECT DC.DC_ID,CONVERT(NVARCHAR(19),DC.DC_CreatedDate,121) DC_CreatedDate,'CRM' AS ComplainType,DC.DC_Status,DC.DC_CorpId,LI.IDENTITY_NAME,DC.DC_ComplainNbr,Model AS UPN,substring(LOT,1,charindex('@',lot,1)-1) as lot,substring(LOT,charindex('@',lot,1)+2,len(lot) -charindex('@',lot,1)-1) as qrcode,IAN AS DN,CarrierNumber,DM2.DMA_ChineseName as ParentName,SUBSOLDTONAME AS CorpName,case when CONFIRMRETURNTYPE = 1 then '换货' else case when CONFIRMRETURNTYPE = 2 then '退款' else '只退不换' end end AS ReturnType,DM.DMA_SAP_Code,SUBSOLDTONAME,HOS_HospitalName as DISTRIBUTORCUSTOMER,ld.VALUE1,Returned,DN,whm_name as WHMName,ld2.VALUE1 as WHMType,'心脏节律管理',
      PMA_UPN,case when ISNULL(PRL_LotNumber,'') <> '' then substring(PRL_LotNumber,1,charindex('@',PRL_LotNumber,1)-1) else '' end as lot2,case when ISNULL(PRL_LotNumber,'') <> '' then substring(PRL_LotNumber,charindex('@',PRL_LotNumber,1)+2,len(PRL_LotNumber) -charindex('@',PRL_LotNumber,1)-1) else '' end as qrcode2,LTM_ExpiredDate as ExpiredDate,DM2.DMA_ID as ParentID,PRL_ExpiredDate as NewExpiredDate
      ,DC.EFINSTANCECODE
	  FROM DealerComplainCRM DC
      inner join DealerMaster DM on DC.DC_CorpId = DM.DMA_ID
      inner join DealerMaster DM2 on DM.DMA_Parent_DMA_ID = DM2.DMA_ID
      inner join Lafite_DICT LD on DC_Status = LD.DICT_KEY
      inner join Lafite_IDENTITY LI on DC.DC_CreatedBy = LI.Id
      left join Hospital on DC.DISTRIBUTORCUSTOMER = HOS_Key_Account
      inner join LotMaster on LOT = LTM_LotNumber
      left join Warehouse w on w.WHM_ID = dc.WHMID
      left join Lafite_DICT ld2 on w.WHM_Type = ld2.DICT_KEY and  ld2.DICT_TYPE='MS_WarehouseType'
      left join POReceiptHeader PRH on CASE WHEN dc.DN is null or dc.DN='' then 'NoDN' ELSE dc.DN END = PRH_SAPShipmentID
      left join POReceipt por on PRH_ID = por.POR_PRH_ID
      left join POReceiptLot on POR_ID = PRL_POR_ID
      left join Product on POR_SAP_PMA_ID = PMA_ID
      where ld.DICT_TYPE = 'CONST_QAComplainReturn_Status') A
      group by DC_ID,DC_ComplainNbr ,DC_CreatedDate ,DMA_SAP_Code,SUBSOLDTONAME ,ParentName,DISTRIBUTORCUSTOMER,ProductLineName,UPN ,LOT,qrcode ,ReturnNum,PMA_UPN,lot2 ,qrcode2 ,NewExpiredDate, WHMName ,WHMType,DN2,DN ,ReturnType ,VALUE1, A.EFINSTANCECODE


GO


