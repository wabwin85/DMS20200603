DROP view [interface].[V_I_DPS_BusinessSample_FeedbackFormUploadNotification] 
GO

CREATE view [interface].[V_I_DPS_BusinessSample_FeedbackFormUploadNotification] As
SELECT Tab.ApplyUserAccount, Tab.UserName, Tab.UserEmail, Tab.ApplyNo, Tab.Qty, Tab.OverdueDays, Tab.AlertDate,
       CASE WHEN Tab.OverdueDays >= 60 THEN '���ݹ�˾�Ϲ�Ҫ�����������ҵ��Ʒ�����ţ�'+ApplyNo+'���ڷ�����60����('+ convert(nvarchar(10),dateadd( day ,60, PRH_SAPShipmentDate),120)  +'֮ǰ)���в�Ʒδ��ʱ�ϴ���������������ҵ��Ʒ����Ȩ���ѱ��رգ��뼰ʱ�ϴ����ϴ���7��ϵͳ���Զ���������Ȩ�ޡ�' 
       ELSE '���ݹ�˾�Ϲ�Ҫ�����������ҵ��Ʒ�����ţ�'+ApplyNo+'����Ҫ��'+ convert(nvarchar(10),dateadd( day ,60, PRH_SAPShipmentDate),120)  +'֮ǰ�ϴ��������������ڲ��ϴ�������ͣ��Ʒ������Ȩ�ޣ���֪ͨBU�����ˡ��밴ʱ��΢����ҵ�ŵ���ҵ��Ʒģ���������ϴ���'
       END AS Notification
FROM (
select ApplyUserId AS ApplyUserAccount, sales.Name AS UserName,sales.Email AS UserEmail, 
ApplyNo, sum(isnull(DeliveryQuantity,0)) - sum(isnull(EvalQuantity,0)) - sum(isnull(ReturnQuantity,0)) AS Qty, 
DATEDIFF ( day , min(PRH_SAPShipmentDate) , getdate() ) AS OverdueDays,
dateadd( day ,60, min(PRH_SAPShipmentDate)) AS AlertDate,
min(PRH_SAPShipmentDate) AS PRH_SAPShipmentDate
from 
(
select tab.*, EvalQuantity = ( 
	           SELECT COUNT(*)
	           FROM   SampleEval B
	           WHERE  tab.UpnNo = B.UpnNo
	                  AND tab.Lot = B.Lot
	                  AND B.SampleHeadId = tab.SampleApplyHeadId
	       ),
	       ReturnQuantity = (
	           SELECT ISNULL(SUM(B.ApplyQuantity), 0)
	           FROM   SampleUpn B,
	                  SampleReturnHead C
	           WHERE  tab.UpnNo = B.UpnNo
	                  AND tab.Lot = B.Lot
	                  AND C.ApplyNo = tab.ApplyNo
	                  AND B.SampleHeadId = C.SampleReturnHeadId
	                  AND C.ReturnStatus <> 'Deny'
	       ) from (
SELECT     E.SampleApplyHeadId,
           E.ApplyUserId,
           E.ApplyNo,
           D.PMA_UPN UpnNo,
	       C.PRL_LotNumber Lot,
	       F.ProductName,
	       F.ProductDesc,
		   max(A.PRH_SAPShipmentDate) AS PRH_SAPShipmentDate,
	       SUM(C.PRL_ReceiptQty) AS DeliveryQuantity,
	       CASE WHEN E.SampleType='��ҵ��Ʒ' or A.PRH_Status='Complete' then SUM(C.PRL_ReceiptQty) else 0 end AS ReciveQuantity
	FROM   POReceiptHeader_SAPNoQR A(nolock),
	       POReceipt_SAPNoQR B(nolock),
	       POReceiptLot_SAPNoQR C(nolock),
	       Product D(nolock),
	       SampleApplyHead E(nolock),
	       SampleUpn F(nolock)
	WHERE  A.PRH_ID = B.POR_PRH_ID
	       AND B.POR_ID = C.PRL_POR_ID
	       AND B.POR_SAP_PMA_ID = D.PMA_ID
	       AND A.PRH_PurchaseOrderNbr = E.ApplyNo
	       AND E.SampleApplyHeadId = F.SampleHeadId
	       AND D.PMA_UPN = F.UpnNo
		     AND e.ApplyDate>'2016-01-01'
         AND E.SampleType ='��ҵ��Ʒ'
		     AND e.ApplyUserId not in ('1541009','1535482','1071881','1109746','1066617','1107896')  --�������Ȳ�����,��������ְ�������ְ��Ҳ������
         AND case when ApplyPurpose in ('��Ʒ��ʾ�����','����','CRM��������') 
                       or F.UpnNo in (SELECT Value1 
                                        FROM [dbo].Lafite_DICT 
                                       WHERE dict_type='CONST_Sample_CrmUpn') then 'No' else 'Yes' end = 'Yes'
	GROUP BY E.SampleApplyHeadId,E.ApplyUserId,E.ApplyNo, D.PMA_UPN, C.PRL_LotNumber, F.ProductName, F.ProductDesc,E.SampleType,A.PRH_Status
	) tab
	) resultTab inner join interface.T_I_QV_SalesRep as sales on (resultTab.ApplyUserId = sales.UserAccount)
	   where isnull(DeliveryQuantity,0) - isnull(EvalQuantity,0) - isnull(ReturnQuantity,0)>0
	     --and DATEDIFF ( day , PRH_SAPShipmentDate , getdate() )<=60 
       and DATEDIFF ( day , PRH_SAPShipmentDate , getdate() )>30
group by ApplyUserId, sales.Name,sales.Email, ApplyNo
) Tab
GO


