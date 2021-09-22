DROP view [interface].[V_I_OPS_DealerComplain]
GO



CREATE view [interface].[V_I_OPS_DealerComplain]
as
SELECT DC_ComplainNbr as 'Ͷ�ߵ���',DC_CreatedDate as 'Ͷ��ʱ��',DMA_SAP_Code as '�����̱��',SUBSOLDTONAME as '������',ParentName as '��Ӧƽ̨����',isnull(DISTRIBUTORCUSTOMER,'') as 'ҽԺ',ProductLineName as 'BU',UPN as '�ͺ�',LOT as '����',qrcode as '��ά��',max(ExpiredDate) as 'Ч��' ,ReturnNum as '����',isnull(PMA_UPN,'') as '����UPN',lot2 as '��������',qrcode2 as '���¶�ά��',isnull(NewExpiredDate,'') as '���²�ƷЧ��',case when isnull(WHMName,'') = '' then '���۵�ҽԺ' else WHMName end as '�ֿ�',isnull(WHMType,'') as '��Ʒ��Ȩ',isnull(DN2,'') AS 'DN��',DN as '��ʿ�ٿ�ѧȫ��Ͷ�ߺ�',ReturnType AS 'Ͷ������',VALUE1 as '״̬'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote = 'eWorkflow�ύͶ���˻�����') as '���Ʒ���Ͷ������'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote like 'eWorkflow�޸�״̬Ϊ:Ͷ����ȷ�ϣ��뷵��Ͷ�߲�Ʒ,Ͷ�ߺ�%') as '����QAͶ���ϱ�����'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote = 'eWorkflow�޸�״̬Ϊ��Ͷ�߲�Ʒ���յ�') as 'Ͷ�߲�Ʒ���յ�����'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote = 'eWorkflowȷ��Ͷ�߻�������') as 'BU/QA����ȷ��ʱ��'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote = 'eWorkflowȱ��') as '����ȷ�Ͽ���޷����������'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote in ('eWorkflow�޸�״̬Ϊ�����ƻ����ѷ���','eWorkflow�޸�״̬Ϊ�������ѻ�����ƽ̨/T1')) as '�����ѻ�����ƽ̨/T1'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote = 'eWorkflow���������') as '�������˿��ƽ̨/T1'
      ,(select max(pol_operdate) from PurchaseOrderLog where POL_POH_ID= DC_ID and POL_OperNote = 'ƽ̨ȷ���ѻ�����T2������˿�Э���T2') as 'ƽ̨ȷ���ѻ�����T2������˿�Э���T2'
	  ,EFINSTANCECODE
      FROM (
      SELECT DC.DC_ID,CONVERT(NVARCHAR(19),DC.DC_CreatedDate,121) DC_CreatedDate,'BSC' AS ComplainType,DC.DC_Status,DC.DC_CorpId,LI.IDENTITY_NAME,DC.DC_ComplainNbr,UPN,substring(LOT,1,charindex('@',lot,1)-1) as lot,substring(LOT,charindex('@',lot,1)+2,len(lot) -charindex('@',lot,1)-1) as qrcode,COMPLAINTID AS DN,CarrierNumber,DM2.DMA_ChineseName as ParentName,SUBSOLDTONAME AS CorpName,case when CONFIRMRETURNTYPE = 10 then '����' else case when CONFIRMRETURNTYPE = 11 then '�˿�' else 'ֻ�˲���' end end AS ReturnType,DM.DMA_SAP_Code,SUBSOLDTONAME,HOS_HospitalName as DISTRIBUTORCUSTOMER,ld.VALUE1,ReturnNum,DN as DN2,whm_name as WHMName,ld2.VALUE1 as WHMType,ProductLineName,
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
      SELECT DC.DC_ID,CONVERT(NVARCHAR(19),DC.DC_CreatedDate,121) DC_CreatedDate,'CRM' AS ComplainType,DC.DC_Status,DC.DC_CorpId,LI.IDENTITY_NAME,DC.DC_ComplainNbr,Model AS UPN,substring(LOT,1,charindex('@',lot,1)-1) as lot,substring(LOT,charindex('@',lot,1)+2,len(lot) -charindex('@',lot,1)-1) as qrcode,IAN AS DN,CarrierNumber,DM2.DMA_ChineseName as ParentName,SUBSOLDTONAME AS CorpName,case when CONFIRMRETURNTYPE = 1 then '����' else case when CONFIRMRETURNTYPE = 2 then '�˿�' else 'ֻ�˲���' end end AS ReturnType,DM.DMA_SAP_Code,SUBSOLDTONAME,HOS_HospitalName as DISTRIBUTORCUSTOMER,ld.VALUE1,Returned,DN,whm_name as WHMName,ld2.VALUE1 as WHMType,'������ɹ���',
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


