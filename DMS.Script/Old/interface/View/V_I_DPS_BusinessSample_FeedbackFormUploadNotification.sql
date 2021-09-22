DROP view [interface].[V_I_DPS_BusinessSample_FeedbackFormUploadNotification] 
GO

CREATE view [interface].[V_I_DPS_BusinessSample_FeedbackFormUploadNotification] As
SELECT Tab.ApplyUserAccount, Tab.UserName, Tab.UserEmail, Tab.ApplyNo, Tab.Qty, Tab.OverdueDays, Tab.AlertDate,
       CASE WHEN Tab.OverdueDays >= 60 THEN '根据公司合规要求，您申请的商业样品（单号：'+ApplyNo+'）在发货后60天内('+ convert(nvarchar(10),dateadd( day ,60, PRH_SAPShipmentDate),120)  +'之前)还有产品未及时上传评估单，您的商业样品申请权限已被关闭，请及时上传，上传后7天系统会自动开放申请权限。' 
       ELSE '根据公司合规要求，您申请的商业样品（单号：'+ApplyNo+'）需要在'+ convert(nvarchar(10),dateadd( day ,60, PRH_SAPShipmentDate),120)  +'之前上传评估单，如逾期不上传，将暂停样品的申请权限，并通知BU负责人。请按时在微信企业号的商业样品模块中拍照上传。'
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
	       CASE WHEN E.SampleType='商业样品' or A.PRH_Status='Complete' then SUM(C.PRL_ReceiptQty) else 0 end AS ReciveQuantity
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
         AND E.SampleType ='商业样品'
		     AND e.ApplyUserId not in ('1541009','1535482','1071881','1109746','1066617','1107896')  --李泽章先不处理,其他已离职或提出离职的也不处理
         AND case when ApplyPurpose in ('产品演示或捐赠','捐赠','CRM手术辅助') 
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


