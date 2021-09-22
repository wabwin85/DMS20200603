DROP view [dbo].[interfaceDailyErrorMessage]
GO


CREATE view [dbo].[interfaceDailyErrorMessage] AS 
select interfaceType,ErrDesc,il_clientID,IL_Name,Convert(nvarchar(10),dateadd(day,-1,getdate()),112) AS ErrorDate from ( 
select distinct tab.InterfaceType,ErrDesc,IL.IL_ClientID,IL.IL_Name--,IL.IL_StartTime
from 
(
select distinct DNL_BatchNbr AS BacthNo,'平台发货数据上传' AS InterfaceType,DNL_DeliveryNoteNbr ErrDesc from DeliveryNote  where DNL_ProblemDescription is not null and convert(nvarchar(8), DNL_HandleDate ,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct TNL_BatchNbr,'移库操作',TNL_ArticleNumber  from TransferNote where TNL_ProblemDescription is not null and convert(nvarchar(8), TNL_HandleDate ,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct SNL_BatchNbr,'平台销量医院上传',SNL_HospitalName+'-'+SNL_ArticleNumber from SalesNote where SNL_ProblemDescription is not null and convert(nvarchar(8), SNL_HandleDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct DC_BatchNbr,'平台收货确认', DC_SapDeliveryNo from DeliveryConfirmation where DC_ProblemDescription is not null and convert(nvarchar(8), DC_HandleDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct IDC_BatchNbr,'平台退货确认',IDC_ReturnNo from InterfaceDealerReturnConfirm where (IDC_ErrorMsg IS NOT NULL and IDC_ErrorMsg <>'') and convert(nvarchar(8), IDC_ImportDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct IDP_BatchNbr,'平台寄售价格上传',IDP_SalesNo from InterfaceDealerConsignmentSalesPrice where IDP_ProblemDescription IS NOT NULL and convert(nvarchar(8), IDP_ImportDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct POC_BatchNbr,'二级订单平台确认',POC_OrderNo from PurchaseOrderConfirmation where POC_ProblemDescription IS NOT NULL and convert(nvarchar(8), POC_HandleDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct ANL_BatchNbr,'其他出入库',ANL_ArticleNumber from AdjustNote where ANL_ProblemDescription IS NOT NULL and convert(nvarchar(8), ANL_HandleDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct IWH_BatchNbr,'二级仓库上传',Convert(nvarchar(10),IWH_DealerCode)+'-'+IWH_WhmCode from InterfaceWarehouse where IWH_ErrorMsg is not null and convert(nvarchar(8), IWH_ImportDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct IDW_BatchNbr,'二级寄售销售冲红',IDW_WriteBackNo from InterfaceDealerSalesWriteback where IDW_ErrorMsg IS NOT NULL and convert(nvarchar(8), IDW_ImportDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
) tab , interfacelog IL
where tab.BacthNo = IL.IL_BatchNbr
) result

GO


