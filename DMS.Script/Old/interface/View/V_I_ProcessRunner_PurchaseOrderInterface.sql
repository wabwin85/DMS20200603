DROP VIEW [interface].[V_I_ProcessRunner_PurchaseOrderInterface]
GO






CREATE VIEW [interface].[V_I_ProcessRunner_PurchaseOrderInterface]
AS
SELECT [POI_Id]
      ,[POI_OrderNo]
      ,[POI_Status]
      ,[SalesDocumentType]
      ,[SalesOrganization]
      ,[DistributionChannel]
      ,[DIVISION]
      ,[CustomerPurchaseOrderNumber]
      ,[RequestedDeliveryDate]
      ,[CustomerPurchaseOrderType]
      ,[NameOfOrderer]
      ,[YourReference]
      ,[TelephoneNumber]
      ,[ShiptoPartysPurchaseOrderNumber]
      ,[DeliveryBlock_DocumentHeader]
      ,[OrderReason]
      ,[TextID]
      ,[Text]
      ,[PartnerFunction]
      ,CASE WHEN [CustomerNumber] = '' THEN '' ELSE SUBSTRING('000000'+[CustomerNumber],LEN('000000'+[CustomerNumber])-9,10) END AS [CustomerNumber]
      , [SalesDocumentItem]
      ,[Material]
      ,[Batch]
      ,[Quantity]
      ,[Plant]
      ,[StorageLocation]
      ,[ConditionItemNumber]
      ,[ConditionType]
      ,case when [ConditionValue] = '' then '' else [ConditionValue] end as [ConditionValue]
      ,[Currency]
      ,[ConditionUnit]
      ,[ConditionPricingUnit]
      ,[POI_CreateDate]
      ,[POI_ModifyDate]
      ,[LineNbr]
  FROM [interface].[T_I_ProcessRunner_PurchaseOrderInterface]
  where POI_Status = 'Processing'
  and POI_OrderNo not in (select distinct POI_OrderNo from [interface].[T_I_ProcessRunner_PurchaseOrderInterface]
  where POI_Status = 'Processing'
  AND SalesDocumentType = 'ZRB')
 




GO


