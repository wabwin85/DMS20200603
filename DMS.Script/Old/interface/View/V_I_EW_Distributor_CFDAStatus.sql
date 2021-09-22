DROP view [interface].[V_I_EW_Distributor_CFDAStatus] 
GO


CREATE view [interface].[V_I_EW_Distributor_CFDAStatus] 
AS
select DM.DMA_ID, DM.DMA_SAP_Code,DM.DMA_ChineseName,DM.DMA_DealerType, isnull(convert(nvarchar(20),DML.Status),'NotApproved') As CFDAStatus
from DealerMaster DM 
 left join 
 (select DML_DMA_ID, 'Approved' AS Status 
 from DealerMasterLicense
where (DML_NewApplyStatus ='ÉóÅúÍ¨¹ý' 
or (DML_CurSecondClassCatagory is not null and  DML_CurSecondClassCatagory<>'')
or (DML_CurThirdClassCatagory is not null and DML_CurThirdClassCatagory<>'')
)) DML on  DML.DML_DMA_ID = DM.DMA_ID

GO


