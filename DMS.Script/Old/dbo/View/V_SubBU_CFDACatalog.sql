DROP view [dbo].[V_SubBU_CFDACatalog] 
GO


CREATE view [dbo].[V_SubBU_CFDACatalog]  as 
select distinct CC_ProductLineName,CA_NameCN,CA_Code,CA_ID,GM_KIND,GM_CATALOG , tab2.CatagoryName
from (
select t1.CC_ProductLineName,t1.CA_NameCN,t1.CA_Code,t1.CA_ID,t2.CFN_ID,t2.CFN_CustomerFaceNbr,t3.GM_KIND,t3.GM_CATALOG
from V_ProductClassificationStructure t1(nolock), cfn t2(nolock), MD.V_INF_UPN_REG_LIST t3,CfnClassification t4
where t1.CA_ID = t4.ClassificationId and t2.CFN_CustomerFaceNbr=t4.CfnCustomerFaceNbr
and t1.ca_code>100
and t2.CFN_CustomerFaceNbr = t3.CFN_CustomerFaceNbr
union
select t1.CC_ProductLineName,t1.CA_NameCN,t1.CA_Code,t1.CA_ID, t2.CFN_ID,t2.CFN_CustomerFaceNbr,t3.GM_KIND,t3.GM_CATALOG
from V_ProductClassificationStructure t1, cfn t2, MD.V_INF_UPN_REG_LIST t3,CfnClassification t4
where t1.CA_ID = t4.ClassificationId and t2.CFN_CustomerFaceNbr=t4.CfnCustomerFaceNbr
and t1.ca_code<100
and t2.CFN_CustomerFaceNbr = t3.CFN_CustomerFaceNbr
) tab , MD.MedicalDeviceCatagory tab2
where GM_KIND is not null and GM_CATALOG is not null
and case when tab.GM_KIND in ('2','II') then '二类'
         when tab.GM_KIND in ('3','III') then '三类'
         else '一类'end = tab2.[TYPE]
and tab.GM_CATALOG = tab2.CatagoryID
and tab2.Status = 1
--select * from MD.V_INF_UPN_REG_LIST

GO


