DROP view [dbo].[View_SalesReHospital]
GO

--销售人员负责的产品线
Create view [dbo].[View_SalesReHospital]
as
select a.Id as UserId,b.Id as BumId from Lafite_IDENTITY a,View_ProductLine b
 where IDENTITY_CODE='TSR001' and b.ATTRIBUTE_NAME='Interventional Cardiology'
 union all
 select a.Id as UserId,b.Id as BumId from Lafite_IDENTITY a,View_ProductLine b
 where IDENTITY_CODE='TSR002' and b.ATTRIBUTE_NAME='PERI INT/VASC SURG'
 union all
  select a.Id as UserId,b.Id as BumId from Lafite_IDENTITY a,View_ProductLine b
 where IDENTITY_CODE='TSR003' and b.ATTRIBUTE_NAME='Endoscopy'
 union all
  select a.Id as UserId,b.Id as BumId from Lafite_IDENTITY a,View_ProductLine b
 where IDENTITY_CODE='TSR004' and b.ATTRIBUTE_NAME='CRM'
 union all
  select a.Id as UserId,b.Id as BumId from Lafite_IDENTITY a,View_ProductLine b
 where IDENTITY_CODE='TSR005' and b.ATTRIBUTE_NAME='Urology/Gynecology'
 union all
  select a.Id as UserId,b.Id as BumId from Lafite_IDENTITY a,View_ProductLine b
 where IDENTITY_CODE='TSR006' and b.ATTRIBUTE_NAME='Electrophysiology'

GO


