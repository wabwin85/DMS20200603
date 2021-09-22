DROP view [dbo].[interfaceDailyErrorMessage]
GO


CREATE view [dbo].[interfaceDailyErrorMessage] AS 
select interfaceType,ErrDesc,il_clientID,IL_Name,Convert(nvarchar(10),dateadd(day,-1,getdate()),112) AS ErrorDate from ( 
select distinct tab.InterfaceType,ErrDesc,IL.IL_ClientID,IL.IL_Name--,IL.IL_StartTime
from 
(
select distinct DNL_BatchNbr AS BacthNo,'ƽ̨���������ϴ�' AS InterfaceType,DNL_DeliveryNoteNbr ErrDesc from DeliveryNote  where DNL_ProblemDescription is not null and convert(nvarchar(8), DNL_HandleDate ,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct TNL_BatchNbr,'�ƿ����',TNL_ArticleNumber  from TransferNote where TNL_ProblemDescription is not null and convert(nvarchar(8), TNL_HandleDate ,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct SNL_BatchNbr,'ƽ̨����ҽԺ�ϴ�',SNL_HospitalName+'-'+SNL_ArticleNumber from SalesNote where SNL_ProblemDescription is not null and convert(nvarchar(8), SNL_HandleDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct DC_BatchNbr,'ƽ̨�ջ�ȷ��', DC_SapDeliveryNo from DeliveryConfirmation where DC_ProblemDescription is not null and convert(nvarchar(8), DC_HandleDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct IDC_BatchNbr,'ƽ̨�˻�ȷ��',IDC_ReturnNo from InterfaceDealerReturnConfirm where (IDC_ErrorMsg IS NOT NULL and IDC_ErrorMsg <>'') and convert(nvarchar(8), IDC_ImportDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct IDP_BatchNbr,'ƽ̨���ۼ۸��ϴ�',IDP_SalesNo from InterfaceDealerConsignmentSalesPrice where IDP_ProblemDescription IS NOT NULL and convert(nvarchar(8), IDP_ImportDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct POC_BatchNbr,'��������ƽ̨ȷ��',POC_OrderNo from PurchaseOrderConfirmation where POC_ProblemDescription IS NOT NULL and convert(nvarchar(8), POC_HandleDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct ANL_BatchNbr,'���������',ANL_ArticleNumber from AdjustNote where ANL_ProblemDescription IS NOT NULL and convert(nvarchar(8), ANL_HandleDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct IWH_BatchNbr,'�����ֿ��ϴ�',Convert(nvarchar(10),IWH_DealerCode)+'-'+IWH_WhmCode from InterfaceWarehouse where IWH_ErrorMsg is not null and convert(nvarchar(8), IWH_ImportDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
union
select distinct IDW_BatchNbr,'�����������۳��',IDW_WriteBackNo from InterfaceDealerSalesWriteback where IDW_ErrorMsg IS NOT NULL and convert(nvarchar(8), IDW_ImportDate,112)=convert(nvarchar(8), dateadd(day,-1,getdate()),112)
) tab , interfacelog IL
where tab.BacthNo = IL.IL_BatchNbr
) result

GO


