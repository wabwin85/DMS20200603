DROP view [dbo].[V_NormalSample_DailyAlertDetail]
GO




CREATE view [dbo].[V_NormalSample_DailyAlertDetail]
AS
select ApplyUserId AS ApplyUserAccount, sales.Name AS UserName,sales.Email AS UserEmail,sales.ParentUserAccount,
(select Email from interface.T_I_QV_SalesRep where UserAccount= sales.ParentUserAccount) AS ParentUserEmail,
ApplyNo, UpnNO AS UPN, Lot,
sum(isnull(DeliveryQuantity,0)) - sum(isnull(EvalQuantity,0)) - sum(isnull(ReturnQuantity,0)) AS Qty,'30' AS AlertDays
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
		   and e.ApplyDate>'2016-01-01'	
		   and e.ApplyUserId not in ('1541009','1535482','1071881','1109746','1066617','1107896')  --李泽章先不处理,其他已离职或提出离职的也不处理
           and case when ApplyPurpose in ('产品演示或捐赠','捐赠','CRM手术辅助') 
                       or F.UpnNo in (SELECT Value1 
                                        FROM [dbo].Lafite_DICT 
                                       WHERE dict_type='CONST_Sample_CrmUpn') then 'No' else 'Yes' end = 'Yes'
	GROUP BY E.SampleApplyHeadId,E.ApplyUserId,E.ApplyNo, D.PMA_UPN, C.PRL_LotNumber, F.ProductName, F.ProductDesc,E.SampleType,A.PRH_Status
	) tab
	) resultTab inner join interface.T_I_QV_SalesRep as sales on (resultTab.ApplyUserId = sales.UserAccount)
	   where isnull(DeliveryQuantity,0) - isnull(EvalQuantity,0) - isnull(ReturnQuantity,0)>0
	     and DATEDIFF ( day , PRH_SAPShipmentDate , getdate() )=30
group by ApplyUserId, sales.Name,sales.Email,sales.ParentUserAccount, ApplyNo, UpnNO, Lot

union
select ApplyUserId, sales.Name,sales.Email,sales.ParentUserAccount,
(select Email from interface.T_I_QV_SalesRep where UserAccount= sales.ParentUserAccount) AS ParentUserEmail,ApplyNo, UpnNO, Lot,
sum(isnull(DeliveryQuantity,0)) - sum(isnull(EvalQuantity,0)) - sum(isnull(ReturnQuantity,0)) AS Qty,'55'
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
		   max(A.PRH_SAPShipmentDate) As PRH_SAPShipmentDate,
	       SUM(C.PRL_ReceiptQty) DeliveryQuantity,
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
		   and e.ApplyDate>'2016-01-01'	
		   and e.ApplyUserId not in ('1541009','1535482','1071881','1109746','1066617','1107896')  --李泽章先不处理,其他已离职或提出离职的也不处理
           and case when ApplyPurpose in ('产品演示或捐赠','捐赠','CRM手术辅助') 
                       or F.UpnNo in (SELECT Value1 
                                        FROM [dbo].Lafite_DICT 
                                       WHERE dict_type='CONST_Sample_CrmUpn') then 'No' else 'Yes' end = 'Yes'
	GROUP BY E.SampleApplyHeadId,E.ApplyUserId,E.ApplyNo, D.PMA_UPN, C.PRL_LotNumber, F.ProductName,F.ProductDesc,E.SampleType,A.PRH_Status
	) tab
	) resultTab inner join interface.T_I_QV_SalesRep as sales on (resultTab.ApplyUserId = sales.UserAccount)
	   where isnull(DeliveryQuantity,0) - isnull(EvalQuantity,0) - isnull(ReturnQuantity,0)>0
	     and DATEDIFF ( day , PRH_SAPShipmentDate , getdate() )=55
group by ApplyUserId, sales.Name,sales.Email,sales.ParentUserAccount, ApplyNo, UpnNO, Lot
union
select ApplyUserId, sales.Name,sales.Email,sales.ParentUserAccount,
(select Email from interface.T_I_QV_SalesRep where UserAccount= sales.ParentUserAccount) AS ParentUserEmail,ApplyNo, UpnNO, Lot,
sum(isnull(DeliveryQuantity,0)) - sum(isnull(EvalQuantity,0)) - sum(isnull(ReturnQuantity,0)) AS Qty,'60'
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
		   max(A.PRH_SAPShipmentDate) As PRH_SAPShipmentDate,
	       SUM(C.PRL_ReceiptQty) DeliveryQuantity,
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
		   and e.ApplyDate>'2016-01-01'	
		   and e.ApplyUserId not in ('1541009','1535482','1071881','1109746','1066617','1107896')  --李泽章先不处理,其他已离职或提出离职的也不处理
           and case when ApplyPurpose in ('产品演示或捐赠','捐赠','CRM手术辅助') 
                       or F.UpnNo in (SELECT Value1 
                                        FROM [dbo].Lafite_DICT 
                                       WHERE dict_type='CONST_Sample_CrmUpn') then 'No' else 'Yes' end = 'Yes'
	GROUP BY E.SampleApplyHeadId,E.ApplyUserId,E.ApplyNo, D.PMA_UPN, C.PRL_LotNumber, F.ProductName,F.ProductDesc,E.SampleType,A.PRH_Status
	) tab
	) resultTab inner join interface.T_I_QV_SalesRep as sales on (resultTab.ApplyUserId = sales.UserAccount)
	   where isnull(DeliveryQuantity,0) - isnull(EvalQuantity,0) - isnull(ReturnQuantity,0)>0
	     and DATEDIFF ( day , PRH_SAPShipmentDate , getdate() )=60
group by ApplyUserId, sales.Name,sales.Email,sales.ParentUserAccount, ApplyNo, UpnNO, Lot



GO


