USE [BSC_Prd]
GO

/****** Object:  StoredProcedure [Workflow].[Proc_DealerMasterLicense_GetHtmlData]    Script Date: 2018/2/28 16:06:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [Workflow].[Proc_DealerMasterLicense_GetHtmlData]
	@InstanceId uniqueidentifier
AS
declare @dealerid nvarchar(50);
declare @NewSecondClassCatagory nvarchar(500);
declare @NewThirdClassCatagory nvarchar(500);
declare @SecondClassCatagory nvarchar(500);
declare @ThirdClassCatagory nvarchar(500);


--ģ����Ϣ��������ڵ�һ����ѯ�������ֻ�й̶��������ֶΣ����Ʋ��ܱ�
SELECT 'DealerMasterLicenseModify' AS TemplateName, 'Header','NewShipToInformation','ShipToInformation','NewSecondClassCatagory','SecondClassCatagory'
'NewThirdClassCatagory','ThirdClassCatagory','Attachment' AS TableNames

select @dealerid=d.DML_DMA_ID ,@NewSecondClassCatagory=d.DML_NewSecondClassCatagory,@NewThirdClassCatagory=d.DML_NewThirdClassCatagory from DealerMasterLicenseModify d where d.DML_MID=@InstanceId
select @SecondClassCatagory=dm.DML_CurSecondClassCatagory ,@ThirdClassCatagory=dm.DML_CurThirdClassCatagory from DealerMasterLicense dm where dm.DML_DMA_ID=@dealerid
--������Ϣ
--��ͷ
select  DML_NewApplyNO as 'ContractNo',d.DMA_ChineseShortName as 'DealerName',s.DML_NewApplyDate as 'RequestDate',s.DML_NewCurRespPerson as 'NewCurRespPerson',d1.DML_CurRespPerson as 'CurRespPerson',s.DML_NewCurLegalPerson as 'NewCurLegalPerson',d1.DML_CurLegalPerson as 'CurLegalPerson'
,s.DML_NewLicenseNo as 'NewLicenseNo' , d1.DML_CurLicenseNo as 'LicenseNo', s.DML_NewLicenseValidFrom as 'NewLicenseValidFrom',d1.DML_CurLicenseValidFrom as 'LicenseValidFrom', 
s.DML_NewLicenseValidTo as 'NewLicenseValidTo', d1.DML_CurLicenseValidTo as 'LicenseValidTo',
s.DML_NewFilingNo as 'NewFilingNo',d1.DML_CurFilingNo as 'FilingNo' ,s.DML_NewFilingValidFrom as 'NewFilingValidFrom',d1.DML_CurFilingValidFrom as 'FilingValidFrom',s.DML_NewFilingValidTo as 'NewFilingValidTo',d1.DML_CurFilingValidTo as 'FilingValidTo'
from DealerMasterLicenseModify s inner join DealerMaster d  on d.DMA_ID= s.DML_DMA_ID
inner join  DealerMasterLicense d1 on d1.DML_DMA_ID=s.DML_DMA_ID
where s.DML_MID=@InstanceId
 
 
--������shipto ��Ϣ
select ST_WH_Code as Code ,ST_Type as 'Type' ,ST_Address as 'Address',case when ST_IsSendAddress='0' then'��' 
when ST_IsSendAddress='1' then '��' end as 'IsSendAddress' from SAPWarehouseAddress_temp s 
where s.ST_DML_MID=@InstanceId

--shipto��Ϣ
select s.SWA_WH_Code as 'Code',s.SWA_WH_Type as 'Type',s.SWA_WH_Address as 'Address',case when s.SWA_IsSendAddress='0' then'��' 
when s.SWA_IsSendAddress='1' then '��' end as 'IsSendAddress' from SAPWarehouseAddress s where 
SWA_DMA_ID=@dealerid

---���������ҽ����е��Ʒ����
select CatagoryID as 'NewCatagoryID',CatagoryName as 'NewCatagoryName',[TYPE] As 'NewCatagoryType'
      from [MD].[MedicalDeviceCatagory]
      where [TYPE]= '����' and
      CatagoryID in (select VAL from dbo.GC_Fn_SplitStringToTable(@NewSecondClassCatagory,','))
--����ҽ����е��Ʒ����
select CatagoryID,CatagoryName,[TYPE] As CatagoryType 
      from [MD].[MedicalDeviceCatagory]
      where [TYPE]= '����' and
      CatagoryID in (select VAL from dbo.GC_Fn_SplitStringToTable(@SecondClassCatagory,','))
--����������ҽ����е��Ʒ����
select CatagoryID as 'NewCatagoryID',CatagoryName as 'NewCatagoryName',[TYPE] As 'NewCatagoryType'
      from [MD].[MedicalDeviceCatagory]
      where [TYPE]= '����' and
      CatagoryID in (select VAL from dbo.GC_Fn_SplitStringToTable(@NewThirdClassCatagory,','))
--����ҽ����е��Ʒ����
select CatagoryID,CatagoryName,[TYPE] As CatagoryType ,Status AS CatagoryStatus
      from [MD].[MedicalDeviceCatagory]
      where [TYPE]= '����' and
      CatagoryID in (select VAL from dbo.GC_Fn_SplitStringToTable(@ThirdClassCatagory,','))

--������Ϣ

EXEC Workflow.Proc_Attachment_GetHtmlData @dealerid,'DealerLicense'


GO


